#Requires -Modules Pester

$module = 'GimmeeBeer'
Import-Module ..\$module.psm1 -Force

$function = 'Get-GimmeeBeerSettings'

Describe 'GimmeeBeer Get-GimmeeBeerSettings Tests' {
    It "[$module] $function should throw an error for missing configuration" {
        Remove-Item "..\$module.json" -ErrorAction Ignore
        {Get-GimmeeBeerSettings} | Should Throw 'Unable to locate Gimmee settings'
    }

    It "[$module] $function should return a non-empty valid configuration PSObject" {
        Remove-Item "..\$module.json" -ErrorAction Ignore
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