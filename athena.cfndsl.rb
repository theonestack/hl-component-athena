CloudFormation do

  workgroups = external_parameters.fetch(:workgroups, {})
  workgroups.each do |workgroup, wgconfig|

    safe_workgroup_name = workgroup.capitalize.gsub('_','').gsub('-','')

    workgroup_tags = []
    workgroup_tags << {Key: 'Name', Value: FnSub("${EnvironmentName}-#{workgroup}")}
    workgroup_tags << {Key: 'Environment', Value: Ref("EnvironmentName")}
    workgroup_tags << {Key: 'EnvironmentType', Value: Ref("EnvironmentType")}

    Athena_WorkGroup("#{safe_workgroup_name}") do
      Name FnSub("${EnvironmentName}-#{safe_workgroup_name}")
      State wgconfig.has_key?('workgroup_state') ? wgconfig['workgroup_state'] : "ENABLED"
      Tags workgroup_tags
      WorkGroupConfiguration ({
        ResultConfiguration: ({
          OutputLocation: Ref('S3OutputLocation')
        })
      })
    end


    wgconfig['databases'].each do |database, dbconfig|

      safe_database_name = database.capitalize.gsub('_','').gsub('-','')

      Athena_NamedQuery("#{safe_database_name}") do
        Database 'default'
        Name FnSub("${EnvironmentName}-#{safe_database_name}")
        QueryString dbconfig.has_key?('create_database_query') ? FnSub("#{dbconfig['create_database_query']} #{safe_database_name}") : FnSub("CREATE DATABASE #{safe_database_name}}")
        WorkGroup Ref(safe_workgroup_name)
      end

      dbconfig['tables'].each do |table, tbconfig|

        safe_table_name = table.capitalize.gsub('_','').gsub('-','')

        Athena_NamedQuery("#{safe_table_name}") do
          Database database
          Name FnSub("${EnvironmentName}-#{safe_table_name}")
          QueryString FnSub("#{tbconfig['create_table_query']}")
          WorkGroup Ref(safe_workgroup_name)
        end

        Athena_NamedQuery("ReturnAllQueryFor#{safe_table_name}") do
          Database database
          Name 'ReturnAllQuery'
          QueryString FnSub("SELECT * FROM #{safe_database_name}.#{safe_table_name}")
          WorkGroup Ref(safe_workgroup_name)
        end
      end if dbconfig.has_key?('tables')
    end if wgconfig.has_key?('databases')
  end
end
