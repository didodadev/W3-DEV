<cfquery NAME="UPD_SERVICE_CARE_CAT" DATASOURCE="#DSN3#">
	UPDATE
		SERVICE_CARE_CAT
	SET 
		SERVICE_CARE = '#attributes.service_cat#',
		DETAIL = <cfif len(attributes.detail)>'#attributes.detail#'<cfelse>NULL</cfif>,
		UPDATE_IP = '#cgi.remote_addr#',
		UPDATE_DATE = #now()#,
		UPDATE_EMP = #session.ep.userid#
	WHERE
		SERVICE_CARECAT_ID=#attributes.service_carecat_id#
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_service_care_cat" addtoken="no">





















