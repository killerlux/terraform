# Définir le fournisseur DigitalOcean
terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

# Variable pour le token d'accès DigitalOcean (sera fourni via les secrets GitHub)
variable "do_token" {}

provider "digitalocean" {
  token = var.do_token
}

# Définition de notre serveur (Droplet)
resource "digitalocean_droplet" "private_ai_server" {
  image  = "ubuntu-22-04-x64" # Utilise une image Ubuntu stable
  name   = "private-ai-server-01"
  region = "fra1" # Francfort, à changer si nécessaire
  size   = "s-2vcpu-4gb" # Un bon point de départ.

  # IMPORTANT : Remplacez la valeur entre crochets par l'ID de votre clé SSH sur DigitalOcean.
  ssh_keys = ["62:69:4b:04:86:c4:bc:41:4a:e5:96:08:69:3d:d3:54"]

  # Script minimaliste, Docker sera installé par le workflow
  user_data = <<-EOF
              #!/bin/bash
              apt-get update -y
              ufw allow ssh
              ufw allow 5678/tcp
              ufw --force enable
              EOF
}

# Output pour récupérer l'adresse IP du serveur après sa création
output "droplet_ip_address" {
  value = digitalocean_droplet.private_ai_server.ipv4_address
}
