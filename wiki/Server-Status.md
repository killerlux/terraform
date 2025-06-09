# 🖥️ Server Status & Information

## 📡 **Current Active Server**

- **IP Address**: `159.89.100.120`
- **Region**: Amsterdam (AMS3)
- **Server Type**: s-2vcpu-4gb (2 vCPUs, 4GB RAM, 80GB SSD)
- **Deployment Date**: December 2024
- **Cost**: ~$24/month

## 🚀 **Services Status**

### **📊 n8n Workflow Platform**
- **URL**: http://159.89.100.120:5678
- **Status**: ✅ Operational
- **Health Check**: `curl http://159.89.100.120:5678/healthz`
- **Purpose**: Workflow orchestration and web interface

### **🤖 Ollama LLM Engine**
- **URL**: http://159.89.100.120:11434
- **Status**: ⏳ Starting (downloading Llama3 model)
- **Health Check**: `curl http://159.89.100.120:11434/api/tags`
- **Model**: Llama3 8B (~4.7GB download)

### **🧠 ChromaDB Vector Database**
- **URL**: http://159.89.100.120:8000
- **Status**: ⏳ Starting
- **Health Check**: `curl http://159.89.100.120:8000/api/v1/heartbeat`
- **Purpose**: Vector embeddings storage and similarity search

## 🔧 **Quick Access Commands**

### **Check All Services**
```bash
# Quick health check
curl -s http://159.89.100.120:5678/healthz  # n8n
curl -s http://159.89.100.120:11434/api/tags # Ollama models
curl -s http://159.89.100.120:8000/api/v1/heartbeat # ChromaDB
```

### **SSH Access**
```bash
# Connect to server
ssh -i ~/.ssh/private-ai root@159.89.100.120

# Check Docker services
docker compose ps

# View logs
docker compose logs -f n8n
docker compose logs -f ollama
docker compose logs -f chroma
```

## 📈 **Performance Monitoring**

### **Resource Usage**
```bash
# Check server resources
ssh root@159.89.100.120 "htop"
ssh root@159.89.100.120 "df -h"
ssh root@159.89.100.120 "free -h"
```

### **Docker Stats**
```bash
# Monitor container performance
ssh root@159.89.100.120 "docker stats --no-stream"
```

## 🔄 **Service Management**

### **Restart Services**
```bash
# Restart all services
ssh root@159.89.100.120 "cd /root/private-ai && docker compose restart"

# Restart individual service
ssh root@159.89.100.120 "cd /root/private-ai && docker compose restart n8n"
```

### **Update Deployment**
Use GitHub Actions workflow dispatch with option `restart-services` to update without destroying the server.

## 🚨 **Troubleshooting**

### **Common Issues**

| Issue | Solution | Command |
|-------|----------|---------|
| n8n not responding | Restart n8n container | `docker compose restart n8n` |
| Ollama model missing | Re-download model | `docker exec ollama_service ollama pull llama3:8b` |
| ChromaDB connection error | Check port 8000 | `netstat -tulpn | grep 8000` |
| Out of disk space | Clean Docker images | `docker system prune -a` |

### **Emergency Recovery**
If services are completely down:
```bash
ssh root@159.89.100.120
cd /root/private-ai
docker compose down
docker compose up -d
```

## 📊 **Service URLs for Bookmarks**

- **🎛️ n8n Interface**: http://159.89.100.120:5678
- **📄 Document Upload**: http://159.89.100.120:5678/webhook/ingest-document
- **💬 Chat Interface**: http://159.89.100.120:5678/webhook/chat
- **🤖 Ollama API**: http://159.89.100.120:11434
- **🧠 ChromaDB Dashboard**: http://159.89.100.120:8000

## 🔐 **Security Notes**

- Server uses SSH key authentication only
- All services run on private Docker network
- Firewall configured for necessary ports only
- Regular security updates via GitHub Actions

---

**Last Updated**: December 2024
**Next Review**: Check monthly for updates and security patches 