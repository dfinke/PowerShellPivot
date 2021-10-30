# The midpoint of a frequency distribution of observed values
class Median : BaseStats {
    hidden [double[]]$numList

    Median() {}
    Median([double]$n) { $this.numList = $n }
    
    AddToMeasure([double]$n) {
        $this.numList += $n
    }

    [double]Result() {
        return [MathNet.Numerics.Statistics.Statistics]::Median($this.numList)
    }
}