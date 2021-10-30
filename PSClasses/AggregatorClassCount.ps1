# Returns the number of elements in the list
class Count : BaseStats {
    hidden $Count

    Count() {
        $this.count++
    }
    
    Count([double]$n) {
        $this.count++
    }
    
    AddToMeasure([double]$n) {
        $this.count++
    }

    [double]Result() {
        return $this.count
    }
}
