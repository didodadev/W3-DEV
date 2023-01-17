<cfquery name="CHECK" datasource="#dsn3#">
	SELECT
		CAMP_ID
	FROM
		CAMPAIGNS
	WHERE
		','TMARKET_IDS',' LIKE '%#TMARKET_ID#%'
</cfquery>
