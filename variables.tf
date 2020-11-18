variable "prefix" {
  description = <<-EOT
    Prefix for all resources created by this configuration. Use an
    abbreviation of your name. For example, 'jdoe' for John Doe.
  EOT

  type        = string
  default     = "user"
}

variable "gcp_zone" {
  description = "GCP zone to launch servers in."

  type        = string
  default     = "europe-west3-b" # E2,N2,N1,M1,M2,C2
}

variable "gcp_region" {
  description = "GCP region to launch servers in."

  type        = string
  default     = "europe-west3" # Frankfurt (Germany)
}

variable "gcp_project_id" {
  description = "Identifier of GCP project to use for the deployment."

  type        = string
  default     = null
}

variable "accessible_from" {
  description = <<-EOT
    A list of networks from which the entire deployment will be accessible,
    specified in CIDR format.
  EOT

  type        = list(string)
  default     = null
}

variable "ssh_public_key_path" {
  description = <<-EOT
    Path to the SSH public key to be used for authentication. Ensure this
    keypair is added to your local SSH agent so provisioners can connect.
  EOT

  type        = string
  default     = "./ssh/key.pub"
}
