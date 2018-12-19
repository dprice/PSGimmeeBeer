#Requires -Modules Pester

Import-Module ..\GimmeeBeer.psm1 -Force

$module = 'GimmeeBeer'
$function = 'Get-GimmeeToken'

Describe 'GimmeeBeer Get-GimmeeToken Tests' {
    It "$function should return a token" {
        $token = Get-GimmeeToken
        $token.Length | Should BeGreaterThan 0
    }

    It "$function should return a valid JWT token" {
        $token = Get-GimmeeToken
        $token.Length | Should BeGreaterThan 0
        $token | Should Match '^ey[a-zA-Z0-9\-_]+\.[a-zA-Z0-9\-_]+\.[a-zA-Z0-9\-_]+$'
    }
}