# The sum of the data divided by the number of data points
class Average : BaseStats {
    hidden $Sum
    hidden $Count

    Average() {}
    Average([double]$n) { 
        $this.Sum = $n
        $this.Count = 1 
    }
    
    AddToMeasure([double]$n) {
        if ([double]::IsNaN($n) -eq $false) {
            $this.sum = $this.ConvertNaNToNumber($this.sum) 
            $this.sum += $n
        }
     
        $this.count++
    }

    [double]Result() {
        return [math]::Round($this.sum / $this.count, 3)
    }
}