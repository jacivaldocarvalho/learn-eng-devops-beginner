#!/bin/bash

# Defina o nome do grupo de recursos, recurso e bloqueio
resource_group="exercicios-learn-eng-devops-beginner"
resource_name="jcstorage6078436903c7"
resource_type="Microsoft.Storage/storageAccounts"
lock_name="BloqueioSomenteLeitura"  # Nome do bloqueio existente

# Verificar se o bloqueio já está aplicado
echo "Verificando se o bloqueio '$lock_name' existe no recurso $resource_name..."
lock_info=$(az lock list --resource-group "$resource_group" --query "[?name=='$lock_name']")

if [[ -z "$lock_info" ]]; then
  echo "Erro: O bloqueio '$lock_name' não foi encontrado."
  #exit 1
else
  echo "Bloqueio encontrado: $lock_info"
fi

# Remover o bloqueio existente
echo "Removendo o bloqueio '$lock_name' no recurso $resource_name..."
az lock delete --name "$lock_name" --resource-group "$resource_group" --resource "$resource_name" --resource-type "$resource_type"

if [[ $? -eq 0 ]]; then
  echo "Bloqueio '$lock_name' removido com sucesso."
else
  echo "Erro ao remover o bloqueio."
  #exit 1
fi

# Criar o novo bloqueio com tipo CanNotDelete
new_lock_name="BloqueioNaoDeletar"  # Nome do novo bloqueio
echo "Aplicando o novo bloqueio 'CanNotDelete' no recurso $resource_name..."
az lock create \
  --name "$new_lock_name" \
  --lock-type CanNotDelete \
  --resource-group "$resource_group" \
  --resource "$resource_name" \
  --resource-type "$resource_type"

# Verificar se o novo bloqueio foi aplicado com sucesso
echo "Verificando o novo bloqueio no recurso $resource_name..."
new_lock_info=$(az lock list --resource-group "$resource_group" --query "[?name=='$new_lock_name']")

if [[ -z "$new_lock_info" ]]; then
  echo "Erro: O novo bloqueio '$new_lock_name' não foi aplicado corretamente."
  exit 1
else
  echo "Novo bloqueio aplicado com sucesso:"
  echo "$new_lock_info"
fi
