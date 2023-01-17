<cfquery name="GET_ASSETP_CATS" datasource="#dsn#">
	SELECT 
		*
	FROM 
		ASSET_P_CAT
	ORDER BY
		ASSETP_CAT
</cfquery>
