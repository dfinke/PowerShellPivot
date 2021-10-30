# In mathematical terms, variance is the calculation of how far a set of values is from the average value (the mean)
class UpperQuartile : BaseStats {
    hidden [double[]]$numList

    UpperQuartile() {}
    UpperQuartile([double]$n) { $this.numList = $n }
    
    AddToMeasure([double]$n) {
        $this.numList += $n
    }

    [double]Result() {
        return [MathNet.Numerics.Statistics.Statistics]::UpperQuartile($this.numList)
    }
}