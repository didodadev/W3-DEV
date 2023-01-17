<cfif len(attributes.startdate)>
	<cf_date tarih="attributes.startdate">
	<cfset attributes.startdate = date_add("h",START_CLOCK,attributes.startdate)>
	<cfset attributes.startdate = date_add("n",START_MINUTE,attributes.startdate)>
</cfif>
<cfif len(attributes.finishdate)>
	<cf_date tarih="attributes.finishdate">
	<cfset attributes.finishdate = date_add("h",FINISH_CLOCK,attributes.finishdate)>
	<cfset attributes.finishdate = date_add("n",FINISH_MINUTE,attributes.finishdate)>
</cfif>
<cf_date tarih="attributes.target_due_date">
<cfif len(form.camp_id)>
	<cfquery name="GET_CAMPAIGN" datasource="#DSN3#">
		SELECT CAMP_STARTDATE,CAMP_FINISHDATE FROM CAMPAIGNS WHERE CAMP_ID = #FORM.CAMP_ID#
	</cfquery>
	<cfif (attributes.startdate lt date_add("H",session.ep.time_zone,get_campaign.camp_startdate)) or (attributes.finishdate gt date_add("H",session.ep.time_zone,get_campaign.camp_finishdate))>
		<script type="text/javascript">
			alert("<cf_get_lang no ='871.Promosyon Tarihi Kampanya Tarihi ile Uyuşmuyor, Lütfen Geri Dönüp Kontrol Ediniz'> !");
			window.history.go(-1);
		</script>	
		<cfabort>
	</cfif>
</cfif>

<cfif len(form.prom_no)>
	<cfquery name="CHECK_PROM" datasource="#DSN3#">
		SELECT PROM_ID FROM PROMOTIONS WHERE PROM_ID <> #ATTRIBUTES.PROM_ID# AND PROM_NO = '#PROM_NO#'
	</cfquery>
	<cfif check_prom.recordcount>
		<script type="text/javascript">
			alert("<cf_get_lang no ='895.Girdiğiniz Promosyon No Kullanılıyor Lütfen Geri Dönüp Kontrol Ediniz'>..");
			window.history.go(-1);
		</script>	
		<cfabort>
	</cfif>
