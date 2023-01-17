<cfquery name="FAX_CONT" datasource="#dsn3#">
	SELECT
		*
	FROM
		CAMPAIGN_FAX_CONT
	WHERE
		FAX_CONT_ID = #FAX_CONT_ID#
</cfquery>	
	

