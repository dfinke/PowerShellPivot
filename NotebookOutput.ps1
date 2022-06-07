<#
  Thank you to James O'Neill for contributing this script.
  Some really cool functions that can take your PowerShell .NET Interative notebooks to the next level.
#>

using namespace "Microsoft.DotNet.Interactive"

function Write-Notebook {
  <#
      .SYNOPSIS
        Writes to  the output part of the current cell (a streamlined version of Out-Display)

      .PARAMETER Html
        Output to be sent as Hmtl

      .PARAMETER Text
        Output to be sent as plain text

      .PARAMETER PassThru
        If specified returns the output object, allowing it to be updated.

      .EXAMPLE
        > $statusMsg = Write-Notebook -PassThru -text  "Step 1"
        > ...
        > $statusmsg.update("Step2")

        Displays and updates text in the current cell output

      .EXAMPLE
        >  $PSVersionTable | ConvertTo-Html -Fragment | Write-Notebook

        Converts $psversionTable to a table and displays it. Without Write-Notebook the HTML markup would appear.
    #>
  [cmdletbinding(DefaultParameterSetName = 'Html')]
  param   (
    [parameter(Mandatory = $true, ParameterSetName = 'Html', ValueFromPipeline = $true, Position = 1 )]
    $Html,

    [parameter(Mandatory = $true, ParameterSetName = 'Text')]
    $Text,

    [Alias('PT')]
    [switch]$PassThru
  )
  begin { $htmlbody = @() }
  process { if ($html) { $htmlbody += $Html } }
  end {
    if ($htmlbody.count -gt 0) { $result = [Kernel]::display([Kernel]::HTML($htmlbody), 'text/html') }
    if ($Text) { $result = [Kernel]::display($Text, 'text/plain') }
    if ($PassThru) { return $result }
  }
}

