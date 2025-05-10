variable "permissions" {
  type        = set(string)
}
variable "effect" {
  type        = string
  default     = "Allow"
}
variable "resource" {
  type = set(string)
  default = [ "*" ]
}
variable "service" {
  type = string
}