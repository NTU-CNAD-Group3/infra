locals {
  domain_name  = "cnad.info"
  domain_price = 12
}

resource "google_clouddomains_registration" "domain_registration" {
  domain_name = local.domain_name
  location    = "global"

  yearly_price {
    currency_code = "USD"
    units         = local.domain_price
  }

  dns_settings {
    custom_dns {
      name_servers = [
        "ns-cloud-a1.googledomains.com.",
        "ns-cloud-a2.googledomains.com.",
        "ns-cloud-a3.googledomains.com.",
        "ns-cloud-a4.googledomains.com."
      ]
    }
  }

  contact_settings {
    privacy = "REDACTED_CONTACT_DATA"
    registrant_contact {
      phone_number = "+886912345678"
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
      phone_number = "+886912345678"
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
      phone_number = "+886912345678"
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
}