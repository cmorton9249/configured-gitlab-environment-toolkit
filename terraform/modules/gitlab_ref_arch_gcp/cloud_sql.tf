resource "google_sql_database_instance" "gitlab" {
  count = var.cloud_sql_postgres_machine_tier != "" ? 1 : 0

  name             = "${var.prefix}-cloud-sql"
  database_version = var.cloud_sql_postgres_version

  root_password = var.cloud_sql_postgres_root_password

  settings {
    tier    = "db-${var.cloud_sql_postgres_machine_tier}"
    edition = var.cloud_sql_postgres_edition

    disk_type = var.cloud_sql_postgres_disk_type
    disk_size = var.cloud_sql_postgres_disk_size

    availability_type = var.cloud_sql_postgres_availability_type

    ip_configuration {
      ipv4_enabled    = false
      private_network = local.create_network ? google_compute_network.gitlab_vpc[0].id : data.google_compute_network.gitlab_network.id
      require_ssl     = var.cloud_sql_postgres_require_ssl
    }

    database_flags {
      name  = "password_encryption"
      value = "scram-sha-256"
    }
    database_flags {
      name  = "log_min_duration_statement"
      value = 1000
    }

    dynamic "backup_configuration" {
      for_each = range(var.cloud_sql_postgres_backup_configuration["enabled"] == true ? 1 : 0)

      content {
        enabled = var.cloud_sql_postgres_backup_configuration["enabled"]

        start_time = var.cloud_sql_postgres_backup_configuration["start_time"]

        point_in_time_recovery_enabled = var.cloud_sql_postgres_backup_configuration["point_in_time_recovery_enabled"]
        transaction_log_retention_days = var.cloud_sql_postgres_backup_configuration["transaction_log_retention_days"]

        dynamic "backup_retention_settings" {
          for_each = range(var.cloud_sql_postgres_backup_configuration["retained_backups"] != null ? 1 : 0)

          content {
            retained_backups = var.cloud_sql_postgres_backup_configuration["retained_backups"]
          }
        }
      }
    }

    dynamic "maintenance_window" {
      for_each = range(var.cloud_sql_postgres_maintenance_window["day"] != null ? 1 : 0)

      content {
        day  = var.cloud_sql_postgres_maintenance_window["day"]
        hour = var.cloud_sql_postgres_maintenance_window["hour"]

        update_track = var.cloud_sql_postgres_maintenance_window["update_track"]
      }
    }

    user_labels = var.additional_labels
  }

  deletion_protection = var.cloud_sql_postgres_deletion_protection
  encryption_key_name = var.cloud_sql_postgres_encryption_key_name

  depends_on = [
    google_service_networking_connection.gitlab_private_service_access[0]
  ]
}

resource "google_sql_database_instance" "gitlab_read_replica" {
  count = var.cloud_sql_postgres_machine_tier != "" ? var.cloud_sql_postgres_read_replica_count : 0

  name                 = "${var.prefix}-cloud-sql-read-replica-${count.index + 1}"
  database_version     = google_sql_database_instance.gitlab[0].database_version
  master_instance_name = google_sql_database_instance.gitlab[0].name

  settings {
    tier = google_sql_database_instance.gitlab[0].settings[0].tier

    availability_type = var.cloud_sql_postgres_read_replica_availability_type

    ip_configuration {
      ipv4_enabled    = false
      private_network = local.create_network ? google_compute_network.gitlab_vpc[0].id : data.google_compute_network.gitlab_network.id
    }
  }

  deletion_protection = var.cloud_sql_postgres_read_replica_deletion_protection

  depends_on = [
    google_service_networking_connection.gitlab_private_service_access[0]
  ]
}

output "cloud_sql_postgres_connection" {
  value = {
    "cloud_sql_host"               = try(google_sql_database_instance.gitlab[0].ip_address[0].ip_address, "")
    "cloud_sql_version"            = try(google_sql_database_instance.gitlab[0].maintenance_version, "")
    "cloud_sql_read_replica_hosts" = try(google_sql_database_instance.gitlab_read_replica[*].ip_address[0].ip_address, "")
  }
}
