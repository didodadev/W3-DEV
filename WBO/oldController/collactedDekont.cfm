<cfquery name="GET_MONEY" datasource="#DSN#">
    SELECT
        MONEY,
        RATE2,
        RATE1,
        0 AS IS_SELECTED
    FROM
        SETUP_MONEY
    WHERE
        PERIOD_ID = #SESSION.EP.PERIOD_ID# AND
        MONEY_STATUS = 1
        <cfif isDefined('attributes.money') and len(attributes.money)>
            AND MONEY_ID = #attributes.money#
        </cfif>
    ORDER BY 
        MONEY_ID
</cfquery>
<cfif isdefined("attributes.multi_id") and len(attributes.multi_id)>
	<cfquery name="get_money" datasource="#dsn2#">
		SELECT MONEY_TYPE AS MONEY,* FROM CARI_ACTION_MULTI_MONEY WHERE ACTION_ID = #attributes.multi_id# ORDER BY ACTION_MONEY_ID
	</cfquery>
    
	<cfif not get_money.recordcount>
		<cfquery name="get_money" datasource="#dsn2#">
			SELECT MONEY,0 AS IS_SELECTED,* FROM SETUP_MONEY WHERE MONEY_STATUS=1 ORDER BY MONEY_ID
		</cfquery>
	</cfif>
	<cfquery name="get_action_detail" datasource="#dsn2#">
		SELECT
			CAM.*,
			ISNULL(CA.FROM_CMP_ID,CA.TO_CMP_ID) AS ACTION_COMPANY_ID,
			ISNULL(CA.FROM_CONSUMER_ID,CA.TO_CONSUMER_ID) AS ACTION_CONSUMER_ID,
			ISNULL(CA.FROM_EMPLOYEE_ID,CA.TO_EMPLOYEE_ID) AS ACTION_EMPLOYEE_ID,
			CA.OTHER_CASH_ACT_VALUE AS ACTION_VALUE_OTHER,
			CA.PROJECT_ID,
			CA.PAPER_NO,
			CA.ACTION_ID,
			CA.ACTION_VALUE,
			CA.ACTION_DETAIL,
			CA.OTHER_MONEY AS ACTION_CURRENCY,
			CAM.UPD_STATUS,
			CA.EXPENSE_CENTER_ID,
			CA.EXPENSE_ITEM_ID,
			CA.INCOME_CENTER_ID,
			CA.INCOME_ITEM_ID,
			CA.ACTION_ACCOUNT_CODE,
			CA.ASSETP_ID,
			CA.ACC_DEPARTMENT_ID,
            CA.ACC_BRANCH_ID,
			CA.CONTRACT_ID,
            CA.ACC_TYPE_ID
		FROM
			CARI_ACTIONS_MULTI CAM,
			CARI_ACTIONS CA
		WHERE
			CAM.MULTI_ACTION_ID = CA.MULTI_ACTION_ID 
			AND CAM.MULTI_ACTION_ID = #attributes.multi_id#
	</cfquery>
