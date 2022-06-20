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
    .EXAMPLE
    PS>  ConvertFrom-Csv @"
    Region,Item,TotalSold
    West,melon,27
    North,avocado,21
    West,kiwi,84
    East,melon,23
    North,kiwi,8
    North,avocado,29
    North,kiwi,46
    South,avocado,83
    East,Melon,10
    South,avocado,40
    "@  | ConvertTo-CrossTab -ValueName TotalSold -RowName Region -columnname item | ft

    This data has more than one item at least Region/Item combination so the data is aggreated
    - no aggregation function is specified so the default "SUM" is used and the result is

        Region avocado kiwi melon
        ------ ------- ---- -----
        East                   33
        North  50      54
        South  123
        West           84      27
#>

    param(
        [Parameter(Position=0,Mandatory=$true)]
        [string]$ValueName,
        [Parameter(Position=1,Mandatory=$true)]
        [string]$RowName,
        [Parameter(Position=2,Mandatory=$true)]
        [String]$ColumnName,
        [Parameter(Position=3)]
        [ValidateSet('Average', 'Count',  'Sum', 'Max', 'Min', 'Mean', 'Entropy', 'GeometricMean', 'HarmonicMean',  'Median',
                     'Quantile', 'LowerQuartile', 'UpperQuartile', 'RootMeanSquare',
                     'StandardDeviation', 'PopulationStandardDeviation', 'std', 'Variance', 'PopulationVariance',
                     'AllStats',  'Character', 'Line', 'Word')]
        [String]$AggregateFunction = "Sum",


        [string]$PrefixColumn = "",
        [string]$SuffixColumn = "",
        [Parameter(ValueFromPipeline=$true,Mandatory=$true)]
        $InputObject,
        [switch]$IgnoreWhiteSpace
        )
    begin {
        $data = @()
    }
    process {
        $data += $inputObject
    }
    end {
        if (($data | Group-Object -Property $RowName,$ColumnName | ForEach-Object {$_.Group.count}) -gt 1) {
            $subTotalParams = @{AggregateFunction=$AggregateFunction; SimpleName=$true ; ValueName = $ValueName; GroupByName=@($RowName,$ColumnName) }
            if ($IgnoreWhiteSpace -and $AggregateFunction -notin @("Character ", "Line ", "Word")) {
                Write-warning "Can't use ignorewhitespace with $AggregateFunction ignoring it. "
            }
            elseif ($IgnoreWhiteSpace) {$subTotalParams["IgnoreWhiteSpace"]=$true}
            $data = $data | Get-Subtotal @subTotalParams
        }
        elseif ($PSBoundParameters.ContainsKey('Aggregate')) {
            Write-Warning "There is only one value for each combination of $RowName and $ColumnName"
        }
        $Rows    = @{}
        $Columns = @{}
        if ($data.where({($null -eq  $_.$RowName) -or ($null -eq $_.$ColumnName) -or ($null -eq $_.$ValueName)}) ) {
            Write-Warning "Some data is missing $RowName and/or $ColumnName and/or $ValueName properties"
        }
#       $Duplicates = $false
        foreach ($d in $data.where({$_.$RowName -and $_.$ColumnName -and $_.$ValueName}))   {
            if ($null -eq $rows[$d.$RowName]) {$rows[$d.$RowName] = @{}}
            $Columns[$d.$ColumnName] = $true #if ($null -ne $rows[$d.$RowName][$d.$ColumnName]) {$Duplicates = $true} else { }
            $rows[$d.$RowName][$d.$ColumnName] = $d.$ValueName
        }
#       if ($Duplicates) {
#           Write-Warning "Some Row/Column combinations had duplicate rows, the last value in the data will be used"
#       }
        $OutputProperties= @($RowName) + ($Columns.Keys | Sort-Object | ForEach-Object {@{n=($PrefixColumn + $_ + $SuffixColumn); e= $_.tostring()}})
        $rows.Keys | Sort-Object | ForEach-Object {
            $r = $rows[$_]
            $r[$RowName] = $_
            [pscustomobject]$r
        } | Select-Object -Property $OutputProperties

    }
}