<cf_xml_page_edit fuseact="ch.popup_form_add_debit_claim_note">
<cf_get_lang_set module_name="ch">
<cfparam name="attributes.process_cat" default="">
<cfparam name="attributes.action_type_id" default="">
<cfparam name="attributes.to_employee_id" default="">
<cfparam name="attributes.acc_type_id" default="">
<cfparam name="attributes.from_employee_id" default="">
<cfparam name="attributes.to_cmp_id" default="">
<cfparam name="attributes.to_consumer_id" default="">
<cfparam name="attributes.from_cmp_id" default="">
<cfparam name="attributes.from_consumer_id" default="">
<cfparam name="attributes.action_value" default="">
<cfparam name="attributes.other_cash_act_value" default="">
<cfparam name="attributes.action_currency_id" default="#session.ep.money#">
<cfparam name="attributes.acc_branch_id" default="">
<cfparam name="attributes.acc_department_id" default="">
<cfparam name="attributes.project_id" default="">
<cfparam name="attributes.assetp_id" default="">
<cfparam name="attributes.action_date" default="#now()#">
<cfparam name="attributes.contract_id" default="">
<cfparam name="attributes.action_account_code" default="">
<cfparam name="attributes.action_detail" default="">
<cfset getActivity = createobject("component","workdata.get_activity_types").getActivity()>
<cfquery name="GET_MONEY_RATE" datasource="#DSN2#">
	SELECT MONEY_ID,MONEY FROM SETUP_MONEY WHERE MONEY_STATUS = 1 ORDER BY MONEY_ID
</cfquery>
<cfif isdefined("attributes.id") and len(attributes.id)>
	<cfquery name="GET_NOTE" datasource="#DSN2#">
		SELECT 
			* 
		FROM 
			CARI_ACTIONS 
		WHERE 
			ACTION_ID = #attributes.id#
	</cfquery>
		<cfquery name="GET_COST_WITH_EXPENSE_ROWS_ID" datasource="#dsn2#">
			SELECT * FROM EXPENSE_ITEMS_ROWS WHERE ACTION_ID = #URL.ID# AND EXPENSE_COST_TYPE = #get_note.action_type_id#
		</cfquery>
		<cfif len(get_cost_with_expense_rows_id.expense_center_id)>
		  <cfquery name="GET_EXPENSE" datasource="#dsn2#">
			  SELECT EXPENSE FROM EXPENSE_CENTER WHERE EXPENSE_ID = #GET_COST_WITH_EXPENSE_ROWS_ID.EXPENSE_CENTER_ID#
		  </cfquery>
		</cfif>
		<cfif len(get_cost_with_expense_rows_id.expense_item_id)>
			<cfquery name="GET_EXPENSE_ITEM" datasource="#dsn2#">
				SELECT EXPENSE_ITEM_NAME FROM EXPENSE_ITEMS WHERE EXPENSE_ITEM_ID = #GET_COST_WITH_EXPENSE_ROWS_ID.EXPENSE_ITEM_ID#
			</cfquery>
		</cfif>
    <cfset attributes.process_cat = get_note.process_cat>
	<cfset attributes.action_type_id = get_note.action_type_id>
    <cfset attributes.to_employee_id = get_note.to_employee_id>
    <cfset attributes.acc_type_id = get_note.acc_type_id>
    <cfset attributes.from_employee_id = get_note.from_employee_id>
    <cfset attributes.to_cmp_id = get_note.to_cmp_id>
    <cfset attributes.to_consumer_id = get_note.to_consumer_id>
    <cfset attributes.from_cmp_id = get_note.from_cmp_id>
    <cfset attributes.from_consumer_id = get_note.from_consumer_id>
    <cfset attributes.action_value = get_note.action_value>
    <cfset attributes.other_cash_act_value = get_note.other_cash_act_value>
	<cfset attributes.acc_branch_id = get_note.acc_branch_id>
	<cfset attributes.acc_department_id = get_note.acc_department_id>
	<cfset attributes.project_id = get_note.project_id>
	<cfset attributes.assetp_id = get_note.assetp_id>
	<cfset attributes.action_date = get_note.action_date>
	<cfset attributes.contract_id = get_note.contract_id>
	<cfset attributes.action_account_code = get_note.action_account_code>
	<cfset attributes.action_detail = get_note.action_detail>
	<cfset subscription_id = get_note.subscription_id>
    <cfif len(subscription_id)>
        <cfset subscription_no = get_subscription_no(subscription_id)>
    <cfelse>
        <cfset subscription_no = "">
    </cfif>
