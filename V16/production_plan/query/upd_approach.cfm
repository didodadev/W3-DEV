<cfquery name="upd_approach" datasource="#DSN3#">
    UPDATE 
        STOCKS 
    SET 
        PRODUCTION_TYPE = <cfif isdefined("attributes.approach") and len(attributes.approach)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.approach#"><cfelse>NULL</cfif>,
        PRODUCTION_AMOUNT_TYPE = <cfif isdefined("attributes.is_used_rate") and len(attributes.is_used_rate)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.is_used_rate#"><cfelse>NULL</cfif>
    WHERE  
        STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.stock_id#">
</cfquery> 

<script>
    window.location.href="<cfoutput>#request.self#?fuseaction=prod.list_product_tree&event=upd&stock_id=#attributes.stock_id#</cfoutput>";
</script>