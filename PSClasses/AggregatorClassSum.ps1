# Return the sum fof the list of numbers
class Sum : BaseStats {
    hidden $Sum

    Sum() {}
    Sum([double]$n) { 
        $this.Sum = $n 
    }
    
    AddToMeasure([double]$n) {
        # $this.sum += $n
        if ([double]::IsNaN($n) -eq $false) {
            $this.sum = $this.ConvertNaNToNumber($this.sum) 
            $this.sum += $n
        }

    }

    [double]Result() {
        return $this.sum
    }
}