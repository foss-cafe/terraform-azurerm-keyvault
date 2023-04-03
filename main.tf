resource "azurerm_key_vault" "this" {
  count = var.create_kv ? 1 : 0

  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku_name            = var.sku_name
  tenant_id           = var.tenant_id

  dynamic "access_policy" {
    for_each = var.access_policy

    content {
      tenant_id               = var.tenant_id
      object_id               = try(access_policy.value.object_id)
      application_id          = try(access_policy.value.application_id, null)
      certificate_permissions = try(access_policy.value.certificate_permissions, [])
      key_permissions         = try(access_policy.value.key_permissions, [])
      secret_permissions      = try(access_policy.value.secret_permissions, [])
      storage_permissions     = try(access_policy.value.storage_permissions, [])
    }

  }

  enabled_for_deployment          = var.enabled_for_deployment
  enabled_for_disk_encryption     = var.enabled_for_disk_encryption
  enabled_for_template_deployment = var.enabled_for_template_deployment
  enable_rbac_authorization       = var.enable_rbac_authorization

  dynamic "network_acls" {
    for_each = var.network_acls

    content {
      bypass                     = try(network_acls.value.bypass)
      default_action             = try(network_acls.value.default_action)
      ip_rules                   = try(network_acls.value.ip_rules, [])
      virtual_network_subnet_ids = try(network_acls.value.virtual_network_subnet_ids, [])
    }
  }

  purge_protection_enabled      = var.purge_protection_enabled
  public_network_access_enabled = var.public_network_access_enabled

  soft_delete_retention_days = var.soft_delete_retention_days

  dynamic "contact" {
    for_each = var.contact

    content {
      email = try(contact.value.email)
      name  = try(contact.value.name, null)
      phone = try(contact.value.phone, null)
    }
  }

  tags = var.tags
}

resource "azurerm_key_vault_secret" "this" {
  for_each = var.key_vault_secrets

  name            = each.key
  value           = each.value.value
  key_vault_id    = var.create_kv ? azurerm_key_vault.this[0].id : var.key_vault_id
  content_type    = try(each.value.content_type, null)
  tags            = try(each.value.tags, {})
  not_before_date = try(each.value.not_before_date, null)
  expiration_date = try(each.value.expiration_date, null)
}
