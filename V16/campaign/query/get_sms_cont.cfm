<cfquery name="SMS_CONT" datasource="#dsn3#">
	SELECT
		*
	FROM
		CAMPAIGN_SMS_CONT
	WHERE
		SMS_CONT_ID = #SMS_CONT_ID#
</cfquery>	
	

