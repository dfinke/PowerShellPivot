function CalcMaximumLength {
    param($list)

    $max = [int]::MinValue

    foreach ($item in $list) {        
        if ($item.Length -gt $max) {
            $max = $item.Length
        }
    }

    $max
}

function PrettyPrint {
    param($InputObject)

    $keys = $InputObject.Keys -notmatch 'metadata'
    $columns = $InputObject[$keys[0]].Keys
    
    $colPad = (CalcMaximumLength $columns) + 2
    $pad = - ((CalcMaximumLength $keys) + 2)
    
    $strFmt = @("{0,$pad}")
    for ($colIdx = 1; $colIdx -le $columns.Count; $colIdx++) {
        $strFmt += "{$colIdx,$colPad}"
    }
    
    $topBottomChar = '─' 
    # $topBottomChar = '╼'
    # $topBottomChar = '╸'
    
    $sepChar = '|'
    # $sepChar = '╏'
    # $sepChar = '║'
    # $sepChar = '┊'
    # $sepChar = '╿'
    
    $fmt = '"{0}"' -f ($strFmt -join " $($sepChar)")
    $data = "'" + ($columns -join "','") + "'"
    $target = "$fmt -f '', $data" 
    $output = Invoke-Expression $target
    
    $topBottomChar * $output.Length 
    $output
    
    foreach ($item in $keys) {
        $data = ("'{0}'," -f $item) + ($InputObject["$($item)"].Values.Result() -join ', ')
        $target = "$fmt -f $data"
        Invoke-Expression $target
    }
    
    $topBottomChar * $output.Length 
    
}
