
<#
    .SYNOPSIS
        This will import D365FSC base assemblies
        
    .DESCRIPTION
        This will import D365FSC base assemblies. For package generating process
        
    .PARAMETER binDir
        XppTools directory path
        
    .EXAMPLE
        PS C:\> Invoke-FSCAssembliesImport -DefaultRoot "C:\temp\buildbuild\packages\Microsoft.Dynamics.AX.Platform.DevALM.BuildXpp.7.0.7120.99\ref\net40"
        
    .NOTES
        General notes
        Author: Oleksandr Nikolaiev (@onikolaiev)
#>
function Invoke-FSCAssembliesImport([string]$binDir)
{
    Write-PSFMessage -Level Verbose -Message "Importing metadata assemblies"

    # Need load metadata.dll and any referenced ones, not flexible to pick the new added references
    $m_core = Join-Path $binDir Microsoft.Dynamics.AX.Metadata.Core.dll
    $m_metadata = Join-Path $binDir Microsoft.Dynamics.AX.Metadata.dll
    $m_storage = Join-Path $binDir Microsoft.Dynamics.AX.Metadata.Storage.dll
    $m_xppinstrumentation = Join-Path $binDir Microsoft.Dynamics.ApplicationPlatform.XppServices.Instrumentation.dll
    $m_management_core = Join-Path $binDir Microsoft.Dynamics.AX.Metadata.Management.Core.dll
    $m_management_delta = Join-Path $binDir Microsoft.Dynamics.AX.Metadata.Management.Delta.dll
    $m_management_diff = Join-Path $binDir Microsoft.Dynamics.AX.Metadata.Management.Diff.dll
    $m_management_merge = Join-Path $binDir Microsoft.Dynamics.AX.Metadata.Management.Merge.dll

    # Load required dlls, loading should fail the script run with exceptions thrown
    [Reflection.Assembly]::LoadFile($m_core) > $null
    [Reflection.Assembly]::LoadFile($m_metadata) > $null
    [Reflection.Assembly]::LoadFile($m_storage) > $null
    [Reflection.Assembly]::LoadFile($m_xppinstrumentation) > $null
    [Reflection.Assembly]::LoadFile($m_management_core) > $null
    [Reflection.Assembly]::LoadFile($m_management_delta) > $null
    [Reflection.Assembly]::LoadFile($m_management_diff) > $null
    [Reflection.Assembly]::LoadFile($m_management_merge) > $null
}