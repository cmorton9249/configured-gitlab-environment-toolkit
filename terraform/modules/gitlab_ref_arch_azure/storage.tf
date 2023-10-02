resource "azurerm_storage_container" "gitlab_object_storage_buckets" {
  for_each              = toset(var.object_storage_buckets)
  name                  = "${var.object_storage_prefix != null ? var.object_storage_prefix : var.prefix}-${each.value}"
  storage_account_name  = var.storage_account_name
  container_access_type = "private"
}
