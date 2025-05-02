output "gsa_emails" {
  description = "The email addresses of the created Google Service Accounts"
  value       = { for svc, sa in google_service_account.gsa : svc => sa.email }
}