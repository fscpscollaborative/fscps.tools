Describe "Get-FSCPSNuget Unit Tests" -Tag "Unit" {
	BeforeAll {
		# Place here all things needed to prepare for the tests
	}
	AfterAll {
		# Here is where all the cleanup tasks go
	}
	
	Describe "Ensuring unchanged command signature" {
		It "should have the expected parameter sets" {
			(Get-Command Get-FSCPSNuget).ParameterSets.Name | Should -Be 'Version', 'KnownVersion'
		}
		
		It 'Should have the expected parameter Version' {
			$parameter = (Get-Command Get-FSCPSNuget).Parameters['Version']
			$parameter.Name | Should -Be 'Version'
			$parameter.ParameterType.ToString() | Should -Be System.String
			$parameter.IsDynamic | Should -Be $False
			$parameter.ParameterSets.Keys | Should -Be 'Version'
			$parameter.ParameterSets.Keys | Should -Contain 'Version'
			$parameter.ParameterSets['Version'].IsMandatory | Should -Be $True
			$parameter.ParameterSets['Version'].Position | Should -Be -2147483648
			$parameter.ParameterSets['Version'].ValueFromPipeline | Should -Be $False
			$parameter.ParameterSets['Version'].ValueFromPipelineByPropertyName | Should -Be $False
			$parameter.ParameterSets['Version'].ValueFromRemainingArguments | Should -Be $False
		}
		It 'Should have the expected parameter KnownVersion' {
			$parameter = (Get-Command Get-FSCPSNuget).Parameters['KnownVersion']
			$parameter.Name | Should -Be 'KnownVersion'
			$parameter.ParameterType.ToString() | Should -Be System.String
			$parameter.IsDynamic | Should -Be $False
			$parameter.ParameterSets.Keys | Should -Be 'KnownVersion'
			$parameter.ParameterSets.Keys | Should -Contain 'KnownVersion'
			$parameter.ParameterSets['KnownVersion'].IsMandatory | Should -Be $True
			$parameter.ParameterSets['KnownVersion'].Position | Should -Be -2147483648
			$parameter.ParameterSets['KnownVersion'].ValueFromPipeline | Should -Be $False
			$parameter.ParameterSets['KnownVersion'].ValueFromPipelineByPropertyName | Should -Be $False
			$parameter.ParameterSets['KnownVersion'].ValueFromRemainingArguments | Should -Be $False
		}
		It 'Should have the expected parameter KnownType' {
			$parameter = (Get-Command Get-FSCPSNuget).Parameters['KnownType']
			$parameter.Name | Should -Be 'KnownType'
			$parameter.ParameterType.ToString() | Should -Be VersionStrategy
			$parameter.IsDynamic | Should -Be $False
			$parameter.ParameterSets.Keys | Should -Be 'KnownVersion'
			$parameter.ParameterSets.Keys | Should -Contain 'KnownVersion'
			$parameter.ParameterSets['KnownVersion'].IsMandatory | Should -Be $True
			$parameter.ParameterSets['KnownVersion'].Position | Should -Be -2147483648
			$parameter.ParameterSets['KnownVersion'].ValueFromPipeline | Should -Be $False
			$parameter.ParameterSets['KnownVersion'].ValueFromPipelineByPropertyName | Should -Be $False
			$parameter.ParameterSets['KnownVersion'].ValueFromRemainingArguments | Should -Be $False
		}
		It 'Should have the expected parameter Type' {
			$parameter = (Get-Command Get-FSCPSNuget).Parameters['Type']
			$parameter.Name | Should -Be 'Type'
			$parameter.ParameterType.ToString() | Should -Be NuGetType
			$parameter.IsDynamic | Should -Be $False
			$parameter.ParameterSets.Keys | Should -Be '__AllParameterSets'
			$parameter.ParameterSets.Keys | Should -Contain '__AllParameterSets'
			$parameter.ParameterSets['__AllParameterSets'].IsMandatory | Should -Be $True
			$parameter.ParameterSets['__AllParameterSets'].Position | Should -Be -2147483648
			$parameter.ParameterSets['__AllParameterSets'].ValueFromPipeline | Should -Be $False
			$parameter.ParameterSets['__AllParameterSets'].ValueFromPipelineByPropertyName | Should -Be $False
			$parameter.ParameterSets['__AllParameterSets'].ValueFromRemainingArguments | Should -Be $False
		}
		It 'Should have the expected parameter Path' {
			$parameter = (Get-Command Get-FSCPSNuget).Parameters['Path']
			$parameter.Name | Should -Be 'Path'
			$parameter.ParameterType.ToString() | Should -Be System.String
			$parameter.IsDynamic | Should -Be $False
			$parameter.ParameterSets.Keys | Should -Be '__AllParameterSets'
			$parameter.ParameterSets.Keys | Should -Contain '__AllParameterSets'
			$parameter.ParameterSets['__AllParameterSets'].IsMandatory | Should -Be $False
			$parameter.ParameterSets['__AllParameterSets'].Position | Should -Be -2147483648
			$parameter.ParameterSets['__AllParameterSets'].ValueFromPipeline | Should -Be $False
			$parameter.ParameterSets['__AllParameterSets'].ValueFromPipelineByPropertyName | Should -Be $False
			$parameter.ParameterSets['__AllParameterSets'].ValueFromRemainingArguments | Should -Be $False
		}
		It 'Should have the expected parameter Force' {
			$parameter = (Get-Command Get-FSCPSNuget).Parameters['Force']
			$parameter.Name | Should -Be 'Force'
			$parameter.ParameterType.ToString() | Should -Be System.Management.Automation.SwitchParameter
			$parameter.IsDynamic | Should -Be $False
			$parameter.ParameterSets.Keys | Should -Be '__AllParameterSets'
			$parameter.ParameterSets.Keys | Should -Contain '__AllParameterSets'
			$parameter.ParameterSets['__AllParameterSets'].IsMandatory | Should -Be $False
			$parameter.ParameterSets['__AllParameterSets'].Position | Should -Be -2147483648
			$parameter.ParameterSets['__AllParameterSets'].ValueFromPipeline | Should -Be $False
			$parameter.ParameterSets['__AllParameterSets'].ValueFromPipelineByPropertyName | Should -Be $False
			$parameter.ParameterSets['__AllParameterSets'].ValueFromRemainingArguments | Should -Be $False
		}
		It 'Should have the expected parameter ProgressAction' {
			$parameter = (Get-Command Get-FSCPSNuget).Parameters['ProgressAction']
			$parameter.Name | Should -Be 'ProgressAction'
			$parameter.ParameterType.ToString() | Should -Be System.Management.Automation.ActionPreference
			$parameter.IsDynamic | Should -Be $False
			$parameter.ParameterSets.Keys | Should -Be '__AllParameterSets'
			$parameter.ParameterSets.Keys | Should -Contain '__AllParameterSets'
			$parameter.ParameterSets['__AllParameterSets'].IsMandatory | Should -Be $False
			$parameter.ParameterSets['__AllParameterSets'].Position | Should -Be -2147483648
			$parameter.ParameterSets['__AllParameterSets'].ValueFromPipeline | Should -Be $False
			$parameter.ParameterSets['__AllParameterSets'].ValueFromPipelineByPropertyName | Should -Be $False
			$parameter.ParameterSets['__AllParameterSets'].ValueFromRemainingArguments | Should -Be $False
		}
	}
	
	Describe "Testing parameterset Version" {
		<#
		Version -Version -Type
		Version -Version -Type -Path -Force -ProgressAction
		#>
	}
 	Describe "Testing parameterset KnownVersion" {
		<#
		KnownVersion -KnownVersion -KnownType -Type
		KnownVersion -KnownVersion -KnownType -Type -Path -Force -ProgressAction
		#>
	}

}