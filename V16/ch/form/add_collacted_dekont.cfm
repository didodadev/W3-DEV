<cf_get_lang_set module_name="ch">
<cf_xml_page_edit fuseact="ch.add_collacted_dekont">
<cfinclude template="../../cash/query/get_money.cfm">
<cfset date_info = now()>
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
			CA.SUBSCRIPTION_ID,
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
    <cfset date_info = get_action_detail.action_date>
</cfif>
<cfset processTypeInfo = "">
<cfif isdefined("attributes.debt_claim")>
	<cfif attributes.debt_claim eq 1>
        <cfset processTypeInfo = 45>
    <cfelseif attributes.debt_claim eq 0>
        <cfset processTypeInfo = 46>
    <cfelseif attributes.debt_claim eq 2>
        <cfset processTypeInfo = 410>
    <cfelseif attributes.debt_claim eq 3>
        <cfset processTypeInfo = 420>
    </cfif>
</cfif>
<div id="dekont_file" style="margin-left:1000px; margin-top:15px; position:absolute;display:none;z-index:9999;"></div>
<cfset pageHead = getLang('ch',4) & ' : ' & getLang('main',2352)><!--- Toplu Dekont : Yeni Kayıt--->
<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box>
		<cfform name="add_process">
			<cf_box_elements id="collacted_dekont">
				<input type="hidden" name="active_period" id="active_period" value="<cfoutput>#session.ep.period_id#</cfoutput>">
				<!--- tezcan ozel rapor icin eklenmistir silmeyiniz. 20130320 --->
				<input type="hidden" name="cheque_id_list" id="cheque_id_list" value="<cfif isdefined("cheque_id_list")><cfoutput>#attributes.cheque_id_list#</cfoutput></cfif>">
				<select name="action_currency_id" id="action_currency_id" style="display:none">
					<option value="1;<cfoutput>#session.ep.money#</cfoutput>" selected></option>
				</select>
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
					<div class="form-group" id="item-process_cat">
						<label class="col col-4 col-xs-12"><cf_get_lang_main no='388.işlem tipi'> *</label>
						<div class="col col-8 col-xs-12">
							<cfif isdefined('get_action_detail')>
								<cf_workcube_process_cat process_cat="#get_action_detail.process_cat#" process_type_info="410,420,45,46" onclick_function="ayarla_gizle_goster();">
							<cfelse>
								<cfif isdefined("attributes.debt_claim") and (attributes.debt_claim eq 1 or attributes.debt_claim eq 0 or attributes.debt_claim eq 2 or attributes.debt_claim eq 3)>
									<cf_workcube_process_cat process_type_info="#processTypeInfo#" onclick_function="ayarla_gizle_goster();">
								<cfelse>
									<cf_workcube_process_cat process_type_info="410,420,45,46" onclick_function="ayarla_gizle_goster();">
								</cfif>
							</cfif>
						</div>
					</div>
					<cfif session.ep.isBranchAuthorization eq 0>
						<div class="form-group" id="item-acc_branch_id">
							<label class="col col-4 col-xs-12"><cf_get_lang_main no='41.Şube'></label>
							<div class="col col-8 col-xs-12">
								<cfif isdefined("attributes.multi_id") and len(attributes.multi_id)>
									<cf_wrkDepartmentBranch fieldId='acc_branch_id' is_branch='1' is_deny_control='0' selected_value='#get_action_detail.ACC_BRANCH_ID#'>
								<cfelse>
									<cf_wrkDepartmentBranch fieldId='acc_branch_id' is_branch='1' is_deny_control='0'>
								</cfif>
							</div>
						</div>
					</cfif>
				</div>
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
					<div class="form-group" id="item-acc_department_id">
						<label class="col col-4 col-xs-12"><cf_get_lang_main no='160.Departman'></label>
						<div class="col col-8 col-xs-12">
							<cfif isdefined("attributes.multi_id") and len(attributes.multi_id)>
								<cf_wrkDepartmentBranch fieldId='acc_department_id' is_department='1' is_deny_control='0' selected_value='#get_action_detail.ACC_DEPARTMENT_ID#'>
							<cfelse>
								<cf_wrkDepartmentBranch fieldId='acc_department_id' is_department='1' is_deny_control='0'>
							</cfif>
						</div>
					</div>
					<div class="form-group" id="item-action_date">
						<label class="col col-4 col-xs-12"><cf_get_lang_main no='330.Tarih'> *</label>
						<div class="col col-8 col-xs-12">
							<cfsavecontent variable="message"><cf_get_lang_main no='1091.Lutfen Tarih Giriniz'></cfsavecontent>
							<div class="input-group">
								<cfinput type="text" name="action_date" id="action_date" value="#dateformat(date_info,dateformat_style)#" maxlength="10" validate="#validate_style#" required="Yes" message="#message#">
								<span class="input-group-addon">
									<cf_wrk_date_image date_field="action_date" call_function="change_money_info">
								</span>
							</div>
						</div>
					</div>
				</div>
			</cf_box_elements>
			<cf_box_footer>	<!---/// footer alanı record info ve submit butonu--->
				<cf_workcube_buttons is_upd='0' add_function='control_form()'>
			</cf_box_footer>				
			<div id="collacted_dekont_bask">
				<cfset paper_type = 5>
				<cfif isdefined("attributes.multi_id") and len(attributes.multi_id)>
					<cfset is_copy = 1>
				</cfif>		
				<cfinclude template="../../objects/display/add_bank_cash_process_row.cfm">
			</div>
		</cfform>
	</cf_box>
</div>
<script type="text/javascript">
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
		document.add_process.action_date.value = window.opener.document.getElementById("action_date").value;
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
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
