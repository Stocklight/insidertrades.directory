variable "cloudflare_token" {
  description = "Cloudflare API token"
  type        = string
  sensitive   = true
}

provider "cloudflare" {
  api_token = var.cloudflare_token
}

resource "cloudflare_zone" "insidertrades_directory_zone" {
  name = "insidertrades.directory"
  account = {
    id = "083db226c63c06a3d775c5811d1848ed"
  }
  type = "full"
}

# https://github.com/basecamp/kamal/issues/1039
resource "cloudflare_dns_record" "root_a_record" {
  zone_id = cloudflare_zone.insidertrades_directory_zone.id
  comment = "Root record for digital ocean server not google"
  name    = "insidertrades.directory" # ie. @
  type    = "A"
  content = "206.81.6.23"
  ttl     = 1
  proxied = false
}
