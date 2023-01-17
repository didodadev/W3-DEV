<cfquery name="GET_BRAND" datasource="#dsn#">
	SELECT 
		BRAND_NAME
	FROM 
		SETUP_BRAND
	<cfif isdefined("attributes.brand_id")>
	WHERE
		BRAND_ID = #attributes.brand_id#
	</cfif>	
</cfquery>
