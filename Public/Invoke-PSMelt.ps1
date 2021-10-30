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
    
    Process {
        if ($null -eq $InputObject) {
            return $null
        }
        
        $propertyNames = $InputObject[0].psobject.Properties.name
        if ($ExcludeProperty) {
            $propertyNames = $propertyNames -notmatch ($ExcludeProperty -join '|')
        }

        if (!$Id -and !$Vars) {
            $Vars = $propertyNames
        } 
        elseif ($Id -and !$Vars) {
            $Vars = $propertyNames -notmatch ($id -join '|')
        }        

        foreach ($var in $Vars) {
            foreach ($record in $InputObject) {
                $h = [ordered]@{}
                
                foreach ($idItem in $Id) {                    
                    $h["$($idItem)"] = $record.$idItem
                }

                $h[$VarName] = $var
                $h[$ValueName] = $record.$var
                [pscustomobject]$h
            }
        }
    }
}