# Doppler

A MySQL-to-Redshift Utility.

## Installation

`git clone https://github.com/githoov/doppler`

## ETL Process

### Initial tasks
```
establish connection to mysql source

for each database in config do
 for each schema in database do
  for each table in schema do
   describe table with output to xml
   map data type from mysql to redshift
   clean column names
   generate json schema
   materialize json schema
  end
 end
end

break

alter sort, distribution, and encoding defaults in each json schema as needed

resume 

for each json schema do
 generate create table statement
 issue create table statement to redshift
end

for each database in config do
 for each schema in database do
  for each table in schema do
   use awscli/sdk to dump table to s3
   copy from s3 to redshift
  end
 end
end
```
### Incremental tasks
```
for each database in config do
 for each schema in database do
  for each table in schema do
  	describe table with xml out
  	convert xml to json
  	if current json schema differs from serialized json schema
  		determine column changes
  		update json schema
  		issue alter table statements
  	end
  	if table-size <= max cuttoff in size
  		truncate target table
  		perform full dump to s3
  		copy from s3 to redshift
  	else
	   retrieve new rows using created_at or id
	   retrieve updated rows using updated_at
	   retrieve deleted rows using deleted_at
	   perform incremental dump to s3
	   select into staging_table from target_table
	   copy from s3 to redshift staging table
	   perform upserts on staging (http://docs.aws.amazon.com/redshift/latest/dg/merge-examples.html)
     insert staging to target
     drop staging
	  end
  end
 end
end
```

### Maintenance tasks
```
vacuum tables
analyze compression
analyze skew
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/githoov/doppler.

