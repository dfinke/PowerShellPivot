# Variance is the calculation of how far a set of values is from the average value (the mean)
class Variance : BaseStats {
    hidden [double[]]$numList

    Variance() {}
    Variance([double]$n) { $this.numList = $n }
    
    AddToMeasure([double]$n) {
        $this.numList += $n
    }

    [double]Result() {
        return [MathNet.Numerics.Statistics.Statistics]::Variance($this.numList)
    }
}