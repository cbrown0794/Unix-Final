resource "google_compute_network" "rag_vpc" {
  name                    = "rag-vpc"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "rag_subnet" {
  name          = "rag-subnet"
  ip_cidr_range = "10.10.0.0/24"
  region        = "us-east1"
  network       = google_compute_network.rag_vpc.id
}

resource "google_compute_firewall" "allow_http_https" {
  name    = "rag-allow-http-https"
  network = google_compute_network.rag_vpc.name

  allow {
    protocol = "tcp"
    ports    = ["80", "443"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["rag-web-lb"]
}

resource "google_compute_firewall" "allow_iap_ssh" {
  name    = "rag-allow-iap-ssh"
  network = google_compute_network.rag_vpc.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["35.235.240.0/20"]
  target_tags   = ["rag-web-lb"]
}
