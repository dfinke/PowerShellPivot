# The middle number between the smallest number and the median
class LowerQuartile : BaseStats {
    hidden [double[]]$numList

    LowerQuartile() {}
    LowerQuartile([double]$n) { $this.numList = $n }
    
    AddToMeasure([double]$n) {
        $this.numList += $n
    }

    [double]Result() {
        return [MathNet.Numerics.Statistics.Statistics]::LowerQuartile($this.numList)
    }
}