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
		<cfquery name="ADD_PROM" datasource="#DSN3#">
			INSERT INTO
				PROMOTIONS
                (
                    PROM_NO,
                    PROM_HEAD,
                    PROM_STATUS,
                    PROM_STAGE,
                    STARTDATE,
                    FINISHDATE,
                    PROM_DETAIL,
                    PRICE_CATID,
                    CONDITION_PRICE_CATID,
                    PROM_ZONE,
                    PROM_TYPE,
                    IS_DETAIL,
                    IS_ONLY_FIRST_ORDER,
                    PROM_HIERARCHY,
                    DISCOUNT,
                    AMOUNT_DISCOUNT,
                    AMOUNT_DISCOUNT_MONEY_1,
                    TOTAL_DISCOUNT_AMOUNT,
                    TOTAL_DISCOUNT_PRICE,
                    CATALOG_ID,
                    ONLY_SAME_PRODUCT,
                    PRODUCT_PROMOTION_NONEFFECT,
                    LIST_WORK_TYPE,
                    CONTROL_START_DATE,
                    CONTROL_FINISH_DATE,
                    CAMP_ID,
                    CONDITION_LIST_WORK_TYPE,
                    CONSUMERCAT_ID,
                    PROM_WORK_COUNT,
                    REFERENCE_CODE,
                    ICON_ID,
                    PROM_ACTION_TYPE,
                    IS_REQUIRED_PROM,
                    IS_INTERNET,
                    IS_PROM_WARNING,
                    DETAIL_PROM_TYPE,
                    WORK_CAMP_TYPE,
                    IS_CONS_REF_PROM,
                    MEMBER_ORDER_COUNT,
                    MEMBER_RECORD_LINE,
                    IS_DEMAND_PRODUCTS,
                    IS_DEMAND_ORDER_PRODUCTS,
                    DRP_RTR_FROM_PROM,
                    PROM_WORK_TYPE,
                    MONEY_CREDIT,
                    VALID_DAY,
                    DEMAND_CONTROL_DATE,
                    CREDIT_PAY_TYPES,
                    MEMBER_ADD_OPTION_ID,				
                    RECORD_EMP,
                    RECORD_IP,
                    RECORD_DATE
                )
                VALUES
                (
                    '#attributes.system_paper_no#',
                    '#attributes.prom_head#',
                    <cfif isdefined("attributes.prom_status")>1<cfelse>0</cfif>,
                    #attributes.process_stage#,
                    <cfif len(attributes.startdate)>#attributes.startdate#<cfelse>NULL</cfif>,
                    <cfif len(attributes.finishdate)>#attributes.finishdate#<cfelse>NULL</cfif>,
                    '#attributes.prom_detail#',
                    #attributes.price_catid#,
                    <cfif len(attributes.condition_price_catid)>#attributes.condition_price_catid#<cfelse>NULL</cfif>,
                    0,
                    #attributes.prom_type#,
                    1,
                    <cfif isdefined("attributes.first_order")>1<cfelse>0</cfif>,
                    <cfif len(attributes.work_hierarchy)>#attributes.work_hierarchy#<cfelse>NULL</cfif>,
                    <cfif isdefined("attributes.discount_1") and len(attributes.discount_1)>#attributes.discount_1#<cfelse>0</cfif>,
                    <cfif isdefined("attributes.amount_discount_1") and len(attributes.amount_discount_1)>#attributes.amount_discount_1#<cfelse>0</cfif>,
                    <cfif isdefined("attributes.amount_discount_money_1") and len(attributes.amount_discount_money_1)>'#attributes.amount_discount_money_1#'<cfelse>NULL</cfif>,					
                    <cfif isdefined("attributes.product_benefit_count") and len(attributes.product_benefit_count)>#attributes.product_benefit_count#<cfelse>NULL</cfif>,					
                    <cfif isdefined("attributes.product_benefit_amount") and len(attributes.product_benefit_amount)>#attributes.product_benefit_amount#<cfelse>NULL</cfif>,		
                    <cfif len(attributes.catalog_id)>#attributes.catalog_id#<cfelse>NULL</cfif>,		
                    <cfif isdefined("attributes.is_only_same_product")>1<cfelse>0</cfif>,
                    <cfif isdefined("attributes.is_other_prom_act")>1<cfelse>0</cfif>,
                    <cfif isdefined("attributes.prom_benefit_status_and")>1<cfelse>0</cfif>,
                    <cfif len(attributes.startdate)>#attributes.startdate#<cfelse>NULL</cfif>,
                    <cfif len(attributes.finishdate)>#attributes.finishdate#<cfelse>NULL</cfif>,
                    <cfif len(attributes.camp_id)>#attributes.camp_id#<cfelse>NULL</cfif>,		
                    <cfif isdefined("attributes.prom_condition_status_and")>1<cfelse>0</cfif>,
                    <cfif isdefined("attributes.consumer_category") and len(attributes.consumer_category)>'#attributes.consumer_category#'<cfelse>NULL</cfif>,	
                    <cfif len(attributes.prom_count)>#attributes.prom_count#<cfelse>NULL</cfif>,
                    <cfif len(attributes.reference_code)>'#attributes.reference_code#'<cfelse>NULL</cfif>,
                    <cfif isDefined("attributes.icon_id") and len(attributes.icon_id)>#attributes.icon_id#<cfelse>NULL</cfif>,
                    <cfif isDefined("attributes.prom_action_type") and len(attributes.prom_action_type)>#attributes.prom_action_type#<cfelse>NULL</cfif>,
                    <cfif isdefined("attributes.is_required_prom")>1<cfelse>0</cfif>,
                    <cfif isdefined("attributes.is_internet")>1<cfelse>0</cfif>,
                    <cfif isdefined("attributes.is_prom_warning")>1<cfelse>0</cfif>,
                    #attributes.detail_prom_type#,
                    <cfif isdefined("attributes.kamp_type") and len(attributes.kamp_type)>'#attributes.kamp_type#'<cfelse>NULL</cfif>,
                    <cfif isdefined("attributes.consumer_ref_prom")>1<cfelse>0</cfif>,
                    <cfif isdefined("attributes.member_order_count") and len(attributes.member_order_count)>#attributes.member_order_count#<cfelse>NULL</cfif>,
                    <cfif isdefined("attributes.member_line_order") and len(attributes.member_line_order)>#attributes.member_line_order#<cfelse>NULL</cfif>,
                    <cfif isdefined("attributes.is_demand_products")>1<cfelse>0</cfif>,
                    <cfif isdefined("attributes.drp_rtr_from_prom")>1<cfelse>0</cfif>,			
                    <cfif isdefined("attributes.is_demand_order_promotion_price")>1<cfelse>0</cfif>,
                    <cfif isdefined("attributes.is_prom_and")>1<cfelse>0</cfif>,
                    <cfif isdefined("attributes.parapuan_percent") and len(attributes.parapuan_percent)>#attributes.parapuan_percent#<cfelse>NULL</cfif>,
                    <cfif len(attributes.valid_day)>#attributes.valid_day#<cfelse>NULL</cfif>,
                    <cfif len(attributes.control_date)>#attributes.control_date#<cfelse>NULL</cfif>,
                    <cfif isdefined("attributes.credit_pay_types") and len(attributes.credit_pay_types)>'#attributes.credit_pay_types#'<cfelse>NULL</cfif>,
                    <cfif isdefined("attributes.member_add_option") and len(attributes.member_add_option)>'#attributes.member_add_option#'<cfelse>NULL</cfif>,				
                    #session.ep.userid#,
                    '#cgi.remote_addr#',
                    #now()#
                )
		</cfquery>
		<cfquery name="GET_MAX" datasource="#DSN3#">
			SELECT MAX(PROM_ID) AS MAX_ID FROM PROMOTIONS
		</cfquery>
		<cfquery name="UPD_GEN_PAP" datasource="#DSN3#">
			UPDATE 
				GENERAL_PAPERS
			SET
				PROMOTION_NUMBER = #attributes.system_paper_no_add#
			WHERE
				PROMOTION_NUMBER IS NOT NULL
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
						#get_max.max_id#,
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
						#get_max.max_id#,
						#evaluate("attributes.promotion_id#ll#")#
					)
				</cfquery>
			</cfif>
		</cfloop>
		<cfloop from="1" to="#attributes.record_num#" index="jj">
			<cfif evaluate("attributes.row_control_prom_#jj#") eq 1>
				<cfquery name="ADD_CONDITIONS" datasource="#DSN3#">
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
						#get_max.max_id#,
						<cfif len(evaluate("attributes.product_count_#jj#"))>#evaluate("attributes.product_count_#jj#")#<cfelse>NULL</cfif>,
						<cfif len(evaluate("attributes.product_amount_#jj#"))>#evaluate("attributes.product_amount_#jj#")#<cfelse>NULL</cfif>,
                        NULL,
                        <!--- BK 20130103 <cfif isdefined("attributes.total_product_amount_2_#jj#") and len(evaluate("attributes.total_product_amount_2_#jj#"))>#evaluate("attributes.total_product_amount_2_#jj#")#<cfelse>NULL</cfif>,--->
						<cfif len(evaluate("attributes.catalog_id_#jj#"))>#evaluate("attributes.catalog_id_#jj#")#<cfelse>NULL</cfif>,
						<cfif isdefined("attributes.prom_list_status_and_#jj#")>1<cfelse>0</cfif>,
						<cfif len(evaluate("attributes.product_point_#jj#"))>#evaluate("attributes.product_point_#jj#")#<cfelse>NULL</cfif>
					)
				</cfquery>
				<cfquery name="GET_MAX_COND" datasource="#DSN3#">
					SELECT MAX(PROM_CONDITION_ID) AS MAX_ID FROM PROMOTION_CONDITIONS
				</cfquery>
				<cfset row_count = evaluate("attributes.record_num1_#jj#")>
				<cfif len(row_count)>
					<cfloop from="1" to="#row_count#" index="kk">
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
									#get_max_cond.max_id#,
									#evaluate("attributes.product_id_#jj#_#kk#")#,
									#evaluate("attributes.stock_id_#jj#_#kk#")#,
									<cfif len(evaluate("attributes.catalog_page_no_#jj#_#kk#"))>#evaluate("attributes.catalog_page_no_#jj#_#kk#")#<cfelse>NULL</cfif>,
									<cfif len(evaluate("attributes.product_amount_#jj#_#kk#"))>#evaluate("attributes.product_amount_#jj#_#kk#")#<cfelse>NULL</cfif>,
									<cfif isdefined("attributes.is_only_sale_product_#jj#_#kk#")>1<cfelse>0</cfif>
								)
							</cfquery>
						</cfif>
					</cfloop>
				</cfif>
			</cfif>
		</cfloop>
		
		<!--- Varsa kampanyaya bağlı segmentesyon ve prim bilgileri yazılıyor--->
		<cfif len(attributes.camp_id)>
			<cfquery name="GET_SEGMENT" datasource="#DSN3#">
				SELECT CONSCAT_SEGMENT_ID FROM SETUP_CONSCAT_SEGMENTATION WHERE CAMPAIGN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.camp_id#">
			</cfquery>
			<cfif get_segment.recordcount>
				<cfquery name="ADD_SEGMENT" datasource="#DSN3#">
					INSERT INTO
						SETUP_CONSCAT_SEGMENTATION
					(
						PROMOTION_ID,
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
						#get_max.max_id#,
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
						CAMPAIGN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.camp_id#">	
				</cfquery>
				<cfquery name="GET_MAX_ID" datasource="#DSN3#">
					SELECT MAX(CONSCAT_SEGMENT_ID) CONSCAT_SEGMENT_ID FROM SETUP_CONSCAT_SEGMENTATION
				</cfquery>	
				<cfquery name="GET_SEGMENT_ROWS" datasource="#DSN3#">
					SELECT CONSCAT_SEGMENT_ID FROM SETUP_CONSCAT_SEGMENTATION_ROWS WHERE CONSCAT_SEGMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_segment.conscat_segment_id#">
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
							CONSCAT_SEGMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_segment.conscat_segment_id#">
					</cfquery>	
				</cfif>
			</cfif>	
			<cfquery name="GET_PREMIUM" datasource="#DSN3#">
				SELECT CAMPAIGN_ID FROM SETUP_CONSCAT_PREMIUM WHERE CAMPAIGN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.camp_id#">
			</cfquery>
			<cfif get_premium.recordcount>
				<cfquery name="ADD_PREMIUM" datasource="#DSN3#">
					INSERT INTO
						SETUP_CONSCAT_PREMIUM
					(
						PROMOTION_ID,
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
						#get_max.max_id#,
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
						CAMPAIGN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.camp_id#">
				</cfquery>
			</cfif>
		</cfif>
		<cf_workcube_process 
			is_upd='1' 
			data_source='#dsn3#' 
			old_process_line='0'
			process_stage='#attributes.process_stage#' 
			record_member='#session.ep.userid#' 
			record_date='#now()#' 
			action_table='PROMOTIONS'
			action_column='PROM_ID'
			action_id='#get_max.max_id#'
			action_page='#request.self#?fuseaction=mlm.promotions&event=updDetail&prom_id=#get_max.max_id#' 
			warning_description='Promosyon : #get_max.max_id#'>
	</cftransaction>
</cflock>
<cfset attributes.actionId = get_max.max_id>
<script type="text/javascript">
	window.location.href="<cfoutput>#request.self#?fuseaction=mlm.promotions&event=updDetail&prom_id=#get_max.max_id#</cfoutput>";
</script>