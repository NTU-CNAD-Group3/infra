# create a frontend bucket to store react app
resource "google_storage_bucket" "frontend" {
  name     = var.bucket_name
  location = var.region

  storage_class               = "STANDARD"
  force_destroy               = true
  uniform_bucket_level_access = true

  website {
    main_page_suffix = "index.html"
    not_found_page   = "index.html"
  }
  cors {
    origin          = ["*"]
    method          = ["GET", "HEAD", "OPTIONS"]
    response_header = ["*"]
    max_age_seconds = 3600
  }
  versioning {
    enabled = true
  }
}

# IAM binding for frontend bucket to allow public access
resource "google_storage_bucket_iam_binding" "frontend_bucket_iam" {
  bucket = google_storage_bucket.frontend.name
  role   = "roles/storage.objectViewer"

  members = [
    "allUsers",
  ]
}
