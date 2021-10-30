function doFmt {
    param([hashtable]$target)        
    $(
        foreach ($entry in $target.GetEnumerator()) {
            $hash = [ordered]@{$index[0] = $entry.Key }

            foreach ($valueEntry in $entry.Value.GetEnumerator()) {
                $hash[$valueEntry.Key] = $valueEntry.Value.Result()
            }

            [PSCustomObject]$hash
        }   
    ) | Sort-Object -Property $index[0]
}