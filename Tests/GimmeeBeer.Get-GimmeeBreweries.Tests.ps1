#Requires -Modules Pester

$Script:module = 'GimmeeBeer'
$Script:function = 'Get-GimmeeBreweries'

Import-Module ..\$Script:module.psm1 -Force
