using namespace System.Net

# Input bindings are passed in via param block.
param($Request, $TriggerMetadata)

# Write to the Azure Functions log stream.
Write-Host "PowerShell HTTP trigger function processed a request."
$SleepMilliseconds = get-random -Minimum 100 -Maximum 2000
# Interact with query parameters or the body of the request.
$name = $Request.Query.Name
if (-not $name) {
    $name = $Request.Body.Name
}

$body = "This HTTP triggered function executed successfully. Sleep Ms= '$SleepMilliseconds' Pass a name in the query string or in the request body for a personalized response. MSI_SECRET:$($env:MSI_SECRET)"

Write-Verbose "MSI_SECRET:$($env:MSI_SECRET)"
if ($name) {
    $Context = Get-AzContext
    Write-Host $Context
    $JsonContext = [pscustomObject]@{
        Name = $name
        SleepMs= $SleepMilliseconds
        MSI_SECRET=$env:MSI_SECRET
        Subscription = $Context.Subscription.Name
        TenantID = $Context.Tenant.Id
    }
    $Body = $JsonContext | ConvertTo-Json
    # $body = "Hello, $name. Sleep Ms= '$SleepMilliseconds' This HTTP triggered function executed successfully. MSI_SECRET:$($env:MSI_SECRET), Subcription: $($Context.Subscription.Name), TenantID: $($Context.Tenant.Id) "
    
}
Start-Sleep -Milliseconds $SleepMilliseconds
# Associate values to output bindings by calling 'Push-OutputBinding'.
Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
    StatusCode = [HttpStatusCode]::OK
    Body = $body
})
