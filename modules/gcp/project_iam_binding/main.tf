resource "google_project_iam_member" "main" {
  project            = "${var.project}"
  role               = "${var.role}"
  member            = "${var.member}"
}
