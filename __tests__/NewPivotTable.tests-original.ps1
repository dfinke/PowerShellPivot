Import-Module "$PSScriptRoot/../PowerShellPivot.psd1" -Force

Describe "Tests New PSPivotTable Basics" -Tag NewPSPivotTable {

    BeforeEach {
        $data = ConvertFrom-Csv @"
Dimension1, Measure1
North, 1
North, 2
North, 3
South, 1
South, 2
South, 3
East, 1
East, 2
East, 3
West, 1
West, 2
West, 3
"@
    }

    It 'Test Sum on one index and value' {
        $actual = New-PSPivotTable $data -index Dimension1 -value Measure1 -aggregateFunction Sum

        <#
            Dimension1 Sum_Measure1
            ---------- ------------
            East                  6
            North                 6
            South                 6
            West                  6
        #>        

        $propertyNames = $actual[0].psobject.properties.name

        $propertyNames.Count | Should -Be 2
        $propertyNames[0] | Should -Be 'Dimension1'
        $propertyNames[1] | Should -Be 'Sum_Measure1'

        $actual.count | Should -Be 4
        $actual[0].Dimension1 | Should -Be 'East'
        $actual[0].Sum_Measure1 | Should -Be 6

        $actual[1].Dimension1 | Should -Be 'North'
        $actual[1].Sum_Measure1 | Should -Be 6

        $actual[2].Dimension1 | Should -Be 'South'
        $actual[2].Sum_Measure1 | Should -Be 6

        $actual[3].Dimension1 | Should -Be 'West'
        $actual[3].Sum_Measure1 | Should -Be 6
    }    

    It 'Test Max on one index and value' {
        $actual = New-PSPivotTable $data -index Dimension1 -value Measure1 -aggregateFunction Max
        $propertyNames = $actual[0].psobject.properties.name

        $propertyNames.Count | Should -Be 2
        $propertyNames[0] | Should -Be 'Dimension1'
        $propertyNames[1] | Should -Be 'Max_Measure1'

        $actual.count | Should -Be 4

        $actual[0].Dimension1 | Should -Be 'East'
        $actual[0].Max_Measure1 | Should -Be 3

        $actual[1].Dimension1 | Should -Be 'North'
        $actual[1].Max_Measure1 | Should -Be 3

        $actual[2].Dimension1 | Should -Be 'South'
        $actual[2].Max_Measure1 | Should -Be 3

        $actual[3].Dimension1 | Should -Be 'West'
        $actual[3].Max_Measure1 | Should -Be 3
    }

    It 'Test Min on one index and value' {
        $actual = New-PSPivotTable $data -index Dimension1 -value Measure1 -aggregateFunction Min
        $propertyNames = $actual[0].psobject.properties.name

        $propertyNames.Count | Should -Be 2
        $propertyNames[0] | Should -Be 'Dimension1'
        $propertyNames[1] | Should -Be 'Min_Measure1'

        $actual.count | Should -Be 4

        $actual[0].Dimension1 | Should -Be 'East'
        $actual[0].Min_Measure1 | Should -Be 1

        $actual[1].Dimension1 | Should -Be 'North'
        $actual[1].Min_Measure1 | Should -Be 1

        $actual[2].Dimension1 | Should -Be 'South'
        $actual[2].Min_Measure1 | Should -Be 1

        $actual[3].Dimension1 | Should -Be 'West'
        $actual[3].Min_Measure1 | Should -Be 1
    }
}

Describe "Tests New PSPivotTable Multiple Measures" -Tag NewPSPivotTable-Measures {
    BeforeEach {
        $data = ConvertFrom-Csv @"
Region, Units, Price
North, 1, 10
North, 2, 20
North, 3, 30
South, 1, 10
South, 2, 20
South, 3, 30
East, 1, 10
East, 2, 20
East, 3, 30
West, 1, 10
West, 2, 20
West, 3, 30
"@
    }
    
    It "Tests multiple values" {
        $actual = New-PSPivotTable $data -index Region -value Units, Price -aggregateFunction Sum

        $propertyNames = $actual[0].psobject.properties.name
        $propertyNames.Count | Should -Be 3
        $propertyNames[0] | Should -BeExactly 'Region'
        $propertyNames[1] | Should -BeExactly 'Sum_Units'
        $propertyNames[2] | Should -BeExactly 'Sum_Price'
        
        $actual.Count | Should -Be 4
 
        $actual[0].Region | Should -Be 'East'
        $actual[0].Sum_Units | Should -Be 6
        $actual[0].Sum_Price | Should -Be 60
       
        $actual[1].Region | Should -Be 'North'
        $actual[1].Sum_Units | Should -Be 6
        $actual[1].Sum_Price | Should -Be 60

        $actual[2].Region | Should -Be 'South'
        $actual[2].Sum_Units | Should -Be 6
        $actual[2].Sum_Price | Should -Be 60

        $actual[3].Region | Should -Be 'West'
        $actual[3].Sum_Units | Should -Be 6
        $actual[3].Sum_Price | Should -Be 60
    }

    It "Tests multiple values and aggregates" -Skip {
        $actual = New-PSPivotTable $data -index Region -value Units, Price -aggregateFunction Sum, Min, Max, Count
 
        $propertyNames = $actual[0].psobject.properties.name
        $propertyNames.Count | Should -Be 8

        $propertyNames[0] | Should -BeExactly 'Region'
        $propertyNames[1] | Should -BeExactly 'Sum_Units'
        $propertyNames[2] | Should -BeExactly 'Min_Units'
        $propertyNames[3] | Should -BeExactly 'Max_Units'
        $propertyNames[4] | Should -BeExactly 'Total_Count'
        $propertyNames[5] | Should -BeExactly 'Sum_Price'
        $propertyNames[6] | Should -BeExactly 'Min_Price'
        $propertyNames[7] | Should -BeExactly 'Max_Price'

        $actual.Count | Should -Be 4

        $actual[0].Region | Should -BeExactly 'East'
        $actual[0].Sum_Units | Should -Be 6
        $actual[0].Min_Units | Should -Be 1
        $actual[0].Max_Units | Should -Be 3
        $actual[0].Sum_Price | Should -Be 60
        $actual[0].Min_Price | Should -Be 10
        $actual[0].Max_Price | Should -Be 30
        $actual[0].Total_Count | Should -Be 3

        $actual[1].Region | Should -BeExactly 'North'
        $actual[1].Sum_Units | Should -Be 6
        $actual[1].Min_Units | Should -Be 1
        $actual[1].Max_Units | Should -Be 3
        $actual[1].Sum_Price | Should -Be 60
        $actual[1].Min_Price | Should -Be 10
        $actual[1].Max_Price | Should -Be 30
        $actual[1].Total_Count | Should -Be 3

        $actual[2].Region | Should -BeExactly 'South'
        $actual[2].Sum_Units | Should -Be 6
        $actual[2].Min_Units | Should -Be 1
        $actual[2].Max_Units | Should -Be 3
        $actual[2].Sum_Price | Should -Be 60
        $actual[2].Min_Price | Should -Be 10
        $actual[2].Max_Price | Should -Be 30
        $actual[2].Total_Count | Should -Be 3
 
        $actual[3].Region | Should -BeExactly 'West'
        $actual[3].Sum_Units | Should -Be 6
        $actual[3].Min_Units | Should -Be 1
        $actual[3].Max_Units | Should -Be 3
        $actual[3].Sum_Price | Should -Be 60
        $actual[3].Min_Price | Should -Be 10
        $actual[3].Max_Price | Should -Be 30
        $actual[3].Total_Count | Should -Be 3
    }
}