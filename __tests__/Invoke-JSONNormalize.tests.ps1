Import-Module "$PSScriptRoot/../PowerShellPivot.psd1" -Force

Describe "Tests Get AggregateFunctionNames" -Tag InvokeJSONNormalize {
    BeforeAll {
        $tvShows = Get-Content $PSScriptRoot\tv_shows.json | ConvertFrom-JSON
        $tvShows = $tvShows.shows
    }

    It 'Should have 3 shows' {
        $tvShows.Count | Should -Be 3    
    }

    It 'Should normalize to 3 shows' {
        $actual = Invoke-JSONNormalize -data $tvShows
        $actual.Count | Should -Be 3
        
        $actual[0].show | Should -Be 'The X-Files'
        $actual[1].show | Should -Be 'Lost'
        $actual[2].show | Should -Be 'Buffy the Vampire Slayer'

        $actual[0].episodes.Count | Should -Be 218
        $actual[1].episodes.Count | Should -Be 121
        $actual[2].episodes.Count | Should -Be 143
    }

    It 'Should return top level fields' {
        $actual = Invoke-JSONNormalize -data $tvShows -meta @('name', 'network')
        $actual.Count | Should -Be 3
 
        $actual[0].episodes.Count | Should -Be 218
        $actual[1].episodes.Count | Should -Be 121
        $actual[2].episodes.Count | Should -Be 143
    }
   
    It 'Should flatten the data' {
        $actual = Invoke-JSONNormalize -data $tvShows -recordPath episodes

        $actual.Count | Should -Be 482

        $actual[0].season | Should -Be 1
        $actual[0].episode | Should -Be 1
        $actual[0].name | Should -Be 'Pilot'
        $actual[0].air_date | Should -Be '1993-09-11 01:00:00'

        $actual[5].season | Should -Be 1
        $actual[5].episode | Should -Be 6
        $actual[5].name | Should -Be 'Shadows'
        $actual[5].air_date | Should -Be '1993-10-23 01:00:00'
    }

    It 'Should flatten the data and add the meta' {
        $actual = Invoke-JSONNormalize -data $tvShows -recordPath episodes -meta @("show", "runtime", "network")

        $actual.Count | Should -Be 482

        $actual[0].season | Should -Be 1
        $actual[0].episode | Should -Be 1
        $actual[0].name | Should -Be 'Pilot'
        $actual[0].air_date | Should -Be '1993-09-11 01:00:00'
        $actual[0].show | Should -Be 'The X-Files'
        $actual[0].runtime | Should -Be '60'
        $actual[0].network | Should -Be 'FOX'
 
        $actual[5].season | Should -Be 1
        $actual[5].episode | Should -Be 6
        $actual[5].name | Should -Be 'Shadows'
        $actual[5].air_date | Should -Be '1993-10-23 01:00:00'
        $actual[5].show | Should -Be 'The X-Files'
        $actual[5].runtime | Should -Be '60'
        $actual[5].network | Should -Be 'FOX'
    }

    It 'Should return data with multiple calls' {
        $actual = Invoke-JSONNormalize -data $tvShows -recordPath episodes -meta network
        $actual = Invoke-JSONNormalize -data $tvShows -recordPath episodes -meta network, show

        $actual.Count | Should -Be 482
    }

    It "Should not have a network property on the second call" {
        $actual = Invoke-JSONNormalize -data $tvShows -recordPath episodes -meta network
        $actual = Invoke-JSONNormalize -data $tvShows -recordPath episodes 

        $names = $actual[0].psobject.Properties.Name
        $names.Count | Should -Be 4
        $names -eq 'network' | Should -BeNullOrEmpty
    }
}