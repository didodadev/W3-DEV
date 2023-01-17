<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
	<cffunction name="addComplaint" access="public" returntype="any">
		<cfargument name="code" type="string" required="no" default="">
		<cfargument name="complaint" type="string" required="no">
		<cfargument name="description" type="string" required="no" default="">
		<cfquery name="INSERT_COMPLAINT" datasource="#DSN#"> 
			INSERT INTO 
				SETUP_COMPLAINTS
			(
				COMPLAINT,
				DESCRIPTION,
				IS_DEFAULT,
				CODE,
				RECORD_IP,
				RECORD_DATE,
				RECORD_EMP
			) 
			VALUES 
			(
				<cfif len(arguments.complaint)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.complaint#"><cfelse>NULL</cfif>,
				<cfif len(arguments.description)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.description#"><cfelse>NULL</cfif>,
				<cfif isDefined("arguments.is_default") and arguments.is_default eq 1>1,<cfelse>0,</cfif>
				<cfif len(arguments.code)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.code#"><cfelse>NULL</cfif>,
				'#cgi.remote_addr#',
				#now()#,
				#session.ep.userid#
			)
		</cfquery>
		
	</cffunction>

	<cffunction name="updComplaint" access="public" returntype="any">
		<cfargument name="complaint_id" type="numeric" required="yes">
		<cfargument name="code" type="string" required="no">
		<cfargument name="complaint" type="string" required="no" default="">
		<cfargument name="description" type="string" required="no" default="">
		<cfquery name="UPDATE_COMPLAINT" datasource="#DSN#">
			UPDATE 
				SETUP_COMPLAINTS
			SET 
				COMPLAINT = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.complaint#">,
				DESCRIPTION = <cfif len(arguments.description)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.description#"><cfelse>NULL</cfif>,
				IS_DEFAULT =<cfif isDefined("arguments.is_default") and arguments.is_default eq 1>1,<cfelse>0,</cfif>
				CODE = <cfif len(arguments.code)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.code#"><cfelse>NULL</cfif>,
				UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
				UPDATE_DATE = #now()#,
				UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"> 
			WHERE 
				COMPLAINT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.complaint_id#">
		</cfquery>
		<cfreturn true>
	</cffunction>
	
	<cffunction name="getComplaints" access="public" returntype="query">
		<cfargument name="complaint_id" type="numeric" required="no" default="0">
		<cfargument name="complaint_id_list" type="string" required="no" default="0">
		<cfargument name="sortdir" type="string" required="no" default="ASC">
		<cfargument name="sortfield" type="string" required="no" default="CODE">
		<cfquery name="get_complaint_list" datasource="#dsn#">
			SELECT 
			COMPLAINT_ID
			,CODE
			,DESCRIPTION
			,IS_DEFAULT
			,RECORD_IP
			,RECORD_EMP
			,RECORD_DATE
			,UPDATE_IP
			,UPDATE_EMP
			,UPDATE_DATE
			,COMPLIANT_CAT_ID
			,#dsn#.Get_Dynamic_Language(SETUP_COMPLAINTS.COMPLAINT_ID,'#session.ep.language#','SETUP_COMPLAINTS','COMPLAINT',NULL,NULL,SETUP_COMPLAINTS.COMPLAINT) AS COMPLAINT
			FROM 
				SETUP_COMPLAINTS
			WHERE
				1 = 1
				<cfif arguments.complaint_id gt 0>
					AND COMPLAINT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.complaint_id#">
				<cfelseif len(complaint_id_list) and complaint_id_list neq 0>
					AND COMPLAINT_ID IN (<cfqueryparam cfsqltype="cf_sql_varchar" list="yes" value="#arguments.complaint_id_list#">)
				<cfelseif  isdefined("complaint_id_list") and not len(complaint_id_list) and complaint_id_list neq 0>
					AND 1=0
				</cfif>
				<cfif isDefined("arguments.is_default") and len(arguments.is_default)>AND IS_DEFAULT = #arguments.is_default#</cfif>
				<cfif isDefined("arguments.keyword") and len(arguments.keyword)>AND COMPLAINT LIKE '%#arguments.keyword#%' COLLATE SQL_Latin1_General_CP1_CI_AI</cfif>
			ORDER BY
				COMPLAINT_ID,
				#arguments.sortfield# #arguments.sortdir# 
		</cfquery>
		<cfreturn get_complaint_list>
	</cffunction> 
</cfcomponent>

