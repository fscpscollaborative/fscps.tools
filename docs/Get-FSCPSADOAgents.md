---
external help file: fscps.tools-help.xml
Module Name: fscps.tools
online version:
schema: 2.0.0
---

# Get-FSCPSADOAgents

## SYNOPSIS
Retrieves agents from a specified agent pool in Azure DevOps.

## SYNTAX

```
Get-FSCPSADOAgents [[-AgentPoolId] <Int32>] [[-Organization] <String>] [[-apiVersion] <String>]
 [[-Token] <String>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The \`Get-FSCPSADOAgents\` function retrieves agents from a specified agent pool in Azure DevOps.
It requires the organization, agent pool ID, and a valid authentication token.
The function constructs
the appropriate URL, makes the REST API call, and returns detailed information about the agents,
including their capabilities and statuses.
It also handles errors and interruptions gracefully.

## EXAMPLES

### EXAMPLE 1
```
Get-FSCPSADOAgents -AgentPoolId 1 -Organization "my-org" -Token "Bearer my-token"
```

This example retrieves agents from the agent pool with ID 1 in the specified organization.

## PARAMETERS

### -AgentPoolId
The ID of the agent pool from which to retrieve agents.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Organization
The name of the Azure DevOps organization.
If not in the form of a URL, it will be prefixed with "https://dev.azure.com/".

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -apiVersion
The version of the Azure DevOps REST API to use.
Default is "7.0".

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: 7.0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Token
The authentication token for accessing Azure DevOps.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ProgressAction
{{ Fill ProgressAction Description }}

```yaml
Type: ActionPreference
Parameter Sets: (All)
Aliases: proga

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
- The function uses the Azure DevOps REST API to retrieve agent information.
- An authentication token is required.
- Handles errors and interruptions gracefully.

## RELATED LINKS