</cfif>
<cfif  IsDefined("attributes.event") and attributes.event eq 'upd'>
	<script type="text/javascript">
	function ayarla_gizle_goster()
	{
		var selected_ptype = document.add_process.process_cat.options[document.add_process.process_cat.selectedIndex].value;
		if (selected_ptype != '')
			eval('var proc_control = document.add_process.ct_process_type_'+selected_ptype+'.value');
		else
			var proc_control = '';
		if(proc_control != '')
		{
			if(proc_control == 420 || proc_control == 46)
			{
				<cfif not isdefined("x_project_expence_center") or x_project_expence_center eq 0>
					document.getElementById("exp_center_1").style.display='';
				<cfelseif isdefined("x_project_expence_center") or x_project_expence_center eq 1>
					document.getElementById("exp_center_1").style.display='none';
				</cfif>
				document.getElementById("exp_item_1").style.display='';
				document.getElementById("exp_center_2").style.display='none';
				document.getElementById("exp_item_2").style.display='none';
				
				for(j=1;j<=add_process.record_num.value;j++)
				{		
					if(eval("document.add_process.row_kontrol"+j).value==1)
					{
						<cfif not isdefined("x_project_expence_center") or x_project_expence_center eq 0>
							document.getElementById('expense_center_id_1'+j).style.display='';
						<cfelseif isdefined("x_project_expence_center") or x_project_expence_center eq 1>
							document.getElementById('expense_center_id_1'+j).style.display='none';
						</cfif>						
						document.getElementById('expense_item_id_1'+j).style.display='';
						document.getElementById('income_center_id_1'+j).style.display='none';
						document.getElementById('income_item_id_1'+j).style.display='none';
					}
				}
			}
			else if(proc_control == 410 || proc_control == 45)
			{
				<cfif not isdefined("x_project_expence_center") or x_project_expence_center eq 0>
					document.getElementById("exp_center_2").style.display='';
				<cfelseif isdefined("x_project_expence_center") or x_project_expence_center eq 1>
					document.getElementById("exp_center_2").style.display='none';
				</cfif>
				document.getElementById("exp_item_2").style.display='';
				document.getElementById("exp_center_1").style.display='none';
				document.getElementById("exp_item_1").style.display='none';
				for(j=1;j<=add_process.record_num.value;j++)
				{		
					if(eval("document.add_process.row_kontrol"+j).value==1)
					{
						if(document.getElementById('income_center_id_1'+j) != undefined)
						{
							<cfif not isdefined("x_project_expence_center") or x_project_expence_center eq 0>
								document.getElementById('income_center_id_1'+j).style.display='';
							<cfelseif isdefined("x_project_expence_center") or x_project_expence_center eq 1>
								document.getElementById('income_center_id_1'+j).style.display='none';
							</cfif>
						}
						document.getElementById('income_item_id_1'+j).style.display='';
						document.getElementById('expense_center_id_1'+j).style.display='none';
						document.getElementById('expense_item_id_1'+j).style.display='none';
					}
				}
			}
		}
		else
		{
			document.getElementById("exp_center_1").style.display='';
			document.getElementById("exp_item_1").style.display='';
			document.getElementById("exp_center_2").style.display='';
			document.getElementById("exp_item_2").style.display='';
			for(j=1;j<=add_process.record_num.value;j++)
			{		
				if(eval("document.add_process.row_kontrol"+j).value==1)
				{
					document.getElementById('expense_center_id_1'+j).style.display='';
					document.getElementById('expense_item_id_1'+j).style.display='';
					document.getElementById('income_center_id_1'+j).style.display='';
					document.getElementById('income_item_id_1'+j).style.display='';
				}
			}
		}
	}
</script>
</cfif>

<cfif not IsDefined("attributes.event") or (IsDefined("attributes.event") and attributes.event eq 'add')>
<cfset paper_type = 5>
<cfif paper_type eq 1>
	<cfset select_input = 'account_id'>
	<cfset auto_paper_type = "incoming_transfer">
<cfelseif paper_type eq 2>
	<cfset select_input = 'account_id'>
	<cfset auto_paper_type = "outgoing_transfer">
<cfelseif paper_type eq 3>
	<cfset select_input = 'cash_action_to_cash_id'>
	<cfset auto_paper_type = "revenue_receipt">
<cfelseif paper_type eq 4>
	<cfset select_input = 'cash_action_from_cash_id'>
	<cfset auto_paper_type = "cash_payment">
<cfelseif paper_type eq 5>
	<cfset select_input = 'action_currency_id'>
	<cfset auto_paper_type = "debit_claim">
