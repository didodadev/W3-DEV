<cf_get_lang_set module_name="cash">
<cfif (isdefined("attributes.event") and attributes.event is "add") or not isdefined("attributes.event")>
    <cfparam name="attributes.startdate" default="">
    <cfparam name="attributes.finishdate" default="">
    <cfparam name="attributes.cash_currency_id" default="">
    <cfparam name="attributes.cash_status" default="1">
    <cfparam name="attributes.branch_id" default="">
    <cfquery name="get_money_rate" datasource="#dsn2#">
        SELECT * FROM SETUP_MONEY WHERE MONEY_STATUS = 1 AND MONEY <> '#session.ep.money#' ORDER BY MONEY_ID
    </cfquery>
    <cfinclude template="../cash/query/get_com_branch.cfm">
    <cfif isdefined("attributes.form_submitted")>
        <cfif isDefined("attributes.startdate") and len(attributes.startdate)><cf_date tarih="attributes.startdate"></cfif>
        <cfif isDefined("attributes.finishdate") and len(attributes.finishdate)><cf_date tarih="attributes.finishdate"></cfif>
        <cfquery name="get_cash" datasource="#dsn2#">
            SELECT
                CASH_ID,
                CASH_NAME,
                BRANCH_ID,
                CASH_ACC_CODE,
                OTHER_MONEY,
                SUM(BORC) BORC,
                SUM(ALACAK) ALACAK,
                SUM(BORC-ALACAK) BAKIYE,
                SUM(BORC3) BORC3,
                SUM(ALACAK3) ALACAK3,
                SUM(BORC3-ALACAK3) BAKIYE3
            FROM
            (
                SELECT 
                    CASH.CASH_ID,
                    CASH.CASH_NAME,
                    CASH.BRANCH_ID,
                    CASH.CASH_ACC_CODE,
                    0 BORC,
                    0 BORC3,
                    SUM(ACTION_VALUE) ALACAK,
                    SUM(CASH_ACTION_VALUE) ALACAK3,
                    CASH_ACTIONS.CASH_ACTION_CURRENCY_ID OTHER_MONEY
                FROM
                    CASH,
                    CASH_ACTIONS
                WHERE
                    CASH.CASH_ID=CASH_ACTIONS.CASH_ACTION_FROM_CASH_ID
                    AND CASH.CASH_CURRENCY_ID <> '#session.ep.money#'
                    AND CASH_ACTIONS.CASH_ACTION_CURRENCY_ID <> '#session.ep.money#'
                    <cfif isDefined("attributes.branch_id") and len(attributes.branch_id)>
                        AND CASH.BRANCH_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#">
                    </cfif>
                    <cfif (isDefined("attributes.cash_status") and len(attributes.cash_status))>
                        AND CASH.CASH_STATUS = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cash_status#"> 
                    </cfif>
                    <cfif isDefined("attributes.cash_currency_id") and len(attributes.cash_currency_id)>
                        AND CASH.CASH_CURRENCY_ID= <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.cash_currency_id#">
                    </cfif>
                    <cfif isdefined('attributes.finishdate') and len(attributes.finishdate)>
                        AND CASH_ACTIONS.ACTION_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.finishdate#">
                    </cfif>	
                    <cfif isdefined('attributes.startdate') and len(attributes.startdate)>
                        AND CASH_ACTIONS.ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.startdate#">
                    </cfif>
                GROUP BY
                    CASH.CASH_ID,
                    CASH.CASH_NAME,
                    CASH.BRANCH_ID,
                    CASH.CASH_ACC_CODE,
                    CASH_ACTIONS.CASH_ACTION_CURRENCY_ID
            UNION ALL
                SELECT 
                    CASH.CASH_ID,
                    CASH.CASH_NAME,
                    CASH.BRANCH_ID,
                    CASH.CASH_ACC_CODE,
                    SUM(ACTION_VALUE) BORC,
                    SUM(CASH_ACTION_VALUE) BORC3,
                    0 ALACAK,
                    0 ALACAK3,
                    CASH_ACTIONS.CASH_ACTION_CURRENCY_ID OTHER_MONEY
                FROM
                    CASH,
                    CASH_ACTIONS
                WHERE
                    CASH.CASH_ID=CASH_ACTIONS.CASH_ACTION_TO_CASH_ID
                    AND CASH.CASH_CURRENCY_ID <> '#session.ep.money#'
                    AND CASH_ACTIONS.CASH_ACTION_CURRENCY_ID <> '#session.ep.money#'
                    <cfif isDefined("attributes.branch_id") and len(attributes.branch_id)>
                        AND CASH.BRANCH_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#">
                    </cfif>
                    <cfif (isDefined("attributes.cash_status") and len(attributes.cash_status))>
                        AND CASH.CASH_STATUS = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cash_status#"> 
                    </cfif>
                    <cfif isDefined("attributes.cash_currency_id") and len(attributes.cash_currency_id)>
                        AND CASH.CASH_CURRENCY_ID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.cash_currency_id#">
                    </cfif>
                    <cfif isdefined('attributes.finishdate') and len(attributes.finishdate)>
                        AND CASH_ACTIONS.ACTION_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.finishdate#">
                    </cfif>	
                    <cfif isdefined('attributes.startdate') and len(attributes.startdate)>
                        AND CASH_ACTIONS.ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.startdate#">
                    </cfif>
                GROUP BY
                    CASH.CASH_ID,
                    CASH.CASH_NAME,
                    CASH.BRANCH_ID,
                    CASH.CASH_ACC_CODE,
                    CASH_ACTIONS.CASH_ACTION_CURRENCY_ID
            )T1
            GROUP BY
                CASH_ID,
                CASH_NAME,
                BRANCH_ID,
                CASH_ACC_CODE,
                OTHER_MONEY
        </cfquery>
        <cfif session.ep.rate_valid eq 1>
            <cfset readonly_info = "yes">
        <cfelse>
            <cfset readonly_info = "no">
        </cfif>
    <cfelse>
        <cfset get_cash.recordcount = 0>
    </cfif>
