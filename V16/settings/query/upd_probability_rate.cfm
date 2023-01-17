<cfquery name="UPD_OPPORTUNITY_CURRENCY" datasource="#dsn3#">
	UPDATE 
		SETUP_PROBABILITY_RATE 
	SET 
		PROBABILITY_RATE = '#PROBABILITY_RATE#',
		PROBABILITY_NAME = '#PROBABILITY_NAME#',
		UPDATE_DATE = #now()#,
		UPDATE_EMP = #session.ep.userid#		
	WHERE
		PROBABILITY_RATE_ID = #PROBABILITY_RATE_ID#
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_probability_rate" addtoken="no">
