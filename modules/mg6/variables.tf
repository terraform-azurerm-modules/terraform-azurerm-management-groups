variable "level" {
  type = number
}

variable "display_name" {}

variable "parent_management_group_id" {}

variable "children" {
  type = map

  validation {
    condition     = length(var.children) == 0 || keys(var.children) == "ami-"
    error_message = "The maximum depth for a management group hierarchy is 6."
  }
}
