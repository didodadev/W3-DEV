<cf_get_lang_set module_name="product">
<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
    <cfset xml_page_control_list = 'is_detail_prom,is_product_code_2'>
    <cf_xml_page_edit page_control_list="#xml_page_control_list#" default_value="0" fuseact="product.list_promotions">
    <cfparam name="attributes.product_catid" default="">
    <cfparam name="attributes.product_cat" default="">
    <cfparam name="attributes.product_name" default="">
    <cfparam name="attributes.stock_id" default="">
    <cfparam name="attributes.company_id" default="">
    <cfparam name="attributes.company" default="">
    <cfparam name="attributes.supplier_id" default="">
    <cfparam name="attributes.supplier_name" default="">
    <cfparam name="attributes.keyword" default="">
    <cfparam name="attributes.price_catid" default="">
    <cfparam name="attributes.start_date" default="">
    <cfparam name="attributes.finish_date" default="">
    <cfparam name="attributes.prom_stage" default="">
    <cfparam name="attributes.is_status" default="1">
    <cfparam name="attributes.collacted_status" default="">
    <cfparam name="attributes.supplier_id" default="">
    <cfparam name="attributes.brand_id" default="">
    <cfif fusebox.circuit is 'store'>
        <cfset attributes.branch_id = listgetat(session.ep.user_location,2,'-')>
    </cfif>
    <cfif isdefined('attributes.supplier_id') and len (attributes.supplier_id) and not isdefined("attributes.supplier_name")>
        <cfquery name="get_company_name" datasource="#dsn#">
            SELECT FULLNAME FROM COMPANY WHERE COMPANY_ID = #attributes.supplier_id#
        </cfquery>
        <cfset attributes.supplier_name = get_company_name.fullname>
    </cfif>
    <cfquery name="get_emp_position_cat_id" datasource="#dsn#">
        SELECT POSITION_CAT_ID FROM EMPLOYEE_POSITIONS WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#"> 
    </cfquery>
    <cfquery name="GET_PRICE_CAT" datasource="#DSN3#">
        SELECT 
            * 
        FROM 
            PRICE_CAT
        WHERE 
            PRICE_CAT_STATUS = 1 
        <cfif isDefined("attributes.pcat_id") and len(attributes.pcat_id)>
            AND PRICE_CATID = #attributes.PCAT_ID#
        </cfif>
        <!--- Pozisyon tipine gore yetki veriliyor  --->
        <cfif isDefined("xml_related_position_cat") and xml_related_position_cat eq 1>
            AND POSITION_CAT LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#get_emp_position_cat_id.position_cat_id#,%">
        </cfif>
        <!--- //Pozisyon tipine gore yetki veriliyor  --->
        ORDER BY
            PRICE_CAT
    </cfquery> 
    <cfif isdefined("attributes.is_submitted")>
        <cfinclude template="../product/query/get_proms.cfm">
    <cfelse>
        <cfset proms.recordcount = 0>
    </cfif>
    <cfparam name="attributes.page" default=1>
    <cfif isDefined("session.ep.maxrows")>
        <cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
    <cfelse>
        <cfparam name="attributes.maxrows" default='#session.pp.maxrows#'>
    </cfif>
    <cfparam name="attributes.totalrecords" default="#proms.recordcount#">
    <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
    <cfif isdate(attributes.start_date)><cfset attributes.start_date = dateformat(attributes.start_date, "dd/mm/yyyy")></cfif>
    <cfif isdate(attributes.finish_date)><cfset attributes.finish_date = dateformat(attributes.finish_date, "dd/mm/yyyy")></cfif>
    <cfif proms.recordcount>
			<cfset prom_stage_list=''>
			<cfset proms_stock_list=''>
			<cfset proms_camp_list=''>
			<cfoutput query="proms" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
				<cfif len(prom_stage) and not listfind(prom_stage_list,prom_stage)>
					<cfset prom_stage_list=listappend(prom_stage_list,prom_stage)>
				</cfif>
				<cfif len(stock_id) and not listfind(proms_stock_list,stock_id)>
					<cfset proms_stock_list=listappend(proms_stock_list,stock_id)>
				</cfif>
				<cfif len(camp_id) and not listfind(proms_camp_list,camp_id)>
					<cfset proms_camp_list=listappend(proms_camp_list,camp_id)>
				</cfif>
			</cfoutput>
			<cfif len(prom_stage_list)>
				<cfset prom_stage_list=listsort(prom_stage_list,"numeric","ASC",",")>
				<cfquery name="process_type" datasource="#dsn#">
					SELECT STAGE, PROCESS_ROW_ID FROM PROCESS_TYPE_ROWS WHERE PROCESS_ROW_ID IN(#prom_stage_list#) ORDER BY PROCESS_ROW_ID
				</cfquery>
			</cfif>
			<cfif not(isdefined("is_detail_prom") and is_detail_prom eq 1)>
				<cfif len(proms_stock_list)>
					<cfset proms_stock_list=listsort(proms_stock_list,"numeric","ASC",",")>
					<cfquery name="GET_STOCK_NAME" datasource="#DSN3#">
						SELECT S.STOCK_CODE, S.PRODUCT_NAME, S.PRODUCT_ID, S.STOCK_ID FROM STOCKS S WHERE S.STOCK_ID IN(#proms_stock_list#) ORDER BY S.STOCK_ID 
					</cfquery>
					<cfset proms_stock_list_2 = listsort(listdeleteduplicates(valuelist(GET_STOCK_NAME.STOCK_ID,',')),'numeric','ASC',',')>
				</cfif>
			</cfif>
			<cfif len(proms_camp_list)>
				<cfset proms_camp_list=listsort(proms_camp_list,"numeric","ASC",",")>
				<cfquery name="GET_CAMP_NAME" datasource="#DSN3#">
					SELECT CAMP_HEAD, CAMP_ID FROM CAMPAIGNS WHERE CAMP_ID IN(#proms_camp_list#) ORDER BY CAMP_ID
				</cfquery>
			</cfif>
	</cfif>    
<cfelseif isdefined("attributes.event") and attributes.event is 'adddetprom'>
    <cf_get_lang_set module_name="product">
    <cfset xml_page_control_list = 'is_conscat_segmentation,is_conscat_premium,is_product_code_2,other_price_cat'>
    <cf_xml_page_edit page_control_list="#xml_page_control_list#" default_value="0" fuseact="product.form_upd_detail_prom">
    <cfinclude template="../product/query/get_money.cfm">
    <cfinclude template="../product/query/get_price_cats.cfm">
    <cfinclude template="../member/query/get_member_add_options.cfm">
    <!--- Sadece aktif kategorilerin gelmesi için --->
    <cfset attributes.is_active_consumer_cat = 1>
    <cfinclude template="../product/query/get_consumer_cat.cfm">
    <cfif isdefined("other_price_cat") and len(other_price_cat)>
        <cfquery name="GET_PRICECAT_NAME" dbtype="query">
            SELECT PRICE_CAT FROM GET_PRICE_CATS WHERE PRICE_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#other_price_cat#">
        </cfquery>
    <cfelse>
        <cfset get_pricecat_name.recordcount = 0>
    </cfif>
    <cfif isdefined("attributes.camp_id")>
        <cfquery name="GET_CAMP_INFO" datasource="#DSN3#">
            SELECT CAMP_HEAD,CAMP_ID,CAMP_STARTDATE,CAMP_FINISHDATE FROM CAMPAIGNS WHERE CAMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.camp_id#">
        </cfquery>
        <cfset camp_start = date_add("H",session.ep.time_zone,get_camp_info.camp_startdate)>
        <cfset camp_finish = date_add("H",session.ep.time_zone,get_camp_info.camp_finishdate)>
        <cfset camp_start_date=date_add("H",session.ep.time_zone,get_camp_info.camp_startdate)>
        <cfset camp_start_hour=datepart("H",camp_start_date)>
        <cfset camp_start_minute=datepart("N",camp_start_date)>
        <cfset camp_finish_date=date_add("H",session.ep.time_zone,get_camp_info.camp_finishdate)>
        <cfset camp_finish_hour=datepart("H",camp_finish_date)>
        <cfset camp_finish_minute=datepart("N",camp_finish_date)>
        <cfset camp_id = get_camp_info.camp_id>
        <cfset camp_head = '#get_camp_info.camp_head#(#dateformat(camp_start,'dd/mm/yyyy')#-#dateformat(camp_finish,'dd/mm/yyyy')#)'>
    <cfelse>
        <cfset camp_start = ''>
        <cfset camp_finish = ''>
        <cfset camp_id = ''>
        <cfset camp_head = ''>
        <cfset camp_start_date=''>
        <cfset camp_start_hour=''>
        <cfset camp_start_minute=''>
        <cfset camp_finish_date=''>
        <cfset camp_finish_hour=''>
        <cfset camp_finish_minute=''>
    </cfif>
    <cfquery name="GET_CREDIT_TYPES" datasource="#DSN3#">
        SELECT PAYMENT_TYPE_ID,CARD_NO FROM CREDITCARD_PAYMENT_TYPE WHERE ISNULL(IS_PROM_CONTROL,0) = 1
    </cfquery>
    <cfquery name="get_category" datasource="#dsn#">
        SELECT MEMBER_ADD_OPTION_ID,MEMBER_ADD_OPTION_NAME FROM SETUP_MEMBER_ADD_OPTIONS ORDER BY MEMBER_ADD_OPTION_NAME
    </cfquery>
    <cf_papers paper_type="promotion">
    <cfset system_paper_no = paper_code & '-' & paper_number>
    <cfset system_paper_no_add = paper_number>
<cfelseif isdefined("attributes.event") and attributes.event is 'upddetprom'>
    <cf_get_lang_set module_name="product">
    <cfset xml_page_control_list = 'is_conscat_segmentation,is_conscat_premium,is_product_code_2,other_price_cat'>
    <cf_xml_page_edit page_control_list="#xml_page_control_list#" default_value="0" fuseact="product.form_upd_detail_prom">
    <cfinclude template="../product/query/get_consumer_cat.cfm">
    <cfinclude template="../product/query/get_money.cfm">
    <cfinclude template="../product/query/get_price_cats.cfm">
    <cfinclude template="../member/query/get_member_add_options.cfm">
    <cfif isdefined("other_price_cat") and len(other_price_cat)>
        <cfquery name="GET_PRICECAT_NAME" dbtype="query">
            SELECT PRICE_CAT FROM GET_PRICE_CATS WHERE PRICE_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#other_price_cat#">
        </cfquery>
    <cfelse>
        <cfset get_pricecat_name.recordcount = 0>
    </cfif>
    <cfquery name="GET_PROM" datasource="#DSN3#">
        SELECT * FROM PROMOTIONS WHERE PROM_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.prom_id#">
    </cfquery>    
    <cfquery name="get_prom_products" datasource="#dsn3#">
        SELECT 
            PP.*,
            <cfif isdefined("is_product_code_2") and is_product_code_2 eq 1>P.PRODUCT_CODE_2 AS PRODUCT_CODE<cfelse>P.PRODUCT_CODE</cfif>,
            P.PRODUCT_NAME 
        FROM 
            PROMOTION_PRODUCTS PP,
            PRODUCT P
        WHERE 
            PP.PROMOTION_ID = #attributes.prom_id# AND 
            P.PRODUCT_ID = PP.PRODUCT_ID
    </cfquery>
    
    <cfquery name="get_prom_conditions" datasource="#dsn3#">
        SELECT * FROM PROMOTION_CONDITIONS WHERE PROMOTION_ID = #attributes.prom_id# ORDER BY PROM_CONDITION_ID
    </cfquery>
    <cfquery name="get_prom_related" datasource="#dsn3#">
        SELECT PROMOTION_RELATED_PROMOTIONS.*,PROM_HEAD,PROM_NO FROM PROMOTION_RELATED_PROMOTIONS,PROMOTIONS WHERE PROMOTION_RELATED_PROMOTIONS.PROMOTION_ID = #attributes.prom_id# AND PROMOTION_RELATED_PROMOTIONS.RELATED_PROM_ID = PROMOTIONS.PROM_ID ORDER BY PROM_RELATED_ID
    </cfquery>
    <cfif isdefined("is_copy")>
        <cf_papers paper_type="promotion">
        <cfset action_ = "emptypopup_add_detail_prom">
        <cfset system_paper_no = paper_code & '-' & paper_number>
        <cfset system_paper_no_add = paper_number>
    <cfelse>
        <cfset action_ = "emptypopup_upd_detail_prom">
    </cfif>
    <cfquery name="get_credit_types" datasource="#dsn3#">
        SELECT PAYMENT_TYPE_ID,CARD_NO FROM CREDITCARD_PAYMENT_TYPE WHERE ISNULL(IS_PROM_CONTROL,0) = 1
    </cfquery>
    <cfsavecontent variable="title_">
        <cfif isdefined("is_copy")>
            Promosyon Ekle
        <cfelse>
            Promosyon Güncelle
        </cfif>
    </cfsavecontent>
<cfelseif isdefined("attributes.event") and attributes.event is 'addcollectedprom'>
    <cfparam name="attributes.product_name" default="">
    <cfparam name="attributes.product_id" default="">
    <cfquery name="get_price_cats" datasource="#DSN3#">
        SELECT PRICE_CATID, PRICE_CAT FROM PRICE_CAT WHERE PRICE_CAT_STATUS = 1 ORDER BY PRICE_CAT
    </cfquery>
    <cfif isdefined("attributes.camp_id") and len(attributes.camp_id)>
        <cfquery name="get_camp_info" datasource="#dsn3#">
            SELECT CAMP_HEAD,CAMP_ID,CAMP_STARTDATE,CAMP_FINISHDATE FROM CAMPAIGNS WHERE CAMP_ID = #attributes.camp_id#
        </cfquery>
        <cfset camp_start = date_add("H",session.ep.time_zone,get_camp_info.camp_startdate)>
        <cfset camp_finish = date_add("H",session.ep.time_zone,get_camp_info.camp_finishdate)>
        <cfset camp_id = get_camp_info.camp_id>
        <cfset camp_head = '#get_camp_info.camp_head#(#dateformat(camp_start,'dd/mm/yyyy')#-#dateformat(camp_finish,'dd/mm/yyyy')#)'>
    <cfelse>
        <cfset camp_start = ''>
        <cfset camp_finish = ''>
        <cfset camp_id = ''>
        <cfset camp_head = ''>
    </cfif>
<cfelseif isdefined("attributes.event") and attributes.event is 'updcollectedprom'>
	<cfset xml_page_control_list = 'is_conscat_segmentation,is_conscat_premium'>
    <cf_xml_page_edit page_control_list="#xml_page_control_list#" default_value="0" fuseact="product.form_upd_collacted_prom">
    <cfquery name="get_price_cats" datasource="#DSN3#">
        SELECT PRICE_CATID,PRICE_CAT FROM PRICE_CAT WHERE PRICE_CAT_STATUS = 1 ORDER BY PRICE_CAT
    </cfquery>
    <cfquery name="get_all_proms" datasource="#dsn3#">
        SELECT 
            PR.*,
            P.PROM_ID,
            P.CAMP_ID,
            P.PROM_NO,
            P.STOCK_ID,
            P.PRODUCT_ID,
            P.PROM_HEAD,
            P.PRICE_CATID PRICE_CAT_ID,
            P.STARTDATE,
            P.FINISHDATE,
            P.LIMIT_TYPE,
            P.LIMIT_VALUE,
            P.FREE_STOCK_ID,
            P.FREE_STOCK_AMOUNT,
            P.FREE_STOCK_PRICE,
            P.AMOUNT_1,
            P.DISCOUNT,
            P.AMOUNT_DISCOUNT
        FROM
            PROMOTIONS_RELATION PR,
            PROMOTIONS P
        WHERE 
            PR.PROM_RELATION_ID = P.PROM_RELATION_ID
            AND PR.PROM_RELATION_ID = #attributes.prom_rel_id#
    </cfquery>
    <cfquery name="GET_CAMPAIGN" datasource="#DSN3#">
        SELECT CAMP_ID,CAMP_HEAD,CAMP_FINISHDATE,CAMP_STARTDATE FROM CAMPAIGNS WHERE CAMP_FINISHDATE > #now()# ORDER BY CAMP_HEAD
    </cfquery>
     <cfif len(get_all_proms.camp_id)>
        <cfquery name="get_camp_name" datasource="#dsn3#">
            SELECT CAMP_HEAD,CAMP_STARTDATE,CAMP_FINISHDATE FROM CAMPAIGNS WHERE CAMP_ID = #get_all_proms.camp_id#
        </cfquery>
        <cfset camp_start_date=dateformat(date_add("H",session.ep.time_zone,get_camp_name.camp_startdate),'dd/mm/yyyy')>
        <cfset camp_finish_date=dateformat(date_add("H",session.ep.time_zone,get_camp_name.camp_finishdate),'dd/mm/yyyy')>
    </cfif>
    <cfset stock_id_list=''>
		<cfset free_stock_id_list=''>
        <cfoutput query="get_all_proms">
            <cfif len(stock_id) and not listfind(stock_id_list,stock_id)>
              <cfset stock_id_list=listappend(stock_id_list,stock_id)>
            </cfif>
            <cfif len(free_stock_id) and not listfind(free_stock_id_list,free_stock_id)>
              <cfset free_stock_id_list=listappend(free_stock_id_list,free_stock_id)>
            </cfif>
        </cfoutput>
        <cfif len(stock_id_list)>
            <cfset stock_id_list=listsort(stock_id_list,"numeric","ASC",",")>
            <cfquery name="get_pro_name" datasource="#DSN3#">
                SELECT STOCK_ID,PRODUCT_ID,PRODUCT_NAME FROM STOCKS WHERE STOCK_ID IN (#stock_id_list#) ORDER BY STOCK_ID
            </cfquery>	
            <cfset stock_id_list = listsort(listdeleteduplicates(valuelist(get_pro_name.STOCK_ID,',')),'numeric','ASC',',')>
        </cfif>
        <cfif len(free_stock_id_list)>
            <cfset free_stock_id_list=listsort(free_stock_id_list,"numeric","ASC",",")>
            <cfquery name="get_free_pro_name" datasource="#DSN3#">
                SELECT STOCK_ID,PRODUCT_ID,PRODUCT_NAME FROM STOCKS WHERE STOCK_ID IN (#free_stock_id_list#) ORDER BY STOCK_ID
            </cfquery>	
            <cfset free_stock_id_list = listsort(listdeleteduplicates(valuelist(get_free_pro_name.STOCK_ID,',')),'numeric','ASC',',')>
        </cfif>
<cfelseif isdefined("attributes.event") and attributes.event is 'add'>
	<cfif isdefined("attributes.prom_id") and Len(attributes.prom_id)>
        <cfinclude template="../product/query/get_prom.cfm">
        <cfset attributes.prom_head = get_prom.prom_head>
        <cfset attributes.camp_id = get_prom.camp_id>
        <cfset attributes.stock_id = get_prom.stock_id>
        <cfset attributes.target_due_date = dateformat(get_prom.target_due_date,'dd/mm/yyyy')>
    <cfelse>
        <cfset attributes.prom_head = "">
        <cfset attributes.target_due_date = "">
    </cfif>
    <cfquery name="PRICE_CATS" datasource="#DSN3#">
        SELECT
            PRICE_CATID,
            PRICE_CAT
        FROM
            PRICE_CAT
        WHERE
            PRICE_CAT_STATUS = 1
        <cfif isdefined("attributes.var_") and (attributes.var_ contains "store")>
            AND PRICE_CAT.BRANCH LIKE '%,#listgetat(session.ep.user_location,2,"-")#,%'
        </cfif>
        ORDER BY
            PRICE_CAT
    </cfquery>
    <cfquery name="get_roundnum" datasource="#dsn#">
        SELECT SALES_PRICE_ROUND_NUM FROM OUR_COMPANY_INFO WHERE COMP_ID=#session.ep.company_id#
    </cfquery>
    <cfset roundnum=get_roundnum.sales_price_round_num>
    <!--- <cfinclude template="../query/get_discount_types.cfm"> --->
    <cfinclude template="../product/query/get_money.cfm">
    <cfif isdefined("attributes.camp_id") and len(attributes.camp_id)>
        <cfquery name="get_camp_info" datasource="#dsn3#">
            SELECT CAMP_ID,CAMP_STARTDATE,CAMP_FINISHDATE,CAMP_HEAD FROM CAMPAIGNS WHERE CAMP_ID = #attributes.camp_id#
        </cfquery>
    </cfif>
    <cfif isdefined("attributes.prom_id") and Len(attributes.prom_id)>
        <cfset start_date_ = get_prom.startdate>
        <cfset finish_date_ = get_prom.finishdate>
        <cfset camp_id = get_prom.camp_id>
        <cfif Len(camp_id)>
            <cfset camp_head = '#get_camp_info.camp_head#(#dateformat(date_add("H",session.ep.time_zone,start_date_),'dd/mm/yyyy')#-#dateformat(date_add("H",session.ep.time_zone,finish_date_),'dd/mm/yyyy')#)'>
        <cfelse>
            <cfset camp_head = "">
        </cfif>
    <cfelseif isdefined("attributes.camp_id") and len(attributes.camp_id)>
        <cfset start_date_ = get_camp_info.camp_startdate>
        <cfset finish_date_ = get_camp_info.camp_finishdate>
        <cfset camp_id = get_camp_info.camp_id>
        <cfset camp_head = "#get_camp_info.camp_head#(#dateformat(date_add("H",session.ep.time_zone,start_date_),'dd/mm/yyyy')#-#dateformat(date_add("H",session.ep.time_zone,finish_date_),'dd/mm/yyyy')#)">
    <cfelse>
        <cfset start_date_ = "">
        <cfset finish_date_ = "">
        <cfset camp_id = "">
        <cfset camp_head = "">
    </cfif>
    <cfif len(start_date_)>
        <cfset start_hour_ = datepart("H",start_date_)>
        <cfset start_minute_ = datepart("N",start_date_)>
    <cfelse>
        <cfset start_date_ = "">
        <cfset start_hour_ = "">
        <cfset start_minute_ = "">
    </cfif>
    <cfif Len(finish_date_)>
        <cfset finish_hour_ = datepart("H",finish_date_)>
        <cfset finish_minute_ = datepart("N",finish_date_)>
    <cfelse>
        <cfset finish_date_ = "">
        <cfset finish_hour_ = "">
        <cfset finish_minute_ = "">
    </cfif>
    <cf_papers paper_type="promotion">
    <cfset str_link="&product_id=add_prom.pid"><cfif isdefined("attributes.from_promotion")><cfset str_link="&from_promotion=1"></cfif>
    <cfif isDefined("attributes.prom_id") and Len(attributes.prom_id) and Len(get_prom.product_catid)>
        <cfquery name="Get_Product_Cat" datasource="#dsn3#">
            SELECT PRODUCT_CAT FROM PRODUCT_CAT WHERE PRODUCT_CATID = #get_prom.product_catid#
        </cfquery>
    </cfif>
    <cfif isDefined("attributes.prom_id") and Len(attributes.prom_id) and Len(get_prom.brand_id)>
        <cfquery name="Get_Brand_Name" datasource="#dsn3#">
            SELECT BRAND_NAME FROM PRODUCT_BRANDS WHERE BRAND_ID = #get_prom.brand_id#
        </cfquery>
    </cfif>
     <cfif isDefined("attributes.stock_id") and Len(attributes.stock_id)>
        <cfquery name="PRODUCT_NAME" datasource="#DSN3#">
            SELECT
                STOCKS.STOCK_ID,
                STOCKS.PRODUCT_ID,
                PRODUCT.PRODUCT_NAME,
                STOCKS.PROPERTY,
                STOCKS.STOCK_CODE
            FROM
                PRODUCT,
                STOCKS
            WHERE
                STOCKS.STOCK_ID = #attributes.stock_id# AND
                STOCKS.PRODUCT_ID = PRODUCT.PRODUCT_ID
        </cfquery>
	</cfif>    
    <cfif isDefined("attributes.prom_id") and Len(attributes.prom_id) and Len(get_prom.free_stock_id)>
        <cfquery name="GET_STOCK_FREE" datasource="#DSN3#">
            SELECT
                P.PRODUCT_NAME,
                S.PROPERTY
            FROM
                STOCKS S,
                PRODUCT P
            WHERE
                S.PRODUCT_ID = P.PRODUCT_ID AND
                S.STOCK_ID = #get_prom.free_stock_id# 
        </cfquery>
        <cfset stock = "#get_stock_free.product_name# #get_stock_free.property#">
    <cfelse>
        <cfset stock = "">
    </cfif>
     <cfif isDefined("attributes.prom_id") and Len(attributes.prom_id) and Len(get_prom.coupon_id)>
        <cfquery name="get_coupon" datasource="#dsn3#">
            SELECT COUPON_NAME FROM COUPONS WHERE COUPON_ID = #get_prom.coupon_id#
        </cfquery>
    </cfif>
    <cfif isDefined("attributes.prom_id") and Len(attributes.prom_id)>
		<cfset prom_point_ = get_prom.prom_point>
    <cfelse>
        <cfset prom_point_ = "">
    </cfif>
     <cfif isDefined("attributes.prom_id") and Len(attributes.prom_id)>
		<cfset total_promotion_cost_ = TLFormat(get_prom.total_promotion_cost,roundnum)>
    <cfelse>
        <cfset total_promotion_cost_ = "">
    </cfif>
    <cfquery name="GET_ICON" datasource="#DSN3#">
        SELECT * FROM SETUP_PROMO_ICON
    </cfquery>
<cfelseif isdefined("attributes.event") and attributes.event is 'upd'>
	<cfset xml_page_control_list = 'is_conscat_segmentation,is_conscat_premium'>
    <cf_xml_page_edit page_control_list="#xml_page_control_list#" default_value="0" fuseact="product.form_upd_prom">
    <cfparam name="attributes.prom_type" default="">
    <cfquery name="PRICE_CATS" datasource="#DSN3#">
        SELECT
            PRICE_CATID,
            PRICE_CAT
        FROM
            PRICE_CAT
        WHERE
            PRICE_CAT_STATUS = 1
        <cfif isdefined("attributes.var_") and (attributes.var_ contains "store")>
            AND PRICE_CAT.BRANCH LIKE '%,#LISTGETAT(SESSION.EP.USER_LOCATION,2,"-")#,%'
        </cfif>
        ORDER BY
            PRICE_CAT
    </cfquery>
    <!--- <cfinclude template="../query/get_discount_types.cfm"> --->
    <cfinclude template="../product/query/get_prom.cfm">
    <cfinclude template="../product/query/get_money.cfm">
    <cfquery name="get_roundnum" datasource="#dsn#">
        SELECT SALES_PRICE_ROUND_NUM FROM OUR_COMPANY_INFO WHERE COMP_ID=#session.ep.company_id#
    </cfquery>
    <cfset roundnum=get_roundnum.sales_price_round_num>
    <cfset stock_id = get_prom.stock_id>
    <cfset str_link=""><cfif isdefined("attributes.from_promotion")><cfset str_link="&from_promotion=1"></cfif>
    <cfif len(get_prom.supplier_id)>
        <cfquery name="GET_COMPANY" datasource="#DSN#">
            SELECT NICKNAME FROM COMPANY WHERE COMPANY_ID = #get_prom.supplier_id#
        </cfquery>
    </cfif>
    <cfif len(get_prom.camp_id)>
        <cfquery name="get_camp_name" datasource="#dsn3#">
            SELECT CAMP_HEAD,CAMP_STARTDATE,CAMP_FINISHDATE FROM CAMPAIGNS WHERE CAMP_ID = #get_prom.camp_id#
        </cfquery>
        <cfset camp_start_date=dateformat(date_add("H",session.ep.time_zone,get_camp_name.camp_startdate),'dd/mm/yyyy')>
        <cfset camp_finish_date=dateformat(date_add("H",session.ep.time_zone,get_camp_name.camp_finishdate),'dd/mm/yyyy')>
    </cfif>
    <cfif len(get_prom.product_catid)>
		<cfset attributes.product_catid = get_prom.product_catid>
        <cfquery name="GET_PRODUCT_CAT" datasource="#DSN3#">
            SELECT PRODUCT_CATID,PRODUCT_CAT FROM PRODUCT_CAT WHERE PRODUCT_CATID = #attributes.product_catid#
        </cfquery>
    </cfif>
    <cfif len(get_prom.brand_id)>
        <cfquery name="GET_BRAND_NAME" datasource="#DSN3#">
            SELECT BRAND_NAME FROM PRODUCT_BRANDS WHERE BRAND_ID = #get_prom.brand_id#
        </cfquery>
    </cfif>
    <cfif len(get_prom.stock_id)>
        <cfquery name="PRODUCT_NAME" datasource="#DSN3#">
            SELECT
                STOCKS.STOCK_ID,
                STOCKS.PRODUCT_ID,
                PRODUCT.PRODUCT_NAME,
                STOCKS.PROPERTY,
                STOCKS.STOCK_CODE
            FROM
                PRODUCT,
                STOCKS
            WHERE
                STOCKS.STOCK_ID = #get_prom.stock_id# AND
                STOCKS.PRODUCT_ID = PRODUCT.PRODUCT_ID
        </cfquery>	
        <cfset attributes.stock_id = get_prom.stock_id>
        <cfset attributes.product_id = product_name.product_id>
    </cfif>
    <cfif len(get_prom.company_id)>
        <cfquery name="GET_COMPANY" datasource="#DSN#">
            SELECT NICKNAME FROM COMPANY WHERE COMPANY_ID = #get_prom.company_id#
        </cfquery>
    </cfif>
    <cfif len(get_prom.free_stock_id)>
        <cfquery name="GET_STOCK_FREE" datasource="#DSN3#">
            SELECT
                P.PRODUCT_NAME,
                S.PROPERTY
            FROM
                STOCKS S,
                PRODUCT P
            WHERE
                S.PRODUCT_ID = P.PRODUCT_ID AND
                S.STOCK_ID = #get_prom.free_stock_id# 
        </cfquery>
        <cfset stock = "#get_stock_free.product_name# #get_stock_free.property#">
    <cfelse>
        <cfset stock = "">
    </cfif>
    <cfif len(get_prom.amount_1_money)>
		<cfset get_prom_amount_1_money = get_prom.amount_1_money>
    <cfelse>
        <cfset get_prom_amount_1_money = session.ep.money>
    </cfif>
    <cfif len(get_prom.amount_2_money)>
		<cfset get_prom_amount_2_money = get_prom.amount_2_money>
    <cfelse>
        <cfset get_prom_amount_2_money = session.ep.money>
    </cfif>
    <cfif len(get_prom.coupon_id)>
        <cfquery name="GET_COUPON" datasource="#DSN3#">
            SELECT COUPON_NO,COUPON_NAME FROM COUPONS WHERE COUPON_ID = #get_prom.coupon_id#
        </cfquery>
    </cfif>
    <cfif len(get_prom.amount_discount_money_2)>
		<cfset get_prom_amount_discount_money_2 = get_prom.amount_discount_money_2>
    <cfelse>
        <cfset get_prom_amount_discount_money_2 = session.ep.money>
    </cfif>
    <cfif len(get_prom.amount_3_money)>
		<cfset get_prom_amount_3_money = get_prom.amount_3_money>
    <cfelse>
        <cfset get_prom_amount_3_money = session.ep.money>
    </cfif>
	<cfif len(get_prom.amount_4_money)>
		<cfset get_prom_amount_4_money = get_prom.amount_4_money>
    <cfelse>
        <cfset get_prom_amount_4_money = session.ep.money>
    </cfif>	
    <cfif len(get_prom.amount_5_money)>
		<cfset get_prom_amount_5_money = get_prom.amount_5_money>
    <cfelse>
        <cfset get_prom_amount_5_money = session.ep.money>
    </cfif>	
    <cfif len(get_prom.total_promotion_cost_money)>
		<cfset get_prom_total_promotion_cost_money = get_prom.total_promotion_cost_money>
    <cfelse>
        <cfset get_prom_total_promotion_cost_money = session.ep.money>
    </cfif>	
    <cfquery name="GET_ICON" datasource="#DSN3#">
        SELECT * FROM SETUP_PROMO_ICON 
    </cfquery>				
</cfif>  
<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
   <script type="text/javascript">
	   $(document).ready(function(){
		   $('#keyword').focus();
	   });		
		function upd_prom(deger,prom_id)
		{
			div_id = 'upd_prom'+prom_id;
			
		//  $('#prom_hierarchy'+prom_id) != undefined && $('#prom_hierarchy'+prom_id).val().length != '')
			
			if(document.getElementById('prom_hierarchy'+prom_id) != undefined && document.getElementById('prom_hierarchy'+prom_id).value.length != '')
			{
				var send_address = '<cfoutput>#request.self#</cfoutput>?fuseaction=product.emptypopup_upd_prom_hierarchy&prom_id='+ prom_id +'&deger='+deger;
				AjaxPageLoad(send_address,div_id,1);
			}
		}
		function connectAjax(crtrow,prom_id)
		{
			var bb = '<cfoutput>#request.self#</cfoutput>?fuseaction=product.emptypopup_dsp_promotion_detail<cfif isdefined("is_product_code_2") and is_product_code_2 eq 1>&is_product_code_2=1</cfif>&prom_id='+ prom_id;
			AjaxPageLoad(bb,'prom_detail_info'+crtrow,1);
		}
	</script>
<cfelseif isdefined("attributes.event") and attributes.event is 'addcollectedprom'>
	<script type="text/javascript">
		$(document).ready(function(){
			record_exist=0;//Row_kontrol değeri 1 olan yani silinmemiş satırların varlığını kontrol ediyor
		});				
        function kontrol()
        {
			unformat_fields();
            for(r=1;r<=add_prom.record_num.value;r++)
            {
                if(eval("document.add_prom.row_kontrol"+r).value == 1)
                {
                    record_exist=1;
                    if (eval("document.add_prom.product_id"+r).value == "" || eval("document.add_prom.product_name"+r).value == "")
                    { 
                        alert ("<cf_get_lang_main no ='313.Lütfen Ürün Seçiniz'> !");
                        return false;
                    }
                    if (eval("document.add_prom.prom_head"+r).value == "")
                    { 
                        alert ("<cf_get_lang no ='819.Lütfen Promosyon Başlığı Giriniz'> !");
                        return false;
                    }
                    if (eval("document.add_prom.start_date"+r).value == "")
                    { 
                        alert ("<cf_get_lang_main no ='326.Lütfen Başlangıç Tarihi Giriniz '>!");
                        return false;
                    }
                    if (eval("document.add_prom.finish_date"+r).value == "")
                    { 
                        alert ("<cf_get_lang_main no ='327.Lütfen Bitiş Tarihi Giriniz'> !");
                        return false;
                    }			
                    if (eval("document.add_prom.amount"+r).value == 0)
                    { 
                        alert ("<cf_get_lang_main no ='402.Lütfen Miktar Giriniz'>!");
                        return false;
                    }
                    if(eval("document.add_prom.percent_discount"+r).value == 0 && eval("document.add_prom.value_discount"+r).value == 0)
                    {
                        if (eval("document.add_prom.free_product_id"+r).value == "" || eval("document.add_prom.free_product_name"+r).value == "")
                        { 
                            alert ("<cf_get_lang no ='820.Lütfen Promosyon Ürünü Seçiniz veya İndirim Giriniz'>!");
                            return false;
                        }
                        if (eval("document.add_prom.free_amount"+r).value == 0)
                        { 
                            alert ("<cf_get_lang no ='824.Lütfen Promosyon Miktarı Giriniz'>!");
                            return false;
                        }
                    }
                }
            }
            if (record_exist == 0) 
                {
                    alert("<cf_get_lang no ='821.Lütfen Promosyon Giriniz'>!");
                    return false;
                }
            return process_cat_control();
            return true;
        }
        function sil(sy)
        {
            var my_element=eval("add_prom.row_kontrol"+sy);
            my_element.value=0;
            var my_element=eval("frm_row"+sy);
            my_element.style.display="none";
        }
    
        function copy_row(no)
        {
            row_count = document.add_prom.record_num.value;
            
            stock_id = eval('add_prom.stock_id' + no).value;
            product_id = eval('add_prom.product_id' + no).value;
            product_name = eval('add_prom.product_name' + no).value;
            prom_head = eval('add_prom.prom_head' + no).value;
            price_cat = eval('add_prom.price_cat' + no).value;
            start_date = eval('add_prom.start_date' + no).value;
            finish_date = eval('add_prom.finish_date' + no).value;
            amount = eval('add_prom.amount' + no).value;
            free_stock_id = eval('add_prom.free_stock_id' + no).value;
            free_product_id = eval('add_prom.free_product_id' + no).value;
            free_product_name = eval('add_prom.free_product_name' + no).value;
            free_amount = eval('add_prom.free_amount' + no).value;
            invoice_value = eval('add_prom.invoice_value' + no).value;
            cost_value = eval('add_prom.cost_value' + no).value;
            percent_discount = eval('add_prom.percent_discount' + no).value;
            value_discount = eval('add_prom.value_discount' + no).value;
            row_count++;
            var newRow;
            var newCell;
            newRow = document.getElementById("table1").insertRow(document.getElementById("table1").rows.length);
            newRow.setAttribute("name","frm_row" + row_count);
            newRow.setAttribute("id","frm_row" + row_count);		
            newRow.setAttribute("NAME","frm_row" + row_count);
            newRow.setAttribute("ID","frm_row" + row_count);		
            newRow.className = 'color-row';
            document.add_prom.record_num.value=row_count;
            newCell = newRow.insertCell(newRow.cells.length);
            newCell.setAttribute('nowrap','nowrap');
            newCell.innerHTML = '<input  type="hidden"  value="1"  name="row_kontrol' + row_count +'" ><a style="cursor:pointer" onclick="sil(' + row_count + ');" title="<cf_get_lang_main no="1559.Satır Sil">"><img  src="images/delete_list.gif" border="0"></a><a style="cursor:pointer" onclick="copy_row(' + row_count + ');" title="<cf_get_lang_main no="1560.Satır Kopyala">"><img  src="images/copy_list.gif" border="0"></a>';
            
            newCell = newRow.insertCell(newRow.cells.length);
            newCell.setAttribute('nowrap','nowrap');
            newCell.innerHTML = '<input type="hidden" name="product_id' + row_count +'" value="' + product_id + '"><input type="hidden" name="stock_id' + row_count +'" value="' + stock_id + '"><input type="text" style="width:140px;" name="product_name' + row_count +'" value="' + product_name + '"><a href="javascript://"> <img src="/images/plus_thin.gif" onclick="pencere_ac_product_detail('+ row_count +');" align="absmiddle" border="0"></a>';
            
            newCell = newRow.insertCell(newRow.cells.length);
            newCell.innerHTML = '<input type="text" name="prom_head' + row_count +'" style="width:120px;" maxlength="100" value="' + prom_head + '">';
            
            newCell = newRow.insertCell(newRow.cells.length);
            c = '<select name="price_cat' + row_count +'" style="width:200px;"><option value="-2" selected><cf_get_lang_main no="1309.Standart Satış"></option>';
            <cfoutput query="get_price_cats">
            if('#price_catid#' == price_cat)
                c += '<option value="#price_catid#" selected>#price_cat#</option>';
            else
                c += '<option value="#price_catid#">#price_cat#</option>';
            </cfoutput>
            newCell.innerHTML = c+ '</select>';
            
            newCell = newRow.insertCell(newRow.cells.length);
            newCell.setAttribute("id","start_date" + row_count + "_td");
            newCell.innerHTML = '<input type="text" name="start_date' + row_count +'" maxlength="10" style="width:70px;" value="'+start_date+'">&nbsp;';
            wrk_date_image('start_date' + row_count);
            
            newCell = newRow.insertCell(newRow.cells.length);
            newCell.setAttribute('nowrap','nowrap');
            newCell.setAttribute("id","finish_date" + row_count + "_td");
            newCell.innerHTML = '<input type="text" name="finish_date' + row_count +'" maxlength="10" style="width:70px;" value="'+finish_date+'">&nbsp;';
            wrk_date_image('finish_date' + row_count);
    
            newCell = newRow.insertCell(newRow.cells.length);
            newCell.setAttribute('nowrap','nowrap');
            newCell.innerHTML = '<input type="text" name="amount' + row_count +'" value="' + amount + '" onkeyup="return(FormatCurrency(this,event));" onBlur="if(this.value.length == 0 || filterNum(this.value)==0) this.value = \'1\';" style="width:100%;">';
            
            newCell = newRow.insertCell(newRow.cells.length);
            newCell.setAttribute('nowrap','nowrap');
            newCell.innerHTML = '<input type="hidden" name="free_product_id' + row_count +'" value="' + free_product_id + '"><input type="hidden" name="free_stock_id' + row_count +'" value="' + free_stock_id + '"> <input type="text" style="width:140px;" name="free_product_name' + row_count +'" value="' + free_product_name + '"><a href="javascript://"> <img src="/images/plus_thin.gif" onclick="pencere_ac_free_product('+ row_count +');" align="absmiddle" border="0"></a>';
            
            newCell = newRow.insertCell(newRow.cells.length);
            newCell.innerHTML = '<input type="text" name="free_amount' + row_count +'" value="' + free_amount + '" onkeyup="return(FormatCurrency(this,event));" style="width:100%;" onBlur="if(this.value.length == 0 || filterNum(this.value)==0) this.value = \'1\';">';
            
            newCell = newRow.insertCell(newRow.cells.length);
            newCell.innerHTML = '<input type="text" name="invoice_value' + row_count +'" value="' + invoice_value + '" onkeyup="return(FormatCurrency(this,event));" style="width:85px;" onBlur="if(this.value.length == 0 || filterNum(this.value)==0) this.value = \'0\';">';
            
            newCell = newRow.insertCell(newRow.cells.length);
            newCell.innerHTML = '<input type="text" name="cost_value' + row_count +'" value="' + cost_value + '" onkeyup="return(FormatCurrency(this,event));" style="width:85px;" onBlur="if(this.value.length == 0 || filterNum(this.value)==0) this.value = \'0\';">';
            
            newCell = newRow.insertCell(newRow.cells.length);
            newCell.innerHTML = '<input type="text" name="percent_discount' + row_count +'" value="' + percent_discount + '" onkeyup="return(FormatCurrency(this,event));" style="width:85px;" onBlur="if(this.value.length == 0 || filterNum(this.value)==0) this.value = \'0\';">';
            
            newCell = newRow.insertCell(newRow.cells.length);
            newCell.innerHTML = '<input type="text" name="value_discount' + row_count +'" value="' + value_discount + '" onkeyup="return(FormatCurrency(this,event));" style="width:85px;" onBlur="if(this.value.length == 0 || filterNum(this.value)==0) this.value = \'0\';">';
        }
        function pencere_ac_product_detail(no)
        {
            pid = eval('add_prom.product_id'+no).value;
            windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_detail_product&pid='+pid,'list');
        }
        //ust kisimdan secilen- girilen degerlerin satirlara kopyalanmasini saglar
        function order_copy(nesne)
        {
            if(document.add_prom.record_num.value > 0)
            {
                var number = document.add_prom.record_num.value;
                for(var k=1;k<=number;k++)
                    eval("document.add_prom."+nesne+k).value = eval("document.add_prom."+nesne).value;
                    
                return false;
            }
        }
        function copy_startdate()
        {
            order_copy('start_date');
        }
        function copy_finishdate()
        {
            order_copy('finish_date');
        }
        
        function pencere_ac_product(no)
        {
            if(document.add_prom.camp_id.value!='')
                camp_ = '&camp_id='+document.add_prom.camp_id.value;
            else
                camp_ = '';
            windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_product_names&is_collacted_prom=1&is_form_submitted=1</cfoutput>&record_num='+document.add_prom.record_num.value + camp_,'list');
        }	
        
        function pencere_ac_free_product(no)
        {
            windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&field_id=add_prom.free_stock_id' + no +'&field_name=add_prom.free_product_name' + no +'&product_id=add_prom.free_product_id' + no +'&field_calistir=1','list');
        }
        
        function add_free_product(no)
        {
            eval('add_prom.free_stock_id' + no).value = eval('add_prom.stock_id' + no).value;
            eval('add_prom.free_product_id' + no).value = eval('add_prom.product_id' + no).value;
            eval('add_prom.free_product_name' + no).value = eval('add_prom.product_name' + no).value;
        }
        
        function unformat_fields()
        {
            for(r=1;r<=add_prom.record_num.value;r++)
            {
                deger_miktar = eval("document.add_prom.amount"+r);
                deger_pro_miktar= eval("document.add_prom.free_amount"+r);
                deger_value = eval("document.add_prom.invoice_value"+r);
                deger_cost_value = eval("document.add_prom.cost_value"+r);
                deger_percent_discount = eval("document.add_prom.percent_discount"+r);
                deger_value_discount = eval("document.add_prom.value_discount"+r);
                
                deger_miktar.value = filterNum(deger_miktar.value);
                deger_pro_miktar.value = filterNum(deger_pro_miktar.value);
                deger_value.value = filterNum(deger_value.value);
                deger_cost_value.value = filterNum(deger_cost_value.value);
                deger_percent_discount.value = filterNum(deger_percent_discount.value);
                deger_value_discount.value = filterNum(deger_value_discount.value);
            }
        }
    </script>
<cfelseif isdefined("attributes.event") and attributes.event is 'updcollectedprom'>
	<script type="text/javascript">
		$(document).ready(function(){
			record_exist=0;//Row_kontrol değeri 1 olan yani silinmemiş satırların varlığını kontrol ediyor		
		});
		function deneme(){
			row_count = document.upd_prom.record_num.value;		
			for(r=1;r<=row_count;r++){
			<!---$('#free_product_name'+r).val($('#free_product_name').val());--->
			$( "input[name$='free_product_name"+r+"']").val($('#free_product_name').val());	
			}
		}
		function kontrol()
		{
			unformat_fields();
			for(r=1;r<=upd_prom.record_num.value;r++)
			{
				if(eval("document.upd_prom.row_kontrol"+r).value == 1)
				{
					record_exist=1;
					if (eval("document.upd_prom.product_id"+r).value == "" || eval("document.upd_prom.product_name"+r).value == "")
					{ 
						alert ("<cf_get_lang_main no ='313.Lütfen Ürün Seçiniz'> !");
						return false;
					}
					if (eval("document.upd_prom.prom_head"+r).value == "")
					{ 
						alert ("<cf_get_lang no ='819.Lütfen Promosyon Başlığı Giriniz'> !");
						return false;
					}
					if ((eval("document.upd_prom.start_date"+r).value == ""))
					{ 
						alert ("<cf_get_lang_main no ='326.Lütfen Başlangıç Tarihi Giriniz'> !");
						return false;
					}
					if ((eval("document.upd_prom.finish_date"+r).value == ""))
					{ 
						alert ("<cf_get_lang_main no ='327.Lütfen Bitiş Tarihi Giriniz'> !");
						return false;
					}			
					if (eval("document.upd_prom.amount"+r).value == 0)
					{ 
						alert ("<cf_get_lang no ='402.Lütfen Miktar Giriniz'>!");
						return false;
					}
					if(eval("document.upd_prom.percent_discount"+r).value == 0 && eval("document.upd_prom.value_discount"+r).value == 0)
					{
						if (eval("document.upd_prom.free_product_id"+r).value == "" || eval("document.upd_prom.free_product_name"+r).value == "")
						{ 
							alert ("<cf_get_lang no ='845.Lütfen Promosyon Ürünü Seçiniz'> !");
							return false;
						}
						if (eval("document.upd_prom.free_amount"+r).value == 0)
						{ 
							alert ("<cf_get_lang no ='824.Lütfen Promosyon Miktarı Giriniz'>!");
							return false;
						}
					}
				}
			}
			if (record_exist == 0) 
				{
					alert("<cf_get_lang no ='821.Lütfen Promosyon Giriniz'>!");
					return false;
				}
			return process_cat_control();
			return true;
		}
		function unformat_fields()
		{
			for(r=1;r<=upd_prom.record_num.value;r++)
			{
				deger_miktar = eval("document.upd_prom.amount"+r);
				deger_pro_miktar= eval("document.upd_prom.free_amount"+r);
				deger_value = eval("document.upd_prom.invoice_value"+r);
				deger_cost_value = eval("document.upd_prom.cost_value"+r);
				deger_percent_discount = eval("document.upd_prom.percent_discount"+r);
	
	
				deger_value_discount = eval("document.upd_prom.value_discount"+r);
				
				deger_miktar.value = filterNum(deger_miktar.value);
				deger_pro_miktar.value = filterNum(deger_pro_miktar.value);
				deger_value.value = filterNum(deger_value.value);
				deger_cost_value.value = filterNum(deger_cost_value.value);
				deger_percent_discount.value = filterNum(deger_percent_discount.value);
				deger_value_discount.value = filterNum(deger_value_discount.value);
			}
		}
		
		function sil(sy)
		{
			var my_element=eval("upd_prom.row_kontrol"+sy);
			my_element.value=0;
			var my_element=eval("frm_row"+sy);
			my_element.style.display="none";
		}
		function copy_row(no)
		{
			row_count = document.upd_prom.record_num.value;
			
			stock_id = eval('upd_prom.stock_id' + no).value;
			product_id = eval('upd_prom.product_id' + no).value;
			product_name = eval('upd_prom.product_name' + no).value;
			prom_head = eval('upd_prom.prom_head' + no).value;
			price_cat = eval('upd_prom.price_cat' + no).value;
			start_date = eval('upd_prom.start_date' + no).value;
			finish_date = eval('upd_prom.finish_date' + no).value;
			amount = eval('upd_prom.amount' + no).value;
			free_stock_id = eval('upd_prom.free_stock_id' + no).value;
			free_product_id = eval('upd_prom.free_product_id' + no).value;
			free_product_name = eval('upd_prom.free_product_name' + no).value;
			free_amount = eval('upd_prom.free_amount' + no).value;
			invoice_value = eval('upd_prom.invoice_value' + no).value;
			cost_value = eval('upd_prom.cost_value' + no).value;
			percent_discount = eval('upd_prom.percent_discount' + no).value;
			value_discount = eval('upd_prom.value_discount' + no).value;
			row_count++;
			var newRow;
			var newCell;
			newRow = document.getElementById("table1").insertRow(document.getElementById("table1").rows.length);
			newRow.setAttribute("name","frm_row" + row_count);
			newRow.setAttribute("id","frm_row" + row_count);		
			newRow.setAttribute("NAME","frm_row" + row_count);
			newRow.setAttribute("ID","frm_row" + row_count);		
			newRow.className = 'color-row';
			document.upd_prom.record_num.value=row_count;
			newCell = newRow.insertCell();
			newCell.innerHTML = '<input type="hidden" value="0" name="prom_id' + row_count +'"><input  type="hidden"  value="1"  name="row_kontrol' + row_count +'"><a style="cursor:pointer" onclick="sil(' + row_count + ');" title="<cf_get_lang_main no="1559.Satır Sil">"><img  src="images/delete_list.gif" border="0"></a><a style="cursor:pointer" onclick="copy_row(' + row_count + ');" title="<cf_get_lang_main no="1560.Satır Kopyala">"><img  src="images/copy_list.gif" border="0"></a>';
			
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute('nowrap','nowrap');
			newCell.innerHTML = '<input type="hidden" name="product_id' + row_count +'" value="' + product_id + '"><input type="hidden" name="stock_id' + row_count +'" value="' + stock_id + '"><input type="text" style="width:140px;" name="product_name' + row_count +'" value="' + product_name + '"><a href="javascript://"> <img src="/images/plus_thin.gif" onclick="pencere_ac_product_detail('+ row_count +');" align="absmiddle" border="0"></a>';
			
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="text" name="prom_head' + row_count +'" style="width:120px;" maxlength="100" value="' + prom_head + '">';
			
			newCell = newRow.insertCell(newRow.cells.length);
			c = '<select name="price_cat' + row_count +'" style="width:200px;"><option value="-2" selected><cf_get_lang_main no="1309.Standart Satış"></option>';
			<cfoutput query="get_price_cats">
			if('#price_catid#' == price_cat)
				c += '<option value="#price_catid#" selected>#price_cat#</option>';
			else
				c += '<option value="#price_catid#">#price_cat#</option>';
			</cfoutput>
			newCell.innerHTML = c+ '</select>';
			
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("id","start_date" + row_count + "_td");
			newCell.innerHTML = '<input type="text" name="start_date' + row_count +'" maxlength="10" style="width:70px;" value="'+start_date+'">&nbsp;';
			wrk_date_image('start_date' + row_count);
			
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("id","finish_date" + row_count + "_td");
			newCell.innerHTML = '<input type="text" name="finish_date' + row_count +'" maxlength="10" style="width:70px;" value="'+finish_date+'">&nbsp;';
			wrk_date_image('finish_date' + row_count);
	
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="text" name="amount' + row_count +'" value="' + amount + '" onkeyup="return(FormatCurrency(this,event));" onBlur="if(this.value.length == 0 || filterNum(this.value)==0) this.value = \'1\';" style="width:100%;">';
			
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="hidden" id="free_product_id' + row_count +'" name="free_product_id' + row_count +'" value="' + free_product_id + '"><input type="hidden" id="free_stock_id' + row_count +'" name="free_stock_id' + row_count +'" value="' + free_stock_id + '"><input type="text" style="width:140px;" id="free_product_name' + row_count +'" name="free_product_name' + row_count +'" value="' + free_product_name + '">&nbsp;<a href="javascript://"><img src="/images/plus_thin.gif" onclick="pencere_ac_free_product('+ row_count +');" align="absmiddle" border="0"></a>';
			
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="text" name="free_amount' + row_count +'" value="' + free_amount + '" onkeyup="return(FormatCurrency(this,event));" style="width:100%;" onBlur="if(this.value.length == 0 || filterNum(this.value)==0) this.value = \'1\';">';
			
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="text" name="invoice_value' + row_count +'" value="' + invoice_value + '" onkeyup="return(FormatCurrency(this,event));" style="width:85px;" onBlur="if(this.value.length == 0 || filterNum(this.value)==0) this.value = \'0\';">';
			
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="text" name="cost_value' + row_count +'" value="' + cost_value + '" onkeyup="return(FormatCurrency(this,event));" style="width:85px;" onBlur="if(this.value.length == 0 || filterNum(this.value)==0) this.value = \'0\';">';
			
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="text" name="percent_discount' + row_count +'" value="' + percent_discount + '" onkeyup="return(FormatCurrency(this,event));" style="width:85px;" onBlur="if(this.value.length == 0 || filterNum(this.value)==0) this.value = \'0\';">';
			
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="text" name="value_discount' + row_count +'" value="' + value_discount + '" onkeyup="return(FormatCurrency(this,event));" style="width:85px;" onBlur="if(this.value.length == 0 || filterNum(this.value)==0) this.value = \'0\';">';
		}
		function pencere_ac_product(no)
		{
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&field_id=upd_prom.stock_id' + no +'&field_name=upd_prom.product_name' + no +'&product_id=upd_prom.product_id' + no +'&field_calistir=1&run_function=add_free_product&run_function_param=' + no +'','list');
		}
		function pencere_ac_product_detail(no)
		{
			pid = eval('upd_prom.product_id'+no).value;
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_detail_product&pid='+pid,'list');
		}
		function pencere_ac_free_product(no)
		{
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&field_id=upd_prom.free_stock_id' + no +'&field_name=upd_prom.free_product_name' + no +'&product_id=upd_prom.free_product_id' + no +'&field_calistir=1','list');
		}
		function add_free_product(no)
		{
			eval('upd_prom.free_stock_id' + no).value = eval('upd_prom.stock_id' + no).value;
			eval('upd_prom.free_product_id' + no).value = eval('upd_prom.product_id' + no).value;
			eval('upd_prom.free_product_name' + no).value = eval('upd_prom.product_name' + no).value;
		}
		function pencere_ac_product(no)
		{
			if(document.upd_prom.camp_id.value!='')
				camp_ = '&camp_id='+document.upd_prom.camp_id.value;
			else
				camp_ = '';
			windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_product_names&is_collacted_prom=1&is_form_submitted=1&prom_rel_id=#attributes.prom_rel_id#&record_num='+document.upd_prom.record_num.value+'</cfoutput>'+camp_,'list');
		}
		function order_copy(nesne)
		{
			if(document.upd_prom.record_num.value > 0)
			{
				var number = document.upd_prom.record_num.value;
				for(var k=1;k<=number;k++)
					eval("document.upd_prom."+nesne+k).value = eval("document.upd_prom."+nesne).value;
					
				return false;
			}
		}
		function copy_startdate()
		{
			order_copy('start_date');
		}
		function copy_finishdate()
		{
			order_copy('finish_date');
		}
	</script>
<cfelseif isdefined("attributes.event") and attributes.event is 'add'>
	<script type="text/javascript">
        function degistir()
        {
            if(document.add_prom.limit_type.value==2)
                document.getElementById('limit_currency').style.display = '';
            else
                document.getElementById('limit_currency').style.display = 'none';
        }
        function hesapla()
        {	
            var t1 = parseFloat(filterNum(add_prom.amount_discount_2.value,4));
            var t2 = parseFloat(filterNum(add_prom.amount_1.value,4));
            var t3 = parseFloat(filterNum(add_prom.amount_2.value,4));
            var t4 = parseFloat(filterNum(add_prom.amount_3.value,4));
            var t5 = parseFloat(filterNum(add_prom.amount_4.value,4));
            var t6 = parseFloat(filterNum(add_prom.amount_5.value,4));
            if (isNaN(t1)) {t1 = 0; add_prom.amount_discount_2.value = 0;}
            if (isNaN(t2)) {t2 = 0; add_prom.amount_1.value = 0;}
            if (isNaN(t3)) {t3 = 0; add_prom.amount_2.value = 0;}
            if (isNaN(t4)) {t4 = 0; add_prom.amount_3.value = 0;}
            if (isNaN(t5)) {t5 = 0; add_prom.amount_4.value = 0;}
            if (isNaN(t6)) {t6 = 0; add_prom.amount_5.value = 0;}
        
            
            t1 = t1 * eval('add_prom.money_'+add_prom.amount_discount_money_2.value).value;
            t2 = t2 * eval('add_prom.money_'+add_prom.amount_1_money.value).value;
            t3 = t3 * eval('add_prom.money_'+add_prom.amount_2_money.value).value;
            t4 = t4 * eval('add_prom.money_'+add_prom.amount_3_money.value).value;
            t5 = t5 * eval('add_prom.money_'+add_prom.amount_4_money.value).value;
            t6 = t6 * eval('add_prom.money_'+add_prom.amount_5_money.value).value;
            order_total = t2+t3+t4+t5+t6-t1;
            add_prom.total_promotion_cost.value = commaSplit(order_total,4);
        }	
        function unformat_fields()
        {
            add_prom.limit_value.value = filterNum(add_prom.limit_value.value);
            add_prom.TOTAL_AMOUNT.value = filterNum(add_prom.TOTAL_AMOUNT.value);
            add_prom.discount_1.value = filterNum(add_prom.discount_1.value);
            add_prom.amount_discount_1.value = filterNum(add_prom.amount_discount_1.value,4);
            add_prom.amount_discount_2.value = filterNum(add_prom.amount_discount_2.value,4);
            add_prom.amount_1.value = filterNum(add_prom.amount_1.value);
            add_prom.amount_2.value = filterNum(add_prom.amount_2.value);
            add_prom.amount_3.value = filterNum(add_prom.amount_3.value);
            add_prom.amount_4.value = filterNum(add_prom.amount_4.value);
            add_prom.amount_5.value = filterNum(add_prom.amount_5.value);
            add_prom.free_stock_price.value = filterNum(add_prom.free_stock_price.value);
            add_prom.gift_price.value = filterNum(add_prom.gift_price.value);
            add_prom.free_stock_amount.value = filterNum(add_prom.free_stock_amount.value);
            add_prom.gift_amount.value = filterNum(add_prom.gift_amount.value);
            add_prom.total_promotion_cost.value = filterNum(add_prom.total_promotion_cost.value);
            add_prom.prim_percent.value = filterNum(add_prom.prim_percent.value);
            add_prom.total_promotion_cost_money.disabled = false;
        }	
        function form_kontrol()
        {
			unformat_fields();	
            if(	document.add_prom.discount_1.value=="" && document.add_prom.amount_discount_1.value== "" && 
                document.add_prom.prim_percent.value == "" && document.add_prom.free_stock_id.value == "" && 
                document.add_prom.prom_point.value == "" &&  document.add_prom.gift_head.value == "" && 
                document.add_prom.amount_discount_2.value == "")
            { 
                alert ("<cf_get_lang no ='834.Hiçbir Promosyon Koşulu Girmediniz'> !");
                return false;
            }	
            if(document.add_prom.limit_value.value == "")
            {
                alert("<cf_get_lang_main no='332.Alışveriş Miktarı girmelisiniz'>!");
                return false;
            }	
            if('<cfoutput>#session.ep.our_company_info.workcube_sector#</cfoutput>' =='per')
            {
                if(document.add_prom.free_product.value == "" && (document.add_prom.discount_1.value == "" && document.add_prom.amount_discount_1.value =="") )
                {
                    alert ("<cf_get_lang no ='835.Anında İndirim Bölümüne İndirim Yüzdesi yada Tutarı Girmelisiniz'> !");
                    return false;	
                }
            }	
            if(document.add_prom.discount_1.value != "")
            {
                if(filterNum(add_prom.discount_1.value) > 100 || filterNum(add_prom.discount_1.value) < 0)
                {
                    alert("<cf_get_lang no ='836.İskonto Yüzdesi 0 ile 100 Arasında Olmalıdır'> !");
                    return false;
                }
            }		
            if(time_check(add_prom.startdate, add_prom.start_clock, add_prom.start_minute, add_prom.finishdate,  add_prom.finish_clock, add_prom.finish_minute, "<cf_get_lang no ='837.Promosyon Başlama Tarihi Bitiş Tarihinden Önce Olmalıdır'> !"))
                return process_cat_control();
            else
                return false;
			
			return true;
        }	
        function butonlari_goster()
        {
            butonlar.style.display = '';
        }
    <cfif isDefined("attributes.stock_id")>
        function sayfa_ac(sayfa_type)
        {
            <cfoutput>
                pid = document.getElementById('pid').value;
                if(pid != '')
                {
                    if(sayfa_type==1)
                        windowopen('#request.self#?fuseaction=product.popup_product_contract&pid='+pid,'project');
                    else
                        windowopen('#request.self#?fuseaction=product.popup_product_cost&pid='+pid,'list');
                }
            </cfoutput>
        }
    </cfif>
        
        function empty_target_due_date(deger)
        {
            if (deger==1)
                document.add_prom.target_due_date.value='';
            else
                document.add_prom.due_day.value='';
        }
        function add_camp_date(start_hour,start_minute,finish_hour,finish_minute)
        {
            count = 0;
            for(kk=1;kk<=24;kk++)
            {
                if(start_hour == kk)
                    document.add_prom.start_clock.options[count].selected = true;
                if(finish_hour == kk)
                    document.add_prom.finish_clock.options[count].selected = true;

                count++;
            }
            count = 0;
            for(jj=00;jj<=55;jj=jj+5)
            {
                if(start_minute == jj)
                    document.add_prom.start_minute.options[count].selected = true;
                if(finish_minute == jj)
                    document.add_prom.finish_minute.options[count].selected = true;
                count++;
            }
        }
    </script>
<cfelseif isdefined("attributes.event") and attributes.event is 'upd'>
    <script type="text/javascript">
		function degistir()
		{
			if(document.upd_prom.limit_type.value==2)
				goster(currency_change);
			else
				gizle(currency_change);
		}
		function hesapla()
		{	
			var t1 = parseFloat(filterNum(upd_prom.amount_discount_2.value,4));
			var t2 = parseFloat(filterNum(upd_prom.amount_1.value,4));
			var t3 = parseFloat(filterNum(upd_prom.amount_2.value,4));
			var t4 = parseFloat(filterNum(upd_prom.amount_3.value,4));
			var t5 = parseFloat(filterNum(upd_prom.amount_4.value,4));
			var t6 = parseFloat(filterNum(upd_prom.amount_5.value,4));
			if (isNaN(t1)) {t1 = 0; upd_prom.amount_discount_2.value = 0;}
			if (isNaN(t2)) {t2 = 0; upd_prom.amount_1.value = 0;}
			if (isNaN(t3)) {t3 = 0; upd_prom.amount_2.value = 0;}
			if (isNaN(t4)) {t4 = 0; upd_prom.amount_3.value = 0;}
			if (isNaN(t5)) {t5 = 0; upd_prom.amount_4.value = 0;}
			if (isNaN(t6)) {t6 = 0; upd_prom.amount_5.value = 0;}
			t1 = t1 * eval('upd_prom.money_'+upd_prom.amount_discount_money_2.value).value;
			t2 = t2 * eval('upd_prom.money_'+upd_prom.amount_1_money.value).value;
			t3 = t3 * eval('upd_prom.money_'+upd_prom.amount_2_money.value).value;
			t4 = t4 * eval('upd_prom.money_'+upd_prom.amount_3_money.value).value;
			t5 = t5 * eval('upd_prom.money_'+upd_prom.amount_4_money.value).value;
			t6 = t6 * eval('upd_prom.money_'+upd_prom.amount_5_money.value).value;
			order_total = t2+t3+t4+t5+t6-t1;
			upd_prom.total_promotion_cost.value = commaSplit(order_total,4);
		}
		function unformat_fields()
		{	
			upd_prom.limit_value.value = filterNum(upd_prom.limit_value.value);
			upd_prom.TOTAL_AMOUNT.value = filterNum(upd_prom.TOTAL_AMOUNT.value);
			upd_prom.discount_1.value = filterNum(upd_prom.discount_1.value);
			upd_prom.amount_discount_1.value = filterNum(upd_prom.amount_discount_1.value,4);
			upd_prom.amount_discount_2.value = filterNum(upd_prom.amount_discount_2.value,4);
			upd_prom.amount_1.value = filterNum(upd_prom.amount_1.value);
			upd_prom.amount_2.value = filterNum(upd_prom.amount_2.value);
			upd_prom.amount_3.value = filterNum(upd_prom.amount_3.value);
			upd_prom.amount_4.value = filterNum(upd_prom.amount_4.value);
			upd_prom.amount_5.value = filterNum(upd_prom.amount_5.value);
			upd_prom.free_stock_price.value = filterNum(upd_prom.free_stock_price.value);
			upd_prom.gift_price.value = filterNum(upd_prom.gift_price.value);
			upd_prom.free_stock_amount.value = filterNum(upd_prom.free_stock_amount.value);
			upd_prom.gift_amount.value = filterNum(upd_prom.gift_amount.value);
			upd_prom.total_promotion_cost.value = filterNum(upd_prom.total_promotion_cost.value);
			upd_prom.prim_percent.value = filterNum(upd_prom.prim_percent.value);
			upd_prom.total_promotion_cost_money.disabled = false;
		}
		function form_kontrol()
		{		
			unformat_fields();
			if(	document.upd_prom.discount_1.value=="" && document.upd_prom.discount_1.value=="" &&
				document.upd_prom.prim_percent.value == "" && document.upd_prom.free_stock_id.value == "" &&
				document.upd_prom.prom_point.value == "" &&	document.upd_prom.gift_head.value == "" &&
				document.upd_prom.amount_discount_1.value == "" && document.upd_prom.amount_discount_2.value == "")
			{ 
				alert ("<cf_get_lang no ='834.Hiçbir Promosyon Koşulu Girmediniz'> !");
				return false;
			}
			
			if(document.upd_prom.amount_discount_1.value != '' && (document.upd_prom.product_id.value=='' || document.upd_prom.product_name.value==''))
			{
				alert("<cf_get_lang no ='846.Tutar İndirimi Uygulanacak Ürünü Seçiniz'>!");
				return false;
			}
			
			if(document.upd_prom.limit_value.value == "")
			{
				alert("<cf_get_lang_main no='332.Alışveriş Miktarı girmelisiniz'>!");
				return false;
			}
			
			if('<cfoutput>#session.ep.our_company_info.workcube_sector#</cfoutput>' =='per')
			{
				if(document.upd_prom.free_product.value == "" && (document.upd_prom.discount_1.value == "" && document.upd_prom.amount_discount_1.value =="") )
				{
					alert ("<cf_get_lang no ='835.Anında İndirim Bölümüne İndirim Yüzdesi yada Tutarı Girmelisiniz'> !");
					return false;	
				}	
			}
			
			if(document.upd_prom.discount_1.value != "")
			{
				if(filterNum(document.upd_prom.discount_1.value) > 100 || filterNum(document.upd_prom.discount_1.value) < 0)
				{
					alert("<cf_get_lang no ='836.İskonto Yüzdesi 0 ile 100 Arasında Olmalıdır'> !");
					return false;
				}
			}	
			if(time_check(upd_prom.startdate, upd_prom.start_clock, upd_prom.start_minute, upd_prom.finishdate,  upd_prom.finish_clock, upd_prom.finish_minute, "<cf_get_lang no ='837.Promosyon Başlama Tarihi Bitiş Tarihinden Önce Olmalıdır'> !"))
				return process_cat_control();
			else
				return false;
		return true;
		}
		function sayfa_ac(sayfa_type)
		{
			<cfoutput>
			pid = upd_prom.product_id.value;
			if(pid != '')
				if(sayfa_type==1)
					windowopen('#request.self#?fuseaction=product.popup_product_contract&pid='+pid,'project');
		   </cfoutput>
		}
		function empty_target_due_date(deger)
		{
			if (deger==1)
				document.upd_prom.target_due_date.value='';
			else
				document.upd_prom.due_day.value='';
		}
		function empty_product_brand()
		{	
			document.upd_prom.brand_name.value='';
			document.upd_prom.product_catid.value='';
			document.upd_prom.brand_id.value='';
			document.upd_prom.product_cat.value='';
		} 	
		function add_camp_date(start_hour,start_minute,finish_hour,finish_minute)
		{
			count = 0;
			for(kk=1;kk<=24;kk++)
			{
				if(start_hour == kk)
					document.upd_prom.start_clock.options[count].selected = true;
				if(finish_hour == kk)
					document.upd_prom.finish_clock.options[count].selected = true;
				count++;
			}
			count = 0;
			for(jj=00;jj<=55;jj=jj+5)
			{
				if(start_minute == jj)
					document.upd_prom.start_minute.options[count].selected = true;
				if(finish_minute == jj)
					document.upd_prom.finish_minute.options[count].selected = true;
				count++;
			}
		}
	</script>
<cfelseif isdefined("attributes.event") and attributes.event is 'adddetprom'>
	<script type="text/javascript">
		$(document).ready(function(){
			 row_count= 0;
        	 row_count1 = 0;
			   row_count3= 0;
		});
       
        function control_member()
        {
            if(document.getElementById('consumer_ref_prom').checked == true)
            {
                document.getElementById('member_td_1').style.display='';
                document.getElementById('member_td_2').style.display='';
            }
            else
            {
                document.getElementById('member_td_1').style.display='none';
                document.getElementById('member_td_2').style.display='none';
            }
        }
        function del_condition(row_id)
        {	
            document.getElementById('condition'+row_id).style.display = 'none';
            // $('#row_control_prom_'+row_id).val()=0
            document.getElementById('row_control_prom_'+row_id).value=0;
        }
        function add_condition()
        {	
		
            row_count+=1;
            $('#record_num').val(row_count);
            //document.getElementById('record_num').value = row_count;
            var my_obj = document.createElement('div');
            my_obj.innerHTML='<tr height="25"><td colspan="6"><div id="condition'+row_count+'"></div></td></tr>';
            document.getElementById('table2').appendChild(my_obj);
            AjaxPageLoad('<cfoutput>#request.self#?fuseaction=product.emptypopup_form_add_prom_condition&row_id='+row_count+'</cfoutput><cfif isdefined("is_product_code_2") and is_product_code_2 eq 1>&is_product_code_2=1</cfif>','condition'+row_count+'');
        
		}
        function sil1(sy)
        {
            var my_element=eval("document.getElementById('row_kontrol1" + sy + "')");
            my_element.value=0;
            var my_element=eval("frm_row_product"+sy);
            my_element.style.display="none";
        }
        function add_product(product_id,stock_id,product_name,stock_code,page_no,profit_margin)
        {
            if(product_id == undefined)
                product_id = '';
            if(stock_id == undefined)
                stock_id = '';
            if(product_name == undefined)
                product_name = '';
            if(stock_code == undefined)
                stock_code = '';
            if(page_no == undefined)
                page_no = '';
            if(profit_margin == undefined)
                profit_margin = 0;
            row_count1++;
            var newRow;
            var newCell;
            newRow = document.getElementById("table_product").insertRow(document.getElementById("table_product").rows.length);
            newRow.setAttribute("name","frm_row_product" + row_count1);
            newRow.setAttribute("id","frm_row_product" + row_count1);
            document.add_prom.record_num1.value=row_count1;
            newCell = newRow.insertCell(newRow.cells.length);
            newCell.innerHTML = '';
            newCell = newRow.insertCell(newRow.cells.length);
            newCell.innerHTML = '<input type="hidden" name="row_kontrol1'+row_count1+'" id="row_kontrol1'+row_count1+'" value="1"><a style="cursor:pointer" onclick="sil1(' + row_count1 + ');"><img  src="images/delete_list.gif" border="0"></a>';
            newCell = newRow.insertCell(newRow.cells.length);
            newCell.innerHTML = '<input type="text" name="stock_code' + row_count1 +'" id="stock_code' + row_count1 +'" class="text" style="width:60px;" readonly value='+stock_code+'>';
            newCell.innerHTML = '<input type="text" name="stock_code' + row_count1 +'" id="stock_code' + row_count1 +'" class="text" style="width:60px;" readonly value=' + stock_code + '>';
            newCell = newRow.insertCell(newRow.cells.length);	
            newCell.setAttribute('nowrap','nowrap');																																																										
            newCell.innerHTML = '<input  type="hidden" name="product_id' + row_count1 +'" id="product_id' + row_count1 +'"  value="'+product_id+'"><input  type="hidden" name="stock_id' + row_count1 +'" id="stock_id' + row_count1 +'" value="'+stock_id+'"><input type="text" name="product_name' + row_count1 +'" id="product_name' + row_count1 +'" class="text" style="width:100px;" value="'+product_name+'" onFocus="AutoComplete_Create(\'product_name' + row_count1 +'\',\'<cfif isdefined("is_product_code_2") and is_product_code_2 eq 1>STOCK_CODE_2<cfelse>STOCK_CODE</cfif>,PRODUCT_NAME\',\'<cfif isdefined("is_product_code_2") and is_product_code_2 eq 1>STOCK_CODE_2<cfelse>STOCK_CODE</cfif>,PRODUCT_NAME\',\'get_product_autocomplete\',0,\'PRODUCT_ID,STOCK_ID,PRODUCT_NAME<cfif isdefined("is_product_code_2") and is_product_code_2 eq 1>,STOCK_CODE_2<cfelse>,STOCK_CODE</cfif>,PRODUCT_COST<cfif get_pricecat_name.recordcount>,PROFIT_MARGIN</cfif>\',\'product_id' + row_count1 +',stock_id' + row_count1 +',product_name' + row_count1 +',stock_code' + row_count1 +',product_cost' + row_count1 +'<cfif get_pricecat_name.recordcount>,marj_value' + row_count1 +'</cfif>\',\'add_prom\',3,270,\'change_cost('+row_count1+')\');">'
                            +' '+'<a href="javascript://" onClick="windowopen('+"'<cfoutput>#request.self#?fuseaction=objects.popup_product_names</cfoutput>&product_id=add_prom.product_id" + row_count1 + "<cfif isdefined("is_product_code_2") and is_product_code_2 eq 1>&field_code2=add_prom.stock_code" + row_count1 + "<cfelse>&field_code=add_prom.stock_code" + row_count1 + "</cfif>&field_id=add_prom.stock_id" + row_count1 + "&field_name=add_prom.product_name" + row_count1 + "&field_product_cost=add_prom.product_cost" + row_count1 + "<cfif get_pricecat_name.recordcount>&field_profit_margin=add_prom.marj_value" + row_count1 + "</cfif>','list');"+'"><img src="/images/plus_thin.gif" border="0" align="absbottom"></a>';
            newCell = newRow.insertCell(newRow.cells.length);
            newCell.innerHTML = '<input type="text" name="product_cost' + row_count1 +'" id="product_cost' + row_count1 +'" class="moneybox" style="width:40px;" readonly>';
            newCell = newRow.insertCell(newRow.cells.length);
            newCell.innerHTML = '<input type="text" name="product_amount' + row_count1 +'" id="product_amount' + row_count1 +'" class="moneybox" style="width:40px;" value="1" onKeyup="isNumber(this);">';
            <cfif get_pricecat_name.recordcount>
                newCell = newRow.insertCell(newRow.cells.length);
                newCell.innerHTML = '<input type="text" name="product_price_other' + row_count1 +'" id="product_price_other' + row_count1 +'" class="moneybox" style="width:85px;" value="0" onkeyup="return(FormatCurrency(this,event));" onblur="hesapla(' + row_count1 + ',1);">';
                newCell = newRow.insertCell(newRow.cells.length);
                newCell.innerHTML = '<input type="text" name="marj_value' + row_count1 +'" id="marj_value' + row_count1 +'" class="moneybox" style="width:60px;" value="'+profit_margin+'" onkeyup="return(FormatCurrency(this,event));" onblur="if(this.value.length && filterNum(this.value) > 100) this.value=commaSplit(0);hesapla(' + row_count1 + ',1);">';
            </cfif>
            newCell = newRow.insertCell(newRow.cells.length);
            newCell.innerHTML = '<input type="text" name="product_price' + row_count1 +'" id="product_price' + row_count1 +'" class="moneybox" style="width:50px;" value="0" onkeyup="return(FormatCurrency(this,event));" onblur="hesapla(' + row_count1 + ',2);">';
            newCell = newRow.insertCell(newRow.cells.length);
            newCell.innerHTML = '<input type="checkbox" name="is_nondelete' + row_count1 +'" id="is_nondelete' + row_count1 +'" value="1">';
            newCell = newRow.style.textAlign="center";
        }
        function hesapla(row_id,type)
        {
            if(eval('document.getElementById("product_price_other'+row_id+'")') != undefined)
            {
                if(type == 1)
                {
                    satir_deger = filterNum(eval('document.getElementById("product_price_other'+row_id+'")').value);
                    satir_marj = commaSplit((100+filterNum(eval('document.getElementById("marj_value'+row_id+'"').value))/100);
                    if(satir_deger == '') satir_deger = 0;
                    eval('document.getElementById("product_price'+row_id+'")').value = commaSplit(parseFloat(satir_deger) / parseFloat(filterNum(satir_marj)));
                }
                else if(type == 2)
                {
                    satir_deger = filterNum(eval('document.getElementById("product_price' + row_id + '")').value);
                    satir_deger_other = filterNum(eval('document.getElementById("product_price_other' + row_id + '")').value);
                    if(satir_deger == '') satir_deger = 0;
                    if(satir_deger_other == '') satir_deger_other = 0;
                    if(satir_deger != 0)
                        marj_value = commaSplit(parseFloat(satir_deger_other) / parseFloat(satir_deger));
                    else
                        marj_value = 0;
                    eval('document.getElementById("marj_value'+row_id+'"').value = commaSplit(parseFloat(filterNum(marj_value))*100-100);
                }
            }
        }
        function apply_marj()
        {
            for(j=1;j<=add_prom.record_num1.value;j++)
                if(eval("document.getElementById('row_kontrol1" + j + "')").value==1)	
                {
                    eval('document.getElementById("marj_value'+j+'"').value = commaSplit(filterNum(document.getElementById('set_marj').value));
                    hesapla(j,1);
                }
        }
        function open_process_row()
        {
            document.getElementById('open_process').style.display ='';
            document.getElementById('open_process').style.visibility ='';
            AjaxPageLoad('<cfoutput>#request.self#?fuseaction=product.emptypopup_form_add_prom_benefit_product<cfif isdefined("is_product_code_2") and is_product_code_2 eq 1>&is_product_code_2=1</cfif>&catalog_id='+document.getElementById('catalog_id').value+'</cfoutput>','open_process',1);
        }
        function change_cost(row_id)
        {
            if(eval('document.getElementById("product_cost'+row_id+'")').value != "")
                eval('document.getElementById("product_cost'+row_id+'")').value = commaSplit(eval('document.getElementById("product_cost'+row_id+'")').value);
        }
        function check_condition_status(kont)
        {
            if(kont==1)
            {
                if(document.getElementById('prom_condition_status_and').checked == true)
                    document.getElementById('prom_condition_status_or').checked = false;
            }
            else
            {
                if(document.getElementById('prom_condition_status_or').checked == true)
                    document.getElementById('prom_condition_status_and').checked = false;
            }
        }
        function check_benefit_status(kont)
        {
            if(kont==1)
            {
                if(document.getElementById('prom_benefit_status_and').checked == true)
                    document.getElementById('prom_benefit_status_or').checked = false;
            }
            else
            {
                if(document.getElementById('prom_benefit_status_or').checked == true)
                    document.getElementById('prom_benefit_status_and').checked = false;
            }
        }
        function unformat_fields()
        {
            
            for(r=1;r<=add_prom.record_num1.value;r++)
            {
                eval("document.add_prom.product_cost"+r).value = filterNum(eval("document.add_prom.product_cost"+r).value);
                eval("document.add_prom.product_price"+r).value = filterNum(eval("document.add_prom.product_price"+r).value);
                if(eval("document.add_prom.marj_value"+r) != undefined)
                {
                    eval("document.add_prom.marj_value"+r).value = filterNum(eval("document.add_prom.marj_value"+r).value);
                    eval("document.add_prom.product_price_other"+r).value = filterNum(eval("document.add_prom.product_price_other"+r).value);
                }
            }
        }	
        function form_kontrol()
        {
			unformat_fields();
            if(document.getElementById('is_only_same_product').checked == true && document.getElementById('prom_benefit_status_or').checked == true)
            {
                alert("<cf_get_lang no ='751.Kazanç Bölümünde Sadece Aynı Ürünü Ekle ve Veya Seçeneklerini Birlikte Seçemezsiniz'> !");
                return false;
            }
            if($('#condition_price_catid').val() != '' && $('#prom_type').val() == 2)
            {
                alert("<cf_get_lang no ='766.Çalışma Şekli Dönemsel İse Hesaplanacak Fiyat Listesi Seçemezsiniz'> !");
                return false;
            }
            if($('#condition_price_catid').val() == '' && $('#prom_type').val() == 0)
            {
                alert("<cf_get_lang no ='780.Çalışma Şekli Sipariş İse Hesaplanacak Fiyat Listesi Seçmelisiniz'> !");
                return false;
            }
            if(time_check(add_prom.startdate, add_prom.start_clock, add_prom.start_minute, add_prom.finishdate,  add_prom.finish_clock, add_prom.finish_minute, "<cf_get_lang no ='837.Promosyon Başlama Tarihi Bitiş Tarihinden Önce Olmalıdır'> !"))
                return process_cat_control();
            else
                return false;
			return true;
        }	
        function add_camp_date(start_hour,start_minute,finish_hour,finish_minute)
        {
            count = 0;
            for(kk=1;kk<=24;kk++)
            {
                if(start_hour == kk)
                    document.add_prom.start_clock.options[count].selected = true;
                if(finish_hour == kk)
                    document.add_prom.finish_clock.options[count].selected = true;
                count++;
            }
            count = 0;
            for(jj=00;jj<=55;jj=jj+5)
            {
                if(start_minute == jj)
                    document.add_prom.start_minute.options[count].selected = true;
                if(finish_minute == jj)
                    document.add_prom.finish_minute.options[count].selected = true;
                count++;
            }
        }
       
        function sil3(sy)
        {
            var my_element=eval("document.getElementById('row_kontrol3" + sy + "')");
            my_element.value=0;
            var my_element=eval("frm_row3"+sy);
            my_element.style.display="none";
        }
        function add_row3()
        {
            row_count3++;
            var newRow;
            var newCell;
            newRow = document.getElementById("table3").insertRow(document.getElementById("table3").rows.length);	
            newRow.setAttribute("name","frm_row3" + row_count3);
            newRow.setAttribute("id","frm_row3" + row_count3);
            document.add_prom.record_num3.value=row_count3;
            newCell = newRow.insertCell(newRow.cells.length);
            newCell.innerHTML = '<input type="hidden" name="row_kontrol3'+row_count3+'" id="row_kontrol3'+row_count3+'" value="1"><a style="cursor:pointer" onclick="sil3(' + row_count3 + ');"><img  src="images/delete_list.gif" border="0"></a>';
            newCell = newRow.insertCell(newRow.cells.length);
            newCell.innerHTML = '<input type="text" name="prom_no' + row_count3 +'" id="prom_no' + row_count3 +'" class="text" style="width:55px;" readonly>';
            newCell = newRow.insertCell(newRow.cells.length);
            newCell.setAttribute('nowrap','nowrap');
            newCell.innerHTML = '<input  type="hidden" name="promotion_id' + row_count3 +'" id="promotion_id' + row_count3 +'" ><input type="text" name="promotion_name' + row_count3 +'" id="promotion_name' + row_count3 +'" class="text" style="width:125px;" readonly>'
                            +' '+'<a href="javascript://" onClick="windowopen('+"'<cfoutput>#request.self#?fuseaction=objects.popup_list_promotions&prom_id=add_prom.promotion_id" + row_count3 + "&prom_head=add_prom.promotion_name" + row_count3 + "&prom_no=add_prom.prom_no" + row_count3 + "</cfoutput>','small');"+'"><img src="/images/plus_thin.gif" border="0" align="absbottom"></a>';
        }
        function check_prom(kont)
        {
            if(kont==1)
            {
                if(document.getElementById('is_prom_and').checked == true)
                    document.getElementById('is_prom_or').checked = false;
            }
            else
            {
                if(document.getElementById('is_prom_or').checked == true)
                    document.getElementById('is_prom_and').checked = false;
            }
        }
        
    </script>
<cfelseif isdefined("attributes.event") and attributes.event is 'upddetprom'>
	<script type="text/javascript">
	
		$(document).ready(function(){
			 row_count= 0;
			 row_count1 = <cfoutput>#get_prom_products.recordcount#</cfoutput>;
			 row_count3= <cfoutput>#get_prom_related.recordcount#</cfoutput>;		
		});
      
        function control_member()
        {
            if(document.add_prom.consumer_ref_prom.checked == true)
            {
                document.getElementById('member_td_1').style.display='';
                document.getElementById('member_td_2').style.display='';
            }
            else
            {
                document.getElementById('member_td_1').style.display='none';
                document.getElementById('member_td_2').style.display='none';
            }
        }
        function del_condition(row_id)
        {	
            document.getElementById('condition'+row_id).style.display = 'none';
            document.getElementById('row_control_prom_'+row_id).value=0;
        }
        function add_condition(prom_condition_id)
        {	
		
            if(prom_condition_id == undefined)
                prom_condition_id = 0;
            row_count+=1;
            $('#record_num').val(row_count);
            //document.getElementById('record_num').value = row_count;
            var my_obj = document.createElement('div');
            my_obj.innerHTML='<tr height="25"><td colspan="6"><div id="condition'+row_count+'"></div></td></tr>';
            document.getElementById('table2').appendChild(my_obj);
            AjaxPageLoad('<cfoutput>#request.self#?fuseaction=product.emptypopup_form_add_prom_condition&row_id='+row_count+'&prom_condition_id='+prom_condition_id+'</cfoutput><cfif isdefined("is_product_code_2") and is_product_code_2 eq 1>&is_product_code_2=1</cfif>','condition'+row_count+'');
        
		}
        function sil1(sy)
        {
            var my_element=eval("add_prom.row_kontrol1"+sy);
            my_element.value=0;
            var my_element=eval("frm_row_product"+sy);
            my_element.style.display="none";
        }
        function add_product(product_id,stock_id,product_name,stock_code,page_no)
        {
            if(product_id == undefined)
                product_id = '';
            if(stock_id == undefined)
                stock_id = '';
            if(product_name == undefined)
                product_name = '';
            if(stock_code == undefined)
                stock_code = '';
            if(page_no == undefined)
                page_no = '';
            row_count1++;
            var newRow;
            var newCell;
            newRow = document.getElementById("table_product").insertRow(document.getElementById("table_product").rows.length);
            newRow.setAttribute("name","frm_row_product" + row_count1);
            newRow.setAttribute("id","frm_row_product" + row_count1);
            document.add_prom.record_num1.value=row_count1;
            newCell = newRow.insertCell(newRow.cells.length);
            newCell.innerHTML = '';
            newCell = newRow.insertCell(newRow.cells.length);
            newCell.innerHTML = '<input type="hidden" name="row_kontrol1'+row_count1+'" value="1"><a style="cursor:hand" onclick="sil1(' + row_count1 + ');"><img  src="images/delete_list.gif" border="0"></a>';
            newCell = newRow.insertCell(newRow.cells.length);
            newCell.innerHTML = '<input type="text" name="stock_code' + row_count1 +'" id="stock_code' + row_count1 +'" class="text" style="width:60px;" readonly value='+stock_code+'>';
            newCell = newRow.insertCell(newRow.cells.length);																																																											
            newCell.innerHTML = '<input  type="hidden" name="product_id' + row_count1 +'" id="product_id' + row_count1 +'" value="'+product_id+'"><input type="hidden" name="stock_id' + row_count1 +'" id="stock_id' + row_count1 +'" value="'+stock_id+'"><input type="text" name="product_name' + row_count1 +'" id="product_name' + row_count1 +'" class="text" style="width:100px;" value="'+product_name+'" onFocus="AutoComplete_Create(\'product_name' + row_count1 +'\',\'<cfif isdefined("is_product_code_2") and is_product_code_2 eq 1>STOCK_CODE_2<cfelse>STOCK_CODE</cfif>,PRODUCT_NAME\',\'<cfif isdefined("is_product_code_2") and is_product_code_2 eq 1>STOCK_CODE_2<cfelse>STOCK_CODE</cfif>,PRODUCT_NAME\',\'get_product_autocomplete\',0,\'PRODUCT_ID,STOCK_ID,PRODUCT_NAME<cfif isdefined("is_product_code_2") and is_product_code_2 eq 1>,STOCK_CODE_2<cfelse>,STOCK_CODE</cfif>,PRODUCT_COST<cfif get_pricecat_name.recordcount>,PROFIT_MARGIN</cfif>\',\'product_id' + row_count1 +',stock_id' + row_count1 +',product_name' + row_count1 +',stock_code' + row_count1 +',product_cost' + row_count1 +'<cfif get_pricecat_name.recordcount>,marj_value' + row_count1 +'</cfif>\',\'add_prom\',3,270,\'change_cost('+row_count1+')\');">'
                            +' '+'<a href="javascript://" onClick="windowopen('+"'<cfoutput>#request.self#?fuseaction=objects.popup_product_names</cfoutput>&product_id=add_prom.product_id" + row_count1 + "<cfif isdefined("is_product_code_2") and is_product_code_2 eq 1>&field_code2=add_prom.stock_code" + row_count1 + "<cfelse>&field_code=add_prom.stock_code" + row_count1 + "</cfif>&field_id=add_prom.stock_id" + row_count1 + "&field_name=add_prom.product_name" + row_count1 + "&field_product_cost=add_prom.product_cost" + row_count1 + "<cfif get_pricecat_name.recordcount>&field_profit_margin=add_prom.marj_value" + row_count1 + "</cfif>','list');"+'"><img src="/images/plus_thin.gif" border="0" align="absbottom"></a>';
            newCell = newRow.insertCell(newRow.cells.length);
            newCell.setAttribute('nowrap','nowrap');
            newCell.innerHTML = '<input type="text" name="product_cost' + row_count1 +'" id="product_cost' + row_count1 +'" class="moneybox" style="width:40px;" readonly>';
            newCell = newRow.insertCell(newRow.cells.length);
            newCell.innerHTML = '<input type="text" name="product_amount' + row_count1 +'" class="moneybox" style="width:40px;" value="1" onKeyup="isNumber(this);">';
            <cfif get_pricecat_name.recordcount>
                newCell = newRow.insertCell(newRow.cells.length);
                newCell.innerHTML = '<input type="text" name="product_price_other' + row_count1 +'" class="moneybox" style="width:85px;" value="0" onkeyup="return(FormatCurrency(this,event));" onblur="hesapla(' + row_count1 + ',1);">';
                newCell = newRow.insertCell(newRow.cells.length);
                newCell.innerHTML = '<input type="text" name="marj_value' + row_count1 +'" id="marj_value' + row_count1 +'" class="moneybox" style="width:60px;" value="0" onkeyup="return(FormatCurrency(this,event));" onblur="if(this.value.length && filterNum(this.value) > 100) this.value=commaSplit(0);hesapla(' + row_count1 + ',1);">';
            </cfif>
            newCell = newRow.insertCell(newRow.cells.length);
            newCell.innerHTML = '<input type="text" name="product_price' + row_count1 +'" class="moneybox" style="width:50px;" value="0" onkeyup="return(FormatCurrency(this,event));" onblur="hesapla(' + row_count1 + ',2);">';
            newCell = newRow.insertCell(newRow.cells.length);
            newCell.innerHTML = '<input type="checkbox" name="is_nondelete' + row_count1 +'" value="1">';
            newCell = newRow.style.textAlign="center";
        }
        function hesapla(row_id,type)
        {
            if(eval('add_prom.product_price_other'+row_id) != undefined)
            {
                if(type == 1)
                {
                    satir_deger = filterNum(eval('add_prom.product_price_other'+row_id).value);
                    satir_marj = commaSplit((100+filterNum(eval('add_prom.marj_value'+row_id).value))/100);
                    if(satir_deger == '') satir_deger = 0;
                    eval('add_prom.product_price'+row_id).value = commaSplit(parseFloat(satir_deger) / parseFloat(filterNum(satir_marj)));
                }
                else if(type == 2)
                {
                    satir_deger = filterNum(eval('add_prom.product_price'+row_id).value);
                    satir_deger_other = filterNum(eval('add_prom.product_price_other'+row_id).value);
                    if(satir_deger == '') satir_deger = 0;
                    if(satir_deger_other == '') satir_deger_other = 0;
                    if(satir_deger != 0)
                        marj_value = commaSplit(parseFloat(satir_deger_other) / parseFloat(satir_deger));
                    else
                        marj_value = 0;
                    eval('add_prom.marj_value'+row_id).value = commaSplit(parseFloat(filterNum(marj_value))*100-100);
                }
            }
        }
        function apply_marj()
        {
            for(j=1;j<=add_prom.record_num1.value;j++)
                if(eval("document.add_prom.row_kontrol1"+j).value==1)	
                {
                    eval('add_prom.marj_value'+j).value = commaSplit(filterNum(add_prom.set_marj.value));
                    hesapla(j,1);
                }
        }
        function open_process_row()
        {
            document.getElementById('open_process').style.display ='';
            document.getElementById('open_process').style.visibility ='';
            AjaxPageLoad('<cfoutput>#request.self#?fuseaction=product.emptypopup_form_add_prom_benefit_product&catalog_id='+document.add_prom.catalog_id.value+'</cfoutput><cfif isdefined("is_product_code_2") and is_product_code_2 eq 1>&is_product_code_2=1</cfif>','open_process',1);
        }
        function change_cost(row_id)
        {
            if(eval('document.add_prom.product_cost'+row_id).value != "")
                eval('document.add_prom.product_cost'+row_id).value = commaSplit(eval('document.add_prom.product_cost'+row_id).value);
        }
        function check_condition_status(kont)
        {
            if(kont==1)
            {
                if(document.getElementById('prom_condition_status_and').checked == true)
                    document.getElementById('prom_condition_status_or').checked = false;
            }
            else
            {
                if(document.getElementById('prom_condition_status_or').checked == true)
                    document.getElementById('prom_condition_status_and').checked = false;
            }
        }
        function check_benefit_status(kont)
        {
            if(kont==1)
            {
                if(document.getElementById('prom_benefit_status_and').checked == true)
                    document.getElementById('prom_benefit_status_or').checked = false;
            }
            else
            {
                if(document.getElementById('prom_benefit_status_or').checked == true)
                    document.getElementById('prom_benefit_status_and').checked = false;
            }
        }
        function unformat_fields()
        {
            for(r=1;r<=add_prom.record_num.value;r++)
            {
                eval("document.getElementById('product_amount_"+r+"')").value = filterNum(eval("document.getElementById('product_amount_"+r+"')").value);
                //eval("document.getElementById('total_product_amount_2_"+r+"')").value = filterNum(eval("document.getElementById('total_product_amount_2_"+r+"')").value);
            }
            
            for(r=1;r<=add_prom.record_num1.value;r++)
            {
                eval("document.add_prom.product_cost"+r).value = filterNum(eval("document.add_prom.product_cost"+r).value);
                eval("document.add_prom.product_price"+r).value = filterNum(eval("document.add_prom.product_price"+r).value);
                if(eval("document.add_prom.marj_value"+r) != undefined)
                {
                    eval("document.add_prom.marj_value"+r).value = filterNum(eval("document.add_prom.marj_value"+r).value);
                    eval("document.add_prom.product_price_other"+r).value = filterNum(eval("document.add_prom.product_price_other"+r).value);
                }
            }
        }	
        function form_kontrol()
        {
			unformat_fields();
            if(add_prom.is_only_same_product.checked == true && add_prom.prom_benefit_status_or.checked == true)
            {
                alert("<cf_get_lang no ='751.Kazanç Bölümünde Sadece Aynı Ürünü Ekle ve Veya Seçeneklerini Birlikte Seçemezsiniz'>!");
                return false;
            }
            if(add_prom.condition_price_catid.value != '' && add_prom.prom_type.value == 2)
            {
                alert("<cf_get_lang no ='766.Çalışma Şekli Dönemsel İse Hesaplanacak Fiyat Listesi Seçemezsiniz'>!");
                return false;
            }
            if(add_prom.condition_price_catid.value == '' && add_prom.prom_type.value == 0)
            {
                alert("<cf_get_lang no ='780.Çalışma Şekli Sipariş İse Hesaplanacak Fiyat Listesi Seçmelisiniz'>!");
                return false;
            }
            if(time_check(add_prom.startdate, add_prom.start_clock, add_prom.start_minute, add_prom.finishdate,  add_prom.finish_clock, add_prom.finish_minute, "<cf_get_lang no ='837.Promosyon Başlama Tarihi Bitiş Tarihinden Önce Olmalıdır'>!"))
                return process_cat_control();
            else
                return false;
			return true;
        }
        function add_camp_date(start_hour,start_minute,finish_hour,finish_minute)
        {
            count = 0;
            for(kk=1;kk<=24;kk++)
            {
                if(start_hour == kk)
                    document.add_prom.start_clock.options[count].selected = true;
                if(finish_hour == kk)
                    document.add_prom.finish_clock.options[count].selected = true;
                count++;
            }
            count = 0;
            for(jj=00;jj<=55;jj=jj+5)
            {
                if(start_minute == jj)
                    document.add_prom.start_minute.options[count].selected = true;
                if(finish_minute == jj)
                    document.add_prom.finish_minute.options[count].selected = true;
                count++;
            }
        }
       
        function sil3(sy)
        {
            var my_element=eval("add_prom.row_kontrol3"+sy);
            my_element.value=0;
            var my_element=eval("frm_row3"+sy);
            my_element.style.display="none";
        }
        function add_row3()
        {
            row_count3++;
            var newRow;
            var newCell;
            newRow = document.getElementById("table3").insertRow(document.getElementById("table3").rows.length);	
            newRow.setAttribute("name","frm_row3" + row_count3);
            newRow.setAttribute("id","frm_row3" + row_count3);
            document.add_prom.record_num3.value=row_count3;
            newCell = newRow.insertCell(newRow.cells.length);
            newCell.innerHTML = '<input type="hidden" name="row_kontrol3'+row_count3+'" value="1"><a style="cursor:hand" onclick="sil3(' + row_count3 + ');"><img  src="images/delete_list.gif" border="0"></a>';
            newCell = newRow.insertCell(newRow.cells.length);
            newCell.innerHTML = '<input type="text" name="prom_no' + row_count3 +'" class="text" style="width:55px;" readonly>';
            newCell = newRow.insertCell(newRow.cells.length);
            newCell.setAttribute('nowrap','nowrap');
            newCell.innerHTML = '<input  type="hidden" name="promotion_id' + row_count3 +'" ><input type="text" name="promotion_name' + row_count3 +'" class="text" style="width:125px;" readonly>'
                            +' '+'<a href="javascript://" onClick="windowopen('+"'<cfoutput>#request.self#?fuseaction=objects.popup_list_promotions&prom_id=add_prom.promotion_id" + row_count3 + "&prom_head=add_prom.promotion_name" + row_count3 + "&prom_no=add_prom.prom_no" + row_count3 + "</cfoutput>','small');"+'"><img src="/images/plus_thin.gif" border="0" align="absbottom"></a>';
        }
        function check_prom(kont)
        {
            if(kont==1)
            {
                if(document.add_prom.is_prom_and.checked == true)
                    document.add_prom.is_prom_or.checked = false;
            }
            else
            {
                if(document.add_prom.is_prom_or.checked == true)
                    document.add_prom.is_prom_and.checked = false;
            }
        }
    </script>

</cfif>
<cfscript>
	// Switch //
	WOStruct = StructNew();
	
	WOStruct['#attributes.fuseaction#'] = structNew();	
	
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	if(not isdefined('attributes.event'))
		attributes.event = WOStruct['#attributes.fuseaction#']['default'];
	
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'product.list_promotions';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'product/display/list_proms.cfm';
	WOStruct['#attributes.fuseaction#']['list']['default'] = 1;	
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'window';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'product.form_add_prom';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'product/form/add_prom.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'product/query/add_prom.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'product.list_promotions';
	
	WOStruct['#attributes.fuseaction#']['addcollectedprom'] = structNew();
	WOStruct['#attributes.fuseaction#']['addcollectedprom']['window'] = 'window';
	WOStruct['#attributes.fuseaction#']['addcollectedprom']['fuseaction'] = 'product.list_promotions';
	WOStruct['#attributes.fuseaction#']['addcollectedprom']['filePath'] = 'product/form/add_collacted_prom.cfm';
	WOStruct['#attributes.fuseaction#']['addcollectedprom']['queryPath'] = 'product/query/add_collacted_prom.cfm';
	WOStruct['#attributes.fuseaction#']['addcollectedprom']['nextEvent'] = 'product.list_promotions&event=updcollectedprom';
	WOStruct['#attributes.fuseaction#']['addcollectedprom']['js'] = "javascript:gizle_goster_ikili('collected_prom_','collected_prom_bask_')";
	
	WOStruct['#attributes.fuseaction#']['adddetprom'] = structNew();
	WOStruct['#attributes.fuseaction#']['adddetprom']['window'] = 'window';
	WOStruct['#attributes.fuseaction#']['adddetprom']['fuseaction'] = 'product.form_add_detail_prom';
	WOStruct['#attributes.fuseaction#']['adddetprom']['filePath'] = 'product/form/form_add_detail_prom.cfm';
	WOStruct['#attributes.fuseaction#']['adddetprom']['queryPath'] = 'product/query/add_detail_prom.cfm';
	WOStruct['#attributes.fuseaction#']['adddetprom']['nextEvent'] = 'product.list_promotions&event=upddetprom';
	
	WOStruct['#attributes.fuseaction#']['upddetprom'] = structNew();
	WOStruct['#attributes.fuseaction#']['upddetprom']['window'] = 'window';
	WOStruct['#attributes.fuseaction#']['upddetprom']['fuseaction'] = 'product.list_promotions';
	WOStruct['#attributes.fuseaction#']['upddetprom']['filePath'] = 'product/form/form_upd_detail_prom.cfm';
	WOStruct['#attributes.fuseaction#']['upddetprom']['queryPath'] = 'product/query/upd_detail_prom.cfm';
	WOStruct['#attributes.fuseaction#']['upddetprom']['nextEvent'] = 'product.list_promotions&event=upddetprom';
	WOStruct['#attributes.fuseaction#']['upddetprom']['parameters'] = 'prom_id=##attributes.prom_id##';
	WOStruct['#attributes.fuseaction#']['upddetprom']['Identity'] = '##attributes.prom_id##';
	
	WOStruct['#attributes.fuseaction#']['updcollectedprom'] = structNew();
	WOStruct['#attributes.fuseaction#']['updcollectedprom']['window'] = 'window';
	WOStruct['#attributes.fuseaction#']['updcollectedprom']['fuseaction'] = 'product.list_promotions';
	WOStruct['#attributes.fuseaction#']['updcollectedprom']['filePath'] = 'product/form/upd_collacted_prom.cfm';
	WOStruct['#attributes.fuseaction#']['updcollectedprom']['queryPath'] = 'product/query/upd_collacted_prom.cfm';
	WOStruct['#attributes.fuseaction#']['updcollectedprom']['nextEvent'] = 'product.list_promotions&event=updcollectedprom';
	WOStruct['#attributes.fuseaction#']['updcollectedprom']['parameters'] = 'prom_rel_id=##attributes.prom_rel_id##';
	WOStruct['#attributes.fuseaction#']['updcollectedprom']['Identity'] = '##attributes.prom_rel_id##';
	WOStruct['#attributes.fuseaction#']['updcollectedprom']['js'] = "javascript:gizle_goster_ikili('cellacted_prom_','cellacted_prom_bask_')";
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'window';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'product.form_upd_prom';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'product/form/upd_prom.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'product/query/upd_prom.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'product.list_promotions&event=upd';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'prom_id=##attributes.prom_id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.prom_id##';
	
	if(not attributes.event is 'list' and not attributes.event is 'add')
	{
		WOStruct['#attributes.fuseaction#']['del'] = structNew();
		WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
		WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'product.list_promotions';
		WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'product/query/del_prom.cfm';
		WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'product/query/del_prom.cfm';
		WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'product.list_promotions';
		
		WOStruct['#attributes.fuseaction#']['delcollectedprom'] = structNew();
		WOStruct['#attributes.fuseaction#']['delcollectedprom']['window'] = 'emptypopup';
		WOStruct['#attributes.fuseaction#']['delcollectedprom']['fuseaction'] = 'product.list_promotions';
		WOStruct['#attributes.fuseaction#']['delcollectedprom']['filePath'] = 'product/query/del_collacted_prom.cfm';
		WOStruct['#attributes.fuseaction#']['delcollectedprom']['queryPath'] = 'product/query/del_collacted_prom.cfm';
		WOStruct['#attributes.fuseaction#']['delcollectedprom']['nextEvent'] = 'product.list_promotions';
		
		WOStruct['#attributes.fuseaction#']['deldetailprom'] = structNew();
		WOStruct['#attributes.fuseaction#']['deldetailprom']['window'] = 'emptypopup';
		WOStruct['#attributes.fuseaction#']['deldetailprom']['fuseaction'] = 'product.list_promotions';
		WOStruct['#attributes.fuseaction#']['deldetailprom']['filePath'] = 'product/query/del_detail_prom.cfm';
		WOStruct['#attributes.fuseaction#']['deldetailprom']['queryPath'] = 'product/query/del_detail_prom.cfm';
		WOStruct['#attributes.fuseaction#']['deldetailprom']['nextEvent'] = 'product.list_promotions';
	}

	if(attributes.event is 'add')
		{		
		if(isDefined("attributes.stock_id")){
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add'] = structNew();
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['menus'] = structNew();
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['menus'][0]['text'] = '#lang_array.item[467]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['menus'][0]['onClick'] = "sayfa_ac('1')";
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['menus'][1]['text'] = '#lang_array_main.item[846]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['menus'][1]['onClick'] = "sayfa_ac('2')";
			tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
			}		
		}
		
	if(attributes.event is 'upd')
		{		
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd'] = structNew();
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'] = structNew();
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['text'] = '#lang_array.item[579]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['onClick'] = "window.open('#request.self#?fuseaction=product.popup_list_promotions_invoice&prom_id=#attributes.prom_id#','list')";
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][1]['text'] = '#lang_array.item[467]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][1]['onClick'] = "sayfa_ac('1')";
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][2]['text'] = '#lang_array_main.item[345]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][2]['onClick'] = "window.open('#request.self#?fuseaction=objects.popup_page_warnings&action=product.form_upd_prom&action_name=prom_id&action_id=#attributes.prom_id#','list')";
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][3]['text'] = '#lang_array.item[493]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][3]['onClick'] = "window.open('#request.self#?fuseaction=objects.popup_detail_promotion_history&prom_id=#attributes.prom_id#','list')";
			i=3;
			if(isdefined("is_conscat_segmentation") and is_conscat_segmentation eq 1){
				if(not listfindnocase(denied_pages,'product.popup_add_conscat_segmentation')){
					tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#lang_array.item[839]#';
					tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['onClick'] = "window.open('#request.self#?fuseaction=product.popup_add_conscat_segmentation&promotion_id=#attributes.prom_id#','list_horizantal')";
					i=i+1;		
				}
			}
			//if(isdefined("is_conscat_premium") and is_conscat_premium eq 1){
//				if(not listfindnocase(denied_pages,'product.popup_add_conscat_premium')){
//					tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#lang_array.item[838]#';
//					tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['onClick'] = "window.open('#request.self#?fuseaction=product.popup_add_conscat_premium&prom_rel_id=#attributes.prom_rel_id#','horizantal')";
//					i=i+1;
//				}
//			}
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#lang_array_main.item[170]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=product.list_promotions&event=addcollectedprom";
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['copy']['text'] = '#lang_array_main.item[64]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['copy']['href'] = '#request.self#?fuseaction=product.list_promotions&event=addcollectedprom&prom_id=#attributes.prom_id#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['copy']['target'] = "_blank";
			tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
		}		

	if(attributes.event is 'updcollectedprom'){
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['updcollectedprom'] = structNew();
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['updcollectedprom']['menus'] = structNew();
			i=0;
			if(isdefined("is_conscat_segmentation") and is_conscat_segmentation eq 1){
				if(not listfindnocase(denied_pages,'product.popup_add_conscat_segmentation')){
					tabMenuStruct['#attributes.fuseaction#']['tabMenus']['updcollectedprom']['menus'][i]['text'] = '#lang_array.item[839]#';
					tabMenuStruct['#attributes.fuseaction#']['tabMenus']['updcollectedprom']['menus'][i]['onClick'] = "window.open('#request.self#?fuseaction=product.popup_add_conscat_segmentation&prom_rel_id=#attributes.prom_rel_id#','list_horizantal')";
					i=i+1;
				}
			}
			if(isdefined("is_conscat_premium") and is_conscat_premium eq 1){
				if(not listfindnocase(denied_pages,'product.popup_add_conscat_premium')){
					tabMenuStruct['#attributes.fuseaction#']['tabMenus']['updcollectedprom']['menus'][i]['text'] = '#lang_array.item[838]#';
					tabMenuStruct['#attributes.fuseaction#']['tabMenus']['updcollectedprom']['menus'][i]['onClick'] = "window.open('#request.self#?fuseaction=product.popup_add_conscat_premium&prom_rel_id=#attributes.prom_rel_id#','horizantal')";
					i=i+1;
				}
			}
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['updcollectedprom']['icons']['add']['text'] = '#lang_array_main.item[170]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['updcollectedprom']['icons']['add']['href'] = "#request.self#?fuseaction=product.list_promotions&event=addcollectedprom";
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['updcollectedprom']['icons']['add']['target'] = "_blank";
			tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	if(attributes.event is 'upddetprom'){
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upddetprom'] = structNew();
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upddetprom']['menus'] = structNew();
			i=0;
			if(isdefined("is_conscat_segmentation") and is_conscat_segmentation eq 1){
				if(not listfindnocase(denied_pages,'product.popup_add_conscat_segmentation')){
					tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upddetprom']['menus'][i]['text'] = '#lang_array.item[839]#';
					tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upddetprom']['menus'][i]['onClick'] = "window.open('#request.self#?fuseaction=product.popup_add_conscat_segmentation&promotion_id=#attributes.prom_id#','list_horizantal')";
					i=i+1;
				}
			}
			//if(isdefined("is_conscat_premium") and is_conscat_premium eq 1){
//				if(not listfindnocase(denied_pages,'product.popup_add_conscat_premium')){
//					tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upddetprom']['menus'][i]['text'] = '#lang_array.item[838]#';
//					tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upddetprom']['menus'][i]['onClick'] = "window.open('#request.self#?fuseaction=product.popup_add_conscat_premium&prom_rel_id=#attributes.prom_rel_id#','horizantal')";
//					i=i+1;
//				}
//			}
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upddetprom']['icons']['add']['text'] = '#lang_array_main.item[170]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upddetprom']['icons']['add']['href'] = "#request.self#?fuseaction=product.list_promotions&event=adddetprom";
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upddetprom']['icons']['add']['target'] = "_blank";
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upddetprom']['icons']['copy']['text'] = '#lang_array_main.item[64]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upddetprom']['icons']['copy']['href'] = "#request.self#?fuseaction=product.list_promotions&event=upddetprom&prom_id=#attributes.prom_id#&is_copy=1";
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upddetprom']['icons']['copy']['target'] = "_blank";
			tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	if(attributes.event is 'add' or attributes.event is 'upd'){
	WOStruct['#attributes.fuseaction#']['extendedForm'] = structNew();
	WOStruct['#attributes.fuseaction#']['extendedForm']['controllerFileName'] = 'listPromotionsController';
	WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'PROMOTIONS';
	WOStruct['#attributes.fuseaction#']['extendedForm']['dataSourceName'] = 'company';
	WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "['item-prom_head','item-startdate','item-finishdate','item-limit_type']";
	}
	else if(attributes.event is 'addcollectedprom' or attributes.event is 'updcollectedprom'){
	WOStruct['#attributes.fuseaction#']['extendedForm'] = structNew();
	WOStruct['#attributes.fuseaction#']['extendedForm']['controllerFileName'] = 'listPromotionsController';
	WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'addcollectedprom,updcollectedprom';
	WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'PROMOTIONS_RELATION';
	WOStruct['#attributes.fuseaction#']['extendedForm']['dataSourceName'] = 'company';
	WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "['item-process_stage']";
	}
	else if(attributes.event is 'adddetprom'){
	WOStruct['#attributes.fuseaction#']['extendedForm'] = structNew();
	WOStruct['#attributes.fuseaction#']['extendedForm']['controllerFileName'] = 'listPromotionsController';
	WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'adddetprom';
	WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'PROMOTIONS';
	WOStruct['#attributes.fuseaction#']['extendedForm']['dataSourceName'] = 'company';
	WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "['item-prom_head','item-startdate','item-finishdate']";
	}
</cfscript>