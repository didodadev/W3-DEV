<cf_get_lang_set module_name="sales">
<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
	<cfsetting showdebugoutput="yes">
    <cf_xml_page_edit fuseact ="sales.list_order" default_value="1">
    <cfparam name="attributes.product_name" default="">
    <cfparam name="attributes.product_id" default="">
    <cfparam name="attributes.short_code_id" default="">
    <cfparam name="attributes.short_code_name" default="">
    <cfparam name="attributes.prod_cat" default="">
    <cfparam name="attributes.start_date" default="">
    <cfparam name="attributes.finish_date" default="">
    <cfparam name="attributes.order_employee" default="">
    <cfparam name="attributes.order_employee_id" default="">
    <cfparam name="attributes.sales_member_name" default="">
    <cfparam name="attributes.sales_member_id" default="">
    <cfparam name="attributes.sales_member_type" default="">
    <cfparam name="attributes.order_stage" default="">
    <cfparam name="attributes.sale_add_option" default="">
    <cfparam name="attributes.sales_departments" default="">
    <cfif xml_listing_type eq 1>
    	<cfparam name="attributes.listing_type" default="2">
    <cfelse>
    	<cfparam name="attributes.listing_type" default="">
    </cfif>
    <cfparam name="attributes.quantity" default="">
    <cfparam name="attributes.unit" default="">
    <cfparam name="attributes.project_id" default="">
    <cfparam name="attributes.project_head" default="">
    <cfparam name="attributes.subscription_id" default="">
    <cfparam name="attributes.subscription_no" default="">
    <cfparam name="attributes.brand_id" default="">
    <cfparam name="attributes.brand_name" default="">
    <cfparam name="attributes.sort_type" default="4">
    <cfparam name="attributes.keyword" default="">
    <cfparam name="attributes.keyword_orderno" default="">
    <cfparam name="attributes.branch_id" default="">
    <cfparam name="attributes.zone_id" default="">
    <cfparam name="attributes.sales_county" default="">
    <cfparam name="attributes.record_emp_id" default="">
    <cfparam name="attributes.record_cons_id" default="">
    <cfparam name="attributes.record_part_id" default="">
    <cfparam name="attributes.record_name" default="">
    <cfparam name="attributes.card_paymethod_id" default="">
    <cfparam name="attributes.paymethod_id" default="">
    <cfparam name="attributes.paymethod" default="">
    <cfparam name="attributes.irsaliye_fatura" default="">
    <cfparam name="attributes.use_efatura" default="">
    
    <cfif listlen(attributes.fuseaction,'.') eq 2 and listgetat(attributes.fuseaction,2,'.') is 'list_order_instalment'>
        <cfset attributes.is_instalment = 1>
    </cfif>
    <cfif isdefined("attributes.start_date") and isdate(attributes.start_date)>
        <cf_date tarih="attributes.start_date">
    <cfelse>
        <cfif session.ep.our_company_info.unconditional_list>
            <cfset attributes.start_date=''>
        <cfelse>
            <cfset attributes.start_date = wrk_get_today()>
        </cfif>
    </cfif>
    <cfif isdefined("attributes.finish_date") and isdate(attributes.finish_date)>
        <cf_date tarih="attributes.finish_date">
    <cfelse>
        <cfif session.ep.our_company_info.unconditional_list>
            <cfset attributes.finish_date=''>
        <cfelse>
            <cfset attributes.finish_date = date_add('ww',1,attributes.start_date)>
        </cfif>
    </cfif>
    <cfparam name="attributes.page" default="1">
    <cfparam name="attributes.maxrows" default='#session.ep.maxrows#'> 
    <cfset attributes.startrow = ((attributes.page-1)*attributes.maxrows) + 1 >
    
    <cfif isdefined("attributes.form_varmi")>
        <cfset arama_yapilmali = 0>
        <cfscript>
        get_order_list_action = createObject("component", "sales.cfc.get_order_list");
        get_order_list_action.dsn3 = dsn3;
        get_order_list_action.dsn_alias = dsn_alias;
        get_order_list = get_order_list_action.get_order_list_fnc
            (
                listing_type : '#IIf(IsDefined("attributes.listing_type"),"attributes.listing_type",DE(""))#',
                sort_type : '#IIf(IsDefined("attributes.sort_type"),"attributes.sort_type",DE("4"))#',
                x_control_ims : '#IIf(IsDefined("x_control_ims"),"x_control_ims",DE("0"))#',
                x_show_special_definition : '#IIf(IsDefined("x_show_special_definition"),"x_show_special_definition",DE("0"))#',
                x_multiple_filters : '#IIf(IsDefined("x_multiple_filters"),"x_multiple_filters",DE("0"))#',
                x_show_other_money_value : '#IIf(IsDefined("x_show_other_money_value"),"x_show_other_money_value",DE("0"))#',
                prod_cat : '#IIf(IsDefined("attributes.prod_cat"),"attributes.prod_cat",DE(""))#',
                product_name : '#IIf(IsDefined("attributes.product_name"),"attributes.product_name",DE(""))#',
                product_id : '#IIf(IsDefined("attributes.product_id"),"attributes.product_id",DE(""))#',
                currency_id : '#IIf(IsDefined("attributes.currency_id"),"attributes.currency_id",DE(""))#',
                employee_id : '#IIf(IsDefined("attributes.employee_id"),"attributes.employee_id",DE(""))#',
                employee_name : '#IIf(IsDefined("attributes.employee"),"attributes.employee",DE(""))#',
                order_employee_id : '#IIf(IsDefined("attributes.order_employee_id"),"attributes.order_employee_id",DE(""))#',
                order_employee : '#IIf(IsDefined("attributes.order_employee"),"attributes.order_employee",DE(""))#',
                brand_name : '#IIf(IsDefined("attributes.brand_name"),"attributes.brand_name",DE(""))#',
                brand_id : '#IIf(IsDefined("attributes.brand_id"),"attributes.brand_id",DE(""))#',
                short_code_name : '#IIf(IsDefined("attributes.short_code_name"),"attributes.short_code_name",DE(""))#',
                short_code_id : '#IIf(IsDefined("attributes.short_code_id"),"attributes.short_code_id",DE(""))#',
                sales_departments : '#IIf(IsDefined("attributes.sales_departments"),"attributes.sales_departments",DE(""))#',
                status : '#IIf(IsDefined("attributes.status"),"attributes.status",DE(""))#',
                subscription_no : '#IIf(IsDefined("attributes.subscription_no"),"attributes.subscription_no",DE(""))#',
                subscription_id : '#IIf(IsDefined("attributes.subscription_id"),"attributes.subscription_id",DE(""))#',
                priority : '#IIf(IsDefined("attributes.priority"),"attributes.priority",DE(""))#',
                keyword : '#IIf(IsDefined("attributes.keyword"),"attributes.keyword",DE(""))#',
                keyword_orderno : '#IIf(IsDefined("attributes.keyword_orderno"),"attributes.keyword_orderno",DE(""))#',
                member_type : '#IIf(IsDefined("attributes.member_type"),"attributes.member_type",DE(""))#',
                member_name : '#IIf(IsDefined("attributes.member_name"),"attributes.member_name",DE(""))#',
                company_id : '#IIf(IsDefined("attributes.company_id"),"attributes.company_id",DE(""))#',
                consumer_id : '#IIf(IsDefined("attributes.consumer_id"),"attributes.consumer_id",DE(""))#',
                sales_member_type : '#IIf(IsDefined("attributes.sales_member_type"),"attributes.sales_member_type",DE(""))#',
                sales_member_name : '#IIf(IsDefined("attributes.sales_member_name"),"attributes.sales_member_name",DE(""))#',
                sales_member_id : '#IIf(IsDefined("attributes.sales_member_id"),"attributes.sales_member_id",DE(""))#',
                start_date : '#IIf(IsDefined("attributes.start_date"),"attributes.start_date",DE(""))#',
                finish_date : '#IIf(IsDefined("attributes.finish_date"),"attributes.finish_date",DE(""))#',
                order_stage : '#IIf(IsDefined("attributes.order_stage"),"attributes.order_stage",DE(""))#',
                sales_county : '#IIf(IsDefined("attributes.sales_county"),"attributes.sales_county",DE(""))#',
                sale_add_option : '#IIf(IsDefined("attributes.sale_add_option"),"attributes.sale_add_option",DE(""))#',
                branch_id : '#IIf(IsDefined("attributes.branch_id"),"attributes.branch_id",DE(""))#',
                zone_id : '#IIf(IsDefined("attributes.zone_id"),"attributes.zone_id",DE(""))#',
                record_emp_id : '#IIf(IsDefined("attributes.record_emp_id"),"attributes.record_emp_id",DE(""))#',
                record_cons_id : '#IIf(IsDefined("attributes.record_cons_id"),"attributes.record_cons_id",DE(""))#',
                record_part_id : '#IIf(IsDefined("attributes.record_part_id"),"attributes.record_part_id",DE(""))#',
                record_name : '#IIf(IsDefined("attributes.record_name"),"attributes.record_name",DE(""))#',
                project_head : '#IIf(IsDefined("attributes.project_head"),"attributes.project_head",DE(""))#',
                project_id : '#IIf(IsDefined("attributes.project_id"),"attributes.project_id",DE(""))#',
                module_name : '#fusebox.circuit#',
                is_instalment : '#IIf(IsDefined("attributes.is_instalment"),"attributes.is_instalment",DE("0"))#',
                card_paymethod_id : '#attributes.card_paymethod_id#',
                paymethod_id : '#attributes.paymethod_id#',
                paymethod : '#attributes.paymethod#',
                startrow : '#attributes.startrow#',
                maxrows : '#attributes.maxrows#',
                dsn2_alias : '#dsn2_alias#',
                irsaliye_fatura : '#IIf(IsDefined("attributes.irsaliye_fatura"),"attributes.irsaliye_fatura",DE(""))#',
                related_orders : '#IIf(IsDefined("attributes.related_orders"),"attributes.related_orders",DE(""))#',
                use_efatura : '#IIf(IsDefined("attributes.use_efatura"),"attributes.use_efatura",DE(""))#'
            );
        </cfscript>
    <cfelse>
        <cfset arama_yapilmali = 1>
        <cfset get_order_list.recordcount = 0>
    </cfif>
    <cfscript>
        if (isdefined("attributes.keyword")) url_str = "keyword=#attributes.keyword#"; else attributes.keyword = "";
        if (isdefined("attributes.keyword_orderno")) url_str = "#url_str#&keyword_orderno=#attributes.keyword_orderno#"; else attributes.keyword_orderno = "";
        if (isdefined("attributes.currency_id")) url_str = "#url_str#&currency_id=#attributes.currency_id#"; else attributes.currency_id = "";
        if (isdefined("attributes.status"))	url_str = "#url_str#&status=#attributes.status#"; else attributes.status = 1;
    </cfscript>
    <cfinclude template="../sales/query/get_priorities.cfm">
    <cfif isdefined("get_order_list.query_count")>
        <cfparam name="attributes.totalrecords" default="#get_order_list.query_count#">
    <cfelse>
        <cfparam name="attributes.totalrecords" default="#get_order_list.recordcount#">
    </cfif>
    
    <cfquery name="get_process_type" datasource="#DSN#">
        SELECT
            PTR.STAGE,
            PTR.PROCESS_ROW_ID,
            PT.PROCESS_NAME,
            PT.PROCESS_ID
        FROM
            PROCESS_TYPE_ROWS PTR,
            PROCESS_TYPE_OUR_COMPANY PTO,
            PROCESS_TYPE PT
        WHERE
            PT.IS_ACTIVE = 1 AND
            PT.PROCESS_ID = PTR.PROCESS_ID AND
            PT.PROCESS_ID = PTO.PROCESS_ID AND
            PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
            <cfif listlen(attributes.fuseaction,'.') eq 2 and listgetat(attributes.fuseaction,2,'.') is 'list_order_instalment'>
                PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#listfirst(attributes.fuseaction,'.')#.list_order_instalment%">
            <cfelse>
                PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#listfirst(attributes.fuseaction,'.')#.list_order%">
                AND PT.FACTION NOT LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#listfirst(attributes.fuseaction,'.')#.list_order_instalment%">
            </cfif>
        ORDER BY
            PT.PROCESS_NAME,
            PTR.LINE_NUMBER
    </cfquery>
    <cfquery name="get_department_name" datasource="#DSN#">
        SELECT 
            SL.LOCATION_ID,
            SL.COMMENT,
            D.DEPARTMENT_ID,
            D.DEPARTMENT_HEAD,
            D.BRANCH_ID
        FROM
            STOCKS_LOCATION SL,
            DEPARTMENT D
        WHERE 
            SL.DEPARTMENT_ID = D.DEPARTMENT_ID
            AND D.BRANCH_ID IN (SELECT BRANCH_ID FROM BRANCH WHERE COMPANY_ID = #session.ep.company_id#)
        ORDER BY
            D.DEPARTMENT_HEAD,
            SL.COMMENT
    </cfquery>
    <cfquery name="get_branch" datasource="#dsn#">
        SELECT BRANCH_ID,BRANCH_NAME FROM BRANCH WHERE COMPANY_ID = #session.ep.company_id# ORDER BY BRANCH_NAME
    </cfquery>
    <cfif isdefined("attributes.is_instalment")>
        <cfsavecontent variable="head"><cf_get_lang_main no='796.Taksitli Satislar'></cfsavecontent>
    <cfelse>
        <cfsavecontent variable="head"><cf_get_lang no='6.siparisler'></cfsavecontent>
    </cfif>
<cfelseif isdefined("attributes.event") and attributes.event is 'add'>
    <cf_xml_page_edit fuseact="sales.add_fast_sale">
    <cfinclude template="../invoice/query/control_bill_no.cfm">
    <cfscript>session_basket_kur_ekle(process_type:0);</cfscript>
    <cfparam name="attributes.deliver_dept_name" default="">
    <cfparam name="attributes.deliver_dept_id" default="">
    <cfparam name="attributes.deliver_loc_id" default="">
    <cfparam name="attributes.branch_id" default="">
    <cfif isDefined("attributes.offer_id") and Len(attributes.offer_id)>
        <!--- Satis Tekliften donusturulen sipariste, carinin tekliften alinmasi icin eklendi FS 20110120 --->
        <cfquery name="get_offer_info" datasource="#dsn3#">
            SELECT * FROM OFFER WHERE OFFER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.offer_id#">
        </cfquery>
        <cfset attributes.consumer_id = get_offer_info.consumer_id>
        <cfset attributes.company_ıd = get_offer_info.company_id>
        <cfset attributes.partner_id = get_offer_info.partner_id>
        <cfset attributes.project_id = get_offer_info.project_id>
        <cfset attributes.ship_method_id = get_offer_info.ship_method>
        <cfset attributes.card_paymethod_id = get_offer_info.card_paymethod_id>
        <cfset attributes.paymethod_id = get_offer_info.paymethod>
        <cfset attributes.deliverdate = get_offer_info.deliverdate>
        <cfset attributes.ship_address_city_id = get_offer_info.city_id>
        <cfset attributes.ship_address_county_id = get_offer_info.county_id>
        <cfset attributes.ship_address = get_offer_info.ship_address>
    </cfif>
    <!--- add_fast_sale_member.cfm dosyasının kodları--->
    <cfset member_name = ''>
	<cfset member_surname = ''>
    <cfset member_code = ''>
    <cfset member_ozel_code = ''>
    <cfset company_name = ''>
    <cfset member_adres = ''>
    <cfset member_tax_no = ''>
    <cfset member_tax_office = ''>
    <cfset member_county = ''>
    <cfset member_city = ''>
    <cfset member_tc_no = ''>
    <cfset member_tel_cod = ''>
    <cfset member_tel = ''>
    <cfset member_ims_code_id = ''>
    <cfset member_vocation_type=''>
    <cfparam name="attributes.member_type" default="2">
    <cfparam name="attributes.comp_member_cat" default="">
    <cfparam name="attributes.cons_member_cat" default="">
    <cfparam name="attributes.field_vocation" default="">
	<cfset card_link="&field_card_payment_id=form_basket.card_paymethod_id&field_card_payment_name=form_basket.paymethod&field_commission_rate=form_basket.commission_rate&field_paymethod_vehicle=form_basket.paymethod_vehicle">
    <cfif isdefined("attributes.consumer_id") and len(attributes.consumer_id)>
        <cfquery name="get_consumer" datasource="#dsn#">
            SELECT
                CONSUMER_CAT_ID, 
                CONSUMER_ID, 
                MEMBER_CODE, 
                CONSUMER_NAME, 
                CONSUMER_SURNAME, 
                MOBIL_CODE, 
                MOBIL_CODE_2, 
                CONSUMER_HOMETELCODE, 
                CONSUMER_HOMETEL, 
                COMPANY, 
                CONSUMER_STAGE, 
                HOMEADDRESS, 
                HOME_COUNTY_ID, 
                HOME_CITY_ID, 
                WORKSEMT,
                TAX_OFFICE, 
                TAX_NO, 
                MEMBER_TYPE, 
                DEPARTMENT, 
                OZEL_KOD, 
                TC_IDENTY_NO, 
                IMS_CODE_ID, 
                VOCATION_TYPE_ID, 
                RECORD_DATE, 
                RECORD_MEMBER, 
                RECORD_PAR, 
                RECORD_IP, 
                UPDATE_DATE, 
                UPDATE_EMP, 
                UPDATE_IP
            FROM
                CONSUMER
            WHERE
                CONSUMER_ID = #attributes.consumer_id#
        </cfquery>
    <cfelseif isdefined("attributes.company_id") and len(attributes.company_id)>
        <cfquery name="get_company" datasource="#dsn#">
            SELECT 
                COMPANY_ID,
                FULLNAME,
                TAXOFFICE,
                TAXNO,
                COMPANY_ADDRESS,
                COUNTY,
                CITY,
                COUNTRY,
                FULLNAME,
                COMPANY_TELCODE,
                COMPANY_TEL1,
                COMPANY_FAX,
                COMPANY_ADDRESS,
                COMPANY_EMAIL,
                MEMBER_CODE,
                IMS_CODE_ID,
                OZEL_KOD
            FROM
                COMPANY
            WHERE 
                COMPANY.COMPANY_ID=#attributes.company_id#
        </cfquery>
        <cfif isdefined("attributes.partner_id") and len(attributes.partner_id)>
            <cfquery name="get_partner" datasource="#dsn#">
                SELECT 
                    PARTNER_ID, 
                    COMPANY_ID, 
                    MEMBER_CODE, 
                    COMPANY_PARTNER_NAME, 
                    COMPANY_PARTNER_SURNAME, 
                    MOBIL_CODE, 
                    MEMBER_TYPE, 
                    DEPARTMENT, 
                    COUNTY,
                    CITY, 
                    COUNTRY, 
                    RECORD_DATE, 
                    RECORD_PAR, 
                    RECORD_MEMBER, 
                    RECORD_IP, 
                    UPDATE_PAR, 
                    UPDATE_IP, 
                    UPDATE_DATE, 
                    WEB_USER_KEY
                FROM 
                    COMPANY_PARTNER
                WHERE 
                    COMPANY_PARTNER.COMPANY_ID = #attributes.company_id# AND
                    PARTNER_ID= #attributes.partner_id#
            </cfquery>
        </cfif>
    </cfif>
    <cfif isdefined("attributes.consumer_id") and len(attributes.consumer_id)>
        <cfset company_name = ''>
        <cfset member_name = get_consumer.CONSUMER_NAME>
        <cfset member_surname = get_consumer.CONSUMER_SURNAME>
        <cfset member_code = get_consumer.MEMBER_CODE>
        <cfset member_ozel_code = get_consumer.OZEL_KOD>
        <cfset member_adres = get_consumer.HOMEADDRESS>
        <cfset member_tax_no = get_consumer.TAX_NO>
        <cfset member_tax_office = get_consumer.TAX_OFFICE>
        <cfset member_county = get_consumer.HOME_COUNTY_ID>
        <cfset member_city = get_consumer.HOME_CITY_ID>
        <cfset member_tc_no = get_consumer.TC_IDENTY_NO>
        <cfset member_tel_cod = get_consumer.CONSUMER_HOMETELCODE>
        <cfset member_tel = get_consumer.CONSUMER_HOMETEL>
        <cfset member_ims_code_id = get_consumer.IMS_CODE_ID>
        <cfset member_vocation_type=get_consumer.VOCATION_TYPE_ID>
    <cfelseif isdefined("attributes.company_id") and len(attributes.company_id)>
        <cfset company_name = get_company.FULLNAME>
        <cfset member_code = get_company.MEMBER_CODE>
        <cfset member_ozel_code = get_company.OZEL_KOD>
        <cfset member_adres = get_company.COMPANY_ADDRESS>
        <cfset member_tax_no = get_company.TAXNO>
        <cfset member_tax_office = get_company.TAXOFFICE>
        <cfset member_county = get_company.COUNTY>
        <cfset member_city = get_company.CITY>
        <cfset member_tel_cod = get_company.COMPANY_TELCODE>
        <cfset member_tel = get_company.COMPANY_TEL1>
        <cfset member_vocation_type=''>
        <cfif isdefined("attributes.partner_id") and len(attributes.partner_id)>
            <cfset member_name = get_partner.COMPANY_PARTNER_NAME>
            <cfset member_surname = get_partner.COMPANY_PARTNER_SURNAME>
            <cfset member_tc_no = ''>
        </cfif>
    </cfif>
    <cfquery name="get_mobilcat" datasource="#dsn#">
        SELECT MOBILCAT_ID,MOBILCAT	FROM SETUP_MOBILCAT ORDER BY MOBILCAT ASC
    </cfquery>
    <cfquery name="get_vocation_type" datasource="#dsn#">
        SELECT
            VOCATION_TYPE_ID,
            VOCATION_TYPE
        FROM
            SETUP_VOCATION_TYPE
        ORDER BY
            VOCATION_TYPE
    </cfquery>
    <cfquery name="get_city" datasource="#dsn#">
        SELECT CITY_ID, CITY_NAME, PHONE_CODE, COUNTRY_ID,PLATE_CODE FROM SETUP_CITY ORDER BY PRIORITY,CITY_NAME
    </cfquery>
    <cf_workcube_process_info fuseaction="member.form_add_consumer">
    <cfquery name="get_consumer_stage" datasource="#dsn#" maxrows="1">
        SELECT TOP 1
            PTR.STAGE,
            PTR.PROCESS_ROW_ID 
        FROM
            PROCESS_TYPE_ROWS PTR,
            PROCESS_TYPE_OUR_COMPANY PTO,
            PROCESS_TYPE PT
        WHERE
            PT.IS_ACTIVE = 1 AND
            PT.PROCESS_ID = PTR.PROCESS_ID AND
            PT.PROCESS_ID = PTO.PROCESS_ID AND
            PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
            PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%member.form_add_consumer%">
            <cfif isDefined("process_rowid_list") and ListLen(process_rowid_list)>
                AND PTR.PROCESS_ROW_ID IN(#process_rowid_list#)
            </cfif>
        ORDER BY 
            PTR.LINE_NUMBER	
    </cfquery>
    <cfquery name="get_company_stage" datasource="#dsn#" maxrows="1">
        SELECT TOP 1
            PTR.STAGE,
            PTR.PROCESS_ROW_ID 
        FROM
            PROCESS_TYPE_ROWS PTR,
            PROCESS_TYPE_OUR_COMPANY PTO,
            PROCESS_TYPE PT
        WHERE
            PT.IS_ACTIVE = 1 AND
            PT.PROCESS_ID = PTR.PROCESS_ID AND
            PT.PROCESS_ID = PTO.PROCESS_ID AND
            PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
            PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%member.form_add_company%">
        ORDER BY 
            PTR.LINE_NUMBER	
    </cfquery>
    <cfquery name="get_consumer_cat" datasource="#dsn#">
        SELECT CONSCAT_ID FROM CONSUMER_CAT WHERE IS_DEFAULT = 1
    </cfquery>
<cfelseif isdefined("attributes.event") and attributes.event is 'upd'>
	<cf_get_lang_set module_name = "sales">
    <cf_xml_page_edit fuseact="sales.add_fast_sale">
	<cfset is_instalment = 1>
    <cfif isnumeric(attributes.order_id)>
        <cfinclude template="../sales/query/get_order_detail.cfm">
    <cfelse>
        <cfset get_order_detail.recordcount = 0>
    </cfif>
    <cfif not (get_order_detail.recordcount) or (isdefined("attributes.active_company") and attributes.active_company neq session.ep.company_id)>
    	<cfset hata  = 11>
        <cfsavecontent variable="message"><cf_get_lang_main no='585.Şube Yetkiniz Uygun Değil'> <cf_get_lang_main no='586.Veya'> <cf_get_lang_main no='588.Sirketinizde Böyle Bir Sipariş Bulunamadı'> !</cfsavecontent>
        <cfset hata_mesaj  = message>
        <cfinclude template="../../dsp_hata.cfm">
    <cfelse>
        <cfquery name="GET_ORDERS_SHIP" datasource="#DSN3#">
            SELECT ORDER_ID FROM ORDERS_SHIP WHERE ORDER_ID = #get_order_detail.order_id# AND PERIOD_ID = #session.ep.period_id#
        </cfquery>
        <cfquery name="GET_ORDERS_INVOICE" datasource="#DSN3#">
            SELECT ORDER_ID FROM ORDERS_INVOICE WHERE ORDER_ID = #get_order_detail.order_id# AND PERIOD_ID = #session.ep.period_id#
        </cfquery>
        <cfquery name="get_period" datasource="#dsn3#">
            SELECT KASA_PERIOD_ID AS PERIOD_ID FROM ORDER_CASH_POS WHERE ORDER_ID = #get_order_detail.order_id# AND KASA_PERIOD_ID IS NOT NULL AND ORDER_CASH_POS.IS_CANCEL = 0 
        </cfquery>
        <cfif not get_period.recordcount>
            <cfquery name="get_period" datasource="#dsn3#">
                SELECT PERIOD_ID FROM ORDER_VOUCHER_RELATION WHERE ORDER_ID = #get_order_detail.order_id# AND PERIOD_ID IS NOT NULL
            </cfquery>
        </cfif>
        <cfif get_period.recordcount>
            <cfquery name="get_company" datasource="#dsn#">
                SELECT 
                    PERIOD_ID, 
                    PERIOD, 
                    PERIOD_YEAR, 
                    OUR_COMPANY_ID, 
                    OTHER_MONEY, 
                    RECORD_DATE, 
                    RECORD_IP, 
                    RECORD_EMP, 
                    UPDATE_DATE, 
                    UPDATE_IP, 
                    UPDATE_EMP, 
                    PROCESS_DATE 
                FROM 
                    SETUP_PERIOD 
                WHERE 
                    PERIOD_ID = #get_period.period_id#
            </cfquery>
            <cfset new_dsn2 = '#dsn#_#get_company.period_year#_#get_company.our_company_id#'>
            <cfquery name="get_new_period" datasource="#dsn#">
                SELECT 
                    PERIOD_ID, 
                    PERIOD, 
                    PERIOD_YEAR, 
                    OUR_COMPANY_ID, 
                    OTHER_MONEY, 
                    RECORD_DATE, 
                    RECORD_IP, 
                    RECORD_EMP, 
                    UPDATE_DATE, 
                    UPDATE_IP, 
                    UPDATE_EMP, 
                    PROCESS_DATE 
                FROM 
                    SETUP_PERIOD 
                WHERE 
                    OUR_COMPANY_ID = #get_company.our_company_id# 
                AND 
                    PERIOD_YEAR = #get_company.period_year+1#
            </cfquery>
            <cfif get_new_period.recordcount>
                <cfset new_dsn2_1 = '#dsn#_#get_company.period_year+1#_#get_company.our_company_id#'>
            </cfif>
        <cfelse>
            <cfset get_new_period.recordcount = 0>
            <cfset new_dsn2 = '#dsn2#'>
        </cfif>
        <cfquery name="control_cashes" datasource="#dsn3#">
            SELECT 
                ORDER_CASH_POS.KASA_ID,
                CASH_ACTIONS.*
            FROM
                ORDERS,
                ORDER_CASH_POS,
                #new_dsn2#.CASH_ACTIONS CASH_ACTIONS
            WHERE
                CASH_ACTIONS.ACTION_ID=ORDER_CASH_POS.CASH_ID
                AND ORDER_CASH_POS.ORDER_ID=ORDERS.ORDER_ID 
                AND ORDERS.ORDER_ID=#attributes.order_id#
                AND ORDER_CASH_POS.IS_CANCEL = 0
        </cfquery>
        <cfquery name="get_sale_vouchers" datasource="#new_dsn2#">
            SELECT 
                VP.PAYROLL_NO,
                VP.ACTION_ID,
                VP.CASH_PAYMENT_VALUE,
                V.VOUCHER_ID,
                V.VOUCHER_VALUE,
                V.VOUCHER_DUEDATE,
                V.IS_PAY_TERM,
                ISNULL(VP.PAYROLL_CASH_ID,0) PAYROLL_CASH_ID,
                <cfif get_new_period.recordcount>
                    ISNULL((SELECT VV.VOUCHER_STATUS_ID FROM #new_dsn2_1#.VOUCHER VV,#dsn_alias#.CHEQUE_VOUCHER_COPY_REF VC WHERE VV.VOUCHER_ID = VC.TO_CHEQUE_VOUCHER_ID AND VC.IS_CHEQUE = 0 AND V.VOUCHER_ID = VC.FROM_CHEQUE_VOUCHER_ID AND VC.TO_PERIOD_ID = #get_new_period.period_id#) ,VOUCHER_STATUS_ID)  AS VOUCHER_STATUS_ID
                <cfelse>
                    V.VOUCHER_STATUS_ID AS VOUCHER_STATUS_ID
                </cfif>
            FROM 
                VOUCHER V, 
                VOUCHER_PAYROLL VP 
            WHERE 
                V.VOUCHER_PAYROLL_ID = VP.ACTION_ID AND 
                VP.PAYMENT_ORDER_ID = #attributes.order_id#
            ORDER BY
                V.VOUCHER_DUEDATE
        </cfquery>
        <cfquery name="get_sale_cheques" datasource="#new_dsn2#">
            SELECT 
                P.PAYROLL_NO,
                P.ACTION_ID,
                C.CHEQUE_ID,
                C.CHEQUE_VALUE,
                C.CHEQUE_DUEDATE,
                C.BANK_NAME,
                C.BANK_BRANCH_NAME,
                C.CHEQUE_NO,
                C.ACCOUNT_NO,
                ISNULL(P.PAYROLL_CASH_ID,0) PAYROLL_CASH_ID,
                <cfif get_new_period.recordcount>
                    ISNULL((SELECT CC.CHEQUE_STATUS_ID FROM #new_dsn2_1#.CHEQUE CC,#dsn_alias#.CHEQUE_VOUCHER_COPY_REF VC WHERE CC.CHEQUE_ID = VC.TO_CHEQUE_VOUCHER_ID AND VC.IS_CHEQUE = 1 AND C.CHEQUE_ID = VC.FROM_CHEQUE_VOUCHER_ID AND VC.TO_PERIOD_ID = #get_new_period.period_id#) ,CHEQUE_STATUS_ID)  AS CHEQUE_STATUS_ID
                <cfelse>
                    C.CHEQUE_STATUS_ID AS CHEQUE_STATUS_ID
                </cfif>
            FROM 
                CHEQUE C, 
                PAYROLL P 
            WHERE 
                C.CHEQUE_PAYROLL_ID = P.ACTION_ID AND 
                P.PAYMENT_ORDER_ID = #attributes.order_id#
            ORDER BY
                C.CHEQUE_DUEDATE
        </cfquery>
        <cfquery name="get_cashes" datasource="#dsn3#">
            SELECT 
                CASH_ID,
                CASH_NAME,
                CASH_ACC_CODE,
                CASH_CODE,
                BRANCH_ID,		
                CASH_CURRENCY_ID,		
                CASH_EMP_ID
            FROM
                #new_dsn2#.CASH CASH
            WHERE
                CASH_ACC_CODE IS NOT NULL 
                <cfif fusebox.circuit is 'store'>
                    AND 
                    (
                    (CASH.BRANCH_ID IN(SELECT EMPLOYEE_POSITION_BRANCHES.BRANCH_ID FROM #dsn_alias#.EMPLOYEE_POSITION_BRANCHES EMPLOYEE_POSITION_BRANCHES WHERE EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = #session.ep.position_code#))
                    <cfif control_cashes.recordcount>
                        OR
                        CASH.CASH_ID IN(#valuelist(control_cashes.kasa_id)#)					
                    </cfif>
                    <cfif get_sale_vouchers.recordcount>
                        OR
                        CASH.CASH_ID IN(#valuelist(get_sale_vouchers.payroll_cash_id)#)					
                    </cfif>
                    <cfif get_sale_cheques.recordcount>
                        OR
                        CASH.CASH_ID IN(#valuelist(get_sale_cheques.payroll_cash_id)#)					
                    </cfif>
                    )
                </cfif>
            ORDER BY 
                CASH_NAME
        </cfquery>
        <cfquery name="get_pay_vouchers" dbtype="query">
            SELECT * FROM get_sale_vouchers WHERE VOUCHER_STATUS_ID <> 1
        </cfquery>
        <cfquery name="get_total_vouchers" dbtype="query">
            SELECT SUM(VOUCHER_VALUE) AS TOTAL_VALUE FROM get_sale_vouchers WHERE VOUCHER_STATUS_ID <> 1
        </cfquery>
        <cfquery name="get_pay_cheques" dbtype="query">
            SELECT * FROM get_sale_cheques WHERE CHEQUE_STATUS_ID <> 1
        </cfquery>
        <cfquery name="get_total_cheques" dbtype="query">
            SELECT SUM(CHEQUE_VALUE) AS TOTAL_VALUE FROM get_sale_cheques WHERE CHEQUE_STATUS_ID <> 1
        </cfquery>   
    </cfif> 
	<!--- upd_fast_sale_member.cfm dosyasına ait kodlar--->
    <cfif len(get_order_detail.company_id) and get_order_detail.company_id neq 0>
        <cfset comp = "comp">
        <cfquery name="get_order_comp" datasource="#dsn#">
            SELECT 
                COMPANY_ID,
                COMPANYCAT_ID,
                TAXOFFICE,
                TAXNO,
                COMPANY_ADDRESS,
                COUNTY,
                CITY,
                COUNTRY,
                FULLNAME,
                COMPANY_TELCODE,
                COMPANY_TEL1,
                COMPANY_FAX,
                COMPANY_ADDRESS,
                COMPANY_EMAIL,
                IMS_CODE_ID,
                MEMBER_CODE,
                OZEL_KOD,
                MOBIL_CODE,
                MOBILTEL
            FROM
                COMPANY
            WHERE 
                COMPANY.COMPANY_ID=#get_order_detail.company_id#
        </cfquery>
        <cfif len(get_order_detail.partner_id)>
        <cfquery name="get_order_partner" datasource="#dsn#">
            SELECT 
                PARTNER_ID,
                COMPANY_PARTNER_NAME,
                COMPANY_PARTNER_SURNAME
            FROM 
                COMPANY_PARTNER
            WHERE 
                PARTNER_ID= #get_order_detail.partner_id#
        </cfquery>
        </cfif>
    <cfelseif len(get_order_detail.consumer_id)>
        <cfquery name="get_order_consumer" datasource="#dsn#">
            SELECT 
                CONSUMER_CAT_ID, 
                CONSUMER_ID,
                MEMBER_CODE, 
                CONSUMER_NAME, 
                CONSUMER_SURNAME, 
                CONSUMER_EMAIL, 
                MOBIL_CODE, 
                MOBILTEL, 
                MOBIL_CODE_2, 
                MOBILTEL_2, 
                CONSUMER_FAX, 
                CONSUMER_HOMETELCODE, 
                CONSUMER_HOMETEL, 
                COMPANY, 
                HOMEADDRESS, 
                HOME_COUNTY_ID, 
                HOME_CITY_ID, 
                TAX_OFFICE, 
                TAX_NO, 
                MEMBER_TYPE, 
                PERIOD_ID, 
                TITLE, 
                DEPARTMENT, 
                OZEL_KOD, 
                TC_IDENTY_NO, 
                IMS_CODE_ID, 
                VOCATION_TYPE_ID, 
                RECORD_DATE, 
                RECORD_MEMBER, 
                RECORD_IP, 
                UPDATE_DATE, 
                UPDATE_EMP, 
                UPDATE_IP, 
                IS_DELETE
            FROM 
                CONSUMER
            WHERE 
                CONSUMER_ID=#get_order_detail.consumer_id#
        </cfquery>		
    </cfif>
    <cfquery name="GET_BANK_ACTION_INFO" datasource="#dsn3#">
        SELECT
            ORDERS.ORDER_ID 
        FROM
            ORDERS,
            ORDER_CASH_POS,
            CREDIT_CARD_BANK_PAYMENTS_ROWS CC
        WHERE
            ORDERS.ORDER_ID = ORDER_CASH_POS.ORDER_ID AND
            ORDER_CASH_POS.POS_ACTION_ID = CC.CREDITCARD_PAYMENT_ID AND
            CC.BANK_ACTION_ID IS NOT NULL AND
            ORDER_CASH_POS.IS_CANCEL = 0 AND
            ORDERS.ORDER_ID = #get_order_detail.ORDER_ID#
    </cfquery>
    <cfscript>
        session_basket_kur_ekle(action_id=attributes.order_id,table_type_id:3,process_type:1);
        if (len(get_order_detail.company_id))
            {
            member_tax_office=get_order_comp.TAXOFFICE;
            member_tax_no=get_order_comp.TAXNO;
            member_tel_cod=get_order_comp.COMPANY_TELCODE;
            member_tel=get_order_comp.COMPANY_TEL1;
            member_fax=get_order_comp.COMPANY_FAX;											
            member_adres=get_order_comp.COMPANY_ADDRESS;
            member_city=get_order_comp.CITY;
            member_county=get_order_comp.COUNTY;
            member_mail=get_order_comp.COMPANY_EMAIL;
            member_code=get_order_comp.MEMBER_CODE;
            ozel_kod=get_order_comp.OZEL_KOD;
            if (is_ims_code eq 1)
            {
                member_ims_code_id =get_order_comp.IMS_CODE_ID;
            }
            member_mobil_cod=get_order_comp.MOBIL_CODE;
            member_mobil=get_order_comp.MOBILTEL;
            member_mobil_cod_2='';
            member_mobil_2='';
            member_tc_no='';
            member_vocation_type='';
            }
        else if(len(get_order_detail.consumer_id))
            {
            member_tax_office=get_order_consumer.TAX_OFFICE;
            member_tax_no=get_order_consumer.TAX_NO;
            member_tel_cod=get_order_consumer.CONSUMER_HOMETELCODE;
            member_tel=get_order_consumer.CONSUMER_HOMETEL;
            member_fax=get_order_consumer.CONSUMER_FAX;											
            member_adres=get_order_consumer.HOMEADDRESS;
            member_city=get_order_consumer.HOME_CITY_ID;
            member_county=get_order_consumer.HOME_COUNTY_ID;
            member_mail=get_order_consumer.CONSUMER_EMAIL;
            member_code=get_order_consumer.MEMBER_CODE;
            ozel_kod=get_order_consumer.OZEL_KOD;
            if (is_ims_code eq 1)
            {
                member_ims_code_id =get_order_consumer.IMS_CODE_ID;
            }
            member_mobil_cod=get_order_consumer.MOBIL_CODE;
            member_mobil=get_order_consumer.MOBILTEL;
            member_mobil_cod_2=get_order_consumer.MOBIL_CODE_2;
            member_mobil_2=get_order_consumer.MOBILTEL_2;
            member_tc_no=get_order_consumer.TC_IDENTY_NO;
            member_vocation_type=get_order_consumer.VOCATION_TYPE_ID;
            }
    </cfscript>
    <cfparam name="attributes.member_type" default="2">
    <cfparam name="attributes.comp_member_cat" default="">
    <cfparam name="attributes.cons_member_cat" default="">
   	<cfset card_link="&field_card_payment_id=form_basket.card_paymethod_id&field_card_payment_name=form_basket.paymethod&field_commission_rate=form_basket.commission_rate&field_paymethod_vehicle=form_basket.paymethod_vehicle">
    <cfquery name="get_mobilcat" datasource="#dsn#">
        SELECT MOBILCAT_ID,MOBILCAT	FROM SETUP_MOBILCAT ORDER BY MOBILCAT ASC
    </cfquery>
    <cfquery name="get_vocation_type" datasource="#dsn#">
        SELECT
            VOCATION_TYPE_ID,
            VOCATION_TYPE
        FROM
            SETUP_VOCATION_TYPE
        ORDER BY
            VOCATION_TYPE
    </cfquery>
    <cfquery name="get_city" datasource="#dsn#">
        SELECT CITY_ID, CITY_NAME, PHONE_CODE, COUNTRY_ID,PLATE_CODE FROM SETUP_CITY ORDER BY PRIORITY,CITY_NAME
    </cfquery>
</cfif>

<script type="text/javascript">
	<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
		$( document ).ready(function() {
			document.getElementById('keyword').focus();
		});
		<cfif x_select_row_print eq 1 and attributes.listing_type eq 1>
			function send_print_()
			{
				<cfif not get_order_list.recordcount>
					alert("<cf_get_lang no='83.Yazdirilacak Belge Bulunamadi! Toplu Print Yapamazsiniz'>!");
					return false;
				<cfelseif get_order_list.recordcount eq 1>
					if(document.send_print_page.print_islem_id.checked == false)
					{
						alert("<cf_get_lang no='83.Yazdirilacak Belge Bulunamadi! Toplu Print Yapamazsiniz'>!");
						return false;
					}
					else
					{
						ship_list_ = document.send_print_page.print_islem_id.value;
					}
				<cfelseif get_order_list.recordcount gt 1>
					ship_list_ = "";
					for (i=0; i < document.send_print_page.print_islem_id.length; i++)
					{
						if(document.send_print_page.print_islem_id[i].checked == true)
							{
							ship_list_ = ship_list_ + document.send_print_page.print_islem_id[i].value + ',';
							}	
					}
					if(ship_list_.length == 0)
						{
						alert("<cf_get_lang no='83.Yazdirilacak Belge Bulunamadi! Toplu Print Yapamazsiniz'>!");
						return false;
						}																							
				windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_print_files&print_type=73&iid='+ship_list_,'page');
				<cfelse>
						alert("<cf_get_lang no='83.Yazdirilacak Belge Bulunamadi! Toplu Print Yapamazsiniz'>!");
						return false;
					</cfif>
			}
		</cfif>
		function input_control()
		{
			if( !date_check(document.getElementById('start_date'), document.getElementById('finish_date'), "<cf_get_lang_main no='1450.Baslangi Tarihi Bitis Tarihinden Byk Olamaz'>!") )
				return false;
	
			<cfif not session.ep.our_company_info.unconditional_list>
				if(document.getElementById('keyword').value.length == 0 && document.getElementById('keyword_orderno').value.length == 0 && (document.getElementById('employee_id').value.length == 0 || document.getElementById('employee').value.length == 0) &&
					(document.getElementById('member_name').value.length == 0 || (document.getElementById('company_id').value.length == 0 && document.getElementById('consumer_id').value.length == 0)) && 
					(document.getElementById('sales_member_id').value.length == 0 || document.getElementById('sales_member_name').value.length == 0)&&
					(document.getElementById('order_employee_id').value.length == 0 || document.getElementById('order_employee').value.length == 0) && (document.getElementById('start_date').value.length ==0) && (document.getElementById('finish_date').value.length ==0) )
					{
						alert("<cf_get_lang_main no='1538.En az bir alanda filtre etmelisiniz'>!");
						return false;
					}
				else return true;
			<cfelse>
				return true;
			</cfif>
		}
		
		function connectAjax(crtrow,prod_id,stock_id,unit_,order_amount)
		{
			var bb = '<cfoutput>#request.self#?fuseaction=objects.emptypopup_ajax_product_stock_info&sales=1</cfoutput>&pid='+prod_id+'&sid='+ stock_id+'&amount='+ order_amount;
			AjaxPageLoad(bb,'DISPLAY_ORDER_STOCK_INFO'+crtrow,1);
		}
	<cfelseif isdefined("attributes.event") and (attributes.event is 'add')>
		//$( document ).ready(function() {
//			document.form_basket.member_name.focus();
//		});
		function kontrol_form()
		{
			if (form_basket.order_date.value == '')
			{
				alert("Sipariş Tarihi Girmelisiniz!");
				return false;
			}
			<cfif is_required_project eq 1>
				if (form_basket.project_head.value.length ==0)
				{
					alert("<cf_get_lang_main no ='59.Eksik Veri'> : <cf_get_lang_main no ='4.proje'> ");
					return false;
				}
			</cfif>
			if (form_basket.deliverdate.value.length == 0)
			{
				alert("<cf_get_lang no='185.Teslim Tarihi Girmelisiniz'> !");
				return false;
			}	
			if (!date_check(form_basket.order_date,form_basket.deliverdate,"Sipariş Teslim Tarihi, Sipariş Tarihinden Önce Olamaz !"))
				return false;
				
			if(document.getElementById('consumer_id').value != '' && form_basket.tc_num.value=="")
			{
				alert("<cf_get_lang no ='441.Bireysel Müşteri İçin TC Kimlik No Bilgisini Giriniz'>!");
				return false;
			}
			if(form_basket.record_num_3.value > 0 || form_basket.record_num_4.value > 0)
			{
				if(document.all.kontrol_cash.value == 0)
				{
					alert("<cf_get_lang_main no ='59.Eksik Veri'>: <cf_get_lang_main no ='108.Kasa'> <cfoutput>#session.ep.money#</cfoutput> !");
					return false;
				}
			}
			if(form_basket.total_cash_amount.value == '')form_basket.total_cash_amount.value= 0;
			toplam_pesin_tutar = filterNum(form_basket.total_cash_amount.value);
			toplam_fatura_tutar = wrk_round(form_basket.basket_net_total.value,2);
			toplam_senet_tutar = filterNum(form_basket.total_voucher_value.value);
			toplam_h_senet_tutar = filterNum(form_basket.total_voucher_value.value);
			toplam_cek_tutar = filterNum(form_basket.total_cheque_value.value);
			toplam_senet_tutar = wrk_round(toplam_senet_tutar+toplam_pesin_tutar+toplam_cek_tutar,2);
			//if (toplam_fatura_tutar != toplam_senet_tutar) 
	//		{
	//			alert("<cf_get_lang no ='87.Sipariş Tutarı İle Çek , Senet Ve Ödemelerin Toplam Tutarı Eşit Olmalı'> !");
	//			return false;
	//		}
			form_due_value = filterNum(form_basket.basket_due_value.value,2);
			payment_due_value = parseFloat((filterNum(form_basket.total_due_value.value,2)*filterNum(form_basket.total_voucher_value.value))+(filterNum(form_basket.total_cheque_due_value.value,2)*toplam_cek_tutar));
			payment_due_value = parseFloat(payment_due_value / toplam_senet_tutar);
			if (payment_due_value != 0 && payment_due_value > form_due_value) 
			{
				alert("<cf_get_lang no ='89.Ödeme Ortalama Vadesi Siparişin Ortalama Vadesinden Fazla Olamaz Lütfen Çek ve Senetlerinizi Tekrar Düzenleyiniz'>! ");
				return false;
			}
			for(dd=1;dd<=form_basket.record_num_3.value;dd++)
			{
				if(eval("document.form_basket.row_kontrol_3"+dd).value == 1)
				{
					if(eval('form_basket.due_date'+dd).value == '')
					{
						alert("<cf_get_lang no ='90.Lütfen Senetler İçin Vade Tarihi Giriniz'> !");
						return false;
					}
				}
			}
			for(dd=1;dd<=form_basket.record_num_4.value;dd++)
			{
				if(eval("document.form_basket.row_kontrol_4"+dd).value == 1)
				{
					if(eval('form_basket.cheque_due_date'+dd).value == '')
					{
						alert("<cf_get_lang_main no ='59.Eksik Veri'>: <cf_get_lang_main no='469.Vade Tarihi'>");
						return false;
					}
					if(eval('form_basket.cheque_number'+dd).value == '')
					{
						alert("<cf_get_lang_main no ='59.Eksik Veri'>: <cf_get_lang no ='91.Çek Numarası'>");
						return false;
					}
				}
			}
			//sıfır stok
			/*var basket_zero_stock_status = wrk_safe_query('sls_bsk_z_stk_stt','dsn3',0,#attributes.basket_id#);
			if(basket_zero_stock_status.IS_SELECTED != 1)//<!--- basket sablonlarında sıfır stok ile calıs secilmemisse zero_stock kontrolu yapılıyor --->
			{
				if(!zero_stock_control('','',0,'',1)) return false;
			}*/
			<cfif isdefined("xml_upd_row_project") and xml_upd_row_project eq 1>
				project_field_name = 'project_head';
			<cfelse>
				project_field_name = '';
			</cfif>
			<cfif isdefined('x_apply_deliverdate_to_rows') and x_apply_deliverdate_to_rows eq 1>
				date_field_name = 'deliverdate';
			<cfelse>
				date_field_name = '';
			</cfif>
			apply_deliver_date(date_field_name,project_field_name);
			document.all.is_run_voucher_function.value=0;
			return (process_cat_control() && check_cash_pos() && saveForm());
		}
		phone_code_list = new Array(<cfoutput>#valuelist(get_city.phone_code)#</cfoutput>);
		function get_phone_code()
		{	
			if(document.form_basket.city.selectedIndex > 0)
				document.form_basket.tel_code.value = phone_code_list[document.form_basket.city.selectedIndex-1];
			else
				document.form_basket.tel_code.value = '';
		}
		function pencere_ac(no)
		{
			if (document.form_basket.city[document.form_basket.city.selectedIndex].value == "")
				alert("<cf_get_lang no ='400.İlk Olarak İl Seçiniz'> !");
			else
				windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_dsp_county&field_id=form_basket.county_id&field_name=form_basket.county&city_id=' + document.form_basket.city.value,'small');
		}
		function add_adress()
		{
			if(!(form_basket.company_id.value=="") || !(form_basket.consumer_id.value==""))
			{
				if(form_basket.company_id.value!="")
				{
					str_adrlink = '&field_long_adres=form_basket.ship_address&field_member_id='+document.form_basket.company_id.value+'';
					if(form_basket.ship_address_city_id!=undefined) str_adrlink = str_adrlink+'&field_city=form_basket.ship_address_city_id';
					if(form_basket.ship_address_county_id!=undefined) str_adrlink = str_adrlink+'&field_county=form_basket.ship_address_county_id'<cfif fusebox.circuit eq "store">+'&is_store_module='+1</cfif>;
					windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_member_address&is_comp=1&keyword='+encodeURIComponent(form_basket.comp_name.value)+''+ str_adrlink , 'list');
					return true;
				}
				else
				{
					str_adrlink = '&field_long_adres=form_basket.ship_address&field_member_id='+document.form_basket.consumer_id.value+''; 
					if(form_basket.ship_address_city_id!=undefined) str_adrlink = str_adrlink+'&field_city=form_basket.ship_address_city_id';
					if(form_basket.ship_address_county_id!=undefined) str_adrlink = str_adrlink+'&field_county=form_basket.ship_address_county_id'<cfif fusebox.circuit eq "store">+'&is_store_module='+1</cfif>;
					windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_member_address&is_comp=0&keyword='+encodeURIComponent(form_basket.member_name.value)+' '+encodeURIComponent(form_basket.member_surname.value)+''+ str_adrlink , 'list');
					return true;
				}
			}
			else
			{
				alert("<cf_get_lang no='254.Cari Hesap Secmelisiniz'>!");
				return false;
			}
		}
		function pencere_ac_paymethod()
		{
			var str_control=0;
			<cfif x_required_paymethod eq 1>
				if(document.form_basket!=undefined && document.form_basket.basket_id!= undefined && document.form_basket.product_id!= undefined)
				{
					if(document.form_basket.product_id.value!=undefined && document.form_basket.product_id.value!='' )
					{
						str_control=1;
					}
					else if(document.form_basket.product_id.length > 1)
					{
						for(var spt_row=0;spt_row < document.form_basket.product_id.length;spt_row++)
						{
							if(document.form_basket.product_id[spt_row].value!='')
							{
								str_control=1;
								break;
							}
						}
					}
					if(str_control==1)
					{
						alert("<cf_get_lang no ='401.Baskette Ürün Varken Ödeme Yöntemini Değiştiremezsiniz'> !");
					}
				}
			</cfif>
			if(str_control == 0)
				windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_paymethods&field_id=form_basket.paymethod_id&field_name=form_basket.paymethod&field_dueday=form_basket.basket_due_value#card_link#</cfoutput>','list');
		}
		str_cons_link="&field_member_code=form_basket.member_code&field_ozel_kod=form_basket.ozel_kod&field_comp_name=form_basket.comp_name&field_address=form_basket.address&field_mobil_code_2=form_basket.mobil_code_2&field_mobil_tel_2=form_basket.mobil_tel_2&field_mobil_code=form_basket.mobil_code&field_mobil_tel=form_basket.mobil_tel&field_tel_code=form_basket.tel_code&field_tel_number=form_basket.tel_number&field_ims_code=form_basket.tel_number<cfif is_ims_code eq 1>&field_ims_code_id=form_basket.ims_code_id&field_ims_code_name=form_basket.ims_code_name</cfif>";
		str_cons_link=str_cons_link+"&field_tax_office=form_basket.tax_office&field_tax_num=form_basket.tax_num&field_county=form_basket.county&field_county_id=form_basket.county_id&field_city=form_basket.city&field_faxcode=form_basket.faxcode&field_fax_number=form_basket.fax_number&field_tc_no=form_basket.tc_num";
		str_cons_link=str_cons_link+"&field_member_name=form_basket.member_name&field_member_surname=form_basket.member_surname&field_adres_type=form_basket.adres_type";
		str_cons_link=str_cons_link+"&field_company_id=form_basket.company_id&field_partner_id=form_basket.partner_id&field_consumer_id=form_basket.consumer_id";
		str_cons_link = str_cons_link+'&field_vocation=form_basket.vocation_type';
	
		function cons_pre_records()
		{	
			if(((form_basket.member_name.value!="" && form_basket.member_surname.value!="") || form_basket.tc_num.value != "") && form_basket.comp_name.value=="")
				windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_check_consumer_prerecords&call_function=find_risk()&is_from_sale=1<cfif listgetat(attributes.fuseaction,1,'.') is 'store'>&is_store_module=1</cfif>&tc_num=' + form_basket.tc_num.value + '&consumer_name=' + encodeURIComponent(form_basket.member_name.value) + '&consumer_surname=' + encodeURIComponent(form_basket.member_surname.value) + '&tax_no=' + form_basket.tax_num.value +str_cons_link,'project','popup_check_consumer_prerecords');
		}
		function tax_num_pre_records()
		{	
			if(form_basket.tax_num.value!="")
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_check_company_prerecords&is_from_sale=1<cfif listgetat(attributes.fuseaction,1,'.') is 'store'>&is_store_module=1</cfif>&tax_num='+ encodeURIComponent(form_basket.tax_num.value) +'&fullname='+ encodeURIComponent(form_basket.comp_name.value) +'&nickname=' + encodeURIComponent(form_basket.comp_name.value) +'&name='+''+'&surname='+''+'&tel_code='+''+'&telefon='+''+str_cons_link,'project','popup_check_company_prerecords');
		}
		function comp_pre_records()
		{
			if(form_basket.comp_name.value!="" && form_basket.member_name.value=="" && form_basket.member_surname.value=="")
				windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_check_company_prerecords&call_function=find_risk()&is_from_sale=1<cfif listgetat(attributes.fuseaction,1,'.') is 'store'>&is_store_module=1</cfif>&tax_no='+ encodeURIComponent(form_basket.member_tax_no.value) +'&fullname='+ encodeURIComponent(form_basket.comp_name.value) +'&nickname=' + encodeURIComponent(form_basket.comp_name.value) +'&name='+''+'&surname='+''+'&tel_code='+''+'&telefon='+''+str_cons_link,'project','popup_check_company_prerecords');
		}
		function kontrol_member_cat(type)
		{
			if (type == 1)
			{
				is_company.style.display = '';
				is_consumer.style.display = 'none';
				document.getElementById('cons_member_cat').value = '';
			}
			if (type == 2)
			{
				is_company.style.display = 'none';
				is_consumer.style.display = '';
				document.getElementById('comp_member_cat').value = '';
			}
		}
		function kontrol_member()
		{
			if (form_basket.order_date.value == '')
			{
				alert("Sipariş Tarihi Girmelisiniz!");
				return false;
			}
			if(form_basket.member_type[0].checked)
			{
				if(form_basket.comp_name.value=="" || form_basket.tax_office.value=="" || form_basket.tax_num.value=="" || form_basket.address.value=="")
				{
					alert("<cf_get_lang no ='402.Kurumsal Müşteri İçin Firma, Vergi Dairesi, Vergi Numarası ve Adres Bilgilerini Giriniz'>!");
					return false;
				}					
				if(form_basket.company_stage.value=="" && form_basket.company_id.value == "")
				{
					alert("<cf_get_lang no ='403.Kurumsal Üye Süreçlerinizi Kontrol Ediniz'>!");
					return false;
				}
			}
			else if(form_basket.member_type[1].checked)
			{
				if(form_basket.member_name.value=="" || form_basket.member_surname.value=="" || form_basket.address.value=="")
				{
					alert("<cf_get_lang no ='404.Bireysel Müşteri İçin Ad Soyad ve Adres Bilgilerini Giriniz'>!");
					return false;
				}
				<cfif xml_kontrol_tcnumber eq 1>
					if(form_basket.tc_num.value=="")
					{
						alert("<cf_get_lang_main no ='782.Zorunlu Alan'>:<cf_get_lang_main no ='613.TC Kimlik No'>");
						return false;	
					}
				</cfif>
				<cfif is_required_vocation eq 1>
					if(form_basket.vocation_type.value=="")
					{
						alert("<cf_get_lang_main no ='782.Zorunlu Alan'>:<cf_get_lang no ='393.Meslek Tipi'>");
						return false;		
					}
				</cfif>
				if(form_basket.consumer_stage.value=="" && form_basket.consumer_id.value == "")
				{
					alert("<cf_get_lang no ='405.Bireysel Üye Süreçlerinizi Kontrol Ediniz'>!");
					return false;
				}
				<cfif xml_kontrol_tcnumber eq 1>
					var consumer_control = wrk_safe_query('ext_cnsr_ctrl','dsn',0,form_basket.tc_num.value);
					if(consumer_control.recordcount > 0)
					{
						alert("<cf_get_lang no ='533.Aynı TC Kimlik Numarası İle Kayıtlı Üye Var Lütfen Bilgilerinizi Kontrol Ediniz'> !");
						return false;
					}
				</cfif>
			}
			<cfif isdefined("is_dsp_category") and is_dsp_category eq 1>
				if(((document.getElementById('comp_member_cat') != undefined && document.getElementById('comp_member_cat').value == '') || document.getElementById('comp_member_cat') == undefined) && ((document.getElementById('cons_member_cat') != undefined && document.getElementById('cons_member_cat').value == '') || document.getElementById('cons_member_cat') == undefined))
				{
					alert("Lütfen Üye Kategorisi Giriniz!");	
					return false;
				}
			</cfif>
			windowopen('','small','cc_member');
			form_basket.action='<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_add_sale_member</cfoutput>';
			form_basket.target='cc_member';
			form_basket.submit();
			return false;
		}
		function add_adresses()
		{
			if(!(form_basket.company_id.value=="") || !(form_basket.consumer_id.value==""))
			{
				if(form_basket.company_id.value!="")
				{
					str_adrlink = '&field_adres=form_basket.address&field_member_id='+document.form_basket.company_id.value+'';
					if(form_basket.city!=undefined) str_adrlink = str_adrlink+'&field_city=form_basket.city';
					if(form_basket.county_id!=undefined) str_adrlink = str_adrlink+'&field_county=form_basket.county_id';
					if(form_basket.county!=undefined) str_adrlink = str_adrlink+'&field_county_name=form_basket.county';
					windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_member_address&is_comp=1&keyword='+encodeURIComponent(form_basket.comp_name.value)+''+ str_adrlink , 'list');
					return true;
				}
				else
				{
					str_adrlink = '&field_adres=form_basket.address&field_member_id='+document.form_basket.consumer_id.value+''; 
					if(form_basket.city!=undefined) str_adrlink = str_adrlink+'&field_city=form_basket.city';
					if(form_basket.county_id!=undefined) str_adrlink = str_adrlink+'&field_county=form_basket.county_id';
					if(form_basket.county!=undefined) str_adrlink = str_adrlink+'&field_county_name=form_basket.county';
					windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_member_address&is_comp=0&keyword='+encodeURIComponent(form_basket.member_name.value)+' '+form_basket.member_surname.value+'&tc_num='+form_basket.tc_num.value+''+ str_adrlink , 'list');
					return true;
				}
			}
			else
			{
				alert("<cf_get_lang_main no ='303.Önce Üye Seçiniz'>!");
				return false;
			}
	}
	<cfelseif isdefined("attributes.event") and (attributes.event is 'upd')>
		function kontrol_form(type)
		{
			if (form_basket.order_date.value == '')
			{
				alert("Sipariş Tarihi Girmelisiniz!");
				return false;
			}
			if (form_basket.deliverdate.value.length == 0)
			{
				alert("<cf_get_lang no='185.Teslim Tarihi Girmelisiniz'> !");
				return false;
			}	
			if (!date_check(form_basket.order_date,form_basket.deliverdate,"Sipariş Teslim Tarihi, Sipariş Tarihinden Önce Olamaz !"))
				return false;
			
			
			if(document.all.consumer_id.value != '' && form_basket.tc_num.value=="")
			{
				alert("<cf_get_lang no ='441.Bireysel Müşteri İçin TC Kimlik No Bilgisini Giriniz'>!");
				return false;
			}
			if(type == undefined)
			{
				if(form_basket.record_num_3.value > 0 || form_basket.record_num_4.value > 0)
				{
					if(document.all.kontrol_cash.value == 0)
					{
						alert("<cf_get_lang no ='439.Senetler İçin En Az Bir Tane'> <cfoutput>#session.ep.money#</cfoutput><cf_get_lang no ='440.Kasa Ekleyiniz'>  !");
						return false;
					}
				}
				if(form_basket.total_cash_amount.value == '')form_basket.total_cash_amount.value= 0;
				toplam_pesin_tutar = filterNum(form_basket.total_cash_amount.value);
				toplam_fatura_tutar = wrk_round(form_basket.basket_net_total.value,2);
				toplam_senet_tutar = filterNum(form_basket.total_voucher_value.value);
				toplam_h_senet_tutar = filterNum(form_basket.total_voucher_value.value);
				toplam_cek_tutar = filterNum(form_basket.total_cheque_value.value);
				toplam_senet_tutar = wrk_round(toplam_senet_tutar+toplam_pesin_tutar+toplam_cek_tutar,2);
				//if (toplam_fatura_tutar != toplam_senet_tutar) 
	//			{
	//				alert("<cf_get_lang no='87.Sipariş Tutarı İle Çek , Senet Ve Ödemelerin Toplam Tutarı Eşit Olmalı'> !");
	//				return false;
	//			}
				form_due_value = filterNum(form_basket.basket_due_value.value,2);
				payment_due_value = parseFloat((filterNum(form_basket.total_due_value.value,2)*filterNum(form_basket.total_voucher_value.value))+(filterNum(form_basket.total_cheque_due_value.value,2)*toplam_cek_tutar));
				payment_due_value = parseFloat(payment_due_value / toplam_senet_tutar);
				if (payment_due_value != 0 && payment_due_value > form_due_value) 
				{
					alert("<cf_get_lang no='89.Ödeme Ortalama Vadesi Siparişin Ortalama Vadesinden Fazla Olamaz Lütfen Çek ve Senetlerinizi Tekrar Düzenleyiniz'>! ");
					return false;
				}
				for(dd=1;dd<=form_basket.record_num_3.value;dd++)
				{
					if(eval("document.form_basket.row_kontrol_3"+dd).value == 1)
					{
						if(eval('form_basket.due_date'+dd).value == '')
						{
							alert("<cf_get_lang no='90.Lütfen Senetler İçin Vade Tarihi Giriniz'> !");
							return false;
						}
					}
				}
				for(dd=1;dd<=form_basket.record_num_4.value;dd++)
				{
					if(eval("document.form_basket.row_kontrol_4"+dd).value == 1)
					{
						if(eval('form_basket.cheque_due_date'+dd).value == '')
						{
							alert("<cf_get_lang no='616.Lütfen Çekler İçin Vade Tarihi Giriniz'> !");
							return false;
						}
						if(eval('form_basket.cheque_number'+dd).value == '')
						{
							alert("<cf_get_lang no='614.Lütfen Çekler İçin Çek Numarası Giriniz'> !");
							return false;
						}
					}
				}
			}
			else
			{
				toplam_fatura_tutar = wrk_round(form_basket.basket_net_total.value,2);
				if(toplam_fatura_tutar != document.form_basket.old_nettotal.value)
				{
					alert("<cf_get_lang no='615.Sipariş Tutarını Değiştiremezsiniz Lütfen Ürünleri Düzenleyiniz'> !");
					return false;
				}
			}
			//sıfır stok
			//var new_sql = "SELECT IS_SELECTED FROM SETUP_BASKET_ROWS WHERE B_TYPE=1 AND TITLE='zero_stock_status' AND BASKET_ID =  AND B_TYPE=1";
			/*var basket_id_ = '#attributes.basket_id#';
			var basket_zero_stock_status = wrk_safe_query('sls_bsk_z_stk_stt','dsn3',0,basket_id_);
			alert(basket_zero_stock_status.IS_SELECTED);
			if(basket_zero_stock_status.IS_SELECTED != 1)
			{
				if(!zero_stock_control('','',0,'',1)) return false;
			}*/
			<cfif isdefined("is_dsp_category") and is_dsp_category eq 1>
				if(((document.getElementById('comp_member_cat') != undefined && document.getElementById('comp_member_cat').value == '') || document.getElementById('comp_member_cat') == undefined) && ((document.getElementById('cons_member_cat') != undefined && document.getElementById('cons_member_cat').value == '') || document.getElementById('cons_member_cat') == undefined))
				{
					alert("Lütfen Üye Kategorisi Giriniz!");	
					return false;
				}
			</cfif>
			<cfif isdefined("xml_upd_row_project") and xml_upd_row_project eq 1>
				project_field_name = 'project_head';
			<cfelse>
				project_field_name = '';
			</cfif>
			<cfif isdefined('x_apply_deliverdate_to_rows') and x_apply_deliverdate_to_rows eq 1>
				date_field_name = 'deliverdate';
			<cfelse>
				date_field_name = '';
			</cfif>
			apply_deliver_date(date_field_name,project_field_name);
			document.all.is_run_voucher_function.value=0;
			return (process_cat_control() && saveForm());
			return false;
		}
		function kontrol_member_cat(type)
		{
			if (type == 1)
			{
				is_company.style.display = '';
				is_consumer.style.display = 'none';
				document.getElementById('cons_member_cat').value = '';
			}
			if (type == 2)
			{
				is_company.style.display = 'none';
				is_consumer.style.display = '';
				document.getElementById('comp_member_cat').value = '';
			}
		}		
		function kontrol_form2()
		{
			form_basket.del_order_id.value = <cfoutput>#attributes.order_id#</cfoutput>;
				return process_cat_control();
			return true;
		}
		phone_code_list = new Array(<cfoutput>#valuelist(get_city.phone_code)#</cfoutput>);
		function get_phone_code()
		{	
			if(document.form_basket.city.selectedIndex > 0)
				document.form_basket.tel_code.value = phone_code_list[document.form_basket.city.selectedIndex-1];
			else
				document.form_basket.tel_code.value = '';
		}
		function pencere_ac(no)
		{
			if (document.form_basket.city[document.form_basket.city.selectedIndex].value == "")
				alert("<cf_get_lang no ='400.İlk Olarak İl Seçiniz'> !");
			else
				windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_dsp_county&field_id=form_basket.county_id&field_name=form_basket.county&city_id=' + document.form_basket.city.value,'small');
		}
		function add_adress()
		{
			if(!(form_basket.company_id.value=="") || !(form_basket.consumer_id.value==""))
			{
				if(form_basket.company_id.value!="")
				{
					str_adrlink = '&field_long_adres=form_basket.ship_address&field_member_id='+document.form_basket.company_id.value+'';
					if(form_basket.ship_address_city_id!=undefined) str_adrlink = str_adrlink+'&field_city=form_basket.ship_address_city_id';
					if(form_basket.ship_address_county_id!=undefined) str_adrlink = str_adrlink+'&field_county=form_basket.ship_address_county_id'<cfif fusebox.circuit eq "store">+'&is_store_module='+1</cfif>;
					windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_member_address&is_comp=1&keyword='+encodeURIComponent(form_basket.comp_name.value)+''+ str_adrlink , 'list');
					return true;
				}
				else
				{
					str_adrlink = '&field_long_adres=form_basket.ship_address&field_member_id='+document.form_basket.consumer_id.value+''; 
					if(form_basket.ship_address_city_id!=undefined) str_adrlink = str_adrlink+'&field_city=form_basket.ship_address_city_id';
					if(form_basket.ship_address_county_id!=undefined) str_adrlink = str_adrlink+'&field_county=form_basket.ship_address_county_id'<cfif fusebox.circuit eq "store">+'&is_store_module='+1</cfif>;
					windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_member_address&is_comp=0&keyword='+encodeURIComponent(form_basket.member_name.value)+' '+form_basket.member_surname.value+''+ str_adrlink , 'list');
					return true;
				}
			}
			else
			{
				alert("<cf_get_lang no='254.Cari Hesap Secmelisiniz'>!");
				return false;
			}
		}
		function pencere_ac_paymethod()
		{
			var str_control=0;
			<cfif x_required_paymethod eq 1>
				if(document.form_basket!=undefined && document.form_basket.basket_id!= undefined && document.form_basket.product_id!= undefined)
				{
					if(document.form_basket.product_id.value!=undefined && document.form_basket.product_id.value!='' )
					{
						str_control=1;
					}
					else if(document.form_basket.product_id.length > 1)
					{
						for(var spt_row=0;spt_row < document.form_basket.product_id.length;spt_row++)
						{
							if(document.form_basket.product_id[spt_row].value!='')
							{
								str_control=1;
								break;
							}
						}
					}
					if(str_control==1)
					{
						alert("<cf_get_lang no ='401.Baskette Ürün Varken Ödeme Yöntemini Değiştiremezsiniz'> !");
					}
				}
			</cfif>
			if(str_control == 0)
				windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_paymethods&field_id=form_basket.paymethod_id&field_name=form_basket.paymethod&field_dueday=form_basket.basket_due_value#card_link#</cfoutput>','list');
		}
		function add_adresses()
		{
			if(!(form_basket.company_id.value=="") || !(form_basket.consumer_id.value==""))
			{
				if(form_basket.company_id.value!="")
				{
					str_adrlink = '&field_adres=form_basket.address&field_member_id='+document.form_basket.company_id.value+'';
					if(form_basket.city_id!=undefined) str_adrlink = str_adrlink+'&field_city=form_basket.city';
					if(form_basket.county_id!=undefined) str_adrlink = str_adrlink+'&field_county=form_basket.county_id';
					if(form_basket.county!=undefined) str_adrlink = str_adrlink+'&field_county_name=form_basket.county';
					windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_member_address&is_comp=1&keyword='+encodeURIComponent(form_basket.comp_name.value)+''+ str_adrlink , 'list');
					return true;
				}
				else
				{
					str_adrlink = '&field_adres=form_basket.address&field_member_id='+document.form_basket.consumer_id.value+''; 
					if(form_basket.city!=undefined) str_adrlink = str_adrlink+'&field_city=form_basket.city';
					if(form_basket.county_id!=undefined) str_adrlink = str_adrlink+'&field_county=form_basket.county_id';
					if(form_basket.county!=undefined) str_adrlink = str_adrlink+'&field_county_name=form_basket.county';
					windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_member_address&is_comp=0&keyword='+encodeURIComponent(form_basket.member_name.value)+' '+form_basket.member_surname.value+'&tc_num='+form_basket.tc_num.value+''+ str_adrlink , 'list');
					return true;
				}
			}
			else
			{
				alert("<cf_get_lang_main no ='303.Önce Üye Seçiniz'>!");
				return false;
			}
		}
		function sayfa_getir()
		{
			if(confirm("<cf_get_lang no ='444.Teslim Tarihi Güncellenecek Emin misiniz'> ?") == true)
				AjaxPageLoad('<cfoutput>#request.self#?fuseaction=#fusebox.circuit#.emptypopup_upd_fast_sale_deliverdate&order_id=#attributes.order_id#</cfoutput>&deliver_date='+document.form_basket.deliverdate.value,'deliverdate_div');
		}
		function sayfa_getir_2()
		{
			if(confirm("<cf_get_lang no ='613.Aşama Güncellenecek Emin misiniz'> ?") == true)
				AjaxPageLoad('<cfoutput>#request.self#?fuseaction=#fusebox.circuit#.emptypopup_upd_fast_sale_deliverdate&order_id=#attributes.order_id#</cfoutput>&deliver_date='+document.form_basket.deliverdate.value+'&process_cat='+document.form_basket.process_stage.value,'process_div');
		}
	</cfif>
</script>

<cfscript>
	// Switch //
	WOStruct = StructNew();
	
	WOStruct['#attributes.fuseaction#'] = structNew();
	
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'sales.list_order_instalment';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'sales/display/list_order.cfm';
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'sales.list_order_instalment';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'sales/form/add_fast_sale.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'sales/query/add_fast_sale.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'sales.list_order_instalment&event=upd';
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'sales.list_order_instalment';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'sales/form/upd_fast_sale.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'sales/query/upd_fast_sale.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'sales.list_order_instalment&event=upd';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'order_id=##attributes.order_id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.order_id##';
	
	if(isdefined("attributes.event") and attributes.event is 'upd')
	{
		WOStruct['#attributes.fuseaction#']['del'] = structNew();
		WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
		WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'sales.list_order_instalment&order_id=#attributes.order_id#';
		WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'sales/query/upd_fast_sale.cfm';
		WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'sales/query/upd_fast_sale.cfm';
		WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'sales.list_order_instalment';
		WOStruct['#attributes.fuseaction#']['del']['parameters'] = 'order_id=##attributes.order_id##';
	}
	
	// Tab Menus //
	tabMenuStruct = StructNew();
	tabMenuStruct['#attributes.fuseaction#'] = structNew();
	tabMenuStruct['#attributes.fuseaction#']['tabMenus'] = structNew();
	// Upd //
	if(isdefined("attributes.event") and attributes.event is 'upd')
	{
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'] = structNew();
		if((not get_orders_ship.recordcount or GET_ORDERS_INVOICE.recordcount eq 0) and not len(get_order_detail.cancel_date))
		{
			if(fusebox.circuit is 'store')
			{
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['text'] = '#lang_array.item[373]#';//Fatura Kes
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['href'] = "#request.self#?fuseaction=store.add_sale_invoice_from_order&order_id=#attributes.order_id#";

			}
			else
			{
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['text'] = '#lang_array.item[373]#';//Fatura Kes
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['href'] = "#request.self#?fuseaction=invoice.add_sale_invoice_from_order&order_id=#attributes.order_id#";
			}
		}
		if(len(get_order_detail.consumer_id))
		{
			if(not denied_pages is 'myhome.my_consumer_details')
			{				
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][1]['text'] = '#lang_array_main.item[163]#';//Üye Bilgileri
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][1]['href'] = "#request.self#?fuseaction=myhome.my_consumer_details&cid=#get_order_detail.consumer_id#";
			}
			if(not denied_pages is 'member.detail_consumer')
			{				
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][2]['text'] = '#lang_array_main.item[163]#';//Üye Bilgileri
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][2]['href'] = "#request.self#?fuseaction=member.detail_consumer&cid=#get_order_detail.consumer_id#";
			}

			if(not denied_pages is 'contract.detail_contract_company')
			{				
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][3]['text'] = '#lang_array.item[429]#';//Risk ve Çalışma Bilgileri
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][3]['href'] = "#request.self#?fuseaction=contract.detail_contract_company&consumer_id=#get_order_detail.consumer_id#";
			}
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][4]['text'] = '#lang_array_main.item[397]#';//Hesap Ekstresi
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][4]['onClick'] = "windowopen('#request.self#?fuseaction=ch.list_company_extre&member_type=consumer&member_id=#get_order_detail.consumer_id#','page')";
		}
		else
		{
			if(not denied_pages is 'myhome.my_company_details')
			{				
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][1]['text'] = '#lang_array_main.item[163]#';//Üye Bilgileri
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][1]['href'] = "#request.self#?fuseaction=myhome.my_company_details&cpid=#get_order_detail.company_id#";
			}
			if(not denied_pages is 'member.detail_company')
			{				
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][2]['text'] = '#lang_array.item[428]#';//Üye Detay
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][2]['href'] = "#request.self#?fuseaction=member.detail_company&cpid=#get_order_detail.company_id#";
			}
			if(not denied_pages is 'contract.detail_contract_company')
			{				
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][3]['text'] = '#lang_array.item[429]#';//Risk ve Çalışma Bilgileri
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][3]['href'] = "#request.self#?fuseaction=contract.detail_contract_company&company_id=#get_order_detail.company_id#";
			}
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][4]['text'] = '#lang_array_main.item[397]#';//Hesap Ekstresi
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][4]['onClick'] = "windowopen('#request.self#?fuseaction=ch.list_company_extre&member_type=partner&member_id=#get_order_detail.company_id#','page')";
		}
		if(not denied_pages is 'objects.popup_list_order_history')
		{				
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][5]['text'] = '#lang_array.item[47]#';//Tarihçe
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][5]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_list_order_history&order_id=#url.ORDER_ID#&portal_type=employee','project')";
		}
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][6]['text'] = '#lang_array_main.item[345]#';//Uyarılar
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][6]['onClick'] = "windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_page_warnings&action=#listgetat(attributes.fuseaction,1,'.')#.upd_fast_sale&action_name=order_id&action_id=#attributes.order_id#&relation_papers_type=ORDER_ID</cfoutput>','list')";
		if(not denied_pages is 'sales.popup_list_pluses_order')
		{				
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][7]['text'] = '#lang_array.item[62]#';//Takipler
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][7]['onClick'] = "windowopen('<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.popup_list_pluses_order&order_id=#attributes.order_id#</cfoutput>','wide2')";
		}
		if(not denied_pages is 'objects.popup_list_order_receive_rate')
		{				
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][8]['text'] = '#lang_array.item[65]#';//Sipariş Karşılama Raporu
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][8]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_list_order_receive_rate&is_sale=1&order_id=#attributes.order_id#','list')";
		}
		if(not denied_pages is 'sales.popup_add_order_cancel' and not len(get_order_detail.cancel_date) and get_pay_vouchers.recordcount eq 0 and get_pay_cheques.recordcount eq 0)
		{				
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][9]['text'] = '#lang_array.item[430]#';//Satış İptal
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][9]['onClick'] = "windowopen('#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.popup_add_order_cancel&order_id=#attributes.order_id#','page')";
		}
		else if(len(get_order_detail.cancel_date))
		{
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][9]['text'] = '#lang_array.item[431]#';//İptal Detay
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][9]['onClick'] = "windowopen('#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.popup_dsp_order_cancel&order_id=#attributes.order_id#','small')";
		}
		if(get_module_user(22))
		{				
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][10]['text'] = 'Muhasebe Hareketleri';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][10]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_list_order_account_cards&order_id=#attributes.order_id#','page','upd_bill')";
		}
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][11]['text'] = '#lang_array.item[434]#';//Satış Ekle
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][11]['href'] = "#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.add_fast_sale";
		if (fusebox.circuit is 'store')
			fac_ = "store" ;
		else 
			fac_ = "purchase";	
		if(not denied_pages is '#fac_#.add_order_product_all_criteria')//and fusebox.circuit is not 'store' 
		{				
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][12]['text'] = '#lang_array.item[372]#';//Satınalma Siparişi Oluştur
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][12]['href'] = "#request.self#?fuseaction=#fac_#.add_order_product_all_criteria&order_id=#url.order_id#&active_company_id=#session.ep.company_id#";
		}
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][13]['text'] = '#lang_array.item[433]#';//Senet Yazdır
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][13]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_print_files&action_id=#url.order_id#&print_type=115','page')";			
			
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = 'Ekle';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=sales.list_order_instalment&event=add";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['text'] = '#lang_array_main.item[62]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_print_files&action_id=#url.order_id#&print_type=73','page')";
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	WOStruct['#attributes.fuseaction#']['extendedForm'] = structNew();
	WOStruct['#attributes.fuseaction#']['extendedForm']['controllerFileName'] = 'OrderInstalmentController';
	WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'ORDERS';
	WOStruct['#attributes.fuseaction#']['extendedForm']['dataSourceName'] = 'company';
	WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "['item-member_name','item-process_stage','item-order_date','item-deliver_loc_id']"; // Bu atama yapılmazsa sayfada her alan değiştirilebilir olur.
</cfscript>