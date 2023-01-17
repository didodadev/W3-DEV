<cf_get_lang_set module_name="bank">
<cfif isdefined("attributes.date1") and isdate(attributes.date1)>
	<cf_date tarih = "attributes.date1">
<cfelse>	
	<cfif session.ep.our_company_info.UNCONDITIONAL_LIST>
		<cfset attributes.date1 = ''>
	<cfelse>
		<cfset attributes.date1 = date_add('d',-7,wrk_get_today())>
	</cfif>
</cfif>
<cfif isdefined("attributes.date2") and isdate(attributes.date2)>
	<cf_date tarih = "attributes.date2">
<cfelse>	
	<cfif session.ep.our_company_info.UNCONDITIONAL_LIST>
		<cfset attributes.date2 = ''>
	<cfelse>
		<cfset attributes.date2 = #date_add('d',7,attributes.date1)#>
	</cfif>
</cfif>
<cfparam name="attributes.search_id" default="">
<cfparam name="attributes.search_name" default="">
<cfparam name="attributes.search_type" default="">
<cfparam name="attributes.emp_type" default="">
<cfparam name="attributes.emp_name" default="">
<cfparam name="attributes.emp_id" default="">
<cfparam name="attributes.record_emp_id" default="">
<cfparam name="attributes.record_emp_name" default="">
<cfparam name="attributes.record_date" default="">
<cfparam name="attributes.record_date2" default="">
<cfparam name="attributes.special_definition_id" default="">
<cfparam name="attributes.action_bank" default="2">
<cfparam name="attributes.bankAccount" default="">
<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.project_head" default="">
<cfparam name="attributes.project_id" default="">

<cfinclude template="../bank/query/get_money_rate.cfm">
<cfquery name="GET_ACCOUNTS" datasource="#dsn3#">
	SELECT
		ACCOUNT_ID,
	<cfif session.ep.period_year lt 2009>
        CASE WHEN(ACCOUNT_CURRENCY_ID = 'TL') THEN 'YTL' ELSE ACCOUNT_CURRENCY_ID END AS ACCOUNT_CURRENCY_ID,
    <cfelse>
        ACCOUNT_CURRENCY_ID,
    </cfif>
		ACCOUNT_NAME
	FROM
		ACCOUNTS
	<cfif session.ep.isBranchAuthorization>
	WHERE
		ACCOUNT_ID IN(SELECT AB.ACCOUNT_ID FROM ACCOUNTS_BRANCH AB WHERE AB.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ListGetAt(session.ep.user_location,2,"-")#">)
	</cfif>
	ORDER BY
		ACCOUNT_NAME
</cfquery>
<cfquery name="get_branchs" datasource="#dsn#">
	SELECT BRANCH_ID,BRANCH_NAME FROM BRANCH 
		WHERE
			COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
            AND BRANCH_STATUS = 1
	<cfif session.ep.isBranchAuthorization>
			AND BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)
	</cfif>
	ORDER BY BRANCH_NAME
</cfquery>

<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.paper_number" default="">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>

<cfset cat_list = '20,21,22,23,24,25,230,240,253,26,27,104,105,120,121,243,247,244,248,291,292,293,294,254'>
<cfquery name="GET_PROCESS_CAT" datasource="#DSN3#">
	SELECT PROCESS_TYPE,PROCESS_CAT_ID,PROCESS_CAT FROM SETUP_PROCESS_CAT WHERE PROCESS_TYPE IN (#cat_list#) ORDER BY PROCESS_TYPE
</cfquery>
<script language="javascript">
	function hesap_sec()
	{
		if(document.bank_list.search_id.value!='')
		{
			document.bank_list.search_id.value='';
			document.bank_list.emp_name.value='';
			document.bank_list.emp_type.value='';
		}
		if(document.bank_list.emp_id != undefined && document.bank_list.emp_id.value!='')
		{
			document.bank_list.emp_id.value='';
			document.bank_list.emp_name.value='';
			document.bank_list.emp_type.value='';
		}
		if(document.bank_list.search_type.value!='')
		{
			document.bank_list.search_type.value='';
			document.bank_list.emp_name.value='';
			document.bank_list.emp_type.value='';
		}
	}
</script>
<cfscript>
	// Switch //
	WOStruct = StructNew();
	
	WOStruct['#attributes.fuseaction#'] = structNew();
	
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	
	WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
	WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'list';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'BANK_ACTIONS';
	WOStruct['#attributes.fuseaction#']['systemObject']['dataSourceName'] = dsn2;
	WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'ACTION_ID';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "";	
	
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'bank.list_bank_actions';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'bank/display/list_bank_actions.cfm';

</cfscript>