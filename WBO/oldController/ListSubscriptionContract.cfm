<cf_get_lang_set module_name = 'sales'>
<cfif not isdefined("attributes.event") or (isdefined("attributes.event") and attributes.event is 'list')><!--- Liste--->
    <cf_xml_page_edit fuseact ="sales.list_subscription_contract">
    <cfparam name="attributes.start_date" default="">
    <cfparam name="attributes.finish_date" default="">
    <cfparam name="attributes.process_stage_type" default="">
    <cfparam name="attributes.product_name" default="">
    <cfparam name="attributes.product_id" default="">
    <cfparam name="attributes.subscription_type" default="">
    <cfparam name="attributes.sale_add_option" default="">
    <cfparam name="attributes.subs_add_option" default="">
    <cfparam name="attributes.keyword" default="">
    <cfparam name="attributes.keyword_no" default="">
    <cfparam name="attributes.adress_keyword" default="">
    <cfparam name="attributes.semt_keyword" default="">
    <cfparam name="attributes.member_cat_type" default="">
    <cfparam name="attributes.sort_type" default="4">
    <cfparam name="attributes.project_id" default="">
    <cfparam name="attributes.project_head" default="">
    <cfparam name="attributes.use_efatura" default="">
    <cfparam name="attributes.page" default="1">
    <cfparam name="attributes.maxrows" default='#session.ep.maxrows#'> 
    <cfset attributes.startrow = ((attributes.page-1)*attributes.maxrows) + 1 >
    <cfif isdefined("attributes.form_submitted")> 
        <cfinclude template="../sales/query/get_subscriptions.cfm"> 
    <cfelse> 
        <cfset get_subscriptions.recordCount = 0>
    </cfif> 
    <cfinclude template="../sales/query/get_subscription_type.cfm">
    <cfinclude template="../sales/query/get_subs_add_option.cfm">
    <cfinclude template="../sales/query/get_sale_add_option.cfm">
    <cfquery name="GET_SERVICE_STAGE" datasource="#DSN#">
        SELECT
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
            PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%sales.add_subscription_contract%">
        ORDER BY
            PTR.LINE_NUMBER
    </cfquery>
    <cfquery name="GET_COMPANY_CAT" datasource="#DSN#">
        SELECT DISTINCT	
            COMPANYCAT_ID,
            COMPANYCAT
        FROM
            GET_MY_COMPANYCAT
        WHERE
            EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"> AND
            OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
        ORDER BY
            COMPANYCAT
    </cfquery>
    <cfquery name="GET_CONSUMER_CAT" datasource="#DSN#">
        SELECT DISTINCT	
            CONSCAT_ID,
            CONSCAT,
            HIERARCHY
        FROM
            GET_MY_CONSUMERCAT
        WHERE
            EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"> AND
            OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
        ORDER BY
            HIERARCHY		
    </cfquery>
    
    <cfif get_subscriptions.recordcount>
        <cfparam name="attributes.totalrecords" default='#get_subscriptions.QUERY_COUNT#'>
    <cfelse>
        <cfparam name="attributes.totalrecords" default='0'>
    </cfif>
