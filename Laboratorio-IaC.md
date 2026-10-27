# Laboratorio práctico: IaC con GitHub y Terragrunt

## Objetivo

Crear una nueva configuración de DynamoDB a partir de un ejemplo existente, subir los cambios a GitHub y generar un Pull Request para verificar el plan de Terraform.

## Antes de empezar

- Tener Git instalado.
- Tu usuario de GitHub tiene que tener permiso de escritura en el repositorio (pedíselo al instructor).
- Al hacer `git push` por HTTPS, GitHub pide tu usuario y un token personal, no la contraseña.

### 1. Clonar el repositorio

```bash
git clone https://github.com/fmoreno0207/workshop-sendati-iac.git
cd workshop-sendati-iac
```

### 2. Crear una rama de trabajo

Reemplazá `<nombre>` por tu nombre, sin espacios ni caracteres especiales.

```bash
git switch -c tabla-<nombre>
```

### 3. Copiar la configuración existente

```bash
cp -r mi-project/live/dev/dynamodb mi-project/live/dev/tabla-<nombre>
```

### 4. Modificar la configuración

Abrí el archivo:

`mi-project/live/dev/tabla-<nombre>/terragrunt.hcl`

**Cambiar el nombre** para identificar tu configuración:

```hcl
nombre = "${local.env_vars.locals.name_prefix}-${local.env_vars.locals.environment}-<nombre>"
```

Reemplazá `<nombre>` por tu nombre.

**Agregar tu usuario en los tags**, respetando la alineación del signo `=`:

```hcl
      Componente = local.component
      Owner      = "<nombre>"
```

> **Tip:** si el `=` no queda alineado, falla el control `validar` del pipeline.

### 5. Guardar y subir los cambios

```bash
git add mi-project/live/dev/tabla-<nombre>
git commit -m "dev: tabla de <nombre>"
git push -u origin tabla-<nombre>
```

### 6. Crear el Pull Request

1. Ingresá al repositorio en GitHub.
2. Hacé clic en **Compare & pull request**.
3. Verificá que la rama base sea `main` y que la rama de comparación sea `tabla-<nombre>`.
4. Hacé clic en **Create pull request**.
5. Esperá a que termine la ejecución del pipeline.

### 7. Verificar el resultado

En el comentario automático del Pull Request, buscá el resultado esperado:

```text
tabla-<nombre>: Plan: 1 to add
```

Esto indica que Terraform planea agregar un recurso y no modificar ni eliminar otros recursos, según el resumen del plan.

> **Importante:** no ejecutes `apply`. El objetivo del laboratorio es crear el Pull Request y verificar el plan.
