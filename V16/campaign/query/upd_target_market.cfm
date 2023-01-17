<CF_DATE TARIH="SHOPPING_STARTDATE">
<CF_DATE TARIH="SHOPPING_FINISHDATE">
<CF_DATE TARIH="TMARKET_MEMBERSHIP_STARTDATE">
<CF_DATE TARIH="TMARKET_MEMBERSHIP_FINISHDATE">
<!---
kurumsal gelenler : 0,1,3,4
bireysel gelenler : 0,2,3,5
maillist gelenler : 3,4,5,6
--->
<cfset standart_method = ''>
<cfset card_method = ''>
<cfif isdefined("attributes.order_paymethod") and listlen(attributes.order_paymethod)>
	<cfset uzunluk=listlen(attributes.order_paymethod)>
	<cfloop from="1" to="#uzunluk#" index="catyp">
		<cfset eleman = listgetat(attributes.order_paymethod,catyp,',')>
		<cfoutput>#eleman#</cfoutput><br/>
		<cfif listlen(eleman) and listfirst(eleman,'-') eq 1>
			<cfset standart_method = listappend(standart_method,listlast(eleman,'-'))>
		<cfelseif listlen(eleman) and listfirst(eleman,'-') eq 2>
			<cfset card_method = listappend(card_method,listlast(eleman,'-'))>
		</cfif>
	</cfloop>
</cfif>
<cfif isdefined("attributes.birth_date")>
	<cf_date tarih="attributes.birth_date">
</cfif>
<cfif isdefined("attributes.order_start_date")>
	<cf_date tarih="attributes.order_start_date">
</cfif>
<cfif isdefined("attributes.order_finish_date")>
	<cf_date tarih="attributes.order_finish_date">
</cfif>
<cfset search_type=0>
<cfif isdefined("attributes.is_company_search") and isdefined("attributes.is_consumer_search") and not isdefined("attributes.is_maillist")>
	<cfset search_type=0>
<cfelseif isdefined("attributes.is_company_search") and not isdefined("attributes.is_consumer_search") and not isdefined("attributes.is_maillist")>
	<cfset search_type=1>
<cfelseif isdefined("attributes.is_consumer_search") and not isdefined("attributes.is_company_search") and not isdefined("attributes.is_maillist")>
	<cfset search_type=2>
<cfelseif isdefined("attributes.is_consumer_search") and isdefined("attributes.is_company_search") and isdefined("attributes.is_maillist")>
	<cfset search_type=3>
<cfelseif isdefined("attributes.is_company_search") and not isdefined("attributes.is_consumer_search") and isdefined("attributes.is_maillist")>
	<cfset search_type=4>
<cfelseif not isdefined("attributes.is_company_search") and isdefined("attributes.is_consumer_search") and isdefined("attributes.is_maillist")>
	<cfset search_type=5>
<cfelseif not isdefined("attributes.is_company_search") and not isdefined("attributes.is_consumer_search") and isdefined("attributes.is_maillist")>
	<cfset search_type=6>
