<#
Script to move databases into different elastic Pools
#>
param (
    # height of largest column without top bar
    [Parameter(Mandatory=$true)]
    [String]$ResourceGroupName,
    [Parameter(Mandatory=$true)]
    [String]$ServerName,
    [Parameter(Mandatory=$true)]
    [String]$DatabaseName,
     [Parameter(Mandatory=$true)]
    [String]$ElasticPoolName,
    [Parameter(Mandatory=$true)]
    [String]$SubscriptionId
)

# import the module into the PowerShell session
Import-Module Az
# connect to Azure with an interactive dialog for sign-in
#Connect-AzAccount
# list subscriptions available and copy id of the subscription target the managed instance belongs to
Get-AzSubscription -TenantId (Get-AzContext).Tenant
# set subscription for the session
Select-AzSubscription $SubscriptionId
Set-AzSqlDatabase -ResourceGroupName $ResourceGroupName -ServerName $ServerName -DatabaseName $DatabaseName  -ElasticPoolName $ElasticPoolName