<div style="display:none;z-index:10;" id="wizard_div"></div>
<!--- <cfif attributes.fuseaction eq 'health.expenses'>
	<cf_xml_page_edit fuseact="hr.expense_cost">
<cfelse>
	<cf_xml_page_edit fuseact="objects.expense_cost">
</cfif> --->
<cf_xml_page_edit>
<cf_get_lang_set module_name="objects">
<cfif is_default_employee eq 1>
	<cfparam name="attributes.expense_employee" default="#session.ep.name# #session.ep.surname#">
	<cfparam name="attributes.expense_employee_id" default="#session.ep.userid#">
</cfif>
<cfif fusebox.use_period eq true>
    <cfset dsn_2 = dsn2>
<cfelse>
    <cfset dsn_2 = dsn>
</cfif>
<cfif fusebox.use_period eq true>
	<cfinclude template="../../invoice/query/control_bill_no.cfm">
</cfif>
<cfset components = createObject('component','V16.hr.cfc.assurance_type')>
<cfset components2 = createObject('component','V16.workdata.get_budget_period_date')>
<cfset budget_date = components2.get_budget_period_date()>
<cfset get_assurance = components.GET_HEALTH_ASSURANCE_TYPE()>
<cfif isdefined("attributes.expense_id") and len(attributes.expense_id)><!--- Masraf kopyalama --->
	<cfquery name="get_money" datasource="#dsn2#">
		SELECT MONEY_TYPE AS MONEY, RATE2 AS RATE3,* FROM EXPENSE_ITEM_PLANS_MONEY WHERE ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.expense_id#"> ORDER BY MONEY
	</cfquery>
	<cfif not get_money.recordcount>
		<cfquery name="get_money" datasource="#dsn#">
			SELECT 0 AS IS_SELECTED,* FROM SETUP_MONEY WHERE PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#"> AND MONEY_STATUS = <cfqueryparam cfsqltype="cf_sql_smallint" value="1"> ORDER BY MONEY_ID
		</cfquery>
	</cfif>
<cfelseif isdefined("attributes.request_id") and len(attributes.request_id)><!--- Harcama Talebinden Donusturme --->
	<cfquery name="get_project" datasource="#dsn2#">
    		SELECT PROJECT_ID FROM EXPENSE_ITEM_PLAN_REQUESTS WHERE EXPENSE_ID = #attributes.request_id#
    </cfquery>
	<cfquery name="get_money" datasource="#dsn2#">
		SELECT MONEY_TYPE AS MONEY, RATE2 AS RATE3,* FROM EXPENSE_ITEM_PLAN_REQUESTS_MONEY WHERE ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.request_id#"> ORDER BY MONEY
	</cfquery>
	<cfif not get_money.recordcount>
		<cfquery name="get_money" datasource="#dsn#">
			SELECT 0 AS IS_SELECTED,* FROM SETUP_MONEY WHERE PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#"> AND MONEY_STATUS = <cfqueryparam cfsqltype="cf_sql_smallint" value="1"> ORDER BY MONEY_ID
		</cfquery>
	</cfif>
<cfelseif isdefined("attributes.from_health_approve")> <!--- Sağlık Harcama Talebinden Geliyorsa PY --->
	<cfquery name="get_money" datasource="#dsn2#">
		SELECT MONEY_TYPE AS MONEY,RATE2 AS RATE3,* FROM EXPENSE_ITEM_PLAN_REQUESTS_MONEY WHERE ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.health_id#"> ORDER BY MONEY
	</cfquery>
	<cfif not get_money.recordcount>
		<cfquery name="get_money" datasource="#dsn#">
			SELECT 0 AS IS_SELECTED,* FROM SETUP_MONEY WHERE PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#"> AND MONEY_STATUS = <cfqueryparam cfsqltype="cf_sql_smallint" value="1"> ORDER BY MONEY_ID
		</cfquery>
	</cfif>
<cfelse>
	<cfif fusebox.use_period eq true>
		<cfquery name="get_money" datasource="#dsn2#">
			SELECT *,0 AS IS_SELECTED FROM SETUP_MONEY WHERE MONEY_STATUS = <cfqueryparam cfsqltype="cf_sql_smallint" value="1"> ORDER BY MONEY_ID
		</cfquery>
	</cfif>
</cfif>

<cfif isdefined("attributes.expense_id") and len(attributes.expense_id)><!--- Masraf Kopyalama --->
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
			EXPENSE_DATE_TIME,
			DUE_DATE,
			EMP_ID,
			ACC_TYPE_ID_EXP,
			IS_CASH,
			IS_BANK,
			TEVKIFAT,
			TEVKIFAT_ORAN,
			TEVKIFAT_ID,
			BRANCH_ID,
            PROJECT_ID,
			ROUND_MONEY,
			IS_CREDITCARD,
			EXPENSE_ID,
			STOPAJ,
			ISNULL(STOPAJ_ORAN,0) STOPAJ_ORAN,
			ISNULL(STOPAJ_RATE_ID,0) STOPAJ_RATE_ID,
			ACC_DEPARTMENT_ID,
			TAX_CODE,
            SHIP_ADDRESS_ID,
            SHIP_ADDRESS,
			TOTAL_AMOUNT,
			KDV_TOTAL,
			OTV_TOTAL,
			TOTAL_AMOUNT_KDVLI,
			OTHER_MONEY_AMOUNT,
			OTHER_MONEY,
			OTHER_MONEY_KDV,
			OTHER_MONEY_OTV,
			OTHER_MONEY_NET_TOTAL,
			PROCESS_DATE,
			POSITION_CODE
		FROM
			EXPENSE_ITEM_PLANS
		WHERE
			EXPENSE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.expense_id#">
	</cfquery>
