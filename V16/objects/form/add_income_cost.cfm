<div style="display:none;z-index:10;" id="wizard_div"></div>
<cf_xml_page_edit fuseact="objects.income_cost">
<cf_get_lang_set module_name="objects">
<cfparam name="attributes.expense_employee" default="#session.ep.name# #session.ep.surname#">
<cfparam name="attributes.expense_employee_id" default="#session.ep.userid#">
<cfquery name="GET_ACTIVITY_TYPES" datasource="#dsn#">
	SELECT ACTIVITY_ID, ACTIVITY_NAME FROM SETUP_ACTIVITY ORDER BY ACTIVITY_NAME
</cfquery>
<cfif isdefined("attributes.expense_id") and len(attributes.expense_id)><!--- Gelir Fisi Kopyalama --->
	<cfquery name="get_money" datasource="#dsn2#">
		SELECT MONEY_TYPE AS MONEY,* FROM EXPENSE_ITEM_PLANS_MONEY WHERE ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.expense_id#">
	</cfquery>
	<cfif not get_money.recordcount>
		<cfquery name="get_money" datasource="#dsn#">
			SELECT MONEY,0 AS IS_SELECTED,* FROM SETUP_MONEY WHERE PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#"> AND MONEY_STATUS = <cfqueryparam cfsqltype="cf_sql_smallint" value="1">
		</cfquery>
	</cfif>
<cfelse>
	<cfquery name="GET_MONEY" datasource="#dsn#">
		SELECT *,0 AS IS_SELECTED FROM SETUP_MONEY WHERE PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.EP.PERIOD_ID#"> AND MONEY_STATUS = <cfqueryparam cfsqltype="cf_sql_smallint" value="1"> ORDER BY MONEY_ID
	</cfquery>
</cfif>
<cfset components2 = createObject('component','V16.workdata.get_budget_period_date')>
<cfset budget_date = components2.get_budget_period_date()>
<cfif isdefined("attributes.expense_id") and len(attributes.expense_id)><!--- Gelir Fisi Kopyalama --->
	<cfquery name="get_expense" datasource="#dsn2#">
		SELECT
			PAPER_TYPE,
			DETAIL,
			SYSTEM_RELATION,
			CH_COMPANY_ID,
			CH_CONSUMER_ID,
			CH_EMPLOYEE_ID,
			CH_PARTNER_ID,
			ACC_TYPE_ID,
			DEPARTMENT_ID,
			LOCATION_ID,
			EXPENSE_CASH_ID,
			PAYMETHOD_ID,
			EXPENSE_DATE,
			DUE_DATE,
			EMP_ID,
			IS_CASH,
			IS_BANK,
			TEVKIFAT,
			TEVKIFAT_ORAN,
			SHIP_ADDRESS_ID,
            SHIP_ADDRESS,
            BRANCH_ID,
            STOPAJ,
			ISNULL(STOPAJ_ORAN,0) STOPAJ_ORAN,
			ISNULL(STOPAJ_RATE_ID,0) STOPAJ_RATE_ID,
			ISNULL(OTV_TOTAL,0) OTV_TOTAL
		FROM
			EXPENSE_ITEM_PLANS
		WHERE
			EXPENSE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.expense_id#">
	</cfquery>
	<cfquery name="get_rows" datasource="#dsn2#"><!--- Gelir Satirlari --->
		SELECT * FROM EXPENSE_ITEMS_ROWS WHERE EXPENSE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.expense_id#"> ORDER BY EXP_ITEM_ROWS_ID
	</cfquery>
<cfelseif IsDefined("attributes.law_request_id") and len(attributes.law_request_id)>
	<cfset components = createObject('component','V16.objects.cfc.income_cost')>
	<cfset get_expense = components.getLawRequest(law_id:attributes.law_request_id)>
</cfif>
<cfif isdefined("get_expense")>
	<cfset expense_bank_id = get_expense.expense_cash_id>
	<cfset expense_branch_id = get_expense.branch_id>
<cfelse>
	<cfset expense_bank_id = ''>
	<cfset expense_branch_id = ''>
</cfif>
<cfquery name="GET_DOCUMENT_TYPE" datasource="#dsn#">
	SELECT
		SETUP_DOCUMENT_TYPE.DOCUMENT_TYPE_ID,
		SETUP_DOCUMENT_TYPE.DOCUMENT_TYPE_NAME
	FROM
		SETUP_DOCUMENT_TYPE,
		SETUP_DOCUMENT_TYPE_ROW
	WHERE
		SETUP_DOCUMENT_TYPE_ROW.DOCUMENT_TYPE_ID =  SETUP_DOCUMENT_TYPE.DOCUMENT_TYPE_ID AND
		SETUP_DOCUMENT_TYPE_ROW.FUSEACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#fuseaction#%">
	ORDER BY
		DOCUMENT_TYPE_NAME
</cfquery>
<cfinvoke 
 		component = "/workdata/get_cash" 
 		method="getComponentFunction" 
 		returnvariable="kasa">
		<cfinvokeargument name="acc_code" value="0">
		<cfinvokeargument name="cash_status" value="1">
		<cfinvokeargument name="use_period" value="#fusebox.use_period#">
</cfinvoke>

