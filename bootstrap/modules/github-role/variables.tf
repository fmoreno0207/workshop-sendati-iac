variable "nombre" {
  description = "Nombre del rol."
  type        = string
}

variable "oidc_provider_arn" {
  description = "ARN del proveedor OIDC de GitHub."
  type        = string
}

variable "sujetos" {
  description = "Claims sub permitidos (ej.: repo:org/repo:pull_request)."
  type        = list(string)
}

variable "politicas" {
  description = "Nombres de políticas administradas de AWS."
  type        = list(string)
  default     = []
}

variable "politica" {
  description = "Política propia en JSON (null = ninguna)."
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags base."
  type        = map(string)
  default     = {}
}
