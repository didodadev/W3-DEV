<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
	<cfparam name="attributes.keyword" default="">
	<cfparam name="attributes.sal_year" default="#session.ep.period_year#">
	
	<cfif isdefined("attributes.is_submit")>
		<cfquery name="get_kesinti" datasource="#dsn#">
			SELECT
				SO.AMOUNT_PAY,
				SO.COMMENT_PAY,
				SO.END_SAL_MON,
				SO.METHOD_PAY,
				SO.MONEY,
				SO.ODKES_ID,
				SO.START_SAL_MON
			FROM 
				SETUP_PAYMENT_INTERRUPTION SO
			WHERE 
				SO.IS_ODENEK = 0
				<cfif len(attributes.keyword)> 
					AND SO.COMMENT_PAY LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
				</cfif>
				<cfif isDefined("attributes.status") and len(attributes.status)>
					AND STATUS = <cfqueryparam cfsqltype="cf_sql_bit" value="#attributes.status#">
				</cfif>
		</cfquery>
	<cfelse>
		<cfset get_kesinti.recordcount = 0>
	</cfif>
	<cfparam name="attributes.page" default=1>
	<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
	<cfparam name="attributes.totalrecords" default='#get_kesinti.recordcount#'>
<cfelseif isdefined("attributes.event") and (attributes.event is 'add' or attributes.event is 'upd')>
	<cfquery name="get_ch_types" datasource="#dsn#">
		SELECT ACC_TYPE_ID,ACC_TYPE_NAME FROM SETUP_ACC_TYPE ORDER BY ACC_TYPE_NAME
	</cfquery>
	<cfif attributes.event is 'upd'>
		<cfquery name="get_odenek" datasource="#dsn#">
			SELECT
				ACC_TYPE_ID,
				ACCOUNT_CODE,
				ACCOUNT_NAME,
				AMOUNT_PAY,
				CALC_DAYS,
				COMMENT_PAY,
				COMPANY_ID,
				CONSUMER_ID,
				END_SAL_MON,
				FROM_SALARY,
				IS_DEMAND,
				IS_EHESAP,
				IS_INST_AVANS,
				METHOD_PAY,
				MONEY,
				PERIOD_PAY,
				RECORD_DATE,
				RECORD_EMP,
				SHOW,
				START_SAL_MON,
				STATUS,
				TAX,
				UPDATE_DATE,
				UPDATE_EMP
			FROM 
				SETUP_PAYMENT_INTERRUPTION 
			WHERE 
				ODKES_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.odkes_id#">
		</cfquery>
	</cfif>
</cfif>

<script type="text/javascript">
	<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
		$(document).ready(function() {
			$('#keyword').focus();
		});
	<cfelseif isdefined("attributes.event") and (attributes.event is 'add' or attributes.event is 'upd')>
		function form_chk()
		{
			$('#amount').val(filterNum($('#amount').val()));
			return true;
		}
	</cfif>
</script>

<cfscript>
	WOStruct = StructNew();
	WOStruct['#attributes.fuseaction#'] = structNew();
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	if(not isdefined('attributes.event'))
		attributes.event = WOStruct['#attributes.fuseaction#']['default'];
	
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'ehesap.list_kesinti';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'hr/ehesap/display/list_kesinti.cfm';
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'ehesap.popup_form_add_kesinti';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'hr/ehesap/form/add_kesinti.cfm ';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'hr/ehesap/query/add_kesinti.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'ehesap.list_kesinti&event=upd';
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'ehesap.popup_form_upd_kesinti';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'hr/ehesap/form/upd_kesinti.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'hr/ehesap/query/upd_kesinti.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'ehesap.list_kesinti&event=upd';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'odkes_id=##attributes.odkes_id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##get_odenek.comment_pay##';
	
	if(not attributes.event is 'add')
	{
		WOStruct['#attributes.fuseaction#']['del'] = structNew();
		WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
		WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'ehesap.list_kesinti';
		WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'hr/ehesap/query/del_kesinti.cfm';
		WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'hr/ehesap/query/del_kesinti.cfm';
		WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'ehesap.list_kesinti';
	}
	
	if ((isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event"))
	{
		attributes.startrow=((attributes.page-1)*attributes.maxrows)+1;
		url_str = "";
		if (isdefined("attributes.keyword") and len(attributes.keyword))
			url_str = "#url_str#&keyword=#attributes.keyword#";
		if (isdefined("attributes.sal_year") and len(attributes.sal_year))
			url_str = "#url_str#&sal_year=#attributes.sal_year#";
		if (isdefined("attributes.is_submit") and len(attributes.is_submit))
			url_str = "#url_str#&is_submit=#attributes.is_submit#";
		if (isdefined("attributes.status") and len(attributes.status))
			url_str = "#url_str#&status=#attributes.status#";
	}
	else if(attributes.event is 'add' or attributes.event is 'upd')
	{
		include "../hr/ehesap/query/get_moneys.cfm";
		if (attributes.event is 'upd')
		{
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd'] = structNew();
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons'] = structNew();
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#lang_array_main.item[170]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=ehesap.list_kesinti&event=add";
			tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
		}
	}
	
	WOStruct['#attributes.fuseaction#']['extendedForm'] = structNew();
	WOStruct['#attributes.fuseaction#']['extendedForm']['controllerFileName'] = 'ehesapListKesinti.cfm';
	WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'SETUP_PAYMENT_INTERRUPTION';
	WOStruct['#attributes.fuseaction#']['extendedForm']['dataSourceName'] = 'main';
</cfscript>