<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box>
		<div id="income_cost_file" style="margin-left:1000px; margin-top:15px; position:absolute;display:none;z-index:9999;"></div><!--- phl için eklendi --->
		<cf_papers paper_type="income_cost">
		<cfform name="add_costplan" method="post" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_add_income_cost">
			<cf_basket_form id="income_cost">
				<cf_box_elements>
					<cfinput type="hidden" name="budget_period" id="budget_period" value="#dateformat(budget_date.budget_period_date,dateformat_style)#">
					<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
						<div class="form-group" id="item-process_cat">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57800.İşlem Tipi'> *</label>
							<div class="col col-8 col-xs-12">
								<cf_workcube_process_cat slct_width="120">
							</div>
						</div>
						<div class="form-group" id="item-ch_member_type">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57519.Cari Hesap'></label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<cfif isdefined("get_expense")>
										<cfif len(get_expense.ch_company_id)>
											<cfset ch_member_type="partner">
										<cfelseif len(get_expense.ch_consumer_id)>
											<cfset ch_member_type="consumer">
										<cfelseif len(get_expense.ch_employee_id)>
											<cfset ch_member_type="employee">
										<cfelse>
											<cfset ch_member_type="">
										</cfif>
										<cfset emp_id = get_expense.ch_employee_id>
										<cfif len(get_expense.acc_type_id)>
											<cfset emp_id = "#emp_id#_#get_expense.acc_type_id#">
										</cfif>
										<cfoutput>
										<input type="hidden" name="ch_member_type" id="ch_member_type" value="#ch_member_type#">
										<input type="hidden" name="ch_company_id" id="ch_company_id" value="#get_expense.ch_company_id#">
										<input type="hidden" name="ch_partner_id" id="ch_partner_id" value="<cfif ch_member_type eq "partner">#get_expense.ch_partner_id#<cfelseif ch_member_type eq "consumer">#get_expense.ch_consumer_id#</cfif>">
										<input type="hidden" name="emp_id" id="emp_id" value="<cfif ch_member_type eq "employee">#emp_id#</cfif>">
										<input name="ch_company" type="text" id="ch_company" value="<cfif ch_member_type eq "partner">#get_par_info(get_expense.ch_company_id,1,1,0)#<cfelseif ch_member_type eq "consumer">#get_cons_info(get_expense.ch_consumer_id,2,0)#</cfif>" >
										</cfoutput>
									<cfelse>
										<input type="hidden" name="ch_member_type" id="ch_member_type">
										<input type="hidden" name="ch_company_id" id="ch_company_id">
										<input type="hidden" name="ch_partner_id" id="ch_partner_id">
										<input type="hidden" name="emp_id" id="emp_id">
										<input name="ch_company" type="text" id="ch_company" onfocus="AutoComplete_Create('ch_company','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2,3\',\'\',\'\',\'\',\'\',\'\',\'\',\'1\'','MEMBER_TYPE,COMPANY_ID,PARTNER_CODE,EMPLOYEE_ID,MEMBER_PARTNER_NAME','ch_member_type,ch_company_id,ch_partner_id,emp_id,ch_partner','','3','250','get_money_info(\'add_costplan\',\'expense_date\');');" autocomplete="off">
									</cfif>
									<span class="input-group-addon icon-ellipsis btnPointer" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&is_cari_action=1&field_id=add_costplan.ch_partner_id&field_adress_id=add_costplan.ship_address_id&field_long_address=add_costplan.adres&field_comp_name=add_costplan.ch_company&field_name=add_costplan.ch_partner&field_comp_id=add_costplan.ch_company_id&field_type=add_costplan.ch_member_type&field_emp_id=add_costplan.emp_id&field_paymethod_id=add_costplan.paymethod&field_paymethod=add_costplan.paymethod_name&field_basket_due_value=add_costplan.basket_due_value&call_function=change_due_date()<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&select_list=1,2,3,9');"></span>
								</div>
							</div>
						</div>
						<div class="form-group" id="item-ch_partner">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57578.Yetkili'></label>
							<div class="col col-8 col-xs-12">
								<input type="text" name="ch_partner" id="ch_partner" value="<cfif isdefined("get_expense")><cfif ch_member_type eq "partner"><cfoutput>#get_par_info(get_expense.ch_partner_id,0,-1,0)#</cfoutput><cfelseif ch_member_type eq "consumer"><cfoutput>#get_cons_info(get_expense.ch_consumer_id,0,0)#</cfoutput><cfelseif ch_member_type eq "employee"><cfoutput>#get_emp_info(get_expense.ch_employee_id,0,0,0,get_expense.acc_type_id)#</cfoutput></cfif></cfif>">
							</div>
						</div>
						<div class="form-group" id="item-expense_employee_id">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='33483.Tahsil Eden'> *</label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<input type="hidden" name="expense_employee_id" id="expense_employee_id" value="<cfif isdefined("get_expense") and len(get_expense.emp_id)><cfoutput>#get_expense.emp_id#</cfoutput><cfelse><cfoutput>#attributes.expense_employee_id#</cfoutput></cfif>">
									<input type="hidden" name="expense_employee_type" id="expense_employee_type" value="<cfif isdefined("get_expense")>employee</cfif>">
									<input type="text" name="expense_employee" id="expense_employee" onfocus="AutoComplete_Create('expense_employee','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID,MEMBER_TYPE','expense_employee_id,expense_employee_type','','3','135');" value="<cfif isdefined("get_expense") and len(get_expense.emp_id)><cfoutput>#get_emp_info(get_expense.emp_id,0,0)#</cfoutput><cfelse><cfoutput>#attributes.expense_employee#</cfoutput></cfif>" autocomplete="off">
									<span class="input-group-addon icon-ellipsis btnPointer" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=add_costplan.expense_employee_id&field_name=add_costplan.expense_employee&field_type=add_costplan.expense_employee_type&select_list=1,9');"></span>
								</div>
							</div>
						</div>
						<div class="form-group" id="item-ship_address_id">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58061.Cari'> <cf_get_lang dictionary_id='57453.Şube'></label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<input type="hidden" name="ship_address_id" id="ship_address_id" value="<cfif isdefined("get_expense") and len(get_expense.SHIP_ADDRESS_ID)><cfoutput>#get_expense.SHIP_ADDRESS_ID#</cfoutput></cfif>" />
									<input type="text" name="adres" id="adres" value="<cfif isdefined("get_expense") and len(get_expense.SHIP_ADDRESS)><cfoutput>#get_expense.SHIP_ADDRESS#</cfoutput></cfif>"/>
									<span class="input-group-addon icon-ellipsis btnPointer" onclick="add_adress();"></span>
								</div>
							</div>
						</div>
					</div>
					<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
						<cfif isdefined("xml_show_process_stage") and len(xml_show_process_stage) and xml_show_process_stage eq 1>
							<div class="form-group" id="item-process_stage">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58859.Süreç'></label>
								<div class="col col-8 col-xs-12">
									<cf_workcube_process is_upd='0' process_cat_width='150' is_detail='0'>
								</div>
							</div>
						</cfif> 
						<div class="form-group" id="item-serial_number">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57637.Seri No'> *</label>
							<div class="col col-4 col-xs-12">
								<input type="text" name="serial_number" id="serial_number" maxlength="5" value="<cfoutput>#paper_code#</cfoutput>">
							</div>
							<div class="col col-4 col-xs-12">
								<input type="text" name="serial_no" id="serial_no" value="<cfoutput>#paper_number#</cfoutput>" maxlength="50" onblur="paper_control(this,'INCOME_COST',true,'','','','','','',1,add_costplan.serial_number);">
							</div>
						</div>
						<div class="form-group" id="item-expense_date">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='33203.Belge Tarihi'> *</label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<input type="text" name="expense_date" id="expense_date" value="<cfif isdefined("get_expense")><cfoutput>#dateformat(get_expense.expense_date,dateformat_style)#</cfoutput><cfelse><cfoutput>#dateformat(now(),dateformat_style)#</cfoutput></cfif>" maxlength="10" style="width:115px;" onchange="change_paper_duedate();" onblur="change_money_info('add_costplan','expense_date');">
									<span class="input-group-addon"><cf_wrk_date_image date_field="expense_date" call_function="change_money_info"></span>
								</div>
							</div>
						</div>
						<div class="form-group" id="item-expense_paper_type">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58578.Belge Türü'></label>
							<div class="col col-8 col-xs-12">
								<select name="expense_paper_type" id="expense_paper_type">
									<option value=""><cf_get_lang dictionary_id='58578.Belge Türü'></option>
									<cfoutput query="get_document_type">
										<option value="#document_type_id#" <cfif isdefined("get_expense") and get_expense.paper_type eq document_type_id>selected</cfif>>#document_type_name#</option>
									</cfoutput>
								</select>
							</div>
						</div>
						<cfif IsDefined("attributes.law_request_id") and len(attributes.law_request_id)>
							<div class="form-group" id="item-law_request_no">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='50363.İcra'>-<cf_get_lang dictionary_id='53302.Dosya No'></label>
								<div class="col col-8 col-xs-12">
									<input type="hidden" name="law_request_id" id="law_request_id" value="<cfoutput>#attributes.law_request_id#</cfoutput>">
									<input type="text" name="law_request_no" id="law_request_no" value="<cfoutput>#get_expense.file_number#</cfoutput>">
								</div>
							</div>
						</cfif>
						<cfif x_select_project eq 1 or x_select_project eq 2>
						<div class="form-group" id="item-project_id">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57416.Proje'></label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<input type="hidden" name="project_id" id="project_id" value="<cfif isdefined('get_expense.project_id')><cfoutput>#get_expense.project_id#</cfoutput></cfif>">
									<input type="text" name="project_head" id="project_head" value="<cfif isdefined('get_expense.project_id') and len(get_expense.project_id)><cfoutput>#GET_PROJECT_NAME(get_expense.project_id)#</cfoutput></cfif>"  style="width:115px;" 
									onfocus="AutoComplete_Create('project_head','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','add_costplan','3','135')" autocomplete="off">
									<span class="input-group-addon icon-ellipsis btnPointer" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_projects&project_id=add_costplan.project_id&project_head=add_costplan.project_head');"></span>
								</div>
							</div>
						</div>
							<cfelse>
					
						</cfif>
					</div>
					<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
						<cfif isdefined("get_expense") and len(get_expense.paymethod_id)>
							<cfquery name="get_pay_meyhod" datasource="#dsn#">
								SELECT PAYMETHOD FROM SETUP_PAYMETHOD WHERE PAYMETHOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_expense.paymethod_id#">
							</cfquery>
						</cfif>
						<div class="form-group" id="item-paymethod">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58516.Ödeme Yöntemi'></label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<input type="hidden" name="paymethod" id="paymethod" value="<cfif isdefined("get_expense.paymethod_id")><cfoutput>#get_expense.paymethod_id#</cfoutput></cfif>">
									<input type="text" name="paymethod_name" id="paymethod_name" value="<cfif isdefined("get_expense.paymethod_id") and len(get_expense.paymethod_id)><cfoutput>#get_pay_meyhod.paymethod#</cfoutput></cfif>" onchange="change_paper_duedate2();">
									<span class="input-group-addon icon-ellipsis btnPointer" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_paymethods&field_id=add_costplan.paymethod&field_dueday=add_costplan.basket_due_value&field_name=add_costplan.paymethod_name&is_paymethods=1&function_name=change_due_date,opener.change_paper_duedate2</cfoutput>','list');" title="<cf_get_lang dictionary_id='57734.seçiniz'>"></span>
								</div>
							</div>
						</div>
						<div class="form-group" id="item-basket_due_value">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57640.Vade'></label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<cfsavecontent variable="message"><cf_get_lang dictionary_id ='33756.Vade Tarihi İçin Geçerli Bir Format Giriniz'></cfsavecontent>
										<cfif isdefined("get_expense")>
											<input name="basket_due_value" id="basket_due_value" type="text" value="<cfif len(get_expense.due_date) and len(get_expense.expense_date)><cfoutput>#datediff('d',get_expense.expense_date,get_expense.due_date)#</cfoutput></cfif>"  onchange="change_due_date();change_paper_duedate();">
											<span class="input-group-addon no-bg"></span>
											<cfinput type="text" name="basket_due_value_date_" id="basket_due_value_date_" value="#dateformat(get_expense.due_date,dateformat_style)#" onChange="change_due_date(1);" validate="#validate_style#" message="#message#" maxlength="10" readonly>
										<cfelse>
											<input name="basket_due_value" id="basket_due_value" type="text" value="" onchange="change_due_date();">
											<span class="input-group-addon no-bg"></span>
											<cfinput type="text" name="basket_due_value_date_" id="basket_due_value_date_" value="#dateformat(now(),dateformat_style)#" onChange="change_due_date(1);" validate="#validate_style#" message="#message#" maxlength="10" readonly>
										</cfif>
									<span class="input-group-addon"><cf_wrk_date_image date_field="basket_due_value_date_"></span>
								</div>
							</div>
						</div>
						<div class="form-group" id="item-system_relation">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58794.Referans No'></label>
							<div class="col col-8 col-xs-12">
								<input type="text" name="system_relation" id="system_relation" value="">
							</div>
						</div>
					</div>
					<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="4" sort="true">
						<div class="form-group" id="item-cash">
							<label class="col col-4 col-xs-12 hide"><cf_get_lang dictionary_id='58645.Nakit'></label>
							<div class="col col-8 col-xs-12">
								<input type="Checkbox" name="cash" id="cash" onclick="ayarla_gizle_goster(1);" <cfif isdefined("get_expense") and get_expense.is_cash eq 1>checked</cfif>>
							</div>
						</div>
						<div class="form-group" id="item-bank">
							<label class="col col-4 col-xs-12 hide"><cf_get_lang dictionary_id='57521.Banka'></label>
							<div class="col col-8 col-xs-12">
								<input type="Checkbox" name="bank" id="bank" onclick="ayarla_gizle_goster(2);" <cfif isdefined("get_expense") and get_expense.is_bank eq 1>checked</cfif>>
							</div>
						</div>
						<div class="form-group" id="item-banka1">
							<label class="col col-4 col-xs-12 hide"><cf_get_lang dictionary_id='57520.Kasa'> / <cf_get_lang dictionary_id='57521.Banka '></label>
							<div class="col col-8 col-xs-12">
								<div style="display:none;" id="kasa1"><cf_get_lang dictionary_id='57520.Kasa'></div>
								<div style="display:none;" id="banka1"><cf_get_lang dictionary_id='57521.Banka '></div>
									<div <cfif isdefined("get_expense") and get_expense.is_cash eq 1>style="display:'';"<cfelseif  isdefined("get_expense") and get_expense.is_cash eq 0>style="display:none;"<cfelse>style="display:none;"</cfif> id="kasa2">
									<cfif isdefined("get_expense")>									
										<cf_wrk_Cash name="kasa" acc_code="0" cash_status="1" currency_branch="0" value="#expense_bank_id#">
									<cfelse>
										<cf_wrk_Cash name="kasa" acc_code="0" cash_status="1" currency_branch="0">
									</cfif>
								</div>
								<div <cfif isdefined("get_expense") and get_expense.is_bank eq 1>style="display:'';"<cfelseif isdefined("get_expense") and get_expense.is_bank eq 0>style="display:none;"<cfelse>style="display:none;"</cfif> id="banka2">
									<cf_wrkbankaccounts width='170' control_status='1' selected_value='#expense_bank_id#'>
								</div>
							</div>
						</div>
						<cfif x_select_branch eq 1 and session.ep.isBranchAuthorization eq 1>
							<div class="form-group" id="item-branch_id">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57453.Şube'></label>
								<div class="col col-8 col-xs-12">
									<cf_wrkdepartmentbranch fieldid='branch_id' is_branch='1' width='170' is_default='1' is_deny_control='1' selected_value='#expense_branch_id#'>
								</div>
							</div>
						</cfif>
						<div class="form-group" id="item-detail">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
							<div class="col col-8 col-xs-12">
								<textarea name="detail" id="detail" style="width:140px;height:45px;"><cfif isdefined("get_expense.detail")><cfoutput>#get_expense.detail#</cfoutput></cfif></textarea>
							</div>
						</div>
						<div id="hidden_fields" style="display:none;"></div>
					</div>
				</cf_box_elements>
				<cf_box_footer>
					<cf_workcube_buttons is_upd='0' add_function='kontrol()'>
				</cf_box_footer>
			</cf_basket_form>
			<cf_basket id="income_cost_bask">
				<div id="cc" style="width:100%; height:100%; overflow:auto; position:relative;">
					<cfset x_row_project_priority_from_product = 0><!--- Satırda Proje Seçilmeden Ürün Seçilemesin --->
					<cfset x_is_add_position_to_asset_list = 0><!--- Varlık Sorumlusu Harcama Yapan Olsun --->
					<cfset x_row_workgroup_project = 0><!--- Satırda Proje Seçilince İş Grubu Otomatik Gelsin --->
					<cfset x_is_project_select = 1><!--- Satırda Ürün Varken Proje Değiştirilebilsin --->
					<cfset x_row_copy_product_info = 1><!--- Satır Kopyalanırken Ürün Bilgileri Taşınsın --->
					<cfset x_row_copy_asset_info = 1><!--- Satır Kopyalanırken Fiziki Varlık Bilgileri Taşınsın --->
					<cfset is_income = 1><!--- Gider/Gelir Kalemi Belirlenir. --->
					<cfinclude template="../display/list_plan_rows_cost.cfm">
				</div>
			</cf_basket>
			<cfoutput>
				<div class="ui-row">
					<div id="sepetim_total" class="padding-0">
						<div class="col col-3 col-sm-6 col-xs-12">
							<div class="totalBox">
								<div class="totalBoxHead font-grey-mint">
									<span class="headText"><cf_get_lang dictionary_id='57677.Dövizler'></span>
									<div class="collapse">
										<span class="icon-minus"></span>
									</div>
								</div>
								<div class="totalBoxBody">
									<table>
										<cfquery name="get_standart_process_money" datasource="#dsn#"><!--- muhasebe doneminden standart islem dövizini alıyor --->
											SELECT * FROM SETUP_PERIOD WHERE PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">
										</cfquery>
										<cfif IsQuery(get_standart_process_money) and len(get_standart_process_money.STANDART_PROCESS_MONEY)><!--- muhasebe doneminden standart islem dövizi işlemleri için --->
											<cfset default_basket_money_=get_standart_process_money.STANDART_PROCESS_MONEY>
										<cfelseif len(session.ep.money2)>
											<cfset default_basket_money_=session.ep.money2>
										<cfelse>
											<cfset default_basket_money_=session.ep.money>
										</cfif>
										<input type="hidden" name="kur_say" id="kur_say" value="#get_money.recordcount#">
										<cfset str_money_bskt_found = true>
										<cfloop query="get_money">
											<cfif IS_SELECTED>
												<cfset str_money_bskt = money>
												<cfset str_money_bskt_found = false>
											<cfelseif str_money_bskt_found and money eq default_basket_money_>
												<cfset str_money_bskt = money>
												<cfset str_money_bskt_found = false>
											</cfif>
												<tr>
													<div class="col col-4">
														<td>
															<input type="hidden" name="hidden_rd_money_#currentrow#" id="hidden_rd_money_#currentrow#" value="#money#">
															<input type="hidden" name="txt_rate1_#currentrow#" id="txt_rate1_#currentrow#" value="#rate1#">
															<div class="form-group">
																<input type="radio" name="rd_money" id="rd_money" value="#money#,#currentrow#,#rate1#,#rate2#" onclick="other_calc();" <cfif isDefined('str_money_bskt') and str_money_bskt eq money>checked</cfif>>#money#
															</div>
														</td>
													</div>
													<cfif session.ep.rate_valid eq 1>
														<cfset readonly_info = "yes">
													<cfelse>
														<cfset readonly_info = "no">
													</cfif>
													<div class="col col-2">
														<div class="form-group">
															<td>#TLFormat(rate1,0)#/</td>
														</div>
													</div>
													<div class="col col-6">
														<td>
															<div class="form-group">
																<input type="text" name="txt_rate2_#currentrow#" id="txt_rate2_#currentrow#" <cfif readonly_info>readonly</cfif> class="moneybox" <cfif money eq session.ep.money>readonly="yes"</cfif> value="#TLFormat(rate2,session.ep.our_company_info.rate_round_num)#" onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.rate_round_num#));" onblur="other_calc();">
															</div>
														</td>
													</div>
												</tr>
										</cfloop>
									</table>
								</div>
							</div>
						</div>
						<div class="col col-3 col-sm-6 col-xs-12">
							<div class="totalBox">
								<div class="totalBoxBody">
									<div class="totalBoxHead font-grey-mint">
										<span class="headText"><cf_get_lang dictionary_id='57492.Toplam'></span>
										<div class="collapse">
											<span class="icon-minus"></span>
										</div>
									</div>
									<div class="totalBoxBody">
										<table>
											<div class="col col-12">
												<div class="form-group">
													<label class="col col-3 col-xs-12 txtbold">
														<cf_get_lang dictionary_id='57492.Toplam'>
													</label>
													<div class="col col-8 col-xs-12">
														<input type="text" name="total_amount" id="total_amount" class="moneybox" readonly="" value="0">
													</div>
													<label class="col col-1 col-xs-12">
														#session.ep.money#
													</label>
												</div>
											</div>
											<div class="col col-12">
												<div class="form-group">
													<label class="col col-3 col-xs-12 txtbold">
														<cf_get_lang dictionary_id='33213.Toplam KDV'>
													</label>
													<div class="col col-8 col-xs-12">
														<input type="text" name="kdv_total_amount" id="kdv_total_amount" class="moneybox" readonly="" value="0">
													</div>
													<label class="col col-1 col-xs-12">
														#session.ep.money#
													</label>
												</div>
											</div>
											<div class="col col-12">
												<div class="form-group">
													<label class="col col-3 col-xs-12 txtbold">
														<cf_get_lang dictionary_id='57492.Toplam'> <cf_get_lang dictionary_id='58021.ÖTV'>
													</label>
													<div class="col col-8 col-xs-12">
														<input type="text" name="otv_total_amount" id="otv_total_amount" class="moneybox" readonly="" value="0">
													</div>
													<label class="col col-1 col-xs-12">
														#session.ep.money#
													</label>
												</div>
											</div>
											<div class="col col-12">
												<div class="form-group">
													<label class="col col-3 col-xs-12 txtbold">
														<cf_get_lang dictionary_id="50923.BSMV">
													</label>
													<div class="col col-8 col-xs-12">
														<input type="text" name="bsmv_total_amount" id="bsmv_total_amount" class="moneybox" readonly="" <cfif isdefined("attributes.expense_id")>value="#TLFormat(get_expense.otv_total,xml_genel_number)#"<cfelse>value="0"</cfif> >
													</div>
													<label class="col col-1 col-xs-12">
														#session.ep.money#
													</label>
												</div>
											</div>
											<div class="col col-12">
												<div class="form-group">
													<label class="col col-3 col-xs-12 txtbold">
														<cf_get_lang dictionary_id="50982.OIV">
													</label>
													<div class="col col-8 col-xs-12">
														<input type="text" name="oiv_total_amount" id="oiv_total_amount" class="moneybox" readonly="" <cfif isdefined("attributes.expense_id")>value="#TLFormat(get_expense.otv_total,xml_genel_number)#"<cfelse>value="0"</cfif> >
													</div>
													<label class="col col-1 col-xs-12">
														#session.ep.money#
													</label>
												</div>
											</div>
											<div class="col col-12">
												<div class="form-group">
													<label class="col col-3 col-xs-12 txtbold">
														<a href="javascript://" onclick="getStopajRate();"><i class="fa fa-plus" title="Stopaj Oranları" alt="Stopaj Oranları"></i></a>
														<cf_get_lang dictionary_id='57711.Stopaj'>%
														<input type="hidden" name="stopaj_rate_id" id="stopaj_rate_id" value="<cfif isdefined("get_expense")>#get_expense.stopaj_rate_id#</cfif>">
													</label>
													<div class="col col-4 col-xs-12">
														<input type="text" name="stopaj_yuzde" id="stopaj_yuzde" class="moneybox" onblur="calc_stopaj();" onkeyup="return(FormatCurrency(this,event,0));" value="<cfif isdefined("get_expense")>#TLFormat(get_expense.stopaj_oran)#<cfelse>#Tlformat(0)#</cfif>" autocomplete="off">
													</div>
													<div class="col col-4 col-xs-12">
														<input type="text" class="moneybox" name="stopaj" id="stopaj" value="<cfif isdefined("get_expense")>#TLFormat(get_expense.stopaj)#<cfelse>#Tlformat(0)#</cfif>" onblur="toplam_hesapla(1);">
													</div>
												</div>
											</div>
											<div class="col col-12">
												<div class="form-group">
													<label class="col col-3 col-xs-12 txtbold">
														<cf_get_lang dictionary_id='57680.KDV li Toplam'>
													</label>
													<div class="col col-8 col-xs-12">
														<input type="text" name="net_total_amount" id="net_total_amount" class="moneybox" readonly="" value="0">
													</div>
													<label class="col col-1 col-xs-12">
														#session.ep.money#
													</label>
												</div>
											</div>
										</table>
									</div>
								</div>
							</div>
						</div>
						<div class="col col-3 col-sm-6 col-xs-12">
							<div class="totalBox">
								<div class="totalBoxHead font-grey-mint">
									<span class="headText"><cf_get_lang dictionary_id='58560.İndirim'></span>
									<div class="collapse">
										<span class="icon-minus"></span>
									</div>
								</div>
								<div class="totalBoxBody">
									<table>
										<div class="col col-12">
											<div class="form-group">
												<label class="col col-4 col-xs-12 txtbold">
													<cf_get_lang dictionary_id='58124.Döviz Toplam'>
												</label>
												<div class="col col-6 col-xs-12" id="rate_value1">
													<input type="text" name="other_total_amount" id="other_total_amount" class="box" readonly="" value="0">
												</div>
												<div class="col col-2 col-xs-12">
													<input type="text" name="tl_value1" id="tl_value1" class="box" readonly="" value="">
												</div>
											</div>
										</div>
										<div class="col col-12">
											<div class="form-group">
												<label class="col col-4 col-xs-12 txtbold">
													<cf_get_lang dictionary_id='51331.Döviz KDV'>
												</label>
												<div class="col col-6 col-xs-12" id="rate_value2">
													<input type="text" name="other_kdv_total_amount" id="other_kdv_total_amount" class="box" readonly="" value="0">
												</div>
												<div class="col col-2 col-xs-12">
													<input type="text" name="tl_value2" id="tl_value2" class="box" readonly="" value="">
												</div>
											</div>
										</div>
										<div class="col col-12">
											<div class="form-group">
												<label class="col col-4 col-xs-12 txtbold">
													<cf_get_lang dictionary_id='34085.ÖTV tutar'>
												</label>
												<div class="col col-6 col-xs-12" id="rate_value4">
													<input type="text" name="other_otv_total_amount" id="other_otv_total_amount" class="box" readonly="" value="0">
												</div>
												<div class="col col-2 col-xs-12">
													<input type="text" name="tl_value4" id="tl_value4" class="box" readonly="" value="">
												</div>
											</div>
										</div>
										<div class="col col-12">
											<div class="form-group">
												<label class="col col-4 col-xs-12 txtbold">
													<cf_get_lang dictionary_id='33215.Döviz KDV li Toplam'>
												</label>
												<div class="col col-6 col-xs-12" id="rate_value3">
													<input type="text" name="other_net_total_amount" id="other_net_total_amount" class="box" readonly="" value="0">
												</div>
												<div class="col col-2 col-xs-12">
													<input type="text" name="tl_value3" id="tl_value3" class="box" readonly="" value="">
												</div>
											</div>
										</div>
									</table>
								</div>
							</div>
						</div>
						<div class="col col-3 col-sm-6 col-xs-12">
							<div class="totalBox">
								<div class="totalBoxHead font-grey-mint">
									<span class="headText"><cf_get_lang dictionary_id='59181.Vergi'></span>
								</div>
								<div class="totalBoxBody">  
									<table>
										<tr class="color-list" height="20">
											<td id="td_kdv_list">
											</td>
										</tr>
										<tr height="20">
											<td id="td_otv_list">
											</td>
										</tr>
										<tr class="color-list" height="20">
											<td id="td_bsmv_list"></td>
										</tr>
										<tr class="color-list" height="20">
											<td id="td_oiv_list"></td>
										</tr>
										<tr>
										<td colspan="2">
											<input type="checkbox" name="tevkifat_box" id="tevkifat_box" onclick="gizle_goster(tevkifat_oran);gizle_goster(tevkifat_plus);gizle_goster(tevk_1);gizle_goster(tevk_2);gizle_goster(beyan_1);gizle_goster(beyan_2);toplam_hesapla();">
											<b><cf_get_lang dictionary_id='58022.Tevkfat'></b>
											<input type="hidden" id="tevkifat_id" name="tevkifat_id">
											<input type="text" name="tevkifat_oran" id="tevkifat_oran" readonly style="display:none;width:35px;" onblur="toplam_hesapla();">
											<a style="display:none;cursor:pointer" id="tevkifat_plus" onclick="windowopen('#request.self#?fuseaction=objects.popup_list_tevkifat_rates&field_tevkifat_rate=add_costplan.tevkifat_oran&field_tevkifat_rate_id=add_costplan.tevkifat_id&call_function=toplam_hesapla()','small')"> <img src="images/plus_thin.gif" align="absbottom"></a>
										</td>
										</tr>
										<tr>
											<td id="tevk_1" style="display:none"><b><cf_get_lang dictionary_id ='58022.Tevkifat'> :</b></td>
											<td id="tevk_2" style="display:none" nowrap="nowrap"><div id="tevkifat_text"></div></td>
										</tr>
										<tr>
											<td id="beyan_1" style="display:none"><b><cf_get_lang dictionary_id ='58024.Beyan Edilen'> :</b></td>
											<td id="beyan_2" style="display:none" nowrap="nowrap"><div id="beyan_text"></div></td>
										</tr>
									</table>
								</div>
							</div>
						</div>
					</div>
				</div>
			</cfoutput>
		</cfform>
	</cf_box>
