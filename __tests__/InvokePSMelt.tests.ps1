Import-Module "$PSScriptRoot/../PowerShellPivot.psd1" -Force

Describe "Tests Invoke PSMelt" -Tag InvokePSMelt {
    BeforeEach {
        $data = ConvertFrom-Csv @"
State,Apple,Orange,Banana
Texas,12,10,40
Arizona,9,7,12
Florida,0,14,190
"@
    }

    It "Tests defaults via -InputObject" {
        $actual = Invoke-PSMelt -InputObject $data | Sort-Object variable,value

        $actual.Count | Should -Be 12
        <#
            variable value
            -------- -----
            Apple    0
            Apple    9
            Apple    12
            Banana   12
            Banana   40
            Banana   190
            Orange   7
            Orange   10
            Orange   14

            State    Arizona
            State    Florida
            State    Texas
                    #>
        $names = $actual[0].psobject.properties.name
        $names.Count | Should -Be 2

        $names[0] | Should -BeExactly "variable"
        $names[1] | Should -BeExactly "value"

        $actual[11].variable | Should -BeExactly "State"
        $actual[11].value | Should -BeExactly "Texas"
        $actual[10].variable | Should -BeExactly "State"
        $actual[10].value | Should -BeExactly "Florida"
        $actual[9].variable | Should -BeExactly "State"
        $actual[9].value | Should -BeExactly "Arizona"
        $actual[8].variable | Should -BeExactly "Orange"
        $actual[8].value | Should -BeExactly "7"
        $actual[7].variable | Should -BeExactly "Orange"
        $actual[7].value | Should -BeExactly "14"
        $actual[6].variable | Should -BeExactly "Orange"
        $actual[6].value | Should -BeExactly "10"
        $actual[5].variable | Should -BeExactly "Banana"
        $actual[5].value | Should -BeExactly "40"
        $actual[4].variable | Should -BeExactly "Banana"
        $actual[4].value | Should -BeExactly "190"
        $actual[3].variable | Should -BeExactly "Banana"
        $actual[3].value | Should -BeExactly "12"
        $actual[2].variable | Should -BeExactly "Apple"
        $actual[2].value | Should -BeExactly "9"
        $actual[1].variable | Should -BeExactly "Apple"
        $actual[1].value | Should -BeExactly "12"
        $actual[0].variable | Should -BeExactly "Apple"
        $actual[0].value | Should -BeExactly "0"

    }

    It "Tests defaults via piping" {
        $actual = $data | Invoke-PSMelt

        $actual.Count | Should -Be 12
        <#
            variable value
            -------- -----
            State    Texas
            Apple    12
            Orange   10
            Banana   40
            State    Arizona
            Apple    9
            Orange   7
            Banana   12
            State    Florida
            Apple    0
            Orange   14
            Banana   190
        #>

        $names = $actual[0].psobject.properties.name
        $names.Count | Should -Be 2

        $names[0] | Should -BeExactly "variable"
        $names[1] | Should -BeExactly "value"

        $actual[0].variable | Should -BeExactly "State"
        $actual[0].value | Should -BeExactly "Texas"
        $actual[1].variable | Should -BeExactly "Apple"
        $actual[1].value | Should -BeExactly "12"
        $actual[2].variable | Should -BeExactly "Orange"
        $actual[2].value | Should -BeExactly "10"
        $actual[3].variable | Should -BeExactly "Banana"
        $actual[3].value | Should -BeExactly "40"
        $actual[4].variable | Should -BeExactly "State"
        $actual[4].value | Should -BeExactly "Arizona"
        $actual[5].variable | Should -BeExactly "Apple"
        $actual[5].value | Should -BeExactly "9"
        $actual[6].variable | Should -BeExactly "Orange"
        $actual[6].value | Should -BeExactly "7"
        $actual[7].variable | Should -BeExactly "Banana"
        $actual[7].value | Should -BeExactly "12"
        $actual[8].variable | Should -BeExactly "State"
        $actual[8].value | Should -BeExactly "Florida"
        $actual[9].variable | Should -BeExactly "Apple"
        $actual[9].value | Should -BeExactly "0"
        $actual[10].variable | Should -BeExactly "Orange"
        $actual[10].value | Should -BeExactly "14"
        $actual[11].variable | Should -BeExactly "Banana"
        $actual[11].value | Should -BeExactly "190"
    }

    It 'Tests changing var and value name' {
        $data = ConvertFrom-Csv @"
Name,Course,Age
John,Masters,27
Bob,Graduate,23
Shiela,Graduate,21
"@

        $actual = $data | Invoke-PSMelt -VarName PropertyName -ValueName TargetValue
        $actual.Count | Should -Be 9
        <#
            PropertyName TargetValue
            -----------  -----------
            Name         John
            Course       Masters
            Age          27
            Name         Bob
            Course       Graduate
            Age          23
            Name         Shiela
            Course       Graduate
            Age          21
        #>

        $names = $actual[0].psobject.properties.name
        $names.Count | Should -Be 2

        $names[0] | Should -BeExactly "PropertyName"
        $names[1] | Should -BeExactly "TargetValue"

        $actual[0].PropertyName | Should -BeExactly "Name"
        $actual[0].TargetValue | Should -BeExactly "John"
        $actual[1].PropertyName | Should -BeExactly "Course"
        $actual[1].TargetValue | Should -BeExactly "Masters"
        $actual[2].PropertyName | Should -BeExactly "Age"
        $actual[2].TargetValue | Should -BeExactly "27"
        $actual[3].PropertyName | Should -BeExactly "Name"
        $actual[3].TargetValue | Should -BeExactly "Bob"
        $actual[4].PropertyName | Should -BeExactly "Course"
        $actual[4].TargetValue | Should -BeExactly "Graduate"
        $actual[5].PropertyName | Should -BeExactly "Age"
        $actual[5].TargetValue | Should -BeExactly "23"
        $actual[6].PropertyName | Should -BeExactly "Name"
        $actual[6].TargetValue | Should -BeExactly "Shiela"
        $actual[7].PropertyName | Should -BeExactly "Course"
        $actual[7].TargetValue | Should -BeExactly "Graduate"
        $actual[8].PropertyName | Should -BeExactly "Age"
        $actual[8].TargetValue | Should -BeExactly "21"
    }

    It 'Tests adding Id' {
        $data = ConvertFrom-Csv @"
Name,Course,Age
John,Masters,27
Bob,Graduate,23
Shiela,Graduate,21
"@

        $actual = $data | Invoke-PSMelt Name
        $actual.Count | Should -Be 6

        <#
            Name   variable value
            ----   -------- -----
            John   Course   Masters
            John   Age      27
            Bob    Course   Graduate
            Bob    Age      23
            Shiela Course   Graduate
            Shiela Age      21
        #>

        $names = $actual[0].psobject.properties.name
        $names.Count | Should -Be 3

        $names[0] | Should -BeExactly "Name"
        $names[1] | Should -BeExactly "variable"
        $names[2] | Should -BeExactly "value"

        $actual[0].Name | Should -BeExactly "John"
        $actual[0].variable | Should -BeExactly "Course"
        $actual[0].value | Should -BeExactly "Masters"
        $actual[1].Name | Should -BeExactly "John"
        $actual[1].variable | Should -BeExactly "Age"
        $actual[1].value | Should -BeExactly "27"
        $actual[2].Name | Should -BeExactly "Bob"
        $actual[2].variable | Should -BeExactly "Course"
        $actual[2].value | Should -BeExactly "Graduate"
        $actual[3].Name | Should -BeExactly "Bob"
        $actual[3].variable | Should -BeExactly "Age"
        $actual[3].value | Should -BeExactly "23"
        $actual[4].Name | Should -BeExactly "Shiela"
        $actual[4].variable | Should -BeExactly "Course"
        $actual[4].value | Should -BeExactly "Graduate"
        $actual[5].Name | Should -BeExactly "Shiela"
        $actual[5].variable | Should -BeExactly "Age"
        $actual[5].value | Should -BeExactly "21"
    }

    It "Tests Id and 'Course' Var" {
        $data = ConvertFrom-Csv @"
Name,Course,Age
John,Masters,27
Bob,Graduate,23
Shiela,Graduate,21
"@
        $actual = $data | Invoke-PSMelt Name Course
        $actual.Count | Should -Be 3

        <#
            Name   variable value
            ----   -------- -----
            John   Course   Masters
            Bob    Course   Graduate
            Shiela Course   Graduate
        #>
        $names = $actual[0].psobject.properties.name
        $names.Count | Should -Be 3

        $names[0] | Should -BeExactly "Name"
        $names[1] | Should -BeExactly "variable"
        $names[2] | Should -BeExactly "value"

        $actual[0].Name | Should -BeExactly "John"
        $actual[0].variable | Should -BeExactly "Course"
        $actual[0].value | Should -BeExactly "Masters"
        $actual[1].Name | Should -BeExactly "Bob"
        $actual[1].variable | Should -BeExactly "Course"
        $actual[1].value | Should -BeExactly "Graduate"
        $actual[2].Name | Should -BeExactly "Shiela"
        $actual[2].variable | Should -BeExactly "Course"
        $actual[2].value | Should -BeExactly "Graduate"
    }

    It "Tests Id and 'Age' Var" {
        $data = ConvertFrom-Csv @"
Name,Course,Age
John,Masters,27
Bob,Graduate,23
Shiela,Graduate,21
"@
        $actual = $data | Invoke-PSMelt Name Age
        $actual.Count | Should -Be 3

        <#
        Name   variable value
        ----   -------- -----
        John   Age      27
        Bob    Age      23
        Shiela Age      21
        #>

        $names = $actual[0].psobject.properties.name
        $names.Count | Should -Be 3

        $names[0] | Should -BeExactly "Name"
        $names[1] | Should -BeExactly "variable"
        $names[2] | Should -BeExactly "value"

        $actual[0].Name | Should -BeExactly "John"
        $actual[0].variable | Should -BeExactly "Age"
        $actual[0].value | Should -BeExactly "27"
        $actual[1].Name | Should -BeExactly "Bob"
        $actual[1].variable | Should -BeExactly "Age"
        $actual[1].value | Should -BeExactly "23"
        $actual[2].Name | Should -BeExactly "Shiela"
        $actual[2].variable | Should -BeExactly "Age"
        $actual[2].value | Should -BeExactly "21"
    }

    It "Tests Id and 'Course,Age' Var" {
        $data = ConvertFrom-Csv @"
Name,Course,Age
John,Masters,27
Bob,Graduate,23
Shiela,Graduate,21
"@
        $actual = $data | Invoke-PSMelt Name Course, Age
        $actual.Count | Should -Be 6

        <#
        Name   variable value
        ----   -------- -----
        John   Course   Masters
        John   Age      27
        Bob    Course   Graduate
        Bob    Age      23
        Shiela Course   Graduate
        Shiela Age      21
        #>

        $names = $actual[0].psobject.properties.name
        $names.Count | Should -Be 3

        $names[0] | Should -BeExactly "Name"
        $names[1] | Should -BeExactly "variable"
        $names[2] | Should -BeExactly "value"

        $actual[0].Name | Should -BeExactly "John"
        $actual[0].variable | Should -BeExactly "Course"
        $actual[0].value | Should -BeExactly "Masters"
        $actual[1].Name | Should -BeExactly "John"
        $actual[1].variable | Should -BeExactly "Age"
        $actual[1].value | Should -BeExactly "27"
        $actual[2].Name | Should -BeExactly "Bob"
        $actual[2].variable | Should -BeExactly "Course"
        $actual[2].value | Should -BeExactly "Graduate"
        $actual[3].Name | Should -BeExactly "Bob"
        $actual[3].variable | Should -BeExactly "Age"
        $actual[3].value | Should -BeExactly "23"
        $actual[4].Name | Should -BeExactly "Shiela"
        $actual[4].variable | Should -BeExactly "Course"
        $actual[4].value | Should -BeExactly "Graduate"
        $actual[5].Name | Should -BeExactly "Shiela"
        $actual[5].variable | Should -BeExactly "Age"
        $actual[5].value | Should -BeExactly "21"
    }

    It "Tests an array for the Id parameter" {
        $data = Import-Csv "$PSScriptRoot\SalesByEmployee.csv"
        $actual = Invoke-PSMelt -InputObject $data Date, Name, Customer  | Sort-Object name,variable,customer

        $actual.Count | Should -Be 52

        <#
        date   name  customer      variable value
        ----   ----  --------      -------- -----
        1/1/20 Oscar Logistics XYZ Revenue  5250
        1/1/20 Oscar Money Corp.   Revenue  4406
        1/2/20 Oscar PaperMaven    Revenue  8661
        1/3/20 Oscar PaperGenius   Revenue  7075
        1/4/20 Oscar Paper Pound   Revenue  2524
        #>

        $names = $actual[0].psobject.properties.name
        $names.Count | Should -Be 5

        $names[0] | Should -Be "date"
        $names[1] | Should -Be "name"
        $names[2] | Should -Be "customer"
        $names[3] | Should -Be "variable"
        $names[4] | Should -Be "value"

        $actual[-6].date | Should -Be "1/1/20"
        $actual[-6].name | Should -Be "Oscar"
        $actual[-6].customer | Should -Be "Logistics XYZ"
        $actual[-6].variable | Should -Be "Revenue"
        $actual[-6].value | Should -Be "5250"

        $actual[-5].date | Should -Be "1/1/20"
        $actual[-5].name | Should -Be "Oscar"
        $actual[-5].customer | Should -Be "Money Corp."
        $actual[-5].variable | Should -Be "Revenue"
        $actual[-5].value | Should -Be "4406"

        $actual[-1].date | Should -Be "1/2/20"
        $actual[-1].name | Should -Be "Oscar"
        $actual[-1].customer | Should -Be "PaperMaven"
        $actual[-1].variable | Should -Be "Revenue"
        $actual[-1].value | Should -Be "8661"

        $actual[-2].date | Should -Be "1/3/20"
        $actual[-2].name | Should -Be "Oscar"
        $actual[-2].customer | Should -Be "PaperGenius"
        $actual[-2].variable | Should -Be "Revenue"
        $actual[-2].value | Should -Be "7075"

        $actual[-3].date | Should -Be "1/4/20"
        $actual[-3].name | Should -Be "Oscar"
        $actual[-3].customer | Should -Be "Paper Pound"
        $actual[-3].variable | Should -Be "Revenue"
        $actual[-3].value | Should -Be "2524"
    }

    It "Tests an array for the Id parameter and the Vars a single property" {
        $data = Import-Csv "$PSScriptRoot\SalesByEmployee.csv"
        $actual = Invoke-PSMelt -InputObject $data Date, Name, Customer -Vars Revenue

        $actual.Count | Should -Be 26
        <#
        Date   Name  Customer      variable value
        ----   ----  --------      -------- -----
        1/1/20 Oscar Logistics XYZ Revenue  5250
        1/1/20 Oscar Money Corp.   Revenue  4406
        1/2/20 Oscar PaperMaven    Revenue  8661
        1/3/20 Oscar PaperGenius   Revenue  7075
        1/4/20 Oscar Paper Pound   Revenue  2524
        #>

        $names = $actual[0].psobject.properties.name
        $names.Count | Should -Be 5

        $names[0] | Should -BeExactly "Date"
        $names[1] | Should -BeExactly "Name"
        $names[2] | Should -BeExactly "Customer"
        $names[3] | Should -BeExactly "variable"
        $names[4] | Should -BeExactly "value"

        $actual[0].Date | Should -Be "1/1/20"
        $actual[0].Name | Should -Be "Oscar"
        $actual[0].Customer | Should -Be "Logistics XYZ"
        $actual[0].variable | Should -Be "Revenue"
        $actual[0].value | Should -Be "5250"

        $actual[1].Date | Should -Be "1/1/20"
        $actual[1].Name | Should -Be "Oscar"
        $actual[1].Customer | Should -Be "Money Corp."
        $actual[1].variable | Should -Be "Revenue"
        $actual[1].value | Should -Be "4406"

        $actual[2].Date | Should -Be "1/2/20"
        $actual[2].Name | Should -Be "Oscar"
        $actual[2].Customer | Should -Be "PaperMaven"
        $actual[2].variable | Should -Be "Revenue"
        $actual[2].value | Should -Be "8661"

        $actual[3].Date | Should -Be "1/3/20"
        $actual[3].Name | Should -Be "Oscar"
        $actual[3].Customer | Should -Be "PaperGenius"
        $actual[3].variable | Should -Be "Revenue"
        $actual[3].value | Should -Be "7075"

        $actual[4].Date | Should -Be "1/4/20"
        $actual[4].Name | Should -Be "Oscar"
        $actual[4].Customer | Should -Be "Paper Pound"
        $actual[4].variable | Should -Be "Revenue"
        $actual[4].value | Should -Be "2524"
    }

    It "Tests an array ofr Id and the Vars single property and rename var, val properties" {
        $data = Import-Csv "$PSScriptRoot\SalesByEmployee.csv"
        $actual = Invoke-PSMelt -InputObject $data Date, Name, Customer -Vars Revenue -VarName Category -ValueName Amount

        $actual.Count | Should -Be 26
        <#
        Date   Name  Customer      variable value
        ----   ----  --------      -------- -----
        1/1/20 Oscar Logistics XYZ Revenue  5250
        1/1/20 Oscar Money Corp.   Revenue  4406
        1/2/20 Oscar PaperMaven    Revenue  8661
        1/3/20 Oscar PaperGenius   Revenue  7075
        1/4/20 Oscar Paper Pound   Revenue  2524
        #>

        $names = $actual[0].psobject.properties.name
        $names.Count | Should -Be 5

        $names[0] | Should -BeExactly "Date"
        $names[1] | Should -BeExactly "Name"
        $names[2] | Should -BeExactly "Customer"
        $names[3] | Should -BeExactly "Category"
        $names[4] | Should -BeExactly "Amount"
    }

    It 'Tests null InputObject should not throw' {
        Invoke-PSMelt -InputObject $nullData | Should -Be $null
    }

    It 'Tests piping null InputObject should not throw' {
        $nullData | Invoke-PSMelt $nullData | Should -Be $null
    }
}