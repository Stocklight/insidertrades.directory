variable "digital_ocean_token" {
  description = "Digital Ocean API token"
  type        = string
  sensitive   = true
}

provider "digitalocean" {
  token = var.digital_ocean_token
}

resource "tls_private_key" "kamal_deploy" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "digitalocean_ssh_key" "kamal_deploy" {
  name       = "insidertrades-directory-kamal-deploy-key"
  public_key = tls_private_key.kamal_deploy.public_key_openssh
}

resource "digitalocean_droplet" "web_droplet" {
  image     = "ubuntu-22-04-x64"
  name      = "insidertrades-directory-web-production"
  region    = "nyc1"
  size      = "s-1vcpu-1gb"
  ssh_keys  = [digitalocean_ssh_key.kamal_deploy.fingerprint]

  provisioner "remote-exec" {
    inline = [
      "sudo apt update",
      "sudo apt install -y -o DPkg::Lock::Timeout=60 docker.io",
      "sudo systemctl start docker",
      "sudo systemctl enable docker"
    ]
  }
  backups = true
  
  monitoring = true

  connection {
    type        = "ssh"
    user        = "root"
    private_key = tls_private_key.kamal_deploy.private_key_pem
    host        = self.ipv4_address
  }  
  
  tags = [
    "insidertrades-directory",
    "production",
    "web"
  ]
}

resource "digitalocean_volume" "web_storage" {
  region                  = "nyc1"
  name                    = "insidertrades-directory-web-storage"
  size                    = 30
  initial_filesystem_type = "ext4"
  description             = "30GB volume for web application storage"
}

resource "digitalocean_volume_attachment" "web_storage_volume_attachment" {
  droplet_id = "${digitalocean_droplet.web_droplet.id}"
  volume_id  = "${digitalocean_volume.web_storage.id}"
}

resource "digitalocean_firewall" "web_firewall" {
  name = "insidertrades-directory-web-firewall-production"

  droplet_ids = [digitalocean_droplet.web_droplet.id]

  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "80"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "443"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  inbound_rule {
    protocol         = "icmp"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  # Allow all outbound traffic
  outbound_rule {
    protocol              = "tcp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "udp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "icmp"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }
}

output "ip_address" {
  description = "Public IP address of the web server"
  value       = digitalocean_droplet.web_droplet.ipv4_address
}

output "ssh_private_key" {
  description = "Private SSH key for Kamal deployment (keep secure!)"
  value       = tls_private_key.kamal_deploy.private_key_pem
  sensitive   = true
}
