Import-Module "$PSScriptRoot/../PowerShellPivot.psd1" -Force

Describe "Tests New PSPivotTable Multiple Dimensions" -Tag NewPSPivotTable-MultipleDimensions {

    It 'Test Sum on a multiple index and one value' -Skip {

        $data = ConvertFrom-Csv @"
Region,State,Units,Price
West,Texas,927,923.71
North,Tennessee,466,770.67
East,Florida,520,458.68
East,Maine,828,661.24
West,Virginia,465,053.58
North,Missouri,436,235.67
South,Kansas,214,992.47
South,Delaware,712,508.55
"@
        
        $actual = New-PSPivotTable $data -index Region, State -Values Units -aggregateFunction Sum

        $actual.Count | Should -Be 4

        $actual.GetType().Name | Should -BeExactly "OrderedDictionary"
        $actual.Keys.Count | Should -Be 4
        $keys = @($actual.Keys)
        
        $keys[0] | Should -BeExactly "West"
        $keys[1] | Should -BeExactly "North"
        $keys[2] | Should -BeExactly "East"
        $keys[3] | Should -BeExactly "South"

        $actual.West.Keys.Count  | Should -Be 2
        $actual.North.Keys.Count | Should -Be 2
        $actual.East.Keys.Count  | Should -Be 2
        $actual.South.Keys.Count | Should -Be 2
 
        $actual.West.Keys  | Should -BeExactly 'Texas', 'Virginia'
        $actual.North.Keys | Should -BeExactly 'Tennessee', 'Missouri'
        $actual.East.Keys  | Should -BeExactly 'Florida', 'Maine'
        $actual.South.Keys | Should -BeExactly 'Kansas', 'Delaware'

        $actual.West.Texas.Sum_Units  | Should -Be 927
        $actual.West.Virginia.Sum_Units  | Should -Be 465

        $actual.North.Tennessee.Sum_Units  | Should -Be 466
        $actual.North.Missouri.Sum_Units  | Should -Be 436

        $actual.East.Florida.Sum_Units  | Should -Be 520
        $actual.East.Maine.Sum_Units  | Should -Be 828

        $actual.South.Kansas.Sum_Units  | Should -Be 214
        $actual.South.Delaware.Sum_Units  | Should -Be 712
    } 

    It 'Test Sum on a multiple index and one value' -Skip {
        $data = ConvertFrom-Csv @"
Region,State,Units,Price
West,Texas,200,100
West,Texas,300,200
"@
        $actual = New-PSPivotTable $data -index Region, State -Values Units, Price -aggregateFunction Sum

        $actual.Count | Should -Be 1
        $actual.West.Texas.Sum_Units | Should -Be 500
        $actual.West.Texas.Sum_Price | Should -Be 300
    }
}