module "key_vault" {
  source = "../../"

  name                          = var.name
  location                      = var.location
  resource_group_name           = var.resource_group_name
  sku_name                      = var.sku_name
  tenant_id                     = data.azurerm_client_config.this.tenant_id
  purge_protection_enabled      = false
  soft_delete_retention_days    = var.soft_delete_retention_days
  public_network_access_enabled = true

  access_policy = [
    {
      object_id = data.azurerm_client_config.this.object_id
      secret_permissions = [
        "Set",
        "Get",
        "Delete",
        "Purge",
        "Recover",
        "List"
      ]
    }
  ]
  tags = {
    "environment" = "example"
  }

  key_vault_secrets = {
    "access-key" = {
      value = "asdf1234"
    }
  }

}
