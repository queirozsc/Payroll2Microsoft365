# Set all env variables from a file
& { Invoke-Expression (Get-Content -Raw .\Variables.env) }
