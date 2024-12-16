# Made by Gaspaq
function Update-DataTable {
    [cmdletBinding()]
    param (
        $datatable,
        $By,
        $inputobject
    )
    # Check if the show already exists in the DataTable
    $DBSelect = "{0} = '{1}'" -f $By, $inputobject.$By
    Write-Verbose $DBSelect
    $existingRow = ($Datatable.Select($DBSelect))
    
 
    if ($existingRow.count -eq 0) {
        $existingRow = $Datatable.NewRow()
        $newrow = $true
        
    } else {
        $newrow = $false
    }

    # Update each column that matches
    foreach ($rowitem in $existingRow) {
        
       foreach ($key in $inputobject.Keys) {
            $rowitem[$key] = $inputobject[$key]
        }

        #}
    }
<# 
    foreach ($column in $Datatable.Columns) {
        $columnName = $column.ColumnName
        if ($inputobject.ContainsKey($columnName.ToLower())) {
            $existingRow[$columnName] = $inputobject[$columnName.ToLower()]
        }
    }
 #>

    if ($newrow) {
        Write-Verbose "Adding new row"
        $Datatable.Rows.Add($existingRow)
    }
    
    $existingRow #| Select *
}


