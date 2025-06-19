variable "datacenter" {
  type        = string
  description = "The datacenter to deploy the server in"
}
variable "image" {
  type        = string
  description = "The image to deploy the server with"
}

variable "server_type" {
  type        = string
  description = "The type of server to deploy"
}

variable "labels" {
  type        = map(string)
  description = "Labels to apply to the server"
  default     = {}
}

variable "ssh_key" {
  type        = string
  description = "The ssh key to deploy the server with"
}

variable "current_ip" {
  description = "Current public IP address for SSH access"
  type        = string
}
