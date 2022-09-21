data "google_compute_network" "default" {
    name = "default"
}

locals {
  binary_log_enabled = lookup(var.mysql_80_met, "binary_log_enabled", null)
  backups_enabled    = lookup(var.mysql_80_met, "enabled", null)
  retained_backups = lookup(var.mysql_80_met, "retained_backups", null)
  retention_unit   = lookup(var.mysql_80_met, "retention_unit", null)
}

resource "google_sql_database_instance" "mysql_80" {
  count = var.is_present
  name = "test-1"
  region = var.region
  project = var.project
  database_version = "MYSQL_8_0"
  settings {
    tier = var.tier
    disk_type = "PD_SSD"
    dynamic "backup_configuration" {
      for_each = [var.mysql_80_met]
      content {
        binary_log_enabled             = local.binary_log_enabled
        enabled                        = local.backups_enabled
        start_time                     = lookup(backup_configuration.value, "start_time", null)
        location                       = lookup(backup_configuration.value, "location", null)
        dynamic "backup_retention_settings" {
          for_each = local.retained_backups != null || local.retention_unit != null ? [var.mysql_80_met] : []
          content {
            retained_backups = local.retained_backups
            retention_unit   = local.retention_unit
          }
        }
      }
    }
  }
}