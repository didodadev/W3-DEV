<cf_xml_page_edit fuseact="invent.add_invent_purchase">
<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.company" default="">
<cfparam name="attributes.partner_name" default="">
<cfparam name="attributes.partner_id" default="">
<cfparam name="attributes.member_code" default="">
<cfif isdefined('attributes.company_id') and len(attributes.company_id)>
	<cfset attributes.company_id = attributes.company_id>
	<cfset attributes.company = get_par_info(attributes.company_id,1,1,0)>
	<cfif len(attributes.partner_id)>
		<cfset attributes.partner_id = attributes.partner_id>
		<cfset attributes.partner_name = get_par_info(attributes.partner_id,0,-1,0)>
	<cfelse>
		<cfquery name="get_manager_partner" datasource="#dsn#">
			SELECT MANAGER_PARTNER_ID FROM COMPANY WHERE COMPANY_ID = #attributes.company_id#
		</cfquery>
		<cfset attributes.partner_id = get_manager_partner.manager_partner_id>
		<cfset attributes.partner_name = get_par_info(get_manager_partner.manager_partner_id,0,-1,0)>
	</cfif>
	<cfset attributes.member_code = GET_COMPANY_PERIOD(attributes.company_id)>
	<cfquery name="GET_PAYMETHOD" datasource="#DSN#">
		SELECT
			CC.PAYMETHOD_ID,
			SP.PAYMETHOD,
			SP.DUE_DAY
		FROM
			COMPANY_CREDIT CC
				LEFT JOIN SETUP_PAYMETHOD SP ON SP.PAYMETHOD_ID = CC.PAYMETHOD_ID
		WHERE
			CC.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
			AND CC.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.COMPANY_ID#">
	</cfquery>
	<cfif len(get_paymethod.paymethod_id)>
		<cfset invoice_paymethod_id = get_paymethod.paymethod_id>
		<cfset invoice_paymethod = get_paymethod.paymethod>
		<cfset invoice_due_day = get_paymethod.due_day>
		<cfif len(get_paymethod.due_day)>
			<cfset invoice_due_date = dateadd('d',get_paymethod.due_day,now())>
		</cfif>
	</cfif>
</cfif>

<cfquery name="GET_MONEY" datasource="#DSN#">
	SELECT MONEY,RATE1,RATE2 FROM SETUP_MONEY WHERE PERIOD_ID = #session.ep.period_id# AND MONEY_STATUS = 1 ORDER BY MONEY_ID
</cfquery>
<cfquery name="KASA" datasource="#DSN2#">
	SELECT CASH_CURRENCY_ID,CASH_NAME,CASH_ID FROM CASH WHERE CASH_ACC_CODE IS NOT NULL ORDER BY CASH_NAME
</cfquery>
<cfquery name="GET_TAX" datasource="#DSN2#">
	SELECT TAX FROM SETUP_TAX ORDER BY TAX
</cfquery>
<cfquery name="GET_OTV" datasource="#DSN3#">
	SELECT TAX FROM SETUP_OTV WHERE PERIOD_ID = #session.ep.period_id# ORDER BY TAX
</cfquery>
<cfquery name="GET_EXPENSE_CENTER" datasource="#DSN2#">
	SELECT EXPENSE_ID,EXPENSE,EXPENSE_CODE FROM EXPENSE_CENTER ORDER BY EXPENSE
</cfquery>
<cfquery name="GET_SALE_DET" datasource="#dsn2#">
	SELECT 
		ACC_DEPARTMENT_ID
	FROM
		INVOICE
	WHERE
		INVOICE_CAT <> 67 AND
		INVOICE_CAT <> 69
</cfquery>
<cfset invoice_date = now()>
<cfset process_date = now()>
<cfset serial_no = ''>
<cfset serial_number = ''>
<cfif isdefined("attributes.receiving_detail_id")>
	<!--- Gelen e-fatura sayfasindaki xml degerleri aliniyor. --->
	<cf_xml_page_edit fuseact="objects.popup_dsp_efatura_detail">
	<cfquery name="GET_INV_DET" datasource="#DSN2#">
		SELECT ISSUE_DATE,EINVOICE_ID FROM EINVOICE_RECEIVING_DETAIL WHERE RECEIVING_DETAIL_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.receiving_detail_id#"> 
	</cfquery>
	<cfif get_inv_det.recordcount>
		<cfset invoice_date = get_inv_det.issue_date>
		<cfset process_date = get_inv_det.issue_date>
        <cfif xml_separate_serial_number>
			<cfset serial_no = right(get_inv_det.einvoice_id,13)>
            <cfset serial_number = left(get_inv_det.einvoice_id,3)>
        <cfelse>
        	<cfset serial_no = get_inv_det.einvoice_id>
        </cfif>        

		<script type="text/javascript">
			try{
				window.onload = function () { change_money_info('add_invent','invoice_date');}
			}
			catch(e){}
		</script>
	</cfif>
</cfif>

