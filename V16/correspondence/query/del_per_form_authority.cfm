<cfif isdefined("attributes.per_req_id")>
	<cfif attributes.valid_status eq 1>
		<cfquery name="upd_authority" datasource="#dsn#">
			UPDATE EMPLOYEES_APP_AUTHORITY SET AUTHORITY_STATUS = 0 WHERE PER_REQ_FORM_ID=#attributes.per_req_id# AND POS_CODE=#attributes.pos_code#
		</cfquery>
	<cfelse>
		<cfquery name="del_authority" datasource="#dsn#">
			DELETE FROM EMPLOYEES_APP_AUTHORITY WHERE PER_REQ_FORM_ID=#attributes.per_req_id# AND POS_CODE=#attributes.pos_code#
		</cfquery>
	</cfif>
	<cflocation url="#request.self#?fuseaction=correspondence.popup_upd_per_form_autority&per_req_id=#attributes.per_req_id#" addtoken="no">
<cfelseif isdefined("attributes.per_rot_id")>
	<cfif attributes.valid_status eq 1>	
		<cfquery name="upd_authority" datasource="#dsn#">
			UPDATE EMPLOYEES_APP_AUTHORITY SET AUTHORITY_STATUS = 0 WHERE ROTATION_FORM_ID=#attributes.per_rot_id# AND POS_CODE=#attributes.pos_code#
		</cfquery>
	<cfelse>	
		<cfquery name="del_authority" datasource="#dsn#">
			DELETE FROM EMPLOYEES_APP_AUTHORITY WHERE ROTATION_FORM_ID=#attributes.per_rot_id# AND POS_CODE=#attributes.pos_code#
		</cfquery>
	</cfif>
	<cflocation url="#request.self#?fuseaction=correspondence.popup_upd_per_form_autority&per_rot_id=#attributes.per_rot_id#" addtoken="no">
</cfif>

