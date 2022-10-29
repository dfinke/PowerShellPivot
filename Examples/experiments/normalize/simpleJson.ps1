$s = @"
{
    "A": {
        "A": 1,
        "B": 2
    }
}
"@

$r = ConvertFrom-Json -InputObject $s 
$r.A.GetType()