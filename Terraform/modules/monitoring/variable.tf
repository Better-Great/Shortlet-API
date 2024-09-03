variable "alert_email" {
  description = "The email address to receive alert notifications."
  type        = string
}

variable "api_availability_threshold" {
  description = "The threshold value for the API availability alert."
  type        = number
  default     = 0
}
