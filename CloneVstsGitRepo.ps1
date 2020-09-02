
#$file = "C:\Users\Sergio\Desktop\script\repovy.json"
#$json = Get-Content -Raw -Path $file | ConvertFrom-Json

<#
    .NOTES
    ===========================================================================
    Created with:     PowerShell Studio 2020
    Created on:       14/03/2020 4:28 PM
    Created by:       Eng. Sergio Massip Alvarez 
    Filename: CloneVstsGitRepos.ps1
    ===========================================================================
    .DESCRIPTION
     Script to clone all repos from VSTS .
#>
Remove-Variable * -ErrorAction SilentlyContinue;
Remove-Module *;
$Error.Clear()
Set-StrictMode -Version Latest

$MyPat = 'yourPAt'
$B64Pat = [Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes(":$MyPat"))
$url = "https://yourcompany.visualstudio.com"
$headers = @{
    "Authorization" = ("Basic {0}" -f $B64Pat)
    "Accept" = "application/json"
}

$resp = Invoke-WebRequest -Headers $headers -Uri ("{0}/_apis/git/repositories?api-version=6.0" -f $url)
$json = convertFrom-JSON $resp.Content

# Clone or pull all repositories
foreach ($entry in $json.value) {
     
    Write-Host 'cloning ... '$entry.remoteUrl -ForegroundColor Green  
    $directory ="S:\VY\" + $entry.project.name + '\'+$entry.name
   
    if (Test-Path $directory) {
        Write-Information "repo $entry.remoteUrl already exists" 
        Write-Information "Executting: git -c http.extraHeader="Authorization: Basic $B64Pat" pull $entry.remoteUrl $directory" 
        git -c http.extraHeader="Authorization: Basic $B64Pat" pull $entry.remoteUrl $directory
    } else {
        Write-Information "git -c http.extraHeader="Authorization: Basic $B64Pat" clone $entry.remoteUrl $directory"
        git -c http.extraHeader="Authorization: Basic $B64Pat" clone $entry.remoteUrl $directory
    }  
}
