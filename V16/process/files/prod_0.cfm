<cfquery datasource="#attributes.data_source#" name="updpr">
    UPDATE 
        #caller.dsn1_alias#.PRODUCT
    SET 
        PRODUCT_STATUS  = 0 
    WHERE
        PRODUCT_ID = #caller.pid#	
</cfquery>