<cfelseif isDefined("attributes.project_id") and Len(attributes.project_id)>
	<cfquery name="get_project_info" datasource="#dsn#">
		SELECT COMPANY_ID,PARTNER_ID,CONSUMER_ID FROM PRO_PROJECTS WHERE PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
	</cfquery>
	<cfif len(get_project_info.partner_id)>
		<cfset attributes.to_cmp_id = get_project_info.company_id>
		<cfset attributes.from_cmp_id = get_project_info.company_id>
	<cfelseif len(get_project_info.consumer_id)>
		<cfset attributes.to_consumer_id = get_project_info.consumer_id>
		<cfset attributes.to_consumer_id = get_project_info.consumer_id>
	</cfif>
<cfelse>
	<cfset subscription_id = "">
	<cfset subscription_no = "">
</cfif>
<cfif attributes.action_type_id eq 41>
	<cfset emp_id = attributes.to_employee_id>
	<cfif len(attributes.acc_type_id)>
		<cfset emp_id = "#emp_id#_#attributes.acc_type_id#">
	</cfif>
<cfelse>
	<cfset emp_id = attributes.from_employee_id>
	<cfif len(attributes.acc_type_id)>
		<cfset emp_id = "#emp_id#_#attributes.acc_type_id#">
	</cfif>
</cfif>
<cfset member_name = "">
<cfif len(attributes.from_cmp_id)>
	<cfset member_name = get_par_info(attributes.from_cmp_id,1,1,0)>
<cfelseif len(attributes.to_cmp_id)>
	<cfset member_name = get_par_info(attributes.to_cmp_id,1,1,0)>
<cfelseif len(attributes.from_consumer_id)>
	<cfset member_name = get_cons_info(attributes.from_consumer_id,0,0)>
<cfelseif len(attributes.to_consumer_id)>
	<cfset member_name = get_cons_info(attributes.to_consumer_id,0,0)>
<cfelseif len(attributes.to_employee_id)>
	<cfset member_name = get_emp_info(attributes.to_employee_id,0,0,0,attributes.acc_type_id)>
<cfelseif len(attributes.from_employee_id)>
	<cfset member_name = get_emp_info(attributes.from_employee_id,0,0,0,attributes.acc_type_id)>
