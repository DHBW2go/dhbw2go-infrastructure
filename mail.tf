resource "cloudflare_record" "TXT-Mail-Domain" {
  zone_id = data.cloudflare_zone.DHBW2go.id

  type    = "TXT"
  name    = "@"

  value   = var.apple_domain
}

resource "cloudflare_record" "TXT-Mail-SPF" {
  zone_id = data.cloudflare_zone.DHBW2go.id

  type    = "TXT"

  name    = "@"
  value   = "v=spf1 include:icloud.com ~all"
}

resource "cloudflare_record" "MX-Mail-01" {
  zone_id  = data.cloudflare_zone.DHBW2go.id

  type     = "MX"

  name     = "@"
  value    = "mx01.mail.icloud.com"

  priority = 10
}

resource "cloudflare_record" "MX-Mail-02" {

  zone_id  = data.cloudflare_zone.DHBW2go.id

  type     = "MX"

  name     = "@"
  value    = "mx02.mail.icloud.com"

  priority = 10
}

resource "cloudflare_record" "CNAME-Mail-DKIM" {
  zone_id = data.cloudflare_zone.DHBW2go.id

  type    = "CNAME"

  name    = "sig1._domainkey"
  value   = "sig1.dkim.dhbw2go.de.at.icloudmailadmin.com"
}
