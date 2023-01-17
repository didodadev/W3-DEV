<cf_xml_page_edit fuseact="ch.list_duty_claim">
<cf_get_lang_set module_name="ch">
<cfparam name="attributes.startdate" default="">
<cfparam name="attributes.finishdate" default="">
<cfparam name="attributes.startdate2" default="">
<cfparam name="attributes.finishdate2" default="">
<cfparam name="attributes.consumer_id" default="">
<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.employee_id" default="">
<cfparam name="attributes.member_name" default="">
<cfparam name="attributes.member_type" default="">
<cfparam name="attributes.member_cat_type" default="">
<cfparam name="attributes.member_cat_value" default="">
<cfparam name="attributes.money_info" default="">
<cfparam name="attributes.due_info" default="1">
<cfparam name="attributes.order_type" default="1">
<cfparam name="attributes.city" default="">
<cfparam name="attributes.country" default="">
<cfparam name="attributes.sales_zones" default="">
<cfparam name="attributes.duty_claim" default="">
<cfparam name="attributes.resource" default="">
<cfparam name="attributes.customer_value" default="">
<cfparam name="attributes.buy_status" default="">
<cfparam name="attributes.project_id" default="">
<cfparam name="attributes.project_head" default="">
<cfparam name="attributes.vade_dev" default="">
<cfparam name="attributes.comp_status" default="">
<cfparam name="attributes.ims_code_id" default=""> 
<cfparam name="attributes.vade_borc_ara_toplam" default="0">
<cfparam name="attributes.vade_alacak_ara_toplam" default="0">
<cfparam name="attributes.money_type_info" default="">
<cfparam name="attributes.asset_id" default="">
<cfparam name="attributes.asset_name" default="">
<cfparam name="attributes.special_definition_type" default="">
<cfparam name="attributes.expense_center_id" default="">
<cfparam name="attributes.expense_center_name" default="">
<cfparam name="attributes.expense_item_id" default="">
<cfparam name="attributes.expense_item_name" default="">
<cfparam name="attributes.branch_id" default="">
<cfif not isdefined("is_revenue_duedate")>
	<cfset is_revenue_duedate = 0>
</cfif>
<cfscript>
	cmp_branch = createObject("component","hr.cfc.get_branches");
	cmp_branch.dsn = dsn;
	get_branchs = cmp_branch.get_branch();
</cfscript>
<cfquery name="get_company_cat" datasource="#dsn#">
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
<cfquery name="get_consumer_cat" datasource="#dsn#">
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
<cfquery name="get_customer_value" datasource="#dsn#">
	SELECT CUSTOMER_VALUE_ID,CUSTOMER_VALUE FROM SETUP_CUSTOMER_VALUE ORDER BY CUSTOMER_VALUE
</cfquery>
<cfquery name="get_country" datasource="#dsn#">
	SELECT COUNTRY_ID,COUNTRY_NAME FROM SETUP_COUNTRY ORDER BY COUNTRY_NAME
</cfquery>
<cfquery name="get_sales_zones" datasource="#dsn#">
	SELECT SZ_ID, SZ_NAME FROM SALES_ZONES ORDER BY SZ_NAME
</cfquery>
<cfquery name="get_resource" datasource="#dsn#">
	SELECT RESOURCE_ID, RESOURCE FROM COMPANY_PARTNER_RESOURCE ORDER BY RESOURCE
</cfquery>
<cfquery name="get_all_ch_type" datasource="#dsn#">
    SELECT ACC_TYPE_ID,ACC_TYPE_NAME FROM SETUP_ACC_TYPE ORDER BY ACC_TYPE_ID
</cfquery>
<!---Tahsilat / Ödeme tipi alanının multiple olması için eklemiştir.--->
<cfquery name="GET_SPECIAL_DEFINITION" datasource="#DSN#">
	SELECT SPECIAL_DEFINITION_ID,SPECIAL_DEFINITION,SPECIAL_DEFINITION_TYPE FROM SETUP_SPECIAL_DEFINITION WHERE SPECIAL_DEFINITION_TYPE IN (1,2)
</cfquery>
<cfscript>
	alacak = 0;
	borc = 0;
	alacak_2 = 0;
	borc_2 = 0;
	top_alacak_dev = 0;
	top_borc_dev = 0;
	top_alacak_dev_2 = 0;
	top_borc_dev_2 = 0;
	top_bakiye_dev = 0;
	sayfa_toplam_alacak = 0;
	sayfa_toplam_borc = 0;
	top_bakiye_dev_2 = 0;
	top_bakiye_dev_3 = 0;
	sayfa_toplam_alacak_2 = 0;
	sayfa_toplam_borc_2 = 0;
	sayfa_toplam_alacak_3 = 0;
	sayfa_toplam_borc_3 = 0;
	top_ceksenet = 0;
	top_ceksenet_ch = 0;
	top_ceksenet_other = 0;
	top_ceksenet2 = 0;
	top_ceksenet_ch2 = 0;
	top_ceksenet_other2 = 0;
	sayfa_toplam_ceksenet_ch = 0;
	sayfa_toplam_ceksenet_other = 0;
	sayfa_toplam_ceksenet_ch2 = 0;
	sayfa_toplam_ceksenet_other2 = 0;
	sayfa_toplam_ceksenet_ch3 = 0;
	sayfa_toplam_ceksenet_other3 = 0;
</cfscript>
<cfquery name="get_money" datasource="#dsn2#">
	SELECT MONEY FROM SETUP_MONEY
</cfquery>
<cfoutput query="get_money">
	<cfset 'toplam_borc_#money#' = 0>
	<cfset 'toplam_alacak_#money#' = 0>
	<cfset 'toplam_ceksenet_#money#' = 0>
	<cfset 'toplam_ceksenet_ch_#money#' = 0>
	<cfset 'toplam_ceksenet_other_#money#' = 0>
</cfoutput>

<cfquery name="GET_CITY" datasource="#DSN#">
    SELECT CITY_ID,CITY_NAME FROM SETUP_CITY <cfif len(attributes.country)>WHERE COUNTRY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.country#"></cfif>
</cfquery>
<cfif len(attributes.ims_code_id) and len(attributes.ims_code_name)>
    <cfquery name="GET_IMS" datasource="#dsn#">
        SELECT IMS_CODE,IMS_CODE_NAME FROM SETUP_IMS_CODE WHERE IMS_CODE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ims_code_id#">
    </cfquery>
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
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'ch.list_duty_claim';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'ch/display/list_duty_claim.cfm';
</cfscript>

