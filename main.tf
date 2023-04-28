provider "azurerm" {
  features {}
}

variable "ssr_password" {
  type = string
  sensitive = true
}

variable "location" {
  type = string
  default = "UAE North"
}

resource "azurerm_resource_group" "ssr" {
  name     = "ssr"
  location = var.location
}

resource "azurerm_container_group" "ssr" {
  name                = "ssr"
  location            = azurerm_resource_group.ssr.location
  resource_group_name = azurerm_resource_group.ssr.name
  ip_address_type     = "Public"
  os_type             = "Linux"

  container {
    name   = "ssr"
    image  = "johndoessr/ssr"
    cpu    = "1"
    memory = "1.5"

    secure_environment_variables = {
        "SSPASSWORD" = var.ssr_password
    }
    ports {
      port     = 443
      protocol = "TCP"
    }
  }
}

output "public_ip" {
  value = azurerm_container_group.ssr.ip_address
}
