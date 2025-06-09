#!/bin/bash

# 🤖 Private Document AI - n8n Initial Setup Script
# Configures n8n with workflows, credentials, and initial settings

set -e

SERVER_IP="${1:-159.89.105.105}"
N8N_URL="http://$SERVER_IP:5678"

echo "🚀 Starting n8n Initial Setup for Private Document AI"
echo "📡 Server: $SERVER_IP"
echo "🌐 n8n URL: $N8N_URL"

# Function to wait for n8n to be ready
wait_for_n8n() {
    echo "⏳ Waiting for n8n to be ready..."
    for i in {1..30}; do
        if curl -s "$N8N_URL" > /dev/null 2>&1; then
            echo "✅ n8n is ready!"
            return 0
        fi
        echo "Waiting... ($i/30)"
        sleep 5
    done
    echo "❌ n8n is not responding after 150 seconds"
    return 1
}

# Function to setup n8n credentials
setup_credentials() {
    echo "🔐 Setting up n8n credentials..."
    
    # ChromaDB credential
    cat > /tmp/chroma_credential.json << EOF
{
  "name": "ChromaDB Local",
  "type": "chromaDbApi",
  "data": {
    "host": "chroma",
    "port": 8000,
    "protocol": "http"
  }
}
EOF

    # Ollama credential  
    cat > /tmp/ollama_credential.json << EOF
{
  "name": "Ollama Local",
  "type": "httpBasicAuth",
  "data": {
    "host": "ollama",
    "port": 11434,
    "protocol": "http"
  }
}
EOF

    echo "✅ Credential files created"
}

# Function to import workflows via API
import_workflows() {
    echo "📋 Importing n8n workflows..."
    
    # Wait for n8n API to be ready
    sleep 10
    
    # Import ingestion workflow
    if [ -f "n8n_workflows/ingestion_workflow.json" ]; then
        echo "📄 Importing document ingestion workflow..."
        curl -X POST \
            -H "Content-Type: application/json" \
            -d @n8n_workflows/ingestion_workflow.json \
            "$N8N_URL/api/v1/workflows/import" || echo "⚠️ Ingestion workflow import failed"
    fi
    
    # Import Q&A workflow
    if [ -f "n8n_workflows/qa_workflow.json" ]; then
        echo "💬 Importing Q&A chat workflow..."
        curl -X POST \
            -H "Content-Type: application/json" \
            -d @n8n_workflows/qa_workflow.json \
            "$N8N_URL/api/v1/workflows/import" || echo "⚠️ Q&A workflow import failed"
    fi
    
    echo "✅ Workflows imported successfully"
}

# Function to activate workflows
activate_workflows() {
    echo "🔄 Activating workflows..."
    
    # Get workflow list and activate them
    WORKFLOWS=$(curl -s "$N8N_URL/api/v1/workflows" | jq -r '.data[].id' 2>/dev/null || echo "")
    
    if [ -n "$WORKFLOWS" ]; then
        for workflow_id in $WORKFLOWS; do
            echo "▶️ Activating workflow: $workflow_id"
            curl -X PATCH \
                -H "Content-Type: application/json" \
                -d '{"active": true}' \
                "$N8N_URL/api/v1/workflows/$workflow_id" || echo "⚠️ Failed to activate workflow $workflow_id"
        done
    else
        echo "⚠️ No workflows found to activate"
    fi
    
    echo "✅ Workflows activation completed"
}

# Function to setup initial settings
setup_initial_settings() {
    echo "⚙️ Configuring n8n initial settings..."
    
    # Create settings file
    cat > /tmp/n8n_settings.json << EOF
{
  "userManagement": {
    "disabled": true
  },
  "publicApi": {
    "disabled": false
  },
  "versionNotifications": {
    "enabled": false
  },
  "templates": {
    "enabled": true
  },
  "endpoints": {
    "webhook": "webhook",
    "webhookTest": "webhook-test"
  }
}
EOF

    echo "✅ Settings configured"
}

