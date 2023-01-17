<cfquery name="GET_ALL_TABLE" datasource="#DSN#">
    SELECT 
        TABLE_NAME,
        TABLE_CATALOG,
        TABLE_SCHEMA,
        TABLE_TYPE 
    FROM 
        INFORMATION_SCHEMA.TABLES 
    WHERE 
        TABLE_TYPE='BASE TABLE' AND 
        TABLE_NAME NOT LIKE 'DP%' AND 
        TABLE_NAME NOT LIKE '[_]%' AND 
        TABLE_NAME NOT LIKE 'FOREKS%'
    UNION ALL
    SELECT 
        TABLE_NAME,
        TABLE_CATALOG,
        TABLE_SCHEMA,
        TABLE_TYPE 
    FROM 
        #dsn1#.INFORMATION_SCHEMA.TABLES 
    WHERE 
        TABLE_TYPE='BASE TABLE' AND 
        TABLE_NAME NOT LIKE 'DP%' AND 
        TABLE_NAME NOT LIKE '[_]%' AND 
        TABLE_NAME NOT LIKE 'FOREKS%'
    UNION  ALL
    SELECT 
        TABLE_NAME,
        TABLE_CATALOG,
        TABLE_SCHEMA,
        TABLE_TYPE 
    FROM 
        #dsn2#.INFORMATION_SCHEMA.TABLES 
    WHERE 
        TABLE_TYPE='BASE TABLE' AND 
        TABLE_NAME NOT LIKE 'DP%' AND 
        TABLE_NAME NOT LIKE '[_]%' AND 
        TABLE_NAME NOT LIKE 'FOREKS%'
    UNION ALL
    SELECT 
        TABLE_NAME,
        TABLE_CATALOG,
        TABLE_SCHEMA,
        TABLE_TYPE 
    FROM 
        #dsn3#.INFORMATION_SCHEMA.TABLES 
    WHERE 
        TABLE_TYPE='BASE TABLE' AND 
        TABLE_NAME NOT LIKE 'DP%' AND 
        TABLE_NAME NOT LIKE '[_]%' AND 
        TABLE_NAME NOT LIKE 'FOREKS%'
</cfquery>

<cfquery name="get_all_column" datasource="#dsn#">
	SELECT 
		*,
		CASE  WHEN IS_IDENTITY=1 THEN 1
		ELSE 0 END AS INCREMENT,
		CASE  WHEN IS_IDENTITY=1  THEN 1
		ELSE 0 END AS SEED	
	FROM 
		(
		
		
		    SELECT 
				TABLE_NAME,
				COLUMN_NAME,
				DATA_TYPE,
				CHARACTER_MAXIMUM_LENGTH,
				IS_NULLABLE,
				CASE WHEN COLUMNPROPERTY(OBJECT_ID(c.TABLE_NAME),c.COLUMN_NAME,'IsIdentity') = 1 THEN 1
				ELSE 0 END AS IS_IDENTITY
			FROM 
				INFORMATION_SCHEMA.COLUMNS  C
			WHERE 
				TABLE_NAME IN (SELECT TABLE_NAME FROM  INFORMATION_SCHEMA.TABLES WHERE  
																					TABLE_TYPE='BASE TABLE'
																				AND TABLE_NAME NOT LIKE 'DP%'
																				AND TABLE_NAME NOT LIKE '[_]%'
																				AND TABLE_NAME NOT LIKE 'FOREKS%')
		
		)
	AS XXX
	
    UNION ALL
        
   	SELECT 
        *,
        CASE  WHEN IS_IDENTITY=1 THEN 1
        ELSE 0 END AS INCREMENT,
        CASE  WHEN IS_IDENTITY=1  THEN 1
        ELSE 0 END AS SEED	
    FROM 
        (
        
        
        SELECT 
            TABLE_NAME,
            COLUMN_NAME,
            DATA_TYPE,
            CHARACTER_MAXIMUM_LENGTH,
            IS_NULLABLE,
            CASE WHEN COLUMNPROPERTY(OBJECT_ID(c.TABLE_NAME),c.COLUMN_NAME,'IsIdentity') = 1 THEN 1
            ELSE 0 END AS IS_IDENTITY
        FROM 
            #dsn1#.INFORMATION_SCHEMA.COLUMNS  C
        WHERE 
            TABLE_NAME in (SELECT TABLE_NAME FROM  #dsn1#.INFORMATION_SCHEMA.TABLES WHERE  TABLE_TYPE='BASE TABLE'
                                                                                            AND TABLE_NAME NOT LIKE 'DP%'
                                                                                            AND TABLE_NAME NOT LIKE '[_]%'
                                                                                            AND TABLE_NAME NOT LIKE 'FOREKS%'))
    AS XXX
    
    UNION ALL
    
    SELECT *,
        CASE  WHEN IS_IDENTITY=1 THEN 1
        ELSE 0 END AS INCREMENT,
        CASE  WHEN IS_IDENTITY=1  THEN 1
        ELSE 0 END AS SEED	
     FROM 
        (SELECT 
        TABLE_NAME,
        COLUMN_NAME,
        DATA_TYPE,
        CHARACTER_MAXIMUM_LENGTH,
        IS_NULLABLE,
        CASE WHEN COLUMNPROPERTY(OBJECT_ID(c.TABLE_NAME),c.COLUMN_NAME,'IsIdentity') = 1 THEN 1
        ELSE 0 END AS IS_IDENTITY
    FROM 
        #dsn2#.INFORMATION_SCHEMA.COLUMNS  C
    WHERE 
        TABLE_NAME in (SELECT TABLE_NAME FROM  #dsn2#.INFORMATION_SCHEMA.TABLES WHERE TABLE_TYPE='BASE TABLE'
            AND TABLE_NAME NOT LIKE 'DP%'
            AND TABLE_NAME NOT LIKE '[_]%'
            AND TABLE_NAME NOT LIKE 'FOREKS%'))
    AS XXX
    UNION ALL

    SELECT 
        *,
        CASE  WHEN IS_IDENTITY=1 THEN 1
        ELSE 0 END AS INCREMENT,
        CASE  WHEN IS_IDENTITY=1  THEN 1
        ELSE 0 END AS SEED	
     FROM 
        (SELECT 
        TABLE_NAME,
        COLUMN_NAME,
        DATA_TYPE,
        CHARACTER_MAXIMUM_LENGTH,
        IS_NULLABLE,
        CASE WHEN COLUMNPROPERTY(OBJECT_ID(c.TABLE_NAME),c.COLUMN_NAME,'IsIdentity') = 1 THEN 1
        ELSE 0 END AS IS_IDENTITY
    FROM 
        #dsn3#.INFORMATION_SCHEMA.COLUMNS  C
    WHERE 
        TABLE_NAME in (SELECT TABLE_NAME FROM  #dsn3#.INFORMATION_SCHEMA.TABLES WHERE TABLE_TYPE='BASE TABLE'
            AND TABLE_NAME NOT LIKE 'DP%'
            AND TABLE_NAME NOT LIKE '[_]%'
            AND TABLE_NAME NOT LIKE 'FOREKS%'))
    AS XXX