<cfelseif isdefined("attributes.event") and attributes.event is "det">
    <cfquery name="get_cash_actions" datasource="#dsn2#">
        SELECT
            CA.ACTION_DATE,
            CA.ACTION_VALUE,
            CA.CASH_ACTION_CURRENCY_ID,
            CA.RECORD_EMP,
            CA.RECORD_DATE,
            CA.UPDATE_EMP,
            CA.UPDATE_DATE,
            C.CASH_NAME,
            CAM.UPD_STATUS,
            CAM.ACTION_TYPE_ID PROCESS_TYPE
        FROM 
            CASH_ACTIONS CA,
            CASH_ACTIONS_MULTI CAM,
            CASH C
        WHERE
            ISNULL(CASH_ACTION_FROM_CASH_ID,CASH_ACTION_TO_CASH_ID) = C.CASH_ID	
            AND CA.MULTI_ACTION_ID = CAM.MULTI_ACTION_ID
            AND CA.MULTI_ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.multi_action_id#">
    </cfquery>
    <cfquery name="get_cash_action_money" datasource="#dsn2#">
        SELECT
            RATE1,
            RATE2,
            MONEY_TYPE
        FROM 
            CASH_ACTION_MULTI_MONEY
        WHERE
            ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.multi_action_id#">
    </cfquery>
