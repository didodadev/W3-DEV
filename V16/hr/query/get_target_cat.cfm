<cfquery name="GET_TARGET_CAT" datasource="#dsn#">
	SELECT 
		*
	FROM	
		TARGET_CAT
	WHERE
		TARGETCAT_ID = #attributes.TARGETCAT_ID#
</cfquery>
