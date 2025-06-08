# Private Document AI

## Statut du Déploiement
[![Deploy Private AI Stack to DigitalOcean](https://github.com/killerlux/terraform/actions/workflows/deploy.yml/badge.svg)](https://github.com/killerlux/terraform/actions/workflows/deploy.yml)

**Le système a été déployé avec succès !**

Ce projet est une application complète permettant de chatter avec des documents privés, construite avec n8n, Ollama, et ChromaDB, et déployée sur DigitalOcean via Terraform et GitHub Actions.

## Architecture
- **Serveur :** DigitalOcean Droplet (`s-2vcpu-4gb` Ubuntu 22.04)
- **Orchestration :** n8n
- **LLM :** Ollama (avec Llama 3 8B)
- **Base Vectorielle :** ChromaDB
- **Déploiement :** Docker, Terraform, et GitHub Actions

---

## Configuration Requise

Avant de déployer, vous devez configurer les éléments suivants :

### 1. Clé SSH sur DigitalOcean
1. Assurez-vous d'avoir une clé SSH publique ajoutée à votre compte DigitalOcean.
2. Ouvrez le fichier `terraform/main.tf`.
3. Repérez la ligne `ssh_keys = ["ID_DE_TA_CLE_SSH_A_REMPLACER"]`.
4. Remplacez `ID_DE_TA_CLE_SSH_A_REMPLACER` par l'ID numérique ou l'empreinte de votre clé SSH.

### 2. Secrets du Dépôt GitHub
Allez dans `Settings > Secrets and variables > Actions` de votre dépôt GitHub et ajoutez les secrets suivants :

- **`DIGITALOCEAN_TOKEN`**: Votre token d'accès personnel de l'API DigitalOcean.
- **`SSH_PRIVATE_KEY`**: Le contenu de votre clé SSH privée qui correspond à la clé publique que vous avez ajoutée à DigitalOcean.

---

## Déploiement

Le déploiement est entièrement automatisé. Il suffit de pousser vos modifications sur la branche `main` de votre dépôt GitHub.

`git push origin main`

L'action GitHub se chargera de :
1. Provisionner le serveur avec Terraform.
2. Installer Docker.
3. Déployer les services n8n, Ollama et ChromaDB via Docker Compose.
4. Télécharger le modèle `llama3:8b` dans Ollama.

Une fois le déploiement terminé (environ 5 minutes), l'adresse IP de votre serveur sera affichée dans les logs du workflow GitHub Actions.

### ⚠️ Étape Manuelle Importante : Configuration du Pare-feu

Pour des raisons de robustesse du déploiement automatisé, le pare-feu du serveur n'est pas activé par défaut. Vous **devez** vous connecter au serveur après le premier déploiement pour l'activer.

1.  Récupérez l'adresse IP de votre serveur depuis les logs du workflow.
2.  Connectez-vous en SSH :
    ```bash
    ssh root@VOTRE_ADRESSE_IP
    ```
3.  Activez le pare-feu avec les bonnes règles :
    ```bash
    ufw allow ssh
    ufw allow 5678/tcp
    ufw enable
    ```
    Vous devrez confirmer l'opération en tapant `y`.

## 🚀 Utilisation

Une fois le déploiement et la configuration du pare-feu terminés, votre instance "Private Document AI" est prête.

### 1. Accéder à n8n
Une fois le déploiement terminé, consultez les logs de l'action GitHub pour trouver l'adresse IP de votre Droplet. Accédez à n8n dans votre navigateur via :
`http://<VOTRE_IP_DE_DROPLET>:5678`

### 2. Importer les Workflows
1. Créez deux nouveaux workflows vides dans n8n.
2. Pour chaque workflow, cliquez sur les trois points en haut à droite, puis `Import from File`.
3. Copiez le contenu de `n8n_workflows/ingestion_workflow.json` pour le premier, et `n8n_workflows/qa_workflow.json` pour le second.

### 3. Configurer les Credentials
Dans les deux workflows, les nœuds ChromaDB ont besoin d'une connexion.
1. Cliquez sur le nœud `Store in ChromaDB` ou `Search Relevant Chunks`.
2. Dans le champ "Credential", sélectionnez `Create New`.
3. Nommez-le "ChromaDB Local".
4. Pour l'URL, entrez : `http://chroma:8000`.
5. Enregistrez.

### 4. Activer les Workflows
Activez les deux workflows en utilisant l'interrupteur en haut à droite de l'éditeur n8n.

### 5. Utiliser l'Application
- **Pour ingérer un document :** Envoyez une requête `POST` avec votre fichier (ex: via Postman ou un autre script) au webhook d'ingestion : `http://<VOTRE_IP_DE_DROPLET>:5678/webhook/ingest-document`.
- **Pour chatter avec vos documents :** Ouvrez le workflow "Document Q&A Chat", cliquez sur le bouton "Open Chat" en bas de l'écran et commencez à poser des questions.

---
*Ce README a été mis à jour automatiquement après le déploiement réussi.*
