﻿
<#
    .SYNOPSIS
        Get the active OData configuration
        
    .DESCRIPTION
        Get the active OData configuration from the configuration store
        
    .PARAMETER OutputAsHashtable
        Instruct the cmdlet to return a hashtable object
        
    .PARAMETER EnableException
        This parameters disables user-friendly warnings and enables the throwing of exceptions
        This is less user friendly, but allows catching exceptions in calling scripts
        
    .EXAMPLE
        PS C:\> Get-D365CeActiveODataConfig
        
        This will get the active OData configuration.
        
    .NOTES
        Tags: OData, Environment, Config, Configuration, ClientId, ClientSecret
        
        Author: Mötz Jensen (@Splaxi)
        
    .LINK
        Add-D365CeODataConfig
        
    .LINK
        Get-D365CeODataConfig
        
    .LINK
        Set-D365CeActiveODataConfig
#>

function Get-D365CeActiveODataConfig {
    [CmdletBinding()]
    [OutputType()]
    param (
        [switch] $OutputAsHashtable,

        [switch] $EnableException
    )

    $configName = (Get-PSFConfig -FullName "d365ce.integrations.active.odata.config.name").Value

    if ($configName -eq "") {
        $messageString = "It looks like there <c='em'>isn't configured</c> an active OData configuration."
        Write-PSFMessage -Level Host -Message $messageString
        Stop-PSFFunction -Message "Stopping because an active OData configuration wasn't found." -Exception $([System.Exception]::new($($messageString -replace '<[^>]+>','')))
        return
    }

    Get-D365CeODataConfig -Name $configName -OutputAsHashtable:$OutputAsHashtable
}