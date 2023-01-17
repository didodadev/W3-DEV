<cfquery name="GET_PRODUCT_INFO" datasource="#DSN2#">
	SELECT DISTINCT
		S.BARCOD,
		S.STOCK_ID,
		S.PRODUCT_ID,
		S.PRODUCT_NAME,
		S.TAX,
		S.IS_INVENTORY,
		PU.MAIN_UNIT,
		PU.MAIN_UNIT_ID,
		PU.ADD_UNIT,
		PU.UNIT_ID,
		ISNULL(PU.MULTIPLIER,0) MULTIPLIER
	FROM
		#dsn3_alias#.STOCKS S,
		#dsn3_alias#.PRODUCT_UNIT PU, 
		#dsn3_alias#.STOCKS_BARCODES SB
	WHERE
		SB.STOCK_ID = S.STOCK_ID AND 
		S.PRODUCT_STATUS = 1 AND 
		S.STOCK_STATUS = 1 AND 
		S.PRODUCT_ID = PU.PRODUCT_ID AND 
		SB.UNIT_ID = PU.PRODUCT_UNIT_ID AND
		SB.BARCODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Evaluate("attributes.barcode#i#")#">
</cfquery>
<cfset amount_row_ = Evaluate("attributes.amount#i#")>
<cfset "attributes.stock_id#i#" = get_product_info.stock_id>
<cfset "attributes.product_id#i#" = get_product_info.product_id>
<cfset "attributes.product_name#i#" = get_product_info.product_name>
<cfset "attributes.unit_other#i#" = get_product_info.add_unit>
<cfset "attributes.amount_other#i#" = amount_row_>
<cfset "attributes.unit#i#" = get_product_info.main_unit>
<cfset "attributes.unit_id#i#" = get_product_info.main_unit_id>
<cfset "attributes.amount#i#" = amount_row_ * get_product_info.multiplier>
<cfset "attributes.tax#i#" = get_product_info.tax>
<cfset "attributes.is_inventory#i#" = get_product_info.is_inventory>
