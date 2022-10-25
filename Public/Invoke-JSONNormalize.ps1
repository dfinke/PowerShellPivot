function Invoke-JSONNormalize {
    <#
        .SYNOPSIS
        Normalize semi-structured JSON data into a flat table
    #>
    param(
        # Unserialized JSON objects
        $data,
        # Path in each object to list of records. If not passed, data will be assumed to be an array of records
        $recordPath,
        # Fields to use as metadata for each record in resulting table
        [string[]]$meta
    )

    if (!$PSBoundParameters.ContainsKey('recordPath')) {
        $data
    }
    else {        
        foreach ($topLevel in $data) {
            foreach ($record in $topLevel.$recordPath) {
                # PSCustomObject does not support the Clone() method
                # Need to copy the object to avoid modifying the original
                $newRecord = $record.psobject.Copy()

                foreach ($metaItem in $meta) {
                    $newRecord | Add-Member -MemberType NoteProperty -Name $metaItem -Value $topLevel.$metaItem -Force
                }
                $newRecord
            }
        }
    }
}
