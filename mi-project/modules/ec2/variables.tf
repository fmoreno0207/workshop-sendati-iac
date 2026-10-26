variable "nombre" {
  description = "Nombre de la instancia y prefijo del SG."
  type        = string
}

variable "instance_profile" {
  description = "Instance profile del módulo iam-ssm."
  type        = string
}

variable "instance_type" {
  description = "Tipo de instancia (capa gratuita)."
  type        = string
  default     = "t3.micro"
}

variable "tags" {
  description = "Tags del entorno."
  type        = map(string)
  default     = {}
}
