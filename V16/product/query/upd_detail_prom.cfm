<cfif len(attributes.startdate)>
	<cf_date tarih="attributes.startdate">
	<cfset attributes.startdate = date_add("n",start_minute,date_add("h",start_clock-session.ep.time_zone,attributes.startdate))>
</cfif>
<cfif len(attributes.finishdate)>
	<cf_date tarih="attributes.finishdate">
	<cfset attributes.finishdate = date_add("n",finish_minute,date_add("h",finish_clock-session.ep.time_zone,attributes.finishdate))>
</cfif>
<cfif len(attributes.control_date)><cf_date tarih="attributes.control_date"></cfif>
<cflock name="#CreateUUID()#" timeout="20">
	<cftransaction>
		<cfquery name="UPD_PROM" datasource="#DSN3#">
			UPDATE
				PROMOTIONS
			SET
				PROM_NO = '#attributes.prom_no#',
				PROM_HEAD = '#attributes.prom_head#',
				PROM_STATUS = <cfif isdefined("attributes.prom_status")>1<cfelse>0</cfif>,
				PROM_STAGE = #attributes.process_stage#,
				STARTDATE = <cfif len(attributes.startdate)>#attributes.startdate#<cfelse>NULL</cfif>,
				FINISHDATE = <cfif len(attributes.finishdate)>#attributes.finishdate#<cfelse>NULL</cfif>,
				PROM_DETAIL = '#attributes.prom_detail#',
				PRICE_CATID = #attributes.price_catid#,
				CONDITION_PRICE_CATID = <cfif len(attributes.condition_price_catid)>#attributes.condition_price_catid#<cfelse>NULL</cfif>,
				PROM_TYPE = #attributes.prom_type#,
				IS_ONLY_FIRST_ORDER = <cfif isdefined("attributes.first_order")>1<cfelse>0</cfif>,
				PROM_HIERARCHY = <cfif len(attributes.work_hierarchy)>#attributes.work_hierarchy#<cfelse>NULL</cfif>,
				DISCOUNT = <cfif isdefined("attributes.discount_1") and len(attributes.discount_1)>#attributes.discount_1#<cfelse>0</cfif>,
				AMOUNT_DISCOUNT = <cfif isdefined("attributes.amount_discount_1") and len(attributes.amount_discount_1)>#attributes.amount_discount_1#<cfelse>0</cfif>,
				AMOUNT_DISCOUNT_MONEY_1 = <cfif isdefined("attributes.amount_discount_money_1") and len(attributes.amount_discount_money_1)>'#attributes.amount_discount_money_1#'<cfelse>NULL</cfif>,
				TOTAL_DISCOUNT_AMOUNT = <cfif isdefined("attributes.product_benefit_count") and len(attributes.product_benefit_count)>#attributes.product_benefit_count#<cfelse>NULL</cfif>,
				TOTAL_DISCOUNT_PRICE = <cfif isdefined("attributes.product_benefit_amount") and len(attributes.product_benefit_amount)>#attributes.product_benefit_amount#<cfelse>NULL</cfif>,
				CATALOG_ID = <cfif len(attributes.catalog_id)>#attributes.catalog_id#<cfelse>NULL</cfif>,
				ONLY_SAME_PRODUCT = <cfif isdefined("attributes.is_only_same_product")>1<cfelse>0</cfif>,
				PRODUCT_PROMOTION_NONEFFECT = <cfif isdefined("attributes.is_other_prom_act")>1<cfelse>0</cfif>,
				LIST_WORK_TYPE = <cfif isdefined("attributes.prom_benefit_status_and")>1<cfelse>0</cfif>,
				CONTROL_START_DATE = <cfif len(attributes.startdate)>#attributes.startdate#<cfelse>NULL</cfif>,
				CONTROL_FINISH_DATE = <cfif len(attributes.finishdate)>#attributes.finishdate#<cfelse>NULL</cfif>,
				CAMP_ID = <cfif len(attributes.camp_id)>#attributes.camp_id#<cfelse>NULL</cfif>,
				CONDITION_LIST_WORK_TYPE = <cfif isdefined("attributes.prom_condition_status_and")>1<cfelse>0</cfif>,
				CONSUMERCAT_ID = <cfif isdefined("attributes.consumer_category") and len(attributes.consumer_category)>'#attributes.consumer_category#'<cfelse>NULL</cfif>,
				PROM_WORK_COUNT = <cfif len(attributes.prom_count)>#attributes.prom_count#<cfelse>NULL</cfif>,
				REFERENCE_CODE = <cfif len(attributes.reference_code)>'#attributes.reference_code#'<cfelse>NULL</cfif>,
				ICON_ID = <cfif isDefined("attributes.icon_id") and len(attributes.icon_id)>#attributes.icon_id#<cfelse>NULL</cfif>,
				PROM_ACTION_TYPE = <cfif isDefined("attributes.prom_action_type") and len(attributes.prom_action_type)>#attributes.prom_action_type#<cfelse>NULL</cfif>,
				IS_REQUIRED_PROM = <cfif isdefined("attributes.is_required_prom")>1<cfelse>0</cfif>,
				IS_INTERNET = <cfif isdefined("attributes.is_internet")>1<cfelse>0</cfif>,
				IS_PROM_WARNING = <cfif isdefined("attributes.is_prom_warning")>1<cfelse>0</cfif>,
				DETAIL_PROM_TYPE = #attributes.detail_prom_type#,
				WORK_CAMP_TYPE = <cfif isdefined("attributes.kamp_type") and len(attributes.kamp_type)>'#attributes.kamp_type#'<cfelse>NULL</cfif>,
				IS_CONS_REF_PROM = <cfif isdefined("attributes.consumer_ref_prom")>1<cfelse>0</cfif>,
				MEMBER_ORDER_COUNT = <cfif isdefined("attributes.member_order_count") and len(attributes.member_order_count)>#attributes.member_order_count#<cfelse>NULL</cfif>,
				MEMBER_RECORD_LINE = <cfif isdefined("attributes.member_line_order") and len(attributes.member_line_order)>#attributes.member_line_order#<cfelse>NULL</cfif>,
				IS_DEMAND_PRODUCTS = <cfif isdefined("attributes.is_demand_products")>1<cfelse>0</cfif>,
				IS_DEMAND_ORDER_PRODUCTS = <cfif isdefined("attributes.is_demand_order_products")>1<cfelse>0</cfif>,
                DRP_RTR_FROM_PROM = <cfif isdefined("attributes.drp_rtr_from_prom")>1<cfelse>0</cfif>,
				VALID_DAY = <cfif isdefined('attributes.valid_day') and len(attributes.valid_day)>#attributes.valid_day#<cfelse>NULL</cfif>,
				MONEY_CREDIT = <cfif isdefined('attributes.parapuan_percent') and len(attributes.parapuan_percent)>#attributes.parapuan_percent#<cfelse>NULL</cfif>,
				PROM_WORK_TYPE = <cfif isdefined("attributes.is_prom_and")>1<cfelse>0</cfif>,
				DEMAND_CONTROL_DATE = <cfif len(attributes.control_date)>#attributes.control_date#<cfelse>NULL</cfif>,
				CREDIT_PAY_TYPES = <cfif isdefined("attributes.credit_pay_types") and len(attributes.credit_pay_types)>'#attributes.credit_pay_types#'<cfelse>NULL</cfif>,
                MEMBER_ADD_OPTION_ID = <cfif isdefined("attributes.member_add_option") and len(attributes.member_add_option)>'#attributes.member_add_option#'<cfelse>NULL</cfif>,				
				UPDATE_EMP = #session.ep.userid#,
				UPDATE_IP = '#cgi.remote_addr#',
				UPDATE_DATE = #now()#
			WHERE
				PROM_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.prom_id#">
		</cfquery>
		<cfquery name="DEL_PROM_PRODUCTS" datasource="#DSN3#">
			DELETE FROM PROMOTION_PRODUCTS WHERE PROMOTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.prom_id#">
		</cfquery>
		<cfquery name="DEL_PROM_CONDITIONS_PRODUCT" datasource="#DSN3#">
			DELETE FROM PROMOTION_CONDITIONS_PRODUCTS WHERE PROM_CONDITION_ID IN (SELECT PROM_CONDITION_ID FROM PROMOTION_CONDITIONS WHERE PROMOTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.prom_id#"> )
		</cfquery>
		<cfquery name="DEL_PROM_CONDITIONS" datasource="#DSN3#">
			DELETE FROM PROMOTION_CONDITIONS WHERE PROMOTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.prom_id#">
		</cfquery>
		<cfquery name="DEL_PROM_RELATED" datasource="#DSN3#">
			DELETE FROM PROMOTION_RELATED_PROMOTIONS WHERE PROMOTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.prom_id#">
		</cfquery>
		<cfloop from="1" to="#attributes.record_num1#" index="kk">
			<cfif evaluate("attributes.row_kontrol1#kk#") and len(evaluate("attributes.product_id#kk#")) and len(evaluate("attributes.product_amount#kk#")) and evaluate("attributes.product_amount#kk#") gt 0>
				<cfquery name="ADD_PRODUCTS" datasource="#DSN3#">
					INSERT INTO
						PROMOTION_PRODUCTS
					(
						PROMOTION_ID,
						PRODUCT_ID,
						STOCK_ID,
						PRODUCT_AMOUNT,
						PRODUCT_PRICE,
						PRODUCT_PRICE_OTHER_LIST,
						MARGIN,
						PRODUCT_COST,
						IS_NONDELETE_PRODUCT
					)
					VALUES
					(
						#attributes.prom_id#,
						#evaluate("attributes.product_id#kk#")#,
						#evaluate("attributes.stock_id#kk#")#,
						#evaluate("attributes.product_amount#kk#")#,
						<cfif len(evaluate("attributes.product_price#kk#"))>#evaluate("attributes.product_price#kk#")#<cfelse>NULL</cfif>,
						<cfif isdefined("attributes.product_price_other#kk#") and len(evaluate("attributes.product_price_other#kk#"))>#evaluate("attributes.product_price_other#kk#")#<cfelse>NULL</cfif>,
						<cfif isdefined("attributes.marj_value#kk#") and len(evaluate("attributes.marj_value#kk#"))>#evaluate("attributes.marj_value#kk#")#<cfelse>NULL</cfif>,
						<cfif len(evaluate("attributes.product_cost#kk#"))>0<cfelse>NULL</cfif>,
						<cfif isdefined("attributes.is_nondelete#kk#")>1<cfelse>0</cfif>
					)
				</cfquery>
			</cfif>
		</cfloop>
		<cfloop from="1" to="#attributes.record_num3#" index="ll">
			<cfif evaluate("attributes.row_kontrol3#ll#") and len(evaluate("attributes.promotion_id#ll#")) and len(evaluate("attributes.promotion_name#ll#"))>
				<cfquery name="ADD_PRODUCTS" datasource="#DSN3#">
					INSERT INTO
						PROMOTION_RELATED_PROMOTIONS
					(
						PROMOTION_ID,
						RELATED_PROM_ID
					)
					VALUES
					(
						#attributes.prom_id#,
						#evaluate("attributes.promotion_id#ll#")#
					)
				</cfquery>
			</cfif>
		</cfloop>
		<cfloop from="1" to="#attributes.record_num#" index="jj">
			<cfif evaluate("attributes.row_control_prom_#jj#") eq 1>				
				<cfquery name="ADD_CONDITIONS" datasource="#DSN3#" result="MAX_ID">
					INSERT INTO
						PROMOTION_CONDITIONS
					(
						PROMOTION_ID,
						TOTAL_PRODUCT_AMOUNT,
						TOTAL_PRODUCT_PRICE,
						TOTAL_PRODUCT_PRICE_LAST,
						CATALOG_ID,
						LIST_WORK_TYPE,
						TOTAL_PRODUCT_POINT
					)
					VALUES
					(
						#attributes.prom_id#,
						<cfif len(evaluate("attributes.product_count_#jj#"))>#evaluate("attributes.product_count_#jj#")#<cfelse>NULL</cfif>,
						<cfif len(evaluate("attributes.product_amount_#jj#"))>#evaluate("attributes.product_amount_#jj#")#<cfelse>NULL</cfif>,
                        NULL,
						<!--- BK 20130103 <cfif len(evaluate("attributes.total_product_amount_2_#jj#"))>#evaluate("attributes.total_product_amount_2_#jj#")#<cfelse>NULL</cfif>,--->
						<cfif len(evaluate("attributes.catalog_id_#jj#"))>#evaluate("attributes.catalog_id_#jj#")#<cfelse>NULL</cfif>,
						<cfif isdefined("attributes.prom_list_status_and_#jj#")>1<cfelse>0</cfif>,
						<cfif len(evaluate("attributes.product_point_#jj#"))>#evaluate("attributes.product_point_#jj#")#<cfelse>NULL</cfif>
					)
				</cfquery>
				<cfset row_count = evaluate("attributes.record_num1_#jj#")>
				<cfloop from="1" to="#row_count#" index="kk">
                	<cfif len(row_count)>
						<cfif evaluate("attributes.row_kontrol1_#jj#_#kk#") and len(evaluate("attributes.product_id_#jj#_#kk#")) and len(evaluate("attributes.product_amount_#jj#_#kk#")) and evaluate("attributes.product_amount_#jj#_#kk#") gt 0>
                            <cfquery name="ADD_COND_PRODUCTS" datasource="#DSN3#">
                                INSERT INTO
                                    PROMOTION_CONDITIONS_PRODUCTS
                                (
                                    PROM_CONDITION_ID,
                                    PRODUCT_ID,
                                    STOCK_ID,
                                    CATALOG_PAGE_NUMBER,
                                    PRODUCT_AMOUNT,
                                    IS_SALE_WITH_PROM
                                )
                                VALUES
                                (
                                    #MAX_ID.IDENTITYCOL#,
                                    #evaluate("attributes.product_id_#jj#_#kk#")#,
                                    #evaluate("attributes.stock_id_#jj#_#kk#")#,
                                    <cfif len(evaluate("attributes.catalog_page_no_#jj#_#kk#"))>#evaluate("attributes.catalog_page_no_#jj#_#kk#")#<cfelse>NULL</cfif>,
                                    <cfif len(evaluate("attributes.product_amount_#jj#_#kk#"))>#evaluate("attributes.product_amount_#jj#_#kk#")#<cfelse>NULL</cfif>,
                                    <cfif isdefined("attributes.is_only_sale_product_#jj#_#kk#")>1<cfelse>0</cfif>
                                )
                            </cfquery>
                        </cfif>
                    </cfif>
				</cfloop>
			</cfif>
		</cfloop>
		<cf_workcube_process 
			is_upd='1' 
			data_source='#dsn3#' 
			old_process_line='0'
			process_stage='#attributes.process_stage#' 
			record_member='#session.ep.userid#' 
			record_date='#now()#' 
			action_table='PROMOTIONS'
			action_column='PROM_ID'
			action_id='#attributes.prom_id#'
			action_page='#request.self#?fuseaction=mlm.promotions&event=updDetail&prom_id=#attributes.prom_id#' 
			warning_description='Promosyon : #attributes.prom_id#'>
	</cftransaction>
</cflock>
<cfset attributes.actionId = attributes.prom_id >
<script type="text/javascript">
	window.location.href="<cfoutput>#request.self#?fuseaction=mlm.promotions&event=updDetail&prom_id=#attributes.prom_id#</cfoutput>"
</script>
