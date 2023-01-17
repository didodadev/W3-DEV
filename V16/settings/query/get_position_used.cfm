<cfquery name="POSITION_USED" datasource="#dsn#">
	SELECT 
		POSITION_CAT_ID
	FROM 
		SETUP_POSITION_CAT
	WHERE 
		POSITION_ID = #attributes.TITLE_ID#
</cfquery>		

