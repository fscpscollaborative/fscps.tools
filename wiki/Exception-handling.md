You may have noticed that the fscps.tools cmdlets rarely throw exceptions. In fact, most cmdlets are written in such a way that exceptions are caught and a warning message is displayed instead.

While this is the preferred approach when using the fscps.tools in an interactive way (i.e. a users enters commands one by one in a PowerShell console), it can cause issues in other situations.

If for example you want to write a script that call severals cmdlets, the script should probably stop when one call runs into an issue. But instead, the script just shows a warning and continues executing the other calls.

# How to stop execution of the cmdlets in case of a warning?

The simplest way to change the default behavior is to tell PowerShell that it should stop executing in case of a warning. This can be done by setting the value of a preference variable:
```
$WarningPreference="Stop"
```

This will change the behavior of all PowerShell commands that are executed after this variable has been set for the remainder of the PowerShell session.

If you want to restore the default behavior, run the following command or start a new PowerShell session:
```
$WarningPreference="Continue"
```

To learn more about preference variables, run the following command or visit [about_Preference_Variables](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_preference_variables).
```
Get-Help About_Preference_Variables
```

# How to throw exceptions?

While stopping in case of warnings will cover many situations, sometimes you might prefer getting a real exception so you can implement your own exception handling. 

To cover those situations, the fscps.tools provide a cmdlet to activate exceptions: `Enable-FSCPSException`

By calling this cmdlet at the start of a PowerShell session (or at the beginning of a script), subsequent calls to other cmdlets of the module will throw an exception in case of an issue.

However, note that only cmdlets with the `-EnableException` parameter support this type of exception handling.

To disable throwing exceptions, call the `Disable-FSCPSException` cmdlet.

## What does the -EnableException parameter do?

You may have noticed that some cmdlets provide a `-EnableException` switch parameter that does not seem to change how the cmdlet behaves. This is because this parameter only works in combination with the `Enable-FSCPSException` cmdlet. 

You would not add this parameter explicitely to your commands. Rather, you call the `Enable-FSCPSException` cmdlet first and then other cmdlet calls will use the `-EnableException` parameter behind the scenes to throw an exception.

## Can this be changed?

If you want to contribute to that, we encourage you to create an [issue](https://github.com/fscpscollaborative/fscps.tools/issues) or [discussion](https://github.com/fscpscollaborative/fscps.tools/discussions) or submit a pull request.