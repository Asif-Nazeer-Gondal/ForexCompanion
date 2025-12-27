output "cloud_run_url" {
  description = "URL of the Cloud Run service"
  value       = google_cloud_run_service.app.status[0].url
}

output "database_connection_name" {
  description = "Cloud SQL connection name"
  value       = google_sql_database_instance.main.connection_name
}