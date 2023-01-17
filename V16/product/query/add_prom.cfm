<cfif isdefined('attributes.target_due_date') and IsDate(attributes.target_due_date)><cf_date tarih="attributes.target_due_date"></cfif>
<cfif len(attributes.startdate)>
	<cf_date tarih="attributes.startdate">
	<cfif isdefined("session.ep.time_zone")>
		<cfset attributes.startdate = date_add("n",START_MINUTE,date_add("h",START_CLOCK,attributes.startdate))>
	<cfelseif isdefined("session.pp.time_zone")>
		<cfset attributes.startdate = date_add("n",START_MINUTE,date_add("h",START_CLOCK,attributes.startdate))>
	</cfif>	
</cfif>
<cfif len(attributes.finishdate)>
	<cf_date tarih="attributes.finishdate">
	<cfif isdefined("session.ep.time_zone")>
		<cfset attributes.finishdate = date_add("n",FINISH_MINUTE,date_add("h",FINISH_CLOCK,attributes.finishdate))>
	<cfelseif isdefined("session.pp.time_zone")>
		<cfset attributes.finishdate = date_add("n",FINISH_MINUTE,date_add("h",FINISH_CLOCK,attributes.finishdate))>
	</cfif>	
</cfif>
<cfif len(attributes.camp_id)>
	<cfquery name="GET_CAMPAIGN" datasource="#DSN3#">
		SELECT CAMP_STARTDATE,CAMP_FINISHDATE FROM CAMPAIGNS WHERE CAMP_ID = #attributes.camp_id#
	</cfquery>
	<cfif (attributes.startdate lt date_add("H",session.ep.time_zone,get_campaign.camp_startdate)) or (attributes.finishdate gt date_add("H",session.ep.time_zone,get_campaign.camp_finishdate))>
		<script type="text/javascript">
			alert("<cf_get_lang no ='871.Promosyon Tarihi Kampanya Tarihi ile Uyuşmuyor, Lütfen Geri Dönüp Kontrol Ediniz'> !");
			window.history.go(-1);
		</script>	
		<cfabort>
	</cfif>
