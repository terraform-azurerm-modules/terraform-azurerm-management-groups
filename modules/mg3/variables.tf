variable "level" {
  type = number
}

variable "display_name" {}

variable "parent_management_group_id" {}

variable "children" {
  type = any
}
