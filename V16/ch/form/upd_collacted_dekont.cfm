<cf_get_lang_set module_name="ch">
<cf_xml_page_edit fuseact="ch.add_collacted_dekont">
<cfinclude template="../../cash/query/get_money.cfm">
<cfif isdefined("attributes.multi_id") and len(attributes.multi_id)><!--- güncelleme--->
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
			CA.SUBSCRIPTION_ID,
			CA.EXPENSE_ITEM_ID,
			CA.INCOME_CENTER_ID,
			CA.INCOME_ITEM_ID,
			CA.ACTION_ACCOUNT_CODE,
			CA.ASSETP_ID,
			CA.ACC_DEPARTMENT_ID,
            CA.ACC_BRANCH_ID,
			CA.CONTRACT_ID,
            CA.ACC_TYPE_ID,
			CA.RELATION_ACTION_TYPE_ID,
			CA.RELATION_ACTION_ID
		FROM
			CARI_ACTIONS_MULTI CAM,
			CARI_ACTIONS CA
		WHERE
			CAM.MULTI_ACTION_ID = CA.MULTI_ACTION_ID 
			AND CAM.MULTI_ACTION_ID = #attributes.multi_id#
		ORDER BY
			CA.ACTION_ID
	</cfquery>
</cfif>
<cfset pageHead = getLang('ch',4) & ' : ' & get_action_detail.multi_action_id><!--- Toplu Dekont : ID--->
<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box>
		<cfform name="add_process">
			<cf_box_elements id="collacted_dekont">
				<input type="hidden" name="active_period" id="active_period" value="<cfoutput>#session.ep.period_id#</cfoutput>">
				<input type="hidden" name="multi_id" id="multi_id" value="<cfoutput>#get_action_detail.multi_action_id#</cfoutput>">
				<input type="hidden" name="pageDelEvent" id="pageDelEvent" value="delMulti" />
				<select name="action_currency_id" id="action_currency_id" style="display:none">
					<option value="1;<cfoutput>#session.ep.money#</cfoutput>" selected></option>
				</select>
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
					<div class="form-group" id="item-process_cat">
						<label class="col col-4 col-xs-12"><cf_get_lang_main no='388.işlem tipi'> *</label>
						<div class="col col-8 col-xs-12">
							<cfif get_action_detail.action_type_id eq 45 or get_action_detail.action_type_id eq 46>
								<cf_workcube_process_cat process_cat="#get_action_detail.process_cat#" process_type_info="#get_action_detail.action_type_id#" onclick_function="ayarla_gizle_goster();">
							<cfelse>
								<cf_workcube_process_cat process_cat="#get_action_detail.process_cat#" process_type_info="410,420,45,46" onclick_function="ayarla_gizle_goster();">
							</cfif>
						</div>
					</div>
					<cfif session.ep.isBranchAuthorization eq 0>
						<div class="form-group" id="item-acc_branch_id">
							<label class="col col-4 col-xs-12"><cf_get_lang_main no='41.Şube'></label>
							<div class="col col-8 col-xs-12">
								<cf_wrkDepartmentBranch fieldId='acc_branch_id' is_branch='1' is_deny_control='#session.ep.isBranchAuthorization#' selected_value='#get_action_detail.ACC_BRANCH_ID#'>
							</div>
						</div>
					</cfif>
				</div>
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
					<div class="form-group" id="item-acc_department_id">
						<label class="col col-4 col-xs-12"><cf_get_lang_main no='160.Departman'></label>
						<div class="col col-8 col-xs-12">
							<cf_wrkDepartmentBranch fieldId='acc_department_id' is_department='1' selected_value='#get_action_detail.ACC_DEPARTMENT_ID#'>
						</div>
					</div>
					<div class="form-group" id="item-action_date">
						<label class="col col-4 col-xs-12"><cf_get_lang_main no='330.Tarih'> *</label>
						<div class="col col-8 col-xs-12">
							<cfsavecontent variable="message"><cf_get_lang_main no='1091.Lutfen Tarih Giriniz'></cfsavecontent>
							<div class="input-group">
								<cfinput type="text" name="action_date" value="#dateformat(get_action_detail.action_date,dateformat_style)#" maxlength="10" validate="#validate_style#" required="Yes" message="#message#">
								<span class="input-group-addon">
									<cf_wrk_date_image date_field="action_date" call_function="change_money_info">
								</span>
							</div>
						</div>
					</div>
				</div>
			</cf_box_elements>
			<cf_box_footer>
				<div class="col col-6">
					<cf_record_info query_name="get_action_detail">
				</div>
				<div class="col col-6">
					<cf_workcube_buttons
						is_upd='1'
						add_function='control_form()'
						update_status='#get_action_detail.upd_status#'
						>
				</div>
			</cf_box_footer>
			<div id="collacted_dekont_bask">
				<cfset paper_type = 5>
				<cfset is_update = 1>
				<cfinclude template="../../objects/display/add_bank_cash_process_row.cfm">
			</div>
		</cfform>
	</cf_box>
</div>
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
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
