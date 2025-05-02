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

  #  The name servers are the output of the DNS module
  dns_settings {
    custom_dns {
      name_servers = [
        "ns-cloud-c1.googledomains.com",
        "ns-cloud-c2.googledomains.com",
        "ns-cloud-c3.googledomains.com",
        "ns-cloud-c4.googledomains.com",
      ]
    }
  }

  # ensure the domain is registered with the correct email
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