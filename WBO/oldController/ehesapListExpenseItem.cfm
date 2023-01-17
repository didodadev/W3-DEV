<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
	<cfparam name="attributes.keyword" default="">
	<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
	<cfparam name="attributes.keyword" default="">
	<cfparam name="attributes.page" default=1>
	<cfscript>
		attributes.static_cat_id=-3;
		if (isdefined("attributes.form_submitted"))
			include "../hr/ehesap/query/get_expense_item_static_cat.cfm";
		else
			get_expense_item_sta.recordcount = 0;
		attributes.startrow = ((attributes.page-1)*attributes.maxrows)+1;
	</cfscript>
	<cfparam name="attributes.totalrecords" default="#get_expense_item_sta.recordcount#">
<cfelseif isdefined("attributes.event") and attributes.event is 'add'>
	<cfquery name="get_expense_cat" datasource="#dsn2#">
		SELECT 
	    	EXPENSE_CAT_ID,
	        EXPENSE_CAT_NAME,
	        EXPENCE_IS_HR,
	        RECORD_EMP,
	        RECORD_IP,
	        RECORD_DATE,
	        UPDATE_EMP,
	        UPDATE_IP,
	        UPDATE_DATE
	    FROM
		    EXPENSE_CATEGORY
	    WHERE
	    	EXPENCE_IS_HR = 1
	</cfquery>
<cfelseif isdefined("attributes.event") and attributes.event is 'upd'>
	<cfinclude template="../hr/ehesap/query/get_expense_item_static_cat.cfm">
</cfif>

<script type="text/javascript">
	<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
		$(document).ready(function() {
			$('#keyword').focus();
		});
	<cfelseif isdefined("attributes.event") and (attributes.event is 'add' or attributes.event is 'upd')>
		function kontrol()
		{
			if($('#expense_cat').val() == '')
			{
				alert("<cf_get_lang_main no='782.Zorunlu Alan'> : <cf_get_lang_main no='74.Kategori'>");
				return false;
			}
			if($('#expense_item_name').val() == '')
			{
				alert("<cf_get_lang_main no='782.Zorunlu Alan'> : <cf_get_lang_main no='1139.Gider Kalemi'>");
				return false;
			}
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
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'ehesap.list_expense_item';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'hr/ehesap/display/list_budget_expense_item.cfm';
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'ehesap.popup_form_add_expense_item';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'hr/ehesap/form/form_add_budget_expense_item.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'hr/ehesap/query/add_budget_expense_item.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'ehesap.list_expense_item&event=upd';
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'ehesap.popup_form_upd_expense_item';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'hr/ehesap/form/form_upd_budget_expense_item.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'hr/ehesap/query/upd_budget_expense_item.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'ehesap.list_expense_item&event=upd';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'item_id=##attributes.item_id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##get_expense_item_sta.expense_item_name##';
	
	if(not attributes.event is 'add')
	{
		WOStruct['#attributes.fuseaction#']['del'] = structNew();
		WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
		WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'ehesap.list_expense_item';
		WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'hr/ehesap/query/del_budget_expense_item.cfm';
		WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'hr/ehesap/query/del_budget_expense_item.cfm';
		WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'ehesap.list_expense_item';
	}
	
	WOStruct['#attributes.fuseaction#']['extendedForm'] = structNew();
	WOStruct['#attributes.fuseaction#']['extendedForm']['controllerFileName'] = 'ehesapListExpenseItem.cfm';
	WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'EXPENSE_ITEMS';
	WOStruct['#attributes.fuseaction#']['extendedForm']['dataSourceName'] = 'period';
	WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "['item-expense_cat','item-expense_item_name']";
</cfscript>
