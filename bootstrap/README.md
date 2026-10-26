# bootstrap

Se corre a mano, una vez. Prepara AWS para `mi-project` y para el pipeline.

| Unidad | Crea |
|---|---|
| `state-bucket` | Bucket del state de `mi-project` |
| `github-oidc` | Proveedor OIDC de GitHub (el pipeline entra sin claves) |
| `github-role-plan` | Rol de solo lectura para los plan |
| `github-role-apply` | Rol del apply: solo desde los environments `dev` / `qa`, solo recursos `workshop-*` |

El state del bootstrap va a otro bucket, `workshop-<cuenta>-<región>-bootstrap-tfstate`, que crea Terragrunt.

## Uso

```bash
cd live
terragrunt backend bootstrap --all   # bucket del state del bootstrap
terragrunt run --all plan            # revisar
terragrunt run --all apply
terragrunt run --all output          # ARNs de los roles → variables de GitHub
```

## Borrar (opcional)

Con `mi-project` ya destruido:

1. Vaciar el bucket de `mi-project` desde la consola.
2. `terragrunt run --all destroy` (desde `live/`).
3. Borrar a mano el bucket `-bootstrap-tfstate`.
