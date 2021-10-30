# Returns the element from the list with maximum value
class Max : BaseStats {
    hidden [double[]]$numList = @()

    Max() {}
    Max([double]$n) { $this.numList += $n }
    
    AddToMeasure([double]$n) {
        $this.numList += $n
    }

    [double]Result() {
        return [MathNet.Numerics.Statistics.Statistics]::Maximum($this.numList)
    }
}