terraform {
  backend "gcs" {
    project = "comp698-ds1067"
    bucket  = "comp698-ds1067-terraform-state"
    prefix  = "terraform-state"
  }

}

provider "google" {
  region = "us-central1"
}

//instances
resource "google_compute_instance_template" "terraform_server"{
  name         = "terraform_server"
  project      = "comp698-ds1067"
  machine_type = "f1-mico"

  // boot disk
  disk {
    source_image = "cos-cloud/cos-stable"
  }

  network_interface {
    network = "default"
  }

  lifecycle {
    create_before_destroy = true
  }
}



resource "google_compute_instance_group_manager" "terraform_group-manager" {
  name               = "terraform_group-manager"
  instance_template  = "${google_compute_instance_template.terraform_server.self_link}"
  base_instance_name = "terraform_group-manager"
  zone               = "us-central1-f"
  target_size        = "1"
}