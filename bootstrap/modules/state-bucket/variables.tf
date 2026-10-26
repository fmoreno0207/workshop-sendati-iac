variable "nombre" {
  description = "Nombre del bucket (único en todo S3)."
  type        = string
}

variable "tags" {
  description = "Tags base."
  type        = map(string)
  default     = {}
}
