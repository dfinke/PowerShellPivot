. $PSScriptRoot\..\NotebookOutput.ps1

$data = ConvertFrom-Csv @"
Day,Location,Cucumber,Tomato,Lettuce,Asparagus,Potato
Monday,London,46,35,41,49,30
Tuesday,London,30,26,36,38,27
Wednesday,London,25,26,27,31,30
Thursday,London,47,32,44,21,37
Friday,London,38,40,35,27,39
Saturday,London,32,29,39,32,31
Sunday,London,28,31,37,29,39
Monday,Edinburgh,29,26,36,25,35
Tuesday,Edinburgh,44,48,32,26,28
Wednesday,Edinburgh,46,43,38,41,26
Thursday,Edinburgh,39,39,36,31,20
Friday,Edinburgh,36,38,47,30,24
Saturday,Edinburgh,33,27,39,47,39
Sunday,Edinburgh,43,42,35,37,28
Monday,Glasgow,29,30,25,29,47
Tuesday,Glasgow,32,36,46,38,22
Wednesday,Glasgow,20,33,26,44,27
Thursday,Glasgow,21,29,25,35,46
Friday,Glasgow,39,36,45,28,32
Saturday,Glasgow,22,34,33,33,29
Sunday,Glasgow,27,23,29,24,24
Monday,Birmingham,27,34,49,35,31
Tuesday,Birmingham,39,41,41,31,20
Wednesday,Birmingham,33,46,28,40,47
Thursday,Birmingham,21,46,38,29,20
Friday,Birmingham,31,32,21,32,31
Saturday,Birmingham,44,20,46,26,29
Sunday,Birmingham,47,41,42,23,29
Monday,Cardiff,34,37,40,30,41
Tuesday,Cardiff,47,41,26,24,49
Wednesday,Cardiff,27,40,38,26,32
Thursday,Cardiff,29,28,43,26,22
Friday,Cardiff,21,43,23,37,27
Saturday,Cardiff,42,44,47,38,47
Sunday,Cardiff,37,31,21,28,26
"@

$DataToPivot = $data | Invoke-PSMelt -Id Day, location -ValueName Sales -VarName Product

$PivotBy = 'Product' 
$aggFunction = 'Average' 
$Pivoted = $DataToPivot  |  New-PSPivotTable -index $PivotBy -aggregateFunction $aggFunction -column day -values  sales -fill 0

$html = $pivoted | ConvertTo-Html -As Table -Fragment 
foreach ( $rowHeading in $pivoted.$PivotBy) {
    $tree = $DataToPivot.where({ $_.$pivotby -eq $rowHeading }) | Out-TreeView -ExcludeProperty $PivotBy -TitleHtml $rowHeading -Raw
    $html = $html -replace "<td>\s*$rowHeading\s*</td>" , "<td>$tree</td>"
}

$html > ./test.html
Invoke-Item ./test.html