Import-Module $PSScriptRoot\..\PSPivotTable.psd1 -Force

$data = import-csv $PSScriptRoot\SalesByEmployee.csv 
New-PSPivotTable -InputObject $data date -agg AllStats | Format-Table *