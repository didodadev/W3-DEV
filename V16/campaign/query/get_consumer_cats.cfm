<cfquery name="CONSUMER_CATS" datasource="#dsn#">
	SELECT
		*
	FROM
		CONSUMER_CAT
	ORDER BY
		HIERARCHY
</cfquery>	
	

