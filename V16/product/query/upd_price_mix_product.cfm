<cfloop from=1 to="#attributes.record_count#" index="k">
<cfscript>
   entry_id= evaluate('attributes.entry_id#k#');
   price=replace(evaluate('attributes.new_price#k#'),",",".");
</cfscript>
  <cfset row_money = listfirst(evaluate("attributes.p_money#k#"),';')>
	<cfif len(price)>
        <cfquery name="" datasource="#DSN1#">
            UPDATE 
                KARMA_PRODUCTS
            SET
                SALES_PRICE=<cfqueryparam cfsqltype="cf_sql_float" value="#price#">,
                MONEY =<cfqueryparam cfsqltype="cf_sql_varchar" value="#row_money#">
            WHERE
                ENTRY_ID=#entry_id#
         </cfquery>
     </cfif>
</cfloop>
<script type="text/javascript">
	window.location.href = '<cfoutput>#request.self#</cfoutput>?fuseaction=product.collacted_product_prices&event=upd-mix&p_product_id=<cfoutput>#attributes.product_id#</cfoutput>&form_varmi=1';
</script>
