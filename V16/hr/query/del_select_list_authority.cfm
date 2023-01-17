<cfif attributes.valid_status eq 1>
	<cfquery name="upd_authority" datasource="#dsn#">
		UPDATE EMPLOYEES_APP_AUTHORITY SET AUTHORITY_STATUS = 0 WHERE LIST_ID=#attributes.list_id# AND POS_CODE=#attributes.pos_code#	
	</cfquery>
<cfelse>	
	<cfquery name="del_authority" datasource="#dsn#">
		DELETE FROM EMPLOYEES_APP_AUTHORITY WHERE LIST_ID=#attributes.list_id# AND POS_CODE=#attributes.pos_code#
	</cfquery>
</cfif>
<cflocation url="#request.self#?fuseaction=hr.popup_upd_select_list&list_id=#attributes.list_id#" addtoken="no">
