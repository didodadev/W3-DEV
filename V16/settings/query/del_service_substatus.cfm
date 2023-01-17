<cfquery name="DELSERVICESTATUS" datasource="#dsn3#">
	DELETE FROM SERVICE_SUBSTATUS WHERE SERVICE_SUBSTATUS_ID=#SERVICE_SUBSTATUS_ID#
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_service_substatus" addtoken="no">
