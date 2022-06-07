function ConvertTo-CrossTab {
<#
    .SYNOPSIS
        Converts simple rows into a cross tab query
    .DESCRIPTION
    Takes data like
            Place, Month, Person
            London, Jan, Alice
            London, Feb, Bob
            London, Mar, Chris
            New York, Jan, Alex
            New York, Feb, Jean
            New York, Mar, Phil
            And converts it to
            Place, Jan, Feb, Mar
            London, Alice, Bob, Chris
            New York Alex, Jean, Phil
    .EXAMPLE
    Ps > $data = @"
    Place, Month, Person
    London, Jan, Alice
    London, Feb, Bob
    London, Mar, Chris
    New York, Jan, Alex
    New York, Feb, Jean
    New York, Mar, Phil
    "@ | convertfrom-csv
    Ps > $data | ConvertTo-CrossTab -RowName Place -ColumnName Month -ValueName person | ft

    Takes some sample data as a string and converts it from Csv format and Outputs a Crosstab using Places as a row names and Months column names

    Place    Feb  Jan   Mar
    -----    ---  ---   ---
    London   Bob  Alice Chris
    New York Jean Alex  Phil

    .EXAMPLE
    ps> $data | ConvertTo-CrossTab -RowName Month -ColumnName Place -ValueName person | ft

    Pivots the same data but switches the rows and columns. Note that data is sorted by the row name so Feb  is first alphabetically.
    Thhe result looks like this

    Month London New York
    ----- ------ --------
    Feb   Bob    Jean
    Jan   Alice  Alex
    Mar   Chris  Phil
#>

    param(
        [string]$RowName,
        [String]$ColumnName,
        [string]$PrefixColumn = "",
        [String]$SuffixColum = "",
        [string]$ValueName,
        [Parameter(ValueFromPipeline=$true,Mandatory=$true)]
        $InputObject
        )
    begin {
        $data = @()
    }
    process {
        $data += $inputObject
    }
    end {
        $Rows    = @{}
        $Columns = @{}
        if ($data.where({($null -eq  $_.$RowName) -or ($null -eq $_.$ColumnName) -or ($null -eq $_.$ValueName)}) ) {
            Write-Warning "Some data is missing $RowName and/or $ColumnName and/or $ValueName properties"
        }
        $Duplicates = $false
        foreach ($d in $data.where({$_.$RowName -and $_.$ColumnName -and $_.$ValueName}))   {
            if ($null -eq $rows[$d.$RowName]) {$rows[$d.$RowName] = @{}}
            if ($null -ne $rows[$d.$RowName][$d.$ColumnName]) {$Duplicates = $true} else {$Columns[$d.$ColumnName] = $true }
            $rows[$d.$RowName][$d.$ColumnName] = $d.$ValueName
        }
        if ($Duplicates) {
            Write-Warning "Some Row/Column combinations had duplicate rows, the last value in the data will be used"
        }
        $OutputProperties= @($RowName) + ($Columns.Keys | Sort-Object | ForEach-Object {@{n=($PrefixColumn + $_ + $SuffixColum); e= $_.tostring()}})
        $rows.Keys | Sort-Object | ForEach-Object {
            $r = $rows[$_]
            $r[$RowName] = $_
            [pscustomobject]$r
        } | Select-Object -Property $OutputProperties

    }
}