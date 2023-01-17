<cf_date tarih="SHOPPING_STARTDATE">
<cf_date tarih="SHOPPING_FINISHDATE">
<cf_date tarih="TMARKET_MEMBERSHIP_STARTDATE">
<cf_date tarih="TMARKET_MEMBERSHIP_FINISHDATE"> 
<cf_papers paper_type="TARGET_MARKET">
<cfset system_paper_no=paper_code & '-' & paper_number>
<cfset system_paper_no_add=paper_number>

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
 		<cfquery name="ADD_TMARKET" datasource="#dsn3#" result="MAX_ID">
			INSERT INTO
				TARGET_MARKETS
				(
					TARGET_MARKET_TYPE,
					TMARKET_NO,
					<cfif isdefined("attributes.only_firm_members") and len(attributes.only_firm_members)>ONLY_FIRMMEMBER,</cfif>
					<cfif isdefined("attributes.connect_member") and len(attributes.connect_member)>COMP_CONMEMBER,</cfif>
					<cfif isdefined("attributes.only_firmmember") and len(attributes.only_firmmember)>ONLY_FIRMMEMBER,</cfif>
					<cfif len(attributes.TMARKET_NAME)>TMARKET_NAME,</cfif>
					<cfif isDefined("attributes.TMARKET_SEX")>TMARKET_SEX,</cfif>
					<cfif isDefined("attributes.TMARKET_MARITAL_STATUS")>TMARKET_MARITAL_STATUS,</cfif>
					<cfif isdefined("attributes.AGE_LOWER") and  len(attributes.AGE_LOWER)>AGE_LOWER,</cfif>
					<cfif isdefined("attributes.AGE_UPPER") and len(attributes.AGE_UPPER)>AGE_UPPER,</cfif>
					<cfif isdefined("attributes.CHILD_LOWER") and len(attributes.CHILD_LOWER)>CHILD_LOWER,</cfif>
					<cfif isdefined("attributes.CHILD_UPPER") and  len(attributes.CHILD_UPPER)>CHILD_UPPER,</cfif>
					<cfif isdefined("attributes.cons_city_id") and len(attributes.cons_city_id)>CITY_ID,</cfif>
					<cfif isdefined("attributes.cons_county_id") and len(attributes.cons_county_id)>COUNTY_ID,</cfif>
					<cfif isDefined("attributes.SHOPPING_STARTDATE") and len(attributes.SHOPPING_STARTDATE)>SHOPPING_STARTDATE,</cfif>
					<cfif isDefined("attributes.SHOPPING_FINISHDATE") and len(attributes.SHOPPING_FINISHDATE)>SHOPPING_FINISHDATE,</cfif>
					<cfif isDefined("attributes.TMARKET_MEMBERSHIP_STARTDATE") and len(attributes.TMARKET_MEMBERSHIP_STARTDATE)>TMARKET_MEMBERSHIP_STARTDATE,</cfif>
					<cfif isDefined("attributes.TMARKET_MEMBERSHIP_FINISHDATE") and len(attributes.TMARKET_MEMBERSHIP_FINISHDATE)>TMARKET_MEMBERSHIP_FINISHDATE,</cfif>
					<cfif isDefined("attributes.CATEGORY") and attributes.CATEGORY eq 1>PRODUCT_CATID,<cfelseif isDefined("attributes.CATEGORY") and attributes.CATEGORY eq 0>STOCK_ID,</cfif>
					<cfif isDefined("attributes.CONSCAT_IDS")>CONSCAT_IDS,</cfif>
					<cfif isDefined("attributes.SECTOR_CATS")>SECTOR_CATS,</cfif>
					<cfif isDefined("attributes.COMPANY_SIZE_CATS")>COMPANY_SIZE_CATS,</cfif>
					<cfif isDefined('attributes.COMPANYCATS')>COMPANYCATS,</cfif>
					<cfif isDefined('attributes.CONS_IS_POTANTIAL')>CONS_IS_POTANTIAL,</cfif>
					<cfif isDefined('attributes.IS_POTANTIAL')>IS_POTANTIAL,</cfif>
					IS_BUYER,
					IS_SELLER,
					<cfif isDefined('attributes.PARTNER_STATUS')>PARTNER_STATUS,</cfif>
					<cfif isDefined('attributes.camp_id')>CAMP_ID,</cfif>
					<cfif isDefined('attributes.CONS_SECTOR_CATS')>CONS_SECTOR_CATS,</cfif>
					<cfif isDefined('attributes.CONS_SIZE_CATS')>CONS_SIZE_CATS,</cfif>
					<cfif isdefined("attributes.company_city_id") and len(attributes.company_city_id)>COMPANY_CITY_ID,</cfif>
					<cfif isdefined("attributes.company_county_id") and len(attributes.company_county_id)>COMPANY_COUNTY_ID,</cfif>
                    <cfif isdefined("attributes.company_country_id") and len(attributes.company_country_id)>COMPANY_COUNTRY_ID,</cfif>
					<cfif isDefined("attributes.PARTNER_TMARKET_SEX")>PARTNER_TMARKET_SEX,</cfif>
					<cfif isDefined("attributes.PARTNER_MISSION")>PARTNER_MISSION,</cfif>
					<cfif isDefined("attributes.PARTNER_DEPARTMENT")>PARTNER_DEPARTMENT,</cfif>
					<cfif isdefined("attributes.cons_sales_total_start") and len(trim(attributes.cons_sales_total_start))>CONS_SALES_TOTAL_START,</cfif>
					<cfif isdefined("attributes.cons_sales_total_end") and len(trim(attributes.cons_sales_total_end))>CONS_SALES_TOTAL_END,</cfif>
					<cfif isdefined("attributes.cons_value") and len(attributes.cons_value)>CONSUMER_VALUE,</cfif>
					<cfif isdefined("attributes.company_value") and len(attributes.company_value)>COMPANY_VALUE,</cfif>
					<cfif isdefined("attributes.cons_ims_code") and len(attributes.cons_ims_code)>CONSUMER_IMS_CODE,</cfif>
					<cfif isdefined("attributes.company_ims_code") and len(attributes.company_ims_code)>COMPANY_IMS_CODE,</cfif>
					<cfif isdefined("attributes.cons_hobby") and len(attributes.cons_hobby)>CONSUMER_HOBBY,</cfif>
					<cfif isdefined("attributes.company_hobby") and len(attributes.company_hobby)>COMPANY_PARTNER_HOBBY,</cfif>
					<cfif isdefined("attributes.cons_resource") and len(attributes.cons_resource)>CONSUMER_RESOURCE,</cfif>
					<cfif isdefined("attributes.company_resource") and len(attributes.company_resource)>COMPANY_RESOURCE,</cfif>
					<cfif isdefined("attributes.cons_ozel_kod1") and len(attributes.cons_ozel_kod1)>CONSUMER_OZEL_KOD1,</cfif>
					<cfif isdefined("attributes.company_ozel_kod1") and len(attributes.company_ozel_kod1)>COMPANY_OZEL_KOD1,</cfif>
					<cfif isdefined("attributes.company_ozel_kod2") and len(attributes.company_ozel_kod2)>COMPANY_OZEL_KOD2,</cfif>
					<cfif isdefined("attributes.company_ozel_kod3") and len(attributes.company_ozel_kod3)>COMPANY_OZEL_KOD3,</cfif>
					<cfif isdefined("attributes.cons_sales_zone") and len(attributes.cons_sales_zone)>CONSUMER_SALES_ZONE,</cfif>
					<cfif isdefined("attributes.company_sales_zone") and len(attributes.company_sales_zone)>COMPANY_SALES_ZONE,</cfif>
					<cfif isdefined("attributes.cons_education") and len(attributes.cons_education)>CONS_EDUCATION,</cfif>
					<cfif isdefined("attributes.cons_vocation_type") and len(attributes.cons_vocation_type)>CONS_VOCATION_TYPE,</cfif>
					<cfif isdefined("attributes.cons_society") and len(attributes.cons_society)>CONS_SOCIETY,</cfif>
					<cfif isdefined("attributes.cons_income_level") and len(attributes.cons_income_level)>CONS_INCOME_LEVEL,</cfif>
					<cfif isDefined('attributes.cons_status')>CONS_STATUS,</cfif>					
					<cfif isdefined("attributes.rel_company_name") and len(attributes.rel_company_id)>COMPANY_REL_ID,</cfif>
					<cfif isdefined("attributes.rel_type_id") and len(attributes.rel_type_id)>COMPANY_REL_TYPE_ID,</cfif>
					<cfif isdefined('attributes.req_comp') and len(attributes.req_comp)>REQ_COMP,</cfif>
					<cfif isdefined('attributes.req_cons') and len(attributes.req_cons)>REQ_CONS,</cfif>
					<cfif isdefined('attributes.COMP_AGENT_POS_CODE') and len(attributes.COMP_AGENT_POS_CODE)>COMP_AGENT_POS_CODE,</cfif>
					<cfif isdefined('attributes.CONS_AGENT_POS_CODE') and len(attributes.CONS_AGENT_POS_CODE)>CONS_AGENT_POS_CODE,</cfif>
					<cfif isdefined('attributes.COMP_REL_BRANCH') and len(attributes.COMP_REL_BRANCH)>COMP_REL_BRANCH,</cfif>
					<cfif isdefined('attributes.CONS_REL_BRANCH') and len(attributes.CONS_REL_BRANCH)>CONS_REL_BRANCH,</cfif>
					<cfif isdefined('attributes.COMP_REL_COMP') and len(attributes.COMP_REL_COMP)>COMP_REL_COMP,</cfif>
					<cfif isdefined('attributes.CONS_REL_COMP') and len(attributes.CONS_REL_COMP)>CONS_REL_COMP,</cfif>
					<cfif isdefined('attributes.product_category') and len(attributes.product_category)>COMP_PRODUCTCAT_LIST,</cfif>
					<cfif isdefined('attributes.firm_type') and len(attributes.firm_type)>COMP_FIRM_LIST,</cfif>
					IS_MAILLIST,
					ORDER_START_DATE,
					ORDER_FINISH_DATE,
					LAST_DAY_COUNT,
					LAST_DAY_TYPE,
					IS_GIVEN_ORDER,
					ORDER_PRODUCT_ID,
					ORDER_PRODUCT_STATUS,
					ORDER_PRODUCTCAT_ID,
					ORDER_PRODUCTCAT_STATUS,
					ORDER_AMOUNT,
					ORDER_AMOUNT_TYPE,
					ORDER_COUNT,
					ORDER_COUNT_TYPE,
					PRODUCT_COUNT,
					PRODUCT_COUNT_TYPE,
					ORDER_COMMETHOD_ID,
					ORDER_PAYMETHOD_ID,
					ORDER_CARDPAYMETHOD_ID,
					PROMOTION_ID,
					PROMOTION_STATUS,
					PROMOTION_COUNT,
					CONSUMER_STAGE,
                    PARTNER_STAGE,
					CONSUMER_BIRTHDATE,
					PROMOTION_OFFER_STATUS,
					IS_CONS_CEPTEL,
					IS_CONS_EMAIL,
					IS_CONS_TAX,
					IS_CONS_DEBT,
					IS_CONS_BLOKE,
					IS_CONS_OPEN_ORDER,
					IS_CONS_BLACK_LIST,
					CONS_PASSWORD_DAY,
					TRAINING_ID,
					TRAINING_STATUS,
					COMP_WANT_EMAIL,
					CONS_WANT_EMAIL,
                    PROCESS_STAGE,
                    IS_ACTIVE,
					RECORD_DATE,
					RECORD_EMP,
					RECORD_IP
				)
			VALUES
				(
					#search_type#,
					'#system_paper_no#',
					<cfif isdefined("attributes.only_firm_members") and len(attributes.only_firm_members)>#attributes.only_firm_members#,</cfif>
					<cfif isdefined("attributes.connect_member") and len(attributes.connect_member)>#attributes.connect_member#,</cfif>
					<cfif isdefined("attributes.only_firmmember") and len(attributes.only_firmmember)>#attributes.only_firmmember#,</cfif>
					'#attributes.TMARKET_NAME#',
					<cfif isDefined("attributes.TMARKET_SEX")>'#attributes.TMARKET_SEX#',</cfif>
					<cfif isDefined("attributes.TMARKET_MARITAL_STATUS")>'#attributes.TMARKET_MARITAL_STATUS#',</cfif>
					<cfif isdefined("attributes.AGE_LOWER") and len(attributes.AGE_LOWER)>#attributes.AGE_LOWER#,</cfif>
					<cfif isdefined("attributes.AGE_UPPER") and len(attributes.AGE_UPPER)>#attributes.AGE_UPPER#,</cfif>
					<cfif  isdefined("attributes.CHILD_LOWER") and len(attributes.CHILD_LOWER)>#attributes.CHILD_LOWER#,</cfif>
					<cfif isdefined("attributes.CHILD_UPPER") and len(attributes.CHILD_UPPER)>#attributes.CHILD_UPPER#,</cfif>
					<cfif isdefined("attributes.cons_city_id") and len(attributes.cons_city_id)>'#attributes.cons_city_id#',</cfif>
					<cfif isdefined("attributes.cons_county_id") and len(attributes.cons_county_id)>'#attributes.cons_county_id#',</cfif>
					<cfif isDefined("attributes.SHOPPING_STARTDATE") AND len(attributes.SHOPPING_STARTDATE)>#attributes.SHOPPING_STARTDATE#,</cfif>
					<cfif isDefined("attributes.SHOPPING_FINISHDATE") AND len(attributes.SHOPPING_FINISHDATE)>#attributes.SHOPPING_FINISHDATE#,</cfif>
					<cfif isDefined("attributes.TMARKET_MEMBERSHIP_STARTDATE") AND len(attributes.TMARKET_MEMBERSHIP_STARTDATE)>#TMARKET_MEMBERSHIP_STARTDATE#,</cfif>
					<cfif isDefined("attributes.TMARKET_MEMBERSHIP_FINISHDATE") AND len(attributes.TMARKET_MEMBERSHIP_FINISHDATE)>#TMARKET_MEMBERSHIP_FINISHDATE#,</cfif>
					<cfif isDefined("attributes.CATEGORY") AND attributes.CATEGORY EQ 1>#attributes.PRODUCT_CATID#,<cfelseif isDefined("attributes.CATEGORY") AND attributes.CATEGORY EQ 0>#attributes.STOCK_ID#,</cfif>
					<cfif isDefined("attributes.CONSCAT_IDS")>'#attributes.CONSCAT_IDS#',</cfif>
					<cfif isDefined("attributes.SECTOR_CATS")>'#attributes.SECTOR_CATS#',</cfif>
					<cfif isDefined("attributes.COMPANY_SIZE_CATS")>'#attributes.COMPANY_SIZE_CATS#',</cfif>
					<cfif isDefined('attributes.COMPANYCATS')>'#attributes.COMPANYCATS#',</cfif>
					<cfif isDefined('attributes.CONS_IS_POTANTIAL')>'#attributes.CONS_IS_POTANTIAL#',</cfif>
					<cfif isDefined('attributes.IS_POTANTIAL')>'#attributes.IS_POTANTIAL#',</cfif>
					<cfif isDefined('attributes.IS_BUYER')>1,<cfelse>0,</cfif>
					<cfif isDefined('attributes.IS_SELLER')>1,<cfelse>0,</cfif>
					<cfif isDefined('attributes.PARTNER_STATUS')>'#attributes.PARTNER_STATUS#',</cfif>
					<cfif isdefined('attributes.camp_id')>#attributes.CAMP_ID#,</cfif>
					<cfif isDefined('attributes.CONS_SECTOR_CATS')>'#attributes.CONS_SECTOR_CATS#',</cfif>
					<cfif isDefined('attributes.CONS_SIZE_CATS')>'#attributes.CONS_SIZE_CATS#',</cfif>
					<cfif isDefined("attributes.company_city_id") and len(attributes.company_city_id)>'#attributes.company_city_id#',</cfif>
					<cfif isDefined("attributes.company_county_id") and len(attributes.company_county_id)>'#attributes.company_county_id#',</cfif>
                    <cfif isDefined("attributes.company_country_id") and len(attributes.company_country_id)>'#attributes.company_country_id#',</cfif>
					<cfif isDefined("attributes.PARTNER_TMARKET_SEX")>'#attributes.PARTNER_TMARKET_SEX#',</cfif>			
					<cfif isDefined("attributes.PARTNER_MISSION")>'#attributes.PARTNER_MISSION#',</cfif>			
					<cfif isDefined("attributes.PARTNER_DEPARTMENT")>'#attributes.PARTNER_DEPARTMENT#',</cfif>
					<cfif isdefined("attributes.cons_sales_total_start") and len(trim(attributes.cons_sales_total_start))>'#attributes.cons_sales_total_start#',</cfif>
					<cfif isdefined("attributes.cons_sales_total_end") and len(trim(attributes.cons_sales_total_end))>'#attributes.cons_sales_total_end#',</cfif>
					<cfif isdefined("attributes.cons_value") and len(attributes.cons_value)>'#attributes.cons_value#',</cfif>
					<cfif isdefined("attributes.company_value") and len(attributes.company_value)>'#attributes.company_value#',</cfif>
					<cfif isdefined("attributes.cons_ims_code") and len(attributes.cons_ims_code)>'#attributes.cons_ims_code#',</cfif>
					<cfif isdefined("attributes.company_ims_code") and len(attributes.company_ims_code)>'#attributes.company_ims_code#',</cfif>
					<cfif isdefined("attributes.cons_hobby") and len(attributes.cons_hobby)>'#attributes.cons_hobby#',</cfif>
					<cfif isdefined("attributes.company_hobby") and len(attributes.company_hobby)>'#attributes.company_hobby#',</cfif>
					<cfif isdefined("attributes.cons_resource") and len(attributes.cons_resource)>'#attributes.cons_resource#',</cfif>
					<cfif isdefined("attributes.company_resource") and len(attributes.company_resource)>'#attributes.company_resource#',</cfif>
					<cfif isdefined("attributes.cons_ozel_kod1") and len(attributes.cons_ozel_kod1)>'#attributes.cons_ozel_kod1#',</cfif>
					<cfif isdefined("attributes.company_ozel_kod1") and len(attributes.company_ozel_kod1)>'#attributes.company_ozel_kod1#',</cfif>
					<cfif isdefined("attributes.company_ozel_kod2") and len(attributes.company_ozel_kod2)>'#attributes.company_ozel_kod2#',</cfif>
					<cfif isdefined("attributes.company_ozel_kod3") and len(attributes.company_ozel_kod3)>'#attributes.company_ozel_kod3#',</cfif>
					<cfif isdefined("attributes.cons_sales_zone") and len(attributes.cons_sales_zone)>'#attributes.cons_sales_zone#',</cfif>
					<cfif isdefined("attributes.company_sales_zone") and len(attributes.company_sales_zone)>'#attributes.company_sales_zone#',</cfif>
					<cfif isdefined("attributes.cons_education") and len(attributes.cons_education)>'#attributes.cons_education#',</cfif>
					<cfif isdefined("attributes.cons_vocation_type") and len(attributes.cons_vocation_type)>'#attributes.cons_vocation_type#',</cfif>
					<cfif isdefined("attributes.cons_society") and len(attributes.cons_society)>'#attributes.cons_society#',</cfif>
					<cfif isdefined("attributes.cons_income_level") and len(attributes.cons_income_level)>'#attributes.cons_income_level#',</cfif>
					<cfif isDefined('attributes.cons_status')>'#attributes.CONS_STATUS#',</cfif>					
					<cfif isdefined("attributes.rel_company_name") and len(attributes.rel_company_id)>#attributes.rel_company_id#,</cfif>
					<cfif isdefined("attributes.rel_type_id") and len(attributes.rel_type_id)>'#attributes.rel_type_id#',</cfif>
					<cfif isdefined('attributes.req_comp') and len(attributes.req_comp)>'#attributes.req_comp#',</cfif>
					<cfif isdefined('attributes.req_cons') and len(attributes.req_cons)>'#attributes.req_cons#',</cfif>
					<cfif isdefined('attributes.COMP_AGENT_POS_CODE') and len(attributes.COMP_AGENT_POS_CODE)>'#attributes.COMP_AGENT_POS_CODE#',</cfif>
					<cfif isdefined('attributes.CONS_AGENT_POS_CODE') and len(attributes.CONS_AGENT_POS_CODE)>'#attributes.CONS_AGENT_POS_CODE#',</cfif>
					<cfif isdefined('attributes.COMP_REL_BRANCH') and len(attributes.COMP_REL_BRANCH)>'#attributes.COMP_REL_BRANCH#',</cfif>
					<cfif isdefined('attributes.CONS_REL_BRANCH') and len(attributes.CONS_REL_BRANCH)>'#attributes.CONS_REL_BRANCH#',</cfif>
					<cfif isdefined('attributes.COMP_REL_COMP') and len(attributes.COMP_REL_COMP)>'#attributes.COMP_REL_COMP#',</cfif>
					<cfif isdefined('attributes.CONS_REL_COMP') and len(attributes.CONS_REL_COMP)>'#attributes.CONS_REL_COMP#',</cfif>
					<cfif isdefined('attributes.product_category') and len(attributes.product_category)>'#attributes.product_category#',</cfif>
					<cfif isdefined('attributes.firm_type') and len(attributes.firm_type)>'#attributes.firm_type#',</cfif>
					<cfif isdefined("attributes.is_maillist")>1,<cfelse>0,</cfif>
					<cfif isdefined('attributes.order_start_date') and len(attributes.order_start_date)>#attributes.order_start_date#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.order_finish_date') and len(attributes.order_finish_date)>#attributes.order_finish_date#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.order_date') and len(attributes.order_date)>#attributes.order_date#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.order_date_opt') and len(attributes.order_date_opt)>#attributes.order_date_opt#<cfelse>NULL</cfif>,
					<cfif isdefined("attributes.is_order")>1<cfelseif isdefined("attributes.is_not_order")>2<cfelse>1</cfif>,
					<cfif isdefined("product_id_list") and len(product_id_list)>'#product_id_list#'<cfelse>NULL</cfif>,
					<cfif isdefined("attributes.is_product_and")>1<cfelseif isdefined("attributes.is_product_or")>2<cfelse>1</cfif>,
					<cfif isdefined("productcat_id_list") and len(productcat_id_list)>'#productcat_id_list#'<cfelse>NULL</cfif>,
					<cfif isdefined("attributes.is_productcat_and")>1<cfelseif isdefined("attributes.is_productcat_or")>2<cfelse>1</cfif>,
					<cfif isdefined("attributes.order_amount") and len(attributes.order_amount)>#attributes.order_amount#<cfelse>NULL</cfif>,
					<cfif isdefined("attributes.sel_order_amount") and len(attributes.sel_order_amount)>#attributes.sel_order_amount#<cfelse>NULL</cfif>,
					<cfif isdefined("attributes.product_amount") and len(attributes.product_amount)>#attributes.product_amount#<cfelse>NULL</cfif>,
					<cfif isdefined("attributes.sel_product_amount") and len(attributes.sel_product_amount)>#attributes.sel_product_amount#<cfelse>NULL</cfif>,
					<cfif isdefined("attributes.order_count") and len(attributes.order_count)>#attributes.order_count#<cfelse>NULL</cfif>,
					<cfif isdefined("attributes.sel_order_count") and len(attributes.sel_order_count)>#attributes.sel_order_amount#<cfelse>NULL</cfif>,
					<cfif isdefined("attributes.order_commethod") and len(attributes.order_commethod)>'#attributes.order_commethod#'<cfelse>NULL</cfif>,
					<cfif isdefined("standart_method") and len(standart_method)>'#standart_method#'<cfelse>NULL</cfif>,
					<cfif isdefined("card_method") and len(card_method)>'#card_method#'<cfelse>NULL</cfif>,
					<cfif isdefined("promotion_id_list") and len(promotion_id_list)>'#promotion_id_list#'<cfelse>NULL</cfif>,
					<cfif isdefined("attributes.is_prom_and")>1<cfelseif isdefined("attributes.is_prom_or")>2<cfelse>1</cfif>,
					<cfif isdefined("attributes.prom_count") and len(attributes.prom_count)>#attributes.prom_count#<cfelse>NULL</cfif>,
					<cfif isdefined("attributes.member_stage") and len(attributes.member_stage)>'#attributes.member_stage#'<cfelse>NULL</cfif>,
                    <cfif isdefined("attributes.partmember_stage") and len(attributes.partmember_stage)>'#attributes.partmember_stage#'<cfelse>NULL</cfif>,
					<cfif isdefined("attributes.birth_date") and len(attributes.birth_date)>#attributes.birth_date#<cfelse>NULL</cfif>,
					<cfif isdefined("attributes.is_prom_select") and len(attributes.is_prom_select)>#attributes.is_prom_select#<cfelse>NULL</cfif>,
					<cfif isdefined("attributes.is_cep_tel")>1<cfelse>0</cfif>,
					<cfif isdefined("attributes.is_email")>1<cfelse>0</cfif>,
					<cfif isdefined("attributes.is_tax")>1<cfelse>0</cfif>,
					<cfif isdefined("attributes.is_debt")>1<cfelse>0</cfif>,
					<cfif isdefined("attributes.is_bloke")>1<cfelse>0</cfif>,
					<cfif isdefined("attributes.is_open_order")>1<cfelse>0</cfif>,
					<cfif isdefined("attributes.is_black_list")>1<cfelse>0</cfif>,
					<cfif isdefined("attributes.password_day") and len(attributes.password_day)>#attributes.password_day#<cfelse>NULL</cfif>,
					<cfif isdefined("training_id_list") and len(training_id_list)>'#training_id_list#'<cfelse>NULL</cfif>,
					<cfif isdefined("attributes.is_train_or")>2<cfelse>1</cfif>,
					<cfif isdefined("attributes.comp_want_email") and len(attributes.comp_want_email)>#attributes.comp_want_email#<cfelse>NULL</cfif>,
					<cfif isdefined("attributes.cons_want_email") and len(attributes.cons_want_email)>#attributes.cons_want_email#<cfelse>NULL</cfif>,
                    <cfif isdefined("attributes.process_stage") and len(attributes.process_stage)>#attributes.process_stage#<cfelse>NULL</cfif>,
                    1,					
					#now()#,
					#SESSION.EP.USERID#,
					'#CGI.REMOTE_ADDR#'
				)
		</cfquery>
		<cfquery name="UPD_GEN_PAP" datasource="#DSN3#">
			UPDATE 
				GENERAL_PAPERS
			SET
				TARGET_MARKET_NUMBER=#system_paper_no_add#
			WHERE
				TARGET_MARKET_NUMBER IS NOT NULL
		</cfquery>
		<cfif isdefined('attributes.camp_id')>
			<cfquery name="INS_CAMP_TMARKETS" datasource="#dsn3#">
				INSERT INTO
					CAMPAIGN_TARGET_MARKETS
                    (
						CAMP_ID,
                        TMARKET_ID					
					)
					VALUES
                    (
						#form.camp_id#,
                        #MAX_ID.IDENTITYCOL#
					)
			</cfquery>
			<cfset attributes.TMARKET_ID = MAX_ID.IDENTITYCOL>
			<cfinclude template="../query/get_target_markets.cfm">
			<cfif search_type eq 0 or search_type eq 2>
				<cfinclude template="get_tmarket_consumer_count.cfm">
				<cfloop query="GET_TMARKET_CONSUMER">
					<cfquery name="CONTROL" datasource="#DSN3#">
						SELECT 
							TMARKET_ID
						FROM 
							CAMPAIGN_TARGET_PEOPLE 
						WHERE
							CAMP_ID = #attributes.camp_id# AND
							TMARKET_ID = #attributes.tmarket_id# AND
							CON_ID = #consumer_id#
					</cfquery>
					<cfif not control.recordcount>
						<cfquery name="ADD_TARGET_PEOPLE" datasource="#DSN3#">
							INSERT INTO
								CAMPAIGN_TARGET_PEOPLE
							(
								CAMP_ID,
								TMARKET_ID,
								CON_ID,
								RECORD_EMP,
								RECORD_DATE
							)
							VALUES
							(
								#attributes.camp_id#,
								#attributes.tmarket_id#,
								#consumer_id#,
								#session.ep.userid#,
								#now()#
							)
						</cfquery>
					</cfif>
				</cfloop>
			</cfif>			
			<cfif search_type eq 0 or search_type eq 1>
				<cfinclude template="get_tmarket_partners_count.cfm">
				<cfloop query="GET_TMARKET_PARTNERS">
					<cfquery name="CONTROL" datasource="#DSN3#">
						SELECT 
							TMARKET_ID
						FROM 
							CAMPAIGN_TARGET_PEOPLE 
						WHERE
							CAMP_ID = #attributes.camp_id#AND
							TMARKET_ID = #attributes.tmarket_id# AND
							PAR_ID = #partner_id#
					</cfquery>
					<cfif not CONTROL.RECORDCOUNT>
						<cfquery name="ADD_TARGET_PEOPLE" datasource="#DSN3#">
							INSERT INTO 
								CAMPAIGN_TARGET_PEOPLE
							(
								CAMP_ID,
								TMARKET_ID,
								PAR_ID,
								RECORD_EMP,
								RECORD_DATE
							)
							VALUES
							(
								#attributes.camp_id#,
								#attributes.tmarket_id#,
								#partner_id#,
								#session.ep.userid#,
								#now()#
							)
						</cfquery>
					</cfif>
				</cfloop>
			</cfif>
		</cfif>
	</cftransaction>
</cflock>
<cfset tmarket_id = MAX_ID.IDENTITYCOL>
<cf_workcube_process
    is_upd='1'
    old_process_line='0'
    process_stage='#attributes.process_stage#'
    record_member='#session.ep.userid#' 
    record_date='#now()#'
    action_table="TARGET_MARKETS"
    action_column="tmarket_id"
     warning_description='Hedef Kitle : #tmarket_id#'
    action_id="#tmarket_id#"
    action_page='#request.self#?fuseaction=campaign.list_target_markets&event=upd&tmarket_id=#tmarket_id#'>

<cfset attributes.actionId = tmarket_id >
<cfif listgetat(attributes.fuseaction,1,'.') is 'objects'>
	<script type="text/javascript">
		window.close();
	</script>
<cfelse>
	<script type="text/javascript">
		window.location.href="<cfoutput>#request.self#?fuseaction=campaign.list_target_markets&event=upd&tmarket_id=#tmarket_id#</cfoutput>";
    </script>
</cfif>
