function New-MiniPivot {
    param(
        $Row,
        $Column,
        $Measure,
        [ValidateScript( { $_ -in (Get-AggregateFunctionNames) })]
        $AggregationFunction = 'Sum',
        $Fill = [double]::NaN,
        [parameter(ValueFromPipeline)]
        $InputObject,
        [Switch]$Raw
    )

    Process {
        $data += @($inputObject)
    }

    End {
        $colHeadings = $data.$Column | Sort-Object -Unique

        $result = $(
            foreach ($item in $data) {
                [pscustomobject]@{
                    Item          = $item.$Row
                    $item.$Column = $item.$Measure
                }
            }
        ) | Select-Object (@($row) + $colHeadings) 

        if ($Raw) {
            return $result
        }
        
        $result | New-PSPivotTable $Row -agg $AggregationFunction -values $colHeadings -Fill $Fill
    }
}