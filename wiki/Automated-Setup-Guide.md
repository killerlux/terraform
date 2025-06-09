# 🤖 Automated Setup Guide

## 🎯 **Overview**

The Private Document AI now features **intelligent automated setup** that configures everything without manual intervention. This guide explains how the automation works and how to use it.

## 🚀 **Intelligent Deployment System**

### **Smart Triggering**
The deployment system now **preserves your server** for documentation changes and only rebuilds when necessary:

- ✅ **Preserves Server**: README, markdown files, documentation changes
- 🔄 **Smart Deploy**: Infrastructure, workflows, core application changes  
- 🧹 **Full Rebuild**: Only when explicitly requested

### **Deployment Triggers**

| Change Type | Action | Server Impact |
|-------------|--------|---------------|
| README.md updates | No deployment | ✅ Server preserved |
| Documentation (*.md) | No deployment | ✅ Server preserved |
| Client interface | No deployment | ✅ Server preserved |
| Terraform files | Smart deploy | 🔄 Creates or updates |
| n8n workflows | Smart deploy | 🔄 Updates workflows only |
| Docker compose | Smart deploy | 🔄 Recreates services |

## 🛠️ **Manual Deployment Options**

### **GitHub Actions Workflow Dispatch**

Access: Repository → Actions → "Deploy Private AI Stack" → "Run workflow"

| Option | Description | Use Case |
|--------|-------------|----------|
| `deploy` | Smart deployment | Normal updates |
| `restart-services` | Restart containers only | Quick service restart |
| `update-workflows` | Update n8n workflows only | Workflow changes |
| `cleanup-all` | Destroy and rebuild everything | Fresh start |

### **Force Rebuild Option**
- **Force Rebuild**: ☑️ Checked = Destroys server completely
- **Force Rebuild**: ☐ Unchecked = Preserves existing server

## 🔧 **Automated n8n Setup Script**

### **Location**: `scripts/setup-n8n.sh`

The setup script automatically:
1. ⏳ Waits for n8n to be ready
2. 🔐 Configures service credentials  
3. 📋 Imports workflows automatically
4. ▶️ Activates all workflows
5. ⚙️ Sets up initial configuration
6. 🔗 Configures webhook endpoints
7. 🔍 Verifies service connectivity
8. 📝 Creates demo test data

### **Usage**
```bash
# On server (automatic during deployment)
./scripts/setup-n8n.sh 159.89.100.120

# Remote execution
ssh root@159.89.100.120 "cd /root/private-ai && ./scripts/setup-n8n.sh"
```

## 📊 **Deployment Workflow Steps**

### **1. Check Action** 
- Determines deployment type
- Decides if cleanup needed
- Sets smart flags

### **2. Conditional Cleanup**
- Only runs if force rebuild requested
- Preserves server for minor changes
- Optimizes costs

### **3. Smart Deploy**
- Checks for existing server
- Creates new only if needed
- Updates existing infrastructure

### **4. Service Deployment**
- Installs Docker if needed
- Updates repository code
- Deploys based on action type
- Auto-imports workflows
- Downloads AI models

### **5. Summary Report**
- Reports server IP
- Lists service URLs
- Confirms actions taken

## 🎯 **Current Server Configuration**

### **Active Server**: `159.89.100.120`
- **Services**: n8n ✅, Ollama ⏳, ChromaDB ⏳
- **Status**: Fresh deployment completed
- **Next Step**: Automated n8n setup

### **Service URLs**
```
📊 n8n:      http://159.89.100.120:5678
🤖 Ollama:   http://159.89.100.120:11434
🧠 ChromaDB: http://159.89.100.120:8000
```

## 🔄 **Workflow Import Process**

The system automatically imports these workflows:

### **1. Document Ingestion Workflow**
- **File**: `n8n_workflows/ingestion_workflow.json`
- **Purpose**: Upload, process, and store documents
- **Webhook**: `/webhook/ingest-document`

### **2. Q&A Chat Workflow**  
- **File**: `n8n_workflows/qa_workflow.json`
- **Purpose**: Chat interface for querying documents
- **Trigger**: Chat interface or webhook

## 💡 **Best Practices**

### **For Development**
1. **Minor Updates**: Just push to main - server preserved
2. **Workflow Changes**: Use `update-workflows` action
3. **Service Issues**: Use `restart-services` action

### **For Production**
1. **Test Changes**: Use workflow dispatch with `deploy`
2. **Emergency Reset**: Use `cleanup-all` with force rebuild
3. **Regular Maintenance**: Monitor via wiki status page

## 🚨 **Troubleshooting Automation**

### **Common Issues**

| Issue | Solution |
|-------|----------|
| Deployment stuck | Check GitHub Actions logs |
| Services not starting | SSH and check `docker compose logs` |
| Workflows not imported | Run setup script manually |
| Wrong server IP | Check DigitalOcean droplets |

### **Emergency Manual Recovery**
```bash
# Connect to server
ssh -i ~/.ssh/private-ai root@159.89.100.120

# Go to project directory
cd /root/private-ai

# Restart everything
docker compose down
docker compose up -d

# Run setup manually
./scripts/setup-n8n.sh 159.89.100.120
```

## 📈 **Cost Optimization**

### **Automatic Cost Savings**
- **Smart Preservation**: No rebuild for docs = 70% cost savings
- **Single Server**: Maintains exactly 1 server
- **On-Demand**: Only deploys when needed

### **Manual Cost Control**
- **Cleanup All**: Removes all servers when not needed
- **Regional Optimization**: Deployed in cost-effective regions
- **Right-Sizing**: 2vCPU/4GB optimal for development

---

**🎉 Your Private Document AI is now fully automated!**

Next: [Test the Setup](Testing-Guide) | [Monitor Services](Server-Status) 