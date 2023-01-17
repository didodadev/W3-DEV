<cfquery name="upd" datasource="#dsn#">
	DELETE FROM SMS_TEMPLATE WHERE SMS_TEMPLATE_ID =#attributes.sms_template_id#
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_sms_template" addtoken="no">
