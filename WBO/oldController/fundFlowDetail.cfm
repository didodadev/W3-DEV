<cf_get_lang_set module_name="account">
<cfquery name="get_branchs" datasource="#dsn#">
	SELECT 
		BRANCH_ID,BRANCH_NAME 
	FROM 
		BRANCH 
	WHERE
		BRANCH_STATUS = 1 
		AND COMPANY_ID = #session.ep.company_id#
	<cfif listgetat(attributes.fuseaction,1,'.') is 'store'>
		AND BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#)
	</cfif>
	ORDER BY BRANCH_NAME
</cfquery>
<cfparam name="attributes.acc_card_type" default="">
<cfparam name="attributes.search_date" default="#dateformat(now(),'dd/mm/yyyy')#">
<cf_date tarih="attributes.search_date">
<cfif isdefined("is_submitted")>
	<cfquery name="GET_SETUP" datasource="#DSN2#">
	SELECT
		*
	FROM
		SETUP_FUND_TABLE_LIST
</cfquery>
	<cfquery name="GET_FUND_FLOW_DEF" datasource="#dsn2#">
	SELECT
		DEF_SELECTED_ROWS,
		INVERSE_REMAINDER
	FROM
		ACCOUNT_DEFINITIONS
	WHERE
		DEF_TYPE_ID=11
</cfquery>
<cfif GET_FUND_FLOW_DEF.RECORDCOUNT>
	<cfset SELECTED_LIST = GET_FUND_FLOW_DEF.DEF_SELECTED_ROWS >
	<cfset inv_rem = GET_FUND_FLOW_DEF.INVERSE_REMAINDER >
	<cfquery name="GET_FUND_FLOW" datasource="#DSN2#">
		SELECT
			*
		FROM
			FUND_FLOW_TABLE
		WHERE
			FUND_FLOW_ID IN (#SELECTED_LIST#) OR
			ACCOUNT_CODE IS NULL	
		ORDER BY 
			CODE
	</cfquery>
	<cfset view_amount_type = GET_FUND_FLOW.VIEW_AMOUNT_TYPE >
</cfif>
<cfelse>
	<cfset GET_FUND_FLOW_DEF.recordcount=0>
	<cfset GET_FUND_FLOW.recordcount=0>
</cfif>
<cfquery name="get_acc_card_type" datasource="#dsn3#">
	SELECT PROCESS_TYPE,PROCESS_CAT_ID,PROCESS_CAT FROM SETUP_PROCESS_CAT WHERE PROCESS_TYPE IN (10,11,12,13,14,19) ORDER BY PROCESS_TYPE
</cfquery>
<script type="text/javascript">
	function save_fund_flow_table()
	{
		if(document.getElementById("search_date").value=='')
		{
			alert("<cf_get_lang no ='197.Önce Tarihleri Seçiniz'>!");
			return false;
		}
		date2 = document.getElementById("search_date").value;
		fintab_type_ = document.getElementById("fintab_type").value;
		windowopen('<cfoutput>#request.self#?fuseaction=account.list_fund_flow_detail&event=add&module=#fusebox.circuit#&faction=#fusebox.fuseaction#</cfoutput>&fintab_type='+fintab_type_+'&date2='+date2,'small');
	}
</script>

<cfif IsDefined("attributes.event") and attributes.event eq 'add'>
	<script type="text/javascript">
		function kontrol()
		{
			if(document.getElementById("user_given_name").value == "")
			{
				alert("<cf_get_lang_main no ='782.Zorunlu Alan'>:<cf_get_lang no ='91.Tablo Adi'>");
				return false;
			}
			return true;
		}
		function get_content()
		{
			document.getElementById("cons_last").value = window.opener.document.getElementById("cons_last").value;
		}
		$(document).ready(function(e) {
		   get_content();
		})
	</script>
</cfif>  

 <cfif IsDefined("attributes.event") and attributes.event eq 'det'>
	<cfquery name="GET_RECORDS" datasource="#DSN3#">
        SELECT
            TABLE_NAME,
            USER_GIVEN_NAME,
            SOURCE,
            RECORD_DATE
        FROM
            SAVE_ACCOUNT_TABLES
        WHERE
            SAVE_ID=#attributes.id#
    </cfquery>
	<script type="text/javascript">
		$(document).ready(function(e) {
		   $('.footermenus td:first').attr('colspan',2) 
		});
	</script>
</cfif> 
<cfscript>
	WOStruct = StructNew();
	WOStruct['#attributes.fuseaction#'] = structNew();
	
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'account.list_fund_flow_detail';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'account/display/list_fund_flow_sheet.cfm';
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'account.list_fund_flow_detail';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'account/form/add_financial_table.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'account/query/add_save_fintab.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'account.list_fund_flow_detail';
	
	WOStruct['#attributes.fuseaction#']['det'] = structNew();
	WOStruct['#attributes.fuseaction#']['det']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['det']['fuseaction'] = 'account.list_fund_flow_detail';
	WOStruct['#attributes.fuseaction#']['det']['filePath'] = 'account/display/detail_fintab.cfm';
	WOStruct['#attributes.fuseaction#']['det']['queryPath'] = 'account/display/detail_fintab.cfm';
	WOStruct['#attributes.fuseaction#']['det']['nextEvent'] = 'account.list_fund_flow_detail';
	WOStruct['#attributes.fuseaction#']['det']['parameters'] = 'id=##attributes.id##';
	WOStruct['#attributes.fuseaction#']['det']['Identity'] = '##attributes.id##';
	
	WOStruct['#attributes.fuseaction#']['extendedForm'] = structNew();
	WOStruct['#attributes.fuseaction#']['extendedForm']['controllerFileName'] = 'fundFlowDetail';
	WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'add';
	WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'SAVE_ACCOUNT_TABLES';
	WOStruct['#attributes.fuseaction#']['extendedForm']['dataSourceName'] = 'company';
	WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "['item-2']"; 
</cfscript>

