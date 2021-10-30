Import-Module "$PSScriptRoot/../PowerShellPivot.psd1" -Force

Describe "Tests New PSPivotTable Basics" -Tag NewPSPivotTable {

    BeforeEach {
        $script:data = Import-Csv $PSScriptRoot/SalesByEmployee.csv
    }

    It 'Test should return null if no data is passed in' {
        $actual = New-PSPivotTable 

        $actual | Should -BeNullOrEmpty
    }

    It 'Test should return null only data is passed in' {
        $actual = New-PSPivotTable -InputObject $data

        $actual | Should -BeNullOrEmpty
    }

    It 'Test average aggregation on a single index and value' {
        <#
        Date   Average_Revenue
        ----   ---------------
        1/1/20          4293.5
        1/2/20            7303
        1/3/20        4865.833
        1/4/20            3948
        1/5/20         4834.75
        #>
        
        $actual = New-PSPivotTable -InputObject $data -Index Date -values Revenue -aggregateFunction Average

        $names = $actual[0].psobject.properties.name
        $names.count | Should -Be 2
        $names[0] | Should -Be 'Date'
        $names[1] | Should -Be 'Average_Revenue'

        $actual[0].Date | Should -Be '1/1/20'
        $actual[0].Average_Revenue | Should -Be 4293.5
        $actual[1].Date | Should -Be '1/2/20'
        $actual[1].Average_Revenue | Should -Be 7303
        $actual[2].Date | Should -Be '1/3/20'
        $actual[2].Average_Revenue | Should -Be 4865.833
        $actual[3].Date | Should -Be '1/4/20'
        $actual[3].Average_Revenue | Should -Be 3948
        $actual[4].Date | Should -Be '1/5/20'
        $actual[4].Average_Revenue | Should -Be 4834.75
    }

    It 'Test std aggregation on a single index and value' {
        <#
        Date   STD_Revenue
        ----   -----------
        1/1/20  1725.87096
        1/2/20  1317.28691
        1/3/20   1389.8558
        1/4/20   2058.7605
        1/5/20  3040.90746
        #>
        $actual = New-PSPivotTable -InputObject $data -Index Date -values Revenue -aggregateFunction STD

        $actual.Count | Should -Be 5

        $names = $actual[0].psobject.properties.name
        $names.count | Should -Be 2
        $names[0] | Should -Be 'Date'
        $names[1] | Should -Be 'STD_Revenue'

        $actual[0].Date | Should -Be '1/1/20'
        $actual[0].STD_Revenue | Should -Be 1725.87096
        $actual[1].Date | Should -Be '1/2/20'
        $actual[1].STD_Revenue | Should -Be 1317.28691
        $actual[2].Date | Should -Be '1/3/20'
        $actual[2].STD_Revenue | Should -Be 1389.8558
        $actual[3].Date | Should -Be '1/4/20'
        $actual[3].STD_Revenue | Should -Be 2058.7605
        $actual[4].Date | Should -Be '1/5/20'                
    }

    It 'Test min aggregation on a single index and value' {
        <#
        Date   Min_Revenue
        ----   -----------
        1/1/20        1864
        1/2/20        5188
        1/3/20        2703
        1/4/20        2287
        1/5/20         938
        #>

        $actual = New-PSPivotTable -InputObject $data -Index Date -values Revenue -aggregateFunction Min

        $actual.Count | Should -Be 5
        
        $names = $actual[0].psobject.properties.name
        $names.count | Should -Be 2
        $names[0] | Should -Be 'Date'
        $names[1] | Should -Be 'Min_Revenue'

        $actual[0].Date | Should -Be '1/1/20'
        $actual[0].Min_Revenue | Should -Be 1864
        $actual[1].Date | Should -Be '1/2/20'
        $actual[1].Min_Revenue | Should -Be 5188
        $actual[2].Date | Should -Be '1/3/20'
        $actual[2].Min_Revenue | Should -Be 2703
        $actual[3].Date | Should -Be '1/4/20'
        $actual[3].Min_Revenue | Should -Be 2287
        $actual[4].Date | Should -Be '1/5/20'
        $actual[4].Min_Revenue | Should -Be 938
    }
    
    It 'Test max aggregation on a single index and value' {
        <#
        Date   Max_Revenue
        ----   -----------
        1/1/20        7172
        1/2/20        8661
        1/3/20        7075
        1/4/20        7917
        1/5/20        7837
        #>

        $actual = New-PSPivotTable -InputObject $data -Index Date -values Revenue -aggregateFunction Max

        $actual.Count | Should -Be 5

        $names = $actual[0].psobject.properties.name
        $names.count | Should -Be 2
        $names[0] | Should -Be 'Date'
        $names[1] | Should -Be 'Max_Revenue'

        $actual[0].Date | Should -Be '1/1/20'        
        $actual[0].Max_Revenue | Should -Be 7172
        $actual[1].Date | Should -Be '1/2/20'
        $actual[1].Max_Revenue | Should -Be 8661
        $actual[2].Date | Should -Be '1/3/20'
        $actual[2].Max_Revenue | Should -Be 7075
        $actual[3].Date | Should -Be '1/4/20'
        $actual[3].Max_Revenue | Should -Be 7917
        $actual[4].Date | Should -Be '1/5/20'
        $actual[4].Max_Revenue | Should -Be 7837
    }

    It 'Test count aggregation on a single index and value' {
        $actual = New-PSPivotTable -InputObject $data -Index Date -values Revenue -aggregateFunction Count

        $actual.Count | Should -Be 5

        $names = $actual[0].psobject.properties.name
        $names.count | Should -Be 2
        $names[0] | Should -Be 'Date'
        $names[1] | Should -Be 'Count_Revenue'

        $actual[0].Date | Should -Be '1/1/20'
        $actual[0].Count_Revenue | Should -Be 6
        $actual[1].Date | Should -Be '1/2/20'
        $actual[1].Count_Revenue | Should -Be 5
        $actual[2].Date | Should -Be '1/3/20'
        $actual[2].Count_Revenue | Should -Be 6
        $actual[3].Date | Should -Be '1/4/20'
        $actual[3].Count_Revenue | Should -Be 5
        $actual[4].Date | Should -Be '1/5/20'
        $actual[4].Count_Revenue | Should -Be 4        
    }

    It 'Test sum aggregation on a single index and value' {
        <#
            Date   Sum_Revenue
            ----   -----------
            1/1/20       25761
            1/2/20       36515
            1/3/20       29195
            1/4/20       19740
            1/5/20       19339
        #>
        
        $actual = New-PSPivotTable -InputObject $data -Index Date -values Revenue -aggregateFunction Sum

        $actual.Count | Should -Be 5
        
        $names = $actual[0].psobject.Properties.name
        $names.Count | Should -Be 2
        $names[0] | Should -BeExactly "Date"
        $names[1] | Should -BeExactly "Sum_Revenue"

        $actual[0].Date | Should -Be "1/1/20"
        $actual[0].Sum_Revenue | Should -Be 25761
        $actual[1].Date | Should -Be "1/2/20"
        $actual[1].Sum_Revenue | Should -Be 36515
        $actual[2].Date | Should -Be "1/3/20"
        $actual[2].Sum_Revenue | Should -Be 29195
        $actual[3].Date | Should -Be "1/4/20"
        $actual[3].Sum_Revenue | Should -Be 19740
        $actual[4].Date | Should -Be "1/5/20"
        $actual[4].Sum_Revenue | Should -Be 19339        
    }

    It 'Test average (default) aggregation on a single index' {
        <#
            date   Average_Revenue Average_Expenses
            ----   --------------- ----------------
            1/1/20          4293.5            637.5
            1/2/20            7303           1244.4
            1/3/20        4865.833         1313.667
            1/4/20            3948           1450.6
            1/5/20         4834.75          1196.25
        #>

        $actual = New-PSPivotTable -InputObject $data -Index Date

        $actual.Count | Should -Be 5
        $names = $actual[0].psobject.properties.name
        
        $names[0] | Should -Be 'Date'
        $names[1] | Should -Be 'Average_Revenue'
        $names[2] | Should -Be 'Average_Expenses'

        $actual[0].Date | Should -Be '1/1/20'
        $actual[0].Average_Revenue | Should -Be 4293.5
        $actual[0].Average_Expenses | Should -Be 637.5

        $actual[1].Date | Should -Be '1/2/20'
        $actual[1].Average_Revenue | Should -Be 7303
        $actual[1].Average_Expenses | Should -Be 1244.4
        
        $actual[2].Date | Should -Be '1/3/20'
        $actual[2].Average_Revenue | Should -Be 4865.833
        $actual[2].Average_Expenses | Should -Be 1313.667

        $actual[3].Date | Should -Be '1/4/20'
        $actual[3].Average_Revenue | Should -Be 3948
        $actual[3].Average_Expenses | Should -Be 1450.6

        $actual[4].Date | Should -Be '1/5/20'
        $actual[4].Average_Revenue | Should -Be 4834.75
        $actual[4].Average_Expenses | Should -Be 1196.25
    }

    It "Test year as index" {
        $data = convertfrom-csv @"
Published,Year,Views
2019-01-17 15:21:59,2019,1
2019-01-03 13:34:22,2019,1
2018-12-11 16:46:06,2018,12
2018-11-15 16:59:10,2018,11
2020-02-05 03:28:26,2020,2
2020-02-08 04:56:31,2020,2
2020-10-11 14:00:02,2020,10
2020-11-30 16:00:09,2020,11
2021-04-21 13:00:14,2021,4
2021-04-20 13:26:55,2021,4
"@ | ForEach-Object { $_.Year = [int]$_.Year; $_ }

        $actual = New-PSPivotTable -InputObject $data Year

        $actual.Count | Should -Be 4
        
        $names = $actual[0].psobject.properties.name
        $names.Count | Should -Be 3
        
        <#
            Year Average_Year Average_Views
            ---- ------------ -------------
            2018         2018          11.5
            2019         2019             1
            2020         2020          6.25
            2021         2021             4
        #>

        $names[0] | Should -Be 'Year'
        $names[1] | Should -Be 'Average_Year'
        $names[2] | Should -Be 'Average_Views'

        $actual[0].Year | Should -Be 2018
        $actual[0].Average_Year | Should -Be 2018
        $actual[0].Average_Views | Should -Be 11.5

        $actual[1].Year | Should -Be 2019
        $actual[1].Average_Year | Should -Be 2019
        $actual[1].Average_Views | Should -Be 1

        $actual[2].Year | Should -Be 2020
        $actual[2].Average_Year | Should -Be 2020
        $actual[2].Average_Views | Should -Be 6.25

        $actual[3].Year | Should -Be 2021
        $actual[3].Average_Year | Should -Be 2021
        $actual[3].Average_Views | Should -Be 4
    }


    It "Test piping data" {
        $data = convertfrom-csv @"
Date,Name,Customer,Revenue,Expenses
1/1/20,Oscar,Logistics XYZ,5250,531
1/1/20,Oscar,Money Corp.,4406,661
1/2/20,Oscar,PaperMaven,8661,1401
"@

        $actual = $data | New-PSPivotTable name
        $actual.Count | Should -Be 1

        <#
            name  Average_Revenue Average_Expenses
            ----  --------------- ----------------
            Oscar        6105.667          864.333        
        #>

        $names = $actual[0].psobject.properties.name
        $names.count | Should -Be 3
        $names[0] | Should -Be 'name'
        $names[1] | Should -Be 'Average_Revenue'
        $names[2] | Should -Be 'Average_Expenses'

        $actual[0].name | Should -Be 'Oscar'
        $actual[0].Average_Revenue | Should -Be 6105.667
        $actual[0].Average_Expenses | Should -Be 864.333
    }
}