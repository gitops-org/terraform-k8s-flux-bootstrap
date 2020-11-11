# Generate a keypair. The private key will go to Flux in-cluster, public key
# will be added as a deploy key to the Github repo.

resource "tls_private_key" "flux" {
  count     = var.private_key_pem == null ? 1 : 0
  algorithm = "RSA"
  rsa_bits  = 2048
}

data "github_repository" "flux-repo" {
  full_name = var.github_repository
}

resource "github_repository_deploy_key" "flux" {
  count      = var.private_key_pem == null ? 1 : 0
  title      = var.github_deploy_key_title
  repository = data.github_repository.flux-repo.name
  read_only  = false
  key        = tls_private_key.flux[0].public_key_openssh
}
