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
resource "google_compute_instance_template" "terraform-webserver"{
        name = "terraform-webserver"
        project     = "comp698-ds1067"
        
        

        disk {
        source_image = "cos-cloud/cos-stable"
        }
        
        machine_type         = "f1-mico"


        network_interface {
        network = "default"
        }     
}

resource "google_compute_instance_group_manager" "instance_group_manager" {
name               = "instance-group-manager"
instance_template  = "${google_compute_instance_template.terraform-webserver.self_link}"
base_instance_name = "instance-group-manager"
zone               = "us-central1-f"
target_size        = "1"
}

resource "google_storage_bucket" "image-store" {
  project  = "comp698-ds1067"
  name     = "my-bucket"
  location = "us-central1"
}