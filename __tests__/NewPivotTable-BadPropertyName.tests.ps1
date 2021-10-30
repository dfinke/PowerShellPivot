Import-Module "$PSScriptRoot/../PowerShellPivot.psd1" -Force

Describe "Tests New PSPivotTable Bad Property Name" -Tag NewPSPivotTable-BadPropertyName {

    BeforeEach {
        $script:data = Import-Csv $PSScriptRoot/SalesByEmployee.csv
    }

    It 'Test should remove a property name if not found in original data' {
        <#
        date  
        ----  
        1/1/20
        1/2/20
        1/3/20
        1/4/20
        1/5/20
        #>

        $actual = New-PSPivotTable -InputObject $data date BadPropertyName
        
        $actual.Count | Should -Be 5
        
        $propertyNames = $actual[0].psobject.Properties.name

        $propertyNames.Count | Should -Be 1

        $actual[0].date | Should -Be 1/1/20
        $actual[1].date | Should -Be 1/2/20
        $actual[2].date | Should -Be 1/3/20
        $actual[3].date | Should -Be 1/4/20
        $actual[4].date | Should -Be 1/5/20
    }

    It 'Test combo of found and not found property names' {
        <#
            date   Average_Revenue
            ----   ---------------
            1/1/20          4293.5
            1/2/20            7303
            1/3/20        4865.833
            1/4/20            3948
            1/5/20         4834.75
        #>

        $actual = New-PSPivotTable -InputObject $data date BadPropertyName, Revenue
        $actual.Count | Should -Be 5
        
        $propertyNames = $actual[0].psobject.Properties.name
        $propertyNames.Count | Should -Be 2

        $actual[0].date | Should -Be 1/1/20
        $actual[0].Average_Revenue | Should -Be 4293.5
        
        $actual[1].date | Should -Be 1/2/20
        $actual[1].Average_Revenue | Should -Be 7303
        
        $actual[2].date | Should -Be 1/3/20
        $actual[2].Average_Revenue | Should -Be 4865.833
        
        $actual[3].date | Should -Be 1/4/20
        $actual[3].Average_Revenue | Should -Be 3948
        
        $actual[4].date | Should -Be 1/5/20
        $actual[4].Average_Revenue | Should -Be 4834.75
    }

    It 'Test combo of found and not found property names bad name in the middle' {
        <#
        date   Average_Expenses Average_Revenue
        ----   ---------------- ---------------
        1/1/20            637.5          4293.5
        1/2/20           1244.4            7303
        1/3/20         1313.667        4865.833
        1/4/20           1450.6            3948
        1/5/20          1196.25         4834.75
        #>

        $actual = New-PSPivotTable -InputObject $data date Expenses, BadPropertyName, Revenue

        $actual.Count | Should -Be 5
        $names = $actual[0].psobject.properties.name 
        $names.Count | Should -Be 3

        $actual[0].date | Should -Be 1/1/20
        $actual[0].Average_Expenses | Should -Be 637.5
        $actual[0].Average_Revenue | Should -Be 4293.5

        $actual[1].date | Should -Be 1/2/20
        $actual[1].Average_Expenses | Should -Be 1244.4
        $actual[1].Average_Revenue | Should -Be 7303

        $actual[2].date | Should -Be 1/3/20
        $actual[2].Average_Expenses | Should -Be 1313.667
        $actual[2].Average_Revenue | Should -Be 4865.833

        $actual[3].date | Should -Be 1/4/20
        $actual[3].Average_Expenses | Should -Be 1450.6
        $actual[3].Average_Revenue | Should -Be 3948

        $actual[4].date | Should -Be 1/5/20
        $actual[4].Average_Expenses | Should -Be 1196.25
        $actual[4].Average_Revenue | Should -Be 4834.75
    }
}