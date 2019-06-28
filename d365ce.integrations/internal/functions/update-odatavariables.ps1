﻿
<#
    .SYNOPSIS
        Update the broadcast message config variables
        
    .DESCRIPTION
        Update the active broadcast message config variables that the module will use as default values
        
    .EXAMPLE
        PS C:\> Update-BroadcastVariables
        
        This will update the broadcast variables.
        
    .NOTES
        Author: Mötz Jensen (@Splaxi)
#>

function Update-ODataVariables {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "")]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseSingularNouns", "")]
    [CmdletBinding()]
    [OutputType()]
    param ( )
    
    $configName = (Get-PSFConfig -FullName "d365ce.integrations.active.odata.config.name").Value

    if (([string]::IsNullOrEmpty($configName))) {
        return
    }

    $configName = $configName.ToString().ToLower()
    
    if (-not ($configName -eq "")) {
        $configHash = Get-D365ActiveODataConfig -OutputAsHashtable
        foreach ($item in $configHash.Keys) {
            if ($item -eq "name") { continue }
            
            $name = "OData" + (Get-Culture).TextInfo.ToTitleCase($item)
        
            Write-PSFMessage -Level Verbose -Message "$name - $($configHash[$item])" -Target $configHash[$item]
            Set-Variable -Name $name -Value $configHash[$item] -Scope Script
        }
    }
}