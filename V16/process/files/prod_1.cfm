<cfquery name="UPDPR" datasource="#attributes.data_source#">
    UPDATE 
        #caller.dsn1_alias#.PRODUCT
    SET 
        PRODUCT_STATUS  = 1
    WHERE
        PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#caller.pid#">	
</cfquery>