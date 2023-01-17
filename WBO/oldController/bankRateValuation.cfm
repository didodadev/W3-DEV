<cf_get_lang_set module_name="bank">
<cfif IsDefined("attributes.event") and attributes.event eq 'upd'>
    <cfquery name="get_bank_actions" datasource="#dsn2#">
        SELECT
            BA.ACTION_DATE,
            BA.ACTION_VALUE,
            BA.ACTION_CURRENCY_ID,
            BA.RECORD_EMP,
            BA.RECORD_DATE,
            A.ACCOUNT_NAME,
            BAM.UPD_STATUS,
            BAM.ACTION_TYPE_ID PROCESS_TYPE
        FROM 
            BANK_ACTIONS BA,
            BANK_ACTIONS_MULTI BAM,
            #dsn3_alias#.ACCOUNTS A
        WHERE
            ISNULL(ACTION_TO_ACCOUNT_ID,ACTION_FROM_ACCOUNT_ID) = A.ACCOUNT_ID	
            AND BA.MULTI_ACTION_ID = BAM.MULTI_ACTION_ID
            AND BA.MULTI_ACTION_ID = #attributes.multi_action_id#
    </cfquery>
    <cfquery name="get_bank_action_money" datasource="#dsn2#">
        SELECT
            RATE1,
            RATE2,
            MONEY_TYPE
        FROM 
            BANK_ACTION_MULTI_MONEY
        WHERE
            ACTION_ID = #attributes.multi_action_id#
    </cfquery>
