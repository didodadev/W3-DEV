<div style="display:none;z-index:999999;" id="wizard_div"></div>

<cf_get_lang_set module_name="budget">
<cfparam name="attributes.is_transfer" default="">
<cfparam name="attributes.demand_id" default="">
<cf_xml_page_edit fuseact="budget.add_budget_plan">
<cf_papers paper_type="budget_plan">
	
<cfquery name="get_processCat" datasource="#dsn3#">
	SELECT PROCESS_CAT_ID FROM SETUP_PROCESS_CAT WHERE PROCESS_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="1601">
</cfquery>
<cfif isdefined("attributes.budget_plan_id") and len(attributes.budget_plan_id)>
	<cfquery name="get_budget_plan" datasource="#dsn#">
		SELECT
			BUDGET_PLAN_ID,
			BUDGET_ID,
			PROCESS_TYPE,
			PROCESS_CAT,
			BUDGET_PLAN_DATE,
			BUDGET_PLANNER_EMP_ID,
			DETAIL,
			INCOME_TOTAL,
			EXPENSE_TOTAL,
			DIFF_TOTAL,
			OTHER_EXPENSE_TOTAL,
			OTHER_INCOME_TOTAL,
			OTHER_DIFF_TOTAL,
			OTHER_MONEY,
			IS_SCENARIO,
			ACC_DEPARTMENT_ID,
			BRANCH_ID,
			PERIOD_ID,
            DOCUMENT_TYPE,
            PAYMENT_METHOD,
            DUE_DATE
		FROM
			BUDGET_PLAN
		WHERE
			BUDGET_PLAN_ID = #attributes.budget_plan_id#
	</cfquery>
	<cfset attributes.budget_id = get_budget_plan.budget_id>
	<cfquery name="get_budget_plan_row" datasource="#dsn#">
		SELECT
			BUDGET_PLAN_ROW_ID,
			BUDGET_PLAN_ID,
			PLAN_DATE,
			DETAIL,
			EXP_INC_CENTER_ID,
			BUDGET_ITEM_ID,
			BUDGET_ACCOUNT_CODE,
			ACTIVITY_TYPE_ID,
			RELATED_EMP_ID,
			RELATED_EMP_TYPE,
			ROW_TOTAL_INCOME,
			ROW_TOTAL_EXPENSE,
			ROW_TOTAL_DIFF,
			OTHER_ROW_TOTAL_INCOME,
			OTHER_ROW_TOTAL_EXPENSE,
			OTHER_ROW_TOTAL_DIFF,
			IS_PAYMENT,
			WORKGROUP_ID,
			PROJECT_ID,
			ACC_TYPE_ID,
			ASSETP_ID
		FROM
			BUDGET_PLAN_ROW
		WHERE
			BUDGET_PLAN_ID = #attributes.budget_plan_id# ORDER BY BUDGET_PLAN_ROW_ID
	</cfquery>

	<cfquery name="get_money" datasource="#dsn#">
		SELECT MONEY_TYPE AS MONEY,* FROM BUDGET_PLAN_MONEY WHERE ACTION_ID = #attributes.budget_plan_id#
	</cfquery>
	<cfif not get_money.recordcount>
		<cfquery name="get_money" datasource="#dsn2#">
			SELECT MONEY,0 AS IS_SELECTED,* FROM SETUP_MONEY WHERE PERIOD_ID = #session.ep.period_id# AND MONEY_STATUS = 1 ORDER BY MONEY_ID
		</cfquery>
	</cfif>
<cfelseif isdefined("attributes.demand_id") and len(attributes.demand_id)>
	<cfset attributes.is_transfer = 1>
	<cfquery name="get_budget_plan" datasource="#dsn2#">
		SELECT
		    DEMAND_ID,
			BUDGET_ID,
			DEMAND_DATE AS BUDGET_PLAN_DATE,
			DEMAND_EMP_ID AS BUDGET_PLANNER_EMP_ID,
			DETAIL,
			DEMAND_NO
		FROM
			BUDGET_TRANSFER_DEMAND
		WHERE
			DEMAND_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.demand_id#">
	</cfquery>
	<cfset attributes.budget_id = get_budget_plan.budget_id>
	<cfquery name="get_budget_plan_row" datasource="#dsn2#">
		SELECT
			DEMAND_ROWS_ID AS BUDGET_PLAN_ROW_ID,
			DEMAND_ID,
			'#dateformat(now(),dateformat_style)#' AS PLAN_DATE,
			'GİDER' DETAIL,
			DEMAND_EXP_CENTER AS EXP_INC_CENTER_ID,
			DEMAND_EXP_ITEM AS BUDGET_ITEM_ID,
			'' BUDGET_ACCOUNT_CODE,
			DEMAND_ACTIVITY_TYPE AS ACTIVITY_TYPE_ID,
			'' RELATED_EMP_ID,
			'' RELATED_EMP_TYPE,
			(CASE WHEN BLOCK_TYPE = 0 THEN '' ELSE (0-ROUND(AMOUNT,2)) END) AS ROW_TOTAL_INCOME,
			(CASE WHEN BLOCK_TYPE = 0 THEN (0-ROUND(AMOUNT,2)) ELSE '' END) AS ROW_TOTAL_EXPENSE,
			(CASE WHEN BLOCK_TYPE = 0 THEN (0-ROUND(-AMOUNT,2)) ELSE '' END) AS ROW_TOTAL_DIFF,
			0 AS OTHER_ROW_TOTAL_INCOME,
			'' OTHER_ROW_TOTAL_EXPENSE,
			'' OTHER_ROW_TOTAL_DIFF,
			'' IS_PAYMENT,
			'' WORKGROUP_ID,
			DEMAND_PROJECT_ID AS PROJECT_ID,
			'' ACC_TYPE_ID,
			'' ASSETP_ID
		FROM
			BUDGET_TRANSFER_DEMAND_ROWS
		WHERE
			DEMAND_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.demand_id#">	
		UNION ALL 
		SELECT
			DEMAND_ROWS_ID AS BUDGET_PLAN_ROW_ID,
			DEMAND_ID,
			'#dateformat(now(),dateformat_style)#' AS PLAN_DATE,
			'GİDER' DETAIL,
			TRANSFER_EXP_CENTER AS EXP_INC_CENTER_ID,
			TRANSFER_EXP_ITEM AS BUDGET_ITEM_ID,
			'' BUDGET_ACCOUNT_CODE,
			TRANSFER_ACTIVITY_TYPE AS ACTIVITY_TYPE_ID,
			'' RELATED_EMP_ID,
			'' RELATED_EMP_TYPE,
			(CASE WHEN BLOCK_TYPE = 0 THEN 0 ELSE (ROUND(AMOUNT,2)) END) AS ROW_TOTAL_INCOME,
			(CASE WHEN BLOCK_TYPE = 0 THEN (ROUND(AMOUNT,2)) ELSE '' END) AS ROW_TOTAL_EXPENSE,
			(CASE WHEN BLOCK_TYPE = 0 THEN (0-ROUND(AMOUNT,2)) ELSE '' END) AS ROW_TOTAL_DIFF,
			0 OTHER_ROW_TOTAL_INCOME,
			'' OTHER_ROW_TOTAL_EXPENSE,
			'' OTHER_ROW_TOTAL_DIFF,
			'' IS_PAYMENT,
			'' WORKGROUP_ID,
			TRANSFER_PROJECT_ID AS PROJECT_ID,
			'' ACC_TYPE_ID,
			'' ASSETP_ID
		FROM
			BUDGET_TRANSFER_DEMAND_ROWS
		WHERE
			DEMAND_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.demand_id#">
	</cfquery>
	<cfquery name="get_money" datasource="#dsn2#">
		SELECT MONEY,RATE1,RATE2 FROM SETUP_MONEY ORDER BY MONEY_ID
	</cfquery>

