variable "tags" {
  description = "Tags to apply to resources"
  default = {}
}
variable "role_name" {
  default = "tlz_watchdog"
}
variable "account_id" {
  type = string
  description = "The AWS ID of the account" 
}
