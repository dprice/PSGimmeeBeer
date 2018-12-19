#Requires -Modules Pester

Import-Module ..\GimmeeBeer.psm1 -Force

$module = 'GimmeeBeer'
$function = 'Set-GimmeeBeerSettings'

Describe 'GimmeeBeer Get-GimmeeBeerSettings Tests' {
    Context "[$module] $function should throw an exception with missing parameters" {
        $parameters = @(
            'GimmeeUrl',
            'GimmeeAppId',
            'GimmeePw',
            'BreweryDbUrl',
            'BreweryDbApiKey'
        )
        foreach ($parameter in $parameters) {
            It "[$module] $function should throw an error with missing parameter $parameter" {
                {Set-GimmeeBeerSettings -$parameter $null} | Should Throw
            }
        }

        It "[$module] $function should not throw exception when all parameters passed" {
            $splat = @{
                GimmeeUrl       = 'http://test.com'
                GimeeAppId      = '2'
                GimmeePw        = '3'
                BreweryDbUrl    = 'http://test.com'
                BreweryDbApiKey = '5'
            }
            {Set-GimmeeBeerSettings @splat} | Should Not Throw
        }
    }

    Context "[$module] $function should validate parameters" {
        $splat = @{
            GimmeeUrl       = '1'
            GimeeAppId      = '2'
            GimmeePw        = '3'
            BreweryDbUrl    = 'http://test.com'
            BreweryDbApiKey = '5'
        }

        It "[$module] $function should throw exception for invalid url for GimmeeUrl" {
            $splat.GimmeeUrl = '1'
            $splat.BreweryDbUrl = 'http://test.com'
            {Set-GimmeeBeerSettings @splat} | Should Throw 'not a valid url'
        }

        It "[$module] $function should throw exception for invalid url for BreweryDbUrl" {
            $splat.GimmeeUrl = 'http://test.com'
            $splat.BreweryDbUrl = '1'
            {Set-GimmeeBeerSettings @splat} | Should Throw 'not a valid url'
        }
    }

    Context "[$module] $function should create a valid non-empty configuration file" {
        It "[$module] $function should create non-empty file" {
            $splat = @{
                GimmeeUrl       = 'http://test.com'
                GimeeAppId      = '2'
                GimmeePw        = '3'
                BreweryDbUrl    = 'http://test.com'
                BreweryDbApiKey = '5'
            }
            Remove-Item ..\$module.json
            Set-GimmeeBeerSettings @splat
            Get-Item ..\$module.json | Should Exist
            Get-Content -Path..\$module.json | Should Not BeNullOrEmpty
        }
    }
}