variable "nombre" {
  description = "Prefijo de los nombres."
  type        = string
}

variable "tags" {
  description = "Tags del entorno."
  type        = map(string)
  default     = {}
}
