<cfif not isdefined("attributes.event")>
	<cfset attributes.event = "add">
</cfif>
<cfinclude template="../cash/query/get_cashes.cfm">
<cfset fromCashId = "">
<cfset processCat = "">
<cfset date_info = now()>
<cfif not isdefined("attributes.multi_id")>
	<cfset attributes.multi_id = "">
</cfif>
<cfif attributes.event is "add">
    <cfset cash_status = 1>
    <cfif isdefined("attributes.multi_id") and len(attributes.multi_id)><!--- MA20081113 kopyalama --->
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
                CA.CASH_ACTION_TO_COMPANY_ID AS ACTION_COMPANY_ID,
                CA.CASH_ACTION_TO_CONSUMER_ID AS ACTION_CONSUMER_ID,
                CA.CASH_ACTION_TO_EMPLOYEE_ID AS ACTION_EMPLOYEE_ID,
                CA.OTHER_CASH_ACT_VALUE AS ACTION_VALUE_OTHER,
                CA.PROJECT_ID,
                CA.PAPER_NO,
                CA.CASH_ACTION_VALUE AS ACTION_VALUE,
                CA.ACTION_DETAIL,
                CA.ACTION_ID,
                CA.OTHER_MONEY AS ACTION_CURRENCY,
                CA.PAYER_ID AS EMPLOYEE_ID,
                CM.UPD_STATUS,
                CA.ASSETP_ID,
                CA.SPECIAL_DEFINITION_ID,
                CA.ACC_TYPE_ID
            FROM
                CASH_ACTIONS_MULTI CM,
                CASH_ACTIONS CA
            WHERE
                CM.MULTI_ACTION_ID = CA.MULTI_ACTION_ID 
                AND CM.MULTI_ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.multi_id#"> 
        </cfquery>
    <cfelseif isdefined("attributes.puantaj_id") and len(attributes.puantaj_id)>
        <cfquery name="get_money" datasource="#dsn#">
            SELECT MONEY_TYPE AS MONEY,* FROM EMPLOYEES_PUANTAJ_CARI_ACTIONS_MONEY WHERE ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.puantaj_id#">
        </cfquery>
        <cfif not get_money.recordcount>
            <cfquery name="get_money" datasource="#dsn2#">
                SELECT MONEY,0 AS IS_SELECTED,* FROM SETUP_MONEY WHERE MONEY_STATUS=1 ORDER BY MONEY_ID
            </cfquery>
        </cfif>
        <cfquery name="get_action_detail" datasource="#dsn#">
            SELECT
                '' PROCESS_CAT,
                EP.ACTION_DATE,
                '' AS ACTION_COMPANY_ID,
                '' AS ACTION_CONSUMER_ID,
                EPCR.EMPLOYEE_ID AS ACTION_EMPLOYEE_ID,
                ((EPCR.ACTION_VALUE
                -
                ISNULL(
                (
                    SELECT 
                        SUM(AMOUNT)
                    FROM
                        EMPLOYEES_PUANTAJ_ROWS_EXT EXT,
                        EMPLOYEES_PUANTAJ_ROWS EPR
                    WHERE
                        EPR.EMPLOYEE_PUANTAJ_ID = EXT.EMPLOYEE_PUANTAJ_ID
                        AND (EPR.IN_OUT_ID = EPCR.IN_OUT_ID OR EPCR.IN_OUT_ID IS NULL)
                        AND EPR.PUANTAJ_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.puantaj_id#">
                        AND EPR.EMPLOYEE_ID = EPCR.EMPLOYEE_ID
                        AND EXT.EXT_TYPE = 1
                )
                ,0))/(EPCR.ACTION_VALUE/EPCR.OTHER_ACTION_VALUE)) ACTION_VALUE_OTHER,
                '' PAPER_NO,
                '' PROJECT_ID,
                '' ACTION_ID,
                (EPCR.ACTION_VALUE
                -
                ISNULL(
                (
                    SELECT 
                        SUM(AMOUNT)
                    FROM
                        EMPLOYEES_PUANTAJ_ROWS_EXT EXT,
                        EMPLOYEES_PUANTAJ_ROWS EPR
                    WHERE
                        EPR.EMPLOYEE_PUANTAJ_ID = EXT.EMPLOYEE_PUANTAJ_ID
                        AND EPR.PUANTAJ_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.puantaj_id#">
                        AND EPR.EMPLOYEE_ID = EPCR.EMPLOYEE_ID
                        AND EXT.EXT_TYPE = 1
                )
                ,0)
                ) ACTION_VALUE,
                EP.ACTION_DETAIL,
                EP.OTHER_MONEY AS ACTION_CURRENCY,
                0 UPD_STATUS,
                0 MASRAF,
                EPCR.EXPENSE_CENTER_ID,
                EPCR.EXPENSE_ITEM_ID,
                '' ASSETP_ID,
                '' FROM_CASH_ID,
                '' SPECIAL_DEFINITION_ID,
                EP.EMPLOYEE_ID,
                EPCR.ACC_TYPE_ID
            FROM
                EMPLOYEES_PUANTAJ_CARI_ACTIONS EP,
                EMPLOYEES_PUANTAJ_CARI_ACTIONS_ROW EPCR
            WHERE
                EP.DEKONT_ID = EPCR.DEKONT_ID 
                AND EP.PUANTAJ_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.puantaj_id#">
                AND (EPCR.ACTION_VALUE
                -
                ISNULL(
                (
                    SELECT 
                        SUM(AMOUNT)
                    FROM
                        EMPLOYEES_PUANTAJ_ROWS_EXT EXT,
                        EMPLOYEES_PUANTAJ_ROWS EPR
                    WHERE
                        EPR.EMPLOYEE_PUANTAJ_ID = EXT.EMPLOYEE_PUANTAJ_ID
                        AND (EPR.IN_OUT_ID = EPCR.IN_OUT_ID OR EPCR.IN_OUT_ID IS NULL)
                        AND EPR.PUANTAJ_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.puantaj_id#">
                        AND EPR.EMPLOYEE_ID = EPCR.EMPLOYEE_ID
                        AND EXT.EXT_TYPE = 1
                )
                ,0)
                ) > 0
        </cfquery>
    <cfelseif isdefined('attributes.payment_ids') and len(attributes.payment_ids)>
        <cfquery name="get_action_detail" datasource="#dsn#">
            SELECT	
                '' PROCESS_CAT,
                CP.RECORD_DATE AS ACTION_DATE,
                '' AS ACTION_COMPANY_ID,
                '' AS ACTION_CONSUMER_ID,
                CP.TO_EMPLOYEE_ID AS ACTION_EMPLOYEE_ID,
                '' AS FROM_CASH_ID,
                #session.ep.userid# AS EMPLOYEE_ID,
                '' AS PROJECT_ID,
                '' AS ACTION_ID,
                CP.ID AS AVANS_ID,
                CP.AMOUNT AS ACTION_VALUE,
                '' AS ACTION_VALUE_OTHER,
                '' AS ACTION_CURRENCY,
                '' AS ACTION_DETAIL,
                '' AS SPECIAL_DEFINITION_ID,
                ISNULL((SELECT ACC_TYPE_ID FROM SETUP_PAYMENT_INTERRUPTION WHERE ODKES_ID = CP.DEMAND_TYPE),-2) AS ACC_TYPE_ID
            FROM
                CORRESPONDENCE_PAYMENT CP,
                EMPLOYEES E,
                EMPLOYEES_IN_OUT EI
            WHERE 
                CP.ID IN(<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.payment_ids#" list="yes">) AND
                CP.IN_OUT_ID = EI.IN_OUT_ID AND 
                EI.EMPLOYEE_ID = E.EMPLOYEE_ID 
        </cfquery>
        <cfquery name="get_money" datasource="#dsn2#">
            SELECT MONEY,0 AS IS_SELECTED,* FROM SETUP_MONEY WHERE MONEY_STATUS=1 ORDER BY MONEY_ID
        </cfquery>
    <cfelse>
        <cfinclude template="../cash/query/get_money.cfm">
    </cfif>
<cfelseif attributes.event is "upd">
    <cfif not isdefined("attributes.new_dsn3")><cfset new_dsn3 = dsn3><cfelse><cfset new_dsn3 = attributes.new_dsn3></cfif>
    <cfif not isdefined("attributes.new_dsn2")><cfset new_dsn2 = dsn2><cfelse><cfset new_dsn2 = attributes.new_dsn2></cfif>
    <cfquery name="get_money" datasource="#new_dsn2#">
        SELECT MONEY_TYPE AS MONEY,* FROM CASH_ACTION_MULTI_MONEY WHERE ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.multi_id#"> ORDER BY ACTION_MONEY_ID
    </cfquery>
    <cfif not get_money.recordcount>
        <cfquery name="get_money" datasource="#new_dsn2#">
            SELECT MONEY,0 AS IS_SELECTED,* FROM SETUP_MONEY WHERE MONEY_STATUS=1 ORDER BY MONEY_ID
        </cfquery>
    </cfif>
    <cfquery name="get_action_detail" datasource="#new_dsn2#">
        SELECT
            CM.*,
            CA.CASH_ACTION_TO_COMPANY_ID AS ACTION_COMPANY_ID,
            CA.CASH_ACTION_TO_CONSUMER_ID AS ACTION_CONSUMER_ID,
            CA.CASH_ACTION_TO_EMPLOYEE_ID AS ACTION_EMPLOYEE_ID,
            CA.OTHER_CASH_ACT_VALUE AS ACTION_VALUE_OTHER,
            CA.PROJECT_ID,
            CA.PAPER_NO,
            CA.CASH_ACTION_VALUE AS ACTION_VALUE,
            CA.ACTION_DETAIL,
            CA.ACTION_ID,
            CA.OTHER_MONEY AS ACTION_CURRENCY,
            CA.PAYER_ID AS EMPLOYEE_ID,
            CM.UPD_STATUS,
            CA.ASSETP_ID,
            CA.SPECIAL_DEFINITION_ID,
            CA.ACC_TYPE_ID,
            CA.AVANS_ID
        FROM
            CASH_ACTIONS_MULTI CM,
            CASH_ACTIONS CA
        WHERE
            CM.MULTI_ACTION_ID = CA.MULTI_ACTION_ID 
            AND CM.MULTI_ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.multi_id#">
    </cfquery>
    <cfset fromCashId = get_action_detail.from_cash_id>
	<cfset processCat = get_action_detail.process_cat>
    <cfset date_info = get_action_detail.action_date>
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
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'cash.add_collacted_payment';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'cash/form/form_collacted_payment.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'cash/query/add_collacted_payment.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'cash.add_collacted_payment&event=upd';
	WOStruct['#attributes.fuseaction#']['add']['js'] = "javascript:gizle_goster_ikili('collacted_revenue','collacted_revenue_bask')";
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'cash.add_collacted_payment';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'cash/form/form_collacted_payment.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'cash/query/upd_collacted_payment.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'cash.add_collacted_payment&event=upd';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'multi_id=##attributes.multi_id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.multi_id##';
	WOStruct['#attributes.fuseaction#']['upd']['js'] = "javascript:gizle_goster_ikili('collacted_payment','collacted_payment_bask')";
	
	if(not attributes.event is 'add')
	{
		WOStruct['#attributes.fuseaction#']['del'] = structNew();
		WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
		if(isdefined("attributes.puantaj_id") and len(attributes.puantaj_id) and dsn2 eq new_dsn2)
			WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'cash.del_collacted_action&is_virtual=#attributes.is_virtual_puantaj#&puantaj_id=#attributes.puantaj_id#&multi_id=#attributes.multi_id#&old_process_type=#get_action_detail.action_type_id#';
		else
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
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['menus'][0]['onClick'] = "openBox('#request.self#?fuseaction=objects.popup_add_collacted_from_file&type=5',this)";
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	else if(attributes.event is 'upd')
	{	
		if(not (isdefined("attributes.puantaj_id") and len(attributes.puantaj_id)))
		{
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd'] = structNew();
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'] = structNew();
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['text'] = '#lang_array_main.item[1966]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['customTag'] = '<cf_get_workcube_related_acts period_id="#session.ep.period_id#" company_id="#session.ep.company_id#" asset_cat_id="-17" module_id="18" action_section="ACTION_ID" action_id="#attributes.multi_id#">';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][1]['text'] = '#lang_array_main.item[1542]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][1]['onClick'] = "windowopen('#request.self#?fuseaction=account.popup_list_card_rows&action_id=#attributes.multi_id#&process_cat=#get_action_detail.action_type_id#','page','add_process')";
			
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons'] = structNew();
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#lang_array_main.item[170]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=cash.add_collacted_payment";
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['copy']['text'] = '#lang_array_main.item[64]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['copy']['href'] = '#request.self#?fuseaction=cash.add_collacted_payment&multi_id=#attributes.multi_id#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['copy']['target'] = "_blank";
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['text'] = '#lang_array_main.item[62]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_print_files&action_id=#attributes.multi_id#&keyword=multi_payment&print_type=132','page')";
			tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
		}
	}
	WOStruct['#attributes.fuseaction#']['extendedForm'] = structNew();
	WOStruct['#attributes.fuseaction#']['extendedForm']['controllerFileName'] = 'collactedCashPayment';
	WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'CASH_ACTIONS_MULTI';
	WOStruct['#attributes.fuseaction#']['extendedForm']['dataSourceName'] = 'period';
	WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "['item-processCat','item-cash_action_from_cash_id','item-action_date']";

</cfscript>
