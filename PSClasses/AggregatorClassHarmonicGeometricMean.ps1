# The geometric mean indicates the central tendency or typical value of the data using the product of the values (as opposed to the arithmetic mean which uses their sum)
class GeometricMean : BaseStats {
    hidden [double[]]$numList

    GeometricMean() {}
    GeometricMean([double]$n) { $this.numList = $n }
    
    AddToMeasure([double]$n) {
        $this.numList += $n
    }

    [double]Result() {
        return [MathNet.Numerics.Statistics.Statistics]::GeometricMean($this.numList)
    }
}