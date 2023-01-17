<cfsetting showdebugoutput="yes">
<cf_xml_page_edit fuseact="invent.add_invent_purchase">
<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.comp_name" default="">
<cfparam name="attributes.partner_name" default="">
<cfset variable = '1'>
<cfif IsDefined('attributes.invoice_id') and len(attributes.invoice_id)>
	<cfset paper_id = attributes.invoice_id>
<cfelse>
	<cfset paper_id = attributes.ship_id>
</cfif>
<cfquery name="get_expense" datasource="#dsn2#">
	SELECT
		EIP.*,
        D.BRANCH_ID,
        CASE WHEN CA.ACTION_ID IS NOT NULL THEN CA.ACTION_ID WHEN CCBE.CREDITCARD_EXPENSE_ID IS NOT NULL THEN CCBE.CREDITCARD_EXPENSE_ID ELSE 0 END AS RELATED_ACTION_ID,
        CASE WHEN CA.ACTION_ID IS NOT NULL THEN 'CASH_ACTIONS' WHEN CCBE.CREDITCARD_EXPENSE_ID IS NOT NULL THEN 'CREDIT_CARD_BANK_EXPENSE' ELSE '' END AS RELATED_ACTION_TABLE
    FROM
		INVOICE EIP
		JOIN #dsn#.DEPARTMENT D ON EIP.DEPARTMENT_ID = D.DEPARTMENT_ID
        LEFT JOIN CASH_ACTIONS CA ON CA.PAPER_NO = EIP.INVOICE_NUMBER
        LEFT JOIN #dsn3_alias#.CREDIT_CARD_BANK_EXPENSE CCBE ON CCBE.PAPER_NO = EIP.INVOICE_NUMBER	
	WHERE
		EIP.INVOICE_ID = #paper_id#
		<cfif session.ep.isBranchAuthorization>
			AND D.BRANCH_ID = #listgetat(session.ep.user_location,2,'-')#
		</cfif>
</cfquery>
<cfif isDefined("attributes.ship_id")>
	<cfquery name="GET_SHIP" datasource="#DSN2#">
		SELECT SHIP_NUMBER,INVOICE_ID FROM INVOICE_SHIPS WHERE SHIP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ship_id#"> AND SHIP_PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">
	</cfquery>
	<cfset attributes.invoice_id = get_ship.invoice_id>
<cfelse>
	<cfquery name="GET_SHIP" datasource="#DSN2#">
		SELECT SHIP_NUMBER FROM INVOICE_SHIPS WHERE INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.invoice_id#">
	</cfquery>
</cfif>
<cfif isdefined("attributes.invoice_id") and len(attributes.invoice_id)>
	<cfquery name="GET_PURCHASE_MONEY" datasource="#DSN2#">
		SELECT RATE2,MONEY_TYPE FROM INVOICE_MONEY WHERE ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.invoice_id#"> AND IS_SELECTED = <cfqueryparam value="#variable#" cfsqltype="cf_sql_smallint">
	</cfquery>
<cfelse>
	<cfset GET_PURCHASE_MONEY.recordcount = 0>
</cfif>
<cfif not GET_PURCHASE_MONEY.recordcount>
	<cfquery name="GET_PURCHASE_MONEY" datasource="#DSN#">
		SELECT MONEY,0 AS IS_SELECTED,* FROM SETUP_MONEY WHERE PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#"> AND MONEY_STATUS = <cfqueryparam value="#variable#" cfsqltype="cf_sql_smallint">
	</cfquery>
</cfif>
<cfif isdefined("attributes.invoice_id") and len(attributes.invoice_id)>
    <cfquery name="GET_INVOICE" datasource="#DSN2#">
        SELECT 
        	INVOICE.*
        FROM 
        	INVOICE
        WHERE 
        	INVOICE.INVOICE_CAT NOT IN (67,69) AND 
            INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.invoice_id#">
    </cfquery>
	<cfquery name="get_efatura_det" datasource="#dsn2#">
		SELECT 
			RECEIVING_DETAIL_ID
		FROM
			EINVOICE_RECEIVING_DETAIL
		WHERE
			INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.invoice_id#">
		ORDER BY
			RECEIVING_DETAIL_ID DESC
	</cfquery>
	<cfscript>
		get_invent_action = createObject("component", "V16.invoice.cfc.get_bill");
		CHK_SEND_INV= get_invent_action.CHK_SEND_INV(iid:attributes.invoice_id);
		CHK_SEND_ARC= get_invent_action.CHK_SEND_ARC(iid:attributes.invoice_id);
		CONTROL_EARCHIVE= get_invent_action.CONTROL_EARCHIVE(iid:attributes.invoice_id);
		CONTROL_EINVOICE= get_invent_action.CONTROL_EINVOICE(iid:attributes.invoice_id);
	</cfscript>
<cfelse>
	<cfset GET_INVOICE.recordcount = 0>
</cfif>
<cfif not GET_INVOICE.recordcount>
	<br/><font class="txtbold"><cf_get_lang dictionary_id='57999.Çalıştığınız Muhasebe Dönemine Ait Böyle Bir Fatura Bulunamadı'> !</font>
	<cfexit method="exittemplate">
</cfif>
<cfif isdefined("attributes.invoice_id") and len(attributes.invoice_id)>
	<cfquery name="GET_INVOICE_MONEY" datasource="#DSN2#">
		SELECT MONEY_TYPE AS MONEY,* FROM INVOICE_MONEY WHERE ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.invoice_id#">
	</cfquery>
<cfelse>
	<cfset GET_INVOICE_MONEY.recordcount = 0>
</cfif>
<cfif not GET_INVOICE_MONEY.recordcount>
	<cfquery name="GET_INVOICE_MONEY" datasource="#DSN#">
		SELECT MONEY,0 AS IS_SELECTED,* FROM SETUP_MONEY WHERE PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#"> AND MONEY_STATUS = <cfqueryparam value="#variable#" cfsqltype="cf_sql_smallint">
	</cfquery>
</cfif>
<cfquery name="KASA" datasource="#DSN2#">
	SELECT * FROM CASH WHERE CASH_ACC_CODE IS NOT NULL ORDER BY CASH_NAME
</cfquery>
<cfquery name="GET_MONEY" datasource="#DSN#">
	SELECT * FROM SETUP_MONEY WHERE PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#"> AND MONEY_STATUS = <cfqueryparam value="#variable#" cfsqltype="cf_sql_smallint">
</cfquery>
<cfquery name="GET_TAX" datasource="#DSN2#">
	SELECT * FROM SETUP_TAX ORDER BY TAX
</cfquery>
<cfquery name="GET_OTV" datasource="#DSN3#">
	SELECT TAX FROM SETUP_OTV WHERE PERIOD_ID = #session.ep.period_id# ORDER BY TAX
</cfquery>
<cfquery name="GET_INVENTORY_CATS" datasource="#DSN3#">
	SELECT * FROM SETUP_INVENTORY_CAT ORDER BY INVENTORY_CAT_ID
</cfquery>
<cfset inventory_cat_list=valuelist(get_inventory_cats.inventory_cat_id)>
<cfquery name="GET_ACCOUNTS" datasource="#DSN3#">
	SELECT ACCOUNT_ID,ACCOUNT_CURRENCY_ID,ACCOUNT_NAME FROM ACCOUNTS ORDER BY ACCOUNT_NAME
</cfquery>
<cfquery name="GET_EXPENSE_CENTER" datasource="#DSN2#">
	SELECT EXPENSE_ID,EXPENSE,EXPENSE_CODE FROM EXPENSE_CENTER ORDER BY EXPENSE
</cfquery>
<cfquery name="GET_AMORTIZATION_COUNT" datasource="#DSN3#">
	SELECT 
		COUNT(IA.AMORTIZATION_ID) AS AMORTIZATION_COUNT
	FROM 
		INVENTORY I,
		INVENTORY_ROW IR,
		INVENTORY_AMORTIZATON IA
	WHERE 
		I.INVENTORY_ID = IR.INVENTORY_ID
		AND IA.INVENTORY_ID = IR.INVENTORY_ID
		AND IR.PERIOD_ID = #session.ep.period_id#
		AND IR.ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.invoice_id#">
		AND IR.PROCESS_TYPE = 65
	UNION 
	SELECT 
		COUNT(IA.AMORTIZATION_ID) AS AMORTIZATION_COUNT
	FROM 
		INVENTORY I,
		INVENTORY_ROW IR,
		INVENTORY_AMORTIZATON_IFRS IA
	WHERE 
		I.INVENTORY_ID = IR.INVENTORY_ID
		AND IA.INVENTORY_ID = IR.INVENTORY_ID
		AND IR.PERIOD_ID = #session.ep.period_id#
		AND IR.ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.invoice_id#">
		AND IR.PROCESS_TYPE = 65
</cfquery>
<cfquery name="GET_SALE_COUNT" datasource="#DSN3#">
	SELECT 
		COUNT(IR2.INVENTORY_ROW_ID) AS SALE_COUNT
	FROM 
		INVENTORY I,
		INVENTORY_ROW IR,
		INVENTORY_ROW IR2
	WHERE 
		I.INVENTORY_ID = IR.INVENTORY_ID
		AND I.INVENTORY_ID = IR2.INVENTORY_ID
		AND IR.PERIOD_ID = #session.ep.period_id#
		AND IR.ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.invoice_id#">
		AND IR.PROCESS_TYPE = 65
		AND IR2.PROCESS_TYPE = 66
</cfquery>