</cfif>
<!---catalyst_header ekelencek.--->
<cf_catalystHeader>
<cf_papers paper_type="debit_claim">
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box>
		<cfform name="cari" method="post" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_add_debit_claim_note">
			<input type="hidden" name="active_period" id="active_period" value="<cfoutput>#session.ep.period_id#</cfoutput>">
			<input type="hidden" name="my_fuseaction" id="my_fuseaction" value="<cfoutput>#fusebox.fuseaction#</cfoutput>">
			<cf_box_elements>
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
					<div class="form-group" id="item-process_cat">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57800.işlem tipi'> *</label>
						<div class="col col-8 col-xs-12">
						<cf_workcube_process_cat process_cat=#attributes.process_cat# slct_width="180" onclick_function="ayarla_gizle_goster();">
						</div>
					</div>
					<div class="form-group" id="item-company_id">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57519.Cari Hesap'>*</label>
						<div class="col col-8 col-xs-12">
							<div class="input-group">
							<input type="hidden" name="employee_id" id="employee_id" value="<cfoutput>#emp_id#</cfoutput>">
							<input type="hidden" name="company_id" id="company_id" value="<cfif attributes.action_type_id eq 41><cfoutput>#attributes.TO_CMP_ID#</cfoutput><cfelseif attributes.ACTION_TYPE_ID eq 42><cfoutput>#attributes.from_cmp_id#</cfoutput></cfif>">
							<input type="hidden" name="consumer_id" id="consumer_id" value="<cfif attributes.action_type_id eq 41><cfoutput>#attributes.TO_CONSUMER_ID#</cfoutput><cfelseif attributes.ACTION_TYPE_ID eq 42><cfoutput>#attributes.from_consumer_id#</cfoutput></cfif>">
							<cfinput name="member_name" id="member_name" type="text" value="#member_name#" style="width:180px;" onFocus="AutoComplete_Create('member_name','MEMBER_NAME,MEMBER_CODE','MEMBER_NAME,MEMBER_CODE,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2,3\',\'\',\'\',\'\',\'2\',\'\',\'\',\'1\'','COMPANY_ID,CONSUMER_ID,EMPLOYEE_ID','company_id,consumer_id,employee_id','','3','180','get_money_info(\'cari\',\'action_date\')');">
							<span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_pars&is_cari_action=1&select_list=1,2,3,9&field_comp_id=cari.company_id&field_member_name=cari.member_name&field_name=cari.member_name&field_consumer=cari.consumer_id&field_emp_id=cari.employee_id</cfoutput>')"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-paper_number">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57880.Belge No'>*</label>
						<div class="col col-8 col-xs-12">
							<cfinput type="text" name="paper_number" id="paper_number" value="#paper_code & '-' & paper_number#" maxlength="50" style="width:180px;">
						</div>
					</div>
					<div class="form-group" id="item-ACTION_CURRENCY_ID">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57673.Tutar'> *</label>
						<div class="col col-5 col-xs-12">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='29535.Geçerli Tutar Girmelisiniz!'></cfsavecontent>
							<cfinput type="text" name="action_value" id="action_value" class="moneybox" value="#TLFormat(attributes.action_value)#" style="width:120px;" required="yes" message="#message#" onBlur="calc_kur('ACTION_CURRENCY_ID',false);" onkeyup="return(FormatCurrency(this,event));">
						</div> 
						<div class="col col-3 col-xs-6">
							<select name="ACTION_CURRENCY_ID" id="ACTION_CURRENCY_ID"  style="width:57px;" onChange="calc_kur('ACTION_CURRENCY_ID',false);">
							<cfoutput query="get_money_rate">
								<option value="#money_id#;#money#" <cfif attributes.action_currency_id is money>selected</cfif>>#money#</option>
							</cfoutput>
							</select> 
						</div>
					</div>
					<div class="form-group" id="item-other_cash_act_value">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='30635.Döviz Tutar'></label>
						<div class="col col-8 col-xs-12">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='50074.Döviz Cinsi Girmelisiniz'> !</cfsavecontent>
							<cfinput type="text" name="other_cash_act_value" class="moneybox" style="width:180px;" value="#TLFormat(attributes.other_cash_act_value)#" required="yes" message="#message#" onBlur="calc_kur('ACTION_CURRENCY_ID',true);" onkeyup="return(FormatCurrency(this,event));">
						</div>
					</div>	
					<div class="form-group" id="item-action_date">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57879.İşlem Tarihi'></label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<cfsavecontent variable="message"><cf_get_lang dictionary_id='57906.İşlem Tarihi Girmelisiniz'></cfsavecontent>
									<cfinput type="text" name="action_date" id="action_date" maxlength="10" value="#dateformat(attributes.action_date,dateformat_style)#" validate="#validate_style#" required="yes" message="#message#" style="width:65px;" onBlur="change_money_info('cari','action_date');">
									<span class="input-group-addon"><cf_wrk_date_image date_field="action_date" call_function="change_money_info"></span>
								</div>
							</div>
					</div>			
				</div>
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
					<div class="form-group" id="item-acc_branch_id">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57453.Şube'></label>
						<div class="col col-8 col-xs-12">
						<cf_wrkDepartmentBranch fieldId='acc_branch_id' is_branch='1' is_deny_control='0' selected_value='#attributes.ACC_BRANCH_ID#'>
						</div>
					</div>
					<div class="form-group" id="item-acc_department_id">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57572.Departman'></label>
						<div class="col col-8 col-xs-12">
						<cf_wrkDepartmentBranch fieldId='acc_department_id' is_department='1' is_deny_control='0' selected_value='#attributes.ACC_DEPARTMENT_ID#'>
						</div>
					</div>
					<div class="form-group" id="item-project_name">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57416.Proje'></label>
						<div class="col col-8 col-xs-12">
							<div class="input-group">
                                <input type="hidden" name="project_id" id="project_id" value="<cfoutput>#attributes.project_id#</cfoutput>">
                                <input type="text" name="project_name" id="project_name" style="width:100px;" onFocus="AutoComplete_Create('project_head','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','list_works','3','250');">
                                <span class="input-group-addon icon-ellipsis btnPointer" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_projects&project_head=list_works.project_name&project_id=cari.project_id</cfoutput>');" title="<cf_get_lang dictionary_id='58797.Proje Seiniz'>" ></span>
                            </div>
						</div>
					</div>
					<div class="form-group" id="item-subscription_id">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='29502.Abone No'></label>
						<div class="col col-8 col-xs-12">
							<cf_wrk_subscriptions fieldId='subscription_id' fieldName='subscription_no' form_name='cari' subscription_id='#subscription_id#' subscription_no='#subscription_no#'>
						</div>
					</div>
					<cfif session.ep.our_company_info.asset_followup eq 1>
						<div class="form-group" id="item-asset_id">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58833.Fiziki Varlık'></label>
							<div class="col col-8 col-xs-12">
								<cf_wrkAssetp asset_id="#attributes.assetp_id#" fieldId='asset_id' fieldName='asset_name' form_name='cari' width='180'>
							</div>
						</div>
					</cfif>
					<div class="form-group" id="item-contract_id">
						<label class="col col-4 col-xs12"><cf_get_lang dictionary_id='29522.Sözleşme'></label>
						<div class="col col-8 col-xs-12">
							<div class="input-group">
								<cfif len(attributes.contract_id)>
									<cfquery name="getContract" datasource="#dsn3#">
										SELECT CONTRACT_HEAD FROM RELATED_CONTRACT WHERE CONTRACT_ID = #attributes.contract_id#
									</cfquery>
								</cfif>
								<input type="hidden" name="contract_id" id="contract_id" value="<cfif len(attributes.contract_id)><cfoutput>#attributes.contract_id#</cfoutput></cfif>"> 
								<input type="text" name="contract_no" id="contract_no" value="<cfif len(attributes.contract_id)><cfoutput>#getContract.contract_head#</cfoutput></cfif>" style="width:180px;">
								<span class="input-group-addon icon-ellipsis btnPointer" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_contract&event=list&field_id=cari.contract_id&field_name=cari.contract_no'</cfoutput>)"></span>
							</div>
						</div>
					</div>					
				</div>
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
					<div class="form-group" id="item-action_account_code">
						<label class="col col-4 col-xs12"><cf_get_lang dictionary_id='58811.Muhasebe Kodu'></label>
						<div class="col col-8 col-xs-12">
							<div class="input-group">
								<cfoutput>
									<cf_wrk_account_codes form_name='cari' account_code='action_account_code'>
									<cfinput message="#message#" type="text" name="action_account_code" id="action_account_code" value="#attributes.action_account_code#" style="width:180px;" onFocus="AutoComplete_Create('action_account_code','ACCOUNT_CODE,ACCOUNT_NAME','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','0','','','','3','225');" >
									<span class="input-group-addon icon-ellipsis btnPointer" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_account_plan&field_id=cari.action_account_code')"></span>
								</cfoutput>
							</div>
						</div>
					</div>									
					<div class="form-group" id="merkez_alacak" style="display:none">
						<label class="col col-4 col-xs12"><cf_get_lang dictionary_id='58172.Gelir Merkezi'></label>
						<div class="col col-8 col-xs-12">
							<div class="input-group">
								<cfif isDefined("get_cost_with_expense_rows_id.expense_center_id") and len(get_cost_with_expense_rows_id.expense_center_id)>
									<input name="expense_center_id_1" id="expense_center_id_1" type="hidden" value="<cfoutput>#get_cost_with_expense_rows_id.expense_center_id#</cfoutput>">
									<cfinput name="expense_center_1" id="expense_center_1"  style="width:180px;"  type="text" value="#get_expense.expense#">
								<cfelse>
									<input name="expense_center_id_1" id="expense_center_id_1" type="hidden" value="">
									<cfinput name="expense_center_1" id="expense_center_1" style="width:180px;"  type="text" value="">
								</cfif>
								<span class="input-group-addon icon-ellipsis btnPointer" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_expense_center&field_name=cari.expense_center_1&field_id=cari.expense_center_id_1&is_invoice=1</cfoutput>');"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="kalem_alacak" style="display:none">
						<label class="col col-4 col-xs12"><cf_get_lang dictionary_id='58173.Gelir Kalemi'></label>
						<div class="col col-8 col-xs-12">
							<div class="input-group">
								<cfif isDefined("get_cost_with_expense_rows_id.expense_item_id") and  len(get_cost_with_expense_rows_id.expense_item_id)>
									<input type="hidden" name="expense_item_id_1" id="expense_item_id_1" value="<cfoutput>#get_cost_with_expense_rows_id.expense_item_id#</cfoutput>">
									<cfinput type="text" name="expense_item_name_1" id="expense_item_name_1" value="#get_expense_item.expense_item_name#" style="width:180px;">
								<cfelse>
									<input type="hidden" name="expense_item_id_1" id="expense_item_id_1" value="">
									<cfinput type="text" name="expense_item_name_1" id="expense_item_name_1" value="" style="width:180px;">
								</cfif>
								<span class="input-group-addon icon-ellipsis btnPointer" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_exp_item&event=list&field_id=cari.expense_item_id_1&field_name=cari.expense_item_name_1&is_income=1');"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="merkez_borc" style="display:none">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58460.Masraf Merkezi'></label>
						<div class="col col-8 col-xs-12">
							<div class="input-group">
								<cfif isDefined("get_cost_with_expense_rows_id.expense_center_id") and len(get_cost_with_expense_rows_id.expense_center_id)>
									<input name="expense_center_id_2" id="expense_center_id_2" type="hidden" value="<cfoutput>#get_cost_with_expense_rows_id.expense_center_id#</cfoutput>">
									<cfinput name="expense_center_2" id="expense_center_2" style="width:180px;"  type="text" value="#get_expense.expense#">
								<cfelse>
									<input name="expense_center_id_2" id="expense_center_id_2" type="hidden" value="">
									<cfinput name="expense_center_2" id="expense_center_2" style="width:180px;"  type="text" value="">
								</cfif>
								<span class="input-group-addon icon-ellipsis btnPointer" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_expense_center&field_name=cari.expense_center_2&field_id=cari.expense_center_id_2&is_invoice=1</cfoutput>');"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="kalem_borc" style="display:none">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58551.Gider Kalemi'></label>
						<div class="col col-8 col-xs-12">
							<div class="input-group">
								<cfif isDefined("get_cost_with_expense_rows_id.expense_item_id") and len(get_cost_with_expense_rows_id.expense_item_id)>
									<input type="hidden" name="expense_item_id_2" id="expense_item_id_2" value="<cfoutput>#get_cost_with_expense_rows_id.expense_item_id#</cfoutput>">
									<cfinput type="text" name="expense_item_name_2" id="expense_item_name_2" value="#get_expense_item.expense_item_name#" style="width:180px;">
								<cfelse>
									<input type="hidden" name="expense_item_id_2" id="expense_item_id_2" value="">
									<cfinput type="text" name="expense_item_name_2" id="expense_item_name_2" value="" style="width:180px;">
								</cfif>
								<span class="input-group-addon icon-ellipsis btnPointer" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_exp_item&event=list&field_id=cari.expense_item_id_2&field_name=cari.expense_item_name_2');"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-activity_id">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ="49184.Aktivite tipi"></label>
						<div class="col col-8 col-xs-12">
							<select name="activity_id" id="activity_id">
								<option value=""><cf_get_lang dictionary_id ="57734.Aktivite tipi"></option>
								<cfoutput  query="getActivity">
									<option value="#activity_id#">#activity_name#</option>
								</cfoutput>
							</select>
						</div>
					</div>
					<div class="form-group" id="item-action_detail">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
						<div class="col col-8 col-xs-12">
							<cftextarea name="action_detail" style="width:180px;height:50px;" value="#attributes.ACTION_DETAIL#"/>
						</div>
					</div>
					<div class="form-group" id="tr_system_price" style="display:none;">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="32742.Sistem Tutarı"> *</label>
						<div class="col col-8 col-xs-12" id="td_system_price">
							<cfoutput>#session.ep.money#</cfoutput>
						</div>
					</div>
				</div>
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="4" sort="true">
					<div class="form-group">
						<label class="col col-12 bolt"><cf_get_lang dictionary_id='49891.Döviz Birimi'></label>
					</div>
					<div class="form-group">
						<div class="col col-12 scrollContent scroll-x3">
							<cfif isdefined("get_note")>
								<cfscript>f_kur_ekle(action_id:attributes.id,process_type:1,base_value:'action_value',other_money_value:'other_cash_act_value',form_name:'cari',action_table_name:'CARI_ACTION_MONEY',action_table_dsn:'#dsn2#',select_input:'ACTION_CURRENCY_ID');</cfscript>
							<cfelse>
								<cfscript>f_kur_ekle(process_type:0,base_value:'action_value',other_money_value:'other_cash_act_value',form_name:'cari',select_input:'ACTION_CURRENCY_ID');</cfscript>
							</cfif>
						</div>
					</div>
				</div> 
			</cf_box_elements>
			<cf_box_footer>	<!---/// footer alanı record info ve submit butonu--->
				<cf_workcube_buttons type_format='1' is_upd='0' add_function='kontrol_()'><!---///butonlar--->
			</cf_box_footer>
		</cfform>
	</cf_box>