function ConvertTo-Grid {
  param   (
    [parameter(ValueFromPipeline = $true, Position = 0, Mandatory = $true)]
    $InputObject,

    # .Net formatting string to apply to floating point numbers; default is N2 i.e. #,###.00
    [string]$FloatFormat = 'N2',

    # .Net formatting string to apply to integers; default is N0 i.e. #,###
    [string]$IntFormat = 'N0',

    #A title to appear above the grid, centred in H1 style
    [string]$TitleText,

    #css for the grid background and padding: default is middle grey and 5 pixels padding
    [string]$GridStyle = 'background-color: #7f7f7f; padding: 5px;',

    #css for alternating light and dark rows. to remove dark rows use an empty string
    [string]$DarkRowStyle = 'background-color: rgba(255, 255, 255, 0.8);',

    #css for normal cells in the grid
    [string]$ItemStyle = 'text-align: center; background-color: white; border: 1px solid rgba(0, 0, 0, 0.8); padding: 8px; font-size: 16px;' ,

    #css for normal cells in the grid, default is left aligned, bold white text on black background,
    [string]$ColumnHeadingStyle = 'text-align: left;   background-color: black; color: white; font-weight: bold;',

    #css for normal cells in the grid
    [string]$RowLablelStyle = 'text-align: left;   background-color: black; color: white; font-weight: bold;',

    #Displays the grid in the output of the notebook cell, instead of returning the html
    [switch]$Display,

    #Specifies the properties to select. Wildcards are permitted.
    [Parameter(Position = 1)]
    $Property,

    #Specifies the properties that the selection process excludes from the operation. Wildcards are permitted.
    $ExcludeProperty,

    #Specifies that if a subset of the input objects has identical properties and values, only a single member of the subset will be selected. Unique selects values after other filtering parameters are applied.
    [switch]$Unique,

    #Specifies the number of objects to select from the end of an array of input objects.
    [int32]$Last,

    #Specifies the number of objects to select from the beginning of an array of input objects.
    [int32]$First,

    #Skips (does not select) the specified number of items. By default, the Skip parameter counts from the beginning of the array or list of objects, but if the command uses the Last parameter, it counts from the end of the list or array.
    [int32]$Skip
  )
  begin {
    $rows = @()
    $html = @('<style>' , "    .grid-container {display: grid; grid-template-columns: auto auto auto; $gridStyle}" ,
      "    .grid-item {$ItemStyle}", '</style>') -join "`r`n"
  }
  process { $rows += $InputObject }
  end {
    if ($rows.count -eq 0) { return }

    $selectParams = @{}
    foreach ($param in @( 'Property', 'ExcludeProperty', 'Unique', 'Last', 'First', 'Skip')) {
      if ($PSBoundParameters.ContainsKey($param)) { $selectParams[$param] = $PSBoundParameters[$param] }
    }
    if ($selectParams.Count -ge 1) { $rows = $rows | Select-Object @selectParams }

    $properties = $rows[0].psobject.Properties.name

    if ($TitleText) {
      $html += "`r`n<center><h1>$TitleText</h1></center>"
    }
    $html += "`r`n<div class=`"grid-container`" style=`"grid-template-columns:$(' auto' * $properties.Count);`" >"
    foreach ($p in $properties) {
      $html += "`r`n     <div class=`"grid-item`" style=`"$ColumnHeadingStyle`">$p</div>"
    }
    $html += "`r`n"
    $rowcount = 0
    foreach ($r in $rows) {
      $rowstyle = $rowcount ++ % 2 ? $DarkRowStyle : ""
      foreach ($p in $properties) {
        if ($null -eq $r.$p) {
          $html += "`r`n     <div class=`"grid-item`" style=`"$rowstyle`"></div>"
          continue
        }
        if ($r.$p.GetType().name -match 'int') {
          $itemStyle = $rowstyle + "text-align: right;"; $itemText = $r.$p.tostring($IntFormat)
        }
        elseif ($r.$p -is [Single] -or
          $r.$p -is [double]) { $itemStyle = $rowstyle + "text-align: right;"; $itemText = $r.$p.tostring($FloatFormat) }
        elseif ($r.$p -is [boolean]) { $itemStyle = $rowstyle + "text-align: center;"; $itemText = $r.$p.tostring() }
        elseif ($r.$p -is [enum]) { $itemStyle = $rowstyle + "text-align: left;"; $itemText = $r.$p.tostring() }
        elseif ($r.$p -is [ValueType]) { $itemStyle = $rowstyle + "text-align: right;"; $itemText = $r.$p.tostring() }
        elseif ($r.$p -is [string]) { $itemStyle = $rowstyle + "text-align: left;"; $itemText = $r.$p }
        elseif ($r.$p -is [string]) { $itemStyle = $rowstyle + "text-align: left;"; $itemText = $r.$p.toString() }
        $html += "`r`n     <div class=`"grid-item`" style=`"$itemStyle`">$itemText</div>"
      }
      $html += "`r`n"
    }
    $html += "</div>"
    if ($Display) { Write-Notebook -Html $html }
    else { $html }
  }
}

