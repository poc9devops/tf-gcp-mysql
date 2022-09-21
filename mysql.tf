data "google_compute_network" "default" {
    name = "default"
}

resource "google_sql_database_instance" "mysql_80" {
  count = var.mysql_80_met.is_present

  name = "test-1"
  region = var.mysql_80_met.region
  project = var.mysql_80_met.project
  database_version = "MYSQL_8_0"
  settings {
    tier = var.mysql_80_met.tier
    disk_type = "PD_SSD"
    dynamic "backup_configuration" {
      for_each = var.mysql_80_met.backup_configuration[*].enabled == true ? var.mysql_80_met[*] : []
      content {
        binary_log_enabled = backup_configuration.value.binary_log_enabled
        enabled = backup_configuration.value.enabled
        start_time =  backup_configuration.value.start_time
        location =  backup_configuration.value.location
        backup_retention_settings {
          retained_backups = backup_configuration.value.retained_backups
          retention_unit = backup_configuration.value.retention_unit
        }
      }
    }
  }
}