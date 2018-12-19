$Script:settingsFile = 'GimmeeBeer.json'

function Set-GimmeeBeerSettings {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline = $false)]
        [ValidateScript({
            if (![system.uri]::IsWellFormedUriString($_,[System.UriKind]::Absolute)) {
                throw "GimmeeUrl is not a valid URL"
            } else { return $true }
        })]
        [string] $GimmeeUrl = $(throw "GimmeeUrl is mandatory, please provide a value."),

        [Parameter(ValueFromPipeline = $false)]
        [ValidateNotNullOrEmpty()]
        [string] $GimeeAppId = $(throw "GimeeAppId is mandatory, please provide a value."),

        [Parameter(ValueFromPipeline = $false)]
        [ValidateNotNullOrEmpty()]
        [string] $GimmeePw = $(throw "GimmeePw is mandatory, please provide a value."),

        [Parameter(ValueFromPipeline = $false)]
        [ValidateScript({
            if (![system.uri]::IsWellFormedUriString($_,[System.UriKind]::Absolute)) {
                throw "GimmeeUrl is not a valid URL"
            } else { return $true }
        })]
        [string] $BreweryDbUrl = $(throw "BreweryDbUrl is mandatory, please provide a value."),

        [Parameter(ValueFromPipeline = $false)]
        [ValidateNotNullOrEmpty()]
        [string] $BreweryDbApiKey = $(throw "BreweryDbApiKey is mandatory, please provide a value.")
    )
    $settings = [ordered]@{
        GimmeeUrl = $GimmeeUrl
        GimmeeAppId = $GimeeAppId
        GimmeePw = $GimmeePw
        BreweryDbUrl = $BreweryDbUrl
        BreweryDbApiKey = $BreweryDbApiKey
    }
    $settings | ConvertTo-Json | Set-Content -Path "$PSScriptRoot\$Script:settingsFile" -Force
}

function Get-GimmeeBeerSettings {
    [CmdletBinding()]
    param ()
    if(!(Test-Path "$PSScriptRoot\$Script:settingsFile")) {
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
        pw = $Script:GimmeePw
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

    # Invoke-RestMethod -Method Get -Uri

    $data = [ordered]@{
        CurrentPage = ''
        NumberOfPages = ''
        TotalResults = ''
        Beers = ''
        DataProvidedBy = ''
        TermsOfServiceUrl = ''
        DataPullDateTime = ''
        GimmeeVersion = ''
    }
    New-Object -TypeName psobject -Property $data
}

function Get-GimmeeBreweries {
    [CmdletBinding()]
    param (

    )
}

Export-ModuleMember -Function Get-GimmeeBeerSettings
Export-ModuleMember -Function Set-GimmeeBeerSettings
Export-ModuleMember -Function Get-GimmeeToken
Export-ModuleMember -Function Get-GimmeeBeers
Export-ModuleMember -Function Get-GimmeeBreweries