</div>
<script type="text/javascript">
	function open_wizard() {
		document.getElementById("wizard_div").style.display ='';
		
		$("#wizard_div").css('margin-left',$("#tabMenu").position().left - 500);
		$("#wizard_div").css('margin-top',$("#tabMenu").position().top + 50);
		$("#wizard_div").css('position','absolute');
		
		openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_budget_row_calculator&type=income');
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

<cfif isdefined("attributes.expense_id") and len(attributes.expense_id)>
	var row_count=<cfoutput>#get_rows.recordcount#</cfoutput>;
<cfelse>
	var row_count=0;
</cfif>

function getStopajRate(){
	bank_code = $("input#bank_code").val();
	windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_stoppage_rates&field_stoppage_rate=add_costplan.stopaj_yuzde&field_stoppage_rate_id=add_costplan.stopaj_rate_id&field_decimal=#xml_satir_number#</cfoutput>&bank_code='+bank_code+'&call_function=toplam_hesapla()','list');
}
function add_adress()
	{
		
		if(document.getElementById("ch_company_id").value=="" || document.getElementsByName("ch_consumer_id").value=="" || document.getElementById("ch_company").value=="")
		{
			alert("<cf_get_lang dictionary_id='33557.Cari Hesap Seçmelisiniz'>");
			return false;
		}
		else
		{
			if(document.getElementsByName("ch_company_id").value!="")
			{
				
				str_adrlink = '&field_long_adres=add_costplan.adres&field_adress_id=add_costplan.ship_address_id&is_compname_readonly=1';
				openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_member_address&is_comp=1&keyword='+encodeURIComponent(add_costplan.ch_company.value)+''+ str_adrlink);
				return true;
			}
			else
			{
				str_adrlink = '&field_long_adres=add_costplan.adres&field_adress_id=add_costplan.ship_address_id&is_compname_readonly=1';
				openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_member_address&is_comp=0&keyword='+encodeURIComponent(add_costplan.ch_partner.value)+''+ str_adrlink);
				return true;
			}
		}
	}

function open_file() // phl' yi çağırıyor
{
	document.getElementById("income_cost_file").style.display='';
	openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_add_income_cost_file<cfif isdefined("attributes.expense_id")>&expense_id=#attributes.expense_id#</cfif></cfoutput>','','ui-draggable-box-medium');
	return false;
}

function kontrol_et()
{
	if(row_count ==0) return false;
	else return true;
}
function banka_kontrol()
{
	if (document.getElementById("bank"))
	{	
		document.getElementById("bank").checked = false;
		document.getElementById("banka1").style.display='none';
		document.getElementById("banka2").style.display='none';
	}
	if (document.getElementById("cash")) 
	{
		document.getElementById("cash").checked = false;
		document.getElementById("kasa1").style.display='none';
		document.getElementById("kasa2").style.display='none';
	}
	return true;
}
<cfoutput>
function hesapla(field_name,satir,hesap_type,extra_type)
{
	var toplam_dongu_0 = 0;//satir toplam
	if(document.getElementById("row_kontrol"+satir).value==1)
	{
		if(document.getElementById("total"+satir) != undefined) deger_total = document.getElementById("total"+satir); else deger_total="";//tutar
		if(document.getElementById("quantity"+satir) != undefined) deger_quantity = document.getElementById("quantity"+satir); else deger_quantity="";//miktar
		if(document.getElementById("kdv_total"+satir) != undefined) deger_kdv_total= document.getElementById("kdv_total"+satir); else deger_kdv_total="";//kdv tutarı
		if(document.getElementById("otv_total"+satir) != undefined) deger_otv_total= document.getElementById("otv_total"+satir); else deger_otv_total="";//ötv tutarı
		if(document.getElementById("net_total"+satir) != undefined) deger_net_total = document.getElementById("net_total"+satir); else deger_net_total="";//kdvli tutar
		if(document.getElementById("tax_rate"+satir) != undefined) deger_tax_rate = document.getElementById("tax_rate"+satir); else deger_tax_rate="";//kdv oranı
		if(document.getElementById("otv_rate"+satir) != undefined) deger_otv_rate = document.getElementById("otv_rate"+satir); else deger_otv_rate="";//ötv oranı
		if(document.getElementById("other_net_total"+satir) != undefined) deger_other_net_total = document.getElementById("other_net_total"+satir); else deger_other_net_total="";//dovizli tutar kdv dahil
		if(document.getElementById("other_net_total_kdvsiz"+satir) != undefined) deger_other_net_total_kdvsiz = document.getElementById("other_net_total_kdvsiz"+satir); else deger_other_net_total_kdvsiz="";//dovizli tutar kdv hariç
				
		if(document.getElementById("money_id"+satir) != undefined)
		{
			deger_money_id = document.getElementById("money_id"+satir);
			deger_money_id =  list_getat(deger_money_id.value,1,',');
			for(s=1;s<=document.getElementById("kur_say").value;s++)
			{
				money_deger =list_getat(document.all.rd_money[s-1].value,1,',');
				if(money_deger == deger_money_id)
				{
					deger_diger_para_satir = document.all.rd_money[s-1];
					form_value_rate_satir = document.getElementById("txt_rate2_"+s);
				}
			}
			deger_para_satir = list_getat(deger_diger_para_satir.value,3,',');
		}
		else
		{
			deger_money_id="";
			deger_para_satir="";
			form_value_rate_satir="";
		}
		if(deger_total != "") deger_total.value = filterNum(deger_total.value,'#xml_satir_number#');
		if(deger_quantity != "") deger_quantity.value = filterNum(deger_quantity.value,'#xml_satir_number#'); else deger_quantity.value = 1;
		if(deger_kdv_total != "") deger_kdv_total.value = filterNum(deger_kdv_total.value,'#xml_satir_number#');
		if(deger_otv_total != "") deger_otv_total.value = filterNum(deger_otv_total.value,'#xml_satir_number#');
		if(deger_net_total != "") deger_net_total.value = filterNum(deger_net_total.value,'#xml_satir_number#');
		if(deger_other_net_total != "") deger_other_net_total.value = filterNum(deger_other_net_total.value,'#xml_satir_number#');
		if(deger_other_net_total_kdvsiz != "") deger_other_net_total_kdvsiz.value = filterNum(deger_other_net_total_kdvsiz.value,'#xml_satir_number#');
		if(hesap_type ==undefined)
		{
			if(deger_kdv_total != "" && deger_total != "") deger_kdv_total.value = ((parseFloat(deger_total.value) * parseFloat(deger_quantity.value)) * deger_tax_rate.value)/100;
			if(deger_otv_total != "" && deger_total != "") deger_otv_total.value = ((parseFloat(deger_total.value) * parseFloat(deger_quantity.value)) * deger_otv_rate.value)/100;
		}
		else if(hesap_type == 2)
		{
			if(deger_otv_rate.value == undefined)
				otv_rate_ = 0;
			else 
				otv_rate_ = deger_otv_rate.value;
			
			if(deger_tax_rate != undefined && deger_tax_rate.value == '')
				tax_rate_ = 0;
			else
				tax_rate_ = deger_tax_rate.value;
			
			if(deger_total != "" && deger_tax_rate != "") deger_total.value = ((parseFloat(deger_net_total.value)/parseFloat(deger_quantity.value))*100)/ (parseFloat(tax_rate_)+parseFloat(otv_rate_)+100);
			if(deger_kdv_total != "" && deger_total != "") deger_kdv_total.value = (parseFloat(deger_total.value * deger_quantity.value * deger_tax_rate.value))/100;
			if(deger_otv_total != "" && deger_total != "") deger_otv_total.value = (parseFloat(deger_total.value * deger_quantity.value * deger_otv_rate.value))/100;
		}
		toplam_dongu_0 = parseFloat(deger_total.value * deger_quantity.value);
		if(deger_kdv_total != "") toplam_dongu_0 = toplam_dongu_0 + parseFloat(deger_kdv_total.value);
		if(deger_otv_total != "") toplam_dongu_0 = toplam_dongu_0 + parseFloat(deger_otv_total.value);
		if(extra_type != 2)
			if(deger_other_net_total != "") deger_other_net_total.value = ((toplam_dongu_0) * parseFloat(deger_para_satir) / (parseFloat(form_value_rate_satir.value)));
		if(deger_net_total != "") deger_net_total.value = commaSplit(toplam_dongu_0,'#xml_satir_number#');
		if(deger_total != "") deger_total.value = commaSplit(deger_total.value,'#xml_satir_number#');
		if(deger_quantity != "") deger_quantity.value = commaSplit(deger_quantity.value,'#xml_satir_number#');
		if(deger_kdv_total != "") deger_kdv_total.value = commaSplit(deger_kdv_total.value,'#xml_satir_number#');
		if(deger_otv_total != "") deger_otv_total.value = commaSplit(deger_otv_total.value,'#xml_satir_number#');
		if(deger_other_net_total != "") deger_other_net_total.value = commaSplit(deger_other_net_total.value,'#xml_satir_number#');
		if(deger_other_net_total_kdvsiz != "") deger_other_net_total_kdvsiz.value = commaSplit(deger_other_net_total_kdvsiz.value,'#xml_satir_number#');

		if( field_name+satir == 'row_bsmv_amount'+satir+'' ){
			row_bsmv_amount = filterNum( document.getElementById('row_bsmv_amount'+satir+'').value);
			row_bsmv_rate = row_bsmv_amount * 100 / filterNum(document.getElementById('total'+satir+'').value);
			row_bsmv_currency = row_bsmv_amount * filterNum(document.getElementById('txt_rate2_'+satir+'').value) / filterNum(document.getElementById('txt_rate1_'+satir+'').value);
		}
		else if( field_name+satir == 'row_bsmv_currency'+satir+'' ){
			row_bsmv_currency = filterNum( document.getElementById('row_bsmv_currency'+satir+'').value);
			row_bsmv_amount = row_bsmv_currency * filterNum(document.getElementById("txt_rate1_"+satir).value) / filterNum(document.getElementById("txt_rate2_"+satir).value);
			row_bsmv_rate = row_bsmv_amount * 100 /  filterNum(document.getElementById('net_total'+satir+'').value);
		}
		else if( field_name+satir == 'row_bsmv_rate'+satir+'' ){
			row_bsmv_rate =  document.getElementById('row_bsmv_rate'+satir+'').value;
			row_bsmv_amount = filterNum(document.getElementById('total'+satir+'').value) * row_bsmv_rate / 100;
			row_bsmv_currency = row_bsmv_amount * filterNum(document.getElementById("txt_rate2_"+satir).value) / filterNum(document.getElementById("txt_rate1_"+satir).value);
		}

		if( document.getElementById("row_bsmv_rate"+satir) != undefined && document.getElementById("row_bsmv_rate"+satir).value != 0) {
			document.getElementById('row_bsmv_amount'+satir+'').value = ( row_bsmv_amount > 0 ) ? commaSplit(row_bsmv_amount,<cfoutput>#xml_satir_number#</cfoutput>) : commaSplit(0,<cfoutput>#xml_satir_number#</cfoutput>);
			document.getElementById('row_bsmv_currency'+satir+'').value = ( row_bsmv_currency > 0 ) ? commaSplit(row_bsmv_currency,<cfoutput>#xml_satir_number#</cfoutput>) : commaSplit(0,<cfoutput>#xml_satir_number#</cfoutput>);	
		}
		else if( document.getElementById("row_bsmv_rate"+satir) != undefined && document.getElementById("row_bsmv_rate"+satir).value == 0 ){
			document.getElementById('row_bsmv_amount'+satir+'').value = commaSplit(0,<cfoutput>#xml_satir_number#</cfoutput>);
			document.getElementById('row_bsmv_currency'+satir+'').value = commaSplit(0,<cfoutput>#xml_satir_number#</cfoutput>);	
		}

		if( field_name+satir == 'row_oiv_amount'+satir+'' ){
			row_oiv_amount = filterNum( document.getElementById('row_oiv_amount'+satir+'').value);
			row_oiv_rate = row_oiv_amount * 100 / filterNum(document.getElementById('net_total'+satir+'').value);
			document.getElementById('row_oiv_amount'+satir+'').value = ( row_oiv_amount > 0 ) ? commaSplit(row_oiv_amount,<cfoutput>#xml_satir_number#</cfoutput>) : commaSplit(0,<cfoutput>#xml_satir_number#</cfoutput>);
		} 
		else if( field_name+satir == 'row_oiv_rate'+satir+'' ){
			row_oiv_rate = document.getElementById('row_oiv_rate'+satir+'').value;
			row_oiv_amount = filterNum(document.getElementById('net_total'+satir+'').value) * row_oiv_rate / 100;
			document.getElementById('row_oiv_amount'+satir+'').value = ( row_oiv_amount > 0 ) ? commaSplit(row_oiv_amount,<cfoutput>#xml_satir_number#</cfoutput>) : commaSplit(0,<cfoutput>#xml_satir_number#</cfoutput>);
		}

		if( field_name+satir == 'row_tevkifat_amount'+satir+'') {		
			row_tevkifat_amount = filterNum( document.getElementById('row_tevkifat_amount'+satir+'').value );
			row_tevkifat_rate = row_tevkifat_amount * 100 / filterNum(document.getElementById('kdv_total'+satir+'').value);
			document.getElementById('row_tevkifat_amount'+satir+'').value = ( row_tevkifat_amount > 0 ) ? commaSplit(row_tevkifat_amount,<cfoutput>#xml_satir_number#</cfoutput>) : commaSplit(0,<cfoutput>#xml_satir_number#</cfoutput>);
		}
		else if(field_name+satir == 'row_tevkifat_rate'+satir+''){
			row_tevkifat_rate = filterNum( document.getElementById('row_tevkifat_rate'+satir+'').value );
			row_tevkifat_amount = filterNum( document.getElementById('kdv_total'+satir+'').value) * row_tevkifat_rate / 100;
			document.getElementById('row_tevkifat_amount'+satir+'').value = ( row_tevkifat_amount > 0 ) ? commaSplit(row_tevkifat_amount,<cfoutput>#xml_satir_number#</cfoutput>) : commaSplit(0,<cfoutput>#xml_satir_number#</cfoutput>);
		}
	}
	if(extra_type == 2 || extra_type == undefined)
		toplam_hesapla(extra_type);
}
function toplam_hesapla(type)
{
	var toplam_dongu_1 = 0;//tutar genel toplam
	var toplam_dongu_2 = 0;// kdv genel toplam
	var toplam_dongu_3 = 0;// kdvli genel toplam
	var toplam_dongu_4 = 0;// ötv genel toplam
	var toplam_dongu_5 = 0; 
	var toplam_dongu_6 = 0;
	var new_taxArray = new Array(0);
	var new_OtvArray = new Array(0);
	var new_BsmvArray = new Array(0);
	var new_OivArray = new Array(0);
	var bsmvArray = new Array(0);
	var oivArray = new Array(0);
	var taxArray = new Array(0);
	var OtvArray = new Array(0);
	var taxBeyanArray = new Array(0);
	var taxTevkifatArray = new Array(0);
	var beyan_tutar = 0;
	var tevkifat_info = "";
	var beyan_tutar_info = "";
			
	if(type != 2)
		doviz_hesapla();
	for(r=1; r<= document.getElementById("record_num").value;r++)
	{
		if(document.getElementById("row_kontrol"+r).value==1)
		{
			if(document.getElementById("total"+r) != undefined) deger_total = document.getElementById("total"+r); else deger_total="";//tutar
			if(document.getElementById("quantity"+r) != undefined) deger_quantity = document.getElementById("quantity"+r); else deger_quantity="";//miktar
			if(document.getElementById("kdv_total"+r) != undefined) deger_kdv_total= document.getElementById("kdv_total"+r); else deger_kdv_total="";//kdv tutarı
			if(document.getElementById("otv_total"+r) != undefined) deger_otv_total= document.getElementById("otv_total"+r); else deger_otv_total="";//ötv tutarı
			if(document.getElementById("net_total"+r) != undefined) deger_net_total = document.getElementById("net_total"+r); else deger_net_total="";//kdvli tutar
			if(document.getElementById("tax_rate"+r) != undefined) deger_tax_rate = document.getElementById("tax_rate"+r); else deger_tax_rate="";//kdv oranı
			if(document.getElementById("otv_rate"+r) != undefined) deger_otv_rate = document.getElementById("otv_rate"+r); else deger_otv_rate="";//ötv oranı
			if(document.getElementById("row_bsmv_rate"+r) != undefined) deger_bsmv_rate = document.getElementById("row_bsmv_rate"+r); else deger_bsmv_rate=0;//bsmv oranı
			if(document.getElementById("row_bsmv_amount"+r) != undefined) deger_bsmv_amount = document.getElementById("row_bsmv_amount"+r); else deger_bsmv_amount=0;//bsmv tutarı
			if(document.getElementById("row_oiv_rate"+r) != undefined) deger_oiv_rate = document.getElementById("row_oiv_rate"+r); else deger_oiv_rate=0;//bsmv oranı
			if(document.getElementById("row_oiv_amount"+r) != undefined) deger_oiv_amount = document.getElementById("row_oiv_amount"+r); else deger_oiv_amount=0;//bsmv tutarı
			if(document.getElementById("other_net_total"+r) != undefined) deger_other_net_total = document.getElementById("other_net_total"+r); else deger_other_net_total="";//dovizli tutar kdv dahil
			if(document.getElementById("other_net_total_kdvsiz"+r) != undefined) deger_other_net_total_kdvsiz = document.getElementById("other_net_total_kdvsiz"+r); else deger_other_net_total_kdvsiz="";//dovizli tutar kdv hariç
			
			if(document.getElementById("row_bsmv_amount"+r) != undefined) deger_bsmv_amount = document.getElementById("row_bsmv_amount"+r); else deger_bsmv_amount="";//bsmv tutarı
			if(document.getElementById("row_bsmv_rate"+r) != undefined) deger_bsmv_rate = document.getElementById("row_bsmv_rate"+r); else deger_bsmv_rate="";//bsmv oranı
			if(document.getElementById("row_oiv_amount"+r) != undefined) deger_oiv_amount = document.getElementById("row_oiv_amount"+r); else deger_oiv_amount="";//oiv tutarı
			if(document.getElementById("row_oiv_rate"+r) != undefined) deger_oiv_rate = document.getElementById("row_oiv_rate"+r); else deger_oiv_rate="";//oiv oranı

			if(deger_total != "") deger_total.value = filterNum(deger_total.value,'#xml_satir_number#');
			if(deger_quantity != "") deger_quantity.value = filterNum(deger_quantity.value,'#xml_satir_number#');
			if(deger_kdv_total != "") deger_kdv_total.value = filterNum(deger_kdv_total.value,'#xml_satir_number#');
			
			if(document.getElementById("tax_rate"+r) != undefined && document.getElementById("kdv_total"+r) != undefined)
			{
				if(document.getElementById("tevkifat_oran") != undefined && document.getElementById("tevkifat_oran").value != "" && document.getElementById("tevkifat_box").checked == true)
				{//tevkifat hesaplamaları
					beyan_tutar = beyan_tutar + wrk_round(deger_kdv_total.value*filterNum(document.getElementById("tevkifat_oran").value,8));
				}

					if(new_taxArray.length != 0)
						for (var m=0; m < new_taxArray.length; m++)
						{	
							var tax_flag = false;
							if(new_taxArray[m] == deger_tax_rate.value){
								tax_flag = true;
								
								if(document.getElementById("tevkifat_oran") != undefined && document.getElementById("tevkifat_oran").value != "" && document.getElementById("tevkifat_box").checked == true)
								{	//tevkifat hesaplamaları
									taxBeyanArray[m] += wrk_round(deger_kdv_total.value - (deger_kdv_total.value*(filterNum(document.getElementById("tevkifat_oran").value,8))));
									taxTevkifatArray[m] += wrk_round(deger_kdv_total.value*(filterNum(document.getElementById("tevkifat_oran").value,8)));
								}
								taxArray[m] += wrk_round(deger_kdv_total.value);
								break;
							}
						}
					if(!tax_flag){
							new_taxArray[new_taxArray.length] = deger_tax_rate.value;
							taxBeyanArray[taxBeyanArray.length] = wrk_round(deger_kdv_total.value - (deger_kdv_total.value*(filterNum(document.getElementById("tevkifat_oran").value,8))));
							taxTevkifatArray[taxTevkifatArray.length] = wrk_round(deger_kdv_total.value*(filterNum(document.getElementById("tevkifat_oran").value,8)));
							taxArray[taxArray.length] = wrk_round(deger_kdv_total.value);
						}
	
			}
			if(deger_otv_total != "") deger_otv_total.value = filterNum(deger_otv_total.value,'#xml_satir_number#');

			tax_flag = false;
			oiv_flag = false;
			bsmv_flag = false;
				if(document.getElementById("otv_rate"+r) != undefined && document.getElementById("otv_total"+r) != undefined)
				{
					if(new_OtvArray.length != 0)
						for (var otv=0; otv < new_OtvArray.length; otv++)
						{	
							tax_flag = false;
							if(new_OtvArray[otv] == deger_otv_rate.value){
								tax_flag = true;
								OtvArray[otv] += wrk_round(deger_otv_total.value);
								break;
							}
						}
					if(!tax_flag){
						new_OtvArray[new_OtvArray.length] = deger_otv_rate.value;
						OtvArray[OtvArray.length] = wrk_round(deger_otv_total.value);
					}
				}

				if(document.getElementById("row_bsmv_amount"+r) != undefined && document.getElementById("row_bsmv_rate"+r)){

                    if(new_BsmvArray.length != 0)
                            for (var bsmv=0; bsmv < new_BsmvArray.length; bsmv++)
                            {    
                                bsmv_flag = false;
                                if(new_BsmvArray[bsmv] == parseFloat(deger_bsmv_rate.value.replace(",","."))){
                                    bsmv_flag = true;
                                    bsmvArray[bsmv] += parseFloat(deger_bsmv_amount.value.replace(",","."));
                                    break;
                                }
                            }
                        if(!bsmv_flag){
                            new_BsmvArray[new_BsmvArray.length] = parseFloat(deger_bsmv_rate.value.replace(",","."));
                            bsmvArray[bsmvArray.length] = parseFloat(deger_bsmv_amount.value.replace(",","."));
                        }
                    }

                    if(document.getElementById("row_oiv_amount"+r) != undefined && document.getElementById("row_oiv_rate"+r)){

                        if(new_OivArray.length != 0)
                            for (var oiv=0; oiv < new_OivArray.length; oiv++)
                            {    
                                oiv_flag = false;
                                if(new_OivArray[oiv] == parseFloat(deger_oiv_rate.value.replace(",","."))){
                                    oiv_flag = true;
                                    oivArray[oiv] += parseFloat(deger_oiv_amount.value.replace(",","."));
                                    break;
                                }
                            }
                        if(!oiv_flag){
                            new_OivArray[new_OivArray.length] = parseFloat(deger_oiv_rate.value.replace(",","."));
                            oivArray[oivArray.length] = parseFloat(deger_oiv_amount.value.replace(",","."));
                        }
                    }


			if(deger_net_total != "") deger_net_total.value = filterNum(deger_net_total.value,'#xml_satir_number#');
			if(deger_total != "") toplam_dongu_1 = toplam_dongu_1 + parseFloat(deger_total.value * deger_quantity.value);
			if(deger_kdv_total != "") toplam_dongu_2 = toplam_dongu_2 + parseFloat(deger_kdv_total.value);
			if(deger_otv_total != "") toplam_dongu_4 = toplam_dongu_4 + parseFloat(deger_otv_total.value);
			if(deger_bsmv_amount != "") toplam_dongu_5 = toplam_dongu_5 + parseFloat( filterNum( deger_bsmv_amount.value,'#xml_satir_number#'));
			if(deger_oiv_amount != "") toplam_dongu_6 = toplam_dongu_6 + parseFloat( filterNum( deger_oiv_amount.value,'#xml_satir_number#'));
			if(deger_total != "") toplam_dongu_3 = toplam_dongu_3 + (parseFloat(deger_total.value * deger_quantity.value));
			if(deger_kdv_total != "") toplam_dongu_3 = toplam_dongu_3 + parseFloat(deger_kdv_total.value);
			if(deger_otv_total != "") toplam_dongu_3 = toplam_dongu_3 + parseFloat(deger_otv_total.value);
			if(deger_bsmv_amount != "") toplam_dongu_3 = toplam_dongu_3 + parseFloat( filterNum( deger_bsmv_amount.value, '#xml_satir_number#'));
			if(deger_oiv_amount != "") toplam_dongu_3 = toplam_dongu_3 + parseFloat( filterNum ( deger_oiv_amount.value, '#xml_satir_number#'));
			if(deger_net_total != "") deger_net_total.value = commaSplit(deger_net_total.value,'#xml_satir_number#');
			if(deger_total != "") deger_total.value = commaSplit(deger_total.value,'#xml_satir_number#');
			if(deger_quantity != "") deger_quantity.value = commaSplit(deger_quantity.value,'#xml_satir_number#');
			if(deger_kdv_total != "") deger_kdv_total.value = commaSplit(deger_kdv_total.value,'#xml_satir_number#');
			if(deger_otv_total != "") deger_otv_total.value = commaSplit(deger_otv_total.value,'#xml_satir_number#');
			if(deger_bsmv_amount != "") deger_bsmv_amount.value = commaSplit(deger_bsmv_amount.value,'#xml_satir_number#');
			if(deger_oiv_amount != "") deger_oiv_amount.value = commaSplit(deger_oiv_amount.value,'#xml_satir_number#');
			<cfif ListFind(ListDeleteDuplicates(xml_order_list_rows),6)>
			if(document.getElementById("product_id"+r) != undefined && document.getElementById("product_id"+r) != '')
					view_product_info(r);
			</cfif>
		}
	}
	if(document.getElementById("tevkifat_oran") != undefined && document.getElementById("tevkifat_oran").value != "" && document.getElementById("tevkifat_box").checked == true)
		{//tevkifat hesaplamaları
			toplam_dongu_3 = toplam_dongu_3 - toplam_dongu_2 + beyan_tutar;
			toplam_dongu_2 = beyan_tutar;
			tevkifat_text.style.fontWeight = 'bold';
			tevkifat_text.innerHTML = '';
			beyan_text.style.fontWeight = 'bold';
			beyan_text.innerHTML = '';
			for (var tt=0; tt < new_taxArray.length; tt++)
			{
				tevkifat_text.innerHTML += '% ' + new_taxArray[tt] + ' : ' + commaSplit(taxBeyanArray[tt],'#xml_genel_number#') + ' ';
				beyan_text.innerHTML += '% ' + new_taxArray[tt] + ' : ' + commaSplit(taxTevkifatArray[tt],'#xml_genel_number#') + ' ';
			}
		}

	var stopaj_yuzde_ = filterNum(document.getElementById("stopaj_yuzde").value,'#xml_satir_number#');
	if(type == undefined || stopaj_yuzde_ == 0)
		stopaj_ = wrk_round(((toplam_dongu_1 * stopaj_yuzde_) / 100),'#xml_genel_number#');
	else
		stopaj_ = filterNum(document.getElementById("stopaj").value);
		
	document.getElementById("stopaj_yuzde").value = commaSplit(stopaj_yuzde_);
	document.getElementById("stopaj").value = commaSplit(stopaj_,'#xml_genel_number#');
	
	toplam_dongu_3 = toplam_dongu_3-parseFloat(stopaj_);	
	
	


	document.getElementById("total_amount").value = commaSplit(toplam_dongu_1,'#xml_genel_number#');
	document.getElementById("kdv_total_amount").value = commaSplit(toplam_dongu_2,'#xml_genel_number#');
	document.getElementById("otv_total_amount").value = commaSplit(toplam_dongu_4,'#xml_genel_number#');
	document.getElementById("net_total_amount").value = commaSplit(toplam_dongu_3,'#xml_genel_number#');
	document.getElementById("bsmv_total_amount").value = commaSplit(toplam_dongu_5,'#xml_genel_number#');
	document.getElementById("oiv_total_amount").value = commaSplit(toplam_dongu_6,'#xml_genel_number#');
	for(s=1;s<=document.getElementById("kur_say").value;s++)
	{
		form_txt_rate2_ = document.getElementById("txt_rate2_"+s);
		if(form_txt_rate2_.value == "")
			form_txt_rate2_.value = 1;
	}
	if(document.getElementById("kur_say").value == 1)
		for(s=1;s<=document.getElementById("kur_say").value;s++)
		{
			if(document.add_costplan.rd_money[s-1].checked == true)
			{
				deger_diger_para = document.getElementById("rd_money");
				form_txt_rate2_ = document.getElementById("txt_rate2_"+s);
			}
		}
	else 
		for(s=1;s<=document.getElementById("kur_say").value;s++)
		{
			if(document.add_costplan.rd_money[s-1] != undefined && document.add_costplan.rd_money[s-1].checked == true)
			{
				deger_diger_para = document.add_costplan.rd_money[s-1];
				form_txt_rate2_ = document.getElementById("txt_rate2_"+s);
			}
		}
		deger_money_id_1 = list_getat(deger_diger_para.value,1,',');
		deger_money_id_2 = list_getat(deger_diger_para.value,2,',');
		deger_money_id_3 = list_getat(deger_diger_para.value,3,',');
		//form_txt_rate2_.value = filterNum(form_txt_rate2_.value,'#session.ep.our_company_info.rate_round_num#');
		document.getElementById("other_total_amount").value = commaSplit(toplam_dongu_1 * parseFloat(deger_money_id_3) / (parseFloat(filterNum(form_txt_rate2_.value,'#session.ep.our_company_info.rate_round_num#'),'#session.ep.our_company_info.rate_round_num#')),'#xml_genel_number#');
		document.getElementById("other_kdv_total_amount").value = commaSplit(toplam_dongu_2 * parseFloat(deger_money_id_3) / (parseFloat(filterNum(form_txt_rate2_.value,'#session.ep.our_company_info.rate_round_num#'),'#session.ep.our_company_info.rate_round_num#')),'#xml_genel_number#');
		document.getElementById("other_otv_total_amount").value = commaSplit(toplam_dongu_4 * parseFloat(deger_money_id_3) / (parseFloat(filterNum(form_txt_rate2_.value,'#session.ep.our_company_info.rate_round_num#'),'#session.ep.our_company_info.rate_round_num#')),'#xml_genel_number#');
		document.getElementById("other_net_total_amount").value = commaSplit(toplam_dongu_3 * parseFloat(deger_money_id_3) / (parseFloat(filterNum(form_txt_rate2_.value,'#session.ep.our_company_info.rate_round_num#'),'#session.ep.our_company_info.rate_round_num#')),'#xml_genel_number#');
		document.getElementById("tl_value1").value = deger_money_id_1;
		document.getElementById("tl_value2").value = deger_money_id_1;
		document.getElementById("tl_value3").value = deger_money_id_1;
		//form_txt_rate2_.value = commaSplit(form_txt_rate2_.value,'#session.ep.our_company_info.rate_round_num#');

		td_kdv_list.style.fontWeight = 'bold';
		td_kdv_list.innerHTML = '<b><cf_get_lang dictionary_id="57639.KDV"></b>';
		for (var tt=0; tt < new_taxArray.length; tt++)
		{
			td_kdv_list.innerHTML += ' % ' + new_taxArray[tt] + ' : ' + commaSplit(taxArray[tt],'#xml_genel_number#') + ' ';
		}
		td_otv_list.style.fontWeight = 'bold';
		td_otv_list.innerHTML = '<b><cf_get_lang dictionary_id="58021.ÖTV"></b>';
		for (var tt=0; tt < new_OtvArray.length; tt++)
		{
			td_otv_list.innerHTML += ' % ' + new_OtvArray[tt] + ' : ' + commaSplit(OtvArray[tt],'#xml_genel_number#') + ' ';
		}

		td_bsmv_list.style.fontWeight = 'bold';
		td_bsmv_list.innerHTML = '<b><cf_get_lang dictionary_id="50923.BSMV"></b>';
		for (var tt=0; tt < new_BsmvArray.length; tt++)
		{
			td_bsmv_list.innerHTML += ' % ' + new_BsmvArray[tt] + ' : ' + commaSplit(bsmvArray[tt],'#xml_genel_number#') + ' ';
		}

		td_oiv_list.style.fontWeight = 'bold';
		td_oiv_list.innerHTML = '<b><cf_get_lang dictionary_id="50982.OIV"></b>';
		for (var tt=0; tt < new_OivArray.length; tt++)
		{
			td_oiv_list.innerHTML += ' % ' + new_OivArray[tt] + ' : ' + commaSplit(oivArray[tt],'#xml_genel_number#') + ' ';
		}
}
function doviz_hesapla(type)
{
	for(k=1;k<=document.getElementById("record_num").value;k++)
	{		
		if(document.getElementById("money_id"+k) != undefined)
		{
			deger_money_id = document.getElementById("money_id"+k);
			deger_money_id =  list_getat(deger_money_id.value,1,',');
			for (var t=1; t<=document.getElementById("kur_say").value; t++)
			{
				money_deger =list_getat(document.add_costplan.rd_money[t-1].value,1,',');
				if(money_deger == deger_money_id)	
				{						
					rate2_value = filterNum(document.getElementById("txt_rate2_"+t).value,'#session.ep.our_company_info.rate_round_num#')/filterNum(document.getElementById("txt_rate1_"+t).value,'#session.ep.our_company_info.rate_round_num#');
					if(document.getElementById("other_net_total"+k) != undefined)
					document.getElementById("other_net_total"+k).value = commaSplit(filterNum(document.getElementById("net_total"+k).value,'#xml_satir_number#')/rate2_value,'#xml_satir_number#');
					if(document.getElementById("other_net_total_kdvsiz"+k) != undefined)
					document.getElementById("other_net_total_kdvsiz"+k).value = commaSplit(filterNum(document.getElementById("total"+k).value,'#xml_satir_number#')/rate2_value,'#xml_satir_number#');
				}
			}
		}
	}
}
</cfoutput>
function kontrol()
{	
	var beyan_tutar = 0;
	var tevkifat_info = "";
	var beyan_tutar_info = "";
	var new_taxArray = new Array(0);
	var taxBeyanArray = new Array(0);
	var taxTevkifatArray = new Array(0);

	<cfif xml_upd_row_project eq 1>
			for(i=1; i<row_count+1; i++){
				if(document.getElementById("project_id"+i).value == "" || document.getElementById("project"+i).value == "")
				{ 
					document.getElementById("project_id"+i).value = document.getElementById("project_id").value;
					document.getElementById("project"+i).value = document.getElementById("project_head").value;
				<cfif xml_upd_row_expense_center eq 1>
					if(document.getElementById("project_id"+i).value != "" || document.getElementById("project"+i).value != "")
					{ 
						var xxx = document.getElementById("project_id"+i).value;
						var get_expense_center = wrk_safe_query('obj_get_project_related_expense','dsn2',0,xxx);
						if(get_expense_center.recordcount != 0)
						{
							document.getElementById("expense_center_id"+i).value = get_expense_center.EXPENSE_ID;
							document.getElementById("expense_center_name"+i).value = get_expense_center.EXPENSE;
						}
					}
				</cfif>
				}
			}
		</cfif>
	if(document.getElementById("ch_company").value == "" &&  document.getElementById("ch_partner").value == "" && document.getElementById("cash").checked == false && document.getElementById("bank").checked == false)
	{
		alert("<cf_get_lang dictionary_id='33455.Cari kasa veya banka işleminden birini seçiniz'>!");
		return false;
	}
	if(document.getElementById("bank").checked == true)
	{		
		if(!acc_control()) return false;
	}
	<cfif isdefined("xml_show_process_stage") and len(xml_show_process_stage) and xml_show_process_stage eq 1>
		if(document.add_costplan.process_stage.value == "")
			{
				alert("<cf_get_lang dictionary_id ='41036.Lütfen Süreçlerinizi Tanimlayiniz veya Tanimlanan Süreçler Üzerinde Yetkiniz Yok'>!");
				return false;
			}
	</cfif>
	if (!chk_process_cat('add_costplan')) return false;
	if (!check_display_files('add_costplan')) return false;
	if (!chk_period(document.getElementById("expense_date"),"<cf_get_lang dictionary_id ='57692.İşlem'>")) return false;
	if (!paper_control(document.getElementById("serial_no"),'INCOME_COST',true,'','','','','','',1,document.getElementById("serial_number"))) return false;;
	if(document.getElementById("expense_date").value == "")
	{
		alert("<cf_get_lang dictionary_id='33454.Lütfen Harcama Tarihi Giriniz'>!");
		return false;
	}
	if(document.getElementById("expense_employee").value == "")
	{
		alert("<cf_get_lang dictionary_id='33486.Lütfen Tahsil Eden Giriniz'>!");
		return false;
	}
	<cfif (session.ep.our_company_info.is_efatura eq 1) > //MCP tarafından #75351 numaralı iş için eklendi.e-Fatura kullanıyorsa gösterilecek 
		if(document.getElementById('ch_company_id') != undefined && document.getElementById('ch_company_id').value != '')
		{
			var get_efatura_info = wrk_query("SELECT USE_EFATURA FROM COMPANY WHERE COMPANY_ID = "+document.getElementById('ch_company_id').value,"dsn");	
			if(get_efatura_info.USE_EFATURA == 1)															   
			{
				if(document.getElementById('ship_address_id').value =='' || document.getElementById('adres').value =='')
				{
					alert('<cf_get_lang dictionary_id="60200.Cari Şube Boş Bırakılmaz">');
					return false;
				}
			}
		}
	</cfif>
	<cfif isdefined('x_select_project') and x_select_project eq 2> //xmlde muhasebe icin proje secimi zorunlu ise
			if(document.getElementById("project_head").value=='' || document.getElementById("project_id").value=='' )
			{
				alert("<cf_get_lang dictionary_id='58797.Proje Seçiniz'>");
				return false;
			} 
		</cfif>
	record_exist=0;//Row_kontrol değeri 1 olan yani silinmemiş satırların varlığını kontrol ediyor
	for(r=1;r<=document.getElementById("record_num").value;r++)
	{
		deger_row_kontrol = document.getElementById("row_kontrol"+r);
		if(document.getElementById("expense_center_id"+r) != undefined) deger_expense_center_id = document.getElementById("expense_center_id"+r).value; else deger_expense_center_id ="";
		if(document.getElementById("expense_center_name"+r) != undefined) deger_expense_center_name = document.getElementById("expense_center_name"+r).value; else deger_expense_center_name ="";		
		if(document.getElementById("expense_item_id"+r) != undefined) deger_expense_item_id = document.getElementById("expense_item_id"+r).value; else deger_expense_item_id = "";
		if(document.getElementById("expense_item_name"+r) != undefined) deger_expense_item_name = document.getElementById("expense_item_name"+r).value; else deger_expense_item_name = "";		
		if(document.getElementById("row_detail"+r) != undefined) deger_row_detail = document.getElementById("row_detail"+r).value; else deger_row_detail = "";
		if(document.getElementById("authorized"+r) != undefined) harcama_yapan = document.getElementById("authorized"+r); else harcama_yapan="";
		if(document.getElementById("company"+r) != undefined) harcama_yapan_firma = document.getElementById("company"+r); else harcama_yapan_firma="";
		deger_total = document.getElementById("total"+r);
		
		<cfif x_is_project_priority eq 1>
			deger_project = document.getElementById("project_id"+r);
			deger_project_name = document.getElementById("project"+r);
			deger_product_id = document.getElementById("product_id"+r);
			deger_product_name = document.getElementById("product_name"+r);
		</cfif>
		
		
		if(deger_row_kontrol.value == 1)
		{
		    record_exist=1;
			<cfif x_is_project_priority eq 1>
				if (deger_product_id.value == "" || deger_product_name.value == "")
				{ 
					alert ("<cf_get_lang dictionary_id='57725.Ürün Seçiniz'>");
					return false;
				}
				
				var get_urun_kalem = wrk_safe_query("obj_get_urun_kalem","dsn3","1", deger_product_id.value);
				var urun_record_ = get_urun_kalem.recordcount;
				if(urun_record_<1)
				{
					alert("<cf_get_lang dictionary_id='34267.Ürün Gider Kalemi Bulunamadı'>");
					return false;
				}
				else
				{
					document.getElementById("expense_item_id"+r).value = get_urun_kalem.EXPENSE_ITEM_ID;
				}
						
				if (urun_record_==1 && document.getElementById("expense_item_id"+r).value == '')		
				{
					alert("<cf_get_lang dictionary_id='34264.Seçmiş Olduğunuz Ürün Dağıtıma Tabidir Başka Bir Ürün Seçmeniz Gerekir'>!");
					return false;
				}
				if (deger_project.value == "" || deger_project_name.value == "")
				{ 
					alert ("<cf_get_lang dictionary_id='58797.Proje Seçiniz'>");
					return false;
				}
				var get_proje_merkez = wrk_safe_query("obj_get_proje_merkez","dsn","1", deger_project.value);
				var proje_record_ = get_proje_merkez.recordcount;
				if(proje_record_<1 || get_proje_merkez.EXPENSE_CODE =='' || get_proje_merkez.EXPENSE_CODE==undefined)
				{
					alert("<cf_get_lang dictionary_id='34265.Proje Masraf Merkezi Bulunamadı'>");
					return false;
				}
				else
				{
					var get_code = wrk_safe_query("obj_get_code","dsn2","1",get_proje_merkez.EXPENSE_CODE);
					document.getElementById("expense_center_id"+r).value = get_code.EXPENSE_ID;
				}			
			</cfif>
			//Bütçe tarih kısıtı kontrolü
			if(document.getElementById("expense_date"+r) != undefined && document.getElementById("expense_date"+r) != '')
			if(!date_check_hiddens(document.getElementById("budget_period"),document.getElementById("expense_date"+r),'Bütçe dönemi kapandığı için satırdaki harcama tarihi '+document.getElementById("budget_period").value+' tarihinden sonra girilmiş olmalıdır.'))
			return false;
			if(document.getElementById("tax_rate"+r) != undefined && document.getElementById("kdv_total"+r) != undefined)
				{
					if(document.getElementById("tevkifat_oran") != undefined && document.getElementById("tevkifat_oran").value != "" && document.getElementById("tevkifat_box").checked == true)
					{//tevkifat hesaplamaları
						if(new_taxArray.length != 0)
							for (var m=0; m < new_taxArray.length; m++)
							{	
								var tax_flag = false;
								if(new_taxArray[m] == document.getElementById("tax_rate"+r).value){
									tax_flag = true;
									taxBeyanArray[m] += wrk_round(filterNum(document.getElementById("kdv_total"+r).value,'<cfoutput>#xml_satir_number#</cfoutput>') - (filterNum(document.getElementById("kdv_total"+r).value,'<cfoutput>#xml_satir_number#</cfoutput>')*(filterNum(document.getElementById("tevkifat_oran").value,8))));
									taxTevkifatArray[m] += wrk_round(filterNum(document.getElementById("kdv_total"+r).value,'<cfoutput>#xml_satir_number#</cfoutput>')*(filterNum(document.getElementById("tevkifat_oran").value,8)));
									break;
								}
							}
						if(!tax_flag){
							new_taxArray[new_taxArray.length] = document.getElementById("tax_rate"+r).value;
							taxBeyanArray[taxBeyanArray.length] = wrk_round(filterNum(document.getElementById("kdv_total"+r).value,'<cfoutput>#xml_satir_number#</cfoutput>') - (filterNum(document.getElementById("kdv_total"+r).value,'<cfoutput>#xml_satir_number#</cfoutput>')*(filterNum(document.getElementById("tevkifat_oran").value,8))));
							taxTevkifatArray[taxTevkifatArray.length] = wrk_round(filterNum(document.getElementById("kdv_total"+r).value,'<cfoutput>#xml_satir_number#</cfoutput>')*(filterNum(document.getElementById("tevkifat_oran").value,8)));
						}
					}
				}

			var otv_list = "";
			if(document.getElementById("otv_rate"+r) != undefined && document.getElementById("otv_rate"+r).value > 0 && !list_find(otv_list,document.getElementById("otv_rate"+r).value))
				otv_list+= document.getElementById("otv_rate"+r).value+',';
			otv_list = otv_list.substr(0,otv_list.length-1);
			if(otv_list != "")
			{
	
				var otv_control = wrk_safe_query("obj_otv_control",'dsn3',0,otv_list);
				if(otv_control.recordcount != list_len(otv_list))
				{
					alert("<cf_get_lang dictionary_id ='33755.Seçtiğiniz ÖTV Değerlerinin İçinde Tanımlı Olmayan ÖTV ler var'> !");
					return false;
				}	
			}	
			if(document.getElementById("tevkifat_oran") != undefined && document.getElementById("tevkifat_oran").value != "" && document.getElementById("tevkifat_box").checked == true)
			{
				for (var tt=0; tt < new_taxArray.length; tt++)
				{
					document.getElementById("hidden_fields").innerHTML += '<input type="hidden" id="basket_tax_'+tt+'" name="basket_tax_'+tt+'" value="'+new_taxArray[tt]+'">';
					document.getElementById("hidden_fields").innerHTML += '<input type="hidden" id="basket_tax_value_'+tt+'" name="basket_tax_value_'+tt+'" value="'+taxBeyanArray[tt]+'">';
					document.getElementById("hidden_fields").innerHTML += '<input type="hidden" id="tevkifat_tutar_'+tt+'" name="tevkifat_tutar_'+tt+'" value="'+taxTevkifatArray[tt]+'">';
				}
			}
			<cfif x_is_project_priority eq 0>
				if (deger_expense_center_id == "" || deger_expense_center_name == "")
				{ 
					alert ("<cf_get_lang dictionary_id='33488.Lütfen Gelir Merkezi Seçiniz'>");
					return false;
				}	
				if (deger_expense_item_id == "" || deger_expense_item_name == "")
				{ 
					alert ("<cf_get_lang dictionary_id='33489.Lütfen Gelir Kalemi Seçiniz'>");
					return false;
				}	
			</cfif>	
			
			if (deger_row_detail == "")
			{ 
				alert ("<cf_get_lang dictionary_id='33463.Lütfen Açıklama Giriniz'>");
				return false;
			}	
			if (deger_total.value == "")
			{ 
				alert ("<cf_get_lang dictionary_id='29535.Lütfen Tutar Giriniz'>");
				return false;
			}	
			if (deger_total.value == 0)
			{ 
				alert ("<cf_get_lang dictionary_id='29535.Lütfen Tutar Giriniz'>");
				return false;
			}
			if(harcama_yapan=="" && harcama_yapan_firma=="")
			{
				if(document.getElementById("member_type"+r) != undefined) document.getElementById("member_type"+r).value="";
				if(document.getElementById("company_id"+r) != undefined) document.getElementById("company_id"+r).value="";
				if(document.getElementById("member_id"+r) != undefined) document.getElementById("member_id"+r).value="";
				if(document.getElementById("company"+r) != undefined) document.getElementById("company"+r).value="";
			}
			//Muhasebe hesabı alt hesaplar gelirken üst hesapların yazılamaması kontrolü
			var action_account_code = document.getElementById("account_code"+r).value;
			if(action_account_code != "")
			{ 
				if(WrkAccountControl(action_account_code,r+".<cf_get_lang dictionary_id='58508.Satır'>: <cf_get_lang dictionary_id='52213.Muhasebe Hesabı Hesap Planında Tanımlı Değildir'>!") == 0)
				return false;
			}
		}
	}
	if (record_exist == 0) 
		{
			alert("<cf_get_lang dictionary_id='33487.Lütfen Gelir Fişine Satır Ekleyiniz'> !");
			return false;
		}
	change_due_date();
	unformat_fields();
}
function unformat_fields()
{
	<cfoutput>
	for(r=1;r<=document.getElementById("record_num").value;r++)
	{
		if(document.getElementById("total"+r) != undefined) deger_total = document.getElementById("total"+r); else deger_total="";
		if(document.getElementById("quantity"+r) != undefined) deger_quantity = document.getElementById("quantity"+r); else deger_quantity="";
		if(document.getElementById("kdv_total"+r) != undefined) deger_kdv_total= document.getElementById("kdv_total"+r); else deger_kdv_total="";
		if(document.getElementById("otv_total"+r) != undefined) deger_otv_total= document.getElementById("otv_total"+r); else deger_otv_total="";
		if(document.getElementById("net_total"+r) != undefined) deger_net_total = document.getElementById("net_total"+r); else deger_net_total="";
		if(document.getElementById("other_net_total"+r) != undefined) deger_other_net_total = document.getElementById("other_net_total"+r); else deger_other_net_total="";
		//if(document.getElementById("row_bsmv_rate"+r) != undefined) row_bsmv_rate = document.getElementById("row_bsmv_rate"+r); else row_bsmv_rate="";
		if(document.getElementById("row_bsmv_amount"+r) != undefined) row_bsmv_amount = document.getElementById("row_bsmv_amount"+r); else row_bsmv_amount="";
		if(document.getElementById("row_bsmv_currency"+r) != undefined) row_bsmv_currency = document.getElementById("row_bsmv_currency"+r); else row_bsmv_currency="";
		//if(document.getElementById("row_oiv_rate"+r) != undefined) row_oiv_rate = document.getElementById("row_oiv_rate"+r); else row_oiv_rate="";
		if(document.getElementById("row_oiv_amount"+r) != undefined) row_oiv_amount = document.getElementById("row_oiv_amount"+r); else row_oiv_amount="";
		if(document.getElementById("row_tevkifat_rate"+r) != undefined) row_tevkifat_rate = document.getElementById("row_tevkifat_rate"+r); else row_tevkifat_rate="";
		if(document.getElementById("row_tevkifat_amount"+r) != undefined) row_tevkifat_amount = document.getElementById("row_tevkifat_amount"+r); else row_tevkifat_amount="";
		
		if(deger_total != "") deger_total.value = filterNum(deger_total.value,'#xml_satir_number#');
		if(deger_quantity != "") deger_quantity.value = filterNum(deger_quantity.value,'#xml_satir_number#');
		if(deger_kdv_total != "") deger_kdv_total.value = filterNum(deger_kdv_total.value,'#xml_satir_number#');
		if(deger_otv_total != "") deger_otv_total.value = filterNum(deger_otv_total.value,'#xml_satir_number#');
		if(deger_net_total != "") deger_net_total.value = filterNum(deger_net_total.value,'#xml_satir_number#');
		if(deger_other_net_total != "") deger_other_net_total.value = filterNum(deger_other_net_total.value,'#xml_satir_number#');
		//if(row_bsmv_rate != "") row_bsmv_rate.value = filterNum(row_bsmv_rate.value,'#xml_satir_number#');
		if(row_bsmv_amount != "") row_bsmv_amount.value = filterNum(row_bsmv_amount.value,'#xml_satir_number#');
		if(row_bsmv_currency != "") row_bsmv_currency.value = filterNum(row_bsmv_currency.value,'#xml_satir_number#');
		//if(row_oiv_rate != "") row_oiv_rate.value = filterNum(row_oiv_rate.value,'#xml_satir_number#');
		if(row_oiv_amount != "") row_oiv_amount.value = filterNum(row_oiv_amount.value,'#xml_satir_number#');
		if(row_tevkifat_rate != "") row_tevkifat_rate.value = filterNum(row_tevkifat_rate.value,'#xml_satir_number#');
		if(row_tevkifat_amount != "") row_tevkifat_amount.value = filterNum(row_tevkifat_amount.value,'#xml_satir_number#');
	}
	document.getElementById("stopaj_yuzde").value = filterNum(document.getElementById("stopaj_yuzde").value,'#xml_genel_number#');
	document.getElementById("stopaj").value = filterNum(document.getElementById("stopaj").value,'#xml_genel_number#');
	document.getElementById("total_amount").value = filterNum(document.getElementById("total_amount").value,'#xml_genel_number#');
	document.getElementById("kdv_total_amount").value = filterNum(document.getElementById("kdv_total_amount").value,'#xml_genel_number#');
	document.getElementById("otv_total_amount").value = filterNum(document.getElementById("otv_total_amount").value,'#xml_genel_number#');
	document.getElementById("bsmv_total_amount").value = filterNum(document.getElementById("bsmv_total_amount").value,'#xml_genel_number#');
	document.getElementById("oiv_total_amount").value = filterNum(document.getElementById("oiv_total_amount").value,'#xml_genel_number#');
	document.getElementById("net_total_amount").value = filterNum(document.getElementById("net_total_amount").value,'#xml_genel_number#');
	document.getElementById("other_total_amount").value = filterNum(document.getElementById("other_total_amount").value,'#xml_genel_number#');
	document.getElementById("other_kdv_total_amount").value = filterNum(document.getElementById("other_kdv_total_amount").value,'#xml_genel_number#');
	document.getElementById("other_otv_total_amount").value = filterNum(document.getElementById("other_otv_total_amount").value,'#xml_genel_number#');
	document.getElementById("other_net_total_amount").value = filterNum(document.getElementById("other_net_total_amount").value,'#xml_genel_number#');
	for(s=1;s<=document.getElementById("kur_say").value;s++)
	{
		document.getElementById("txt_rate2_" + s).value = filterNum(document.getElementById("txt_rate2_" + s).value,'#session.ep.our_company_info.rate_round_num#');
		document.getElementById("txt_rate1_" + s).value = filterNum(document.getElementById("txt_rate1_" + s).value,'#session.ep.our_company_info.rate_round_num#');
	}
	if(document.getElementById("tevkifat_oran") != undefined)	document.getElementById("tevkifat_oran").value = filterNum(document.getElementById("tevkifat_oran").value,8);
	</cfoutput>
}
	function change_paper_duedate()
	{ 
		var is_holiday = 0;
		var is_nextday = 0;
		if(document.getElementById("paymethod").value.length != 0)
			var paymethod_id_ = document.getElementById("paymethod").value;  
		else
			var paymethod_id_ = 0;
		if(paymethod_id_ != 0){
				var paper_date_ = document.getElementById("expense_date").value; 
				var due_day = document.getElementById("basket_due_value").value;
				var deger= document.getElementById("basket_due_value_date_").value;
				add_url = "";	
				add_url += "&action_date="+paper_date_;
				add_url += "&paymethod_id="+paymethod_id_;			
				$.ajax({ url :'cfc/paymethod_calc.cfc?method=calc_duedate&isAjax=1'+add_url,
					async:false,
					success : function(res){
							data = res.replace('//""','');
							data = $.parseJSON(data);
							}
						}); 
				if(data != ""){
					is_holiday = data.ISHOLIDAY;
					is_nextday = data.NEXT_DAY;
					deger = data.DAYDIFF;
					deger = data.DUE_DATE;
				}else{
					alert("Vade hesaplamasında hata oluştu!");
				} 
				if (data.DUE_DATE != undefined && data.DAYDIFF != undefined){
				document.getElementById("basket_due_value_date_").value=data.DUE_DATE; 
				document.getElementById("basket_due_value").value=data.DAYDIFF;
				}
				if(is_holiday)
					alert("<cf_get_lang dictionary_id='60201.Ödeme Yönteminde Genel Tatil ve Hafta Tatilinde Vade İlk İş Gününe Ertelensin Parametresi Seçili.'> <cf_get_lang dictionary_id='60202.Vade Tarihi İlk İş Gününe Ertelendi'>!");
				if(is_nextday)
					alert("<cf_get_lang dictionary_id='60203.Ödeme Yönteminde hafta günü seçili'>. <cf_get_lang dictionary_id='60204.Vade Tarihi Düzenlendi'>!");	
		}
	}
	function change_paper_duedate2()
	{   
		var is_holiday = 0;
		var is_nextday = 0;
		var paymethod_id_ = document.getElementById("paymethod").value;  
		var paper_date_ = document.getElementById("expense_date").value; 
		var due_day = document.getElementById("basket_due_value").value;
		var deger= document.getElementById("basket_due_value_date_").value;
		add_url = "&due_day="+due_day;		
		add_url += "&action_date="+paper_date_;
		add_url += "&paymethod_id="+paymethod_id_;	
		$.ajax({ url :'cfc/paymethod_calc.cfc?method=calc_duedate&isAjax=1'+add_url,
			async:false,
			success : function(res){
					data = res.replace('//""','');
					data = $.parseJSON( data );
					}
				}); 
		if(data != ""){
			is_holiday = data.ISHOLIDAY;
			is_nextday = data.NEXT_DAY;
			deger = data.DAYDIFF;
			deger = data.DUE_DATE;
		}else{
			alert("Vade hesaplamasında hata oluştu!");
		} 
		if (data.DUE_DATE != undefined && data.DAYDIFF != undefined){
		document.getElementById("basket_due_value_date_").value=data.DUE_DATE; 
		document.getElementById("basket_due_value").value=data.DAYDIFF;
		}
		if(is_holiday)
			alert("<cf_get_lang dictionary_id='60201.Ödeme Yönteminde Genel Tatil ve Hafta Tatilinde Vade İlk İş Gününe Ertelensin Parametresi Seçili.'> <cf_get_lang dictionary_id='60202.Vade Tarihi İlk İş Gününe Ertelendi'>!");
		if(is_nextday)
			alert("<cf_get_lang dictionary_id='60203.Ödeme Yönteminde hafta günü seçili'>. <cf_get_lang dictionary_id='60204.Vade Tarihi Düzenlendi'>!");	
	}
function change_due_date(type)
{
	if (type==1)
	{
		document.getElementById("basket_due_value").value = datediff(document.getElementById("expense_date").value,document.getElementById("basket_due_value_date_").value,0);
	}
	else
	{
		if(isNumber(document.getElementById("basket_due_value"))!= false && (document.getElementById("basket_due_value").value != 0))
			document.getElementById("basket_due_value_date_").value = date_add('d',+document.getElementById("basket_due_value").value,document.getElementById("expense_date").value);
		else
			document.getElementById("basket_due_value_date_").value = document.getElementById("expense_date").value;
	}
	//change_paper_duedate2();
}
toplam_hesapla();
<cfoutput>
	function other_calc(row_info,type_info)
	{
		if(row_info != undefined)
		{
			if(document.getElementById("row_kontrol"+row_info).value==1)
			{
				deger_money_id = list_getat(document.getElementById("money_id"+row_info).value,1,',');
				for(kk=1; kk<= document.getElementById("kur_say").value;kk++)
				{
					money_deger =list_getat(document.all.rd_money[kk-1].value,1,',');
					if(money_deger == deger_money_id)
					{
						deger_diger_para_satir = document.all.rd_money[kk-1];
						form_value_rate_satir = document.getElementById("txt_rate2_"+kk);
					}
				}
				if(document.getElementById("other_net_total_kdvsiz"+row_info) != undefined) document.getElementById("other_net_total_kdvsiz"+row_info).value = filterNum(document.getElementById("other_net_total_kdvsiz"+row_info).value,'#xml_satir_number#');
						if(document.getElementById("otv_rate"+row_info) != undefined) 
							var otv_rate = document.getElementById("otv_rate"+row_info).value;
						else
							var otv_rate = 0;
						<cfif isdefined('x_kdv_add_to_otv') and x_kdv_add_to_otv eq 0>
							var tax_multiplier = 100/(100+ + otv_rate + +filterNum(document.getElementById("tax_rate"+row_info).value,'#xml_satir_number#'));
						<cfelse>
							var tax_multiplier = (100/(100+ + otv_rate )*100/(100+ +filterNum(document.getElementById("tax_rate"+row_info).value,'#xml_satir_number#')));
						</cfif>
				if(document.getElementById("other_net_total_kdvsiz"+row_info) != undefined) document.getElementById("other_net_total_kdvsiz"+row_info).value = document.getElementById("other_net_total"+row_info).value*tax_multiplier;
				//document.getElementById("other_net_total"+row_info).value = filterNum(document.getElementById("other_net_total"+row_info).value,'#xml_satir_number#');
				document.getElementById("net_total"+row_info).value = filterNum(document.getElementById("other_net_total"+row_info).value,'#xml_satir_number#')*filterNum(form_value_rate_satir.value,'#session.ep.our_company_info.rate_round_num#');
				//document.getElementById("other_net_total"+row_info).value = commaSplit(document.getElementById("other_net_total"+row_info).value,'#xml_satir_number#');
				document.getElementById("net_total"+row_info).value = commaSplit(document.getElementById("net_total"+row_info).value,'#xml_satir_number#');
			}
			if(type_info==undefined)
				hesapla('other_net_total',row_info,2);
			else
				hesapla('other_net_total',row_info,2,type_info);
		}
		else
		{
			for(yy=1; yy<= document.getElementById("record_num").value;yy++)
			{	
				if(document.getElementById("row_kontrol"+yy).value==1)
				{
					other_calc(yy,1);
				}
			}
			toplam_hesapla();
		}
	}
	function other_calc_kdvsiz(row_info,type_info)
		{
			if(row_info != undefined)
			{
				if(document.getElementById("row_kontrol"+row_info).value==1)
				{
					if(document.getElementById("money_id"+row_info) != undefined)
					{
						deger_money_id = list_getat(document.getElementById("money_id"+row_info).value,1,',');
						for(kk=1;kk<=document.getElementById("kur_say").value;kk++)
						{
							money_deger =list_getat(document.add_costplan.rd_money[kk-1].value,1,',');
							if(money_deger == deger_money_id)
							{
								deger_diger_para_satir = document.add_costplan.rd_money[kk-1];
								form_value_rate_satir = document.getElementById("txt_rate2_"+kk);
							}
						}
						if(document.getElementById("other_net_total_kdvsiz"+row_info) != undefined) document.getElementById("other_net_total_kdvsiz"+row_info).value = filterNum(document.getElementById("other_net_total_kdvsiz"+row_info).value,'#xml_satir_number#');
						if(document.getElementById("otv_rate"+row_info) != undefined) 
							var otv_rate = document.getElementById("otv_rate"+row_info).value;
						else
							var otv_rate = 0;
						<cfif isdefined('x_kdv_add_to_otv') and x_kdv_add_to_otv eq 0>
							var tax_multiplier = 100/(100+ + otv_rate + +filterNum(document.getElementById("tax_rate"+row_info).value,'#xml_satir_number#'));
						<cfelse>
							var tax_multiplier = (100/(100+ + otv_rate )*100/(100+ +filterNum(document.getElementById("tax_rate"+row_info).value,'#xml_satir_number#')));
						</cfif>
						if(document.getElementById("other_net_total"+row_info) != undefined) document.getElementById("other_net_total"+row_info).value = document.getElementById("other_net_total_kdvsiz"+row_info).value/tax_multiplier;
						if(document.getElementById("net_total"+row_info) != undefined) document.getElementById("net_total"+row_info).value = document.getElementById("other_net_total"+row_info).value*filterNum(form_value_rate_satir.value,'#session.ep.our_company_info.rate_round_num#');
						if(document.getElementById("net_total"+row_info) != undefined) document.getElementById("net_total"+row_info).value = commaSplit(document.getElementById("net_total"+row_info).value,'#xml_satir_number#');
						if(document.getElementById("other_net_total"+row_info) != undefined) document.getElementById("other_net_total"+row_info).value = commaSplit(document.getElementById("other_net_total"+row_info).value,'#xml_satir_number#');
						if(document.getElementById("other_net_total_kdvsiz"+row_info) != undefined) document.getElementById("other_net_total_kdvsiz"+row_info).value = commaSplit(document.getElementById("other_net_total_kdvsiz"+row_info).value,'#xml_satir_number#');
					}
				}
				if(type_info==undefined)
					hesapla('other_net_total_kdvsiz',row_info,2);
				else
					hesapla('other_net_total_kdvsiz',row_info,2,type_info);
			}
			else
			{
				for(yy=1;yy<=document.getElementById("record_num").value;yy++)
				{
					if(document.getElementById("row_kontrol"+yy).value==1)
					{
						other_calc(yy,1);
					}
				}
				toplam_hesapla();
			}
		}

document.getElementById('income_cost_file').style.marginLeft=screen.width-360;
</cfoutput>
var stopaj_yuzde_;
function calc_stopaj()
{
	stopaj_yuzde_ = filterNum(document.getElementById("stopaj_yuzde").value,'#xml_genel_number#');
	if((stopaj_yuzde_ < 0) || (stopaj_yuzde_ > 99.99))
	{
		alert('<cf_get_lang dictionary_id='50036.Stopaj Oranı'>');
		document.getElementById("stopaj_yuzde").value = 0;
	}
	toplam_hesapla(0);
}

function enterControl(e,objeName,ObjeRowNumber,hesapType)//Basket alanlarının içindeyken enter tuşuna basıldığında hesapla fonksiyonunu çağırmıyordu. Bu nedenle eklendi.
{
	if(e.keyCode == 13)
	{	
		if(hesapType == undefined)
		{
			hesapla(objeName,ObjeRowNumber);
		}
		else
		{
			hesapla(objeName,ObjeRowNumber,hesapType);
		}
	}
}

</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
