#!/bin/bash

# Defina o nome do grupo de recursos e o recurso
resource_group="exercicios-learn-eng-devops-beginner"
resource_name="jcstorage6078436903c7"
resource_type="Microsoft.Storage/storageAccounts"
lock_name="BloqueioNaoDeletar"  # Nome do bloqueio a ser removido

# Passo 1: Verificar se o bloqueio existe
echo "Verificando se o bloqueio '$lock_name' existe no recurso $resource_name..."
lock_info=$(az lock list --resource-group "$resource_group" --query "[?name=='$lock_name']")

if [[ -z "$lock_info" ]]; then
  echo "Erro: O bloqueio '$lock_name' não foi encontrado."
else
  echo "Bloqueio encontrado: $lock_info"
  echo "Removendo o bloqueio '$lock_name' no recurso $resource_name..."

  # Passo 2: Remover o bloqueio
  az lock delete --name "$lock_name" --resource-group "$resource_group" --resource "$resource_name" --resource-type "$resource_type"
  
  if [[ $? -eq 0 ]]; then
    echo "Bloqueio '$lock_name' removido com sucesso."
  else
    echo "Erro ao remover o bloqueio."
  fi
fi

# Passo 3: Excluir a conta de armazenamento
echo "Excluindo a conta de armazenamento '$resource_name' no grupo de recursos '$resource_group'..."
az storage account delete --name "$resource_name" --resource-group "$resource_group" --yes

if [[ $? -eq 0 ]]; then
  echo "Conta de armazenamento '$resource_name' foi marcada para exclusão."
else
  echo "Erro ao excluir a conta de armazenamento."
fi
