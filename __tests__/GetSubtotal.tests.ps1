Import-Module "$PSScriptRoot/../PowerShellPivot.psd1" -Force

Describe "Tests GetSubTotal" -Tag GetSubTotal {
    BeforeAll {
        $script:data = ConvertFrom-Csv @"
Region,State,Units,Price
South,Texas,927,923.71
North,Tennessee,466,770.67
East,Florida,520,458.68
East,Maine,828,661.24
West,Virginia,465,053.58
North,Missouri,436,235.67
South,Kansas,214,992.47
North,North Dakota,789,640.72
South,Delaware,712,508.55
East,South Dakota,327,043.72
West,Ohio,327,761.93
South,Colorado,841,573.59
East,Nebraska,292,929.38
North,Oklahoma,810,627.88
East,Pennsylvania,577,614.09
West,Georgia,229,864.72
South,Indiana,355,382.15
South,Iowa,165,944.88
North,Hawaii,302,126.59
North,Wyoming,836,994.75
West,Minnesota,905,509.88
South,North Carolina,856,302.80
West,Alabama,465,222.77
South,Texas,135,954.26
"@
    }

    It 'Should calculate the count subtotals for each region' {
        $actual = $data | Get-SubTotal Region

        $actual[0].Region | Should -BeExactly "East"
        $actual[0].Count | Should -Be 5

        $actual[1].Region | Should -BeExactly "North"
        $actual[1].Count | Should -Be 6

        $actual[2].Region | Should -BeExactly "South"
        $actual[2].Count | Should -Be 8

        $actual[3].Region | Should -BeExactly "West"
        $actual[3].Count | Should -Be 5
    }

    It 'Should calculate the sum of Units For State and Region' {
        $actual = $data | Get-SubTotal State, Region -Sum Units

        $actual.Count | Should -Be 23

        $actual[0].State | Should -BeExactly "Alabama"
        $actual[0].Region | Should -BeExactly "West"
        $actual[0].Sum_Units | Should -Be 465

        $actual[1].State | Should -BeExactly "Colorado"
        $actual[1].Region | Should -BeExactly "South"
        $actual[1].Sum_Units | Should -Be 841

        $actual[2].State | Should -BeExactly "Delaware"
        $actual[2].Region | Should -BeExactly "South"
        $actual[2].Sum_Units | Should -Be 712

        $actual[3].State | Should -BeExactly "Florida"
        $actual[3].Region | Should -BeExactly "East"
        $actual[3].Sum_Units | Should -Be 520

        $actual[4].State | Should -BeExactly "Georgia"
        $actual[4].Region | Should -BeExactly "West"
        $actual[4].Sum_Units | Should -Be 229

        $actual[5].State | Should -BeExactly "Hawaii"
        $actual[5].Region | Should -BeExactly "North"
        $actual[5].Sum_Units | Should -Be 302

        $actual[6].State | Should -BeExactly "Indiana"
        $actual[6].Region | Should -BeExactly "South"
        $actual[6].Sum_Units | Should -Be 355

        $actual[7].State | Should -BeExactly "Iowa"
        $actual[7].Region | Should -BeExactly "South"
        $actual[7].Sum_Units | Should -Be 165

        $actual[8].State | Should -BeExactly "Kansas"
        $actual[8].Region | Should -BeExactly "South"
        $actual[8].Sum_Units | Should -Be 214

        $actual[9].State | Should -BeExactly "Maine"
        $actual[9].Region | Should -BeExactly "East"
        $actual[9].Sum_Units | Should -Be 828

        $actual[10].State | Should -BeExactly "Minnesota"
        $actual[10].Region | Should -BeExactly "West"
        $actual[10].Sum_Units | Should -Be 905

        $actual[11].State | Should -BeExactly "Missouri"
        $actual[11].Region | Should -BeExactly "North"
        $actual[11].Sum_Units | Should -Be 436

        $actual[12].State | Should -BeExactly "Nebraska"
        $actual[12].Region | Should -BeExactly "East"
        $actual[12].Sum_Units | Should -Be 292

        $actual[13].State | Should -BeExactly "North Carolina"
        $actual[13].Region | Should -BeExactly "South"
        $actual[13].Sum_Units | Should -Be 856

        $actual[14].State | Should -BeExactly "North Dakota"
        $actual[14].Region | Should -BeExactly "North"
        $actual[14].Sum_Units | Should -Be 789

        $actual[15].State | Should -BeExactly "Ohio"
        $actual[15].Region | Should -BeExactly "West"
        $actual[15].Sum_Units | Should -Be 327

        $actual[16].State | Should -BeExactly "Oklahoma"
        $actual[16].Region | Should -BeExactly "North"
        $actual[16].Sum_Units | Should -Be 810

        $actual[17].State | Should -BeExactly "Pennsylvania"
        $actual[17].Region | Should -BeExactly "East"
        $actual[17].Sum_Units | Should -Be 577

        $actual[18].State | Should -BeExactly "South Dakota"
        $actual[18].Region | Should -BeExactly "East"
        $actual[18].Sum_Units | Should -Be 327

        $actual[19].State | Should -BeExactly "Tennessee"
        $actual[19].Region | Should -BeExactly "North"
        $actual[19].Sum_Units | Should -Be 466

        $actual[20].State | Should -BeExactly "Texas"
        $actual[20].Region | Should -BeExactly "South"
        $actual[20].Sum_Units | Should -Be 1062

        $actual[21].State | Should -BeExactly "Virginia"
        $actual[21].Region | Should -BeExactly "West"
        $actual[21].Sum_Units | Should -Be 465

        $actual[22].State | Should -BeExactly "Wyoming"
        $actual[22].Region | Should -BeExactly "North"
        $actual[22].Sum_Units | Should -Be 836
    }

    It "Should calculate multiple values" {
        $actual = $data | Get-SubTotal State, Region Units, Price -Sum

        $actual.Count | Should -Be 23

        $actual[0].State | Should -BeExactly "Alabama"
        $actual[0].Region | Should -BeExactly "West"
        $actual[0].Sum_Units | Should -Be 465
        $actual[0].Sum_Price | Should -Be 222.77

        $actual[1].State | Should -BeExactly "Colorado"
        $actual[1].Region | Should -BeExactly "South"
        $actual[1].Sum_Units | Should -Be 841
        $actual[1].Sum_Price | Should -Be 573.59

        $actual[5].State | Should -BeExactly "Hawaii"
        $actual[5].Region | Should -BeExactly "North"
        $actual[5].Sum_Units | Should -Be 302
        $actual[5].Sum_Price | Should -Be 126.59

        $actual[10].State | Should -BeExactly "Minnesota"
        $actual[10].Region | Should -BeExactly "West"
        $actual[10].Sum_Units | Should -Be 905
        $actual[10].Sum_Price | Should -Be 509.88

        $actual[15].State | Should -BeExactly "Ohio"
        $actual[15].Region | Should -BeExactly "West"
        $actual[15].Sum_Units | Should -Be 327
        $actual[15].Sum_Price | Should -Be 761.93

        $actual[20].State | Should -BeExactly "Texas"
        $actual[20].Region | Should -BeExactly "South"
        $actual[20].Sum_Units | Should -Be 1062
        $actual[20].Sum_Price | Should -Be 1877.97

        $actual[-1].State | Should -BeExactly "Wyoming"
        $actual[-1].Region | Should -BeExactly "North"
        $actual[-1].Sum_Units | Should -Be 836
        $actual[-1].Sum_Price | Should -Be 994.75
    }

    It "Should calculate all stats" {
        $data = ConvertFrom-Csv @"
Region,State,Units,Price
South,Texas,927,923.71
North,Tennessee,466,770.67
North,Tennessee,866,1770.67
East,Florida,1520,1458.68
East,Florida,520,458.68
East,Maine,1828,1661.24
East,Maine,828,661.24
West,Virginia,465,53.58
West,Virginia,1465,153.58
South,Texas,135,954.26
"@
        $actual = $data | Get-SubTotal State, Region Price -AllStats

        $actual.Count | Should -Be 5

        $actual[0].State | Should -BeExactly "Florida"
        $actual[0].Region | Should -BeExactly "East"
        $actual[0].Count_Price | Should -Be 2
        $actual[0].Average_Price | Should -Be ([decimal]958.68)
        $actual[0].Sum_Price | Should -Be ([decimal]1917.36)
        $actual[0].Max_Price | Should -Be ([decimal]1458.68)
        $actual[0].Min_Price | Should -Be ([decimal]458.68)
        # $actual[0].STD_Price | Should -Be ([decimal]707.106781186548)

        $actual[1].State | Should -BeExactly "Maine"
        $actual[1].Region | Should -BeExactly "East"
        $actual[1].Count_Price | Should -Be 2
        $actual[1].Average_Price | Should -Be ([decimal]1161.24)
        $actual[1].Sum_Price | Should -Be ([decimal]2322.48)
        $actual[1].Max_Price | Should -Be ([decimal]1661.24)
        $actual[1].Min_Price | Should -Be ([decimal]661.24)
        # $actual[1].STD_Price | Should -Be ([decimal]707.106781186548)

        $actual[2].State | Should -BeExactly "Tennessee"
        $actual[2].Region | Should -BeExactly "North"
        $actual[2].Count_Price | Should -Be 2
        $actual[2].Average_Price | Should -Be ([decimal]1270.67)
        $actual[2].Sum_Price | Should -Be ([decimal]2541.34)
        $actual[2].Max_Price | Should -Be ([decimal]1770.67)
        $actual[2].Min_Price | Should -Be ([decimal]770.67)
        # $actual[2].STD_Price | Should -Be ([decimal]707.106781186548)

        $actual[3].State | Should -BeExactly "Texas"
        $actual[3].Region | Should -BeExactly "South"
        $actual[3].Count_Price | Should -Be 2
        $actual[3].Average_Price | Should -Be ([decimal]938.985)
        $actual[3].Sum_Price | Should -Be ([decimal]1877.97)
        $actual[3].Max_Price | Should -Be ([decimal]954.26)
        $actual[3].Min_Price | Should -Be ([decimal]923.71)
        # $actual[3].STD_Price | Should -Be ([decimal]21.602112165249)

        $actual[4].State | Should -BeExactly "Virginia"
        $actual[4].Region | Should -BeExactly "West"
        $actual[4].Count_Price | Should -Be 2
        $actual[4].Average_Price | Should -Be ([decimal]103.58)
        $actual[4].Sum_Price | Should -Be ([decimal]207.16)
        $actual[4].Max_Price | Should -Be ([decimal]153.58)
        $actual[4].Min_Price | Should -Be ([decimal]53.58)
        # $actual[4].STD_Price | Should -Be ([decimal]70.7106781186548)
    }
}