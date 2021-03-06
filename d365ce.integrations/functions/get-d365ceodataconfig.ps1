﻿
<#
    .SYNOPSIS
        Get OData configs
        
    .DESCRIPTION
        Get all OData configuration objects from the configuration store
        
    .PARAMETER Name
        The name of the OData configuration you are looking for
        
        Default value is "*" to display all OData configs
        
    .PARAMETER OutputAsHashtable
        Instruct the cmdlet to return a hashtable object
        
    .PARAMETER EnableException
        This parameters disables user-friendly warnings and enables the throwing of exceptions
        This is less user friendly, but allows catching exceptions in calling scripts
        
    .EXAMPLE
        PS C:\> Get-D365CeODataConfig
        
        This will display all OData configurations on the machine.
        
    .EXAMPLE
        PS C:\> Get-D365CeODataConfig -OutputAsHashtable
        
        This will display all OData configurations on the machine.
        Every object will be output as a hashtable, for you to utilize as parameters for other cmdlets.
        
    .EXAMPLE
        PS C:\> Get-D365CeODataConfig -Name "UAT"
        
        This will display the OData configuration that is saved with the name "UAT" on the machine.
        
    .NOTES
        Tags: OData, Environment, Config, Configuration, ClientId, ClientSecret
        
        Author: Mötz Jensen (@Splaxi)
        
    .LINK
        Add-D365CeODataConfig
        
    .LINK
        Get-D365CeActiveODataConfig
        
    .LINK
        Set-D365CeActiveODataConfig
        
#>

function Get-D365CeODataConfig {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseOutputTypeCorrectly', '')]
    [CmdletBinding()]
    [OutputType('PSCustomObject')]
    param (
        [string] $Name = "*",

        [switch] $OutputAsHashtable,

        [switch] $EnableException
    )
    
    Write-PSFMessage -Level Verbose -Message "Fetch all configurations based on $Name" -Target $Name

    $Name = $Name.ToLower()
    $configurations = Get-PSFConfig -FullName "d365ce.integrations.odata.$Name.name"

    if($($configurations.count) -lt 1) {
        $messageString = "No configurations found <c='em'>with</c> the name."
        Write-PSFMessage -Level Host -Message $messageString
        Stop-PSFFunction -Message "Stopping because no configuration found." -Exception $([System.Exception]::new($($messageString -replace '<[^>]+>','')))
        return
    }

    foreach ($configName in $configurations.Value.ToLower()) {
        Write-PSFMessage -Level Verbose -Message "Working against the $configName configuration" -Target $configName
        $res = @{}

        $configName = $configName.ToLower()

        foreach ($config in Get-PSFConfig -FullName "d365ce.integrations.odata.$configName.*") {
            $propertyName = $config.FullName.ToString().Replace("d365ce.integrations.odata.$configName.", "")
            $res.$propertyName = $config.Value
        }
        
        if($OutputAsHashtable) {
            $res
        } else {
            [PSCustomObject]$res
        }
    }
}