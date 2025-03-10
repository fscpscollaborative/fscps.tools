
<#
    .SYNOPSIS
        Get all parameter values of a function call
        
        
    .DESCRIPTION
        Get the actual values of parameters which have manually set (non-null) default values or values passed in the call
        Unlike $PSBoundParameters, the hashtable returned from Get-ParameterValue includes non-empty default parameter values.
        NOTE: Default values that are the same as the implied values are ignored (e.g.: empty strings, zero numbers, nulls).
        
    .EXAMPLE
        PS C:\> Get-ParameterValue
        
        This will return a hashtable of all parameters and their values that have been set in the current scope.
        Normally, you would never call this function directly, but rather use it within another function.
        This example is mainly here to satisfy the generic Pester tests. See the next example for a more practical use.
        
    .EXAMPLE
        function Test-Parameters {
        [CmdletBinding()]
        param(
        $Name = $Env:UserName,
        $Age
        )
        $Parameters = Get-ParameterValue
        # This WILL ALWAYS have a value...
        Write-Host $Parameters["Name"]
        # But this will NOT always have a value...
        Write-Host $PSBoundParameters["Name"]
        }
        
    .NOTES
        This is based on the following gist: https://gist.github.com/elovelan/d697882b99d24f1b637c7e7a97f721f2
        
        Original Author: Eric Loveland (@elovelan)
        Author: Florian Hopfner (@FH-Inway)
        
#>
function Get-ParameterValue {
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param()

    # The $MyInvocation for the caller
    $Invocation = Get-Variable -Scope 1 -Name MyInvocation -ValueOnly
    # The $PSBoundParameters for the caller
    $BoundParameters = Get-Variable -Scope 1 -Name PSBoundParameters -ValueOnly

    $ParameterValues = @{}
    foreach ($parameter in $Invocation.MyCommand.Parameters.GetEnumerator()) {
        $key = $parameter.Key
        $value = Get-Variable -Name $key -ValueOnly -ErrorAction Ignore

        $valueNotNull = $null -ne $value
        $valueNotTypedNull = ($null -as $parameter.Value.ParameterType) -ne $value

        if ($valueNotNull -and $valueNotTypedNull) {
            $ParameterValues[$key] = $value
        }

        if ($BoundParameters.ContainsKey($key)) {
            $ParameterValues[$key] = $BoundParameters[$key]
        }
    }
    $ParameterValues
}