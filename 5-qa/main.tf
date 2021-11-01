module "app1_qa_project" {
  source          = "../modules/projects"
  name            = local.app1_project_name
  project_id      = local.app1_project_name
  services        = local.app1_service_apis
  billing_account = var.billing_account
  folder_id       = data.terraform_remote_state.organization.outputs.folders.QA.name
  labels          = local.project_terraform_labels
}
