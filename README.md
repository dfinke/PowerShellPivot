# PS Pivot Table

<p align="center">
• <a href="https://github.com/dfinke/PowerShellPivot/wiki" style="font-size: 25px">Documentation</a> •
</p>

Create a spreadsheet-style pivot table.

Drawing from Excel pivot table concepts and Python Pandas pivot table functionality.

# Getting Started
## Install

Install the PowerShell module from the gallery.

```powershell
Install-Module -Name PowerShellPivot
```

It supports a single dimension, multiple values, and these stats:

|Name|Description|
|---|---|
|Average|The sum of the data divided by the number of data points|
|Count|Returns the number of elements in the list|
|Entropy|Calculate the entropy of a distribution for given probability values|
|GeometricMean|The geometric mean indicates the central tendency or typical value of the data using the product of the values (as opposed to the arithmetic mean which uses their sum)|
|HarmonicMean|The reciprocal of the arithmetic mean of the reciprocals of the given set of observations|
|LowerQuartile|The middle number between the smallest number and the median|
|UpperQuartile|In mathematical terms, variance is the calculation of how far a set of values is from the average value (the mean)|
|Max|Returns the element from the list with maximum value|
|Mean|The sum of the data divided by the number of data points|
|Median|The midpoint of a frequency distribution of observed values|
|Min|Returns the element from the list with minimum value|
|RootMeanSquare|The square root of the mean square|
|STD|The square root of the sample variance|
|Sum|Return the sum for the list of numbers|
|Variance|Variance is the calculation of how far a set of values is from the average value (the mean)|


More to come...

> Feel free to contribute! Code, feedback, features, ideas, etc. all are welcome.

## Examples

### Defaults just work

Pass in `data` and a single `index` to `New-PSPivotTable`, and the default aggregate function will be `Average`. Plus, `New-PSPivotTable` will infer what properties are numeric, and do the calculations.

Now that's, automating the boring stuff.

```powershell
$data = ConvertFrom-Csv @"
Date,Name,Customer,Revenue,Expenses
1/1/20,Oscar,Logistics XYZ,5250,531
1/1/20,Oscar,Money Corp.,4406,661
1/2/20,Oscar,PaperMaven,8661,1401
1/3/20,Oscar,PaperGenius,7075,906
1/4/20,Oscar,Paper Pound,2524,1767
1/5/20,Oscar,Paper Pound,2793,624
"@

$table = New-PSPivotTable -InputObject $data date

$table

date   Average_Revenue Average_Expenses
----   --------------- ----------------
1/1/20            4828              596
1/2/20            8661             1401
1/3/20            7075              906
1/4/20            2524             1767
1/5/20            2793              624
```

## Stocks

```powershell
$url = 'https://gist.githubusercontent.com/alexdebrie/b3f40efc3dd7664df5a20f5eee85e854/raw/ee3e6feccba2464cbbc2e185fb17961c53d2a7f5/stocks.csv'
$data = ConvertFrom-Csv (Invoke-RestMethod $url)

# Raw data
$data[0..1]

date       symbol open    high    low     close   volume
----       ------ ----    ----    ---     -----   ------
2019-03-01 AMZN   1655.13 1674.26 1651.0  1671.73 4974877
2019-03-04 AMZN   1685.0  1709.43 1674.36 1696.17 6167358

# Show averages of all numeric properties, averaged by date
New-PSPivotTable -InputObject $data date

date       Average_open Average_high Average_low Average_close Average_volume
----       ------------ ------------ ----------- ------------- --------------
2019-03-01       984.77       997.46      982.88       995.897   10770453.333
2019-03-04      1002.56     1015.153     993.007      1006.607   11683202.667
2019-03-05      1009.65     1017.803    1003.247      1009.997    8287371.667
2019-03-06     1011.043     1013.603     999.237      1000.443    8635224.667
2019-03-07      998.987     1000.317     975.813       980.583       10306650
```

## Sum, single index and value

Aggregates values using the `Sum` aggregate.

```powershell
$data = ConvertFrom-Csv @"
Dimension1, Measure1
North, 1
North, 2
North, 3
South, 1
South, 2
South, 3
East, 1
East, 2
East, 3
West, 1
West, 2
West, 3
"@

$table = New-PSPivotTable -InputObject $data -index Dimension1 -value Measure1 -aggregateFunction Sum

$table

Dimension1 Sum_Measure1
---------- ------------
South                 6
East                  6
West                  6
North                 6
```

## Multiple values and aggregates

By Region show the `Sum`, `Min`, `Max` and `Count` of the `Units` and `Prices.

```powershell
$data = ConvertFrom-Csv @"
Region, Units, Price
North, 1, 10
North, 2, 20
North, 3, 30
South, 1, 10
South, 2, 20
South, 3, 30
East, 1, 10
East, 2, 20
East, 3, 30
West, 1, 10
West, 2, 20
West, 3, 30
"@

$table = New-PSPivotTable -InputObject $data -index Region -value Units, Price -aggregateFunction Sum, Min, Max, Count

$table

Region Sum_Units Min_Units Max_Units Count_Units Sum_Price Min_Price Max_Price Count_Price
------ --------- --------- --------- ----------- --------- --------- --------- -----------
East           6         1         3           2        60        10        30           2
North          6         1         3           2        60        10        30           2
South          6         1         3           2        60        10        30           2
West           6         1         3           2        60        10        30           2
```

## Exclude Values from Calculation



```powershell
$url = 'https://gist.githubusercontent.com/alexdebrie/b3f40efc3dd7664df5a20f5eee85e854/raw/ee3e6feccba2464cbbc2e185fb17961c53d2a7f5/stocks.csv'
$data = ConvertFrom-Csv (Invoke-RestMethod $url)

