terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.0"
    }
  }
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

resource "cloudflare_tunnel" "home_automation_tunnel" {
  account_id = var.cloudflare_account_id
  name       = "home-automation-edge"
  secret     = base64sha256(var.tunnel_secret)
}

resource "cloudflare_tunnel_config" "tunnel_config" {
  account_id = var.cloudflare_account_id
  tunnel_id  = cloudflare_tunnel.home_automation_tunnel.id

  config {
    ingress_rule {
      hostname = "ha.ats-automation.com"
      service  = "http://192.168.88.10:8123" # Home Assistant Local IP
    }
    ingress_rule {
      service = "http_status:404"
    }
  }
}

# Access Policy enforcing mTLS
resource "cloudflare_access_policy" "mtls_policy" {
  application_id = var.cloudflare_app_id
  zone_id        = var.cloudflare_zone_id
  name           = "Enforce mTLS - Resident Devices Only"
  decision       = "allow"

  include {
    certificate = true # Requires a valid client certificate
  }

  require {
    common_name = "resident-device" # Optional: Check specific CN
  }
}

output "tunnel_token" {
  value     = cloudflare_tunnel.home_automation_tunnel.tunnel_token
  sensitive = true
}