function Out-Cell {
  <#
      .SYNOPSIS
        Outputs a notebook cell - takes a script block, or html or objects to format as a list/table

      .DESCRIPTION
        This command has four ways of working. It can
        * Take HTML (via the pipeline or as a parameter) and output it into a cell
        * Make an HTML grid, table or list from objects, selecting properties, first, last etc.
        * Render objects as text (using Out-String)
        * Take a script block to generate html or objects to transform to a list/table

      .PARAMETER InputObject
        Specifies the objects to format, or HTML or a script block to excecute to generate the rquired output

      .PARAMETER AsGrid
        Specifies the object sould be output as an HTML grid (this uses ConvertTo-Grid )

      .PARAMETER GridOption
        Specifies additional options for ConvertTo-Grid when using -AsGrid

      .PARAMETER AsList
        Specifies the object sould be output as an HTML list (this uses ConvertTo-Html -Fragment -As "Grid" internaly)

      .PARAMETER AsTable
        Specifies the object sould be output as an HTML table (this uses ConvertTo-Html -Fragment -As Table internaly)

      .PARAMETER AsText
        Specifies the object sould be output as text (Similar to using Out-String, optionally combined with select-object)

      .PARAMETER Property
        Specifies the properties to select. Wildcards are permitted. Property, ExcludeProperty, Unique, Last, First and Skip work as they do with Select-Object (the function calls Select-object with these parameters),

      .PARAMETER ExcludeProperty
        Specifies the properties that the selection process excludes from the operation. Wildcards are permitted.

      .PARAMETER Unique
        Specifies that if a subset of the input objects has identical properties and values, only a single member of the subset will be selected. Unique selects values after other filtering parameters are applied.

      .PARAMETER Last
        Specifies the number of objects to select from the end of an array of input objects.

      .PARAMETER First
        Specifies the number of objects to select from the beginning of an array of input objects.

      .PARAMETER Skip
        Skips (does not select) the specified number of items. By default, the Skip parameter counts from the beginning of the array or list of objects, but if the command uses the Last parameter, it counts from the end of the list or array.


      .EXAMPLE
        > Get-command -Module  Microsoft.DotNet.Interactive.PowerShell | Out-Cell -AsTable -Property name,version

        Takes CommandInfo objects and displays their name and version as an HTML Table
        ---------------------------
        | Name	        | Version |
        ---------------------------
        | Enter-AzShell | 0.1.0   |
        | Out-Display	| 0.1.0   |
        ---------------------------


      .EXAMPLE
        > Get-command -Module  Microsoft.DotNet.Interactive.PowerShell | Out-Cell -AsText -Property name,version

        Renders the output as console-style text
            Name          Version
            ----          -------
            Enter-AzShell 0.1.0
            Out-Display   0.1.0

      .EXAMPLE
        > Cell { Get-command -Module  Microsoft.DotNet.Interactive.PowerShell } -AsList name,version

        Similar to the previous object this uses the alias "cell" and uses a script block to create
        the objects and formats their name and version as an HTML List
        ----------------------------
        | Name:    | Enter-AzShell |
        | Version: | 0.1.0         |
        ----------------------------
        | Name:	   | Out-Display   |
        | Version: |	0.1.0      |
        ----------------------------

      .EXAMPLE
        > cell  {plot_pipeline FollowOn.pipeline.yml  -DestinationPath "" }

        In this example, `plot_pipeline` reads a yml file and draws a simple SVG graph.
        Out-cell will assume the script block is creating HTML because it has not been told  as a list, table or grid
    #>
  [cmdletbinding(DefaultParameterSetName = "Default")]
  [alias("cell")]
  param   (
    [Parameter(ParameterSetName = 'Default', Mandatory = $true, Position = 0, ValueFromPipeline = $true )]
    [Parameter(ParameterSetName = 'List', Mandatory = $true, Position = 0, ValueFromPipeline = $true )]
    [Parameter(ParameterSetName = 'Table', Mandatory = $true, Position = 0, ValueFromPipeline = $true )]
    [Parameter(ParameterSetName = 'Grid', Mandatory = $true, Position = 0, ValueFromPipeline = $true )]
    [Parameter(ParameterSetName = 'Text', Mandatory = $true, Position = 0, ValueFromPipeline = $true )]
    $InputObject,

    [Parameter(ParameterSetName = 'List', Mandatory = $true)]
    [Alias('List')]
    [switch]$AsList,

    [Parameter(ParameterSetName = 'Table', Mandatory = $true)]
    [Alias('Table')]
    [switch]$AsTable,

    [Parameter(ParameterSetName = 'Grid', Mandatory = $true)]
    [switch]$AsGrid,

    [Parameter(ParameterSetName = 'Grid')]
    [hashtable]$GridOptions,

    [Parameter(ParameterSetName = 'Text', Mandatory = $true)]
    [Alias('Text')]
    [switch]$AsText,

    [Parameter(ParameterSetName = 'Grid' , Position = 1)]
    [Parameter(ParameterSetName = 'List' , Position = 1)]
    [Parameter(ParameterSetName = 'Table', Position = 1)]
    [Parameter(ParameterSetName = 'Text' , Position = 1)]
    $Property,

        [Parameter(ParameterSetName='Grid')]
        [Parameter(ParameterSetName='List')]
        [Parameter(ParameterSetName='Table')]
        [Parameter(ParameterSetName='Text')]
        [string[]]$ExcludeProperty,

        [Parameter(ParameterSetName='Grid')]
        [Parameter(ParameterSetName='List')]
        [Parameter(ParameterSetName='Table')]
        [Parameter(ParameterSetName='Text')]
        [int32]$First,

        [Parameter(ParameterSetName='Grid')]
        [Parameter(ParameterSetName='List')]
        [Parameter(ParameterSetName='Table')]
        [Parameter(ParameterSetName='Text')]
        [int32]$Last,

        [Parameter(ParameterSetName='Grid')]
        [Parameter(ParameterSetName='List')]
        [Parameter(ParameterSetName='Table')]
        [Parameter(ParameterSetName='Text')]
        [int32]$Skip,

        [switch]$PassThru
    )
    begin   {
            $data = @()
    }
    process {
        if ($InputObject -is [scriptblock]) {
                $data += Invoke-Command -ScriptBlock $InputObject
        }
        else {  $data += $InputObject }
    }
    end     {
        # if we're not told to render as something assume we've recieved HTML
        if (-not ($AsGrid -or $AsList -or $AsTable -or $AsText)) {
                $html = $data -join ""
        }
        else {
            $selectParameterNames = @("First","Last","Skip","Property","ExcludeProperty")
            if ($PSBoundParameters[$selectParameterNames]) {
                $selectParams = @{}
                foreach ($p in $selectParameterNames.Where({$PSBoundParameters.ContainsKey($_)})) {
                    $selectParams[$p]=$PSBoundParameters[$p]
                }
                $data = $data | Select-Object @selectParams
            }
            if ($GridOptions) {$html = $data | ConvertTo-Grid @GridOptions}
            elseif  ($AsGrid) {$html = $data | ConvertTo-Grid }
            elseif  ($AsList) {$html = $data | ConvertTo-Html -Fragment -As "List"}
            elseif ($AsTable) {$html = $data | ConvertTo-Html -Fragment -As "Table"}
            elseif  ($AsText) {
                $t = $data | Out-String
                Write-Notebook -Text $t.Trim() -PassThru:$PassThru
                return
            }
        }
        Write-Notebook -Html $html -PassThru:$PassThru
    }
}

