terraform {
  backend "gcs" {
    bucket      = "ultra-task-434221-r5-terraform-state"
    prefix      = "terraform/state"
    credentials = "/home/better-great/Downloads/keys.json"
  }
}