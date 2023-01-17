<cfquery name="GET_ASSETP_CATS_RESERVE" datasource="#dsn#">
	SELECT 
		*
	FROM 
		ASSET_P_CAT
	WHERE 
		ASSETP_RESERVE = 1
	ORDER BY
		ASSETP_CAT
</cfquery>
