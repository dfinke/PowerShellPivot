param(
    $index = 'date',
    $column = 'city'
)

Import-Module "$PSScriptRoot/../PowerShellPivot.psd1" -Force

$data = Import-Csv "$PSScriptRoot/TempAndHumidity.csv"

$data | psp -index $index -column $column