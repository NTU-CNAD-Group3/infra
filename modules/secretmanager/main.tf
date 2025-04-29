resource "google_secret_manager_secret" "my_secret" {
  for_each  = toset(var.secret_keys)
  secret_id = each.value

  replication {
    user_managed {
      replicas {
        location = var.region
      }
    }
  }
}

resource "google_secret_manager_secret_version" "my_secret_version" {
  for_each    = toset(var.secret_keys)
  secret      = google_secret_manager_secret.my_secret[each.value].id
  secret_data = var.secret_values[each.value]
}