#Requires -Modules Pester

$Script:module = 'GimmeeBeer'
$Script:function = 'Get-GimmeeBeerSettings'

Import-Module ..\$Script:module.psm1 -Force

Describe 'GimmeeBeer Get-GimmeeBeerSettings Tests' {
    Context "[$Script:module] $Script:function should throw an exception with missing parameters" {
        $parameters = @(
            'GimmeeUrl',
            'GimmeeAppId',
            'GimmeePw',
            'BreweryDbUrl',
            'BreweryDbApiKey'
        )
        foreach ($parameter in $parameters) {
            It "[$Script:module] $Script:function should throw an error with missing parameter $parameter" {
                {Set-GimmeeBeerSettings -$parameter $null} | Should Throw
            }
        }

        It "[$Script:module] $Script:function should not throw exception when all parameters passed" {
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

    Context "[$Script:module] $Script:function should validate parameters" {
        $splat = @{
            GimmeeUrl       = '1'
            GimeeAppId      = '2'
            GimmeePw        = '3'
            BreweryDbUrl    = '4'
            BreweryDbApiKey = '5'
        }

        It "[$Script:module] $Script:function should throw exception for invalid url for GimmeeUrl" {
            $splat.GimmeeUrl = '1'
            $splat.BreweryDbUrl = 'http://test.com'
            {Set-GimmeeBeerSettings @splat} | Should Throw 'not a valid url'
        }

        It "[$Script:module] $Script:function should throw exception for invalid url for BreweryDbUrl" {
            $splat.GimmeeUrl = 'http://test.com'
            $splat.BreweryDbUrl = '4'
            {Set-GimmeeBeerSettings @splat} | Should Throw 'not a valid url'
        }
    }

    Context "[$Script:module] $Script:function should create a valid non-empty configuration file" {
        It "[$Script:module] $Script:function should create non-empty file" {
            $splat = @{
                GimmeeUrl       = 'http://test.com'
                GimeeAppId      = '2'
                GimmeePw        = '3'
                BreweryDbUrl    = 'http://test.com'
                BreweryDbApiKey = '5'
            }
            Remove-Item ..\$Script:module.json -ErrorAction Ignore
            Set-GimmeeBeerSettings @splat
            Get-Item ..\$Script:module.json | Should Exist
            Get-Content -Path..\$Script:module.json | Should Not BeNullOrEmpty
        }
    }
}