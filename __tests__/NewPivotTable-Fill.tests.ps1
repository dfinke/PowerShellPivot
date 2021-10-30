Import-Module "$PSScriptRoot/../PowerShellPivot.psd1" -Force

$global:nullUnitsData = ConvertFrom-Csv @"
Region,State,Units,Price
East,Florida,,458.68
East,Maine,,661.24
"@

$global:nullFirstUnitData = ConvertFrom-Csv @"
Region,State,Units,Price
East,Florida,,458.68
East,Maine,10,661.24
"@

$global:nullSecondUnitData = ConvertFrom-Csv @"
Region,State,Units,Price
East,Florida,10,458.68
East,Maine,,661.24
"@

$global:allGoodData = ConvertFrom-Csv @"
Region,State,Units,Price
East,Florida,10,458.68
East,Maine,20,661.24
"@

Describe "Tests New PSPivotTable Null Measures" -Tag NewPSPivotTableFill {
    It "Tests Fill for Aggregations" -TestCases @(
        @{dataSet = $global:nullUnitsData; propertyName = 'Units'; aggregateFunction = 'Average' }
        @{dataSet = $global:nullUnitsData; propertyName = 'Units'; aggregateFunction = 'Min' }
        @{dataSet = $global:nullUnitsData; propertyName = 'Units'; aggregateFunction = 'Max' }
        @{dataSet = $global:nullUnitsData; propertyName = 'Units'; aggregateFunction = 'Sum' }
    ) {
        param(
            $dataSet,
            $propertyName,
            $aggregateFunction
        )
        
        $actual = $dataSet | New-PSPivotTable Region -values $propertyName -aggregateFunction $aggregateFunction -Fill 0

        $fullPropertyName = $aggregateFunction + "_" + $propertyName 
        $actual[0].$fullPropertyName | Should -Be 0
    }
    
    It "Tests Fill for Aggregations" -TestCases @(
        @{dataSet = $global:nullFirstUnitData; propertyName = 'Units'; expected = 5; aggregateFunction = 'Average' }
        @{dataSet = $global:nullFirstUnitData; propertyName = 'Units'; expected = 0; aggregateFunction = 'Min' }
        @{dataSet = $global:nullFirstUnitData; propertyName = 'Units'; expected = 10; aggregateFunction = 'Max' }
        @{dataSet = $global:nullFirstUnitData; propertyName = 'Units'; expected = 10; aggregateFunction = 'Sum' }
    ) {
        param(
            $dataSet,
            $propertyName,
            $expected,
            $aggregateFunction
        )
        
        $actual = $dataSet | New-PSPivotTable Region -values $propertyName -aggregateFunction $aggregateFunction -Fill 0

        $fullPropertyName = $aggregateFunction + "_" + $propertyName 
        $actual[0].$fullPropertyName | Should -Be $expected
    }
}