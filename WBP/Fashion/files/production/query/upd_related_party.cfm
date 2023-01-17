
<cfquery name="get_related_order" datasource="#dsn3#">
            select 
					STOCKS.PRODUCT_ID,
					PO.QUANTITY,
					PO.P_ORDER_ID,
					PO.PRODUCTION_LEVEL
					from 
					PRODUCTION_ORDERS PO,STOCKS
			WHERE 
			PO.STOCK_ID=STOCKS.STOCK_ID AND
			PO.PARTY_ID=#attributes.party_id# AND 
			PO.PO_RELATED_ID IS not NULL
			ORDER BY
				PO.PRODUCTION_LEVEL,
				STOCKS.PRODUCT_ID
</cfquery>

<cfquery name="get_product" dbtype="query">
	select DISTINCT PRODUCT_ID from get_related_order
</cfquery>
<cfoutput query="get_related_order">
		<cfif not isdefined("orderid_list_#product_id#")>
				<cfset "orderid_list_#product_id#"="">
		</cfif>
		
		<cfset "orderid_list_#product_id#"=ListAppend(evaluate("orderid_list_#product_id#"),p_order_id)>
		<cfif not isdefined("product_sum_amount_#product_id#")>
				<cfset "product_sum_amount_#product_id#"=0>
		</cfif>
		<cfset "product_sum_amount_#product_id#"=evaluate("product_sum_amount_#product_id#")+quantity>
</cfoutput>
		<cfoutput query="get_product">
					<cfquery name="UPD_GEN_PAP" datasource="#dsn3#">
								UPDATE 
									GENERAL_PAPERS
								SET
									CATALOG_NUMBER = CATALOG_NUMBER+1
								WHERE PAPER_TYPE IS NULL AND ZONE_TYPE=0
						</cfquery>	
				<cfquery name="get_party_no_" datasource="#dsn3#">
					SELECT CATALOG_NO,CATALOG_NUMBER FROM GENERAL_PAPERS
					WHERE PAPER_TYPE IS NULL AND ZONE_TYPE=0
				</cfquery>
				<cfset party_amount=evaluate("product_sum_amount_#get_product.product_id#")>
				<cfset party_paperno_="#get_party_no_.catalog_no#"&"#get_party_no_.catalog_number#">
					<cfquery name="add_production_orders_main" datasource="#dsn3#" result="MAX_ID">
						INSERT INTO [dbo].[PRODUCTION_ORDERS_MAIN]
						   (
							[PARTY_NO]
						   ,[PARTY_STARTDATE]
						   ,[PARTY_FINISHDATE]
						   ,[STAGE]
						   ,[PRODUCT_ID]
						   ,[COLOR_ID]
						   ,[OPERATION_TYPE_ID]
						   ,AMOUNT
						   ,RELATED_PARTY_ID
							)
					 VALUES
						   (
							'#party_paperno_#'
						   ,#attributes.party_start_date#
						   ,#attributes.party_finish_date#
						   ,#attributes.process_stage#
						   ,#get_product.product_id#
						   ,#attributes.colorid#
						   ,#listgetat(Evaluate('attributes.op_id_#prod_ind#'),1,',')#
						   ,#party_amount#
						   ,#attributes.party_id#
							)
					</cfquery>
			<cfset sub_party_id=MAX_ID.IDENTITYCOL>
				<cfloop list="#evaluate("orderid_list_#get_product.product_id#")#" index="xx">
						<cfquery name="upd_ord" datasource="#dsn3#">
								UPDATE PRODUCTION_ORDERS
									  SET PARTY_ID=#sub_party_id#
								WHERE P_ORDER_ID=#xx#
						</cfquery>
				</cfloop>
		</cfoutput>
