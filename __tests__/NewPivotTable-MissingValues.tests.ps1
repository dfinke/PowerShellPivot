Import-Module "$PSScriptRoot/../PowerShellPivot.psd1" -Force

Describe "Tests New PSPivotTable MissingValues" -Tag NewPSPivotTable-MissingValue {

    BeforeEach {
        $script:data = Import-Csv $PSScriptRoot/MissingValues.csv 
    }

    It 'Test should return "[missing]" for missing values' {      
        $actual = New-PSPivotTable -InputObject $data Region

        $actual.Count | Should -Be 3
        
        $actual[0].Region | Should -BeExactly "[missing]"
        $actual[0].Average_Units | Should -Be 568.5
        $actual[0].Average_Price | Should -Be 655.235
        
        $actual[1].Region | Should -BeExactly "North"
        $actual[1].Average_Units | Should -Be 563.667
        $actual[1].Average_Price | Should -Be 549.02
        
        $actual[2].Region | Should -BeExactly "West"
        $actual[2].Average_Units | Should -Be 696
        $actual[2].Average_Price | Should -Be 488.645
    }

    It 'Test should return "[Region missing]" for missing values' {
        $actual = New-PSPivotTable -InputObject $data Region -MissingValueText "[Region missing]"

        $actual.Count | Should -Be 3

        $actual[0].Region | Should -BeExactly "[Region missing]"
        $actual[0].Average_Units | Should -Be 568.5
        $actual[0].Average_Price | Should -Be 655.235

        $actual[1].Region | Should -BeExactly "North"
        $actual[1].Average_Units | Should -Be 563.667
        $actual[1].Average_Price | Should -Be 549.02

        $actual[2].Region | Should -BeExactly "West"
        $actual[2].Average_Units | Should -Be 696
        $actual[2].Average_Price | Should -Be 488.645
    }

}