# Automação de Criação e Configuração de Máquina Virtual no Azure com Nginx Usando Script Bash

## Índice

- [Automação de Criação e Configuração de Máquina Virtual no Azure com Nginx Usando Script Bash](#automação-de-criação-e-configuração-de-máquina-virtual-no-azure-com-nginx-usando-script-bash)
  - [Índice](#índice)
  - [Introdução](#introdução)
- [README: Automação de Criação e Configuração de Máquina Virtual no Azure com Nginx Usando Script Bash](#readme-automação-de-criação-e-configuração-de-máquina-virtual-no-azure-com-nginx-usando-script-bash)
  - [Índice](#índice-1)
  - [Introdução](#introdução-1)
  - [Objetivo](#objetivo)
  - [Estrutura do Script](#estrutura-do-script)
    - [1. Definição de Variáveis](#1-definição-de-variáveis)
    - [2. Criação da Máquina Virtual](#2-criação-da-máquina-virtual)
    - [3. Instalação do Nginx](#3-instalação-do-nginx)
    - [4. Configuração de Regras de Segurança](#4-configuração-de-regras-de-segurança)
    - [5. Verificação do Servidor Web](#5-verificação-do-servidor-web)
  - [Execução do Script](#execução-do-script)
  - [Insights sobre Automação e Bash](#insights-sobre-automação-e-bash)
  - [Conclusão](#conclusão)
  - [Referências](#referências)
  - [Objetivo](#objetivo-1)
  - [Estrutura do Script](#estrutura-do-script-1)
    - [1. Definição de Variáveis](#1-definição-de-variáveis-1)
    - [2. Criação da Máquina Virtual](#2-criação-da-máquina-virtual-1)
    - [3. Instalação do Nginx](#3-instalação-do-nginx-1)
    - [4. Configuração de Regras de Segurança](#4-configuração-de-regras-de-segurança-1)
    - [5. Verificação do Servidor Web](#5-verificação-do-servidor-web-1)
  - [Execução do Script](#execução-do-script-1)
  - [Insights sobre Automação e Bash](#insights-sobre-automação-e-bash-1)
  - [Conclusão](#conclusão-1)
  - [Referências](#referências-1)

---

## Introdução

A automação de processos na nuvem tem se tornado uma prática cada vez mais necessária para melhorar a eficiência, reduzir erros humanos e acelerar o provisionamento de infraestrutura. Este artigo apresenta uma solução de automação para criação de uma máquina virtual (VM) no **Azure**, instalação do servidor web **Nginx** e configuração das regras de segurança de rede, tudo isso utilizando um **script Bash**.

Neste exercício, o script automatiza a criação da VM, instalação do Nginx, configuração do Grupo de Segurança de Rede (NSG) e realiza testes de conectividade HTTP, utilizando a **Azure CLI**. A ideia principal é demonstrar como um script pode facilitar a gestão de recursos na nuvem de forma rápida e eficiente.

**"Este artigo foi desenvolvido com base nas tarefas propostas nos exercícios da plataforma Microsoft Learn, disponível em: [Criar uma máquina virtual do Azure](https://learn.microsoft.com/pt-br/training/modules/describe-azure-compute-networking-services/3-exercise-create-azure-virtual-machine.)" e [Configurar o acesso à rede](https://learn.microsoft.com/pt-br/training/modules/describe-azure-compute-networking-services/9-exercise-configure-network-access)**

# README: Automação de Criação e Configuração de Máquina Virtual no Azure com Nginx Usando Script Bash

## Índice

1. [Introdução](#introdução)
2. [Objetivo](#objetivo)
3. [Estrutura do Script](#estrutura-do-script)
   1. [Definição de Variáveis](#definição-de-variáveis)
   2. [Criação da Máquina Virtual](#criação-da-máquina-virtual)
   3. [Instalação do Nginx](#instalação-do-nginx)
   4. [Configuração de Regras de Segurança](#configuração-de-regras-de-segurança)
   5. [Verificação do Servidor Web](#verificação-do-servidor-web)
4. [Execução do Script](#execução-do-script)
5. [Insights sobre Automação e Bash](#insights-sobre-automação-e-bash)
6. [Conclusão](#conclusão)
7. [Referências](#referências)

---

## Introdução

A automação de processos na nuvem tem se tornado uma prática cada vez mais necessária para melhorar a eficiência, reduzir erros humanos e acelerar o provisionamento de infraestrutura. Este artigo apresenta uma solução de automação para criação de uma máquina virtual (VM) no **Azure**, instalação do servidor web **Nginx** e configuração das regras de segurança de rede, tudo isso utilizando um **script Bash**.

Neste exercício, o script automatiza a criação da VM, instalação do Nginx, configuração do Grupo de Segurança de Rede (NSG) e realiza testes de conectividade HTTP, utilizando a **Azure CLI**. A ideia principal é demonstrar como um script pode facilitar a gestão de recursos na nuvem de forma rápida e eficiente.

## Objetivo

O objetivo desta atividade é demonstrar como utilizar um script Bash para:

1. Criar uma máquina virtual Linux no Azure.
2. Instalar e configurar o servidor **Nginx** automaticamente.
3. Configurar as regras de segurança de rede para permitir o tráfego HTTP (porta 80).
4. Verificar se o servidor web está acessível externamente.

O script foi criado para ser executado em ambientes como o **Azure Cloud Shell** ou **localmente** com o Azure CLI instalado.

## Estrutura do Script

O script apresentado automatiza uma série de tarefas na nuvem e tem a seguinte estrutura:

### 1. Definição de Variáveis

O primeiro passo do script é definir variáveis importantes para evitar repetição de valores e facilitar a manutenção do código:

```bash
RESOURCE_GROUP="learn-078fa850-2a51-4085-b9c9-9c069c0bd2dc"
VM_NAME="my-vm"
NSG_NAME="my-vmNSG"
ADMIN_USER="azureuser"
IMAGE="Ubuntu2204"
PUBLIC_IP_SKU="Standard"
```

Essas variáveis permitem um controle mais organizado sobre os valores usados em múltiplos comandos, como o nome da máquina virtual, o grupo de recursos e a imagem do sistema operacional.

### 2. Criação da Máquina Virtual

O script utiliza a **Azure CLI** para criar uma máquina virtual no Azure com o sistema operacional Ubuntu. O comando para criação da VM é o seguinte:

```bash
az vm create \
  --resource-group "$RESOURCE_GROUP" \
  --name "$VM_NAME" \
  --public-ip-sku "$PUBLIC_IP_SKU" \
  --image "$IMAGE" \
  --admin-username "$ADMIN_USER" \
  --generate-ssh-keys
```

Essa etapa garante que a VM seja criada com uma chave SSH gerada automaticamente, facilitando o acesso seguro.

### 3. Instalação do Nginx

Após a criação da VM, o script utiliza a **extensão customScript** para automatizar a instalação do servidor **Nginx**. O script de instalação é recuperado de um repositório GitHub oficial do Azure:

```bash
az vm extension set \
  --resource-group "$RESOURCE_GROUP" \
  --vm-name "$VM_NAME" \
  --name customScript \
  --publisher Microsoft.Azure.Extensions \
  --version 2.1 \
  --settings '{"fileUris":["https://raw.githubusercontent.com/MicrosoftDocs/mslearn-welcome-to-azure/master/configure-nginx.sh"]}' \
  --protected-settings '{"commandToExecute": "./configure-nginx.sh"}'
```

Isso faz com que o script de configuração seja executado na VM, instalando o **Nginx** e configurando a página inicial para exibir uma mensagem personalizada.

### 4. Configuração de Regras de Segurança

O script também cria uma regra de segurança de rede (NSG) para permitir acesso HTTP na porta 80, essencial para o funcionamento do servidor web.

```bash
az network nsg rule create \
  --resource-group "$RESOURCE_GROUP" \
  --nsg-name "$NSG_NAME" \
  --name allow-http \
  --protocol tcp \
  --priority 100 \
  --destination-port-range 80 \
  --access Allow
```

### 5. Verificação do Servidor Web

Após a configuração da VM e do Nginx, o script tenta acessar a página inicial do servidor web via `curl` para verificar se o serviço está funcionando corretamente:

```bash
curl --connect-timeout 5 http://$IPADDRESS
```

Além disso, o script também imprime o endereço IP da VM para que o usuário possa acessar o servidor diretamente no navegador.

## Execução do Script

Para executar o script, siga os seguintes passos:

1. **Crie um arquivo de script** com o nome `criar_vm_nginx.sh`.
2. **Cole o conteúdo do script** fornecido.
3. **Dê permissão de execução** ao script:

   ```bash
   chmod +x criar_vm_nginx.sh
   ```

4. **Execute o script**:

   ```bash
   ./criar_vm_nginx.sh
   ```

O script fará todo o processo automaticamente, criando a máquina virtual, instalando o Nginx e configurando o NSG para permitir o tráfego HTTP.

## Insights sobre Automação e Bash

O uso de scripts Bash na automação de serviços na nuvem é uma prática poderosa e eficiente. Algumas vantagens incluem:

- **Repetibilidade**: Automatizar tarefas repetitivas, como a criação de VMs, configuração de software e segurança, reduz o risco de erro humano e torna o processo mais rápido e confiável.
- **Facilidade de Manutenção**: Scripts podem ser facilmente modificados e versionados, permitindo que você aplique mudanças de forma rápida e eficiente em múltiplos ambientes.
- **Integração com Ferramentas de CI/CD**: Scripts Bash podem ser integrados a pipelines de CI/CD, facilitando o provisionamento de infraestrutura em ambientes de desenvolvimento, teste e produção.
- **Escalabilidade**: Quando você precisa escalar sua infraestrutura, os scripts permitem que você crie novas instâncias de forma rápida e sem a necessidade de interação manual.

## Conclusão

A automação de tarefas na nuvem com **Azure CLI** e **Bash** é uma maneira eficiente de gerenciar recursos de forma escalável e confiável. Este script facilita a criação e configuração de uma máquina virtual no Azure, incluindo a instalação do Nginx e a configuração de segurança para permitir o acesso HTTP. A automação não só acelera o processo, mas também torna o gerenciamento de infraestrutura mais robusto e seguro.

Seja para uso pessoal ou em um ambiente corporativo, o uso de scripts para automatizar tarefas de nuvem é uma estratégia recomendada para aumentar a eficiência e reduzir custos operacionais.

## Referências

1. [Documentação oficial da Azure CLI](https://learn.microsoft.com/en-us/cli/azure/)
2. [Azure VM Creation - Documentação Oficial](https://learn.microsoft.com/en-us/azure/virtual-machines/linux/quick-create-cli)
3. [Tutorial de Extensão CustomScript no Azure](https://learn.microsoft.com/en-us/azure/virtual-machines/extensions/custom-script-linux)
4. [Configuração de Nginx no Ubuntu](https://www.nginx.com/resources/wiki/start/)

## Objetivo

O objetivo desta atividade é demonstrar como utilizar um script Bash para:

1. Criar uma máquina virtual Linux no Azure.
2. Instalar e configurar o servidor **Nginx** automaticamente.
3. Configurar as regras de segurança de rede para permitir o tráfego HTTP (porta 80).
4. Verificar se o servidor web está acessível externamente.

O script foi criado para ser executado em ambientes como o **Azure Cloud Shell** ou **localmente** com o Azure CLI instalado.

## Estrutura do Script

O script apresentado automatiza uma série de tarefas na nuvem e tem a seguinte estrutura:

### 1. Definição de Variáveis

O primeiro passo do script é definir variáveis importantes para evitar repetição de valores e facilitar a manutenção do código:

```bash
RESOURCE_GROUP="learn-078fa850-2a51-4085-b9c9-9c069c0bd2dc"
VM_NAME="my-vm"
NSG_NAME="my-vmNSG"
ADMIN_USER="azureuser"
IMAGE="Ubuntu2204"
PUBLIC_IP_SKU="Standard"
```

Essas variáveis permitem um controle mais organizado sobre os valores usados em múltiplos comandos, como o nome da máquina virtual, o grupo de recursos e a imagem do sistema operacional.

### 2. Criação da Máquina Virtual

O script utiliza a **Azure CLI** para criar uma máquina virtual no Azure com o sistema operacional Ubuntu. O comando para criação da VM é o seguinte:

```bash
az vm create \
  --resource-group "$RESOURCE_GROUP" \
  --name "$VM_NAME" \
  --public-ip-sku "$PUBLIC_IP_SKU" \
  --image "$IMAGE" \
  --admin-username "$ADMIN_USER" \
  --generate-ssh-keys
```

Essa etapa garante que a VM seja criada com uma chave SSH gerada automaticamente, facilitando o acesso seguro.

### 3. Instalação do Nginx

Após a criação da VM, o script utiliza a **extensão customScript** para automatizar a instalação do servidor **Nginx**. O script de instalação é recuperado de um repositório GitHub oficial do Azure:

```bash
az vm extension set \
  --resource-group "$RESOURCE_GROUP" \
  --vm-name "$VM_NAME" \
  --name customScript \
  --publisher Microsoft.Azure.Extensions \
  --version 2.1 \
  --settings '{"fileUris":["https://raw.githubusercontent.com/MicrosoftDocs/mslearn-welcome-to-azure/master/configure-nginx.sh"]}' \
  --protected-settings '{"commandToExecute": "./configure-nginx.sh"}'
```

Isso faz com que o script de configuração seja executado na VM, instalando o **Nginx** e configurando a página inicial para exibir uma mensagem personalizada.

### 4. Configuração de Regras de Segurança

O script também cria uma regra de segurança de rede (NSG) para permitir acesso HTTP na porta 80, essencial para o funcionamento do servidor web.

```bash
az network nsg rule create \
  --resource-group "$RESOURCE_GROUP" \
  --nsg-name "$NSG_NAME" \
  --name allow-http \
  --protocol tcp \
  --priority 100 \
  --destination-port-range 80 \
  --access Allow
```

### 5. Verificação do Servidor Web

Após a configuração da VM e do Nginx, o script tenta acessar a página inicial do servidor web via `curl` para verificar se o serviço está funcionando corretamente:

```bash
curl --connect-timeout 5 http://$IPADDRESS
```

Além disso, o script também imprime o endereço IP da VM para que o usuário possa acessar o servidor diretamente no navegador.

## Execução do Script

Para executar o script, siga os seguintes passos:

1. **Crie um arquivo de script** com o nome `criar_vm_nginx.sh`.
2. **Cole o conteúdo do script** fornecido.
3. **Dê permissão de execução** ao script:

   ```bash
   chmod +x criar_vm_nginx.sh
   ```

4. **Execute o script**:

   ```bash
   ./criar_vm_nginx.sh
   ```

O script fará todo o processo automaticamente, criando a máquina virtual, instalando o Nginx e configurando o NSG para permitir o tráfego HTTP.

## Insights sobre Automação e Bash

O uso de scripts Bash na automação de serviços na nuvem é uma prática poderosa e eficiente. Algumas vantagens incluem:

- **Repetibilidade**: Automatizar tarefas repetitivas, como a criação de VMs, configuração de software e segurança, reduz o risco de erro humano e torna o processo mais rápido e confiável.
- **Facilidade de Manutenção**: Scripts podem ser facilmente modificados e versionados, permitindo que você aplique mudanças de forma rápida e eficiente em múltiplos ambientes.
- **Integração com Ferramentas de CI/CD**: Scripts Bash podem ser integrados a pipelines de CI/CD, facilitando o provisionamento de infraestrutura em ambientes de desenvolvimento, teste e produção.
- **Escalabilidade**: Quando você precisa escalar sua infraestrutura, os scripts permitem que você crie novas instâncias de forma rápida e sem a necessidade de interação manual.

## Conclusão

A automação de tarefas na nuvem com **Azure CLI** e **Bash** é uma maneira eficiente de gerenciar recursos de forma escalável e confiável. Este script facilita a criação e configuração de uma máquina virtual no Azure, incluindo a instalação do Nginx e a configuração de segurança para permitir o acesso HTTP. A automação não só acelera o processo, mas também torna o gerenciamento de infraestrutura mais robusto e seguro.

Seja para uso pessoal ou em um ambiente corporativo, o uso de scripts para automatizar tarefas de nuvem é uma estratégia recomendada para aumentar a eficiência e reduzir custos operacionais.

## Referências

1. [Documentação oficial da Azure CLI](https://learn.microsoft.com/en-us/cli/azure/)
2. [Azure VM Creation - Documentação Oficial](https://learn.microsoft.com/en-us/azure/virtual-machines/linux/quick-create-cli)
3. [Tutorial de Extensão CustomScript no Azure](https://learn.microsoft.com/en-us/azure/virtual-machines/extensions/custom-script-linux)
4. [Configuração de Nginx no Ubuntu](https://www.nginx.com/resources/wiki/start/)