<cfelseif isdefined("attributes.event") and attributes.event is 'add'><!--- Ekleme --->
    <cfquery name="GET_COUNTY_" datasource="#DSN#">
        SELECT COUNTY_ID,COUNTY_NAME FROM SETUP_COUNTY
    </cfquery>
    <cfquery name="GET_CITY_" datasource="#DSN#">
        SELECT CITY_ID,CITY_NAME FROM SETUP_CITY
    </cfquery>
    <cfquery name="GET_COUNTRY_" datasource="#DSN#">
        SELECT
            COUNTRY_ID,
            COUNTRY_NAME
        FROM
            SETUP_COUNTRY
        ORDER BY
            COUNTRY_NAME
    </cfquery>
    <cfquery name="GET_SALE_ADD_OPTION" datasource="#DSN3#">
        SELECT 
            SERVICE_ADD_OPTION_ID,
            SERVICE_ADD_OPTION_NAME
        FROM
            SETUP_SERVICE_ADD_OPTIONS
        ORDER BY
            SERVICE_ADD_OPTION_NAME
    </cfquery>
    <cfquery name="GET_SALES_ZONES" datasource="#dsn#">
        SELECT IS_ACTIVE,SZ_ID,SZ_NAME FROM SALES_ZONES 
    </cfquery>
    <cfinclude template="../sales/query/get_subs_add_option.cfm">
    <cfif isdefined('attributes.company_id') or isdefined('attributes.partner_id') or isdefined('attributes.consumer_id')>
        <cfinclude template="../sales/query/get_address.cfm">
    </cfif>
    <cfquery name="get_ref_state" datasource="#dsn3#">
        SELECT REFERANCE_STATUS,REFERANCE_STATUS_ID FROM SETUP_REFERANCE_STATUS WHERE IS_ACTIVE = 1
    </cfquery>
    <cf_xml_page_edit fuseact="sales.add_subscription_contract">
    <cfquery name="GET_MONEY_INFO" datasource="#dsn2#">
        SELECT * FROM SETUP_MONEY ORDER BY MONEY_ID
    </cfquery>
    <cfif isDefined("attributes.subscription_id")><!--- sistem kopyalama için --->
        <cfinclude template="../sales/query/get_subsciption_contract.cfm">
        <cfset attributes.company_id = get_subscription.company_id>
        <cfset attributes.consumer_id = get_subscription.consumer_id>
        <cfset attributes.partner_id = get_subscription.partner_id>
        <cfset attributes.invoice_consumer_id = get_subscription.invoice_consumer_id>
        <cfset attributes.invoice_company_id = get_subscription.invoice_company_id>
        <cfset attributes.invoice_partner_id = get_subscription.invoice_partner_id>
        <cfif len(get_subscription.company_id)>
            <cfset attributes.member_type = 'partner'>
            <cfset attributes.member_name = get_par_info(get_subscription.company_id,1,1,0)>
        <cfelse>
            <cfset attributes.member_type = 'consumer'>
            <cfset attributes.member_name = get_cons_info(get_subscription.consumer_id,2,0)>
        </cfif>
        <cfif len(get_subscription.invoice_company_id)>
            <cfset attributes.invoice_member_name = get_par_info(get_subscription.invoice_company_id,1,1,0)>
        <cfelseif len(get_subscription.invoice_consumer_id)>
            <cfset attributes.invoice_member_name = get_cons_info(get_subscription.invoice_consumer_id,1,0)>
        </cfif>
        <cfset attributes.subs_type = get_subscription.subscription_type_id>
        <cfset attributes.special_code = get_subscription.special_code>
        <cfset attributes.sales_emp_id = get_subscription.sales_emp_id>
        <cfset attributes.sales_emp = get_emp_info(get_subscription.sales_emp_id,0,0)>
        <cfif len(get_subscription.sales_partner_id)>
            <cfset attributes.sales_member_id = get_subscription.sales_partner_id>
            <cfset attributes.sales_member_type = "partner">
            <cfset attributes.sales_company_id = get_subscription.sales_company_id>
            <cfset attributes.sales_member = get_par_info(get_subscription.sales_partner_id,0,0,0)>
        <cfelseif len(get_subscription.sales_consumer_id)>
            <cfset attributes.sales_member_id = get_subscription.sales_consumer_id>
            <cfset attributes.sales_member_type = "consumer">
            <cfset attributes.sales_company_id = "">
            <cfset attributes.sales_member = get_cons_info(get_subscription.sales_consumer_id,1,0)>
        </cfif>
        <cfif len(get_subscription.ref_partner_id)>
            <cfset attributes.ref_company_id = get_subscription.ref_company_id>
            <cfset attributes.ref_company = get_par_info(get_subscription.ref_partner_id,0,1,0)>
            <cfset attributes.ref_member_id = get_subscription.ref_partner_id>
            <cfset attributes.ref_member_type = "partner">
            <cfset attributes.ref_member = get_par_info(get_subscription.ref_partner_id,0,-1,0)>
        <cfelseif len(get_subscription.ref_consumer_id)>
            <cfset attributes.ref_member_id = get_subscription.ref_consumer_id>
            <cfset attributes.ref_member_type = "consumer">
            <cfset attributes.ref_member = get_cons_info(get_subscription.ref_consumer_id,0,0)>
        <cfelseif len(get_subscription.ref_employee_id)>
            <cfset attributes.ref_member_id = get_subscription.ref_employee_id>
            <cfset attributes.ref_member_type = "employee">
            <cfset attributes.ref_member = get_emp_info(get_subscription.ref_employee_id,0,0)>
        </cfif>
        <cfset attributes.subscription_product_id = get_subscription.product_id>
        <cfset attributes.subscription_stock_id = get_subscription.stock_id>
        <cfif len(get_subscription.product_id)>
            <cfset attributes.subscription_product_name = get_product_name(product_id:get_subscription.PRODUCT_ID)>
        </cfif>
        <cfset attributes.subs_add_opt = get_subscription.subscription_add_option_id>
        <cfset attributes.sales_add_opt = get_subscription.sales_add_option_id>
        <cfset attributes.detail = get_subscription.subscription_detail>
        <cfset attributes.project_id = get_subscription.project_id>
        <cfset attributes.montage_emp_id = get_subscription.montage_emp_id>
        <cfset attributes.montage_emp = get_emp_info(get_subscription.montage_emp_id,0,0)>
        <cfset attributes.ship_sales_zone_id = get_subscription.ship_sz_id>
        <cfset attributes.invoice_sales_zone_id = get_subscription.invoice_sz_id>
        <cfset attributes.contact_sales_zone_id = get_subscription.contact_sz_id>
        <cfset attributes.ship_address = get_subscription.ship_address>
        <cfset attributes.ship_postcode = get_subscription.ship_postcode>
        <cfset attributes.ship_semt = get_subscription.ship_semt>
        <cfset attributes.ship_id = get_subscription.INVOICE_ADDRESS_ID> 
        <cfset attributes.alias = get_subscription.ALIAS> 
        <cfset attributes.ship_coordinate_1 = get_subscription.ship_coordinate_1>
        <cfset attributes.ship_coordinate_2 = get_subscription.ship_coordinate_2>
        <cfset attributes.invoice_coordinate_1 = get_subscription.invoice_coordinate_1>
        <cfset attributes.invoice_coordinate_2 = get_subscription.invoice_coordinate_2>
        <cfset attributes.contact_coordinate_1 = get_subscription.contact_coordinate_1>
        <cfset attributes.contact_coordinate_2 = get_subscription.contact_coordinate_2>
        <cfset attributes.invoice_address = get_subscription.invoice_address>
        <cfset attributes.contact_address = get_subscription.contact_address>
        <cfset attributes.invoice_postcode = get_subscription.invoice_postcode>
        <cfset attributes.contact_postcode = get_subscription.contact_postcode>
        <cfset attributes.invoice_semt = get_subscription.invoice_semt>
        <cfset attributes.contact_semt = get_subscription.contact_semt>
        <cfset attributes.ship_county_id = get_subscription.ship_county_id>
        <cfset attributes.ship_city_id = get_subscription.ship_city_id>
        <cfset attributes.ship_country_id = get_subscription.ship_country_id>
        <cfset attributes.invoice_county_id = get_subscription.invoice_county_id>
        <cfset attributes.invoice_city_id = get_subscription.invoice_city_id>
        <cfset attributes.invoice_country_id = get_subscription.invoice_country_id> 
        <cfset attributes.contact_county_id = get_subscription.contact_county_id> 
        <cfset attributes.contact_city_id = get_subscription.contact_city_id> 
        <cfset attributes.contact_country_id = get_subscription.contact_country_id>    
    </cfif>
    <cfif isDefined("attributes.subscription_id")>
        <cfset county_list = ''>
        <cfset city_list = ''>
        <cfset country_list = ''>
        
        <cfset county_list = Listappend(county_list,'#get_subscription.ship_county_id#,#get_subscription.invoice_county_id#,#get_subscription.contact_county_id#',',')>
        <cfset city_list = ListAppend(city_list,'#get_subscription.ship_city_id#,#get_subscription.invoice_city_id#,#get_subscription.contact_city_id#',',')>
        <cfset country_list = ListAppend(country_list,'#get_subscription.ship_country_id#,#get_subscription.invoice_country_id#,#get_subscription.contact_country_id#',',')>
        
        <cfset county_list = ListSort(ListDeleteDuplicates(county_list),'Numeric','ASC',',')>
        <cfset city_list = ListSort(ListDeleteDuplicates(city_list),'Numeric','ASC',',')>
        <cfset country_list = ListSort(ListDeleteDuplicates(country_list),'Numeric','ASC',',')>
        <cfif len(county_list)>
            <cfquery name="GET_COUNTY" datasource="#DSN#">
                SELECT COUNTY_NAME,COUNTY_ID FROM SETUP_COUNTY WHERE COUNTY_ID IN (#county_list#) ORDER BY COUNTY_ID
            </cfquery>
            <cfset main_county_list = listsort(listdeleteduplicates(valuelist(get_county.county_id,',')),'numeric','ASC',',')>
        </cfif>
        <cfif len(city_list)>
            <cfquery name="GET_CITY" datasource="#DSN#">
                SELECT CITY_NAME,CITY_ID FROM SETUP_CITY WHERE CITY_ID IN (#city_list#) ORDER BY CITY_ID
            </cfquery>
            <cfset main_city_list = listsort(listdeleteduplicates(valuelist(get_city.city_id,',')),'numeric','ASC',',')>
        </cfif>
        <cfif len(country_list)>
            <cfquery name="GET_COUNTRY" datasource="#DSN#">
                SELECT COUNTRY_NAME,COUNTRY_ID FROM SETUP_COUNTRY WHERE COUNTRY_ID IN (#country_list#) ORDER BY COUNTRY_ID
            </cfquery>
            <cfset main_country_list = listsort(listdeleteduplicates(valuelist(get_country.country_id,',')),'numeric','ASC',',')>
        </cfif>
    </cfif>
    <!--- MT: Abonede şube ilşkisinin tutulması için eklendi--->
    <cfquery name="GET_BRANCH_ALL" datasource="#DSN#">
        SELECT  
            BRANCH.BRANCH_NAME, 
            BRANCH.BRANCH_ID,
            BRANCH.COMPANY_ID
        FROM 
            BRANCH
    </cfquery>
    <cfscript>session_basket_kur_ekle(process_type:0);</cfscript>
    <cfif xml_kontrol_product eq 1>
        <cfset on_submit = "return (unformat_fields());">
    <cfelse>
        <cfset on_submit = "return (unformat_fields());">
    </cfif>
	<cfset str_linke_ait="field_partner=form_basket.partner_id&field_consumer=form_basket.consumer_id&field_comp_id=form_basket.company_id&field_comp_name=form_basket.company_name&field_name=form_basket.member_name&field_type=form_basket.member_type&call_function=kontrol_prerecord()">
    <cfset str_linke_ait="#str_linke_ait#&field_address=form_basket.ship_address&field_postcode=form_basket.ship_postcode&field_semt=form_basket.ship_semt&field_county=form_basket.ship_county_id&field_county_id=form_basket.ship_county_id&field_city=form_basket.ship_city_id&field_city_id=form_basket.ship_city_id&field_country=form_basket.ship_country_id&field_country_id=form_basket.ship_country_id">
    <cfset str_linke_ait="#str_linke_ait#&field_address2=form_basket.invoice_address&field_postcode2=form_basket.invoice_postcode&field_semt2=form_basket.invoice_semt&field_county2=form_basket.invoice_county_id&field_county_id2=form_basket.invoice_county_id&field_city2=form_basket.invoice_city_id&field_city_id2=form_basket.invoice_city_id&field_country2=form_basket.invoice_country_id&field_country_id2=form_basket.invoice_country_id">
    <cfset str_linke_ait="#str_linke_ait#&field_address3=form_basket.contact_address&field_postcode3=form_basket.contact_postcode&field_semt3=form_basket.contact_semt&field_county3=form_basket.contact_county_id&field_county_id3=form_basket.contact_county_id&field_city3=form_basket.contact_city_id&field_city_id3=form_basket.contact_city_id&field_country3=form_basket.contact_country_id&field_country_id3=form_basket.contact_country_id">
    <cfset str_linke_ait="#str_linke_ait#&ship_coordinate_1=form_basket.ship_coordinate_1&ship_coordinate_2=form_basket.ship_coordinate_2&invoice_coordinate_1=form_basket.invoice_coordinate_1&invoice_coordinate_2=form_basket.invoice_coordinate_2&contact_coordinate_1=form_basket.contact_coordinate_1&contact_coordinate_2=form_basket.contact_coordinate_2">
    <cfset str_linke_ait="#str_linke_ait#&ship_sales_zone_id=form_basket.ship_sales_zone_id&invoice_sales_zone_id=form_basket.invoice_sales_zone_id&contact_sales_zone_id=form_basket.contact_sales_zone_id">
	<cfset str_linke_ait2="field_member_name=form_basket.invoice_member_name&field_consumer=form_basket.invoice_consumer_id&field_comp_id=form_basket.invoice_company_id&field_name=form_basket.invoice_member_name&field_partner=form_basket.invoice_partner_id">
    <cfset str_linke_ait2="#str_linke_ait2#&field_address=form_basket.invoice_address&field_postcode=form_basket.invoice_postcode&field_semt=form_basket.invoice_semt&field_county=form_basket.invoice_county&field_county_id=form_basket.invoice_county_id&field_city=form_basket.invoice_city&field_city_id=form_basket.invoice_city_id&field_country=form_basket.invoice_country&field_country_id=form_basket.invoice_country_id">
<cfelseif isdefined("attributes.event") and attributes.event is 'upd'><!--- Güncelleme --->
    <cf_xml_page_edit fuseact ="sales.upd_subscription_contract">
    <cfquery name="GET_MONEY_INFO" datasource="#dsn2#">
        SELECT * FROM SETUP_MONEY ORDER BY MONEY_ID
    </cfquery>
    <cfquery name="Get_Subs_Row" datasource="#dsn3#">
    	SELECT SUBSCRIPTION_ID FROM SUBSCRIPTION_CONTRACT_ROW WHERE SUBSCRIPTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.subscription_id#">
    </cfquery>
    <input type="hidden" name="rowcount" id="rowcount" value="<cfoutput>#Get_Subs_Row.RecordCount#</cfoutput>">
    <cfinclude template="../sales/query/get_upd_subscription_contact.cfm">
    <cfif not get_subscription.recordcount>
        <cfset hata  = 10>
        <cfinclude template="../../dsp_hata.cfm">
    </cfif>
    <!--- Sistem silmek icin yapilan kontrol --->
    <cfquery name="CONTROL_PAYMENT_PLAN" datasource="#DSN3#"><!--- Odeme Plani --->
        SELECT SUBSCRIPTION_ID,ISNULL(IS_COLLECTED_PROVISION,0) IS_COLLECTED_PROVISION,ISNULL(IS_PAID,0) IS_PAID FROM SUBSCRIPTION_PAYMENT_PLAN_ROW WHERE SUBSCRIPTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.subscription_id#">
    </cfquery>
    <cfquery name="CONTROL_SERVICE" datasource="#DSN3#"><!--- Servis --->
        SELECT SUBSCRIPTION_ID FROM SERVICE WHERE SUBSCRIPTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.subscription_id#">
    </cfquery>
    <cfquery name="CONTROL_ORDER" datasource="#DSN3#"><!--- Siparis --->
        SELECT SUBSCRIPTION_ID FROM SUBSCRIPTION_CONTRACT_ORDER WHERE SUBSCRIPTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.subscription_id#">
    </cfquery>
    <cfquery name="CONTROL_COUNTER_RESULT" datasource="#DSN3#"><!--- Sayac Okuma Belgesi --->
        SELECT SUBSCRIPTION_ID FROM SUBSCRIPTION_COUNTER_RESULT WHERE SUBSCRIPTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.subscription_id#">
    </cfquery>
    <cfquery name="GET_SALES_ZONES" datasource="#dsn#">
        SELECT IS_ACTIVE,SZ_ID,SZ_NAME FROM SALES_ZONES 
    </cfquery>
    <cfif xml_control_payment_rows eq 1><!--- xml den ödeme planı satırları kontrol edilsin mi seçeneği seçilmişse --->
        <cfquery name="control_prov_rows" dbtype="query">
            SELECT SUBSCRIPTION_ID FROM CONTROL_PAYMENT_PLAN WHERE IS_COLLECTED_PROVISION = <cfqueryparam cfsqltype="cf_sql_smallint" value="1"> AND IS_PAID = <cfqueryparam cfsqltype="cf_sql_smallint" value="0">
        </cfquery>
    </cfif>
    <cfquery name="get_ref_state" datasource="#dsn3#">
        SELECT 
            REFERANCE_STATUS,
            REFERANCE_STATUS_ID 
        FROM 
            SETUP_REFERANCE_STATUS 
        WHERE 
            IS_ACTIVE = 1
        <cfif len(get_subscription.REFERANCE_STATUS_ID)>
        UNION 
        SELECT
            REFERANCE_STATUS,
            REFERANCE_STATUS_ID 
        FROM 
            SETUP_REFERANCE_STATUS 
        WHERE
            REFERANCE_STATUS_ID  = #get_subscription.REFERANCE_STATUS_ID#
        </cfif>
    </cfquery>
    <cfset county_list = ''>
    <cfset city_list = ''>
    <cfset country_list = ''>
    
    <cfset county_list = Listappend(county_list,'#get_subscription.ship_county_id#,#get_subscription.invoice_county_id#,#get_subscription.contact_county_id#',',')>
    <cfset city_list = ListAppend(city_list,'#get_subscription.ship_city_id#,#get_subscription.invoice_city_id#,#get_subscription.contact_city_id#',',')>
    <cfset country_list = ListAppend(country_list,'#get_subscription.ship_country_id#,#get_subscription.invoice_country_id#,#get_subscription.contact_country_id#',',')>
    
    <cfset county_list = ListSort(ListDeleteDuplicates(county_list),'Numeric','ASC',',')>
    <cfset city_list = ListSort(ListDeleteDuplicates(city_list),'Numeric','ASC',',')>
    <cfset country_list = ListSort(ListDeleteDuplicates(country_list),'Numeric','ASC',',')>
    <cfif len(county_list)>
        <cfquery name="GET_COUNTY" datasource="#DSN#">
            SELECT COUNTY_NAME,COUNTY_ID FROM SETUP_COUNTY WHERE COUNTY_ID IN (#county_list#) ORDER BY COUNTY_ID
        </cfquery>
        <cfset main_county_list = listsort(listdeleteduplicates(valuelist(get_county.county_id,',')),'numeric','ASC',',')>
    </cfif>
    <cfif len(city_list)>
        <cfquery name="GET_CITY" datasource="#DSN#">
            SELECT CITY_NAME,CITY_ID FROM SETUP_CITY WHERE CITY_ID IN (#city_list#) ORDER BY CITY_ID
        </cfquery>
        <cfset main_city_list = listsort(listdeleteduplicates(valuelist(get_city.city_id,',')),'numeric','ASC',',')>
    </cfif>
    <cfif len(country_list)>
        <cfquery name="GET_COUNTRY" datasource="#DSN#">
            SELECT COUNTRY_NAME,COUNTRY_ID FROM SETUP_COUNTRY WHERE COUNTRY_ID IN (#country_list#) ORDER BY COUNTRY_ID
        </cfquery>
        <cfset main_country_list = listsort(listdeleteduplicates(valuelist(get_country.country_id,',')),'numeric','ASC',',')>
    </cfif>
    
    <cfscript>session_basket_kur_ekle(action_id=attributes.subscription_id,table_type_id:13,process_type:1);</cfscript>
    <cfinclude template="../sales/query/get_subscription_type.cfm">
    <cfinclude template="../sales/query/get_subs_add_option.cfm">
    <cfquery name="GET_SALE_ADD_OPTION" datasource="#DSN3#">
        SELECT 
            SERVICE_ADD_OPTION_ID,
            SERVICE_ADD_OPTION_NAME
        FROM
            SETUP_SERVICE_ADD_OPTIONS
        ORDER BY
            SERVICE_ADD_OPTION_NAME
    </cfquery>
    <cfquery name="GET_MEMBER_CC" datasource="#DSN#">
        SELECT
        <cfif len(get_subscription.partner_id)>
            CC.COMPANY_CC_ID MEMBER_CC_ID,
            CC.COMPANY_ID MEMBER_ID,
            CC.COMPANY_CC_TYPE MEMBER_CC_TYPE,
            CC.COMPANY_CC_NUMBER MEMBER_CC_NUMBER,
            CC.COMPANY_EX_MONTH MEMBER_EX_MONTH,
            CC.COMPANY_EX_YEAR MEMBER_EX_YEAR
        <cfelse>
            CC.CONSUMER_CC_ID MEMBER_CC_ID,
            CC.CONSUMER_ID MEMBER_ID,
            CC.CONSUMER_CC_TYPE MEMBER_CC_TYPE,
            CC.CONSUMER_CC_NUMBER MEMBER_CC_NUMBER,
            CC.CONSUMER_EX_MONTH MEMBER_EX_MONTH,
            CC.CONSUMER_EX_YEAR MEMBER_EX_YEAR
        </cfif>
        ,IS_DEFAULT
        FROM
        <cfif len(get_subscription.partner_id)>
            COMPANY_CC CC
        <cfelse>
            CONSUMER_CC CC
        </cfif>
        WHERE
        <cfif len(get_subscription.partner_id)>
            CC.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_subscription.company_id#">
        <cfelse>
            CC.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_subscription.consumer_id#">
        </cfif>	
            AND IS_DEFAULT = 1
    </cfquery>
    <!--- MT: Abonede şube ilşkisinin tutulması için eklendi--->
    <cfquery name="GET_BRANCH_ALL" datasource="#DSN#">
        SELECT  
            BRANCH.BRANCH_NAME, 
            BRANCH.BRANCH_ID,
            BRANCH.COMPANY_ID
        FROM 
            BRANCH
    </cfquery>
    <!--- 
        FA-09102013
        kredi kartı Gelişmiş şifreleme standartları ile şifrelenmesi. 
        Bu sistemin çalışması için sistem/güvenlik altında kredi kartı şifreleme anahtarlırının tanımlanması gerekmektedir 
    --->
    <cfscript>
        getCCNOKey = createObject("component", "settings.cfc.setupCcnoKey");
        getCCNOKey.dsn = dsn;
        getCCNOKey1 = getCCNOKey.getCCNOKey1();
        getCCNOKey2 = getCCNOKey.getCCNOKey2();
    </cfscript>
    
    <cfif len(get_subscription.partner_id)>
        <cfscript>
            contact_type = "p";
            contact_id = get_subscription.partner_id;
            par_id = get_subscription.partner_id;
        </cfscript>
    <cfelseif len(get_subscription.consumer_id)>
        <cfscript>
            contact_type = "c";
            contact_id = get_subscription.consumer_id;
            con_id = get_subscription.consumer_id;
        </cfscript>
    <cfelse>
        <cfscript>
            contact_type = '';
            contact_id = '';
        </cfscript>
    </cfif>
    <cfquery name="GET_COUNTY_" datasource="#DSN#">
        SELECT COUNTY_ID,COUNTY_NAME FROM SETUP_COUNTY
    </cfquery>
    <cfquery name="GET_CITY_" datasource="#DSN#">
        SELECT CITY_ID,CITY_NAME FROM SETUP_CITY
    </cfquery>
    <cfquery name="GET_COUNTRY_" datasource="#DSN#">
        SELECT
            COUNTRY_ID,
            COUNTRY_NAME
        FROM
            SETUP_COUNTRY
        ORDER BY
            COUNTRY_NAME
    </cfquery>
    <!--- basvuru ekle icin eklenen form--->
    <form name="add_service" method="post" action="<cfoutput>#request.self#?fuseaction=service.list_service&event=add<cfif isdefined("get_subscription.subscription_id")>&subscrt_id=#get_subscription.subscription_id#</cfif></cfoutput>">
        <input type="hidden" name="subscription_id" id="subscription_id" value="<cfoutput>#get_subscription.subscription_id#</cfoutput>">
        <input type="hidden" name="subscription_no" id="subscription_no" value="<cfoutput>#get_subscription.subscription_no#</cfoutput>">
        <cfset other_shipp_address = ''>
        <cfif len(get_subscription.ship_county_id)>
            <cfset other_shipp_address = get_county.county_name[listfind(main_county_list,get_subscription.ship_county_id,',')]>
        </cfif>
        <cfif len(get_subscription.ship_city_id)>
            <cfset other_shipp_address = other_shipp_address&' '&get_city.city_name[listfind(main_city_list,get_subscription.ship_city_id,',')]>
        </cfif>
        <cfif len(get_subscription.ship_country_id)>
            <cfset other_shipp_address = other_shipp_address&' '&get_country.country_name[listfind(main_country_list,get_subscription.ship_country_id,',')]>
        </cfif>
        <input type="hidden" name="service_address" id="service_address" value="<cfoutput>#get_subscription.ship_address# #get_subscription.ship_postcode# #get_subscription.ship_semt# #other_shipp_address#</cfoutput>">
        <cfoutput>
            <input type="hidden" name="service_county_id" id="service_county_id" value="#get_subscription.ship_county_id#" />
            <input type="hidden" name="service_city_id" id="service_city_id" value="#get_subscription.ship_city_id#" />    
            <input type="hidden" name="service_country_id" id="service_country_id" value="#get_subscription.ship_country_id#" />    
        </cfoutput>
        <cfif len(get_subscription.partner_id)>
            <input type="hidden" name="member_type" id="member_type" value="partner">
            <input type="hidden" name="member_id" id="member_id" value="<cfoutput>#get_subscription.partner_id#</cfoutput>">
            <input type="hidden" name="company_id" id="company_id" value="<cfoutput>#get_subscription.company_id#</cfoutput>">
        <cfelse>
            <input type="hidden" name="member_type" id="member_type" value="consumer">
            <input type="hidden" name="member_id" id="member_id" value="<cfoutput>#get_subscription.consumer_id#</cfoutput>">
            <input type="hidden" name="company_id" id="company_id" value="">
        </cfif>
    </form>
    <!--- basvuru listesi icin eklenen form--->
    <!--- callcenter basvuru ekle icin eklenen form--->
    <form name="add_call_center" method="post" action="<cfoutput>#request.self#</cfoutput>?fuseaction=call.add_service">
        <input type="hidden" name="subscription_id" id="subscription_id" value="<cfoutput>#get_subscription.subscription_id#</cfoutput>">
        <input type="hidden" name="subscription_no" id="subscription_no" value="<cfoutput>#get_subscription.subscription_no#</cfoutput>">
        <cfif len(get_subscription.partner_id)>
            <input type="hidden" name="consumer_id" id="consumer_id" value="">
            <input type="hidden" name="partner_id" id="partner_id" value="<cfoutput>#get_subscription.partner_id#</cfoutput>">
            <input type="hidden" name="company_id" id="company_id" value="<cfoutput>#get_subscription.company_id#</cfoutput>">
        <cfelse>
            <input type="hidden" name="consumer_id" id="consumer_id" value="<cfoutput>#get_subscription.consumer_id#</cfoutput>">
            <input type="hidden" name="partner_id" id="partner_id" value="">
            <input type="hidden" name="company_id" id="company_id" value="">
        </cfif>
    </form>
    <!--- basvuru listesi icin eklenen form--->
    <form name="list_service" method="post" action="<cfoutput>#request.self#</cfoutput>?fuseaction=service.list_service">
      <input type="hidden" name="subscription_id" id="subscription_id" value="<cfoutput>#get_subscription.subscription_id#</cfoutput>">
      <input type="hidden" name="subscription_no" id="subscription_no" value="<cfoutput>#get_subscription.subscription_no#</cfoutput>">
      <input type="hidden" name="form_submitted" id="form_submitted" value="1">
    </form>
    <!--- callcenter basvuru listesi icin eklenen form--->
    <form name="list_call_center" method="post" action="<cfoutput>#request.self#</cfoutput>?fuseaction=call.list_service">
      <input type="hidden" name="subscription_id" id="subscription_id" value="<cfoutput>#get_subscription.subscription_id#</cfoutput>">
      <input type="hidden" name="subscription_no" id="subscription_no" value="<cfoutput>#get_subscription.subscription_no#</cfoutput>">
      <input type="hidden" name="form_submitted" id="form_submitted" value="1">
    </form>
    <!--- Fatura Ekleme icin eklenen form (Sayac ve Odeme Planından)--->
    <cfform name="add_invoice" method="post" action="<cfoutput>#request.self#</cfoutput>?fuseaction=invoice.form_add_bill">
        <cfif len(get_subscription.invoice_company_id)>
            <input type="hidden" name="company_id" id="company_id" value="<cfoutput>#get_subscription.invoice_company_id#</cfoutput>">
            <input type="hidden" name="partner_id" id="partner_id" value="<cfoutput>#get_subscription.invoice_partner_id#</cfoutput>">
            <input type="hidden" name="comp_name" id="comp_name" value="<cfoutput>#get_par_info(get_subscription.invoice_company_id,1,1,0)#</cfoutput>">
            <input type="hidden" name="consumer_id" id="consumer_id" value="">
            <input type="hidden" name="partner_name" id="partner_name" value="<cfoutput>#get_par_info(get_subscription.invoice_partner_id,0,-1,0)#</cfoutput>">
            <input type="hidden" name="member_account_code" id="member_account_code" value="<cfoutput>#get_company_period(get_subscription.invoice_company_id)#</cfoutput>">
        <cfelse>
            <input type="hidden" name="company_id" id="company_id" value="">
            <input type="hidden" name="partner_id" id="partner_id" value="">
            <input type="hidden" name="comp_name" id="comp_name" value="">
            <input type="hidden" name="consumer_id" id="consumer_id" value="<cfoutput>#get_subscription.invoice_consumer_id#</cfoutput>">
            <input type="hidden" name="partner_name" id="partner_name" value="<cfoutput>#get_cons_info(get_subscription.invoice_consumer_id,0,0)#</cfoutput>">
            <input type="hidden" name="member_account_code" id="member_account_code" value="<cfoutput>#get_consumer_period(get_subscription.invoice_consumer_id)#</cfoutput>">
        </cfif>
        <input type="hidden" name="city_id" id="city_id" value="">
        <input type="hidden" name="county_id" id="county_id" value="">
        <input type="hidden" name="adres" id="adres" value="">
        <input type="hidden" name="subscription_id" id="subscription_id" value="<cfoutput>#get_subscription.subscription_id#</cfoutput>">
        <input type="hidden" name="list_payment_row_id" id="list_payment_row_id" value="">
        <!--- Ödeme Planındaki faturalanmamis satirlarin tek tek faturalanması icin --->
    </cfform>
    <cfset str_linke_ait="field_partner=form_basket.partner_id&field_consumer=form_basket.consumer_id&field_comp_id=form_basket.company_id&field_comp_name=form_basket.company_name&field_name=form_basket.member_name&field_type=form_basket.member_type">
    <cfset str_linke_ait="#str_linke_ait#&field_address=form_basket.ship_address&field_postcode=form_basket.ship_postcode&field_semt=form_basket.ship_semt&field_county=form_basket.ship_county_id&field_county_id=form_basket.ship_county_id&field_city=form_basket.ship_city_id&field_city_id=form_basket.ship_city_id&field_country=form_basket.ship_country_id&field_country_id=form_basket.ship_country_id">
    <cfset str_linke_ait="#str_linke_ait#&field_address2=form_basket.invoice_address&field_postcode2=form_basket.invoice_postcode&field_semt2=form_basket.invoice_semt&field_county2=form_basket.invoice_county_id&field_county_id2=form_basket.invoice_county_id&field_city2=form_basket.invoice_city_id&field_city_id2=form_basket.invoice_city_id&field_country2=form_basket.invoice_country_id&field_country_id2=form_basket.invoice_country_id">
    <cfset str_linke_ait="#str_linke_ait#&field_address3=form_basket.contact_address&field_postcode3=form_basket.contact_postcode&field_semt3=form_basket.contact_semt&field_county3=form_basket.contact_county_id&field_county_id3=form_basket.contact_county_id&field_city3=form_basket.contact_city_id&field_city_id3=form_basket.contact_city_id&field_country3=form_basket.contact_country_id&field_country_id3=form_basket.contact_country_id">
    <cfset str_linke_ait="#str_linke_ait#&ship_coordinate_1=form_basket.ship_coordinate_1&ship_coordinate_2=form_basket.ship_coordinate_2&invoice_coordinate_1=form_basket.invoice_coordinate_1&invoice_coordinate_2=form_basket.invoice_coordinate_2&contact_coordinate_1=form_basket.contact_coordinate_1&contact_coordinate_2=form_basket.contact_coordinate_2">
    <cfset str_linke_ait="#str_linke_ait#&ship_sales_zone_id=form_basket.ship_sales_zone_id&invoice_sales_zone_id=form_basket.invoice_sales_zone_id&contact_sales_zone_id=form_basket.contact_sales_zone_id">
	<cfset str_linke_ait2="field_member_name=form_basket.invoice_member_name&field_consumer=form_basket.invoice_consumer_id&field_comp_id=form_basket.invoice_company_id&field_name=form_basket.invoice_member_name&field_partner=form_basket.invoice_partner_id">
    <cfset str_linke_ait2="#str_linke_ait2#&field_address=form_basket.invoice_address&field_postcode=form_basket.invoice_postcode&field_semt=form_basket.invoice_semt&field_county=form_basket.invoice_county&field_county_id=form_basket.invoice_county_id&field_city=form_basket.invoice_city&field_city_id=form_basket.invoice_city_id&field_country=form_basket.invoice_country&field_country_id=form_basket.invoice_country_id">
	
	<!---<cfif isdefined('attributes.opp_id')>
        <cfset href ='#request.self#?fuseaction=sales.emptypopup_upd_subscription_contract&opp_id=#attributes.opp_id#'>
    <cfelse>
        <cfset href ='#request.self#?fuseaction=sales.emptypopup_upd_subscription_contract'>
    </cfif>
	<cfif xml_kontrol_product eq 1>
    	<cfset on_submit = "return (unformat_fields());">
    <cfelse>
    	<cfset on_submit = "return (unformat_fields());">
    </cfif>--->
</cfif>

<!---Script Bloğu--->
<script type="text/javascript">
	<cfif not isdefined("attributes.event") or (isdefined("attributes.event") and attributes.event is 'list')>//Liste
		$( document ).ready(function() {
			document.getElementById('keyword').focus();
		});	
		function county_temizle()
		{
			if(subscription_list.county.value.length == 0) subscription_list.county_id.value='';
		}
		
		function city_temizle()
		{
			if(subscription_list.city.value.length == 0) subscription_list.city_id.value='';
		}
	<cfelseif isdefined("attributes.event") and attributes.event is 'add'>//Ekleme
		function add_adress(adress_type)
		{
			if(!(form_basket.partner_id.value=="") || !(form_basket.consumer_id.value==""))
			{	
				if(form_basket.partner_id.value!="")
				{
					if(adress_type==1)
					{
						str_adrlink = '&field_adres=form_basket.ship_address&field_city=form_basket.ship_city_id&field_county=form_basket.ship_county_id&field_country=form_basket.ship_country_id&field_postcode=form_basket.ship_postcode&field_semt=form_basket.ship_semt&coordinate_1=form_basket.ship_coordinate_1&coordinate_2=form_basket.ship_coordinate_2&sales_zone=form_basket.ship_sales_zone_id'; 
						windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_member_address&is_comp=1&keyword='+encodeURIComponent(form_basket.company_name.value)+''+ str_adrlink , 'list');
						return true;
					}
					else if(adress_type==2)
					{
						str_adrlink = '&field_adres=form_basket.invoice_address&field_city=form_basket.invoice_city_id&field_county=form_basket.invoice_county_id&field_country=form_basket.invoice_country_id&field_postcode=form_basket.invoice_postcode&field_semt=form_basket.invoice_semt&coordinate_1=form_basket.invoice_coordinate_1&coordinate_2=form_basket.invoice_coordinate_2&sales_zone=form_basket.invoice_sales_zone_id&alias=form_basket.alias&field_adress_id=form_basket.ship_id'; 
						windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_member_address&is_comp=1&keyword='+encodeURIComponent(form_basket.company_name.value)+''+ str_adrlink , 'list');
						return true;
					}
					else if(adress_type==3)
					{
						str_adrlink = '&field_adres=form_basket.contact_address&field_city=form_basket.contact_city_id&field_county=form_basket.contact_county_id&field_country=form_basket.contact_country_id&field_postcode=form_basket.contact_postcode&field_semt=form_basket.contact_semt&coordinate_1=form_basket.contact_coordinate_1&coordinate_2=form_basket.contact_coordinate_2&sales_zone=form_basket.contact_sales_zone_id'; 
						windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_member_address&is_comp=1&keyword='+encodeURIComponent(form_basket.company_name.value)+''+ str_adrlink , 'list');
						return true;
					}			
				}
				else
				{
					if(adress_type==1)
					{
						str_adrlink = '&field_adres=form_basket.ship_address&field_city=form_basket.ship_city_id&field_county=form_basket.ship_county_id&field_country=form_basket.ship_country_id&field_postcode=form_basket.ship_postcode&field_semt=form_basket.ship_semt&coordinate_1=form_basket.ship_coordinate_1&coordinate_2=form_basket.ship_coordinate_2&sales_zone=form_basket.ship_sales_zone_id'; 
						windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_member_address&is_comp=0&keyword='+encodeURIComponent(form_basket.member_name.value)+''+ str_adrlink , 'list');
						return true;
					}
					else if(adress_type==2)
					{
						str_adrlink = '&field_adres=form_basket.invoice_address&field_city=form_basket.invoice_city_id&field_county=form_basket.invoice_county_id&field_country=form_basket.invoice_country_id&field_postcode=form_basket.invoice_postcode&field_semt=form_basket.invoice_semt&coordinate_1=form_basket.invoice_coordinate_1&coordinate_2=form_basket.invoice_coordinate_2&sales_zone=form_basket.invoice_sales_zone_id'; 
						windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_member_address&is_comp=0&keyword='+encodeURIComponent(form_basket.member_name.value)+''+ str_adrlink , 'list');
						return true;
					}
					else if(adress_type==3)
					{
						str_adrlink = '&field_adres=form_basket.contact_address&field_city=form_basket.contact_city_id&field_county=form_basket.contact_county_idfield_country=form_basket.contact_country_id&field_postcode=form_basket.contact_postcode&field_semt=form_basket.contact_semt&coordinate_1=form_basket.contact_coordinate_1&coordinate_2=form_basket.contact_coordinate_2&sales_zone=form_basket.contact_sales_zone_id'; 
						windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_member_address&is_comp=0&keyword='+encodeURIComponent(form_basket.member_name.value)+''+ str_adrlink , 'list');
						return true;
					}
				}
			}
			else
			{
				alert("<cf_get_lang no='302.Müşteri Seçiniz'> !");
				return false;
			}		
		}
		function del_alias(alias_adres_type)
		{
			if(alias_adres_type == 1)
			{
			document.getElementById('alias').value='';
			document.getElementById('ship_id').value='';
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_all_pars&<cfoutput>#str_linke_ait#</cfoutput>&select_list=2,3','list','popup_list_all_pars');
			}
			if(alias_adres_type == 2)
			{
				document.getElementById('alias').value='';
			document.getElementById('ship_id').value='';
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_all_pars&<cfoutput>#str_linke_ait2#</cfoutput>&select_list=2,3','list','popup_list_all_pars');	
			}
		}
		function add_kontrol()
		{
			if((document.form_basket.partner_id.value == "") && (document.form_basket.consumer_id.value == ""))
			{
				alert("<cf_get_lang no='302.Müşteri Seçiniz'> !");
				return false;
			}
			
			a = document.form_basket.subscription_type.selectedIndex;
			if (document.form_basket.subscription_type[a].value == "")
			{ 
				alert ("<cf_get_lang no='292.Sistem Kategorisi Seçiniz'> ");
				document.getElementById('subscription_type').focus();
				return false;
			}
			
			x = (300 - document.form_basket.ship_address.value.length);
			if ( x < 0)
			{ 
				alert ("<cf_get_lang no='2.Sevk Adresi'><cf_get_lang no ='510.Alanina 300 Karakterden Fazla Girmeyiniz Fazla Karakter Sayısı'>"+ ((-1) * x));
				return false;
			}
		
			y = (300 - document.form_basket.invoice_address.value.length);
			if ( y < 0)
			{ 
				alert ("<cf_get_lang no='283.Fatura Adresi'><cf_get_lang no ='510.Alanina 300 Karakterden Fazla Girmeyiniz Fazla Karakter Sayısı'>"+ ((-1) * x));
				return false;
			}
		
			z = (300 - document.form_basket.contact_address.value.length);
			if ( z < 0)
			{ 
				alert ("<cf_get_lang no='284.Irtibat Adresi'><cf_get_lang no ='510.Alanina 300 Karakterden Fazla Girmeyiniz Fazla Karakter Sayısı'>"+ ((-1) * x));
				return false;
			}
		
			t = (500 - document.form_basket.detail.value.length);
			if ( t < 0 )
			{ 
				alert ("<cf_get_lang_main no='217.Aciklama'><cf_get_lang no ='513.Alanina 500 Karakterden Fazla Girmeyiniz Fazla Karakter Sayısı'>"+ ((-1) * x));
				return false;
			}
			
			if(!(document.form_basket.start_date.value == "") && !(document.form_basket.finish_date.value == ""))
			{
				if(!date_check(document.form_basket.start_date,document.form_basket.finish_date,"<cf_get_lang no ='514.Başlangıç Bitiş Tarihlerini Kontrol Ediniz'>!"))
				{	
					return false;
				}
			}	
			
			<cfif isdefined("xml_service_definition") and xml_service_definition eq 1>
				if((document.form_basket.valid_days.value == 1) && (document.form_basket.start_clock_1.value == 0) && (document.form_basket.finish_clock_1.value == 0) && (document.form_basket.start_minute_1.value == 0) && (document.form_basket.finish_minute_1.value == 0) )
				{
					alert("<cf_get_lang no='59.Hafta İçi Destek Saatlerini Seçiniz'> ! ");
					return false;
				}
				
				if((document.form_basket.valid_days.value == 2) && (document.form_basket.start_clock_1.value == 0) && (document.form_basket.finish_clock_1.value == 0) && (document.form_basket.start_minute_1.value == 0) && (document.form_basket.finish_minute_1.value == 0) )
				{
					alert("<cf_get_lang no='61.Hafta İçi Ve Cumartesi Destek Saatlerini Seçiniz'> ! ");
					return false;
				}
				
				if((document.form_basket.valid_days.value == 2) && (document.form_basket.start_clock_2.value == 0) && (document.form_basket.finish_clock_2.value == 0) && (document.form_basket.start_minute_2.value == 0) && (document.form_basket.finish_minute_2.value == 0))
				{
					alert("<cf_get_lang no='66.Cumartesi Destek Saatlerini Seçiniz'> ! ");
					return false;
				}
				
				if((document.form_basket.valid_days.value == 3) && (document.form_basket.start_clock_1.value == 0) && (document.form_basket.finish_clock_1.value == 0) && (document.form_basket.start_minute_1.value == 0) && (document.form_basket.finish_minute_1.value == 0) )
				{
					alert("<cf_get_lang no='67.Hafta İçi, Cumartesi Ve Pazar Destek Saatlerini Seçiniz'> ! ");
					return false;
				}
				
				if((document.form_basket.valid_days.value == 3) && (document.form_basket.start_clock_2.value == 0) && (document.form_basket.finish_clock_2.value == 0) && (document.form_basket.start_minute_2.value == 0) && (document.form_basket.finish_minute_2.value == 0))
				{
					alert("<cf_get_lang no='68.Cumartesi ve Pazar Destek Saatlerini Seçiniz'> ! ");
					return false;
				}
				
				if((document.form_basket.valid_days.value == 3) && (document.form_basket.start_clock_3.value == 0) && (document.form_basket.finish_clock_3.value == 0) && (document.form_basket.start_minute_3.value == 0) && (document.form_basket.finish_minute_3.value == 0))
				{
					alert("<cf_get_lang no='69.Pazar Destek Saatlerini Seçiniz'> ! ");
					return false;
				}
				
				start_1 = parseInt(document.form_basket.start_clock_1.value) * 60 ;
				sonuc_1 = start_1 +  parseInt(document.form_basket.start_minute_1.value);
				finish_1 = parseInt(document.form_basket.finish_clock_1.value) * 60 ;
				sonuc_2 = finish_1 +  parseInt(document.form_basket.finish_minute_1.value);
				if( sonuc_1 > sonuc_2)
				{	
					alert("<cf_get_lang no='70.Hafta İçi İçin Uygun Saat Değeri Giriniz'> ! ");
					return false;
				}
				
				start_2 = parseInt(document.form_basket.start_clock_2.value) * 60 ;
				sonuc_3 = start_2 +  parseInt(document.form_basket.start_minute_2.value);
				finish_2 = parseInt(document.form_basket.finish_clock_2.value) * 60 ;
				sonuc_4 = finish_2 +  parseInt(document.form_basket.finish_minute_2.value);
				if( sonuc_3 > sonuc_4)
				{	
					alert("<cf_get_lang no='71.Cumartesi Günü İçin Uygun Saat Değeri Giriniz'> ! ");
					return false;
				}
				
				start_3 = parseInt(document.form_basket.start_clock_3.value) * 60 ;
				sonuc_5 = start_3 +  parseInt(document.form_basket.start_minute_3.value);
				finish_3 = parseInt(document.form_basket.finish_clock_3.value) * 60 ;
				sonuc_6 = finish_3 +  parseInt(document.form_basket.finish_minute_3.value);
				if( sonuc_5 > sonuc_6)
				{	
					alert("<cf_get_lang no='72.Pazar Günü İçin Uygun Saat Değeri Giriniz'> ! ");
					return false;
				}
			</cfif>
			$( document ).ready(function() {
				return (process_cat_control() && saveForm());
			});	
			return false;
		}
		function kontrol_prerecord()
		{
			if(form_basket.member_name.value!="")
				if(form_basket.member_type.value=="partner")
					windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_check_contract_prerecords&member_type=partner&company_name='+ encodeURIComponent(form_basket.company_name.value) +'&member_name=' + encodeURIComponent(form_basket.member_name.value) +'&partner_id='+ form_basket.partner_id.value +'&company_id='+ form_basket.company_id.value,'project');
				else
					windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_check_contract_prerecords&member_type=consumer&member_name=' + encodeURIComponent(form_basket.member_name.value) +'&consumer_id='+ form_basket.consumer_id.value,'project');
		}
		
		function unformat_fields()
		{
			document.form_basket.premium_value.value = filterNum(document.form_basket.premium_value.value);
		}
		function return_company()
		{	
			if(document.getElementById('ref_member_type').value=='employee')
			{	
				var emp_id = document.getElementById('ref_member_id').value;
				var GET_COMPANY=wrk_safe_query('sls_get_cmpny_2','dsn',0,emp_id);
				document.getElementById('ref_company_id').value=GET_COMPANY.COMP_ID;
			}
			else
				return false;
		}
		<cfif isDefined("attributes.subscription_id")>
			rowCount = 1;
			for( var satir_index = 1 ; satir_index <= rowCount ; satir_index++)
			{
				if(satir_index < rowCount)
				{
					$( document ).ready(function() {
						hesapla('price_other',satir_index,0);
					});
				}
				else <!--- sadece son satirda toplam hesaplansin  --->
				{
					$( document ).ready(function() {
						hesapla('price_other',satir_index,1);
					});
				}
			}
			$( document ).ready(function() {
				toplam_hesapla(0);
			});
		</cfif>
	<cfelseif isdefined("attributes.event") and attributes.event is 'upd'>//Güncelleme
		function add_adress(adress_type)
		{
			if(!(form_basket.partner_id.value=="") || !(form_basket.consumer_id.value==""))
			{	
				if(form_basket.partner_id.value!="")
				{
					if(adress_type==1)
					{
						str_adrlink = '&field_adres=form_basket.ship_address&field_city=form_basket.ship_city_id&field_county=form_basket.ship_county_id&field_country=form_basket.ship_country_id&field_postcode=form_basket.ship_postcode&field_semt=form_basket.ship_semt&coordinate_1=form_basket.ship_coordinate_1&coordinate_2=form_basket.ship_coordinate_2&sales_zone=form_basket.ship_sales_zone_id'; 
						windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_member_address&is_comp=1&keyword='+encodeURIComponent(form_basket.company_name.value)+''+ str_adrlink , 'list');
						return true;
					}
					else if(adress_type==2)
					{
						str_adrlink = '&field_adres=form_basket.invoice_address&field_city=form_basket.invoice_city_id&field_county=form_basket.invoice_county_id&field_country=form_basket.invoice_country_id&field_postcode=form_basket.invoice_postcode&field_semt=form_basket.invoice_semt&coordinate_1=form_basket.invoice_coordinate_1&coordinate_2=form_basket.invoice_coordinate_2&sales_zone=form_basket.invoice_sales_zone_id&field_adress_id=form_basket.ship_id&field_long_address=form_basket.ship_address&alias=form_basket.alias'; 
						windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_member_address&is_comp=1&keyword='+encodeURIComponent(form_basket.company_name.value)+''+ str_adrlink , 'list');
						return true;
					}
					else if(adress_type==3)
					{
						str_adrlink = '&field_adres=form_basket.contact_address&field_city=form_basket.contact_city_id&field_county=form_basket.contact_county_id&field_country=form_basket.contact_country_id&field_postcode=form_basket.contact_postcode&field_semt=form_basket.contact_semt&coordinate_1=form_basket.contact_coordinate_1&coordinate_2=form_basket.contact_coordinate_2&sales_zone=form_basket.contact_sales_zone_id'; 
						windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_member_address&is_comp=1&keyword='+encodeURIComponent(form_basket.company_name.value)+''+ str_adrlink , 'list');
						return true;
					}			
				}
				else
				{
					if(adress_type==1)
					{
						str_adrlink = '&field_adres=form_basket.ship_address&field_city=form_basket.ship_city_id&field_county=form_basket.ship_county_id&field_country=form_basket.ship_country_id&field_postcode=form_basket.ship_postcode&field_semt=form_basket.ship_semt&coordinate_1=form_basket.ship_coordinate_1&coordinate_2=form_basket.ship_coordinate_2&sales_zone=form_basket.ship_sales_zone_id'; 
						windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_member_address&is_comp=0&keyword='+encodeURIComponent(form_basket.member_name.value)+''+ str_adrlink , 'list');
						return true;
					}
					else if(adress_type==2)
					{
						str_adrlink = '&field_adres=form_basket.invoice_address&field_city=form_basket.invoice_city_id&field_county=form_basket.invoice_county_id&field_country=form_basket.invoice_country_id&field_postcode=form_basket.invoice_postcode&field_semt=form_basket.invoice_semt&coordinate_1=form_basket.invoice_coordinate_1&coordinate_2=form_basket.invoice_coordinate_2&sales_zone=form_basket.invoice_sales_zone_id'; 
						windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_member_address&is_comp=0&keyword='+encodeURIComponent(form_basket.member_name.value)+''+ str_adrlink , 'list');
						return true;
					}
					else if(adress_type==3)
					{
						str_adrlink = '&field_adres=form_basket.contact_address&field_city=form_basket.contact_city_id&field_county=form_basket.contact_county_id&field_country=form_basket.contact_country_id&field_postcode=form_basket.contact_postcode&field_semt=form_basket.contact_semt&coordinate_1=form_basket.contact_coordinate_1&coordinate_2=form_basket.contact_coordinate_2&sales_zone=form_basket.contact_sales_zone_id'; 
						windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_member_address&is_comp=0&keyword='+encodeURIComponent(form_basket.member_name.value)+''+ str_adrlink , 'list');
						return true;
					}
				}
			}
			else
			{
				alert("<cf_get_lang no='290.Sistem Seçiniz'> !");
				return false;
			}		
		}
		function del_alias(alias_adres_type)
		{
			if(alias_adres_type == 1)
			{
			document.getElementById('alias').value='';
			document.getElementById('ship_id').value='';
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_all_pars&<cfoutput>#str_linke_ait#</cfoutput>&select_list=2,3','list','popup_list_all_pars');
			}
			if(alias_adres_type == 2)
			{
			document.getElementById('alias').value='';
			document.getElementById('ship_id').value='';
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_all_pars&<cfoutput>#str_linke_ait2#</cfoutput>&select_list=2,3','list','popup_list_all_pars');	
				
						
			}
		}
		//function unformat_fields()
//		{
//			cfif xml_kontrol_product eq 0>
//				cfoutput query="get_money_bskt">
//					form_basket.txt_rate1_#currentrow#.value = filterNumBasket(form_basket.txt_rate1_#currentrow#.value,basket_rate_round_number);
//					form_basket.txt_rate2_#currentrow#.value = filterNumBasket(form_basket.txt_rate2_#currentrow#.value,basket_rate_round_number);
//				/cfoutput>
//			/cfif>
//		}
		function upd_kontrol()
		{
			if(document.getElementById('ship_coordinate_1') != undefined) document.getElementById('ship_coordinate_1').disabled = false;
			if(document.getElementById('ship_coordinate_2') != undefined) document.getElementById('ship_coordinate_2').disabled = false;
			if(document.getElementById('invoice_coordinate_1') != undefined) document.getElementById('invoice_coordinate_1').disabled = false;
			if(document.getElementById('invoice_coordinate_2') != undefined) document.getElementById('invoice_coordinate_2').disabled = false;
			if(document.getElementById('contact_coordinate_1') != undefined) document.getElementById('contact_coordinate_1').disabled = false;
			if(document.getElementById('contact_coordinate_2') != undefined) document.getElementById('contact_coordinate_2').disabled = false;
			
			if((document.form_basket.partner_id.value=="") && (document.form_basket.consumer_id.value==""))
			{
				alert("<cf_get_lang no='290.Sistem Seçiniz'> !");
				return false;
			}
			
			if(document.getElementById('subscription_type') != undefined)
			{
				if (document.form_basket.subscription_type[document.form_basket.subscription_type.selectedIndex] == "")
				{ 
					alert ("<cf_get_lang no='292.Sistem Kategorisi Seçiniz'> ! ");
					return false;
				}
			}
			if(document.getElementById('ship_address') != undefined)
			{
				x = (300 - document.form_basket.ship_address.value.length);
				if ( x < 0)
				{ 
					alert ("<cf_get_lang no='2.Sevk Adresi'><cf_get_lang no ='510.Alanina 300 Karakterden Fazla Girmeyiniz Fazla Karakter Sayısı'>"+ ((-1) * x));
					return false;
				}
			}
			if(document.getElementById('invoice_address') != undefined)
			{
				y = (300 - document.form_basket.invoice_address.value.length);
				if ( y < 0)
				{ 
					alert ("<cf_get_lang no='283.Fatura Adresi'><cf_get_lang no ='510.Alanina 300 Karakterden Fazla Girmeyiniz Fazla Karakter Sayısı'>"+ ((-1) * x));
					return false;
				}
			}
			if(document.getElementById('contact_address') != undefined)
			{
				z = (300 - document.form_basket.contact_address.value.length);
				if ( z < 0)
				{ 
					alert ("<cf_get_lang no='284.Irtibat Adresi'><cf_get_lang no ='510.Alanina 300 Karakterden Fazla Girmeyiniz Fazla Karakter Sayısı'>"+ ((-1) * x));
					return false;
				}
			}
			if(document.getElementById('detail') != undefined)
			{
				t = (500 - document.form_basket.detail.value.length);
				if ( t < 0 )
				{ 
					alert ("<cf_get_lang_main no='217.Aciklama'><cf_get_lang no ='513.Alanina 500 Karakterden Fazla Girmeyiniz Fazla Karakter Sayısı'>"+ ((-1) * x));
					return false;
				}
			}
			
			if(!(document.form_basket.start_date.value == "") && !(document.form_basket.finish_date.value == ""))
			{
				if(!date_check(document.form_basket.start_date,document.form_basket.finish_date,"<cf_get_lang no ='514.Başlangıç - Bitiş Tarihlerini Kontrol Ediniz'>!"))
				{	
					return false;
				}
			}
		
			<cfif xml_service_definition eq 1>
			if((document.form_basket.valid_days.value == 1) && (document.form_basket.start_clock_1.value == 0) && (document.form_basket.finish_clock_1.value == 0) && (document.form_basket.start_minute_1.value == 0) && (document.form_basket.finish_minute_1.value == 0) )
			{
				alert("<cf_get_lang no='59.Hafta İçi Destek Saatlerini Seçiniz'> !");
				return false;
			}
			
			if((document.form_basket.valid_days.value == 2) && (document.form_basket.start_clock_1.value == 0) && (document.form_basket.finish_clock_1.value == 0) && (document.form_basket.start_minute_1.value == 0) && (document.form_basket.finish_minute_1.value == 0) )
			{
				alert("<cf_get_lang no='61.Hafta İçi Ve Cumartesi Destek Saatlerini Seçiniz'> !");
				return false;
			}
			
			if((document.form_basket.valid_days.value == 2) && (document.form_basket.start_clock_2.value == 0) && (document.form_basket.finish_clock_2.value == 0) && (document.form_basket.start_minute_2.value == 0) && (document.form_basket.finish_minute_2.value == 0))
			{
				alert("<cf_get_lang no='66.Cumartesi Destek Saatlerini Seçiniz'> !");
				return false;
			}
			
			if((document.form_basket.valid_days.value == 3) && (document.form_basket.start_clock_1.value == 0) && (document.form_basket.finish_clock_1.value == 0) && (document.form_basket.start_minute_1.value == 0) && (document.form_basket.finish_minute_1.value == 0) )
			{
				alert("<cf_get_lang no='67.Hafta İçi, Cumartesi Ve Pazar Destek Saatlerini Seçiniz'> !");
				return false;
			}
			
			if((document.form_basket.valid_days.value == 3) && (document.form_basket.start_clock_2.value == 0) && (document.form_basket.finish_clock_2.value == 0) && (document.form_basket.start_minute_2.value == 0) && (document.form_basket.finish_minute_2.value == 0))
			{
				alert("<cf_get_lang no='68.Cumartesi ve Pazar Destek Saatlerini Seçiniz'> !");
				return false;
			}
			
			if((document.form_basket.valid_days.value == 3) && (document.form_basket.start_clock_3.value == 0) && (document.form_basket.finish_clock_3.value == 0) && (document.form_basket.start_minute_3.value == 0) && (document.form_basket.finish_minute_3.value == 0))
			{
				alert("<cf_get_lang no='69.Pazar Destek Saatlerini Seçiniz'> !");
				return false;
			}
			
			start_1 = parseInt(document.form_basket.start_clock_1.value) * 60 ;
			sonuc_1 = start_1 +  parseInt(document.form_basket.start_minute_1.value);
			finish_1 = parseInt(document.form_basket.finish_clock_1.value) * 60 ;
			sonuc_2 = finish_1 +  parseInt(document.form_basket.finish_minute_1.value);
			if( sonuc_1 > sonuc_2)
			{	
				alert("<cf_get_lang no='70.Hafta İçi İçin Uygun Saat Değeri Giriniz'> !");
				return false;
			}
			
			start_2 = parseInt(document.form_basket.start_clock_2.value) * 60 ;
			sonuc_3 = start_2 +  parseInt(document.form_basket.start_minute_2.value);
			finish_2 = parseInt(document.form_basket.finish_clock_2.value) * 60 ;
			sonuc_4 = finish_2 +  parseInt(document.form_basket.finish_minute_2.value);
			if( sonuc_3 > sonuc_4)
			{	
				alert("<cf_get_lang no='71.Cumartesi Günü İçin Uygun Saat Değeri Giriniz'> !");
				return false;
			}
			
			start_3 = parseInt(document.form_basket.start_clock_3.value) * 60 ;
			sonuc_5 = start_3 +  parseInt(document.form_basket.start_minute_3.value);
			finish_3 = parseInt(document.form_basket.finish_clock_3.value) * 60 ;
			sonuc_6 = finish_3 +  parseInt(document.form_basket.finish_minute_3.value);
			if( sonuc_5 > sonuc_6)
			{	
				alert("<cf_get_lang no='72.Pazar Günü İçin Uygun Saat Değeri Giriniz'> !");
				return false;
			}
			</cfif>
			document.form_basket.credit_card_id.disabled = false;
			//return true;
			$( document ).ready(function() {
				return (process_cat_control() && saveForm());
			});
			return false;
		}
		function del_alias(alias_adres_type)
		{
			if(alias_adres_type == 1)
			{
			document.getElementById('alias').value='';
			document.getElementById('ship_id').value='';
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_all_pars&<cfoutput>#str_linke_ait#</cfoutput>&select_list=2,3','list','popup_list_all_pars');
			}
			if(alias_adres_type == 2)
			{
				document.getElementById('alias').value='';
			document.getElementById('ship_id').value='';
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_all_pars&<cfoutput>#str_linke_ait2#</cfoutput>&select_list=2,3','list','popup_list_all_pars');	
			}
		}
		function return_company()
		{
			if(document.getElementById('ref_member_type').value=='employee')
			{	
				var emp_id=document.getElementById('ref_member_id').value;
				var GET_COMPANY=wrk_safe_query('sls_get_cmpny_2','dsn',0,emp_id);
				document.getElementById('ref_company_id').value=GET_COMPANY.COMP_ID;
			}
			else
				return false;
		}
		<cfif isDefined("attributes.subscription_id")>
			rowCount = document.getElementById('rowcount').value;
			for( var satir_index = 1 ; satir_index <= rowCount ; satir_index++)
			{
				if(satir_index < rowCount)
						hesapla('price_other',satir_index,0);
				else <!--- sadece son satirda toplam hesaplansin  --->
						hesapla('price_other',satir_index,1);
			}
			toplam_hesapla(0);
		</cfif>
	</cfif>
</script>

<!---<td class="dpht">            
<cf_get_lang_main no='1420.Abone'>: <cfoutput>#get_subscription.subscription_no#</cfoutput> / 
<cfoutput>

<cfif len(get_subscription.partner_id)>
    <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_com_det&company_id=#get_subscription.company_id#','medium','popup_com_det');">#get_par_info(get_subscription.partner_id,0,0,0)#<!---  - #get_par_info(get_subscription.partner_id,0,-1,0)# ---> <!--- Gerek yok diğeri ikisinide yapıyo FA20070131 ---></a> 
<cfelse>
    <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_con_det&con_id=#get_subscription.consumer_id#','medium','popup_con_det');">#get_cons_info(get_subscription.consumer_id,0,0)#</a>
</cfif>
</cfoutput> 
&nbsp;<cfif len(get_subscription.cancel_date)><b><font color="red"> - <cf_get_lang no ='438.İptal Edildi'> </font></b></cfif>
</td>--->
<cfscript>
	// Switch //
	WOStruct = StructNew();
	WOStruct['#attributes.fuseaction#'] = structNew();
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'sales.list_subscription_contract';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'sales/display/list_subscription_contract.cfm';
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'sales.add_subscription_contract';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'sales/form/add_subscription_contract.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'sales/query/add_subscription_contract.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'sales.list_subscription_contract&event=upd';

	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'sales.upd_subscription_contract';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'sales/form/upd_subscription_contract.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'sales/query/upd_subscription_contract.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'sales.list_subscription_contract&event=upd';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'subscription_id=##attributes.subscription_id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.subscription_id##';
	
	if(IsDefined("attributes.event") && (attributes.event is 'upd' || attributes.event is 'del'))
	{
		WOStruct['#attributes.fuseaction#']['del'] = structNew();
		WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
		WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'sales.list_subscription_contract';
		WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'sales/query/del_subscription_contract.cfm';
		WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'sales/query/del_subscription_contract.cfm';
		WOStruct['#attributes.fuseaction#']['del']['parameters'] = 'subscription_id=##attributes.subscription_id##';
		WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'sales.list_subscription_contract';
	}
               
	if(isdefined("attributes.event") and attributes.event is 'upd')
	{
		tabMenuStruct = StructNew();
		tabMenuStruct['#attributes.fuseaction#'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus'] = structNew();

		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['text'] = '#lang_array_main.item[345]#';//Uyarılar
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['onClick'] = "windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_page_warnings&action=sales.upd_subscription_contract&action_name=subscription_id&action_id=#attributes.subscription_id#</cfoutput>','list');";
				
		if (len(get_subscription.company_id))
		{
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][1]['text'] = '#lang_array.item[468]#';//Zaman Harcaması Ekle
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][1]['onClick'] = "windowopen('#request.self#?fuseaction=myhome.mytime_management&event=add&subscription_id=#get_subscription.subscription_id#&comp_id=#get_subscription.COMPANY_ID#&partner_id=#get_subscription.PARTNER_ID#&is_subscription=1','medium');";
		}
		else if (len(get_subscription.consumer_id))
		{
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][1]['text'] = '#lang_array.item[468]#';//Zaman Harcaması Ekle
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][1]['onClick'] = "windowopen('#request.self#?fuseaction=myhome.mytime_management&event=add&subscription_id=#get_subscription.subscription_id#&cons_id=#get_subscription.CONSUMER_ID#&is_subscription=1','medium');";
		}

		if (session.ep.our_company_info.sms eq 1)
		{
			if (len(get_subscription.company_id))
			{
				member_type='partner';
				member_id=get_subscription.partner_id;
			}
			else if (len(get_subscription.consumer_id))
			{
				member_type='consumer';
				member_id=get_subscription.consumer_id;
			}				
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][2]['text'] = '#lang_array_main.item[1178]#';//SMS Gönder
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][2]['onClick'] = "windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_form_send_sms&member_type=#member_type#&member_id=#member_id#&paper_type=8&paper_id=#attributes.subscription_id#&sms_action=#fuseaction#</cfoutput>','small');";
		}

		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][3]['text'] = '#lang_array.item[469]#';//Sayaç Okuma
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][3]['onClick'] = "windowopen('<cfoutput>#request.self#?fuseaction=sales.popup_add_subscription_read_counter&subscription_id=#attributes.subscription_id#&subscription_no=#get_subscription.subscription_no#</cfoutput>','page','popup_subscription_counter');";

		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][4]['text'] = 'Partition';//Partition
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][4]['onClick'] = "windowopen('<cfoutput>#request.self#?fuseaction=sales.popup_list_subscription_partition&subscription_id=#attributes.subscription_id#</cfoutput>','medium','popup_list_subscription_partition');";

		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][5]['text'] = '#lang_array.item[60]#';//Ek Sayfa Ekle
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][5]['onClick'] = "windowopen('<cfoutput>#request.self#?fuseaction=sales.popup_add_subscription_page&subs_id=#attributes.subscription_id#</cfoutput>','page');return false;";

		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][6]['text'] = '#lang_array.item[306]#';//Ödeme Planı
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][6]['onClick'] = "windowopen('<cfoutput>#request.self#?fuseaction=sales.popup_dsp_subscription_payment_plan&subscription_id=#get_subscription.subscription_id#</cfoutput>','wwide','popup_dsp_subscription_payment_plan');";

		if (len(get_subscription.company_id))
		{
			comp_id_list = get_subscription.company_id & "," & get_subscription.invoice_company_id;
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][7]['text'] = '#lang_array.item[306]#';//Ödeme Planı
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][7]['onClick'] = "windowopen('<cfoutput>#request.self#?fuseaction=sales.popup_subscription_payment_plan&subscription_id=#get_subscription.subscription_id#&subs_no=#get_subscription.subscription_no#&comp_id=#comp_id_list#</cfoutput>','wwide','popup_subscription_payment_plan');";
		}
		else
		{
			cons_id_list = get_subscription.consumer_id & "," & get_subscription.invoice_consumer_id;
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][7]['text'] = '#lang_array.item[306]#';//Ödeme Planı
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][7]['onClick'] = "windowopen('<cfoutput>#request.self#?fuseaction=sales.popup_subscription_payment_plan&subscription_id=#get_subscription.subscription_id#&subs_no=#get_subscription.subscription_no#&cons_id=#cons_id_list#</cfoutput>','wwide','popup_subscription_payment_plan');";
		}
		
		if (len(get_subscription.invoice_company_id))
		{
			member_type_='partner';
			member_id_=get_subscription.invoice_company_id;
		}
		else if (len(get_subscription.invoice_consumer_id))
		{
			member_type_='consumer';
			member_id_=get_subscription.invoice_consumer_id;
		}
		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][8]['text'] = '#lang_array_main.item[397]#';//Hesap Ekstresi
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][8]['onClick'] = "windowopen('<cfoutput>#request.self#?fuseaction=ch.list_company_extre&member_type=#member_type_#&member_id=#member_id_#</cfoutput>','page')";

		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][9]['text'] = '#lang_array.item[470]#';//Sanal POS
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][9]['onClick'] = "windowopen('<cfoutput>#request.self#?fuseaction=sales.popup_add_multi_provision&from_subs_detail=1&subscription_id=#get_subscription.subscription_id#&subscription_no=#get_subscription.subscription_no#&<cfif len(get_subscription.invoice_company_id)>company_id=#get_subscription.invoice_company_id#<cfelse>consumer_id=#get_subscription.invoice_consumer_id#</cfif></cfoutput>','wide');";

		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][10]['text'] = '#lang_array.item[335]#';//Sistem İptal
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][10]['onClick'] = "windowopen('<cfoutput>#request.self#?fuseaction=sales.popup_subscription_to_cancel&subscription_id=#get_subscription.subscription_id#</cfoutput>','small','popup_subscription_to_cancel');";

		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][11]['text'] = '#lang_array_main.item[1577]#';//Sipariş Ekle
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][11]['href'] = "<cfoutput>#request.self#?fuseaction=sales.list_order&event=add&subscription_id=#get_subscription.subscription_id#<cfif xml_is_invoice_member>&xml_is_invoice_member=1</cfif></cfoutput>";

		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][12]['text'] = '#lang_array.item[471]#';//Başvuru Ekle
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][12]['href'] = "javascript:add_service.submit();";

		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][13]['text'] = '#lang_array_main.item[774]#';//Başvurular
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][13]['href'] = "javascript:list_service.submit();";


		if (len(get_subscription.company_id))
		{
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][14]['text'] = '#lang_array.item[203]#';//Olaylar
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][14]['onClick'] = "windowopen('<cfoutput>#request.self#?fuseaction=member.popup_list_comp_agenda&company_id=#get_subscription.company_id#&partner_id=#get_subscription.partner_id#</cfoutput>','list','popup_list_comp_agenda');";
		}
		else
		{
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][14]['text'] = '#lang_array.item[203]#';//Olaylar
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][14]['onClick'] = "windowopen('<cfoutput>#request.self#?fuseaction=member.popup_list_con_agenda&consumer_id=#get_subscription.consumer_id#</cfoutput>','list','popup_list_comp_agenda');";
		}

		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][15]['text'] = '#lang_array.item[329]#';//Pirim Bilgileri
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][15]['onClick'] = "windowopen('<cfoutput>#request.self#?fuseaction=sales.popup_premium_info&subscription_id=#attributes.subscription_id#</cfoutput>','small','popup_premium');";

		if (session.ep.userid eq 16 or session.ep.userid eq 292)
		{
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][16]['text'] = 'Abone Bakım Planı Atama';//Abone Bakım Planı Atama
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][16]['href'] = "<cfoutput>#request.self#?fuseaction=report.detail_report&report_id=415&subscription_id=#attributes.subscription_id#</cfoutput>;";

			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][17]['text'] = 'Abone Bilg. Atama';//Abone Bilg. Atama
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][17]['href'] = "<cfoutput>#request.self#?fuseaction=report.detail_report&report_id=418&subscription_id=#attributes.subscription_id#</cfoutput>;";

			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][18]['text'] = 'Abone Per. Serv. Atama';//Abone Per. Serv. Atama
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][18]['href'] = "<cfoutput>#request.self#?fuseaction=report.detail_report&report_id=419&subscription_id=#attributes.subscription_id#</cfoutput>;";

			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][19]['text'] = 'Lokasyon Bazlı Atama';//Lokasyon Bazlı Atama
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][19]['href'] = "<cfoutput>#request.self#?fuseaction=report.detail_report&report_id=424&subscription_id=#attributes.subscription_id#</cfoutput>;";			
		}
		else
		{
			i = 16;		
		}

		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#lang_array.item[473]#';//CallCenter Başvuru Ekle
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['onClick'] = "javascript:add_call_center.submit();";
		i = i + 1;

		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#lang_array.item[474]#';//CallCenter Başvurular
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['onClick'] = "javascript:list_call_center.submit();";
		i = i + 1;
		
		if (session.ep.our_company_info.guaranty_followup)
		{
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#lang_array_main.item[305]#';//Garanti
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['href'] = "#request.self#?fuseaction=stock.list_serial_operations&is_filtre=1&belge_no=#get_subscription.subscription_no#&process_cat_id=1193&process_id=#get_subscription.subscription_id#";
		}

		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#lang_array_main.item[170]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=sales.list_subscription_contract&event=add";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['copy']['text'] = '#lang_array_main.item[1578]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['copy']['href'] = '#request.self#?fuseaction=sales.list_subscription_contract&event=add&subscription_id=#attributes.subscription_id#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['copy']['target'] = "_blank";

		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['text'] =  '#lang_array_main.item[62]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['onClick'] ="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_print_files&iid=#attributes.subscription_id#&print_type=74</cfoutput>;";

		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	WOStruct['#attributes.fuseaction#']['extendedForm'] = structNew();
	WOStruct['#attributes.fuseaction#']['extendedForm']['controllerFileName'] = 'ListSubscriptionContract';
	WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'SUBSCRIPTION_CONTRACT';
	WOStruct['#attributes.fuseaction#']['extendedForm']['dataSourceName'] = 'company';
	WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "['item-subscription_head','item-company_name','item-invoice_consumer_id','item-process_stage','item-subscription_type','item-start_date','item-contract_no']"; // Bu atama yapılmazsa sayfada her alan değiştirilebilir olur.
</cfscript>