tflint {
  required_version = ">= 0.56"
}

config {
  call_module_type = "all"
}

rule "terraform_required_version" {
  enabled = false
}

rule "terraform_required_providers" {
  enabled = false
}