</cfif>
<script type="text/javascript">
	<cfif (isdefined("attributes.event") and attributes.event is "add") or not isdefined("attributes.event")>
		var control_checked = 0;
		function kontrol_form_2()
		{
			if(!chk_process_cat('add_rate_valuation_1')) return false;
			if(!check_display_files('add_rate_valuation_1')) return false;
			if(!chk_period(add_rate_valuation_1.action_date,'İşlem')) return false;
			cash_id_list_1='';
			cash_id_list_2='';
			for(j=1;j<=<cfoutput>#get_cash.recordcount#</cfoutput>;j++)
			{
				if(eval("document.add_rate_valuation_1.other_money_"+j) != undefined && eval("document.add_rate_valuation_1.is_pay_"+j).checked == true)
				{
					if(parseFloat(filterNum(eval('document.add_rate_valuation_1.control_amount_2_'+j).value)) > 0)
						cash_id_list_1+=eval('document.add_rate_valuation_1.control_amount_2_'+j).value;
					else if(parseFloat(filterNum(eval('document.add_rate_valuation_1.control_amount_2_'+j).value)) < 0)
						cash_id_list_2+=eval('document.add_rate_valuation_1.control_amount_2_'+j).value;
				}
			}
			if(cash_id_list_1 != '' && cash_id_list_2 != '')
			{
				alert("<cf_get_lang dictionary_id='49990.Borç ve Alacak Karakterli İşlemleri Bir arada Seçemezsiniz'>!");
				return false;
			}
			if(cash_id_list_1 == '' && cash_id_list_2 == '')
			{
				alert("<cf_get_lang dictionary_id='49087.En Az Bir İşlem Seçmelisiniz'>!");
				return false;
			}
			process=document.add_rate_valuation_1.process_cat.value;
			var get_process_cat = wrk_safe_query('csh_get_process_cat','dsn3',0,process);
			if(get_process_cat.IS_ACCOUNT == 1)
			{
				if(document.add_rate_valuation_1.action_account_code.value == "")
				{ 
					alert("<cf_get_lang dictionary_id='54918.Muhasebe Kodu Seçmelisiniz'>!");
					return false;
				}
			}
			return true;
		}
		function hepsi_view()
		{
			for(j=1;j<=<cfoutput>#get_cash.recordcount#</cfoutput>;j++)
			{
				if(eval("document.add_rate_valuation_1.other_money_"+j) != undefined)
				{
					eval('add_rate_valuation_1.is_pay_'+j).checked = false;
					control_checked--;
				}
			}
		}
		function check_kontrol(nesne)
		{
			if(nesne.checked)
				control_checked++;
			else
				control_checked--;
		}
		function toplam_hesapla()
		{
			total_amount = 0;
			for(s=1;s<=document.add_rate_valuation_1.kur_say.value;s++)
			{
				money_deger = eval("document.add_rate_valuation_1.hidden_rd_money_"+s).value;
				eval("document.add_rate_valuation_1.txt_rate2_1_"+money_deger).value = eval("document.add_rate_valuation_1.txt_rate2_"+s).value;
			}
			for(j=1;j<=<cfoutput>#get_cash.recordcount#</cfoutput>;j++)
			{
				if(eval("document.add_rate_valuation_1.other_money_"+j) != undefined)
				{
					row_money = eval("document.add_rate_valuation_1.other_money_"+j).value;
					eval('document.add_rate_valuation_1.control_amount_'+j).value = commaSplit(eval("document.add_rate_valuation_1.bakiye3_"+j).value*filterNum(eval("document.add_rate_valuation_1.txt_rate2_1_"+row_money).value,4),2);
					total_amount = parseFloat(total_amount + parseFloat(eval("document.add_rate_valuation_1.bakiye3_"+j).value*filterNum(eval("document.add_rate_valuation_1.txt_rate2_1_"+row_money).value)));
					eval('document.add_rate_valuation_1.control_amount_2_'+j).value =  commaSplit((eval("document.add_rate_valuation_1.bakiye3_1_"+j).value*filterNum(eval("document.add_rate_valuation_1.txt_rate2_1_"+row_money).value,4))-eval("document.add_rate_valuation_1.bakiye_"+j).value)
					if(filterNum(eval('document.add_rate_valuation_1.control_amount_2_'+j).value) == 0)
					{
						eval('document.add_rate_valuation_1.is_pay_'+j).disabled = true;
					}
					else
					{
						eval('document.add_rate_valuation_1.is_pay_'+j).disabled = false;
					}	
				}
			}
			document.add_rate_valuation_1.total_amount.value = commaSplit(total_amount);
		}
		function check_currency(type)
		{
			if(type == 1 && document.getElementById('is_minus_currency').checked == true)
			{
				document.getElementById('is_plus_currency').checked=false;
				for(j=1;j<=<cfoutput>#get_cash.recordcount#</cfoutput>;j++)
				{
					if(document.getElementById('other_money_'+j) != undefined)
					{
						if(parseFloat(filterNum(document.getElementById('control_amount_2_'+j).value)) <0)
							document.getElementById('is_pay_'+j).checked = true;
						else
							document.getElementById('is_pay_'+j).checked = false;
						
					}
				}
			}
			else if(type == 2 && document.getElementById('is_plus_currency').checked == true)
			{
				document.getElementById('is_minus_currency').checked=false;			
				for(j=1;j<=<cfoutput>#get_cash.recordcount#</cfoutput>;j++)
				{
					if(document.getElementById('other_money_'+j) != undefined)
					{
						if(parseFloat(filterNum(document.getElementById('control_amount_2_'+j).value)) >0)
							document.getElementById('is_pay_'+j).checked = true;
						else
							document.getElementById('is_pay_'+j).checked = false;
					}
				}
			}
			else
				hepsi_view();
		}
	</cfif>
</script>
<cfscript>
	// Switch //
	WOStruct = StructNew();
	
	WOStruct['#attributes.fuseaction#'] = structNew();
	
	WOStruct['#attributes.fuseaction#']['default'] = 'add';
	
	if(not isDefined("attributes.event"))
		attributes.event = WOStruct['#attributes.fuseaction#']['default'];
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'cash.form_add_cash_rate_valuation';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'cash/form/add_cash_rate_valuation.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'cash/form/add_cash_rate_valuation.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'cash.form_add_cash_rate_valuation';
	WOStruct['#attributes.fuseaction#']['add']['js'] = "javascript:gizle_goster_ikili('add_due','add_due_bask')";
	
	WOStruct['#attributes.fuseaction#']['add_row'] = structNew();
	WOStruct['#attributes.fuseaction#']['add_row']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['add_row']['fuseaction'] = 'cash.form_add_cash_rate_valuation';
	WOStruct['#attributes.fuseaction#']['add_row']['filePath'] = 'cash/form/add_cash_rate_valuation.cfm';
	WOStruct['#attributes.fuseaction#']['add_row']['queryPath'] = 'cash/query/add_cash_rate_valuation.cfm';
	WOStruct['#attributes.fuseaction#']['add_row']['nextEvent'] = 'cash.form_add_cash_rate_valuation';

	WOStruct['#attributes.fuseaction#']['det'] = structNew();
	WOStruct['#attributes.fuseaction#']['det']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['det']['fuseaction'] = 'cash.form_add_cash_rate_valuation';
	WOStruct['#attributes.fuseaction#']['det']['filePath'] = 'cash/display/dsp_cash_rate_valuation.cfm';
	WOStruct['#attributes.fuseaction#']['det']['queryPath'] = 'cash/display/dsp_cash_rate_valuation.cfm';
	WOStruct['#attributes.fuseaction#']['det']['nextEvent'] = 'cash.list_cash_actions';
	WOStruct['#attributes.fuseaction#']['det']['parameters'] = 'multi_action_id=##attributes.multi_action_id##';
	WOStruct['#attributes.fuseaction#']['det']['Identity'] = '##attributes.multi_action_id##';
	
	if(attributes.event is 'det' or attributes.event is 'del')
	{
		WOStruct['#attributes.fuseaction#']['del'] = structNew();
		WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
		WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'cash.emptypopup_del_cash_rate_valuation';
		WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'cash/query/del_cash_rate_valuation.cfm';
		WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'cash/query/del_cash_rate_valuation.cfm';
		WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'cash.list_cash_actions';
	}
	
	if(attributes.event is 'det')
	{
		if(get_module_user(22))
		{
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det'] = structNew();
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'] = structNew();
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][0]['text'] = '#lang_array_main.item[1040]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][0]['onClick'] = "windowopen('#request.self#?fuseaction=account.popup_list_card_rows&action_id=#attributes.multi_action_id#&process_cat=#get_cash_actions.process_type#','page');";
			tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
		}
	}
	WOStruct['#attributes.fuseaction#']['extendedForm'] = structNew();
	WOStruct['#attributes.fuseaction#']['extendedForm']['controllerFileName'] = 'cashRateValuation';
	WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'add';
	WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'CASH_ACTIONS_MULTI';
	WOStruct['#attributes.fuseaction#']['extendedForm']['dataSourceName'] = 'period';
	WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "['item-process_cat','item-action_date','item-action_account_code']";
</cfscript>
