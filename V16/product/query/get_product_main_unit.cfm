<cfquery name="GET_PRODUCT_MAIN_UNIT" datasource="#DSN3#">
	SELECT 
		ADD_UNIT 
	FROM 
		PRODUCT_UNIT 
	WHERE 
		PRODUCT_ID = #attributes.product_id# AND 
		IS_MAIN = 1
</cfquery>
