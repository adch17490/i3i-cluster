#!/bin/bash

set -e

ACTION=$1

if [[ "$ACTION" == "up" ]]; then
  echo "🚀 Inicializando Terraform..."
  terraform init

  echo "📋 Planificando..."
  terraform plan -out=tfplan

  echo "🛠 Aplicando..."
  terraform apply tfplan

  echo "✅ Infraestructura desplegada."

elif [[ "$ACTION" == "down" ]]; then
  echo "⚠️ Esta acción destruirá toda la infraestructura."

  read -p "¿Estás seguro? (yes/no): " CONFIRM
  if [[ "$CONFIRM" == "yes" ]]; then
    terraform destroy -auto-approve
    echo "🧹 Infraestructura destruida."
  else
    echo "❌ Cancelado."
  fi

else
  echo "Uso: ./infra.sh [up|down]"
fi
