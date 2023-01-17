<cfset upd_internaldemand=arraynew(2)>
<cfquery name="GET_INTERNAL" datasource="#dsn3#">
	SELECT 
		* 
	FROM 
		INTERNALDEMAND
	WHERE 
		INTERNAL_ID=#attributes.ID#
</cfquery>
<cfquery name="GET_STOCK_ID" datasource="#DSN3#">
	SELECT 
		STOCK_ID,PRICE,TAX
	FROM 
		INTERNALDEMAND_ROW
	WHERE 
		I_ID = #attributes.ID#		   
</cfquery>
<cfoutput query="get_internal">
	<cfset total_demand_upd=get_internal.total>
	<cfset net_total_demand_upd=get_internal.net_total>
	<cfset total_tax_demand_upd=get_internal.total_tax>				
	<cfset discount_demand_upd=get_internal.discount>
	<cfset attributes.stock_ids = "0#GET_STOCK_ID.stock_id#0">
	<cfset row=listlen(GET_STOCK_ID.stock_id)>
	<cfset row_demand=listlen(GET_STOCK_ID.stock_id)>
	<cfset var_="upd_internaldemand">
	<cfset array_poz= 1>
	<cfloop from="1" to="#row#" index="k">
		<cfset upd_internaldemand[array_poz][10]=listgetat(GET_STOCK_ID.stock_id,k)>
		<cfset upd_internaldemand[array_poz][6]=listgetat(GET_STOCK_ID.price,k)>
		<cfset upd_internaldemand[array_poz][7]=listgetat(GET_STOCK_ID.tax,k)>
		<cfset upd_internaldemand[array_poz][8]=get_internal.discount>
		<cfquery name="GET_PRODUCT" datasource="#dsn3#">
			SELECT 
				*
			FROM
				STOCKS
			WHERE 
				STOCK_ID=#UPD_INTERNALDEMAND[ARRAY_POZ][10]#
		</cfquery>
		<cfset upd_internaldemand[array_poz][1]= get_product.product_id>
		<cfset upd_internaldemand[array_poz][11] = get_product.barcod>
		<cfset upd_internaldemand[array_poz][12] = get_product.stock_code >
		<cfquery name="GET_PRODUCT_NAME" datasource="#dsn3#">
			SELECT 
				PRODUCT_ID,
				PRODUCT_NAME
			FROM
				PRODUCT
			WHERE 
				PRODUCT_ID=#UPD_INTERNALDEMAND[ARRAY_POZ][1]#
		</cfquery>
		<cfset upd_internaldemand[array_poz][2]= get_product_name.product_name>
		<cfset upd_internaldemand[array_poz][15] =0>
		<cfset upd_internaldemand[array_poz][16] =0>
		<cfset upd_internaldemand[array_poz][17] =0>		
		<cfset upd_internaldemand[array_poz][18] =0>
		<cfset upd_internaldemand[array_poz][19] =0>
		<cfset upd_internaldemand[array_poz][20] =0>
		<cfset upd_internaldemand[array_poz][13] =0>		
		<cfset upd_internaldemand[array_poz][14] =0>
		<cfset upd_internaldemand[array_poz][27] =0>
		<cfset upd_internaldemand[array_poz][28] =0>
		<cfset upd_internaldemand[array_poz][40] ="">		
		<cfset upd_internaldemand[array_poz][39] ="">				
		<cfset array_poz=array_poz + 1>
	</cfloop>
</cfoutput>
