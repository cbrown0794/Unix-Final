data "google_compute_disk" "lvm_disk" {
  name = "rag-lvm-disk"
  zone = "us-east1-b"
}

resource "google_compute_instance" "rag_host" {
  name         = "rag-ai-host"
  machine_type = "e2-standard-4"
  zone         = "us-east1-b"
  tags         = ["rag-web-lb"]

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2404-lts-amd64"
      size  = 30
      type  = "pd-balanced"
    }
  }

  attached_disk {
    source      = data.google_compute_disk.lvm_disk.id
    device_name = "rag-lvm-disk"
  }

  network_interface {
    subnetwork = google_compute_subnetwork.rag_subnet.id
    access_config {}
  }

  service_account {
    email  = "rag-vm-sa@unix-final-515221.iam.gserviceaccount.com"
    scopes = ["cloud-platform"]
  }

  metadata_startup_script = file("${path.module}/../scripts/startup.sh")
}

output "vm_external_ip" {
  value = google_compute_instance.rag_host.network_interface[0].access_config[0].nat_ip
}
