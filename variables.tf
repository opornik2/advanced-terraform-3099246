### VARIABLES
variable "project-id" {
  type = string
}

variable "region" {
  type = string
  default = "europe-central2"
}

variable "zone" {
  type = string
  default = "europe-central2-a"
}

variable "subnet-name" {
  type = string
  default = "subnet1"
}

variable "subnet-cidr" {
  type = string
  default = "10.127.0.0/20"
}

variable "private_google_access" {
  type = bool
  default = true
}

variable "firewall-ports" {
  type = list
  default = ["80", "443", "6443", "2379-2380", "10250", "22"]
}

variable "compute-source-tags" {
    type = list
    default = ["worker"]
}

variable "target_environment" {
  default = "DEV"
}

variable "environment_list" {
  type = list(string)
  default = ["DEV","QA","STAGE","PROD"]
}

variable "environment_map" {
  type = map(string)
  default = {
    "DEV" = "dev",
    "QA" = "qa",
    "STAGE" = "stage",
    "PROD" = "prod"
  }
}

variable "environment_machine_type" {
  type = map(string)
  default = {
    "DEV" = "e2-small",
    "QA" = "f1-micro",
    "STAGE" = "e2-micro",
    "PROD" = "e2-medium"
  }
}

variable "environment_instance_settings" {
  type = map(object({machine_type=string, labels=map(string)}))
  default = {
    "DEV" = {
      machine_type = "e2-small"
      labels = {
        environment = "dev"
      }
      metadata = {
        "ssh-keys" = <<EOT
            jbloch:ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDRCApR7nuFfSjxhfScxfrep3e1VTl7LjN9deMeoBY7a jbloch@herezja
            jbloch:ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDRH7qnvVUKiuL0GebRfGfkOQNobg2/iiCdfQ3X4lSPC eddsa-key-20240328@LenovoT570
        EOT
      }
    },
   "QA" = {
      machine_type = "f1-micro"
      labels = {
        environment = "qa"
      }
    },
    "STAGE" = {
      machine_type = "e2-micro"
      labels = {
        environment = "stage"
      }
    },
    "PROD" = {
      machine_type = "e2-medium"
      labels = {
        environment = "prod"
      }
    }
  }
}