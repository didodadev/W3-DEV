<cfquery datasource="#caller.dsn1#" name="updpr">
UPDATE 
	PRODUCT
SET 
	PRODUCT_STATUS  = 0 
WHERE
	PRODUCT_ID = #caller.pid#	
</cfquery>

