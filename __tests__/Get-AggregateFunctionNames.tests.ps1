Import-Module "$PSScriptRoot/../PowerShellPivot.psd1" -Force

Describe "Tests Get AggregateFunctionNames" -Tag GetAggregateFunctionNames {
    It 'Test should return null if no data is passed in' {
        $actual = Get-AggregateFunctionNames
        $actual.Count | Should -Be 16
    }
}