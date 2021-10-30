# The sum of the data divided by the number of data points
class Mean : BaseStats {
    hidden [double[]]$numList

    Mean() {}
    Mean([double]$n) { $this.numList = $n }
    
    AddToMeasure([double]$n) {
        $this.numList += $n
    }

    [double]Result() {
        return [MathNet.Numerics.Statistics.Statistics]::Mean($this.numList)
    }
}