<cfelseif isdefined("attributes.is_rapor") and attributes.is_rapor eq 1>
	<cfscript>
		satir_sayisi = attributes.total_record;
		index = 1;
		get_budget_plan_row = QueryNew("BUDGET_PLAN_ROW_ID,BUDGET_PLAN_ID,PLAN_DATE,DETAIL,EXP_INC_CENTER_ID,BUDGET_ITEM_ID,BUDGET_ACCOUNT_CODE,
										ACTIVITY_TYPE_ID,RELATED_EMP_ID,RELATED_EMP_TYPE,ROW_TOTAL_INCOME,ROW_TOTAL_EXPENSE,ROW_TOTAL_DIFF,OTHER_ROW_TOTAL_INCOME,
										OTHER_ROW_TOTAL_EXPENSE,OTHER_ROW_TOTAL_DIFF,IS_PAYMENT,WORKGROUP_ID,PROJECT_ID,ASSETP_ID");
		QueryAddRow(get_budget_plan_row,satir_sayisi*2);

		for(a=1;a lte attributes.record_num; a=a+1)
		{
			if (isdefined("attributes.row_check#a#"))
			{
				QuerySetCell(get_budget_plan_row,"BUDGET_PLAN_ROW_ID","",index);
				QuerySetCell(get_budget_plan_row,"BUDGET_PLAN_ID","",index);
				QuerySetCell(get_budget_plan_row,"PLAN_DATE",now(),index);
				QuerySetCell(get_budget_plan_row,"DETAIL",evaluate("attributes.detail#a#"),index);
				QuerySetCell(get_budget_plan_row,"EXP_INC_CENTER_ID",evaluate("attributes.expense_center_id#a#"),index);
				QuerySetCell(get_budget_plan_row,"BUDGET_ITEM_ID",evaluate("attributes.expense_item_id#a#"),index);
				QuerySetCell(get_budget_plan_row,"BUDGET_ACCOUNT_CODE",evaluate("attributes.tahakkuk_acc_code#a#"),index);
				QuerySetCell(get_budget_plan_row,"ACTIVITY_TYPE_ID","",index);
				QuerySetCell(get_budget_plan_row,"RELATED_EMP_ID","",index);
				QuerySetCell(get_budget_plan_row,"RELATED_EMP_TYPE","",index);
				QuerySetCell(get_budget_plan_row,"ROW_TOTAL_INCOME",evaluate("attributes.income_total#a#"),index);
				QuerySetCell(get_budget_plan_row,"ROW_TOTAL_EXPENSE",evaluate("attributes.expense_total#a#"),index);
				QuerySetCell(get_budget_plan_row,"ROW_TOTAL_DIFF","",index);
				QuerySetCell(get_budget_plan_row,"OTHER_ROW_TOTAL_INCOME",evaluate("attributes.other_income_total#a#"),index);
				QuerySetCell(get_budget_plan_row,"OTHER_ROW_TOTAL_EXPENSE",evaluate("attributes.other_expense_total#a#"),index);
				QuerySetCell(get_budget_plan_row,"OTHER_ROW_TOTAL_DIFF","",index);
				QuerySetCell(get_budget_plan_row,"IS_PAYMENT","",index);
				QuerySetCell(get_budget_plan_row,"WORKGROUP_ID","",index);
				QuerySetCell(get_budget_plan_row,"PROJECT_ID",evaluate("attributes.project_id#a#"),index);
				QuerySetCell(get_budget_plan_row,"ASSETP_ID","",index);
				index ++;

				QuerySetCell(get_budget_plan_row,"BUDGET_PLAN_ROW_ID","",index);
				QuerySetCell(get_budget_plan_row,"BUDGET_PLAN_ID","",index);
				QuerySetCell(get_budget_plan_row,"PLAN_DATE",now(),index);
				QuerySetCell(get_budget_plan_row,"DETAIL",evaluate("attributes.detail#a#"),index);
				QuerySetCell(get_budget_plan_row,"EXP_INC_CENTER_ID","",index);
				QuerySetCell(get_budget_plan_row,"BUDGET_ITEM_ID","",index);
				QuerySetCell(get_budget_plan_row,"BUDGET_ACCOUNT_CODE",evaluate("attributes.account_code#a#"),index);
				QuerySetCell(get_budget_plan_row,"ACTIVITY_TYPE_ID","",index);
				QuerySetCell(get_budget_plan_row,"RELATED_EMP_ID","",index);
				QuerySetCell(get_budget_plan_row,"RELATED_EMP_TYPE","",index);
				QuerySetCell(get_budget_plan_row,"ROW_TOTAL_INCOME",evaluate("attributes.expense_total#a#"),index);
				QuerySetCell(get_budget_plan_row,"ROW_TOTAL_EXPENSE",evaluate("attributes.income_total#a#"),index);
				QuerySetCell(get_budget_plan_row,"ROW_TOTAL_DIFF","",index);
				QuerySetCell(get_budget_plan_row,"OTHER_ROW_TOTAL_INCOME",evaluate("attributes.other_expense_total#a#"),index);
				QuerySetCell(get_budget_plan_row,"OTHER_ROW_TOTAL_EXPENSE",evaluate("attributes.other_income_total#a#"),index);
				QuerySetCell(get_budget_plan_row,"OTHER_ROW_TOTAL_DIFF","",index);
				QuerySetCell(get_budget_plan_row,"IS_PAYMENT","",index);
				QuerySetCell(get_budget_plan_row,"WORKGROUP_ID","",index);
				QuerySetCell(get_budget_plan_row,"PROJECT_ID",evaluate("attributes.project_id#a#"),index);
				QuerySetCell(get_budget_plan_row,"ASSETP_ID","",index);
				index++;
			}
		}
	</cfscript>
	<cfquery name="get_money" datasource="#dsn2#">
		SELECT MONEY,RATE1,RATE2 FROM SETUP_MONEY ORDER BY MONEY_ID
	</cfquery>
<cfelse>
	<cfquery name="get_money" datasource="#dsn2#">
		SELECT MONEY,RATE1,RATE2 FROM SETUP_MONEY ORDER BY MONEY_ID
	</cfquery>
</cfif>
<cfscript>
	budget_plan=createObject("component","V16.budget.cfc.budget_plan") ;
	get_branches=budget_plan.get_branches();
	GET_DEPARTMENT=budget_plan.GET_DEPARTMENT();
	get_expense_center=budget_plan.get_expense_center();
	get_activity_types=budget_plan.get_activity_types();
	get_workgroups=budget_plan.get_workgroups();
</cfscript>
<cfscript>
	netbook = createObject("component","V16.e_government.cfc.netbook");
	netbook.dsn = dsn;
	get_account_card_document_types = netbook.getAccountCardDocumentTypes(is_company : 1, is_active : 1);
	get_account_card_payment_types = netbook.getAccountCardPaymentTypes(is_active : 1);
</cfscript>
<cf_catalystHeader>
<div class="col col-12 col-xs-12">
	<cf_box>
		<cfform name="add_budget_plan" method="post" action="#request.self#?fuseaction=budget.emptypopup_add_budget_plan" enctype="multipart/form-data">
			<input type="hidden" name="active_period" id="active_period" value="<cfoutput>#session.ep.period_id#</cfoutput>">
			<input type="hidden" name="is_transfer" id="is_transfer" value="<cfoutput>#attributes.is_transfer#</cfoutput>">
			<input type="hidden" name="demand_id" id="demand_id" value="<cfoutput>#attributes.demand_id#</cfoutput>">
			<cf_box_elements id="budget_plan">
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
					<div class="form-group" id="item-process_cat">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="57800.İşlem Tipi">*</label>
						<div class="col col-8 col-xs-12">
							<cfif isdefined("attributes.budget_plan_id") and len(attributes.budget_plan_id)>
								<cf_workcube_process_cat process_cat='#get_processCat.process_cat_id#' slct_width='150' form_name="add_budget_plan">
								<cfelseif isDefined("attributes.demand_id") and len(attributes.demand_id)>
									<cf_workcube_process_cat process_cat='#get_processCat.process_cat_id#' slct_width='150' form_name="add_budget_plan">
								<cfelse>
								<cf_workcube_process_cat slct_width="150" form_name="add_budget_plan">
							</cfif>
						</div>
					</div>
					<div class="form-group" id="item-surec">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="58859.Süreç">*</label>
						<div class="col col-8 col-xs-12">
							<cf_workcube_process is_upd='0' process_cat_width='150' is_detail='0'>
						</div>
					</div>
					<div class="form-group" id="item-surec">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="49179.İlişkili Bütçe"></label>
						<div class="col col-8 col-xs-12">
							<div class="input-group">
								<cfif isdefined("attributes.budget_id") and len(attributes.budget_id)>
									<cfquery name="GET_BUDGET" datasource="#dsn#">
										SELECT BUDGET_NAME FROM BUDGET WHERE BUDGET_ID = #attributes.budget_id#
									</cfquery>
									<cfset budget_id = attributes.budget_id>
									<cfset budget_name = get_budget.budget_name>
								<cfelse>
									<cfset budget_id = ''>
									<cfset budget_name = ''>
								</cfif>
								<input type="hidden" name="budget_id" id="budget_id" value="<cfoutput>#budget_id#</cfoutput>">
								<input type="text" name="budget_name" id="budget_name" <cfif not isdefined("attributes.from_plan_list")>readonly="yes"</cfif> style="width:150px;" value="<cfoutput>#budget_name#</cfoutput>">
								<span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_budget&field_id=add_budget_plan.budget_id&field_name=add_budget_plan.budget_name&select_list=2');return false" title="<cfoutput>#getLang('budget',85)#</cfoutput>"></span>
							</div>
						</div>
					</div>
					<cfif is_show_branch eq 1>
						<div class="form-group" id="item-acc_branch_id">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57453.Şube'></label>
							<div class="col col-8 col-xs-12">
								<select name="acc_branch_id" id="acc_branch_id" >
									<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
									<cfoutput query="get_branches">
										<option value="#BRANCH_ID#" <cfif isdefined("attributes.budget_plan_id") and len(attributes.budget_plan_id) and get_budget_plan.branch_id eq branch_id>selected</cfif>>#BRANCH_NAME#</option>
									</cfoutput>
								</select>
							</div>
						</div>
					</cfif>
					<cfif isdefined("attributes.budget_plan_id") and len(attributes.budget_plan_id) and xml_show_percent eq 1>
						<div class="form-group" id="item-rate">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='47476.Yüzde'>(%)</label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<input type="text" name="rate" id="rate" value="0">
									<span class="input-group-addon no-bg"></span>
									<input type="button" name="calistir" id="calistir" value="<cfoutput>#getLang('main',499)#</cfoutput>" onclick="percent_hesapla();" />
								</div>
							</div>
						</div>
					</cfif>
				</div>
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
					<div class="form-group" id="item-paper_number">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57880.Belge No'>*</label>
						<div class="col col-8 col-xs-12">
							<cfif len(paper_code) and len(paper_number)>
								<cfinput type="text" name="paper_number" id="paper_number" value="#paper_code & '-' & paper_number#" maxlength="40" style="width:80px;">
							<cfelse>
								<cfinput type="text" name="paper_number" id="paper_number" value="" maxlength="40" style="width:80px;">
							</cfif>
						</div>
					</div>
					<div class="form-group" id="item-record_date">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57627.Kayıt Tarihi'></label>
						<div class="col col-8 col-xs-12">
							<div class="input-group">
								<cfif (isdefined("attributes.budget_plan_id") and len(attributes.budget_plan_id)) or (isdefined("attributes.demand_id") and len(attributes.demand_id))>
									<cfinput name="record_date" id="record_date" type="text" validate="#validate_style#" required="Yes" value="#dateformat(get_budget_plan.BUDGET_PLAN_DATE,dateformat_style)#" onblur="change_money_info('add_budget_plan','record_date');">
								<cfelse>
									<cfinput name="record_date" id="record_date" type="text" validate="#validate_style#" required="Yes" value="#dateformat(now(),dateformat_style)#" onblur="change_money_info('add_budget_plan','record_date');">
								</cfif>
								<span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="record_date" call_function="change_money_info"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-employee_name">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='49175.Planlayan'><cfif not isdefined("attributes.from_plan_list")> *</cfif></label>
						<div class="col col-8 col-xs-12">
							<div class="input-group">
								<input type="hidden" name="employee_id" id="employee_id" value="<cfif (isdefined("attributes.budget_plan_id") and len(attributes.budget_plan_id)) or (isdefined("attributes.demand_id") and len(attributes.demand_id))><cfoutput>#get_budget_plan.budget_planner_emp_id#</cfoutput></cfif>">
								<input type="Text" name="employee_name" id="employee_name" value="<cfif (isdefined("attributes.budget_plan_id") and len(attributes.budget_plan_id)) or (isdefined("attributes.demand_id") and len(attributes.demand_id))><cfoutput>#get_emp_info(get_budget_plan.budget_planner_emp_id,0,0)#</cfoutput></cfif>" style="width:150px;">
								<span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=add_budget_plan.employee_id&field_name=add_budget_plan.employee_name&select_list=1');" title="<cfoutput>#getLang('budget',81)#</cfoutput>"></span>
							</div>
						</div>
					</div>
					<cfif xml_acc_department_info>
						<div class="form-group" id="item-acc_department_id">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57572.Departman'></label>
							<div class="col col-8 col-xs-12">
								<cf_wrkDepartmentBranch fieldId='acc_department_id' is_department='1' width='150' is_deny_control='0'>
							</div>
						</div>
					</cfif>
				</div>
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
					<div class="form-group" id="item-detail">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
						<div class="col col-8 col-xs-12">
							<textarea name="detail" id="detail"><cfif (isdefined("attributes.budget_plan_id") and len(attributes.budget_plan_id)) or (isdefined("attributes.demand_id") and len(attributes.demand_id))><cfoutput>#get_budget_plan.detail#</cfoutput></cfif></textarea>
						</div>
					</div>
					<div class="form-group" id="item-is_scenario">
						<label class="col col-12"><input name="is_scenario" id="is_scenario" type="checkbox" value="" <cfif isdefined("attributes.budget_plan_id") and len(attributes.budget_plan_id) and get_budget_plan.is_scenario eq 1>checked</cfif>><cf_get_lang dictionary_id='49113.Senaryoda Gözüksün'></label>
					</div>
				</div>
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="4" sort="true">
					<div class="form-group" id="item-document_type" style="position:relative">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58533.Açıklama'></label>
						<div class="col col-8 col-xs-12">
							<select name="document_type" id="document_type" onchange="display_duedate()">
								<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
								<cfoutput query="get_account_card_document_types">
									<option value="#document_type_id#" <cfif isdefined("attributes.budget_plan_id") and len(attributes.budget_plan_id) and get_budget_plan.document_type eq document_type_id>selected</cfif>>#document_type#</option>
								</cfoutput>
							</select>
						</div> 
						<div id="budget_file" style="display:none;z-index:999999; position:absolute; width:100%; float:right; top:0;"></div>                     	
					</div>
					<div class="form-group" id="item-payment_type">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='30057.Ödeme Şekli'></label>
						<div class="col col-8 col-xs-12">
							<select name="payment_type" id="payment_type" style="width:150px;">
								<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
								<cfoutput query="get_account_card_payment_types">
									<option value="#payment_type_id#" <cfif isdefined("attributes.budget_plan_id") and len(attributes.budget_plan_id) and get_budget_plan.payment_method eq payment_type_id>selected</cfif>>#payment_type#</option>
								</cfoutput>
							</select>
						</div>                      	
					</div>
					<div class="form-group" id="item-due_date" <cfif not isdefined("attributes.budget_plan_id") or not listFind("-1,-3",get_budget_plan.document_type)>style="display:none;"</cfif>>
						<label id="td_due_date_label" class="col col-4 col-xs-12"><cfoutput>#getLang('main',469)#</cfoutput></label>
						<div id="td_due_date_input" class="col col-8 col-xs-12">
							<div class="input-group">
								<cfif isdefined("attributes.budget_plan_id") and len(attributes.budget_plan_id)>
									<cfinput type="text" name="due_date" maxlength="10" validate="#validate_style#" value="#dateformat(get_budget_plan.due_date,dateformat_style)#">
								<cfelse>
									<cfinput type="text" name="due_date" maxlength="10" validate="#validate_style#">
								</cfif>
								<span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="due_date" call_function="change_money_info"></span> 
							</div>
						</div>
					</div>
				</div>
			</cf_box_elements>
			<cf_basket id="budget_plan_bask">
				<div style="position:absolute;margin-left:50px;margin-top:41px;z-index:999;" id="open_process"></div>
				<cf_grid_list>
					<thead>
						<cfoutput>
							<tr>
								<th style="min-width:20px;"><cf_get_lang dictionary_id='57487.No'></th>
								<th style="min-width:20px;">
									<input type="hidden" name="record_num_kontrol" id="record_num_kontrol" value="<cfif (isdefined("attributes.budget_plan_id") and len(attributes.budget_plan_id)) or (isdefined("attributes.demand_id") and len(attributes.demand_id))>#get_budget_plan_row.recordcount#<cfelse>0</cfif>">
									<input type="hidden" name="record_num" id="record_num" value="<cfif (isdefined("attributes.budget_plan_id") and len(attributes.budget_plan_id)) or (isdefined("attributes.is_rapor")) or (isdefined("attributes.demand_id") and len(attributes.demand_id))>#get_budget_plan_row.recordcount#<cfelse>0</cfif>">
									<a style="cursor:pointer" onclick="add_row();" title="Satır Ekle"><i class="fa fa-plus" alt="<cf_get_lang dictionary_id='57707.Satır Ekle'>"></i></a>
									<a onClick="open_process_row();"><i class="icon-MLM" title="<cf_get_lang dictionary_id='34266.Masraf Dağılımı Yap'>" align="absmiddle" style="cursor:pointer;"></i></a>
								</th>
								<cfloop list="#ListDeleteDuplicates(xml_order_list_rows)#" index="xlr">
									<cfswitch expression="#xlr#">
										<cfcase value="1"><!--- 1.Tarih --->
											<cfsavecontent variable="message"><cf_get_lang dictionary_id='58503.Lütfen Tarih Giriniz'>!</cfsavecontent>
											<th style="min-width:120px;"><cf_get_lang dictionary_id='57742.Tarih'>&nbsp;<cfinput type="text" name="temp_date" id="temp_date" value="#dateformat(now(),dateformat_style)#" style="width:70px;" class="box" onBlur="change_date_info();" validate="#validate_style#" message="#message#"></th>
										</cfcase>
										<cfcase value="2"><!--- 2.Açıklama --->
											<th style="min-width:100px;"><cf_get_lang dictionary_id='57629.Açıklama'>*</th>
										</cfcase>
										<cfcase value="3"><!--- 3.Masraf Merkezi --->
											<th style="min-width:150px;"><cf_get_lang dictionary_id='58235.Masraf/Gelir Merkezi'> *</th>
										</cfcase>
										<cfcase value="4"><!--- 4.Butce Kategorisi --->
											<th style="min-width:120px;"><cf_get_lang dictionary_id="32999.Bütçe Kategorisi"></th>
										</cfcase>
										<cfcase value="5"><!--- 5.Butce Kalemi --->
											<th style="min-width:120px;"><cf_get_lang dictionary_id='58234.Bütçe Kalemi'> *</th>
										</cfcase>
										<cfcase value="6"><!--- 6.Muhasebe Kodu --->
											<th style="min-width:120px;"><cf_get_lang dictionary_id='58811.Muhasebe Kodu'></th>
										</cfcase>
										<cfcase value="7"><!--- 7.Aktivite Tipi --->
											<th style="min-width:100px;"><cf_get_lang dictionary_id='49184.Aktivite Tipi'></th>
										</cfcase>
										<cfcase value="8"><!--- 8.Is Grubu --->
											<th style="min-width:100px;"><cf_get_lang dictionary_id='58140.İş Grubu'></th>
										</cfcase>
										<cfcase value="17"><!--- 17.Fiziki Varlık --->
											<th style="min-width:120px;"><cf_get_lang dictionary_id='58833.Fiziki Varlık'></th>
										</cfcase>
										<cfcase value="9"><!--- 9.Proje --->
											<th style="min-width:120px;"><cf_get_lang dictionary_id='57416.Proje'></th>
										</cfcase>
										<cfcase value="10"><!--- 10.Cari Hesap --->
											<th style="min-width:120px;"><cf_get_lang dictionary_id='57519.Cari Hesap'></th>
										</cfcase>
										<cfcase value="11"><!--- 11.Gelir TL --->
											<th style="min-width:70px;"><cf_get_lang dictionary_id='58677.Gelir'> #session.ep.money#</th>
										</cfcase>
										<cfcase value="12"><!--- 12.Gider TL --->
											<th style="min-width:70px;"><cf_get_lang dictionary_id='58678.Gider'> #session.ep.money#</th>
										</cfcase>
										<cfcase value="13"><!--- 13.Fark TL --->
											<th style="min-width:70px;"><cf_get_lang dictionary_id='58583.Fark'> #session.ep.money#</th>
										</cfcase>
										<cfcase value="14"><!--- 14.Gelir Doviz --->
											<th style="min-width:70px;"><cf_get_lang dictionary_id='58677.Gelir'> <input type="text" name="other_money_info2" id="other_money_info2" class="moneybox"  style="width:20px" readonly="" value="#session.ep.money2#"></th>
										</cfcase>
										<cfcase value="15"><!--- 15.Gider Doviz --->
											<th style="min-width:70px;"><cf_get_lang dictionary_id='58678.Gider'> <input type="text" name="other_money_info3" id="other_money_info3" class="moneybox"  style="width:20px" readonly="" value="#session.ep.money2#"></th>
										</cfcase>
										<cfcase value="16"><!--- 16.Fark Doviz --->
											<th style="min-width:70px;"><cf_get_lang dictionary_id='58583.Fark'><input type="text" name="other_money_info4" id="other_money_info4" class="moneybox" readonly="" style="width:20px" value="#session.ep.money2#"></th>
										</cfcase>
									</cfswitch>
								</cfloop>
							</tr>
						</cfoutput>
					</thead>
					<tbody name="table1" id="table1">
						<cfif (isdefined("attributes.budget_plan_id") and len(attributes.budget_plan_id)) or (isdefined("attributes.is_rapor") and attributes.is_rapor eq 1) or (isdefined("attributes.demand_id") and len(attributes.demand_id))>
							<cfset budget_item_id_list=''>
							<cfset budget_project_list=''>
							<cfset budget_assetp_id_list=''>
							<cfoutput query="get_budget_plan_row">
								<cfif len(BUDGET_ITEM_ID) and not listfind(budget_item_id_list,budget_item_id)>
								<cfset budget_item_id_list=listappend(budget_item_id_list,budget_item_id)>
								</cfif>
								<cfif len(project_id) and not listfind(budget_project_list,project_id)>
									<cfset budget_project_list=listappend(budget_project_list,project_id)>
								</cfif>
								<cfif len(assetp_id) and not listfind(budget_assetp_id_list,assetp_id)>
									<cfset budget_assetp_id_list=listappend(budget_assetp_id_list,assetp_id)>
								</cfif>
							</cfoutput>
							<cfif len(budget_item_id_list)>
								<cfset budget_item_id_list=listsort(budget_item_id_list,"numeric","ASC",",")>
								<cfquery name="get_exp_detail" datasource="#dsn2#">
									SELECT
										EI.EXPENSE_ITEM_NAME,
										EI.ACCOUNT_CODE,
										EI.EXPENSE_ITEM_ID,
										EC.EXPENSE_CAT_NAME,
										EC.EXPENSE_CAT_ID
									FROM
										EXPENSE_ITEMS EI
										LEFT JOIN EXPENSE_CATEGORY EC ON EC.EXPENSE_CAT_ID = EI.EXPENSE_CATEGORY_ID
									WHERE
										EXPENSE_ITEM_ID IN (#budget_item_id_list#)
									ORDER BY
										EXPENSE_ITEM_ID
								</cfquery>
							</cfif>
							<cfif len(budget_project_list)>
								<cfset budget_project_list=listsort(budget_project_list,"numeric","ASC",",")>
								<cfquery name="get_pro_detail" datasource="#dsn#">
									SELECT PROJECT_ID, PROJECT_HEAD FROM PRO_PROJECTS WHERE PROJECT_ID IN (#budget_project_list#) ORDER BY PROJECT_ID
								</cfquery>
								<cfset budget_project_list = ListSort(ListDeleteDuplicates(ValueList(get_pro_detail.project_id,',')),"numeric","asc",",")>
							</cfif>
							<cfif len(budget_assetp_id_list)>
								<cfset budget_assetp_id_list=listsort(budget_assetp_id_list,"numeric","ASC",",")>
								<cfquery name="get_assetp_name" datasource="#dsn#">
									SELECT ASSETP_ID, ASSETP FROM ASSET_P WHERE ASSETP_ID IN (#budget_assetp_id_list#) ORDER BY ASSETP_ID
								</cfquery>
							</cfif>
							<cfoutput query="get_budget_plan_row">
								<tr id="frm_row#currentrow#">
									<td style="width:20px;" nowrap="nowrap">#currentrow#</td>
									<td nowrap="nowrap"><input type="hidden" value="1" name="row_kontrol#currentrow#" id="row_kontrol#currentrow#"><a href="javascript://" onClick="sil('#currentrow#');"><i class="fa fa-minus" alt="<cf_get_lang dictionary_id='58971.Satır Sil'>"></i></a><a style="cursor:pointer" onclick="copy_row('#currentrow#');" title="<cf_get_lang dictionary_id='58972.Satır Kopyala'>"><i class="icon-copy"></i></a></td>
										<input type="hidden" value="#budget_plan_row_id#" name="budget_plan_row_id#currentrow#" id="budget_plan_row_id#currentrow#">
									<cfloop list="#ListDeleteDuplicates(xml_order_list_rows)#" index="xlr">
										<cfswitch expression="#xlr#">
											<cfcase value="1"><!--- 1.Tarih --->
												<td nowrap="nowrap">
													<div class="form-group">
														<div class="input-group">
															<input type="text" name="expense_date#currentrow#" id="expense_date#currentrow#" style="width:95px;" value="#dateformat(get_budget_plan_row.PLAN_DATE,dateformat_style)#" title="#detail#">
															<span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="expense_date#currentrow#"></span>
														</div>
													</div>
												</td>
											</cfcase>
											<cfcase value="2"><!--- 2.Açıklama --->
												<td><div class="form-group"><input type="text" class="boxtext" name="row_detail#currentrow#" id="row_detail#currentrow#" style="width:120px;" value="#get_budget_plan_row.DETAIL#" title="#detail#"></div></td>
											</cfcase>
											<cfcase value="3"><!--- 3.Masraf Merkezi --->
												<td><cfset deger_expense_center_id = get_budget_plan_row.exp_inc_center_id>
													<div class="form-group">
														<select name="expense_center_id#currentrow#" id="expense_center_id#currentrow#" style="width:100%;" class="boxtext">
															<option value=""><cf_get_lang dictionary_id='58235.Masraf/Gelir Merkezi'></option>
															<cfloop query="get_expense_center">
																<option value="#expense_id#" <cfif deger_expense_center_id eq get_expense_center.expense_id>selected</cfif>>#EXPENSE#</option>
															</cfloop>
														</select>
													</div>
												</td>
											</cfcase>
											<cfcase value="4"><!--- 4.Butce Kategorisi --->
												<td nowrap="nowrap">
													<div class="form-group">
														<input type="hidden" name="expense_cat_id#currentrow#" id="expense_cat_id#currentrow#" value="<cfif len(budget_item_id_list)>#get_exp_detail.expense_cat_id[listfind(budget_item_id_list,budget_item_id,',')]#</cfif>" style="width:25px;"/>
														<input type="text" name="expense_cat_name#currentrow#" id="expense_cat_name#currentrow#"  value="<cfif len(budget_item_id_list)>#get_exp_detail.expense_cat_name[listfind(budget_item_id_list,budget_item_id,',')]#</cfif>" style="width:100%;" class="boxtext" >
													</div>
												</td>
											</cfcase>
											<cfcase value="5"><!--- 5.Butce Kalemi --->
												<td nowrap="nowrap">
													<div class="form-group">
														<div class="input-group">
															<input type="hidden" name="expense_item_id#currentrow#" id="expense_item_id#currentrow#" value="#budget_item_id#">
															<input type="text" name="expense_item_name#currentrow#" id="expense_item_name#currentrow#"  value="<cfif len(budget_item_id_list)>#get_exp_detail.expense_item_name[listfind(budget_item_id_list,budget_item_id,',')]#</cfif>" style="width:120px;" class="boxtext" title="#detail#" onFocus="AutoComplete_Create('expense_item_name#currentrow#','EXPENSE_ITEM_NAME','EXPENSE_ITEM_NAME','get_expense_item','','EXPENSE_ITEM_ID,ACCOUNT_CODE,EXPENSE_CAT_ID,EXPENSE_CAT_NAME','expense_item_id#currentrow#,account_code#currentrow#,expense_cat_id#currentrow#,expense_cat_name#currentrow#','upd_budget_plan',1);" autocomplete="off">
															<span class="input-group-addon icon-ellipsis btnPointer" href="javascript://" onclick="pencere_ac_exp('#currentrow#');"></span>
														</div>
													</div>
												</td>
											</cfcase>
											<cfcase value="6"><!--- 6.Muhasebe Kodu --->
												<td nowrap="nowrap">
													<div class="form-group">
														<div class="input-group">
															<input type="hidden" name="account_id#currentrow#" id="account_id#currentrow#" value="#budget_account_code#">
															<input type="text" name="account_code#currentrow#" id="account_code#currentrow#" value="#budget_account_code#" style="width:120px;" class="boxtext" title="#detail#" onFocus="AutoComplete_Create('account_code#currentrow#','ACCOUNT_CODE,ACCOUNT_NAME','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','','ACCOUNT_CODE','account_id#currentrow#','','3','225');" autocomplete="off">
															<span class="input-group-addon icon-ellipsis btnPointer" href="javascript://" onclick="pencere_ac_acc('#currentrow#');"></span>
														</div>
													</div>
												</td>
											</cfcase>
											<cfcase value="7"><!--- 7.Aktivite Tipi --->
												<td><cfset deger_activity_type_id = get_budget_plan_row.activity_type_id>
													<div class="form-group">
														<select name="activity_type#currentrow#" id="activity_type#currentrow#" style="width:120px;" class="boxtext">
															<option value=""><cf_get_lang dictionary_id='49184.Aktivite Tipi'></option>
															<cfloop query="get_activity_types">
																<option value="#activity_id#" <cfif deger_activity_type_id eq activity_id>selected</cfif>>#activity_name#</option>
															</cfloop>
														</select>
													</div>
												</td>
											</cfcase>
											<cfcase value="8"><!--- 8.Is Grubu --->
												<td><cfset deger_workgroup_id = get_budget_plan_row.workgroup_id>
													<div class="form-group">
														<select name="workgroup_id#currentrow#" id="workgroup_id#currentrow#" style="width:100px;" class="boxtext">
															<option value=""><cf_get_lang dictionary_id='58140.İş Grubu'></option>
															<cfloop query="get_workgroups">
																<option value="#workgroup_id#" <cfif deger_workgroup_id eq workgroup_id>selected</cfif>>#WORKGROUP_NAME#</option>
															</cfloop>
														</select>
													</div>
												</td>
											</cfcase>
											<cfcase value="17"><!--- 17.Fiziki Varlik --->
												<td nowrap="nowrap">
													<div class="form-group">
														<div class="input-group">
															<input type="hidden" name="assetp_id#currentrow#" id="assetp_id#currentrow#" value="#get_budget_plan_row.assetp_id#">
															<input type="text" name="assetp_name#currentrow#" id="assetp_name#currentrow#" style="width:105px;" onFocus="autocomp_assetp('#currentrow#');" value="<cfif len(budget_assetp_id_list)>#get_assetp_name.assetp[listfind(budget_assetp_id_list,assetp_id,',')]#</cfif>" class="boxtext" autocomplete="off">
															<span class="input-group-addon icon-ellipsis btnPointer" href="javascript://" onClick="pencere_ac_assetp('#currentrow#');"></span>
														</div>
													</div>
												</td>
											</cfcase>
											<cfcase value="9"><!--- 9.Proje --->
												<td nowrap="nowrap">
													<div class="form-group">
														<div class="input-group">
															<input type="hidden" name="project_id#currentrow#" id="project_id#currentrow#" value="#get_budget_plan_row.project_id#">
																<input type="text" style="width:140px;" name="project_head#currentrow#" id="project_head#currentrow#" onFocus="autocomp_project('#currentrow#');" value="<cfif len(budget_project_list) and len(project_id)>#get_pro_detail.project_head[listfind(budget_project_list,project_id,',')]#</cfif>"  class="boxtext">
															<span class="input-group-addon icon-ellipsis btnPointer" href="javascript://" onClick="pencere_ac_project('#currentrow#');"></span>
														</div>
													</div>
												</td>
											</cfcase>
											<cfcase value="10"><!--- 10.Cari Hesap --->
												<td nowrap="nowrap">
													<div class="form-group">
														<div class="input-group">
															<cfif related_emp_type eq 'partner'>
																<input type="hidden" name="employee_id#currentrow#" id="employee_id#currentrow#" value="">
																<input type="hidden" name="consumer_id#currentrow#" id="consumer_id#currentrow#" value="">
																<input type="hidden" name="company_id#currentrow#" id="company_id#currentrow#" value="#related_emp_id#">
																<input type="hidden" name="member_type#currentrow#" id="member_type#currentrow#" value="#related_emp_type#">
																<input type="text" style="width:110px;" name="authorized#currentrow#" id="authorized#currentrow#" value="#get_par_info(related_emp_id,1,0,0)#" class="boxtext" title="#detail#" onFocus="AutoComplete_Create('authorized#currentrow#','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','\'1,2,3\',\'\',\'\',\'\',\'\',\'\',\'\',\'1\'','MEMBER_TYPE,COMPANY_ID,PARTNER_CODE,EMPLOYEE_ID,ACCOUNT_CODE,ACCOUNT_CODE','member_type#currentrow#,company_id#currentrow#,partner_id#currentrow#,employee_id#currentrow#,account_code#currentrow#,account_id#currentrow#','','3','250');" autocomplete="off">&nbsp;<span class="input-group-addon icon-ellipsis btnPointer" href="javascript://" onClick="pencere_ac_company('#currentrow#');"></span></td>
															<cfelseif related_emp_type eq 'consumer'>
																<input type="hidden" name="employee_id#currentrow#" id="employee_id#currentrow#" value="">
																<input type="hidden" name="consumer_id#currentrow#" id="consumer_id#currentrow#" value="#related_emp_id#">
																<input type="hidden" name="company_id#currentrow#" id="company_id#currentrow#" value="">
																<input type="hidden" name="member_type#currentrow#" id="member_type#currentrow#" value="#related_emp_type#">
																<input type="text" name="authorized#currentrow#" id="authorized#currentrow#" value="#get_cons_info(related_emp_id,0,0)#" style="width:110px;" class="boxtext" title="#detail#" onFocus="AutoComplete_Create('authorized#currentrow#','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','\'1,2,3\',\'\',\'\',\'\',\'\',\'\',\'\',\'1\'','MEMBER_TYPE,COMPANY_ID,PARTNER_CODE,EMPLOYEE_ID,ACCOUNT_CODE,ACCOUNT_CODE','member_type#currentrow#,company_id#currentrow#,partner_id#currentrow#,employee_id#currentrow#,account_code#currentrow#,account_id#currentrow#,account_code#currentrow#,account_id#currentrow#','','3','250');" autocomplete="off">&nbsp;<span class="input-group-addon icon-ellipsis btnPointer" href="javascript://" onClick="pencere_ac_company('#currentrow#');"></span></td>
															<cfelseif related_emp_type eq 'employee'>
																<input type="hidden" name="employee_id#currentrow#" id="employee_id#currentrow#" value="<cfif len(acc_type_id)>#related_emp_id#_#acc_type_id#<cfelse>#related_emp_id#</cfif>">
																<input type="hidden" name="consumer_id#currentrow#" id="consumer_id#currentrow#" value="">
																<input type="hidden" name="company_id#currentrow#" id="company_id#currentrow#" value="">
																<input type="hidden" name="member_type#currentrow#" id="member_type#currentrow#" value="#related_emp_type#">
																<input type="text" style="width:110px;" name="authorized#currentrow#" id="authorized#currentrow#" value="#get_emp_info(related_emp_id,0,0,0,acc_type_id)#" class="boxtext" title="#detail#" onFocus="AutoComplete_Create('authorized#currentrow#','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','\'1,2,3\',\'\',\'\',\'\',\'\',\'\',\'\',\'1\'','MEMBER_TYPE,COMPANY_ID,PARTNER_CODE,EMPLOYEE_ID,ACCOUNT_CODE,ACCOUNT_CODE','member_type#currentrow#,company_id#currentrow#,partner_id#currentrow#,employee_id#currentrow#','','3','250');" autocomplete="off">&nbsp;<span class="input-group-addon icon-ellipsis btnPointer" href="javascript://" onClick="pencere_ac_company('#currentrow#');"></span></td>
															<cfelse>
																<input type="hidden" name="employee_id#currentrow#" id="employee_id#currentrow#" value="">
																<input type="hidden" name="consumer_id#currentrow#" id="consumer_id#currentrow#" value="">
																<input type="hidden" name="company_id#currentrow#" id="company_id#currentrow#" value="">
																<input type="hidden" name="member_type#currentrow#" id="member_type#currentrow#" value="">
																<input type="text" style="width:110px;" name="authorized#currentrow#" id="authorized#currentrow#" value="" class="boxtext" title="#detail#" onFocus="AutoComplete_Create('authorized#currentrow#','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','\'1,2,3\',\'\',\'\',\'\',\'\',\'\',\'\',\'1\'','MEMBER_TYPE,COMPANY_ID,PARTNER_CODE,EMPLOYEE_ID,ACCOUNT_CODE,ACCOUNT_CODE','member_type#currentrow#,company_id#currentrow#,partner_id#currentrow#,employee_id#currentrow#,account_code#currentrow#,account_id#currentrow#','','3','250');" autocomplete="off">&nbsp;<span class="input-group-addon icon-ellipsis btnPointer" href="javascript://" onClick="pencere_ac_company('#currentrow#');"></span>
															</cfif>
														</div>
													</div>
												</td>
											</cfcase>
											<cfcase value="11"><!--- 11.Gelir TL --->
												<td><div class="form-group"><input type="text" name="income_total#currentrow#" id="income_total#currentrow#" value="#TLFormat(row_total_income)#" style="width:75px;" onBlur="if(filterNum(this.value) <=0) this.value=commaSplit(0);hesapla('#currentrow#');" class="moneybox" title="#detail#"></div></td>
											</cfcase>
											<cfcase value="12"><!--- 12.Gider TL --->
												<td><div class="form-group"><input type="text" name="expense_total#currentrow#" id="expense_total#currentrow#" value="#TLFormat(row_total_expense)#" style="width:75px;" onBlur="if(filterNum(this.value) <=0) this.value=commaSplit(0);hesapla('#currentrow#');" class="moneybox" title="#detail#"></div></td>
											</cfcase>
											<cfcase value="13"><!--- 13.Fark TL --->
												<td><div class="form-group"><input type="text" name="diff_total#currentrow#" id="diff_total#currentrow#" value="#TLFormat(row_total_diff)#" style="width:75px;" onBlur="if(filterNum(this.value) <=0) this.value=commaSplit(0);hesapla('#currentrow#');" class="moneybox" title="#detail#"></div></td>
											</cfcase>
											<cfcase value="14"><!--- 14.Gelir Doviz --->
												<td><div class="form-group"><input type="text" name="other_income_total#currentrow#" id="other_income_total#currentrow#" value="#TLFormat(other_row_total_income)#" style="width:75px;" class="moneybox" readonly="yes" title="#detail#"></div></td>
											</cfcase>
											<cfcase value="15"><!--- 15.Gider Doviz --->
												<td><div class="form-group"><input type="text" name="other_expense_total#currentrow#" id="other_expense_total#currentrow#" value="#TLFormat(other_row_total_expense)#" style="width:75px;" class="moneybox" readonly="yes" title="#detail#"></div></td>
											</cfcase>
											<cfcase value="16"><!--- 16.Fark Doviz --->
												<td><div class="form-group"><input type="text" name="other_diff_total#currentrow#" id="other_diff_total#currentrow#" value="#TLFormat(other_row_total_diff)#" style="width:75px;" class="moneybox" readonly="yes" title="#detail#"></div></td>
											</cfcase>
										</cfswitch>
									</cfloop>
								</tr>
							</cfoutput>
						</cfif>
					</tbody>
				</cf_grid_list>				
			</cf_basket>	
			<div id="sepetim_total">
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12">
					<div class="totalBox">
						<div class="totalBoxHead font-grey-mint">
							<span class="headText"><cf_get_lang dictionary_id='57677.Döviz'></span>
							<div class="collapse">
								<span class="icon-minus"></span>
							</div>
						</div>
						<div class="totalBoxBody">
							<cfoutput>
								<table>
								<input type="hidden" name="kur_say" id="kur_say" value="<cfoutput>#get_money.recordcount#</cfoutput>">
								<cfoutput>
									<cfset selected_money=session.ep.money>
									<cfloop query="get_money">
										<tr>
											<td height="17">
												<input type="hidden" name="hidden_rd_money_#currentrow#" id="hidden_rd_money_#currentrow#" value="#money#">
												<input type="hidden" name="txt_rate1_#currentrow#" id="txt_rate1_#currentrow#" value="#rate1#">
												<input type="radio" name="rd_money" id="rd_money" value="#money#" onClick="toplam_doviz_hesapla();" <cfif selected_money eq money>checked</cfif>>
											</td>
											<td>#money#</td>
											<cfif session.ep.rate_valid eq 1>
												<cfset readonly_info = "yes">
											<cfelse>
												<cfset readonly_info = "no">
											</cfif>
											<td>#TLFormat(rate1,0)#/</td>
											<td valign="bottom"><input type="text"  name="txt_rate2_#currentrow#" id="txt_rate2_#currentrow#"<cfif readonly_info>readonly</cfif> class="box" value="#TLFormat(rate2,session.ep.our_company_info.rate_round_num)#" <cfif money eq session.ep.money>readonly="yes"</cfif> onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.rate_round_num#));" onBlur="toplam_doviz_hesapla();"></td>
									</tr>
									</cfloop>
								</cfoutput>
							</table>  
							</cfoutput>                  
							
						</div>
					</div>
				</div>
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12">
					<div class="totalBox">
						<div class="totalBoxHead font-grey-mint">
							<span class="headText"><cf_get_lang dictionary_id='57492.Toplam'><cf_get_lang dictionary_id='57635.Miktar'></span>
							<div class="collapse">
								<span class="icon-minus"></span>
							</div>
						</div>
						<div class="totalBoxBody">
							<table>
								<tr>
									<td width="150" class="txtbold" colspan="2" style="text-align:right;"><cfoutput>#session.ep.money#</cfoutput> <cf_get_lang dictionary_id='57492.Toplam'> </td>
								</tr>
								<tr>
									<td width="50"><cf_get_lang dictionary_id='58677.Gelir'></td>
									<td style="text-align:right;">
										<input type="text" name="income_total_amount" id="income_total_amount" class="box" readonly="" value="<cfif isdefined("attributes.budget_plan_id") and len(attributes.budget_plan_id)><cfoutput>#TLFormat(GET_BUDGET_PLAN.INCOME_TOTAL)#</cfoutput><cfelse>0</cfif>" style="width:100%;">
									</td>
								</tr>
								<tr>
									<td><cf_get_lang dictionary_id='58678.Gider'></td>
									<td style="text-align:right;">
										<input type="text" name="expense_total_amount" id="expense_total_amount" class="box" readonly="" value="<cfif isdefined("attributes.budget_plan_id") and len(attributes.budget_plan_id)><cfoutput>#TLFormat(GET_BUDGET_PLAN.EXPENSE_TOTAL)#</cfoutput><cfelse>0</cfif>" style="width:100%;">
									</td>
								</tr>
								<tr>
									<td><cf_get_lang dictionary_id='58583.Fark'></td>
									<td style="text-align:right;">
										<input type="text" name="diff_total_amount" id="diff_total_amount" class="box" readonly="" value="<cfif isdefined("attributes.budget_plan_id") and len(attributes.budget_plan_id)><cfoutput>#TLFormat(GET_BUDGET_PLAN.DIFF_TOTAL)#</cfoutput><cfelse>0</cfif>" style="width:100%;">
									</td>
								</tr>
						</table>
						</div>
					</div>
				</div>
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12">
					<div class="totalBox">
						<div class="totalBoxHead font-grey-mint">
							<span class="headText"><cf_get_lang dictionary_id='58156.Diğer'></span>
							<div class="collapse">
								<span class="icon-minus"></span>
							</div>
						</div>
						<div class="totalBoxBody">
							<table>
								<tr>
									<td width="150" class="txtbold" style="text-align:right;"><input type="text" name="other_money_info" id="other_money_info" class="box" readonly="" style="width:35px;" value="<cfoutput>#session.ep.money2#</cfoutput>">&nbsp;&nbsp;<cf_get_lang dictionary_id='57492.Toplam'></td>
								</tr>
								<tr>
									<td style="text-align:right;">
									<input type="text" name="other_income_total_amount" id="other_income_total_amount" class="box" readonly="" value="<cfif isdefined("attributes.budget_plan_id") and len(attributes.budget_plan_id)><cfoutput>#TLFormat(GET_BUDGET_PLAN.OTHER_INCOME_TOTAL)#</cfoutput><cfelse>0</cfif>" style="width:100%;">
									</td>
								</tr>
								<tr>
									<td style="text-align:right;">
										<input type="text" name="other_expense_total_amount" id="other_expense_total_amount" class="box" readonly="" value="<cfif isdefined("attributes.budget_plan_id") and len(attributes.budget_plan_id)><cfoutput>#TLFormat(GET_BUDGET_PLAN.OTHER_EXPENSE_TOTAL)#</cfoutput><cfelse>0</cfif>" style="width:100%;">
									</td>
								</tr>
								<tr>
									<td style="text-align:right;">
										<input type="text" name="other_diff_total_amount" id="other_diff_total_amount" class="box" readonly="" value="<cfif isdefined("attributes.budget_plan_id") and len(attributes.budget_plan_id)><cfoutput>#TLFormat(GET_BUDGET_PLAN.OTHER_DIFF_TOTAL)#</cfoutput><cfelse>0</cfif>" style="width:100%;">
									</td>
								</tr>
							</table>
						</div>
					</div>
				</div>
			</div>
			<cf_box_footer>
				<cf_workcube_buttons is_upd='0' add_function='kontrol()'>
			</cf_box_footer>
			<cfif isdefined("attributes.demand_id") and len(attributes.demand_id)>
				<div style="display:none" class="ui-cfmodal ui-cfmodal__alert">
					<cf_box>
						<div class="ui-cfmodal-close">×</div>
						<ul class="required_list"></ul>
						<div class="ui-form-list-btn">
							<div>
								<a href="javascript:void(0);"  onClick="cancel();" class="ui-btn ui-btn-delete"><cf_get_lang dictionary_id='58461.Reddet'></a>
							</div>
							<div>
								<input type="submit" class="ui-btn ui-btn-success" value="Kaydet" onClick="return (process_cat_control() && unformat_fields());">		
							</div>
						</div>
					</cf_box>
				</div>
			</cfif>
		</cfform>	
	</cf_box>
</div>
<script type = "text/javascript">
	function open_wizard() {
		document.getElementById("wizard_div").style.display ='';
		
		$("#wizard_div").css('margin-left',$("#tabMenu").position().left - 500);
		$("#wizard_div").css('margin-top',$("#tabMenu").position().top + 50);
		$("#wizard_div").css('position','absolute');
		
		AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_budget_row_calculator&type=budget_plan','wizard_div',1);
		return true;
	}

	var count = 0;
	$('.collapse').click(function(){
	$(this).parent().parent().find('.totalBoxBody').slideToggle();
		if($(this).find("span").hasClass("icon-minus")){
			$(this).find("span").removeClass("icon-minus").addClass("icon-pluss");
		}
		else{
			$(this).find("span").removeClass("icon-pluss").addClass("icon-minus");
		}
	});

	function open_calc_popup() {
		openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_budget_row_calculator</cfoutput>');
	}
</script>

<script type="text/javascript">
	function formatMoney(number, decPlaces, decSep, thouSep) {
		decPlaces = isNaN(decPlaces = Math.abs(decPlaces)) ? 2 : decPlaces,
		decSep = typeof decSep === "undefined" ? "," : decSep;
		thouSep = typeof thouSep === "undefined" ? "." : thouSep;
		var sign = number < 0 ? "-" : "";
		var i = String(parseInt(number = Math.abs(Number(number) || 0).toFixed(decPlaces)));
		var j = (j = i.length) > 3 ? j % 3 : 0;

		return sign +
		(j ? i.substr(0, j) + thouSep : "") +
		i.substr(j).replace(/(\decSep{3})(?=\decSep)/g, "$1" + thouSep) +
		(decPlaces ? decSep + Math.abs(number - i).toFixed(decPlaces).slice(2) : "");
	}

	function open_exp_center()
	{
		openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_expense_center&field_id=add_budget_plan.wizard_expense_center_id&field_name=add_budget_plan.wizard_expense_center');
	}
	function open_exp_item(sira)
	{
		if(sira == 1)
			openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_exp_item&field_id=add_budget_plan.wizard_month_expense_item_id&field_name=add_budget_plan.wizard_month_expense_item_name&field_account_no=add_budget_plan.wizard_month_account_code&field_account_id=add_budget_plan.wizard_month_account_id');
		else if(sira == 2)
			openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_exp_item&field_id=add_budget_plan.wizard_year_expense_item_id&field_name=add_budget_plan.wizard_year_expense_item_name&field_account_no=add_budget_plan.wizard_year_account_code&field_account_id=add_budget_plan.wizard_year_account_id');
	}
	<cfif isdefined("attributes.is_rapor")>
		for(zzz=1;zzz<=document.getElementById("record_num").value;zzz++)
		{
			if(document.getElementById("row_kontrol"+zzz).value==1)
			{
				hesapla(zzz);
			}
		}
	</cfif>
	<cfif isdefined("attributes.budget_plan_id") and len(attributes.budget_plan_id)>
		row_count=<cfoutput>#get_budget_plan_row.recordcount#</cfoutput>;
	<cfelse>
		row_count=0;
	</cfif>
	function display_duedate()
	{
		if(document.getElementById('document_type').value == -1 || document.getElementById('document_type').value == -3)
		{
			document.getElementById('item-due_date').style.display = '';
		}
		else
		{
			document.getElementById('item-due_date').style.display = 'none';
		}
	}
	function open_file()
	{
		document.getElementById('budget_file').style.display='';
		AjaxPageLoad('<cfoutput>#request.self#?fuseaction=budget.popup_add_budget_file<cfif isdefined("attributes.budget_id")>&budget_id=#attributes.budget_id#</cfif></cfoutput>','budget_file',1);
		return false;
	}
	function check_all(deger)
	{
		if(add_budget_plan.hepsi.checked)
		{
			for(i=1;i<=add_budget_plan.record_num.value;i++)
			{
				if(document.getElementById("row_kontrol"+i).value==1)
				{
					var form_field = document.getElementById("is_payment" + i);
					form_field.checked = true;
					document.getElementById("is_payment"+i).focus();
				}
			}
		}
		else
		{
			for(i=1;i<=add_budget_plan.record_num.value;i++)
			{
				if(document.getElementById("row_kontrol"+i).value==1)
				{
					form_field = document.getElementById("is_payment" + i);
					form_field.checked = false;
					document.getElementById("is_payment"+i).focus();
				}
			}
		}
	}
	function sil(sy)
	{
		var my_element=document.getElementById("row_kontrol"+sy);
		my_element.value=0;
		var my_element=document.getElementById("frm_row"+sy);
		my_element.style.display="none";
		toplam_hesapla();
		document.getElementById("record_num_kontrol").value = parseInt(document.getElementById("record_num_kontrol").value)-1;
	}
	function add_row(expense_date,row_detail,expense_center_id,expense_item_id,expense_item_name,expense_cat_id,expense_cat_name,account_id,account_code,activity_type,workgroup_id,member_type,company_id,consumer_id,employee_id,authorized,project_id,project_name,income_total,expense_total,diff_total,other_income_total,other_expense_total,other_diff_total,assetp_id,assetp_name)
	{
		//Normal satır eklerken değişkenler olmadığı için boşluk atıyor,kopyalarken değişkenler geliyor
		if(expense_date == undefined)expense_date = '';
		if(row_detail == undefined)row_detail = '';
		if(expense_center_id == undefined)expense_center_id = '';
		if(expense_item_id == undefined)expense_item_id = '';
		if(expense_item_name == undefined)expense_item_name = '';
		if(expense_cat_id == undefined)expense_cat_id = '';
		if(expense_cat_name == undefined)expense_cat_name = '';
		if(account_id == undefined)account_id = '';
		if(account_code == undefined)account_code = '';
		if(activity_type == undefined)activity_type = '';
		if(workgroup_id == undefined)workgroup_id = '';
		if(member_type == undefined)member_type = '';
		if(company_id == undefined)company_id = '';
		if(consumer_id == undefined)consumer_id = '';
		if(employee_id == undefined)employee_id = '';
		if(authorized == undefined)authorized = '';
		if(project_id == undefined) project_id = '';
		if(project_name == undefined) project_name = '';
		if(assetp_id == undefined) assetp_id = '';
		if(assetp_name == undefined) assetp_name = '';
		if(income_total == undefined)income_total = 0;
		if(expense_total == undefined)expense_total = 0;
		if(diff_total == undefined)diff_total = 0;
		if(other_income_total == undefined)other_income_total = 0;
		if(other_expense_total == undefined)other_expense_total = 0;
		if(other_diff_total == undefined)other_diff_total = 0;

		row_count++;
		var newRow;
		var newCell;
		newRow = document.getElementById("table1").insertRow(document.getElementById("table1").rows.length);
		newRow.setAttribute("name","frm_row" + row_count);
		newRow.setAttribute("id","frm_row" + row_count);
		newRow.setAttribute("NAME","frm_row" + row_count);
		newRow.setAttribute("ID","frm_row" + row_count);
		newRow.className = 'color-row';
		document.getElementById("record_num").value=row_count;
		document.getElementById("record_num_kontrol").value=parseInt(document.getElementById("record_num_kontrol").value)+1;
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		newCell.innerHTML = '<input type="text" name="satir_no' + row_count +'" id="satir_no' + row_count +'" value=' +row_count+' class="boxtext" style="width:20px;" readonly="yes">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		newCell.innerHTML = '<input  type="hidden"  value="1"  name="row_kontrol' + row_count +'" id="row_kontrol' + row_count +'" ><a style="cursor:pointer" onclick="sil(' + row_count + ');"  ><i class="fa fa-minus" alt="<cf_get_lang dictionary_id='58971.Satır Sil'>"></i></a><a style="cursor:pointer" onclick="copy_row(' + row_count + ');" title="<cf_get_lang dictionary_id='58972.Satır Kopyala'>"><i class="icon-copy" alt="<cf_get_lang dictionary_id='58972.Satır Kopyala'>" border="0"></a>';
		<cfloop list="#ListDeleteDuplicates(xml_order_list_rows)#" index="xlr">
			<cfswitch expression="#xlr#">
				<cfcase value="1">//1.<cf_get_lang dictionary_id="57742.Tarih">
					newCell = newRow.insertCell(newRow.cells.length);
					newCell.setAttribute('nowrap','nowrap');
					newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="text" name="expense_date' + row_count +'"id="expense_date'+ row_count +'"class="text" maxlength="10" style="width:95px;" value="' + expense_date +'"> <span class="input-group-addon" id="expense_date' + row_count + '_td"></span></div></div>';
					wrk_date_image('expense_date' + row_count);
				</cfcase>
				<cfcase value="2">//2.<cf_get_lang dictionary_id="57629.Açıklama">
					newCell = newRow.insertCell(newRow.cells.length);
					newCell.setAttribute('nowrap','nowrap');
					newCell.innerHTML = '<div class="form-group"><input type="text" name="row_detail' + row_count +'" id="row_detail' + row_count +'" style="width:120px;" class="boxtext" maxlength="300" value="' + row_detail +'"></div>';
				</cfcase>
				<cfcase value="3">//3.<cf_get_lang dictionary_id="58460.Masraf Merkezi">
					newCell = newRow.insertCell(newRow.cells.length);
					a = '<div class="form-group"><select name="expense_center_id' + row_count  +'" id="expense_center_id' + row_count  +'" style="width:100%;" class="boxtext"><option value=""><cf_get_lang dictionary_id="58235.Masraf/Gelir Merkezi"></option>';
					<cfoutput query="get_expense_center">
						if('#expense_id#' == expense_center_id)
							a += '<option value="#expense_id#" selected>#expense#</option>';
						else
							a += '<option value="#expense_id#">#expense#</option>';
					</cfoutput>
					newCell.innerHTML =a+ '</select></div>';
				</cfcase>
				<cfcase value="4">//4.<cf_get_lang dictionary_id="32999.Butce Kategorisi">
					newCell = newRow.insertCell(newRow.cells.length);
					newCell.setAttribute('nowrap','nowrap');
					newCell.innerHTML = '<div class="form-group"><input type ="hidden" name="expense_cat_id' + row_count + '" id="expense_cat_id' + row_count + '" value="'+ expense_cat_id +'"><input type="text" name="expense_cat_name'+ row_count +'" id="expense_cat_name'+ row_count +'" value="'+ expense_cat_name +'" class="boxtext"></div>';
				</cfcase>
				<cfcase value="5">//5.<cf_get_lang dictionary_id="58234.Butce Kalemi">
					newCell = newRow.insertCell(newRow.cells.length);
					newCell.setAttribute('nowrap','nowrap');
					newCell.innerHTML = '<div class="form-group"><div class="input-group"><input  type="hidden" name="expense_item_id' + row_count +'" id="expense_item_id' + row_count +'" value="'+expense_item_id+'"><input type="text" style="width:120px;" name="expense_item_name' + row_count +'" id="expense_item_name' + row_count +'" class="boxtext" value="'+expense_item_name+'" onFocus="autocomp_budget('+row_count+');"><span class="input-group-addon icon-ellipsis btnPointer" href="javascript://" onclick="pencere_ac_exp('+ row_count +');"></span></div></div>';
				</cfcase>
				<cfcase value="6">//6.<cf_get_lang dictionary_id="58811.Muhasebe Kodu">
					newCell = newRow.insertCell(newRow.cells.length);
					newCell.setAttribute('nowrap','nowrap');
					newCell.innerHTML = '<div class="form-group"><div class="input-group"><input  type="hidden" name="account_id' + row_count +'" id="account_id' + row_count +'" value="'+account_id+'"><input type="text" style="width:120px;" name="account_code' + row_count +'" id="account_code' + row_count +'" class="boxtext"  value="'+account_code+'" onFocus="autocomp_acc_code('+row_count+');" ><span class="input-group-addon icon-ellipsis btnPointer" href="javascript://" onclick="pencere_ac_acc('+ row_count +');"></span></div></div>';
				</cfcase>
				<cfcase value="7">//7.<cf_get_lang dictionary_id="49184.Aktivite Tipi">
					newCell = newRow.insertCell(newRow.cells.length);
					newCell.setAttribute('nowrap','nowrap');
					b = '<div class="form-group"><select name="activity_type' + row_count  +'" id="activity_type' + row_count  +'" style="width:100px;" class="boxtext"><option value="">Aktivite Tipi</option>';
					<cfoutput query="get_activity_types">
						if('#activity_id#' == activity_type)
							b += '<option value="#activity_id#" selected>#activity_name#</option>';
						else
							b += '<option value="#activity_id#">#activity_name#</option>';
					</cfoutput>
					newCell.innerHTML =b+ '</select></div>';
				</cfcase>
				<cfcase value="8">//8.<cf_get_lang dictionary_id="58140.Is Grubu">
					newCell = newRow.insertCell(newRow.cells.length);
					newCell.setAttribute('nowrap','nowrap');
					b = '<div class="form-group"><select name="workgroup_id' + row_count  +'" id="workgroup_id' + row_count  +'" style="width:100px;;" class="boxtext"><option value="">İş Grubu</option>';
					<cfoutput query="get_workgroups">
						if('#workgroup_id#' == workgroup_id)
							b += '<option value="#workgroup_id#" selected>#workgroup_name#</option>';
						else
							b += '<option value="#workgroup_id#">#workgroup_name#</option>';
					</cfoutput>
					newCell.innerHTML =b+ '</select></div>';
				</cfcase>
				<cfcase value="17">//17.<cf_get_lang dictionary_id="58833.Fiziki Varlik">
					newCell = newRow.insertCell(newRow.cells.length);
					newCell.setAttribute('nowrap','nowrap');
					newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="hidden" name="assetp_id'+ row_count +'" id="assetp_id'+ row_count +'" value="'+assetp_id+'"><input type="text" style="width:105px;" name="assetp_name'+ row_count +'" id="assetp_name'+ row_count +'" onFocus="autocomp_assetp('+row_count+');" value="'+assetp_name+'" class="boxtext"> <span class="input-group-addon icon-ellipsis btnPointer" href="javascript://" onClick="pencere_ac_assetp('+ row_count +');"></span></div></div>';
				</cfcase>
				<cfcase value="9">//9.<cf_get_lang dictionary_id="57416.Proje">
					newCell = newRow.insertCell(newRow.cells.length);
					newCell.setAttribute('nowrap','nowrap');
					newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="hidden" name="project_id'+ row_count +'" id="project_id'+ row_count +'" value="'+project_id+'"><input type="text" style="width:143px;" name="project_head'+ row_count +'" id="project_head'+ row_count +'" onFocus="autocomp_project('+row_count+');" value="'+project_name+'" class="boxtext"><span  class="input-group-addon icon-ellipsis btnPointer" href="javascript://" onClick="pencere_ac_project('+ row_count +');"></span></div></div>';
				</cfcase>
				<cfcase value="10">//10.<cf_get_lang dictionary_id="57519.Cari Hesap">
					newCell = newRow.insertCell(newRow.cells.length);
					newCell.setAttribute('nowrap','nowrap');
					newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="hidden" name="member_type'+ row_count +'" id="member_type'+ row_count +'" value="'+member_type+'"><input type="hidden" name="company_id'+ row_count +'" id="company_id'+ row_count +'" value="'+company_id+'"><input type="hidden" name="consumer_id'+ row_count +'" id="consumer_id'+ row_count +'" value="'+consumer_id+'"><input type="hidden" name="employee_id'+ row_count +'" id="employee_id'+ row_count +'" value="'+employee_id+'"><input type="text" style="width:110px;" name="authorized'+ row_count +'" id="authorized'+ row_count +'" value="'+authorized+'" class="boxtext" onFocus="autocomp_cari('+row_count+');">&nbsp;<span class="input-group-addon icon-ellipsis btnPointer" href="javascript://" onClick="pencere_ac_company('+ row_count +');"></span></div></div>';
				</cfcase>
				<cfcase value="11">//11.<cf_get_lang dictionary_id="56669.Gelir TL">
					newCell = newRow.insertCell(newRow.cells.length);
					newCell.setAttribute('nowrap','nowrap');
					newCell.innerHTML = '<div class="form-group"><input type="text" name="income_total' + row_count +'" id="income_total' + row_count +'" value="'+income_total+'" onkeyup="return(FormatCurrency(this,event));" class="moneybox" onBlur="if(filterNum(this.value) <=0) this.value=commaSplit(0);hesapla('+row_count+');"></div>';
				</cfcase>
				<cfcase value="12">//12.<cf_get_lang dictionary_id="56670.Gider TL">
					newCell = newRow.insertCell(newRow.cells.length);
					newCell.innerHTML = '<div class="form-group"><input type="text" name="expense_total' + row_count +'" id="expense_total' + row_count +'" value="'+expense_total+'" onkeyup="return(FormatCurrency(this,event));" class="moneybox" onBlur="if(filterNum(this.value) <=0) this.value=commaSplit(0);hesapla('+row_count+');"></div>';
				</cfcase>
				<cfcase value="13">//13.<cf_get_lang dictionary_id="56671.Fark TL">
					newCell = newRow.insertCell(newRow.cells.length);
					newCell.innerHTML = '<div class="form-group"><input type="text" name="diff_total' + row_count +'" id="diff_total' + row_count +'" value="'+diff_total+'" onkeyup="return(FormatCurrency(this,event));" class="moneybox" onBlur="hesapla('+row_count+');" readonly="yes"></div>';
				</cfcase>
				<cfcase value="14">//<cf_get_lang dictionary_id="56673.Gelir Doviz">
					newCell = newRow.insertCell(newRow.cells.length);
					newCell.innerHTML = '<div class="form-group"><input type="text" name="other_income_total' + row_count +'" id="other_income_total' + row_count +'" value="'+other_income_total+'" onkeyup="return(FormatCurrency(this,event));" class="moneybox" readonly="yes"></div>';
				</cfcase>
				<cfcase value="15">//<cf_get_lang dictionary_id="56714.Gider Doviz">
					newCell = newRow.insertCell(newRow.cells.length);
					newCell.innerHTML = '<div class="form-group"><input type="text" name="other_expense_total' + row_count +'" id="other_expense_total' + row_count +'" value="'+other_expense_total+'" onkeyup="return(FormatCurrency(this,event));" class="moneybox" readonly="yes"></div>';
				</cfcase>
				<cfcase value="16">//<cf_get_lang dictionary_id="56733.Fark Doviz">
					newCell = newRow.insertCell(newRow.cells.length);
					newCell.innerHTML = '<div class="form-group"><input type="text" name="other_diff_total' + row_count +'" id="other_diff_total' + row_count +'" value="'+other_diff_total+'" onkeyup="return(FormatCurrency(this,event));" class="moneybox" readonly="yes"></div>';
				</cfcase>
			</cfswitch>
		</cfloop>
		hesapla(row_count);
		toplam_hesapla();
	}
	function open_process_row()
	{
		document.getElementById("open_process").style.display ='';
		<cfif isdefined("is_income") and is_income eq 1>type = 2;<cfelse>type=1;</cfif>
		AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=budget.emptypopup_add_budget_plan_rows&type='+type,'open_process',1);
	}
	function copy_row(no)
	{
		if (document.getElementById("expense_date" + no) == undefined) expense_date =""; else expense_date = document.getElementById("expense_date" + no).value;
		if (document.getElementById("row_detail" + no) == undefined) row_detail =""; else row_detail = document.getElementById("row_detail" + no).value;
		if (document.getElementById("expense_center_id" + no) == undefined) expense_center_id =""; else expense_center_id = document.getElementById("expense_center_id" + no).value;
		if (document.getElementById("expense_item_id" + no) == undefined) expense_item_id =""; else expense_item_id = document.getElementById("expense_item_id" + no).value;
		if (document.getElementById("expense_item_id" + no) == undefined) expense_item_id =""; else expense_item_name = document.getElementById("expense_item_name" + no).value;
		if(document.getElementById("expense_cat_id" + no) != undefined)
		{
			expense_cat_id = document.getElementById("expense_cat_id" + no).value;
			expense_cat_name = document.getElementById("expense_cat_name" + no).value;
		}
		else
		{
			expense_cat_id = '';
			expense_cat_name = '';
		}
		if (document.getElementById("account_id" + no) == undefined) account_id =""; else account_id = document.getElementById("account_id" + no).value;
		if (document.getElementById("account_code" + no) == undefined) account_code =""; else account_code = document.getElementById("account_code" + no).value;
		if (document.getElementById("activity_type" + no) == undefined) activity_type =""; else activity_type = document.getElementById("activity_type" + no).value;
		if (document.getElementById("workgroup_id" + no) == undefined) workgroup_id =""; else workgroup_id = document.getElementById("workgroup_id" + no).value;
		if (document.getElementById("member_type" + no) == undefined) member_type =""; else member_type = document.getElementById("member_type" + no).value;
		if (document.getElementById("company_id" + no) == undefined) company_id =""; else company_id = document.getElementById("company_id" + no).value;
		if (document.getElementById("consumer_id" + no) == undefined) consumer_id =""; else consumer_id = document.getElementById("consumer_id" + no).value;
		if (document.getElementById("employee_id" + no) == undefined) employee_id =""; else employee_id = document.getElementById("employee_id" + no).value;
		if (document.getElementById("authorized" + no) == undefined) authorized =""; else authorized = document.getElementById("authorized" + no).value;
		if(document.getElementById("project_id" + no) != undefined)
		{
			project_id = document.getElementById("project_id" + no).value;
			project_head = document.getElementById("project_head" + no).value;
		}
		else
		{
			project_id = '';
			project_head = '';
		}
		if(document.getElementById("assetp_id" + no) != undefined)
		{
			assetp_id = document.getElementById("assetp_id" + no).value;
			assetp_name = document.getElementById("assetp_name" + no).value;
		}
		else
		{
			assetp_id = '';
			assetp_name = '';
		}
		if (document.getElementById("income_total" + no) == undefined) income_total =""; else income_total = document.getElementById("income_total" + no).value;
		if (document.getElementById("expense_total" + no) == undefined) expense_total =""; else expense_total = document.getElementById("expense_total" + no).value;
		if (document.getElementById("diff_total" + no) == undefined) diff_total =""; else diff_total = document.getElementById("diff_total" + no).value;
		if (document.getElementById("other_income_total" + no) == undefined) other_income_total =""; else other_income_total = document.getElementById("other_income_total" + no).value;
		if (document.getElementById("other_expense_total" + no) == undefined) other_expense_total =""; else other_expense_total = document.getElementById("other_expense_total" + no).value;
		if (document.getElementById("other_diff_total" + no) == undefined) other_diff_total =""; else other_diff_total = document.getElementById("other_diff_total" + no).value;
		add_row(expense_date,row_detail,expense_center_id,expense_item_id,expense_item_name,expense_cat_id,expense_cat_name,account_id,account_code,activity_type,workgroup_id,member_type,company_id,consumer_id,employee_id,authorized,project_id,project_head,income_total,expense_total,diff_total,other_income_total,other_expense_total,other_diff_total,assetp_id,assetp_name);
	}
	function pencere_ac_acc(no)
	{
		openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_id=add_budget_plan.account_id' + no +'&field_name=add_budget_plan.account_code' + no +'');
	}
	function pencere_ac_exp(no)
	{
		if(document.getElementById("expense_cat_id" + no) != undefined)
			openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_exp_item&is_budget_items=1&field_id=add_budget_plan.expense_item_id' + no +'&field_name=add_budget_plan.expense_item_name' + no +'&field_account_no=add_budget_plan.account_code' + no +'&field_account_no2=add_budget_plan.account_id' + no + '&field_cat_id=add_budget_plan.expense_cat_id' + no + '&field_cat_name=add_budget_plan.expense_cat_name' + no);
		else
			openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_exp_item&is_budget_items=1&field_id=add_budget_plan.expense_item_id' + no +'&field_name=add_budget_plan.expense_item_name' + no +'&field_account_no=add_budget_plan.account_code' + no +'&field_account_no2=add_budget_plan.account_id' + no);
	}
	function pencere_ac_company(no)
	{
		document.getElementById("company_id"+no).value='';
		document.getElementById("authorized"+no).value='';
		document.getElementById("employee_id"+no).value='';
		document.getElementById("consumer_id"+no).value='';
		var send_account_code = '';
		<cfif xml_account_code_from_member eq 1>
			var send_account_code= "&field_member_account_code=add_budget_plan.account_code"+no+"&field_member_account_id=add_budget_plan.account_id"+no;
		</cfif>
		openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&is_cari_action=1'+send_account_code+'&field_name=add_budget_plan.authorized' + no +'&field_type=add_budget_plan.member_type' + no +'&field_comp_name=add_budget_plan.authorized' + no +'&field_consumer=add_budget_plan.consumer_id' + no + '&field_emp_id=add_budget_plan.employee_id' + no + '&field_comp_id=add_budget_plan.company_id' + no + '&select_list=1,2,3,9');
	}
	function percent_hesapla()
	{
		if(confirm("<cf_get_lang dictionary_id='56734.Yüzdesel Orana Göre Satırdaki Gelir ve Gider Değerleri Yeniden Hesaplanacaktır. Emin misiniz?'>"))
		{
			if(document.getElementById("rate") != undefined && document.getElementById("rate").value != 0 )
			{
				for(j=1;j<=document.getElementById("record_num").value;j++)
				{
					diff_income_value = parseFloat(parseFloat(filterNum(document.getElementById("income_total"+j).value))*parseFloat(filterNum(document.getElementById("rate").value))/100);
					document.getElementById("income_total"+j).value = commaSplit(parseFloat(diff_income_value+parseFloat(filterNum(document.getElementById("income_total"+j).value))));
					diff_expense_value =  parseFloat(parseFloat(filterNum(document.getElementById("expense_total"+j).value))*parseFloat(filterNum(document.getElementById("rate").value))/100);
					document.getElementById("expense_total"+j).value = commaSplit(parseFloat(diff_expense_value+parseFloat(filterNum(document.getElementById("expense_total"+j).value))));
					document.getElementById("diff_total"+j).value = commaSplit(filterNum(document.getElementById("income_total"+j).value)-filterNum(document.getElementById("expense_total"+j).value));
				}
			}
		}
	}
	function hesapla(row_no)
	{
		if(document.getElementById("diff_total"+row_no) != undefined)
			document.getElementById("diff_total"+row_no).value = commaSplit(filterNum(document.getElementById("income_total"+row_no).value)-filterNum(document.getElementById("expense_total"+row_no).value));
		if(document.getElementById("kur_say").value == 1)
			for (var i=1; i<=document.getElementById("kur_say").value; i++)
			{
				if(document.getElementById("rd_money").checked == true)
				{
					form_txt_rate2_ = filterNum(document.getElementById("txt_rate2_"+i).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
					document.getElementById("other_income_total"+row_no).value = commaSplit(filterNum(document.getElementById("income_total"+row_no).value)/form_txt_rate2_);
					if(document.getElementById("expense_total"+row_no) != undefined && document.getElementById("other_expense_total"+row_no) != undefined)
						document.getElementById("other_expense_total"+row_no).value = commaSplit(filterNum(document.getElementById("expense_total"+row_no).value)/form_txt_rate2_);
					if(document.getElementById("diff_total"+row_no) != undefined && document.getElementById("other_diff_total"+row_no) != undefined)
						document.getElementById("other_diff_total"+row_no).value = commaSplit(filterNum(document.getElementById("diff_total"+row_no).value)/form_txt_rate2_);
				}
			}
		else
			for (var i=1; i<=document.getElementById("kur_say").value; i++)
			{
				if(document.add_budget_plan.rd_money[i-1].checked == true)
				{
					form_txt_rate2_ = filterNum(document.getElementById("txt_rate2_"+i).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
					document.getElementById("other_income_total"+row_no).value = commaSplit(filterNum(document.getElementById("income_total"+row_no).value)/form_txt_rate2_);
					if(document.getElementById("expense_total"+row_no) != undefined && document.getElementById("other_expense_total"+row_no) != undefined)
						document.getElementById("other_expense_total"+row_no).value = commaSplit(filterNum(document.getElementById("expense_total"+row_no).value)/form_txt_rate2_);
					if(document.getElementById("diff_total"+row_no) != undefined && document.getElementById("other_diff_total"+row_no) != undefined)
						document.getElementById("other_diff_total"+row_no).value = commaSplit(filterNum(document.getElementById("diff_total"+row_no).value)/form_txt_rate2_);
				}
			}
		toplam_hesapla();
	}
	function toplam_hesapla()
	{
		var total_amount = 0;
		var other_total_amount = 0;
		var expense_total = 0;
		var other_expense_total = 0;
		var diff_total = 0;
		var other_diff_total = 0;
		for(j=1;j<=document.getElementById("record_num").value;j++)
		{
			if(document.getElementById("row_kontrol"+j).value==1)
			{
				total_amount = parseFloat(total_amount + parseFloat(filterNum(document.getElementById("income_total"+j).value)));
				other_total_amount = parseFloat(other_total_amount + parseFloat(filterNum(document.getElementById("other_income_total"+j).value)));
				expense_total = parseFloat(expense_total + parseFloat(filterNum(document.getElementById("expense_total"+j).value)));
				if(document.getElementById("other_expense_total"+j) != undefined)
					other_expense_total = parseFloat(other_expense_total + parseFloat(filterNum(document.getElementById("other_expense_total"+j).value)));
				if(document.getElementById("diff_total"+j) != undefined)
					diff_total = parseFloat(diff_total + parseFloat(filterNum(document.getElementById("diff_total"+j).value)));
				if(document.getElementById("other_diff_total"+j) != undefined)
					other_diff_total = parseFloat(other_diff_total + parseFloat(filterNum(document.getElementById("other_diff_total"+j).value)));
			}
		}
		document.getElementById("income_total_amount").value = commaSplit(total_amount);
		document.getElementById("other_income_total_amount").value = commaSplit(other_total_amount);
		document.getElementById("expense_total_amount").value = commaSplit(expense_total);
		document.getElementById("other_expense_total_amount").value = commaSplit(other_expense_total);
		document.getElementById("diff_total_amount").value = commaSplit(diff_total);
		document.getElementById("other_diff_total_amount").value = commaSplit(other_diff_total);
	}
	function toplam_doviz_hesapla()
	{
		if(document.getElementById("kur_say").value == 1)
			for (var t=1; t<=document.getElementById("kur_say").value; t++)
			{
				if(document.document.getElementById("rd_money").checked == true)
				{
					for(k=1;k<=document.getElementById("record_num").value;k++)
					{
						rate2_value = filterNum(document.getElementById("txt_rate2_"+t).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
						document.getElementById("other_income_total"+k).value = commaSplit(filterNum(document.getElementById("income_total"+k).value)/rate2_value);
						if(document.getElementById("other_expense_total"+k) != undefined)
							document.getElementById("other_expense_total"+k).value = commaSplit(filterNum(document.getElementById("expense_total"+k).value)/rate2_value);
						if(document.getElementById("diff_total"+k) != undefined && document.getElementById("other_diff_total"+k) != undefined)
							document.getElementById("other_diff_total"+k).value = commaSplit(filterNum(document.getElementById("diff_total"+k).value)/rate2_value);
					}
					document.getElementById("other_money_info").value = document.getElementById("rd_money").value;
					if(document.getElementById("other_money_info2") != undefined)
						document.getElementById("other_money_info2").value = document.getElementById("rd_money").value;
					if(document.getElementById("other_money_info3") != undefined)
						document.getElementById("other_money_info3").value = document.getElementById("rd_money").value;
					if(document.getElementById("other_money_info4") != undefined)
						document.getElementById("other_money_info4").value = document.getElementById("rd_money").value;
				}
			}
		else
			for (var t=1; t<=document.getElementById("kur_say").value; t++)
			{
				if(document.add_budget_plan.rd_money[t-1].checked == true)
				{
					for(k=1;k<=document.getElementById("record_num").value;k++)
					{
						rate2_value = filterNum(document.getElementById("txt_rate2_"+t).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
						document.getElementById("other_income_total"+k).value = commaSplit(filterNum(document.getElementById("income_total"+k).value)/rate2_value);
						if(document.getElementById("other_expense_total"+k) != undefined)
							document.getElementById("other_expense_total"+k).value = commaSplit(filterNum(document.getElementById("expense_total"+k).value)/rate2_value);
						if(document.getElementById("diff_total"+k) != undefined && document.getElementById("other_diff_total"+k) != undefined)
							document.getElementById("other_diff_total"+k).value = commaSplit(filterNum(document.getElementById("diff_total"+k).value)/rate2_value);
					}
					document.getElementById("other_money_info").value = document.add_budget_plan.rd_money[t-1].value;
					if(document.getElementById("other_money_info2") != undefined)
						document.getElementById("other_money_info2").value = document.add_budget_plan.rd_money[t-1].value;
					if(document.getElementById("other_money_info3") != undefined)
						document.getElementById("other_money_info3").value = document.add_budget_plan.rd_money[t-1].value;
					if(document.getElementById("other_money_info4") != undefined)
						document.getElementById("other_money_info4").value = document.add_budget_plan.rd_money[t-1].value;
				}
			}
		toplam_hesapla();
	}
	function kontrol()
	{
		if(!chk_process_cat('add_budget_plan')) return false;
		if(!chk_period(add_budget_plan.record_date,"İşlem")) return false;
		if(!check_display_files('add_budget_plan')) return false;
		if(!paper_control(document.getElementById("paper_number"),'BUDGET_PLAN',true,'','','0','0','0','<cfoutput>#dsn#</cfoutput>')) return false;
		<cfif not isdefined("attributes.from_plan_list")>
			if(document.getElementById("budget_id").value == "")
			{
				alert("<cf_get_lang dictionary_id='49157.Lütfen İlişkili Bütçe Giriniz'>!");
				return false;
			}
		</cfif>
		<cfif isdefined('xml_acc_department_info') and xml_acc_department_info eq 2 and session.ep.isBranchAuthorization eq 0> //xmlde muhasebe icin departman secimi zorunlu ise
			if( document.getElementById("acc_department_id").options[document.getElementById("acc_department_id").selectedIndex].value=='')
			{
				alert("<cf_get_lang dictionary_id='58836.Lütfen Departman Seçiniz'>!");
				return false;
			}
		</cfif>
		if((document.getElementById('document_type').value == -1 || document.getElementById('document_type').value == -3) && document.getElementById('due_date').value == '')
		{
			alert("<cf_get_lang dictionary_id='59046.Vade Tarihi Giriniz'>!");
			return false;
		}
		var record_exist=0;
		process = document.getElementById("process_cat").value;
		var selected_ptype = document.getElementById("process_cat").options[document.getElementById("process_cat").selectedIndex].value;
		eval('var proc_control = document.add_budget_plan.ct_process_type_'+selected_ptype+'.value');
		var get_process_cat = wrk_safe_query('bdg_get_process_cat','dsn3',0,process);
		var income_total_ = 0;
		var expense_total_ = 0;
		for(r=1;r<=document.getElementById("record_num").value;r++)
		{
			if(document.getElementById("row_kontrol"+r).value==1)
			{
				<!---Muhasebe hesabı alt hesaplar gelirken üst hesapların yazılamaması kontrolü--->
				var account_code_value = list_getat(document.getElementById("account_code"+r).value,1,'-');
				if(account_code_value != "")
				{
					if(WrkAccountControl(account_code_value,r+"<cf_get_lang dictionary_id='58508.Satır'>:<cf_get_lang dictionary_id='52213.Muhasebe Hesabı Hesap Planında Tanımlı Değildir'>!") == 0)
					return false;
				}
				<!---Muhasebe hesabı alt hesaplar gelirken üst hesapların yazılamaması kontrolü--->
				record_exist=1;
				if (document.getElementById("expense_date"+r) != undefined && document.getElementById("expense_date"+r).value == "")
				{
					alert ("<cf_get_lang dictionary_id='49126.Satıra Lütfen Tarih Giriniz'>!");
					return false;
				}
			
				<cfif is_show_project eq 1>
					if (document.getElementById("project_id"+r) != undefined && document.getElementById("project_id"+r).value == "")
					{
						
						alert ("<cf_get_lang dictionary_id='32379.Lütfen Proje Seçiniz'>!");
						return false;
					}
				</cfif>
				if (document.getElementById("row_detail"+r).value == "")
				{
					alert ("<cf_get_lang dictionary_id='49156.Lütfen Açıklama Giriniz'>!");
					return false;
				}
				if(proc_control != 161)
				{
					x = document.getElementById("expense_center_id"+r).selectedIndex;
					if (document.getElementById("expense_center_id"+r)[x].value == "")
					{
						alert ("<cf_get_lang dictionary_id='49154.Satıra Lütfen Masraf/Gelir Merkezi Seçiniz'>!");
						return false;
					}
					if (get_process_cat.IS_ACCOUNT == 0)
					{
						if (document.getElementById("expense_item_id"+r).value == "")
						{
							alert ("<cf_get_lang dictionary_id='49131.Satıra Lütfen Bütçe Kalemi Seçiniz'>!");
							return false;
						}
					}
					<cfif ListFind(ListDeleteDuplicates(xml_order_list_rows),10)>
						if(filterNum(document.getElementById("income_total"+r).value) > 0 && filterNum(document.getElementById("expense_total"+r).value) > 0)
						{
							if(document.getElementById("authorized"+r).value != "")
							{
								alert("<cf_get_lang dictionary_id='49112.Gelir ve Gider Değerlerini Girdiğinizde Cari Hesap Seçemezsiniz'> !");
								return false;
							}
						}
					</cfif>
					if (get_process_cat.IS_ACCOUNT == 1)
					{
						if (document.getElementById("account_code"+r).value == "")
						{
							alert ("<cf_get_lang dictionary_id='49133.Lütfen Muhasebe Kodu Seçiniz'>!");
							return false;
						}
					}
				}
				else
				{
					if ((document.getElementById("expense_item_id"+r).value == "" || document.getElementById("expense_item_name"+r).value == "") && document.getElementById("authorized"+r).value == '' && document.getElementById("account_code"+r).value == '')
					{
						alert ("<cf_get_lang dictionary_id='59037.Bütçe Kalemi, Cari Hesap veya Muhasebe Kodu Seçmelisiniz'>!");
						return false;
					}
					if ((document.getElementById("expense_item_id"+r).value != "" && document.getElementById("expense_item_name"+r).value != ""))
					{
						x = document.getElementById("expense_center_id"+r).selectedIndex;
						if (document.getElementById("expense_center_id"+r)[x].value == "")
						{
							alert ("<cf_get_lang dictionary_id='49154.Satıra Lütfen Masraf/Gelir Merkezi Seçiniz'>!");
							return false;
						}
					}
					if(filterNum(document.getElementById("income_total"+r).value) > 0 && filterNum(document.getElementById("expense_total"+r).value) > 0)
					{
						alert("<cf_get_lang dictionary_id='59043.Tahakkuk Fişi İçin Gelir ve Gider Değerlerini Aynı Anda Giremezsiniz'>!");
						return false;
					}
					if(document.getElementById("account_code"+r).value != '')
					{
						income_total_ = parseFloat(income_total_ + parseFloat(filterNum(document.getElementById("income_total"+r).value)));
						expense_total_ = parseFloat(expense_total_ + parseFloat(filterNum(document.getElementById("expense_total"+r).value)));
					}
				}
			}
		}
		if(document.getElementById("paper_number").value == "")
		{
			alert("<cf_get_lang dictionary_id='49122.Lütfen Belge No Giriniz'> !");
			return false;
		}
		if (record_exist == 0)
		{
			alert("<cf_get_lang dictionary_id='49152.Lütfen Plan Giriniz'>!");
			return false;
		}
		<cfif is_kontrol_value eq 1>
			if(proc_control == 161)
			{
				if(filterNum(document.getElementById("income_total_amount").value) != filterNum(document.getElementById("expense_total_amount").value))
				{
					alert("<cf_get_lang dictionary_id='59044.Tahakkuk Fişi İçin Gelir ve Gider Değer Toplamları Eşit Olmalı'>!");
					return false;
				}
			}
		</cfif>
		if(proc_control == 161 && get_process_cat.IS_ACCOUNT != 0)
		{
			if(commaSplit(income_total_) != commaSplit(expense_total_))
			{
				alert("<cf_get_lang no='100.Muhasebe Hesabı Seçilen Satırların Gelir Gider Toplamları Eşit Olmalı'>!");
				return false;
			}
		}
		<cfif isdefined("attributes.demand_id") and len(attributes.demand_id)>		
			$('.ui-cfmodal__alert .required_list li').remove();
			if(filterNum(document.getElementById("income_total_amount").value) == filterNum(document.getElementById("expense_total_amount").value))
			{			
				$('.ui-cfmodal__alert .required_list').append('Gelir ve Gider Değer Toplamları Eşit');	
				$('.ui-cfmodal__alert').fadeIn();
				return false;		
			}	
		</cfif>	
		return (process_cat_control() && unformat_fields());
		return true;
	}
	
	function cancel() {
		   $('.ui-cfmodal__alert').fadeOut();
		   return false;		
	}
	
	function unformat_fields()
	{
		for(rm=1;rm<=document.getElementById("record_num").value;rm++)
		{
			document.getElementById("income_total"+rm).value =  filterNum(document.getElementById("income_total"+rm).value);
			document.getElementById("other_income_total"+rm).value =  filterNum(document.getElementById("other_income_total"+rm).value);
			document.getElementById("expense_total"+rm).value =  filterNum(document.getElementById("expense_total"+rm).value);
			if(document.getElementById("other_expense_total"+rm) != undefined)
				document.getElementById("other_expense_total"+rm).value =  filterNum(document.getElementById("other_expense_total"+rm).value);
			if(document.getElementById("diff_total"+rm) != undefined)
				document.getElementById("diff_total"+rm).value =  filterNum(document.getElementById("diff_total"+rm).value);
			if(document.getElementById("other_diff_total"+rm) != undefined)
				document.getElementById("other_diff_total"+rm).value =  filterNum(document.getElementById("other_diff_total"+rm).value);
		}

		document.getElementById("income_total_amount").value = filterNum(document.getElementById("income_total_amount").value);
		document.getElementById("expense_total_amount").value = filterNum(document.getElementById("expense_total_amount").value);
		document.getElementById("diff_total_amount").value = filterNum(document.getElementById("diff_total_amount").value);
		document.getElementById("other_income_total_amount").value = filterNum(document.getElementById("other_income_total_amount").value);
		document.getElementById("other_expense_total_amount").value = filterNum(document.getElementById("other_expense_total_amount").value);
		document.getElementById("other_diff_total_amount").value = filterNum(document.getElementById("other_diff_total_amount").value);
		for(st=1;st<=document.getElementById("kur_say").value;st++)
		{
			document.getElementById("txt_rate2_"+ st).value = filterNum(document.getElementById("txt_rate2_" + st).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
			document.getElementById("txt_rate1_"+ st).value = filterNum(document.getElementById("txt_rate1_"+ st).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
		}
	}
	function change_date_info()
	{
		if(document.getElementById("temp_date").value != '')
			for(tt=1;tt<=document.getElementById("record_num").value;tt++)
				if(document.getElementById("row_kontrol"+tt).value==1)
					document.getElementById("expense_date"+tt).value = document.getElementById("temp_date").value;
	}
	function pencere_ac_project(no)
	{
		openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_projects&project_id=add_budget_plan.project_id' + no +'&project_head=add_budget_plan.project_head' + no +'');
	}
	function autocomp_project(no)
	{
		AutoComplete_Create("project_head"+no,"PROJECT_HEAD","PROJECT_HEAD","get_project","","PROJECT_ID","project_id"+no,"",3,200);
	}
	function pencere_ac_assetp(no)
	{
		adres = '<cfoutput>#request.self#</cfoutput>?fuseaction=assetcare.popup_list_assetps';
		adres += '&field_id=all.assetp_id' + no +'&field_name=all.assetp_name' + no +'&event_id=0&motorized_vehicle=0';
		openBoxDraggable(adres);
	}
	function autocomp_assetp(no)
	{
		AutoComplete_Create("assetp_name"+no,"ASSETP","ASSETP","get_assetp_autocomplete","","ASSETP_ID","assetp_id"+no,"",3,200);
	}
	function autocomp_acc_code(no)
	{
		AutoComplete_Create("account_code"+no,"ACCOUNT_CODE,ACCOUNT_NAME","ACCOUNT_CODE,ACCOUNT_NAME","get_account_code","","ACCOUNT_CODE","account_id"+no,"",3,225);
	}
	function autocomp_budget(no)
	{
		AutoComplete_Create("expense_item_name"+no,"EXPENSE_ITEM_NAME","EXPENSE_ITEM_NAME","get_expense_item","","EXPENSE_ITEM_ID,ACCOUNT_CODE,ACCOUNT_CODE,EXPENSE_CAT_ID,EXPENSE_CAT_NAME","expense_item_id"+no+",account_code"+no+",account_id"+no+",expense_cat_id"+no+",expense_cat_name"+no,3,200);
	}
	function autocomp_cari(no)
	{
		<cfif xml_account_code_from_member eq 1>
			AutoComplete_Create("authorized"+no,"MEMBER_NAME","MEMBER_NAME","get_member_autocomplete","\'1,2,3\',\'\',\'\',\'\',\'\',\'\',\'\',\'1\'","MEMBER_TYPE,COMPANY_ID,CONSUMER_ID,EMPLOYEE_ID,ACCOUNT_CODE,ACCOUNT_CODE","member_type"+no+",company_id"+no+",consumer_id"+no+",employee_id"+no+",account_code"+no+",account_id"+no,"add_budget_plan",3,250);
		<cfelse>
			AutoComplete_Create("authorized"+no,"MEMBER_NAME","MEMBER_NAME","get_member_autocomplete","\'1,2,3\',\'\',\'\',\'\',\'\',\'\',\'\',\'1\'","MEMBER_TYPE,COMPANY_ID,CONSUMER_ID,EMPLOYEE_ID","member_type"+no+",company_id"+no+",consumer_id"+no+",employee_id"+no,3,250);
		</cfif>
	}
	toplam_hesapla();
	toplam_doviz_hesapla();
	document.getElementById('budget_file').style.marginLeft=screen.width-360;
	var is_show_project = <cfoutput>#is_show_project#</cfoutput>;
</script>
<cfif isdefined("attributes.is_from_file")><!---  Dosya importtan gelmişse satırlar eklenecek --->
	<cfinclude template="../query/get_budget_row_from_file.cfm">
</cfif>