</cfif>
	<script type="text/javascript">
		$( document ).ready(function() {
			ayarla_gizle_goster();
			
			<cfif isdefined("attributes.from_rate_valuation")>
				exp_center_1.style.display='none';
				exp_item_1.style.display='none';
				exp_center_2.style.display='none';
				exp_item_2.style.display='none';
				start_row = window.opener.document.getElementById("startrow").value;
				max_row = <cfoutput>#attributes.maxrows#</cfoutput>;
				all_records = parseFloat(start_row)+parseFloat(max_row);
				count_=0;
				acc_code = window.opener.document.getElementById("action_account_code").value;
				exp_center_id = window.opener.document.getElementById("expense_center_id").value;
				exp_item_id = window.opener.document.getElementById("expense_item_id").value;
				exp_center_name = window.opener.document.getElementById("expense_center").value;
				exp_item_name = window.opener.document.getElementById("expense_item_name").value;
				project_id = window.opener.document.getElementById("pro_id").value;
				project_name = window.opener.document.getElementById("project_name").value;
				
				for(i=start_row;i<=all_records;i++)
				{
					if(window.opener.document.getElementById("is_pay_"+i) != undefined && window.opener.document.getElementById("is_pay_"+i).disabled != true && window.opener.document.getElementById("is_pay_"+i).checked == true)
					{
						count_++;
						amount_ = Math.abs(filterNum(window.opener.document.getElementById("control_amount_2_"+i).value));
						if(amount_ > 0)
						{
							other_money = window.opener.document.getElementById("other_money_"+i).value;
							member_code = window.opener.document.getElementById("member_code_"+i).value;
							member_type = window.opener.document.getElementById("member_type_"+i).value;
							action_company_id = window.opener.document.getElementById("company_id_"+i).value;
							action_consumer_id = window.opener.document.getElementById("consumer_id_"+i).value;
							if (window.opener.document.getElementById("acc_type_id_"+i) != undefined && window.opener.document.getElementById("acc_type_id_"+i).value != "")
								action_employee_id	=  window.opener.document.getElementById("employee_id_"+i).value+'_'+window.opener.document.getElementById("acc_type_id_"+i).value;
							else
								action_employee_id = window.opener.document.getElementById("employee_id_"+i).value;
							comp_name = window.opener.document.getElementById("comp_name_"+i).value;
							if(window.opener.document.getElementById("related_action_id"+i) != undefined)
							{
								related_action_id = window.opener.document.getElementById("related_action_id"+i).value;
								related_action_type = window.opener.document.getElementById("related_action_type"+i).value;
							}
							else
							{
								related_action_id = '';
								related_action_type = '';
							}
							<cfif isdefined("attributes.is_other_act")>
								if(filterNum(window.opener.document.getElementById("control_amount_2_"+i).value) < 0)
									add_row(0,other_money,member_code,member_type,action_company_id,action_consumer_id,action_employee_id,comp_name,acc_code,"",exp_center_id,exp_item_id,exp_center_name,exp_item_name,"","","","",project_id,project_name,'','','','','','','','','','',amount_,'',related_action_id,related_action_type);
								else
									add_row(0,other_money,member_code,member_type,action_company_id,action_consumer_id,action_employee_id,comp_name,acc_code,"","","","","",exp_center_id,exp_item_id,exp_center_name,exp_item_name,project_id,project_name,'','','','','','','','','','',amount_,'',related_action_id,related_action_type);
							<cfelse>
								if(filterNum(window.opener.document.getElementById("control_amount_2_"+i).value) < 0)
									add_row(amount_,other_money,member_code,member_type,action_company_id,action_consumer_id,action_employee_id,comp_name,acc_code,"",exp_center_id,exp_item_id,exp_center_name,exp_item_name,"","","","",project_id,project_name,'','','','','','','','','','','','',related_action_id,related_action_type);
								else
									add_row(amount_,other_money,member_code,member_type,action_company_id,action_consumer_id,action_employee_id,comp_name,acc_code,"","","","","",exp_center_id,exp_item_id,exp_center_name,exp_item_name,project_id,project_name,'','','','','','','','','','','','',related_action_id,related_action_type);
								kur_ekle_f_hesapla('<cfoutput>#select_input#</cfoutput>',true,count_);
								
							</cfif>
							document.getElementById('expense_center_id_1'+count_).style.display='none';
							document.getElementById('expense_item_id_1'+count_).style.display='none';
							document.getElementById('income_center_id_1'+count_).style.display='none';
							document.getElementById('income_item_id_1'+count_).style.display='none';
						}
					}
				}
				<cfif not isdefined("attributes.is_other_act")>
					toplam_hesapla();
				</cfif>
			</cfif>	
		});
		function ayarla_gizle_goster()
		{
			var selected_ptype = document.add_process.process_cat.options[document.add_process.process_cat.selectedIndex].value;
			if (selected_ptype != '')
				eval('var proc_control = document.add_process.ct_process_type_'+selected_ptype+'.value');
			else
				var proc_control = '';
			
			if(proc_control != '')
			{
				if(proc_control == 420 || proc_control == 46)
				{
					<cfif not isdefined("x_project_expence_center") or x_project_expence_center eq 0>
						exp_center_1.style.display='';
					<cfelseif isdefined("x_project_expence_center") and x_project_expence_center eq 1>
						exp_center_1.style.display='none';
					</cfif>
					exp_item_1.style.display='';
					exp_center_2.style.display='none';
					exp_item_2.style.display='none';
					for(j=1;j<=add_process.record_num.value;j++)
					{		
						if(eval("document.add_process.row_kontrol"+j).value==1)
						{
							<cfif not isdefined("x_project_expence_center") or x_project_expence_center eq 0>
								document.getElementById('expense_center_id_1'+j).style.display='';
							<cfelseif isdefined("x_project_expence_center") and x_project_expence_center eq 1>
								document.getElementById('expense_center_id_1'+j).style.display='none';
							</cfif>
							document.getElementById('expense_item_id_1'+j).style.display='';
							document.getElementById('income_center_id_1'+j).style.display='none';
							document.getElementById('income_item_id_1'+j).style.display='none';
						}
					}
				}
				else if(proc_control == 410 || proc_control == 45)
				{
					<cfif not isdefined("x_project_expence_center") or x_project_expence_center eq 0>
						exp_center_2.style.display='';
					<cfelseif isdefined("x_project_expence_center") and x_project_expence_center eq 1>
						exp_center_2.style.display='none';
					</cfif>
					exp_item_2.style.display='';
					exp_center_1.style.display='none';
					exp_item_1.style.display='none';
					for(j=1;j<=add_process.record_num.value;j++)
					{		
						if(eval("document.add_process.row_kontrol"+j).value==1)
						{
							document.getElementById('expense_center_id_1'+j).style.display='none';
							document.getElementById('expense_item_id_1'+j).style.display='none';
							if(document.getElementById('income_center_id_1'+j) != undefined)
							{
								<cfif not isdefined("x_project_expence_center") or x_project_expence_center eq 0>
									document.getElementById('income_center_id_1'+j).style.display='';
								<cfelseif isdefined("x_project_expence_center") and x_project_expence_center eq 1>
									document.getElementById('income_center_id_1'+j).style.display='none';
								</cfif>
							}
							document.getElementById('income_item_id_1'+j).style.display='';
						}
					}
				}
			}
			else
			{
				<cfif not isdefined("attributes.from_rate_valuation")>
					exp_center_1.style.display='';
					exp_item_1.style.display='';
					exp_center_2.style.display='';
					exp_item_2.style.display='';
					for(j=1;j<=add_process.record_num.value;j++)
					{		
						if(eval("document.add_process.row_kontrol"+j).value==1)
						{
							document.getElementById('expense_center_id_1'+j).style.display='';
							document.getElementById('expense_item_id_1'+j).style.display='';
							document.getElementById('income_center_id_1'+j).style.display='';
	
							document.getElementById('income_item_id_1'+j).style.display='';
						}
					}
				<cfelse>
					<cfif isdefined("attributes.debt_claim") and attributes.debt_claim eq 1>
						exp_center_2.style.display='';
						exp_item_2.style.display='';
						exp_center_1.style.display='none';
						exp_item_1.style.display='none';
						for(j=1;j<=add_process.record_num.value;j++)
						{		
							if(eval("document.add_process.row_kontrol"+j).value==1)
							{
								document.getElementById('expense_center_id_1'+j).style.display='none';
								document.getElementById('expense_item_id_1'+j).style.display='none';
								document.getElementById('income_center_id_1'+j).style.display='';
								document.getElementById('income_item_id_1'+j).style.display='';
							}
						}
					<cfelseif isdefined("attributes.debt_claim") and attributes.debt_claim eq 0>
						exp_center_1.style.display='';
						exp_item_1.style.display='';
						exp_center_2.style.display='none';
						exp_item_2.style.display='none';
						for(kk=1;kk<=add_process.record_num.value;kk++)
						{
							if(eval("document.add_process.row_kontrol"+kk).value==1)
							{
								document.getElementById('expense_center_id_1'+kk).style.display='';
								document.getElementById('expense_item_id_1'+kk).style.display='';
								document.getElementById('income_center_id_1'+kk).style.display='none';
								document.getElementById('income_item_id_1'+kk).style.display='none';
							}
						}
					</cfif>
				</cfif>
			}
		}
		function open_file()
		{
			document.getElementById('dekont_file').style.display='';
			AjaxPageLoad('<cfoutput>#request.self#?fuseaction=objects.popup_add_collacted_from_file&type=1<cfif isdefined("attributes.multi_id")>&multi_id=#attributes.multi_id#</cfif></cfoutput>','dekont_file',1);
			return false;
		}
	</script>
