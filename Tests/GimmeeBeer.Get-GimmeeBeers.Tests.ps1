#Requires -Modules Pester

function Set-GimmeeBeerSettingsForTests {
    param ()
    $splat = @{
        GimmeeUrl       = 'http://test.com'
        GimeeAppId      = '2'
        GimmeePw        = '3'
        BreweryDbUrl    = 'http://test.com'
        BreweryDbApiKey = '5'
    }
    Set-GimmeeBeerSettings @splat
}

$module = 'GimmeeBeer'
Import-Module ..\$module.psm1 -Force

$function = 'Get-GimmeeBeers'

$beerProperties = 'Name', 'NameDisplay', 'Description', 'Abv', 'Ibu', 'Style', 'IsOrganic', 'IsRetired', 'Status', 'StatusDisplay'
$beerStyleProperties = 'Category', 'Name', 'ShortName', 'Description', 'IbuMin', 'IbuMax', 'AbvMin', 'AbvMax', 'SrmMin', 'SrmMax', 'OgMin', 'FgMin', 'FgMax'

Describe 'GimmeeBeer Get-GimmeeBeers Tests' {
    It "[$module] $function should throw an error for missing configuration" {
        Remove-Item ..\$module.json -ErrorAction Ignore
        {Get-GimmeeBeers} | Should Throw 'Unable to locate Gimmee settings'
    }

    It "[$module] $function should return a non-empty valid data PSObject" {
        Set-GimmeeBeerSettingsForTests
        $beers = Get-GimmeeBeers
        $beers | Should Not BeNullOrEmpty
        $beers | Should BeOfType System.Management.Automation.PSObject
    }

    Context "[$module] $function should have the correct properties" {
        Set-GimmeeBeerSettingsForTests
        $beers = Get-GimmeeBeers

        $properties = @('CurrentPage', 'NumberOfPages', 'TotalResults', 'Beers', 'DataProvidedBy', 'TermsOfServiceUrl', 'DataPullDateTime', 'GimmeeVersion')
        foreach ($property in $properties) {
            It "[$module] $function should have a property of $property" {
                [bool]($beers.PSObject.Properties.Name -cmatch $property) | Should BeTrue
            }
        }
    }
}