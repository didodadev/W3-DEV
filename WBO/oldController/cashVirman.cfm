<cf_get_lang_set module_name="cash">
<cfif not isdefined("attributes.event")>
	<cfset attributes.event = "add">
</cfif>
<cf_xml_page_edit fuseact="cash.add_cash_to_cash">
<cf_papers paper_type="cash_to_cash">
<cfset process_cat = "">
<cfinclude template="../cash/query/get_cashes.cfm">
<cfset processCat = "">
<cfset fromCashId = "">
<cfset toCashId = "">
<cfset projectId = "">
<cfset projectName = "">
<cfset actionDate = dateformat(now(),'dd/mm/yyyy')>
<cfset actionValue = "">
<cfset otherValue = "">
<cfset actionDetail = "">
<cfif attributes.event is "add" and not isdefined("attributes.id")>
	<cfset cash_status = 1>
    <cfset is_virman_act = 1>
    <cfset paperNo = paper_code & '-' & paper_number>
<cfelseif attributes.event is "upd" or (attributes.event is "add" and isdefined("attributes.id"))>
	<cfset refmodule="#listgetat(attributes.fuseaction,1,'.')#">
    <cfset attributes.TABLE_NAME = "CASH_ACTIONS">
    <cfset is_virman_act = 1>
    <cfif attributes.event is "add">
    	<cfset cash_status = 1>
    </cfif>
    <cfquery name="GET_ACTION_DETAIL" datasource="#dsn2#">
        SELECT
            CASH_ACTIONS.*,
            PP.PROJECT_HEAD        
        FROM
            CASH_ACTIONS
            LEFT JOIN #dsn_alias#.PRO_PROJECTS PP ON PP.PROJECT_ID = CASH_ACTIONS.PROJECT_ID        
        WHERE
            (ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ATTRIBUTES.ID#"> OR ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ATTRIBUTES.ID+1#">) AND
            ACTION_TYPE_ID = 33
             <cfif session.ep.isBranchAuthorization>
                AND
                (
                        (CASH_ACTION_FROM_CASH_ID IN (SELECT CASH_ID FROM CASH WHERE BRANCH_ID = #ListGetAt(session.ep.user_location,2,"-")# OR IS_ALL_BRANCH = 1) OR
                        CASH_ACTION_TO_CASH_ID IN (SELECT CASH_ID FROM CASH WHERE BRANCH_ID = #ListGetAt(session.ep.user_location,2,"-")# OR IS_ALL_BRANCH = 1))
                )
            </cfif>
        ORDER BY
            ACTION_ID ASC
    </cfquery>
	<cfif get_action_detail.recordcount neq 2>
        <br/><font class="txtbold"><cf_get_lang_main no='1531.Böyle Bir Kayıt Bulunmamaktadır'> !</font>
        <cfexit method="exittemplate">
    <cfelse>
    	<cfset processCat = get_action_detail.process_cat>
        <cfset fromCashId = get_action_detail.CASH_ACTION_FROM_CASH_ID>
        <cfset toCashId = get_action_detail.CASH_ACTION_TO_CASH_ID[2]>
        <cfset projectId = get_action_detail.project_id>
		<cfset projectName = get_action_detail.project_head>
        <cfset paperNo = get_action_detail.paper_no>
        <cfset actionDate = dateformat(get_action_detail.ACTION_DATE,'dd/mm/yyyy')>
        <cfif attributes.event is "add">
			<cfset actionDate = dateformat(now(),'dd/mm/yyyy')>
            <cfset paperNo = paper_code & '-' & paper_number>
        </cfif>
        <cfset actionValue = TLFormat(get_action_detail.CASH_ACTION_VALUE)>
		<cfset otherValue = TLFormat(get_action_detail.OTHER_CASH_ACT_VALUE)>
        <cfset actionDetail = get_action_detail.ACTION_DETAIL>
    </cfif>
</cfif>

<script type="text/javascript">
	$(document).ready(function(){
		kur_ekle_f_hesapla('FROM_CASH_ID');
		<cfif attributes.event is "add">
			change_currency_info();
		</cfif>
	});
	function change_currency_info()
	{
		new_kur_say = document.all.kur_say.value;
		var currency_type_2 = list_getat(cash_to_cash.TO_CASH_ID.options[cash_to_cash.TO_CASH_ID.options.selectedIndex].value,2,';');
		for(var i=1;i<=new_kur_say;i++)
		{
			if(eval('document.all.hidden_rd_money_'+i) != undefined && eval('document.all.hidden_rd_money_'+i).value == currency_type_2)
				eval('document.all.rd_money['+(i-1)+']').checked = true;
		}
		kur_ekle_f_hesapla('FROM_CASH_ID');
	}
	function unformat_fields()
	{
		cash_to_cash.CASH_ACTION_VALUE.value = filterNum(cash_to_cash.CASH_ACTION_VALUE.value);
		cash_to_cash.OTHER_CASH_ACT_VALUE.value = filterNum(cash_to_cash.OTHER_CASH_ACT_VALUE.value);
		cash_to_cash.system_amount.value = filterNum(cash_to_cash.system_amount.value);
		for(var i=1;i<=cash_to_cash.kur_say.value;i++)
		{
			eval('cash_to_cash.txt_rate1_' + i).value = filterNum(eval('cash_to_cash.txt_rate1_' + i).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
			eval('cash_to_cash.txt_rate2_' + i).value = filterNum(eval('cash_to_cash.txt_rate2_' + i).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
		}
	}
	function kontrol()
	{
		if(!chk_process_cat('cash_to_cash')) return false;
		if(!check_display_files('cash_to_cash')) return false;
		if(!chk_period(cash_to_cash.ACTION_DATE,'İşlem')) return false;
		<cfif attributes.event is "upd">
			control_account_process(<cfoutput>'#attributes.id#','#get_action_detail.action_type_id#'</cfoutput>);
		</cfif>
		if ((document.cash_to_cash.ACTION_DETAIL.value.length) > 250) 
		{ 
			alert("<cf_get_lang no ='201.Açıklama bilgisi 250 karakterden fazla girilemez'>");
			return false;
		}
		if(document.cash_to_cash.TO_CASH_ID.value == document.cash_to_cash.FROM_CASH_ID.value)				
		{
			alert("<cf_get_lang no='47.Seçtiğiniz Kasalar Aynı!'>");		
			return false; 
		}
		kur_ekle_f_hesapla('FROM_CASH_ID');
		unformat_fields();
		return true;
	}
	<cfif attributes.event is "upd">
		function del_kontrol()
		{
			return control_account_process(<cfoutput>'#attributes.id#','#get_action_detail.action_type_id#'</cfoutput>);
			if(!chk_period(cash_to_cash.ACTION_DATE, 'İşlem')) return false;
			else return true;
		}
	</cfif>
</script>

<cfscript>
	// Switch //
	WOStruct = StructNew();
	
	WOStruct['#attributes.fuseaction#'] = structNew();
	
	WOStruct['#attributes.fuseaction#']['default'] = 'add';
	
	if(not isdefined('attributes.event'))
		attributes.event = WOStruct['#attributes.fuseaction#']['default'];
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'cash.form_add_cash_to_cash';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'cash/form/form_cash_to_cash.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'cash/query/add_cash_to_cash.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'cash.form_add_cash_to_cash&event=upd';
	WOStruct['#attributes.fuseaction#']['add']['formName'] = 'cash_to_cash';
	
	WOStruct['#attributes.fuseaction#']['add']['buttons'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['buttons']['save'] = 1;
	WOStruct['#attributes.fuseaction#']['add']['buttons']['saveFunction'] = 'kontrol()';
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'cash.form_add_cash_to_cash';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'cash/form/form_cash_to_cash.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'cash/query/upd_cash_to_cash.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'cash.form_add_cash_to_cash&event=upd&id=';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'id=##attributes.id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.id##';
	WOStruct['#attributes.fuseaction#']['upd']['recordQuery'] = 'get_action_detail';
	WOStruct['#attributes.fuseaction#']['upd']['formName'] = 'cash_to_cash';
	
	WOStruct['#attributes.fuseaction#']['upd']['buttons'] = structNew();

	WOStruct['#attributes.fuseaction#']['upd']['buttons']['update'] = 1;
	WOStruct['#attributes.fuseaction#']['upd']['buttons']['updateFunction'] = 'kontrol()';
	WOStruct['#attributes.fuseaction#']['upd']['buttons']['delete'] = 1;
	WOStruct['#attributes.fuseaction#']['upd']['buttons']['deleteFunction'] = 'del_kontrol()';
	
	if(not attributes.event is 'add')
	{
		WOStruct['#attributes.fuseaction#']['del'] = structNew();
		WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
		WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#listgetat(attributes.fuseaction,1,'.')#.emptypopup_del_cash_to_cash&ids=#attributes.id#,#attributes.id+1#&old_process_type=#get_action_detail.action_type_id#';
		WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'cash/query/del_cash_to_cash.cfm';
		WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'cash/query/del_cash_to_cash.cfm';
		WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'cash.list_cash_actions';
	}

	if(attributes.event is 'upd')
	{
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['text'] = '#lang_array_main.item[1040]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['onClick'] = "windowopen('#request.self#?fuseaction=account.popup_list_card_rows&action_id=#attributes.id#&process_cat=#get_action_detail.action_type_id#','page','upd_cash_to_cash');";
		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#lang_array_main.item[170]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=cash.form_add_cash_to_cash";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['copy']['text'] = '#lang_array_main.item[64]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['copy']['href'] = '#request.self#?fuseaction=cash.form_add_cash_to_cash&ID=#get_action_detail.action_id#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['copy']['target'] = "_blank";
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	WOStruct['#attributes.fuseaction#']['extendedForm'] = structNew();
	WOStruct['#attributes.fuseaction#']['extendedForm']['controllerFileName'] = 'cashVirman';
	WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'CASH_ACTIONS';
	WOStruct['#attributes.fuseaction#']['extendedForm']['dataSourceName'] = 'period';
	WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "['item-processCat','item-FROM_CASH_ID','item-TO_CASH_ID','item-ACTION_DATE','item-CASH_ACTION_VALUE']";
</cfscript>
