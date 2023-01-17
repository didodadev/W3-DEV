<cfquery name="UPDOFFER_CURRENCY" datasource="#dsn3#">
	UPDATE 
		OFFER_CURRENCY 
	SET 
		OFFER_CURRENCY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#OFFER_CURRENCY#"> ,
		UPDATE_DATE = #now()#,
		UPDATE_EMP = #session.ep.userid#		
	WHERE 
		OFFER_CURRENCY_ID=#OFFER_CURRENCY_ID#
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_offer_currency" addtoken="no">
