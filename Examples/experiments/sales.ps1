Import-Module $PSScriptRoot\..\..\PowerShellPivot.psd1 -force

#import-csv sales.csv | Format-Table
import-csv sales.csv | Get-Subtotal region