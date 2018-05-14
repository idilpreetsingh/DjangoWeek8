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
  name         = "myserver"
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

  metadata {
    gce-container-declaration = <<EOF
spec:
  containers:
    - image: 'gcr.io/comp698-ds1067/github-idilpreetsingh-djangoweek8:708f9cf1897a7d0387b9eb99ec11cb15f2aae0aa'
      name: service-container
      stdin: false
      tty: false
  restartPolicy: Always
EOF
  }

}

resource "google_compute_instance_group_manager" "myserver-manager" {
  name               = "myserver-manager"
  project            = "comp698-ds1067"
  instance_template  = "${google_compute_instance_template.myserver.self_link}"
  base_instance_name = "myserver"
  zone               = "us-central1-f"

  target_size        = "1"
}

resource "google_storage_bucket" "image-store" {
  project  = "comp698-ds1067"
  name     = "ds1067bucket"
  location = "us-central1"
}