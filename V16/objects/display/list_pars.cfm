
<cf_xml_page_edit fuseact="objects.popup_list_pars">
<cfinclude template="../query/get_company_sector.cfm">
<cfscript>
	accountingType = createObject("component","V16.settings.cfc.accountingType");
    getAccount = accountingType.getAccountType();
</cfscript>
<script type="text/javascript">
function add_pro(company_id,fullname,member_code)
{  
	<cfif isdefined("attributes.satir") and len(attributes.satir)>
		var satir = <cfoutput>#attributes.satir#</cfoutput>;
	<cfelse>
		var satir = -1;
	</cfif>
	if(<cfif isdefined("attributes.draggable")>document<cfelse>window.opener</cfif>.basket && satir > -1) 
		<cfif not isdefined("attributes.draggable")>window.opener.</cfif>updateBasketItemFromPopup(satir, { COMPANY_ID: company_id, NAME_COMPANY: fullname,MEMBER_CODE:member_code}); // Basket Çalışmaları için eklendi. Kaldırmayınız. 20140826

	
	<cfif not isdefined("attributes.draggable")>window.close();<cfelse>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );</cfif>

}
</script>
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.product_cat_hierarchy" default="">
<cfparam name="attributes.product_cat_id" default="">
<cfparam name="attributes.category_name" default="">
<cfparam name="attributes.keyword_partner" default="">
<cfparam name="attributes.sector_cat_id" default="">
<cfparam name="attributes.customer_value_id" default="">
<cfparam name="attributes.sz_id" default="">
<cfparam name="attributes.tax_no" default="">
<cfparam name="attributes.search_status" default="1">
<cfparam name="attributes.is_my_extre_page" default="0">
<cfparam name="attributes.is_kur" default="">
<cfparam name="attributes.ACCOUNT_TYPE_ID" default="">
<cfparam name="attributes.modal_id" default="">
<cfparam name="attributes.is_period_kontrol" default="1"><!--- 0 olara gönderildiğinde dönem bilgisinin default olarak seçilmemesi sağlanır. --->
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
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
<cfif fusebox.use_period>
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
</cfif>
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
        WEP.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND 
        WEP.IS_MASTER = 1  
</cfquery>
<cfif not isNumeric(attributes.maxrows)>
	<cfset attributes.maxrows = session.ep.maxrows>
</cfif>
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.modal_id" default="">
<cfset attributes.startrow = ((attributes.page-1)*attributes.maxrows) + 1 >
<cfif isdefined('attributes.is_form_submitted') or (isdefined("attributes.keyword") and len(attributes.keyword))>
	<cfinclude template="../query/get_partners.cfm">
<cfelse>
	<cfset get_partners.recordcount = 0>
</cfif>
<cfif get_partners.recordcount>
	<cfparam name="attributes.totalrecords" default="#get_partners.query_count#">
<cfelse>
	<cfparam name="attributes.totalrecords" default="0">
</cfif>

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
				<cfif isdefined("attributes.draggable")><cfelse>window.opener.</cfif><cfoutput>#function_name#</cfoutput>(p_id,1);		//sirket yetkilisinin subesine bagli ulke.
			<cfelse>
				<cfif isdefined("attributes.draggable")><cfelse>window.opener.</cfif><cfoutput>#function_name#</cfoutput>(c_id,1);
			</cfif>
		</cfif>
		<cfif isdefined("attributes.draggable")>loadPopupBox('form_add_opener_doviz')<cfelse>form_add_opener_doviz.submit()</cfif>;
		<cfif isdefined("attributes.satir") and len(attributes.satir)>
			var satir = <cfoutput>#attributes.satir#</cfoutput>;
		<cfelse>
			var satir = -1;
		</cfif>
		if(<cfif isdefined("attributes.draggable")>document<cfelse>window.opener</cfif>.basket && satir > -1) 
			<cfif not isdefined("attributes.draggable")>window.opener.</cfif>updateBasketItemFromPopup(satir, { COMPANY_ID: c_id, NAME_COMPANY: c_name, MEMBER_CODE:member_code});//CARİ HESAP POPUNDA SEÇİLEN CARİYİ BASKETTE ATAR.

		<cfif not isdefined("attributes.draggable")><cfelse>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );</cfif>
		
	}
