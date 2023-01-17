<cfquery name="GET_TARGET_CATS" datasource="#dsn#">
	SELECT 
		*
	FROM	
		TARGET_CAT
	ORDER BY
		TARGETCAT_NAME
</cfquery>
