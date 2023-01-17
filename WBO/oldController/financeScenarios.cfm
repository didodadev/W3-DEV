<cf_get_lang_set module_name="finance">
<cfparam name="attributes.scenario_id" default="" >
<cfparam name="attributes.scenario" default="" >
<cfparam name="attributes.scenario_detail" default="" >
<cfif not IsDefined("attributes.event") or (IsDefined("attributes.event") and attributes.event eq 'list')>
	<cfparam name="attributes.keyword" default="">
	<cfif isdefined("attributes.form_submitted")>
    <cfquery name="GET_SCENARIOS" datasource="#DSN#">
        SELECT 
            SCENARIO_ID, 
            SCENARIO 
        FROM 
            SETUP_SCENARIO <cfif len(attributes.keyword)>WHERE SCENARIO LIKE '%#attributes.keyword#%'</cfif>
    </cfquery>
    <cfelse>
        <cfset get_scenarios.recordcount=0>
    </cfif>
    <cfparam name="attributes.page" default=1>
    <cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
    <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
    <cfparam name="attributes.totalrecords" default=#get_scenarios.recordcount#>
    <script type="text/javascript">
		$( document ).ready(function() {
			document.getElementById('keyword').focus();
		});
	</script>
</cfif>
<cfif IsDefined("attributes.event") and (attributes.event eq 'upd')>
    <cfquery name="GET_SCENARIO" datasource="#dsn#">
        SELECT
            *,
            '' UPDATE_DATE,
            '' UPDATE_EMP
        FROM
            SETUP_SCENARIO
        WHERE
            SCENARIO_ID=#attributes.id#
    </cfquery>
    <cfquery name="GET_SCE_ID" datasource="#dsn3#">
        SELECT
            SCENARIO_TYPE_ID
        FROM
            SCEN_EXPENSE_PERIOD
        WHERE
            SCENARIO_TYPE_ID=#attributes.id#
    </cfquery>
   	<cfset attributes.scenario_id = get_scenario.scenario_id>
	<cfset attributes.scenario = get_scenario.scenario>
	<cfset attributes.scenario_detail = get_scenario.scenario_detail>
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
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'finance.list_scenarios';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'finance/display/list_scenarios.cfm';
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'finance.popup_form_add_scenarios';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'finance/form/add_scenarios.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'finance/query/add_scenario.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'finance.list_scenarios';
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'finance.popup_form_upd_scenarios';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'finance/form/add_scenarios.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'finance/query/upd_scenario.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'budget.list_scenarios';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'id=##attributes.id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.id##';
	
	if(IsDefined("attributes.event") && (attributes.event is 'upd' or attributes.event is 'del'))
	{ 
		WOStruct['#attributes.fuseaction#']['del'] = structNew();
		WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
		WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'finance.list_scenarios';
		WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'finance/query/del_scenarios.cfm';
		WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'finance/query/del_scenarios.cfm';
		WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'finance.list_scenarioss';
	}
	WOStruct['#attributes.fuseaction#']['extendedForm'] = structNew();
	WOStruct['#attributes.fuseaction#']['extendedForm']['controllerFileName'] = 'financeScenarios';
	WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'SETUP_SCENARIO';
	WOStruct['#attributes.fuseaction#']['extendedForm']['dataSourceName'] = '';
	WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "['item-1']"; 
	/*
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'finance.list_creditcard';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'finance/form/upd_creditcard.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'finance/query/upd_creditcard.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'finance.list_creditcard&event=upd';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'creditcard_id=##attributes.creditcard_id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.creditcard_id##';
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'finance.list_creditcard';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'finance/form/add_creditcard.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'finance/query/add_creditcard.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'finance.list_creditcard&event=upd';
	
	if(IsDefined("attributes.event") && attributes.event is 'upd')
	{
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#lang_array_main.item[170]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=finance.list_creditcard&event=add";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	*/
</cfscript>

