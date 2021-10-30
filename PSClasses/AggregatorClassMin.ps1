# Returns the element from the list with minimum value
class Min : BaseStats {
    hidden [double[]]$numList = @()

    Min() {}
    Min([double]$n) { $this.numList += $n }
    
    AddToMeasure([double]$n) {
        $this.numList += $n
    }

    [double]Result() {
        return [MathNet.Numerics.Statistics.Statistics]::Minimum($this.numList)
    }
}