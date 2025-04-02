#!/bin/bash

# Defina o nome da conta de armazenamento e o contêiner
storage_account_name="jcstorage6078436903c7"
container_name="teste-container-bloqueio-delete"

# Obtenha a chave de acesso da conta de armazenamento
account_key=$(az storage account keys list --resource-group "exercicios-learn-eng-devops-beginner" --account-name "$storage_account_name" --query "[0].value" --output tsv)

# Verifique se a chave foi obtida com sucesso
if [[ -z "$account_key" ]]; then
  echo "Erro: Não foi possível obter a chave de acesso para a conta de armazenamento '$storage_account_name'."
fi

# Criar o contêiner usando a chave de acesso
create_container=$(az storage container create \
  --name "$container_name" \
  --account-name "$storage_account_name" \
  --account-key "$account_key" \
  --output none)

# Verificar se o contêiner foi criado com sucesso
if [[ $? -eq 0 ]]; then
  echo "Contêiner '$container_name' criado com sucesso na conta de armazenamento '$storage_account_name'."
else
  echo "Erro: Não foi possível criar o contêiner '$container_name'."
fi