</div>
<script type="text/javascript">
	calc_kur('ACTION_CURRENCY_ID',false);
	if(document.cari.process_cat.options[document.cari.process_cat.selectedIndex].value)
		ayarla_gizle_goster();
		
	function calc_kur(input_,doviz_tutar_)
	{
		if(document.cari.process_cat.options[document.cari.process_cat.selectedIndex].value)
		{
			var selected_ptype = document.cari.process_cat.options[document.cari.process_cat.selectedIndex].value;
			str1_ = "SELECT IS_PROCESS_CURRENCY FROM SETUP_PROCESS_CAT WHERE PROCESS_CAT_ID = '"+ selected_ptype +"'";
			var get_is_process_currency = wrk_query(str1_,'dsn3');
			
			if(get_is_process_currency.IS_PROCESS_CURRENCY == 1)
				kur_ekle_f_hesapla(input_,doviz_tutar_,1);
			else
				kur_ekle_f_hesapla(input_,doviz_tutar_,0);	
		}
		else
			kur_ekle_f_hesapla(input_,doviz_tutar_,0);	
	}
	
	function kontrol_()
	{
		<!---Muhasebe hesabı alt hesaplar gelirken üst hesapların yazılamaması kontrolü--->
		var action_account_code = document.getElementById("action_account_code").value;
		if(action_account_code != "")
		{ 
			if(WrkAccountControl(action_account_code, '<cf_get_lang dictionary_id='52213.Muhasebe Hesabı Hesap Planında Tanımlı Değildir!'>') == 0)
			return false;
		}
		if(document.cari.process_cat.options[document.cari.process_cat.selectedIndex].value)
		{
			var selected_ptype = document.cari.process_cat.options[document.cari.process_cat.selectedIndex].value;
			eval('var proc_control = document.cari.ct_process_type_'+selected_ptype+'.value');
		}
		paper_control(document.cari.paper_number,'DEBIT_CLAIM');
		if(!chk_period(document.cari.action_date,'İşlem')) return false;
		if(!chk_process_cat('cari')) return false;
		if(!check_display_files('cari')) return false;
		if(document.cari.company_id.value=="" && document.cari.employee_id.value=="" && document.cari.consumer_id.value=="")
		{
			alert("<cf_get_lang dictionary_id='57471.Eksik veri'> : <cf_get_lang dictionary_id='57519.Cari Hesap'> <cf_get_lang dictionary_id='57998.veya'> <cf_get_lang dictionary_id='48715.Çalışan Hesap'>");
			return false;
		}
		if(proc_control == 42)
		{
			if( (cari.expense_center_id_2.value=="" && cari.expense_item_id_2.value != "" && cari.expense_item_name_2.value != "") || (cari.expense_center_id_2.value!="" && cari.expense_center_2.value!="" && cari.expense_item_id_2.value == "") || (cari.expense_center_2.value=="" && cari.expense_item_name_2.value != "") || (cari.expense_center_2.value!="" && cari.expense_item_name_2.value == "") )
			{
				alert("<cf_get_lang dictionary_id='57471.Eksik veri'> : <cf_get_lang dictionary_id='58460.Masraf Merkezi'> <cf_get_lang dictionary_id='57989.ve'> <cf_get_lang dictionary_id='58551.Gider Kalemi'>");
				return false;
			}
		}
		else
		{
			if( (cari.expense_center_id_1.value=="" && cari.expense_item_id_1.value != "" && cari.expense_item_name_1.value != "") || (cari.expense_center_id_1.value!="" && cari.expense_center_1.value!="" && cari.expense_item_id_1.value == "") || (cari.expense_center_1.value=="" && cari.expense_item_name_1.value != "") || (cari.expense_center_1.value!="" && cari.expense_item_name_1.value == "") )
			{
				alert("<cf_get_lang dictionary_id='57471.Eksik veri'> : <cf_get_lang dictionary_id='58172.Gelir Merkezi'> <cf_get_lang dictionary_id='57989.ve'> <cf_get_lang dictionary_id='58173.Gelir Kalemi'>");
				return false;
			}
		}
		process=document.cari.process_cat.value;
		var get_process_cat = wrk_safe_query('ch_get_process_cat','dsn3',0,process);
		if(get_process_cat.IS_ACCOUNT == 1)
		{
			if (document.cari.action_account_code.value=="")
			{ 
				alert ("<cf_get_lang dictionary_id='35394.Muhasebe Kodu Seçiniz'>!");
				return false;
			}
			var get_account_code = wrk_safe_query('ch_get_account_code','dsn2',0,document.cari.action_account_code.value);
			if(get_account_code.recordcount == 0)
			{
				alert("<cf_get_lang dictionary_id='50177.Muhasebe Kodunu kontrol ediniz'>");
				return false;
			}
		}		
		//sysytem amount kontrolu
		if(document.getElementById("system_amount") != undefined && document.getElementById("system_amount").value == '')
		{
			alert("<cf_get_lang dictionary_id='59079.Sistem Tutarı Girmelisiniz'>!");
			return false;
		}
		return true;
	}
	function get_expense()
	{
		<cfif isdefined("x_expense_show") and x_expense_show eq 1>
			var selected_ptype_ = document.cari.process_cat.options[document.cari.process_cat.selectedIndex].value;
			if(selected_ptype_ != '')
			{
				eval('var proc_control_ = document.cari.ct_process_type_'+selected_ptype_+'.value');
				if(proc_control_ == 42 && document.cari.employee_id.value!='' && document.cari.member_name.value!='')
				{
					employee_id_ = document.cari.employee_id.value;
					period_id = document.cari.active_period.value;
					var listParam = period_id + "*" + employee_id_;
					var get_expense_center = wrk_safe_query('ch_get_expense_center','dsn',0,listParam);
					if(get_expense_center.recordcount)
					{
						document.cari.expense_center_id_2.value = get_expense_center.EXPENSE_CENTER_ID;
						document.cari.expense_item_id_2.value = get_expense_center.EXPENSE_ITEM_ID;
						document.cari.expense_center_2.value = get_expense_center.EXPENSE_CODE_NAME;
						document.cari.expense_item_name_2.value = get_expense_center.EXPENSE_ITEM_NAME;
					}
					else
					{
						document.cari.expense_center_id_2.value = '';
						document.cari.expense_item_id_2.value = '';
						document.cari.expense_center_2.value = '';
						document.cari.expense_item_name_2.value = '';
					}
				}
				if (proc_control_ == 41 && document.cari.employee_id.value!='' && document.cari.member_name.value!='')
				{
					employee_id_ = document.cari.employee_id.value;
					period_id = document.cari.active_period.value;
					var listParam = period_id + "*" + employee_id_;
					var get_expense_center = wrk_safe_query('ch_get_expense_center','dsn',0,listParam);
					if(get_expense_center.recordcount)
					{
						document.cari.expense_center_id_1.value = get_expense_center.EXPENSE_CENTER_ID;
						document.cari.expense_item_id_1.value = get_expense_center.EXPENSE_ITEM_ID;
						document.cari.expense_center_1.value = get_expense_center.EXPENSE_CODE_NAME;
						document.cari.expense_item_name_1.value = get_expense_center.EXPENSE_ITEM_NAME;
					}
					else
					{
						document.cari.expense_center_id_1.value = '';
						document.cari.expense_item_id_1.value = '';
						document.cari.expense_center_1.value = '';
						document.cari.expense_item_name_1.value = '';
					}
				}
			}
		</cfif>	
	}
	function ayarla_gizle_goster()
	{
		if(document.cari.process_cat.options[document.cari.process_cat.selectedIndex].value)	
		{
			if(chk_process_cat('cari'))
			{
				var selected_ptype = document.cari.process_cat.options[document.cari.process_cat.selectedIndex].value;
				eval('var proc_control = document.cari.ct_process_type_'+selected_ptype+'.value');
				if(proc_control == 42)
				{
					merkez_borc.style.display='';
					kalem_borc.style.display='';
					merkez_alacak.style.display='none';
					kalem_alacak.style.display='none';
				}
				else
				{
					merkez_alacak.style.display='';
					kalem_alacak.style.display='';
					merkez_borc.style.display='none';
					kalem_borc.style.display='none';
				}
			}
			else
			{
				merkez_alacak.style.display='none';
				kalem_alacak.style.display='none';
				merkez_borc.style.display='none';
				kalem_borc.style.display='none';
			}
			get_expense();
		}
		else
		{
			merkez_alacak.style.display='none';
			kalem_alacak.style.display='none';
			merkez_borc.style.display='none';
			kalem_borc.style.display='none';
		}
		
		/* islem kategorilerine eklenen İşlem Dövizi Kurlarından Hesap Yapılmasın parametresi icin eklendi */
		if(document.cari.process_cat.options[document.cari.process_cat.selectedIndex].value)
		{
			var selected_ptype = document.cari.process_cat.options[document.cari.process_cat.selectedIndex].value;
			str1_ = "SELECT IS_PROCESS_CURRENCY FROM SETUP_PROCESS_CAT WHERE PROCESS_CAT_ID = '"+ selected_ptype +"'";
			var get_is_process_currency = wrk_query(str1_,'dsn3');
			
			if(get_is_process_currency.IS_PROCESS_CURRENCY == 1)
			{
				$('#tr_system_price').show();
				temp_system_val =  $('#system_amount').val();
				$('#system_amount').remove();
				$('<input>').attr({
					type: 'text',
					id: 'system_amount',
					name: 'system_amount',
					style: 'width:180px;text-align:right;',
					value: temp_system_val
				}).appendTo('#td_system_price');
			}
			else
				$('#tr_system_price').hide();
		}
		else
			$('#tr_system_price').hide();
	}
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
