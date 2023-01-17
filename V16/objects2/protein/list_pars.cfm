<cfinclude template="../query/get_company_sector.cfm">
<cfscript>
    accountingType = createObject("component","V16.settings.cfc.accountingType");
    getAccount = accountingType.getAccountType();
    getComponent = createObject('component','V16.callcenter.cfc.call_center');
    get_company_sector = getComponent.get_company_sector();
    get_customer_value = getComponent.get_customer_value();

</cfscript>
<cfset attributes.isbox=1>
<cfset opportunitiesCFC = createObject('component','V16.objects2.protein.data.opportunities_data')>
<cfset contract_cmp = createObject("component","V16.sales.cfc.subscription_contract")>

<cfif isdefined("session.pp")>
    <cfset session_base = evaluate('session.pp')>
    <cfset session_our_company_id = session.pp.our_company_id>
    <cfset session_company_id = session.pp.company_id>
    <cfset session_period_year = session.pp.period_year>
    <cfset session_language = session.pp.language>
<cfelseif isdefined("session.ep")>
    <cfset session_base = evaluate('session.ep')>
    <cfset session_our_company_id = session.ep.our_company_id>
    <cfset session_company_id = session.ep.company_id>
    <cfset session_period_year = session.ep.period_year>
    <cfset session_language = session.ep.language>
    <cfset session_user_id = session.ep.user_id>
<cfelseif isdefined("session.ww")>
    <cfset session_base = evaluate('session.ww')>
    <cfset session_our_company_id = session.ww.our_company_id>
    <cfset session_company_id = session.ww.company_id>
    <cfset session_period_year = session.ww.period_year>
    <cfset session_language = session.ww.language>
</cfif>
<script type="text/javascript">
function add_pro(company_id,fullname,member_code)
{  
    <cfif isdefined("attributes.satir") and len(attributes.satir)>
        var satir = <cfoutput>#attributes.satir#</cfoutput>;
    <cfelse>
        var satir = -1;
    </cfif>
    if(<cfif isdefined("attributes.draggable")>document<cfelse>window.opener</cfif>.basket && satir > -1) 
        <cfif isdefined("attributes.draggable")>document<cfelse>window.opener</cfif>.updateBasketItemFromPopup(satir, { COMPANY_ID: company_id, NAME_COMPANY: fullname,MEMBER_CODE:member_code}); // Basket Çalışmaları için eklendi. Kaldırmayınız. 20140826

        <cfif not isdefined("attributes.draggable")>window.close();<cfelseif isdefined("attributes.draggable")>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );</cfif>
}
</script>
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.product_cat_hierarchy" default="">
<cfparam name="attributes.product_cat_id" default="">
<cfparam name="attributes.category_name" default="">
<cfparam name="attributes.keyword_partner" default="">
<cfparam name="attributes.sector_cat_id" default="">
<cfparam name="attributes.customer_value_id" default="">
<cfparam name="attributes.phone" default="">
<cfparam name="attributes.email" default="">
<cfparam name="attributes.sz_id" default="">
<cfparam name="attributes.tax_no" default="">
<cfparam name="attributes.contact" default="">
<cfparam name="attributes.search_status" default="1">
<cfparam name="attributes.is_my_extre_page" default="0">
<cfparam name="attributes.is_kur" default="">
<cfparam name="attributes.ACCOUNT_TYPE_ID" default="">
<cfparam name="attributes.is_period_kontrol" default="0"><!--- 0 olara gönderildiğinde dönem bilgisinin default olarak seçilmemesi sağlanır. --->
<cfparam name="attributes.maxrows" default='20'>
<cfif attributes.is_period_kontrol eq 1>
    <cfif isdefined('session.ep.userid')>
        <cfparam name="attributes.period_id" default="1;#session.ep.company_id#;#session.ep.period_id#">
    <cfelseif isdefined('session.pp.our_company_id')>
        <cfparam name="attributes.period_id" default="1;#session.pp.our_company_id#;#session.pp.our_company_id#">
    </cfif>
</cfif>
<cfquery name="GET_CITY_NAME" datasource="#DSN#">
    SELECT CITY_ID,CITY_NAME FROM SETUP_CITY
