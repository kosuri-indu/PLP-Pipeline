using LibPQ, DBInterface, DataFrames, DotEnv, PrettyTables

DotEnv.config()

db_name = ENV["DB_NAME"]
db_user = ENV["DB_USER"]
db_password = ENV["DB_PASSWORD"]
db_host = ENV["DB_HOST"]

connection_string = "dbname=$db_name user=$db_user password=$db_password host=$db_host"
connection = DBInterface.connect(LibPQ.Connection, connection_string)

function query_and_print_table(connection, table_name::String)
    result = DBInterface.execute(connection, "SELECT * FROM $table_name LIMIT 5")
    df = DataFrame(result)
    println("Data from table '$table_name':")
    pretty_table(df)
end

tables = ["cohort", "concept", "concept_relationship"]

for table in tables
    query_and_print_table(connection, table)
end

DBInterface.close!(connection)