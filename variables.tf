variable "mysql_80_met" {
  type = object({
    binary_log_enabled             = bool
    enabled                        = bool
    start_time                     = string
    location                       = string
    retained_backups               = number
    retention_unit                 = string
    })
  default = {
    binary_log_enabled             = true
    enabled                        = true
    start_time                     = "20:00"
    location                       = "us-central1"
    retained_backups               = "7"
    retention_unit                 = "COUNT"
  }
}

variable "is_present" {
  type        = number
  default     = 1
}

variable "region" {
  type        = string
  default     = "us-central1"
}

variable "project" {
  type        = string
  default     = "decoded-path-356013"
}

variable "tier" {
  type        = string
  default     = "db-f1-micro"
}