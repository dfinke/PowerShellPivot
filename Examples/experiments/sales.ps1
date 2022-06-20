Import-Module $PSScriptRoot\..\..\PowerShellPivot.psd1 -force

#import-csv sales.csv | Format-Table
#Import-Csv $PSScriptRoot\sales.csv | Get-Subtotal 
#import-csv $PSScriptRoot\sales.csv | ConvertTo-CrossTab
# Import-Csv $PSScriptRoot\sales.csv | ConvertTo-CrossTab Region $null -ValueName Sales
Import-Csv $PSScriptRoot\sales.csv | New-PSPivotTable #Region -PrettyPrint