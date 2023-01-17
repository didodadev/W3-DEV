<cfquery name="GET_BRANCH_DEP_COUNT" datasource="#dsn#">
	SELECT 
		BRANCH_ID, 
		COUNT(DEP_ID) AS TOTAL
	FROM 
		DEPARTMAN
	WHERE 
		BRANCH_ID=#attributes.BRANCH_ID#
	GROUP BY
		BRANCH_ID
</cfquery>
