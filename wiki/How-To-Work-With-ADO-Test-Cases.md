This tutorial will show you how to work with Azure DevOps (ADO) test cases and test suites using fscps.tools.

## **Prerequisites**
* PowerShell 5.1
* fscps.tools module installed
* Access to an Azure DevOps project with Test Plans
* A valid Azure DevOps Personal Access Token (PAT) with test management permissions

Please visit the [Install as a Administrator](https://github.com/fscpscollaborative/fscps.tools/wiki/Tutorial-Install-Administrator) or the [Install as a non-Administrator](https://github.com/fscpscollaborative/fscps.tools/wiki/Tutorial-Install-Non-Administrator) tutorials to learn how to install the tools.

## **Import module**

```
Import-Module -Name fscps.tools
```

## **Prepare authentication**

All ADO cmdlets require a `-Token` parameter. Use a Bearer token with your PAT:

```
$pat = "your-personal-access-token"
$token = "Bearer " + [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(":$pat"))
$organization = "my-org"
$project = "my-project"
```

## **Available cmdlets**

| Cmdlet | Description |
| :-- | :-- |
| `Get-FSCPSADOTestCase` | Get details of a specific test case by ID |
| `Get-FSCPSADOTestSuitesByTestPlan` | List all test suites in a test plan |
| `Get-FSCPSADOTestCasesBySuite` | List all test cases in a test suite |
| `Get-FSCPSADOTestSuiteByTestCase` | Find which test suite a test case belongs to |

## **Get test case details**

Retrieve detailed information about a specific test case:

```
Get-FSCPSADOTestCase `
    -TestCaseId 1234 `
    -Project $project `
    -Organization $organization `
    -Token $token
```

## **List test suites in a test plan**

Get all test suites from a specific test plan:

```
$suites = Get-FSCPSADOTestSuitesByTestPlan `
    -Organization $organization `
    -Project $project `
    -TestPlanId 100 `
    -Token $token

$suites | ForEach-Object {
    Write-Host "Suite: $($_.name) (ID: $($_.id))"
}
```

## **List test cases in a test suite**

Get all test cases from a specific test suite within a test plan:

```
$testCases = Get-FSCPSADOTestCasesBySuite `
    -TestSuiteId 1001 `
    -TestPlanId 100 `
    -Organization $organization `
    -Project $project `
    -Token $token

$testCases | ForEach-Object {
    Write-Host "Test Case: $($_.testCase.name) (ID: $($_.testCase.id))"
}
```

## **Find test suite by test case**

Find which test suite a specific test case belongs to:

```
Get-FSCPSADOTestSuiteByTestCase `
    -TestCaseId 1234 `
    -Project $project `
    -Organization $organization `
    -Token $token
```

## **Example: Export all test cases from a test plan**

A practical example that lists all test cases across all suites in a test plan:

```
$testPlanId = 100

# Get all suites in the test plan
$suites = Get-FSCPSADOTestSuitesByTestPlan `
    -Organization $organization `
    -Project $project `
    -TestPlanId $testPlanId `
    -Token $token

foreach ($suite in $suites) {
    Write-Host "=== Suite: $($suite.name) (ID: $($suite.id)) ==="
    
    $testCases = Get-FSCPSADOTestCasesBySuite `
        -TestSuiteId $suite.id `
        -TestPlanId $testPlanId `
        -Organization $organization `
        -Project $project `
        -Token $token
    
    foreach ($tc in $testCases) {
        Write-Host "  - $($tc.testCase.name) (ID: $($tc.testCase.id))"
    }
}
```

## **Closing comments**
In this tutorial we showed you how to use the ADO test management cmdlets:
- **Get-FSCPSADOTestCase** — get details of a test case
- **Get-FSCPSADOTestSuitesByTestPlan** — list suites in a test plan
- **Get-FSCPSADOTestCasesBySuite** — list test cases in a suite
- **Get-FSCPSADOTestSuiteByTestCase** — find which suite a test case belongs to

These cmdlets are useful for test management automation, reporting, and integration with CI/CD pipelines.
