''
Import-Module ./powershellpivot.psd1 -Force

function PrintPivotBasics {
    param(
        $pivotData,
        $fill = [double]::nan
    )

    $keys = $pivotData.Keys -ne 'metadata'

    $max = [int]::MinValue

    foreach ($key in $keys) {
        if ($key.Length -gt $max) {
            $max = $key.Length
        }
    }

    $lookupMax = [int]::MinValue
    $lookup = $(
        foreach ($key in $keys) {
            $target = $pivotData[$key].Keys
            
            foreach ($item in $target) {
                if ($item.Length -gt $lookupMax) {
                    $lookupMax = $item.Length
                }                
            }

            $target
        }
    ) | Sort-Object -Unique

    
    $p = @("{0,$(-1*$max)}" -f $pivotData.metaData.column[0])
    foreach ($t in $lookup) {    
        $p += "{0,$($lookupMax+1)}" -f $t        
    }

    -join $p
    $pivotData.metaData.index[0]

    foreach ($key in $keys | Sort-Object) {
        $p = @("{0,$(-1*$max)}" -f $key)
        
        foreach ($item in $lookup) {
            if (!$pivotData[$key].Contains($item)) {
                $p += @("{0,$($lookupMax)}" -f $fillValue)
            }
            else {
                $p += @("{0,$($lookupMax)}" -f $pivotData[$key][$item].Values.Result())
            }
        }
        $p -join ' '
    }
}

$data = ConvertFrom-Csv @"
Fruit, Region, Revenue
Oranges, North, 12.30
Apples, South, 10.55
Oranges, South, 22.00
Bananas, South, 5.90
Bananas, North, 31.30
Oranges, North, 13.10
Pear, West, 14.25
Pinapple, East, 7.36
Pear, East, 11.67
"@
# "@

PrintPivotBasics ($data | New-PSPivotTable -Index Fruit -column Region -agg sum) | Out-String
PrintPivotBasics ($data | New-PSPivotTable -Index Region -Column Fruit -agg sum) | Out-String

<#
Out[92]: Region   North  South  Total
         Fruit
         Apples     NaN  10.55  10.55
         Bananas   31.3   5.90  37.20
         Oranges   25.4  22.00  47.40
         Total     56.7  38.45  95.15
#>