function Write-Progress {
    <#
      .SYNOPSIS
        Notebook friendly replacement for the Write-Progress cmdlet. Similar to the "Minimal" view implemented in PowerShell 7.2
    #>
    param (
        [Parameter(Mandatory=$true,position = 0)]
        [string]$Activity,
        [Parameter(position = 1)]
        [string]$Status,
        [string]$CurrentOperation,
        [int]$PercentComplete,
        [int]$SecondsRemaining,
        [switch]$Completed
    )
    if ($status)           {$bar  = "{0,-100}"  -f $Status}
    else                   {$bar  = "{0,-100}"  -f $CurrentOperation} #even if it is empty!
    if ($PercentComplete)  {$bar  = $PSStyle.Background.blue + $PSStyle.Foreground.BrightWhite +
                                    ($bar -replace "(?<=^.{$percentComplete})", ($PSStyle.Reset + $PSStyle.Foreground.blue))
    }
    if ($SecondsRemaining) {$bar += $SecondsRemaining.tostring("0s") }
    if ($Completed)        {$bar  = ' '}
    else                   {$bar  = $PSStyle.Foreground.blue + $Activity +  "[" + $bar + "]" + $PSStyle.Reset}

    if ($global:ProgressBar -and $global:contextID -eq  [KernelInvocationContext]::Current.Command.Properties.id) {
        $global:ProgressBar.Update($bar)
    }
    else {
        $global:ProgressBar =  Write-Notebook -Text $bar -PassThru
        $global:contextID   =  [KernelInvocationContext]::Current.Command.Properties.id
    }
}

