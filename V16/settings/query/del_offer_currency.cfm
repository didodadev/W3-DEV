<cfquery name="DELOFFER_CURRENCY" datasource="#dsn3#">
	DELETE FROM OFFER_CURRENCY WHERE OFFER_CURRENCY_ID=#OFFER_CURRENCY_ID#
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_offer_currency" addtoken="no">
