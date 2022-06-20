function Invoke-PSMelt {
    <#
    .SYNOPSIS
    Unpivot a given array from wide format to long format
    #>
    param(
        [string[]]$Id,
        [string[]]$Vars,
        [string[]]$ExcludeProperty,
        $VarName = "variable",
        $ValueName = "value",
        [Parameter(ValueFromPipeline)]
        $InputObject
    )

    process {
        if ($null -eq $InputObject) {
            return $null
        }
        <# 
            By NOT gathering the objects and processing in an end block, we can melt rows with disimilar columns; 
            but skip figuring columnnames when all piped items are the same
        #>
        $propertyNames = $InputObject[0].psobject.Properties.name
        $newprops = $propertyNames -join ''
        if ($oldprops -ne $newProps) {
            #Allow exclude property to be an array of wildcards. Regex would match "name" to "parentname"
            foreach ($e in $ExcludeProperty) {
                $propertyNames = $propertyNames.where({ $_ -notlike $e })
            }
            if (!$Vars) {
                $Vars = $propertyNames
                foreach ($i in $Id) { $Vars = $Vars.where({ $_ -notlike $i }) }
            }
            $oldProps = $newprops
        }
        <#
            if we loop by columns (vars then records), we need to re-create the hash table every time. 
            by rows (records the vars) we only create a new one once per row
        #>
        foreach ($record in $InputObject) {
            $h = [ordered]@{}
            foreach ($idItem in $Id) { $h[$idItem] = $record.$idItem }
            foreach ($var in $Vars) {
                $h[$VarName] = $var
                $h[$ValueName] = $record.$var
                [pscustomobject]$h
            }
        }
    }
}