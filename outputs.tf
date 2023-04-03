output "id" {
  description = "The ID of the Key Vault."
  value       = try(azurerm_key_vault.this[0].id, "")
}

output "vault_uri" {
  description = "The URI of the Key Vault, used for performing operations on keys and secrets."
  value       = try(azurerm_key_vault.this[0].vault_uri, "")
}
