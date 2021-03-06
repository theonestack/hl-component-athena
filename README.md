# Athena CfHighlander Project

## Cfhighlander Setup

install cfhighlander [gem](https://github.com/theonestack/cfhighlander)

```bash
gem install cfhighlander
```

or via docker

```bash
docker pull theonestack/cfhighlander
```

Build and validate component

```bash
cfhighlander cfcompile --validate athena
```



## Parameters

| Parameter        | Description                                                  | Optional |
| ---------------- | ------------------------------------------------------------ | -------- |
| EnvironmentName  | The name of the environment                                  | No       |
| EnvironmentType  | The type of the environment (i.e. dev, prod, etc)            | No       |
| S3OutputLocation | S3 bucket for saving the Athena queries run within the workgroup | No       |



## Sample Configuration

````yaml
workgroups:
  SampleWG1:
    workgroup_state: DISABLED
    databases:
      sampleDatabase1:
        create_database_query: CREATE DATABASE
        tables:
          sampleTable1:
            create_table_query: CREATE TABLE
          sampleTabl2:
            create_table_query:   CREATE EXTERNAL TABLE IF NOT EXISTS database.table (
                `date` DATE,
                time STRING,
                location STRING,
                bytes BIGINT,
                request_ip STRING,
                method STRING,
                host STRING,
                uri STRING,
                status INT,
                referrer STRING,
                user_agent STRING,
                query_string STRING,
                cookie STRING,
                result_type STRING,
                request_id STRING,
                host_header STRING,
                request_protocol STRING,
                request_bytes BIGINT,
                time_taken FLOAT,
                xforwarded_for STRING,
                ssl_protocol STRING,
                ssl_cipher STRING,
                response_result_type STRING,
                http_version STRING,
                fle_status STRING,
                fle_encrypted_fields INT,
                c_port INT,
                time_to_first_byte FLOAT,
                x_edge_detailed_result_type STRING,
                sc_content_type STRING,
                sc_content_len BIGINT,
                sc_range_start BIGINT,
                sc_range_end BIGINT)
              ROW FORMAT DELIMITED
              FIELDS TERMINATED BY '\t'
              LOCATION 's3://bucket.${EnvironmentName}.${AWS::AccountId}/'
              TBLPROPERTIES ( 'skip.header.line.count'='2' )
````
