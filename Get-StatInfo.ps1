$(
    @"
|Name|Description|
|---|---|
"@

    Get-ChildItem ./PSClasses agg*.ps1 | ForEach-Object {
        $comment, $name = Get-Content $_.FullName | Select-Object -First 2

        $Name = $name -replace 'class | : BaseStats {', ''
        $Comment = $comment.Substring(1).Trim()
        "|{0}|{1}|" -f $name, $comment
    } ) 