</cfif>
<cfif not IsDefined("attributes.event") or attributes.event eq 'add'>
<cf_xml_page_edit fuseact="bank.form_add_bank_rate_valuation">

	<cfquery name="get_money_rate" datasource="#dsn2#">
		SELECT MONEY,RATE1,RATE2,RATE3,EFFECTIVE_SALE,EFFECTIVE_PUR FROM SETUP_MONEY WHERE MONEY_STATUS = 1 AND MONEY <> '#session.ep.money#' ORDER BY MONEY_ID
	</cfquery>
    <cfquery name="GET_BRANCHES" datasource="#DSN3#" cachedwithin="#fusebox.general_cached_time#">
            SELECT DISTINCT
                BANK_BRANCH.*,
                SETUP_BANK_TYPES.BANK_CODE
            FROM
                BANK_BRANCH,
                #dsn_alias#.SETUP_BANK_TYPES SETUP_BANK_TYPES
            WHERE
                BANK_BRANCH.BANK_ID = SETUP_BANK_TYPES.BANK_ID AND
                BANK_BRANCH.BANK_BRANCH_ID IS NOT NULL
            <cfif isDefined("attributes.bank") and len(attributes.bank)>
                AND BANK_BRANCH.BANK_NAME = '#attributes.bank#'
            </cfif>
            <cfif not isdefined("attributes.is_bank_account")>
                <cfif isDefined("attributes.keyword") and len(attributes.keyword)>
                AND
                    (
                        BANK_BRANCH.BANK_BRANCH_NAME LIKE '%#attributes.keyword#%' OR
                        BANK_BRANCH.BRANCH_CODE LIKE '%#attributes.keyword#%' OR
                        BANK_BRANCH.BANK_BRANCH_CITY LIKE '%#attributes.keyword#%' OR
                        BANK_BRANCH.BANK_BRANCH_ADDRESS LIKE '%#attributes.keyword#%' OR
                        BANK_BRANCH.CONTACT_PERSON LIKE '%#attributes.keyword#%'
                    )
                </cfif>
            </cfif>
            ORDER BY
                BANK_BRANCH.BANK_BRANCH_NAME
        </cfquery>
        <cfquery name="GET_BANKS" datasource="#DSN3#">
            SELECT
                DISTINCT(BANK_NAME)
            FROM
                BANK_BRANCH
            ORDER BY
                BANK_NAME
        </cfquery>
	<cfif isdefined("attributes.form_submitted")>
		
        
        <cfquery name="get_bank" datasource="#dsn2#">
            SELECT
                ACCOUNT_ID,
                ACCOUNT_NAME,
                ACCOUNT_ACC_CODE,
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
                    ACCOUNTS.ACCOUNT_ID,
                    ACCOUNTS.ACCOUNT_NAME,
                    ACCOUNTS.ACCOUNT_ACC_CODE,
                    0 BORC,
                    0 BORC3,
                    ISNULL(SUM(SYSTEM_ACTION_VALUE),0) ALACAK,
                    ISNULL(SUM(ACTION_VALUE),0) ALACAK3,
                    BANK_ACTIONS.ACTION_CURRENCY_ID OTHER_MONEY
                FROM
                    #dsn3_alias#.ACCOUNTS ACCOUNTS,
                    BANK_ACTIONS
                WHERE
                    ACCOUNTS.ACCOUNT_ID=BANK_ACTIONS.ACTION_FROM_ACCOUNT_ID
                    AND ACCOUNTS.ACCOUNT_CURRENCY_ID <> '#session.ep.money#'
                    AND BANK_ACTIONS.ACTION_CURRENCY_ID <> '#session.ep.money#'
                    <cfif isDefined("attributes.bank_name") and len(attributes.bank_name)>
                        AND ACCOUNTS.ACCOUNT_BRANCH_ID IN(SELECT BB.BANK_BRANCH_ID FROM #dsn3_alias#.BANK_BRANCH BB WHERE BB.BANK_NAME='#attributes.bank_name#')
                    </cfif>
                    <cfif isDefined("attributes.branch_id") and len(attributes.branch_id)>
                        AND ACCOUNTS.ACCOUNT_BRANCH_ID=#attributes.branch_id#
                    </cfif>
                    <cfif (isDefined("attributes.acc_status") and len(attributes.acc_status))>
                        AND ACCOUNTS.ACCOUNT_STATUS = #attributes.acc_status# 
                    </cfif>
                    <cfif isDefined("attributes.acc_currency_id") and len(attributes.acc_currency_id)>
                        AND ACCOUNTS.ACCOUNT_CURRENCY_ID='#attributes.acc_currency_id#'
                    </cfif>
                    <cfif isdefined('attributes.finishdate') and len(attributes.finishdate)>
                        AND BANK_ACTIONS.ACTION_DATE <= #attributes.finishdate#
                    </cfif>	
                    <cfif isdefined('attributes.startdate') and len(attributes.startdate)>
                        AND BANK_ACTIONS.ACTION_DATE >= #attributes.startdate#
                    </cfif>
                GROUP BY
                    ACCOUNTS.ACCOUNT_ID,
                    ACCOUNTS.ACCOUNT_NAME,
                    ACCOUNTS.ACCOUNT_ACC_CODE,
                    BANK_ACTIONS.ACTION_CURRENCY_ID
            UNION ALL
                SELECT 
                    ACCOUNTS.ACCOUNT_ID,
                    ACCOUNTS.ACCOUNT_NAME,
                    ACCOUNTS.ACCOUNT_ACC_CODE,
                    ISNULL(SUM(SYSTEM_ACTION_VALUE),0) BORC,
                    ISNULL(SUM(ACTION_VALUE),0) BORC3,
                    0 ALACAK,
                    0 ALACAK3,
                    BANK_ACTIONS.ACTION_CURRENCY_ID OTHER_MONEY
                FROM
                    #dsn3_alias#.ACCOUNTS ACCOUNTS,
                    BANK_ACTIONS
                WHERE
                    ACCOUNTS.ACCOUNT_ID=BANK_ACTIONS.ACTION_TO_ACCOUNT_ID
                    AND ACCOUNTS.ACCOUNT_CURRENCY_ID <> '#session.ep.money#'
                    AND BANK_ACTIONS.ACTION_CURRENCY_ID <> '#session.ep.money#'
                    <cfif isDefined("attributes.bank_name") and len(attributes.bank_name)>
                        AND ACCOUNTS.ACCOUNT_BRANCH_ID IN(SELECT BB.BANK_BRANCH_ID FROM #dsn3_alias#.BANK_BRANCH BB WHERE BB.BANK_NAME='#attributes.bank_name#')
                    </cfif>
                    <cfif isDefined("attributes.branch_id") and len(attributes.branch_id)>
                        AND ACCOUNTS.ACCOUNT_BRANCH_ID=#attributes.branch_id#
                    </cfif>
                    <cfif (isDefined("attributes.acc_status") and len(attributes.acc_status))>
                        AND ACCOUNTS.ACCOUNT_STATUS = #attributes.acc_status# 
                    </cfif>
                    <cfif isDefined("attributes.acc_currency_id") and len(attributes.acc_currency_id)>
                        AND ACCOUNTS.ACCOUNT_CURRENCY_ID='#attributes.acc_currency_id#'
                    </cfif>
                    <cfif isdefined('attributes.finishdate') and len(attributes.finishdate)>
                        AND BANK_ACTIONS.ACTION_DATE <= #attributes.finishdate#
                    </cfif>	
                    <cfif isdefined('attributes.startdate') and len(attributes.startdate)>
                        AND BANK_ACTIONS.ACTION_DATE >= #attributes.startdate#
                    </cfif>
                GROUP BY
                    ACCOUNTS.ACCOUNT_ID,
                    ACCOUNTS.ACCOUNT_NAME,
                    ACCOUNTS.ACCOUNT_ACC_CODE,
                    BANK_ACTIONS.ACTION_CURRENCY_ID
            )T1
            GROUP BY
                ACCOUNT_ID,
                ACCOUNT_NAME,
                ACCOUNT_ACC_CODE,
                OTHER_MONEY
        </cfquery>
	<cfelse>
    	<cfset get_bank.recordcount = 0>
    </cfif>
    <script type="text/javascript">
	var control_checked = 0;
	function kontrol()
	{
		if(document.add_rate_valuation.is_excel.checked==false)
		{
			document.add_rate_valuation.action="<cfoutput>#request.self#?fuseaction=bank.form_add_bank_rate_valuation</cfoutput>";
			return true;
		}
		else
			document.add_rate_valuation.action="<cfoutput>#request.self#?fuseaction=bank.emptypopup_form_add_bank_rate_valuation</cfoutput>";
		return true;
	}
	function kontrol_form_2()
	{ 
		if(!chk_process_cat('add_rate_valuation_1')) return false;
		if(!check_display_files('add_rate_valuation_1')) return false;
		if(!chk_period(add_rate_valuation_1.action_date,'İşlem')) return false;
		bank_id_list_1='';
		bank_id_list_2='';
		for(j=1;j<=<cfoutput>#get_bank.recordcount#</cfoutput>;j++)
		{
			if(document.getElementById("other_money_"+j) != undefined && document.getElementById("is_pay_"+j).checked == true)
			{
				if(filterNum(eval('document.add_rate_valuation_1.control_amount_2_'+j).value) > 0)
					bank_id_list_1+=eval('document.add_rate_valuation_1.control_amount_2_'+j).value;
				else if(filterNum(eval('document.add_rate_valuation_1.control_amount_2_'+j).value) < 0)
					bank_id_list_2+=eval('document.add_rate_valuation_1.control_amount_2_'+j).value;
			}
		}
		if(bank_id_list_1 != '' && bank_id_list_2 != '')
		{
			alert("<cf_get_lang dictionary_id='49990.Borç ve Alacak Karakterli İşlemleri Bir arada Seçemezsiniz!'>");
			return false;
		}
		if(bank_id_list_1 == '' && bank_id_list_2 == '')
		{
			alert("<cf_get_lang dictionary_id='49087.En Az Bir İşlem Seçmelisiniz'>!");
			return false;
		}
		process=document.add_rate_valuation_1.process_cat.value;
		var get_process_cat = wrk_safe_query('bnk_get_process_cat','dsn3',0,process);
		if(get_process_cat.IS_ACCOUNT == 1)
		{
			if(document.add_rate_valuation_1.action_account_code.value == "")
			{ 
				alert("<cf_get_lang dictionary_id='54918.Muhasebe Kodu Seçmelisiniz'>!");
				return false;
			}
		}
		<cfif isdefined('xml_acc_department_info') and xml_acc_department_info eq 2> //xmlde muhasebe icin departman secimi zorunlu ise
			if( document.add_rate_valuation_1.acc_department_id.options[document.add_rate_valuation_1.acc_department_id.selectedIndex].value=='')
			{
				alert("<cf_get_lang dictionary_id='53200.Departman Seçiniz'>!");
				return false;
			} 
		</cfif>
		return true;
	}
	function hepsi_view()
	{
		for(j=1;j<=<cfoutput>#get_bank.recordcount#</cfoutput>;j++)
		{
			if(document.getElementById("other_money_"+j) != undefined)
			{
				document.getElementById('is_pay_'+j).checked = false;
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
		for(s=1; s<=document.getElementById("kur_say").value; s++)
		{
			money_deger = document.getElementById("hidden_rd_money_"+s).value;
			document.getElementById("txt_rate2_1_"+money_deger).value = document.getElementById("txt_rate2_"+s).value;
			/*excel icin kur farki atanir */
			document.getElementById("excel_rate2_"+money_deger).value = document.getElementById("txt_rate2_"+s).value;
		}
		total_amount = 0;
		for(j=1;j<=<cfoutput>#get_bank.recordcount#</cfoutput>;j++)
		{
			if(document.getElementById("other_money_"+j) != undefined)
			{
				row_money = document.getElementById("other_money_"+j).value;
				document.getElementById("control_amount_"+j).value = commaSplit(document.getElementById("bakiye3_"+j).value*filterNum(document.getElementById("txt_rate2_1_"+row_money).value,4),2);
				total_amount = parseFloat(total_amount + parseFloat(document.getElementById("bakiye3_"+j).value*filterNum(document.getElementById("txt_rate2_1_"+row_money).value)));
				document.getElementById("control_amount_2_"+j).value =  commaSplit((document.getElementById("bakiye3_1_"+j).value*filterNum(document.getElementById("txt_rate2_1_"+row_money).value,4))-document.getElementById("bakiye_"+j).value)
				if(filterNum(document.getElementById("control_amount_2_"+j).value) == 0)
				{
					document.getElementById("is_pay_"+j).disabled = true;
				}
				else
				{
					document.getElementById("is_pay_"+j).disabled = false;
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
			for(j=1;j<=<cfoutput>#get_bank.recordcount#</cfoutput>;j++)
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
			for(j=1;j<=<cfoutput>#get_bank.recordcount#</cfoutput>;j++)
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
	function change_money_info_set()
		{
			change_money_info('add_rate_valuation_1','action_date','<cfoutput>#xml_money_type#</cfoutput>');
		}
	
</script>
</script>
</cfif>
<cfscript>
	// Switch //
	WOStruct = StructNew();
	WOStruct['#attributes.fuseaction#'] = structNew();
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['default'] = 'add';
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'bank.form_add_bank_rate_valuation';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'bank/form/add_bank_rate_valuation.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'bank/query/add_bank_rate_valuation.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'bank.form_add_bank_rate_valuation';
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'bank.form_add_bank_rate_valuation';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'bank/display/dsp_bank_rate_valuation.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'bank/display/dsp_bank_rate_valuation.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'bank.form_add_bank_rate_valuation';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'multi_action_id=##attributes.multi_action_id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.multi_action_id##';
	
	
	
	if(IsDefined("attributes.event") and attributes.event is 'upd')
	{
		WOStruct['#attributes.fuseaction#']['del'] = structNew();
		WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
		WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=bank.emptypopup_del_bank_rate_valuation&multi_action_id=#attributes.multi_action_id#&old_process_type=#get_bank_actions.process_type#';
		WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'bank/query/del_bank_rate_valuation.cfm';
		WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'bank/query/del_bank_rate_valuation.cfm';
		WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'bank.form_add_bank_rate_valuation';
		
		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['text'] = '#lang_array_main.item[1040]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['onClick'] = "windowopen('#request.self#?fuseaction=account.popup_list_card_rows&action_id=25&process_cat=254','page','upd_gidenh');";
		
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
</cfscript>

