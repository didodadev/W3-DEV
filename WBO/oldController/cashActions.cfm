<cf_get_lang_set module_name="cash"><!--- sayfanin en altinda kapanisi var --->
<cf_xml_page_edit fuseact="cash.list_cash_actions">
<cfparam name="attributes.oby" default="1">
<cfparam name="toplam_bakiye" default="0">
<cfparam name="toplam_bakiye_" default="0">
<cfparam name="attributes.action_cash" default="2">
<cfparam name="attributes.special_definition_id" default="">
<cfparam name="attributes.project_head" default="">
<cfparam name="attributes.project_id" default="">
<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.company" default="">
<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.consumer_id" default="">
<cfparam name="attributes.employee_id" default="">
<cfparam name="attributes.employee_name" default="">
<cfparam name="attributes.member_type" default="">
<cfparam name="attributes.record_emp_id" default="">
<cfparam name="attributes.record_emp_name" default="">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.record_date" default="">
<cfparam name="attributes.record_date2" default="">
<cfparam name="attributes.paper_number" default="">
<cfparam name="attributes.cash_status" default="">
<cfparam name="attributes.action" default="">
<cfparam name="attributes.is_excel" default="">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfif isdefined("attributes.employee_id")>
	<cfscript>
		attributes.acc_type_id = '';
		if(listlen(attributes.employee_id,'_') eq 2)
		{
			attributes.acc_type_id = listlast(attributes.employee_id,'_');
			attributes.emp_id = listfirst(attributes.employee_id,'_');
		}
		else
			attributes.emp_id = attributes.employee_id;
	</cfscript>
</cfif>
<cfscript>
	cashActions = createobject("component","cash.cfc.cash");
	totalValue = createObject("component","cash.cfc.cash");
	totalValue.dsn2 = dsn2;
	totalValue.dsn = dsn;
	totalValue.dsn_alias = dsn_alias;
	totalValue.dsn3_alias = dsn3_alias;
	cashActions.dsn2 = dsn2;
	cashActions.dsn = dsn;
	cashActions.dsn_alias = dsn_alias;
	cashActions.dsn3_alias = dsn3_alias;
	cashActions.upload_folder = upload_folder;
</cfscript>
<cfif isdefined("attributes.is_form_submitted")>
	<cfif isdefined("attributes.record_date") and isdate (attributes.record_date)><cf_date tarih ="attributes.record_date"></cfif>
	<cfif isdefined("attributes.record_date2") and isdate (attributes.record_date2)><cf_date tarih ="attributes.record_date2"></cfif>
    <cfif isdefined("attributes.start_date") and isdate(attributes.start_date)><cf_date tarih = "attributes.start_date"></cfif>
    <cfif isdefined("attributes.finish_date") and isdate(attributes.finish_date)><cf_date tarih = "attributes.finish_date"></cfif>
    <cfscript>
		get_cash_actions = cashActions.getCashActions
		(
			is_excel : attributes.is_excel,
			acc_type_id : attributes.acc_type_id,
			employee_id : attributes.employee_id,
			emp_id : attributes.emp_id,
			record_date : attributes.record_date,
			record_date2 : attributes.record_date2,
			start_date : attributes.start_date,
			finish_date : attributes.finish_date,
			page_action_type : attributes.page_action_type,
			company_id : attributes.company_id,
			consumer_id : attributes.consumer_id,
			member_type : attributes.member_type,
			company : attributes.company,
			record_emp_id : attributes.record_emp_id,
			record_emp_name : attributes.record_emp_name,
			keyword : attributes.keyword,
			paper_number : attributes.paper_number,
			cash : attributes.cash,
			action : attributes.action,
			special_definition_id : attributes.special_definition_id,
			branch_id : attributes.branch_id,
			cash_status : attributes.cash_status,
			action_cash : attributes.action_cash,
			project_head : attributes.project_head,
			project_id : attributes.project_id,
			is_money : iif(isdefined("attributes.is_money") and len(attributes.is_money),de("attributes.is_money"),de('')),
			oby : attributes.oby,
			startrow : attributes.startrow,
			maxrows : attributes.maxrows,
			fuseaction : attributes.fuseaction,
			x_branch_info : x_branch_info,
			x_project_info : x_project_info
		);
		getTotalValue = totalValue.getCashActionTotal
		(
			acc_type_id : attributes.acc_type_id,
			employee_id : attributes.employee_id,
			emp_id : attributes.emp_id,
			record_date : attributes.record_date,
			record_date2 : attributes.record_date2,
			start_date : attributes.start_date,
			finish_date : attributes.finish_date,
			page_action_type : attributes.page_action_type,
			company_id : attributes.company_id,
			consumer_id : attributes.consumer_id,
			member_type : attributes.member_type,
			company : attributes.company,
			record_emp_id : attributes.record_emp_id,
			record_emp_name : attributes.record_emp_name,
			keyword : attributes.keyword,
			paper_number : attributes.paper_number,
			cash : attributes.cash,
			action : attributes.action,
			special_definition_id : attributes.special_definition_id,
			branch_id : attributes.branch_id,
			cash_status : attributes.cash_status,
			action_cash : attributes.action_cash,
			project_head : attributes.project_head,
			project_id : attributes.project_id,
			oby : attributes.oby,
			fuseaction : attributes.fuseaction,
			x_branch_info : x_branch_info,
			x_project_info : x_project_info
		);
	</cfscript>
	<cfif not (isdefined("attributes.is_excel") and attributes.is_excel eq 1)>
        <cfparam name="attributes.totalrecords" default='#get_cash_actions.query_count#'>
    <cfelse>
        <cfparam name="attributes.totalrecords" default="0">
    </cfif>
	<cfset arama_yapilmali = 0 >
