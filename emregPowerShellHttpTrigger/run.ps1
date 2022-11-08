using namespace System.Net

# Input bindings are passed in via param block.
param($Request, $TriggerMetadata)

# Write to the Azure Functions log stream.
Write-Host "PowerShell HTTP trigger function processed a request."

# Interact with query parameters or the body of the request.
$name = $Request.Query.Name
if (-not $name) {
    $name = $Request.Body.Name
}

$body = "This HTTP triggered function executed successfully. Pass a name in the query string or in the request body for a personalized response. MSI_SECRET:$($env:MSI_SECRET)"

Write-Verbose "MSI_SECRET:$($env:MSI_SECRET)"
if ($name) {
    $Context = Get-AzContext
    Write-Output $Context
    $body = "Hello, $name. This HTTP triggered function executed successfully. MSI_SECRET:$($env:MSI_SECRET), Subcription: $($Context.SubscriptionName), TenantID: $($Context.TenantID) "
    
}

# Associate values to output bindings by calling 'Push-OutputBinding'.
Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
    StatusCode = [HttpStatusCode]::OK
    Body = $body
})