</cfquery>

<cfif FileExists("#index_folder#CustomTags#dir_seperator#xml#dir_seperator#workcube_table.csv")>
    <cffile action="rename" source="#index_folder#CustomTags#dir_seperator#xml#dir_seperator#workcube_table.csv" destination="#index_folder#CustomTags#dir_seperator#xml#dir_seperator#workcube_table_#dateformat(now(),'ddmmyyyyhhmm')#.csv">
</cfif> 
<cffile action="write" charset="iso-8859-9" file="#index_folder#CustomTags#dir_seperator#xml#dir_seperator#workcube_table.csv" output="TABLE_CATALOG;TABLE_SCHEMA;TABLE_NAME;TABLE_TYPE" addnewline="yes">
<cfoutput query="get_all_table">
	<cfset get_all_table.TABLE_TYPE = replace("#TABLE_TYPE#",chr(13)&chr(10),"","ALL")>  
	<cffile action="append" charset="iso-8859-9" file="#index_folder#CustomTags#dir_seperator#xml#dir_seperator#workcube_table.csv" output="#TABLE_CATALOG#;#TABLE_SCHEMA#;#TABLE_NAME#;#TABLE_TYPE#;" addnewline="yes">
</cfoutput>
<cfif FileExists("#index_folder#CustomTags#dir_seperator#xml#dir_seperator#workcube_column.csv")>
    <cffile action="rename" source="#index_folder#CustomTags#dir_seperator#xml#dir_seperator#workcube_column.csv" destination="#index_folder#CustomTags#dir_seperator#xml#dir_seperator#workcube_column.csv#dateformat(now(),'ddmmyyyyhhmm')#.csv">
</cfif> 
<cffile action="write" charset="iso-8859-9" file="#index_folder#CustomTags#dir_seperator#xml#dir_seperator#workcube_column.csv" output="TABLE_NAME;COLUMN_NAME;DATA_TYPE;CHARACTER_MAXIMUM_LENGTH;IS_NULLABLE;IS_IDENTITY;INCREMENT;SEED" addnewline="yes">
<cfoutput query="get_all_column">
	<cfset get_all_column.SEED = replace("#SEED#",chr(13)&chr(10),"","ALL")>  
	<cffile action="append" charset="iso-8859-9" file="#index_folder#CustomTags#dir_seperator#xml#dir_seperator#workcube_column.csv" output="#TABLE_NAME#;#COLUMN_NAME#;#DATA_TYPE#;#CHARACTER_MAXIMUM_LENGTH#;#IS_NULLABLE#;#IS_IDENTITY#;#INCREMENT#;#SEED#;" addnewline="yes">
</cfoutput>

<cflocation url="#request.self#?fuseaction=settings.import_export_table_column" addtoken="no">
