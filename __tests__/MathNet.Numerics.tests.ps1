Import-Module "$PSScriptRoot/../PowerShellPivot.psd1" -Force

<#
Covariance                   GeometricMean                Mean                         OrderStatistic               PopulationStandardDeviation  Ranks
EmpiricalCDF                 HarmonicMean                 MeanStandardDeviation        OrderStatisticFunc           PopulationVariance           ReferenceEquals
EmpiricalCDFFunc             InterquartileRange           MeanVariance                 Percentile                   Quantile                     RootMeanSquare
EmpiricalInvCDF              Kurtosis                     Median                       PercentileFunc               QuantileCustom               Skewness
EmpiricalInvCDFFunc          LowerQuartile                Minimum                      PopulationCovariance         QuantileCustomFunc           SkewnessKurtosis
Entropy                      Maximum                      MinimumAbsolute              PopulationKurtosis           QuantileFunc                 StandardDeviation
Equals                       MaximumAbsolute              MinimumMagnitudePhase        PopulationSkewness           QuantileRank                 UpperQuartile
FiveNumberSummary            MaximumMagnitudePhase        MovingAverage                PopulationSkewnessKurtosis   QuantileRankFunc             Variance
#>
Describe "Tests Math.Numerics integration" -Tag "MathNumerics" {
    BeforeEach {
        [double[]]$script:numList = @(1, 2, 3, 4, 5)
    }

    It "Tests Minimum" {
        [MathNet.Numerics.Statistics.Statistics]::Minimum($numList) | Should -Be 1
    }

    It "Tests Maximum" {
        [MathNet.Numerics.Statistics.Statistics]::Maximum($numList) | Should -Be 5
    }

    It "Tests Mean" {
        [MathNet.Numerics.Statistics.Statistics]::Mean($numList) | Should -Be 3
    }
}