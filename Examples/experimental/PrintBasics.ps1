Import-Module .\PowerShellPivot.psd1 -Force

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
                $p += @("{0,$($lookupMax)}" -f $fill)
            }
            else {
                $p += @("{0,$($lookupMax)}" -f $pivotData[$key][$item].Values.Result())
            }
        }
        $p -join ' '
    }
}

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

$pivot = $data | New-PSPivotTable Region -column State -values Units
$pivotCol = $data | New-PSPivotTable State -column Region -values Units
$pivotIdx = $data | New-PSPivotTable State, Region -values Units
$pivot = $data | New-PSPivotTable Region 


''
PrintPivotBasics $pivot -fill 0

return 
$data = import-csv D:\mygit\pandas-in-action\chapter_08_reshaping_and_pivoting\sales_by_employee.csv

''
$pivot = $data | New-PSPivotTable Date -column Name -agg sum -values revenue
PrintPivotBasics $pivot | Out-String

$pivot = $data | New-PSPivotTable Date -column Name -agg sum -values revenue
PrintPivotBasics $pivot -fill 0 | Out-String