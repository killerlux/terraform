# 🤖 Private Document AI Stack

[![Deploy Status](https://img.shields.io/badge/deploy-automated-brightgreen)](https://github.com/killerlux/terraform/actions)
[![License: Custom](https://img.shields.io/badge/License-Custom%20Commercial-red.svg)](https://github.com/killerlux/terraform/blob/main/LICENSE)
[![DigitalOcean](https://img.shields.io/badge/cloud-digitalocean-blue)](https://www.digitalocean.com/)
[![Docker](https://img.shields.io/badge/containerized-docker-blue)](https://www.docker.com/)

> **Enterprise-grade private AI document processing platform** - Chat with your documents securely using your own infrastructure, powered by Ollama LLM, ChromaDB vector store, and n8n automation workflows.

## 🎯 **Project Overview**

**Private Document AI** is a complete self-hosted solution that enables organizations to implement secure document AI capabilities without data leaving their infrastructure. Built with enterprise DevOps practices, this platform provides:

- **🔒 Complete Data Privacy**: All processing happens on your infrastructure
- **🚀 Production-Ready Deployment**: Automated CI/CD with infrastructure as code
- **🔧 Extensible Workflows**: Visual automation with n8n
- **⚡ High Performance**: Vector search with ChromaDB and local LLM inference
- **📊 Scalable Architecture**: Containerized microservices design

## 🎯 **Architecture**

### **System Components**

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Client Web    │───▶│   n8n Platform  │───▶│  Ollama LLM     │
│   Interface     │    │   :5678         │    │  :11434         │
└─────────────────┘    └─────────────────┘    └─────────────────┘
                                │                       │
                                ▼                       ▼
                       ┌─────────────────┐    ┌─────────────────┐
                       │   ChromaDB      │    │   Vector        │
                       │   :8000         │    │   Embeddings    │
                       └─────────────────┘    └─────────────────┘
```

### **Technology Stack**

| Component | Technology | Purpose | Port |
|-----------|------------|---------|------|
| **Orchestration** | n8n | Workflow automation & UI | 5678 |
| **LLM Engine** | Ollama (Llama3 8B) | Text generation & embeddings | 11434 |
| **Vector Database** | ChromaDB | Document storage & similarity search | 8000 |
| **Infrastructure** | Terraform + DigitalOcean | Cloud provisioning | - |
| **Containerization** | Docker Compose | Service orchestration | - |
| **CI/CD** | GitHub Actions | Automated deployment | - |

### **Data Flow**

1. **📄 Document Ingestion**: Upload → Text extraction → Chunking → Embedding → Vector storage
2. **💬 Question Answering**: Query → Embedding → Similarity search → Context retrieval → LLM response

## 🚀 **Quick Start**

### **Prerequisites**

- DigitalOcean account with API token
- SSH key pair configured in DigitalOcean
- GitHub repository with Actions enabled

### **1. Fork & Configure**

```bash
# Fork this repository
git clone https://github.com/YOUR_USERNAME/private-ai.git
cd private-ai
```

### **2. Set GitHub Secrets**

Navigate to your repository → Settings → Secrets and variables → Actions:

| Secret Name | Description | Example |
|-------------|-------------|---------|
| `DIGITALOCEAN_TOKEN` | DigitalOcean API token | `dop_v1_xxxxx` |
| `SSH_PRIVATE_KEY` | Private SSH key content | `-----BEGIN OPENSSH PRIVATE KEY-----` |

### **3. Update Terraform Configuration**

Edit `terraform/main.tf` and replace the SSH key ID:

```hcl
resource "digitalocean_droplet" "private_ai_server" {
  ssh_keys = ["YOUR_SSH_KEY_ID"]  # Replace with your key ID
  # ... rest of configuration
}
```

### **4. Deploy**

```bash
git add .
git commit -m "feat: configure deployment secrets"
git push origin main
```

**🎉 That's it!** GitHub Actions will automatically:
- Provision DigitalOcean infrastructure
- Install and configure all services
- Deploy the complete AI stack

## 💻 **Usage**

### **Access Your Platform**

After deployment completes, access your services:

- **📊 n8n Interface**: `http://YOUR_DROPLET_IP:5678`
- **🔍 ChromaDB API**: `http://YOUR_DROPLET_IP:8000`
- **🤖 Ollama API**: `http://YOUR_DROPLET_IP:11434`

### **Document Ingestion**

1. Navigate to n8n interface
2. Import `n8n_workflows/ingestion_workflow.json`
3. Activate the workflow
4. Send documents via webhook: `POST http://YOUR_DROPLET_IP:5678/webhook/ingest-document`

### **Chat with Documents**

1. Import `n8n_workflows/qa_workflow.json`
2. Activate the chat workflow
3. Use the built-in chat interface to ask questions about your documents

## 🔧 **Development & Customization**

### **Local Development**

```bash
# Clone repository
git clone https://github.com/YOUR_USERNAME/private-ai.git
cd private-ai

# Start services locally
docker-compose up -d

# Access local services
# n8n: http://localhost:5678
# ChromaDB: http://localhost:8000
# Ollama: http://localhost:11434
```

### **Workflow Customization**

The platform includes two pre-built workflows:

- **`ingestion_workflow.json`**: Document processing pipeline
- **`qa_workflow.json`**: Question-answering interface

Customize these workflows in the n8n interface or create new ones for your specific use cases.

### **LLM Model Management**

```bash
# SSH into your server
ssh root@YOUR_DROPLET_IP

# List available models
docker exec ollama_service ollama list

# Pull additional models
docker exec ollama_service ollama pull codellama:7b
docker exec ollama_service ollama pull mistral:7b
```

## 🔒 **Security Considerations**

### **Network Security**

- All services run on a private Docker network
- Firewall configured to allow only necessary ports (22, 5678, 8000, 11434)
- Consider adding SSL/TLS certificates for production use

### **Data Privacy**

- **✅ No data leaves your infrastructure**
- **✅ All processing happens locally**
- **✅ No external API calls to OpenAI/Anthropic**
- **✅ Full control over your data**

### **Recommended Production Hardening**

```bash
# Enable SSL with Let's Encrypt
certbot --nginx -d yourdomain.com

# Set up backup automation
# Configure log rotation
# Implement monitoring with Prometheus/Grafana
# Set up automated security updates
```

## 📊 **Monitoring & Maintenance**

### **Service Health Checks**

```bash
# Check all services status
docker-compose ps

# View logs
docker-compose logs -f n8n
docker-compose logs -f ollama
docker-compose logs -f chroma
```

### **Backup Strategy**

```bash
# Backup n8n workflows and data
tar -czf backup-n8n-$(date +%Y%m%d).tar.gz ./n8n_data

# Backup ChromaDB vector store
tar -czf backup-chroma-$(date +%Y%m%d).tar.gz ./chroma_data

# Backup Ollama models
tar -czf backup-ollama-$(date +%Y%m%d).tar.gz ./ollama_data
```

## 🛠️ **Troubleshooting**

### **Common Issues**

| Issue | Solution |
|-------|----------|
| `Connection refused` on port 5678 | Check if firewall allows port 5678: `ufw status` |
| Docker containers not starting | Check logs: `docker-compose logs SERVICE_NAME` |
| Out of disk space | Clean up: `docker system prune -a` |
| n8n workflow errors | Verify environment variables in `.env` file |

### **Debug Commands**

```bash
# Check system resources
df -h
free -h
docker stats

# Check service connectivity
curl http://localhost:5678
curl http://localhost:8000/api/v1/heartbeat
curl http://localhost:11434/api/tags
```

## 🔄 **CI/CD Pipeline**

The automated deployment pipeline includes:

1. **Infrastructure Provisioning** (Terraform)
2. **Environment Setup** (Ubuntu + Docker)
3. **Application Deployment** (Docker Compose)
4. **Service Verification** (Health checks)
5. **Model Preparation** (Ollama model download)

### **Pipeline Triggers**

- **Automatic**: Push to `main` branch
- **Manual**: Workflow dispatch with custom commands

## 📈 **Scaling & Performance**

### **Vertical Scaling**

Edit `terraform/main.tf` to upgrade server size:

```hcl
resource "digitalocean_droplet" "private_ai_server" {
  size = "s-4vcpu-8gb"  # Upgrade from s-2vcpu-4gb
}
```

### **Performance Optimization**

- **GPU Support**: Use GPU-enabled droplets for faster inference
- **Load Balancing**: Deploy multiple instances behind a load balancer
- **Caching**: Implement Redis for frequently accessed embeddings
- **CDN**: Use DigitalOcean Spaces for static content delivery

## 💼 **Commercial Licensing & Business Opportunities**

### **📋 License Overview**

This project uses a **Custom Commercial License**:

- **✅ FREE for**: Personal use, education, research, and non-commercial projects
- **💰 PAID for**: Commercial use, selling services, or creating commercial products

### **🚀 Commercial Use Cases**

Perfect for businesses looking to:
- **🏢 Enterprise Document AI**: Internal knowledge management systems
- **💡 SaaS Products**: Build document processing services
- **🔧 Custom Solutions**: White-label AI document platforms
- **📊 Consulting Services**: AI implementation for clients

### **💬 Get Commercial License**

Ready to use this commercially? Let's discuss:

- **📧 Email**: [YOUR_EMAIL] 
- **💼 LinkedIn**: [YOUR_LINKEDIN]
- **🐙 GitHub**: Contact via issues or discussions
- **💰 Pricing**: Flexible licensing based on your use case

**Custom enterprise features available:**
- Priority support and updates
- Custom integrations and modifications  
- On-premise deployment assistance
- Training and consultation services

## 🤝 **Contributing**

We welcome contributions! Please see our [Contributing Guide](CONTRIBUTING.md) for details.

### **Development Workflow**

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📞 **Support**

- **📖 Documentation**: [Wiki](https://github.com/killerlux/terraform/wiki)
- **🐛 Bug Reports**: [Issues](https://github.com/killerlux/terraform/issues)
- **💬 Discussions**: [GitHub Discussions](https://github.com/killerlux/terraform/discussions)

## 📄 **License**

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 **Acknowledgments**

- **[n8n](https://n8n.io/)** - Workflow automation platform
- **[Ollama](https://ollama.ai/)** - Local LLM inference engine
- **[ChromaDB](https://www.trychroma.com/)** - Vector database
- **[DigitalOcean](https://www.digitalocean.com/)** - Cloud infrastructure
- **[Terraform](https://www.terraform.io/)** - Infrastructure as code

---

**🚀 Built with ❤️ for private, secure AI document processing**

*For enterprise support and custom implementations, please contact us.*
