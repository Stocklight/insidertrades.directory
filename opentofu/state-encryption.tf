variable "state_encryption_passphrase" {
  description = "Passphrase for encrypting Open Tofu state files"
  type        = string
  sensitive   = true
}

terraform {
  required_version = ">= 1.0"
  
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.40"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
  }

  encryption {
    key_provider "pbkdf2" "state_key" {
      passphrase    = var.state_encryption_passphrase
      key_length    = 32
      salt_length   = 32
      hash_function = "sha256"
      iterations    = 600000
    }

    method "aes_gcm" "state_method" {
      keys = key_provider.pbkdf2.state_key
    }

    state {
      method = method.aes_gcm.state_method
    }
  }
}