</cfif>
<cflock name="#CreateUUID()#" timeout="20">
  <cftransaction>
	<cfquery name="ADD_PROM" datasource="#DSN3#">
		UPDATE
			PROMOTIONS
		SET
			PROM_NO = <cfif len(PROM_NO)>'#PROM_NO#',<cfelse>NULL,</cfif>
			CAMP_ID = <cfif isdefined("attributes.camp_id") and  isdefined("attributes.camp_name") and len(attributes.camp_id) and len(attributes.camp_name)>#attributes.camp_id#<cfelse>NULL</cfif>,
			CATALOG_ID = <cfif isdefined("attributes.catalog_id") and  isdefined("attributes.catalog_head") and len(attributes.catalog_id) and len(attributes.catalog_head)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.catalog_id#"><cfelse>NULL</cfif>,
			PROM_HEAD = <cfif isdefined("attributes.PROM_HEAD") and len(attributes.PROM_HEAD)> '#PROM_HEAD#'</cfif>,
			STOCK_ID = <cfif isdefined("attributes.stock_id") and isdefined("attributes.product_name") and  len(attributes.stock_id) and len(attributes.product_name)>#STOCK_ID#,<cfelse>NULL,</cfif>
			PRODUCT_CATID = <cfif isdefined("attributes.product_catid") and isdefined("attributes.product_cat") and  len(attributes.product_catid) and len(attributes.product_cat)>#attributes.product_catid#,<cfelse>NULL,</cfif>
			COMPANY_ID =<cfif isdefined("attributes.get_company_id") and isdefined("attributes.get_company") and len(attributes.get_company_id) and len(attributes.get_company)>#attributes.get_company_id#,<cfelse>NULL,</cfif>
			SUPPLIER_ID = <cfif len(attributes.supplier_id) and len(attributes.supplier_name)>#attributes.supplier_id#,<cfelse>NULL,</cfif>
			<cfif len(FREE_PRODUCT) AND len(FREE_STOCK_ID)>FREE_STOCK_ID = #FREE_STOCK_ID#,<cfelse>FREE_STOCK_ID = NULL,</cfif>
			FREE_STOCK_AMOUNT = <cfif len(FREE_STOCK_AMOUNT)>#filterNum(FREE_STOCK_AMOUNT,2)#<cfelse>NULL</cfif>,
			FREE_STOCK_PRICE = <cfif len(FREE_STOCK_PRICE)>#filterNum(FREE_STOCK_PRICE,2)#<cfelse>NULL</cfif>,
			GIFT_AMOUNT = <cfif isdefined("GIFT_AMOUNT") and len(GIFT_AMOUNT)>#filterNum(GIFT_AMOUNT,2)#<cfelse>NULL</cfif>,
			GIFT_PRICE = <cfif isdefined("GIFT_PRICE") and len(GIFT_PRICE)>#filterNum(GIFT_PRICE,2)#<cfelse>NULL</cfif>,
			PROM_STATUS= <cfif isdefined("attributes.prom_status")>1<cfelse>0</cfif>,
			LIMIT_TYPE = <cfif len(LIMIT_VALUE)>#LIMIT_TYPE#,<cfelse>NULL,</cfif>
			LIMIT_VALUE = <cfif len(LIMIT_VALUE)>#filterNum(LIMIT_VALUE,2)#,<cfelse>NULL,</cfif>
				PROMOTION_CODE=	<cfif  isdefined("attributes.PROMOTION_CODE") and  len(attributes.PROMOTION_CODE)>'#PROMOTION_CODE#',<cfelse>NULL,</cfif>
			BANNER_ID=<cfif  isdefined("attributes.BANNER_ID") and  len(attributes.BANNER_ID)>'#BANNER_ID#',<cfelse>NULL,</cfif>
			USER_FRIENDLY_URL=<cfif  isdefined("attributes.USER_FRIENDLY_URL") and  len(attributes.USER_FRIENDLY_URL)>'#USER_FRIENDLY_URL#',<cfelse>NULL,</cfif>
			LIMIT_CURRENCY = <cfif len(LIMIT_CURRENCY)>'#LIMIT_CURRENCY#',<cfelse>NULL,</cfif>
			PROM_STAGE = <cfif isdefined("attributes.process_stage")>#attributes.process_stage#,<cfelse>NULL,</cfif>
			GIFT_HEAD = <cfif isdefined("GIFT_HEAD") and len(GIFT_HEAD)>'#GIFT_HEAD#',<cfelse>NULL,</cfif>
			PROM_POINT = <cfif len(PROM_POINT)>#PROM_POINT#,<cfelse>NULL,</cfif>
			TOTAL_AMOUNT = <cfif len(TOTAL_AMOUNT)>#filterNum(TOTAL_AMOUNT,2)#,<cfelse>NULL,</cfif>
			COUPON_ID = <cfif len(COUPON_ID)>#COUPON_ID#,<cfelse>NULL,</cfif>
			DISCOUNT = <cfif isdefined("DISCOUNT_1") and len(DISCOUNT_1)>#filterNum(DISCOUNT_1,2)#,<cfelse>NULL,</cfif>
			AMOUNT_DISCOUNT = <cfif isdefined("AMOUNT_DISCOUNT_1") and len(AMOUNT_DISCOUNT_1)>#filterNum(AMOUNT_DISCOUNT_1,2)#,<cfelse>NULL,</cfif>
			AMOUNT_DISCOUNT_MONEY_1= <cfif isdefined("AMOUNT_DISCOUNT_MONEY_1") and len(AMOUNT_DISCOUNT_MONEY_1)>'#AMOUNT_DISCOUNT_MONEY_1#',<cfelse>NULL,</cfif>
			<!--- BK 180 gune silinsin 20130724 DISCOUNT_TYPE_ID_2 = <cfif len(DISCOUNT_TYPE_ID_2)>#DISCOUNT_TYPE_ID_2#,<cfelse>NULL,</cfif> --->
			AMOUNT_DISCOUNT_2 = <cfif len(AMOUNT_DISCOUNT_2)>#filterNum(AMOUNT_DISCOUNT_2,2)#,<cfelse>NULL,</cfif>
			AMOUNT_DISCOUNT_MONEY_2= <cfif len(AMOUNT_DISCOUNT_MONEY_2)>'#AMOUNT_DISCOUNT_MONEY_2#',<cfelse>NULL,</cfif>
			PRIM_PERCENT = <cfif isdefined("PRIM_PERCENT") and len(PRIM_PERCENT)>#PRIM_PERCENT#,<cfelse>NULL,</cfif>
			AMOUNT_1 = <cfif isdefined("AMOUNT_1") and len(AMOUNT_1)>#filterNum(AMOUNT_1,2)#,<cfelse>NULL,</cfif>
			AMOUNT_2 = <cfif isdefined("AMOUNT_2") and len(AMOUNT_2)>#filterNum(AMOUNT_2,2)#,<cfelse>NULL,</cfif>
			AMOUNT_3 = <cfif isdefined("AMOUNT_3") and len(AMOUNT_3)>#filterNum(AMOUNT_3,2)#,<cfelse>NULL,</cfif>
			AMOUNT_4 = <cfif isdefined("AMOUNT_4") and len(AMOUNT_4)>#filterNum(AMOUNT_4,2)#,<cfelse>NULL,</cfif>
			AMOUNT_5 = <cfif isdefined("AMOUNT_5") and len(AMOUNT_5)>#filterNum(AMOUNT_5,2)#,<cfelse>NULL,</cfif>
			AMOUNT_1_MONEY = <cfif len(AMOUNT_1_MONEY)>'#AMOUNT_1_MONEY#',<cfelse>NULL,</cfif>
			AMOUNT_2_MONEY = <cfif isdefined("AMOUNT_2_MONEY") and len(AMOUNT_2_MONEY)>'#AMOUNT_2_MONEY#',<cfelse>NULL,</cfif>
			AMOUNT_3_MONEY = <cfif isdefined("AMOUNT_3_MONEY") and len(AMOUNT_3_MONEY)>'#AMOUNT_3_MONEY#',<cfelse>NULL,</cfif>
			AMOUNT_4_MONEY = <cfif isdefined("AMOUNT_4_MONEY") and len(AMOUNT_4_MONEY)>'#AMOUNT_4_MONEY#',<cfelse>NULL,</cfif>
			AMOUNT_5_MONEY = <cfif isdefined("AMOUNT_5_MONEY") and len(AMOUNT_5_MONEY)>'#AMOUNT_5_MONEY#',<cfelse>NULL,</cfif>
			TOTAL_PROMOTION_COST = <cfif len(TOTAL_PROMOTION_COST)>#filterNum(TOTAL_PROMOTION_COST,2)#,<cfelse>NULL,</cfif>
			TOTAL_PROMOTION_COST_MONEY = <cfif isdefined("TOTAL_PROMOTION_COST_MONEY") and len(TOTAL_PROMOTION_COST_MONEY)>'#TOTAL_PROMOTION_COST_MONEY#',<cfelse>NULL,</cfif>
			<cfif isDefined("FORM.ICON_ID") AND len(FORM.ICON_ID)>ICON_ID = #ICON_ID#,<cfelse>ICON_ID = NULL,</cfif>
			<cfif len(attributes.startdate)>
			STARTDATE = #attributes.startdate#,<cfelse>NULL,
			</cfif>
			<cfif len(attributes.finishdate)>
			FINISHDATE = #attributes.finishdate#,<cfelse>NULL,
			</cfif>
			PROM_DETAIL = <cfif len(PROM_DETAIL)>'#PROM_DETAIL#',<cfelse>NULL,</cfif>
			PRICE_CATID = <cfif len(PRICE_CATID)>#PRICE_CATID#<cfelse>NULL</cfif>,
			BRAND_ID = <cfif isdefined("form.brand_id") and len(form.brand_id) and isdefined('form.brand_name') and len(form.brand_name)>#form.brand_id#,<cfelse>NULL,</cfif>
			PROM_TYPE = <cfif len(prom_type)>#attributes.prom_type#<cfelse>NULL</cfif>,
			<!--- IS_VIEWED = <cfif isdefined("attributes.is_viewed")>1<cfelse>0</cfif>, --->
			IS_ALL_PRODUCTS = <cfif isdefined("attributes.is_all_products") and len(attributes.is_all_products)><cfqueryparam cfsqltype="cf_sql_bit" value="#attributes.is_all_products#"><cfelse>NULL</cfif>,
			NUMBER_GIFT_PRODUCT =	<cfif isdefined("attributes.number_gift_product") and len(attributes.number_gift_product)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.number_gift_product#"><cfelse>NULL</cfif>,
			NUMBER_GIFT_PRODUCT_RATIO =	<cfif isdefined("attributes.number_gift_product_ratio") and len(attributes.number_gift_product_ratio)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.number_gift_product_ratio#"><cfelse>NULL</cfif>,
			SPECIAL_PRODUCT_DISCOUNT_RATE = <cfif isdefined("attributes.special_product_discount_rate") and len(attributes.special_product_discount_rate)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.special_product_discount_rate#"><cfelse>NULL</cfif>,
			CARD_TYPE = <cfif isdefined("attributes.card_type") and len(attributes.card_type)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.card_type#"><cfelse>NULL</cfif>,
			DUE_DAY = <cfif isdefined('attributes.due_day') and len(attributes.due_day)>#attributes.due_day#<cfelse>NULL</cfif>,
			TARGET_DUE_DATE = <cfif isdefined('attributes.target_due_date') and isdate(attributes.target_due_date)>#attributes.target_due_date#<cfelse>NULL</cfif>, 
			UPDATE_DATE= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,    
			UPDATE_EMP= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
			UPDATE_IP=<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
		WHERE 
			PROM_ID =<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.prom_id#"> 
	</cfquery>
	<cfquery name="ADD_PROM_HISTORY" datasource="#DSN3#">
		INSERT INTO
			PROMOTIONS_HISTORY
		(
			PROM_ID,
			<cfif len(prom_no)>PROM_NO,</cfif>
			CAMP_ID,
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
			<cfif len(LIMIT_CURRENCY)>LIMIT_CURRENCY,</cfif>
			<cfif isdefined("GIFT_HEAD") and len(GIFT_HEAD)>GIFT_HEAD,</cfif>
			<cfif len(PROM_POINT)>PROM_POINT,</cfif>
			<cfif len(TOTAL_AMOUNT)>TOTAL_AMOUNT,</cfif>
			<cfif len(COUPON_ID)>COUPON_ID,</cfif>
			<cfif isdefined("DISCOUNT_1") and len(DISCOUNT_1)>DISCOUNT,</cfif>
			<cfif isdefined("AMOUNT_DISCOUNT_1") and len(AMOUNT_DISCOUNT_1)>AMOUNT_DISCOUNT,</cfif>
			<cfif isdefined("AMOUNT_DISCOUNT_MONEY_1") and len(AMOUNT_DISCOUNT_MONEY_1)>AMOUNT_DISCOUNT_MONEY_1,</cfif> 
			<!--- BK 180 gune silinsin 20130724 <cfif len(DISCOUNT_TYPE_ID_2)>DISCOUNT_TYPE_ID_2,</cfif> --->
			<cfif len(AMOUNT_DISCOUNT_2)>AMOUNT_DISCOUNT_2,</cfif>
			<cfif len(AMOUNT_DISCOUNT_MONEY_2)>AMOUNT_DISCOUNT_MONEY_2,</cfif>
			<cfif isdefined("PRIM_PERCENT") and len(PRIM_PERCENT)>PRIM_PERCENT,</cfif>
			<cfif isdefined("AMOUNT_1") and len(AMOUNT_1)>AMOUNT_1,</cfif>
			<cfif isdefined("AMOUNT_2") and len(AMOUNT_2)>AMOUNT_2,</cfif>
			<cfif isdefined("AMOUNT_3") and len(AMOUNT_3)>AMOUNT_3,</cfif>
			<cfif isdefined("AMOUNT_4") and len(AMOUNT_4)>AMOUNT_4,</cfif>
			<cfif isdefined("AMOUNT_45") and len(AMOUNT_5)>AMOUNT_5,</cfif>
			<cfif len(AMOUNT_1_MONEY)>AMOUNT_1_MONEY,</cfif>
			<cfif isdefined("AMOUNT_2_MONEY") and len(AMOUNT_2_MONEY)>AMOUNT_2_MONEY,</cfif>
			<cfif isdefined("AMOUNT_3_MONEY") and len(AMOUNT_3_MONEY)>AMOUNT_3_MONEY,</cfif>
			<cfif isdefined("AMOUNT_4_MONEY") and len(AMOUNT_4_MONEY)>AMOUNT_4_MONEY,</cfif>
			<cfif isdefined("AMOUNT_5_MONEY") and len(AMOUNT_5_MONEY)>AMOUNT_5_MONEY,</cfif>
			<cfif len(TOTAL_PROMOTION_COST)>TOTAL_PROMOTION_COST,</cfif>
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
			DUE_DAY,
			TARGET_DUE_DATE,
			RECORD_DATE,
			RECORD_IP
		)
		VALUES
		(
			#ATTRIBUTES.PROM_ID#,
			<cfif len(prom_no)>'#prom_no#',</cfif>
			<cfif len(CAMP_ID)>#CAMP_ID#<cfelse>NULL</cfif>,
			'#PROM_HEAD#',
			<cfif len(attributes.stock_id) and len(attributes.product_name)>#attributes.STOCK_ID#<cfelse>NULL</cfif>,
			<cfif len(attributes.product_catid) and len(attributes.product_cat)>#attributes.product_catid#<cfelse>NULL</cfif>,
			<cfif isdefined("attributes.get_company_id") and isdefined("attributes.get_company") and len(attributes.get_company_id) and len(attributes.get_company)>#attributes.get_company_id#<cfelse>NULL</cfif>, 
			<cfif len(attributes.supplier_id) and len(attributes.supplier_name)>#attributes.supplier_id#<cfelse>NULL</cfif>,
			<cfif len(FREE_STOCK_ID)>#FREE_STOCK_ID#<cfelse>NULL</cfif>,
			<cfif len(FREE_STOCK_AMOUNT)>#filterNum(FREE_STOCK_AMOUNT,2)#<cfelse>NULL</cfif>,
			<cfif len(FREE_STOCK_PRICE)>#filterNum(FREE_STOCK_PRICE,2)#<cfelse>NULL</cfif>,
			<cfif isdefined("GIFT_AMOUNT") and len(GIFT_AMOUNT)>#filterNum(GIFT_AMOUNT,2)#<cfelse>NULL</cfif>,
			<cfif isdefined("GIFT_PRICE") and len(GIFT_PRICE)>#filterNum(GIFT_PRICE,2)#<cfelse>NULL</cfif>,
			<cfif isdefined("attributes.prom_status")>1<cfelse>0</cfif>,
			<cfif isdefined('attributes.process_stage')>#attributes.process_stage#<cfelse>NULL</cfif>,
			<cfif len(LIMIT_VALUE)>#LIMIT_TYPE#,<cfelse>NULL,</cfif>
			<cfif len(LIMIT_VALUE)>#filterNum(LIMIT_VALUE,2)#,<cfelse>NULL,</cfif>
			<cfif len(LIMIT_CURRENCY)>'#LIMIT_CURRENCY#',</cfif>
			<cfif isdefined("GIFT_HEAD") and len(GIFT_HEAD)>'#GIFT_HEAD#',</cfif>
			<cfif len(PROM_POINT)>#PROM_POINT#,</cfif>
			<cfif len(TOTAL_AMOUNT)>#filterNum(TOTAL_AMOUNT,2)#,</cfif>
			<cfif len(COUPON_ID)>#COUPON_ID#,</cfif>
			<cfif isdefined("DISCOUNT_1") and len(DISCOUNT_1)>#filterNum(DISCOUNT_1,2)#,</cfif>
			<cfif isdefined("AMOUNT_DISCOUNT_1") and len(AMOUNT_DISCOUNT_1)>#filterNum(AMOUNT_DISCOUNT_1,2)#,</cfif>
			<cfif isdefined("AMOUNT_DISCOUNT_MONEY_1") and len(AMOUNT_DISCOUNT_MONEY_1)>'#AMOUNT_DISCOUNT_MONEY_1#',</cfif>
			<!--- <cfif len(DISCOUNT_TYPE_ID_2)>#DISCOUNT_TYPE_ID_2#,</cfif> --->
			<cfif len(AMOUNT_DISCOUNT_2)>#filterNum(AMOUNT_DISCOUNT_2,2)#,</cfif>
			<cfif len(AMOUNT_DISCOUNT_MONEY_2)>'#AMOUNT_DISCOUNT_MONEY_2#',</cfif>
			<cfif isdefined("PRIM_PERCENT") and len(PRIM_PERCENT)>#PRIM_PERCENT#,</cfif>
			<cfif isdefined("AMOUNT_1") and len(AMOUNT_1)>#filterNum(AMOUNT_1,2)#,</cfif>
			<cfif isdefined("AMOUNT_2") and len(AMOUNT_2)>#filterNum(AMOUNT_2,2)#,</cfif>
			<cfif isdefined("AMOUNT_3") and len(AMOUNT_3)>#filterNum(AMOUNT_3,2)#,</cfif>
			<cfif isdefined("AMOUNT_4") and len(AMOUNT_4)>#filterNum(AMOUNT_4,2)#,</cfif>
			<cfif isdefined("AMOUNT_5") and len(AMOUNT_5)>#filterNum(AMOUNT_5,2)#,</cfif>
			<cfif len(AMOUNT_1_MONEY)>'#AMOUNT_1_MONEY#',</cfif>
			<cfif isdefined("GIFT_HEAD") and len(AMOUNT_2_MONEY)>'#AMOUNT_2_MONEY#',</cfif>
			<cfif isdefined("AMOUNT_3_MONEY") and len(AMOUNT_3_MONEY)>'#AMOUNT_3_MONEY#',</cfif>
			<cfif isdefined("AMOUNT_4_MONEY") and len(AMOUNT_4_MONEY)>'#AMOUNT_4_MONEY#',</cfif>
			<cfif isdefined("AMOUNT_5_MONEY") and len(AMOUNT_5_MONEY)>'#AMOUNT_5_MONEY#',</cfif>
			<cfif len(TOTAL_PROMOTION_COST)>#filterNum(TOTAL_PROMOTION_COST,2)#,</cfif>
			<cfif isdefined("TOTAL_PROMOTION_COST_MONEY") and len(TOTAL_PROMOTION_COST_MONEY)>'#TOTAL_PROMOTION_COST_MONEY#',</cfif>
			<cfif isDefined("FORM.ICON_ID") and len(FORM.ICON_ID)>#FORM.ICON_ID#,<cfelse>NULL,</cfif>
			<cfif len(attributes.startdate)>#attributes.startdate#,</cfif>
			<cfif len(attributes.finishdate)>#attributes.finishdate#,</cfif>
			<cfif len(prom_detail)>'#PROM_DETAIL#'<cfelse>NULL</cfif>,
			#PRICE_CATID#,
			<cfif isdefined("session.ep.userid")>#SESSION.EP.USERID#,</cfif>
			0,
			<cfif isDefined("form.brand_id") and len(form.brand_id)>#form.brand_id#<cfelse>NULL</cfif>,
			#attributes.prom_type#,
			<!--- <cfif isdefined("attributes.is_viewed")>1<cfelse>0</cfif>, --->
			<cfif isdefined('attributes.due_day') and len(attributes.due_day)>#attributes.DUE_DAY#<cfelse>NULL</cfif>,
			<cfif isdefined('attributes.target_due_date') and len(attributes.target_due_date)>#attributes.TARGET_DUE_DATE#<cfelse>NULL</cfif>,
			#now()#,
			'#CGI.REMOTE_ADDR#'
		)
	</cfquery>
	<cf_workcube_process 
		is_upd='1' 
		data_source='#dsn3#' 
		old_process_line='#attributes.old_process_line#'
		process_stage='#attributes.process_stage#' 
		record_member='#session.ep.userid#'
		record_date='#now()#' 
		action_table='PROMOTIONS'
		action_column='PROM_ID'
		action_id='#attributes.prom_id#' 
		action_page='#request.self#?fuseaction=product.list_promotions&event=upd&prom_id=#attributes.prom_id#' 
		warning_description='Promosyon : #attributes.prom_id#'>
	</cftransaction>
</cflock>
<cfset attributes.actionId = attributes.prom_id >
<script type="text/javascript">
	window.location.href="<cfoutput>#request.self#?fuseaction=product.list_promotions&event=upd&prom_id=#attributes.prom_id#</cfoutput>"
</script>
