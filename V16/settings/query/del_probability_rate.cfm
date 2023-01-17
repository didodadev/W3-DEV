<cfquery name="DEL_OPPORTUNITY_CURRENCY" datasource="#dsn3#">
	DELETE FROM SETUP_PROBABILITY_RATE WHERE PROBABILITY_RATE_ID=#PROBABILITY_RATE_ID#
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_probability_rate" addtoken="no">
