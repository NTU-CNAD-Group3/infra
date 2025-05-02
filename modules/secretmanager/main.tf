locals {
  # Flatten the list of secret IDs from all services
  svc_secret_pairs = flatten([
    for svc, cfg in var.services : [
      for sid in cfg.secret_ids : {
        service    = svc
        secret_key = sid
      }
    ]
  ])
}


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
  for_each       = toset(var.secret_keys)
  secret         = google_secret_manager_secret.my_secret[each.value].id
  secret_data_wo = var.secret_values[each.value]
}

resource "google_service_account" "gsa" {
  for_each     = var.services
  account_id   = "${each.key}-gsa"
  display_name = "GSA for ${each.key}"
}

resource "google_secret_manager_secret_iam_member" "access" {
  for_each = {
    for p in local.svc_secret_pairs : "${p.service}:${p.secret_key}" => p
  }

  secret_id = google_secret_manager_secret.my_secret[each.value.secret_key].id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${google_service_account.gsa[each.value.service].email}"
}

resource "google_service_account_iam_member" "wi_binding" {
  for_each = var.services

  service_account_id = google_service_account.gsa[each.key].name
  role               = "roles/iam.workloadIdentityUser"
  member             = "principal://iam.googleapis.com/projects/${var.project_number}/locations/global/workloadIdentityPools/${var.project_id}.svc.id.goog/subject/ns/${each.value.k8s_namespace}/sa/${each.value.k8s_serviceaccount}"
}