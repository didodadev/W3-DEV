<cfquery name="GET_ASSETS" datasource="#dsn#">
		SELECT 
		    MODULE_NAME
		FROM 
			ASSET
		WHERE
			PROPERTY_ID = #attributes.CONTENT_PROPERTY_ID#
</cfquery>
