Import-Module "$PSScriptRoot/../PowerShellPivot.psd1" -Force

Describe "Tests Convert To CorssTab" -Tag ConvertToCrossTab {
    BeforeAll {
        $script:data = ConvertFrom-Csv @'
Environment,Service,IP
Dev,Apple,10.1.2.11
Test,Apple,10.2.3.11
Prod,Apple,10.3.4.11
Dev,Orange,10.1.2.21
Test,Orange,10.2.3.21
Prod,Orange,10.3.4.21
Dev,Banana,10.1.2.22
Test,Banana,10.2.3.22
Prod,Banana,10.3.4.22
'@
    }
    
    It 'Should calculate crosstab' {
        $actual = $data | ConvertTo-CrossTab -ColumnName Environment -RowName Service -ValueName Ip -SuffixColumn " environment"

        $actual.Count  | Should -Be 3

        $actual[0].Service | Should -BeExactly "Apple"
        $actual[0].'Dev Environment' | Should -BeExactly "10.1.2.11"
        $actual[0].'Prod Environment' | Should -BeExactly "10.3.4.11"
        $actual[0].'Test Environment' | Should -BeExactly "10.2.3.11"

        $actual[1].Service | Should -BeExactly "Banana"
        $actual[1].'Dev Environment' | Should -BeExactly "10.1.2.22"
        $actual[1].'Prod Environment' | Should -BeExactly "10.3.4.22"
        $actual[1].'Test Environment' | Should -BeExactly "10.2.3.22"

        $actual[2].Service | Should -BeExactly "Orange"
        $actual[2].'Dev Environment' | Should -BeExactly "10.1.2.21"
        $actual[2].'Prod Environment' | Should -BeExactly "10.3.4.21"
        $actual[2].'Test Environment' | Should -BeExactly "10.2.3.21"        
    }

    It 'Should calculate crosstab for sales' {
        $data = ConvertFrom-Csv @"
        Region,State,Units,Price
        West,Texas,927,923.71
        North,Tennessee,466,770.67
        East,Florida,520,458.68
        East,Maine,828,661.24
        West,Virginia,465,053.58
        North,Missouri,436,235.67
        South,Kansas,214,992.47
        North,North Dakota,789,640.72
        South,Delaware,712,508.55
"@
        $actual = $data | ConvertTo-CrossTab -ColumnName Region -RowName State -ValueName Units -SuffixColumn " units"

        $actual.Count  | Should -Be 9

        $actual[0].State | Should -BeExactly "Delaware"
        $actual[0].'East Units' | Should -BeNullOrEmpty
        $actual[0].'North Units' | Should -BeNullOrEmpty
        $actual[0].'South Units' | Should -BeExactly 712
        $actual[0].'West Units' | Should -BeNullOrEmpty

        $actual[1].State | Should -BeExactly "Florida"
        $actual[1].'East Units' | Should -BeExactly 520
        $actual[1].'North Units' | Should -BeNullOrEmpty
        $actual[1].'South Units' | Should -BeNullOrEmpty
        $actual[1].'West Units' | Should -BeNullOrEmpty

        $actual[2].State | Should -BeExactly "Kansas"
        $actual[2].'East Units' | Should -BeNullOrEmpty
        $actual[2].'North Units' | Should -BeNullOrEmpty
        $actual[2].'South Units' | Should  -BeExactly 214
        $actual[2].'West Units' | Should -BeNullOrEmpty

        $actual[3].State | Should -BeExactly "Maine"
        $actual[3].'East Units' | Should -Be 828
        $actual[3].'North Units' | Should -BeNullOrEmpty
        $actual[3].'South Units' | Should -BeNullOrEmpty
        $actual[3].'West Units' | Should -BeNullOrEmpty
        
        $actual[4].State | Should -BeExactly "Missouri"
        $actual[4].'East Units' | Should -BeNullOrEmpty
        $actual[4].'North Units' | Should -Be 436
        $actual[4].'South Units' | Should -BeNullOrEmpty
        $actual[4].'West Units' | Should -BeNullOrEmpty

        $actual[5].State | Should -BeExactly "North Dakota"
        $actual[5].'East Units' | Should -BeNullOrEmpty
        $actual[5].'North Units' | Should -Be 789
        $actual[5].'South Units' | Should -BeNullOrEmpty
        $actual[5].'West Units' | Should -BeNullOrEmpty

        $actual[6].State | Should -BeExactly "Tennessee"
        $actual[6].'East Units' | Should -BeNullOrEmpty
        $actual[6].'North Units' | Should -Be 466
        $actual[6].'South Units' | Should -BeNullOrEmpty
        $actual[6].'West Units' | Should -BeNullOrEmpty

        $actual[7].State | Should -BeExactly "Texas"
        $actual[7].'East Units' | Should -BeNullOrEmpty
        $actual[7].'North Units' | Should -BeNullOrEmpty
        $actual[7].'South Units' | Should -BeNullOrEmpty
        $actual[7].'West Units' | Should -Be 927

        $actual[8].State | Should -BeExactly "Virginia"
        $actual[8].'East Units' | Should -BeNullOrEmpty
        $actual[8].'North Units' | Should -BeNullOrEmpty
        $actual[8].'South Units' | Should -BeNullOrEmpty
        $actual[8].'West Units' | Should -Be 465

    }
}