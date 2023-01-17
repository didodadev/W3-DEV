<cfquery name="UPD_TARGET_CAT" datasource="#DSN#">
	UPDATE 
		TARGET_CAT 
	SET 
		TARGETCAT_NAME = '#attributes.targetcat_name#',
		DETAIL = '#attributes.targetcat_detail#',
		TARGETCAT_WEIGHT = <cfif isdefined("attributes.targetcat_weight") and len(attributes.targetcat_weight)>#attributes.targetcat_weight#<cfelse>NULL</cfif>,
		UPDATE_IP = '#cgi.remote_addr#', 
		UPDATE_DATE = #now()#,
		UPDATE_EMP = #session.ep.userid#	 
	WHERE 
		TARGETCAT_ID = #attributes.targetcat_id#
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_target_cat" addtoken="no">
