#
#./serviceaccount-create.ps1 -configFilePath "./config.json"
#
### Json input format

# {
#     "names": ["sa1", "sa2"],
#     "namespaces": ["ns1", "ns2"],
#     "clientIds": ["vvv", "sss"]
# }

#add documentation to below script
    
<#
.SYNOPSIS
This script generates YAML files for Kubernetes ServiceAccounts based on a JSON configuration file.

.DESCRIPTION
The script takes a JSON configuration file as input and iterates through the namespaces and names specified in the configuration. For each combination of namespace and name, it generates a YAML file for a Kubernetes ServiceAccount with the corresponding metadata and annotations.

.PARAMETER configFilePath
The path to the JSON configuration file.

.EXAMPLE
.\jsoninput.ps1 -configFilePath "C:\path\to\config.json"
#>

param(
    [Parameter(Mandatory=$true)]
    [string]$configFilePath
)

# Load the configuration from the JSON file
$config = Get-Content -Path $configFilePath | ConvertFrom-Json

foreach ($namespace in $config.namespaces) {
    for ($i = 0; $i -lt $config.names.Length; $i++) {
        try {
            # Define the YAML content
            $yamlContent = @"
apiVersion: v1
kind: ServiceAccount
metadata:
  name: $($config.names[$i])
  namespace: $namespace
  annotations:
    eks.amazonaws.com/role-arn: arn:aws:iam::$($config.clientIds[$i]):role/eksctl-cluster-NodeInstanceRole
"@

            # Save the YAML content to a file
            $yamlContent | Out-File -FilePath "./$namespace-$($config.names[$i])-sa.yaml"
        } catch {
            Write-Error "An error occurred while processing $($config.names[$i]) in $namespace: $_"
        }
    }
}
