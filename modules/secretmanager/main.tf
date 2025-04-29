resource "google_secret_manager_secret" "my_secret" {
  for_each  = var.secrets
  secret_id = each.key

  replication {
    user_managed {
      replicas {
        location = var.region
      }
    }
  }
}

resource "google_secret_manager_secret_version" "my_secret_version" {
  for_each    = var.secrets
  secret      = google_secret_manager_secret.my_secret[each.key].id
  secret_data = var.secrets[each.key]

  is_secret_data_base64 = true
}