</script>
<form name="form_add_opener_doviz" id="form_add_opener_doviz"  method="post" action="<cfoutput>#request.self#?fuseaction=objects.popup_add_company_js#url_string#</cfoutput>">
	<input type="hidden" name="pid" id="pid">
	<input type="hidden" name="member_code" id="member_code">
	<input type="hidden" name="c_id" id="c_id">
	<input type="hidden" name="name" id="name">
	<input type="hidden" name="c_name" id="c_name">
	<input type="hidden" name="p_name" id="p_name">
	<input type="hidden" name="p_surname" id="p_surname">
	<input type="hidden" name="acc_type_id" id="acc_type_id">
	<input type="hidden" name="x_add_multi_acc" id="x_add_multi_acc" value="<cfif isdefined("x_add_multi_acc") and x_add_multi_acc eq 1>1<cfelse>0</cfif>">
	<input type="hidden" name="is_multi_act" id="is_multi_act" value="<cfif isdefined("attributes.is_multi_act")><cfoutput>#attributes.is_multi_act#</cfoutput><cfelse>0</cfif>">
	<cfif isdefined("attributes.row_no")>
		<input type="hidden" name="row_no" id="row_no" value="<cfoutput>#attributes.row_no#</cfoutput>">
	</cfif>
</form>
<cfif isdefined('session.ep.consumer_priority') and session.ep.consumer_priority eq 1 and not isdefined("attributes.is_priority_off") and (listcontainsnocase(select_list,3) or listcontainsnocase(select_list,5) or listcontainsnocase(select_list,8))>
	<script>
		<cfif attributes.fuseaction is 'objects.popup_list_all_pars'>
			<cfif isdefined("attributes.draggable")>openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_all_cons#url_string#</cfoutput>','<cfoutput>#attributes.modal_id#</cfoutput>')<cfelse>location.href="<cfoutput>#request.self#?fuseaction=objects.popup_list_all_cons#url_string#</cfoutput>";</cfif>
		<cfelseif attributes.fuseaction is 'objects.popup_list_pot_pars'>
			<cfif isdefined("attributes.draggable")>
				openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_pot_cons#url_string#','#attributes.modal_id#</cfoutput>');
			<cfelse>
				location.href="<cfoutput>#request.self#?fuseaction=objects.popup_list_pot_cons#url_string#</cfoutput>" ;
			</cfif>
		<cfelseif attributes.fuseaction is 'objects.popup_list_pars'>
			<cfif isdefined("attributes.draggable")>
				openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_cons#url_string#','#attributes.modal_id#</cfoutput>');
			<cfelse>
				location.href="<cfoutput>#request.self#?fuseaction=objects.popup_list_cons#url_string#</cfoutput>" ;
			</cfif>
		</cfif>	
	</script>
	
</cfif>
<cfscript>
	if (isdefined('attributes.is_form_submitted')) url_string = '#url_string#&is_form_submitted=1';
	url_string = '#url_string#&is_priority_off=1';
