param(
    [Parameter(Mandatory=$true)]
    [string[]]$names,

    [Parameter(Mandatory=$false)]
    [hashtable]$labels = @{},

    [Parameter(Mandatory=$false)]
    [hashtable]$annotations = @{}
)
#./kubernetessa-create.ps1 -names "pod1","pod2" -labels @{"app"="myapp"; "tier"="frontend"} -annotations @{"example.com/icon-url"="https://example.com/icon.png"}
foreach ($name in $names) {
    try {
        # Convert labels and annotations to YAML format
        $yamlLabels = ($labels.GetEnumerator() | ForEach-Object { "$($_.Key): $($_.Value)" }) -join "`n    "
        $yamlAnnotations = ($annotations.GetEnumerator() | ForEach-Object { "$($_.Key): $($_.Value)" }) -join "`n    "

        # Define the YAML content
        $yamlContent = @"
apiVersion: v1
kind: Pod
metadata:
  name: $name
  labels:
    $yamlLabels
  annotations:
    $yamlAnnotations
spec:
  containers:
  - name: my-container
    image: my-image
"@

        # Save the YAML content to a file
        $yamlContent | Out-File -FilePath "./$name.yaml"
    } catch {
        Write-Error "An error occurred while processing $name: $_"
    }
}