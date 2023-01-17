<cfquery name="UPD_OPPORTUNITY_CURRENCY" datasource="#dsn3#">
	UPDATE 
		OPPORTUNITY_CURRENCY 
	SET 
		OPP_CURRENCY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#OPPORTUNITY_CURRENCY#">,
		UPDATE_DATE = #now()#,
		UPDATE_EMP = #session.ep.userid#		
	WHERE
		OPP_CURRENCY_ID = #OPPORTUNITY_CURRENCY_ID#
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_opportunity_currency" addtoken="no">