</cfscript>
<cfsavecontent variable="head_">
	<cfoutput>
		<div class="ui-form-list flex-list">
			<div class="form-group">
				<select name="categories" id="categories" onChange="<cfif isdefined("attributes.draggable")>openBoxDraggable(this.value,#attributes.modal_id#);<cfelse>location.href=this.value;</cfif>" tabindex="12">
					<cfif listcontainsnocase(select_list,1)>
						<option value="#request.self#?fuseaction=objects.popup_list_positions#url_string#" selected><cf_get_lang dictionary_id='58875.Calisanlar'></option>
					</cfif>
					<cfif listcontainsnocase(select_list,2)>
						<option value="#request.self#?fuseaction=objects.popup_list_pars#url_string#" <cfif fusebox.fuseaction is "popup_list_pars"> selected</cfif>><cfif isdefined("attributes.is_buyer_seller") and (attributes.is_buyer_seller eq 0)><cf_get_lang dictionary_id='33473.C Müşteriler'><cfelseif isdefined("attributes.is_buyer_seller") and (attributes.is_buyer_seller eq 1)><cf_get_lang dictionary_id='33472.C Tedarikciler'><cfelse><cf_get_lang dictionary_id='32995.C Kurumsal Uyeler'></cfif></option>
					</cfif>
					<cfif listcontainsnocase(select_list,3)>
						<option value="#request.self#?fuseaction=objects.popup_list_cons#url_string#<cfif isdefined("attributes.is_buyer_seller")>&is_buyer_seller=#attributes.is_buyer_seller#</cfif>"><cf_get_lang dictionary_id='32996.C Bireysel Uyeler'></option>
					</cfif>
					<cfif listcontainsnocase(select_list,4)>
						<option value="#request.self#?fuseaction=objects.popup_list_grps#url_string#"><cf_get_lang dictionary_id='32716.Gruplar'></option>
					</cfif>
					<cfif listcontainsnocase(select_list,5)>
						<option value="#request.self#?fuseaction=objects.popup_list_pot_cons#url_string#"><cf_get_lang dictionary_id='32963.P Bireysel Uyeler'></option>
					</cfif>
					<cfif listcontainsnocase(select_list,6)>
						<option value="#request.self#?fuseaction=objects.popup_list_pot_pars#url_string#" <cfif fusebox.fuseaction is "popup_list_pot_pars"> selected</cfif>><cfif isdefined("attributes.is_buyer_seller") and (attributes.is_buyer_seller eq 0)><cf_get_lang dictionary_id ='58673.P Musteriler'><cfelseif isdefined("attributes.is_buyer_seller") and (attributes.is_buyer_seller eq 1)><cf_get_lang dictionary_id ='29528.P Tedarikciler'><cfelse><cf_get_lang dictionary_id='32964.P Kurumsal Uyeler'></cfif></option>
					</cfif>
					<cfif listcontainsnocase(select_list,7)>
						<option value="#request.self#?fuseaction=objects.popup_list_all_pars#url_string#" <cfif fusebox.fuseaction is "popup_list_all_pars"> selected</cfif>><cfif isdefined("attributes.is_buyer_seller") and (attributes.is_buyer_seller eq 0)><!---<cf_get_lang_main no='1261.Musteriler'>---><cf_get_lang dictionary_id='29408.Kurumsal Uyeler'><cfelseif isdefined("attributes.is_buyer_seller") and (attributes.is_buyer_seller eq 1)><cf_get_lang dictionary_id='29528.Tedarikciler'><cfelse><cf_get_lang dictionary_id='29408.Kurumsal Uyeler'></cfif></option>
					</cfif>
					<cfif listcontainsnocase(select_list,8)>
						<option value="#request.self#?fuseaction=objects.popup_list_all_cons#url_string#"><cf_get_lang dictionary_id='29406.Bireysel Uyeler'></option>
					</cfif>
					<cfif listcontainsnocase(select_list,9)>
						<option value="#request.self#?fuseaction=objects.popup_list_all_positions#url_string#"><cf_get_lang dictionary_id='32409.Tüm Çalışanlar'></option>
					</cfif>
				</select>
			</div>
		</div>
	</cfoutput>
