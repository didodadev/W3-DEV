<!--- BK 20100525 Katalogdaki urunlerin tekrar secilmesi durumundaki hataya ortadan kaldırmak icin eklendi --->
<cfquery name="GET_PRODUCT_CONTROL" datasource="#DSN3#">
	SELECT 
		P.PRODUCT_NAME
	FROM 
		CATALOG_PROMOTION_PRODUCTS CPP, 
		#dsn1_alias#.PRODUCT P
	WHERE 
		CPP.CATALOG_ID = #attributes.catalog_id#  AND 
		CPP.PRODUCT_ID = P.PRODUCT_ID
	GROUP BY 
		P.PRODUCT_NAME
	HAVING 
		COUNT(CPP.PRODUCT_ID)>1 
</cfquery>
<cfif get_product_control.recordcount>
	<script type="text/javascript">
		alert('<cfoutput>#valuelist(get_product_control.product_name)#</cfoutput>' + " İlgili Ürünleri Kontrol Ediniz ! ");
		history.back();
	</script>
	<cfabort>
</cfif>
<cfif isdefined("attributes.extra_price_list") and len(attributes.extra_price_list)>
	<cfquery name="get_price_cat_row" datasource="#dsn3#" maxrows="3">
		SELECT PRICE_CAT,PRICE_CATID FROM PRICE_CAT WHERE PRICE_CATID IN(#attributes.extra_price_list#)
	</cfquery>
</cfif>
<cf_date tarih="form.startdate">
<cf_date tarih="form.finishdate">
<cfif isdefined("form.kondusyon_date")><cf_date tarih="form.kondusyon_date"></cfif>
<cfif isdefined("form.kondusyon_finish_date")><cf_date tarih="form.kondusyon_finish_date"></cfif>
<cflock name="#CreateUUID()#" timeout="20">
	<cftransaction>
		<cfquery name="UPD_CATALOG" datasource="#DSN3#">
			UPDATE 
				CATALOG_PROMOTION
			SET 
				IS_PUBLIC = <cfif isdefined("attributes.is_public")>1<cfelse>0</cfif>,
				STAGE_ID = #FORM.STAGE_ID#,
				PROCESS_STAGE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_stage#">,
			<cfif isDefined("FORM.BARCOD") and len(trim(FORM.BARCOD))>
				BARCOD = #FORM.BARCOD#,
			</cfif>
			<cfif isDefined("FORM.VALID") and len(FORM.VALID)>
				VALID = #FORM.VALID#,
				VALID_EMP = #SESSION.EP.USERID#,
				VALIDATE_DATE = #NOW()#,
			</cfif>
			<cfif isDefined("FORM.VALIDATOR") and len(FORM.VALIDATOR)>
				VALIDATOR_POSITION_CODE = #FORM.VALIDATOR_POSITION_CODE#,
			</cfif>
				CATALOG_HEAD = '#FORM.CATALOG_HEAD#',
				CATALOG_STATUS = <cfif isDefined("FORM.CURRENCY")>#FORM.CURRENCY#<cfelse>0</cfif>,
				CATALOG_DETAIL = '#FORM.DETAIL#',
				STARTDATE = #FORM.STARTDATE#,
				FINISHDATE = #FORM.FINISHDATE#,
				<cfif isdefined("form.kondusyon_date")>KONDUSYON_DATE = #FORM.KONDUSYON_DATE#,</cfif>
				<cfif isdefined("form.kondusyon_finish_date")>KONDUSYON_FINISH_DATE = #FORM.kondusyon_finish_date#,</cfif>
				CAMP_ID = <cfif len(attributes.camp_id) and len(attributes.camp_name)>#attributes.CAMP_ID#<cfelse>NULL</cfif>,
				RELATED_CATALOG_ID = <cfif isdefined("attributes.related_catalog_id") and  isdefined("attributes.related_catalog_head") and len(attributes.related_catalog_id) and len(attributes.related_catalog_head)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.related_catalog_id#"><cfelse>NULL</cfif>,
				UPDATE_DATE = #now()#,
				UPDATE_EMP = #session.ep.userid#,
				UPDATE_IP = '#cgi.remote_addr#',
				CAT_PROM_NO = '#attributes.CAT_PROM_NO#'
				<cfif isdefined("attributes.extra_price_list") and len(attributes.extra_price_list)>,EXTRA_PRICE_CATID ='#attributes.extra_price_list#'</cfif>
			WHERE 
				CATALOG_ID = #attributes.catalog_id#
		</cfquery>
		<cf_wrk_get_history 
            datasource="#DSN3#"
            source_table="CATALOG_PROMOTION"
            target_table="CATALOG_PROMOTION_HISTORY"
            record_id= "#attributes.catalog_id#"
            record_name="CATALOG_ID">
		<cfset max_id_ = 1>
		<cfquery name="GET_MAX_ID" datasource="#DSN3#">
			SELECT MAX(CATALOG_HISTORY_ID) as MAXX FROM CATALOG_PROMOTION_HISTORY
		</cfquery>
		<cfif get_max_id.recordcount AND LEN(get_max_id.MAXX)>
			<cfset max_id_ = get_max_id.MAXX>
		</cfif>
		<cfquery name="DEL_OLDS" datasource="#DSN3#">
			DELETE FROM CATALOG_PRICE_LISTS WHERE CATALOG_PROMOTION_ID = #attributes.catalog_id#
		</cfquery>
		 <cfquery name="DEL_OLDS" datasource="#DSN3#">
			DELETE FROM CATALOG_PROMOTION_PRODUCTS WHERE CATALOG_ID = #attributes.catalog_id#
		</cfquery>
		<cfquery name="DEL_OLDS" datasource="#DSN3#">
			DELETE FROM CATALOG_PROMOTION_MEMBERS WHERE CATALOG_ID = #attributes.catalog_id#
		</cfquery>
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
						#attributes.catalog_id#,
						#i#
					)
					INSERT INTO
					CATALOG_PRICE_LISTS_HISTORY
					(
						CATALOG_HISTORY_ID,
						CATALOG_PROMOTION_ID,
						PRICE_LIST_ID
					)
					VALUES
					(
						#max_id_#,
						#attributes.catalog_id#,
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
						#attributes.catalog_id#,
						#y#
					)
                    INSERT INTO
					CATALOG_PROMOTION_MEMBERS_HISTORY
					(
						CATALOG_PROMOTION_MEMBER_HISTORY_ID,
						CATALOG_ID,
						COMPANYCAT_ID
					)
					VALUES
					(
						#max_id_#,
						#attributes.catalog_id#,
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
						#attributes.catalog_id#,
						#z#
					)
                    INSERT INTO
					CATALOG_PROMOTION_MEMBERS_HISTORY
					(
						CATALOG_PROMOTION_MEMBER_HISTORY_ID,
						CATALOG_ID,
						CONSCAT_ID
					)
					VALUES
					(
						#max_id_#,
						#attributes.catalog_id#,
						#z#
					)
				</cfquery>
			</cfloop>
		</cfif>
		<cfloop from="1" to="#attributes.record_num#" index="i">
			<cfif evaluate("attributes.row_kontrol#i#") neq 0>
				<cfquery name="ADD_CT_PRODUCT" datasource="#DSN3#" result="MAX_ID">
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
						EXTRA_PRODUCT_MARJ
						<cfif isdefined("attributes.extra_price_list") and get_price_cat_row.recordcount>
							<cfloop query="get_price_cat_row">
								,EXTRA_PRICEKDV_#get_price_cat_row.currentrow#
							</cfloop>
						</cfif>			
					)
					VALUES   
					(
						#FORM.CATALOG_ID#,
						#evaluate('attributes.product_id#i#')#,
                        <cfif len(evaluate('attributes.stock_id#i#'))>#evaluate('attributes.stock_id#i#')#<cfelse>NULL</cfif>,
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
						<cfif isdefined("attributes.action_price_disc#i#") and len(evaluate('attributes.action_price_disc#i#')) and isnumeric(evaluate('attributes.action_price_disc#i#'))>#evaluate('attributes.action_price_disc#i#')#<cfelse>0</cfif>,
						<cfif isdefined("attributes.action_profit_margin#i#")>#evaluate('attributes.action_profit_margin#i#')#<cfelse>0</cfif>,
						<cfif isdefined("attributes.returning_price#i#")>#evaluate('attributes.returning_price#i#')#<cfelse>0</cfif>,
						<cfif isdefined("attributes.returning_price_kdvsiz#i#")>#evaluate('attributes.returning_price_kdvsiz#i#')#<cfelse>0</cfif>,
						<cfif isdefined("attributes.returning_price_disc#i#") and len(evaluate('attributes.returning_price_disc#i#')) and isnumeric(evaluate('attributes.returning_price_disc#i#'))>#evaluate('attributes.returning_price_disc#i#')#<cfelse>0</cfif>,
						<cfif isdefined("attributes.tax#i#") and len(evaluate('attributes.tax#i#'))>#evaluate('attributes.tax#i#')#<cfelse>NULL</cfif>,
						<cfif isdefined("attributes.tax_purchase#i#") and len(evaluate('attributes.tax_purchase#i#'))>#evaluate('attributes.tax_purchase#i#')#<cfelse>NULL</cfif>,
						<cfif isdefined("attributes.unit_id#i#")>#evaluate('attributes.unit_id#i#')#<cfelse>NULL</cfif>,
						<cfif isdefined("attributes.unit#i#")>'#wrk_eval('attributes.unit#i#')#'<cfelse>NULL</cfif>,
						<cfif isdefined("attributes.money#i#")>'#wrk_eval('attributes.money#i#')#'<cfelse>NULL</cfif>,
						<cfif isdefined("attributes.p_price#i#")>#evaluate('attributes.p_price#i#')#<cfelse>0</cfif>,
						<cfif isdefined("attributes.p_price_kdv#i#")>#evaluate('attributes.p_price_kdv#i#')#<cfelse>0</cfif>,
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
                <cfquery name="ADD_CT_PRODUCT" datasource="#DSN3#">
					INSERT INTO 
						CATALOG_PROMOTION_PRODUCTS_HISTORY
					(
                    	CATALOG_HISTORY_ID,
                        CATALOGPRODUCT_ID,
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
						EXTRA_PRODUCT_MARJ
						<cfif isdefined("attributes.extra_price_list") and get_price_cat_row.recordcount>
							<cfloop query="get_price_cat_row">
								,EXTRA_PRICEKDV_#get_price_cat_row.currentrow#
							</cfloop>
						</cfif>			
					)
					VALUES   
					(
                    	#max_id_#,
                        #MAX_ID.IDENTITYCOL#,
						#FORM.CATALOG_ID#,
						#evaluate('attributes.product_id#i#')#,
                        <cfif len(evaluate('attributes.stock_id#i#'))>#evaluate('attributes.stock_id#i#')#<cfelse>NULL</cfif>,
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
						<cfif isdefined("attributes.action_price_disc#i#") and len(evaluate('attributes.action_price_disc#i#')) and isnumeric(evaluate('attributes.action_price_disc#i#'))>#evaluate('attributes.action_price_disc#i#')#<cfelse>0</cfif>,
						<cfif isdefined("attributes.action_profit_margin#i#")>#evaluate('attributes.action_profit_margin#i#')#<cfelse>0</cfif>,
						<cfif isdefined("attributes.returning_price#i#")>#evaluate('attributes.returning_price#i#')#<cfelse>0</cfif>,
						<cfif isdefined("attributes.returning_price_kdvsiz#i#")>#evaluate('attributes.returning_price_kdvsiz#i#')#<cfelse>0</cfif>,
						<cfif isdefined("attributes.returning_price_disc#i#") and len(evaluate('attributes.returning_price_disc#i#')) and isnumeric(evaluate('attributes.returning_price_disc#i#'))>#evaluate('attributes.returning_price_disc#i#')#<cfelse>0</cfif>,
						<cfif isdefined("attributes.tax#i#") and len(evaluate('attributes.tax#i#'))>#evaluate('attributes.tax#i#')#<cfelse>NULL</cfif>,
						<cfif isdefined("attributes.tax_purchase#i#") and len(evaluate('attributes.tax_purchase#i#'))>#evaluate('attributes.tax_purchase#i#')#<cfelse>NULL</cfif>,
						<cfif isdefined("attributes.unit_id#i#")>#evaluate('attributes.unit_id#i#')#<cfelse>NULL</cfif>,
						<cfif isdefined("attributes.unit#i#")>'#wrk_eval('attributes.unit#i#')#'<cfelse>NULL</cfif>,
						<cfif isdefined("attributes.money#i#")>'#wrk_eval('attributes.money#i#')#'<cfelse>NULL</cfif>,
						<cfif isdefined("attributes.p_price#i#")>#evaluate('attributes.p_price#i#')#<cfelse>0</cfif>,
						<cfif isdefined("attributes.p_price_kdv#i#")>#evaluate('attributes.p_price_kdv#i#')#<cfelse>0</cfif>,
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
				<!---  <cf_wrk_get_history 
                    datasource="#DSN3#"
                    source_table="CATALOG_PROMOTION_PRODUCTS"
                    target_table="CATALOG_PROMOTION_PRODUCTS_HISTORY"
                    record_id= "#ADD_CT_PRODUCT.MAX_ID#"
                    record_name="CATALOGPRODUCT_ID">--->
			</cfif>	
		</cfloop>
	</cftransaction>
</cflock>
<cfquery name="GET_CATALOG_" datasource="#DSN3#">
	SELECT ISNULL(IS_APPLIED,0) IS_APPLIED FROM CATALOG_PROMOTION WHERE CATALOG_ID = #attributes.catalog_id#
</cfquery>
<cf_workcube_process 
		is_upd='1' 
		data_source='#dsn3#' 
		old_process_line='#attributes.old_process_line#'
		process_stage='#attributes.process_stage#' 
		record_member='#session.ep.userid#'
		record_date='#now()#' 
		action_table='CATALOG_PROMOTION'
		action_column='CATALOG_ID'
		action_id='#attributes.id#' 
		action_page='#request.self#?fuseaction=product.list_catalog_promotion&event=upd&id=#attributes.id#' 
		warning_description='Aksiyon : #attributes.id#'>
<cfif isdefined("attributes.extra_price_list") and get_price_cat_row.recordcount and attributes.stage_id eq -2 and get_catalog_.is_applied eq 0>
	<cfinclude template="add_catalog_product_price.cfm">
</cfif>
<script type="text/javascript">
	window.location.href = '<cfoutput>#request.self#?fuseaction=product.list_catalog_promotion&event=upd&id=#attributes.id#</cfoutput>';
</script>