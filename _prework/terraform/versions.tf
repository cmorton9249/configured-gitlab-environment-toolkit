terraform {
  cloud {
    organization = "CleGuardians-Demo"

    workspaces {
      name = "Gitlab-AWS"
    }
  }
}
