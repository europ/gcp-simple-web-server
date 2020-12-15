provider "google" {
  zone        = var.gcp_zone
  region      = var.gcp_region
  project     = var.gcp_project_id
}
