<cfif not isdefined("attributes.event")>
	<cfset attributes.event = "add">
</cfif>
<cfinclude template="../cash/query/get_cashes.cfm">
<cfset toCashId = "">
<cfset processCat = "">
<cfset date_info = now()>
<cfif not isdefined("attributes.multi_id")>
	<cfset attributes.multi_id = "">
</cfif>
<cfif (attributes.event is "add" and isdefined("attributes.multi_id") and len(attributes.multi_id)) or (attributes.event is "upd")>
    <cfquery name="get_money" datasource="#dsn2#">
        SELECT MONEY_TYPE AS MONEY,* FROM CASH_ACTION_MULTI_MONEY WHERE ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.multi_id#"> ORDER BY ACTION_MONEY_ID
    </cfquery>
	<cfif not get_money.recordcount>
        <cfquery name="get_money" datasource="#dsn2#">
            SELECT MONEY,0 AS IS_SELECTED,* FROM SETUP_MONEY WHERE MONEY_STATUS=1 ORDER BY MONEY_ID
        </cfquery>
    </cfif>
	<cfquery name="get_action_detail" datasource="#dsn2#">
		SELECT
			CM.*,
			CA.CASH_ACTION_FROM_COMPANY_ID AS ACTION_COMPANY_ID,
			CA.CASH_ACTION_FROM_CONSUMER_ID AS ACTION_CONSUMER_ID,
			CA.CASH_ACTION_FROM_EMPLOYEE_ID AS ACTION_EMPLOYEE_ID,
			CA.OTHER_CASH_ACT_VALUE AS ACTION_VALUE_OTHER,
			CA.PROJECT_ID,
			CA.PAPER_NO,
			CA.CASH_ACTION_VALUE AS ACTION_VALUE,
			CA.ACTION_DETAIL,
			CA.ACTION_ID,
			CA.OTHER_MONEY AS ACTION_CURRENCY,
			CA.REVENUE_COLLECTOR_ID AS EMPLOYEE_ID,
			CM.UPD_STATUS,
			CA.ASSETP_ID,
			CA.SPECIAL_DEFINITION_ID,
            CA.ACC_TYPE_ID
		FROM
			CASH_ACTIONS_MULTI CM,
			CASH_ACTIONS CA
		WHERE
			CM.MULTI_ACTION_ID = CA.MULTI_ACTION_ID AND
			CM.MULTI_ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.multi_id#">
	</cfquery>
    <cfset toCashId = get_action_detail.to_cash_id>
	<cfset processCat = get_action_detail.process_cat>
    <cfset date_info = get_action_detail.action_date>
<cfelse>
	<cfif (isdefined("attributes.event") and attributes.event is "add") or not isdefined("attributes.event")>
    	<cfinclude template="../cash/query/get_money.cfm">
    </cfif>
</cfif>
<cfscript>
	// Switch //
	WOStruct = StructNew();
	
	WOStruct['#attributes.fuseaction#'] = structNew();
	
	WOStruct['#attributes.fuseaction#']['default'] = 'add';
	
	if(not isdefined('attributes.event'))
		attributes.event = WOStruct['#attributes.fuseaction#']['default'];
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'cash.add_collacted_revenue';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'cash/form/form_collacted_revenue.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'cash/query/add_collacted_revenue.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'cash.add_collacted_revenue&event=upd';
	WOStruct['#attributes.fuseaction#']['add']['js'] = "javascript:gizle_goster_ikili('collacted_revenue','collacted_revenue_bask')";
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'cash.add_collacted_revenue';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'cash/form/form_collacted_revenue.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'cash/query/upd_collacted_revenue.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'cash.add_collacted_revenue&event=upd';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'multi_id=##attributes.multi_id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.multi_id##';
	WOStruct['#attributes.fuseaction#']['upd']['js'] = "javascript:gizle_goster_ikili('collacted_revenue','collacted_revenue_bask')";
	
	if(not (attributes.event is 'add'))
	{
		WOStruct['#attributes.fuseaction#']['del'] = structNew();
		WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
		WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'cash.del_collacted_action&multi_id=#attributes.multi_id#&old_process_type=#get_action_detail.action_type_id#';
		WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'cash/query/del_collacted_action.cfm';
		WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'cash/query/del_collacted_action.cfm';
		WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'cash.list_cash_actions';
	}

	if(attributes.event is 'add')
	{
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['menus'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['menus'][0]['text'] = '#lang_array_main.item[2576]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['menus'][0]['onClick'] = "openBox('#request.self#?fuseaction=objects.popup_add_collacted_from_file&type=4',this)";
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	else if(attributes.event is 'upd')
	{	
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['text'] = '#lang_array_main.item[1966]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['customTag'] = '<cf_get_workcube_related_acts period_id="#session.ep.period_id#" company_id="#session.ep.company_id#" asset_cat_id="-17" module_id="18" action_section="ACTION_ID" action_id="#attributes.multi_id#">';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][1]['text'] = '#lang_array_main.item[35]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][1]['onClick'] = "windowopen('#request.self#?fuseaction=account.popup_list_card_rows&action_id=#attributes.multi_id#&process_cat=#get_action_detail.action_type_id#','page','add_process')";
		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#lang_array_main.item[170]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=cash.add_collacted_revenue";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['copy']['text'] = '#lang_array_main.item[64]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['copy']['href'] = '#request.self#?fuseaction=cash.add_collacted_revenue&multi_id=#attributes.multi_id#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['copy']['target'] = "_blank";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['text'] = '#lang_array_main.item[62]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_print_files&action_id=#attributes.multi_id#&keyword=is_multi&print_type=133','list')";
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	WOStruct['#attributes.fuseaction#']['extendedForm'] = structNew();
	WOStruct['#attributes.fuseaction#']['extendedForm']['controllerFileName'] = 'collactedCashRevenue';
	WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'CASH_ACTIONS_MULTI';
	WOStruct['#attributes.fuseaction#']['extendedForm']['dataSourceName'] = 'period';
	WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "['item-processCat','item-cash_action_to_cash_id','item-action_date']";
</cfscript>
