class BaseStats {
    BaseStats() {}
    
    AddToMeasure([double]$n) {
        throw "[$this] class must implement this method"        
    }
    
    [double]Result() {
        throw "[$this] class must implement this method"        
    }

    [double]ConvertNaNToNumber([double]$n) {
        if ([double]::IsNaN($n)) {
            return 0
        }

        return $n
    }
}

$script:list = $null
function Get-AggregateFunctionNames {
    if ($null -eq $list) {
        $list = (
            Get-ChildItem "$PSScriptRoot\PSClasses\" agg*.ps1 | 
            Select-String class | 
            ForEach-Object line
        ) -replace 'class | : BaseStats {', ''
    
        $list += "AllStats"
    }

    $list
}

Register-ArgumentCompleter -CommandName New-PSPivotTable -ParameterName aggregateFunction -ScriptBlock {
    foreach ($aggregateFunction in Get-AggregateFunctionNames | Sort-Object) {        
        [System.Management.Automation.CompletionResult]::new($aggregateFunction, $aggregateFunction, 'ParameterValue', $aggregateFunction)
    }
}

Add-Type -Path "$PSScriptRoot\lib\MathNet.Numerics.dll"

# import everything we need
foreach ($directory in @('PSClasses', 'Private', 'Public')) {
    Get-ChildItem -Path "$PSScriptRoot\$directory\*.ps1" | ForEach-Object { . $_.FullName }
}

Set-Alias psp New-PSPivotTable
Set-Alias psm Invoke-PSMelt