<cflock name="#createUUID()#" timeout="20">
	<cftransaction>
		<cfquery name="ADD_SETUP_APP_BRANCHES" datasource="#dsn#">
			INSERT 
			INTO 
				SETUP_APP_BRANCHES
				(
					BRANCHES_NAME,
					BRANCHES_DETAIL,
					BRANCHES_STATUS,
					BRANCHES_ROW_LINE,
					BRANCHES_ROW_TYPE,
					RECORD_DATE,
					RECORD_IP,
					RECORD_EMP
				) 
			VALUES 
				(
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#branches_name#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#branches_detail#">,
					<cfif isDefined('attributes.branches_status')>1<cfelse>0</cfif>,
					<cfif isDefined('attributes.branches_row_line') and len(attributes.branches_row_line)>#attributes.branches_row_line#<cfelse>NULL</cfif>,
					<cfif isDefined('attributes.branches_row_type') and len(attributes.branches_row_type)>#attributes.branches_row_type#<cfelse>NULL</cfif>,
					#now()#,
					'#cgi.remote_addr#',
					#session.ep.userid#
				)
		</cfquery>
	</cftransaction>
</cflock>
<script>
	window.location.href = '<cfoutput>#request.self#</cfoutput>?fuseaction=settings.list_cv_branches';
</script>