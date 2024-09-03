output "alert_policy_name" {
  description = "The name of the API availability alert policy."
  value       = google_monitoring_alert_policy.api_availability.display_name
}

output "notification_channel_email" {
  description = "The email address used for alert notifications."
  value       = google_monitoring_notification_channel.email_notification.labels.email_address
}
