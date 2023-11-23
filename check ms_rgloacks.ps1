#ps script in azure check if Rg locks applied to MC resource group in an aks cluster


#set variables
$clustername = "akscluster"
$resourcegroup = "akscluster-rg"

#login to azure powershell commands
Connect-AzAccount

#set subscription powershell commands
Set-AzContext -Subscription "subscriptionname"

#write all below logic to a function and call the function in powershell 


#check and run below command if cluster exists powershell command
if (Get-AzResource -ResourceType "Microsoft.ContainerService/managedClusters" -ResourceName $clustername -ErrorAction SilentlyContinue) {
    Write-Host "Cluster exists"
}
else {
    Write-Host "Cluster does not exist"
}
#get az aks cluster MC resource group name powershell commands
$rgname = Get-AzResource -ResourceType "Microsoft.ContainerService/managedClusters" -ResourceName $clustername -ExpandProperties | Select-Object -ExpandProperty ResourceGroupName

#check if loaks are applied to MC resource group powershell commands and output to console

$locks = Get-AzResourceLock -ResourceGroupName $rgname
if ($locks) {
    Write-Host "Locks applied to MC resource group"
    Write-Host $locks
}
else {
    Write-Host "No locks applied to MC resource group"
}



