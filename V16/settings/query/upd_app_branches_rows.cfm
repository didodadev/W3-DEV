<cflock name="#createUUID()#" timeout="20">
	<cftransaction>
		<cfquery name="UPD_SETUP_APP_BRANCHES_ROWS" datasource="#dsn#">
			UPDATE 
				SETUP_APP_BRANCHES_ROWS
			SET 
				BRANCHES_ID = #branches_id#,
				BRANCHES_NAME_ROW = '#branches_name_row#',
				BRANCHES_DETAIL_ROW = '#branches_detail_row#',
				BRANCHES_STATUS_ROW = <cfif isDefined('attributes.branches_status_row')>1<cfelse>0</cfif>,
				UPDATE_DATE = #now()#,
				UPDATE_EMP = #session.ep.userid#,
				UPDATE_IP = '#cgi.remote_addr#'
			WHERE 
				BRANCHES_ROW_ID=#branches_row_id#
		</cfquery>
	</cftransaction>
</cflock>
<cflocation url="#request.self#?fuseaction=settings.list_cv_branches" addtoken="no">
