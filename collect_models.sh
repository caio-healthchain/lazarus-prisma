#!/bin/bash

echo "Coletando modelos de todos os schemas Prisma..."

# Criar arquivo temporário para coletar modelos
cat > prisma/all_models.txt << 'EOL'
// Modelos coletados de todos os microsserviços

=== MS-AI-AGENT ===
EOL

# Coletar modelos do ms-ai-agent
if [ -f "/home/ubuntu/microservices-corrigidos/ms-ai-agent/prisma/schema.prisma" ]; then
    echo "Coletando modelos do ms-ai-agent..."
    grep -A 50 "^model " /home/ubuntu/microservices-corrigidos/ms-ai-agent/prisma/schema.prisma >> prisma/all_models.txt
fi

echo "" >> prisma/all_models.txt
echo "=== MS-AUDIT ===" >> prisma/all_models.txt

# Coletar modelos do ms-audit
if [ -f "/home/ubuntu/microservices-corrigidos/ms-audit/prisma/schema.prisma" ]; then
    echo "Coletando modelos do ms-audit..."
    grep -A 50 "^model " /home/ubuntu/microservices-corrigidos/ms-audit/prisma/schema.prisma >> prisma/all_models.txt
fi

echo "" >> prisma/all_models.txt
echo "=== MS-BILLING ===" >> prisma/all_models.txt

# Coletar modelos do ms-billing
if [ -f "/home/ubuntu/microservices-corrigidos/ms-billing/prisma/schema.prisma" ]; then
    echo "Coletando modelos do ms-billing..."
    grep -A 50 "^model " /home/ubuntu/microservices-corrigidos/ms-billing/prisma/schema.prisma >> prisma/all_models.txt
fi

echo "" >> prisma/all_models.txt
echo "=== MS-PROCEDURES ===" >> prisma/all_models.txt

# Coletar modelos do ms-procedures
if [ -f "/home/ubuntu/microservices-corrigidos/ms-procedures/prisma/schema.prisma" ]; then
    echo "Coletando modelos do ms-procedures..."
    grep -A 50 "^model " /home/ubuntu/microservices-corrigidos/ms-procedures/prisma/schema.prisma >> prisma/all_models.txt
fi

echo "" >> prisma/all_models.txt
echo "=== MS-RULES-ENGINE ===" >> prisma/all_models.txt

# Coletar modelos do ms-rules-engine
if [ -f "/home/ubuntu/microservices-corrigidos/ms-rules-engine/prisma/schema.prisma" ]; then
    echo "Coletando modelos do ms-rules-engine..."
    grep -A 50 "^model " /home/ubuntu/microservices-corrigidos/ms-rules-engine/prisma/schema.prisma >> prisma/all_models.txt
fi

echo "✅ Modelos coletados em prisma/all_models.txt"
