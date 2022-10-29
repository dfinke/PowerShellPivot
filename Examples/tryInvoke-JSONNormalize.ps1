$tvShowsJson = ConvertFrom-Json @"
{
	"shows": [{
		"show": "The X-Files",
		"runtime": 60,
		"network": "FOX",
		"episodes": [{
				"season": 1,
				"episode": 1,
				"name": "Pilot",
				"air_date": "1993-09-11 01:00:00"
			},
			{
				"season": 1,
				"episode": 4,
				"name": "Conduit",
				"air_date": "1993-10-02 01:00:00"
			}
		]
	}]
}
"@

<#
Parameters
# Unserialized JSON objects
$data

# Path in each object to list of records. If not passed, data will be assumed to be an array of records
$recordPath
# Fields to use as metadata for each record in resulting table

$meta
#>

Invoke-JSONNormalize -data $tvShowsJson.shows -recordPath episodes -meta @("show", "runtime", "network")

<#
season episode name    air_date            show        runtime network
------ ------- ----    --------            ----        ------- -------
     1       1 Pilot   1993-09-11 01:00:00 The X-Files      60 FOX
     1       4 Conduit 1993-10-02 01:00:00 The X-Files      60 FOX
#>