# Update-TypeData -Force -TypeName System.Array -MemberType ScriptMethod -MemberName DTypes -Value {
#     Get-DataType $this
# }

# Update-TypeData -Force -TypeName System.Array -MemberType ScriptMethod -MemberName Head -Value {
#     <#
#         .Synopsis
#         This function returns the first n rows for the object based on position. It is useful for quickly testing if your object has the right type of data in it.
#     #>
#     param($numberOfRows = 5)

#     $this[0..($numberOfRows - 1)]
# }

# Update-TypeData -Force -TypeName System.Array -MemberType ScriptMethod -MemberName Tail -Value {
#     <#
#         .Synopsis
#         This function returns last n rows from the object based on position. It is useful for quickly verifying data, for example, after sorting or appending rows.
#     #>
#     param($numberOfRows = 5)

#     $this[  (-$numberOfRows)..-1]
# }

# Update-TypeData -Force -TypeName System.Array -MemberType ScriptMethod -MemberName Info -Value {
#     Get-DataInfo $this
# }