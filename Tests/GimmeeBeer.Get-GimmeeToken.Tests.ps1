#Requires -Modules Pester

$Script:module = 'GimmeeBeer'
$Script:function = 'Get-GimmeeToken'

Import-Module ..\$Script:module.psm1 -Force

Describe 'GimmeeBeer Get-GimmeeToken Tests' {
    BeforeEach {
        Mock -CommandName Invoke-RestMethod -ModuleName $Script:module -MockWith {
            return @{
                access_token = "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImtpZCI6Ik1UVTVPRFUzUVVNelJVTkNNRGRETURkQk5rWkRRMEk0UlRRM1JEVTRNalZDUlRBek1VSTFOQSJ9.eyJpc3MiOiJodHRwczovL2dpbW1lZS5hdXRoMC5jb20vIiwic3ViIjoiazN0aFRJd3ZDTHlwVkxFSUVRM2E3blQ5VUdzdlRWRFlAY2xpZW50cyIsImF1ZCI6Imh0dHBzOi8vYXBpLmdpbW1lZS5pbyIsImlhdCI6MTU0NTMxMzk1MiwiZXhwIjoxNTQ1MzE3NTUyLCJhenAiOiJrM3RoVEl3dkNMeXBWTEVJRVEzYTduVDlVR3N2VFZEWSIsInNjb3BlIjoiZ2V0OkJlZXIuQnJld2VyaWVzIGdldDpCZWVyLkluZm8iLCJndHkiOiJjbGllbnQtY3JlZGVudGlhbHMifQ.tvFH70Uvee4OZM7vhdW6_L_5M0gsD_pmopSoScNq72GnlnwnXHXxruNNXhGGddFTPaI6MZ5C2ZOsrph22-1aG-VTmx3ZLqXec8KTFCosO3BQbdGIBuSMHBM5EUMT8-rvwlKDkczIdUn1SRAGN4y2PeCGSYNvnkO4V_hVFjsCwJknwMOjyNai_lGuGWBzDBK1fO7dBFj5ShmQa7AqrZZBIfzKhyrSWX9rdaUm1Oc76wKGhcxAag-jDvXXiF_UbtNSDn29hP7QuHVFy3FFTjLLmYpSeL_c-0dS0HEA_R3rO0cOcieTHe8KmqTGT_QOdhv_gIYf7lhtjApdxQSxKIFQeg"
            }
        }
    }

    It "[$Script:module] $Script:function should return a valid JWT token" {
        $token = Get-GimmeeToken
        $token.Length | Should BeGreaterThan 0
        $token | Should Match '^ey[a-zA-Z0-9\-_]+\.[a-zA-Z0-9\-_]+\.[a-zA-Z0-9\-_]+$'
        Assert-MockCalled Invoke-RestMethod -ModuleName $Script:module -Times 1
    }
}