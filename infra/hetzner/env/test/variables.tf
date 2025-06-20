variable "hcloud_token" {
  sensitive = true
}
variable "state_key" {
  type        = string
  description = "The key to use for the state file"
}