# Function to create test webhook endpoints
setup_webhooks() {
    echo "🔗 Setting up webhook endpoints..."
    
    echo "📄 Document ingestion webhook: $N8N_URL/webhook/ingest-document"
    echo "💬 Chat endpoint: $N8N_URL/webhook/chat"
    
    # Test webhook connectivity
    echo "🧪 Testing webhook connectivity..."
    curl -X GET "$N8N_URL/webhook/test" > /dev/null 2>&1 && echo "✅ Webhooks are accessible" || echo "⚠️ Webhook test failed"
}

# Function to verify services connectivity
verify_services() {
    echo "🔍 Verifying service connectivity..."
    
    # Test ChromaDB
    if curl -s "http://$SERVER_IP:8000/api/v1/heartbeat" > /dev/null; then
        echo "✅ ChromaDB is accessible"
    else
        echo "❌ ChromaDB is not accessible"
    fi
    
    # Test Ollama
    if curl -s "http://$SERVER_IP:11434/api/tags" > /dev/null; then
        echo "✅ Ollama is accessible"
        
        # Check if Llama3 model is available
        MODELS=$(curl -s "http://$SERVER_IP:11434/api/tags" | jq -r '.models[].name' 2>/dev/null || echo "")
        if echo "$MODELS" | grep -q "llama3"; then
            echo "✅ Llama3 model is available"
        else
            echo "⚠️ Llama3 model not found, may still be downloading"
        fi
    else
        echo "❌ Ollama is not accessible"
    fi
}

# Function to create demo data
create_demo_data() {
    echo "📝 Creating demo data..."
    
    # Create a sample document for testing
    cat > /tmp/sample_doc.txt << EOF
Private Document AI Sample Document

This is a sample document for testing the Private Document AI system.
The system can process various types of documents including PDFs, text files, and Word documents.

Key Features:
- Document ingestion and processing
- Vector embeddings for semantic search  
- Question answering with context
- Completely private and secure processing

Technical Stack:
- n8n for workflow orchestration
- Ollama for local LLM inference
- ChromaDB for vector storage
- Docker for containerization
- Terraform for infrastructure management

Use this document to test the Q&A functionality by asking questions like:
- What are the key features?
- What technologies are used?
- How does the system work?
EOF

    echo "✅ Demo document created at /tmp/sample_doc.txt"
    echo "💡 Upload this file to test the ingestion workflow"
}

# Main execution
main() {
    echo "🎯 Starting n8n setup process..."
    
    # Check if we're on the server or local
    if [ -f "/root/private-ai/docker-compose.yml" ]; then
        echo "📁 Running on server, changing to project directory"
        cd /root/private-ai
    elif [ -f "docker-compose.yml" ]; then
        echo "📁 Running in project directory"
    else
        echo "❌ Project directory not found"
        exit 1
    fi
    
    # Wait for n8n to be ready
    wait_for_n8n
    
    # Setup credentials
    setup_credentials
    
    # Import workflows
    import_workflows
    
    # Activate workflows
    activate_workflows
    
    # Setup initial settings
    setup_initial_settings
    
    # Setup webhooks
    setup_webhooks
    
    # Verify services
    verify_services
    
    # Create demo data
    create_demo_data
    
    echo ""
    echo "🎉 ===== N8N SETUP COMPLETE ===== 🎉"
    echo ""
    echo "🌐 Access your Private Document AI:"
    echo "   📊 n8n Interface: $N8N_URL"
    echo "   📄 Document Upload: $N8N_URL/webhook/ingest-document"
    echo "   💬 Chat Endpoint: $N8N_URL/webhook/chat"
    echo ""
    echo "🧪 Test with the sample document at /tmp/sample_doc.txt"
    echo ""
    echo "✅ Your Private Document AI is ready to use!"
}

# Run main function
main "$@" 