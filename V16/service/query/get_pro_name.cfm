<cfquery name="GET_PRO_NAME" datasource="#dsn3#">
	SELECT	
		*
	FROM
		PRODUCT
	WHERE
		PRODUCT_ID=#PRO_ID#
</cfquery>