function Out-Mermaid    {
    <#
      .DESCRIPTION
        Accepts a mermaid chart definition as a parameter (example with the definition) or from the  pipeline
        and outputs the minimum correct HTML / Javascript but  **depends on the kernel extension being loaded**

        For examples see the mermaid home page at https://mermaid-js.github.io/mermaid/#/
        Has an alias of `Mermaid` it can be called in a more dsl-y style);

        .EXAMPLE
        ps >Mermaid @'
        sequenceDiagram
            participant Alice
            participant Bob
            Alice->>John: Hello John, how are you?
            loop Healthcheck
                John->>John: Fight against hypochondria
            end
            Note right of John: Rational thoughts <br/>prevail!
            John-->>Alice: Great!
            John->>Bob: How about you?
            Bob-->>John: Jolly good!
        '@

        Outputs a sample diagram found on the mermaid home page
    #>
    [alias('Mermaid')]
    param   (
        [parameter(ValueFromPipeline=$true,Mandatory=$true,Position=0)]
        $Text
    )
    begin   {
        $mermaid = ""
        $guid    = ([guid]::NewGuid().ToString() -replace '\W','')
        $html    = @"
<div style="background-color:white;"><script type="text/javascript">
loadMermaid_$guid = () => {(require.config({ 'paths': { 'context': '1.0.252001', 'mermaidUri' : 'https://colombod.github.io/dotnet-interactive-cdn/extensionlab/1.0.252001/mermaid/mermaidapi', 'urlArgs': 'cacheBuster=7de2aec4927849b5a989d2305cf957bc' }}) || require)(['mermaidUri'], (mermaid) => {let renderTarget = document.getElementById('$guid'); mermaid.render( 'mermaid_$guid', ``~~Mermaid~~``, g => {renderTarget.innerHTML = g  });}, (error) => {console.log(error);});}
if ((typeof(require) !==  typeof(Function)) || (typeof(require.config) !== typeof(Function))) {
    let require_script = document.createElement('script');
    require_script.setAttribute('src', 'https://cdnjs.cloudflare.com/ajax/libs/require.js/2.3.6/require.min.js');
    require_script.setAttribute('type', 'text/javascript');
    require_script.onload = function() {loadMermaid_$guid();};
    document.getElementsByTagName('head')[0].appendChild(require_script);
}
else {loadMermaid_$guid();}
</script><div id="$guid"></div></div>
"@  }
    process {$Mermaid +=  ("`r`n" + $Text -replace '^[\r\n]+','' -replace '[\r\n]+$','') }
    end     {Write-Notebook -Html  ($html -replace  '~~Mermaid~~',$mermaid ) }
}

