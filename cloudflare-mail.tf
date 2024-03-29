resource "cloudflare_record" "Cloudflare-Record-TXT-Mail-Domain" {
  zone_id = data.cloudflare_zone.Cloudflare-Zone.id

  type    = "TXT"
  name    = "@"

  value   = var.apple_domain
}

resource "cloudflare_record" "Cloudflare-Record-TXT-Mail-SPF" {
  zone_id = data.cloudflare_zone.Cloudflare-Zone.id

  type    = "TXT"

  name    = "@"
  value   = "v=spf1 include:icloud.com ~all"
}

resource "cloudflare_record" "Cloudflare-Record-MX-Mail-01" {
  zone_id  = data.cloudflare_zone.Cloudflare-Zone.id

  type     = "MX"

  name     = "@"
  value    = "mx01.mail.icloud.com"

  priority = 10
}

resource "cloudflare_record" "Cloudflare-Record-MX-Mail-02" {
  zone_id  = data.cloudflare_zone.Cloudflare-Zone.id

  type     = "MX"

  name     = "@"
  value    = "mx02.mail.icloud.com"

  priority = 10
}

resource "cloudflare_record" "Cloudflare-Record-CNAME-Mail-DKIM" {
  zone_id = data.cloudflare_zone.Cloudflare-Zone.id

  type    = "CNAME"

  name    = "sig1._domainkey"
  value   = "sig1.dkim.dhbw2go.de.at.icloudmailadmin.com"
}
