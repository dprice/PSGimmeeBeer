#Requires -Modules Pester

$Script:module = 'GimmeeBeer'
$Script:function = 'Get-GimmeeBeers'

function Set-GimmeeBeerSettingsForTests {
    param (
        [switch] $UseIntegrationSettings
    )
    if ($UseIntegrationSettings) {
        Copy-Item ..\localtest\GimmeeBeer.json ..\. -Force
    }
    else {
        $splat = @{
            GimmeeUrl       = 'http://test.com'
            GimeeAppId      = '2'
            GimmeePw        = '3'
            BreweryDbUrl    = 'http://test.com'
            BreweryDbApiKey = '5'
        }
        Set-GimmeeBeerSettings @splat
    }
}

Import-Module ..\$Script:module.psm1 -Force

Describe 'GimmeeBeer Get-GimmeeBeers Tests' {
    BeforeEach {
        Set-GimmeeBeerSettingsForTests
        Mock -CommandName Invoke-RestMethod -ModuleName $Script:module -MockWith {
            return Get-Content .\GimmeeBeer.Get-Beers.TestData.json | ConvertFrom-Json
        }
    }

    It "[$Script:module] $Script:function should throw an error for missing configuration" {
        Remove-Item ..\$Script:module.json -ErrorAction Ignore
        {Get-GimmeeBeers} | Should Throw 'Unable to locate Gimmee settings'
        Assert-MockCalled Invoke-RestMethod -ModuleName $Script:module -Times 0
    }

    It "[$Script:module] $Script:function should return a non-empty valid data PSObject" {
        $beers = Get-GimmeeBeers

        $beers | Should Not BeNullOrEmpty
        $beers | Should BeOfType System.Management.Automation.PSObject
        Assert-MockCalled Invoke-RestMethod -ModuleName $Script:module -Times 1
    }

    Context "[$Script:module] $Script:function should have the correct properties" {
        $beers = Get-GimmeeBeers

        $beers | Should Not BeNullOrEmpty
        $beers.Beers | Should Not BeNullOrEmpty

        $properties = @('CurrentPage', 'NumberOfPages', 'TotalResults', 'Beers', 'DataProvidedBy', 'TermsOfServiceUrl', 'DataPullDateTime', 'GimmeeVersion')
        foreach ($property in $properties) {
            It "[$Script:module] $Script:function should have a property '$property'" {
                [bool]($beers.PSObject.Properties.Name -cmatch $property) | Should BeTrue
            }
        }

        $beerProperties = 'Name', 'NameDisplay', 'Description', 'Abv', 'Ibu', 'Style', 'IsOrganic', 'IsRetired', 'Status', 'StatusDisplay'
        foreach ($beerProperty in $beerProperties) {
            It "[$Script:module] $Script:function should have a Beer property '$beerProperty'" {
                [bool]($beers.Beers[0].PSObject.Properties.Name -cmatch $beerProperty) | Should BeTrue
            }
        }

        $beerStyleProperties = 'Category', 'Name', 'ShortName', 'Description', 'IbuMin', 'IbuMax', 'AbvMin', 'AbvMax', 'SrmMin', 'SrmMax', 'OgMin', 'FgMin', 'FgMax'
        foreach ($beerStyleProperty in $beerStyleProperties) {
            It "[$Script:module] $Script:function should have a Beer.Style property '$beerStyleProperty'" {
                [bool]($beers.Beers[0].Style.PSObject.Properties.Name -cmatch $beerStyleProperty) | Should BeTrue
            }
        }

        Assert-MockCalled Invoke-RestMethod -ModuleName $Script:module -Times 1
    }
}