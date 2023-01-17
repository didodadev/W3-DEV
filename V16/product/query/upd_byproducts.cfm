<cfquery name="ADD_BYPRODUCT" datasource="#dsn3#" result="MAX_ID">
	UPDATE
		PRODUCT_TREE_BY_PRODUCT
    SET
			STOCK_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.stock_id#">,
			PRODUCT_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_id#">,
			RELATED_STOCK_ID=<cfif len(attributes.related_stock_id) and len(attributes.related_stock_id) and len(attributes.product_name)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.related_stock_id#"><cfelse>NULL</cfif>,
			RELATED_PRODUCT_ID=<cfif len(attributes.related_product_id) and len(attributes.related_product_id) and len(attributes.product_name)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.related_product_id#"><cfelse>NULL</cfif>,
			AMOUNT=<cfif len(attributes.amount)><cfqueryparam cfsqltype="cf_sql_float" value="#attributes.AMOUNT#"><cfelse>0</cfif>,
			AMOUNT2=<cfif len(attributes.amount2)><cfqueryparam cfsqltype="cf_sql_float" value="#attributes.AMOUNT2#"><cfelse>0</cfif>,
			SPECT_ID=<cfif len(attributes.spect_main_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.spect_main_id#"><cfelse>NULL</cfif>,
			COMPONENT=<cfif len(attributes.component)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.COMPONENT#"><cfelse>NULL</cfif>,
			DETAIL=<cfif len(attributes.detail)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#attributes.DETAIL#"><cfelse>NULL</cfif>,
			WIDTH=<cfif len(attributes.width)><cfqueryparam cfsqltype="cf_sql_float" value="#attributes.WIDTH#"><cfelse>NULL</cfif>,
			HEIGHT=<cfif len(attributes.height)><cfqueryparam cfsqltype="cf_sql_float" value="#attributes.HEIGHT#"><cfelse>NULL</cfif>,
			LENGTH=<cfif len(attributes.length)><cfqueryparam cfsqltype="cf_sql_float" value="#attributes.LENGTH#"><cfelse>NULL</cfif>
    WHERE
            BY_PRODUCT_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.byproduct_id#">
</cfquery>
<script type="text/javascript">
	closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>','by_products' );
</script>
