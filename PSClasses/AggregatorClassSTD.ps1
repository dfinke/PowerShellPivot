# The square root of the sample variance
class STD : BaseStats {
    hidden $Sum

    STD() {}
    STD([double]$n) {        
        $this.Sum += @($n)
    }

    AddToMeasure([double]$n) {
        $this.Sum += @($n)
    }
    
    [double]Result() {
        $s = 0
        foreach ($num in $this.Sum) { $s += $num }
                
        $average = $s / $this.Sum.Count

        $sumOfDerivation = 0
        foreach ($num in $this.Sum) { $sumOfDerivation += $num * $num }
        
        $sumOfDerivationAverage = $sumOfDerivation / $this.Sum.Count 

        $std = [math]::Sqrt($sumOfDerivationAverage - ($average * $average))
        
        return [math]::Round($std, 5)
    }
}