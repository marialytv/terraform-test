# terraform {
#   backend "gcs" {} #enable it when storing terraform state to GCS bucket
# }

resource "google_storage_bucket" "default" {
  name                        = "${var.project_id}-default"
  location                    = var.region
  force_destroy               = true
  storage_class               = "STANDARD"
  uniform_bucket_level_access = true
  public_access_prevention    = "enforced"
}

resource "google_compute_instance" "vm_instance" {
  project      = var.project_id
  name         = var.machine_name
  machine_type = var.machine_type
  zone         = var.zone
  boot_disk {
    initialize_params {
      image = "centos-stream-9"
    }
  }

  network_interface {
    network    = var.network
    subnetwork = var.subnetwork
    access_config {
    }
  }

  tags = ["ssh", "devops-course"]
}

resource "google_bigquery_dataset" "default" {
  project                         = var.project_id
  dataset_id                      = "test_dataset2"
  friendly_name                   = "terraform test"
  default_partition_expiration_ms = 2592000000
  default_table_expiration_ms     = 31536000000
  description                     = "terraform test big query dataset"
  location                        = var.region
  max_time_travel_hours           = 96
}