</cfquery>
    <!--- FBS Yeniden Duzenlendi, bireysel-kurumsal popup gecislerinde kopukluk oluyor ve bazi durumlarda yanlis calisiyordu --->
    <cfquery name="GET_PERIOD" datasource="#DSN#">
        SELECT
            OUR_COMPANY.COMP_ID,
            OUR_COMPANY.COMPANY_NAME,
            SP.PERIOD_ID,
            SP.PERIOD
        FROM
            SETUP_PERIOD SP WITH (NOLOCK),
            OUR_COMPANY WITH (NOLOCK),
            EMPLOYEE_POSITION_PERIODS EPP WITH (NOLOCK)
        WHERE 
            EPP.PERIOD_ID = SP.PERIOD_ID AND
            <cfif isdefined('session.ep.userid')>
                EPP.POSITION_ID = (SELECT POSITION_ID FROM EMPLOYEE_POSITIONS WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"> AND IS_MASTER = 1) AND
            </cfif>
            SP.OUR_COMPANY_ID = OUR_COMPANY.COMP_ID 
        ORDER BY 
            OUR_COMPANY.COMP_ID,
            OUR_COMPANY.COMPANY_NAME,
            SP.PERIOD_YEAR
    </cfquery>
    <cfset period_id_list = listsort(listdeleteduplicates(valueList(get_period.period_id,',')),'numeric','ASC',',')>

<cfquery name="GET_OUR_COMPANIES" datasource="#DSN#">
    SELECT 
        DISTINCT
        SP.OUR_COMPANY_ID
    FROM
        EMPLOYEE_POSITIONS EP WITH (NOLOCK),
        SETUP_PERIOD SP WITH (NOLOCK),
        EMPLOYEE_POSITION_PERIODS EPP WITH (NOLOCK),
        OUR_COMPANY O WITH (NOLOCK)
    WHERE 
        SP.OUR_COMPANY_ID = O.COMP_ID AND
        SP.PERIOD_ID = EPP.PERIOD_ID AND
        EP.POSITION_ID = EPP.POSITION_ID 
        <cfif isdefined('session.ep.userid')>
            AND EP.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
        </cfif>
</cfquery>
<cfquery name="GET_COMP_CAT" datasource="#DSN#">
    SELECT 
        COMPANYCAT_ID, 
        COMPANYCAT
    FROM
        GET_MY_COMPANYCAT WITH (NOLOCK)
    WHERE
        <cfif isdefined('session.ep.userid')>
            EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">  AND
        </cfif>
        <cfif isdefined("attributes.period_id") and Len(attributes.period_id)>
            OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listGetAt(attributes.period_id,2,';')#"> AND
        </cfif>
        <cfif get_our_companies.recordcount>
            OUR_COMPANY_ID IN (#valuelist(get_our_companies.our_company_id,',')#)
        <cfelse>
            1 = 2	
        </cfif>
    GROUP BY
        COMPANYCAT_ID, 
        COMPANYCAT
    ORDER BY
        COMPANYCAT
</cfquery>

<cfquery name="GET_RESPS" datasource="#DSN#">
    SELECT 
        WEP.POSITION_CODE, 
        WEP.COMPANY_ID,
        EP.EMPLOYEE_ID,
        EP.EMPLOYEE_NAME, 
        EP.EMPLOYEE_SURNAME 
    FROM 
        EMPLOYEE_POSITIONS EP,
        WORKGROUP_EMP_PAR WEP
    WHERE 
        EP.POSITION_CODE = WEP.POSITION_CODE AND
        WEP.COMPANY_ID IS NOT NULL AND 
        WEP.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session_company_id#"> AND 
        WEP.IS_MASTER = 1  
</cfquery>

<cfparam name="attributes.page" default="1">
<cfparam name="attributes.is_form_submitted" default="">
<cfparam name="attributes.modal_id" default="">
<cfset attributes.startrow = ((attributes.page-1)*attributes.maxrows) + 1 >
<cfif len(attributes.is_form_submitted) or (isdefined("attributes.keyword") and len(attributes.keyword))>
    <cfinclude template="../query/get_partners.cfm">
<cfelse>
    <cfset get_partners.recordcount = 0>
</cfif>
<cfparam name="attributes.totalrecords" default="#get_partners.recordcount#">
<cfparam name="select_list" default="1,2,3,4,5,6">
<cfscript>
    url_string = '';
    /* YO22022005 is_buyer_seller degiskeni 0 gelirse company tablosundaki IS_BUYER alani 1 olanlar gelir.is_buyer_seller degiskeni 1 gelirse company tablosundaki IS_SELLER alani 1 olanlar gelir. */
    //if (isdefined('attributes.is_buyer_seller')) url_string = '#url_string#&is_buyer_seller=#attributes.is_buyer_seller#';  //is_buyer_seller selectbox eklendigi icin kapatildi OZDEN20070105//
    if (isdefined('attributes.is_crm_module')) url_string = '#url_string#&is_crm_module=#is_crm_module#'; // CRM de uyeye branch id eklenmesi istenmedigi icin konuldu FB 20070704
    if (isdefined('attributes.is_cari_action')) url_string = '#url_string#&is_cari_action=#is_cari_action#';
    if (isdefined('attributes.is_multi_act')) url_string = '#url_string#&is_multi_act=#is_multi_act#';
    if (isdefined('attributes.field_basket_due_value')) url_string = '#url_string#&field_basket_due_value=#field_basket_due_value#';
    if (isdefined('attributes.field_paymethod_id')) url_string = '#url_string#&field_paymethod_id=#field_paymethod_id#';
    if (isdefined('attributes.field_paymethod')) url_string = '#url_string#&field_paymethod=#field_paymethod#';
    if (isdefined('attributes.field_revmethod_id')) url_string = '#url_string#&field_revmethod_id=#field_revmethod_id#';
    if (isdefined('attributes.field_card_payment_id')) url_string = '#url_string#&field_card_payment_id=#field_card_payment_id#';
    if (isdefined('attributes.field_basket_due_value_rev')) url_string = '#url_string#&field_basket_due_value_rev=#field_basket_due_value_rev#';
    if (isdefined('attributes.field_revmethod')) url_string = '#url_string#&field_revmethod=#field_revmethod#';
    if (isdefined("attributes.str_opener_form_url")) url_string = "#url_string#&str_opener_form_url=#str_opener_form_url#";
    if (isdefined("attributes.str_opener_form")) url_string = "#url_string#&str_opener_form=#str_opener_form#";
    if (isdefined("attributes.type")) url_string = '#url_string#';
    if (isdefined('attributes.islem')) url_string = '#url_string#&islem=#islem#';
    if (isdefined('attributes.field_type')) url_string = '#url_string#&field_type=#field_type#';
    if (isdefined('attributes.field_name')) url_string = '#url_string#&field_name=#field_name#';
    if (isdefined('attributes.account_period')) url_string = '#url_string#&account_period=#account_period#';//Tanımlıysa muhasebe ve dönem kontrolü yapmaz
    if (isdefined('url.come')) url_string = '#url_string#&come=#url.come#';
    if (isdefined('attributes.field_id')) url_string = '#url_string#&field_id=#field_id#';
    if (isdefined('attributes.field_code')) url_string = '#url_string#&field_code=#field_code#';	
    if (isdefined('attributes.field_comp_id')) url_string = '#url_string#&field_comp_id=#field_comp_id#';
    if (isdefined('attributes.field_comp_id2')) url_string = '#url_string#&field_comp_id2=#field_comp_id2#';
    if (isdefined('attributes.function_name')) url_string = '#url_string#&function_name=#function_name#';
    if (isdefined('attributes.field_partner')) url_string = '#url_string#&field_partner=#field_partner#';
    if (isdefined('attributes.field_emp_id')) url_string = '#url_string#&field_emp_id=#field_emp_id#';
    if (isdefined('attributes.field_dep_name')) url_string = '#url_string#&field_dep_name=#field_dep_name#';
    if (isdefined('attributes.field_branch_name')) url_string = '#url_string#&field_branch_name=#field_branch_name#';
    if (isdefined('attributes.field_consno')) url_string = '#url_string#&field_consno=#field_consno#';
    if (isdefined('attributes.startdate')) url_string = '#url_string#&startdate=#startdate#';
    if (isdefined('attributes.finishdate')) url_string = '#url_string#&finishdate=#finishdate#';
    if (isdefined('attributes.field_comp_name')) url_string = '#url_string#&field_comp_name=#field_comp_name#';
    if (isdefined('attributes.field_member_name')) url_string = '#url_string#&field_member_name=#field_member_name#';
    if (isdefined('attributes.field_consumer')) url_string = '#url_string#&field_consumer=#field_consumer#';
    if (isdefined('attributes.field_consumer2')) url_string = '#url_string#&field_consumer2=#field_consumer2#';
    if (isdefined('attributes.field_table')) url_string = '#url_string#&field_table=#field_table#';
    if (isdefined('attributes.field_cons_table')) url_string = '#url_string#&field_cons_table=#field_cons_table#';
    if (isdefined('attributes.field_cons')) url_string = '#url_string#&field_cons=#field_cons#';
    if (isdefined('attributes.field_pars')) url_string = '#url_string#&field_pars=#field_pars#';
    if (isdefined('attributes.field_pos')) url_string = '#url_string#&field_pos=#field_pos#';
    if (isdefined('attributes.select_list')) url_string = '#url_string#&select_list=#select_list#';
    if (isdefined('attributes.field_commission_rate')) url_string = '#url_string#&field_commission_rate=#field_commission_rate#';
    if (isdefined("attributes.is_county_related_company")) url_string = "#url_string#&is_county_related_company=1";
    if (isdefined("attributes.related_company")) url_string = "#url_string#&related_company=#attributes.related_company#";
    if (isdefined("attributes.related_company_id")) url_string = "#url_string#&related_company_id=#attributes.related_company_id#";
    if (isdefined("attributes.field_long_address")) url_string = "#url_string#&field_long_address=#attributes.field_long_address#";
    if (isdefined("attributes.field_address")) url_string = "#url_string#&field_address=#attributes.field_address#";
    if (isdefined("attributes.field_mail")) url_string = "#url_string#&field_mail=#attributes.field_mail#";
    if (isdefined("attributes.field_mobile_tel")) url_string = "#url_string#&field_mobile_tel=#attributes.field_mobile_tel#";
    if (isdefined("attributes.field_mobile_tel_code")) url_string = "#url_string#&field_mobile_tel_code=#attributes.field_mobile_tel_code#";
    if (isdefined("attributes.field_tel")) url_string = "#url_string#&field_tel=#attributes.field_tel#";
    if (isdefined("attributes.field_tel_number")) url_string = "#url_string#&field_tel_number=#attributes.field_tel_number#";
    if (isdefined("attributes.field_tel_code")) url_string = "#url_string#&field_tel_code=#attributes.field_tel_code#";
    if (isdefined("attributes.field_postcode")) url_string = "#url_string#&field_postcode=#attributes.field_postcode#";
    if (isdefined("attributes.field_semt")) url_string = "#url_string#&field_semt=#attributes.field_semt#";
    if (isdefined("attributes.field_county")) url_string = "#url_string#&field_county=#attributes.field_county#";
    if (isdefined("attributes.field_county_id")) url_string = "#url_string#&field_county_id=#attributes.field_county_id#";
    if (isdefined("attributes.field_city")) url_string = "#url_string#&field_city=#attributes.field_city#";
    if (isdefined("attributes.field_city_id")) url_string = "#url_string#&field_city_id=#attributes.field_city_id#";
    if (isdefined("attributes.field_country")) url_string = "#url_string#&field_country=#attributes.field_country#";
    if (isdefined("attributes.field_country_id")) url_string = "#url_string#&field_country_id=#attributes.field_country_id#";
    if (isdefined("attributes.field_ims_code_id")) url_string = "#url_string#&field_ims_code_id=#attributes.field_ims_code_id#";
    if (isdefined("attributes.field_ims_code_name")) url_string = "#url_string#&field_ims_code_name=#attributes.field_ims_code_name#";
    if (isdefined("attributes.field_ozel_kod")) url_string = "#url_string#&field_ozel_kod=#attributes.field_ozel_kod#";
    if (isdefined("attributes.field_address2")) url_string = "#url_string#&field_address2=#attributes.field_address2#";
    if (isdefined("attributes.field_postcode2")) url_string = "#url_string#&field_postcode2=#attributes.field_postcode2#";
    if (isdefined("attributes.field_semt2")) url_string = "#url_string#&field_semt2=#attributes.field_semt2#";
    if (isdefined("attributes.field_county2")) url_string = "#url_string#&field_county2=#attributes.field_county2#";
    if (isdefined("attributes.field_county_id2")) url_string = "#url_string#&field_county_id2=#attributes.field_county_id2#";
    if (isdefined("attributes.field_city2")) url_string = "#url_string#&field_city2=#attributes.field_city2#";
    if (isdefined("attributes.field_city_id2")) url_string = "#url_string#&field_city_id2=#attributes.field_city_id2#";
    if (isdefined("attributes.field_country2")) url_string = "#url_string#&field_country2=#attributes.field_country2#";
    if (isdefined("attributes.field_country_id2")) url_string = "#url_string#&field_country_id2=#attributes.field_country_id2#";
    if (isdefined("attributes.field_address3")) url_string = "#url_string#&field_address3=#attributes.field_address3#";
    if (isdefined("attributes.field_postcode3")) url_string = "#url_string#&field_postcode3=#attributes.field_postcode3#";
    if (isdefined("attributes.field_semt3")) url_string = "#url_string#&field_semt3=#attributes.field_semt3#";
    if (isdefined("attributes.field_county3")) url_string = "#url_string#&field_county3=#attributes.field_county3#";
    if (isdefined("attributes.field_county_id3")) url_string = "#url_string#&field_county_id3=#attributes.field_county_id3#";
    if (isdefined("attributes.field_city3")) url_string = "#url_string#&field_city3=#attributes.field_city3#";
    if (isdefined("attributes.field_city_id3")) url_string = "#url_string#&field_city_id3=#attributes.field_city_id3#";
    if (isdefined("attributes.field_country3")) url_string = "#url_string#&field_country3=#attributes.field_country3#";
    if (isdefined("attributes.field_country_id3")) url_string = "#url_string#&field_country_id3=#attributes.field_country_id3#";
    if (isdefined("attributes.ship_method_id")) url_string = "#url_string#&ship_method_id=#attributes.ship_method_id#";
    if (isdefined("attributes.field_trans_comp_id")) url_string = "#url_string#&field_trans_comp_id=#attributes.field_trans_comp_id#";
    if (isdefined("attributes.field_trans_comp_name")) url_string = "#url_string#&field_trans_comp_name=#attributes.field_trans_comp_name#";
    if (isdefined("attributes.field_trans_deliver_id")) url_string = "#url_string#&field_trans_deliver_id=#attributes.field_trans_deliver_id#";
    if (isdefined("attributes.field_trans_deliver_name")) url_string = "#url_string#&field_trans_deliver_name=#attributes.field_trans_deliver_name#";
    if (isdefined("attributes.ship_method_name")) url_string = "#url_string#&ship_method_name=#attributes.ship_method_name#";
    if (isdefined("attributes.field_emp_id2")) url_string = "#url_string#&field_emp_id2=#attributes.field_emp_id2#";
    if (isdefined('attributes.field_pos_name')) url_string = '#url_string#&field_pos_name=#field_pos_name#';
    if (isdefined("attributes.field_member_account_code")) url_string = "#url_string#&field_member_account_code=#attributes.field_member_account_code#";
    if (isdefined("attributes.field_member_account_id")) url_string = "#url_string#&field_member_account_id=#attributes.field_member_account_id#";
    if (isdefined("attributes.field_account_doviz")) url_string = "#url_string#&field_account_doviz=#attributes.field_account_doviz#";
    if (isdefined("attributes.call_function")) url_string = "#url_string#&call_function=#attributes.call_function#";
    if (isdefined('attributes.is_store_module')) url_string = '#url_string#&is_store_module=1';
    if (isdefined("attributes.process_row_id")) url_string = "#url_string#&process_row_id=#attributes.process_row_id#";
    if (isdefined("attributes.process_date")) url_string = "#url_string#&process_date=#attributes.process_date#";
    if (isdefined("attributes.field_cons_ref_code")) url_string = "#url_string#&field_cons_ref_code=#attributes.field_cons_ref_code#";
    if (isdefined("attributes.is_company_info")) url_string = "#url_string#&is_company_info=#attributes.is_company_info#";
    //fatura adresinin düsmesini istiyorsak gondermemiz gereken degisken.
    if (isdefined("attributes.is_invoice")) url_string = "#url_string#&is_invoice=#attributes.is_invoice#";
    if (isdefined("attributes.field_member_code")) url_string = "#url_string#&field_member_code=#attributes.field_member_code#";
    if (isdefined("attributes.field_partner_name")) url_string = "#url_string#&field_partner_name=#attributes.field_partner_name#";
    if (isdefined("attributes.field_partner_surname")) url_string = "#url_string#&field_partner_surname=#attributes.field_partner_surname#";
    if (isdefined("attributes.field_partner_name_surname")) url_string = "#url_string#&field_partner_name_surname=#attributes.field_partner_name_surname#";
    if (isdefined("attributes.field_tax_no")) url_string = "#url_string#&field_tax_no=#attributes.field_tax_no#";
    if (isdefined("attributes.field_tax_office")) url_string = "#url_string#&field_tax_office=#attributes.field_tax_office#";
    if (isdefined("attributes.field_adress_id")) url_string = "#url_string#&field_adress_id=#attributes.field_adress_id#";
    if (isdefined("attributes.is_period_kontrol")) url_string = "#url_string#&is_period_kontrol=#attributes.is_period_kontrol#";
    if (isdefined("attributes.is_my_extre_page")) url_string = "#url_string#&is_my_extre_page=#attributes.is_my_extre_page#";
    //marinturk icin silmeyin. FA
    if (isdefined("attributes.assetp_id")) url_string = "#url_string#&assetp_id=#attributes.assetp_id#";
    if (isdefined("attributes.row_no")) url_string = "#url_string#&row_no=#attributes.row_no#";
    if (isdefined('attributes.control_pos')) url_string = '#url_string#&control_pos=#control_pos#';
    if (isdefined("attributes.pos_code_new")) url_string = "#url_string#&pos_code=#attributes.pos_code_new#";
    if (isdefined("attributes.pos_code_text_new")) url_string = "#url_string#&pos_code_text=#attributes.pos_code_text_new#";
    if (isdefined("attributes.ship_coordinate_1")) url_string = "#url_string#&ship_coordinate_1=#attributes.ship_coordinate_1#";
    if (isdefined("attributes.ship_coordinate_2")) url_string = "#url_string#&ship_coordinate_2=#attributes.ship_coordinate_2#";
    if (isdefined("attributes.invoice_coordinate_1")) url_string = "#url_string#&invoice_coordinate_1=#attributes.invoice_coordinate_1#";
    if (isdefined("attributes.invoice_coordinate_2")) url_string = "#url_string#&invoice_coordinate_2=#attributes.invoice_coordinate_2#";
    if (isdefined("attributes.contact_coordinate_1")) url_string = "#url_string#&contact_coordinate_1=#attributes.contact_coordinate_1#";
    if (isdefined("attributes.contact_coordinate_2")) url_string = "#url_string#&contact_coordinate_2=#attributes.contact_coordinate_2#";
    if (isdefined("attributes.is_rate_select")) url_string = "#url_string#&is_rate_select=#attributes.is_rate_select#";
    if (isdefined("attributes.is_partner_address")) url_string = "#url_string#&is_partner_address=#attributes.is_partner_address#";
    if (isdefined("attributes.ship_sales_zone_id")) url_string = "#url_string#&ship_sales_zone_id=#attributes.ship_sales_zone_id#";
    if (isdefined("attributes.invoice_sales_zone_id")) url_string = "#url_string#&invoice_sales_zone_id=#attributes.invoice_sales_zone_id#";
    if (isdefined("attributes.contact_sales_zone_id")) url_string = "#url_string#&contact_sales_zone_id=#attributes.contact_sales_zone_id#";
    if (isdefined("attributes.analysis_id")) url_string = "#url_string#&analysis_id=#attributes.analysis_id#";
    if (isdefined("attributes.from_company_id")) url_string = "#url_string#&from_company_id=#attributes.from_company_id#";
    if (isdefined("attributes.from_partner_id")) url_string = "#url_string#&from_partner_id=#attributes.from_partner_id#";
    if (isdefined("attributes.field_notify_app_type")) url_string = "#url_string#&field_notify_app_type=#attributes.field_notify_app_type#";
    if (isdefined("attributes.field_notify_app_id")) url_string = "#url_string#&field_notify_app_id=#attributes.field_notify_app_id#";
    if (isdefined("attributes.field_notify_app_name")) url_string = "#url_string#&field_notify_app_name=#attributes.field_notify_app_name#";
    if (isdefined("attributes.satir")) url_string = "#url_string#&satir=#attributes.satir#";
    if (isdefined("attributes.fullname")) url_string = "#url_string#&comp_name=#attributes.comp_name#";
    if (isdefined("attributes.action_company_id")) url_string = "#url_string#&action_company_id=#attributes.action_company_id#";
    if (isdefined("attributes.is_kur")) url_string = "#url_string#&is_kur=#attributes.is_kur#";
    if (isdefined("attributes.field_select_name")) url_string = "#url_string#&field_select_name=#attributes.field_select_name#";
    if (isdefined("attributes.is_select")) url_string = "#url_string#&is_select=#attributes.is_select#";
    if (isdefined("attributes.is_potansiyel")) url_string = "#url_string#&is_potansiyel=#attributes.is_potansiyel#";
</cfscript><!---20131112--->
<script type="text/javascript">
    function load_opener_accounts(p_id,c_id,name,c_name,member_code,p_name,p_surname,i_code_id,i_code_name,ozel_kod,resp_emp,resp_emp_name,acc_type_id)
    {   
     
        <cfif isdefined("attributes.field_ims_code_name")>
            <cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_ims_code_name#</cfoutput>.value = i_code_name;
        </cfif>
        <cfif isdefined("attributes.field_ims_code_id")>
            <cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_ims_code_id#</cfoutput>.value = i_code_id;
        </cfif>
        <cfif isdefined("attributes.field_ozel_kod")>
            <cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_ozel_kod#</cfoutput>.value = ozel_kod ;
        </cfif>
        <cfif isdefined("attributes.field_notify_app_type")>
            <cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_notify_app_type#</cfoutput>.value = 'employee';
        </cfif>
        <cfif isdefined("attributes.field_notify_app_id")>
            <cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_notify_app_id#</cfoutput>.value = resp_emp;
        </cfif>
        <cfif isdefined("attributes.field_notify_app_name")>
            <cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_notify_app_name#</cfoutput>.value = resp_emp_name;
        </cfif>
        form_add_opener_doviz.pid.value = p_id;
        form_add_opener_doviz.p_name.value = p_name;
        form_add_opener_doviz.p_surname.value = p_surname;
        form_add_opener_doviz.member_code.value = member_code;
        form_add_opener_doviz.c_id.value = c_id;
        form_add_opener_doviz.name.value = name;
        form_add_opener_doviz.c_name.value = c_name;
        if(acc_type_id != 'undefined')
            form_add_opener_doviz.acc_type_id.value = acc_type_id;
        <cfif isdefined('attributes.function_name')>
            <cfif isdefined("attributes.is_partner_address") and attributes.is_partner_address eq 1>
               <cfoutput>#function_name#</cfoutput>(p_id,1);		//sirket yetkilisinin subesine bagli ulke.
            <cfelse>
                <cfoutput>#function_name#</cfoutput>(c_id,1);
            </cfif>
        </cfif>
        
        <cfif isdefined("attributes.draggable")>loadPopupBox('form_add_opener_doviz','<cfoutput>#attributes.modal_id#</cfoutput>');<cfelse>form_add_opener_doviz.submit()</cfif>;
        <cfif isdefined("attributes.satir") and len(attributes.satir)>
            var satir = <cfoutput>#attributes.satir#</cfoutput>;
        <cfelse>
            var satir = -1;
        </cfif>
        if(<cfif isdefined("attributes.draggable")>document<cfelse>window.opener</cfif>.basket && satir > -1) 
            <cfif isdefined("attributes.draggable")>document<cfelse>window.opener</cfif>.updateBasketItemFromPopup(satir, { COMPANY_ID: c_id, NAME_COMPANY: c_name, MEMBER_CODE:member_code});//CARİ HESAP POPUNDA SEÇİLEN CARİYİ BASKETTE ATAR.
    }
</script>
<form name="form_add_opener_doviz" id="form_add_opener_doviz"  method="post" action="widgetloader?widget_load=listParsJs&isbox=1<cfoutput>#url_string#</cfoutput>">
    <input type="hidden" name="pid" id="pid">
    <input type="hidden" name="member_code" id="member_code">
    <input type="hidden" name="c_id" id="c_id">
    <input type="hidden" name="name" id="name">
    <input type="hidden" name="c_name" id="c_name">
    <input type="hidden" name="p_name" id="p_name">
    <input type="hidden" name="p_surname" id="p_surname">
    <input type="hidden" name="modal_id" id="modal_id" value="<cfoutput>#attributes.modal_id#</cfoutput>">
    <input type="hidden" name="acc_type_id" id="acc_type_id">
    <input type="hidden" name="x_add_multi_acc" id="x_add_multi_acc" value="<cfif isdefined("x_add_multi_acc") and x_add_multi_acc eq 1>1<cfelse>0</cfif>">
    <input type="hidden" name="is_multi_act" id="is_multi_act" value="<cfif isdefined("attributes.is_multi_act")><cfoutput>#attributes.is_multi_act#</cfoutput><cfelse>0</cfif>">
    <cfif isdefined("attributes.row_no")>
        <input type="hidden" name="row_no" id="row_no" value="<cfoutput>#attributes.row_no#</cfoutput>">
    </cfif>
</form>
<cfif isdefined('session.ep.consumer_priority') and session.ep.consumer_priority eq 1 and not isdefined("attributes.is_priority_off") and (listcontainsnocase(select_list,3) or listcontainsnocase(select_list,5) or listcontainsnocase(select_list,8))>
    <!--- <cfif attributes.fuseaction is 'objects.popup_list_all_pars'>
        <cflocation url="#request.self#?fuseaction=objects.popup_list_all_cons#url_string#" addtoken="no">
    <cfelseif attributes.fuseaction is 'objects.popup_list_pot_pars'>
        <cflocation url="#request.self#?fuseaction=objects.popup_list_pot_cons#url_string#" addtoken="no">
    <cfelseif attributes.fuseaction is 'objects.popup_list_pars'>
        <cflocation url="#request.self#?fuseaction=objects.popup_list_cons#url_string#" addtoken="no">
    </cfif>	 --->
</cfif>
<cfscript>
    if (isdefined('attributes.is_form_submitted')) url_string = '#url_string#&is_form_submitted=1';
    url_string = '#url_string#&is_priority_off=1';
</cfscript>
<cfsavecontent variable="head_">
    <cfoutput>
        <div class="form-row">
            <div class="form-group col-lg-2">
                <select class="form-control" name="categories" id="categories">
                    <cfif listcontainsnocase(select_list,1)>
                        <option value="widgetloader?widget_load=listPos&isbox=1&draggable=1&modal_id=#attributes.modal_id#&#url_string#" ><cf_get_lang dictionary_id='58875.Calisanlar'></option>
                    </cfif>                   
                    <cfif listcontainsnocase(select_list,7)>
                        <option value="widgetloader?widget_load=listPars&isbox=1&draggable=1&modal_id=#attributes.modal_id#&#url_string#" <cfif attributes.widget_load is "listPars"> selected</cfif>><cfif isdefined("attributes.is_buyer_seller") and (attributes.is_buyer_seller eq 0)><!---<cf_get_lang_main no='1261.Musteriler'>---><cf_get_lang dictionary_id='29408.Kurumsal Uyeler'><cfelseif isdefined("attributes.is_buyer_seller") and (attributes.is_buyer_seller eq 1)><cf_get_lang dictionary_id='29528.Tedarikciler'><cfelse><cf_get_lang dictionary_id='29408.Kurumsal Uyeler'></cfif></option>
                    </cfif>
                    <cfif listcontainsnocase(select_list,8)>
                        <option value="widgetloader?widget_load=listCons&isbox=1&draggable=1&modal_id=#attributes.modal_id#&#url_string#"><cf_get_lang dictionary_id='29406.Bireysel Uyeler'></option>
                    </cfif>
                </select>
            </div>
        </div>
    </cfoutput>
</cfsavecontent>
<cfform name="search_par" id="search_par" action="widgetloader?widget_load=listPars&isbox=1&#url_string#" method="post">
    <input name="is_form_submitted" id="is_form_submitted" type="hidden" value="1" />
    <cfif isdefined("is_potansiyel") and len(is_potansiyel)><cfinput name="type" id="type" type="hidden" value="#attributes.is_potansiyel#" /></cfif>
    <cfif isdefined("attributes.is_partner_address") and attributes.is_partner_address eq 1><input name="is_partner_address_" id="is_partner_address_" type="hidden" value="1" /></cfif>
    <div class="form-row">
        <div class="form-group col-lg-2">
            <label class="font-weight-bold"><cf_get_lang dictionary_id='58585.Kod'>-<cf_get_lang dictionary_id='57574.Şirket'></label>
            <cfsavecontent variable="message"><cf_get_lang dictionary_id='58585.Kod'>-<cf_get_lang dictionary_id='57574.Şirket'></cfsavecontent>
            <cfinput type="text" class="form-control" tabindex="1" name="keyword" id="keyword" value="#attributes.keyword#" maxlength="50"  placeholder="#message#">
        </div>
        <div class="form-group col-lg-2">
            <label class="font-weight-bold"><cf_get_lang dictionary_id='57578.Yetkili'></label>
            <cfsavecontent variable="message"><cf_get_lang dictionary_id='57578.Yetkili'></cfsavecontent>
            <cfinput type="text" class="form-control" tabindex="1" name="contact" id="contact" value="#attributes.contact#" maxlength="50"  placeholder="#message#">
        </div>
        <div class="form-group col-lg-2">
            <label class="font-weight-bold"><cf_get_lang dictionary_id='48176.Phone No.'></label>
            <cfsavecontent variable="message"><cf_get_lang dictionary_id='48176.Phone No.'></cfsavecontent>
            <input type="text" class="form-control" name="phone" id="phone" value="<cfoutput>#attributes.phone#</cfoutput>" maxlength="10"  placeholder="<cfoutput>#message#</cfoutput>"/>
        </div>
         <div class="form-group col-lg-2">
            <label class="font-weight-bold"><cf_get_lang dictionary_id='57428.Email'></label>
            <cfsavecontent variable="message"><cf_get_lang dictionary_id='57428.Email'></cfsavecontent>
            <input type="text" class="form-control" name="email" id="email" value="<cfoutput>#attributes.email#</cfoutput>" maxlength="10"  placeholder="<cfoutput>#message#</cfoutput>"/>
        </div>
        <div class="form-group col-lg-2">
            <label class="font-weight-bold"><cf_get_lang dictionary_id='57752.Vergi No'></label>
            <cfsavecontent variable="message"><cf_get_lang dictionary_id='57752.Vergi No'></cfsavecontent>
            <input type="text" class="form-control" name="tax_no" id="tax_no" value="<cfoutput>#attributes.tax_no#</cfoutput>" maxlength="10"  placeholder="<cfoutput>#message#</cfoutput>"/>
        </div>
   <!---      <div class="form-group col-lg-2">
            <label class="font-weight-bold"><cf_get_lang dictionary_id='57486.Kategori'></label>
            <select class="form-control" name="comp_cat" id="comp_cat" tabindex="6">
                <option value=""><cf_get_lang dictionary_id='57486.Kategori'></option>
                <cfoutput query="get_comp_cat">
                    <option value="#get_comp_cat.companycat_id#" <cfif isdefined("attributes.comp_cat") and attributes.comp_cat eq get_comp_cat.companycat_id>selected</cfif>>#get_comp_cat.companycat#</option>
                </cfoutput>
            </select>
        </div> --->
       <!---  <div class="form-group col-lg-2">
            <label class="font-weight-bold"><cf_get_lang dictionary_id='57756.Durum'></label>
            <select class="form-control" name="search_status" id="search_status">
                <option value="1" <cfif isDefined('attributes.search_status') and attributes.search_status is 1>selected</cfif>><cf_get_lang dictionary_id='57493.Aktif'></option>
                <option value="0" <cfif isDefined('attributes.search_status') and attributes.search_status is 0>selected</cfif>><cf_get_lang dictionary_id='57494.Pasif'></option>
                <option value="" <cfif isDefined('attributes.search_status') and not len(attributes.search_status)>selected</cfif>><cf_get_lang dictionary_id='58081.Tümü'></option>
            </select>
        </div> --->
        <div class="form-group col-lg-1">    
            <label class="font-weight-bold" style="visibility:hidden">Ara </label>         
			<button type="button" id="search_btn" class="btn font-weight-bold text-uppercase btn-color-7" onclick="control()&&loadPopupBox('search_par','<cfoutput>#attributes.modal_id#</cfoutput>')"><i class="fa fa-search"></i>  <cf_get_lang dictionary_id='57565.Ara'></button>
		</div>
    </div>
    <cfset url_string = "#url_string#&sector_cat_id=#attributes.sector_cat_id#">
    <cfif len(attributes.keyword)>
        <cfset url_string = "#url_string#&keyword=#attributes.keyword#">
    </cfif>
    <cfif len(attributes.keyword_partner)>
        <cfset url_string = "#url_string#&keyword_partner=#attributes.keyword_partner#">
    </cfif>
    <cfif len(attributes.category_name)>
        <cfset url_string = "#url_string#&category_name=#attributes.category_name#">
    </cfif>
    <cfif len(attributes.product_cat_id)>
        <cfset url_string = "#url_string#&product_cat_id=#attributes.product_cat_id#">
    </cfif>
    <cfif len(attributes.product_cat_hierarchy)>
        <cfset url_string = "#url_string#&product_cat_hierarchy=#attributes.product_cat_hierarchy#">
    </cfif>
    <cfif isdefined("attributes.search_status")>
        <cfset url_string = "#url_string#&search_status=#attributes.search_status#">
    </cfif> 
    <cfif isdefined("attributes.comp_cat") and len(attributes.comp_cat)>
        <cfset url_string = "#url_string#&comp_cat=#attributes.comp_cat#">
    </cfif>
    <cfif isdefined("attributes.is_buyer_seller") and len(attributes.is_buyer_seller)>
        <cfset url_string = "#url_string#&is_buyer_seller=#attributes.is_buyer_seller#">
    </cfif>
    <cfif isdefined("attributes.sales_zones") and len(attributes.sales_zones)>
        <cfset url_string = "#url_string#&sales_zones=#attributes.sales_zones#">
    </cfif>
    <cfif isdefined("attributes.customer_value") and len(attributes.customer_value)>
        <cfset url_string = "#url_string#&customer_value=#attributes.customer_value#">
    </cfif>
    <cfif isdefined("attributes.city_name") and len(attributes.city_name)>
        <cfset url_string = "#url_string#&city_name=#attributes.city_name#">
    </cfif>
    <cfif isdefined("attributes.control_pos") and len(attributes.control_pos)>
        <cfset url_string = "#url_string#&control_pos=#attributes.control_pos#">
    </cfif>
    <cfif isdefined("attributes.zero_bakiye")>
        <cfset url_string = '#url_string#&zero_bakiye=#attributes.zero_bakiye#'>
    </cfif>
    <cfif isdefined("attributes.period_id")>
        <cfset url_string = "#url_string#&period_id=#attributes.period_id#">
    </cfif>
    <cfif isdefined("attributes.tax_no")>
        <cfset url_string = "#url_string#&tax_no=#attributes.tax_no#">
    </cfif>
</cfform>
<cfoutput>#head_#</cfoutput>

<div class="table-responsive ui-scroll">
    <table class="table table-hover">
        <cfset cols = 7>
        <thead class="main-bg-color">
            <tr>
                <th class="text-uppercase"><cf_get_lang dictionary_id='57487.No'></th>		  
                <th class="text-uppercase"><cf_get_lang dictionary_id='57574.Şirket'></th>
                <th class="text-uppercase"><cf_get_lang dictionary_id='57578.Yetkili'></th>
                <th class="text-uppercase"><cf_get_lang dictionary_id='32381.Interaction'></th>
                <cfif isdefined("x_add_multi_acc") and x_add_multi_acc eq 1 and isdefined("attributes.is_multi_act") and attributes.is_multi_act eq 1>
                <th class="text-uppercase"><cf_get_lang dictionary_id='32694.Muhasebe Hesabı'></th></cfif>
                <th class="text-uppercase"><cf_get_lang dictionary_id='57971.Şehir'></th>
                <th class="text-uppercase"><cf_get_lang dictionary_id='57486.Kategorisi'></th>          
                <th class="text-uppercase" title="<cf_get_lang dictionary_id='50173.Buyer / Dealer'>"><cf_get_lang dictionary_id='58061.Cari'></th>
                <th class="text-uppercase" title="<cf_get_lang dictionary_id='58515.Active / Passive'>">A/P</th>
            </tr>
        </thead>
        <tbody>	
            <cfif get_partners.recordcount>
                <cfset city_list=''>
                <cfset county_list = ''>
                <cfset ims_code_list =''>
                <cfoutput query="get_partners" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                    <cfif len(city) and not listfindnocase(city_list,city)>
                        <cfset city_list = Listappend(city_list,city)>
                    </cfif>
                    <cfif len(county) and not listfind(county_list,county)>
                        <cfset county_list = listappend(county_list,county)>
                    </cfif>
                    <cfif len(ims_code_id) and not listfindnocase(ims_code_list,ims_code_id)>
                        <cfset ims_code_list = Listappend(ims_code_list,ims_code_id)>
                    </cfif>
                </cfoutput>
                <cfif listlen(city_list)>
                    <cfset city_list=listsort(city_list, "numeric","ASC",",")>
                    <cfquery name="GET_CITY_INFO" datasource="#DSN#">
                        SELECT CITY_ID,CITY_NAME FROM SETUP_CITY WHERE CITY_ID IN (#city_list#) ORDER BY CITY_ID
                    </cfquery>	
                    <cfset city_list = listsort(listdeleteduplicates(valuelist(get_city_info.city_id,',')),'numeric','ASC',',')>
                </cfif>
                <cfif listlen(ims_code_list)>
                    <cfset ims_code_list=listsort(ims_code_list, "numeric","ASC",",")>
                    <cfquery name="GET_IMS_CODE_NAME" datasource="#DSN#">
                        SELECT IMS_CODE_ID, IMS_CODE, IMS_CODE_NAME FROM SETUP_IMS_CODE WHERE IMS_CODE_ID IN (#ims_code_list#) ORDER BY IMS_CODE_ID
                    </cfquery>
                </cfif>
                <cfoutput query="get_partners" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                    <cfquery name="GET_RESP" dbtype="query">
                        SELECT * FROM GET_RESPS WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#company_id#">
                    </cfquery>
                    <tr>
                        <td>#member_code#</td>
                        <td>
                            <cfif isdefined("attributes.camp_id")>
                                <a href="#request.self#?fuseaction=campaign.emptypopup_add_target_people&member_type=partner&par_id=#partner_id#&camp_id=#attributes.camp_id#" class="tableyazi"><!--- <cfif xml_is_short_name eq 1>#nickname# / </cfif> --->#left(fullname,100)#</a>
                            <cfelse>
                                <cfset ims_code_name_=''>
                                <cfif isdefined("attributes.field_ims_code_name") and len(ims_code_list)>
                                    <cfset ims_code_name_ = '#get_ims_code_name.ims_code[listfind(ims_code_list,get_partners.ims_code_id,',')]# #get_ims_code_name.ims_code_name[listfind(ims_code_list,get_partners.ims_code_id,',')]#'>
                                </cfif>
                                <cfset str_fullname ='#replace(fullname,"'"," ","all")#'>
                                <cfset str_fullname ='#replace(str_fullname,"&"," ","all")#'>
                                <cfset str_fullname ='#replace(str_fullname,'"'," ","all")#'>
                                <cfset str_partner_name ='#replace(company_partner_name,"'"," ","all")#'>
                                <cfset str_partner_name ='#replace(str_partner_name,'"'," ","all")#'>
                                <cfset str_partner_surname ='#replace(company_partner_surname,"'"," ","all")#'>
                                <cfset str_partner_surname ='#replace(str_partner_surname,'"'," ","all")#'>
                                <cfif isdefined("x_add_multi_acc") and x_add_multi_acc eq 1 and isdefined("attributes.is_multi_act") and attributes.is_multi_act eq 1>
                                    <cfset company_id_ = company_id&'_'&acc_type_id>
                                <cfelse>
                                    <cfset company_id_ = company_id>
                                </cfif>
                                <cfif isdefined("attributes.satir") and len(attributes.satir)>
                                    <a href="javascript://" onClick="add_pro('#company_id_#','#fullname#','#member_code#')" class="tableyazi">#left(fullname,100)#</a>
                                <cfelse>
                                    <a href="javascript://" onclick="load_opener_accounts('<cfif partner_id gt -1>#partner_id#</cfif>','#company_id_#',<cfif len(trim(company_partner_name))>'#str_partner_name# #str_partner_surname#'<cfelse>''</cfif>,'#str_fullname#','#member_code#','#str_partner_name#','#str_partner_surname#','#ims_code_id#','#ims_code_name_#','#ozel_kod#'<cfif get_resp.recordcount>,'#get_resp.employee_id#','#get_emp_info(get_resp.employee_id,0,0)#'<cfelse>,'',''</cfif><cfif isdefined("acc_type_id")>,#acc_type_id#</cfif>);" class="tableyazi"><!--- <cfif xml_is_short_name eq 1>#nickname# / </cfif> --->#left(fullname,100)#</a>
                                </cfif>
                            </cfif>
                        </td>
                        <td>
                            <cfif isdefined("attributes.camp_id")>
                                <a href="#request.self#?fuseaction=campaign.emptypopup_add_target_people&member_type=partner&par_id=#partner_id#&camp_id=#attributes.camp_id#" class="tableyazi">#company_partner_name# #company_partner_surname#</a>
                            <cfelse>
                            <cfif isdefined("x_add_multi_acc") and x_add_multi_acc eq 1 and isdefined("attributes.is_multi_act") and attributes.is_multi_act eq 1>
                                <cfset company_id_ = company_id&'_'&acc_type_id>
                            <cfelse>
                                <cfset company_id_ = company_id>
                            </cfif>
                                <a href="##" onclick="load_opener_accounts(<cfif partner_id gt -1>'#partner_id#'<cfelse>''</cfif>,'#company_id_#','#str_partner_name# #str_partner_surname#','#str_fullname#','#member_code#','#str_partner_name#','#str_partner_surname#','#ims_code_id#','#ims_code_name_#','#ozel_kod#'<cfif get_resp.recordcount>,'#get_resp.employee_id#','#get_emp_info(get_resp.employee_id,0,0)#'<cfelse>,'',''</cfif><cfif isdefined("acc_type_id")>,#acc_type_id#</cfif>);" class="tableyazi">#company_partner_name# #company_partner_surname#</a>
                            </cfif>
                        </td>
                        <td>
                            <cfset get_opportunities = {recordcount: 0} />
                            <cfset get_help = {recordcount: 0} />
                            <cfset get_subs = {recordcount: 0} />
                            <cfif len(partner_id)>
                                <cfset get_opportunities = opportunitiesCFC.GET_OPPORTUNITIES(sales_member_id:partner_id,sales_member_type:'partner',opp_status:1)>
                                <cfquery name="get_help" datasource="#DSN#">
                                    SELECT CUS_HELP_ID FROM CUSTOMER_HELP WHERE PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#partner_id#">
                                </cfquery>
                                <cfset get_subs = contract_cmp.GET_SUBSCRIPTIONS(status:1, sales_partner_id:partner_id, startrow:1, maxrows:500000)>
                            </cfif>
                           
                            <span class="rounded-circle tab-circle mr-1" style="background-color:##e91e63d1;<cfif len(get_help.recordcount) lt 10>padding:10px 14px</cfif>" title="<cf_get_lang dictionary_id='40704.Interaction'>">#get_help.recordcount#</span>
                            <span class="rounded-circle tab-circle mr-1" style="background-color:##3f51b5c7;<cfif len(get_opportunities.recordcount) lt 10>padding:10px 14px</cfif>" title="<cf_get_lang dictionary_id='57612.Opportunities'>">#get_opportunities.recordcount#</span>
                            <span class="rounded-circle tab-circle" style="background-color:##009688d9;<cfif len(get_subs.recordcount) lt 10>padding:10px 14px</cfif>" title="<cf_get_lang dictionary_id='58832.Abone'>">#get_subs.recordcount#</span>
                        </td>
                        <cfif isdefined("x_add_multi_acc") and x_add_multi_acc eq 1 and isdefined("attributes.is_multi_act") and attributes.is_multi_act eq 1>
                        <td>#ACC_TYPE#</td></cfif>
                        <td><cfif listlen(city_list)>#get_city_info.city_name[listfind(city_list,get_partners.city,',')]#</cfif></td>
                        <td>#companycat#</td>
                        <td><cfif is_buyer eq 1 or is_seller eq 1><cf_get_lang dictionary_id='58061.Cari'><cfelseif ISPOTANTIAL eq 1><cf_get_lang dictionary_id='57577.Potansiyel'></cfif></td>
                        <td><cfif company_status eq 1>A<cfelse>P</cfif></td>
                  
                    </tr>
                </cfoutput> 
            <cfelse>
                <tr>
                    <td height="20" colspan="12"><cfif not len(attributes.is_form_submitted)><cf_get_lang dictionary_id='57701.Filtre Ediniz'> !<cfelse><cf_get_lang dictionary_id='65447.Yeni filtre seçenekleri ile tekrar arayınız. Eğer aradığınız müşteri kayıtlı değilse yeni müşteri kaydediniz.'> !</cfif></td>
                </tr>
            </cfif>
        </tbody>
    </table>
    <cfif get_partners.recordcount eq 0 and len(attributes.is_form_submitted)>
        <div class="form-group">
            <cfoutput>
                <button type="button" id="add_pars" class="btn font-weight-bold text-uppercase btn-color-5" onclick="openBoxDraggable('widgetloader?widget_load=addCompanyApp&isbox=1&style=maxi&title=#getLang('','',51592)#')"><i class="fa fa-plus"></i>  <cf_get_lang dictionary_id='51592.Add New Customer'></button>
            </cfoutput>             
        </div>
    </cfif>
        <cfif attributes.totalrecords and (attributes.totalrecords gt attributes.maxrows)>
            <table width="99%" cellpadding="0" cellspacing="0" border="0" align="center" height="35">
                <tr>
                    <td>
                        <cf_pages 
                            page="#attributes.page#" 
                            maxrows="#attributes.maxrows#" 
                            totalrecords="#attributes.totalrecords#" 
                            startrow="#attributes.startrow#" 
                            adres="widgetloader?widget_load=listPars&isbox=1#url_string#" 
                            isAjax="1">
                    </td>
                    <td style="text-align:right"><cfoutput><cf_get_lang dictionary_id='57540.Total Record'>:#attributes.totalrecords#&nbsp;-&nbsp;<cf_get_lang dictionary_id='57581.Page'>:#attributes.page#/#lastpage#</cfoutput> </td>
                </tr>
            </table>
        </cfif>
</div>
<script type="text/javascript">
    $(document).ready(function(){
        $( "#keyword" ).focus();
    });
    <cfif not isdefined('attributes.is_form_submitted')>
            //basketden geliyorsa basketde üye degişim kontrolü varmı ona göre üye seçtirmiyor
        if(<cfif isdefined("attributes.draggable")>document<cfelse>window.opener</cfif>.basket != undefined)
        {	
            var str_control=0;
            if((<cfif isdefined("attributes.draggable")>document<cfelse>window.opener</cfif>.$("#basket_main_div #company_id").length != 0 && <cfif isdefined("attributes.draggable")>document<cfelse>window.opener</cfif>.$("#basket_main_div #company_id").val().length != 0) || (<cfif isdefined("attributes.draggable")>document<cfelse>window.opener</cfif>.$("#basket_main_div #consumer_id").length != 0 && <cfif isdefined("attributes.draggable")>document<cfelse>window.opener</cfif>.$("#basket_main_div #consumer_id").val().length != 0) || (<cfif isdefined("attributes.draggable")>document<cfelse>window.opener</cfif>.$("#basket_main_div #member_type").length != 0 && <cfif isdefined("attributes.draggable")>document<cfelse>window.opener</cfif>.$("#basket_main_div #member_type").val().length != 0))
            {
                for(var spt_row=0;spt_row < <cfif isdefined("attributes.draggable")>document<cfelse>window.opener</cfif>.basket.items.length;spt_row++)
                {
                    if(<cfif isdefined("attributes.draggable")>document<cfelse>window.opener</cfif>.basket.items[spt_row].PRODUCT_ID)
                    {
                        str_control = 1;
                        break;	
                    }
                }
                if(str_control == 1)
                {
                    var get_basket_member_info = wrk_safe_query('obj_get_basket_member_info','dsn3',0,<cfif isdefined("attributes.draggable")>document<cfelse>window.opener</cfif>.basket.hidden_values.basket_id);
                    if(get_basket_member_info.recordcount)
                    {
                        alert("<cf_get_lang dictionary_id ='33802.Belgede Satırlar Seçilmiş Üye Değiştiremezsiniz'>");
                        <cfif not isdefined("attributes.draggable")>window.close();<cfelseif isdefined("attributes.draggable")>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );</cfif>
                    }
                }
            }
        }
    </cfif>
    function change_category(vl)
    {
        var listParam ;
        if(vl == "") vl = "0;0;0";
        <cfif isdefined("session.ep.userid")>
            listParam = "<cfoutput>#session.ep.userid#</cfoutput>*"+list_getat(vl,2,';');

        </cfif>
        var get_my_companycat = wrk_safe_query('obj_get_my_companycat','dsn',0,listParam);
        if(get_my_companycat.recordcount)
        {
            for(j=<cfoutput>#get_comp_cat.recordcount#</cfoutput>;j>=0;j--)
                document.getElementById("comp_cat").options[j] = null;
            
            document.getElementById("comp_cat").options[0] = new Option("<cf_get_lang dictionary_id='57486.Kategori'>","");
            for(var jj=0;jj<get_my_companycat.recordcount;jj++)
            {
                document.getElementById("comp_cat").options[jj+1]=new Option(get_my_companycat.COMPANYCAT[jj],get_my_companycat.COMPANYCAT_ID[jj]);
            }
        }
    }
    $("#categories").change(function(){
		openBoxDraggable(this.value,<cfoutput>#attributes.modal_id#</cfoutput>);  		
	});
    $('#popup_box_<cfoutput>#attributes.modal_id#</cfoutput>').keypress(function (e) {
        var key = e.which;
        if(key == 13)        {
            $('#search_btn').click();
            return false;  
        }
    });   
    function control(){
        if($('#search_par #keyword').val() == '' && $('#search_par #contact').val()== '' && $('#search_par #email').val()== '' && $('#search_par #phone').val()== '' && $('#search_par #tax_no').val()== ''){
            var div = $('<div>');
            div.attr({"class":"ui-draggable-box","id":"popup_box_20222022"});
            div.append('<div class="card card-maxi"><div class="card-header"><span class="card-title"><span class="card-label"><cf_get_lang dictionary_id="57425.Uyarı"></span></span><div class="card-toolbar portHeadLightMenu"><ul><li><a class="catalystClose" onclick="closeBoxDraggable(20222022);"><i class="fas fa-times"></i></a></li></ul></div></div><div class="card-body"><ul class="required_list"><li class="required"><i class="fa fa-terminal"></i><cf_get_lang dictionary_id="57526.You should filter at least one field."></li></ul></div></div>');
            $('body').append(div);
            div.fadeIn();
            return false;
        }
        return true;
    }
</script>
