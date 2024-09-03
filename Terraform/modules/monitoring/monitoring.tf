resource "google_monitoring_notification_channel" "email_notification" {
  display_name = "Email Notifications"
  type         = "email"

  labels = {
    email_address = var.alert_email
  }
}

resource "google_monitoring_alert_policy" "api_availability" {
  display_name           = "API Availability Alert"
  combiner               = "OR"
  notification_channels  = [google_monitoring_notification_channel.email_notification.id]

  conditions {
    display_name = "API Unavailability Condition"
    condition_threshold {
      comparison      = "COMPARISON_GT"
      filter     = "metric.type=\"compute.googleapis.com/instance/disk/write_bytes_count\" AND resource.type=\"gce_instance\""
      threshold_value = var.api_availability_threshold
      duration        = "60s"

      aggregations {
        alignment_period     = "60s"
        per_series_aligner   = "ALIGN_RATE"
        cross_series_reducer = "REDUCE_SUM"
        group_by_fields      = ["resource.label.\"instance_id\""]
      }
    }
  }
}

resource "google_monitoring_alert_policy" "high_error_rate" {
  display_name = "High Error Rate Alert"
  combiner     = "OR"
  conditions {
    display_name = "Error rate above 5%"
    condition_threshold {
      filter     = "metric.type=\"kubernetes.io/container/restart_count\" AND resource.type=\"k8s_container\""
      duration   = "300s"
      comparison = "COMPARISON_GT"
      threshold_value = 5
      aggregations {
        alignment_period   = "300s"
        per_series_aligner = "ALIGN_RATE"
      }
    }
  }
  notification_channels = [google_monitoring_notification_channel.email_notification.id]
}
