#Requires -Modules Pester

$Script:module = 'GimmeeBeer'
$Script:functions = @(
    'Set-GimmeeBeerSettings',
    'Get-GimmeeBeerSettings',
    'Get-GimmeeToken',
    'Get-GimmeeBeers',
    'Get-GimmeeBreweries'
)

Import-Module "..\$Script:module.psm1" -Force

Describe 'GimmeeBeer Module Tests' {
    Context "[$Script:module] Module Setup" {
        It "has the module $Script:module.psm1" {
            "..\$Script:module.psm1" | Should Exist
        }

        # It "has the manifest file for module $Script:module.psm1" {
        #     "..\$Script:module.psd1" | Should Exist
        #     "..\$Script:module.psd1" | Should Contain "$Script:module.psm1"
        # }

        It "$Script:module is valid PowerShell code" {
            $file = Get-Content -Path "..\$Script:module.psm1" -ErrorAction Stop
            $errors = $null
            $null = [System.Management.Automation.PSParser]::Tokenize($file, [ref]$errors)
            $errors.Count | Should Be 0
        }

        foreach ($function in $Script:functions) {
            It "$Script:module should export function $function" {
                (Get-Command -Module $Script:module).Name | Should Contain $function
            }
        }
    }

    Context "[$Script:module] Gimmee functions have tests" {
        foreach ($function in $Script:functions) {
            It "$Script:module.$function.Tests.ps1 should exist" {
                "$Script:module.$function.Tests.ps1" | Should Exist
            }
        }
    }
}
