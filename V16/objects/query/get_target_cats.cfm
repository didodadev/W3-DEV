<cfquery name="GET_TARGET_CATS" datasource="#DSN#">
	SELECT 
		TARGETCAT_ID,
        TARGETCAT_NAME
	FROM	
		TARGET_CAT
  	WHERE
    	IS_ACTIVE = 1
</cfquery>
