<cfquery name="DELMOBILCAT" datasource="#dsn#">
	DELETE FROM SETUP_MONEY	WHERE PERIOD_ID = #SESSION.EP.PERIOD_ID# AND MONEY_ID=#MONEY_ID#
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_money" addtoken="no">