</cfif>

<cfscript>
	// Switch //
	WOStruct = StructNew();
	WOStruct['#attributes.fuseaction#'] = structNew();
	
	WOStruct['#attributes.fuseaction#']['default'] = 'add';
	if(not isdefined('attributes.event'))
		attributes.event = WOStruct['#attributes.fuseaction#']['default'];
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	if(IsDefined("attributes.is_popup"))
	{
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'popup';
	}
	else
	{
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'window';
	}
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'ch.add_collacted_dekont';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'ch/form/add_collacted_dekont.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'ch/query/add_collacted_dekont.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'ch.add_collacted_dekont&event=upd';
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'ch.add_collacted_dekont';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'ch/form/add_collacted_dekont.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'ch/query/upd_collacted_dekont.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'ch.add_collacted_dekont&event=upd';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'multi_id=##attributes.multi_id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.multi_id##';
	
	if(IsDefined("attributes.event") && (attributes.event is 'upd' || attributes.event is 'del'))
	{
		WOStruct['#attributes.fuseaction#']['del'] = structNew();
		WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
		WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'ch.add_collacted_dekont';
		WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'ch/query/del_collacted_dekont_multi.cfm';
		WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'ch/query/del_collacted_dekont_multi.cfm';
		WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'ch.add_collacted_dekont';
		WOStruct['#attributes.fuseaction#']['del']['parameters'] = 'multi_id=##attributes.multi_id##';
		WOStruct['#attributes.fuseaction#']['del']['parameters'] = 'old_process_type=##get_action_detail.action_type_id##';
		WOStruct['#attributes.fuseaction#']['del']['Identity'] = '##attributes.multi_id##';
	}
	if(not IsDefined("attributes.event") || ( IsDefined("attributes.event") && attributes.event is 'add'))
	{
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['menus'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['menus'][0]['text'] = '#lang_array_main.item[1114]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['menus'][0]['onClick'] = "open_file()";
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	if(IsDefined("attributes.event") && attributes.event is 'upd')
	{
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['text'] = '#lang_array_main.item[1966]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['customTag'] = '<cf_get_workcube_related_acts period_id="#session.ep.period_id#" company_id="#session.ep.company_id#" asset_cat_id="-17" module_id="23" action_section="MULTI_ACTION_ID" action_id="#attributes.multi_id#">';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][1]['text'] = '#lang_array_main.item[1040]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][1]['onClick'] = "windowopen('#request.self#?fuseaction=account.popup_list_card_rows&action_id=#attributes.multi_id#&process_cat=#get_action_detail.action_type_id#','page_horizantal','add_process')";
		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#lang_array_main.item[170]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=ch.add_collacted_dekont";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['copy']['text'] = '#lang_array_main.item[64]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['copy']['href'] = '#request.self#?fuseaction=ch.add_collacted_dekont&event=add&multi_id=#attributes.multi_id#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['copy']['target'] = "_blank";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['text'] = '#lang_array_main.item[62]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_print_files&print_type=215&action_id=#URLEncodedFormat(page_code)#','page')";
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	WOStruct['#attributes.fuseaction#']['extendedForm'] = structNew();
	WOStruct['#attributes.fuseaction#']['extendedForm']['controllerFileName'] = 'collactedDekont';
	WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'CARI_ACTIONS';
	WOStruct['#attributes.fuseaction#']['extendedForm']['dataSourceName'] = 'period';
	WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "['item1','item4']"; 
</cfscript>


