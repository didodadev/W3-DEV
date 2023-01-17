<cfquery name="GET_ZONE_BRANCH_COUNT" datasource="#dsn#">
	SELECT 
		ZONE_ID, 
		COUNT(BRANCH_ID) AS TOTAL
	FROM 
		BRANCH
	WHERE 
		ZONE_ID=#attributes.ZONE_ID#
	GROUP BY
		ZONE_ID
</cfquery>
