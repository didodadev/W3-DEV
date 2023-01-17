<cflock timeout="60">
	<cftransaction>
		<cfquery name="UPD_BRANCH_CAT" datasource="#DSN#">
			UPDATE 
				SETUP_BRANCH_CAT
			SET 
				BRANCH_CAT = '#attributes.branch_cat#',
				DETAIL = '#attributes.detail#',
				UPDATE_IP = '#cgi.remote_addr#',
				UPDATE_DATE = #now()#,
				UPDATE_EMP = #session.ep.userid#
			WHERE 
				BRANCH_CAT_ID = #attributes.branch_cat_id#
		</cfquery>
	</cftransaction>
</cflock>
<cflocation url="#request.self#?fuseaction=settings.add_branch_cat" addtoken="no">
