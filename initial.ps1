# script to scale down aks cluster takign insputs as azure subscription and aks cluster name 

#Define parameters for Azure subscription ID and AKS cluster name.#

subscription_id=""
aks_cluster_name=""

# subscription_id=$(az account show --query id -o tsv)
# aks_cluster_name=$(az aks show --query name -o tsv)

# login user credentials to login azure account

#az login --service-principal -u $subscription_id -p $client_secret --tenant $tenant_id

# Login to Azure
#Connect-AzAccount
# Set the active subscription
Set-AzContext -SubscriptionId $subscriptionId

Update-AzAks -ResourceGroupName $resourceGroupName -Name $aksClusterName -NodeCount 1
#get  MC resource group name from AKS Cluster
$mcResourceGroupName = $aksCluster.NodeResourceGroup

#remove locks for MC resource group powershell command

# Get the locks on the MC resource group
$locks = Get-AzResourceLock -ResourceGroupName $mcResourceGroupName

# Remove each lock
foreach ($lock in $locks) {
    Remove-AzResourceLock -LockId $lock.LockId -Force
}

# Navigate to the directory containing the Terraform files
Set-Location -Path "Path\To\Your\Terraform\Files"

# Initialize Terraform
terraform init
# Run Terraform plan and save the output to a file
terraform plan -out=plan.out

# Convert the binary plan file to a human-readable format
terraform show -json plan.out | ConvertFrom-Json | ConvertTo-Json -Depth 10 > plan.json

# Run Terraform apply
terraform apply -auto-approve



