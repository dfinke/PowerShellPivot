Import-Module "$PSScriptRoot\..\PowerShellPivot.psd1" -Force

$url = 'https://gist.githubusercontent.com/alexdebrie/b3f40efc3dd7664df5a20f5eee85e854/raw/ee3e6feccba2464cbbc2e185fb17961c53d2a7f5/stocks.csv'
$data = ConvertFrom-Csv (Invoke-RestMethod $url)

$table = New-PSPivotTable -InputObject $data -index symbol -ExcludeValues open, high, low

$table | Format-Table