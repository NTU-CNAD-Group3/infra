resource "google_project_service" "apis" {
  for_each           = toset(var.apis)
  service            = each.key
  disable_on_destroy = false
}