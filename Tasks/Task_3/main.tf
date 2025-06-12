
provider "azurerm" {
  features {}

  subscription_id = "5f7ed3d6-8e9f-4f3e-a520-e974a5bda9c1"
  tenant_id       = "9be83614-49ca-4299-a54c-e6b6ba4130bf"
  use_cli         = true
}

resource "azurerm_resource_group" "example" {
  name     = "devops-test-rg"
  location = "East US"
}
