function Get-Subtotal  {
    <#
      .SYNOPSIS
        Adds subtotals to data
      .DESCRIPTION
        Combines Measure-Object and Group object - groups on one or more properties,
        and calculates different measures across properties in the group
        It does NOT support custom properties (so use Select-object and pipe into
        Get-Subtotal), and you if you ask for min, max and average, and Width and Height
        you will get six items, and if you want width_min, width_max, height_average, again
        Select-Object is there for the task.
      .EXAMPLE
        Get-ChildItem  | Get-Subtotal Length -Allstats  -Group  Extension | ft
        Produces a table of count, average, sum,  min, max and standard deviation for file length grouped by file extension.
      .EXAMPLE
        Get-ChildItem  | Select-object *, @{n='Month';e={$_.LastWriteTime.toString("yyyy_MM")}} | Get-Subtotal -GroupByName Extension, month
        Adds a "Month" column in the form "2022-02" to files, groups by month and file extension and returns a count for each group
      .EXAMPLE
         Get-ChildItem | Get-Subtotal -GroupByName Extension -ValueName LastWriteTime, CreationTime -Maximum -Minimum | ft
         Produces a table by file extension of min and max dates for file creation and last write
    #>
    [cmdletbinding(DefaultParameterSetName='Default')]
    param (
        #The property name(s) to group on.
        [Parameter(Position=0)]
        $GroupByName,
        #The property name(s) to aggregrate, using the switches used in Measure-Object
        [Parameter(Position=1,ParameterSetName='Default')]
        [Parameter(Position=1,ParameterSetName='Stats',Mandatory=$true)]
        [Parameter(Position=1,ParameterSetName='Chars',Mandatory=$true)]
        $ValueName,
        #The data to subtotal
        [Parameter(ValueFromPipeline=$true)]
        $InputObject,
        [Parameter(ParameterSetName='Default')]
        [Parameter(ParameterSetName='Stats')]
        [switch]$Count,
        [Parameter(ParameterSetName='Stats')]
        [switch]$AllStats,
        [Parameter(ParameterSetName='Stats')]
        [switch]$Average,
        [Parameter(ParameterSetName='Stats')]
        [switch]$Maximum,
        [Parameter(ParameterSetName='Stats')]
        [switch]$Minimum,
        [Parameter(ParameterSetName='Stats')]
        [switch]$StandardDeviation,
        [Parameter(ParameterSetName='Stats')]
        [switch]$Sum,
        [Parameter(ParameterSetName='Chars')]
        [switch]$Character,
        [Parameter(ParameterSetName='Chars')]
        [switch]$IgnoreWhiteSpace,
        [Parameter(ParameterSetName='Chars')]
        [switch]$Line,
        [Parameter(ParameterSetName='Chars')]
            [switch]$Word,
        [switch]$NoPrefix
    )
    begin {
        $data   = @()
    }
    process {
        $data  += $inputObject
    }
    end {
        #Will use most of the parameters with Measure-Object
        $params = @{} + $PSBoundParameters
        [void]$params.Remove('InputObject')
        [void]$params.Remove('GroupByName')
        [void]$params.Remove('ValueName')
        [void]$params.Remove('Count')
        [void]$params.Remove('NoPrefix')
        if ($IgnoreWhiteSpace -and -not ($Line -or $Character -or $Word)) {$params['Character']=$true}
        if ($params.Keys.Count -gt 1 -and $NoPrefix) {Write-Warning "NoPrefix ignored whene there are multiple aggregations"}
        $data | Group-Object -Property $GroupByName | ForEach-Object {
            $newobj = [Ordered]@{}
            #For whatever we grouped on, get that value/those values from the first row of each group. Then total the properties we're interested in
            foreach ($g in $GroupByName) {$newobj[$g] = $_.Group[0].$g }
            if (-not $ValueName) {
                $newobj['Count'] = $_.Group.Count
            }
            foreach ($v in $ValueName)   {
                #Some objects may not have all the properties e.g. Dir | measure length
                $totals =  $_.Group | Measure-object -Property $v @params -ErrorAction SilentlyContinue
                if ($PSCmdlet.ParameterSetName -eq 'Chars') {#paramter is word/line/character, but property is words/lines/characters
                    foreach ($agFn  in $params.Keys.where({$_  -ne 'IgnoreWhiteSpace'}))  {
                                 $newObj[($v + "_" + $agfn + "s")] = $totals."$agFn`s"
                    }
                }
                else {
                    if (-not $AllStats) {
                            if ($count) {$newObj[($v + "_Count" )]    = $totals.count}
                            $agFunctions = $params.Keys
                    }
                    else {  $agFunctions = "Count","Average","Sum","Maximum","Minimum","StandardDeviation"}
                    if ($agfunctions.Count -eq 1 -and $NoPrefix) {
                        $newObj[$v] = $totals.($agFunctions[0])
                    }
                    else {
                        foreach ($agFn in $agFunctions)  {
                                 $newObj[($agfn + "_" + $v )] = $totals.$agFn
                        }
                    }
                }
            }
            [pscustomobject]$newobj
        }
    }
}