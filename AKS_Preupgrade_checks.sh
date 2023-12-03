
subscription_id=""
AKS_CLUSTER_NAME = ""
AKS_RESOURCE_GROUP_akscluster = ""
# get MC rg name in AKS cluster
echo "Getting MC resource group name"
AKS_MC_RESOURCE_GROUP=$(az aks show --resource-group $AKS_RESOURCE_GROUP_akscluster --name $AKS_CLUSTER_NAME --query nodeResourceGroup -o tsv)

#check locks on MC RG in a function and call
def check_locks():
    echo "Checking locks on MC resource group"
    LOCK_STATE=$(az lock show --name "lock" --resource-group $AKS_MC_RESOURCE_GROUP )
    #if locks exist remove them
    if [ -z "$LOCK_STATE" ]
    then
        echo "No lock found on MC resource group"
    else
        echo "Lock found on MC resource group"
        echo "Removing lock on MC resource group"
        az lock delete --name "lock" --resource-group $AKS_MC_RESOURCE_GROUP
    fi
#call function
check_locks

def get_subnet_ipdetails():
    #get vent in aks cluster
        echo "Getting vnet in AKS cluster"
        AKS_VNET=$(az network vnet list --resource-group $AKS_MC_RESOURCE_GROUP --query [0].name -o tsv)

        #check Subnets list in AKS cluster
        echo "Checking subnets list in AKS cluster"
        AKS_SUBNETS=$(az network vnet subnet list --resource-group $AKS_MC_RESOURCE_GROUP --vnet-name $AKS_VNET --query [].name -o tsv)

        #loop through each subnet and check used IPs 
        for subnet in $AKS_SUBNETS
        do
            #print vnet, subnet, ip range details
            echo "Getting vnet, subnet, ip range details"
            az network vnet subnet show --resource-group $AKS_MC_RESOURCE_GROUP --vnet-name $AKS_VNET --name $subnet --query [addressPrefix, name, id] -o tsv
            
            echo "Checking used IPs in subnet $subnet"
            USED_IPS=$(az network vnet subnet show --resource-group $AKS_MC_RESOURCE_GROUP --vnet-name $AKS_VNET --name $subnet --query addressPrefix -o tsv)
            available_ips=$(az network vnet subnet list --resource-group $AKS_MC_RESOURCE_GROUP --vnet-name $AKS_VNET --query [].addressPrefix -o tsv)
            
            echo "Used IPs in subnet $subnet are $USED_IPS"
        done

        #check available available subnets ips in AKS cluster
        echo "Checking available subnets ips in AKS cluster"
        AKS_SUBNETS_IPS=$(az network vnet subnet list --resource-group $AKS_MC_RESOURCE_GROUP --vnet-name $AKS_VNET --query [].addressPrefix -o tsv)
        
def aksversion_availableversions():
    #get aks cluster version
    echo "Getting AKS cluster version"

    AKS_VERSION=$(az aks show --resource-group $AKS_RESOURCE_GROUP_akscluster --name $AKS_CLUSTER_NAME --query kubernetesVersion -o tsv)
    #check if there are any latest versions for upgrade
    echo "Checking if there are any latest versions for upgrade"
    AVAILABLE_VERSIONS=$(az aks get-upgrades --resource-group $AKS_RESOURCE_GROUP_akscluster --name $AKS_CLUSTER_NAME --query [].kubernetesVersions -o tsv)
    if [ -z "$AVAILABLE_VERSIONS" ]
    then
        echo "No latest versions available for upgrade"
    else
        echo "Latest versions available for upgrade are $AVAILABLE_VERSIONS"
    fi

    
#scale down AKS cluster nodes
def scale_down_AKS Cluster():
    #get get all nodepools and node count
    echo "Getting  nodepool namea and node count"\
    NODEPOOLS=$(az aks nodepool list --resource-group $AKS_RESOURCE_GROUP_akscluster --cluster-name $AKS_CLUSTER_NAME --query [].name -o tsv)
    for nodepool in $NODEPOOLS
    do
        echo "Getting node count in nodepool $nodepool"
        NODE_COUNT=$(az aks nodepool show --resource-group $AKS_RESOURCE_GROUP_akscluster --cluster-name $AKS_CLUSTER_NAME --name $nodepool --query count -o tsv)
        echo "Node count in nodepool $nodepool is $NODE_COUNT"
         #take input for each nodepool for count of nodes to scale down or press no to skip
        echo "Enter the count of nodes to scale down in nodepool $nodepool or press no to skip"
        read count
        if [ $count == "no" ]
        then
            echo "Skipping scaling down nodepool $nodepool"
        else
            echo "Scaling down nodepool $nodepool"
            echo run this connand to scale down nodepool $nodepool
            echo "az aks nodepool scale --resource-group $AKS_RESOURCE_GROUP_akscluster --cluster-name $AKS_CLUSTER_NAME --name $nodepool --node-count $count"
        fi
    done    

