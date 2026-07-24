### PROVIDER
provider "google" {
  project = var.project-id
  region  = var.region
  zone    = var.zone
}

### NETWORK
data "google_compute_network" "default" {
  name                    = "default"
}

## SUBNET
resource "google_compute_subnetwork" "subnet-1" {
  name                     = var.subnet-name
  ip_cidr_range            = var.subnet-cidr
  network                  = data.google_compute_network.default.self_link
  region                   = var.region
  private_ip_google_access = var.private_google_access
}

resource "google_compute_firewall" "default" {
  name    = "kube-fw"
  network = data.google_compute_network.default.self_link

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = var.firewall-ports
  }

  source_tags = var.compute-source-tags
}

### COMPUTE
## control node
resource "google_compute_instance" "control" {
  count = 3
  name         = "control${count.index}"
  machine_type = var.environment_machine_type[var.target_environment]
  labels = {
    environment = var.environment_map[var.target_environment]
  }
  metadata = {
  "ssh-keys" = <<EOT
jbloch:ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDRCApR7nuFfSjxhfScxfrep3e1VTl7LjN9deMeoBY7a jbloch@herezja
jbloch:ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDRH7qnvVUKiuL0GebRfGfkOQNobg2/iiCdfQ3X4lSPC eddsa-key-20240328@LenovoT570
EOT
  }
  tags = var.compute-source-tags
  
  boot_disk {
    initialize_params {
      image = "projects/ubuntu-os-cloud/global/images/ubuntu-minimal-2604-resolute-amd64-v20260529"
    }
  }

  network_interface {
    network = data.google_compute_network.default.self_link
    subnetwork = google_compute_subnetwork.subnet-1.self_link
    access_config {
    }
  }
}

# worker nodes
resource "google_compute_instance" "worker" {
  count = 2
  name         = "work${count.index}"
  machine_type = var.environment_machine_type[var.target_environment]
  labels = {
    environment = var.environment_map[var.target_environment]
  }
  metadata = {
  "ssh-keys" = <<EOT
jbloch:ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDRCApR7nuFfSjxhfScxfrep3e1VTl7LjN9deMeoBY7a jbloch@herezja
jbloch:ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDRH7qnvVUKiuL0GebRfGfkOQNobg2/iiCdfQ3X4lSPC eddsa-key-20240328@LenovoT570
EOT
  }
  boot_disk {
    initialize_params {
      image = "projects/ubuntu-os-cloud/global/images/ubuntu-minimal-2604-resolute-amd64-v20260529"
    }
  }

  network_interface {
    # A default network is created for all GCP projects
    network = data.google_compute_network.default.self_link
    subnetwork = google_compute_subnetwork.subnet-1.self_link
    access_config {
    }
  }
}
