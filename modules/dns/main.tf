resource "google_dns_managed_zone" "dns_zone" {
  name     = var.dns_managed_zone_name
  dns_name = "${var.domain_name}."
}

resource "google_clouddomains_registration" "domain_registration" {
  domain_name = var.domain_name
  location    = "global"

  yearly_price {
    currency_code = "USD"
    units         = var.domain_price
  }
  dns_settings {
    custom_dns {
      name_servers = google_dns_managed_zone.dns_zone.name_servers
    }
  }

  contact_settings {
    privacy = "PRIVATE_CONTACT_DATA"
    registrant_contact {
      phone_number = "+888-1234-5678"
      email        = "example@example.com"
      postal_address {
        region_code         = "US"
        postal_code         = "95050"
        administrative_area = "CA"
        locality            = "Example City"
        address_lines       = ["1234 Example street"]
        recipients          = ["example recipient"]
      }
    }
    admin_contact {
      phone_number = "+888-1234-5678"
      email        = "example@example.com"
      postal_address {
        region_code         = "US"
        postal_code         = "95050"
        administrative_area = "CA"
        locality            = "Example City"
        address_lines       = ["1234 Example street"]
        recipients          = ["example recipient"]
      }
    }
    technical_contact {
      phone_number = "+888-1234-5678"
      email        = "example@example.com"
      postal_address {
        region_code         = "US"
        postal_code         = "95050"
        administrative_area = "CA"
        locality            = "Example City"
        address_lines       = ["1234 Example street"]
        recipients          = ["example recipient"]
      }
    }
  }

  lifecycle {
    prevent_destroy = true
  }
}

resource "google_dns_record_set" "a_record" {
  managed_zone = google_dns_managed_zone.dns_zone.name
  name         = "${var.domain_name}."
  type         = "A"
  ttl          = 300
  rrdatas      = [var.load_balancer_ip_address]
}
