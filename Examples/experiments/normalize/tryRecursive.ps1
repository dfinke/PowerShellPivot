# # https://lonewolfonline.net/simple-directory-listing/#:~:text=Recursive%20directory%20listing%20in%20C%23%20and%20get%20a,one%20parameter%2C%20the%20directory%20to%20start%20looking%20in.

$json = @"
{
    'school': 'ABC primary school',
    'location': 'London',
    'ranking': 2,
    'info': {
        'president': 'John Kasich',
        'contacts': {
          'email': {
              'admission': 'admission@abc.com',
              'general': 'info@abc.com'
          },
          'tel': '123456789',
      }
    }
}
"@

function theListing {
    param(
        $target,
        $name
    )

    $result = New-Object System.Collections.ArrayList

    $valueTypes = $target.psobject.properties.name | Where-Object { $target.$_ -isnot [pscustomobject] -and $target.$_ -isnot [array] } | ForEach-Object { $_ }

    $customObjects = $target.psobject.properties.name | Where-Object { $target.$_ -is [pscustomobject] -or $target.$_ -is [array] } | ForEach-Object { $_ }

    foreach ($vt in $valueTypes) {
        if ($name) {
            $keyName = "{0}.{1}" -f $name, $vt
        }
        else {
            $keyName = $vt
        }
        
        $null = $result.add(@{ "$keyName" = $target.$vt })
    }

    foreach ($co in $customObjects) {
        if (!$name) {
            $name = $co
        }
        else {
            $name = "{0}.{1}" -f $name, $co
        }

        theListing $target.$co $name
        $name = $null
    }

    return $result
}

function Invoke-Normalize {
    param(
        $target
    )

    $result = theListing $target

    $final = [ordered]@{}

    foreach ($item in $result) {
        $final += $item
    }

    [PSCustomObject]$final
}

# $data = ConvertFrom-Json -InputObject $json
# Clear-Host
# Invoke-Normalize $data

# $d = Get-Content $PSScriptRoot\tv_shows.json | convertfrom-json
# Invoke-Normalize ($d.shows | Select-Object -first 1 )

# $d = Get-Content $PSScriptRoot\SimpleRecords.json | ConvertFrom-Json
# Invoke-Normalize $d
# return 
$s = @"
{
    "A": {
        "A": 1,
        "B": 2
    },
    "B": {
        "A": 3,
        "B": 4
    },
    "C": {
        "A": 5,
        "B": 6
    },
    "D": {
        "A": 7,
        "B": 8,
        "E": {
            "A": 9,
            "B": 10
        }
    }
}
"@

$r = ConvertFrom-Json -InputObject $s 
Invoke-Normalize $r | Format-Table