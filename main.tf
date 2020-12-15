#####################################################################
# network(s), address(es), firewall(s)

# public IP
resource "google_compute_address" "pub_addr_1" {
  name         = "public-address-1"
  address_type = "EXTERNAL"
  network_tier = "STANDARD"
}

# network
resource "google_compute_network" "net_1" {
  name = "${var.prefix}-network-1"
  auto_create_subnetworks = false
}

# subnet in network
resource "google_compute_subnetwork" "net_1_subnet_1" {
  name          = "${var.prefix}-network-1-subnet-1"
  ip_cidr_range = "10.0.1.0/24"
  network       = google_compute_network.net_1.self_link
}

# private IP in subnet of network
resource "google_compute_address" "net_1_subnet_1_privateIP_1" {
  name         = "${var.prefix}-network-1-subnet-1-privateip-1"
  subnetwork   = google_compute_subnetwork.net_1_subnet_1.self_link
  address_type = "INTERNAL"
  address      = "10.0.1.10"
}

# network firewall
#     - if no target_tags are specified, the firewall rule applies
#       to all instances on the specified network.
resource "google_compute_firewall" "net_1_firewall" {
  name    = "${var.prefix}-network-1-firewall"
  network = google_compute_network.net_1.self_link

  allow {
    protocol = "tcp"
    ports    = [
      "22",  # ssh
      "80",  # http
      "443", # https
    ]
  }

  allow {
    protocol = "icmp"
  }

  source_ranges = var.accessible_from
}

#####################################################################
# machine(s)

# boot image
data "google_compute_image" "debian_image" {
  family  = "debian-10"
  project = "debian-cloud"
}

# virtual machine
resource "google_compute_instance" "virtual_machine" {
  name         = "${var.prefix}-virtual-machine"
  zone         = var.gcp_zone
  machine_type = "n1-standard-4"

  can_ip_forward            = true
  allow_stopping_for_update = true

  boot_disk {
    initialize_params {
      image = data.google_compute_image.debian_image.self_link
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.net_1_subnet_1.self_link
    network_ip = google_compute_address.net_1_subnet_1_privateIP_1.self_link

    access_config {
      nat_ip       = google_compute_address.pub_addr_1.address
      network_tier = "STANDARD"
    }
  }

  metadata = {
    ssh-keys = "root:${file(var.ssh_public_key_path)}"
  }

  metadata_startup_script = <<-EOT
    sudo apt-get -y update;
    sudo apt-get -y upgrade;
    sudo apt-get -y dist-upgrade;
    sudo apt-get -y install nginx;
    sudo systemctl enable nginx;
    sudo systemctl start nginx;
  EOT
}
