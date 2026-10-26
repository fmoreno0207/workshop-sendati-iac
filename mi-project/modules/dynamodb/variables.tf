variable "nombre" {
  description = "Nombre de la tabla."
  type        = string
}

variable "clave" {
  description = "Clave de partición (string)."
  type        = string
  default     = "id"
}

variable "tags" {
  description = "Tags del entorno."
  type        = map(string)
  default     = {}
}
