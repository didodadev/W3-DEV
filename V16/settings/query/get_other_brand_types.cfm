<cfquery name="get_other_types" datasource="#dsn#">
	SELECT 
		* 
	FROM 
		SETUP_BRAND_TYPE
	WHERE
		BRAND_ID = #attributes.brand_id#	
</cfquery>	
