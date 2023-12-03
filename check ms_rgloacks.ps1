#ps script in azure check if Rg locks applied to MC resource group in an aks cluster


#set variables
$clustername = "akscluster"
$resourcegroup = "akscluster-rg"

#login to azure powershell commands
Connect-AzAccount

#set subscription powershell commands
Set-AzContext -Subscription "subscriptionname"

#write all below logic to a function and call the function in powershell 

function CheckAKSResourceGroupLocks {
    param(
        [Parameter(Mandatory=$true)]
        [string]$clusterName,

        [Parameter(Mandatory=$true)]
        [string]$resourceGroupName
    )

    # Check if the AKS cluster exists
    $cluster = Get-AzAks -ResourceGroupName $resourceGroupName -Name $clusterName -ErrorAction SilentlyContinue

    if ($null -eq $cluster) {
        Write-Output "The AKS cluster $clusterName does not exist in the resource group $resourceGroupName."
        return
    }

    # Get the MC resource group name
    $mcResourceGroupName = $cluster.NodeResourceGroup

    # Check if locks are applied to the MC resource group
    $locks = Get-AzResourceLock -ResourceGroupName $mcResourceGroupName

    if ($locks.Count -gt 0) {
        Write-Output "The following locks are applied to the MC resource group $mcResourceGroupName:"
        $locks | ForEach-Object { Write-Output $_.Name }
    } else {
        Write-Output "No locks are applied to the MC resource group $mcResourceGroupName."
    }
}

# Call the function
CheckAKSResourceGroupLocks -clusterName "yourClusterName" -resourceGroupName "yourResourceGroupName"