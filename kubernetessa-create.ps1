# create script to create and save yaml file
param(
    [Parameter(Mandatory=$true)]
    [string[]]$names
)

foreach ($name in $names) {
    # Define the YAML content
    $yamlContent = @"
apiVersion: v1
kind: Pod
metadata:
  name: $name
spec:
  containers:
  - name: my-container
    image: my-image
"@

    # Save the YAML content to a file
    $yamlContent | Out-File -FilePath "./$name.yaml"
}