<cfelseif isdefined("attributes.request_id") and len(attributes.request_id)><!--- Harcama Talebinden Donusturme --->
	<cfquery name="get_expense" datasource="#dsn2#">
		SELECT
			PAPER_TYPE,
			DETAIL,
			ISNULL(SYSTEM_RELATION,PAPER_NO) SYSTEM_RELATION,
			SALES_COMPANY_ID CH_COMPANY_ID,
			SALES_CONSUMER_ID CH_CONSUMER_ID,
			'' CH_EMPLOYEE_ID,
			SALES_PARTNER_ID CH_PARTNER_ID,
			'' ACC_TYPE_ID,
			'' DEPARTMENT_ID,
			'' LOCATION_ID,
			EXPENSE_CASH_ID,
			PAYMETHOD_ID,
			EXPENSE_DATE,
			EXPENSE_DATE AS PROCESS_DATE,
			DUE_DATE,
			EMP_ID,
			ACC_TYPE_ID ACC_TYPE_ID_EXP,
			IS_CASH,
			IS_BANK,
			'' TEVKIFAT,
			'' TEVKIFAT_ORAN,
			'' TEVKIFAT_ID,
			BRANCH_ID,
			0 ROUND_MONEY,
			0 IS_CREDITCARD,
			'' EXPENSE_ID,
			0 STOPAJ,
			0 STOPAJ_ORAN,
			0 STOPAJ_RATE_ID,
			'' ACC_DEPARTMENT_ID,
			'' TAX_CODE,
            ''SHIP_ADDRESS_ID,
            ''SHIP_ADDRESS,
			(SELECT POSITION_CODE FROM #DSN_ALIAS#.EMPLOYEE_POSITIONS WHERE IS_MASTER = 1 AND EMPLOYEE_ID = EXPENSE_ITEM_PLAN_REQUESTS.EMP_ID) POSITION_CODE
		FROM
			EXPENSE_ITEM_PLAN_REQUESTS
		WHERE
			EXPENSE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.request_id#">
	</cfquery>
<cfelseif isdefined("attributes.from_health_approve")>
	<cfquery name="get_expense" datasource="#dsn2#">
		SELECT
			PAPER_TYPE,
			DETAIL,
			RELATIVE_ID,
			NET_TOTAL_AMOUNT,
			TOTAL_AMOUNT,
			NET_KDV_AMOUNT,
			OTHER_MONEY_AMOUNT,
			OTHER_MONEY_KDV,
			OTHER_MONEY_NET_TOTAL,
			OTHER_MONEY,
			ISNULL(SYSTEM_RELATION,PAPER_NO) SYSTEM_RELATION,
			'' CH_COMPANY_ID,
			'' CH_CONSUMER_ID,
			EMP_ID,
			EMP_ID AS CH_EMPLOYEE_ID,
			'' CH_PARTNER_ID,
			'' ACC_TYPE_ID,
			'' DEPARTMENT_ID,
			'' LOCATION_ID,
			EXPENSE_CASH_ID,
			PAYMETHOD_ID,
			EXPENSE_DATE,
			EXPENSE_DATE AS PROCESS_DATE,
			DUE_DATE,
			EMP_ID,
			ACC_TYPE_ID ACC_TYPE_ID_EXP,
			IS_CASH,
			IS_BANK,
			'' TEVKIFAT,
			'' TEVKIFAT_ORAN,
			'' TEVKIFAT_ID,
			BRANCH_ID,
			0 ROUND_MONEY,
			0 IS_CREDITCARD,
			'' EXPENSE_ID,
			0 STOPAJ,
			0 STOPAJ_ORAN,
			0 STOPAJ_RATE_ID,
			'' ACC_DEPARTMENT_ID,
			'' TAX_CODE,
            ''SHIP_ADDRESS_ID,
            ''SHIP_ADDRESS,
			OUR_COMPANY_HEALTH_AMOUNT,
			EMPLOYEE_HEALTH_AMOUNT,
			ASSURANCE_ID,
			(SELECT POSITION_CODE FROM #DSN_ALIAS#.EMPLOYEE_POSITIONS WHERE IS_MASTER = 1 AND EMPLOYEE_ID = EXPENSE_ITEM_PLAN_REQUESTS.EMP_ID) POSITION_CODE
		FROM
			EXPENSE_ITEM_PLAN_REQUESTS
		WHERE
			EXPENSE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.health_id#">
	</cfquery>
<cfelseif IsDefined("attributes.law_request_id") and len(attributes.law_request_id)>
	<cfset components = createObject('component','V16.objects.cfc.income_cost')>
	<cfset get_expense = components.getLawRequest(law_id:attributes.law_request_id)>
</cfif>
<cfif isdefined("GET_EXPENSE") and GET_EXPENSE.RECORDCOUNT eq 0>
	<script type="text/javascript">
		alert("<cf_get_lang dictionary_id='34262.Masraf Fişi Yok veya Silinmiş'>");
		history.go(-1);
	</script>
	<cfabort>
</cfif>
<cfquery name="get_document_type" datasource="#dsn#">
	SELECT
		SETUP_DOCUMENT_TYPE.DOCUMENT_TYPE_ID,
		SETUP_DOCUMENT_TYPE.DOCUMENT_TYPE_NAME
	FROM
		SETUP_DOCUMENT_TYPE,
		SETUP_DOCUMENT_TYPE_ROW
	WHERE
		SETUP_DOCUMENT_TYPE_ROW.DOCUMENT_TYPE_ID =  SETUP_DOCUMENT_TYPE.DOCUMENT_TYPE_ID AND
		SETUP_DOCUMENT_TYPE_ROW.FUSEACTION = <cfqueryparam cfsqltype="cf_sql_varchar" value="#fuseaction#">
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
<cfif isdefined("attributes.credit_contract_id") and len(attributes.credit_contract_id)>
	<cfquery name="get_credit" datasource="#dsn3#">
		SELECT COMPANY_ID,PARTNER_ID FROM CREDIT_CONTRACT WHERE CREDIT_CONTRACT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.credit_contract_id#">
	</cfquery>
   <cfquery name="get_project" datasource="#dsn3#">
    	SELECT PROJECT_ID FROM CREDIT_CONTRACT WHERE CREDIT_CONTRACT_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.credit_contract_id#">
    </cfquery>
</cfif>
<cfif isdefined("get_expense")>
	<cfset expense_bank_id = get_expense.expense_cash_id>
	<cfset expense_branch_id = get_expense.branch_id>
	<cfset expense_paymethod_id = get_expense.paymethod_id>
	<cfset expense_due_date = get_expense.due_date>
<cfelse>
	<cfset expense_bank_id = ''>
	<cfset expense_branch_id = ''>
	<cfset expense_paymethod_id = ''>
	<cfset expense_due_date = ''>
</cfif>
<cf_papers paper_type="expense_cost">
<cfset invoice_date = now()>
<cfif isdefined("attributes.receiving_detail_id")>
	<!--- Gelen e-fatura sayfasindaki xml degerleri aliniyor. --->
	<cf_xml_page_edit fuseact="objects.popup_dsp_efatura_detail">
    <cfquery name="GET_INV_DET" datasource="#DSN2#">
    	SELECT ISSUE_DATE,EINVOICE_ID FROM EINVOICE_RECEIVING_DETAIL WHERE RECEIVING_DETAIL_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.receiving_detail_id#">
    </cfquery>
	<cfif isdefined("attributes.company_id") and len(attributes.company_id)>
		<cfquery name="GET_PAYMETHOD" datasource="#DSN#">
			SELECT PAYMETHOD_ID FROM COMPANY_CREDIT WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#"> AND OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.COMPANY_ID#">
		</cfquery>
		<cfset expense_paymethod_id = get_paymethod.paymethod_id>
	</cfif>
    <cfif get_inv_det.recordcount>
    	<cfset invoice_date = get_inv_det.issue_date>
		<cfset PROCESS_date_ = get_inv_det.issue_date>
        <cfif xml_separate_serial_number>
			<cfset paper_number = right(get_inv_det.einvoice_id,13)>
            <cfset paper_code = left(get_inv_det.einvoice_id,3)>
        <cfelse>
        	<cfset paper_number = get_inv_det.einvoice_id>
			<cfset paper_code = ''>            
        </cfif>          
		<script type="text/javascript">
			try{
				window.onload = function () { change_money_info('add_costplan','expense_date');}
			}
			catch(e){}
    	</script>
    </cfif>
</cfif>
<cfif len(expense_paymethod_id)>
	<cfquery name="get_pay_meyhod" datasource="#dsn#">
		SELECT PAYMETHOD,DUE_DAY FROM SETUP_PAYMETHOD WHERE PAYMETHOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#expense_paymethod_id#">
	</cfquery>
	<cfif isdefined("attributes.receiving_detail_id")>
		<cfset expense_due_date = get_pay_meyhod.DUE_DAY>
	</cfif>
</cfif>
<div id="expense_cost_file" style="margin-left:1000px; margin-top:15px; position:absolute;display:none;z-index:9999;"></div><!--- Div disarda olmali --->
	<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
		<cf_box>
			<cfform name="add_costplan" method="post" action="" enctype="multipart/form-data" onsubmit="return unformat_fields();">
				<cf_catalystHeader>
				<cf_basket_form id="add_cost">
					<cfoutput>
						<cfif isdefined("attributes.line_count") and len(attributes.line_count)>
							<input type="hidden" name="line_count" id="line_count" value="#attributes.line_count#">
						</cfif>
						<cfif isdefined("attributes.expense_id") and len(attributes.expense_id)>
							<input type="hidden" name="expense_id" id="expense_id" value="#attributes.expense_id#">
						</cfif>
						<cfif isdefined("attributes.request_id") and len(attributes.request_id)><!--- Harcama Talebinden Donusturme --->
							<input type="hidden" name="request_id" id="request_id" value="#attributes.request_id#">
						</cfif>
						<cfif isdefined("attributes.health_id") and len(attributes.health_id)>
							<input type="hidden" name="health_id" id="health_id" value="#attributes.health_id#">
						</cfif>
						<cfif isDefined("get_expense") and isdefined("get_expense.RELATIVE_ID") and get_expense.RELATIVE_ID neq '' and get_expense.RELATIVE_ID neq 0>
							<input type="hidden" name="relative_id" id="relative_id" value="#get_expense.RELATIVE_ID#">
						</cfif>
						<cfif fuseaction contains "assetcare"><!--- fiziki varliklardan geliyorsa bakım fisi=122 digerleri 120(işlem tipi) --->
							<input type="hidden" name="expense_cost_type" id="expense_cost_type" value="122"><!--- eskisi 17/1200 standart işlem tipleriyle çakışıyordu vs değiştirildi --->
						<cfelseif  fuseaction contains "health">
							<input type="hidden" name="expense_cost_type" id="expense_cost_type" value="1201"><!--- eskisi 18 standart işlem tipleriyle çakışıyordu vs değiştirildi--->
						<cfelse>
							<input type="hidden" name="expense_cost_type" id="expense_cost_type" value="120"><!--- eskisi 18 standart işlem tipleriyle çakışıyordu vs değiştirildi--->
						</cfif>
						<cfif isdefined("attributes.receiving_detail_id")>
							<input type="hidden" name="receiving_detail_id" id="receiving_detail_id" value="<cfoutput>#attributes.receiving_detail_id#</cfoutput>">
						</cfif>
						<input type="hidden" name="budget_period" id="budget_period" value="#dateformat(budget_date.budget_period_date,dateformat_style)#">
						<input type="hidden" name="budget_plan_id" id="budget_plan_id" value="<cfif isdefined("attributes.budget_plan_id") and len(attributes.budget_plan_id)>#attributes.budget_plan_id#</cfif>">
						<input type="hidden" name="credit_contract_id" id="credit_contract_id" value="<cfif isdefined("attributes.credit_contract_id") and len(attributes.credit_contract_id)>#attributes.credit_contract_id#</cfif>">
						<input type="hidden" name="credit_contract_row_id" id="credit_contract_row_id" value="<cfif isdefined("attributes.credit_contract_row_id") and len(attributes.credit_contract_row_id)>#attributes.credit_contract_row_id#</cfif>">
						<input type="hidden" name="is_from_credit" id="is_from_credit" value="<cfif isdefined("attributes.is_from_credit") and len(attributes.is_from_credit)>#attributes.is_from_credit#</cfif>">
						<input type="hidden" name="active_period" id="active_period" value="#session.ep.period_id#">
						<cf_box_elements>
							<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
								<div class="form-group" id="item">
									<div class="col col-12 col-xs-12">
										<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='59328.E-Archive'></label>
										<div class="col col-8 col-xs-12">
											<input type="checkbox" name="is_earchive" id="is_earchive">
										</div>
									</div>
								</div>
								<div class="form-group" id="item-process_cat">
									<div class="col col-4 col-xs-12">
										<label><cf_get_lang dictionary_id="57800.İşlem Tipi"> *</label>
									</div>
									<div class="col col-8 col-xs-12">
										<cf_workcube_process_cat slct_width="135">
									</div>
								</div>
								<div class="form-group" id="item-ch_member_type">
									<div class="col col-4 col-xs-12">
										<label><cf_get_lang dictionary_id="57519.Cari Hesap"></label>
									</div>
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
												<input type="hidden" name="ch_member_type" id="ch_member_type" value="#ch_member_type#">
												<input type="hidden" name="ch_company_id" id="ch_company_id" value="#get_expense.ch_company_id#">
												<input type="hidden" name="ch_partner_id" id="ch_partner_id" value="<cfif ch_member_type eq "partner">#get_expense.ch_partner_id#<cfelseif ch_member_type eq "consumer">#get_expense.ch_consumer_id#</cfif>">
												<input type="hidden" name="emp_id" id="emp_id" value="<cfif ch_member_type eq "employee">#emp_id#</cfif>">
												<input type="text" name="ch_company" id="ch_company" value="<cfif ch_member_type eq "partner">#get_par_info(get_expense.ch_company_id,1,1,0)#<cfelseif ch_member_type eq "consumer">#get_cons_info(get_expense.ch_consumer_id,2,0)#</cfif>" onfocus="AutoComplete_Create('ch_company','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2,3\',\'\',\'\',\'\',\'\',\'\',\'\',\'1\'','MEMBER_TYPE,COMPANY_ID,PARTNER_CODE,EMPLOYEE_ID,MEMBER_PARTNER_NAME','ch_member_type,ch_company_id,ch_partner_id,emp_id,ch_partner','','3','250','get_money_info(\'add_costplan\',\'expense_date\');');" autocomplete="off">
											<cfelseif isdefined("get_credit")>
												<input type="hidden" name="ch_member_type" id="ch_member_type" value="partner">
												<input type="hidden" name="ch_company_id" id="ch_company_id" value="#get_credit.company_id#">
												<input type="hidden" name="ch_partner_id" id="ch_partner_id" value="#get_credit.partner_id#">
												<input type="hidden" name="emp_id" id="emp_id" value="">
												<input type="text" name="ch_company" id="ch_company" value="#get_par_info(get_credit.company_id,1,1,0)#" onfocus="AutoComplete_Create('ch_company','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2,3\',\'\',\'\',\'\',\'\',\'\',\'\',\'1\'','MEMBER_TYPE,COMPANY_ID,PARTNER_CODE,EMPLOYEE_ID,MEMBER_PARTNER_NAME','ch_member_type,ch_company_id,ch_partner_id,emp_id,ch_partner','','3','250','get_money_info(\'add_costplan\',\'expense_date\');');"  autocomplete="off">
											<cfelseif isdefined('attributes.company_id') and len(attributes.company_id)>
												<cfquery name="get_manager_partner" datasource="#dsn#">
													SELECT MANAGER_PARTNER_ID FROM COMPANY WHERE COMPANY_ID = #attributes.company_id#
												</cfquery>
												<cfset partner_id = get_manager_partner.manager_partner_id>
												<cfset partner_name = get_par_info(get_manager_partner.manager_partner_id,0,-1,0)>
												<input type="hidden" name="ch_member_type" id="ch_member_type" value="partner">
												<input type="hidden" name="ch_company_id" id="ch_company_id" value="#attributes.company_id#">
												<input type="hidden" name="ch_partner_id" id="ch_partner_id" value="#partner_id#">
												<input type="hidden" name="emp_id" id="emp_id" value="">
												<input type="text" name="ch_company" id="ch_company" value="#get_par_info(attributes.company_id,1,1,0)#" onfocus="AutoComplete_Create('ch_company','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2,3\',\'\',\'\',\'\',\'\',\'\',\'\',\'1\'','MEMBER_TYPE,COMPANY_ID,PARTNER_CODE,EMPLOYEE_ID,MEMBER_PARTNER_NAME','ch_member_type,ch_company_id,ch_partner_id,emp_id,ch_partner','','3','250','get_money_info(\'add_costplan\',\'expense_date\');');" autocomplete="off">
											<cfelse>
												<input type="hidden" name="ch_member_type" id="ch_member_type" value="">
												<input type="hidden" name="ch_company_id" id="ch_company_id" value="">
												<input type="hidden" name="ch_partner_id" id="ch_partner_id" value="">
												<input type="hidden" name="emp_id" id="emp_id" value="">
												<input type="text" name="ch_company" id="ch_company" onfocus="AutoComplete_Create('ch_company','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2,3\',\'\',\'\',\'\',\'\',\'\',\'\',\'1\'','MEMBER_TYPE,COMPANY_ID,PARTNER_CODE,EMPLOYEE_ID,MEMBER_PARTNER_NAME','ch_member_type,ch_company_id,ch_partner_id,emp_id,ch_partner','','3','250','get_money_info(\'add_costplan\',\'expense_date\');');" autocomplete="off" value="">
											</cfif>
											<span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_pars&is_cari_action=1&field_id=add_costplan.ch_partner_id&field_adress_id=add_costplan.ship_address_id&field_long_address=add_costplan.adres&field_comp_name=add_costplan.ch_company&field_name=add_costplan.ch_partner&field_comp_id=add_costplan.ch_company_id&field_type=add_costplan.ch_member_type&field_emp_id=add_costplan.emp_id&field_paymethod_id=add_costplan.paymethod&field_paymethod=add_costplan.paymethod_name&field_basket_due_value=add_costplan.basket_due_value&call_function=change_due_date()<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&isClosed=0&select_list=1,2,3,9');"></span>
										</div>
									</div>
								</div>
								<div class="form-group" id="item-ch_partner">
									<div class="col col-4 col-xs-12">
										<label><cf_get_lang dictionary_id="57578.Yetkili"></label>
									</div>
									<div class="col col-8 col-xs-12">
										<input type="text" name="ch_partner" id="ch_partner"  value="<cfif isdefined("get_expense")><cfif ch_member_type eq "partner">#get_par_info(get_expense.ch_partner_id,0,-1,0)#<cfelseif ch_member_type eq "consumer">#get_cons_info(get_expense.ch_consumer_id,0,0)#<cfelseif ch_member_type eq "employee">#get_emp_info(get_expense.ch_employee_id,0,0,0,get_expense.acc_type_id)#</cfif><cfelseif isdefined("get_credit.partner_id") and len(get_credit.partner_id)>#get_par_info(get_credit.partner_id,0,-1,0)#<cfelseif isdefined("partner_name") and len(partner_name)>#partner_name#</cfif>">
									</div>
								</div>
								<div class="form-group" id="item-expense_employee">
									<div class="col col-4 col-xs-12">
										<label><cfif attributes.fuseaction eq 'health.expenses'><cf_get_lang dictionary_id="31173.Harcama yapan"><cfelse><cf_get_lang dictionary_id="51313.Ödeme Yapan"></cfif></label>
									</div>
									<div class="col col-8 col-xs-12">
										<div class="input-group">
											<cfset emp_id_exp_pos = "">
											<cfif isdefined("get_expense")>
												<cfset emp_id_exp = get_expense.emp_id>
												<cfif len(get_expense.acc_type_id_exp)>
													<cfset emp_id_exp = "#emp_id_exp#_#get_expense.acc_type_id_exp#">
												</cfif>
												<cfset emp_id_exp_pos = get_expense.POSITION_CODE>
											<cfelseif is_default_employee eq 1>
												<cfset emp_id_exp = attributes.expense_employee_id>
												<cfset emp_id_exp_pos = session.ep.position_code>
											</cfif>
											<input type="hidden" name="expense_employee_id" id="expense_employee_id" value="<cfif isdefined("get_expense")>#emp_id_exp#<cfelseif is_default_employee eq 1>#attributes.expense_employee_id#</cfif>">
											<input type="hidden" name="expense_employee_type" id="expense_employee_type" value="<cfif isdefined("get_expense")>employee</cfif>">
											<input type="text" name="expense_employee"  id="expense_employee" style="width:135px;" onfocus="AutoComplete_Create('expense_employee','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','\'3\',\'0\',\'0\',\'0\',\'\',\'\',\'\',\'1\'','EMPLOYEE_ID,MEMBER_TYPE','expense_employee_id,expense_employee_type','','3','135');" value="<cfif isdefined("get_expense")>#get_emp_info(get_expense.emp_id,0,0,0,get_expense.acc_type_id_exp)#<cfelseif is_default_employee eq 1>#attributes.expense_employee#</cfif>" autocomplete="off">
											<cfinput type="hidden" name="expense_employee_position" id="expense_employee_position" value="#emp_id_exp_pos#">
											<span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_positions&field_code=add_costplan.expense_employee_position&is_cari_action=1&field_emp_id=add_costplan.expense_employee_id&field_name=add_costplan.expense_employee&field_type=add_costplan.expense_employee_type&select_list=1,9');"></span>
										</div>
									</div>
								</div>
								<cfif session.ep.our_company_info.is_efatura eq 1>
									<div class="form-group" id="item-ship_address">
										<div class="col col-4 col-xs-12">
											<label><cf_get_lang dictionary_id="58061.Cari"> <cf_get_lang dictionary_id="57453.Şube"></label>
										</div>
										<div class="col col-8 col-xs-12">
											<div class="input-group">
												<input type="hidden" name="ship_address_id" id="ship_address_id" value="<cfif isdefined("get_expense") and len(get_expense.SHIP_ADDRESS_ID)><cfoutput>#get_expense.SHIP_ADDRESS_ID#</cfoutput></cfif>" />
												<input type="text" name="adres" id="adres" value="<cfif isdefined("get_expense") and len(get_expense.SHIP_ADDRESS)><cfoutput>#get_expense.SHIP_ADDRESS#</cfoutput></cfif>" style="width:135px;"/>
												<span class="input-group-addon btnPointer icon-ellipsis" onclick="add_adress();"></span>
											</div>
										</div>
									</div>
								</cfif>
							</div>
							<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
								<cfif isdefined("xml_show_process_stage") and len(xml_show_process_stage) and xml_show_process_stage eq 1>
									<div class="form-group" id="item-process_stage">
										<div class="col col-4 col-xs-12">
											<label><cf_get_lang dictionary_id='58859.Süreç'></label>
										</div>
										<div class="col col-8 col-xs-12">
											<cf_workcube_process is_upd='0' process_cat_width='150' is_detail='0'>
										</div>
									</div>
								</cfif>   
								<div class="form-group" id="item-serial_no_">
									<div class="col col-4 col-xs-12">
										<label><cf_get_lang dictionary_id="57637.Seri No"> *</label>
									</div>
									<div class="col col-8 col-xs-12">
										<cfif xml_paper_no_control eq 1>
											<input type="hidden" name="paper_control_" id="paper_control_" value="1" />
										<cfelse>
											<input type="hidden" name="paper_control_" id="paper_control_" value="0" />
										</cfif>
										<div class="col col-6 col-xs-12">
											<input type="text" name="serial_number" id="serial_number" value="#paper_code#" maxlength="5">
										</div>
										<div class="col col-6 col-xs-12">
											<input type="text" name="serial_no" id="serial_no" value="#paper_number#" maxlength="45" onblur="paper_control(this,'EXPENSE_COST',true,0,'',<cfif xml_paper_no_control eq 1>add_costplan.ch_company_id.value,add_costplan.ch_partner_id.value<cfelse>'',''</cfif>,'','',1,add_costplan.serial_number);">
										</div>
									</div>
								</div>
								<div class="form-group" id="item-expense_date">
									<div class="col col-4 col-xs-12">
										<label><cf_get_lang dictionary_id="51308.Belge Tarihi"> *</label>
									</div>
									<div class="col col-8 col-xs-12">
										<div class="input-group">
											<input type="text" name="expense_date" id="expense_date" value="<cfif isdefined("get_expense")>#dateformat(get_expense.expense_date,dateformat_style)#<cfelse>#dateformat(invoice_date,dateformat_style)#</cfif>"maxlength="10" onchange="change_paper_duedate();" onblur="change_product_cost()&change_money_info('add_costplan','expense_date');changeProcessDate();">
											<span class="input-group-addon btnPointer"><cf_wrk_date_image function_currency_type="#xml_money_type#" date_field="expense_date" call_function="change_money_info&change_product_cost&changeProcessDate"></span>
											<cfif isdefined("get_expense") and isdefined("get_expense.expense_date_time") and len(get_expense.expense_date_time)>
												<cfset value_start_h = hour(get_expense.expense_date_time)>
												<cfset value_start_m = minute(get_expense.expense_date_time)>
											<cfelse>
												<cfset value_start_h = hour(dateadd('h',session.ep.time_zone,now()))>
												<cfset value_start_m = minute(now())>
											</cfif>
										</div>
									</div>	
								</div>
								<div class="form-group" id="item-hours">
									<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57491.Hour'> *</label>
									<div class="col col-8 col-xs-12">
										<cfoutput>
											<div class="col col-6 col-xs-12">
												<cf_wrkTimeFormat name="expense_date_h" value="#value_start_h#">
											</div>
											<div class="col col-6 col-xs-12">
												<select name="expense_date_m" id="expense_date_m">
													<cfloop from="0" to="59" index="i">
														<option value="#NumberFormat(i)#" <cfif value_start_m eq i>selected</cfif>><cfif i lt 10>0</cfif>#NumberFormat(i)# </option>
													</cfloop>
												</select>
											</div>
										</cfoutput>
									</div>	
								</div>
								<div class="form-group" id="item-process_date">
									<div class="col col-4 col-xs-12">
										<label><cf_get_lang dictionary_id='57879.İşlem Tarihi'> *</label>
									</div>
									<div class="col col-8 col-xs-12">
										<div class="input-group">
											<cfif isdefined("get_expense") and len(get_expense.process_date)>
												<cfset p_date = get_expense.process_date>
											<cfelseif isdefined("get_expense") and len(get_expense.expense_date)>
												<cfset p_date = get_expense.expense_date>
											<cfelseif isdefined("process_date_")>
												<cfset p_date = process_date_>
											<cfelse>
												<cfset p_date = now()>
											</cfif>
											<cfinput type="text" name="process_date" required="Yes" message="#getLang('','İşlem Tarihi Girmelisiniz',57906)#" value="#dateformat(p_date,dateformat_style)#" validate="#validate_style#" readonly="readonly">
											<span class="input-group-addon btnPointer" title="<cf_get_lang dictionary_id='57734.seçiniz'>"><cf_wrk_date_image date_field="process_date" id="process_date_image" control_date="#dateformat(p_date,dateformat_style)#"></span>
										</div>
									</div>
								</div>
								<cfif xml_acc_department_info>
									<div class="form-group" id="item-acc_department_id">
										<div class="col col-4 col-xs-12">
											<label><cf_get_lang dictionary_id="57572.Departman"></label>
										</div>
										<div class="col col-8 col-xs-12">
											<cfif isdefined("get_expense.ACC_DEPARTMENT_ID") and len(get_expense.ACC_DEPARTMENT_ID)>
												<cfset acc_info = get_expense.ACC_DEPARTMENT_ID>
											<cfelse>
												<cfset acc_info = ''>
											</cfif>
											<cf_wrkdepartmentbranch fieldid='acc_department_id' is_department='1' width='135' is_deny_control='0' selected_value='#acc_info#'>
										</div>
									</div>
								</cfif>
								<cfif ListFind(ListDeleteDuplicates(xml_order_list_rows),6) or x_is_project_priority eq 1>
									<div class="form-group" id="item-department_location">
										<div class="col col-4 col-xs-12">
											<label><cf_get_lang dictionary_id="58763.Depo"></label>
										</div>
										<div class="col col-8 col-xs-12">
											<cfif isdefined("get_expense")><cfset location_info_ = get_location_info(get_expense.department_id,get_expense.location_id,1,1)></cfif>
											<cfif isdefined("get_expense")>
													<cf_wrkdepartmentlocation
													returninputvalue="location_id,department_name,department_id,branch_id"
													returnqueryvalue="LOCATION_ID,LOCATION_NAME,DEPARTMENT_ID,BRANCH_ID"
													fieldname="department_name"
													fieldid="location_id"
													department_fldid="department_id"
													branch_fldid="branch_id"
													branch_id="#listlast(location_info_,',')#"
													department_id="#get_expense.department_id#"
													location_id="#get_expense.location_id#"
													location_name="#listfirst(location_info_,',')#"
													user_level_control="#session.ep.OUR_COMPANY_INFO.IS_LOCATION_FOLLOW#"
													width="135">
												<cfelse>
													<cf_wrkdepartmentlocation
													returninputvalue="location_id,department_name,department_id,branch_id"
													returnqueryvalue="LOCATION_ID,LOCATION_NAME,DEPARTMENT_ID,BRANCH_ID"
													fieldname="department_name"
													fieldid="location_id"
													department_fldid="department_id"
													user_level_control="#session.ep.OUR_COMPANY_INFO.IS_LOCATION_FOLLOW#"
													width="135">
											</cfif> 
										</div>
									</div>
								</cfif>
								<cfif x_select_project eq 1 or x_select_project eq 2>
									<div class="form-group" id="item-project_head">
										<div class="col col-4 col-xs-12">
											<label><cf_get_lang dictionary_id="57416.Proje"></label>
										</div>
										<div class="col col-8 col-xs-12">
											<div class="input-group">
												<input type="hidden" name="project_id" id="project_id" value="<cfif isdefined('get_expense.project_id')>#get_expense.project_id#<cfelseif isdefined('get_project.project_id')>#get_project.project_id#</cfif>">
												<input type="text" name="project_head" id="project_head" value="<cfif isdefined('get_expense.project_id') and len(get_expense.project_id)>#GET_PROJECT_NAME(get_expense.project_id)#<cfelseif isdefined('get_project.project_id') and len(get_project.project_id)>#GET_PROJECT_NAME(get_project.project_id)#</cfif>" 
												onfocus="AutoComplete_Create('project_head','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','add_costplan','3','135')" autocomplete="off">
												<span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_projects&project_id=add_costplan.project_id&project_head=add_costplan.project_head');"></span>
											</div>
										</div>
									</div>
								</cfif>
							</div>
							<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
								<div class="form-group" id="item-payment_method">
									<div class="col col-4 col-xs-12">
										<label><cf_get_lang dictionary_id="58516.Ödeme Yöntemi"></label>
									</div>
									<div class="col col-8 col-xs-12">
										<div class="input-group"> 
											<input type="hidden" name="paymethod" id="paymethod" value="#expense_paymethod_id#">
											<input type="text" name="paymethod_name" id="paymethod_name" value="<cfif len(expense_paymethod_id)>#get_pay_meyhod.paymethod#</cfif>" onchange="change_paper_duedate2();">
											<span title="<cfoutput>#getLang('main','Seçiniz',57734)#</cfoutput>" class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('#request.self#?fuseaction=objects.popup_paymethods&field_id=add_costplan.paymethod&field_dueday=add_costplan.basket_due_value&field_name=add_costplan.paymethod_name&is_paymethods=1&function_name=change_due_date','list');"></span>
										</div>
									</div>
								</div>
								<div class="form-group" id="item-basket_due_value">
									<div class="col col-4 col-xs-12">
										<label><cf_get_lang dictionary_id="57640.Vade"></label>
									</div>
									<div class="col col-8 col-xs-12">
										<cfsavecontent variable="message"><cf_get_lang dictionary_id ='33756.Vade Tarihi İçin Geçerli Bir Format Giriniz'>!</cfsavecontent>
										<cfif isdefined("get_expense") or isdefined("attributes.receiving_detail_id")>
											<div class="col col-4 col-xs-12">
												<input type="text" name="basket_due_value" id="basket_due_value" value="<cfif len(expense_due_date)><cfif isdefined("get_expense")>#datediff('d',get_expense.expense_date,expense_due_date)#<cfelse>#expense_due_date#</cfif></cfif>"  onchange="change_due_date();change_paper_duedate();">
											</div>
											<div class="col col-8 col-xs-12">
												<div class="input-group">
													<cfif isdefined("attributes.receiving_detail_id")>
														<cfif len(expense_due_date)>
															<cfinput type="text" name="basket_due_value_date_" id="basket_due_value_date_" value="#dateformat(dateAdd('d',expense_due_date,now()),dateformat_style)#" onChange="change_due_date(1);" validate="#validate_style#" message="#message#" maxlength="10" readonly>
															<span class="input-group-addon btnPointer">
																<cf_wrk_date_image date_field="basket_due_value_date_">
															</span>
														<cfelse>
															<cfinput type="text" name="basket_due_value_date_" id="basket_due_value_date_" value="" onChange="change_due_date(1);" validate="#validate_style#" message="#message#" maxlength="10" readonly>
															<span class="input-group-addon btnPointer">
																<cf_wrk_date_image date_field="basket_due_value_date_">
															</span>
														</cfif>
													<cfelse>
														<cfinput type="text" name="basket_due_value_date_" id="basket_due_value_date_" value="#dateformat(get_expense.expense_date,dateformat_style)#" onChange="change_due_date(1);" validate="#validate_style#" message="#message#" maxlength="10" readonly>
														<span class="input-group-addon btnPointer">
															<cf_wrk_date_image date_field="basket_due_value_date_">
														</span>
													</cfif>
												</div>
											</div>
										<cfelse>
											<div class="col col-4 col-xs-12">
												<input type="text" name="basket_due_value" id="basket_due_value" value="" onchange="change_due_date();">
											</div>
											<div class="col col-8 col-xs-12">
												<div class="input-group">
													<cfinput type="text" name="basket_due_value_date_" id="basket_due_value_date_" value="#dateformat(now(),dateformat_style)#" onChange="change_due_date(1);" validate="#validate_style#" message="#message#" maxlength="10" readonly>
													<span class="input-group-addon btnPointer">
														<cf_wrk_date_image date_field="basket_due_value_date_">
													</span>
												</div>
											</div>
										</cfif>
									</div>
								</div>
								<div class="form-group" id="item-document_type">
									<div class="col col-4 col-xs-12">
										<label><cf_get_lang dictionary_id="58578.Belge Türü"></label>
									</div>
									<div class="col col-8 col-xs-12">
										<select name="expense_paper_type" id="expense_paper_type">
											<option value=""><cf_get_lang dictionary_id='58578.Belge Türü'></option>
											<cfloop query="get_document_type">
												<option value="#document_type_id#" <cfif isdefined("get_expense") and get_expense.paper_type eq document_type_id>selected</cfif>>#document_type_name#</option>
											</cfloop>
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
								<div class="form-group" id="item-system_relation">
									<div class="col col-4 col-xs-12">
										<label><cf_get_lang dictionary_id="58794.Referans No"></label>
									</div>
									<div class="col col-8 col-xs-12">
										<input type="text" maxlength="250" name="system_relation" id="system_relation" value="<cfif isdefined("get_expense")>#get_expense.system_relation#</cfif>">
									</div>
								</div>
								<div class="form-group" id="item-tax_code">
									<div class="col col-4 col-xs-12">
										<label><cf_get_lang dictionary_id="30006.Vergi Kodu"></label>
									</div>
									<div class="col col-8 col-xs-12">
										<input type="text" name="tax_code" id="tax_code" value="<cfif isdefined("get_expense.tax_code") and len(get_expense.tax_code)>#get_expense.tax_code	#</cfif>">
									</div>
								</div>
								
								<div class="form-group" id="item-wrk_add_info">
									<div class="col col-4 col-xs-12">
										<label><cf_get_lang dictionary_id="57810.Ek Bilgi"></label>
									</div>
									<div class="col col-8 col-xs-12"><cf_wrk_add_info info_type_id="-17" upd_page = "0" colspan="9"></div>
								</div>
							</div>
							<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="4" sort="true">
								<div class="form-group" id="item-detail">
									<div class="col col-4 col-xs-12">
										<label><cf_get_lang dictionary_id="57629.Açıklama"></label>
									</div>
									<div class="col col-8 col-xs-12">
										<textarea name="detail" id="detail"><cfif isdefined("get_expense.detail")>#get_expense.detail#</cfif></textarea>
									</div>
								</div>
								<cfif x_select_branch eq 1 or session.ep.isBranchAuthorization eq 1>
									<div class="form-group" id="item-branch_id">
										<div class="col col-4 col-xs-12">
											<label><cf_get_lang dictionary_id="57453.Şube"></label>
										</div>
										<div class="col col-8 col-xs-12">
											<cf_wrkdepartmentbranch fieldid='branch_id_' is_branch='1' width='135' is_default='1' is_deny_control='1' selected_value='#expense_branch_id#'>
										</div>
									</div>
								</cfif>
								
								<div id="hidden_fields" style="display:none;"></div>
								
								<cfif attributes.fuseaction neq 'health.expenses'>
									<div class="form-group" id="item-checkboxes">
											<!--- <div class="col col-12 col-xs-12">
												<label class="hide"><cf_get_lang dictionary_id="58199.Kredi Kartı">/<cf_get_lang dictionary_id="58645.Nakit">/<cf_get_lang dictionary_id="57521.Banka"></label>
											</div> --->
											<div class="col col-12 col-xs-12"><!---  --->
												<label><cf_get_lang dictionary_id="58199.Kredi Kartı"><input type="checkbox" name="credit" id="credit" onclick="ayarla_gizle_goster(3);" <cfif isdefined("get_expense") and get_expense.is_creditcard eq 1>checked</cfif>></label>
												<label><cf_get_lang dictionary_id="58645.Nakit"><input type="Checkbox" name="cash" id="cash" onclick="ayarla_gizle_goster(1);" <cfif isdefined("get_expense") and get_expense.is_cash eq 1>checked</cfif>></label>
												<label><cf_get_lang dictionary_id="57521.Banka"><input type="checkbox" name="bank" id="bank" onclick="ayarla_gizle_goster(2);" <cfif isdefined("get_expense") and get_expense.is_bank eq 1>checked</cfif>></label>
													<cfif isdefined("get_expense") and get_expense.is_creditcard eq 1>
														<cfquery name="get_credit_info" datasource="#dsn3#">
															SELECT CREDITCARD_ID,INSTALLMENT_NUMBER,DELAY_INFO FROM CREDIT_CARD_BANK_EXPENSE WHERE EXPENSE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_expense.expense_id#"> AND ACTION_PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">
														</cfquery>
														<cfset ins_info = get_credit_info.INSTALLMENT_NUMBER>
														<cfset delay_info = get_credit_info.DELAY_INFO>
														<cfset credit_info = get_credit_info.CREDITCARD_ID>
													<cfelse>
														<cfset ins_info = ''>
														<cfset delay_info = ''>
														<cfset credit_info = ''>
													</cfif>
											</div>
									</div>

									
										<div <cfif isdefined("get_expense") and get_expense.is_cash eq 1>style="display:'';"<cfelseif  isdefined("get_expense") and get_expense.is_cash eq 0>style="display:none;"<cfelse>style="display:none;"</cfif> id="kasa2">
											<div class="form-group" id="item-boxes-child-expense">
												<div class="col col-4 col-xs-12">
													<label><cf_get_lang dictionary_id='57520.Kasa'></label>
												</div>
												<div class="col col-8 col-xs-12">															
													<cfif isdefined("get_expense") and fusebox.use_period eq true>
														<cf_wrk_Cash name="kasa" acc_code="0" cash_status="1" currency_branch="0" value="#get_expense.expense_cash_id#">
													<cfelse>
														<cf_wrk_Cash name="kasa" acc_code="0" cash_status="1" currency_branch="0">
													</cfif>
												</div>
											</div>
										</div>
									

									<div <cfif isdefined("get_expense") and get_expense.is_bank eq 1>style="display:'';"<cfelseif isdefined("get_expense") and get_expense.is_bank eq 0>style="display:none;"<cfelse>style="display:none;"</cfif> id="banka2">
										<div class="form-group">
											<div class="col col-4 col-xs-12">
												<label><cf_get_lang dictionary_id='57652.Hesap'></label>
											</div>
											<div class="col col-8 col-xs-12"><cf_wrkbankaccounts width='135' control_status='1' selected_value='#expense_bank_id#'></div>
										</div>
									</div>
								
									<div <cfif isdefined("get_expense") and get_expense.is_creditcard eq 1>style="display:'';"<cfelse>style="display:none;"</cfif> id="credit2">
										<div class="form-group" id="item-checkboxes-child-credit">
											<div class="col col-4 col-xs-12">
												<label><cf_get_lang dictionary_id='58199.Kredi Kartı'></label>
											</div>
											<div class="col col-8 col-xs-12">
												<cf_wrk_our_credit_cards slct_width="135" credit_card_info="#credit_info#">
											</div>
										</div>
										<div class="form-group" id="item-checkboxes-child-inst">
											<div class="col col-4 col-xs-12">
												<label><cf_get_lang dictionary_id ='32505.Taksit'></label>
											</div>
											<div class="col col-8 col-xs-12">
												<cfinput type="text" name="inst_number" id="inst_number" value="#ins_info#" onkeyup="return(formatcurrency(this,event,0,'int'));" class="moneybox">
											</div>
										</div>
										<div class="form-group" id="item-checkboxes-child-delay">
											<div class="col col-4 col-xs-12">
												<label><cf_get_lang dictionary_id='32752.Erteleme'> - <cf_get_lang dictionary_id='58724.Ay'></label>
											</div>
											<div class="col col-8 col-xs-12">
												<cfinput type="text" name="delay_info" id="delay_info" value="#delay_info#" onkeyup="return(formatcurrency(this,event,0,'int'));" class="moneybox">
											</div>
										</div>
									</div>
								</cfif>

							</div>
						</cf_box_elements>
						<cf_box_footer>
							<div>
								<cf_workcube_buttons is_upd='0' add_function='kontrol()'>
							</div>
						</cf_box_footer>
					</cfoutput>
				</cf_basket_form>
				<cf_basket id="list_plan_rows_cost_div">
					<cfinclude template="../display/list_plan_rows_cost.cfm">
				</cf_basket>
				<cfoutput>
					<div class="col col-12 col-xs-12">
						<div id="sepetim_total">
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
										<cfif fusebox.use_period eq true>
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
													<td>
														<input type="hidden" name="hidden_rd_money_#currentrow#" id="hidden_rd_money_#currentrow#" value="#money#">
														<input type="hidden" name="txt_rate1_#currentrow#" id="txt_rate1_#currentrow#" value="#rate1#">
														<input type="radio" name="rd_money" id="rd_money" value="#money#,#currentrow#,#rate1#,#rate2#,#rate3#" onclick="other_calc();" <cfif isDefined('str_money_bskt') and str_money_bskt eq money>checked</cfif>>
													</td>
													<cfif session.ep.rate_valid eq 1>
														<cfset readonly_info = "yes">
													<cfelse>
														<cfset readonly_info = "no">
													</cfif>
													<td>#money#</td>
													<td>#TLFormat(rate1,0)#/</td>
													<cfif isDefined('xml_money_type') and (xml_money_type eq 0 or xml_money_type eq 2)>
														<td valign="bottom"><input type="text" id="txt_rate2_#currentrow#" <cfif readonly_info>readonly</cfif> class="box" name="txt_rate2_#currentrow#"<cfif money eq session.ep.money>readonly="yes"</cfif> value="#TLFormat(rate2,session.ep.our_company_info.rate_round_num)#" onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.rate_round_num#));" onblur="other_calc();"></td>
													<cfelseif isDefined('xml_money_type') and xml_money_type eq 1>
														<td valign="bottom"><input type="text" id="txt_rate2_#currentrow#" <cfif readonly_info>readonly</cfif> class="box" name="txt_rate2_#currentrow#"<cfif money eq session.ep.money>readonly="yes"</cfif> value="#TLFormat(rate3,session.ep.our_company_info.rate_round_num)#" onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.rate_round_num#));" onblur="other_calc();"></td>
													</cfif>
												</tr>
											</cfloop>
										</cfif>
										
										</table>
										
									</div>
								</div>
							</div>
							<div class="col col-3 col-sm-6 col-xs-12">
								<div class="totalBox">
									<div class="totalBoxHead font-grey-mint">
										<span class="headText"><cf_get_lang dictionary_id='57492.Toplam'></span>
										<div class="collapse">
											<span class="icon-minus"></span>
										</div>
									</div>
									<div class="totalBoxBody">
										<table>
											<cfif xml_discount>
												<tr>
													<td class="txtbold"><cf_get_lang dictionary_id='57649.Toplam İndirim'></td>
													<td style="text-align:right;"><input type="text" name="total_discount" id="total_discount" class="box" readonly="" <cfif isdefined("attributes.expense_id")>value="#TLFormat(get_expense.total_amount,xml_genel_number)#" <cfelse> value="0"</cfif>value="0"></td>
													<td>#session.ep.money#</td>
													</tr>
											</cfif>
											<tr>
												<td class="txtbold"><cf_get_lang dictionary_id='57492.Toplam'></td>
												<td style="text-align:right;"><input type="text" name="total_amount" id="total_amount" class="box" readonly="" <cfif isdefined("attributes.expense_id")>value="#TLFormat(get_expense.total_amount,xml_genel_number)#" <cfelse> value="0"</cfif>value="0"></td>
												<td>#session.ep.money#</td>	
											</tr>
											<tr>
												<td class="txtbold"><cf_get_lang dictionary_id='33213.Toplam KDV'></td>
												<td style="text-align:right;"><input type="text" name="kdv_total_amount" id="kdv_total_amount" class="box" readonly="" <cfif isdefined("attributes.expense_id")><cfif not isdefined("attributes.from_health_approve")>value="#TLFormat(get_expense.kdv_total,xml_genel_number)#"<cfelse>value="#TLFormat(get_expense.net_kdv_amount,xml_genel_number)#"</cfif><cfelse>value="0"</cfif>></td>
												<td>#session.ep.money#</td>
												</tr>
											<tr>
												<td class="txtbold"><cf_get_lang dictionary_id='57492.Toplam'> <cf_get_lang dictionary_id='58021.ÖTV'></td>
												<td style="text-align:right;"><input type="text" name="otv_total_amount" id="otv_total_amount" class="box" readonly="" <cfif isdefined("attributes.expense_id")><cfif not isdefined("attributes.from_health_approve")>value="#TLFormat(get_expense.otv_total,xml_genel_number)#"<cfelse>value="0"</cfif><cfelse>value="0"</cfif> ></td>
												<td>#session.ep.money#</td>
											</tr>
											<tr>
												<td class="txtbold"><cf_get_lang dictionary_id="50923.BSMV"></td>
												<td style="text-align:right;"><input type="text" name="bsmv_total_amount" id="bsmv_total_amount" class="box" readonly="" <cfif isdefined("attributes.expense_id")><cfif not isdefined("attributes.from_health_approve")>value="#TLFormat(get_expense.otv_total,xml_genel_number)#"<cfelse>value="0"</cfif><cfelse>value="0"</cfif> ></td>
												<td>#session.ep.money#</td>
											</tr>
											<tr>
												<td class="txtbold"><cf_get_lang dictionary_id="50982.OIV"></td>
												<td style="text-align:right;"><input type="text" name="oiv_total_amount" id="oiv_total_amount" class="box" readonly="" <cfif isdefined("attributes.expense_id")><cfif not isdefined("attributes.from_health_approve")>value="#TLFormat(get_expense.otv_total,xml_genel_number)#"<cfelse>value="0"</cfif><cfelse>value="0"</cfif> ></td>
												<td>#session.ep.money#</td>
											</tr>
											<tr>
												<td class="txtbold">
												<a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_stoppage_rates&field_stoppage_rate=add_costplan.stopaj_yuzde&field_stoppage_rate_id=add_costplan.stopaj_rate_id&field_decimal=#xml_genel_number#&call_function=toplam_hesapla()</cfoutput>','list')"><img src="/images/plus_small.gif" title="Stopaj Oranları"></a>
												<cf_get_lang dictionary_id='57711.Stopaj'>%</td><input type="hidden" name="stopaj_rate_id" id="stopaj_rate_id" value="<cfif isdefined("get_expense")>#get_expense.stopaj_rate_id#</cfif>">
												<td style="width:40px;">
													<input type="text" name="stopaj_yuzde" id="stopaj_yuzde" class="box" onblur="calc_stopaj();" onkeyup="return(FormatCurrency(this,event,0));" value="<cfif isdefined("get_expense")>#TLFormat(get_expense.stopaj_oran,xml_genel_number)#<cfelse>#Tlformat(0)#</cfif>" autocomplete="off">
												
												<input type="text" class="box" name="stopaj" id="stopaj" value="<cfif isdefined("get_expense")>#TLFormat(get_expense.stopaj)#<cfelse>#Tlformat(0)#</cfif>" <cfif x_is_change_stopaj eq 0>readonly="readonly"</cfif> onblur="toplam_hesapla(1);"></td>
											</tr>
											<tr>
												<td class="txtbold"><cf_get_lang dictionary_id='57710.Yuvarlama'></td>
												<td>
													<input type="text" name="yuvarlama" id="yuvarlama" class="box" onfocus="if(this.value == '0,00') this.value = '';" onblur="if(this.value.length == 0) this.value = '0,00';toplam_hesapla(0);" onkeyup="return(FormatCurrency(this,event,#xml_genel_number#));" value="<cfif isdefined("get_expense.round_money")>#TLFormat(get_expense.round_money,xml_genel_number)#<cfelse>#TLFormat(0,xml_genel_number)#</cfif>" autocomplete="off">
												</td>
												
											</tr>
											<tr>
												<td class="txtbold"><cf_get_lang dictionary_id='34019.KDV li Toplam'></td>
												<td style="text-align:right;"><input type="text" name="net_total_amount" id="net_total_amount" class="box" readonly="" <cfif isdefined("attributes.expense_id")><cfif not isdefined("attributes.from_health_approve")>value="#TLFormat(get_expense.total_amount_kdvli,xml_genel_number)#"<cfelse>value="#TLFormat(get_expense.net_total_amount,xml_genel_number)#"</cfif><cfelse>value="0"</cfif>></td>
												<td>#session.ep.money#</td>	
											</tr>
									</table>
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
											<tr>
												<td class="txtbold" style="text-align:right;"><cf_get_lang dictionary_id='58124.Döviz Toplam'></td>
												<td id="rate_value1" style="text-align:right;">
													<input type="text" name="other_total_amount" id="other_total_amount" class="box" readonly="" <cfif isdefined("attributes.expense_id")>value="#TLFormat(get_expense.other_money_amount,xml_genel_number)#" <cfelse>value=""</cfif>>
												</td>
												<td><input type="text" name="tl_value1" id="tl_value1" class="box" readonly="" <cfif isdefined("attributes.expense_id")>value="#get_expense.other_money#" <cfelse>value="" </cfif>style="width:40px;"></td>
											</tr>
											<tr>
												<td class="txtbold" style="text-align:right;"><cf_get_lang no='824.Döviz KDV'></td>
												<td style="text-align:right;">
													<input type="text" name="other_kdv_total_amount" id="other_kdv_total_amount" class="box" readonly="" <cfif isdefined("attributes.expense_id")>value="#TLFormat(get_expense.other_money_kdv,xml_genel_number)#"<cfelse>value="0"</cfif>>
												</td>
												<td><input type="text" name="tl_value2" id="tl_value2" class="box" readonly="" <cfif isdefined("attributes.expense_id")> value="#get_expense.other_money#" <cfelse>value="" </cfif>style="width:40px;"></td>
											</tr>
											<tr>
												<td class="txtbold" style="text-align:right;"><cf_get_lang dictionary_id='58021.ÖTV'> <cf_get_lang dictionary_id='57673.Tutar'></td>
												<td style="text-align:right;">
													<input type="text" name="other_otv_total_amount" id="other_otv_total_amount" class="box" readonly="" <cfif isdefined("attributes.expense_id")><cfif not isdefined("attributes.from_health_approve")>value="#TLFormat(get_expense.other_money_otv,xml_genel_number)#"<cfelse>value="0"</cfif><cfelse>value="0"</cfif>>
												</td>
											<td><input type="text" name="tl_value4" id="tl_value4" class="box" readonly=""  <cfif isdefined("attributes.expense_id")> value="#get_expense.other_money#" <cfelse>value="" </cfif> style="width:40px;"></td>
											</tr>
											<tr>
												<td class="txtbold" style="text-align:right;"><cf_get_lang dictionary_id='33215.Döviz KDV li Toplam'></td>
												<td style="text-align:right;">
													<input type="text" name="other_net_total_amount" id="other_net_total_amount" class="box" readonly="" <cfif isdefined("attributes.expense_id")>value="#TLFormat(get_expense.other_money_net_total,xml_genel_number)#"<cfelse>value="0"</cfif>>
												</td>
												<td><input type="text" name="tl_value3" id="tl_value3" class="box" readonly="" <cfif isdefined("attributes.expense_id")> value="#get_expense.other_money#" <cfelse>value="" </cfif> style="width:40px;"></td>
											</tr>
										</table>
									</div>
								</div>
							</div>
							<div class="col col-3 col-sm-6 col-xs-12">
								<div class="totalBox">
										<cfif not fuseaction contains "assetcare">
											<div class="totalBoxHead font-grey-mint">
												<span class="headText"><cf_get_lang dictionary_id='59181.Vergi'></span>
												<div class="collapse">
													<span class="icon-minus"></span>
												</div>
											</div>
										
										</cfif>
										<div class="totalBoxBody">  

											<table>
												<tr class="color-list" height="20">
													<td id="td_kdv_list"></td>
												</tr>
												<tr height="20">
													<td id="td_otv_list"></td>
												</tr>
											</table>
											
											<table>
											<tr class="color-list" height="20">
												<td id="td_bsmv_list"></td>
											</tr>
											<tr class="color-list" height="20">
												<td id="td_oiv_list"></td>
											</tr>
											<tr>
											<td colspan="2">
												<input type="checkbox" name="tevkifat_box" id="tevkifat_box" onclick="gizle_goster(tevkifat_oran);gizle_goster(tevkifat_plus);gizle_goster(tevk_1);gizle_goster(tevk_2);gizle_goster(beyan_1);gizle_goster(beyan_2);toplam_hesapla();" <cfif isdefined("get_expense") and get_expense.tevkifat eq 1>checked</cfif>>
												<b><cf_get_lang dictionary_id='58022.Tevkfat'></b>
												<input type="hidden" id="tevkifat_id" name="tevkifat_id" <cfif isdefined("get_expense") and len(get_expense.tevkifat_id)>value="<cfoutput>#get_expense.tevkifat_id#</cfoutput>"</cfif>>
												<input type="text" name="tevkifat_oran" id="tevkifat_oran" <cfif isdefined("get_expense") and len(get_expense.tevkifat_oran)>value="#TLFormat(get_expense.tevkifat_oran,8)#"</cfif> readonly <cfif (isdefined("get_expense") and get_expense.tevkifat neq 1) or not isDefined("get_expense")>style="display:none;width:35px;"<cfelse>style="width:35px;"</cfif> onblur="toplam_hesapla();">
												<a <cfif (isdefined("get_expense") and get_expense.tevkifat neq 1) or not isDefined("get_expense")>style="display:none;cursor:pointer"</cfif> id="tevkifat_plus" onclick="windowopen('#request.self#?fuseaction=objects.popup_list_tevkifat_rates&field_tevkifat_rate=add_costplan.tevkifat_oran&field_tevkifat_rate_id=add_costplan.tevkifat_id&call_function=toplam_hesapla()','small')"> <img src="images/plus_thin.gif" align="absbottom"></a>
											</td>
											</tr>
											<tr>
												<td id="tevk_1" <cfif (isdefined("get_expense") and get_expense.tevkifat neq 1) or not isDefined("get_expense")>style="display:none"</cfif>><b><cf_get_lang dictionary_id ='58022.Tevkifat'> :</b></td>
												<td id="tevk_2" <cfif (isdefined("get_expense") and get_expense.tevkifat neq 1) or not isDefined("get_expense")>style="display:none"</cfif> nowrap="nowrap"><div id="tevkifat_text"></div></td>
											</tr>
											<tr>
												<td id="beyan_1" <cfif (isdefined("get_expense") and get_expense.tevkifat neq 1) or not isDefined("get_expense")>style="display:none"</cfif>><b><cf_get_lang dictionary_id ='58024.Beyan Edilen'> :</b></td>
												<td id="beyan_2" <cfif (isdefined("get_expense") and get_expense.tevkifat neq 1) or not isDefined("get_expense")>style="display:none"</cfif> nowrap="nowrap"><div id="beyan_text"></div></td>
											</tr>
										</table>
									</div>
								
							</div>
						</div>
					</div>
				</cfoutput>
			</cfform>
		</cf_box>
	</div>
</div>
<script type="text/javascript">
	function changeProcessDate(){
		$("#process_date").val($("#expense_date").val());
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

	function add_adress()
	{
		// $('#ch_company').val('')
		if(document.getElementById("ch_company_id").value=="" || document.getElementsByName("ch_consumer_id").value=="" || document.getElementById("ch_company").value=="")
		{
			alert("<cf_get_lang dictionary_id='48826.Cari Hesap Seçmelisiniz'>");
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
	
	var stopaj_yuzde_;
	function calc_stopaj()
	{
		stopaj_yuzde_ = filterNum(document.getElementById("stopaj_yuzde").value,'#xml_genel_number#');
		if((stopaj_yuzde_ < 0) || (stopaj_yuzde_ > 99.99))
		{
			alert("<cf_get_lang dictionary_id='50036.Stopaj Oranı'>");
			document.getElementById("stopaj_yuzde").value = 0;
		}
		toplam_hesapla(0);
	}
	row_count_ilk = row_count;
	<cfoutput>
	function hesapla(field_name,satir,hesap_type,extra_type)
	{
		
		if(field_name != '' && field_name != 'product_id' && field_name != 'product_name')
		{
			var input_name_ = field_name+satir;
			field_changed_value = filterNum(document.getElementById(input_name_).value,'#xml_satir_number#');
		}
		else
			field_changed_value = '-1';
		if(field_changed_value == '-1' || document.getElementById("control_field_value") == undefined || (document.getElementById("control_field_value") != undefined && field_changed_value != document.getElementById("control_field_value").value))
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
					for(s=1; s<=document.getElementById("kur_say").value; s++)
					{
						if(document.getElementById("kur_say").value == 1)
							money_deger =list_getat(document.all.rd_money.value,1,',');
						else
							money_deger =list_getat(document.all.rd_money[s-1].value,1,',');
						if(money_deger == deger_money_id)
						{
							if(document.getElementById("kur_say").value == 1)
								deger_diger_para_satir = document.all.rd_money;
							else	
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
				
				
				if(hesap_type == undefined)
				{
					if(deger_otv_total != "" && deger_total != "") 
					{
						if(deger_otv_rate.value == undefined || deger_otv_rate.value == "")
							deger_otv_total.value = (parseFloat(deger_total.value) * parseFloat(deger_quantity.value * 0))/100;
						else
							deger_otv_total.value = (parseFloat(deger_total.value) * parseFloat(deger_quantity.value) * parseFloat(deger_otv_rate.value))/100;	
					}
					<cfif isdefined('x_kdv_add_to_otv') and x_kdv_add_to_otv eq 0>  
						if(deger_kdv_total != "" && deger_total != "")
						{
							if(deger_tax_rate.value == undefined || deger_tax_rate.value == "")
								deger_kdv_total.value = ((parseFloat(deger_total.value) * parseFloat(deger_quantity.value)) * 0)/100;
							else
								deger_kdv_total.value = ((parseFloat(deger_total.value) * parseFloat(deger_quantity.value)) * deger_tax_rate.value)/100;
						}
					<cfelse>
						if(deger_kdv_total != "" && deger_total != "")
						{
							if(deger_tax_rate.value == undefined || deger_tax_rate.value == "")
								deger_kdv_total.value = ((parseFloat(deger_total.value) * parseFloat(deger_quantity.value)+parseFloat(deger_otv_total.value)) * 0)/100;
							else
								deger_kdv_total.value = ((parseFloat(deger_total.value) * parseFloat(deger_quantity.value)+parseFloat(deger_otv_total.value)) * deger_tax_rate.value)/100;	
						}
					</cfif>
				}
				else if(hesap_type == 2)
				{
					if(deger_otv_rate.value == undefined || deger_otv_rate.value == "")
						otv_rate_ = 0;
					else 
						otv_rate_ = deger_otv_rate.value;
				
					if(deger_tax_rate != undefined && deger_tax_rate.value == '')
						tax_rate_ = 0;
					else
						tax_rate_ = deger_tax_rate.value;
					
					<cfif isdefined('x_kdv_add_to_otv') and x_kdv_add_to_otv eq 0>  
					
						if(deger_total != "" && deger_tax_rate != "") deger_total.value = ((parseFloat(deger_net_total.value)/parseFloat(deger_quantity.value))*100)/ (parseFloat(tax_rate_)+parseFloat(otv_rate_)+100);
						
						if(deger_kdv_total != "" && deger_total != "") 
						{
							if(deger_tax_rate.value == undefined || deger_tax_rate.value == "")
								deger_kdv_total.value = (parseFloat(deger_total.value) * parseFloat(deger_quantity.value * 0))/100;
							else
								deger_kdv_total.value = ((parseFloat(deger_total.value) * parseFloat(deger_quantity.value) * parseFloat(deger_tax_rate.value))/100);
						}

						if(deger_otv_total != "" && deger_total != "") 
						{
							if(deger_otv_rate.value == undefined || deger_otv_rate.value == "")
								deger_otv_total.value = (parseFloat(deger_total.value) * parseFloat(deger_quantity.value) * 0)/100;
							else
								deger_otv_total.value = (parseFloat(deger_total.value) * parseFloat(deger_quantity.value) * parseFloat(deger_otv_rate.value))/100;
						}
					<cfelse>
						if(deger_total != "" && deger_tax_rate != "") 
							deger_total.value = ((parseFloat(deger_net_total.value)/parseFloat(deger_quantity.value))/((parseFloat(tax_rate_)+100)/100))/((parseFloat(otv_rate_)+100)/100);
						if(deger_otv_total != "" && deger_total != "") 
						{
							if(deger_otv_rate.value == undefined || deger_otv_rate.value == "")
								deger_otv_total.value = (parseFloat(deger_total.value) * parseFloat(deger_quantity.value *0))/100;
							else
								deger_otv_total.value = (parseFloat(deger_total.value) * parseFloat(deger_quantity.value * deger_otv_rate.value))/100;
						}
						if(deger_kdv_total != "" && deger_total != "") 
						{
							if(deger_tax_rate.value == undefined || deger_tax_rate.value == "")
								deger_kdv_total.value = (((parseFloat(deger_total.value) * parseFloat(deger_quantity.value))+parseFloat(deger_otv_total.value)) * 0)/100;
							else
								deger_kdv_total.value = (((parseFloat(deger_total.value) * parseFloat(deger_quantity.value))+parseFloat(deger_otv_total.value)) * deger_tax_rate.value)/100;
						}
					</cfif>
				}
				
				toplam_dongu_0 = parseFloat(deger_total.value * deger_quantity.value);
				if(deger_kdv_total != "") toplam_dongu_0 = toplam_dongu_0 + parseFloat(deger_kdv_total.value);
				if(deger_otv_total != "") toplam_dongu_0 = toplam_dongu_0 + parseFloat(deger_otv_total.value);
				if(extra_type != 2)
					if(deger_other_net_total != "") deger_other_net_total.value = ((toplam_dongu_0) * parseFloat(filterNum(deger_para_satir,'#session.ep.our_company_info.rate_round_num#')) / (parseFloat(filterNum(form_value_rate_satir.value,'#session.ep.our_company_info.rate_round_num#'))));
				if(deger_net_total != "") deger_net_total.value = commaSplit(toplam_dongu_0,'#xml_satir_number#');
				if(deger_total != "") deger_total.value = commaSplit(deger_total.value,'#xml_satir_number#');
				if(deger_quantity != "") deger_quantity.value = commaSplit(deger_quantity.value,'#xml_satir_number#');
				if(deger_kdv_total != "") deger_kdv_total.value = commaSplit(deger_kdv_total.value,'#xml_satir_number#');
				if(deger_otv_total != "") deger_otv_total.value = commaSplit(deger_otv_total.value,'#xml_satir_number#');
				if(deger_other_net_total != "") deger_other_net_total.value = commaSplit(deger_other_net_total.value,'#xml_satir_number#');
				if(deger_other_net_total_kdvsiz != "") deger_other_net_total_kdvsiz.value = commaSplit(deger_other_net_total_kdvsiz.value,'#xml_satir_number#');

				if( field_name+satir == 'row_bsmv_amount'+satir+'' ){

					row_bsmv_amount = filterNum( document.getElementById('row_bsmv_amount'+satir+'').value);
					row_bsmv_rate = row_bsmv_amount * 100 / filterNum(document.getElementById('discount_total'+satir+'').value);
					row_bsmv_currency = row_bsmv_amount * filterNum(document.getElementById('txt_rate2_'+satir+'').value) / filterNum(document.getElementById('txt_rate1_'+satir+'').value);
					
				}
				else if( field_name+satir == 'row_bsmv_currency'+satir+'' ){
			
					row_bsmv_currency = filterNum( document.getElementById('row_bsmv_currency'+satir+'').value);
					row_bsmv_amount = row_bsmv_currency * filterNum(document.getElementById("txt_rate1_"+satir).value) / filterNum(document.getElementById("txt_rate2_"+satir).value);
					row_bsmv_rate = row_bsmv_amount * 100 /  filterNum(document.getElementById('net_total'+satir+'').value);
				
				}
				else if( field_name+satir == 'row_bsmv_rate'+satir+'' ){
		
					row_bsmv_rate =  document.getElementById('row_bsmv_rate'+satir+'').value;
					row_bsmv_amount = filterNum(document.getElementById('discount_total'+satir+'').value) * row_bsmv_rate / 100;
					row_bsmv_currency = row_bsmv_amount * filterNum(document.getElementById("txt_rate2_"+satir).value) / filterNum(document.getElementById("txt_rate1_"+satir).value);
				
				} 
				
				if( document.getElementById("row_bsmv_rate"+satir) != undefined && document.getElementById("row_bsmv_rate"+satir).value != 0) {

				document.getElementById('row_bsmv_amount'+satir+'').value = ( row_bsmv_amount > 0 ) ? commaSplit(row_bsmv_amount,<cfoutput>#xml_satir_number#</cfoutput>) : commaSplit(0,<cfoutput>#xml_satir_number#</cfoutput>);
				document.getElementById('row_bsmv_currency'+satir+'').value = ( row_bsmv_currency > 0 ) ? commaSplit(row_bsmv_currency,<cfoutput>#xml_satir_number#</cfoutput>) : commaSplit(0,<cfoutput>#xml_satir_number#</cfoutput>);	
				} else if( document.getElementById("row_bsmv_rate"+satir) != undefined && document.getElementById("row_bsmv_rate"+satir).value == 0 )
				{
					document.getElementById('row_bsmv_amount'+satir+'').value = commaSplit(0,<cfoutput>#xml_satir_number#</cfoutput>);
					document.getElementById('row_bsmv_currency'+satir+'').value = commaSplit(0,<cfoutput>#xml_satir_number#</cfoutput>);	
				}

				<cfif isdefined('x_kdv_add_to_oiv') and x_kdv_add_to_oiv eq 0>
					var total = filterNum(document.getElementById('total'+satir+'').value);
				<cfelse>
					var total = filterNum(document.getElementById('net_total'+satir+'').value);
				</cfif>
				if( field_name+satir == 'row_oiv_amount'+satir+'' ){   
		
					row_oiv_amount = filterNum( document.getElementById('row_oiv_amount'+satir+'').value);
					row_oiv_rate = row_oiv_amount * 100 / total;
					document.getElementById('row_oiv_amount'+satir+'').value = ( row_oiv_amount > 0 ) ? commaSplit(row_oiv_amount,<cfoutput>#xml_satir_number#</cfoutput>) : commaSplit(0,<cfoutput>#xml_satir_number#</cfoutput>);
			
				} 
				else if( field_name+satir == 'row_oiv_rate'+satir+'' ){
		
					row_oiv_rate = document.getElementById('row_oiv_rate'+satir+'').value;
					row_oiv_amount = total * row_oiv_rate / 100;
					document.getElementById('row_oiv_amount'+satir+'').value = ( row_oiv_amount > 0 ) ? commaSplit(row_oiv_amount,<cfoutput>#xml_satir_number#</cfoutput>) : commaSplit(0,<cfoutput>#xml_satir_number#</cfoutput>);
			
				}

			
				if( field_name+satir == 'row_tevkifat_amount'+satir+'') {
						
					row_tevkifat_amount = filterNum( document.getElementById('row_tevkifat_amount'+satir+'').value );
					row_tevkifat_rate = row_tevkifat_amount * 100 / filterNum(document.getElementById('kdv_total'+satir+'').value);

					document.getElementById('row_tevkifat_amount'+satir+'').value = ( row_tevkifat_amount > 0 ) ? commaSplit(row_tevkifat_amount,<cfoutput>#xml_satir_number#</cfoutput>) : commaSplit(0,<cfoutput>#xml_satir_number#</cfoutput>);
				}
				else if(field_name+satir == 'row_tevkifat_rate'+satir+''){

					row_tevkifat_rate = filterNum( document.getElementById('row_tevkifat_rate'+satir+'').value );
					row_tevkifat_amount = ( row_tevkifat_rate > 0 ) ? filterNum( document.getElementById('kdv_total'+satir+'').value) * row_tevkifat_rate : 0;

					document.getElementById('row_tevkifat_amount'+satir+'').value = ( row_tevkifat_amount > 0 ) ? commaSplit(row_tevkifat_amount,<cfoutput>#xml_satir_number#</cfoutput>) : commaSplit(0,<cfoutput>#xml_satir_number#</cfoutput>);
				} 
					
			}
			<cfif fuseaction contains "assetcare"> <!--- sadece assetcare modulunde spec secilebildigi icin eklendi --->
				delete_spec(satir);
			</cfif>
			if(extra_type == 2 || extra_type == undefined)
				toplam_hesapla(extra_type);
		}

	}
	function toplam_hesapla(type)
	{
		var toplam_dongu_1 = 0;//tutar genel toplam
		var toplam_dongu_2 = 0;// kdv genel toplam
		var toplam_dongu_3 = 0;// kdvli genel toplam
		var toplam_dongu_4 = 0;// ötv genel toplam
		var toplam_dongu_5 = 0;// ötv genel toplam
		var toplam_dongu_6 = 0;// ötv genel toplam

		var beyan_tutar = 0;
		var tevkifat_info = "";
		var beyan_tutar_info = "";
		var new_taxArray = new Array(0);
		var new_OtvArray = new Array(0);
		var new_BsmvArray = new Array(0);
		var new_OivArray = new Array(0);
		var taxArray = new Array(0);
		var OtvArray = new Array(0);
		var bsmvArray = new Array(0);
		var oivArray = new Array(0);
		var taxBeyanArray = new Array(0);
		var taxTevkifatArray = new Array(0);
		var totaltevkifat = 0.0;
		if(type != 2)
			doviz_hesapla();
		for(r=1;r<=document.getElementById("record_num").value;r++)
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
				if(document.getElementById("row_tevkifat_rate"+r) != undefined) row_tevkifat_rate = document.getElementById("row_tevkifat_rate"+r); else row_tevkifat_rate="";//tevkifat oranı
                if(document.getElementById("row_tevkifat_amount"+r) != undefined) row_tevkifat_amount = document.getElementById("row_tevkifat_amount"+r); else row_tevkifat_amount="";//tevkifat tutarı

				if(deger_total != "") deger_total.value = filterNum(deger_total.value,'#xml_satir_number#');
				if(deger_quantity != "") deger_quantity.value = filterNum(deger_quantity.value,'#xml_satir_number#');
				if(deger_kdv_total != "") deger_kdv_total.value = filterNum(deger_kdv_total.value,'#xml_satir_number#');
				
				if(document.getElementById("tax_rate"+r) != undefined && document.getElementById("kdv_total"+r) != undefined)
				{
					if(document.getElementById("tevkifat_oran") != undefined && document.getElementById("tevkifat_oran").value != "" && document.getElementById("tevkifat_box").checked == true)
					{//tevkifat hesaplamaları
						beyan_tutar = beyan_tutar + wrk_round(deger_kdv_total.value*filterNum(document.getElementById("tevkifat_oran").value,8));
					}else if( typeof(row_tevkifat_rate) != "undefined" && row_tevkifat_rate.value != undefined && row_tevkifat_rate.value != "" && filterNum(row_tevkifat_amount.value) > 0.0 ){
                        beyan_tutar = beyan_tutar + wrk_round(deger_kdv_total.value*filterNum(row_tevkifat_rate.value,8));
                    }else{
						beyan_tutar = beyan_tutar + wrk_round(deger_kdv_total.value);
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
									}else if( typeof(row_tevkifat_rate) != "undefined" && row_tevkifat_rate.value != undefined && row_tevkifat_rate.value != "" ){
                                        taxBeyanArray[m] += wrk_round(deger_kdv_total.value - (deger_kdv_total.value*(filterNum(row_tevkifat_rate.value,8))));
                                        taxTevkifatArray[m] += wrk_round(deger_kdv_total.value * (filterNum(row_tevkifat_rate.value,8)));
                                    }
									taxArray[m] += wrk_round(deger_kdv_total.value);
									break;
								}
							}
						if(!tax_flag){
							new_taxArray[new_taxArray.length] = deger_tax_rate.value;
							taxArray[taxArray.length] = wrk_round(deger_kdv_total.value);
							if(document.getElementById("tevkifat_oran") != undefined && document.getElementById("tevkifat_oran").value != "" && document.getElementById("tevkifat_box").checked == true ){
                                taxBeyanArray[taxBeyanArray.length] = wrk_round(deger_kdv_total.value - (deger_kdv_total.value*(filterNum(document.getElementById("tevkifat_oran").value,8))));
                                taxTevkifatArray[taxTevkifatArray.length] = wrk_round(deger_kdv_total.value*(filterNum(document.getElementById("tevkifat_oran").value,8)));
                            }else if( typeof(row_tevkifat_rate) != "undefined" && row_tevkifat_rate.value != undefined && row_tevkifat_rate.value != "" ){
                                taxBeyanArray[taxBeyanArray.length] = wrk_round(deger_kdv_total.value - (deger_kdv_total.value*(filterNum(row_tevkifat_rate.value,8))));
                                taxTevkifatArray[taxTevkifatArray.length] = wrk_round(deger_kdv_total.value*(filterNum(row_tevkifat_rate.value,8)));
                            }
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

				if( typeof(row_tevkifat_rate) != "undefined" && row_tevkifat_rate.value != "" && typeof(row_tevkifat_amount) != "undefined" && typeof(row_tevkifat_amount.value) != "undefined" && filterNum(row_tevkifat_amount.value) > 0.0 ){
					toplam_dongu_3 = toplam_dongu_3 - toplam_dongu_2 + beyan_tutar;
					toplam_dongu_2 = beyan_tutar;
				}
			}
		}
		for (let i = 0; i < taxTevkifatArray.length; i++) {
				totaltevkifat += taxTevkifatArray[i];
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
		}else if( typeof(row_tevkifat_rate) != "undefined" && row_tevkifat_rate.value != "" && typeof(row_tevkifat_amount) != "undefined" && typeof(row_tevkifat_amount.value) != "undefined" && totaltevkifat > 0.0 ){
			$("##tevk_1, ##tevk_2, ##beyan_1, ##beyan_2, ##tevkifat_oran").show();
			tevkifat_text.style.fontWeight = 'bold';
			tevkifat_text.innerHTML = '';
			beyan_text.style.fontWeight = 'bold';
			beyan_text.innerHTML = '';
			temptaxtotal=0;
			for (var tt=0; tt < new_taxArray.length; tt++)
			{
				tevkifat_text.innerHTML += '% ' + new_taxArray[tt] + ' : ' + commaSplit(taxBeyanArray[tt],'#xml_genel_number#') + ' ';
				beyan_text.innerHTML += '% ' + new_taxArray[tt] + ' : ' + commaSplit(taxTevkifatArray[tt],'#xml_genel_number#') + ' ';
				temptaxtotal+=taxBeyanArray[tt];
				temptaxtotal+=taxTevkifatArray[tt];
			}
			document.getElementById("tevkifat_oran").value=commaSplit(totaltevkifat/temptaxtotal,8);
		}else if( document.getElementById("tevkifat_box").checked == false && totaltevkifat == 0) {
			$("##tevk_1, ##tevk_2, ##beyan_1, ##beyan_2, ##tevkifat_oran").hide();
		}

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
			
		stopaj_yuzde_ = filterNum(document.getElementById("stopaj_yuzde").value,'#xml_genel_number#');
		if(type == undefined || stopaj_yuzde_ == 0)
			stopaj_ = wrk_round((toplam_dongu_1 * stopaj_yuzde_ / 100),'#xml_genel_number#');
		else
			stopaj_ = filterNum(document.getElementById("stopaj").value);
		document.getElementById("stopaj_yuzde").value = commaSplit(stopaj_yuzde_);
		document.getElementById("stopaj").value = commaSplit(stopaj_,'#xml_genel_number#');
		if(document.getElementById("yuvarlama").value != '')
		{
			toplam_dongu_3 = toplam_dongu_3 + parseFloat(filterNum(document.getElementById("yuvarlama").value,'#xml_genel_number#'));
			document.getElementById("yuvarlama").value = commaSplit(filterNum(document.getElementById("yuvarlama").value),'#xml_genel_number#');
		}
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
				if(document.add_costplan.rd_money.checked == true)
				{
					deger_diger_para = document.getElementById("rd_money");
					form_txt_rate2_ = document.getElementById("txt_rate2_"+s);
				}
			}
		else 
			for(s=1;s<=document.getElementById("kur_say").value;s++)
			{
				if(document.add_costplan.rd_money[s-1].checked == true)
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
	
		$("##tl_value1").val(deger_money_id_1);
		$("##tl_value2").val(deger_money_id_1);
		$("##tl_value3").val(deger_money_id_1);
		$("##tl_value4").val(deger_money_id_1);
		//form_txt_rate2_.value = commaSplit(form_txt_rate2_.value,'#session.ep.our_company_info.rate_round_num#');
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
						
						document.getElementById("other_net_total"+k).value = commaSplit(filterNum(document.getElementById("net_total"+k).value,'#xml_satir_number#')/rate2_value,'#xml_satir_number#');
						
						if(document.getElementById("other_net_total_kdvsiz"+r) != undefined)
						document.getElementById("other_net_total_kdvsiz"+k).value = commaSplit(filterNum(document.getElementById("total"+k).value,'#xml_satir_number#')/rate2_value,'#xml_satir_number#');
					}
				}
			}
		}
	}

	function kontrol()
	{
		<cfif isDefined('xml_upd_row_project') And xml_upd_row_project eq 1>
		if(document.getElementById("project_id")!="")
			{
			for(i=1; i<row_count+1; i++){
				if(document.getElementById("project_id"+i).value != "" || document.getElementById("project"+i).value == "" || document.getElementById("project_id"+i).value == "")
				{
					document.getElementById("project_id"+i).value = document.getElementById("project_id").value;
					document.getElementById("project"+i).value = document.getElementById("project_head").value;
				<cfif isDefined('xml_upd_row_expense_center') And xml_upd_row_expense_center eq 1>
					if(document.getElementById("project_id"+i).value != "")
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
			}
		</cfif>
		<cfif isDefined('xml_row_project_is_required') And xml_row_project_is_required eq 1>
			for (i = 1; i < row_count+1; i++) {
				if (document.getElementById("project_id"+i).value == '') {
					alert(i+'.<cf_get_lang dictionary_id ='58508.Satır'> <cf_get_lang dictionary_id ='30129.Proje Seçimi Zorunludur!'>');
					return false;
				}		
			}
		</cfif>
		var beyan_tutar = 0;
		var tevkifat_info = "";
		var beyan_tutar_info = "";
		var new_taxArray = new Array(0);
		var taxBeyanArray = new Array(0);
		var taxTevkifatArray = new Array(0);
		if(document.getElementById("ch_member_type").value == 'partner')
		{
			var ch_comp_id = document.getElementById("ch_company_id").value;
			var ch_cons_id = '';
		}
		else if(document.getElementById("ch_member_type").value == 'consumer')
		{
			var ch_comp_id = '';
			var ch_cons_id = document.getElementById("ch_partner_id").value;
		}

		<cfif isdefined("xml_show_process_stage") and len(xml_show_process_stage) and xml_show_process_stage eq 1>
			if(document.add_costplan.process_stage.value == "")
			{
				alert("<cf_get_lang dictionary_id ='41036.Lütfen Süreçlerinizi Tanimlayiniz veya Tanimlanan Süreçler Üzerinde Yetkiniz Yok'>!");
				return false;
			}
		</cfif>
		if(!paper_control(document.getElementById("serial_no"),'EXPENSE_COST',true,0,'',<cfif xml_paper_no_control eq 1>ch_comp_id,ch_cons_id<cfelse>'',''</cfif>,'','',1,document.getElementById("serial_number"))) return false;
		if(!chk_period(document.getElementById("process_date"),"İşlem")) return false;
		if(!chk_process_cat('add_costplan')) return false;
		if(!check_display_files('add_costplan')) return false;
		
		<cfif isdefined('xml_acc_department_info') and xml_acc_department_info eq 2> //xmlde muhasebe icin departman secimi zorunlu ise
			if(document.getElementById("acc_department_id").options[document.getElementById("acc_department_id").selectedIndex].value=='')
			{
				alert("<cf_get_lang dictionary_id='53200.Departman Seçiniz'>");
				return false;
			} 
		</cfif>
		<cfif isdefined('x_select_project') and x_select_project eq 2> //xmlde muhasebe icin proje secimi zorunlu ise
			if(document.getElementById("project_head").value=='' || document.getElementById("project_id").value=='')
			{
				alert("<cf_get_lang dictionary_id='58797.Proje Seçiniz'>");
				return false;
			} 
		</cfif>
		if(document.getElementById("expense_date").value == "")
		{
			alert("<cf_get_lang dictionary_id='33454.Lütfen Harcama Tarihi Giriniz'>");
			return false;
		}
		 
		if(document.getElementById("expense_cost_type").value == 120)
		{	
			if(	document.getElementById("budget_plan_id").value == "" && 
				(document.getElementById("credit_contract_id").value == "" || document.getElementById("credit_contract_id").value != "") && 
				((document.getElementById("ch_company_id").value != "" && document.getElementById("ch_company").value == "") || (document.getElementById("ch_company").value == "" && document.getElementById("ch_partner").value == "")) &&
				//((document.getElementById("ch_company_id").value != "" && document.getElementById("ch_company").value == "") || (document.getElementById("ch_partner").value == "")) &&
				(document.getElementById("cash") == undefined || document.getElementById("cash").checked == false) && 
				document.getElementById("bank").checked == false && document.getElementById("credit").checked == false )
			{
				alert("<cf_get_lang dictionary_id ='33754.Cari Hesap, Banka, Kasa,Kredi Kartı Seçeneklerinden Birini Seçmelisiniz'>");
				return false;
			}
		}
	<cfif attributes.fuseaction neq 'health.expenses'>
		if(document.getElementById("bank").checked == true)
		{		
			if(!acc_control()) return false;
		}
	</cfif>
	credit_ = document.getElementById("credit");
	if(credit_ != undefined && credit_.checked == true)
		{		
			if(document.getElementById("credit_card_info").value == '')
			{
				alert("<cf_get_lang dictionary_id='32659.Lütfen Kredi Kartı Seçiniz'>!");
				return false;
			}
		}
		cash_ = document.getElementById("cash");
		if(cash_ != undefined && cash_.checked == true)
		{		
			if(document.getElementById("kasa").value == '')
			{
				alert("<cf_get_lang dictionary_id='49919.Lütfen Kasa Seçiniz'>!");
				return false;
			}
		}
		var otv_list = "";
		for(r=1;r<=document.getElementById("record_num").value;r++)
		{
			deger_row_kontrol = document.getElementById("row_kontrol"+r).value;
			deger_total = document.getElementById("total"+r);
			if(document.getElementById("row_detail"+r) != undefined) deger_row_detail = document.getElementById("row_detail"+r); else deger_row_detail = "";
			<cfif ListFind(ListDeleteDuplicates(xml_order_list_rows),24) and x_is_required_physical_asset eq 1>
				deger_asset = document.getElementById("asset"+r);
			</cfif>
			<cfif x_is_project_priority eq 1>
				deger_project = document.getElementById("project_id"+r);
				deger_project_name = document.getElementById("project"+r);
				deger_product_id = eval('document.getElementById("product_id' + r +'")');
				deger_product_name = eval('document.getElementById("product_name' + r +'")');
			</cfif>
			deger_quantity = document.getElementById("quantity"+r);
			if(document.getElementById("authorized"+r) != undefined) harcama_yapan = document.getElementById("authorized"+r); else harcama_yapan="";
			if(document.getElementById("company"+r) != undefined) harcama_yapan_firma = document.getElementById("company"+r); else harcama_yapan_firma="";
			if(deger_row_kontrol == 1)
			{
				record_exist=1;
				if (document.getElementById("expense_date"+r)!= undefined && document.getElementById("expense_date"+r).value == "")
				{ 
					alert ("<cf_get_lang dictionary_id='58222.Lütfen Tarih giriniz'>");
					return false;
				}
				<cfif ListFind(ListDeleteDuplicates(xml_order_list_rows),6)>
					if(document.getElementById("product_id"+r) != undefined && document.getElementById("product_id"+r).value !="" && document.getElementById("product_name"+r).value != "" && (document.getElementById("department_id").value == "" || document.getElementById("department_name").value == ""))
					{ 
						alert ("<cf_get_lang dictionary_id='33242.Depo Girmelisiniz'>");
						return false;
					}
				</cfif>
				if(document.getElementById("row_detail"+r) != undefined && document.getElementById("row_detail"+r).value == "")
				{ 
					alert ("<cf_get_lang dictionary_id='33463.Lütfen Açıklama Giriniz'> !");
					return false;
				}	
				if (deger_total.value == "" || deger_total.value == 0)
				{ 
					alert ("<cf_get_lang dictionary_id='29535.Lütfen Tutar Giriniz'>");
					return false;
				}	
				<cfif ListFind(ListDeleteDuplicates(xml_order_list_rows),24) and x_is_required_physical_asset eq 1>
					if (deger_asset.value == "")
					{ 
						alert ("<cf_get_lang dictionary_id='58835.Lütfen Fiziki Varlık Giriniz'>");
						return false;
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
									taxBeyanArray[m] += wrk_round(filterNum(document.getElementById("kdv_total"+r).value,'#xml_satir_number#') - (filterNum(document.getElementById("kdv_total"+r).value,'#xml_satir_number#')*(filterNum(document.getElementById("tevkifat_oran").value,8))));
									taxTevkifatArray[m] += wrk_round(filterNum(document.getElementById("kdv_total"+r).value,'#xml_satir_number#')*(filterNum(document.getElementById("tevkifat_oran").value,8)));
									break;
								}
							}
						if(!tax_flag){
							new_taxArray[new_taxArray.length] = document.getElementById("tax_rate"+r).value;
							taxBeyanArray[taxBeyanArray.length] = wrk_round(filterNum(document.getElementById("kdv_total"+r).value,'#xml_satir_number#') - (filterNum(document.getElementById("kdv_total"+r).value,'#xml_satir_number#')*(filterNum(document.getElementById("tevkifat_oran").value,8))));
							taxTevkifatArray[taxTevkifatArray.length] = wrk_round(filterNum(document.getElementById("kdv_total"+r).value,'#xml_satir_number#')*(filterNum(document.getElementById("tevkifat_oran").value,8)));
						}
					}
				}
				if(document.getElementById("otv_rate"+r) != undefined && document.getElementById("otv_rate"+r).value > 0 && !list_find(otv_list,document.getElementById("otv_rate"+r).value))
					otv_list+= document.getElementById("otv_rate"+r).value+',';
				
				<cfif x_is_project_priority eq 1>
					if ((deger_product_id != undefined && deger_product_id.value == "") || (deger_product_name != undefined && deger_product_name.value == ""))
					{ 
						alert ("<cf_get_lang dictionary_id='57725.Ürün Seçiniz'>!");
						return false;
					}

					if(deger_product_id != undefined)
					{					
						var get_urun_kalem = wrk_safe_query("obj_get_urun_kalem","dsn3","1",deger_product_id.value);
						var urun_record_ = get_urun_kalem.recordcount;											
						if(urun_record_<1)
						{
							<cfif fuseaction contains "assetcare">
							alert("<cf_get_lang dictionary_id='41029.Bu ürün için bakım fişi eklenemez.'>");
							</cfif>
							return false;
						}
						else
						{							
							document.getElementById("expense_item_id"+r).value = get_urun_kalem.EXPENSE_ITEM_ID;
							document.getElementById("expense_item_name"+r).value = "<cf_get_lang dictionary_id='58551.Gider Kalemi'>";
						}
					}
							
					if (deger_project.value == "" || deger_project_name.value == "")
					{ 
						alert ("<cf_get_lang dictionary_id='58797.Proje Seçiniz'>!");
						return false;
					}
					var get_proje_merkez = wrk_safe_query("obj_get_proje_merkez","dsn","1",deger_project.value);
					var proje_record_ = get_proje_merkez.recordcount;
					if(proje_record_<1 || get_proje_merkez.EXPENSE_CODE =='' || get_proje_merkez.EXPENSE_CODE==undefined)
					{
						alert("<cf_get_lang dictionary_id='34265.Proje Masraf Merkezi Bulunamadı'>!");
						return false;
					}
					else
					{
						var get_code = wrk_safe_query("obj_get_code","dsn2","1",get_proje_merkez.EXPENSE_CODE);
						if(get_code.recordcount > 0 && get_code.EXPENSE_ID != undefined && get_code.EXPENSE_ID != '')
							document.getElementById("expense_center_id"+r).value = get_code.EXPENSE_ID;
						else
							document.getElementById("expense_center_id"+r).value = "";
						document.getElementById("expense_center_name"+r).value = "<cf_get_lang dictionary_id='58460.Masraf Merkezi'>";
					}			
				</cfif>			
				
				if (document.getElementById("expense_center_id"+r).value == "" || document.getElementById("expense_center_name"+r).value == "")
				{
					alert ("<cf_get_lang dictionary_id='33459.Lütfen Masraf Merkezi Seçiniz '>!");
					return false;
				}
				if(document.getElementById("expense_item_id"+r).value == "" || document.getElementById("expense_item_name"+r).value == "")
				{ 
					alert ("<cf_get_lang dictionary_id='33461.Lütfen Gider Kalemi Seçiniz'> !");
					return false; 
				}	
				
				if(document.getElementById("account_code"+r).value == "" )
				{ 
					alert ("<cf_get_lang dictionary_id='59016.Lütfen Muhasebe Kodu Seçiniz'>");
					return false; 
				}
				
				if(harcama_yapan=="" && harcama_yapan_firma=="")
				{
					if(document.getElementById("member_type"+r) != undefined) document.getElementById("member_type"+r).value="";
					if(document.getElementById("company_id"+r) != undefined) document.getElementById("company_id"+r).value="";
					if(document.getElementById("member_id"+r) != undefined) document.getElementById("member_id"+r).value="";
					if(document.getElementById("company"+r) != undefined) document.getElementById("company"+r).value="";
				}
				<!---Muhasebe hesabı alt hesaplar gelirken üst hesapların yazılamaması kontrolü--->
				var action_account_code = document.getElementById("account_code"+r).value;
				if(action_account_code != "")
				{ 
					if(WrkAccountControl(action_account_code,r+'.Satır: Muhasebe Hesabı Hesap Planında Tanımlı Değildir!') == 0)
					return false;
 				}
							
			}
		}
		if (record_exist == 0) 
		{
			alert("<cf_get_lang dictionary_id='33458.Lütfen Masraf Fişine Satır Ekleyiniz'> !");
			return false;
		}
		change_due_date();
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
		if(document.getElementById("expense_cost_type").value == 122 && check_stock_action('add_costplan'))//üründe sıfır stok kontrolü
		{
			var temp_process_cat = document.getElementById("process_cat").options[document.getElementById("process_cat").selectedIndex].value;
			var temp_process_type = document.getElementById("ct_process_type_" + temp_process_cat);
			if(document.getElementById("department_id") != undefined && document.getElementById("department_id").value != "" && document.getElementById("location_id") != undefined && document.getElementById("location_id").value != "")
				if(!zero_stock_control(document.getElementById("department_id").value,document.getElementById("location_id").value,0,temp_process_type.value)) return false;
		}
		return true;	
	}

	function unformat_fields()
	{
		if(document.getElementById("comp_health_amount") != undefined) comp_health_amount = document.getElementById("comp_health_amount"); else comp_health_amount="";
		if(comp_health_amount != "") comp_health_amount.value = filterNum(comp_health_amount.value,'#xml_satir_number#');
		if(document.getElementById("emp_health_amount") != undefined) emp_health_amount = document.getElementById("emp_health_amount"); else emp_health_amount="";
		if(emp_health_amount != "") emp_health_amount.value = filterNum(emp_health_amount.value,'#xml_satir_number#');
		for(r=1;r<=document.getElementById("record_num").value;r++)
		{
			if(document.getElementById("total"+r) != undefined) deger_total = document.getElementById("total"+r); else deger_total="";
			if(document.getElementById("quantity"+r) != undefined) deger_quantity = document.getElementById("quantity"+r); else deger_quantity="";
			if(document.getElementById("kdv_total"+r) != undefined) deger_kdv_total= document.getElementById("kdv_total"+r); else deger_kdv_total="";
			if(document.getElementById("otv_total"+r) != undefined) deger_otv_total= document.getElementById("otv_total"+r); else deger_otv_total="";
			if(document.getElementById("net_total"+r) != undefined) deger_net_total = document.getElementById("net_total"+r); else deger_net_total="";
			if(document.getElementById("other_net_total"+r) != undefined) deger_other_net_total = document.getElementById("other_net_total"+r); else deger_other_net_total="";
			if(document.getElementById("discount_total"+r) != undefined) discount_total = document.getElementById("discount_total"+r); else discount_total="";
			if(document.getElementById("discount_price"+r) != undefined) discount_price = document.getElementById("discount_price"+r); else discount_price="";
			if(document.getElementById("discount_rate"+r) != undefined) discount_rate = document.getElementById("discount_rate"+r); else discount_rate="";
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
			if(discount_total != "") discount_total.value = filterNum(discount_total.value,'#xml_satir_number#');
			if(deger_other_net_total != "") deger_other_net_total.value = filterNum(deger_other_net_total.value,'#xml_satir_number#');
			if(discount_price != "") discount_price.value = filterNum(discount_price.value,'#xml_satir_number#');
			if(discount_rate != "") discount_rate.value = filterNum(discount_rate.value);

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
		document.getElementById("yuvarlama").value = filterNum(document.getElementById("yuvarlama").value,'#xml_genel_number#');
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
		
		if(document.getElementById("tevkifat_oran") != undefined)	document.getElementById("tevkifat_oran").value = filterNum(document.getElementById("tevkifat_oran").value,8);

		for(s=1;s<=document.getElementById("kur_say").value;s++)
		{
			document.getElementById("txt_rate2_" + s).value = filterNum(document.getElementById("txt_rate2_" + s).value,'#session.ep.our_company_info.rate_round_num#');
			document.getElementById("txt_rate1_" + s).value = filterNum(document.getElementById("txt_rate1_" + s).value,'#session.ep.our_company_info.rate_round_num#');
		}
		return true;
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
				alert("Ödeme Yönteminde Genel Tatil ve Hafta Tatilinde Vade İlk İş Gününe Ertelensin Parametresi Seçili. Vade Tarihi İlk İş Gününe Ertelendi!");
			if(is_nextday)
				alert("Ödeme Yönteminde hafta günü seçili. Vade Tarihi Düzenlendi!");	
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
			alert("Ödeme Yönteminde Genel Tatil ve Hafta Tatilinde Vade İlk İş Gününe Ertelensin Parametresi Seçili. Vade Tarihi İlk İş Gününe Ertelendi!");
		if(is_nextday)
			alert("Ödeme Yönteminde hafta günü seçili. Vade Tarihi Düzenlendi!");	
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
		change_paper_duedate();
	}
	for(yy=1;yy<=document.getElementById("record_num").value;yy++)
	{	
		if(document.getElementById("row_kontrol"+yy).value==1)
		{
			other_calc(yy,1);
			
		}
	}
	toplam_hesapla(2);
	function other_calc(row_info,type_info)
	{
		if(row_info != undefined)
		{
			if(document.getElementById("row_kontrol"+row_info).value==1)
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
				//if(document.getElementById("other_net_total"+row_info) != undefined) document.getElementById("other_net_total"+row_info).value = filterNum(document.getElementById("other_net_total"+row_info).value,'#xml_satir_number#');
				if(document.getElementById("net_total"+row_info) != undefined) document.getElementById("net_total"+row_info).value = filterNum(document.getElementById("other_net_total"+row_info).value,'#xml_satir_number#')*filterNum(form_value_rate_satir.value,'#session.ep.our_company_info.rate_round_num#');
						if(document.getElementById("otv_rate"+row_info) != undefined) 
							var otv_rate = document.getElementById("otv_rate"+row_info).value;
						else
							var otv_rate = 0;
						<cfif isdefined('x_kdv_add_to_otv') and x_kdv_add_to_otv eq 0>
							var tax_multiplier = 100/(100+ + otv_rate + +filterNum(document.getElementById("tax_rate"+row_info).value,'#xml_satir_number#'));
						<cfelse>
							var tax_multiplier = (100/(100+ + otv_rate )*100/(100+ +filterNum(document.getElementById("tax_rate"+row_info).value,'#xml_satir_number#')));
						</cfif>
				if(document.getElementById("other_net_total_kdvsiz"+row_info) != undefined) document.getElementById("other_net_total_kdvsiz"+row_info).value = filterNum(document.getElementById("other_net_total"+row_info).value)*tax_multiplier;
				//if(document.getElementById("other_net_total"+row_info) != undefined ) document.getElementById("other_net_total"+row_info).value = commaSplit(document.getElementById("other_net_total"+row_info).value,'#xml_satir_number#');
				if(document.getElementById("net_total"+row_info) != undefined) document.getElementById("net_total"+row_info).value = commaSplit(document.getElementById("net_total"+row_info).value,'#xml_satir_number#');
				if(document.getElementById("other_net_total_kdvsiz"+row_info) != undefined) document.getElementById("other_net_total_kdvsiz"+row_info).value = commaSplit(document.getElementById("other_net_total_kdvsiz"+row_info).value,'#xml_satir_number#');
			}
			if(type_info==undefined)
				hesapla('other_net_total',row_info,2);
			else
				hesapla('other_net_total',row_info,2,type_info);
				
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
	document.getElementById('expense_cost_file').style.marginLeft=screen.width-360;
	</cfoutput>
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

	<cfif xml_discount>
	function disc_hesapla(row){
		var discount_rate = filterNum(document.getElementById("discount_rate"+row).value,<cfoutput>'#xml_satir_number#'</cfoutput>); // % İskonto
		var discount_price = filterNum(document.getElementById("discount_price"+row).value,<cfoutput>'#xml_satir_number#'</cfoutput>); // İskonto
		var quantity = filterNum(document.getElementById("quantity"+row).value,<cfoutput>'#xml_satir_number#'</cfoutput>); // miktar

		if(discount_rate <= 100) {
				var discount_total = filterNum(document.getElementById("discount_total"+row).value,<cfoutput>'#xml_satir_number#'</cfoutput>); // Tutar
				var total = 0;
				if(discount_total > 0) {
					var discount = (discount_total * discount_rate ) / 100 ;
					document.getElementById("total"+row).value = commaSplit(discount_total - discount - discount_price ,<cfoutput>'#xml_satir_number#'</cfoutput>);
					document.getElementById("net_total"+row).value = commaSplit( (discount_total - discount - discount_price) * quantity ,<cfoutput>'#xml_satir_number#'</cfoutput>);
				}
				document.getElementById("discount_price"+row).value = commaSplit(discount_price,<cfoutput>'#xml_satir_number#'</cfoutput>);
				document.getElementById("discount_total"+row).value = commaSplit(discount_total,<cfoutput>'#xml_satir_number#'</cfoutput>);


			for(r=1;r<=document.getElementById("record_num").value;r++){
				total += ((filterNum(document.getElementById("discount_total"+r).value) - filterNum(document.getElementById("total"+r).value)) * filterNum(document.getElementById("quantity"+r).value));
			}
			document.getElementById("total_discount").value = commaSplit(total,<cfoutput>'#xml_genel_number#'</cfoutput>);
		}
		else{
			alert("<cf_get_lang dictionary_id='54762.İskonto Oranı 100 den büyük olamaz'>");
			return false;
		}
	}

	function disc_total_hesapla(row) {
		if(document.getElementById("discount_rate"+row) != undefined && document.getElementById("discount_price"+row) != undefined){
			var discount_rate = filterNum(document.getElementById("discount_rate"+row).value); // % İskonto
			var discount_price = filterNum(document.getElementById("discount_price"+row).value); // İskonto

			if(discount_rate <= 100) {
					var total = filterNum(document.getElementById("total"+row).value); // Tutar
					if(total > 0) {
						if(discount_price == 100 && discount_rate == 0){ 
							var discount = wrk_round((total * discount_rate ) / (discount_price) + total + discount_price);
						}
						else if( discount_rate > 0 || discount_price > 0 ) {
							var discount = wrk_round((total * discount_rate ) / (100 - discount_rate - discount_price) + total + discount_price);
						}
						else {
							var discount = total;
						}
						document.getElementById("discount_total"+row).value = commaSplit(discount,<cfoutput>'#xml_satir_number#'</cfoutput>);	
					}
			}
			else{
				alert("<cf_get_lang dictionary_id='54762.İskonto Oranı 100 den büyük olamaz'>");
				return false;
			}
		}
	}
	function formatFields(selectedInput) {
		selectedInput.value = commaSplit(filterNum(selectedInput.value),2);
	}
</cfif>
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
