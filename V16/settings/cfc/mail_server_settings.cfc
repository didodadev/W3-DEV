<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
	<cffunction  name="Insert" access="public" returnType="any">
		<cfargument  name="server_name" type="string" default="">
		<cfquery name="ADD_MAIL_SERVER" datasource="#dsn#" result="result">
			INSERT INTO 
				MAIL_SERVER_SETTINGS
				(
					SERVER_NAME,
					RECORD_EMP,
					RECORD_IP,
					RECORD_DATE
				)
			VALUES 
				(
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.server_name#">,
					#session.ep.userid#,
					'#cgi.remote_addr#',
					#now()#
				)
		</cfquery>
		<cfset response = result>
		<cfreturn response>
	</cffunction>
	<cffunction  name="Update" access="public">
		<cfargument  name="server_name" type="string" default="">
		<cfquery name="UPD_MAIL_SERVER" datasource="#dsn#">
			UPDATE
				MAIL_SERVER_SETTINGS
			SET
				SERVER_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.server_name#">,
				UPDATE_EMP = #session.ep.userid#,
				UPDATE_IP = '#cgi.remote_addr#',
				UPDATE_DATE= #now()#
			WHERE
				SERVER_NAME_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.SERVER_NAME_ID#">
		</cfquery>
	</cffunction>
	<cffunction name="Select" access="public">
		<cfargument name="keyword" type="string" default="">
		<cfargument name="SERVER_NAME_ID" type="numeric">
		<cfquery name="GET_MAIL_SERVER" datasource="#dsn#">
			SELECT 
				*
			FROM
				MAIL_SERVER_SETTINGS
			WHERE
				1=1
				<cfif isDefined('arguments.keyword') and len(arguments.keyword)>AND SERVER_NAME LIKE <cfqueryparam cfsqltype="cf_sql_nvarchar" value="%#arguments.keyword#%"></cfif> 
				<cfif isDefined('arguments.SERVER_NAME_ID') and len(arguments.SERVER_NAME_ID)>AND SERVER_NAME_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.SERVER_NAME_ID#"></cfif>
		</cfquery>
		<cfreturn GET_MAIL_SERVER>
	</cffunction>
	<cffunction  name="Delete" access="public">
		<cfquery name="DEL_MAIL_SERVER" datasource="#dsn#">
			DELETE
			FROM
				MAIL_SERVER_SETTINGS
			WHERE
				SERVER_NAME_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.server_name_id#">
		</cfquery>
	</cffunction>
</cfcomponent>