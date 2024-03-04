
data "cloudflare_zone" "Zone-DHBW2go" {
  name = "dhbw2go.de"
}

resource "cloudflare_record" "Record-TXT-iCloudMail-Domain" {
  zone_id = data.cloudflare_zone.Zone-DHBW2go.id
  name    = "@"
  value   = var.apple_domain
  type    = "TXT"
}

resource "cloudflare_record" "Record-TXT-iCloudMail-SPF" {
  zone_id = data.cloudflare_zone.Zone-DHBW2go.id
  name    = "@"
  value   = "v=spf1 include:icloud.com ~all"
  type    = "TXT"
}

resource "cloudflare_record" "Record-MX-iCloudMail-01" {
  zone_id  = data.cloudflare_zone.Zone-DHBW2go.id
  name     = "@"
  value    = "mx01.mail.icloud.com"
  type     = "MX"
  priority = 10
}

resource "cloudflare_record" "Record-MX-iCloudMail-02" {
  zone_id  = data.cloudflare_zone.Zone-DHBW2go.id
  name     = "@"
  value    = "mx02.mail.icloud.com"
  type     = "MX"
  priority = 10
}

resource "cloudflare_record" "Record-CNAME-iCloudMail-DKIM" {
  zone_id = data.cloudflare_zone.Zone-DHBW2go.id
  name    = "sig1._domainkey"
  value   = "sig1.dkim.dhbw2go.de.at.icloudmailadmin.com"
  type    = "CNAME"
}
