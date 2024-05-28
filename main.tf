# Створення Docker ресурсів
resource "docker_container" "example_container" {
  name  = "example-container"
  image = "mavidoc/iitlr45v3ins:latest"
}

resource "docker_network" "example_network" {
  name = "example-network"
}

# Налаштування CI/CD
resource "github_actions_workflow" "terraform_ci" {
  name     = "Terraform CI/CD"
  on       = "push"
  resolves = ["terraform"]

  # Виконати ваші команди Terraform
}

resource "github_actions_job" "terraform" {
  name   = "Terraform Apply"
  needs  = [github_actions_workflow.terraform_ci.id]
  runs-on = "ubuntu-latest"

  steps {
    # Кроки виконання Terraform apply
  }
}
