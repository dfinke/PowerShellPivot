Import-Module "$PSScriptRoot/../PowerShellPivot.psd1" -Force

Describe "Tests New PSPivotTable Null Measures" -Tag NewPSPivotTableNullMeasures {
    It 'Test' {
        $data = ConvertFrom-Csv @"
TimeStamp,Average,Minimum,Maximum,Total,Count
10/15/2021 12:00:00 AM,,,,0,
10/15/2021 12:00:00 AM,,,,0,
10/15/2021 12:00:00 AM,,,,0,
"@
        $data.Count | Should -Be 3

        $actual = psp -InputObject $data TimeStamp Total, Average

        $actual.Count | Should -Be 1

        $names = $actual[0].psobject.properties.name
        $names.Count | Should -Be 3

        $names[0] | Should -Be "TimeStamp"
        $names[1] | Should -Be "Average_Total"
        $names[2] | Should -Be "Average_Average"

        [double]::IsNaN($actual[0].'Average_Average') | Should -Be $true
        $actual[0].'Average_Total' | Should -Be 0
    }
}