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

  # Script exécuté à la création du Droplet pour installer Docker et Docker Compose
  user_data = <<-EOF
              #!/bin/bash
              apt-get update -y
              apt-get install -y apt-transport-https ca-certificates curl software-properties-common
              curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
              echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
              apt-get update -y
              apt-get install -y docker-ce docker-ce-cli containerd.io
              curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
              chmod +x /usr/local/bin/docker-compose
              usermod -aG docker ubuntu
              EOF
}

# Output pour récupérer l'adresse IP du serveur après sa création
output "droplet_ip_address" {
  value = digitalocean_droplet.private_ai_server.ipv4_address
}
