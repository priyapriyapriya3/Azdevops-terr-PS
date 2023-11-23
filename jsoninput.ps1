#
#./serviceaccount-create.ps1 -configFilePath "./config.json"
#
### Json input format

# {
#     "names": ["sa1", "sa2"],
#     "namespaces": ["ns1", "ns2"],
#     "clientIds": ["vvv", "sss"]
# }



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

