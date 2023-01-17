<cfif isdefined("attributes.compid")>
	<cfset dsn3 = "#dsn#_#attributes.compid#">
</cfif>

<cf_papers paper_type="CAT_PROM">
<cfset system_paper_no=paper_code & '-' & paper_number>
<cfset system_paper_no_add=paper_number>
<cfif isdefined("attributes.extra_price_list") and len(attributes.extra_price_list)>
	<cfquery name="GET_PRICE_CAT_ROW" datasource="#DSN3#" maxrows="3">
		SELECT PRICE_CAT,PRICE_CATID FROM PRICE_CAT WHERE PRICE_CATID IN(#attributes.extra_price_list#)
	</cfquery>
</cfif>
<cf_date tarih="form.startdate">
<cf_date tarih="form.finishdate">
<cfif isdefined("form.kondusyon_date")><cf_date tarih="form.kondusyon_date"></cfif>
<cfif isdefined("form.kondusyon_finish_date")><cf_date tarih="form.kondusyon_finish_date"></cfif>
<cflock name="#CreateUUID()#" timeout="20">
	<cftransaction>
		<cfquery name="ADD_CATALOG" datasource="#DSN3#">
			INSERT INTO
				CATALOG_PROMOTION
			(
				IS_PUBLIC,
				STAGE_ID,
				PROCESS_STAGE,
				CATALOG_STATUS,
				STARTDATE,
				FINISHDATE,
				CAMP_ID,
				RELATED_CATALOG_ID,
				KONDUSYON_DATE,
				KONDUSYON_FINISH_DATE,
				CATALOG_HEAD,
				CATALOG_DETAIL,
				RECORD_DATE,
				RECORD_IP,
				RECORD_EMP
			<cfif len(attributes.validator_position_code)>
				,VALIDATOR_POSITION_CODE
			<cfelse>	
				,VALID
				,VALID_EMP
				,VALIDATE_DATE
			</cfif>
				,CAT_PROM_NO
				,EXTRA_PRICE_CATID
			)
			VALUES
			(
				<cfif isdefined("attributes.is_public")>1<cfelse>0</cfif>,
				#FORM.STAGE_ID#,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_stage#">,
				1,
				#FORM.STARTDATE#,
				#FORM.FINISHDATE#,
				<cfif len(attributes.camp_id) and len(attributes.camp_name)>#attributes.CAMP_ID#<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.related_catalog_id") and  isdefined("attributes.related_catalog_head") and len(attributes.related_catalog_id) and len(attributes.related_catalog_head)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.related_catalog_id#"><cfelse>NULL</cfif>,
				<cfif isdefined("form.kondusyon_date")>#FORM.KONDUSYON_DATE#<cfelse>NULL</cfif>,
				<cfif isdefined("form.kondusyon_finish_date")>#FORM.KONDUSYON_FINISH_DATE#<cfelse>NULL</cfif>,
				'#TRIM(FORM.CATALOG_HEAD)#',
				'#TRIM(FORM.DETAIL)#',
				#now()#,
				'#cgi.remote_addr#',
				#session.ep.userid#
				<cfif len(attributes.validator_position_code)>
				,#attributes.validator_position_code#			
				<cfelse>	
				,1
				,#session.ep.userid#
				,#now()#
				</cfif>
				,'#system_paper_no#'
			<cfif isdefined("attributes.extra_price_list") and len(attributes.extra_price_list)>
				,'#attributes.extra_price_list#'
			<cfelse>
				,NULL
			</cfif>
			)					
		</cfquery>
		<cfquery name="GET_CATID" datasource="#DSN3#">
			SELECT
				MAX(CATALOG_ID) CURRENT_CAT
			FROM
				CATALOG_PROMOTION
		</cfquery>
		
		<cfloop from="1" to="#attributes.record_num#" index="i">
			<cfif evaluate("attributes.row_kontrol#i#") neq 0>
				<cfquery name="ADD_CATALOG_PRODUCT" datasource="#DSN3#">
					INSERT INTO 
						CATALOG_PROMOTION_PRODUCTS 
					(
						CATALOG_ID,
						PRODUCT_ID,
						STOCK_ID,
						DISCOUNT1,
						DISCOUNT2,
						DISCOUNT3,
						DISCOUNT4,
						DISCOUNT5,
						DISCOUNT6,
						DISCOUNT7,
						DISCOUNT8,
						DISCOUNT9,
						DISCOUNT10,
						PROFIT_MARGIN,
						ACTION_PRICE,
						ACTION_PRICE_KDVSIZ,
						ACTION_PRICE_DISCOUNT,
						ACTION_PROFIT_MARGIN,
						RETURNING_PRICE,
						RETURNING_PRICE_KDVSIZ,
						RETURNING_PRICE_DISCOUNT,
						TAX,
						TAX_PURCHASE,
						PRODUCT_UNIT_ID,
						UNIT,
						MONEY,
						PURCHASE_PRICE,
						PURCHASE_PRICE_KDV,
						SALES_PRICE,
						ROW_NETTOTAL,
						ROW_TOTAL,
						DUEDATE,
						SHELF_ID,
						REBATE_CASH_1,
						REBATE_CASH_1_MONEY,
						REBATE_RATE,
						RETURN_DAY,
						RETURN_RATE,
						PRICE_PROTECTION_DAY,
						EXTRA_PRODUCT_1,
						EXTRA_PRODUCT_2,
						PAGE_NO,
						PAGE_TYPE_ID,
						DETAIL_INFO,
						REFERENCE_CODE,
						SALE_MONEY_TYPE,
						CUSTOMER_NUMBER,
						UNIT_SALE,
						TOTAL_SALE,
						SALE_TYPE_INFO,
						PAPER_TYPE,
						EXTRA_PRODUCT_COST,
						PROMOTION_ID,
						PROM_POINT,
						AMOUNT_1,
						PROFITABILITY,
						AMOUNT_DISCOUNT_2,
						TOTAL_PROMOTION_COST,
						SPECIAL_PRODUCT_DISCOUNT_RATE,
						NUMBER_GIFT_PRODUCT_RATIO,
						NUMBER_GIFT_PRODUCT,
						FREE_STOCK_ID,
						FREE_STOCK_AMOUNT,
						PROMOTION_CODE,
						EXTRA_PRODUCT_MARJ
					<cfif isdefined("attributes.extra_price_list") and get_price_cat_row.recordcount>
						<cfloop query="get_price_cat_row">
							,EXTRA_PRICEKDV_#get_price_cat_row.currentrow#
						</cfloop>
					</cfif>						
					)
					VALUES   
					(
						#get_catid.current_cat#,
						#evaluate('attributes.product_id#i#')#,
						<cfif isdefined("attributes.stock_id#i#") and len(evaluate('attributes.stock_id#i#'))><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.stock_id#i#')#"><cfelse>NULL</cfif>,
						<cfif isdefined("attributes.disc_ount1#i#")>#evaluate('attributes.disc_ount1#i#')#<cfelse>0</cfif>,
						<cfif isdefined("attributes.disc_ount2#i#")>#evaluate('attributes.disc_ount2#i#')#<cfelse>0</cfif>,
						<cfif isdefined("attributes.disc_ount3#i#")>#evaluate('attributes.disc_ount3#i#')#<cfelse>0</cfif>,
						<cfif isdefined("attributes.disc_ount4#i#")>#evaluate('attributes.disc_ount4#i#')#<cfelse>0</cfif>,
						<cfif isdefined("attributes.disc_ount5#i#")>#evaluate('attributes.disc_ount5#i#')#<cfelse>0</cfif>,
						<cfif isdefined("attributes.disc_ount6#i#")>#evaluate('attributes.disc_ount6#i#')#<cfelse>0</cfif>,
						<cfif isdefined("attributes.disc_ount7#i#")>#evaluate('attributes.disc_ount7#i#')#<cfelse>0</cfif>,
						<cfif isdefined("attributes.disc_ount8#i#")>#evaluate('attributes.disc_ount8#i#')#<cfelse>0</cfif>,
						<cfif isdefined("attributes.disc_ount9#i#")>#evaluate('attributes.disc_ount9#i#')#<cfelse>0</cfif>,
						<cfif isdefined("attributes.disc_ount10#i#")>#evaluate('attributes.disc_ount10#i#')#<cfelse>0</cfif>,
						<cfif isdefined("attributes.profit_margin#i#")>#evaluate('attributes.profit_margin#i#')#<cfelse>0</cfif>,
						<cfif isdefined("attributes.action_price#i#")>#evaluate('attributes.action_price#i#')#<cfelse>0</cfif>,
						<cfif isdefined("attributes.action_price_kdvsiz#i#")>#evaluate('attributes.action_price_kdvsiz#i#')#<cfelse>0</cfif>,
						<cfif isdefined("attributes.action_price_disc#i#") and len(evaluate('attributes.action_price_disc#i#')) and isnumeric(evaluate('attributes.action_price_disc#i#'))>#evaluate('attributes.action_price_disc#i#')#,<cfelse>0,</cfif>
						<cfif isdefined("attributes.action_profit_margin#i#")>#evaluate('attributes.action_profit_margin#i#')#<cfelse>0</cfif>,
						<cfif isdefined("attributes.returning_price#i#")>#evaluate('attributes.returning_price#i#')#<cfelse>0</cfif>,
						<cfif isdefined("attributes.returning_price_kdvsiz#i#")>#filterNum(evaluate('attributes.returning_price_kdvsiz#i#'))#<cfelse>0</cfif>,
						<cfif isdefined("attributes.returning_price_disc#i#") and len(evaluate('attributes.returning_price_disc#i#')) and isnumeric(evaluate('attributes.returning_price_disc#i#'))>#evaluate('attributes.returning_price_disc#i#')#,<cfelse>0,</cfif>
						<cfif isdefined("attributes.tax#i#") and len(evaluate('attributes.tax#i#'))>#evaluate('attributes.tax#i#')#<cfelse>NULL</cfif>,
						<cfif isdefined("attributes.tax_purchase#i#") and len(evaluate('attributes.tax_purchase#i#'))>#evaluate('attributes.tax_purchase#i#')#<cfelse>NULL</cfif>,
						<cfif isdefined("attributes.unit_id#i#")>#evaluate('attributes.unit_id#i#')#<cfelse>NULL</cfif>,
						<cfif isdefined("attributes.unit#i#")>'#wrk_eval('attributes.unit#i#')#'<cfelse>NULL</cfif>,
						<cfif isdefined("attributes.money#i#")>'#wrk_eval('attributes.money#i#')#'<cfelse>NULL</cfif>,
						<cfif isdefined("attributes.p_price#i#")>#evaluate('attributes.p_price#i#')#<cfelse>0</cfif>,
						<cfif isdefined("attributes.p_price_kdv#i#") and len(evaluate('attributes.p_price_kdv#i#'))>#evaluate('attributes.p_price_kdv#i#')#<cfelse>0</cfif>,
						<cfif isdefined("attributes.s_price#i#")>#evaluate('attributes.s_price#i#')#<cfelse>0</cfif>,
						<cfif isdefined("attributes.row_nettotal#i#")>#evaluate('attributes.row_nettotal#i#')#<cfelse>0</cfif>,
						<cfif isdefined("attributes.row_lasttotal#i#")>#evaluate('attributes.row_lasttotal#i#')#<cfelse>0</cfif>,
						<cfif isdefined("attributes.duedate#i#")>#iif(len(evaluate('attributes.duedate#i#')),evaluate('attributes.duedate#i#'),0)#<cfelse>NULL</cfif>,
						<cfif isdefined("attributes.shelf_name#i#") and len(evaluate('attributes.shelf_name#i#')) and len(evaluate('attributes.shelf_id#i#'))>#evaluate('attributes.shelf_id#i#')#<cfelse>NULL</cfif>,
						<cfif isdefined("attributes.rebate_cash_1#i#") and len(evaluate('attributes.rebate_cash_1#i#'))>#evaluate('attributes.rebate_cash_1#i#')#<cfelse>NULL</cfif>,
						<cfif isdefined("attributes.rebate_cash_1#i#") and len(evaluate('attributes.rebate_cash_1#i#'))>'#wrk_eval('attributes.money#i#')#'<cfelse>NULL</cfif>,
						<cfif isdefined("attributes.rebate_rate#i#") and len(evaluate('attributes.rebate_rate#i#'))>#evaluate('attributes.rebate_rate#i#')#<cfelse>NULL</cfif>,
						<cfif isdefined("attributes.return_day#i#") and len(evaluate('attributes.return_day#i#'))>#evaluate('attributes.return_day#i#')#<cfelse>NULL</cfif>,
						<cfif isdefined("attributes.return_rate#i#") and len(evaluate('attributes.return_rate#i#'))>#evaluate('attributes.return_rate#i#')#<cfelse>NULL</cfif>,
						<cfif isdefined("attributes.price_protection_day#i#") and len(evaluate('attributes.price_protection_day#i#'))>#evaluate('attributes.price_protection_day#i#')#<cfelse>NULL</cfif>,
						<cfif isdefined("attributes.extra_product_1#i#") and len(evaluate('attributes.extra_product_1#i#'))>#evaluate('attributes.extra_product_1#i#')#<cfelse>NULL</cfif>,
						<cfif isdefined("attributes.extra_product_2#i#") and len(evaluate('attributes.extra_product_2#i#'))>#evaluate('attributes.extra_product_2#i#')#<cfelse>NULL</cfif>,
						<cfif isdefined("attributes.page_no#i#") and len(evaluate('attributes.page_no#i#'))>#evaluate('attributes.page_no#i#')#<cfelse>NULL</cfif>,
						<cfif isdefined("attributes.page_type#i#") and len(evaluate('attributes.page_type#i#'))>#evaluate('attributes.page_type#i#')#<cfelse>NULL</cfif>,
						<cfif isdefined("attributes.detail_info#i#") and len(evaluate('attributes.detail_info#i#'))>'#wrk_eval('attributes.detail_info#i#')#'<cfelse>NULL</cfif>,
						<cfif isdefined("attributes.ref_code#i#") and len(evaluate('attributes.ref_code#i#'))>'#wrk_eval('attributes.ref_code#i#')#'<cfelse>NULL</cfif>,
						<cfif isdefined("attributes.sale_money_type#i#") and len(evaluate('attributes.sale_money_type#i#'))>'#wrk_eval('attributes.sale_money_type#i#')#'<cfelse>NULL</cfif>,
						<cfif isdefined("attributes.customer_num#i#") and len(evaluate('attributes.customer_num#i#'))>#evaluate('attributes.customer_num#i#')#<cfelse>NULL</cfif>,
						<cfif isdefined("attributes.unit_sale#i#") and len(evaluate('attributes.unit_sale#i#'))>#evaluate('attributes.unit_sale#i#')#<cfelse>NULL</cfif>,
						<cfif isdefined("attributes.total_sale#i#") and len(evaluate('attributes.total_sale#i#'))>#evaluate('attributes.total_sale#i#')#<cfelse>NULL</cfif>,
						<cfif isdefined("attributes.sale_type_info#i#") and len(evaluate('attributes.sale_type_info#i#'))>#evaluate('attributes.sale_type_info#i#')#<cfelse>NULL</cfif>,
						<cfif isdefined("attributes.paper_type#i#") and len(evaluate('attributes.paper_type#i#'))>#evaluate('attributes.paper_type#i#')#<cfelse>NULL</cfif>,
						<cfif isdefined("attributes.new_cost#i#") and len(evaluate('attributes.new_cost#i#'))>#evaluate('attributes.new_cost#i#')#<cfelse>NULL</cfif>,
						<cfif isdefined("attributes.prom_id#i#") and len(evaluate('attributes.prom_id#i#'))><cfqueryparam cfsqltype="cf_sql_integer" value="#filterNum(evaluate('attributes.prom_id#i#'))#"><cfelse>NULL</cfif>,
						<cfif isdefined("attributes.prom_point#i#") and len(evaluate('attributes.prom_point#i#'))><cfqueryparam cfsqltype="cf_sql_float" value="#filterNum(evaluate('attributes.prom_point#i#'))#"><cfelse>NULL</cfif>,
						<cfif isdefined("attributes.amount_1#i#") and len(evaluate('attributes.amount_1#i#'))><cfqueryparam cfsqltype="cf_sql_float" value="#filterNum(evaluate('attributes.amount_1#i#'))#"><cfelse>NULL</cfif>,
						<cfif isdefined("attributes.profitability#i#") and len(evaluate('attributes.profitability#i#'))><cfqueryparam cfsqltype="cf_sql_float" value="#filterNum(evaluate('attributes.profitability#i#'))#"><cfelse>NULL</cfif>,
						<cfif isdefined("attributes.amount_discount_2#i#") and len(evaluate('attributes.amount_discount_2#i#'))><cfqueryparam cfsqltype="cf_sql_float" value="#filterNum(evaluate('attributes.amount_discount_2#i#'))#"><cfelse>NULL</cfif>,
						<cfif isdefined("attributes.total_promotion_cost#i#") and len(evaluate('attributes.total_promotion_cost#i#'))><cfqueryparam cfsqltype="cf_sql_float" value="#filterNum(evaluate('attributes.total_promotion_cost#i#'))#"><cfelse>NULL</cfif>,
						<cfif isdefined("attributes.special_product_discount_rate#i#") and len(evaluate('attributes.special_product_discount_rate#i#'))><cfqueryparam cfsqltype="cf_sql_float" value="#filterNum(evaluate('attributes.special_product_discount_rate#i#'))#"><cfelse>NULL</cfif>,
						<cfif isdefined("attributes.number_gift_product_ratio#i#") and len(evaluate('attributes.number_gift_product_ratio#i#'))><cfqueryparam cfsqltype="cf_sql_float" value="#filterNum(evaluate('attributes.number_gift_product_ratio#i#'))#"><cfelse>NULL</cfif>,
						<cfif isdefined("attributes.number_gift_product#i#") and len(evaluate('attributes.number_gift_product#i#'))><cfqueryparam cfsqltype="cf_sql_integer" value="#filterNum(evaluate('attributes.number_gift_product#i#'))#"><cfelse>NULL</cfif>,
						<cfif isdefined("attributes.free_stock_id#i#") and len(evaluate('attributes.free_stock_id#i#'))><cfqueryparam cfsqltype="cf_sql_integer" value="#filterNum(evaluate('attributes.free_stock_id#i#'))#"><cfelse>NULL</cfif>,
						<cfif isdefined("attributes.free_stock_amount#i#") and len(evaluate('attributes.free_stock_amount#i#'))><cfqueryparam cfsqltype="cf_sql_integer" value="#filterNum(evaluate('attributes.free_stock_amount#i#'))#"><cfelse>NULL</cfif>,
						<cfif isdefined("attributes.promotion_code#i#") and len(evaluate('attributes.promotion_code#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#filterNum(evaluate('attributes.promotion_code#i#'))#"><cfelse>NULL</cfif>,
						<cfif isdefined("attributes.new_marj#i#") and len(evaluate('attributes.new_marj#i#'))>#evaluate('attributes.new_marj#i#')#<cfelse>NULL</cfif>
						<cfif isdefined("attributes.extra_price_list") and get_price_cat_row.recordcount>
							<cfloop query="get_price_cat_row">
								<cfif isdefined("attributes.new_price_kdv#get_price_cat_row.price_catid##i#") and len(evaluate("attributes.new_price_kdv#get_price_cat_row.price_catid##i#"))>
									,#evaluate("attributes.new_price_kdv#get_price_cat_row.price_catid##i#")#
								<cfelse>
									,0
								</cfif>
							</cfloop>
						</cfif>		
					)
				</cfquery>
			</cfif>
		</cfloop>
		
		<!--- Varsa kampanyaya bagli segmentesyon ve prim bilgileri yaziliyor--->
		<cfif len(attributes.camp_id)>
			<cfquery name="GET_SEGMENT" datasource="#DSN3#">
				SELECT * FROM SETUP_CONSCAT_SEGMENTATION WHERE CAMPAIGN_ID = #attributes.camp_id#
			</cfquery>
			<cfif get_segment.recordcount>
				<cfquery name="ADD_SEGMENT" datasource="#DSN3#">
					INSERT INTO
						SETUP_CONSCAT_SEGMENTATION
					(
						CATALOG_ID,
						CONSCAT_ID,
						MIN_PERSONAL_SALE,
						IS_PERSONAL_PRIM,
						REF_MEMBER_COUNT,
						ACTIVE_MEMBER_CONDITION,
						REF_MEMBER_SALE,
						CAMPAIGN_COUNT,
						GROUP_SALE,
						RECORD_EMP,
						RECORD_IP,
						RECORD_DATE
					)
					SELECT
						#get_catid.current_cat#,
						CONSCAT_ID,
						MIN_PERSONAL_SALE,
						IS_PERSONAL_PRIM,
						REF_MEMBER_COUNT,
						ACTIVE_MEMBER_CONDITION,
						REF_MEMBER_SALE,
						CAMPAIGN_COUNT,
						GROUP_SALE,
						#session.ep.userid#,
						'#cgi.remote_addr#',
						#now()#	
					FROM
						SETUP_CONSCAT_SEGMENTATION
					WHERE
						CAMPAIGN_ID = #attributes.camp_id#	
				</cfquery>
				<cfquery name="GET_MAX_ID" datasource="#DSN3#">
					SELECT MAX(CONSCAT_SEGMENT_ID) CONSCAT_SEGMENT_ID FROM SETUP_CONSCAT_SEGMENTATION
				</cfquery>	
				<cfquery name="GET_SEGMENT_ROWS" datasource="#DSN3#">
					SELECT * FROM SETUP_CONSCAT_SEGMENTATION_ROWS WHERE CONSCAT_SEGMENT_ID = #get_segment.conscat_segment_id#
				</cfquery>	
				<cfif get_segment_rows.recordcount>
					<cfquery name="ADD_SEGMENT_ROW" datasource="#DSN3#">
						INSERT INTO
							SETUP_CONSCAT_SEGMENTATION_ROWS
						(
							CONSCAT_SEGMENT_ID,
							CONSCAT_ID,
							ROW_MEMBER_COUNT
						)
						SELECT
							#get_max_id.conscat_segment_id#,
							CONSCAT_ID,
							ROW_MEMBER_COUNT
						FROM
							SETUP_CONSCAT_SEGMENTATION_ROWS
						WHERE
							CONSCAT_SEGMENT_ID = #get_segment.conscat_segment_id#
					</cfquery>	
				</cfif>
			</cfif>
			<cfquery name="GET_PREMIUM" datasource="#DSN3#">
				SELECT * FROM SETUP_CONSCAT_PREMIUM WHERE CAMPAIGN_ID = #attributes.camp_id#
			</cfquery>
			<cfif get_premium.recordcount>
				<cfquery name="ADD_PREMIUM" datasource="#DSN3#">
					INSERT INTO
						SETUP_CONSCAT_PREMIUM
					(
						CATALOG_ID,
						CONSCAT_ID,
						REF_MEMBER_COUNT,
						REF_MEMBER_CAT,
						PREMIUM_LEVEL,
						MIN_NET_SALE,
						MAX_NET_SALE,
						PREMIUM_RATIO,
						RECORD_EMP,
						RECORD_IP,
						RECORD_DATE
					)
					SELECT
						#get_catid.current_cat#,
						CONSCAT_ID,
						REF_MEMBER_COUNT,
						REF_MEMBER_CAT,
						PREMIUM_LEVEL,
						MIN_NET_SALE,
						MAX_NET_SALE,
						PREMIUM_RATIO,
						#session.ep.userid#,
						'#cgi.remote_addr#',
						#now()#						
					FROM
						SETUP_CONSCAT_PREMIUM
					WHERE
						CAMPAIGN_ID = #attributes.camp_id#
				</cfquery>
			</cfif>
		</cfif>		
		<cfif isDefined("form.price_cats")>
			<cfloop list="#form.price_cats#" index="i">            
				<cfquery name="ADD_CATALOG_PRODUCT" datasource="#DSN3#">
					INSERT INTO 
						CATALOG_PRICE_LISTS 
					(
						CATALOG_PROMOTION_ID,
						PRICE_LIST_ID
					)
					VALUES
					(
						#get_catid.current_cat#,
						#i#
					)
				</cfquery>
			</cfloop>
		</cfif>		
		<cfif isDefined("form.companycat_id")>
			<cfloop list="#form.companycat_id#" index="y">
				<cfquery name="ADD_CATALOG_PRODUCT" datasource="#DSN3#">
					INSERT INTO 
						CATALOG_PROMOTION_MEMBERS 
					(
						CATALOG_ID,
						COMPANYCAT_ID
					)
					VALUES
					(
						#get_catid.current_cat#,
						#y#
					)
				</cfquery>
			</cfloop>
		</cfif>
	
		<cfif isDefined("form.conscat_id")>
			<cfloop list="#form.conscat_id#" index="z">
				<cfquery name="ADD_CATALOG_PRODUCT" datasource="#DSN3#">
					INSERT INTO 
						CATALOG_PROMOTION_MEMBERS 
					(
						CATALOG_ID,
						CONSCAT_ID
					)
					VALUES
					(
						#get_catid.current_cat#,
						#z#
					)
				</cfquery>
			</cfloop>
		</cfif>
	</cftransaction>
</cflock>
<cfquery name="UPD_GEN_PAP" datasource="#DSN3#">
	UPDATE 
		GENERAL_PAPERS
	SET
		CAT_PROM_NUMBER = #system_paper_no_add#
	WHERE
		CAT_PROM_NUMBER IS NOT NULL
</cfquery>
<cf_workcube_process 
		is_upd='1' 
		data_source='#dsn3#' 
		old_process_line='0'
		process_stage='#attributes.process_stage#' 
		record_member='#session.ep.userid#' 
		record_date='#now()#' 
		action_table='CATALOG_PROMOTION'
		action_column='CATALOG_ID'
		action_id='#get_catid.current_cat#'
		action_page='#request.self#?fuseaction=product.list_catalog_promotion&event=upd&id=#get_catid.current_cat#' 
		warning_description='Aksiyon : #get_catid.current_cat#'>
<cfif isdefined("attributes.compid")>
	<script type="text/javascript">
		window.location.href = '<cfoutput>#request.self#?fuseaction=product.list_catalog_promotion</cfoutput>';
	</script>
</cfif>
<cfif not isDefined("attributes.is_pop_true")>
	<script type="text/javascript">
		window.location.href = '<cfoutput>#request.self#?fuseaction=product.list_catalog_promotion&event=upd&id=#get_catid.current_cat#</cfoutput>';
	</script>
<cfelse>
	<script type="text/javascript">
		wrk_opener_reload();
		window.close();
	</script>
</cfif> 
