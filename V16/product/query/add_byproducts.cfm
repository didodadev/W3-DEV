<cfquery name="ADD_BYPRODUCT" datasource="#dsn3#" result="MAX_ID">
	INSERT INTO
		PRODUCT_TREE_BY_PRODUCT
		(
			STOCK_ID,
			PRODUCT_ID,
			RELATED_STOCK_ID,
			RELATED_PRODUCT_ID,
			AMOUNT,
			AMOUNT2,
			SPECT_ID,
			COMPONENT,
			DETAIL,
			WIDTH,
			HEIGHT,
			LENGTH
		)
	VALUES
		(
			<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.stock_id#">,
			<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_id#">,
			<cfif len(attributes.related_stock_id) and len(attributes.related_stock_id) and len(attributes.product_name)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.related_stock_id#"><cfelse>NULL</cfif>,
			<cfif len(attributes.related_product_id) and len(attributes.related_product_id) and len(attributes.product_name)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.related_product_id#"><cfelse>NULL</cfif>,
			<cfif len(attributes.amount)><cfqueryparam cfsqltype="cf_sql_float" value="#attributes.AMOUNT#"><cfelse>0</cfif>,
			<cfif len(attributes.amount2)><cfqueryparam cfsqltype="cf_sql_float" value="#attributes.AMOUNT2#"><cfelse>0</cfif>,
			<cfif len(attributes.spect_main_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.spect_main_id#"><cfelse>NULL</cfif>,
			<cfif len(attributes.component)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.COMPONENT#"><cfelse>NULL</cfif>,
			<cfif len(attributes.detail)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#attributes.DETAIL#"><cfelse>NULL</cfif>,
			<cfif len(attributes.width)><cfqueryparam cfsqltype="cf_sql_float" value="#attributes.WIDTH#"><cfelse>NULL</cfif>,
			<cfif len(attributes.height)><cfqueryparam cfsqltype="cf_sql_float" value="#attributes.HEIGHT#"><cfelse>NULL</cfif>,			
			<cfif len(attributes.length)><cfqueryparam cfsqltype="cf_sql_float" value="#attributes.LENGTH#"><cfelse>NULL</cfif>
		)
</cfquery>
<script type="text/javascript">
	closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>','by_products' );
</script>
