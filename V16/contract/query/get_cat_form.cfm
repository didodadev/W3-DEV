<cfquery name="GET_CAT" datasource="#dsn3#">
	SELECT 
		* 
	FROM 
		CONTRACT_CAT 
	WHERE 
		CONTRACT_CAT_ID=#CAT_ID#
	ORDER BY
		CONTRACT_CAT 
</cfquery>
