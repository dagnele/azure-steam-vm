# Azure Gaming VM Deployment

This repository contains an Azure Resource Manager (ARM) template for deploying a Windows 11 virtual machine optimized for game streaming using Steam and Sunshine.

## Prerequisites

Before deploying the VM, ensure you have:
- An active [Azure subscription](https://azure.microsoft.com/en-us/free/).
- [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli) installed on your machine.
- Proper permissions to create resources in an Azure resource group.

## Deployment Instructions

### Step 1: Login to Azure

```sh
az login
```

If you have multiple subscriptions, set the correct one:

```sh
az account set --subscription "<SUBSCRIPTION_ID>"
```

### Step 2: Create a Resource Group

Choose a location (e.g., `eastus`):

```sh
az group create --name myGamingVM-rg --location eastus
```

### Step 3: Deploy the ARM Template

Run the following command, replacing placeholders with your own values:

```sh
az deployment group create \
   --resource-group SteamRG \
   --template-file SteamVM.json \
   --parameters vmName="SteamVM" \
                adminUsername="yourUser" \
                adminPassword="YourPassword" \
                installScriptUri="https://raw.githubusercontent.com/dagnele/azure-steam-vm/refs/heads/main/InstallSoftware.ps1"
```

You'll be prompted to enter the administrator password securely.

### Step 4: Retrieve the Public IP Address

Once deployment is complete, get the VM's public IP address:

```sh
az network public-ip show \
    --resource-group myGamingVM-rg \
    --name myGamingVM-ip \
    --query "ipAddress" --output tsv
```

Use this IP to connect via RDP.

## Networking and Ports

The template configures the following inbound firewall rules:
- **RDP (3389/TCP)**: Remote Desktop access.
- **Steam Link (27036-27037/UDP)**: Required for Steam in-home streaming.
- **Steam TCP (27015-27030/TCP)**: Steam services.
- **Steam UDP (4380/UDP)**: Additional Steam services.

Ensure your firewall allows these ports.

## Connecting to the VM

1. Open Remote Desktop Connection (`mstsc.exe`).
2. Enter the VM's public IP.
3. Login using the provided username and password.

## Additional Setup

- Install Steam and Sunshine manually if not included in `InstallSoftware.ps1`.
- Configure Sunshine for remote streaming.
- Optimize Windows for gaming.

## Cleanup

To remove all resources:

```sh
az group delete --name myGamingVM-rg --yes --no-wait
```

## Troubleshooting

- If deployment fails, check the Azure Portal for detailed logs.
- Ensure the admin password meets Azure complexity requirements.
- Verify network security rules if you cannot connect.

## License

MIT License. See `LICENSE` file for details.
