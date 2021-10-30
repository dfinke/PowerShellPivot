function GetDataTypePrecedence {
    param($list)

    $precedence = @{
        'String'   = 1
        'Double'   = 2
        'Int'      = 3
        'DateTime' = 4
        'bool'     = 5
        'null'     = 6
    }

    ($(foreach ($item in $list) {
            "$($precedence.$item)" + $item
        }) | Sort-Object | Select-Object -First 1) -replace "^\d", ""
}

function Get-DataType {
    param(
        [Parameter(Mandatory)]
        $TargetData
    )

    $names = $TargetData[0].psobject.properties.name

    $NumberOfRowsToCheck = 2
    foreach ($name in $names) {
        $h = [Ordered]@{ }
        $h.ColumnName = $name

        $dt = for ($idx = 0; $idx -lt $NumberOfRowsToCheck; $idx++) {
            if ([string]::IsNullOrEmpty($TargetData[$idx].$name)) {
                "null"
            }
            else {
                (Invoke-AllTests  $TargetData[$idx].$name -OnlyPassing -FirstOne).datatype
            }
        }

        $h.DataType = GetDataTypePrecedence @($dt)

        [pscustomobject]$h
    }
}
