
function NewSqliteConnection ($source,$query) { 
	$source
	$con = New-Object -TypeName System.Data.SQLite.SQLiteConnection
	$con.ConnectionString = "Data Source=$source"
try {
	$con.Open()

	$sql = $con.CreateCommand()
	$sql.CommandText = $query
	$adapter = New-Object -TypeName System.Data.SQLite.SQLiteDataAdapter $sql
	$data = New-Object System.Data.DataSet
	[void]$adapter.Fill($data)    
	$data.tables

	}
catch {
$con
}
}        


