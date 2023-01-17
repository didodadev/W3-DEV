<cfquery NAME="DEL_SERVICE_CARE_CAT" DATASOURCE="#DSN3#">
	DELETE
	FROM
		SERVICE_CARE_CAT
	WHERE
		SERVICE_CARECAT_ID=#attributes.SERVICE_CARECAT_ID#
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_service_care_cat" addtoken="no">