<cfelse>
	<cfset GET_CASH_ACTIONS.recordcount = 0 >
    <cfparam name="attributes.totalrecords" default="0">
	<cfset arama_yapilmali = 1 >
</cfif>
<cfquery name="get_money_rate" datasource="#dsn2#">
	SELECT 
        MONEY, 
        RATE2, 
        MONEY_STATUS, 
        PERIOD_ID, 
        COMPANY_ID
    FROM 
    	SETUP_MONEY 
    WHERE 
	    MONEY_STATUS = 1 ORDER BY MONEY_ID
</cfquery>
<cfoutput query="get_money_rate">
	<cfset "rate_#money#" = rate2>
</cfoutput>
<cfif not isdefined("attributes.start_date")>
	<cfif session.ep.our_company_info.UNCONDITIONAL_LIST>
		<cfset attributes.start_date=''>
	<cfelse>
		<cfset attributes.start_date = '#date_add('d',-7,wrk_get_today())#'>
	</cfif>
</cfif>
<cfif not isdefined("attributes.finish_date")>
	<cfif session.ep.our_company_info.UNCONDITIONAL_LIST>
		<cfset attributes.finish_date=''>
	<cfelse>
		<cfset  attributes.finish_date= '#date_add('d',7,attributes.start_date)#'>
	</cfif>
</cfif>
<cfif not isdefined("attributes.record_date")>
	<cfset attributes.record_date=''>
</cfif>
<cfif not isdefined("attributes.record_date2")>
	<cfset attributes.record_date2=''>
</cfif>
<cfquery name="GET_CASHS" datasource="#dsn2#">
	SELECT
		CASH_ID,
		CASH_NAME,
		BRANCH_ID,
		CASH_CURRENCY_ID
	FROM 
		CASH 
		<cfif listgetat(attributes.fuseaction,1,'.') is 'store'>
			WHERE
				BRANCH_ID = #ListGetAt(session.ep.user_location,2,"-")#
		</cfif>
	ORDER BY 
		CASH_NAME
</cfquery>
<cfquery name="get_branchs" datasource="#dsn#">
	SELECT BRANCH_ID,BRANCH_NAME FROM BRANCH 
	<cfif listgetat(attributes.fuseaction,1,'.') is 'store'>
		WHERE
			BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#)
	</cfif>
	ORDER BY BRANCH_ID
</cfquery>
<cfif isDefined("attributes.cash") and len(attributes.cash) and attributes.oby eq 2 and isDefined('attributes.start_date') and len(attributes.start_date)>
    <cfquery name="GET_REMAINDER" datasource="#dsn2#">
        WITH CTE1 AS (
            SELECT
                (CASE
                    WHEN CASH_ACTION_TO_CASH_ID IS NOT NULL THEN 0 
                    WHEN CASH_ACTION_FROM_CASH_ID IS NOT NULL THEN 1
                 END) AS BA,
                 CASH_ACTION_VALUE
            FROM
                CASH_ACTIONS
            WHERE
                ACTION_ID IS NOT NULL AND
                ISNULL(CASH_ACTION_TO_CASH_ID,CASH_ACTION_FROM_CASH_ID) = #attributes.cash#
                <cfif isDefined('attributes.start_date') and len(attributes.start_date)> AND ACTION_DATE < #attributes.start_date#</cfif>
        )
            SELECT
                ISNULL(SUM(CTE1.CASH_ACTION_VALUE * (1 - 2 * CTE1.BA)),0) BAKIYE
            FROM
                CTE1
    </cfquery>
</cfif>
<cfset cat_list = '30,31,32,310,320,33,120,21,22,121,311,34,35'><!---34 VE 35 V15 KAPSAMINDA EKLENDİ --->
<cfquery name="GET_PROCESS_CAT" datasource="#DSN3#">
	SELECT PROCESS_TYPE,PROCESS_CAT_ID,PROCESS_CAT FROM SETUP_PROCESS_CAT WHERE PROCESS_TYPE IN (#cat_list#) ORDER BY PROCESS_TYPE
</cfquery>
<script type="text/javascript">
	$(document).ready(function(){
		document.getElementById('keyword').focus();
	});
	function input_control()
	{
		if(cash_list.company.value.length == 0)
		{
			cash_list.company_id.value = '';
			cash_list.consumer_id.value = '';
		}
		return true;
	}
</script>
<cfscript>
	// Switch //
	WOStruct = StructNew();
	
	WOStruct['#attributes.fuseaction#'] = structNew();
	
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	
	WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
	WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'list';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'CASH_ACTIONS';
	WOStruct['#attributes.fuseaction#']['systemObject']['dataSourceName'] = dsn2;
	WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'ACTION_ID';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "";	
	
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'cash.list_cash_actions';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'cash/display/list_cash_actions.cfm';

</cfscript>
