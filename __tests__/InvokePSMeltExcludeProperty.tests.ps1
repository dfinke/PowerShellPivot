Import-Module "$PSScriptRoot/../PowerShellPivot.psd1" -Force

Describe "Tests Invoke PSMelt Exclude Property" -Tag InvokePSMeltExcludeProperty {
    BeforeAll {
        $data = ConvertFrom-Csv @"
Date,Name,Customer,Revenue,Expenses
1/1/20,Oscar,Logistics XYZ,5250,531
1/1/20,Oscar,Money Corp.,4406,661
1/2/20,Oscar,PaperMaven,8661,1401
"@
    }

    It "Tests ExcludeProperty Date" {
        $actual = $data | Invoke-PSMelt -ExcludeProperty Date
        $actual.Count | Should -Be 12
    }

    It "Tests ExcludeProperty Date, Name" {
        $actual = $data | Invoke-PSMelt -ExcludeProperty Date, Name
        $actual.Count | Should -Be 9
    }

    It "Tests ExcludeProperty Date, Name, Customer" {
        $actual = $data | Invoke-PSMelt -ExcludeProperty Date, Name, Customer
        $actual.Count | Should -Be 6
    }

    It "Tests ExcludeProperty Date, Name, Customer, Revenue" {
        $actual = $data | Invoke-PSMelt -ExcludeProperty Date, Name, Customer, Revenue
        $actual.Count | Should -Be 3
    }

    It "Tests ExcludeProperty Date, Name, Customer, Revenue, Expenses" {
        $actual = $data | Invoke-PSMelt -ExcludeProperty Date, Name, Customer, Revenue, Expenses
        $actual.Count | Should -Be 0
    }

    It "Tests patterns for -ExcludeProperty" {

        # Excludes Name,Customer,Revenue,Expenses
        $actual = $data | psm -ExcludeProperty *me*, *en*

        $actual.Count | Should -Be 3
    }
}
