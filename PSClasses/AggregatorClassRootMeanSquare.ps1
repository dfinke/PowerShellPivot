# The square root of the mean square
class RootMeanSquare : BaseStats {
    hidden [double[]]$numList

    RootMeanSquare() {}
    RootMeanSquare([double]$n) { $this.numList = $n }
    
    AddToMeasure([double]$n) {
        $this.numList += $n
    }

    [double]Result() {
        return [math]::Round([MathNet.Numerics.Statistics.Statistics]::RootMeanSquare($this.numList), 3)
    }
}