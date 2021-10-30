Import-Module "$PSScriptRoot/../PowerShellPivot.psd1" -Force

Describe "Tests PSPivotTable Exclude Values" -Tag NewPSPivotTableExcludeValues {
    BeforeEach {
        $data = convertfrom-csv @"
Published,Year,Month,ViewCount
2019-01-17 15:21:59,2019,1,10
2019-01-03 13:34:22,2019,1,11
2018-12-11 16:46:06,2018,12,12
2018-11-15 16:59:10,2018,11,13
2020-02-05 03:28:26,2020,2,14
2020-02-08 04:56:31,2020,2,15
2020-10-11 14:00:02,2020,10,16
2020-11-30 16:00:09,2020,11,17
2021-04-21 13:00:14,2021,4,18
2021-04-20 13:26:55,2021,4,19
"@
    }

    It 'Test Excluding Values from measures' {
        $actual = New-PSPivotTable -InputObject $data Year -ExcludeValues year, Month

        $actual.Count | Should -Be 4
        
        $names = $actual[0].psobject.properties.name
        $names.Count | Should -Be 2

        $names[0] | Should -Be "Year"
        $names[1] | Should -Be "Average_ViewCount"
        
        $actual[0].Year | Should -Be 2018
        $actual[0].Average_ViewCount | Should -Be 12.5
    }

    It 'Test Excluding single values from measures' {
        $actual = New-PSPivotTable -InputObject $data Year -ExcludeValues month        

        $names = $actual[0].psobject.properties.name
        $names.Count | Should -Be 3
        $names[0] | Should -Be "Year"
        $names[1] | Should -Be "Average_Year"
        $names[2] | Should -Be "Average_ViewCount"
    }
}