</cfif>
<cflock name="#CREATEUUID()#" timeout="20">
	<cftransaction>
		<cfif isdefined("attributes.record_num1")>
			<cfset product_id_list = ''>
			<cfloop from="1" to="#attributes.record_num1#" index="kk">
				 <cfif isdefined("attributes.row_kontrol1#kk#") and evaluate("attributes.row_kontrol1#kk#")>
					<cfif len(evaluate("attributes.product_name#kk#")) and not listfind(product_id_list,evaluate("attributes.product_id#kk#"))>
						<cfset product_id_list=listappend(product_id_list,evaluate("attributes.product_id#kk#"))>
					</cfif>
				 </cfif>
			</cfloop>
		</cfif>
		<cfif isdefined("attributes.record_num2")>
			<cfset productcat_id_list = ''>
			<cfloop from="1" to="#attributes.record_num2#" index="kk">
				 <cfif isdefined("attributes.row_kontrol2#kk#") and evaluate("attributes.row_kontrol2#kk#")>
					<cfif len(evaluate("attributes.productcat_name#kk#")) and not listfind(productcat_id_list,evaluate("attributes.productcat_id#kk#"))>
						<cfset productcat_id_list=listappend(productcat_id_list,evaluate("attributes.productcat_id#kk#"))>
					</cfif>
				 </cfif>
			</cfloop>
		</cfif>
		<cfif isdefined("attributes.record_num3")>
			<cfset promotion_id_list = ''>
			<cfloop from="1" to="#attributes.record_num3#" index="kk">
				 <cfif isdefined("attributes.row_kontrol3#kk#") and evaluate("attributes.row_kontrol3#kk#")>
					<cfif len(evaluate("attributes.promotion_name#kk#")) and not listfind(promotion_id_list,evaluate("attributes.promotion_id#kk#"))>
						<cfset promotion_id_list=listappend(promotion_id_list,evaluate("attributes.promotion_id#kk#"))>
					</cfif>
				 </cfif>
			</cfloop>
		</cfif>
		<cfif isdefined("attributes.record_num4")>
			<cfset training_id_list = ''>
			<cfloop from="1" to="#attributes.record_num4#" index="kk">
				 <cfif isdefined("attributes.row_kontrol4#kk#") and evaluate("attributes.row_kontrol4#kk#")>
					<cfif len(evaluate("attributes.training_name#kk#")) and not listfind(promotion_id_list,evaluate("attributes.training_id#kk#"))>
						<cfset training_id_list=listappend(training_id_list,evaluate("attributes.training_id#kk#"))>
					</cfif>
				 </cfif>
			</cfloop>
		</cfif>
		 <cfquery name="ADD_TMARKET" datasource="#dsn3#">
			UPDATE
				TARGET_MARKETS
			SET
				TARGET_MARKET_TYPE=#search_type#,
				<cfif isdefined("attributes.connect_member") and  len(attributes.connect_member)>COMP_CONMEMBER=#attributes.connect_member#<cfelse>COMP_CONMEMBER=NULL</cfif>,
				<cfif isdefined("attributes.only_firm_members") and len(attributes.only_firm_members)>ONLY_FIRMMEMBER=#attributes.only_firm_members#<cfelse>ONLY_FIRMMEMBER=NULL</cfif>,
				<cfif isdefined("TMARKET_NO") and len(TMARKET_NO)>TMARKET_NO = '#TMARKET_NO#',<cfelse>TMARKET_NO = NULL,</cfif>
				<cfif isdefined("TMARKET_NAME") and len(TMARKET_NAME)>TMARKET_NAME = '#TMARKET_NAME#',<cfelse>TMARKET_NAME = NULL,</cfif>
				<cfif isDefined("TMARKET_SEX") and len(TMARKET_SEX)>TMARKET_SEX = '#TMARKET_SEX#',<cfelse>TMARKET_SEX = NULL,</cfif>
				<cfif isDefined("TMARKET_MARITAL_STATUS") and len(TMARKET_MARITAL_STATUS)>TMARKET_MARITAL_STATUS = '#TMARKET_MARITAL_STATUS#',<cfelse>TMARKET_MARITAL_STATUS = NULL,</cfif>
				<cfif isDefined("AGE_LOWER") and  len(AGE_LOWER)>AGE_LOWER = #AGE_LOWER#,<cfelse>AGE_LOWER = NULL,</cfif>
				<cfif isdefined("AGE_UPPER") and len(AGE_UPPER)>AGE_UPPER = #AGE_UPPER#,<cfelse>AGE_UPPER = NULL,</cfif>
				<cfif isdefined("CHILD_LOWER") and  len(CHILD_LOWER)>CHILD_LOWER = #CHILD_LOWER#,<cfelse>CHILD_LOWER = NULL,</cfif>
				<cfif isdefined("CHILD_UPPER") and  len(CHILD_UPPER)>CHILD_UPPER = #CHILD_UPPER#,<cfelse>CHILD_UPPER = NULL,</cfif>
				<cfif isDefined("SHOPPING_STARTDATE") and len(SHOPPING_STARTDATE)>SHOPPING_STARTDATE = #SHOPPING_STARTDATE#,<cfelse>SHOPPING_STARTDATE = NULL,</cfif>
				<cfif isDefined("SHOPPING_FINISHDATE") and len(SHOPPING_FINISHDATE)>SHOPPING_FINISHDATE = #SHOPPING_FINISHDATE#,<cfelse>SHOPPING_FINISHDATE = NULL,</cfif>
				<cfif isDefined("TMARKET_MEMBERSHIP_STARTDATE") and len(TMARKET_MEMBERSHIP_STARTDATE)>TMARKET_MEMBERSHIP_STARTDATE = #TMARKET_MEMBERSHIP_STARTDATE#,<cfelse>TMARKET_MEMBERSHIP_STARTDATE = NULL,</cfif>
				<cfif isDefined("TMARKET_MEMBERSHIP_FINISHDATE") and len(TMARKET_MEMBERSHIP_FINISHDATE)>TMARKET_MEMBERSHIP_FINISHDATE = #TMARKET_MEMBERSHIP_FINISHDATE#,<cfelse>TMARKET_MEMBERSHIP_FINISHDATE = NULL,</cfif>
				<cfif isDefined("CATEGORY") and CATEGORY eq 1>
					PRODUCT_CATID = #PRODUCT_CATID#,
					STOCK_ID = NULL,
				<cfelseif isDefined("CATEGORY") and CATEGORY eq 0>
					PRODUCT_CATID = NULL,
					STOCK_ID = #STOCK_ID#,
				</cfif>
				<cfif isDefined("MONEYORAMOUNT") and MONEYORAMOUNT eq 0>
					<cfif isDefined("LIMIT_LOWER") and len(LIMIT_LOWER)>
						SHOP_MONEY_LOWER = #LIMIT_LOWER#,
					<cfelse>
						SHOP_MONEY_LOWER = NULL,
					</cfif>
					<cfif isDefined("LIMIT_LOWER") and len(LIMIT_UPPER)>
						SHOP_MONEY_UPPER = #LIMIT_UPPER#,
					<cfelse>
						SHOP_MONEY_UPPER = NULL,
					</cfif>
					SHOP_AMOUNT_LOWER = NULL,
					SHOP_AMOUNT_UPPER = NULL,
				<cfelse>
					<cfif isDefined("LIMIT_LOWER") and len(LIMIT_LOWER)>
						SHOP_AMOUNT_LOWER = #LIMIT_LOWER#,
					<cfelse>
						SHOP_AMOUNT_LOWER = NULL,
					</cfif>
					<cfif isDefined("LIMIT_LOWER") and len(LIMIT_UPPER)>
						SHOP_AMOUNT_UPPER = #LIMIT_UPPER#,
					<cfelse>
						SHOP_AMOUNT_UPPER = NULL,
					</cfif>
						SHOP_MONEY_LOWER = NULL,
						SHOP_MONEY_UPPER = NULL,
				</cfif>
				<cfif isDefined("CONSCAT_IDS")>CONSCAT_IDS = '#CONSCAT_IDS#',<cfelse>CONSCAT_IDS = NULL,</cfif>
				<cfif isDefined("SECTOR_CATS")>SECTOR_CATS = '#SECTOR_CATS#',<cfelse>SECTOR_CATS = NULL,</cfif>
				<cfif isDefined("COMPANY_SIZE_CATS")>COMPANY_SIZE_CATS = '#COMPANY_SIZE_CATS#',<cfelse>COMPANY_SIZE_CATS = NULL,</cfif>
				<cfif isDefined('COMPANYCATS')>COMPANYCATS = '#COMPANYCATS#',<cfelse>COMPANYCATS = NULL,</cfif>
				<cfif isDefined('CONS_IS_POTANTIAL')>CONS_IS_POTANTIAL = '#CONS_IS_POTANTIAL#',<cfelse>CONS_IS_POTANTIAL = NULL,</cfif>
				<cfif isDefined('IS_POTANTIAL')>IS_POTANTIAL = '#IS_POTANTIAL#',<cfelse>IS_POTANTIAL = NULL,</cfif>
				<cfif isDefined('IS_BUYER')>IS_BUYER = 1,<cfelse>IS_BUYER = 0,</cfif>
				<cfif isDefined('IS_SELLER')>IS_SELLER = 1,<cfelse>IS_SELLER = 0,</cfif>
				<cfif isDefined('PARTNER_STATUS')>PARTNER_STATUS = '#PARTNER_STATUS#',<cfelse>PARTNER_STATUS = NULL,</cfif>
				<cfif isDefined("TARGET_ALTS")>TARGET_ALTS = ',#TARGET_ALTS#,',<cfelse>TARGET_ALTS = NULL,</cfif>
				<cfif isDefined('CONS_SECTOR_CATS')>CONS_SECTOR_CATS = '#CONS_SECTOR_CATS#',<cfelse>CONS_SECTOR_CATS = NULL,</cfif>
				<cfif isDefined('CONS_SIZE_CATS')>CONS_SIZE_CATS = '#CONS_SIZE_CATS#',<cfelse>CONS_SIZE_CATS = NULL,</cfif>
				<cfif isDefined('CONS_STATUS')>CONS_STATUS = '#CONS_STATUS#',<cfelse>CONS_STATUS = NULL,</cfif>
				<cfif isDefined("PARTNER_MISSION")>PARTNER_MISSION = '#PARTNER_MISSION#',<cfelse>PARTNER_MISSION = NULL,</cfif>
				<cfif isDefined("PARTNER_DEPARTMENT")>PARTNER_DEPARTMENT = '#PARTNER_DEPARTMENT#',<cfelse>PARTNER_DEPARTMENT = NULL,</cfif>	
				<cfif isDefined("PARTNER_TMARKET_SEX")>PARTNER_TMARKET_SEX = '#PARTNER_TMARKET_SEX#',<cfelse>PARTNER_TMARKET_SEX = NULL,</cfif>
				<cfif isdefined("attributes.cons_city_id") and len(attributes.cons_city_id)>CITY_ID='#attributes.cons_city_id#',<cfelse>CITY_ID=NULL,</cfif>
				<cfif isdefined("attributes.company_city_id") and len(attributes.company_city_id)>COMPANY_CITY_ID='#attributes.company_city_id#',<cfelse>COMPANY_CITY_ID=NULL,</cfif>
				<cfif isdefined("attributes.company_county_id") and len(attributes.company_county_id)>COMPANY_COUNTY_ID='#attributes.company_county_id#',<cfelse>COMPANY_COUNTY_ID=NULL,</cfif>
				<cfif isdefined("attributes.company_country_id") and len(attributes.company_country_id)>COMPANY_COUNTRY_ID='#attributes.company_country_id#',<cfelse>COMPANY_COUNTRY_ID=NULL,</cfif>
				<cfif isdefined("attributes.cons_county_id") and len(attributes.cons_county_id)>COUNTY_ID='#attributes.cons_county_id#',<cfelse>COUNTY_ID=NULL,</cfif>
				<cfif isdefined("attributes.cons_value") and len(attributes.cons_value)>CONSUMER_VALUE='#attributes.cons_value#',<cfelse>CONSUMER_VALUE=NULL,</cfif>
				<cfif isdefined("attributes.company_value") and len(attributes.company_value)>COMPANY_VALUE='#attributes.company_value#',<cfelse>COMPANY_VALUE=NULL,</cfif>
				<cfif isdefined("attributes.cons_ims_code") and len(attributes.cons_ims_code)>CONSUMER_IMS_CODE='#attributes.cons_ims_code#',<cfelse>CONSUMER_IMS_CODE=NULL,</cfif>
				<cfif isdefined("attributes.company_ims_code") and len(attributes.company_ims_code)>COMPANY_IMS_CODE='#attributes.company_ims_code#',<cfelse>COMPANY_IMS_CODE=NULL,</cfif>
				<cfif isdefined("attributes.cons_hobby") and len(attributes.cons_hobby)>CONSUMER_HOBBY='#attributes.cons_hobby#',<cfelse>CONSUMER_HOBBY=NULL,</cfif>
				<cfif isdefined("attributes.company_hobby") and len(attributes.company_hobby)>COMPANY_PARTNER_HOBBY='#attributes.company_hobby#',<cfelse>COMPANY_PARTNER_HOBBY=NULL,</cfif>
				<cfif isdefined("attributes.cons_resource") and len(attributes.cons_resource)>CONSUMER_RESOURCE='#attributes.cons_resource#',<cfelse>CONSUMER_RESOURCE=NULL,</cfif>
				<cfif isdefined("attributes.company_resource") and len(attributes.company_resource)>COMPANY_RESOURCE='#attributes.company_resource#',<cfelse>COMPANY_RESOURCE=NULL,</cfif>
				<cfif isdefined("attributes.cons_ozel_kod1") and len(attributes.cons_ozel_kod1)>CONSUMER_OZEL_KOD1='#attributes.cons_ozel_kod1#',<cfelse>CONSUMER_OZEL_KOD1=NULL,</cfif>
				<cfif isdefined("attributes.company_ozel_kod1") and len(attributes.company_ozel_kod1)>COMPANY_OZEL_KOD1='#attributes.company_ozel_kod1#',<cfelse>COMPANY_OZEL_KOD1=NULL,</cfif>
				<cfif isdefined("attributes.company_ozel_kod2") and len(attributes.company_ozel_kod2)>COMPANY_OZEL_KOD2='#attributes.company_ozel_kod2#',<cfelse>COMPANY_OZEL_KOD2=NULL,</cfif>
				<cfif isdefined("attributes.company_ozel_kod3") and len(attributes.company_ozel_kod3)>COMPANY_OZEL_KOD3='#attributes.company_ozel_kod3#',<cfelse>COMPANY_OZEL_KOD3=NULL,</cfif>
				<cfif isdefined("attributes.cons_sales_zone") and len(attributes.cons_sales_zone)>CONSUMER_SALES_ZONE='#attributes.cons_sales_zone#',<cfelse>CONSUMER_SALES_ZONE=NULL,</cfif>
				<cfif isdefined("attributes.company_sales_zone") and len(attributes.company_sales_zone)>COMPANY_SALES_ZONE='#attributes.company_sales_zone#',<cfelse>COMPANY_SALES_ZONE=NULL,</cfif>
				<cfif isdefined("attributes.cons_education") and len(attributes.cons_education)>CONS_EDUCATION='#attributes.cons_education#',<cfelse>CONS_EDUCATION=NULL,</cfif>
				<cfif isdefined("attributes.cons_vocation_type") and len(attributes.cons_vocation_type)>CONS_VOCATION_TYPE='#attributes.cons_vocation_type#',<cfelse>CONS_VOCATION_TYPE=NULL,</cfif>
				<cfif isdefined("attributes.cons_society") and len(attributes.cons_society)>CONS_SOCIETY='#attributes.cons_society#',<cfelse>CONS_SOCIETY=NULL,</cfif>
				<cfif isdefined("attributes.cons_income_level") and len(attributes.cons_income_level)>CONS_INCOME_LEVEL='#attributes.cons_income_level#',<cfelse>CONS_INCOME_LEVEL=NULL,</cfif>
				<cfif isdefined("attributes.rel_company_name") and len(attributes.rel_company_id) and len(attributes.rel_company_name)>COMPANY_REL_ID=#attributes.rel_company_id#,<cfelse>COMPANY_REL_ID=NULL,</cfif>
				<cfif isdefined("attributes.rel_type_id") and len(attributes.rel_type_id)>COMPANY_REL_TYPE_ID='#attributes.rel_type_id#',<cfelse>COMPANY_REL_TYPE_ID=NULL,</cfif>
				<cfif isdefined('attributes.req_comp') and len(attributes.req_comp)>REQ_COMP = '#attributes.req_comp#'<cfelse>REQ_COMP = NULL</cfif>,
				<cfif isdefined('attributes.req_cons') and len(attributes.req_cons)>REQ_CONS = '#attributes.req_cons#'<cfelse>REQ_CONS = NULL</cfif>,
				<cfif isdefined('attributes.COMP_AGENT_POS_CODE') and len(attributes.COMP_AGENT_POS_CODE)>COMP_AGENT_POS_CODE ='#attributes.COMP_AGENT_POS_CODE#'<cfelse>COMP_AGENT_POS_CODE = NULL</cfif>,
				<cfif isdefined('attributes.CONS_AGENT_POS_CODE') and len(attributes.CONS_AGENT_POS_CODE)>CONS_AGENT_POS_CODE = '#attributes.CONS_AGENT_POS_CODE#'<cfelse>CONS_AGENT_POS_CODE = NULL</cfif>,
				<cfif isdefined('attributes.COMP_REL_BRANCH') and len(attributes.COMP_REL_BRANCH)>COMP_REL_BRANCH='#attributes.COMP_REL_BRANCH#'<cfelse>COMP_REL_BRANCH= NULL</cfif>,
				<cfif isdefined('attributes.CONS_REL_BRANCH') and len(attributes.CONS_REL_BRANCH)>CONS_REL_BRANCH='#attributes.CONS_REL_BRANCH#'<cfelse>CONS_REL_BRANCH= NULL</cfif>,
				<cfif isdefined('attributes.COMP_REL_COMP') and len(attributes.COMP_REL_COMP)>COMP_REL_COMP='#attributes.COMP_REL_COMP#'<cfelse>COMP_REL_COMP= NULL</cfif>,
				<cfif isdefined('attributes.CONS_REL_COMP') and len(attributes.CONS_REL_COMP)>CONS_REL_COMP='#attributes.CONS_REL_COMP#'<cfelse>CONS_REL_COMP= NULL</cfif>,
				<cfif isdefined('attributes.product_category') and len(attributes.product_category)>COMP_PRODUCTCAT_LIST='#attributes.product_category#'<cfelse>COMP_PRODUCTCAT_LIST=NULL</cfif>,
				<cfif isdefined('attributes.firm_type') and len(attributes.firm_type)>COMP_FIRM_LIST='#attributes.firm_type#'<cfelse>COMP_FIRM_LIST=NULL</cfif>,
				IS_MAILLIST = <cfif isdefined("attributes.is_maillist")>1,<cfelse>0,</cfif>
				ORDER_START_DATE = <cfif isdefined('attributes.order_start_date') and len(attributes.order_start_date)>#attributes.order_start_date#<cfelse>NULL</cfif>,
				ORDER_FINISH_DATE = <cfif isdefined('attributes.order_finish_date') and len(attributes.order_finish_date)>#attributes.order_finish_date#<cfelse>NULL</cfif>,
				LAST_DAY_COUNT = <cfif isdefined('attributes.order_date') and len(attributes.order_date)>#attributes.order_date#<cfelse>NULL</cfif>,
				LAST_DAY_TYPE = <cfif isdefined('attributes.order_date_opt') and len(attributes.order_date_opt)>#attributes.order_date_opt#<cfelse>NULL</cfif>,
				IS_GIVEN_ORDER = <cfif isdefined("attributes.is_order")>1<cfelseif isdefined("attributes.is_not_order")>2<cfelse>1</cfif>,
				ORDER_PRODUCT_ID = <cfif isdefined("product_id_list") and len(product_id_list)>'#product_id_list#'<cfelse>NULL</cfif>,
				ORDER_PRODUCT_STATUS = <cfif isdefined("attributes.is_product_and")>1<cfelseif isdefined("attributes.is_product_or")>2<cfelse>1</cfif>,
				ORDER_PRODUCTCAT_ID = <cfif isdefined("productcat_id_list") and len(productcat_id_list)>'#productcat_id_list#'<cfelse>NULL</cfif>,
				ORDER_PRODUCTCAT_STATUS = <cfif isdefined("attributes.is_productcat_and")>1<cfelseif isdefined("attributes.is_productcat_or")>2<cfelse>1</cfif>,
				ORDER_AMOUNT = <cfif isdefined("attributes.order_amount") and len(attributes.order_amount)>#attributes.order_amount#<cfelse>NULL</cfif>,
				ORDER_AMOUNT_TYPE = <cfif isdefined("attributes.sel_order_amount") and len(attributes.sel_order_amount)>#attributes.sel_order_amount#<cfelse>NULL</cfif>,
				PRODUCT_COUNT = <cfif isdefined("attributes.product_amount") and len(attributes.product_amount)>#attributes.product_amount#<cfelse>NULL</cfif>,
				ORDER_COUNT = <cfif isdefined("attributes.order_count") and len(attributes.order_count)>#attributes.order_count#<cfelse>NULL</cfif>,
				PRODUCT_COUNT_TYPE = <cfif isdefined("attributes.sel_product_amount") and len(attributes.sel_product_amount)>#attributes.sel_product_amount#<cfelse>NULL</cfif>,
				ORDER_COUNT_TYPE = <cfif isdefined("attributes.sel_order_count") and len(attributes.sel_order_count)>#attributes.sel_order_count#<cfelse>NULL</cfif>,
				ORDER_COMMETHOD_ID = <cfif isdefined("attributes.order_commethod") and len(attributes.order_commethod)>'#attributes.order_commethod#'<cfelse>NULL</cfif>,
				ORDER_PAYMETHOD_ID = <cfif isdefined("standart_method") and len(standart_method)>'#standart_method#'<cfelse>NULL</cfif>,
				ORDER_CARDPAYMETHOD_ID = <cfif isdefined("card_method") and len(card_method)>'#card_method#'<cfelse>NULL</cfif>,
				PROMOTION_ID = <cfif isdefined("promotion_id_list") and len(promotion_id_list)>'#promotion_id_list#'<cfelse>NULL</cfif>,
				PROMOTION_STATUS = <cfif isdefined("attributes.is_prom_and")>1<cfelseif isdefined("attributes.is_prom_or")>2<cfelse>1</cfif>,
				PROMOTION_COUNT = <cfif isdefined("attributes.prom_count") and len(attributes.prom_count)>#attributes.prom_count#<cfelse>NULL</cfif>,
				CONSUMER_STAGE = <cfif isdefined("attributes.member_stage") and len(attributes.member_stage)>'#attributes.member_stage#'<cfelse>NULL</cfif>,
                PARTNER_STAGE=<cfif isdefined("attributes.partmember_stage") and len(attributes.partmember_stage)>#attributes.partmember_stage#<cfelse>NULL</cfif>,
				CONSUMER_BIRTHDATE = <cfif isdefined("attributes.birth_date") and len(attributes.birth_date)>#attributes.birth_date#<cfelse>NULL</cfif>,
				PROMOTION_OFFER_STATUS = <cfif isdefined("attributes.is_prom_select") and len(attributes.is_prom_select)>#attributes.is_prom_select#<cfelse>NULL</cfif>,
				IS_CONS_CEPTEL = <cfif isdefined("attributes.is_cep_tel")>1<cfelse>0</cfif>,
				IS_CONS_EMAIL = <cfif isdefined("attributes.is_email")>1<cfelse>0</cfif>,
				IS_CONS_TAX = <cfif isdefined("attributes.is_tax")>1<cfelse>0</cfif>,
				IS_CONS_DEBT = <cfif isdefined("attributes.is_debt")>1<cfelse>0</cfif>,
				IS_CONS_BLOKE = <cfif isdefined("attributes.is_bloke")>1<cfelse>0</cfif>,
				IS_CONS_OPEN_ORDER = <cfif isdefined("attributes.is_open_order")>1<cfelse>0</cfif>,
				IS_CONS_BLACK_LIST = <cfif isdefined("attributes.is_black_list")>1<cfelse>0</cfif>,
				CONS_PASSWORD_DAY = <cfif isdefined("attributes.password_day") and len(attributes.password_day)>#attributes.password_day#<cfelse>NULL</cfif>,
				TRAINING_ID = <cfif isdefined("training_id_list") and len(training_id_list)>'#training_id_list#'<cfelse>NULL</cfif>,
				TRAINING_STATUS = <cfif isdefined("attributes.is_train_and")>1<cfelseif isdefined("attributes.is_train_or")>2<cfelse>1</cfif>,
				<cfif isdefined("attributes.comp_want_email") and len(attributes.comp_want_email)>COMP_WANT_EMAIL = #attributes.comp_want_email#<cfelse>COMP_WANT_EMAIL = NULL</cfif>,
				<cfif isdefined("attributes.cons_want_email") and len(attributes.cons_want_email)>CONS_WANT_EMAIL = #attributes.cons_want_email#<cfelse>CONS_WANT_EMAIL = NULL</cfif>,
				UPDATE_DATE = #now()#,
				UPDATE_EMP = #SESSION.EP.USERID#,
				UPDATE_IP = '#CGI.REMOTE_ADDR#',
                PROCESS_STAGE=<cfif isdefined("attributes.process_stage") and len(attributes.process_stage)>#attributes.process_stage#<cfelse>NULL</cfif>,
                IS_ACTIVE=<cfif isdefined("attributes.is_active")>#attributes.is_active#<cfelse>0</cfif>
			WHERE
				TMARKET_ID = #TMARKET_ID#
		 </cfquery> 
	</cftransaction>
</cflock>
<cf_workcube_process 
    is_upd='1' 
    process_stage='#attributes.process_stage#' 
    record_member='#session.ep.userid#' 
    record_date='#now()#' 
    action_table="TARGET_MARKETS"
    action_column="TMARKET_ID"
    action_id='#attributes.tmarket_id#'
     warning_description='Hedef Kitle : #tmarket_id#'
    action_page='#request.self#?fuseaction=campaign.list_target_markets&event=upd&tmarket_id=#tmarket_id#' 
    old_process_line='#attributes.old_process_line#'>

<cfset attributes.actionId = tmarket_id >
<script type="text/javascript">
	window.location.href="<cfoutput>#request.self#?fuseaction=campaign.list_target_markets&event=upd&tmarket_id=#tmarket_id#</cfoutput>";
</script>
