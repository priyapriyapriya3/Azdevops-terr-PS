#bash script to get client id from MIS
#!/bin/bash
subscription_id = ""
MSI_id = []
az account set --subscription $subscription_id
#print client ID for each MSI name in the list

for id in $MSI_id
do
    echo "Getting client ID for MSI ID $id"
    az identity show --ids $id --query clientId -o tsv
done

#call and execute terraform file 