function Out-TreeView   {
    <#
      .SYNOPSIS
        Outputs a treeview to a notebook.

      .DESCRIPTION
        C# can show JSON as a tree view; this takes an input in a similar way to Format-Table and Creates the same HTML

      .PARAMETER InputObject
        Specifies the objects to format. Enter a variable that contains the objects, or type a command or expression that gets the objects.

      .PARAMETER Property
        Specifies the properties to select. Wildcards are permitted. Property, ExcludeProperty, Unique, Last, First and Skip work as they do with Select-Object (the function calls Select-object with these parameters),

      .PARAMETER ExcludeProperty
        Specifies the properties that the selection process excludes from the operation. Wildcards are permitted.

      .PARAMETER Display
        If specified the tree view will be displayed, otherwise it will will be returned as a HTML

      .PARAMETER Unique
        Specifies that if a subset of the input objects has identical properties and values, only a single member of the subset will be selected. Unique selects values after other filtering parameters are applied.

      .PARAMETER Last
        Specifies the number of objects to select from the end of an array of input objects.

      .PARAMETER First
        Specifies the number of objects to select from the beginning of an array of input objects.

      .PARAMETER Skip
        Skips (does not select) the specified number of items. By default, the Skip parameter counts from the beginning of the array or list of objects, but if the command uses the Last parameter, it counts from the end of the list or array.

      .PARAMETER TreeviewCss
        Replaces the default style sheet for formatting

      .PARAMETER TitleHtml
        The title to be included - formatted as HTML

      .EXAMPLE
        >  $Sales       = Import-Csv .\SalesByEmployee.csv
        >  Out-TreeView $sales.where({$_.name -eq 'Jim'}) -TitleHtml '<b>Jim</b>' -ExcludeProperty Name -Display

        Selects the sales for a single employee and displays
        > Jim
        Clicking the arrow expands this to
        \/ Jim
            ---------------------------------------------
            | Date	 | Customer	   | Revenue | Expenses |
            ---------------------------------------------
            | 1/1/20 | PaperGenius |    1864 |     1305 |
            | 2/2/20 | Money Corp. |    8278 |      462 |
            ---------------------------------------------

      .EXAMPLE
          > $groupby      = 'Name'
          > $groupedSales =  Import-Csv .\SalesByEmployee.csv | Group-object -Property $groupby
          > $subtrees     = foreach ($g in $groupedSales) {
          >      [pscustomobject]@{$groupBy =  (Out-TreeView $g.Group -TitleHtml $g.Name)}
          >  }
          >  $subtrees  | Out-TreeView -Title Sales -Display

           Here the sales are grouped and the for loop greates a subtree for each Name
           The subtrees are gathered together in a parent tree labelled sales.
           By specifying that each tree is "name" property of an object. (Which might have have other properties)
           When the Sales tree expands we have a column "Name" which contains trees like the ones in the first example
           Initiallly it displays
           >  Sales

           Clicking on the arrow expands this to
           \/ Sales
                  Name
               >  Alex
               >  Jim
               >  Phil

            Clicking one of the Name arrows expands to
           \/ Sales
                  Name
               >  Alex
               \/ Jim
                    ---------------------------------------------
                    | Date	 | Customer	   | Revenue | Expenses |
                    ---------------------------------------------
                    | 1/1/20 | PaperGenius |    1864 |     1305 |
                    | 2/2/20 | Money Corp. |    8278 |      462 |
                    ---------------------------------------------
               >  Phil

    #>
    param   (
        [Parameter(Position=0, ValueFromPipeline=$true, Mandatory=$true)]
        $InputObject,
        [string]$TitleHtml ='Tree view',
        [Parameter(Position=1)]
        $Property,
        $ExcludeProperty,
        [switch]$Display,
        [switch]$Unique,
        [int32]$Last,
        [int32]$First,
        [int32]$Skip,
        [string]$TreeviewCss
    )
    begin   {
        if ($ExcludeProperty -and -not $Property) {$Property = '*'}
        $rows = @()
        if (-not $PSBoundParameters.ContainsKey('$TreeviewCss')) { $treeViewCss = @'
<style id="dni-styles-JsonElement">
    .dni-code-hint { font-style: italic; overflow: hidden;  white-space: nowrap;}
    .dni-treeview  { white-space: nowrap; }
    .dni-treeview td { vertical-align: top;}
    details.dni-treeview {padding-left: 1em;}
</style>
'@ }}
    process { $rows += $InputObject}
    end     {
        $selectParams = @{}
        foreach ($param in @( 'Property', 'ExcludeProperty', 'Unique', 'Last', 'First', 'Skip')){
            if ($PSBoundParameters.ContainsKey($param)) {$selectParams[$param] = $PSBoundParameters[$param]}
        }
        if     ($selectParams.Count -ge 1) {$rows = $rows | Select-Object @selectParams }
        #using psobject.Properties we get them in the correct order, not alphabetically.
        $propNames   = $rows[0].psobject.Properties.name
        $outputHtml  = '<details class="dni-treeview"><summary><span class="dni-code-hint">{0}</span></summary><div><table>' -f $TitleHtml
        $outputHtml += "`r`n  <thead>`r`n    <tr>"
        foreach ($p in $propNames) {$outputHtml += "<td>$p</td>"}
        $outputHtml += "</tr>`r`n  </thead>`r`n  <tbody>"
        foreach ($r in $rows) {
            $outputHtml += "`r`n    <tr>"
            foreach ($p in $propNames) {
                $outputHtml += '<td><span><div class="dni-plaintext">{0}</div></span></td>' -f $r.$p
            }
            $outputHtml += "</tr>"
        }
        $outputHtml += "`r`n  </tbody>`r`n</table></div></details>`r`n"
        if ($Display) {Write-Notebook -Html ($outputHtml + $treeViewCss) }
        else          {[Kernel]::HTML( $outputHtml)  }
    }
}
