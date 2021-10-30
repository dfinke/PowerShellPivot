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

Describe "Tests New PSPivotTable Null Measures" -Tag NewPSPivotTableNaN {
    It "Tests NaN for Average Aggregation" -TestCases @(
        @{dataSet = $global:nullUnitsData; expectedUnits = $true; expectedPrice = $false ; aggregateFunction = 'average' }
        @{dataSet = $global:nullFirstUnitData; expectedUnits = $false; expectedPrice = $false ; aggregateFunction = 'average' }
        @{dataSet = $global:nullSecondUnitData; expectedUnits = $false; expectedPrice = $false ; aggregateFunction = 'average' }
    ) {
        param(
            $dataSet,
            $expectedUnits,
            $expectedPrice,
            $aggregateFunction
        )
        
        $actual = $dataSet | New-PSPivotTable Region -values Units, Price -aggregateFunction $aggregateFunction

        [double]::IsNaN($actual[0].Average_Units) | Should -Be $expectedUnits
        [double]::IsNaN($actual[0].Average_Price) | Should -Be $expectedPrice
    }

    It "Tests NaN for Min Aggregation" -TestCases @(
        @{dataSet = $global:nullUnitsData; expectedUnits = $true; expectedPrice = $false ; aggregateFunction = 'min' }
        @{dataSet = $global:nullFirstUnitData; expectedUnits = $true; expectedPrice = $false ; aggregateFunction = 'min' }
        @{dataSet = $global:nullSecondUnitData; expectedUnits = $true; expectedPrice = $false ; aggregateFunction = 'min' }
        @{dataSet = $global:allGoodData; expectedUnits = $false; expectedPrice = $false ; aggregateFunction = 'min' }
    ) {
        param(
            $dataSet,
            $expectedUnits,
            $expectedPrice,
            $aggregateFunction
        )
        
        $actual = $dataSet | New-PSPivotTable Region -values Units, Price -aggregateFunction $aggregateFunction

        [double]::IsNaN($actual[0].min_Units) | Should -Be $expectedUnits
        [double]::IsNaN($actual[0].min_Price) | Should -Be $expectedPrice
    }

    It "Tests NaN for Max Aggregation" -TestCases @(
        @{dataSet = $global:nullUnitsData; expectedUnits = $true; expectedPrice = $false ; aggregateFunction = 'max' }
        @{dataSet = $global:nullFirstUnitData; expectedUnits = $true; expectedPrice = $false ; aggregateFunction = 'max' }
        @{dataSet = $global:nullSecondUnitData; expectedUnits = $true; expectedPrice = $false ; aggregateFunction = 'max' }
        @{dataSet = $global:allGoodData; expectedUnits = $false; expectedPrice = $false ; aggregateFunction = 'max' }
    ) {
        param(
            $dataSet,
            $expectedUnits,
            $expectedPrice,
            $aggregateFunction
        )
        
        $actual = $dataSet | New-PSPivotTable Region -values Units, Price -aggregateFunction $aggregateFunction

        [double]::IsNaN($actual[0].max_Units) | Should -Be $expectedUnits
        [double]::IsNaN($actual[0].max_Price) | Should -Be $expectedPrice
    }

    It "Tests NaN for Sum Aggregation" -TestCases @(
        @{dataSet = $global:nullUnitsData; expectedUnits = $true; expectedPrice = $false ; aggregateFunction = 'sum' }
        @{dataSet = $global:nullFirstUnitData; expectedUnits = $false; expectedPrice = $false ; aggregateFunction = 'sum' }
        @{dataSet = $global:nullSecondUnitData; expectedUnits = $false; expectedPrice = $false ; aggregateFunction = 'sum' }
        @{dataSet = $global:allGoodData; expectedUnits = $false; expectedPrice = $false ; aggregateFunction = 'sum' }
    ) {
        param(
            $dataSet,
            $expectedUnits,
            $expectedPrice,
            $aggregateFunction
        )
        
        $actual = $dataSet | New-PSPivotTable Region -values Units, Price -aggregateFunction $aggregateFunction

        [double]::IsNaN($actual[0].sum_Units) | Should -Be $expectedUnits
        [double]::IsNaN($actual[0].sum_Price) | Should -Be $expectedPrice
    }

    It "Tests NaN for Entropy Aggregation" -TestCases @(
        @{dataSet = $global:nullUnitsData; expectedUnits = $true; expectedPrice = $false ; aggregateFunction = 'Entropy' }
        @{dataSet = $global:nullFirstUnitData; expectedUnits = $true; expectedPrice = $false ; aggregateFunction = 'Entropy' }
        @{dataSet = $global:nullSecondUnitData; expectedUnits = $true; expectedPrice = $false ; aggregateFunction = 'Entropy' }
        @{dataSet = $global:allGoodData; expectedUnits = $false; expectedPrice = $false ; aggregateFunction = 'Entropy' }
    ) {
        param(
            $dataSet,
            $expectedUnits,
            $expectedPrice,
            $aggregateFunction
        )
        
        $actual = $dataSet | New-PSPivotTable Region -values Units, Price -aggregateFunction $aggregateFunction

        [double]::IsNaN($actual[0].Entropy_Units) | Should -Be $expectedUnits
        [double]::IsNaN($actual[0].Entropy_Price) | Should -Be $expectedPrice
    }

    It "Tests NaN for Mean Aggregation" -TestCases @(
        @{dataSet = $global:nullUnitsData; expectedUnits = $true; expectedPrice = $false ; aggregateFunction = 'Mean' }
        @{dataSet = $global:nullFirstUnitData; expectedUnits = $true; expectedPrice = $false ; aggregateFunction = 'Mean' }
        @{dataSet = $global:nullSecondUnitData; expectedUnits = $true; expectedPrice = $false ; aggregateFunction = 'Mean' }
        @{dataSet = $global:allGoodData; expectedUnits = $false; expectedPrice = $false ; aggregateFunction = 'Mean' }
    ) {
        param(
            $dataSet,
            $expectedUnits,
            $expectedPrice,
            $aggregateFunction
        )
        
        $actual = $dataSet | New-PSPivotTable Region -values Units, Price -aggregateFunction $aggregateFunction

        [double]::IsNaN($actual[0].Mean_Units) | Should -Be $expectedUnits
        [double]::IsNaN($actual[0].Mean_Price) | Should -Be $expectedPrice
    }    
}