<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box>
		<cfform name="add_invent" id="add_invent" method="post" action="#request.self#?fuseaction=invent.emptypopup_add_invent_purchase">
		<cfif isdefined("attributes.receiving_detail_id")>
			<input type="hidden" name="receiving_detail_id" id="receiving_detail_id" value="<cfoutput>#attributes.receiving_detail_id#</cfoutput>">
		</cfif>
		<input type="hidden" name="active_period" id="active_period" value="<cfoutput>#session.ep.period_id#</cfoutput>"> 
		<cf_box_elements id="invent_purchase">
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
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="57800.İşlem Tipi"> *</label>
					<div class="col col-8 col-xs-12"><cf_workcube_process_cat slct_width="140"></div>
				</div>
				<div class="form-group" id="item-comp_name">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="57519.Cari Hesap"> *</label>
					<div class="col col-8 col-xs-12">
						<div class="input-group">
							<cfoutput>
								<input type="hidden" name="consumer_id" id="consumer_id" value="">
								<input type="hidden" name="emp_id" id="emp_id" value="">
								<input type="hidden" name="company_id" id="company_id" value="#attributes.company_id#">
								<input type="text" name="comp_name" id="comp_name" readonly value="#attributes.company#" style="width:140px;">
								<input type="hidden" name="member_code" id="member_code" value="#attributes.member_code#">
							</cfoutput>
							<span class="input-group-addon btnPointer icon-ellipsis" title="<cf_get_lang dictionary_id="57519.Cari Hesap">" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_pars&field_member_account_code=add_invent.member_code&is_cari_action=1&select_list=1,2,3&field_name=add_invent.partner_name&field_partner=add_invent.partner_id&field_comp_name=add_invent.comp_name&field_comp_id=add_invent.company_id&field_consumer=add_invent.consumer_id&field_emp_id=add_invent.emp_id&field_paymethod_id=add_invent.paymethod_id&field_paymethod=add_invent.paymethod&field_basket_due_value=add_invent.basket_due_value&field_adress_id=add_invent.ship_address_id&field_long_address=add_invent.adres&call_function=change_paper_duedate()</cfoutput>');"></span>
						</div>
					</div>
				</div>
				<div class="form-group" id="item-partner_name">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="57578.Yetkili"> *</label>
					<div class="col col-8 col-xs-12">
						<cfoutput>
							<input type="hidden" name="partner_id" id="partner_id" value="#attributes.partner_id#">
							<input type="text" name="partner_name" id="partner_name" value="#attributes.partner_name#" readonly style="width:140px;">
						</cfoutput>
					</div>
				</div>
				<div class="form-group" id="item-employee">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="30011.Satın Alan"></label>
					<div class="col col-8 col-xs-12">
						<div class="input-group">
							<input type="hidden" name="employee_id" id="employee_id" value="">
							<input type="text" name="employee"  id="employee" style="width:140px;" onchange="clear_();" onfocus="AutoComplete_Create('employee','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','\'3\',\'0\',\'0\',\'0\',\'\',\'\',\'\',\'\'','EMPLOYEE_ID','employee_id','','3','135');" value="" autocomplete="off">
							<span class="input-group-addon btnPointer icon-ellipsis" title="<cf_get_lang dictionary_id="30011.Satın Alan">" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=add_invent.employee_id&field_name=add_invent.employee&select_list=1,9');"></span>
						</div>
					</div>
				</div>
				<cfif session.ep.our_company_info.is_efatura eq 1 >
					<div class="form-group" id="item-adres">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="29462.Yükleme Yeri"></label>
						<div class="col col-8 col-xs-12">
							<div class="input-group">
								<input type="hidden" name="ship_address_id" id="ship_address_id" value="">
								<cfinput type="text" name="adres" value="" maxlength="200" style="width:140px;">
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
							<cfsavecontent variable="message3"><cf_get_lang dictionary_id='58759.Fatura Tarihi'></cfsavecontent>
							<cfinput type="text" name="invoice_date" validate="#validate_style#" required="yes" message="#message3#" value="#dateformat(invoice_date,dateformat_style)#" maxlength="10" style="width:80px;" onblur="change_money_info('add_invent','invoice_date');changeProcessDate();">
							<span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="invoice_date" call_function="change_paper_duedate&change_money_info&changeProcessDate"></span>
						</div>
					</div>
				</div>
				<div class="form-group" id="item-process_date">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57879.İşlem Tarihi'> *</label>
					<div class="col col-8 col-xs-12">
						<div class="input-group">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='57906.İşlem Tarihi Girmelisiniz !'></cfsavecontent>
							<cfinput type="text" name="process_date" style="width:100px;" required="Yes" message="#message#" value="#dateformat(process_date,dateformat_style)#" validate="#validate_style#" onChange="change_paper_duedate('process_date');"  passthrough="onBlur=""change_money_info('form_basket','process_date');""">
							<span class="input-group-addon btnPointer" title="<cf_get_lang dictionary_id='57734.seçiniz'>"><cf_wrk_date_image date_field="process_date" call_function="change_money_info&rate_control"></span>
						</div>
					</div>
				</div>
				<div class="form-group" id="item-serial_no">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="57637.Seri No"> *</label>
					<div class="col col-8 col-xs-12">
						<div class="input-group">
							<cfinput type="text" maxlength="5" name="serial_number" value="#serial_number#" onBlur="paper_control(this,'INVOICE',true);">
							<span class="input-group-addon no-bg">-</span>
							<cfinput type="text" maxlength="50" name="serial_no" value="#serial_no#"  message="#message#" onBlur="paper_control(this,'INVOICE',true);" style="width:90px;">
						</div>
					</div>
				</div>
				<div class="form-group" id="item-ship_number">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="58138.İrsaliye No"> *</label>
					<div class="col col-8 col-xs-12">
						<cfinput type="text" name="ship_number" id="ship_number" value="" maxlength="50" style="width:135px;">
					</div>
				</div>
				<div class="form-group" id="item-acc_department_id">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="57572.Departman"></label>
					<div class="col col-8 col-xs-12">
						<cfif isdefined("get_sale_det.acc_department_id") and len(get_sale_det.acc_department_id)>
							<cfset acc_info = get_sale_det.acc_department_id>
						<cfelseif isDefined("attributes.acc_department_id") and len(attributes.acc_department_id)>	
							<cfset acc_info = attributes.acc_department_id>
						<cfelse>
							<cfset acc_info = ''>
						</cfif>
						<cf_wrkdepartmentbranch fieldid='acc_department_id' is_department='1' width='135' selected_value='#acc_info#'>
					</div>
				</div>				
			</div>
			<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
				<div class="form-group" id="item-depo">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="58763.Depo"> *</label>
					<div class="col col-8 col-xs-12">
						<cf_wrkdepartmentlocation
						returninputvalue="location_id,department_name,department_id,branch_id"
						returnqueryvalue="LOCATION_ID,LOCATION_NAME,DEPARTMENT_ID,BRANCH_ID"
						fieldname="department_name"
						fieldid="location_id"
						department_fldid="department_id"
						branch_fldid="branch_id"
						user_level_control="#session.ep.OUR_COMPANY_INFO.IS_LOCATION_FOLLOW#"
						width="120">
					</div>
				</div>
				<div class="form-group" id="item-paymethod">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="58516.Ödeme Yöntemi"></label>
					<div class="col col-8 col-xs-12">
						<div class="input-group">
							<input type="hidden" name="card_paymethod_id" id="card_paymethod_id" value="">
							<input type="hidden" name="commission_rate" id="commission_rate" value="">
							<input type="hidden" name="paymethod_id" id="paymethod_id"  value="<cfif isDefined('invoice_paymethod_id')><cfoutput>#invoice_paymethod_id#</cfoutput></cfif>">
							<input type="text" name="paymethod" id="paymethod" style="width:120px;" value="<cfif isDefined('invoice_paymethod')><cfoutput>#invoice_paymethod#</cfoutput></cfif>">
							<cfset card_link="&field_card_payment_id=add_invent.card_paymethod_id&field_card_payment_name=add_invent.paymethod&field_commission_rate=add_invent.commission_rate">
							<span class="input-group-addon btnPointer icon-ellipsis" title="<cfoutput>#getLang('main',322)#</cfoutput>" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_paymethods&field_id=add_invent.paymethod_id&field_dueday=add_invent.basket_due_value&function_name=change_paper_duedate&field_name=add_invent.paymethod#card_link#</cfoutput>');"></span>
						</div>
					</div>
				</div>
				<div class="form-group" id="item-basket_due_value">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="57640.Vade"></label>
					<div class="col col-8 col-xs-12">
						<div class="input-group">
							<input type="text" name="basket_due_value" id="basket_due_value" value="<cfif isDefined('invoice_due_day')><cfoutput>#invoice_due_day#</cfoutput></cfif>" onchange="change_paper_duedate('invoice_date');" style="width:45px;">
							<span class="input-group-addon no-bg"></span>
							<input type="text" name="basket_due_value_date_" id="basket_due_value_date_" value="<cfif isDefined('invoice_due_date')><cfoutput>#dateformat(invoice_due_date,dateformat_style)#</cfoutput><cfelse><cfoutput>#dateformat(invoice_date,dateformat_style)#</cfoutput></cfif>" onChange="change_paper_duedate('invoice_date',1);" validate="#validate_style#" maxlength="10" style="width:72px;" readonly>
							<span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="basket_due_value_date_"></span>
						</div>
					</div>
				</div>
				<cfif session.ep.our_company_info.project_followup eq 1>
					<div class="form-group" id="item-project">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57416.Proje'><cfif xml_project_require eq 1> *</cfif></label>
						<div class="col col-8 col-xs-12">
							<div class="input-group">
								<cf_wrk_projects form_name='add_invent' project_id='project_id' project_name='project_head'>
								<input type="hidden" name="project_id" id="project_id" value="<cfif isdefined('attributes.pj_id')><cfoutput>#attributes.pj_id#</cfoutput></cfif>">
								<input type="text" name="project_head" id="project_head" value="<cfif isdefined('attributes.pj_id') and  len(attributes.pj_id)><cfoutput>#GET_PROJECT_NAME(attributes.pj_id)#</cfoutput></cfif>" style="width:120px;" onfocus="AutoComplete_Create('project_head','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','','3','150');" autocomplete="off">
								<span class="input-group-addon btnPointer icon-ellipsis" title="<cf_get_lang dictionary_id='57416.Proje'>" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_projects&project_id=add_invent.project_id&project_head=add_invent.project_head');"></span>
							</div>
						</div>
					</div>
				</cfif>
			</div>
			<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="4" sort="true">
				<div class="form-group" id="item-detail">
					<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
					<div class="col col-9 col-xs-12">
						<textarea name="detail" id="detail"></textarea>
					</div>
				</div>
				<div class="form-group" id="item-add_info_plus">
					<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id="57810.Ek Bilgi"></label>
					<div class="col col-9 col-xs-12"><cf_wrk_add_info info_type_id="-8" upd_page = "0"></div>
					<div id="add_info_plus"></div>
				</div>
				<cfquery name="get_credit_info" datasource="#dsn3#">
					SELECT CREDITCARD_ID,INSTALLMENT_NUMBER,DELAY_INFO FROM CREDIT_CARD_BANK_EXPENSE WHERE  ACTION_PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">
				</cfquery>
				<div class="form-group" id="item-credit">
					<label class="col col-6 col-xs-12"><input type="checkbox" name="credit" id="credit" onclick="ayarla_gizle_goster(2);" <cfif isdefined("get_expense") and get_expense.is_creditcard eq 1>checked</cfif>><cf_get_lang dictionary_id="58199.Kredi Kartı"></label>
					<cfif kasa.recordcount>
						<label class="col col-6 col-xs-12"><input type="checkbox" name="cash" id="cash" onclick="ayarla_gizle_goster(1);"><cf_get_lang dictionary_id="56937.Nakit Alış"></label>
					</cfif>
				</div>
				<div style="display:none;" id="kasa2">
					<cfif kasa.recordcount>
						<div class="form-group">
							<select name="kasa" id="kasa">
								<cfoutput query="kasa">
									<option value="#cash_id#;#cash_currency_id#">#cash_name#</option>
								</cfoutput>
							</select>
						</div>
					</cfif>
				</div>
				<div <cfif isdefined("get_expense") and get_expense.is_creditcard eq 1>style="display:'';"<cfelse>style="display:none;"</cfif> id="credit2">
					<div class="form-group">
						<div class="col col-12">
							<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='58199.Kredi Kartı'></label>
							<div class="col col-9 col-xs-12"><cf_wrk_our_credit_cards slct_width="135" credit_card_info="#get_credit_info.CREDITCARD_ID#"></div>
						</div>
					</div>
					<div class="form-group">
						<div class="col col-12">
							<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id ='56982.Taksit'></label>
							<div class="col col-9 col-xs-12"><cfinput type="text" name="inst_number" id="inst_number" value="#get_credit_info.INSTALLMENT_NUMBER#"  onkeyup="return(formatcurrency(this,event,0,'int'));" class="moneybox"></div>
						</div>
					</div>
					<div class="form-group">
						<div class="col col-12">
							<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='30133.Erteleme'></label>
							<div class="col col-9 col-xs-12">
								<div class="col col-7 col-xs-12">
									<cfinput type="text" name="delay_info" id="delay_info" value="#get_credit_info.DELAY_INFO#" onkeyup="return(formatcurrency(this,event,0,'int'));" class="moneybox">
								</div>
								<div class="col col-2 col-xs-12">
									<label><cf_get_lang dictionary_id='58724.Ay'></label>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</cf_box_elements>
		<cf_box_footer>
			<cf_workcube_buttons is_upd='0' add_function='kontrol()'>
		</cf_box_footer>
		<cf_basket id="invent_purchase_bask">
			<cf_grid_list class="detail_basket_list">
				<thead>
					<tr>
						<th>
							<input type="hidden" name="record_num" id="record_num" value="0">
							<a onclick="add_row();"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a>
						</th>
						<th nowrap="nowrap"><cf_get_lang dictionary_id='56904.Sabit Kıymet Kategorisi'></th>
						<th nowrap="nowrap"><cf_get_lang dictionary_id='58878.Demirbaş No'> *</th>
						<th nowrap="nowrap"><cf_get_lang dictionary_id='57629.Açıklama'> *</th>
						<th nowrap="nowrap"><cf_get_lang dictionary_id='57635.Miktar'></th>
						<th nowrap="nowrap"><cf_get_lang dictionary_id='57673.Tutar'> *</th>
						<th nowrap="nowrap"><cf_get_lang dictionary_id="58056.Dövizli Tutar"> *</th>
						<th nowrap="nowrap"><cf_get_lang dictionary_id='57639.KDV'> % </th>
						<th nowrap="nowrap"><cf_get_lang dictionary_id='58021.OTV'> % </th>
						<th nowrap="nowrap"><cf_get_lang dictionary_id='57639.KDV'></th>
						<th nowrap="nowrap"><cf_get_lang dictionary_id='58021.OTV'></th>
						<th nowrap="nowrap"><cf_get_lang dictionary_id='58083.Net'><cf_get_lang dictionary_id='58084.Fiyat'></th>
						<th nowrap="nowrap"><cf_get_lang dictionary_id='58083.Net'><cf_get_lang dictionary_id='56994.Döviz Fiyat'></th>
						<th nowrap="nowrap"><cf_get_lang dictionary_id='57677.Döviz'></th>
						<th nowrap="nowrap"><cf_get_lang dictionary_id='57002.Ömür'></th>
						<th nowrap="nowrap"><cf_get_lang dictionary_id="58308.IFRS"> <cf_get_lang dictionary_id='57002.Ömür'></th>
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
						<th nowrap="nowrap"><cf_get_lang dictionary_id='56990.Stok Birimi'> </th>
					</tr>
				</thead>
				<tbody name="table1" id="table1">
				
				</tbody>
			</cf_grid_list>		
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
										<input type="hidden" name="kur_say" id="kur_say" value="<cfoutput>#get_money.recordcount#</cfoutput>">
										<!--- muhasebe doneminden standart islem dovizini aliyor --->
										<cfquery name="GET_STANDART_PROCESS_MONEY" datasource="#DSN#">
											SELECT * FROM SETUP_PERIOD WHERE PERIOD_ID = #session.ep.period_id#
										</cfquery>
										<cfoutput>
										<cfif IsQuery(get_standart_process_money) and len(get_standart_process_money.standart_process_money)>
											<cfset selected_money = get_standart_process_money.standart_process_money>
										<cfelseif len(session.ep.money2)>
											<cfset selected_money = session.ep.money2>
										<cfelse>
											<cfset selected_money = session.ep.money>
										</cfif>
											<cfloop query="get_money">
												<tr>
													<div class="col col-4">
														<td>
															<input type="hidden" name="hidden_rd_money_#currentrow#" id="hidden_rd_money_#currentrow#" value="#money#">
															<input type="hidden" name="txt_rate1_#currentrow#" id="txt_rate1_#currentrow#" value="#rate1#">
															<div class="form-group">
																<input type="radio" name="rd_money" id="rd_money" value="#money#,#currentrow#,#rate1#,#rate2#" onclick="toplam_hesapla();" <cfif selected_money eq money>checked</cfif>>#money#
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
														<td valign="bottom">
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
													<input type="text" name="total_amount" id="total_amount" class="moneybox" readonly value="0">
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
													<input type="text" name="kdv_total_amount" id="kdv_total_amount" class="moneybox" value="0"  readonly>
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
													<input type="text" name="otv_total_amount" id="otv_total_amount" class="moneybox" value="0"  readonly>
												</div>
												<label class="col col-1 col-xs-12">
													<cfoutput>#session.ep.money#</cfoutput>
												</label>
											</div>
										</div>
										<div class="col col-12">
											<div class="form-group">
												<label class="col col-3 col-xs-12 txtbold">
													<a href="javascript://" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_stoppage_rates&field_stoppage_rate=add_invent.stopaj_yuzde&field_stoppage_rate_id=add_invent.stopaj_rate_id&field_decimal=#session.ep.our_company_info.purchase_price_round_num#&call_function=toplam_hesapla()</cfoutput>')"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='33258.Stopaj Oranları'>"></i></a>
													<cf_get_lang dictionary_id='57711.Stopaj'>%
														<input type="hidden" name="stopaj_rate_id" id="stopaj_rate_id" value="0">
												</label>
												<div class="col col-4 col-xs-12">
													<input type="text" name="stopaj_yuzde" id="stopaj_yuzde" class="moneybox" onblur="calc_stopaj();" onkeyup="return(FormatCurrency(this,event,0));" value="0" autocomplete="off">
												</div>
												<div class="col col-4 col-xs-12">
													<input type="text" class="moneybox" name="stopaj" id="stopaj" value="0" onblur="toplam_hesapla(1);" readonly="readonly">
												</div>
											</div>
										</div>
										<div class="col col-12">
											<div class="form-group">
												<label class="col col-3 col-xs-12 txtbold">
													<cf_get_lang dictionary_id='57678.Fatura Altı İndirim'>
												</label>
												<div class="col col-8 col-xs-12">
													<input type="text" name="net_total_discount" id="net_total_discount" class="moneybox" value="0" onblur="toplam_hesapla();" onkeyup="return(FormatCurrency(this,event));">
												</div>
												<label class="col col-1 col-xs-12">
													<cfoutput>#session.ep.money#</cfoutput>
												</label>
											</div>
										</div>
										<div class="col col-12">
											<div class="form-group">
												<label class="col col-3 col-xs-12 txtbold">
													<cf_get_lang dictionary_id='57680.Genel Toplam'>
												</label>
												<div class="col col-8 col-xs-12">
													<input type="text" name="net_total_amount" id="net_total_amount" class="moneybox" readonly="" value="0">
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
													<input type="text" name="other_total_amount" id="other_total_amount" class="moneybox" readonly value="0"></td>
												</div>
												<div class="col col-2 col-xs-12">
													<input type="text" name="tl_value1" id="tl_value1" class="moneybox" readonly value="<cfoutput>#selected_money#</cfoutput>">     
												</div>
											</div>
										</div>
										<div class="col col-12">
											<div class="form-group">
												<label class="col col-4 col-xs-12 txtbold">
													<cf_get_lang dictionary_id='56961.Döviz KDV Toplam'>
												</label>
												<div class="col col-6 col-xs-12">
													<input type="text" name="other_kdv_total_amount" id="other_kdv_total_amount" class="moneybox" readonly value="0">
												</div>
												<div class="col col-2 col-xs-12">
													<input type="text" name="tl_value2" id="tl_value2" class="moneybox" readonly="" value="<cfoutput>#selected_money#</cfoutput>">
												</div>
											</div>
										</div>
										<div class="col col-12">
											<div class="form-group">
												<label class="col col-4 col-xs-12 txtbold">
													<cf_get_lang dictionary_id='57796.Dövizli'><cf_get_lang dictionary_id='58021.OTV'><cf_get_lang dictionary_id='57492.Toplam'>
												</label>
												<div class="col col-6 col-xs-12">
													<input type="text" name="other_otv_total_amount" id="other_otv_total_amount" class="moneybox" readonly value="0" />
												</div>
												<div class="col col-2 col-xs-12">
													<input type="text" name="tl_value5" id="tl_value5" class="moneybox" readonly="" value="<cfoutput>#selected_money#</cfoutput>">
												</div>
											</div>
										</div>
										<div class="col col-12">
											<div class="form-group">
												<label class="col col-4 col-xs-12 txtbold">
													<cf_get_lang dictionary_id='57678.Fatura Altı İndirim'><cf_get_lang dictionary_id ='57677.Döviz'>
												</label>
												<div class="col col-6 col-xs-12">
													<input type="text" name="other_net_total_discount" id="other_net_total_discount" class="moneybox" readonly value="0">
												</div>
												<div class="col col-2 col-xs-12">
													<input type="text" name="tl_value4" id="tl_value4" class="box" readonly="" value="<cfoutput>#selected_money#</cfoutput>">
												</div>
											</div>
										</div>
										<div class="col col-12">
											<div class="form-group">
												<label class="col col-4 col-xs-12 txtbold">
													<cf_get_lang dictionary_id='57677.Döviz'><cf_get_lang dictionary_id ='57680.Genel Toplam'>
												</label>
												<div class="col col-6 col-xs-12" id="rate_value3">
													<input type="text" name="other_net_total_amount" id="other_net_total_amount" class="moneybox" readonly="" value="0">
												</div>
												<div class="col col-2 col-xs-12">
													<input type="text" name="tl_value3" id="tl_value3" class="box" readonly="" value="<cfoutput>#selected_money#</cfoutput>">
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
													<input type="checkbox" name="tevkifat_box" id="tevkifat_box" onclick="gizle_goster(tevkifat_oran);gizle_goster(tevkifat_plus);gizle_goster(tevk_1);gizle_goster(beyan_1);toplam_hesapla();">
													<b><cf_get_lang dictionary_id='58022.Tevkifat'></b>
												</label>
												<div class="col col-6 col-xs-12">
													<input type="hidden" id="tevkifat_id" name="tevkifat_id" value="">
													<input type="text" name="tevkifat_oran" id="tevkifat_oran" value="" readonly style="display:none;" onblur="toplam_hesapla();">
												</div>
												<div class="col col-2 col-xs-12">
													<a style="display:none;cursor:pointer" id="tevkifat_plus" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_tevkifat_rates&draggable=1&field_tevkifat_rate=add_invent.tevkifat_oran&field_tevkifat_rate_id=add_invent.tevkifat_id&call_function=toplam_hesapla()</cfoutput>')"> <img src="images/plus_thin.gif" border="0" alt="<cf_get_lang dictionary_id='58022.Tevkifat'>" align="absmiddle"></a>
												</div>
											</div>
										</div>
										<div class="col col-12">
											<div class="form-group" id="tevk_1" style="display:none">
												<label class="col col-4 col-xs-12 txtbold" >
													<b><cf_get_lang dictionary_id ='58022.Tevkifat'>:</b>
												</label>
												<div class="col col-6 col-xs-12">
													<div id="tevkifat_text"></div>
												</div>
											</div>
										</div>
										<div class="col col-12">
											<div class="form-group" id="beyan_1" style="display:none">
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
	record_exist=0;//Row_kontrol değeri 1 olan yani silinmemiş satırların varlığını kontrol ediyor
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
				str_adrlink = '&field_long_adres=add_invent.adres&field_adress_id=add_invent.ship_address_id&is_compname_readonly=1';
				openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_member_address&is_comp=1&keyword='+encodeURIComponent(add_invent.comp_name.value)+''+ str_adrlink );
				return true;
			}
			else
			{
				str_adrlink = '&field_long_adres=add_invent.adres&field_adress_id=add_invent.ship_address_id&is_compname_readonly=1';
				openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_member_address&is_comp=0&keyword='+encodeURIComponent(add_invent.partner_name.value)+''+ str_adrlink );
				return true;
			}
		}
		else
		{
			alert('Cari Hesap Seçmelisiniz');
			return false;
		}
	}
	function kontrol()
	{
		if(!chk_process_cat('add_invent')) return false;
		if(!check_display_files('add_invent')) return false;
		if(!paper_control(add_invent.serial_number,'INVOICE','true')) return false;
		if(add_invent.department_id.value=="")
		{
			alert("<cf_get_lang dictionary_id='58194.Zorunlu Alan'>:<cf_get_lang dictionary_id='58763.Depo'>");
			return false;
		}
		

		if(document.getElementById("comp_name").value == ""  && document.getElementById("consumer_id").value == "" && document.getElementById("emp_id").value == "")
		{ 
			alert ("<cf_get_lang dictionary_id='56901.Cari Hesap Seçmelisiniz'>!");
			return false;
		}

		if(document.getElementById("ship_number").value == "")
		{ 
			alert ("<cf_get_lang dictionary_id='58138.İrsaliye No'>!");
			return false;
		}
		   
		process=document.getElementById("process_cat").value;
		var get_process_cat = wrk_safe_query('acc_process_cat','dsn3',0,process);
		if(get_process_cat.IS_ACCOUNT ==1)
		{
			if (document.getElementById("comp_name").value != "" && document.getElementById("member_code").value=="")
			{ 
				alert("<cf_get_lang dictionary_id='56912.Seçtiğiniz Üyenin Muhasebe Kodu Seçilmemiş'>!");
				return false;
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
				return false;
			} 
		</cfif>
		for(r=1;r<=row_count;r++)
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
					alert("<cfoutput>#getLang('myhome',871)#</cfoutput>");
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
					alert("<cf_get_lang dictionary_id='56989.Lütfen Muhasebe Kodu Seçiniz'>!");
					return false;
				}
			}
		}
		change_paper_duedate('invoice_date');
		if(!chk_period(add_invent.process_date,"İşlem")) return false;
		if (record_exist == 0) 
		{
			alert("<cf_get_lang dictionary_id='56983.Lütfen Demirbaş Giriniz'>!");
			return false;
		}
		return(unformat_fields());
	}
	
	function amortisman_kontrol(x)
	{
		deger_amortization_rate = document.getElementById("amortization_rate"+x);
		if(filterNum(deger_amortization_rate.value) >100)
		{ 
			alert ("<cf_get_lang dictionary_id='56960.Amortisman Oranı 100 den Büyük Olamaz'> !");
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
	
	function unformat_fields()
	{
		for(r=1;r<=row_count;r++)
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
			
			deger_miktar.value = filterNum(deger_miktar.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
			deger_total.value = filterNum(deger_total.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
			deger_total2.value = filterNum(deger_total2.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
			deger_kdv_total.value = filterNum(deger_kdv_total.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
			deger_otv_total.value = filterNum(deger_otv_total.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
			deger_net_total.value = filterNum(deger_net_total.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
			deger_other_net_total.value = filterNum(deger_other_net_total.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
			deger_amortization_rate.value = filterNum(deger_amortization_rate.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
			temp_inventory_duration.value=filterNum(temp_inventory_duration.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
		}
		document.getElementById("total_amount").value = filterNum(document.getElementById("total_amount").value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
		document.getElementById("kdv_total_amount").value = filterNum(document.getElementById("kdv_total_amount").value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>); 
		document.getElementById("otv_total_amount").value = filterNum(document.getElementById("otv_total_amount").value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>); 
		document.getElementById("net_total_amount").value = filterNum(document.getElementById("net_total_amount").value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
		document.getElementById("other_total_amount").value = filterNum(document.getElementById("other_total_amount").value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
		document.getElementById("other_kdv_total_amount").value = filterNum(document.getElementById("other_kdv_total_amount").value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>); 
		document.getElementById("other_otv_total_amount").value = filterNum(document.getElementById("other_otv_total_amount").value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>); 
		document.getElementById("other_net_total_amount").value = filterNum(document.getElementById("other_net_total_amount").value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
		document.getElementById("net_total_discount").value = filterNum(document.getElementById("net_total_discount").value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
		document.getElementById("tevkifat_oran").value = filterNum(document.getElementById("tevkifat_oran").value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
		document.getElementById("stopaj_yuzde").value = filterNum(document.getElementById("stopaj_yuzde").value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
		document.getElementById("stopaj").value = filterNum(document.getElementById("stopaj").value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
		for(s=1;s<=document.getElementById("kur_say").value;s++)
		{
			document.getElementById("txt_rate2_" + s).value = filterNum(document.getElementById("txt_rate2_" + s).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
			document.getElementById("txt_rate1_" + s).value = filterNum(document.getElementById("txt_rate1_" + s).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
		}
	}
	
	row_count=0;
	function sil(sy)
	{
		var my_element=document.getElementById("row_kontrol"+sy);
		my_element.value=0;
		var my_element=document.getElementById("frm_row"+sy);
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
			deger_otv_rate = document.getElementById("otv_rate"+satir).value;//otv oranı
			deger_other_net_total = document.getElementById("row_other_total"+satir);//dovizli tutar kdv dahil
			if(deger_total.value == "") deger_total.value = 0;
			if(deger_kdv_total.value == "") deger_kdv_total.value = 0;
			if(deger_net_total.value == "") deger_net_total.value = 0;
			if(deger_otv_rate == undefined || deger_otv_rate == '') deger_otv_rate = 0;
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
			
			for(s=1;s<=add_invent.kur_say.value;s++)
			{
				if(list_getat(document.add_invent.rd_money[s-1].value,1,',') == list_getat(deger_money_id.value,1,','))
				{
                    satir_rate2 = filterNum(document.getElementById("txt_rate2_"+s).value,<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>);
                    satir_rate1 = filterNum(document.getElementById("txt_rate1_"+s).value,<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>);
				}
			}
			
			if(hesap_type == undefined)
			{
				deger_total2.value = parseFloat(deger_total.value)*(parseFloat(satir_rate1)/parseFloat(satir_rate2));
				deger_otv_total.value = (parseFloat(deger_total.value) * deger_miktar.value * deger_otv_rate)/100;
				<cfif isdefined('x_kdv_add_to_otv') and x_kdv_add_to_otv eq 0>  
					deger_kdv_total.value = ((parseFloat(deger_total.value) * parseFloat(deger_miktar.value)) * deger_tax_rate.value)/100;
				<cfelse>
					deger_kdv_total.value = ((parseFloat(deger_total.value* deger_miktar.value)+parseFloat(deger_otv_total.value)) * deger_tax_rate.value)/100;
				</cfif>
			}
			else if(hesap_type == 1)
			{
				deger_total.value = parseFloat(deger_total2.value)*(parseFloat(satir_rate2)/parseFloat(satir_rate1));
				deger_otv_total.value = (parseFloat(deger_total.value) * deger_miktar.value * deger_otv_rate)/100;
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
					deger_otv_total.value = (parseFloat(deger_total.value * deger_miktar.value * deger_otv_rate))/100;
				<cfelse>
					deger_total.value = ((parseFloat(deger_net_total.value)*100)/ (parseFloat(deger_tax_rate.value)+100))/deger_miktar.value;
					deger_otv_total.value = (parseFloat(deger_total.value * deger_miktar.value * deger_otv_rate))/100;
					deger_kdv_total.value = ((parseFloat(deger_total.value * deger_miktar.value)+parseFloat(deger_otv_total.value)) * deger_tax_rate.value)/100;
				</cfif>
					deger_total2.value = parseFloat(deger_total.value)*(parseFloat(satir_rate1)/parseFloat(satir_rate2));
			}
			else if(hesap_type == 3)
			{
				<cfif isdefined('x_kdv_add_to_otv') and x_kdv_add_to_otv eq 0>
					deger_kdv_total.value = (parseFloat(deger_net_total.value * deger_tax_rate.value))/(100 + parseFloat(deger_tax_rate.value)+ parseFloat(deger_otv_rate));
					deger_otv_total.value = (parseFloat(deger_net_total.value * deger_otv_rate))/(100 + parseFloat(deger_tax_rate.value)+ parseFloat(deger_otv_rate));
				<cfelse>
					deger_kdv_total.value = (parseFloat(deger_net_total.value * deger_tax_rate.value))/(100 + parseFloat(deger_tax_rate.value));
					deger_otv_total.value = (parseFloat((deger_net_total.value - deger_kdv_total.value) * deger_otv_rate))/(100 + parseFloat(deger_otv_rate));
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
					deger_kdv_total.value = (parseFloat(deger_net_total.value * deger_tax_rate.value))/(100 + parseFloat(deger_tax_rate.value)+ parseFloat(deger_otv_rate));
					deger_otv_total.value = (parseFloat(deger_net_total.value * deger_otv_rate))/(100 + parseFloat(deger_tax_rate.value)+ parseFloat(deger_otv_rate));
				<cfelse>
					deger_kdv_total.value = (parseFloat(deger_net_total.value * deger_tax_rate.value))/(100 + parseFloat(deger_tax_rate.value));
					deger_otv_total.value = (parseFloat((deger_net_total.value - deger_kdv_total.value) * deger_otv_rate))/(100 + parseFloat(deger_otv_rate));
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
			alert('Stopaj Oranı !');
			document.getElementById("stopaj_yuzde").value = 0;
		}
		toplam_hesapla(0);
	}

	function toplam_hesapla(type)
	{
		var toplam_dongu_1 = 0;//tutar genel toplam
		var toplam_dongu_2 = 0;// kdv genel toplam
		var toplam_dongu_3 = 0;// kdvli genel toplam
		var toplam_dongu_4 = 0;// fatura alti indirim
		var toplam_dongu_5 = 0;// ötv genel toplam
		var beyan_tutar = 0;
		var tevkifat_info = "";
		var beyan_tutar_info = "";
		var new_taxArray = new Array(0);
		var taxBeyanArray = new Array(0);
		var taxTevkifatArray = new Array(0);
		for(r=1;r<=row_count;r++)
		{
			if(document.getElementById("row_kontrol"+r).value==1)
			{
				toplam_dongu_4 = toplam_dongu_4 + (parseFloat(filterNum(document.getElementById("row_total"+r).value)) * parseFloat(filterNum(document.getElementById("quantity"+r).value)));
			}
		}			
		deger_discount_value = filterNum(document.getElementById('net_total_discount').value,8);
		genel_indirim_yuzdesi = commaSplit((parseFloat(deger_discount_value) / parseFloat(toplam_dongu_4)).toFixed(8),8);		
		genel_indirim_yuzdesi = filterNum(genel_indirim_yuzdesi,8);
		genel_indirim_yuzdesi = wrk_round(genel_indirim_yuzdesi,8);
		
		for(r=1;r<=row_count;r++)
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
				
				for(s=1;s<=document.getElementById("kur_say").value;s++)
				{
					if(list_getat(document.all.rd_money[s-1].value,1,',') == deger_money_id_ilk)
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
				toplam_dongu_2 = toplam_dongu_2 + parseFloat(deger_kdv_total.value)- parseFloat(deger_kdv_total.value)*parseFloat(genel_indirim_yuzdesi);
				toplam_dongu_5 = toplam_dongu_5 + parseFloat(deger_otv_total.value);
				deger_indirim_kdv = parseFloat(deger_kdv_total.value)- parseFloat(deger_kdv_total.value)*parseFloat(genel_indirim_yuzdesi);
				toplam_dongu_3 = (toplam_dongu_3 + ((parseFloat(deger_total.value)- (parseFloat(deger_total.value)*parseFloat(genel_indirim_yuzdesi)))) * filterNum(document.getElementById("quantity"+r).value));
				toplam_dongu_3 = toplam_dongu_3 + parseFloat(deger_kdv_total.value)- parseFloat(deger_kdv_total.value)*parseFloat(genel_indirim_yuzdesi);
				toplam_dongu_3 = toplam_dongu_3 + parseFloat(deger_otv_total.value);
				if(document.getElementById("tevkifat_oran") != undefined && document.getElementById("tevkifat_oran").value != "" && document.getElementById("tevkifat_box").checked == true)
				{//tevkifat hesaplamaları
					beyan_tutar = beyan_tutar + wrk_round(deger_indirim_kdv*filterNum(document.getElementById("tevkifat_oran").value));
					if(new_taxArray.length != 0)
						for (var m=0; m < new_taxArray.length; m++)
						{	
							var tax_flag = false;
							if(new_taxArray[m] == deger_tax_rate.value){
								tax_flag = true;
								taxBeyanArray[m] += wrk_round(deger_indirim_kdv - (deger_indirim_kdv*(filterNum(document.getElementById("tevkifat_oran").value))));
								taxTevkifatArray[m] += wrk_round(deger_indirim_kdv*(filterNum(document.getElementById("tevkifat_oran").value)));
								break;
							}
						}
					if(!tax_flag){
						new_taxArray[new_taxArray.length] = deger_tax_rate.value;
						taxBeyanArray[taxBeyanArray.length] = wrk_round(deger_indirim_kdv - (deger_indirim_kdv*(filterNum(document.getElementById("tevkifat_oran").value))));
						taxTevkifatArray[taxTevkifatArray.length] = wrk_round(deger_indirim_kdv*(filterNum(document.getElementById("tevkifat_oran").value)));
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
		document.getElementById("total_amount").value = commaSplit(toplam_dongu_1,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
		document.getElementById("kdv_total_amount").value = commaSplit(toplam_dongu_2,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
		document.getElementById("otv_total_amount").value = commaSplit(toplam_dongu_5,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
		document.getElementById("net_total_amount").value = commaSplit(toplam_dongu_3,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
		for(s=1;s<=document.getElementById("kur_say").value;s++)
		{
			form_txt_rate2_ = document.getElementById("txt_rate2_"+s);
			if(form_txt_rate2_.value == "")
				form_txt_rate2_.value = 1;
		}
		if(document.getElementById("kur_say").value == 1)
			for(s=1;s<=document.getElementById("kur_say").value;s++)
			{
				if(document.getElementById("rd_money").checked == true)
				{
					deger_diger_para = document.getElementById("rd_money");
					form_txt_rate2_ = document.getElementById("txt_rate2_"+s);
				}
			}
		else 
			for(s=1;s<=document.getElementById("kur_say").value;s++)
			{
				if(document.all.rd_money[s-1].checked == true)
				{
					deger_diger_para = document.all.rd_money[s-1];
					form_txt_rate2_ = document.getElementById("txt_rate2_"+s);
				}
			}
		deger_money_id_1 = list_getat(deger_diger_para.value,1,',');
		deger_money_id_3 = list_getat(deger_diger_para.value,3,',');
		form_txt_rate2_.value = filterNum(form_txt_rate2_.value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
		document.getElementById("other_total_amount").value = commaSplit(toplam_dongu_1 * parseFloat(deger_money_id_3) / (parseFloat(form_txt_rate2_.value)),<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
		document.getElementById("other_kdv_total_amount").value = commaSplit(toplam_dongu_2 * parseFloat(deger_money_id_3) / (parseFloat(form_txt_rate2_.value)),<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
		document.getElementById("other_otv_total_amount").value = commaSplit(toplam_dongu_5 * parseFloat(deger_money_id_3) / (parseFloat(form_txt_rate2_.value)),<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
		document.getElementById("other_net_total_amount").value = commaSplit(toplam_dongu_3 * parseFloat(deger_money_id_3) / (parseFloat(form_txt_rate2_.value)),<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
		document.getElementById("other_net_total_discount").value = commaSplit(deger_discount_value* parseFloat(deger_money_id_3) / (parseFloat(form_txt_rate2_.value)),<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
		document.getElementById("net_total_discount").value = commaSplit(deger_discount_value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
		
		document.getElementById("tl_value1").value = deger_money_id_1;
		document.getElementById("tl_value2").value = deger_money_id_1;	//kdv
		document.getElementById("tl_value5").value = deger_money_id_1;	//otv
		document.getElementById("tl_value3").value = deger_money_id_1;
		document.getElementById("tl_value4").value = deger_money_id_1;
		
		form_txt_rate2_.value = commaSplit(form_txt_rate2_.value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
	}
	function control_invent_no(value){
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
		x = '<input type="hidden" value="WRK'+row_count+ js_create_unique_id() + row_count+'" name="wrk_row_id' + row_count +'" id="wrk_row_id' + row_count +'"><input  type="hidden" value="" id="wrk_row_relation_id' + row_count +'" name="wrk_row_relation_id' + row_count +'">';
		newCell.innerHTML = x + '<input  type="hidden" value="1" id="row_kontrol' + row_count +'" name="row_kontrol' + row_count +'"><ul class="ui-icon-list"><li><a style="cursor:pointer" onclick="copy_row('+row_count+');" title="<cf_get_lang dictionary_id='58972.Satır Kopyala'>"><i class="fa fa-copy" title="<cf_get_lang dictionary_id='58972.Satır Kopyala'>" alt="<cf_get_lang dictionary_id='58972.Satır Kopyala'>"></i></a></li><li><a href="javascript://" onclick="sil(' + row_count + ');"><i class="fa fa-minus" title="<cf_get_lang dictionary_id='58971.Satır Sil'>" alt="<cf_get_lang dictionary_id='58971.Satır Sil'>"></i></a></li></ul>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<input  type="hidden" id="inventory_cat_id' + row_count +'" name="inventory_cat_id' + row_count +'" value="' + inventory_cat_id +'"><input type="text" style="width:132px;" id="inventory_cat' + row_count +'" name="inventory_cat' + row_count +'" value="' + inventory_cat +'" class="boxtext"><a href="javascript://" onClick="open_inventory_cat_list('+ row_count +');"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" onblur="control_invent_no(' + row_count +')" id="invent_no' + row_count +'" name="invent_no' + row_count +'" value="' + invent_no +'" class="boxtext" maxlength="50">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" id="invent_name' + row_count +'" name="invent_name' + row_count +'" value="' + invent_name +'" style="width:100px;" class="boxtext" maxlength="100">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" id="quantity' + row_count +'" name="quantity' + row_count +'" value="' + quantity +'" class="moneybox" onBlur="hesapla(' + row_count +');" onkeyup="return(FormatCurrency(this,event));">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" id="row_total' + row_count +'" name="row_total' + row_count +'" value="' + row_total +'" onkeyup="return(FormatCurrency(this,event,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>));" onBlur="hesapla(' + row_count +');" class="moneybox">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" id="row_total_other' + row_count +'" name="row_total_other' + row_count +'" value="' + row_total_other +'" onkeyup="return(FormatCurrency(this,event,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>));" onBlur="hesapla(' + row_count +',1);" class="moneybox">';
		//kdv orani
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		a = '<select id="tax_rate'+ row_count +'" name="tax_rate'+ row_count +'" onChange="hesapla('+ row_count +');" class="moneybox">';
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
		x = '<select id="otv_rate'+ row_count +'" name="otv_rate'+ row_count +'" onChange="hesapla('+ row_count +');" class="moneybox">';
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
		newCell.innerHTML = '<input type="text" id="kdv_total' + row_count +'" name="kdv_total' + row_count +'" value="' + kdv_total +'" onkeyup="return(FormatCurrency(this,event,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>));" style="width:60px;" onBlur="hesapla(' + row_count +',1);" class="moneybox">';
		//otv total
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" id="otv_total' + row_count +'" name="otv_total' + row_count +'" value="' + otv_total +'" onkeyup="return(FormatCurrency(this,event,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>));" style="width:60px;" onBlur="hesapla(' + row_count +',1);" class="moneybox">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" id="net_total' + row_count +'" name="net_total' + row_count +'" value="' + net_total +'" class="moneybox" onkeyup="return(FormatCurrency(this,event,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>));" onblur="hesapla(' + row_count +',3);">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" id="row_other_total' + row_count +'" name="row_other_total' + row_count +'" value="' + row_other_total +'" onkeyup="return(FormatCurrency(this,event,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>));" class="moneybox" onblur="hesapla(' + row_count +',4);">';
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
		newCell.innerHTML = '<input type="text" id="inventory_duration' + row_count +'" name="inventory_duration' + row_count +'" value="' + inventory_duration +'" class="moneybox" onkeyup="return(FormatCurrency(this,event));">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" id="inventory_duration_ifrs' + row_count +'" name="inventory_duration_ifrs' + row_count +'" value="' + inventory_duration_ifrs +'" class="moneybox" onkeyup="return(FormatCurrency(this,event));">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" id="amortization_rate' + row_count +'" name="amortization_rate' + row_count +'" value="' + amortization_rate +'" class="moneybox" onblur="return(amortisman_kontrol(' + row_count +'));" onkeyup="return(FormatCurrency(this,event));">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<select id="amortization_method'+ row_count +'" name="amortization_method'+ row_count +'" style="margin-left:-7px;"><option value="0" ><cf_get_lang dictionary_id="29421.Azalan Bakiye Üzerinden"></option><option value="1" ><cf_get_lang dictionary_id="29422.Normal Amortisman"></option></select>';
		if(amortization_method != '')
			document.getElementById('amortization_method'+ row_count).value = amortization_method;
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<select id="amortization_type'+ row_count +'" name="amortization_type'+ row_count +'" style="margin-left:-7px"><option value="1">Kıst Amortismana Tabi</option><option value="2" selected>Kıst Amortismana Tabi Değil</option>></select>';
		if(amortization_type != '')
			document.getElementById('amortization_type'+ row_count).value = amortization_type;
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<input type="hidden" id="account_id' + row_count +'" name="account_id' + row_count +'" value="' + account_id +'"><input type="text" style="width:110px;" id="account_code' + row_count +'" name="account_code' + row_count +'" value="' + account_code +'" class="boxtext" onFocus="autocomp_account('+row_count+');"><a href="javascript://"><a href="javascript://" onClick="pencere_ac_acc('+ row_count +');"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML ='<input type="hidden" name="expense_center_id' + row_count +'" value="'+expense_center_id+'" id="expense_center_id' + row_count +'"><input type="text" id="expense_center_name' + row_count +'" name="expense_center_name' + row_count +'" onFocus="exp_center('+row_count+');" value="'+expense_center_name+'" style="width:150px;" class="boxtext"><a href="javascript://" onClick="pencere_ac_exp_center('+ row_count +');"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<input type="hidden" id="expense_item_id' + row_count +'" name="expense_item_id' + row_count +'" value="' + expense_item_id +'"><input type="text" style="width:120px;" id="expense_item_name' + row_count +'" name="expense_item_name' + row_count +'" value="' + expense_item_name +'" class="boxtext" onFocus="exp_item('+row_count+');"><a href="javascript://"><img src="/images/plus_thin.gif" onclick="pencere_ac_exp('+ row_count +');" align="absmiddle" border="0"></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" id="period' + row_count +'" name="period' + row_count +'" value="' + period +'" class="moneybox" onblur="return(period_kontrol(' + row_count +'));" onkeyup="return(FormatCurrency(this,event,0));">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<input type="hidden" id="debt_account_id' + row_count +'" name="debt_account_id' + row_count +'" value="' + debt_account_id +'"><input type="text" id="debt_account_code' + row_count +'" name="debt_account_code' + row_count +'" value="' + debt_account_code +'" style="width:185px;" class="boxtext" onFocus="autocomp_debt_account('+row_count+');"> <a href="javascript://" onClick="pencere_ac_acc2('+ row_count +');"><img src="/images/plus_thin.gif"  align="absmiddle" border="0"></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<input type="hidden" id="claim_account_id' + row_count +'" name="claim_account_id' + row_count +'" value="' + claim_account_id +'"><input type="text" id="claim_account_code' + row_count +'" name="claim_account_code' + row_count +'" value="' + claim_account_code +'" style="width:201px;" class="boxtext" onFocus="autocomp_claim_account('+row_count+');"><a href="javascript://" onClick="pencere_ac_acc1('+ row_count +');"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<input  type="hidden" id="product_id' + row_count +'" name="product_id' + row_count +'" value="' + product_id +'"><input  type="hidden" id="stock_id' + row_count +'" name="stock_id' + row_count +'" value="' + stock_id +'"><input type="text" id="product_name' + row_count +'" name="product_name' + row_count +'" value="' + product_name +'" style="width:90px;" class="boxtext" maxlength="75" onFocus="AutoComplete_Create(\'product_name' + row_count +'\',\'PRODUCT_NAME\',\'PRODUCT_NAME,STOCK_CODE\',\'get_product_autocomplete\',\'0\',\'PRODUCT_ID,STOCK_ID,MAIN_UNIT,PRODUCT_UNIT_ID\',\'product_id' + row_count +',stock_id' + row_count +',stock_unit' + row_count  +',stock_unit_id' + row_count  +'\',\'add_invent\',1,\'\',\'\');"><a href="javascript://" onClick=""><a href="javascript://" onClick=" openBoxDraggable('+"'<cfoutput>#request.self#?fuseaction=objects.popup_product_names</cfoutput>&product_id=product_id" + row_count + "&field_id=stock_id" + row_count + "&field_unit_name=stock_unit" + row_count + "&field_main_unit=stock_unit_id" + row_count + "&field_name=product_name" + row_count + "','list');"+'"><img src="/images/plus_thin.gif" border="0" align="absbottom"></a>';
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
		openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_expense_center&is_invoice=1&field_id=add_invent.expense_center_id' + no +'&field_name=add_invent.expense_center_name' + no);
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
		openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_id=account_id' + no +'&field_name=account_code' + no +'');
	}
	function pencere_ac_acc1(no)
	{
		openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_id=claim_account_id' + no +'&field_name=claim_account_code' + no +'');
	}
	function clear_()
	{
		if(document.getElementById('employee').value=='')
		{
			document.getElementById('employee_id').value='';
		}
	}
	function pencere_ac_acc2(no)
	{
		openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&is_form_submitted=1&field_id=debt_account_id' + no +'&field_name=debt_account_code' + no +'');
	}
	
	function pencere_ac_exp(no)
	{
		openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_exp_item&is_budget_items=1&field_id=expense_item_id' + no +'&field_name=expense_item_name' + no +'&field_account_no=debt_account_id' + no +'&field_account_no2=debt_account_code' + no +'');
	}
	function open_inventory_cat_list(no)
	{
		openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_inventory_cat&draggable=1&field_id=inventory_cat_id' + no +'&field_name=inventory_cat' + no +'&field_amortization_rate=amortization_rate' + no +'&field_inventory_duration=inventory_duration' + no +'');
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
		paper_date_=eval('document.all.invoice_date.value');
		if(type!=undefined && type==1)
			document.getElementById("basket_due_value").value = datediff(paper_date_,document.getElementById("basket_due_value_date_").value,0);
		else
		{
			if(isNumber(document.getElementById("basket_due_value"))!= false && (document.getElementById("basket_due_value").value != 0))
				document.getElementById("basket_due_value_date_").value = date_add('d',+document.getElementById("basket_due_value").value,paper_date_);
			else
			{
				document.getElementById("basket_due_value_date_").value =paper_date_;
				if(document.getElementById("basket_due_value").value == '')
					document.getElementById("basket_due_value").value = datediff(paper_date_,document.getElementById("basket_due_value_date_").value,0);
			}
		}
	}
</script>