</cfif>
<cf_papers paper_type="promotion">
<cfset system_paper_no=paper_code & '-' & paper_number>
<cfset system_paper_no_add=paper_number>
<cflock name="#CreateUUID()#" timeout="20">
	<cftransaction>
	<cfquery name="ADD_PROM" datasource="#DSN3#">
		INSERT INTO
			PROMOTIONS
		(
			PROM_NO,
			CAMP_ID,
			CATALOG_ID,
			PROM_HEAD,
			STOCK_ID,
			PRODUCT_CATID,
			COMPANY_ID,
			SUPPLIER_ID,
			FREE_STOCK_ID,
			FREE_STOCK_AMOUNT,
			FREE_STOCK_PRICE,
			GIFT_AMOUNT,
			GIFT_PRICE,
			PROM_STATUS,
			PROM_STAGE,
			LIMIT_TYPE,
			LIMIT_VALUE,
			PROMOTION_CODE,
			BANNER_ID,
			USER_FRIENDLY_URL,
			<cfif len(LIMIT_CURRENCY)>LIMIT_CURRENCY,</cfif>
			<cfif isdefined("GIFT_HEAD") and len(GIFT_HEAD)>GIFT_HEAD,</cfif>
			<cfif len(PROM_POINT)>PROM_POINT,</cfif>
			<cfif len(TOTAL_AMOUNT)>TOTAL_AMOUNT,</cfif>
			<cfif len(COUPON_ID)>COUPON_ID,</cfif>
			<!--- BK 20130722 6 aya silinsin <cfif len(DISCOUNT_TYPE_ID_1)>DISCOUNT_TYPE_ID_1,</cfif> --->
			<cfif isdefined("DISCOUNT_1") and len(DISCOUNT_1)>DISCOUNT,</cfif>
			<cfif isdefined("AMOUNT_DISCOUNT_1") and len(AMOUNT_DISCOUNT_1)>AMOUNT_DISCOUNT,</cfif>
			<cfif isdefined("AMOUNT_DISCOUNT_MONEY_1") and len(AMOUNT_DISCOUNT_MONEY_1)>AMOUNT_DISCOUNT_MONEY_1,</cfif> 
			<!--- BK 20130722 6 aya silinsin <cfif len(DISCOUNT_TYPE_ID_2)>DISCOUNT_TYPE_ID_2,</cfif> --->
			<cfif len(AMOUNT_DISCOUNT_2)>AMOUNT_DISCOUNT_2,</cfif>
			<cfif len(AMOUNT_DISCOUNT_MONEY_2)>AMOUNT_DISCOUNT_MONEY_2,</cfif>
			<cfif isdefined("PRIM_PERCENT") and len(PRIM_PERCENT)>PRIM_PERCENT,</cfif>
			<cfif isdefined("AMOUNT_1") and len(AMOUNT_1)>AMOUNT_1,</cfif>
			<cfif isdefined("AMOUNT_2") and len(AMOUNT_2)>AMOUNT_2,</cfif>
			<cfif isdefined("AMOUNT_3") and len(AMOUNT_3)>AMOUNT_3,</cfif>
			<cfif isdefined("AMOUNT_4") and len(AMOUNT_4)>AMOUNT_4,</cfif>
			<cfif isdefined("AMOUNT_5") and len(AMOUNT_5)>AMOUNT_5,</cfif>
			<cfif isdefined("AMOUNT_1_MONEY") and len(AMOUNT_1_MONEY)>AMOUNT_1_MONEY,</cfif>
			<cfif isdefined("AMOUNT_2_MONEY") and len(AMOUNT_2_MONEY)>AMOUNT_2_MONEY,</cfif>
			<cfif isdefined("AMOUNT_3_MONEY") and len(AMOUNT_3_MONEY)>AMOUNT_3_MONEY,</cfif>
			<cfif isdefined("AMOUNT_4_MONEY") and len(AMOUNT_4_MONEY)>AMOUNT_4_MONEY,</cfif>
			<cfif isdefined("AMOUNT_5_MONEY") and len(AMOUNT_5_MONEY)>AMOUNT_5_MONEY,</cfif>
			<cfif isdefined("TOTAL_PROMOTION_COST") and len(TOTAL_PROMOTION_COST)>TOTAL_PROMOTION_COST,</cfif>
			<cfif isdefined("TOTAL_PROMOTION_COST_MONEY") and len(TOTAL_PROMOTION_COST_MONEY)>TOTAL_PROMOTION_COST_MONEY,</cfif>
			ICON_ID,
			<cfif len(attributes.startdate)>STARTDATE,</cfif>
			<cfif len(attributes.finishdate)>FINISHDATE,</cfif>
			PROM_DETAIL,
			PRICE_CATID,
		 	 <cfif isdefined("SESSION.EP.USERID")>RECORD_EMP,</cfif>	
			PROM_ZONE,
			BRAND_ID,
			PROM_TYPE,
			<!--- IS_VIEWED, --->
			IS_ALL_PRODUCTS,
			DISCOUNT_RATE,
			NUMBER_GIFT_PRODUCT,
			NUMBER_GIFT_PRODUCT_RATIO,
			SPECIAL_PRODUCT_DISCOUNT_RATE,
			CARD_TYPE,
			RECORD_DATE,
			RECORD_IP,
			DUE_DAY,
			TARGET_DUE_DATE,
			IS_DETAIL
		)
		VALUES
		(
			'#system_paper_no#',
			<cfif len(attributes.camp_id) and len(attributes.camp_name)>#attributes.camp_id#<cfelse>NULL</cfif>,
			<cfif isdefined("attributes.catalog_id") and  isdefined("attributes.catalog_head") and len(attributes.catalog_id) and len(attributes.catalog_head)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.catalog_id#"><cfelse>NULL</cfif>,
			'#PROM_HEAD#',
			<cfif len(attributes.stock_id) and len(attributes.product_name)>#attributes.STOCK_ID#<cfelse>NULL</cfif>,
			<cfif len(attributes.product_catid) and len(attributes.product_cat)>#attributes.product_catid#<cfelse>NULL</cfif>,
			<cfif isdefined("attributes.get_company_id") and len(attributes.get_company_id) and len(attributes.get_company)>#attributes.get_company_id#<cfelse>NULL</cfif>, 
			<cfif len(attributes.supplier_id) and len(attributes.supplier_name)>#attributes.supplier_id#<cfelse>NULL</cfif>,
			<cfif len(FREE_STOCK_ID)>#FREE_STOCK_ID#<cfelse>NULL</cfif>,
			<cfif len(FREE_STOCK_AMOUNT)>#FREE_STOCK_AMOUNT#<cfelse>NULL</cfif>,
			<cfif len(FREE_STOCK_PRICE)>#FREE_STOCK_PRICE#<cfelse>NULL</cfif>,
			<cfif isdefined("GIFT_AMOUNT") and len(GIFT_AMOUNT)>#GIFT_AMOUNT#<cfelse>NULL</cfif>,
			<cfif isdefined("GIFT_PRICE") and len(GIFT_PRICE)>#GIFT_PRICE#<cfelse>NULL</cfif>,
			<cfif isdefined("attributes.prom_status")>1<cfelse>0</cfif>,
			#attributes.process_stage#,
			<cfif len(LIMIT_VALUE)>#LIMIT_TYPE#,<cfelse>NULL,</cfif>
			<cfif len(LIMIT_VALUE)>#LIMIT_VALUE#,<cfelse>NULL,</cfif>
			<cfif  len(PROMOTION_CODE)>'#PROMOTION_CODE#',<cfelse>NULL,</cfif>
			<cfif  len(BANNER_ID)>'#BANNER_ID#',<cfelse>NULL,</cfif>
			<cfif  len(USER_FRIENDLY_URL)>'#USER_FRIENDLY_URL#',<cfelse>NULL,</cfif>
			<cfif len(LIMIT_CURRENCY)>'#LIMIT_CURRENCY#',</cfif>
			<cfif isdefined("GIFT_HEAD") and len(GIFT_HEAD)>'#GIFT_HEAD#',</cfif>
			<cfif len(PROM_POINT)>#PROM_POINT#,</cfif>
			<cfif len(TOTAL_AMOUNT)>#TOTAL_AMOUNT#,</cfif>
			<cfif len(COUPON_ID)>#COUPON_ID#,</cfif>
			<!--- BK 20130722 6 aya silinsin <cfif len(DISCOUNT_TYPE_ID_1)>#DISCOUNT_TYPE_ID_1#,</cfif> --->
			<cfif isdefined("DISCOUNT_1") and len(DISCOUNT_1)>#DISCOUNT_1#,</cfif>
			<cfif isdefined("AMOUNT_DISCOUNT_1") and len(AMOUNT_DISCOUNT_1)>#AMOUNT_DISCOUNT_1#,</cfif>
			<cfif isdefined("AMOUNT_DISCOUNT_MONEY_1") and len(AMOUNT_DISCOUNT_MONEY_1)>'#AMOUNT_DISCOUNT_MONEY_1#',</cfif>
			<!--- BK 20130722 6 aya silinsin <cfif len(DISCOUNT_TYPE_ID_2)>#DISCOUNT_TYPE_ID_2#,</cfif> --->
			<cfif len(AMOUNT_DISCOUNT_2)>#AMOUNT_DISCOUNT_2#,</cfif>
			<cfif len(AMOUNT_DISCOUNT_MONEY_2)>'#AMOUNT_DISCOUNT_MONEY_2#',</cfif>
			<cfif isdefined("PRIM_PERCENT") and len(PRIM_PERCENT)>#PRIM_PERCENT#,</cfif>
			<cfif isdefined("AMOUNT_1") and len(AMOUNT_1)><cfqueryparam cfsqltype="cf_sql_float" value="#AMOUNT_1#">,</cfif>
			<cfif isdefined("AMOUNT_2") and len(AMOUNT_2)><cfqueryparam cfsqltype="cf_sql_float" value="#AMOUNT_2#">,</cfif>
			<cfif isdefined("AMOUNT_3") and len(AMOUNT_3)><cfqueryparam cfsqltype="cf_sql_float" value="#AMOUNT_3#">,</cfif>
			<cfif isdefined("AMOUNT_4") and len(AMOUNT_4)><cfqueryparam cfsqltype="cf_sql_float" value="#AMOUNT_4#">,</cfif>
			<cfif isdefined("AMOUNT_5") and len(AMOUNT_5)><cfqueryparam cfsqltype="cf_sql_float" value="#AMOUNT_5#">,</cfif>
			<cfif isdefined("AMOUNT_1_MONEY") and len(AMOUNT_1_MONEY)><cfqueryparam cfsqltype="cf_sql_varchar" value="#AMOUNT_1_MONEY#">,</cfif>
			<cfif isdefined("AMOUNT_2_MONEY") and len(AMOUNT_2_MONEY)><cfqueryparam cfsqltype="cf_sql_varchar" value="#AMOUNT_2_MONEY#">,</cfif>
			<cfif isdefined("AMOUNT_3_MONEY") and len(AMOUNT_3_MONEY)><cfqueryparam cfsqltype="cf_sql_varchar" value="#AMOUNT_3_MONEY#">,</cfif>
			<cfif isdefined("AMOUNT_4_MONEY") and len(AMOUNT_4_MONEY)><cfqueryparam cfsqltype="cf_sql_varchar" value="#AMOUNT_4_MONEY#">,</cfif>
			<cfif isdefined("AMOUNT_5_MONEY") and len(AMOUNT_5_MONEY)><cfqueryparam cfsqltype="cf_sql_varchar" value="#AMOUNT_5_MONEY#">,</cfif>
			<cfif isdefined("TOTAL_PROMOTION_COST") and len(TOTAL_PROMOTION_COST)><cfqueryparam cfsqltype="cf_sql_float" value="#TOTAL_PROMOTION_COST#">,</cfif>
			<cfif isdefined("TOTAL_PROMOTION_COST_MONEY") and len(TOTAL_PROMOTION_COST_MONEY)>'#TOTAL_PROMOTION_COST_MONEY#',</cfif>
			<cfif isDefined("FORM.ICON_ID") and len(FORM.ICON_ID)>#FORM.ICON_ID#,<cfelse>NULL,</cfif>
			<cfif len(attributes.STARTDATE)>#attributes.STARTDATE#,</cfif>
			<cfif len(attributes.FINISHDATE)>#attributes.FINISHDATE#,</cfif>
			'#PROM_DETAIL#',
			#PRICE_CATID#,
			<cfif isdefined("session.ep.userid")>#SESSION.EP.USERID#,</cfif>
			0,
			<cfif isDefined("attributes.brand_id") and len(attributes.brand_id)>#attributes.brand_id#<cfelse>NULL</cfif>,
			#attributes.prom_type#,
			<!--- <cfif isdefined("attributes.is_viewed")>1<cfelse>0</cfif>, --->
			<cfif isdefined("attributes.is_all_products") and len(attributes.is_all_products)><cfqueryparam cfsqltype="cf_sql_bit" value="#attributes.is_all_products#"><cfelse>NULL</cfif>,
			<cfif isdefined("attributes.discount_rate") and len(attributes.discount_rate)><cfqueryparam cfsqltype="cf_sql_float" value="#attributes.discount_rate#"><cfelse>NULL</cfif>,
			<cfif isdefined("attributes.number_gift_product") and len(attributes.number_gift_product)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.number_gift_product#"><cfelse>NULL</cfif>,
			<cfif isdefined("attributes.number_gift_product_ratio") and len(attributes.number_gift_product_ratio)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.number_gift_product_ratio#"><cfelse>NULL</cfif>,
			<cfif isdefined("attributes.special_product_discount_rate") and len(attributes.special_product_discount_rate)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.special_product_discount_rate#"><cfelse>NULL</cfif>,
			<cfif isdefined("attributes.card_type") and len(attributes.card_type)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.card_type#"><cfelse>NULL</cfif>,
			#now()#,
			'#CGI.REMOTE_ADDR#',
			<cfif isdefined('attributes.due_day') and len(attributes.due_day)>#attributes.DUE_DAY#<cfelse>NULL</cfif>,
			<cfif isdefined('attributes.target_due_date') and len(attributes.target_due_date)>#attributes.TARGET_DUE_DATE#<cfelse>NULL</cfif>,
			0
		)
	</cfquery>
	<cfquery name="GET_MAX" datasource="#dsn3#">
		SELECT MAX(PROM_ID) AS MAX_ID FROM PROMOTIONS
	</cfquery>
	
	<!--- Varsa kampanyaya bağlı segmentesyon ve prim bilgileri yazılıyor--->
	<cfif len(attributes.camp_id)>
		<cfquery name="get_segment" datasource="#dsn3#">
			SELECT * FROM SETUP_CONSCAT_SEGMENTATION WHERE CAMPAIGN_ID = #attributes.camp_id#
		</cfquery>
		<cfif get_segment.recordcount>
			<cfquery name="add_segment" datasource="#dsn3#">
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
						CAMPAIGN_ID = #attributes.camp_id#	
			</cfquery>
			<cfquery name="get_max_id" datasource="#dsn3#">
				SELECT MAX(CONSCAT_SEGMENT_ID) CONSCAT_SEGMENT_ID FROM SETUP_CONSCAT_SEGMENTATION
			</cfquery>	
			<cfquery name="get_segment_rows" datasource="#dsn3#">
				SELECT * FROM SETUP_CONSCAT_SEGMENTATION_ROWS WHERE CONSCAT_SEGMENT_ID = #get_segment.CONSCAT_SEGMENT_ID#
			</cfquery>	
			<cfif get_segment_rows.recordcount>
				<cfquery name="add_segment_row" datasource="#dsn3#">
					INSERT INTO
						SETUP_CONSCAT_SEGMENTATION_ROWS
						(
							CONSCAT_SEGMENT_ID,
							CONSCAT_ID,
							ROW_MEMBER_COUNT
						)
						SELECT
							#get_max_id.CONSCAT_SEGMENT_ID#,
							CONSCAT_ID,
							ROW_MEMBER_COUNT
						FROM
							SETUP_CONSCAT_SEGMENTATION_ROWS
						WHERE
							CONSCAT_SEGMENT_ID = #get_segment.CONSCAT_SEGMENT_ID#
				</cfquery>	
			</cfif>
		</cfif>
		<cfquery name="get_premium" datasource="#dsn3#">
			SELECT * FROM SETUP_CONSCAT_PREMIUM WHERE CAMPAIGN_ID = #attributes.camp_id#
		</cfquery>
		<cfif get_premium.recordcount>
			<cfquery name="add_premium" datasource="#dsn3#">
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
						CAMPAIGN_ID = #attributes.camp_id#
			</cfquery>
		</cfif>
	</cfif>
	
	<cfquery name="UPD_GEN_PAP" datasource="#DSN3#">
		UPDATE 
			GENERAL_PAPERS
		SET
			PROMOTION_NUMBER = '#system_paper_no_add#'
		WHERE
			PROMOTION_NUMBER IS NOT NULL
	</cfquery>
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
		action_page='#request.self#?fuseaction=product.list_productions&event=upd&prom_id=#get_max.max_id#' 
		warning_description='Promosyon : #get_max.max_id#'>
	</cftransaction>
</cflock>
<cfset attributes.actionId = get_max.max_id>
<script type="text/javascript">
	window.location.href="<cfoutput>#request.self#?fuseaction=product.list_promotions&event=upd&prom_id=#get_max.max_id#</cfoutput>"; 
</script>
