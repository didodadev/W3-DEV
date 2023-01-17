<cfset setupCancel = CreateObject('V16.settings.cfc.setupCancel') /> 
<cfset setupCancel.dsn3 = DSN3>
<cfif isdefined("attributes.is_active")><cfset is_active = 1><cfelse> <cfset is_active = 0></cfif>
<cfset add_cancel_type = setupCancel.addCancelTypeFnc(
	attributes.cancel_type,
	attributes.cancel_name,
	attributes.cancel_detail,
	is_active)
>
<cflocation url="#request.self#?fuseaction=settings.form_add_cancel_type" addtoken="no">