</cfsavecontent><!--- objects.#fusebox.fuseaction#--->
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box title="#getLang('','Kurumsal Üyeler',29408)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
		<cf_wrk_alphabet keyword="url_string" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
		<cfform name="search_par" id="search_par" action="#request.self#?fuseaction=#attributes.fuseaction##url_string#" method="post">
			<input name="is_form_submitted" id="is_form_submitted" type="hidden" value="1" />
			<cfif isdefined("is_potansiyel") and len(is_potansiyel)><cfinput name="type" id="type" type="hidden" value="#attributes.is_potansiyel#" /></cfif>
			<cfif isdefined("attributes.is_partner_address") and attributes.is_partner_address eq 1><input name="is_partner_address_" id="is_partner_address_" type="hidden" value="1" /></cfif>
			<cf_box_search>
				<div class="form-group" id="item-keyword">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='58585.Kod'>-<cf_get_lang dictionary_id='57574.Şirket'></cfsavecontent>
					<cfinput type="text" tabindex="1" name="keyword" id="keyword" value="#attributes.keyword#" maxlength="50"  placeholder="#message#">
				</div>
				<cfif isdefined("xml_is_cari_one_row") and xml_is_cari_one_row eq 0>
					<div class="form-group" id="item-keyword">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='57576.Çalışan'></cfsavecontent>
						<cfinput type="text" tabindex="2" name="keyword_partner" id="keyword_partner" value="#attributes.keyword_partner#" placeholder="#message#" maxlength="50">
					</div>	
				</cfif>
				<div class="form-group" id="item-tax_no">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57752.Vergi No'></cfsavecontent>
					<input type="text" name="tax_no" id="tax_no" value="<cfoutput>#attributes.tax_no#</cfoutput>" maxlength="10"  placeholder="<cfoutput>#message#</cfoutput>"/>
				</div>
				<div class="form-group" id="item-search_status">
					<select name="search_status" id="search_status">
						<option value="1" <cfif isDefined('attributes.search_status') and attributes.search_status is 1>selected</cfif>><cf_get_lang dictionary_id='57493.Aktif'></option>
						<option value="0" <cfif isDefined('attributes.search_status') and attributes.search_status is 0>selected</cfif>><cf_get_lang dictionary_id='57494.Pasif'></option>
						<option value="" <cfif isDefined('attributes.search_status') and not len(attributes.search_status)>selected</cfif>><cf_get_lang dictionary_id='58081.Tümü'></option>
					</select>
				</div>
				<div class="form-group small">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfinput type="text" tabindex="3" name="maxrows" id="maxrows" required="yes" onKeyUp="isNumber(this)" maxlength="3" value="#attributes.maxrows#" validate="integer" range="1,250" message="#message#" >
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4" is_excel="0" search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('search_par' , #attributes.modal_id#)"),DE(""))#">
				</div>
				<div class="form-group">
					<cfif not isdefined("attributes.is_crm_module")>
						<cfif isDefined('session.ep.userid') and (get_module_user(4) or get_module_user(32))>
						<a class="ui-btn ui-btn-gray" title="<cf_get_lang dictionary_id='29409.Kurumsal Üye Ekle'>" href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=member.form_list_company&event=add&isModule=objects<cfif isDefined("attributes.isClosed") and attributes.isClosed eq 0>&isClosed=0</cfif>#url_string#</cfoutput>','wide','popup_form_add_company');"><i class="fa fa-plus"></i></a>
						</cfif>
					</cfif>
				</div>
			</cf_box_search>
			<cfquery name="GET_SALES_ZONES" datasource="#DSN#">
				SELECT SZ_ID, SZ_NAME FROM SALES_ZONES ORDER BY SZ_NAME
			</cfquery>
			<cfinclude template="../query/get_consumer_value.cfm">
			<cf_box_search_detail search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('search_par' , #attributes.modal_id#)"),DE(""))#">
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
					<cfif fusebox.use_period>
						<div class="form-group" id="item-period_id">
							<select name="period_id" id="period_id"  tabindex="4" onchange="change_category(this.value);">
								<option value=""><cf_get_lang dictionary_id ='58472.Dönem'></option>
								<cfoutput query="get_period" group="comp_id">
									<option value="0;#comp_id#;#period_id#" <cfif isDefined("attributes.period_id") and Len(attributes.period_id) and attributes.period_id eq '0;#comp_id#;#period_id#'>selected</cfif>>#Company_Name#</option>
								<cfoutput>
									<option value="1;#comp_id#;#period_id#" <cfif isDefined("attributes.period_id") and Len(attributes.period_id) and attributes.period_id eq '1;#comp_id#;#period_id#'>selected</cfif>>&nbsp;&nbsp;&nbsp;&nbsp;#Period#</option>
								</cfoutput>
								</cfoutput>
							</select>
						</div>   
					</cfif>
					<div class="form-group" id="item-sector_cat_id">
						<select name="sector_cat_id" id="sector_cat_id"  tabindex="5">
								<option value=""><cf_get_lang dictionary_id='33222.Sektörler'>
							<cfoutput query="get_company_sector">
								<option value="#sector_cat_id#"<cfif sector_cat_id eq attributes.sector_cat_id>selected</cfif>>#sector_cat#</option>
							</cfoutput>
						</select>
					</div> 
					<div class="form-group" id="item-comp_cat">
						<select name="comp_cat" id="comp_cat" tabindex="6">
							<option value=""><cf_get_lang dictionary_id='57486.Kategori'></option>
							<cfoutput query="get_comp_cat">
								<option value="#get_comp_cat.companycat_id#" <cfif isdefined("attributes.comp_cat") and attributes.comp_cat eq get_comp_cat.companycat_id>selected</cfif>>#get_comp_cat.companycat#</option>
							</cfoutput>
						</select>
					</div>
					<div class="form-group" id="item-city_name">
						<select name="city_name" id="city_name" tabindex="9">
								<option value=""><cf_get_lang dictionary_id='57971.Şehir'></option>
							<cfoutput query="get_city_name">
								<option value="#city_id#" <cfif isdefined("attributes.city_name") and city_id eq attributes.city_name>selected</cfif>>#city_name#</option>
							</cfoutput>
						</select>
					</div>
				</div>
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">	  	
					<div class="form-group" id="item-customer_value">
						<select name="customer_value" id="customer_value" tabindex="10">
							<option value=""><cf_get_lang dictionary_id='58552.Müşteri Değeri'></option>
							<cfoutput query="get_customer_value">
								<option value="#customer_value_id#" <cfif isdefined("attributes.customer_value") and customer_value_id eq attributes.customer_value>selected</cfif>>#customer_value#</option>
							</cfoutput>
						</select>
					</div>	  	
					<div class="form-group" id="item-is_buyer_seller">
						<select name="is_buyer_seller" id="is_buyer_seller" tabindex="11">
							<option value=""><cf_get_lang dictionary_id='58081.Hepsi'></option>
							<option value="0" <cfif isdefined("attributes.is_buyer_seller") and attributes.is_buyer_seller eq 0>selected</cfif>><cf_get_lang dictionary_id='58733.Alıcı'></option>
							<option value="1" <cfif isdefined("attributes.is_buyer_seller") and attributes.is_buyer_seller eq 1>selected</cfif>><cf_get_lang dictionary_id='58873.Satıcı'></option>
							<option value="2" <cfif isdefined("attributes.is_buyer_seller") and attributes.is_buyer_seller eq 2>selected</cfif>><cf_get_lang dictionary_id='57577.Potansiyel'></option>
						</select>
					</div>
					<div class="form-group" id="item-sales_zones">      
						<select name="sales_zones" id="sales_zones" tabindex="7">
							<option value=""><cf_get_lang dictionary_id='57659.Satış Bölgesi'></option>
							<cfoutput query="get_sales_zones">
								<option value="#sz_id#" <cfif isdefined("attributes.sales_zones") and sz_id eq attributes.sales_zones> selected</cfif>>#sz_name#</option>
							</cfoutput>
						</select>
					</div>	   
					<div class="form-group" id="item-pos_code_new">
						<div class="input-group">
							<input type="hidden" name="pos_code_new"  id="pos_code_new" value="<cfif isdefined("attributes.pos_code_new") and len(attributes.pos_code_new) and len(attributes.pos_code_text_new)><cfoutput>#attributes.pos_code_new#</cfoutput></cfif>">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='57908.Temsilci'></cfsavecontent>
							<input type="text" tabindex="8" placeholder="<cfoutput>#message#</cfoutput>" name="pos_code_text_new" id="pos_code_text_new" <cfif isdefined("attributes.control_pos")>readonly</cfif> value="<cfif isdefined("attributes.pos_code_new") and len(attributes.pos_code_new) and len(attributes.pos_code_text_new)><cfoutput>#attributes.pos_code_text_new#</cfoutput></cfif>">						
							<span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_code=search_par.pos_code_new&field_name=search_par.pos_code_text_new&select_list=1');return false"></span>
						</div>
					</div>
				</div>
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
					<cfif isdefined("x_is_product_category") and x_is_product_category eq 1>
						<div class="form-group" id="item-product_cat_id">
							<div class="input-group">
								<input type="hidden" name="product_cat_id" id="product_cat_id" value="<cfif len(attributes.product_cat_id) and len(attributes.category_name)><cfoutput>#attributes.product_cat_id#</cfoutput></cfif>">
								<input type="hidden" name="product_cat_hierarchy" id="product_cat_hierarchy" value="<cfif len(attributes.product_cat_hierarchy) and len(attributes.category_name)><cfoutput>#attributes.product_cat_hierarchy#</cfoutput></cfif>">
								<cfsavecontent variable="message"><cf_get_lang dictionary_id='57567.Ürün Kategorileri'></cfsavecontent>
								<input name="category_name" type="text" id="category_name" placeholder="<cfoutput>#message#</cfoutput>" style="width:100px;" onfocus="AutoComplete_Create('category_name','PRODUCT_CATID,PRODUCT_CAT,HIERARCHY','PRODUCT_CAT_NAME','get_product_cat','','PRODUCT_CATID,HIERARCHY','product_cat_id,product_cat_hierarchy','','3','200','','1');" value="<cfif len(attributes.category_name)><cfoutput>#attributes.category_name#</cfoutput></cfif>" autocomplete="off">
								<span class="input-group-addon icon-ellipsis btnPointer" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_product_cat_names&is_sub_category=1&field_id=search_par.product_cat_id&field_code=search_par.product_cat_hierarchy&field_name=search_par.category_name</cfoutput>');"></span>
							</div>           
						</div>
					</cfif>	
					<cfif isdefined("x_add_multi_acc") and x_add_multi_acc eq 1 and isdefined("attributes.is_multi_act") and attributes.is_multi_act eq 1>
						<div class="form-group" id="item-acc_type">      
							<select name="acc_type" id="acc_type">
								<option value=""><cf_get_lang dictionary_id='48681.Hesap Tipi'></option>
								<cfoutput query="getAccount">
									<option value="#ACCOUNT_TYPE_ID#" <cfif isdefined("attributes.acc_type") and attributes.acc_type eq ACCOUNT_TYPE_ID>selected</cfif>>#ACCOUNT_TYPE#</option>
								</cfoutput>
							</select>
						</div>
					</cfif> 
					<cfif isdefined("attributes.is_cari_action") and attributes.is_cari_action eq 1 and isdefined("xml_is_zero_bakiye") and xml_is_zero_bakiye eq 1>
						<div class="form-group">
							<input type="checkbox" name="zero_bakiye" id="zero_bakiye" value="1" <cfif isdefined("attributes.zero_bakiye") or not isdefined('attributes.is_form_submitted')>checked</cfif>><cf_get_lang dictionary_id='59153.Sıfır Bakiye Getirme'>
						</div>
					</cfif>
				</div>
			</cf_box_search_detail>
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
		<tbody><cfoutput>#head_#</cfoutput></tbody>
		<cf_flat_list>
			<cfset cols = 7>
			<thead>
				<tr>
					<cfif isDefined("session.ep.our_company_info.is_efatura") and session.ep.our_company_info.is_efatura eq 1>
						<th width="25"><img src="/images/icons/efatura_black.gif" align="absmiddle" title="<cf_get_lang dictionary_id='43184.E-Fatura Kullanılıyor mu'>?" /></th>
					</cfif>
					<th width="40"><cf_get_lang dictionary_id='57487.No'></th>		  
					<th width="200"><cf_get_lang dictionary_id='57574.Şirket'></th>
					<th><cf_get_lang dictionary_id='57570.Ad Soyad'></th>
					<cfif isdefined("x_add_multi_acc") and x_add_multi_acc eq 1 and isdefined("attributes.is_multi_act") and attributes.is_multi_act eq 1>
					<th><cf_get_lang dictionary_id='32694.Muhasebe Hesabı'></th></cfif>
					<th width="100"><cf_get_lang dictionary_id='57971.Şehir'></th>
					<th width="100"><cf_get_lang dictionary_id='57486.Kategorisi'></th>
					<cfif xml_is_taxinfo>
						<cfset cols = cols + 2>
						<th style="width:110px;"><cf_get_lang dictionary_id='58762.Vergi Dairesi'></th>
						<th style="width:90px;"><cf_get_lang dictionary_id='57752.Vergi No'></th>
					</cfif>
					<cfif ListFind(ListDeleteDuplicates(xml_is_display_special_code),1)>
						<cfset cols++>
						<th><cf_get_lang dictionary_id='57789.Özel Kod'> 1</th>
					</cfif>
					<cfif ListFind(ListDeleteDuplicates(xml_is_display_special_code),2)>
						<cfset cols++>
						<th><cf_get_lang dictionary_id='57789.Özel Kod'> 2</th>
					</cfif>
					<cfif ListFind(ListDeleteDuplicates(xml_is_display_special_code),3)>
						<cfset cols++>
						<th><cf_get_lang dictionary_id='57789.Özel Kod'> 3</th>
					</cfif>
					<cfif isdefined("attributes.is_cari_action") and attributes.is_cari_action eq 1 and isdefined("xml_is_bakiye") and xml_is_bakiye eq 1>
						<th width="100"><cf_get_lang dictionary_id='57589.Bakiye'><cfoutput>(#session.ep.money#)</cfoutput></th>
					</cfif>
					<th width="20"><i class="fa fa-table " title="<cf_get_lang dictionary_id='57809.Hesap Ekstresi'>"></i></th>
					<th width="20"><i class="fa fa-plus " title="<cf_get_lang dictionary_id='57582.Ekle'>"></i></th>
					<th width="20"><i class="icon-detail" title="<cf_get_lang dictionary_id='57771.Detay'>"></i></th>
				</tr>
			</thead>
			<tbody>	
				<cfif get_partners.recordcount>
					<cfset city_list=''>
					<cfset county_list = ''>
					<cfset ims_code_list =''>
					<cfoutput query="get_partners">
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
					<cfoutput query="get_partners" >
						<cfquery name="GET_RESP" dbtype="query">
							SELECT * FROM GET_RESPS WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#company_id#">
						</cfquery>
						<tr>
							<cfif isDefined("session.ep.our_company_info.is_efatura") and session.ep.our_company_info.is_efatura eq 1>
								<td>
									<cfif USE_EFATURA eq 1>
										<img src="/images/icons/efatura_green.gif" align="absmiddle" title="<cf_get_lang dictionary_id='60087.E-Fatura Kullanılıyor'>" />
									<cfelse>
										<img src="/images/icons/efatura_red.gif" align="absmiddle" title="<cf_get_lang dictionary_id='60088.E-Fatura Kullanılmıyor'>" />
									</cfif>
								</td>
							</cfif>
							<td>#member_code#</td>
							<td>
								<cfif isdefined("attributes.camp_id")>
									<a href="#request.self#?fuseaction=campaign.emptypopup_add_target_people&member_type=partner&par_id=#partner_id#&camp_id=#attributes.camp_id#" class="tableyazi"><cfif xml_is_short_name eq 1>#nickname# / </cfif>#left(fullname,100)#</a>
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
										<a href="javascript://" onclick="load_opener_accounts('<cfif partner_id gt -1>#partner_id#</cfif>','#company_id_#',<cfif len(trim(company_partner_name))>'#str_partner_name# #str_partner_surname#'<cfelse>''</cfif>,'#str_fullname#','#member_code#','#str_partner_name#','#str_partner_surname#','#ims_code_id#','#ims_code_name_#','#ozel_kod#'<cfif get_resp.recordcount>,'#get_resp.employee_id#','#get_emp_info(get_resp.employee_id,0,0)#'<cfelse>,'',''</cfif><cfif isdefined("acc_type_id")>,#acc_type_id#</cfif>);" class="tableyazi"><cfif xml_is_short_name eq 1>#nickname# / </cfif>#left(fullname,100)#</a>
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
							<cfif isdefined("x_add_multi_acc") and x_add_multi_acc eq 1 and isdefined("attributes.is_multi_act") and attributes.is_multi_act eq 1>
							<td>#ACC_TYPE#</td></cfif>
							<td><cfif listlen(city_list)>#get_city_info.city_name[listfind(city_list,get_partners.city,',')]#</cfif></td>
							<td>#companycat#</td>
							<cfif xml_is_taxinfo>
								<td>#taxoffice#</td>
								<td>#taxno#</td>
							</cfif>
							<cfif ListFind(ListDeleteDuplicates(xml_is_display_special_code),1)>
								<td>#ozel_kod#</td>
							</cfif>
							<cfif ListFind(ListDeleteDuplicates(xml_is_display_special_code),2)>
								<td>#ozel_kod_1#</td>
							</cfif>
							<cfif ListFind(ListDeleteDuplicates(xml_is_display_special_code),3)>
								<td>#ozel_kod_2#</td>
							</cfif>
							<cfif isdefined("attributes.is_cari_action") and attributes.is_cari_action eq 1 and xml_is_bakiye><td style="text-align:right;" nowrap="nowrap"><cfif len(bakiye)>#tlformat(bakiye)#<cfelse>#tlformat(0)#</cfif></td></cfif>
							<td nowrap="nowrap">
								<cfif isDefined('session.ep.userid') and not listfindnocase(denied_pages,'objects.popup_list_comp_extre')>
									<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_list_comp_extre&member_type=partner&member_id=#company_id#&comp_name=#nickname#&date_control=1&form_submit=1<cfif isdefined("is_store_module")>&is_store_module=1</cfif>','page');"><i class="fa fa-table " title="<cf_get_lang dictionary_id='57809.Hesap Ekstresi'>"></i></a>
								</cfif> 
							</td>
							<td>
								<cfif isDefined('session.ep.userid') and get_module_user(4)>
									<a href="javascript://" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_form_add_partner&compid=#company_id##url_string#')"><i class="fa fa-plus " title="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a>
								</cfif>
							</td>
							<td>
								<a href="javascript://" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_com_det&company_id=#company_id#','medium')"><i class="icon-detail" title="<cf_get_lang dictionary_id='57771.Detay'>"></i></a>
							</td>
						</tr>
					</cfoutput> 
				<cfelse>
					<tr>
						<td height="20" colspan="12"><cfif not isdefined('attributes.is_form_submitted')><cf_get_lang dictionary_id='57701.Filtre Ediniz'> !<cfelse><cf_get_lang dictionary_id='57484.Kayıt Yok'> !</cfif></td>
					</tr>
				</cfif>
			</tbody>
		</cf_flat_list>
		<cfif attributes.maxrows lt attributes.totalrecords>
			<cfif isDefined("attributes.draggable") and len(attributes.draggable)>
				<cfset url_string = '#url_string#&draggable=#attributes.draggable#'>
			</cfif>
			<cf_paging 
				page="#attributes.page#" 
				maxrows="#attributes.maxrows#" 
				totalrecords="#attributes.totalrecords#" 
				startrow="#attributes.startrow#" 
				adres="#attributes.fuseaction##url_string#" 
				isAjax="#iif(isdefined("attributes.draggable"),1,0)#">
		</cfif>
	</cf_box>
</div>

<script type="text/javascript">
	$(document).ready(function(){
		$( "form[name=search_par] #keyword" ).focus();
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
						<cfif not isdefined("attributes.draggable")>window.close();<cfelse>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );</cfif>

					}
				}
			}
		}
	</cfif>
	function change_category(vl)
	{
		if(vl == "") vl = "0;0;0";
		listParam = "<cfoutput>#session.ep.userid#</cfoutput>*"+list_getat(vl,2,';');
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
	
</script>
