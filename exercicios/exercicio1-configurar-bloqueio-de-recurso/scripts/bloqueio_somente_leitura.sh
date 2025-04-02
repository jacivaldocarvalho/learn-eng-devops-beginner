#!/bin/bash

# Defina o nome do grupo de recursos e o recurso
resource_group="exercicios-learn-eng-devops-beginner"
resource_name="jcstorage6078436903c7"
resource_type="Microsoft.Storage/storageAccounts"
lock_name="BloqueioSomenteLeitura"

# Aplicar o bloqueio de somente leitura
echo "Aplicando o bloqueio de somente leitura no recurso $resource_name..."
az lock create \
  --name "$lock_name" \
  --lock-type ReadOnly \
  --resource-group "$resource_group" \
  --resource "$resource_name" \
  --resource-type "$resource_type"

# Verificar se o bloqueio foi aplicado com sucesso
echo "Verificando o bloqueio no recurso $resource_name..."

lock_info=$(az lock list --resource-group "$resource_group" --query "[?name=='$lock_name']")

if [[ -z "$lock_info" ]]; then
  echo "O bloqueio não foi aplicado corretamente ou não foi encontrado."
else
  echo "Bloqueio aplicado com sucesso:"
  echo "$lock_info"
fi
