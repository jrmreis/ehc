$Command = 'Get-Process | where {$_.cpu -gt 10}'
Invoke-Expression $Command
