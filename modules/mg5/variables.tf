variable "level" {
  type = number
}

variable "subscription_to_mg_csv_data" {}

variable "name" {}

variable "parent_management_group_id" {}

variable "children" {
  type = any
}