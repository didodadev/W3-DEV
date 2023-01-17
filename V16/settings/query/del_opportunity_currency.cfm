<cfquery name="DEL_OPPORTUNITY_CURRENCY" datasource="#dsn3#">
	DELETE FROM OPPORTUNITY_CURRENCY WHERE OPP_CURRENCY_ID=#OPPORTUNITY_CURRENCY_ID#
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_opportunity_currency" addtoken="no">
