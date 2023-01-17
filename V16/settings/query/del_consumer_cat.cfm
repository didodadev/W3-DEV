<cfquery name="DELCONSUMERCATEGORY" datasource="#dsn#">
	DELETE 
	FROM 
		CONSUMER_CAT 
	WHERE 
		CONSCAT_ID=#CONSCAT_ID#
</cfquery>
<cfquery name="DELCONSUMERCAT_OUR" datasource="#dsn#">
	DELETE FROM CONSUMER_CAT_OUR_COMPANY WHERE CONSCAT_ID = #CONSCAT_ID#
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_consumer_categories" addtoken="no">
