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

resource "cloudflare_dns_record" "sendgrid_record" {
  zone_id = cloudflare_zone.insidertrades_directory_zone.id
  comment = "Sendgrid DNS for email delivery"
  name    = "em6518"
  type    = "CNAME"
  content = "u56390052.wl053.sendgrid.net"
  ttl     = 1
  proxied = false
}

resource "cloudflare_dns_record" "sendgrid_domainkey_record_1" {
  zone_id = cloudflare_zone.insidertrades_directory_zone.id
  comment = "Sendgrid Domainkey for email delivery"
  name    = "s1._domainkey"
  type    = "CNAME"
  content = "s1.domainkey.u56390052.wl053.sendgrid.net"
  ttl     = 1
  proxied = false
}

resource "cloudflare_dns_record" "sendgrid_domainkey_record_2" {
  zone_id = cloudflare_zone.insidertrades_directory_zone.id
  comment = "Sendgrid Domainkey for email delivery"
  name    = "s2._domainkey"
  type    = "CNAME"
  content = "s2.domainkey.u56390052.wl053.sendgrid.net"
  ttl     = 1
  proxied = false
}

resource "cloudflare_dns_record" "sendgrid_dmarc_record" {
  zone_id = cloudflare_zone.insidertrades_directory_zone.id
  comment = "Sendgrid DMARC for email delivery"
  name    = "_dmarc.insidertrades.directory"
  type    = "TXT"
  content = "v=DMARC1; p=none;"
  ttl     = 1
  proxied = false
}