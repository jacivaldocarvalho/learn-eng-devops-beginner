#!/bin/bash

# Definir o nome do grupo de recursos
resource_group="exercicios-learn-eng-devops-beginner"

# Gerar um nome válido para a conta de armazenamento com 24 caracteres no total
# Exemplo: "armazenam123456" (12 caracteres do prefixo + 12 do número aleatório)
storage_account_name="jcstorage$(date +%s | tail -c 7)$(openssl rand -hex 3)"  # Exemplo: armazenamento1633028741162af84

# Certificar-se de que o nome não ultrapasse 24 caracteres
storage_account_name="${storage_account_name:0:24}"  # Limita o nome a 24 caracteres

# Definir a região padrão
location="EastUS"  # Você pode mudar para uma região específica, se necessário.

# Criar o grupo de recursos
echo "Criando o grupo de recursos $resource_group..."
az group create --name $resource_group --location $location

# Criar a conta de armazenamento
echo "Criando a conta de armazenamento $storage_account_name..."
az storage account create \
  --name $storage_account_name \
  --resource-group $resource_group \
  --location $location \
  --sku Standard_LRS \
  --kind StorageV2 
 

# Exibir detalhes sobre a conta de armazenamento criada
echo "Show! Conta de armazenamento $storage_account_name criada com sucesso no grupo de recursos $resource_group."
az storage account show --name $storage_account_name --resource-group $resource_group --output table