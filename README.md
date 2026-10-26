# workshop-sendati-iac

Infraestructura del workshop (Terraform + Terragrunt en AWS) con pipeline de GitHub Actions y aprobación manual.

| Carpeta | Qué es |
|---|---|
| `bootstrap/` | Se corre **a mano, una vez**: bucket del state + acceso de GitHub a AWS por OIDC (sin claves). |
| `mi-project/` | La infraestructura (EC2, IAM, DynamoDB). La aplica el pipeline. |
| `.github/` | Pipeline. |

## Flujo

```
rama → PR → validar + plan → revisión → merge → plan → ✋ aprobación → apply
```

**Qué se planea y aplica** (siempre **un solo entorno** por corrida):

| Si cambiás… | Se planea y aplica |
|---|---|
| `mi-project/live/dev/ec2/` | solo `ec2` (y lo que necesita: `iam-ssm`) en dev |
| `mi-project/live/dev/env.hcl` | todo dev |
| `dev` y `qa` en el mismo PR | ❌ falla: un PR = un entorno |
| `modules/`, `live/root.hcl`, versiones | el PR muestra el plan de dev; **después del merge no se aplica solo** → *Run workflow* |
| `.github/`, README, `bootstrap/` | nada |

- **PR** (`pr.yml`): `fmt`, `init -backend=false`, `validate` y `plan`. Comenta el resumen en el PR y deja el plan en txt (artefacto `plan-dev`). **Nunca aplica.**
- **Merge a main** (`apply.yml`): plan nuevo → frena en el environment hasta que alguien apruebe → aplica **ese mismo plan**.
- **Run workflow** (`apply.yml` a mano): elegís entorno y, si querés, una unidad (ej. `ec2`). Sirve para promover a qa o para cambios compartidos.

## Puesta en marcha (una vez)

1. **Crear el repo** `workshop-sendati-iac` en GitHub (vacío, sin README).
   ⚠️ En el plan Free, los aprobadores y las reglas de rama solo funcionan en repos **públicos**. Privado = GitHub Pro.

2. **Bootstrap en AWS** (ver [bootstrap/README.md](bootstrap/README.md)):
   ```bash
   cd bootstrap/live
   terragrunt backend bootstrap --all
   terragrunt run --all apply
   terragrunt run --all output   # copiá los dos ARN
   ```

3. **GitHub → Settings → Secrets and variables → Actions → Variables** (no son secretos):
   | Variable | Valor |
   |---|---|
   | `AWS_REGION` | `us-east-1` |
   | `AWS_ROLE_PLAN_ARN` | output `arn` de `github-role-plan` |
   | `AWS_ROLE_APPLY_ARN` | output `arn` de `github-role-apply` |

4. **Settings → Environments**: crear `dev` y `qa`. En cada uno:
   - *Required reviewers*: quién aprueba (ej.: `fmoreno0207`).
   - *Deployment branches*: solo `main`.

5. **Settings → Rules → New branch ruleset** sobre `main`:
   - *Require a pull request before merging* (si estás solo, aprobaciones = 0).
   - *Require status checks*: `validar` y `plan-ok`.
   - *Block force pushes*.

## Uso

1. `git switch -c mi-cambio` → cambiar algo en `mi-project/` → `git push` → abrir PR.
2. Mirar el comentario del plan en el PR. El detalle completo está en el txt: *Actions → la corrida → Artifacts → plan-dev*.
3. Merge.
4. *Actions → Apply → Review deployments* → mirar el plan (resumen y artefacto) → **Approve and deploy**.
5. Si falla con `Saved plan is stale`: *Actions → Apply → Run workflow* (entorno y unidad) y aprobar el plan nuevo.

## Seguridad

- Sin claves en el repo: GitHub entra a AWS por OIDC.
- Rol de plan: solo lectura (+ lock del state). Solo desde PRs y `main`.
- Rol de apply: solo recursos `workshop-*` del lab y solo desde los environments `dev` / `qa`, es decir, con aprobación.
- Los planes se guardan 7 días como artefactos. Pueden tener datos de la infraestructura: repo privado o artefactos con cuidado.
