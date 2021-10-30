# The sum of the data divided by the number of data points
class Average : BaseStats {
    hidden [double[]]$numList

    Average() {}
    Average([double]$n) { $this.numList = $n }
    
    AddToMeasure([double]$n) {
        $this.numList += $n
    }

    [double]Result() {        
        $result = [MathNet.Numerics.Statistics.Statistics]::Mean($this.numList)
        return [Math]::Round($result, 3)
    }
}
