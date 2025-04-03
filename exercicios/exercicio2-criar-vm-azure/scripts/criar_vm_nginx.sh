#!/bin/bash

# Definindo variáveis para facilitar o gerenciamento
RESOURCE_GROUP="learn-078fa850-2a51-4085-b9c9-9c069c0bd2dc"
VM_NAME="my-vm"
NSG_NAME="my-vmNSG"
ADMIN_USER="azureuser"
IMAGE="Ubuntu2204"
PUBLIC_IP_SKU="Standard"

# Criar a máquina virtual
echo "Criando a máquina virtual..."
az vm create \
  --resource-group "$RESOURCE_GROUP" \
  --name "$VM_NAME" \
  --public-ip-sku "$PUBLIC_IP_SKU" \
  --image "$IMAGE" \
  --admin-username "$ADMIN_USER" \
  --generate-ssh-keys

# Instalar o Nginx via extensão de script personalizado
echo "Instalando o Nginx na VM..."
az vm extension set \
  --resource-group "$RESOURCE_GROUP" \
  --vm-name "$VM_NAME" \
  --name customScript \
  --publisher Microsoft.Azure.Extensions \
  --version 2.1 \
  --settings '{"fileUris":["https://raw.githubusercontent.com/MicrosoftDocs/mslearn-welcome-to-azure/master/configure-nginx.sh"]}' \
  --protected-settings '{"commandToExecute": "./configure-nginx.sh"}'

# Obter o IP público da VM
IPADDRESS="$(az vm list-ip-addresses --resource-group "$RESOURCE_GROUP" --name "$VM_NAME" --query "[].virtualMachine.network.publicIpAddresses[*].ipAddress" --output tsv)"

# Mostrar o endereço IP
echo "O IP público da sua VM é: $IPADDRESS"

# Tentar acessar a página inicial do servidor via curl
echo "Tentando acessar o servidor via curl..."
curl --connect-timeout 5 http://$IPADDRESS

# Listar as regras do grupo de segurança de rede associado à VM
echo "Listando as regras de NSG..."
az network nsg rule list \
  --resource-group "$RESOURCE_GROUP" \
  --nsg-name "$NSG_NAME" \
  --query '[].{Name:name, Priority:priority, Port:destinationPortRange, Access:access}' \
  --output table

# Criar a regra de segurança de rede para permitir acesso HTTP (porta 80)
echo "Criando regra de segurança para permitir HTTP na porta 80..."
az network nsg rule create \
  --resource-group "$RESOURCE_GROUP" \
  --nsg-name "$NSG_NAME" \
  --name allow-http \
  --protocol tcp \
  --priority 100 \
  --destination-port-range 80 \
  --access Allow

# Listar novamente as regras para verificar a nova regra
echo "Verificando as regras atualizadas de NSG..."
az network nsg rule list \
  --resource-group "$RESOURCE_GROUP" \
  --nsg-name "$NSG_NAME" \
  --query '[].{Name:name, Priority:priority, Port:destinationPortRange, Access:access}' \
  --output table

# Tentar acessar a página inicial do servidor novamente após criar a regra de segurança
echo "Tentando acessar o servidor novamente via curl..."
curl --connect-timeout 5 http://$IPADDRESS
