<#
    .NOTES
    ===========================================================================
    Created with:     PowerShell Studio 2018 v4.1.74
    Created on:       14/03/2019 4:28 PM
    Created by:       Eng. Sergio Massip Alvarez 
    Filename: Test-TcpPort.ps1
    ===========================================================================
    .DESCRIPTION
     Script to check a Tcp Port.
#>

#Check port funcion                  
    function Test-TcpPort { 
      param(                     
        [Parameter (Mandatory)]
        [string] $hostName,
        [Parameter (Mandatory)]
        [int] $port
      )   
      # This works no matter in which form we get $host - hostname or ip address              
      try {  
        $ip = [System.Net.Dns]::GetHostAddresses($hostName) | select-object -expandproperty IPAddressToString 
        #If we have several ip's for that address, let's take first one 
        if ( $ip.GetType().Name -eq "Object[]" ) {                    
            $ip = $ip[0]                     
        }                 
        $socket = New-Object Net.Sockets.TcpClient  
        $socket.Connect( $ip, $port )
        if ( $socket.Connected ) {                     
          $object  = [pscustomobject]@{
            TestName = "Test-TcpPort:" + $hostName + ":" + $port  
            Result = $true     
          }          
        } else {            
          $object = [pscustomobject]@{
            TestName =  "Test-TcpPort:" + $hostName + ":" + $port 
            Result = $false 
          }              
        } 
        $socket.Close()
        Write-Output $object
      } catch {
        $ex = $_.Exception  
        $object = [pscustomobject]@{
          TestName = "Test-TcpPort:" + $hostName  + ":" + $port
          Result =  $false    
        } 
        Write-Output $object 
      }
    }   
    
    #Main script...
    $Error.Clear()  
    Set-StrictMode -Version Latest    
    $results = @()            
    Write-Host "Starting a Test-Connection..."   
    
    #Test Tcp Port
    $results += Test-TcpPort -hostName "127.0.0.1" -port 80
    $results += Test-TcpPort -hostName "www.sergiomassip.com" -port 80
    $results += Test-TcpPort -hostName "www.sergiomassip.com" -port 443
    
    #Print results
    $results | OGV -Title "Summary" 