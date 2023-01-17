<!--- 
SELECT * FROM systypes 104,61,62,56,99,231,108
bit,datetime,float,int,ntext,nvarchar,numeric
--->
<cfset yeni_dsn = attributes.newdsn>

<cfquery datasource="#yeni_dsn#" name="dsndsn">
	SELECT name,id FROM sysobjects WHERE xtype='U' AND CATEGORY<>2 AND name IN (#listqualify(attributes.tablename,"'")#) AND SUBSTRING(name,1,1) <> '_' and  schema_name(uid)='#yeni_dsn#' ORDER BY name 
</cfquery>
<cfquery datasource="#yeni_dsn#" name="syscolumns_records_all">
	SELECT name,xtype,isnullable,id,prec,colorder,colstat,xscale FROM syscolumns WHERE id IN (SELECT id FROM sysobjects WHERE xtype='U' AND name IN (#listqualify(attributes.tablename,"'")#) AND SUBSTRING(name,1,1) <> '_' and  schema_name(uid)='#yeni_dsn#') AND name IN (#listqualify(attributes.columnnames,"'")#) AND SUBSTRING(name,1,1) <> '_'
</cfquery>

<cfset sql_code = "">
<cfoutput query="dsndsn">
	<cfquery dbtype="query" name="syscolumns_records">
		SELECT * FROM syscolumns_records_all WHERE id = #dsndsn.id# ORDER BY colorder
	</cfquery>
	<cfif syscolumns_records.recordcount>
		<cfset sql_code = sql_code & "ALTER TABLE #dsndsn.NAME# #chr(13)#">
		<cfset sql_code = sql_code & "ADD #chr(13)#">
		<cfloop query="syscolumns_records">
			<cfswitch expression="#ListFind('104,61,62,56,99,231,108',syscolumns_records.xtype)#">
				<cfcase value="1"><cfset sql_code =	sql_code & "	[#syscolumns_records.name#] [bit]"> <cfif syscolumns_records.isnullable><cfset sql_code = sql_code & " NULL"><cfelse><cfset sql_code = sql_code & " NOT NULL"></cfif></cfcase>
				<cfcase value="2"><cfset sql_code =	sql_code & "	[#syscolumns_records.name#] [datetime]"> <cfif syscolumns_records.isnullable><cfset sql_code = sql_code & " NULL"><cfelse><cfset sql_code =	sql_code & " NOT NULL"></cfif></cfcase>
				<cfcase value="3"><cfset sql_code =	sql_code & "	[#syscolumns_records.name#] [float]"> <cfif syscolumns_records.isnullable><cfset sql_code = sql_code & " NULL"><cfelse><cfset sql_code = sql_code & " NOT NULL"></cfif></cfcase>
				<cfcase value="4"><cfset sql_code =	sql_code & "	[#syscolumns_records.name#] [int]"> <cfif syscolumns_records.isnullable><cfset sql_code = sql_code & " NULL"><cfelseif syscolumns_records.colstat><cfset sql_code = sql_code & " IDENTITY (1, 1) NOT NULL"><cfelse><cfset sql_code = sql_code & " NOT NULL"></cfif></cfcase>
				<cfcase value="5"><cfset sql_code =	sql_code & "	[#syscolumns_records.name#] [ntext]"> <cfif syscolumns_records.isnullable><cfset sql_code = sql_code & " NULL"><cfelse><cfset sql_code = sql_code & " NOT NULL"></cfif></cfcase>
				<cfcase value="6"><cfset sql_code =	sql_code & "	[#syscolumns_records.name#] [nvarchar] (#syscolumns_records.prec#)"> <cfif syscolumns_records.isnullable><cfset sql_code = sql_code & " NULL"><cfelse><cfset sql_code =	sql_code & " NOT NULL"></cfif></cfcase>
				<cfcase value="7"><cfset sql_code =	sql_code & "	[#syscolumns_records.name#] [numeric] (#syscolumns_records.prec#,#syscolumns_records.xscale#)"> <cfif syscolumns_records.isnullable><cfset sql_code = sql_code & " NULL"><cfelse><cfset sql_code =	sql_code & " NOT NULL"></cfif></cfcase>
			</cfswitch>
			<cfif syscolumns_records.recordcount neq syscolumns_records.currentrow><cfset sql_code = sql_code & ",#chr(13)#"></cfif><!--- <cfset sql_code = sql_code & "#chr(13)#"> --->
		</cfloop>
		<cfset sql_code = sql_code & "; #chr(13)##chr(13)#">
	</cfif>
</cfoutput>
