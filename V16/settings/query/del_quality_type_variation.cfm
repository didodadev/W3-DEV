<cfquery name="DEL_QUALITY_CONTROL_TYPE_VARIATION" datasource="#DSN3#">
	DELETE
	FROM
		QUALITY_CONTROL_ROW
	WHERE
		QUALITY_CONTROL_ROW_ID=#attributes.id#
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_quality_type_variation" addtoken="no">
