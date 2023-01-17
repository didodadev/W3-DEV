
<cfquery name="del_defect_code" datasource="#dsn3#">
	DELETE FROM SETUP_SERVICE_CODE WHERE SERVICE_CODE_ID = #ATTRIBUTES.SERVICE_CODE_ID#
</cfquery>

<cflocation url="#request.self#?fuseaction=settings.form_add_service_defect_code" addtoken="no">