<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box>
		<cfform name="upd_invent" method="post" action="#request.self#?fuseaction=invent.emptypopup_upd_invent_purchase">
			<input type="hidden" name="active_period" id="active_period" value="<cfoutput>#session.ep.period_id#</cfoutput>"> 
			<cf_box_elements id="upd_cost">
				<cfoutput>
					<cfif isDefined("attributes.ship_id")>
						<input type="hidden" name="ship_id" id="ship_id" value="#attributes.ship_id#">
					</cfif>
					<input type="hidden" name="invoice_id" id="invoice_id" value="#attributes.invoice_id#">
					<input type="hidden" name="invoice_cari_action_type" id="invoice_cari_action_type" value="<cfif len(get_invoice.cari_action_type)>#get_invoice.cari_action_type#</cfif>">
					<input type="hidden" name="invoice_payment_plan" id="invoice_payment_plan" value="1">
				</cfoutput>
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
					<div class="form-group" id="item">
						<div class="col col-12 col-xs-12">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='59328.E-Archive'></label>
							<div class="col col-8 col-xs-12">
								<input type="checkbox" name="is_earchive" id="is_earchive" <cfif get_invoice.is_earchive eq 1>checked</cfif>>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-process_cat">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="57800.İşlem Tipi"> *</label>
						<div class="col col-8 col-xs-12"><cf_workcube_process_cat process_cat='#get_invoice.process_cat#' slct_width='140'></div>
					</div>
					<div class="form-group" id="item-comp_name">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="57519.Cari Hesap"> *</label>
						<div class="col col-8 col-xs-12">
							<div class="input-group">
								<cfif len(get_invoice.employee_id) and len(get_invoice.acc_type_id)>
									<cfset emp_id = "#get_invoice.employee_id#_#get_invoice.acc_type_id#">
									<cfset acc_type_id = get_invoice.acc_type_id>
								<cfelseif len(get_invoice.employee_id)>
									<cfset emp_id = get_invoice.employee_id>
									<cfset acc_type_id = ''>
								</cfif>
								<cfoutput>
									<input type="hidden" name="consumer_id" id="consumer_id" value="<cfif len(get_invoice.consumer_id)>#get_invoice.consumer_id#</cfif>">
									<input type="hidden" name="company_id" id="company_id" value="<cfif len(get_invoice.company_id)>#get_invoice.company_id#</cfif>">
									<input type="hidden" name="partner_id" id="partner_id" value="<cfif len(get_invoice.partner_id)>#get_invoice.partner_id#</cfif>" />
									<input type="hidden" name="emp_id" id="emp_id" value="<cfif isdefined("emp_id") and len(emp_id)>#emp_id#</cfif>">
									<input type="text" name="comp_name" id="comp_name" value="<cfif len(get_invoice.company_id)>#get_par_info(get_invoice.company_id,1,0,0)#</cfif>" readonly>
								</cfoutput>
								<span class="input-group-addon btnPointer icon-ellipsis" title="<cf_get_lang dictionary_id='57519.Cari Hesap'>" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_pars&is_cari_action=1&select_list=1,2,3&field_name=upd_invent.partner_name&field_partner=upd_invent.partner_id&field_adress_id=upd_invent.ship_address_id&field_long_address=upd_invent.adres&field_comp_name=upd_invent.comp_name&field_comp_id=upd_invent.company_id&field_consumer=upd_invent.consumer_id&field_emp_id=upd_invent.emp_id&field_paymethod_id=upd_invent.paymethod_id&field_paymethod=upd_invent.paymethod&field_basket_due_value=upd_invent.basket_due_value&call_function=change_paper_duedate()</cfoutput>');"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-partner_name">
						<label class="col col-4 col-xs-12"><cf_geT_lang dictionary_id="57578.Yetkili"> *</label>
						<div class="col col-8 col-xs-12">
							<cfoutput>
							<cfset str_par_names = "">
							<cfif len(get_invoice.PARTNER_ID)>
								<cfquery name="GET_SALE_DET_CONS" datasource="#dsn#">
									SELECT 
										PARTNER_ID,
										COMPANY_PARTNER_NAME,
										COMPANY_PARTNER_SURNAME
									FROM 
										COMPANY_PARTNER
									WHERE 
										PARTNER_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#get_invoice.PARTNER_ID#">
								</cfquery>
								<cfset str_par_names = "#GET_SALE_DET_CONS.COMPANY_PARTNER_NAME# #GET_SALE_DET_CONS.COMPANY_PARTNER_SURNAME#" >
							<cfelseif len(get_invoice.consumer_id)>
								<cfset str_par_names = get_cons_info(get_invoice.consumer_id,0,0)>
							<cfelseif len(get_invoice.employee_id)>
								<cfset str_par_names = get_emp_info(get_invoice.employee_id,0,0,0,acc_type_id)>    
							</cfif>
							<input type="text" name="partner_name" id="partner_name" value="#str_par_names#" readonly>						
							</cfoutput>	
						</div>
					</div>
					<div class="form-group" id="item-employee">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="30011.Satın Alan"></label>
						<div class="col col-8 col-xs-12">
							<div class="input-group">
								<input type="hidden" name="employee_id" id="employee_id" value="<cfoutput>#get_invoice.sale_emp#</cfoutput>">
								<input type="text" name="employee" id="employee" onchange="clear_()" value="<cfoutput>#get_emp_info(get_invoice.sale_emp,0,0)#</cfoutput>"  onfocus="AutoComplete_Create('employee','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','\'3\',\'0\',\'0\',\'0\',\'\',\'\',\'\',\'\'','EMPLOYEE_ID','employee_id','','3','130');" autocomplete="off">
								<cfoutput><span class="input-group-addon btnPointer icon-ellipsis" title="<cf_get_lang dictionary_id='30011.Satın Alan'>" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=upd_invent.employee_id&field_name=upd_invent.employee&select_list=1,9');"></span></cfoutput>
							</div>
						</div>
					</div>
					<cfif session.ep.our_company_info.is_efatura eq 1 >
						<div class="form-group" id="item-adres">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="29462.Yükleme Yeri"></label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<input type="hidden" name="ship_address_id" id="ship_address_id" value="<cfoutput>#GET_INVOICE.SHIP_ADDRESS_ID#</cfoutput>">
									<cfinput type="text" name="adres" value="#GET_INVOICE.SHIP_ADDRESS#" maxlength="200">
									<span class="input-group-addon btnPointer icon-ellipsis" onclick="add_adress();"></span>
								</div>
							</div>
						</div>
					</cfif>
				</div>
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
					<div class="form-group" id="item-invoice_date">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="58759.Fatura Tarihi"> *</label>
						<div class="col col-8 col-xs-12">
							<div class="input-group">
								<cfsavecontent variable="message3"><cf_get_lang dictionary_id="58759.Fatura Tarihi"></cfsavecontent>
								<cfinput type="text" name="invoice_date" validate="#validate_style#" readonly="yes" required="yes" message="#message3#" value="#dateformat(get_invoice.invoice_date,dateformat_style)#" maxlength="10" onblur="change_money_info('upd_invent','invoice_date');changeProcessDate();">
								<cfif GET_AMORTIZATION_COUNT.AMORTIZATION_COUNT lte 0><span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="invoice_date" call_function="change_paper_duedate&change_money_info&changeProcessDate"></span></cfif>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-process_date">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57879.İşlem Tarihi'> *</label>
						<div class="col col-8 col-xs-12">
							<div class="input-group">
								<cfif not len(get_invoice.process_date)>
									<cfset p_date = get_invoice.invoice_date>
								<cfelse>
									<cfset p_date = get_invoice.process_date>
								</cfif>
								<cfsavecontent variable="message"><cf_get_lang dictionary_id='57906.İşlem Tarihi Girmelisiniz !'></cfsavecontent>
								<cfinput type="text" name="process_date" required="Yes" message="#message#" value="#dateformat(p_date,dateformat_style)#" validate="#validate_style#" onChange="change_paper_duedate('process_date');"  passthrough="onBlur=""change_money_info('form_basket','process_date');""">
								<cfif GET_AMORTIZATION_COUNT.AMORTIZATION_COUNT lte 0><span class="input-group-addon btnPointer" title="<cf_get_lang dictionary_id='57734.seçiniz'>"><cf_wrk_date_image date_field="process_date" call_function="change_money_info&rate_control"></span></cfif>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-serial_no">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="57637.Seri No"> *</label>
						<div class="col col-8 col-xs-12">
							<div class="input-group">
								<cfinput type="text" name="serial_number" maxlength="5" value="#get_invoice.serial_number#">
								<span class="input-group-addon no-bg">-</span>
								<cfinput type="text" name="serial_no" maxlength="50" value="#get_invoice.serial_no#" message="#message#" onBlur="paper_control(this,'INVOICE',true,'','#get_invoice.serial_no#',upd_invent.company_id.value,upd_invent.consumer_id.value);">
							</div>
						</div>
					</div>
					<div class="form-group" id="item-ship_number">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="58138.İrsaliye No"></label>
						<div class="col col-8 col-xs-12">
							<cfinput type="text" name="ship_number" id="ship_number" value="#GET_SHIP.SHIP_NUMBER#" maxlength="50">
						</div>
					</div>
					<div class="form-group" id="item-acc_department_id">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="57572.Departman"></label>
						<div class="col col-8 col-xs-12">
							<cf_wrkdepartmentbranch fieldid='acc_department_id' is_department='1' width='135' selected_value='#get_invoice.ACC_DEPARTMENT_ID#'>
						</div>
					</div>					
				</div>
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
					<div class="form-group" id="item-depo">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="58763.Depo"> *</label>
						<div class="col col-8 col-xs-12">
							<cfset location_info_ = get_location_info(get_invoice.department_id,get_invoice.department_location,1,1)>
							<cf_wrkdepartmentlocation
								returninputvalue="location_id,department_name,department_id,branch_id"
								returnqueryvalue="LOCATION_ID,LOCATION_NAME,DEPARTMENT_ID,BRANCH_ID"
								fieldname="department_name"
								fieldid="location_id"
								department_fldid="department_id"
								branch_fldid="branch_id"
								branch_id="#listlast(location_info_,',')#"
								department_id="#get_invoice.department_id#"
								location_id="#get_invoice.department_location#"
								location_name="#listfirst(location_info_,',')#"
								user_level_control="#session.ep.OUR_COMPANY_INFO.IS_LOCATION_FOLLOW#"
								width="125">
						</div>
					</div>
					<div class="form-group" id="item-paymethod">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="58516.Ödeme Yöntemi"></label>
						<div class="col col-8 col-xs-12">
							<div class="input-group">
								<cfif len(get_invoice.pay_method)>
									<cfquery name="get_paymethod" datasource="#DSN#">
										SELECT * FROM SETUP_PAYMETHOD WHERE PAYMETHOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_invoice.PAY_METHOD#">
									</cfquery>						  
									<input type="hidden" name="card_paymethod_id" id="card_paymethod_id" value="">
									<input type="hidden" name="commission_rate" id="commission_rate" value="">
									<input type="hidden" name="paymethod_id" id="paymethod_id" value="<cfoutput>#get_invoice.pay_method#</cfoutput>">
									<input type="text" name="paymethod" id="paymethod" value="<cfoutput>#get_paymethod.paymethod#</cfoutput>">
								<cfelseif len(get_invoice.card_paymethod_id)>
									<cfquery name="get_card_paymethod" datasource="#dsn3#">
										SELECT CARD_NO,COMMISSION_MULTIPLIER FROM CREDITCARD_PAYMENT_TYPE WHERE PAYMENT_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_invoice.card_paymethod_id#">
									</cfquery>
									<cfoutput>
										<input type="hidden" name="paymethod_id" id="paymethod_id" value="">
										<input type="hidden" name="card_paymethod_id" id="card_paymethod_id" value="#get_invoice.card_paymethod_id#">
										<input type="hidden" name="commission_rate" id="commission_rate" value="#get_card_paymethod.commission_multiplier#">
										<input type="text" name="paymethod" id="paymethod" value="#get_card_paymethod.card_no#">
									</cfoutput>
								<cfelse>
									<input type="hidden" name="paymethod_id" id="paymethod_id" value="">
									<input type="hidden" name="card_paymethod_id" id="card_paymethod_id" value="">
									<input type="hidden" name="commission_rate" id="commission_rate" value="">
									<input type="text" name="paymethod" id="paymethod"value="">
								</cfif>
								<cfset card_link="&field_card_payment_id=upd_invent.card_paymethod_id&field_card_payment_name=upd_invent.paymethod&field_commission_rate=upd_invent.commission_rate">
								<span class="input-group-addon btnPointer icon-ellipsis" title="<cf_get_lang dictionary_id='57734.Seçiniz'>" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_paymethods&field_id=upd_invent.paymethod_id&field_dueday=upd_invent.basket_due_value&function_name=change_paper_duedate&field_name=upd_invent.paymethod#card_link#</cfoutput>');"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-basket_due_value">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57640.Vade'></label>
						<div class="col col-8 col-xs-12">
							<div class="input-group">
								<input name="basket_due_value" id="basket_due_value" type="text" value="<cfif len(get_invoice.due_date) and len(get_invoice.invoice_date)><cfoutput>#datediff('d',get_invoice.invoice_date,get_invoice.due_date)#</cfoutput></cfif>" onchange="change_paper_duedate('invoice_date');" style="width:45px;">
								<span class="input-group-addon no-bg"></span>
								<cfinput type="text" name="basket_due_value_date_" value="#dateformat(get_invoice.due_date,dateformat_style)#" onChange="change_paper_duedate('invoice_date',1);" validate="#validate_style#" maxlength="10" readonly>
								<span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="basket_due_value_date_"></span>
							</div>
						</div>
					</div>
					<cfif session.ep.our_company_info.project_followup eq 1>
						<div class="form-group" id="item-project">
							<label class="col col-4 col-xs-12"><cfoutput><cf_get_lang dictionary_id='57416.Proje'><cfif xml_project_require eq 1> *</cfif></cfoutput></label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									
									<cfif len(get_invoice.project_id)>
										<cf_wrk_projects form_name='upd_invent' project_id='#get_invoice.project_id#' project_name='#get_project_name(get_invoice.project_id)#'>
										<input type="hidden" name="project_id" id="project_id" value="<cfoutput>#get_invoice.project_id#</cfoutput>"> 
										<input type="text" name="project_head" id="project_head" value="<cfoutput>#get_project_name(get_invoice.project_id)#</cfoutput>"onfocus="AutoComplete_Create('project_head','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','','3','150');" autocomplete="off">
									<cfelse>
										<cf_wrk_projects form_name='upd_invent' project_id='project_id' project_name='project_head'>
										<input type="hidden" name="project_id" id="project_id" value=""> 
										<input type="text" name="project_head" id="project_head" value=""onfocus="AutoComplete_Create('project_head','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','','3','150');" autocomplete="off">
									</cfif>
									<span class="input-group-addon btnPointer icon-ellipsis" title="<cf_get_lang dictionary_id='57416.Proje'>" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_projects&project_id=upd_invent.project_id&project_head=upd_invent.project_head');"></span>
								</div>
							</div>
						</div>
					</cfif>
				</div>
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="4" sort="true">
					<div class="form-group" id="item-detail">
						<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
						<div class="col col-9 col-xs-12">
							<textarea name="detail" id="detail"><cfoutput>#get_invoice.note#</cfoutput></textarea>
						</div>
					</div>
					<div class="form-group" id="item-add_info_plus">
						<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id="57810.Ek Bilgi"></label>
						<div class="col col-9 col-xs-12">
							<cf_wrk_add_info info_type_id="-8" info_id="#attributes.invoice_id#" upd_page = "1">
						</div>
						<div id="add_info_plus"></div>
					</div>
					<cfquery name="get_credit_info" datasource="#dsn3#">
						SELECT CREDITCARD_ID,INSTALLMENT_NUMBER,DELAY_INFO FROM CREDIT_CARD_BANK_EXPENSE WHERE  ACTION_PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">
					</cfquery>
					<div class="form-group" id="item-credit">
						<label class="col col-6 col-xs-12"><cf_get_lang dictionary_id='58199.Kredi Kartı'><input type="checkbox" name="credit" id="credit" onclick="ayarla_gizle_goster(2);" <cfif isdefined("get_expense") and get_expense.is_credit eq 1>checked</cfif>></label>
						<cfif kasa.recordcount>
							<label class="col col-6 col-xs-12"><cf_get_lang dictionary_id='34121.Nakit Alış'><cfif kasa.recordcount><input type="Checkbox" name="cash" id="cash" onclick="ayarla_gizle_goster(1);" <cfif isdefined("get_expense") and get_expense.is_cash eq 1>checked</cfif>></cfif></label>
						</cfif>
					</div>
					<div  <cfif isdefined("get_expense") and get_expense.is_cash eq 1>style="display:'';"<cfelse>style="display:none;"</cfif> id="kasa2">
						<cfif kasa.recordcount>
							<div class="form-group">
								<select name="kasa" id="kasa">
									<cfoutput query="kasa">
										<option value="#cash_id#;#cash_currency_id#" <cfif get_invoice.kasa_id eq cash_id>selected</cfif>>#cash_name#</option>
									</cfoutput>
								</select>
							</div>
						</cfif>
					</div>
						
					<cfif isdefined("get_expense") and get_expense.is_credit eq 1>
						<cfquery name="get_credit_info" datasource="#dsn3#">
							SELECT
								CREDITCARD_ID,
								INSTALLMENT_NUMBER,
								DELAY_INFO,
								SUM(CLOSED_AMOUNT) CLOSED_AMOUNT
							FROM
							(
								SELECT
									CREDIT_CARD_BANK_EXPENSE.CREDITCARD_ID,
									CREDIT_CARD_BANK_EXPENSE.INSTALLMENT_NUMBER,
									CREDIT_CARD_BANK_EXPENSE.DELAY_INFO,
									ISNULL((SELECT SUM(CLOSED_AMOUNT) FROM CREDIT_CARD_BANK_EXPENSE_RELATIONS WHERE CREDIT_CARD_BANK_EXPENSE_RELATIONS.CC_BANK_EXPENSE_ROWS_ID = CREDIT_CARD_BANK_EXPENSE_ROWS.CC_BANK_EXPENSE_ROWS_ID),0) CLOSED_AMOUNT
								FROM
									CREDIT_CARD_BANK_EXPENSE,
									CREDIT_CARD_BANK_EXPENSE_ROWS
								WHERE
									INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_expense.invoice_id#">
									AND ACTION_PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">
									AND CREDIT_CARD_BANK_EXPENSE_ROWS.CREDITCARD_EXPENSE_ID = CREDIT_CARD_BANK_EXPENSE.CREDITCARD_EXPENSE_ID
							) T1
							GROUP BY
								CREDITCARD_ID,
								INSTALLMENT_NUMBER,
								DELAY_INFO
						</cfquery>
						<cfset ins_info = get_credit_info.INSTALLMENT_NUMBER>
						<cfset credit_info = get_credit_info.CREDITCARD_ID>
						<cfset delay_info = get_credit_info.DELAY_INFO>
						<cfif get_credit_info.closed_amount gt 0>
							<cfset kontrol_update = 1>
						<cfelse>
							<cfset kontrol_update = 0>
						</cfif>
					<cfelse>
						<cfset ins_info = ''>
						<cfset credit_info = ''>
						<cfset delay_info = ''>
						<cfset kontrol_update = 0>
					</cfif>
					<div <cfif isdefined("get_expense") and get_expense.is_credit eq 1>style="display:'';"<cfelse>style="display:none;"</cfif> id="credit2">
						
							<div class="form-group">
								<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='58199.Kredi Kartı'></label>
								<div class="col col-9 col-xs-12"><cf_wrk_our_credit_cards slct_width="125" credit_card_info="#credit_info#"></div>
							</div>
							<div class="form-group">
								<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id ='56982.Taksit'></label>
								<div class="col col-9 col-xs-12"><cfinput type="text" name="inst_number" id="inst_number" value="#ins_info#"  onkeyup="return(formatcurrency(this,event,0,'int'));" class="moneybox"></div>
							</div>
							<div class="form-group">
								<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='30133.Erteleme'></label>
								<div class="col col-9 col-xs-12">
									<div class="input-group x-12">
										<cfinput type="text" name="delay_info" id="delay_info" value="#delay_info#"  onkeyup="return(formatcurrency(this,event,0,'int'));" class="moneybox">
										<span class="input-group-addon no-bg"><cf_get_lang dictionary_id='58724.Ay'></span>
									</div>
								</div>
							</div>
					</div>
				</div>
			</cf_box_elements>
			<cf_box_footer>
				<div class="col col-6">
					<cf_record_info query_name="get_invoice" margintop="1">
				</div>
				<div class="col col-6">
					<cfif not len(isClosed('INVOICE',paper_id)) and (get_expense.RELATED_ACTION_TABLE eq '' or not len(isClosed(get_expense.RELATED_ACTION_TABLE,get_expense.RELATED_ACTION_ID)))>
						<cfif chk_send_arc.recordcount and chk_send_arc.count gt 0 or (chk_send_inv.recordcount and chk_send_inv.count gt 0 )>
							<cf_workcube_buttons is_upd='1' add_function='kontrol()' is_delete='0' update_status="#get_invoice.upd_status#">
							<font color="FF0000"><cf_get_lang dictionary_id='60630.Fatura ile İlişkili e-Fatura veya e-Arşiv Olduğu için Silinemez!'>!</font>
						<cfelse>		
							<cfif GET_AMORTIZATION_COUNT.AMORTIZATION_COUNT gt 0 or GET_SALE_COUNT.SALE_COUNT gt 0>
								<cf_workcube_buttons is_upd='1' add_function='kontrol()' is_delete='0' update_status="#get_invoice.upd_status#">
							<cfelseif get_invoice.upd_status neq 0>
								<cf_workcube_buttons is_upd='1' add_function='kontrol()' is_delete='1' update_status="#get_invoice.upd_status#" del_function_for_submit='kontrol_2()' delete_page_url='#request.self#?fuseaction=invent.emptypopup_del_purchase_sale_invent&invoice_id=#attributes.invoice_id#&head=#get_invoice.invoice_number#&old_process_type=#get_invoice.invoice_cat#&head=#get_invoice.invoice_number#'>
							</cfif>
						</cfif>
					<cfelse>
						<font color="FF0000"><cf_get_lang dictionary_id='47262.Fatura kapama işlemi yapılan belgede değişiklik yapılamaz'>!</font>
					</cfif>
				</div>
			</cf_box_footer>   
			<cf_basket id="upd_cost_bask">
					<cfquery name="GET_ROWS" datasource="#dsn2#">
						SELECT
							(SELECT COUNT(IA.AMORTIZATION_ID) FROM #dsn3_alias#.INVENTORY_AMORTIZATON IA WHERE IA.INVENTORY_ID = INVENTORY.INVENTORY_ID) AMORT_COUNT,
							* 
						FROM
							INVOICE_ROW,
							#dsn3_alias#.INVENTORY INVENTORY
						WHERE
							INVOICE_ROW.INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.invoice_id#"> AND
							INVENTORY.INVENTORY_ID = INVOICE_ROW.INVENTORY_ID
						ORDER BY
							INVENTORY.INVENTORY_ID
					</cfquery>
					<!--- gider kalemleri ve masraf merkezleri --->
					<cfset item_id_list=''>
					<cfset exp_center_id_list=''>
					<cfoutput query="GET_ROWS">
						<cfif len(EXPENSE_ITEM_ID) and not listfind(item_id_list,EXPENSE_ITEM_ID)>
						<cfset item_id_list=listappend(item_id_list,EXPENSE_ITEM_ID)>
						</cfif>
						<cfif len(expense_center_id) and not listfind(exp_center_id_list,expense_center_id)>
							<cfset exp_center_id_list=listappend(exp_center_id_list,expense_center_id)>
						</cfif>
					</cfoutput>
					<cfif len(item_id_list)>
						<cfset item_id_list=listsort(item_id_list,"numeric","ASC",",")>
						<cfquery name="get_exp_detail" datasource="#dsn2#">
							SELECT EXPENSE_ITEM_NAME,ACCOUNT_CODE FROM EXPENSE_ITEMS WHERE EXPENSE_ITEM_ID IN (#item_id_list#) ORDER BY EXPENSE_ITEM_ID
						</cfquery>
					</cfif>
					<cfif len(exp_center_id_list)>
						<cfquery name="get_expense_center" datasource="#dsn2#">
							SELECT * FROM EXPENSE_CENTER WHERE EXPENSE_ID IN (#exp_center_id_list#) ORDER BY EXPENSE_ID
						</cfquery>
						<cfset exp_center_id_list = listsort(listdeleteduplicates(valuelist(get_expense_center.EXPENSE_ID,',')),'numeric','ASC',',')>
					</cfif>
					<cf_grid_list name="table1" id="table1" class="detail_basket_list">
						<thead>
							<th><input name="record_num" id="record_num" type="hidden" value="<cfoutput>#get_rows.recordcount#</cfoutput>"> <a onclick="add_row();" type="button"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>" alt="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th>
							<th nowrap="nowrap"><cf_get_lang dictionary_id='56904.Sabit Kıymet Kategorisi'></th>
							<th nowrap="nowrap"><cf_get_lang dictionary_id='58878.Demirbaş No'> *</th>
							<th nowrap="nowrap"><cf_get_lang dictionary_id='57629.Açıklama'> *</th>
							<th nowrap="nowrap" style="text-align:right;"><cf_get_lang dictionary_id='57635.Miktar'></th>
							<th nowrap="nowrap"><cf_get_lang dictionary_id='57673.Tutar'> *</th>
							<th nowrap="nowrap"><cf_get_lang dictionary_id="58056.Dövizli Tutar"> *</th>
							<th nowrap="nowrap"><cf_get_lang dictionary_id='57639.KDV'> % </th>
							<th nowrap="nowrap"><cf_get_lang dictionary_id='58021.OTV'> % </th>
							<th nowrap="nowrap" style="text-align:right;"><cf_get_lang dictionary_id='57639.KDV'></th>
							<th nowrap="nowrap" style="text-align:right;"><cf_get_lang dictionary_id='58021.OTV'></th>
							<th nowrap="nowrap"><cf_get_lang dictionary_id='58083.Net'><cf_get_lang dictionary_id='58084.Fiyat'></th>
							<th nowrap="nowrap" style="text-align:right;"><cf_get_lang dictionary_id='58083.Net'><cf_get_lang dictionary_id='56994.Döviz Fiyat'></th>
							<th nowrap="nowrap"><cf_get_lang dictionary_id='57677.Döviz'></th>
							<th nowrap="nowrap" style="text-align:right;"><cf_get_lang dictionary_id='57002.Ömür'></th>
							<th nowrap="nowrap" style="text-align:right;"><cf_get_lang dictionary_id="58308.IFRS"> <cf_get_lang dictionary_id='57002.Ömür'></th>
							<th nowrap="nowrap"><cf_get_lang dictionary_id='58456.Oran'> *</th>
							<th nowrap="nowrap"><cf_get_lang dictionary_id='29420.Amortisman Yöntemi'></th>
							<th nowrap="nowrap"><cf_get_lang dictionary_id='29425.Amortisman türü'></th>
							<th nowrap="nowrap"><cf_get_lang dictionary_id='58811.Muhasebe Kodu'> *</th>
							<th nowrap="nowrap"><cf_get_lang dictionary_id='58460.Masraf Merkezi'></th>
							<th nowrap="nowrap"><cf_get_lang dictionary_id='58551.Gider Kalemi'></th>
							<th nowrap="nowrap"><cf_get_lang dictionary_id='58605.Periyod/Yıl'></th>
							<th nowrap="nowrap"><cf_get_lang dictionary_id='56968.Borçlu Hesap Muhasebe Kodu'></th>
							<th nowrap="nowrap"><cf_get_lang dictionary_id='56970.Alacak Hesabı Muhasebe Kodu'></th>								
							<th nowrap="nowrap"><cf_get_lang dictionary_id='57452.Stok'></th>
							<th nowrap="nowrap"><cf_get_lang dictionary_id='56990.Stok Birimi'></th>
						</thead>
						<tbody>
							<cfset gross_toplam = 0>
							<cfset doviz_topla=0>
							<cfoutput query="get_rows">
								<cfset gross_toplam = gross_toplam + NETTOTAL>
								<tr id="frm_row#currentrow#">
									<cfif GET_ROWS.AMORT_COUNT gt 0>
										<cfset readonly_info = 1>
									<cfelse>
										<cfset readonly_info = 0>
									</cfif>
									<input type="hidden" class="boxtext" name="invent_id#currentrow#" id="invent_id#currentrow#" value="#INVENTORY_ID#">
									<td style="width:80px;" nowrap="nowrap">
										<ul class="ui-icon-list">
											<input  type="hidden" value="1" name="row_kontrol#currentrow#" id="row_kontrol#currentrow#"><cfif GET_ROWS.AMORTIZATION_COUNT lte 0>
											<li><a href="javascript://" onclick="sil('#currentrow#');"><i class="fa fa-minus" title="<cf_get_lang dictionary_id='58971.Satır Sil'>" alt="<cf_get_lang dictionary_id='58971.Satır Sil'>"></i></a></cfif></li>
											<li><a href="javascript://" onclick="copy_row('#currentrow#');" title="<cf_get_lang dictionary_id='58972.Satır Kopyala'>"><i class="fa fa-copy" title="<cf_get_lang dictionary_id='58972.Satır Kopyala'>" alt="<cf_get_lang dictionary_id='58972.Satır Kopyala'>"></i></a></li>
											<li><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=invent.popup_add_inventory_stock_to_asset&inventory_id=#inventory_id#&company_id=#get_invoice.company_id#&consumer_id=#get_invoice.consumer_id#&invoice_date=#get_invoice.invoice_date#&partner_id=#get_invoice.partner_id#','list_horizantal');"><i class="fa fa-exchange" title="<cf_get_lang dictionary_id='56938.Fiziki Varlığa Dönüştür'>" alt="<cf_get_lang dictionary_id='56938.Fiziki Varlığa Dönüştür'>"></i></a></li>
										</ul>
									</td>
									<td nowrap="nowrap">
										<input type="hidden" name="wrk_row_id#currentrow#" id="wrk_row_id#currentrow#" value="#wrk_row_id#">
										<input type="hidden" name="wrk_row_relation_id#currentrow#" id="wrk_row_relation_id#currentrow#" value="">
										<input type="hidden" name="inventory_cat_id#currentrow#" id="inventory_cat_id#currentrow#" value="#inventory_catid#">
										<input type="text" name="inventory_cat#currentrow#" id="inventory_cat#currentrow#" <cfif readonly_info>readonly</cfif> style="width:132px;" class="boxtext" value="<cfif len(INVENTORY_CATID)>#GET_INVENTORY_CATS.INVENTORY_CAT[listfind(inventory_cat_list,INVENTORY_CATID)]#</cfif>" title="#INVENTORY_NAME#">
										<cfif GET_ROWS.AMORTIZATION_COUNT lte 0><a href="javascript://" onclick="open_inventory_cat_list('#currentrow#');"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a></cfif>
									</td> 
									<td><input type="text" onblur="control_invent_no(#currentrow#,#inventory_id#)"  name="invent_no#currentrow#" id="invent_no#currentrow#" class="boxtext" value="#INVENTORY_NUMBER#" title="#INVENTORY_NAME#" maxlength="50"></td>
									<td><input type="text" name="invent_name#currentrow#" id="invent_name#currentrow#" class="boxtext" value="#INVENTORY_NAME#" title="#INVENTORY_NAME#" maxlength="100"></td>
									<td><input type="text" name="quantity#currentrow#" id="quantity#currentrow#" class="box"  value="#QUANTITY#" <cfif readonly_info>readonly</cfif> onblur="hesapla('#currentrow#');" onkeyup="return(FormatCurrency(this,event));" title="#INVENTORY_NAME#"></td>
									<td><input type="text" name="row_total#currentrow#" id="row_total#currentrow#" value="#TLFormat(PRICE,session.ep.our_company_info.purchase_price_round_num)#" <cfif readonly_info>readonly</cfif> onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.purchase_price_round_num#));" onblur="hesapla('#currentrow#');" class="box" title="#INVENTORY_NAME#"></td>
									<td><input type="text" name="row_total_other#currentrow#" id="row_total_other#currentrow#" value="#TLFormat(PRICE_OTHER,session.ep.our_company_info.purchase_price_round_num)#" <cfif readonly_info>readonly</cfif> onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.purchase_price_round_num#));" onblur="hesapla('#currentrow#',1);" class="box" title="#INVENTORY_NAME#"></td>
									<td>
										<select name="tax_rate#currentrow#" id="tax_rate#currentrow#" onchange="hesapla('#currentrow#');" class="box">
											<cfset deger_tax = TAX>
											<cfloop query="get_tax">
												<option value="#tax#" <cfif deger_tax eq TAX>selected</cfif>>#tax#</option>
											</cfloop>
										</select>
									</td>
									<td>
										<select name="otv_rate#currentrow#" id="otv_rate#currentrow#" onchange="hesapla('#currentrow#');" class="box">
											<cfset deger_otv = OTV_ORAN>
											<option value="0"><cf_get_lang dictionary_id="58021.ÖTV"></option>
											<cfloop query="get_otv">
												<option value="#tax#" <cfif deger_otv eq TAX>selected</cfif>>#tax#</option>
											</cfloop>
										</select>
									</td>
									<td><input type="text" name="kdv_total#currentrow#" id="kdv_total#currentrow#" value="#TLFormat(TAXTOTAL,session.ep.our_company_info.purchase_price_round_num)#" <cfif readonly_info>readonly</cfif> onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.purchase_price_round_num#));" onblur="hesapla('#currentrow#',1);" class="box" title="#INVENTORY_NAME#"></td>
									<td><input type="text" name="otv_total#currentrow#" id="otv_total#currentrow#" value="#TLFormat(OTVTOTAL,session.ep.our_company_info.purchase_price_round_num)#" <cfif readonly_info>readonly</cfif> onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.purchase_price_round_num#));" onblur="hesapla('#currentrow#',1);" class="box" title="#INVENTORY_NAME#"></td>
									<td><input type="text" name="net_total#currentrow#" id="net_total#currentrow#" value="#TLFormat(GROSSTOTAL,session.ep.our_company_info.purchase_price_round_num)#" <cfif readonly_info>readonly</cfif> class="box" onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.purchase_price_round_num#));" onblur="hesapla('#currentrow#',3);"></td>
									<td><input type="text" name="row_other_total#currentrow#" id="row_other_total#currentrow#" value="#TLFormat(OTHER_MONEY_GROSS_TOTAL,session.ep.our_company_info.purchase_price_round_num)#" <cfif readonly_info>readonly</cfif> onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.purchase_price_round_num#));" onblur="hesapla('#currentrow#',4);" class="box" title="#INVENTORY_NAME#"></td>
									<td>
										<select name="money_id#currentrow#" id="money_id#currentrow#" class="boxtext" onchange="hesapla('#currentrow#',1);">
											<cfset deger_money = OTHER_MONEY>
											<cfloop query="get_money">
											<option value="#money#,#rate1#,#rate2#" <cfif deger_money eq money>selected</cfif>>#money#</option>
											</cfloop>
										</select>
									</td>
									<td><input type="text" name="inventory_duration#currentrow#" id="inventory_duration#currentrow#" class="box" value="#TLFormat(INVENTORY_DURATION)#" <cfif readonly_info>readonly</cfif> onkeyup="return(FormatCurrency(this,event));" title="#INVENTORY_NAME#"></td>
									<td><input type="text" name="inventory_duration_ifrs#currentrow#" id="inventory_duration_ifrs#currentrow#" class="box" value="#TLFormat(INVENTORY_DURATION_IFRS)#" <cfif readonly_info>readonly</cfif> onkeyup="return(FormatCurrency(this,event));" title="#INVENTORY_NAME#"></td>
									<td><input type="text" name="amortization_rate#currentrow#" id="amortization_rate#currentrow#" class="box" value="#TLFormat(AMORTIZATON_ESTIMATE,session.ep.our_company_info.purchase_price_round_num)#" <cfif readonly_info>readonly</cfif> onblur="return(amortisman_kontrol(#currentrow#));" onkeyup="return(FormatCurrency(this,event));" title="#INVENTORY_NAME#"></td>
									<td><select name="amortization_method#currentrow#" id="amortization_method#currentrow#" style="margin-left:-7px;" <cfif readonly_info>disabled="disabled"</cfif>>
									<option value="0" <cfif AMORTIZATON_METHOD eq 0>selected</cfif>><cf_get_lang dictionary_id='29421.Azalan Bakiye Üzerinden'></option>
									<option value="1" <cfif AMORTIZATON_METHOD eq 1>selected</cfif>><cf_get_lang dictionary_id='29422.Normal Amortisman'></option>
									</select></td>
									<td><select name="amortization_type#currentrow#" id="amortization_type#currentrow#" style="margin-left:-7px;" <cfif readonly_info>disabled="disabled"</cfif>><option value="1" <cfif amortization_type eq 1>selected</cfif>><cf_get_lang dictionary_id="29426.Kıst Amortismana Tabi"></option><option value="2" <cfif amortization_type eq 2>selected</cfif>><cf_get_lang dictionary_id="29427.Kıst Amortismana Tabi Değil"></option></select></td>
									<td nowrap="nowrap">
										<input type="hidden" name="account_id#currentrow#" id="account_id#currentrow#" value="#ACCOUNT_ID#">
										<input type="text" name="account_code#currentrow#" id="account_code#currentrow#" value="#ACCOUNT_ID#" class="boxtext" title="#INVENTORY_NAME#" onfocus="autocomp_account(#currentrow#);">
										<a href="javascript://" onclick="pencere_ac_acc('#currentrow#');"><img src="/images/plus_thin.gif"></a>
									</td>
									<td nowrap="nowrap">
										<input type="hidden" name="expense_center_id#currentrow#" id="expense_center_id#currentrow#" value="#EXPENSE_CENTER_ID#" >
										<input type="text"  name="expense_center_name#currentrow#" id="expense_center_name#currentrow#" onfocus="exp_center(#currentrow#);" value="<cfif len(exp_center_id_list)>#get_expense_center.expense[listfind(exp_center_id_list,expense_center_id,',')]#</cfif>" class="boxtext"><a href="javascript://" onclick="pencere_ac_exp_center(#currentrow#);"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>
									</td>
									<td nowrap="nowrap">
										<input type="hidden" name="expense_item_id#currentrow#" id="expense_item_id#currentrow#" value="#EXPENSE_ITEM_ID#">
										<input type="text" name="expense_item_name#currentrow#" id="expense_item_name#currentrow#" onfocus="exp_item(#currentrow#);" value="<cfif len(EXPENSE_ITEM_ID)>#get_exp_detail.EXPENSE_ITEM_NAME[listfind(item_id_list,EXPENSE_ITEM_ID,',')]#</cfif>" class="boxtext" title="#INVENTORY_NAME#"><a href="javascript://" onclick="pencere_ac_exp('#currentrow#');"><img src="/images/plus_thin.gif"></a>
									</td>
									<td nowrap="nowrap">
										<input type="hidden" name="hd_period#currentrow#" id="hd_period#currentrow#" value="#account_period#" >
										<input type="text" name="period#currentrow#" id="period#currentrow#" value="#account_period#" <cfif readonly_info>readonly</cfif> class="box" onblur="return(period_kontrol1(#currentrow#));" onkeyup="return(FormatCurrency(this,event,0));" title="#INVENTORY_NAME#">
									</td>
									<td nowrap="nowrap">
										<input type="hidden" name="debt_account_id#currentrow#" id="debt_account_id#currentrow#" value="#DEBT_ACCOUNT_ID#">
										<input type="text" name="debt_account_code#currentrow#" id="debt_account_code#currentrow#" style="width:185px;" class="boxtext" value="#DEBT_ACCOUNT_ID#" title="#INVENTORY_NAME#" onfocus="AutoComplete_Create('debt_account_code#currentrow#','ACCOUNT_CODE,ACCOUNT_NAME','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','0','ACCOUNT_CODE','debt_account_id#currentrow#','','3','225');">
										<a href="javascript://" onclick="pencere_ac_acc2('#currentrow#');" ><img src="/images/plus_thin.gif"></a>
									</td>
									<td nowrap="nowrap">
										<input type="hidden" name="claim_account_id#currentrow#" id="claim_account_id#currentrow#" value="#CLAIM_ACCOUNT_ID#">
										<input type="text" name="claim_account_code#currentrow#" id="claim_account_code#currentrow#" style="width:201px;" class="boxtext" value="#CLAIM_ACCOUNT_ID#" title="#INVENTORY_NAME#" onfocus="AutoComplete_Create('claim_account_code#currentrow#','ACCOUNT_CODE,ACCOUNT_NAME','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','0','ACCOUNT_CODE','claim_account_id#currentrow#','','3','225');">
										<a href="javascript://" onclick="pencere_ac_acc1('#currentrow#');"><img src="/images/plus_thin.gif"></a>
									</td>
									<td nowrap="nowrap">
										<input type="hidden" name="product_id#currentrow#" id="product_id#currentrow#" value="#PRODUCT_ID#">
										<input type="hidden" name="stock_id#currentrow#" id="stock_id#currentrow#" value="#STOCK_ID#">
										<input type="text" name="product_name#currentrow#" id="product_name#currentrow#" class="boxtext" value="#NAME_PRODUCT#" title="#INVENTORY_NAME#" onfocus="AutoComplete_Create('product_name#currentrow#','PRODUCT_NAME','PRODUCT_NAME,STOCK_CODE','get_product_autocomplete','0','PRODUCT_ID,STOCK_ID,MAIN_UNIT,PRODUCT_UNIT_ID','product_id#currentrow#,stock_id#currentrow#,stock_unit#currentrow#,stock_unit_id#currentrow#','upd_invent',1,'','');">
										<a href="javascript://" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_product_names&product_id=upd_invent.product_id#currentrow#&field_id=upd_invent.stock_id#currentrow#&field_unit_name=upd_invent.stock_unit#currentrow#&is_form_submitted&field_main_unit=upd_invent.stock_unit_id#currentrow#&field_name=upd_invent.product_name#currentrow#');"><img src="/images/plus_thin.gif"></a>
									</td>
									<td>
										<input type="hidden" name="stock_unit_id#currentrow#" id="stock_unit_id#currentrow#" value="#UNIT_ID#">
										<input type="text" name="stock_unit#currentrow#" id="stock_unit#currentrow#" width="100%" class="boxtext" value="#UNIT#" title="#INVENTORY_NAME#">
									</td>
								</tr>
							</cfoutput>
						</tbody>
					</cf_grid_list>
					<cfif len(GET_PURCHASE_MONEY.RATE2)>
						<cfset doviz_topla=gross_toplam/GET_PURCHASE_MONEY.RATE2>
					</cfif>
				<cf_basket_footer>
					<div class="ui-row">
						<div id="sepetim_total" class="padding-0">
							<div class="col col-3 col-sm-6 col-xs-12">
								<div class="totalBox">
									<div class="totalBoxHead font-grey-mint">
										<span class="headText"> <cf_get_lang dictionary_id='57677.Döviz'> </span>
										<div class="collapse">
											<span class="icon-minus"></span>
										</div>
									</div>
									<div class="totalBoxBody">
										<table>
											<input type="hidden" name="kur_say" id="kur_say" value="<cfoutput>#GET_INVOICE_MONEY.recordcount#</cfoutput>">
											<cfoutput>
												<cfloop query="GET_INVOICE_MONEY">
													<tr>
														<div class="col col-4">
															<td>
																<input type="hidden" name="hidden_rd_money_#currentrow#" id="hidden_rd_money_#currentrow#" value="#money#">
																<input type="hidden" name="txt_rate1_#currentrow#" id="txt_rate1_#currentrow#" value="#rate1#">
																<div class="form-group">
																	<input type="radio" name="rd_money" id="rd_money" value="#money#,#currentrow#,#rate1#,#rate2#" onclick="toplam_hesapla();" <cfif get_invoice.other_money eq money>checked</cfif>>#money#
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
																	<input type="text" <cfif readonly_info>readonly</cfif> class="moneybox" name="txt_rate2_#currentrow#" id="txt_rate2_#currentrow#" <cfif money eq session.ep.money>readonly="yes"</cfif> value="#TLFormat(rate2,session.ep.our_company_info.rate_round_num)#" onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.rate_round_num#));" onblur="toplam_hesapla();">
																</div>
															</td>
														</div>
													</tr>
												</cfloop>
											</cfoutput>
										</table>
									</div>
								</div>
							</div>
							<div class="col col-3 col-sm-6 col-xs-12">
								<div class="totalBox">
									<div class="totalBoxHead font-grey-mint">
										<span class="headText"> <cf_get_lang dictionary_id='57492.Toplam'> </span>
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
														<input type="text" name="total_amount" id="total_amount" class="box" readonly="" value="<cfoutput>#TLFormat(get_invoice.GROSSTOTAL,session.ep.our_company_info.purchase_price_round_num)#</cfoutput>">
													</div>
													<label class="col col-1 col-xs-12">
														<cfoutput>#session.ep.money#</cfoutput>
													</label>
												</div>
											</div>
											<div class="col col-12">
												<div class="form-group">
													<label class="col col-3 col-xs-12 txtbold">
														<cf_get_lang dictionary_id='33213.Toplam KDV'>
													</label>
													<div class="col col-8 col-xs-12">
														<input type="text" name="kdv_total_amount" id="kdv_total_amount" class="box" value="<cfoutput>#TLFormat(get_invoice.TAXTOTAL,session.ep.our_company_info.purchase_price_round_num)#</cfoutput>" readonly>
													</div>
													<label class="col col-1 col-xs-12">
														<cfoutput>#session.ep.money#</cfoutput>
													</label>
												</div>
											</div>
											<div class="col col-12">
												<div class="form-group">
													<label class="col col-3 col-xs-12 txtbold">
														<cf_get_lang dictionary_id='57492.Toplam'> <cf_get_lang dictionary_id='58021.ÖTV'>
													</label>
													<div class="col col-8 col-xs-12">
														<input type="text" name="otv_total_amount" id="otv_total_amount" class="box" value="<cfoutput>#TLFormat(get_invoice.OTV_TOTAL,session.ep.our_company_info.purchase_price_round_num)#</cfoutput>" readonly>
													</div>
													<label class="col col-1 col-xs-12">
														<cfoutput>#session.ep.money#</cfoutput>
													</label>
												</div>
											</div>
											<div class="col col-12">
												<div class="form-group">
													<label class="col col-3 col-xs-12 txtbold">
														<a href="javascript://" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_stoppage_rates&field_stoppage_rate=upd_invent.stopaj_yuzde&field_stoppage_rate_id=upd_invent.stopaj_rate_id&field_decimal=#session.ep.our_company_info.purchase_price_round_num#&call_function=toplam_hesapla()</cfoutput>')"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='33258.Stopaj Oranları'>"></i></a>
														<cf_get_lang dictionary_id='57711.Stopaj'>%
															<input type="hidden" name="stopaj_rate_id" id="stopaj_rate_id" value="<cfoutput>#get_invoice.stopaj_rate_id#</cfoutput>">
													</label>
													<cfif not len(get_invoice.stopaj_oran)><cfset get_invoice.stopaj_oran = 0></cfif>
													<cfif not len(get_invoice.stopaj)><cfset get_invoice.stopaj = 0></cfif>
													<div class="col col-4 col-xs-12">
														<input type="text" name="stopaj_yuzde" id="stopaj_yuzde" class="box" onblur="calc_stopaj();" onkeyup="return(FormatCurrency(this,event,0));" value="<cfoutput>#TLFormat(get_invoice.stopaj_oran,session.ep.our_company_info.purchase_price_round_num)#</cfoutput>" autocomplete="off">
													</div>
													<div class="col col-4 col-xs-12">
														<input type="text" name="stopaj" id="stopaj" class="box" readonly="readonly" value="<cfoutput>#TLFormat(get_invoice.stopaj,session.ep.our_company_info.purchase_price_round_num)#</cfoutput>" onblur="toplam_hesapla(1);">
													</div>
												</div>
											</div>
											<div class="col col-12">
												<div class="form-group">
													<label class="col col-3 col-xs-12 txtbold">
														<cf_get_lang dictionary_id='57678.Fatura Altı İndirim'>
													</label>
													<div class="col col-8 col-xs-12">
														<input type="text" name="net_total_discount" id="net_total_discount" class="box" value="<cfif len(get_invoice.sa_discount)><cfoutput>#TLFormat(get_invoice.SA_DISCOUNT,session.ep.our_company_info.purchase_price_round_num)#</cfoutput><cfelse>0</cfif>" onblur="toplam_hesapla();" onkeyup="return(FormatCurrency(this,event));">
													</div>
													<label class="col col-1 col-xs-12">
														<cfoutput>#session.ep.money#</cfoutput>
													</label>
												</div>
											</div>
											<div class="col col-12">
												<div class="form-group">
													<label class="col col-3 col-xs-12 txtbold">
														<cf_get_lang dictionary_id='56975.KDV li Toplam'>
													</label>
													<div class="col col-8 col-xs-12">
														<input type="text" name="net_total_amount" id="net_total_amount" class="box" readonly="" value="<cfoutput>#TLFormat(get_invoice.NETTOTAL,session.ep.our_company_info.purchase_price_round_num)#</cfoutput>">
													</div>
													<label class="col col-1 col-xs-12">
														<cfoutput>#session.ep.money#</cfoutput>
													</label>
												</div>
											</div>
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
									<div class="totalBoxBody" id="totalAmountList"> 
										<table>
											<div class="col col-12">
												<div class="form-group">
													<label class="col col-4 col-xs-12 txtbold">
														<cf_get_lang dictionary_id='58124.Döviz Toplam'>
													</label>
													<div class="col col-6 col-xs-12" id="rate_value1">
														<input type="text" name="other_total_amount" id="other_total_amount" class="box" readonly="" value="<cfoutput>#TLFormat(doviz_topla,session.ep.our_company_info.purchase_price_round_num)#</cfoutput>">
													</div>
													<div class="col col-2 col-xs-12">
														<input type="text" name="tl_value1" id="tl_value1" class="box" readonly="" value="<cfoutput>#get_invoice.other_money#</cfoutput>">
													</div>
												</div>
											</div>
											<div class="col col-12">
												<div class="form-group">
													<label class="col col-4 col-xs-12 txtbold">
														<cf_get_lang dictionary_id='56961.Döviz KDV Toplam'>
													</label>
													<div class="col col-6 col-xs-12">
														<input type="text" name="other_kdv_total_amount" id="other_kdv_total_amount" class="box" readonly value="<cfoutput>#TLFormat(get_invoice.TAXTOTAL/GET_PURCHASE_MONEY.RATE2,session.ep.our_company_info.purchase_price_round_num)#</cfoutput>">
													</div>
													<div class="col col-2 col-xs-12">
														<input type="text" name="tl_value2" id="tl_value2" class="box" readonly="" value="<cfoutput>#get_invoice.other_money#</cfoutput>">
													</div>
												</div>
											</div>
											<div class="col col-12">
												<div class="form-group">
													<label class="col col-4 col-xs-12 txtbold">
														<cf_get_lang dictionary_id='57796.Dövizli'><cf_get_lang dictionary_id='58021.OTV'><cf_get_lang dictionary_id='57492.Toplam'>
													</label>
													<div class="col col-6 col-xs-12">
														<input type="text" name="other_otv_total_amount" id="other_otv_total_amount" class="box" readonly value="<cfoutput>#TLFormat(get_invoice.OTV_TOTAL/GET_PURCHASE_MONEY.RATE2,session.ep.our_company_info.purchase_price_round_num)#</cfoutput>">
													</div>
													<div class="col col-2 col-xs-12">
														<input type="text" name="tl_value5" id="tl_value5" class="box" readonly="" value="<cfoutput>#get_invoice.other_money#</cfoutput>">
													</div>
												</div>
											</div>
											<div class="col col-12">
												<div class="form-group">
													<label class="col col-4 col-xs-12 txtbold">
														<cf_get_lang dictionary_id='57678.Fatura Altı İndirim'><cf_get_lang dictionary_id ='57677.Döviz'>
													</label>
													<div class="col col-6 col-xs-12">
														<input type="text" name="other_net_total_discount" id="other_net_total_discount" class="box" readonly value="<cfoutput>#TLFormat(get_invoice.SA_DISCOUNT/GET_PURCHASE_MONEY.RATE2,session.ep.our_company_info.purchase_price_round_num)#</cfoutput>">
													</div>
													<div class="col col-2 col-xs-12">
														<input type="text" name="tl_value4" id="tl_value4" class="box" readonly="" value="<cfoutput>#get_invoice.other_money#</cfoutput>">
													</div>
												</div>
											</div>
											<div class="col col-12">
												<div class="form-group">
													<label class="col col-4 col-xs-12 txtbold">
														<cf_get_lang dictionary_id='57677.Döviz'><cf_get_lang dictionary_id ='57680.Genel Toplam'>
													</label>
													<div class="col col-6 col-xs-12" id="rate_value3">
														<input type="text" name="other_net_total_amount" id="other_net_total_amount" class="box" readonly="" value="<cfoutput>#TLFormat(get_invoice.OTHER_MONEY_VALUE,session.ep.our_company_info.purchase_price_round_num)#</cfoutput>">
													</div>
													<div class="col col-2 col-xs-12">
														<input type="text" name="tl_value3" id="tl_value3" class="box" readonly="" value="<cfoutput>#get_invoice.other_money#</cfoutput>">
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
										<div class="collapse">
											<span class="icon-minus"></span>
										</div>
									</div>
									<div class="totalBoxBody">  
										<table>
											<div class="col col-12">
												<div class="form-group">
													<label class="col col-4 col-xs-12 txtbold">
														<input type="checkbox" name="tevkifat_box" id="tevkifat_box" onclick="gizle_goster(tevkifat_oran);gizle_goster(tevkifat_plus);gizle_goster(tevk_1);gizle_goster(beyan_1);toplam_hesapla();" <cfif get_invoice.tevkifat eq 1>checked</cfif>>
														<b><cf_get_lang dictionary_id='58022.Tevkifat'></b>
													</label>
													<div class="col col-6 col-xs-12">
														<input type="hidden" id="tevkifat_id" name="tevkifat_id" value="<cfoutput>#get_invoice.tevkifat_id#</cfoutput>">
														<input type="text" name="tevkifat_oran" id="tevkifat_oran" value="<cfoutput>#TLFormat(get_invoice.tevkifat_oran)#</cfoutput>" readonly <cfif get_invoice.tevkifat neq 1>style="display:none;width:35px;"<cfelse>style="width:35px;"</cfif> onblur="toplam_hesapla();">
													</div>
													<div class="col col-2 col-xs-12">
														<a <cfif get_invoice.tevkifat neq 1>style="display:none;cursor:pointer"</cfif> id="tevkifat_plus" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_tevkifat_rates&field_tevkifat_rate=upd_invent.tevkifat_oran&field_tevkifat_rate_id=upd_invent.tevkifat_id&call_function=toplam_hesapla()</cfoutput>')"> <img src="images/plus_thin.gif" alt="tevkifat oran" align="absmiddle"></a>
													</div>
												</div>
											</div>
											<div class="col col-12">
												<div class="form-group" id="tevk_1" <cfif get_invoice.tevkifat neq 1>style="display:none"</cfif>>
													<label class="col col-4 col-xs-12 txtbold" >
														<b><cf_get_lang dictionary_id ='58022.Tevkifat'>:</b>
													</label>
													<div class="col col-6 col-xs-12">
														<div id="tevkifat_text"></div>
													</div>
												</div>
											</div>
											<div class="col col-12">
												<div class="form-group" id="beyan_1" <cfif get_invoice.tevkifat neq 1>style="display:none"</cfif>>
													<label class="col col-4 col-xs-12 txtbold" >
														<b><cf_get_lang dictionary_id ='58024.Beyan Edilen'>:</b>
													</label>
													<div class="col col-6 col-xs-12">
														<div id="beyan_text"></div>
													</div>
													<div class="col col-2 col-xs-12">
													</div>
												</div>
											</div>
										</table>
									</div>
								</div>
							</div>
						</div>
					</div>
				</cf_basket_footer>
			</cf_basket>
		</cfform>
	</cf_box>
</div>
<script type="text/javascript">
	<cfif get_invoice.tevkifat eq 1>//tevkifat hesapları için sayfa yüklenrken çağrılıyor
		toplam_hesapla();
	</cfif>
	function changeProcessDate(){
		$("#process_date").val($("#invoice_date").val());
	}
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
		if(!(document.getElementById('company_id').value=="") || !(document.getElementById('consumer_id').value=="") || !(document.getElementById('employee_id').value==""))
		{
			if(document.getElementById('company_id').value!="")
			{
				str_adrlink = '&field_long_adres=upd_invent.adres&field_adress_id=upd_invent.ship_address_id&is_compname_readonly=1';
				openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_member_address&is_comp=1&keyword='+encodeURIComponent(upd_invent.comp_name.value)+''+ str_adrlink );
				return true;
			}
			else
			{
				str_adrlink = '&field_long_adres=add_invent.adres&field_adress_id=upd_invent.ship_address_id&is_compname_readonly=1';
				openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_member_address&is_comp=0&keyword='+encodeURIComponent(upd_invent.partner_name.value)+''+ str_adrlink );
				return true;
			}
		}
		else
		{
			alert("<cf_get_lang dictionary_id='57183.Cari Hesap Seçmelisiniz'>");
			return false;
		}
	}
	function kontrol()
	{
		if(!paper_control(upd_invent.serial_no,'INVOICE',true,'',<cfoutput>'#get_invoice.serial_no#'</cfoutput>,upd_invent.company_id.value,upd_invent.consumer_id.value)) return false;

		if(!chk_process_cat('upd_invent')) return false;
		if(!chk_period(upd_invent.process_date,"İşlem")) return false;
		if(!check_display_files('upd_invent')) return false;
		if(upd_invent.department_id.value=="")
		{
			alert("<cf_get_lang dictionary_id='58194.Zorunlu Alan'>:<cf_get_lang dictionary_id='58763.Depo'>");
			return false;
		}
		
		if(document.getElementById('comp_name').value == ""  && document.getElementById('consumer_id').value == ""  && document.getElementById('emp_id').value == "")
		{ 
			alert ("<cf_get_lang dictionary_id='56901.Cari Hesap Seçmelisiniz'>!");
			return false;
		}
		
		//Odeme Plani Guncelleme Kontrolleri
		if (document.getElementById('invoice_cari_action_type').value == 5 && document.getElementById('paymethod_id').value != "")
		{
			if (confirm("<cf_get_lang dictionary_id='29460.Güncellediğiniz Belgenin Ödeme Planı Yeniden Oluşturulacaktır'>!"))
				document.getElementById('invoice_payment_plan').value = 1;
			else
			{
				document.getElementById('invoice_payment_plan').value = 0;
				<cfif xml_control_payment_plan_status eq 1>
					return false;
				</cfif>
			}
		}
		<cfif session.ep.our_company_info.is_efatura eq 1 >
			if(document.getElementById("credit").checked == true)
			{		
				if(document.getElementById("credit_card_info").value == '')
				{
					alert("<cf_get_lang dictionary_id='48862.Lütfen Kredi Kartı Seçiniz'>");
					return false;
				}
			}
		</cfif>
		<cfif session.ep.our_company_info.project_followup eq 1 and xml_project_require eq 1>//XML DE PROJE SEÇİMİ ZORUNLU İSE VE PROJE BAZLI TAKİP VARSA
			if(document.getElementById("project_head").value=='' || document.getElementById("project_id").value=='')
			{
				alert("<cf_get_lang dictionary_id='58797.Proje Seçiniz'>");
				document.getElementById('project_head').focus();	
				return false;
			} 
		</cfif>
		if(document.getElementById("ship_number").value == "")
		{ 
			alert ("<cf_get_lang dictionary_id='58138.İrsaliye No'>!");
			return false;
		}
		record_exist=0;//Row_kontrol değeri 1 olan yani silinmemiş satırların varlığını kontrol ediyor
		for(r=1;r<=upd_invent.record_num.value;r++)
		{
			if(document.getElementById("row_kontrol"+r).value == 1)
			{
				record_exist=1;
				if (document.getElementById("invent_no"+r).value == "")
				{ 
					alert("<cf_get_lang dictionary_id='56981.Lütfen Demirbaş No Giriniz'>!");
					return false;
				}
				if (document.getElementById("invent_name"+r).value == "")
				{ 
					alert("<cf_get_lang dictionary_id='31629.Lütfen Açıklama Giriniz'>");
					return false;
				}
				if ((document.getElementById("row_total"+r).value == "")||(document.getElementById("row_total"+r).value ==0))
				{ 
					alert("<cf_get_lang dictionary_id='29535.Lütfen Tutar Giriniz '>!");
					return false;
				}
				if ((document.getElementById("amortization_rate"+r).value == "")||(document.getElementById("amortization_rate"+r).value < 0))
				{ 
					alert("<cf_get_lang dictionary_id='56988.Lütfen Amortisman Oranı Giriniz'> !");
					return false;
				}
				if (document.getElementById("account_id"+r).value == "")
				{ 
					alert("<cf_get_lang dictionary_id='56989.Lütfen Muhasebe Kodu Seçiniz'>");
					return false;
				}
				document.getElementById("amortization_method"+r).disabled = false;
				document.getElementById("amortization_type"+r).disabled = false;
			}
		}
		change_paper_duedate('invoice_date');
		if (record_exist == 0) 
			{
				alert("<cf_get_lang dictionary_id='56983.Lütfen Demirbaş Giriniz'>!");
				return false;
			}
		return(unformat_fields());
	}
	
	/* delete function */
	function kontrol_2()
	{
		if(!paper_control(upd_invent.serial_no,'INVOICE',true,'',<cfoutput>'#get_invoice.serial_no#'</cfoutput>,upd_invent.company_id.value,upd_invent.consumer_id.value)) return false;
		<cfif session.ep.our_company_info.is_efatura and isdefined("get_efatura_det") and get_efatura_det.recordcount>
			alert("<cf_get_lang dictionary_id='57114.Fatura ile İlişkili e-Fatura Olduğu için Silinemez'>");
			return false;
		</cfif>
		if (!check_display_files('upd_invent')) return false;
		return true;
	}
	
	function amortisman_kontrol(x)
	{
		deger_amortization_rate = document.getElementById("amortization_rate"+x);
		if (filterNum(deger_amortization_rate.value) >100)
		{ 
			alert ("<cf_get_lang dictionary_id='56960.Amortisman Oranı 100 den Büyük Olamaz'>!");
			deger_amortization_rate.value = 0;
			return false;
		}
	}
	function period_kontrol(no)
	{
		deger = document.getElementById("period"+no);
		if ((filterNum(deger.value) <1) || (deger.value==""))
		{ 
			alert ("<cf_get_lang dictionary_id='56959.Hesaplama Dönemi 1 den Küçük Olamaz'>!");
			deger.value =1;
			return false;
		}
	}
	function  period_kontrol1(no)
	{
		deger1= document.getElementById("hd_period"+no);
		deger = document.getElementById("period"+no);
		if ((filterNum(deger.value) <1) || (deger.value==""))
		{ 
			alert ("<cf_get_lang dictionary_id='56959.Hesaplama Dönemi 1 den Küçük Olamaz'>!");
			deger.value=deger1.value;
			return false;
		}
	}
	function unformat_fields()
	{
		for(r=1;r<=upd_invent.record_num.value;r++)
		{
			deger_total = document.getElementById("row_total"+r);
			deger_total2 = document.getElementById("row_total_other"+r);
			deger_kdv_total= document.getElementById("kdv_total"+r);
			deger_otv_total= document.getElementById("otv_total"+r);
			deger_net_total = document.getElementById("net_total"+r);
			deger_other_net_total = document.getElementById("row_other_total"+r);
			deger_amortization_rate = document.getElementById("amortization_rate"+r);
			deger_miktar= document.getElementById("quantity"+r);
			temp_inventory_duration= document.getElementById("inventory_duration"+r);
			temp_inventory_duration_ifrs= document.getElementById("inventory_duration_ifrs"+r);
			
			deger_miktar.value = filterNum(deger_miktar.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
			deger_total.value = filterNum(deger_total.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
			deger_total2.value = filterNum(deger_total2.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
			deger_kdv_total.value = filterNum(deger_kdv_total.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
			deger_otv_total.value = filterNum(deger_otv_total.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
			deger_net_total.value = filterNum(deger_net_total.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
			deger_other_net_total.value = filterNum(deger_other_net_total.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
			deger_amortization_rate.value = filterNum(deger_amortization_rate.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
			temp_inventory_duration.value=filterNum(temp_inventory_duration.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
			temp_inventory_duration_ifrs.value=filterNum(temp_inventory_duration_ifrs.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
		}
		document.getElementById('total_amount').value = filterNum(document.getElementById('total_amount').value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
		document.getElementById('kdv_total_amount').value = filterNum(document.getElementById('kdv_total_amount').value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
		document.getElementById("otv_total_amount").value = filterNum(document.getElementById("otv_total_amount").value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>); 
		document.getElementById('net_total_amount').value = filterNum(document.getElementById('net_total_amount').value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
		document.getElementById('other_total_amount').value = filterNum(document.getElementById('other_total_amount').value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
		document.getElementById('other_kdv_total_amount').value = filterNum(document.getElementById('other_kdv_total_amount').value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
		document.getElementById("other_otv_total_amount").value = filterNum(document.getElementById("other_otv_total_amount").value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>); 
		document.getElementById('other_net_total_amount').value = filterNum(document.getElementById('other_net_total_amount').value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
		document.getElementById('net_total_discount').value = filterNum(document.getElementById('net_total_discount').value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
		document.getElementById('tevkifat_oran').value = filterNum(document.getElementById('tevkifat_oran').value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
		document.getElementById("stopaj_yuzde").value = filterNum(document.getElementById("stopaj_yuzde").value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
		document.getElementById("stopaj").value = filterNum(document.getElementById("stopaj").value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
		for(s=1;s<=upd_invent.kur_say.value;s++)
		{
			eval('upd_invent.txt_rate2_' + s).value = filterNum(eval('upd_invent.txt_rate2_' + s).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
			eval('upd_invent.txt_rate1_' + s).value = filterNum(eval('upd_invent.txt_rate1_' + s).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
		}
	}
	row_count=<cfoutput>#get_rows.recordcount#</cfoutput>;
	function sil(sy)
	{
		var my_element=eval("upd_invent.row_kontrol"+sy);
		my_element.value=0;
		var my_element=eval("frm_row"+sy);
		my_element.style.display="none";
		toplam_hesapla();
	}
	function hesapla(satir,hesap_type)
	{
		var toplam_dongu_0 = 0;//satir toplam
		if(document.getElementById("row_kontrol"+satir).value==1)
		{
			deger_total = document.getElementById("row_total"+satir);//tutar
			deger_total2 = document.getElementById("row_total_other"+satir);//dövizli tutar
			deger_miktar = document.getElementById("quantity"+satir);//miktar
			deger_kdv_total= document.getElementById("kdv_total"+satir);//kdv tutarı
			deger_otv_total= document.getElementById("otv_total"+satir);//otv tutarı
			deger_net_total = document.getElementById("net_total"+satir);//kdvli tutar
			deger_tax_rate = document.getElementById("tax_rate"+satir);//kdv oranı
			deger_otv_rate = document.getElementById("otv_rate"+satir);//otv oranı
			deger_other_net_total = document.getElementById("row_other_total"+satir);//dovizli tutar kdv dahil
			if(deger_total.value == "") deger_total.value = 0;
			if(deger_kdv_total.value == "") deger_kdv_total.value = 0;
			if(deger_net_total.value == "") deger_net_total.value = 0;
			deger_money_id = document.getElementById("money_id"+satir);
			deger_money_id_ilk = list_getat(deger_money_id.value,2,',');
			deger_money_id_son = list_getat(deger_money_id.value,3,',');
			deger_total.value = filterNum(deger_total.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
			deger_total2.value = filterNum(deger_total2.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
			deger_kdv_total.value = filterNum(deger_kdv_total.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
			deger_otv_total.value = filterNum(deger_otv_total.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
			deger_net_total.value = filterNum(deger_net_total.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
			deger_other_net_total.value = filterNum(deger_other_net_total.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
			deger_miktar.value = filterNum(deger_miktar.value,0);
			
			for(s=1;s<=upd_invent.kur_say.value;s++)
			{
				if(list_getat(document.upd_invent.rd_money[s-1].value,1,',') == list_getat(deger_money_id.value,1,','))
				{
					satir_rate2 = filterNum(document.getElementById("txt_rate2_"+s).value,<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>);
					satir_rate1 = filterNum(document.getElementById("txt_rate1_"+s).value,<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>);
				}
			}
			
			if(hesap_type == undefined)
			{
				deger_total2.value = parseFloat(deger_total.value)*(parseFloat(satir_rate1)/parseFloat(satir_rate2));
				deger_otv_total.value = (parseFloat(deger_total.value) * deger_miktar.value * deger_otv_rate.value)/100;
				<cfif isdefined('x_kdv_add_to_otv') and x_kdv_add_to_otv eq 0>  
					deger_kdv_total.value = ((parseFloat(deger_total.value) * parseFloat(deger_miktar.value)) * deger_tax_rate.value)/100;
				<cfelse>
					deger_kdv_total.value = ((parseFloat(deger_total.value* deger_miktar.value)+parseFloat(deger_otv_total.value)) * deger_tax_rate.value)/100;
				</cfif>
			}
			else if(hesap_type == 1)
			{
				deger_total.value = parseFloat(deger_total2.value)*(parseFloat(satir_rate2)/parseFloat(satir_rate1));
				deger_otv_total.value = (parseFloat(deger_total.value) * deger_miktar.value * deger_otv_rate.value)/100;
				<cfif isdefined('x_kdv_add_to_otv') and x_kdv_add_to_otv eq 0>  
					deger_kdv_total.value = ((parseFloat(deger_total.value) * parseFloat(deger_miktar.value)) * deger_tax_rate.value)/100;
				<cfelse>
					deger_kdv_total.value = ((parseFloat(deger_total.value* deger_miktar.value)+parseFloat(deger_otv_total.value)) * deger_tax_rate.value)/100;
				</cfif>
			}
			else if(hesap_type == 2)
			{
				<cfif isdefined('x_kdv_add_to_otv') and x_kdv_add_to_otv eq 0>  
					deger_total.value = ((parseFloat(deger_net_total.value)/parseFloat(deger_miktar.value))*100)/ (parseFloat(deger_tax_rate.value)+parseFloat(otv_rate_)+100);
					deger_kdv_total.value = (parseFloat(deger_total.value * deger_miktar.value * deger_tax_rate.value))/100;
					deger_otv_total.value = (parseFloat(deger_total.value * deger_miktar.value * deger_otv_rate.value))/100;
				<cfelse>
					deger_total.value = ((parseFloat(deger_net_total.value)*100)/ (parseFloat(deger_tax_rate.value)+100))/deger_miktar.value;
					deger_otv_total.value = (parseFloat(deger_total.value * deger_miktar.value * deger_otv_rate.value))/100;
					deger_kdv_total.value = ((parseFloat(deger_total.value * deger_miktar.value)+parseFloat(deger_otv_total.value)) * deger_tax_rate.value)/100;
				</cfif>
					deger_total2.value = parseFloat(deger_total.value)*(parseFloat(satir_rate1)/parseFloat(satir_rate2));
			}
			else if(hesap_type == 3)
			{
				<cfif isdefined('x_kdv_add_to_otv') and x_kdv_add_to_otv eq 0>
					deger_kdv_total.value = (parseFloat(deger_net_total.value * deger_tax_rate.value))/(100 + parseFloat(deger_tax_rate.value)+ parseFloat(deger_otv_rate.value));
					deger_otv_total.value = (parseFloat(deger_net_total.value * deger_otv_rate.value))/(100 + parseFloat(deger_tax_rate.value)+ parseFloat(deger_otv_rate.value));
				<cfelse>
					deger_kdv_total.value = (parseFloat(deger_net_total.value * deger_tax_rate.value))/(100 + parseFloat(deger_tax_rate.value));
					deger_otv_total.value = (parseFloat((deger_net_total.value - deger_kdv_total.value) * deger_otv_rate.value))/(100 + parseFloat(deger_otv_rate.value));
				</cfif>
					deger_total.value = parseFloat(deger_net_total.value - deger_kdv_total.value);
					deger_total.value = parseFloat(deger_total.value - deger_otv_total.value);
					deger_total.value = (deger_total.value/deger_miktar.value);
					deger_total2.value = parseFloat(deger_total.value)*(parseFloat(satir_rate1)/parseFloat(satir_rate2));
			}
			else if(hesap_type == 4)
			{
				deger_net_total.value = parseFloat(deger_other_net_total.value) * (parseFloat(satir_rate2)/parseFloat(satir_rate1));
				
				<cfif isdefined('x_kdv_add_to_otv') and x_kdv_add_to_otv eq 0>
					deger_kdv_total.value = (parseFloat(deger_net_total.value * deger_tax_rate.value))/(100 + parseFloat(deger_tax_rate.value)+ parseFloat(deger_otv_rate.value));
					deger_otv_total.value = (parseFloat(deger_net_total.value * deger_otv_rate.value))/(100 + parseFloat(deger_tax_rate.value)+ parseFloat(deger_otv_rate.value));
				<cfelse>
					deger_kdv_total.value = (parseFloat(deger_net_total.value * deger_tax_rate.value))/(100 + parseFloat(deger_tax_rate.value));
					deger_otv_total.value = (parseFloat((deger_net_total.value - deger_kdv_total.value) * deger_otv_rate.value))/(100 + parseFloat(deger_otv_rate.value));
				</cfif>
					deger_total.value = parseFloat(deger_net_total.value - deger_kdv_total.value);
					deger_total.value = parseFloat(deger_total.value - deger_otv_total.value);
					deger_total.value = (deger_total.value/deger_miktar.value);
					deger_total2.value = parseFloat(deger_total.value)*(parseFloat(satir_rate1)/parseFloat(satir_rate2));
			}
			toplam_dongu_0 = (parseFloat(deger_total.value)*deger_miktar.value) + parseFloat(deger_kdv_total.value) + parseFloat(deger_otv_total.value);
			deger_other_net_total.value = ((parseFloat(deger_total.value) + parseFloat(deger_kdv_total.value) + parseFloat(deger_otv_total.value)) * parseFloat(deger_money_id_ilk) / (parseFloat(deger_money_id_son)));
			deger_net_total.value = commaSplit(toplam_dongu_0,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
			deger_total.value = commaSplit(deger_total.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
			deger_total2.value = commaSplit(deger_total2.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
			deger_kdv_total.value = commaSplit(deger_kdv_total.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
			deger_otv_total.value = commaSplit(deger_otv_total.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
			deger_other_net_total.value = commaSplit(deger_other_net_total.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
		}
		toplam_hesapla();
	}

	var stopaj_yuzde_;
	function calc_stopaj()
	{
		stopaj_yuzde_ = filterNum(document.getElementById("stopaj_yuzde").value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
		if((stopaj_yuzde_ < 0) || (stopaj_yuzde_ > 99.99))
		{
			alert("<cf_get_lang dictionary_id='50036.Stopaj Oranı'>!");
			document.getElementById("stopaj_yuzde").value = 0;
		}
		toplam_hesapla(0);
	}
	function control_invent_no(value,control){
		if(control!=undefined)
		var sql = "SELECT INVENTORY_NUMBER FROM INVENTORY WHERE INVENTORY_NUMBER='"+document.getElementById("invent_no"+value).value+"' and INVENTORY_ID!="+control+"";
        else
		var sql = "SELECT INVENTORY_NUMBER FROM INVENTORY WHERE INVENTORY_NUMBER='"+document.getElementById("invent_no"+value).value+"'";

		get_inventory_no = wrk_query(sql,'DSN3');
		for(x=1;x<=row_count;x++)
		{
			if(document.getElementById("invent_no"+x).value == document.getElementById("invent_no"+value).value && x!=value && document.getElementById("invent_no"+value).value!="" || get_inventory_no.recordcount!=0) 
			{
				alert("<cf_get_lang dictionary_id='64243.Bu Demirbaş Numarası Kayıtlı'>!");
				document.getElementById("invent_no"+value).value="";
				break;
			}	
		}	
	}
	function toplam_hesapla(type)
	{
		var toplam_dongu_1 = 0;//tutar genel toplam
		var toplam_dongu_2 = 0;// kdv genel toplam
		var toplam_dongu_3 = 0;// kdvli genel toplam
		var toplam_dongu_4 = 0;// kdvli genel toplam
		var toplam_dongu_5 = 0;// ötv genel toplam
		var beyan_tutar = 0;
		var tevkifat_info = "";
		var beyan_tutar_info = "";
		var new_taxArray = new Array(0);
		var taxBeyanArray = new Array(0);
		var taxTevkifatArray = new Array(0);
		for(r=1;r<=upd_invent.record_num.value;r++)
		{
			if(document.getElementById("row_kontrol"+r).value==1)
			{
				toplam_dongu_4 = toplam_dongu_4 + (parseFloat(filterNum(document.getElementById("row_total"+r).value) * filterNum(document.getElementById("quantity"+r).value)));
			}
		}			
		deger_discount_value = filterNum(document.getElementById('net_total_discount').value);
		genel_indirim_yuzdesi = commaSplit(parseFloat(deger_discount_value) / parseFloat(toplam_dongu_4),8);
		genel_indirim_yuzdesi = filterNum(genel_indirim_yuzdesi,8);
		genel_indirim_yuzdesi = wrk_round(genel_indirim_yuzdesi,8);

		for(r=1;r<=upd_invent.record_num.value;r++)
		{
			if(document.getElementById("row_kontrol"+r).value==1)
			{
				deger_total = document.getElementById("row_total"+r);//tutar
				deger_total2 = document.getElementById("row_total_other"+r);//dövizli tutar
				deger_miktar = document.getElementById("quantity"+r);//miktar
				deger_kdv_total= document.getElementById("kdv_total"+r);//kdv tutarı
				deger_otv_total= document.getElementById("otv_total"+r);//ötv tutarı
				deger_net_total = document.getElementById("net_total"+r);//kdvli tutar
				deger_tax_rate = document.getElementById("tax_rate"+r);//kdv oranı
				deger_other_net_total = document.getElementById("row_other_total"+r);//dovizli tutar kdv dahil
				deger_money_id = document.getElementById("money_id"+r);
				deger_money_id_ilk = list_getat(deger_money_id.value,1,',');
				for(s=1;s<=upd_invent.kur_say.value;s++)
				{
					if(list_getat(document.upd_invent.rd_money[s-1].value,1,',') == deger_money_id_ilk)
					{
						satir_rate2= document.getElementById("txt_rate2_"+s).value;
					}
				}
				satir_rate2= filterNum(satir_rate2,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
				deger_money_id_son = list_getat(deger_money_id.value,3,',');
				deger_total.value = filterNum(deger_total.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
				deger_total2.value = filterNum(deger_total2.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
				deger_kdv_total.value = filterNum(deger_kdv_total.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
				deger_otv_total.value = filterNum(deger_otv_total.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
				toplam_dongu_2 = toplam_dongu_2 + parseFloat(deger_kdv_total.value)- parseFloat(deger_kdv_total.value*genel_indirim_yuzdesi);
				toplam_dongu_5 = toplam_dongu_5 + parseFloat(deger_otv_total.value);
				deger_indirim_kdv = parseFloat(deger_kdv_total.value)- parseFloat(deger_kdv_total.value*genel_indirim_yuzdesi);
				toplam_dongu_3 = toplam_dongu_3 + ((parseFloat(deger_total.value)- (parseFloat(deger_total.value)*genel_indirim_yuzdesi)) * filterNum(document.getElementById("quantity"+r).value));
				toplam_dongu_3 = toplam_dongu_3 + parseFloat(deger_kdv_total.value)- parseFloat(deger_kdv_total.value*genel_indirim_yuzdesi);
				toplam_dongu_3 = toplam_dongu_3 + parseFloat(deger_otv_total.value);
				
				if(document.getElementById('tevkifat_oran') != undefined && document.getElementById('tevkifat_oran').value != "" && upd_invent.tevkifat_box.checked == true)
				{//tevkifat hesaplamaları
					beyan_tutar = beyan_tutar + wrk_round(deger_indirim_kdv*filterNum(document.getElementById('tevkifat_oran').value));
					if(new_taxArray.length != 0)
						for (var m=0; m < new_taxArray.length; m++)
						{	
							var tax_flag = false;
							if(new_taxArray[m] == deger_tax_rate.value){
								tax_flag = true;
								taxBeyanArray[m] += wrk_round(deger_indirim_kdv - (deger_indirim_kdv*(filterNum(document.getElementById('tevkifat_oran').value))));
								taxTevkifatArray[m] += wrk_round(deger_indirim_kdv*(filterNum(document.getElementById('tevkifat_oran').value)));
								break;
							}
						}
					if(!tax_flag){
						new_taxArray[new_taxArray.length] = deger_tax_rate.value;
						taxBeyanArray[taxBeyanArray.length] = wrk_round(deger_indirim_kdv - (deger_indirim_kdv*(filterNum(document.getElementById('tevkifat_oran').value))));
						taxTevkifatArray[taxTevkifatArray.length] = wrk_round(deger_indirim_kdv*(filterNum(document.getElementById('tevkifat_oran').value)));
					}
				}
				deger_net_total.value = filterNum(deger_net_total.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
				deger_other_net_total.value = filterNum(deger_other_net_total.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
				toplam_dongu_1 = toplam_dongu_1 + parseFloat(deger_total.value * deger_miktar.value);
				deger_other_net_total.value = ((parseFloat(deger_total.value * deger_miktar.value) + parseFloat(deger_kdv_total.value) + parseFloat(deger_otv_total.value)) / (parseFloat(satir_rate2)));
				
				deger_net_total.value = commaSplit(deger_net_total.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
				deger_total.value = commaSplit(deger_total.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
				deger_total2.value = commaSplit(deger_total2.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
				deger_kdv_total.value = commaSplit(deger_kdv_total.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
				deger_otv_total.value = commaSplit(deger_otv_total.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
				deger_other_net_total.value = commaSplit(deger_other_net_total.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
			}
		}
		if(document.getElementById('tevkifat_oran') != undefined && document.getElementById('tevkifat_oran').value != "" && upd_invent.tevkifat_box.checked == true)
		{//tevkifat hesaplamaları
			toplam_dongu_3 = toplam_dongu_3 - toplam_dongu_2 + beyan_tutar;
			toplam_dongu_2 = beyan_tutar;
			tevkifat_text.style.fontWeight = 'bold';
			tevkifat_text.innerHTML = '';
			beyan_text.style.fontWeight = 'bold';
			beyan_text.innerHTML = '';
			for (var tt=0; tt < new_taxArray.length; tt++)
			{
				tevkifat_text.innerHTML += '% ' + new_taxArray[tt] + ' : ' + commaSplit(taxBeyanArray[tt],4) + ' ';
				beyan_text.innerHTML += '% ' + new_taxArray[tt] + ' : ' + commaSplit(taxTevkifatArray[tt],4) + ' ';
			}
		}
		var stopaj_yuzde_ = filterNum(document.getElementById("stopaj_yuzde").value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
		if(type == undefined || stopaj_yuzde_ == 0)
			stopaj_ = wrk_round(((toplam_dongu_1 * stopaj_yuzde_) / 100),<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
		else
			stopaj_ = filterNum(document.getElementById("stopaj").value);
			
		document.getElementById("stopaj_yuzde").value = commaSplit(stopaj_yuzde_);
		document.getElementById("stopaj").value = commaSplit(stopaj_,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
		
		toplam_dongu_3 = toplam_dongu_3-parseFloat(stopaj_);
		//stopajlar hesaplandi
		document.getElementById('total_amount').value = commaSplit(toplam_dongu_1,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
		document.getElementById('kdv_total_amount').value = commaSplit(toplam_dongu_2,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
		document.getElementById('otv_total_amount').value = commaSplit(toplam_dongu_5,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
		document.getElementById('net_total_amount').value = commaSplit(toplam_dongu_3,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
		for(s=1;s<=upd_invent.kur_say.value;s++)
		{
			form_txt_rate2_ = document.getElementById("txt_rate2_"+s);
			if(form_txt_rate2_.value == "")
				form_txt_rate2_.value = 1;
		}
		if(upd_invent.kur_say.value == 1)
			for(s=1;s<=upd_invent.kur_say.value;s++)
			{
				if(document.getElementById('rd_money').checked == true)
				{
					deger_diger_para = document.getElementById('rd_money');
					form_txt_rate2_ = document.getElementById("txt_rate2_"+s);
				}
			}
		else 
			for(s=1;s<=upd_invent.kur_say.value;s++)
			{
				if(document.upd_invent.rd_money[s-1].checked == true)
				{
					deger_diger_para = document.upd_invent.rd_money[s-1];
					form_txt_rate2_ = document.getElementById("txt_rate2_"+s);
				}
			}
		deger_money_id_1 = list_getat(deger_diger_para.value,1,',');
		deger_money_id_3 = list_getat(deger_diger_para.value,3,',');
		form_txt_rate2_.value = filterNum(form_txt_rate2_.value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
		document.getElementById('other_total_amount').value = commaSplit(toplam_dongu_1 * parseFloat(deger_money_id_3) / (parseFloat(form_txt_rate2_.value)),<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
		document.getElementById('other_kdv_total_amount').value = commaSplit(toplam_dongu_2 * parseFloat(deger_money_id_3) / (parseFloat(form_txt_rate2_.value)),<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
		document.getElementById('other_otv_total_amount').value = commaSplit(toplam_dongu_5 * parseFloat(deger_money_id_3) / (parseFloat(form_txt_rate2_.value)),<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
		document.getElementById('other_net_total_amount').value = commaSplit(toplam_dongu_3 * parseFloat(deger_money_id_3) / (parseFloat(form_txt_rate2_.value)),<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
		document.getElementById('other_net_total_discount').value = commaSplit(parseFloat(deger_discount_value)* parseFloat(deger_money_id_3) / (parseFloat(form_txt_rate2_.value)),<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
		document.getElementById('net_total_discount').value = commaSplit(parseFloat(deger_discount_value),<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
		
		document.getElementById('tl_value1').value = deger_money_id_1;
		document.getElementById('tl_value2').value = deger_money_id_1;	//kdv
		document.getElementById('tl_value5').value = deger_money_id_1;	//otv
		document.getElementById('tl_value3').value = deger_money_id_1;
		document.getElementById('tl_value4').value = deger_money_id_1;
		form_txt_rate2_.value = commaSplit(form_txt_rate2_.value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
	}
	
	function add_row(inventory_cat_id,inventory_cat,invent_no,invent_name,quantity,row_total,row_total_other,tax_rate,otv_rate,kdv_total,otv_total,net_total,row_other_total,money_id,inventory_duration,amortization_rate,amortization_method,amortization_type,account_id,account_code,expense_center_id,expense_center_name,expense_item_id,expense_item_name,period,debt_account_id,debt_account_code,claim_account_id,claim_account_code,product_id,stock_id,product_name,stock_unit_id,stock_unit,inventory_duration_ifrs)
	{
		if (inventory_cat_id == undefined) inventory_cat_id ="";
		if (inventory_cat == undefined) inventory_cat ="";
		if (invent_no == undefined) invent_no ="";
		if (invent_name == undefined) invent_name ="";
		if (quantity == undefined) quantity = 1;
		if (row_total == undefined) row_total = 0;
		if (row_total_other == undefined) row_total_other = 0;
		if (tax_rate == undefined) tax_rate ="";
		if (otv_rate == undefined) otv_rate ="";
		if (kdv_total == undefined) kdv_total = 0;
		if (otv_total == undefined) otv_total = 0;
		if (net_total == undefined) net_total = 0;
		if (row_other_total == undefined) row_other_total = 0;
		if (money_id == undefined) money_id ="";
		if (inventory_duration == undefined) inventory_duration ="";
		if (inventory_duration_ifrs == undefined) inventory_duration_ifrs ="";
		if (amortization_rate == undefined) amortization_rate ="";
		if (amortization_method == undefined) amortization_method ="";
		if (amortization_type == undefined) amortization_type ="";
		if (account_id == undefined) account_id ="";
		if (account_code == undefined) account_code ="";
		if (expense_center_id == undefined) expense_center_id ="";
		if (expense_center_name == undefined) expense_center_name ="";
		if (expense_item_id == undefined) expense_item_id ="";
		if (expense_item_name == undefined) expense_item_name ="";
		if (period == undefined) period = 12;
		if (debt_account_id == undefined) debt_account_id ="";
		if (debt_account_code == undefined) debt_account_code ="";
		if (claim_account_id == undefined) claim_account_id ="";
		if (claim_account_code == undefined) claim_account_code ="";
		if (product_id == undefined) product_id ="";
		if (stock_id == undefined) stock_id ="";
		if (product_name == undefined) product_name ="";
		if (stock_unit_id == undefined) stock_unit_id ="";
		if (stock_unit == undefined) stock_unit ="";
	
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
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		x = '<input  type="hidden" value="WRK'+row_count+ js_create_unique_id() + row_count+'" name="wrk_row_id' + row_count +'" id="wrk_row_id' + row_count +'"><input  type="hidden" value="" name="wrk_row_relation_id' + row_count +'" id="wrk_row_relation_id' + row_count +'">';
		newCell.innerHTML = x + '<ul class="ui-icon-list"><input  type="hidden" value="1" name="row_kontrol' + row_count +'" id="row_kontrol' + row_count +'"><li><a href="javascript://" onclick="sil(' + row_count + ');"><i class="fa fa-minus" title="<cf_get_lang dictionary_id='58971.Satır Sil'>" alt="<cf_get_lang dictionary_id='58971.Satır Sil'>"></i></a></li><li><a style="cursor:pointer" onclick="copy_row('+row_count+');" title="<cf_get_lang dictionary_id="58972.Satır Kopyala">"><i class="fa fa-copy" title="<cf_get_lang dictionary_id='58972.Satır Kopyala'>" alt="<cf_get_lang dictionary_id='58972.Satır Kopyala'>"></i></a></li></ul>';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<input  type="hidden" id="inventory_cat_id' + row_count +'" name="inventory_cat_id' + row_count +'" value="' + inventory_cat_id +'"><input type="text" id="inventory_cat' + row_count +'" name="inventory_cat' + row_count +'" value="' + inventory_cat +'" style="width:135px;" class="boxtext"><a href="javascript://" onClick="open_inventory_cat_list('+ row_count +');"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" onblur="control_invent_no(' + row_count +')" id="invent_no' + row_count +'" name="invent_no' + row_count +'" value="' + invent_no +'" class="boxtext" maxlength="50">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" id="invent_name' + row_count +'" name="invent_name' + row_count +'" value="' + invent_name +'" style="width:100px;" class="boxtext" maxlength="100">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" id="quantity' + row_count +'" name="quantity' + row_count +'" value="' + quantity +'" class="box" onBlur="hesapla(' + row_count +');" onkeyup="return(FormatCurrency(this,event));">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" id="row_total' + row_count +'" name="row_total' + row_count +'" value="' + row_total +'" onkeyup="return(FormatCurrency(this,event,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>));" onBlur="hesapla(' + row_count +');" class="box">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" id="row_total_other' + row_count +'" name="row_total_other' + row_count +'" value="' + row_total_other +'" onkeyup="return(FormatCurrency(this,event,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>));" onBlur="hesapla(' + row_count +',1);" class="box">';
		//kdv orani
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		a = '<select id="tax_rate'+ row_count +'" name="tax_rate'+ row_count +'" onChange="hesapla('+ row_count +');" class="box">';
			<cfoutput query="get_tax">
				if('#tax#' == tax_rate)
					a += '<option value="#tax#" selected>#tax#</option>';
				else
					a += '<option value="#tax#">#tax#</option>';
			</cfoutput>
		newCell.innerHTML = a+ '</select>';
		//otv orani
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		x = '<select id="otv_rate'+ row_count +'" name="otv_rate'+ row_count +'" onChange="hesapla('+ row_count +');" class="box">';
		x += '<option value="0"><cf_get_lang dictionary_id="58021.ÖTV"></option>';
			<cfoutput query="get_otv">
				if('#tax#' == otv_rate)
					x += '<option value="#tax#" selected>#tax#</option>';
				else
					x += '<option value="#tax#">#tax#</option>';
			</cfoutput>
		newCell.innerHTML = x+ '</select>';
		//kdv total
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" id="kdv_total' + row_count +'" name="kdv_total' + row_count +'" value="' + kdv_total +'" onkeyup="return(FormatCurrency(this,event,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>));" onBlur="hesapla(' + row_count +',1);" class="box">';
		//otv total
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" id="otv_total' + row_count +'" name="otv_total' + row_count +'" value="' + otv_total +'" onkeyup="return(FormatCurrency(this,event,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>));" onBlur="hesapla(' + row_count +',1);" class="box">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" id="net_total' + row_count +'" name="net_total' + row_count +'" value="' + net_total +'" class="box" onkeyup="return(FormatCurrency(this,event,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>));" onblur="hesapla(' + row_count +',3);">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" id="row_other_total' + row_count +'" name="row_other_total' + row_count +'" value="' + row_other_total +'" onkeyup="return(FormatCurrency(this,event,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>));" class="box" onblur="hesapla(' + row_count +',4);">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		b = '<select id="money_id' + row_count  +'" name="money_id' + row_count  +'" class="boxtext" onChange="hesapla('+ row_count +');">';
			<cfoutput query="get_money">
				if('#money#,#rate1#,#rate2#' == money_id)
					b += '<option value="#money#,#rate1#,#rate2#" selected>#money#</option>';
				else
					b += '<option value="#money#,#rate1#,#rate2#">#money#</option>';
			</cfoutput>
		newCell.innerHTML = b+ '</select>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" id="inventory_duration' + row_count +'" name="inventory_duration' + row_count +'" value="' + inventory_duration +'" class="box" onkeyup="return(FormatCurrency(this,event));">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" id="inventory_duration_ifrs' + row_count +'" name="inventory_duration_ifrs' + row_count +'" value="' + inventory_duration_ifrs +'" class="box" onkeyup="return(FormatCurrency(this,event));">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" id="amortization_rate' + row_count +'" name="amortization_rate' + row_count +'" value="' + amortization_rate +'" class="box" onblur="return(amortisman_kontrol(' + row_count +'));" onkeyup="return(FormatCurrency(this,event));">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<select id="amortization_method'+ row_count +'" name="amortization_method'+ row_count +'" style="margin-left:-7px;"><option value="0" ><cf_get_lang dictionary_id="29421.Azalan Bakiye Üzerinden"></option><option value="1" ><cf_get_lang dictionary_id="29422.Normal Amortisman"></option></select>';
		if(amortization_method != '')
			document.getElementById('amortization_method'+ row_count).value = amortization_method;
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<select id="amortization_type'+ row_count +'" name="amortization_type'+ row_count +'" style="margin-left:-7px;"><option value="1">Kıst Amortismana Tabi</option><option value="2" selected>Kıst Amortismana Tabi Değil</option>></select>';
		if(amortization_type != '')
			document.getElementById('amortization_type'+ row_count).value = amortization_type;
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<input type="hidden" id="account_id' + row_count +'" name="account_id' + row_count +'" value="' + account_id +'"><input type="text" id="account_code' + row_count +'" name="account_code' + row_count +'" value="' + account_code +'" style="width:139px;" class="boxtext" onFocus="autocomp_account('+row_count+');"><a href="javascript://"><a href="javascript://" onClick="pencere_ac_acc('+ row_count +');"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML ='<input type="hidden" name="expense_center_id' + row_count +'" value="'+expense_center_id+'" id="expense_center_id' + row_count +'"><input type="text" id="expense_center_name' + row_count +'" name="expense_center_name' + row_count +'" onFocus="exp_center('+row_count+');" value="'+expense_center_name+'" class="boxtext"><a href="javascript://" onClick="pencere_ac_exp_center('+ row_count +');"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<input type="hidden" id="expense_item_id' + row_count +'" name="expense_item_id' + row_count +'" value="' + expense_item_id +'"><input type="text" id="expense_item_name' + row_count +'" name="expense_item_name' + row_count +'" value="' + expense_item_name +'" class="boxtext" onFocus="exp_item('+row_count+');"><a href="javascript://"><img src="/images/plus_thin.gif" onclick="pencere_ac_exp('+ row_count +');" align="absmiddle" border="0"></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" id="period' + row_count +'" name="period' + row_count +'" value="' + period +'" class="box" onblur="return(period_kontrol(' + row_count +'));" onkeyup="return(FormatCurrency(this,event,0));">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<input type="hidden" id="debt_account_id' + row_count +'" name="debt_account_id' + row_count +'" value="' + debt_account_id +'"><input type="text" id="debt_account_code' + row_count +'" name="debt_account_code' + row_count +'" value="' + debt_account_code +'" style="width:185px;" class="boxtext" onFocus="autocomp_debt_account('+row_count+');"> <a href="javascript://" onClick="pencere_ac_acc2('+ row_count +');"><img src="/images/plus_thin.gif"  align="absmiddle" border="0"></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<input type="hidden" id="claim_account_id' + row_count +'" name="claim_account_id' + row_count +'" value="' + claim_account_id +'"><input type="text" id="claim_account_code' + row_count +'" name="claim_account_code' + row_count +'" value="' + claim_account_code +'" style="width:203px;" class="boxtext" onFocus="autocomp_claim_account('+row_count+');"><a href="javascript://" onClick="pencere_ac_acc1('+ row_count +');"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<input  type="hidden" id="product_id' + row_count +'" name="product_id' + row_count +'" value="' + product_id +'"><input  type="hidden" id="stock_id' + row_count +'" name="stock_id' + row_count +'" value="' + stock_id +'"><input type="text" id="product_name' + row_count +'" name="product_name' + row_count +'" value="' + product_name +'" style="width:139px;" class="boxtext" maxlength="75" onFocus="AutoComplete_Create(\'product_name' + row_count +'\',\'PRODUCT_NAME\',\'PRODUCT_NAME,STOCK_CODE\',\'get_product_autocomplete\',\'0\',\'PRODUCT_ID,STOCK_ID,MAIN_UNIT,PRODUCT_UNIT_ID\',\'product_id' + row_count +',stock_id' + row_count +',stock_unit' + row_count  +',stock_unit_id' + row_count  +'\',\'add_invent\',1,\'\',\'\');"><a href="javascript://" onClick=""><a href="javascript://" onClick="openBoxDraggable('+"'<cfoutput>#request.self#?fuseaction=objects.popup_product_names</cfoutput>&product_id=product_id" + row_count + "&field_id=stock_id" + row_count + "&field_unit_name=stock_unit" + row_count + "&field_main_unit=stock_unit_id" + row_count + "&field_name=product_name" + row_count + "');"+'"><img src="/images/plus_thin.gif" border="0" align="absbottom"></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="hidden" id="stock_unit_id' + row_count +'" name="stock_unit_id' + row_count +'" value="' + stock_unit_id +'"><input type="text" id="stock_unit' + row_count +'" name="stock_unit' + row_count +'" value="' + stock_unit +'" class="boxtext">';
	}
	
	function copy_row(no_info)
	{
		if (document.getElementById("inventory_cat_id" + no_info) == undefined) inventory_cat_id =""; else inventory_cat_id = document.getElementById("inventory_cat_id" + no_info).value;
		if (document.getElementById("inventory_cat" + no_info) == undefined) inventory_cat =""; else inventory_cat = document.getElementById("inventory_cat" + no_info).value;
		invent_no ="";
		if (document.getElementById("invent_name" + no_info) == undefined) invent_name =""; else invent_name = document.getElementById("invent_name" + no_info).value;
		if (document.getElementById("quantity" + no_info) == undefined) quantity =""; else quantity = document.getElementById("quantity" + no_info).value;
		if (document.getElementById("row_total" + no_info) == undefined) row_total =""; else row_total = document.getElementById("row_total" + no_info).value;
		if (document.getElementById("row_total_other" + no_info) == undefined) row_total_other =""; else row_total_other = document.getElementById("row_total_other" + no_info).value;
		if (document.getElementById("tax_rate" + no_info) == undefined) tax_rate =""; else tax_rate = document.getElementById("tax_rate" + no_info).value;
		if (document.getElementById("otv_rate" + no_info) == undefined) otv_rate =""; else otv_rate = document.getElementById("otv_rate" + no_info).value;
		if (document.getElementById("kdv_total" + no_info) == undefined) kdv_total =""; else kdv_total = document.getElementById("kdv_total" + no_info).value;
		if (document.getElementById("otv_total" + no_info) == undefined) otv_total =""; else otv_total = document.getElementById("otv_total" + no_info).value;
		if (document.getElementById("net_total" + no_info) == undefined) net_total =""; else net_total =  document.getElementById("net_total" + no_info).value;
		if (document.getElementById("row_other_total" + no_info) == undefined) row_other_total =""; else row_other_total = document.getElementById("row_other_total" + no_info).value;
		if (document.getElementById("money_id" + no_info) == undefined) money_id =""; else money_id = document.getElementById("money_id" + no_info).value;
		if (document.getElementById("inventory_duration" + no_info) == undefined) inventory_duration =""; else inventory_duration = document.getElementById("inventory_duration" + no_info).value;
		if (document.getElementById("inventory_duration_ifrs" + no_info) == undefined) inventory_duration_ifrs =""; else inventory_duration_ifrs = document.getElementById("inventory_duration_ifrs" + no_info).value;
		if (document.getElementById("amortization_rate" + no_info) == undefined) amortization_rate =""; else amortization_rate = document.getElementById("amortization_rate" + no_info).value;
		if (document.getElementById("amortization_method" + no_info) == undefined) amortization_method =""; else amortization_method = document.getElementById("amortization_method" + no_info).value;
		if (document.getElementById("amortization_type" + no_info) == undefined) amortization_type =""; else amortization_type = document.getElementById("amortization_type" + no_info).value;
		if (document.getElementById("account_id" + no_info) == undefined) account_id =""; else account_id =  document.getElementById("account_id" + no_info).value;
		if (document.getElementById("account_code" + no_info) == undefined) account_code =""; else account_code = document.getElementById("account_code" + no_info).value;
		if (document.getElementById("expense_center_id" + no_info) == undefined) expense_center_id =""; else expense_center_id = document.getElementById("expense_center_id" + no_info).value;
		if (document.getElementById("expense_center_name" + no_info) == undefined) expense_center_name =""; else expense_center_name = document.getElementById("expense_center_name" + no_info).value;
		if (document.getElementById("expense_item_id" + no_info) == undefined) expense_item_id =""; else expense_item_id = document.getElementById("expense_item_id" + no_info).value;
		if (document.getElementById("expense_item_name" + no_info) == undefined) expense_item_name =""; else expense_item_name = document.getElementById("expense_item_name" + no_info).value;
		if (document.getElementById("period" + no_info) == undefined) period =""; else period = document.getElementById("period" + no_info).value;
		if (document.getElementById("debt_account_id" + no_info) == undefined) debt_account_id =""; else debt_account_id = document.getElementById("debt_account_id" + no_info).value;
		if (document.getElementById("debt_account_code" + no_info) == undefined) debt_account_code =""; else debt_account_code = document.getElementById("debt_account_code" + no_info).value;
		if (document.getElementById("claim_account_id" + no_info) == undefined) claim_account_id =""; else claim_account_id = document.getElementById("claim_account_id" + no_info).value;
		if (document.getElementById("claim_account_code" + no_info) == undefined) claim_account_code =""; else claim_account_code = document.getElementById("claim_account_code" + no_info).value;
		if (document.getElementById("product_id" + no_info) == undefined) product_id =""; else product_id = document.getElementById("product_id" + no_info).value;
		if (document.getElementById("stock_id" + no_info) == undefined) stock_id =""; else stock_id = document.getElementById("stock_id" + no_info).value;
		if (document.getElementById("product_name" + no_info) == undefined) product_name =""; else product_name = document.getElementById("product_name" + no_info).value;
		if (document.getElementById("stock_unit_id" + no_info) == undefined) stock_unit_id =""; else stock_unit_id = document.getElementById("stock_unit_id" + no_info).value;
		if (document.getElementById("stock_unit" + no_info) == undefined) stock_unit =""; else stock_unit = document.getElementById("stock_unit" + no_info).value;
		
		add_row(inventory_cat_id,inventory_cat,invent_no,invent_name,quantity,row_total,row_total_other,tax_rate,otv_rate,kdv_total,otv_total,net_total,row_other_total,money_id,inventory_duration,amortization_rate,amortization_method,amortization_type,account_id,account_code,expense_center_id,expense_center_name,expense_item_id,expense_item_name,period,debt_account_id,debt_account_code,claim_account_id,claim_account_code,product_id,stock_id,product_name,stock_unit_id,stock_unit,inventory_duration_ifrs);
		hesapla(row_count);
	}
	/* masraf merkezi popup */
	function pencere_ac_exp_center(no)
	{
		openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_expense_center&is_invoice=1&field_id=upd_invent.expense_center_id' + no +'&field_name=upd_invent.expense_center_name' + no);
	}
	/* masraf merkezi autocomplete */
	function exp_center(no)
	{
		AutoComplete_Create("expense_center_name" + no,"EXPENSE,EXPENSE_CODE","EXPENSE,EXPENSE_CODE","get_expense_center","","EXPENSE_ID","expense_center_id"+no,"",3);
	}
	/* gider kalemi autocomplete */
	function exp_item(no)
	{
		AutoComplete_Create("expense_item_name" + no,"EXPENSE_ITEM_NAME","EXPENSE_ITEM_NAME","get_expense_item","","EXPENSE_ITEM_ID,ACCOUNT_CODE,ACCOUNT_CODE","expense_item_id"+no+",debt_account_code"+no+",debt_account_id"+no,"",3);
	}
	function autocomp_account(no)
	{
		AutoComplete_Create("account_code"+no,"ACCOUNT_CODE,ACCOUNT_NAME","ACCOUNT_CODE,ACCOUNT_NAME","get_account_code","0","ACCOUNT_CODE","account_id"+no,"",3);
	}
	function autocomp_debt_account(no)
	{
		AutoComplete_Create("debt_account_code"+no,"ACCOUNT_CODE,ACCOUNT_NAME","ACCOUNT_CODE,ACCOUNT_NAME","get_account_code","0","ACCOUNT_CODE","debt_account_id"+no,"",3);
	}
	function autocomp_claim_account(no)
	{
		AutoComplete_Create("claim_account_code"+no,"ACCOUNT_CODE,ACCOUNT_NAME","ACCOUNT_CODE,ACCOUNT_NAME","get_account_code","0","ACCOUNT_CODE","claim_account_id"+no,"",3);
	}
	function pencere_ac_acc(no)
	{
		openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_id=upd_invent.account_id' + no +'&is_form_submitted' + no +'&field_name=upd_invent.account_code' + no +'');
	}
	function pencere_ac_acc1(no)
	{
		openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_id=upd_invent.claim_account_id' + no +'&field_name=upd_invent.claim_account_code' + no +'');
	}
	function pencere_ac_acc2(no)
	{
		openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_id=upd_invent.debt_account_id' + no +'&field_name=upd_invent.debt_account_code' + no +'');
	}
	function pencere_ac_exp(no)
	{
		openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_exp_item&is_budget_items=1&field_id=upd_invent.expense_item_id' + no +'&field_name=upd_invent.expense_item_name' + no +'&field_account_no=upd_invent.debt_account_id' + no +'&field_account_no2=upd_invent.debt_account_code' + no +'');
	}
	function pencere_ac_stock(no)
	{
			if(upd_invent.branch_id.value == '')
			{
				alert("<cf_get_lang dictionary_id='57723.Önce depo seçmelisiniz'>!");
				return false;
			}
			if(upd_invent.company_id.value.length==0)
			{ 
				alert("<cf_get_lang dictionary_id='57715.Önce Üye Seçiniz'>!");
				return false;
			}
			if(upd_invent.company_id!=undefined && upd_invent.company_id.value.length)
				windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_products&company_id='+upd_invent.company_id.value+'&int_basket_id=1&is_sale_product=0&update_product_row_id=0</cfoutput>','list');
	}
	function clear_()
	{
		if(document.getElementById('employee').value=='')
		{
			document.getElementById('employee_id').value='';
		}
	}
	function open_inventory_cat_list(no)
	{
		openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_inventory_cat&field_id=upd_invent.inventory_cat_id' + no +'&field_name=upd_invent.inventory_cat' + no +'&field_amortization_rate=upd_invent.amortization_rate' + no +'&field_inventory_duration=upd_invent.inventory_duration' + no + '&field_inventory_duration_ifrs=upd_invent.inventory_duration_ifrs' + no);
	}
	function ayarla_gizle_goster(id)
	{
		if(id==1)
		{
			if(document.getElementById("cash").checked == true)
			{
				if (document.getElementById("credit")) 
				{
					document.getElementById("credit").checked = false;
					document.getElementById("credit2").style.display='none';
				}
				document.getElementById("kasa2").style.display='';
			}
			else
			{
				document.getElementById("kasa2").style.display='none';
			}
		}
		else if(id==2)
		{
			if(document.getElementById("credit").checked == true)
			{
				if (document.getElementById("cash")) 
				{
					document.getElementById("cash").checked = false;
					document.getElementById("kasa2").style.display='none';
				}
				document.getElementById("credit2").style.display='';
			}
			else
			{
				document.getElementById("credit2").style.display='none';
			}
		}
	}
	function change_paper_duedate(field_name,type,is_row_parse) 
	{
		paper_date_=eval('document.upd_invent.invoice_date.value');
		if(type!=undefined && type==1)
			document.getElementById('basket_due_value').value = datediff(paper_date_,document.getElementById('basket_due_value_date_').value,0);
		else
		{
			if(isNumber(document.getElementById('basket_due_value'))!= false && (document.getElementById('basket_due_value').value != 0))
				document.getElementById('basket_due_value_date_').value = date_add('d',+document.getElementById('basket_due_value').value,paper_date_);
			else
			{
				document.getElementById('basket_due_value_date_').value = paper_date_;
				if(document.getElementById('basket_due_value').value == '')
					document.getElementById('basket_due_value').value = datediff(paper_date_,document.getElementById('basket_due_value_date_').value,0);
			}
		}
	}
</script>
