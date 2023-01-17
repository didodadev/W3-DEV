<cfquery datasource="#DSN3#" name="GET_PRO_STAGE">
	SELECT 
		* 
	FROM 
		PRODUCT_STAGE
	WHERE
		PRODUCT_STAGE_ID = #attributes.PRODUCT_STAGE_ID#
</cfquery>
