# Calculate the entropy of a distribution for given probability values
class Entropy : BaseStats {
    hidden [double[]]$numList

    Entropy() {}
    Entropy([double]$n) { $this.numList = $n }
    
    AddToMeasure([double]$n) {
        $this.numList += $n
    }

    [double]Result() {
        return [MathNet.Numerics.Statistics.Statistics]::Entropy($this.numList)
    }
}