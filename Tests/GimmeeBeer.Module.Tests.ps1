#Requires -Modules Pester

$module = 'GimmeeBeer'
$functions = @(
    'Set-GimmeeBeerSettings',
    'Get-GimmeeBeerSettings',
    'Get-GimmeeToken',
    'Get-GimmeeBeers',
    'Get-GimmeeBreweries'
)

Describe 'GimmeeBeer Module Tests' {
    Context 'Module Setup' {
        It "has the module $module.psm1" {
            "..\$module.psm1" | Should Exist
        }

        # It "has the manifest file for module $module.psm1" {
        #     "..\$module.psd1" | Should Exist
        #     "..\$module.psd1" | Should Contain "$module.psm1"
        # }

        It "$module is valid PowerShell code" {
            $file = Get-Content -Path "..\$module.psm1" -ErrorAction Stop
            $errors = $null
            $null = [System.Management.Automation.PSParser]::Tokenize($file, [ref]$errors)
            $errors.Count | Should Be 0
        }

        Import-Module "..\$module.psm1" -Force
        foreach ($function in $functions) {
            It "$module should export function $function" {
                (Get-Command -Module $module).Name | Should Contain $function
            }
        }
    }

    Context "Gimmee functions have tests" {
        foreach ($function in $functions) {
            It "$module.$function.Tests.ps1 should exist" {
                "$module.$function.Tests.ps1" | Should Exist
            }
        }
    }
}
