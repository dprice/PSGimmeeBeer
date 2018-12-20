#Requires -Modules Pester

$Script:module = 'GimmeeBeer'
$Script:function = 'Get-GimmeeBeerSettings'

Import-Module ..\$Script:module.psm1 -Force

Describe 'GimmeeBeer Get-GimmeeBeerSettings Tests' {
    BeforeEach {
        Remove-Item "..\$Script:module.json" -ErrorAction Ignore
    }

    It "[$Script:module] $Script:function should throw an error for missing configuration" {
        {Get-GimmeeBeerSettings} | Should Throw 'Unable to locate Gimmee settings'
    }

    It "[$Script:module] $Script:function should return a non-empty valid configuration PSObject" {
        $splat = @{
            GimmeeUrl       = 'http://test.com'
            GimeeAppId      = '2'
            GimmeePw        = '3'
            BreweryDbUrl    = 'http://test.com'
            BreweryDbApiKey = '5'
        }
        Set-GimmeeBeerSettings @splat
        $settings = Get-GimmeeBeerSettings
        $settings | Should Not BeNullOrEmpty
        $settings | Should BeOfType System.Management.Automation.PSObject
        $settings.GimmeeUrl | Should Be $splat.GimmeeUrl
        $settings.GimmeeAppId | Should Be $splat.GimeeAppId
        $settings.GimmeePw | Should Be $splat.GimmeePw
        $settings.BreweryDbUrl | Should Be $splat.BreweryDbUrl
        $settings.BreweryDbApiKey | Should Be $splat.BreweryDbApiKey
    }
}