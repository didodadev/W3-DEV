<cfquery name="GET_COMPETITIVE_NAME" datasource="#DSN3#">
SELECT
	*
FROM	
	PRODUCT_COMP
WHERE
	COMPETITIVE_ID=#attributes.COMPETITIVE_ID#	
</cfquery>
