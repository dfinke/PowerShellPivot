# The reciprocal of the arithmetic mean of the reciprocals of the given set of observations
class HarmonicMean : BaseStats {
    hidden [double[]]$numList

    HarmonicMean() {}
    HarmonicMean([double]$n) { $this.numList = $n }
    
    AddToMeasure([double]$n) {
        $this.numList += $n
    }

    [double]Result() {
        return [MathNet.Numerics.Statistics.Statistics]::HarmonicMean($this.numList)
    }
}