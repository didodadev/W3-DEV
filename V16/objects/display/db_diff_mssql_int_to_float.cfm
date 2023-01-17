<!--- 
	SELECT * FROM systypes 104,61,62,56,99,231
	bit,datetime,float,int,ntext,nvarchar
--->
<cfset yeni_dsn = attributes.newdsn>
<cfset eski_dsn = attributes.upgrade_dsn>

<cfquery datasource="#yeni_dsn#" name="table_length">
	SELECT name,id FROM sysobjects WHERE xtype='U' AND CATEGORY<>2 AND name IN (#listqualify(attributes.tablename,"'")#) AND SUBSTRING(name,1,1) <> '_' ORDER BY name 
</cfquery>
<cfquery datasource="#eski_dsn#" name="table_length_old">
	SELECT name,id FROM sysobjects WHERE xtype='U' AND name IN (#listqualify(attributes.tablename,"'")#) AND SUBSTRING(name,1,1) <> '_' ORDER BY name 
</cfquery>

<cfquery datasource="#yeni_dsn#" name="column_length_all">
	SELECT name,xtype,isnullable,id,prec,colorder,colstat FROM syscolumns WHERE id IN (SELECT id FROM sysobjects WHERE xtype='U' AND name IN (#listqualify(attributes.tablename,"'")#) AND SUBSTRING(name,1,1) <> '_') AND name IN (#listqualify(attributes.columnnames,"'")#) AND SUBSTRING(name,1,1) <> '_' AND xtype = 62
</cfquery>
<cfquery datasource="#eski_dsn#" name="column_length_old">
	SELECT name,xtype,isnullable,id,prec,colorder,colstat FROM syscolumns WHERE id IN (SELECT id FROM sysobjects WHERE xtype='U' AND name IN (#listqualify(attributes.tablename,"'")#) AND SUBSTRING(name,1,1) <> '_') AND name IN (#listqualify(attributes.columnnames,"'")#) AND SUBSTRING(name,1,1) <> '_' AND xtype = 56
</cfquery>
<cfset sql_code = "">
<cfoutput query="table_length">
	<cfquery dbtype="query" name="syscolumns_records">
		SELECT * FROM column_length_all WHERE id = #table_length.id# ORDER BY NAME
	</cfquery>
	<cfif syscolumns_records.recordcount>
		<cfloop from="1" to="#syscolumns_records.recordcount#" index="i_column">
			<!--- yeni alan ntext eskisi nvarchar ise --->
			<cfquery dbtype="query" name="syscolumns_records_old">
				SELECT * FROM column_length_old WHERE id = #table_length_old.id# AND NAME = '#syscolumns_records.name[i_column]#'  ORDER BY NAME
			</cfquery>
			<cfif syscolumns_records_old.name eq syscolumns_records.name[i_column] and syscolumns_records_old.xtype eq 56 and syscolumns_records.xtype[i_column] eq 62>
				<cfset sql_code = sql_code & "ALTER TABLE #table_length.name# #chr(13)#">
				<cfset sql_code = sql_code & "ALTER COLUMN #chr(13)#">
				<cfset sql_code = sql_code & "	#syscolumns_records.name[i_column]# FLOAT">
				<cfif syscolumns_records.isnullable[i_column]><cfset sql_code = sql_code & " NULL; #chr(13)#"><cfelse><cfset sql_code =	sql_code & " NOT NULL; #chr(13)#"></cfif>
			</cfif>
		</cfloop>
		<cfset sql_code = sql_code & "#chr(13)#">
	</cfif>
</cfoutput>
