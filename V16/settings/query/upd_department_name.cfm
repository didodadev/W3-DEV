<cfif IsDefined('attributes.department_name')  and len(attributes.department_name) and IsDefined('attributes.dep_name_id') and len(attributes.dep_name_id)> 
<cfquery name="ADD_NAME" datasource="#dsn#">
	UPDATE
		SETUP_DEPARTMENT_NAME
	SET
		IS_ACTIVE = <cfif isdefined("attributes.is_active")>1,<cfelse>0,</cfif>
		DEPARTMENT_NAME='#attributes.department_name#',
		DETAIL='#attributes.department_name_detail#',
		UPDATE_IP = '#cgi.remote_addr#',
		UPDATE_DATE = #now()#,
		UPDATE_EMP = #session.ep.userid#	 
	WHERE
		DEPARTMENT_NAME_ID=#attributes.dep_name_id#
</cfquery>
</cfif>
<cflocation url="#request.self#?fuseaction=settings.form_upd_department_name&dep_name_id=#attributes.dep_name_id#" addtoken="no">
