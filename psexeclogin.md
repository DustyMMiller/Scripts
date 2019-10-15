This will use PSExec (https://docs.microsoft.com/en-us/sysinternals/downloads/psexec) to query each computer that has checked into AD in the past 60 days and will report all successful or failed logins a specific username has on each computer.

Make sure you have permission to run this as PSExec is a very noisy tool in the security world.

Change ((Data='Administrator')) to whatever the username you are looking for is, or if there are multiple format as below:

((Data='Administrator') or (Data='Admin'))
