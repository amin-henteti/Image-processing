echo "{" | Out-File .\Desktop\config.json
echo ('"'+$a+'",') | Out-File -Append .\Desktop\config.json
echo "{" | Out-File .\Desktop\config.json
echo ('"key1" : "'+$a+'",') | Out-File -Append .\Desktop\config.json
echo ('"key2" : "'+$b+'"') | Out-File -Append .\Desktop\config.json
echo "}" | Out-File -append .\Desktop\config.json
get-content -raw -path .\Desktop\config.json | ConvertFrom-Json

key1                                                        key2
----                                                        ----
prop                                                        par

$x = get-content -raw -path .\Desktop\config.json | ConvertFrom-Json
$x.key1
$x.key2
