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
resource "google_compute_instance_template" "myserver"{
  name         = "myserver-template"
  project      = "comp698-ds1067"
  machine_type = "f1-micro"

  tags = ["http-server"]

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

resource "google_compute_instance_group_manager" "myserver-manager" {
  name               = "myserver-manager"
  project            = "comp698-ds1067"
  instance_template  = "${google_compute_instance_template.myserver-template.self_link}"
  base_instance_name = "myserver"
  zone               = "us-central1-f"

  target_size        = "1"
}