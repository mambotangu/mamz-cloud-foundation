variable "organization_id" {}
variable "billing_account" {}

variable "users" {
  type    = list(string)
}

variable "labels" {
  type = map
}
