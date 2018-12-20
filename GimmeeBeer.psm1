$Script:settingsFile = 'GimmeeBeer.json'

function Set-GimmeeBeerSettings {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline = $false)]
        [ValidateScript( {
                if (![system.uri]::IsWellFormedUriString($_, [System.UriKind]::Absolute)) {
                    throw "GimmeeUrl is not a valid URL"
                }
                else { return $true }
            })]
        [string] $GimmeeUrl = $(throw "GimmeeUrl is mandatory, please provide a value."),

        [Parameter(ValueFromPipeline = $false)]
        [ValidateNotNullOrEmpty()]
        [string] $GimeeAppId = $(throw "GimeeAppId is mandatory, please provide a value."),

        [Parameter(ValueFromPipeline = $false)]
        [ValidateNotNullOrEmpty()]
        [string] $GimmeePw = $(throw "GimmeePw is mandatory, please provide a value."),

        [Parameter(ValueFromPipeline = $false)]
        [ValidateScript( {
                if (![system.uri]::IsWellFormedUriString($_, [System.UriKind]::Absolute)) {
                    throw "GimmeeUrl is not a valid URL"
                }
                else { return $true }
            })]
        [string] $BreweryDbUrl = $(throw "BreweryDbUrl is mandatory, please provide a value."),

        [Parameter(ValueFromPipeline = $false)]
        [ValidateNotNullOrEmpty()]
        [string] $BreweryDbApiKey = $(throw "BreweryDbApiKey is mandatory, please provide a value.")
    )
    $settings = [ordered]@{
        GimmeeUrl       = $GimmeeUrl
        GimmeeAppId     = $GimeeAppId
        GimmeePw        = $GimmeePw
        BreweryDbUrl    = $BreweryDbUrl
        BreweryDbApiKey = $BreweryDbApiKey
    }
    $settings | ConvertTo-Json | Set-Content -Path "$PSScriptRoot\$Script:settingsFile" -Force
}

function Get-GimmeeBeerSettings {
    [CmdletBinding()]
    param ()
    if (!(Test-Path "$PSScriptRoot\$Script:settingsFile")) {
        throw 'Unable to locate Gimmee settings. Run Set-GimmeeBeerSettings to create.'
    }
    Get-Content -Path "$PSScriptRoot\$Script:settingsFile" | ConvertFrom-Json
}

function Get-GimmeeToken {
    [CmdletBinding()]
    param ()

    $uri = "$Script:GimmeeUrl/auth"
    $headers = @{
        'Content-Type' = 'application/x-www-form-urlencoded'
    }
    $body = @{
        appid = $Script:GimmeeAppId
        pw    = $Script:GimmeePw
    }
    $response = Invoke-RestMethod -Method Post -Uri $uri -Body $body -Headers $headers
    $response.access_token.Trim()
}

# https://documenter.getpostman.com/view/1383381/RzZ3KMKV#991072cb-ff87-4c45-83fd-98ab2bd1bff9
function Get-GimmeeBeers {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline = $false)]
        [string] $Name
    )
    $settings = Get-GimmeeBeerSettings
    $uri = "$($settings.GimmeeUrl)/beer/info"

    $response = Invoke-RestMethod -Method Get -Uri $uri

    # Transform response data
    $beers = foreach ($beer in $response.Beers) {
        $s = [ordered]@{
            Category = $beer.category
            Name = $beer.name
            ShortName = $beer.shortName
            Description = $beer.description
            IbuMin = $beer.ibuMin
            IbuMax = $beer.ibuMax
            AbvMin = $beer.abvMin
            AbvMax = $beer.abvMax
            SrmMin = $beer.srmMin
            SrmMax = $beer.srmMax
            OgMin = $beer.ogMin
            FgMin = $beer.fgMin
            FgMax = $beer.fgMax
        }
        $b = [ordered]@{
            Name = $beer.name
            NameDisplay = $beer.nameDisplay
            Description = $beer.description
            Abv = $beer.abv
            Ibu = $beer.ibu
            Style = New-Object -TypeName psobject -Property $s
            IsOrganic = $beer.isOrganic
            IsRetired = $beer.isRetired
            Status = $beer.status
            StatusDisplay = $beer.statusDisplay
        }
        New-Object -TypeName psobject -Property $b
    }

    $data = [ordered]@{
        CurrentPage       = $response.currentPage
        NumberOfPages     = $response.numberOfPages
        TotalResults      = $response.totalResults
        Beers             = $beers
        DataProvidedBy    = $response.DataProvidedBy
        TermsOfServiceUrl = $response.TermsOfServiceUrl
        DataPullDateTime  = $response.DataPullDateTime
        GimmeeVersion     = $response.GimmeeVersion
    }
    New-Object -TypeName psobject -Property $data
}

function Get-GimmeeBreweries {
    [CmdletBinding()]
    param ()
}

Export-ModuleMember -Function Set-GimmeeBeerSettings
Export-ModuleMember -Function Get-GimmeeBeerSettings
Export-ModuleMember -Function Get-GimmeeToken
Export-ModuleMember -Function Get-GimmeeBeers
Export-ModuleMember -Function Get-GimmeeBreweries
