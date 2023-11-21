#./serviceaccount-create.ps1 -names "sa1","sa2" -namespaces "ns1","ns2"
param(
    [Parameter(Mandatory=$true)]
    [string[]]$names,

    [Parameter(Mandatory=$true)]
    [string[]]$namespaces
)

foreach ($namespace in $namespaces) {
    foreach ($name in $names) {
        try {
            # Define the YAML content
            $yamlContent = @"
apiVersion: v1
kind: ServiceAccount
metadata:
  name: $name
  namespace: $namespace
"@

            # Save the YAML content to a file
            $yamlContent | Out-File -FilePath "./$namespace-$name-sa.yaml"
        } catch {
            Write-Error "An error occurred while processing $name in ${namespace}: $_"
        }
    }
}