# Raw data
$data[0..1]

date       symbol open    high    low     close   volume
----       ------ ----    ----    ---     -----   ------
2019-03-01 AMZN   1655.13 1674.26 1651.0  1671.73 4974877
2019-03-04 AMZN   1685.0  1709.43 1674.36 1696.17 6167358

# Show averages of all numeric properties, averaged by date
$table = New-PSPivotTable -InputObject $data date

$table

date       Average_open Average_high Average_low Average_close Average_volume
----       ------------ ------------ ----------- ------------- --------------
2019-03-01       984.77       997.46      982.88       995.897   10770453.333
2019-03-04      1002.56     1015.153     993.007      1006.607   11683202.667
2019-03-05      1009.65     1017.803    1003.247      1009.997    8287371.667
2019-03-06     1011.043     1013.603     999.237      1000.443    8635224.667
2019-03-07      998.987     1000.317     975.813       980.583       10306650

## Exclude open, low, and volume

$table = New-PSPivotTable -InputObject $data date -ExcludeValues open, low, volume

$table

date       Average_high Average_close
----       ------------ -------------
2019-03-01       997.46       995.897
2019-03-04     1015.153      1006.607
2019-03-05     1017.803      1009.997
2019-03-06     1013.603      1000.443
2019-03-07     1000.317       980.583
```

# Invoke-PSMelt

Unpivot a given array from wide format to long format. Adapted from [Python Pandas melt](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.melt.html).

```powershell
$data = ConvertFrom-Csv @"
State,Apple,Orange,Banana
Texas,12,10,40
Arizona,9,7,12
Florida,0,14,190
"@

$data

State   Apple Orange Banana
-----   ----- ------ ------
Texas   12    10     40
Arizona 9     7      12
Florida 0     14     190


$data | Invoke-PSMelt State

Name    variable value
----    -------- -----
Texas   Apple    12
Texas   Orange   10
Texas   Banana   40
Arizona Apple    9
Arizona Orange   7
Arizona Banana   12
Florida Apple    0
Florida Orange   14
Florida Banana   190
```
## Exclude Property

`ExcludeProperty` specifies the properties that this cmdlet excludes from the operation. Currently, supports an array of strings, and it can be a regex.

```powershell
$data = ConvertFrom-Csv @"
Date,Name,Customer,Revenue,Expenses
1/1/20,Oscar,Logistics XYZ,5250,531
1/1/20,Oscar,Money Corp.,4406,661
1/2/20,Oscar,PaperMaven,8661,1401
"@

$data | Invoke-PSMelt -ExcludeProperty Name, Cust, en


variable value
-------- -----
Date     1/1/20
Date     1/1/20
Date     1/2/20
```

## ConvertTo-CrossTab

Converts simple rows into a cross tab query

```powershell
ConvertFrom-Csv @"
Region,State,Units,Price
West,Texas,927,923.71
North,Tennessee,466,770.67
East,Florida,520,458.68
East,Maine,828,661.24
West,Virginia,465,053.58
North,Missouri,436,235.67
South,Kansas,214,992.47
North,North Dakota,789,640.72
South,Delaware,712,508.55
"@ | ConvertTo-CrossTab -ColumnName Region -RowName State -ValueName Units -SuffixColumn " units"
```

```powershell
State        East units North units South units West units
-----        ---------- ----------- ----------- ----------
Delaware                            712         
Florida      520                                
Kansas                              214         
Maine        828                                
Missouri                436                     
North Dakota            789                     
Tennessee               466                     
Texas                                           927
Virginia                                        465
```

## Get-Subtotal

Adds subtotals to data

```powershell
ConvertFrom-Csv @"
Region,State,Units,Price
West,Texas,927,923.71
North,Tennessee,466,770.67
East,Florida,520,458.68
East,Maine,828,661.24
West,Virginia,465,053.58
North,Missouri,436,235.67
South,Kansas,214,992.47
North,North Dakota,789,640.72
South,Delaware,712,508.55
"@ | Get-Subtotal State, Region
```

Default is to calculate the count.

```powershell
State        Region Count
-----        ------ -----
Delaware     South      1
Florida      East       1
Kansas       South      1
Maine        East       1
Missouri     North      1
North Dakota North      1
Tennessee    North      1
Texas        West       1
Virginia     West       1
```

`-AllStats` will calculate the count, average, sum, maximum, minimum, and standard deviation.

```powershell
ConvertFrom-Csv @"
Region,State,Units,Price
West,Texas,927,923.71
North,Tennessee,466,770.67
North,Tennessee,1466,770.67
East,Florida,520,458.68
East,Maine,828,661.24
West,Virginia,465,053.58
North,Missouri,436,235.67
South,Kansas,214,992.47
South,Kansas,1214,992.47
North,North Dakota,789,640.72
South,Delaware,712,508.55
"@ | Get-Subtotal State, Region -ValueName Units -AllStats
```

```powershell
State        Region Units_Count Units_Average Units_Sum Units_Maximum Units_Minimum Units_StandardDeviation
-----        ------ ----------- ------------- --------- ------------- ------------- -----------------------
Delaware     South            1           712       712           712           712                       0
Florida      East             1           520       520           520           520                       0
Kansas       South            2           714      1428          1214           214        707.106781186548
Maine        East             1           828       828           828           828                       0
Missouri     North            1           436       436           436           436                       0
North Dakota North            1           789       789           789           789                       0
Tennessee    North            2           966      1932          1466           466        707.106781186548
Texas        West             1           927       927           927           927                       0
Virginia     West             1           465       465           465           465                       0
```