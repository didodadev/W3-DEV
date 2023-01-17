<cf_get_lang_set module_name="invoice"> 
<cf_xml_page_edit fuseact="invoice.form_add_bill_purchase">
<cfif isdefined("attributes.iid") and len(attributes.iid)>
    <cfinclude template="../query/get_purchase_det.cfm">
    <cfif not get_sale_det.recordcount>
        <br/><font class="txtbold"><cf_get_lang dictionary_id='57999.Çalıştığınız Muhasebe Dönemine Ait Böyle Bir Fatura Bulunamadı'> !</font>
        <cfexit method="exittemplate">
    </cfif>
    <cfinclude template="../query/get_moneys.cfm">
    <cfparam name="attributes.company_id" default="#get_sale_det.company_id#">
    <cfparam name="attributes.process_cat" default="#get_sale_det.process_cat#">
	<cfparam name="attributes.consumer_id" default="#get_sale_det.consumer_id#">
	<cfparam name="attributes.partner_id" default="#get_sale_det.partner_id#">
	<cfparam name="attributes.consumer_reference_code" default="#get_sale_det.consumer_reference_code#">
	<cfparam name="attributes.partner_reference_code" default="#get_sale_det.partner_reference_code#">
	<cfparam name="attributes.employee_id" default="#get_sale_det.employee_id#">
	<cfparam name="attributes.ref_no" default="#get_sale_det.ref_no#">
	<cfparam name="attributes.note" default="#get_sale_det.note#">
	<cfparam name="attributes.ACC_TYPE_ID" default="#get_sale_det.ACC_TYPE_ID#">
	<cfparam name="attributes.deliver_comp_id" default="#get_sale_det.deliver_comp_id#">
	<cfparam name="attributes.deliver_cons_id" default="#get_sale_det.deliver_cons_id#">
	<cfparam name="attributes.deliver_emp" default="#get_sale_det.deliver_emp#">
	<cfparam name="attributes.ship_address_id" default="#get_sale_det.ship_address_id#">
	<cfparam name="attributes.empo_id" default="#get_sale_det.sale_emp#">
	<cfparam name="attributes.project_id" default="#get_sale_det.project_id#">
	<cfparam name="attributes.SHIP_ADDRESS" default="#get_sale_det.SHIP_ADDRESS#">
	<cfparam name="attributes.DEPARTMENT_ID" default="#get_sale_det.DEPARTMENT_ID#">
	<cfparam name="attributes.DEPARTMENT_LOCATION" default="#get_sale_det.DEPARTMENT_LOCATION#">
	<cfparam name="attributes.PAYMETHOD_ID" default="#get_sale_det.pay_method#">
	<cfparam name="basket_due_value_date_" default="#get_sale_det.due_date#">
	<cfparam name="attributes.ACC_DEPARTMENT_ID" default="#get_sale_det.ACC_DEPARTMENT_ID#">
	<cfparam name="attributes.ASSETP_ID" default="#get_sale_det.ASSETP_ID#">
	<cfparam name="attributes.is_cash" default="#get_sale_det.is_cash#">
	<cfparam name="attributes.kasa_id" default="#get_sale_det.kasa_id#">
	<cfparam name="attributes.card_paymethod_id" default="#get_sale_det.card_paymethod_id#">
 	<cfparam name="attributes.city_id" default="#get_sale_det.city_id#">
	 <cfparam name="attributes.county_id" default="#get_sale_det.county_id#">

    <cfscript>session_basket_kur_ekle(process_type:0);</cfscript>
    <cfparam name="attributes.invoice_number" default="">
</cfif>
<cfif isdefined("attributes.ship_id") and len(attributes.ship_id)>
	<cfscript>
		SQLStr = "SELECT (SELECT TOP 1 DATEDIFF(DAY,O.ORDER_DATE,O.DUE_DATE) FROM #dsn3_alias#.ORDERS O,#dsn3_alias#.ORDERS_SHIP OS WHERE O.ORDER_ID = OS.ORDER_ID AND OS.PERIOD_ID = #session.ep.period_id# AND OS.SHIP_ID = SHIP.SHIP_ID) DUE_DAY,* FROM SHIP WHERE  SHIP_ID = #attributes.ship_id#";
		get_ship_info = cfquery(SQLString : SQLStr, Datasource : dsn2);
		SQLStr2 = "SELECT PAYMETHOD, CARD_PAYMETHOD_ID, DUE_DATE FROM #dsn3_alias#.ORDERS O,#dsn3_alias#.ORDERS_SHIP OS WHERE O.ORDER_ID = OS.ORDER_ID AND OS.PERIOD_ID = #session.ep.period_id# AND OS.SHIP_ID = #attributes.ship_id#";		
		get_paymethod_id = cfquery(SQLString : SQLStr2, Datasource : dsn2);
		attributes.company_id = get_ship_info.company_id;
		attributes.partner_id = get_ship_info.partner_id;
		attributes.employee_id = get_ship_info.employee_id;
		attributes.consumer_id = get_ship_info.consumer_id;
		attributes.ship_method = get_ship_info.ship_method;
		attributes.project_id = get_ship_info.project_id;
		basket_due_value_date_ = len(get_paymethod_id.due_date) ? get_paymethod_id.due_date : get_ship_info.due_date;
		due_value_ = get_ship_info.due_day;
		attributes.city_id = get_ship_info.city_id;
		attributes.ship_number = get_ship_info.ship_number;
		attributes.ship_date = get_ship_info.ship_date;
		attributes.deliver_emp = get_ship_info.deliver_emp;
		attributes.sale_emp = get_ship_info.sale_emp;
		attributes.deliver_store_id = get_ship_info.deliver_store_id;
		attributes.location = get_ship_info.location;
		attributes.paymethod_id =  len(get_paymethod_id.paymethod) ? get_paymethod_id.paymethod : get_ship_info.PAYMETHOD_ID;
		attributes.card_paymethod_id =  len(get_paymethod_id.card_paymethod_id) ? get_paymethod_id.card_paymethod_id : get_ship_info.CARD_PAYMETHOD_ID;
		attributes.address =  get_ship_info.address;
		attributes.service_id = get_ship_info.service_id;
		attributes.ship_detail =  get_ship_info.ship_detail;
		attributes.ref_no = get_ship_info.ref_no;
		attributes.deliver_emp_id = get_ship_info.deliver_emp_id;
		attributes.deliver_par_id = get_ship_info.deliver_par_id;
		attributes.department_in= get_ship_info.department_in;
		attributes.location_in = get_ship_info.location_in;
	</cfscript>
	<cfif len(attributes.company_id)>
		<cfset attributes.member_account_code = GET_COMPANY_PERIOD(attributes.company_id)>
	<cfelseif  len(attributes.consumer_id)>
		<cfset attributes.member_account_code = GET_CONSUMER_PERIOD(attributes.consumer_id)>
	<cfelse>
		<cfset attributes.member_account_code = get_employee_period(attributes.employee_id)>
	</cfif>
</cfif>
<cfif isdefined("attributes.company_id")>
	<cfset attributes.comp_id = attributes.company_id>
</cfif>
<cfscript>
	if(isDefined("url.ship_id"))//irsaliyeden gelen
		session_basket_kur_ekle(action_id=attributes.ship_id,table_type_id:2,to_table_type_id:1,process_type:1);
	else
		session_basket_kur_ekle(process_type:0);
</cfscript>
<cfset kontrol_status = 1>
<cfinclude template="../query/get_session_cash_all.cfm">
<cfinclude template="../query/control_bill_no.cfm">
<cfparam name="attributes.partner_name" default="">
<cfparam name="attributes.consumer_id" default="">
<cfparam name="attributes.partner_id" default="">
<cfparam name="attributes.consumer_reference_code" default="">
<cfparam name="attributes.partner_reference_code" default="">
<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.employee_id" default="">
<cfparam name="attributes.company" default="">
<cfparam name="attributes.member_account_code" default="">
<cfparam name="attributes.ref_no" default="">
<cfparam name="attributes.note" default="">
<cfif isdefined("attributes.order_id") and len(attributes.order_id)>
	<cfscript>
		SQLStr = "SELECT DATEDIFF(DAY,ORDER_DATE,DUE_DATE) as DUE_DAY,* FROM ORDERS WHERE ORDER_ID = #attributes.order_id#";
		get_order_info = cfquery(SQLString : SQLStr, Datasource : dsn3);
		attributes.company_id = get_order_info.company_id;
		attributes.partner_id = get_order_info.partner_id;
		attributes.employee_id = get_order_info.employee_id;
		attributes.consumer_id = get_order_info.consumer_id;
		attributes.partner_reference_code = get_order_info.partner_reference_code;
		attributes.consumer_reference_code = get_order_info.consumer_reference_code;
		attributes.subscription_id = get_order_info.subscription_id;
		attributes.order_number = get_order_info.order_number;
		attributes.empo_id = get_order_info.order_employee_id ;
		if(len(get_order_info.sales_partner_id)){
			attributes.sales_member_id = get_order_info.sales_partner_id;
			attributes.sales_member_type = 'partner';
			attributes.sales_member = get_par_info(get_order_info.sales_partner_id,0,-1,0);
		}
		else if(len(get_order_info.sales_consumer_id)){
			attributes.sales_member_id = get_order_info.sales_consumer_id;
			attributes.sales_member_type = 'consumer';
			attributes.sales_member = get_cons_info(get_order_info.sales_consumer_id,0,0);
		}
		attributes.department_id = get_order_info.deliver_dept_id;
		attributes.location_id = get_order_info.location_id;
		attributes.ship_method = get_order_info.ship_method;
		attributes.note = get_order_info.order_detail;
		attributes.project_id = get_order_info.project_id;
		attributes.ref_no = get_order_info.order_number;
		attributes.paymethod_id = get_order_info.paymethod;
		attributes.card_paymethod_id = get_order_info.card_paymethod_id;
		basket_due_value_date_ = get_order_info.due_date;
		attributes.city_id = get_order_info.city_id;
		attributes.county_id = get_order_info.county_id;
		attributes.adres = get_order_info.ship_address;
		invoice_due_day = get_order_info.due_day;
	</cfscript>
</cfif>

<!--- üye bilgileri sayfasından gelince kullanılıyor --->
<cfif isdefined('attributes.company_id') and len(attributes.company_id)>
	<cfif isdefined("attributes.order_id_listesi") and len(attributes.order_id_listesi)>
		<cfset attributes.order_id_listesi=attributes.order_id_listesi>
		<cfset attributes.order_number=attributes.order_id_form>
	</cfif>
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
	<cfset attributes.member_account_code = GET_COMPANY_PERIOD(attributes.company_id)>
	<cfset get_paymethodCFC = createObject('component','workdata.get_member_paymethod')>
	<cfset get_paymethod = get_paymethodCFC.GET_PAYMETHOD_FNC(member_id:attributes.company_id)>
	<cfif get_paymethod.recordcount and len(get_paymethod.paymethod_id)>
		<cfset invoice_paymethod_id = get_paymethod.paymethod_id>
		<cfset invoice_paymethod = get_paymethod.paymethod>
		<cfset invoice_due_day = get_paymethod.due_day>
		<cfset invoice_due_date = dateadd('d',get_paymethod.due_day,now())>
	</cfif>
<cfelseif isdefined('attributes.consumer_id') and len(attributes.consumer_id)>
	<cfset attributes.consumer_id = attributes.consumer_id>
	<cfset attributes.partner_name = get_cons_info(attributes.consumer_id,0,0)>
	<cfset attributes.member_account_code = GET_CONSUMER_PERIOD(attributes.consumer_id)>
	<cfset get_paymethodCFC = createObject('component','workdata.get_member_paymethod')>
	<cfset get_paymethod = get_paymethodCFC.GET_PAYMETHOD_FNC(member_id:attributes.consumer_id,member_type:0)>
	<cfif get_paymethod.recordcount and len(get_paymethod.paymethod_id)>
		<cfset invoice_paymethod_id = get_paymethod.paymethod_id>
		<cfset invoice_paymethod = get_paymethod.paymethod>
		<cfset invoice_due_day = get_paymethod.due_day>
		<cfset invoice_due_date = dateadd('d',get_paymethod.due_day,now())>
	</cfif>
<cfelseif isdefined('attributes.employee_id') and len(attributes.employee_id)>
	<cfquery name="get_emp_info_" datasource="#dsn#">
		SELECT EMPLOYEE_NAME+' '+EMPLOYEE_SURNAME FULLNAME FROM EMPLOYEES WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">
	</cfquery>
	<cfset attributes.employee_id = attributes.employee_id>
	<cfset attributes.partner_name = get_emp_info_.FULLNAME>
	<cfset attributes.member_account_code = GET_EMPLOYEE_PERIOD(attributes.employee_id)>
<cfelseif isdefined("attributes.project_id") and len(attributes.project_id)>
	<cfquery name="get_project_info" datasource="#dsn#">
		SELECT COMPANY_ID,PARTNER_ID,CONSUMER_ID FROM PRO_PROJECTS WHERE PROJECT_ID =#attributes.project_id#
	</cfquery>
	<cfif len(get_project_info.partner_id)>
		<cfset attributes.company_id = get_project_info.company_id>
		<cfset attributes.partner_id = get_project_info.partner_id>
		<cfset attributes.partner_name = get_par_info(get_project_info.partner_id,0,-1,0)>
		<cfset attributes.company =get_par_info(get_project_info.company_id,1,0,0)>
        <cfset attributes.member_account_code = GET_COMPANY_PERIOD(get_project_info.company_id)>
	<cfelseif len(get_project_info.consumer_id)>
		<cfset attributes.consumer_id = get_project_info.consumer_id>
		<cfset attributes.partner_name = get_cons_info(get_project_info.consumer_id,0,0)>
		<cfset attributes.company =get_cons_info(get_project_info.consumer_id,2,0)>
        <cfset attributes.member_account_code = GET_CONSUMER_PERIOD(get_project_info.consumer_id)>
	</cfif>
</cfif>
<cfset invoice_date = now()>
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
		<cfset process_date_ = get_inv_det.issue_date>
        <cfif xml_separate_serial_number>
			<cfset serial_no = right(get_inv_det.einvoice_id,13)>
            <cfset serial_number = left(get_inv_det.einvoice_id,3)>
        <cfelse>
        	<cfset serial_no = get_inv_det.einvoice_id>
        </cfif>
		<script type="text/javascript">
			try{
				window.onload = function () { change_money_info('form_basket','invoice_date');}
			}
			catch(e){}
		</script>
	</cfif>
</cfif>
<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box>
		<div id="basket_main_div">
			<cfform name="form_basket" id="form_basket" method="post" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_add_bill_purchase">
				<cf_basket_form id="add_bill_purchase">
					<cfif isdefined("attributes.iid") and len(attributes.iid)>
						<cfoutput>
							<input type="hidden" name="form_action_address" id="form_action_address" value="#listgetat(attributes.fuseaction,1,'.')#.emptypopup_add_bill_purchase">
							<input type="hidden" name="active_period" id="active_period" value="#session.ep.period_id#">
							<input type="hidden" name="search_process_date" id="search_process_date" value="invoice_date">
							<cfif len(attributes.company_id)>
							<cfset member_account_code = get_company_period(attributes.company_id)>
							<cfelseif len(attributes.consumer_id)>
							<cfset member_account_code = get_consumer_period(attributes.consumer_id)>
							<cfelse>
								<cfset member_account_code = get_employee_period(attributes.employee_id)>
							</cfif>
							<input type="hidden" name="member_account_code" id="member_account_code" value="#member_account_code#">
						</cfoutput>
					<cfelse>            
						<input type="hidden" name="form_action_address" id="form_action_address" value="<cfoutput>#listgetat(attributes.fuseaction,1,'.')#.emptypopup_add_bill_purchase</cfoutput>">
						<cf_papers paper_type="invoice" form_name="form_basket" form_field="invoice_number">
						<input type="hidden" name="active_period" id="active_period" value="<cfoutput>#session.ep.period_id#</cfoutput>">
						<input type="hidden" name="search_process_date" id="search_process_date" value="invoice_date">
						<input type="hidden" name="member_account_code" id="member_account_code" value="<cfoutput>#attributes.member_account_code#</cfoutput>">
						<cfif isdefined("attributes.invoice_id")>
							<input type="hidden" name="bool_from_control_bill" id="bool_from_control_bill" value="<cfoutput>#attributes.invoice_id#</cfoutput>">
						</cfif>
						<cfif isdefined("attributes.receiving_detail_id")>
							<input type="hidden" name="receiving_detail_id" id="receiving_detail_id" value="<cfoutput>#attributes.receiving_detail_id#</cfoutput>">
						</cfif>
						<input type="hidden" name="invoice_control_id" id="invoice_control_id" value="">
						<input type="hidden" name="contract_row_ids" id="contract_row_ids" value="">
					</cfif>
					<cfif isdefined("attributes.order_id") and len(attributes.order_id)>
						<input type="hidden" name="order_id" id="order_id" value="<cfoutput>#attributes.order_id#</cfoutput>">
					</cfif>
					<input type="hidden" name="xml_get_branch_from_department" value="<cfoutput>#xml_get_branch_from_department#</cfoutput>">
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
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57800.işlem tipi'> *</label>
								<div class="col col-8 col-xs-12">
									<cfif isdefined("attributes.iid") and len(attributes.iid)>
										<cf_workcube_process_cat slct_width="140" onclick_function="kontrol_yurtdisi();check_process_is_sale();" process_cat="#attributes.process_cat#">
									<cfelse>
										<cf_workcube_process_cat onclick_function="kontrol_yurtdisi();check_process_is_sale();" slct_width='140'>
									</cfif>
								</div>
							</div>
							<div class="form-group" id="item-comp_name">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57519.cari hesap'> *</label>
								<div class="col col-8 col-xs-12">
									<div class="input-group">
										<cfif isdefined("attributes.iid") and len(attributes.iid)>
											<cfoutput>
													<input type="hidden" name="company_id" id="company_id" value="#get_sale_det.company_id#">
												<cfif len(get_sale_det.company_id) and get_sale_det.company_id neq 0>
													<input type="text" name="comp_name" id="comp_name" value="#GET_SALE_DET_COMP.fullname#" readonly style="width:140px;">
												<cfelseif len(get_sale_det.consumer_id) and get_sale_det.consumer_id neq 0>
													<input type="text" name="comp_name" id="comp_name" value="#get_cons_name.company#" readonly style="width:140px;">
												<cfelse>
													<input type="text" name="comp_name" id="comp_name" value="" readonly style="width:140px;">
												</cfif>
											</cfoutput>
											<cfset str_linkeait="&field_revmethod_id=form_basket.paymethod_id&field_revmethod=form_basket.paymethod&field_basket_due_value_rev=form_basket.basket_due_value&field_card_payment_id=form_basket.card_paymethod_id&call_function=add_general_prom()-check_member_price_cat()-change_paper_duedate()">
											<span class="input-group-addon btnPointer icon-ellipsis" title="<cf_get_lang dictionary_id='57734.seçiniz'>" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_pars&field_adress_id=form_basket.ship_address_id&is_cari_action=1&select_list=2,3,1,9&field_name=form_basket.partner_name&field_partner=form_basket.partner_id&field_emp_id=form_basket.employee_id&field_comp_name=form_basket.comp_name&field_comp_id=form_basket.company_id&field_consumer=form_basket.consumer_id&field_member_account_code=form_basket.member_account_code#str_linkeait#&come=invoice&ship_method_id=form_basket.ship_method&ship_method_name=form_basket.ship_method_name&field_long_address=form_basket.adres&field_city_id=form_basket.city_id&field_county_id=form_basket.county_id&field_cons_ref_code=form_basket.consumer_reference_code<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif></cfoutput>');"></span>
										<cfelse>
											<input type="hidden" name="company_id" id="company_id" value="<cfoutput>#attributes.company_id#</cfoutput>">
											<input  name="comp_name" id="comp_name" type="text" readonly value="<cfoutput>#attributes.company#</cfoutput>" style="width:140px;">
											<cfset str_linkeait="&field_paymethod_id=form_basket.paymethod_id&field_paymethod=form_basket.paymethod&field_basket_due_value=form_basket.basket_due_value&field_card_payment_id=form_basket.card_paymethod_id&field_comp_id2=form_basket.deliver_comp_id&field_consumer2=form_basket.deliver_cons_id">
											<cfif xml_show_ship_address eq 1><cfset str_linkeait= str_linkeait&"&field_long_address=form_basket.ship_address&field_city_id=form_basket.ship_address_city_id&field_county_id=form_basket.ship_address_county_id&field_adress_id=form_basket.ship_address_id"></cfif>
											<span class="input-group-addon btnPointer icon-ellipsis" title="<cf_get_lang dictionary_id='57734.seçiniz'>" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_pars&is_cari_action=1&select_list=2,3,1,9&field_name=form_basket.partner_name&field_emp_id=form_basket.employee_id&field_partner=form_basket.partner_id&field_comp_name=form_basket.comp_name&field_comp_id=form_basket.company_id&field_consumer=form_basket.consumer_id&field_member_account_code=form_basket.member_account_code#str_linkeait#&ship_method_id=form_basket.ship_method&ship_method_name=form_basket.ship_method_name&is_potansiyel=0&field_cons_ref_code=form_basket.consumer_reference_code<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif></cfoutput>&call_function=add_general_prom()-check_member_price_cat()-change_paper_duedate()');"></span>
										</cfif>
									</div>
								</div>
							</div>
							<div class="form-group" id="item-partner_name">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57578.Yetkili'> *</label>
								<div class="col col-8 col-xs-12">
									<cfif isdefined("attributes.iid") and len(attributes.iid)>
										<cfoutput>
											<cfset emp_id = attributes.employee_id>
											<cfif len(attributes.ACC_TYPE_ID)>
												<cfset emp_id = "#emp_id#_#attributes.ACC_TYPE_ID#">
											</cfif>
										</cfoutput>
									</cfif>
									<cfoutput>
										<input type="hidden" name="partner_reference_code" id="partner_reference_code" value="<cfif isdefined("attributes.iid") and len(attributes.iid)>#attributes.partner_reference_code#<cfelse>#attributes.partner_reference_code#</cfif>">
										<input type="hidden" name="consumer_reference_code" id="consumer_reference_code" value="<cfif isdefined("attributes.iid") and len(attributes.iid)>#attributes.consumer_reference_code#<cfelse>#attributes.consumer_reference_code#</cfif>">
										<input type="hidden" name="partner_id" id="partner_id" value="<cfif isdefined("attributes.iid") and len(attributes.iid)>#attributes.partner_id#<cfelse>#attributes.partner_id#</cfif>">
										<input type="hidden" name="consumer_id" id="consumer_id" value="<cfif isdefined("attributes.iid") and len(attributes.iid)>#attributes.consumer_id#<cfelse>#attributes.consumer_id#</cfif>">
										<input type="hidden" name="employee_id" id="employee_id" value="<cfif isdefined("attributes.iid") and len(attributes.iid)>#emp_id#<cfelse>#attributes.employee_id#</cfif>">
										<cfif isdefined("attributes.iid") and len(attributes.iid) >
											<cfif len(attributes.partner_id) and isnumeric(attributes.partner_id)>
												<input type="text" name="partner_name" id="partner_name" value="#get_sale_det_cons.company_partner_name# #get_sale_det_cons.company_partner_surname#" readonly style="width:140px;">
											<cfelseif len(attributes.consumer_id) and isnumeric(attributes.consumer_id)>
												<input type="text" name="partner_name" id="partner_name" value="#get_cons_name.consumer_name# #get_cons_name.consumer_surname#" readonly style="width:140px;">
											<cfelseif len(attributes.employee_id) and isnumeric(attributes.employee_id)>
												<input type="text" name="partner_name" id="partner_name" value="#get_emp_info(attributes.employee_id,0,0,0,attributes.ACC_TYPE_ID)#" readonly style="width:140px;">							
											</cfif>
										<cfelse>
											<input type="text" name="partner_name" id="partner_name" value="#attributes.partner_name#" readonly style="width:140px;">
										</cfif>
									</cfoutput>
								</div>
							</div>
							<div class="form-group" id="item-irsaliye">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57773.İrsaliye'></label>
								<div class="col col-8 col-xs-12">
									<div class="input-group">
										<input type="hidden" name="irsaliye_project_id_listesi" id="irsaliye_project_id_listesi" value="">
										<input type="hidden" name="siparis_date_listesi" id="siparis_date_listesi" value="">
										<input type="hidden" name="irsaliye_date_listesi" id="irsaliye_date_listesi" value="<cfif isdefined("attributes.ship_date") and len(attributes.ship_date)><cfoutput>#dateformat(attributes.ship_date,dateformat_style)#</cfoutput></cfif>">
										<input type="hidden" name="irsaliye_id_listesi" id="irsaliye_id_listesi" value="<cfif isdefined("attributes.ship_id") and len(attributes.ship_id)><cfoutput>#attributes.ship_id#;#session.ep.period_id#</cfoutput></cfif>">
										<input type="text" name="irsaliye" id="irsaliye" value="<cfif isdefined("attributes.ship_id") and len(attributes.ship_id)><cfoutput>#attributes.ship_number#</cfoutput></cfif>" readonly style="width:140px;">
										<span class="input-group-addon btnPointer icon-ellipsis" onclick="add_irsaliye();"></span>
									</div>
								</div>
							</div>
							<div class="form-group" id="item-deliver_get">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57775.Teslim Alan'> *</label>
								<div class="col col-8 col-xs-12">
									<div class="input-group">
										<cfif isdefined("attributes.iid") and len(attributes.iid) >
											<cfif len(attributes.deliver_emp) and isnumeric(attributes.deliver_emp)>
												<cfset str_del_name=get_emp_info(attributes.deliver_emp,0,0)>
											<cfelse>
												<cfset str_del_name="">
											</cfif>	
										</cfif>
										<cfoutput>
											<cfif isdefined("attributes.iid") and len(attributes.iid)>
												<cfset style = "readonly">
											<cfelse>
												<cfset style = "onfocus='AutoComplete_Create('deliver_get','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','deliver_get_id','','3','150');' autocomplete='off'">
											</cfif>
											<input type="hidden" name="deliver_get_id" id="deliver_get_id"  value="<cfif isdefined("attributes.iid") and len(attributes.iid) >#attributes.deliver_emp#<cfelseif isdefined("attributes.ship_id") and len(attributes.ship_id)>#attributes.deliver_emp_id#<cfelse>#session.ep.userid#</cfif>">
											<input type="text" name="deliver_get" id="deliver_get" value="<cfif isdefined("attributes.iid") and len(attributes.iid) ><cfif len(attributes.deliver_emp)>#str_del_name#</cfif><cfelseif isdefined("attributes.ship_id") and len(attributes.ship_id)><cfoutput><cfif len(attributes.deliver_emp_id)>#get_emp_info(attributes.deliver_emp_id,0,0)#<cfelseif len(attributes.deliver_par_id)>#get_par_info(attributes.deliver_par_id,0,0,0)#</cfif></cfoutput><cfelse>#get_emp_info(session.ep.userid,0,0)#</cfif>" #style# >
										</cfoutput>
										<span class="input-group-addon btnPointer icon-ellipsis" title="<cf_get_lang dictionary_id='57734.seçiniz'>" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&select_list=1&field_name=form_basket.deliver_get&field_emp_id2=form_basket.deliver_get_id</cfoutput>','list');"></span>
									</div>
								</div>
							</div>
							<cfif session.ep.our_company_info.subscription_contract eq 1>
								<div class="form-group" id="item-subscription_id">
									<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='29502.Abone No'></label>
									<div class="col col-8 col-xs-12">
										<cfif isdefined("attributes.subscription_id") and len(attributes.subscription_id)>
											<cf_wrk_subscriptions width_info='140' subscription_id='<cfif isdefined("attributes.iid") and len(attributes.iid) or isdefined("attributes.order_id")>#attributes.subscription_id#<cfelseif isdefined("attributes.subscription_id") and len(attributes.subscription_id)>#attributes.subscription_id#</cfif>'  fieldid='subscription_id' fieldname='subscription_no' form_name='form_basket' img_info='plus_thin'>
										<cfelse>
											<cf_wrk_subscriptions width_info='140' fieldid='subscription_id' fieldname='subscription_no' form_name='form_basket' img_info='plus_thin'>
										</cfif>
										
									</div>
								</div>
							</cfif>
							<div class="form-group" id="item-order_id_form">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57611.sipariş'></label>
								<div class="col col-8 col-xs-12">
									<div class="input-group">
										<input type="hidden" name="order_id_listesi" id="order_id_listesi" value="<cfif isdefined('attributes.order_id') and len(attributes.order_id)><cfoutput>#attributes.order_id#</cfoutput><cfelseif isdefined('attributes.order_id_listesi') and len(attributes.order_id_listesi)><cfoutput>#attributes.order_id_listesi#</cfoutput></cfif>">
										<input type="text" name="order_id_form" id="order_id_form" value="<cfif isdefined('attributes.order_number') and len(attributes.order_number)><cfoutput>#attributes.order_number#</cfoutput></cfif>" style="width:140px;" readonly>
										<span class="input-group-addon btnPointer icon-ellipsis" title="<cf_get_lang dictionary_id='57734.seçiniz'>" onclick="add_order();"></span>
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
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57637.Seri No'></label>
								<div class="col col-8 col-xs-12">
									<div class="input-group">
										<cfsavecontent variable="message"><cf_get_lang dictionary_id='57184.Fatura No Girmelisiniz !'></cfsavecontent>
										<cfinput type="text" maxlength="5" name="serial_number" id="serial_number" value="#serial_number#">
										<span class="input-group-addon no-bg"> - </span>
										<cfsavecontent variable="message"><cf_get_lang dictionary_id='57412.Seri No Girmelisiniz'></cfsavecontent>
										<cfif isdefined("serial_no") and len(serial_no)>
											<cfinput type="text" maxlength="50" name="serial_no" id="serial_no" style="margin-bottom:5px;" value="#serial_no#" required="Yes" message="#message#" onBlur="paper_control(this,'INVOICE',false,0,'',form_basket.company_id.value,form_basket.consumer_id.value,'','','',form_basket.serial_number);">
										<cfelseif isdefined('attributes.ship_number') and len(attributes.ship_number)>
											<cfinput type="text" maxlength="50" name="serial_no" id="serial_no" style="margin-bottom:5px;" value="#attributes.ship_number#" required="Yes" message="#message#" onBlur="paper_control(this,'INVOICE',false,0,'',form_basket.company_id.value,form_basket.consumer_id.value,'','','',form_basket.serial_number);">											
										<cfelse>
											<cfinput type="text" maxlength="50" name="serial_no" id="serial_no" style="margin-bottom:5px;" value="#serial_no#" required="Yes" message="#message#" onBlur="paper_control(this,'INVOICE',false,0,'',form_basket.company_id.value,form_basket.consumer_id.value,'','','',form_basket.serial_number);">												
										</cfif>
									</div>
								</div>
							</div>
							<div class="form-group" id="item-invoice_date">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58759.Fatura Tarihi'> *</label>
								<div class="col col-8 col-xs-12">
									<div class="input-group">
										<cfsavecontent variable="message"><cf_get_lang dictionary_id='57185.Fatura Tarihi Girmelisiniz !'></cfsavecontent>
										<cfif isdefined("attributes.iid") and len(attributes.iid)>
											<cfset date = "#dateformat(now(),dateformat_style)#">
										<cfelse>
											<cfset date = "#dateformat(invoice_date,dateformat_style)#">
										</cfif>
										<cfinput type="text" name="invoice_date" style="width:100px;" required="Yes" message="#message#" value="#date#" validate="#validate_style#" onChange="change_paper_duedate('invoice_date');changeProcessDate();"  passthrough="onBlur=""change_money_info('form_basket','invoice_date');changeProcessDate()""">
										<span class="input-group-addon btnPointer" title="<cf_get_lang dictionary_id='57734.seçiniz'>"><cf_wrk_date_image date_field="invoice_date" call_function="change_money_info&rate_control&changeProcessDate"></span>
									</div>
								</div>
							</div>
							<div class="form-group" id="item-process_date">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57879.İşlem Tarihi'> *</label>
								<div class="col col-8 col-xs-12">
									<div class="input-group">
										<cfsavecontent variable="message"><cf_get_lang dictionary_id='57906.İşlem Tarihi Girmelisiniz !'></cfsavecontent>
										<cfif isdefined("process_date_")>
											<cfset p_date = process_date_>
										<cfelse>
											<cfset p_date = now()>
										</cfif>
										<cfinput type="text" name="process_date" style="width:100px;" required="Yes" message="#message#" value="#dateformat(p_date,dateformat_style)#" validate="#validate_style#">
										<span class="input-group-addon btnPointer" title="<cf_get_lang dictionary_id='57734.seçiniz'>"><cf_wrk_date_image date_field="process_date"></span>
									</div>
								</div>
							</div>
							<div class="form-group" id="item-realization_date" style="display:none;">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="57167.İntaç Tarihi"></label>
								<div class="col col-8 col-xs-12">
									<div class="input-group">
										<cfinput type="text" name="realization_date" id="realization_date" value=""  onblur="rate_control('2');" onChange="check_member_price_cat();" validate="#validate_style#" maxlength="10">
										<span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="realization_date" call_function="change_money_info"></span>
									</div>
								</div>
							</div>
							<div class="form-group" id="item-ref_no">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58784.Referans'></label>
								<div class="col col-8 col-xs-12">
									<input type="text" name="ref_no" id="ref_no" value="<cfif isdefined("attributes.iid") and len(attributes.iid)><cfif len(attributes.ref_no)><cfoutput>#attributes.ref_no#</cfoutput></cfif><cfelse><cfoutput>#attributes.ref_no#</cfoutput></cfif>" style="width:135px;" maxlength="500">		
								</div>
							</div>
							<div class="form-group" id="item-PARTNER_NAMEO">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='30011.Satın Alan'></label>
								<div class="col col-8 col-xs-12">
									<div class="input-group">
										<cfif isdefined("attributes.iid") and len(attributes.iid) or isdefined("attributes.order_id") >
											<input type="hidden" name="EMPO_ID" id="EMPO_ID" value="<cfif attributes.empo_id eq "" ><cfoutput><cfelse>#attributes.empo_id#</cfoutput></cfif>">
											<input type="hidden" name="PARTO_ID" id="PARTO_ID">
											<input type="text" name="PARTNER_NAMEO" id="PARTNER_NAMEO"  <cfif len(attributes.empo_id)>value="<cfoutput>#get_emp_info(attributes.empo_id,0,0,0)#</cfoutput>"<cfelse>value="<cfoutput>#get_emp_info(attributes.empo_id,0,0)#</cfoutput>"</cfif>disabled style="width:135px;">
										<cfelse>
											<input type="hidden" name="EMPO_ID" id="EMPO_ID">
											<input type="hidden" name="PARTO_ID" id="PARTO_ID" value="">
											<input type="text" name="PARTNER_NAMEO" id="PARTNER_NAMEO" value="" style="width:135px;" onfocus="AutoComplete_Create('PARTNER_NAMEO','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_PARTNER_NAME2,MEMBER_NAME2','get_member_autocomplete','\'1,3\',0,0','EMPLOYEE_ID,PARTNER_CODE','EMPO_ID,PARTO_ID','','3','250');" autocomplete="off"> 
										</cfif>
										<span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&is_rate_select=1&select_list=1,2&field_name=form_basket.PARTNER_NAMEO&field_id=form_basket.PARTO_ID&field_EMP_id=form_basket.EMPO_ID</cfoutput>','list');"></span>
									</div>
								</div>
							</div>
							<cfif session.ep.our_company_info.project_followup eq 1>
								<div class="form-group" id="item-Proje">
									<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57416.Proje'></label>
									<div class="col col-8 col-xs-12">
									<cfoutput>
										<div class="input-group">
											<input type="hidden" name="project_id" id="project_id" value="<cfif isdefined("attributes.iid") and len(attributes.iid)><cfif len(attributes.project_id)>#attributes.project_id#</cfif><cfelse><cfif isdefined('attributes.project_id')>#attributes.project_id#</cfif></cfif>"> 
											<input type="text" name="project_head" id="project_head" value="<cfif isdefined("attributes.iid") and len(attributes.iid)><cfif len(attributes.project_id)>#GET_PROJECT_NAME(attributes.project_id)#</cfif><cfelse><cfif isdefined('attributes.project_id') and len(attributes.project_id)>#GET_PROJECT_NAME(attributes.project_id)#</cfif></cfif>"  onfocus="AutoComplete_Create('project_head','PROJECT_ID,PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','form_basket','3','200')" autocomplete="off">
											<span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_projects&project_id=form_basket.project_id&project_head=form_basket.project_head');</cfoutput>"></span>
											<span class="input-group-addon btnPointer bold" onclick="if(document.getElementById('project_id').value!='')windowopen('<cfoutput>#request.self#?fuseaction=project.popup_list_project_actions&from_paper=INVOICE&id='+document.getElementById('project_id').value+''</cfoutput>,'horizantal');else alert('<cf_get_lang dictionary_id='58797.Proje Seçiniz'>');">?</span>
										</div>
									</div>
									</cfoutput>
								</div>
							</cfif>
							<cfif xml_show_ship_address eq 1>
							<div class="form-group" id="item-ship_address">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='29462.Yükleme Yeri'></label>
								<div class="col col-8 col-xs-12">
									<div class="input-group">
										<cfif isdefined("attributes.iid") and len(attributes.iid)>
										<cfoutput>
											<input type="hidden" name="ship_address_city_id" id="ship_address_city_id" value="#attributes.city_id#">
											<input type="hidden" name="ship_address_county_id" id="ship_address_county_id" value="#attributes.county_id#">
											<input type="hidden" name="deliver_comp_id" id="deliver_comp_id" value="#attributes.deliver_comp_id#">
											<input type="hidden" name="deliver_cons_id" id="deliver_cons_id" value="#attributes.deliver_cons_id#">
											<input type="hidden" name="ship_address_id" id="ship_address_id" value="#attributes.ship_address_id#">
											<input type="text" name="ship_address" id="ship_address" style="width:135px;" maxlength="200" value="<cfoutput>#attributes.ship_address#</cfoutput>">
											</cfoutput>
										<cfelse>
											<cfif isdefined('attributes.company_id') and len(attributes.company_id)>
												<cfquery name="get_ship_address" datasource="#dsn#">
													SELECT
														TOP 1 *
													FROM
														(	SELECT 0 AS TYPE,COMPBRANCH_ID,COMPBRANCH_ADDRESS AS ADDRESS,POS_CODE,SEMT,COUNTY_ID AS COUNTY,CITY_ID AS CITY,COUNTRY_ID AS COUNTRY FROM COMPANY_BRANCH WHERE IS_SHIP_ADDRESS = 1 AND COMPANY_ID = #attributes.company_id# 
															UNION
															SELECT 1 AS TYPE,-1 COMPBRANCH_ID,COMPANY_ADDRESS AS ADDRESS,POS_CODE,SEMT,COUNTY,CITY,COUNTRY FROM COMPANY WHERE COMPANY_ID = #attributes.company_id#
														) AS TYPE
													ORDER BY
														TYPE 
												</cfquery>
												<cfset address_ = get_ship_address.address>
												<cfset attributes.ship_address_id_ = get_ship_address.COMPBRANCH_ID>
												<cfif len(get_ship_address.pos_code) and len(get_ship_address.semt)>
													<cfset address_ = "#address_# #get_ship_address.pos_code# #get_ship_address.semt#">
												</cfif>
												<cfif len(get_ship_address.county)>
													<cfquery name="get_county_name" datasource="#dsn#">
														SELECT COUNTY_ID,COUNTY_NAME FROM SETUP_COUNTY WHERE COUNTY_ID = #get_ship_address.county#
													</cfquery>
													<cfset attributes.ship_address_county_id = get_county_name.county_id>
													<cfset address_ = "#address_# #get_county_name.county_name#">
												</cfif>
												<cfif len(get_ship_address.city)>
													<cfquery name="get_city_name" datasource="#dsn#">
														SELECT CITY_ID,CITY_NAME FROM SETUP_CITY WHERE CITY_ID = #get_ship_address.city#
													</cfquery>
													<cfset attributes.ship_city_id = get_city_name.city_id>
													<cfset address_ = "#address_# #get_city_name.city_name#">
												</cfif>
												<cfif len(get_ship_address.country)>
													<cfquery name="get_country_name" datasource="#dsn#">
														SELECT COUNTRY_NAME FROM SETUP_COUNTRY WHERE COUNTRY_ID = #get_ship_address.country#
													</cfquery>
													<cfset address_ = "#address_# #get_country_name.country_name#">
												</cfif>
											</cfif>
											<!--- //Uye Bilgilerinden gelindiginde teslim yeri alaninin dolu gelmesi icin eklendi --->
											<cfoutput>
											<input type="hidden" name="ship_address_city_id" id="ship_address_city_id" value="<cfif isdefined('attributes.ship_city_id') and len(attributes.ship_city_id)>#attributes.ship_city_id#</cfif>">
											<input type="hidden" name="ship_address_county_id" id="ship_address_county_id" value="<cfif isDefined("attributes.ship_address_county_id") and len(attributes.ship_address_county_id)>#attributes.ship_address_county_id#</cfif>">
											<input type="hidden" name="deliver_comp_id" id="deliver_comp_id" value="<cfif isdefined('attributes.deliver_comp_id') and len(attributes.deliver_comp_id)>#attributes.deliver_comp_id#</cfif>">
											<input type="hidden" name="deliver_cons_id" id="deliver_cons_id" value="<cfif isDefined("attributes.deliver_cons_id") and len(attributes.deliver_cons_id)>#attributes.deliver_cons_id#</cfif>">
											<input type="hidden" name="ship_address_id" id="ship_address_id" value="<cfif isdefined('attributes.ship_address_id_') and len(attributes.ship_address_id_)>#attributes.ship_address_id_#</cfif>">
											<input type="text" name="ship_address" id="ship_address" style="width:135px;" maxlength="200" value="<cfif isdefined('address_') and len(address_)><cfoutput>#address_#</cfoutput></cfif>">
											</cfoutput>
										</cfif>
										<span class="input-group-addon btnPointer icon-ellipsis" title="<cf_get_lang dictionary_id='57734.seçiniz'>" onclick="add_adress();"></span>
									</div>
								</div>
							</div>
							</cfif>
						</div>
						<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
							<div class="form-group" id="item-department_ID">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58763.Depo'> *</label>
								<div class="col col-8 col-xs-12">
									<cfif isdefined("attributes.iid") and len(attributes.iid)>
										<cfset attributes.department_id = attributes.department_id>
										<cfinclude template="../query/get_dept_name.cfm">
										<cfset txt_department_name = get_dept_name.department_head>
										<cfset branch_id=get_dept_name.branch_id>
										<cfif len(attributes.department_location)>
											<cfset attributes.location_id = attributes.department_location>
											<cfinclude template="../query/get_location_name.cfm">
											<cfset txt_department_name = txt_department_name & "-" & get_location_name.comment>
										</cfif>
										<cf_wrkdepartmentlocation
											returninputvalue="location_id,txt_department_name,department_id,branch_id"
											returnqueryvalue="LOCATION_ID,LOCATION_NAME,DEPARTMENT_ID,BRANCH_ID"
											fieldname="txt_department_name"
											fieldid="location_id"
											department_fldid="department_id"
											branch_fldid="branch_id"
											branch_id="#branch_id#"
											department_id="#attributes.department_id#"
											location_id="#attributes.department_location#"
											location_name="#txt_department_name#"
											user_level_control="#session.ep.OUR_COMPANY_INFO.IS_LOCATION_FOLLOW#"
											width="135">
									<cfelseif isdefined("attributes.ship_id") and len(attributes.ship_id)>
											<cf_wrkdepartmentlocation 
											returnInputValue="location_id,department_name,department_id,branch_id"
											returnQueryValue="LOCATION_ID,LOCATION_NAME,DEPARTMENT_ID,BRANCH_ID"
											fieldName="department_name"
											fieldid="location_id"
											department_fldId="department_id"
											department_id="#attributes.department_in#"
											location_id="#attributes.location_in#"
											user_level_control="#session.ep.OUR_COMPANY_INFO.IS_LOCATION_FOLLOW#"
											line_info = 2
											width="135">
									<cfelse>
										<cfif isdefined('attributes.department_ID') and len(attributes.department_ID)>
											<cfset location_info_ = get_location_info(attributes.department_ID,attributes.location_id,1,1)>
											<cfset attributes.department_ID = attributes.department_ID>
											<cfset attributes.location_id = attributes.location_id>
										<cfelse>
											<cfset location_info_ = ''>
											<cfset attributes.department_ID = ''>
											<cfset attributes.location_id = ''>
										</cfif>
										<cf_wrkdepartmentlocation
											returninputvalue="location_id,department_name,department_id,branch_id"
											returninputquery="LOCATION_ID,LOCATION_NAME,DEPARTMENT_ID,BRANCH_ID"
											fieldname="department_name"
											fieldid="location_id"
											department_fldid="department_id"
											branch_fldid="branch_id"
											branch_id="#listlast(location_info_,',')#"
											department_id="#attributes.department_ID#"
											location_id="#attributes.location_id#"
											location_name="#listfirst(location_info_,',')#"
											user_level_control="#session.ep.OUR_COMPANY_INFO.IS_LOCATION_FOLLOW#"
											width="135">
									</cfif>
								</div>
							</div>
							<div class="form-group" id="item-ship_method">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='29500.Sevk Yöntemi'></label>
								<div class="col col-8 col-xs-12">
									<div class="input-group">
										<input type="hidden" name="ship_method" id="ship_method" value="<cfif isdefined("attributes.ship_method") and len(attributes.ship_method)><cfoutput>#attributes.ship_method#</cfoutput></cfif>">
										<cfif isdefined("attributes.ship_method") and len(attributes.ship_method)>
											<cfset attributes.ship_method_id=attributes.ship_method>
											<cfinclude template="../query/get_ship_methods.cfm">
										</cfif>
										<input type="text" name="ship_method_name" id="ship_method_name"  style="width:135px;" value="<cfif isdefined("attributes.ship_method") and  len(attributes.ship_method) ><cfoutput>#ship_methods.ship_method#</cfoutput></cfif>" onfocus="AutoComplete_Create('ship_method_name','SHIP_METHOD','SHIP_METHOD','get_ship_method','','SHIP_METHOD_ID','ship_method','','3','135');" autocomplete="off">
										<span class="input-group-addon btnPointer icon-ellipsis" title="<cf_get_lang dictionary_id='57734.seçiniz'>" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_ship_methods&field_name=ship_method_name&field_id=ship_method','list');"></span>
									</div>
								</div>
							</div>
							<div class="form-group" id="item-paymethod">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58516.Ödeme Yöntem'></label>
								<div class="col col-8 col-xs-12">
									<div class="input-group">
										<cfif isdefined("attributes.iid") and len(attributes.iid) or (isdefined("attributes.order_id") and len(attributes.order_id)) or (isdefined("attributes.ship_id") and len(attributes.ship_id))>
											<cfif len(attributes.paymethod_id)>
												<cfinclude template="../query/get_paymethod.cfm">
												<!--- <input type="hidden" name="basket_due_value" value="<cfoutput>#get_paymethod.due_day#</cfoutput>"> --->
												<input type="hidden" name="paymethod_id" id="paymethod_id" value="<cfoutput>#attributes.paymethod_id#</cfoutput>">
												<input type="hidden" name="card_paymethod_id" id="card_paymethod_id" value="">
												<input type="hidden" name="commission_rate" id="commission_rate" value="">
												<input type="text" name="paymethod" id="paymethod" value="<cfoutput>#get_paymethod.paymethod#</cfoutput>" readonly style="width:135px;">
											<cfelseif len(attributes.card_paymethod_id)>
												<cfquery name="GET_CARD_PAYMETHOD" datasource="#DSN3#">
													SELECT 
														CARD_NO
														<cfif isdefined("attributes.commethod_id") and attributes.commethod_id eq 6> <!--- WW den gelen siparişlerin guncellemesi, (siparisin commethod_id si faturaya tasınıyor) --->
														,PUBLIC_COMMISSION_MULTIPLIER AS COMMISSION_MULTIPLIER
														<cfelse>  <!--- EP VE PP den gelen siparişlerin guncellemesi --->
														,COMMISSION_MULTIPLIER 
														</cfif>
													FROM 
														CREDITCARD_PAYMENT_TYPE 
													WHERE 
														PAYMENT_TYPE_ID= #attributes.card_paymethod_id#
												</cfquery>
											<cfoutput>
												<input type="hidden" name="paymethod_id" id="paymethod_id" value="">
												<!--- <input type="hidden" name="basket_due_value" value=""> --->
												<input type="hidden" name="card_paymethod_id" id="card_paymethod_id" value="#attributes.card_paymethod_id#">
												<input type="hidden" name="commission_rate" id="commission_rate" value="#get_card_paymethod.commission_multiplier#">
												<input type="text" name="paymethod" id="paymethod" value="#get_card_paymethod.card_no#" readonly style="width:135px;">
											</cfoutput>
											<cfelse>
												<!--- <input type="hidden" name="basket_due_value" value=""> --->
												<input type="hidden" name="paymethod_id" id="paymethod_id">
												<input type="hidden" name="card_paymethod_id" id="card_paymethod_id" value="">
												<input type="hidden" name="commission_rate" id="commission_rate" value="">
												<input type="text" name="paymethod"  id="paymethod"value="" readonly style="width:135px;">
											</cfif>
											<cfset card_link="&field_card_payment_id=form_basket.card_paymethod_id&field_card_payment_name=form_basket.paymethod&field_commission_rate=form_basket.commission_rate">
										<cfelse>
											<input type="hidden" name="card_paymethod_id" id="card_paymethod_id" value="">
											<input type="hidden" name="commission_rate" id="commission_rate" value="">
											<input type="hidden" name="paymethod_vehicle" id="paymethod_vehicle" value=""><!--- Ödeme aracını tutuyor ve basket hesaplamalarında kullanılıyor lütfen silmeyiniz --->
											<input type="hidden" name="paymethod_id" id="paymethod_id" value="<cfif isDefined('invoice_paymethod_id')><cfoutput>#invoice_paymethod_id#</cfoutput></cfif>">
											<input type="text" name="paymethod" id="paymethod" style="width:135px;" value="<cfif isDefined('invoice_paymethod')><cfoutput>#invoice_paymethod#</cfoutput></cfif>"  readonly>
											<cfset card_link="&field_card_payment_id=form_basket.card_paymethod_id&field_card_payment_name=form_basket.paymethod&field_commission_rate=form_basket.commission_rate&field_paymethod_vehicle=form_basket.paymethod_vehicle">
										</cfif>
										<span class="input-group-addon btnPointer icon-ellipsis" title="<cf_get_lang dictionary_id='57734.seçiniz'>" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_paymethods&function_name=change_paper_duedate&function_parameter=invoice_date&field_dueday=form_basket.basket_due_value&field_id=form_basket.paymethod_id&field_name=form_basket.paymethod#card_link#</cfoutput>','list');"></span>
									</div>	
								</div>
							</div>
							<div class="form-group" id="item-basket_due_value_date_">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='57337.Vade/Tarih'></label>
								<div class="col col-8 col-xs-12">
									<div class="input-group">
										<cfsavecontent variable="message"><cf_get_lang dictionary_id ='57338.Vade Tarihi İçin Geçerli Bir Format Giriniz'>!</cfsavecontent>
										<input type="text" name="basket_due_value" id="basket_due_value" value="<cfif isDefined('invoice_due_day')><cfoutput>#invoice_due_day#</cfoutput><cfelseif ( (isdefined("attributes.iid") and len(attributes.iid)) or (isdefined("attributes.order_id") and len(attributes.order_id)) or (isdefined("attributes.ship_id") and len(attributes.ship_id)))  and (len(basket_due_value_date_) and len(invoice_date))><cfoutput>#datediff('d',invoice_date,basket_due_value_date_)#</cfoutput></cfif>" onchange="change_paper_duedate('invoice_date');" style="width:43px;">
										<span class="input-group-addon no-bg"></span>
										<cfif isdefined("attributes.iid") and len(attributes.iid) or (isdefined("attributes.order_id") and len(attributes.order_id)) or (isdefined("attributes.ship_id") and len(attributes.ship_id))>
											<cfset val="#dateformat(basket_due_value_date_,dateformat_style)#">
										<cfelseif isDefined('invoice_due_date')>
											<cfset val="#dateformat(invoice_due_date,dateformat_style)#<cfelse>#dateformat(invoice_date,dateformat_style)#">
										<cfelse>
											<cfset val="#dateformat(now(),dateformat_style)#">
										</cfif>
										<cfinput type="text" name="basket_due_value_date_" value="#val#" onChange="change_paper_duedate('invoice_date',1);" validate="#validate_style#" message="#message#" maxlength="10" style="width:90px;" readonly>
										<span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="basket_due_value_date_"></span>
									</div>
								</div>
							</div>
							<cfif xml_show_contract eq 1>
								<div class="form-group" id="item-contract">
									<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='29522.Sözleşme'></label>
									<div class="col col-8 col-xs-12">
										<div class="input-group">
											<cfif isdefined('attributes.progress_id') and len(attributes.progress_id )>
												<input type="hidden" name="progress_id" id="progress_id" value="<cfoutput>#attributes.progress_id#</cfoutput>">
											</cfif> 
											<cfif isdefined('attributes.contract_id') and len(attributes.contract_id) >
												<cfquery name="getContract" datasource="#dsn3#">
													SELECT CONTRACT_HEAD FROM RELATED_CONTRACT WHERE CONTRACT_ID = #attributes.contract_id#
												</cfquery>
												<input type="hidden" name="contract_id" id="contract_id" value="<cfif len(attributes.contract_id)><cfoutput>#attributes.contract_id#</cfoutput></cfif>"> 
												<input type="text" name="contract_no" id="contract_no" value="<cfif len(attributes.contract_id)><cfoutput>#getContract.contract_head#</cfoutput></cfif>" style="width:135px;">
											<cfelse>
												<input type="hidden" name="contract_id" id="contract_id" value=""> 
												<input type="text" name="contract_no" id="contract_no" value="" style="width:135px;">
											</cfif>
											<span class="input-group-addon btnPointer icon-ellipsis" title="<cf_get_lang dictionary_id='57734.seçiniz'>" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_contract&field_id=form_basket.contract_id&field_name=form_basket.contract_no'</cfoutput>,'large');"></span>
										</div>
									</div>
								</div>
							</cfif>
							<cfif xml_acc_department_info>
								<div class="form-group" id="item-acc_department_id">
									<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57572.Departman'></label>
									<div class="col col-8 col-xs-12">
										<cfif isdefined("attributes.iid") and len(attributes.iid)>
											<cf_wrkdepartmentbranch fieldid='acc_department_id' is_department='1' width='135' selected_value='#attributes.ACC_DEPARTMENT_ID#'>
										<cfelseif isDefined("attributes.acc_department_id") and len(attributes.acc_department_id)>
											<cf_wrkdepartmentbranch fieldid='acc_department_id' is_department='1' width='135' selected_value='#attributes.acc_department_id#'>
										<cfelse>
											<cf_wrkdepartmentbranch fieldid='acc_department_id' is_department='1' width='140' is_deny_control='0'>
										</cfif>
									</div>
								</div>
							</cfif>
						</div>
						<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="4" sort="true">
							<div class="form-group" id="item-note">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
								<div class="col col-8 col-xs-12">
									<textarea name="note" id="note" style="width:135px;height:65px;"><cfif isdefined("attributes.iid") and len(attributes.iid)><cfoutput>#attributes.note#</cfoutput><cfelseif isdefined("attributes.ship_id") and len(attributes.ship_id)><cfif len(attributes.ship_detail)><cfoutput>#attributes.ship_detail#</cfoutput></cfif><cfelse><cfoutput>#attributes.note#</cfoutput></cfif></textarea>
								</div>
							</div>
							<cfif session.ep.our_company_info.asset_followup eq 1>
								<div class="form-group" id="item-asset_name">
									<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='58833.Fiziki Varlık'></label>
									<div class="col col-8 col-xs-12">
										<cfif isdefined("attributes.iid") and len(attributes.iid)>
											<cf_wrkassetp asset_id="#attributes.assetp_id#" fieldid='asset_id' fieldname='asset_name' form_name='form_basket' width='135' button_type="plus_thin">
										<cfelse>
											<cf_wrkassetp fieldid='asset_id' fieldname='asset_name' width='135' form_name='form_basket' button_type="plus_thin">
										</cfif>
									</div>
								</div>
							</cfif>
							<cfif xml_show_cash_checkbox eq 1>
								<div class="form-group" id="item-kasa">
									<label class="col col-4 col-xs-12" id="kasa_sec">
										<cf_get_lang dictionary_id='57163.Nakit Alış'>
										<input type="checkbox" name="cash" id="cash" <cfif isdefined("attributes.iid") and len(attributes.iid)>onclick="gizle_goster(not1);"<cfelse>onclick="ayarla_gizle_goster();"</cfif><cfif isdefined("attributes.iid") and len(attributes.iid) and attributes.is_cash eq 1>checked</cfif>>
									</label>
									<cfif isdefined("attributes.iid") and len(attributes.iid)>
										<cfset id="id='not1'">
										<cfif isdefined("attributes.iid") and len(attributes.iid) and attributes.is_cash neq 1>
											<cfset style="style='display:none;'">
										</cfif>
									<cfelse>
										<cfset style="style='display:none;'">
										<cfset id="id='cash_'">
									</cfif> 
									<div class="col col-8 col-xs-12" <cfoutput>#id# #style#</cfoutput>>
										<cfif kasa.recordcount>
											<select name="kasa" id="kasa" style="width:135px;">
												<cfoutput query="kasa">
													<option value="#cash_id#" <cfif isdefined("attributes.iid") and len(attributes.iid) and attributes.kasa_id eq cash_id >selected</cfif>>#cash_name#-#cash_currency_id#</option>
												</cfoutput>
											</select>
											<cfoutput query="kasa">
												<input type="hidden" name="str_kasa_parasi#cash_id#" id="str_kasa_parasi#cash_id#" value="#cash_currency_id#">
											</cfoutput>	
										</cfif>
									</div>
								</div>
								<div class="form-group" id="item-checkboxes">
									<div class="col col-12 col-xs-12">
										<label><cf_get_lang dictionary_id="58199.Kredi Kartı"><input type="checkbox" name="credit" id="credit" onclick="ayarla_gizle_goster2(3);"></label>
										<label><cf_get_lang dictionary_id="57521.Banka"><input type="checkbox" name="bank" id="bank" onclick="ayarla_gizle_goster2(2);"></label>
										<cfset ins_info = ''>
										<cfset delay_info = ''>
										<cfset credit_info = ''>
										<cfset expense_bank_id = ''>
									</div>
								</div>
								<div class="padding-bottom-5" style="display:none;" id="banka2">
									<div class="form-group" id="item-bank">
										<div class="col col-4 col-xs-12">
											<label><cf_get_lang dictionary_id='57652.Hesap'></label>
										</div>
										<div class="col col-8 col-xs-12"><cf_wrkbankaccounts width='135' control_status='1' selected_value='#expense_bank_id#'></div>
									</div>
								</div>
								<div class="padding-bottom-5" style="display:none;" id="credit2">
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
											<cfinput type="text" name="inst_number" id="inst_number" value="#ins_info#" style="width:30px;"  onkeyup="return(formatcurrency(this,event,0,'int'));" class="moneybox">
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
							<div class="form-group" id="item-add_info_plus">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="57810.Ek Bilgi"></label>
								<div class="col col-8 col-xs-12"><cf_wrk_add_info info_type_id="-8" upd_page = "0"></div>
								<div id="add_info_plus"></div><!--- isbak için eklendi kaldırmayınız sm --->
							</div>
						</div>
					</cf_box_elements>
					<cf_box_footer>
						<cf_workcube_buttons is_upd='0' is_delete=false add_function='kontrol()'>
					</cf_box_footer>
				</cf_basket_form>	
				
				<cfif isdefined("attributes.iid") and len(attributes.iid)  >
					<cfset attributes.basket_id = 1>
					<cfinclude template="../../objects/display/basket.cfm">
				<cfelseif isdefined("attributes.order_id") and len(attributes.order_id)  >
					<cfset attributes.basket_id = 1>
					<cfset attributes.basket_sub_id = 7>
					<cfinclude template="../../objects/display/basket.cfm">
				<cfelseif isdefined("attributes.ship_id") and len(attributes.ship_id)>
					<cfset attributes.basket_id = 1>
					<cfset attributes.basket_sub_id = 1>
					<cfinclude template="../../objects/display/basket.cfm">
				<cfelse>
					<cfif session.ep.isBranchAuthorization>
						<!--- subeden cagırılıyorsa alıs faturası sube basket sablonunu kullansın--->
						<cfset attributes.basket_id = 20> 
					<cfelse>
						<cfset attributes.basket_id = 1>
					</cfif>
					<cfif not isdefined('attributes.stock_id') and not isdefined('attributes.stock_name') and not isdefined('attributes.convert_stocks_id') and not isdefined("attributes.receiving_detail_id")>
						<cfset attributes.form_add = 1>
					</cfif>
					<cfinclude template="../../objects/display/basket.cfm">
				</cfif>
			</cfform>
		</div>
	</cf_box>
</div>
<script type="text/javascript">

	function ayarla_gizle_goster2(id) {
		if(id==3){
			if(document.getElementById("credit").checked == true){
				if (document.getElementById("bank")){
					document.getElementById("bank").checked = false;
					document.getElementById("banka2").style.display='none';
					document.getElementById("bank_code").value = "";
				}
				if (document.getElementById("cash")) {
					document.getElementById("cash").checked = false;
					document.getElementById("cash_").style.display='none';
				}
				document.getElementById("credit2").style.display='';
			}
			else{
				document.getElementById("credit2").style.display='none';
			}
		}
		else{
			if(document.getElementById("bank").checked == true){
				if (document.getElementById("cash")) {
					document.getElementById("cash").checked = false;
					document.getElementById("cash_").style.display='none';
				}
				if (document.getElementById("credit")) {
					document.getElementById("credit").checked = false;
					document.getElementById("credit2").style.display='none';
				}
				document.getElementById("banka2").style.display='';
			}
			else{
				document.getElementById("banka2").style.display='none';
				document.getElementById("bank_code").value = "";
			}
		}
	}							

<cfif not(isdefined('attributes.ship_id') and len(attributes.ship_id))>
$(document).ready(function(){
	if(typeof(change_paper_duedate) == "function")
change_paper_duedate('invoice_date');

});
</cfif>
function changeProcessDate(){
	$("#process_date").val($("#invoice_date").val());
}
function add_order()
{	
	deger = form_basket.process_cat.options[form_basket.process_cat.selectedIndex].value;
	if(deger == '')
	{
		alert("<cf_get_lang dictionary_id='58770.İşlem Tipi Seçmelisiniz'> !");
		return false;
	}	
	if((form_basket.company_id.value.length!="" && form_basket.company_id.value!="") || (form_basket.consumer_id.value.length!="" && form_basket.consumer_id.value!="") || (form_basket.employee_id.value.length!="" && form_basket.employee_id.value!=""))
	{	
		if(eval("form_basket.ct_process_type_" + deger).value == 54 || eval("form_basket.ct_process_type_" + deger).value == 55)
		{
			is_purchase = 0;
			is_return = 1;
		}
		else
		{
			is_purchase = 1;
			is_return = 0;
		}
		str_irslink = '&is_from_invoice=1&order_id_liste=' + form_basket.order_id_listesi.value + '&is_purchase='+is_purchase+'&is_return='+is_return+'&company_id='+form_basket.company_id.value + '&consumer_id='+form_basket.consumer_id.value<cfif session.ep.isBranchAuthorization>+'&is_sale_store='+1</cfif>; 
		<cfif session.ep.our_company_info.project_followup eq 1>
			if(form_basket.project_id.value!='' && form_basket.project_head.value!='')
				str_irslink = str_irslink+'&project_id='+form_basket.project_id.value;
		</cfif>
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_orders_for_ship' + str_irslink , 'list_horizantal');
		return true;
	}
	else (form_basket.company_id.value =="")
	{
		alert("<cf_get_lang dictionary_id='57183.Cari Hesap Seçmelisiniz'> !");
		return false;
	}
}
function add_irsaliye()
{
	if(form_basket.company_id.value.length || form_basket.consumer_id.value.length || form_basket.employee_id.value.length)
	{ 
		str_irslink = '&ship_id_liste=' + form_basket.irsaliye_id_listesi.value + '&id=purchase&sale_product=0&company_id='+form_basket.company_id.value+'&consumer_id='+ form_basket.consumer_id.value+'&employee_id=' + form_basket.employee_id.value + '&invoice_date='+form_basket.invoice_date.value<cfif session.ep.isBranchAuthorization>+'&is_store='+1</cfif>;
		<cfif session.ep.our_company_info.project_followup eq 1>
		 	if(form_basket.project_id.value!='' && form_basket.project_head.value!='')
				str_irslink = str_irslink+'&project_id='+form_basket.project_id.value;
		 </cfif>
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_choice_ship&ship_project_liste=1' + str_irslink , 'page');
		return true;
	}
	else
	{
		alert("<cf_get_lang dictionary_id='57715.Önce Üye Seçiniz'>!");
		return false;
	}
}
function kontrol_ithalat()
{
	deger = form_basket.process_cat.options[form_basket.process_cat.selectedIndex].value;
	sistem_para_birimi = "<cfoutput>#session.ep.money#</cfoutput>";	
	if(deger != "")
	{
		var fis_no = eval("form_basket.ct_process_type_" + deger);
	
		if (fis_no.value == 591)
		{
			if(form_basket.cash != undefined && form_basket.cash.checked)
			{
			}
			else
			{
				if(sistem_para_birimi==document.all.basket_money.value)
				{
					alert("<cf_get_lang dictionary_id='57122.Sistem Para Birimi ile Fatura Para Birimi İthalat Faturası İçin Aynı'>!");
				}
			}
			reset_basket_kdv_rates(); //kdv oranları sıfırlanıyor dsp_basket_js_scripts te tanımlı
		}
	}
	return true;
}
function kontrol()
{
	if(document.getElementById("credit") != undefined && document.getElementById("bank").checked == true)
	{		
		if(!acc_control()) return false;
	}
	if(document.getElementById("credit") != undefined && document.getElementById("credit").checked == true)
	{		
		if(document.getElementById("credit_card_info").value == '')
		{
			alert("<cf_get_lang dictionary_id='32659.Lütfen Kredi Kartı Seçiniz'>");
			return false;
		}
	}
	<cfif isdefined("xml_show_process_stage") and len(xml_show_process_stage) and xml_show_process_stage eq 1>
		if(document.form_basket.process_stage.value == "") 
			{
				alert("<cf_get_lang dictionary_id ='41036.Lütfen Süreçlerinizi Tanimlayiniz veya Tanimlanan Süreçler Üzerinde Yetkiniz Yok'>!");
				return false;
			}
	</cfif>
	if(!paper_control(form_basket.serial_no,'INVOICE',false,0,'',form_basket.company_id.value,form_basket.consumer_id.value,'','','',form_basket.serial_number)) return false;
	if(!chk_process_cat('form_basket')) return false;
	<cfif isdefined('xml_acc_department_info') and xml_acc_department_info eq 2> //xmlde muhasebe icin departman secimi zorunlu ise
		if( document.form_basket.acc_department_id.options[document.form_basket.acc_department_id.selectedIndex].value=='')
		{
			alert("<cf_get_lang dictionary_id='58836.Lutfen Departman Seciniz'>");
			return false;
		} 
	</cfif>
	if(!check_display_files('form_basket')) return false;
	if(!chk_period(form_basket.process_date,"İşlem")) return false;
	if(!kontrol_ithalat()) return false;
	if(!check_accounts('form_basket')) return false;
	<cfif isdefined("xml_upd_row_project") and xml_upd_row_project eq 1 and session.ep.our_company_info.project_followup eq 1>
		apply_deliver_date('','project_head','');
	</cfif>
	if(!check_product_accounts()) return false;
	try
	{
		try{a=form_basket.row_ship_id[0].value;}catch(e){a=form_basket.row_ship_id.value;}
		if (a=="" || a=="0")
		{
			if(form_basket.department_id.value=="")
			{
				alert("<cf_get_lang dictionary_id='57186.Depo Seçmelisiniz'>!");
				return false;
			}
			if(form_basket.deliver_get.value=="")
			{
				alert("<cf_get_lang dictionary_id='57033.Teslim Alan Seçiniz'>!");
				return false;		
			}
		}

	}
	catch(e)
	{
		if(form_basket.department_id.value=="")
		{
			alert("<cf_get_lang dictionary_id='57186.Depo Seçmelisiniz'>!");
			return false;
		}
		if(form_basket.deliver_get.value=="")
		{
			alert("<cf_get_lang dictionary_id='57033.Teslim Alan Seçiniz'>!");
			return false;			
		}		
	}		
	
	if (document.form_basket.comp_name.value == ""  && document.form_basket.consumer_id.value == "" && document.form_basket.employee_id.value == "")
	{ 
		alert ("<cf_get_lang dictionary_id='57183.Cari Hesap Seçmelisiniz !'>");
		return false;
	}
	<cfif xml_paymethod_control>
		if(form_basket.paymethod.value == '' && form_basket.paymethod_id.value == '' || form_basket.paymethod.value == '' && form_basket.card_paymethod_id.value == '')
		{
			alert("<cf_get_lang dictionary_id='58027.Ödeme Yöntemi Seçiniz!'>");
			return false;	
		}
	</cfif>
	
	<cfif xml_shipmethod_control>
		if(form_basket.ship_method.value == '' && form_basket.ship_method_name.value == '')
		{
			alert("<cf_get_lang dictionary_id='764.Lütfen Sevk Yöntemi Seçiniz'>!");
			return false;	
		}
	</cfif>
	<cfif xml_control_ship_date eq 1>
		var irsaliye_deger_list = document.form_basket.irsaliye_date_listesi.value;
		if(irsaliye_deger_list != '')
			{
				var liste_uzunlugu = list_len(irsaliye_deger_list);
				for(var str_i_row=1; str_i_row <= liste_uzunlugu; str_i_row++)
					{
						var tarih_ = list_getat(irsaliye_deger_list,str_i_row,',');
						var sonuc_ = datediff(document.form_basket.invoice_date.value,tarih_,0);
						if(sonuc_ > 0)
							{
								alert("<cf_get_lang dictionary_id='57110.Fatura Tarihi İrsaliye Tarihinden Önce Olamaz'>");
								return false;
							}
					}
			}
	</cfif>
	<cfif xml_control_order_date eq 1>
		var siparis_deger_list = document.form_basket.siparis_date_listesi.value;
		if(siparis_deger_list != '')
			{
				var liste_uzunlugu = list_len(siparis_deger_list);
				for(var str_i_row=1; str_i_row <= liste_uzunlugu; str_i_row++)
					{
						var tarih_ = list_getat(siparis_deger_list,str_i_row,',');
						var sonuc_ = datediff(document.form_basket.invoice_date.value,tarih_,0);
						if(sonuc_ > 0)
							{
								alert("<cf_get_lang dictionary_id='59790.Fatura Tarihi Sipariş Tarihinden Önce Olamaz'>!");
								return false;
							}
					}
			}
	</cfif>
	
	<!---Satır bazında seri girilmesi zorunluluğu kontrolü --->
	<cfif isdefined("xml_serialno_control") and (xml_serialno_control eq 1)>
		prod_name_list = '';
		if( window.basketManager !== undefined ){ 
			for(var str=0; str < basketManagerObject.basketItems().length; str++){
				if( basketManagerObject.basketItems()[str].product_id() != ''){
					wrk_row_id_ = basketManagerObject.basketItems()[str].wrk_row_id();
					amount_ = basketManagerObject.basketItems()[str].amount();
					product_serial_control = wrk_safe_query("chk_product_serial1",'dsn3',0, basketManagerObject.basketItems()[str].product_id());
					str1_ = "SELECT SERIAL_NO FROM SERVICE_GUARANTY_NEW WHERE WRK_ROW_ID = '"+ wrk_row_id_ +"'";
					var get_serial_control = wrk_query(str1_,'dsn3');
					if(product_serial_control.IS_SERIAL_NO=='1'&&get_serial_control.recordcount!=amount_){
						prod_name_list = prod_name_list + eval(str +1) + '.Satır : ' + basketManagerObject.basketItems()[str].product_name() + '\n';
					}
				}
			}
		}else{
			for(var str=0; str < window.basket.items.length; str++){
				if(window.basket.items[str].PRODUCT_ID != ''){
					wrk_row_id_ = window.basket.items[str].WRK_ROW_ID;
					amount_ = window.basket.items[str].AMOUNT;
					product_serial_control = wrk_safe_query("chk_product_serial1",'dsn3',0, window.basket.items[str].PRODUCT_ID);
					str1_ = "SELECT SERIAL_NO FROM SERVICE_GUARANTY_NEW WHERE WRK_ROW_ID = '"+ wrk_row_id_ +"'";
					var get_serial_control = wrk_query(str1_,'dsn3');
					if(product_serial_control.IS_SERIAL_NO=='1'&&get_serial_control.recordcount!=amount_){
						prod_name_list = prod_name_list + eval(str +1) + '.Satır : ' + window.basket.items[str].PRODUCT_NAME + '\n';
					}
				}
			}
		}
		if(prod_name_list!=''){
			alert(prod_name_list + "<cf_get_lang dictionary_id='59791.Ürünler İçin Seri Numarası Girmelisiniz'>!");
			return false;
		}
	</cfif>
	<!---Satır bazında seri girilmesi zorunluluğu kontrolü --->
	<cfif isdefined("xml_control_ship_amount") and xml_control_ship_amount eq 1>
		var ship_product_list = '';
		var wrk_row_id_list_new = '';
		var amount_list_new = '';

		if( window.basketManager !== undefined ){ // basket v2 ye göre kontrol
			for(var str_i_row = 0; str_i_row < basketManagerObject.basketItems().length; str_i_row++){
				if( basketManagerObject.basketItems()[str_i_row].product_id() != '' && basketManagerObject.basketItems()[str_i_row].wrk_row_relation_id() != '' && basketManagerObject.basketItems()[str_i_row].row_ship_id() != ''){
					if( basketManagerObject.basketItems()[str_i_row].product_id() != '' && basketManagerObject.basketItems()[str_i_row].wrk_row_relation_id() == ''){
						ship_row_list = ship_row_list + eval(str_i_row+1) + '.Satır : ' + basketManagerObject.basketItems()[str_i_row].product_name() + '\n';
					}
					
					if(list_find(wrk_row_id_list_new, basketManagerObject.basketItems()[str_i_row].wrk_row_relation_id())){
						row_info = list_find(wrk_row_id_list_new, basketManagerObject.basketItems()[str_i_row].wrk_row_relation_id());
						amount_info = list_getat(amount_list_new, row_info);
						amount_info = parseFloat(amount_info) + parseFloat(filterNum( basketManagerObject.basketItems()[str_i_row].amount(),<cfoutput>#GET_BASKET.AMOUNT_ROUND#</cfoutput>));
						amount_list_new = list_setat(amount_list_new, row_info,amount_info);
					}
					else{
						wrk_row_id_list_new = wrk_row_id_list_new + ',' + basketManagerObject.basketItems()[str_i_row].wrk_row_relation_id();
						amount_list_new = amount_list_new + ',' + filterNum( basketManagerObject.basketItems()[str_i_row].amount(),<cfoutput>#GET_BASKET.AMOUNT_ROUND#</cfoutput>);
					}
				}
			}
		}else{
			for(var str_i_row=0; str_i_row < window.basket.items.length; str_i_row++){
				if(window.basket.items[str_i_row].PRODUCT_ID != '' && window.basket.items[str_i_row].WRK_ROW_RELATION_ID != '' && window.basket.items[str_i_row].ROW_SHIP_ID != ''){
					if(window.basket.items[str_i_row].PRODUCT_ID != '' && window.basket.items[str_i_row].WRK_ROW_RELATION_ID == ''){
						ship_row_list = ship_row_list + eval(str_i_row+1) + '.Satır : ' + window.basket.items[str_i_row].PRODUCT_NAME + '\n';
					}
					
					if(list_find(wrk_row_id_list_new,window.basket.items[str_i_row].WRK_ROW_RELATION_ID)){
						row_info = list_find(wrk_row_id_list_new,window.basket.items[str_i_row].WRK_ROW_RELATION_ID);
						amount_info = list_getat(amount_list_new,row_info);
						amount_info = parseFloat(amount_info) + parseFloat(filterNum(window.basket.items[str_i_row].AMOUNT,<cfoutput>#GET_BASKET.AMOUNT_ROUND#</cfoutput>));
						amount_list_new = list_setat(amount_list_new,row_info,amount_info);
					}
					else{
						wrk_row_id_list_new = wrk_row_id_list_new + ',' + window.basket.items[str_i_row].WRK_ROW_RELATION_ID;
						amount_list_new = amount_list_new + ',' + filterNum(window.basket.items[str_i_row].AMOUNT,<cfoutput>#GET_BASKET.AMOUNT_ROUND#</cfoutput>);
					}
				}
			}
		}
		if( window.basketManager !== undefined ){ // basket v2 ye göre kontrol
			for(var str_i_row=0; str_i_row < basketManagerObject.basketItems().length; str_i_row++){
				if( basketManagerObject.basketItems()[str_i_row].product_id() != '' && basketManagerObject.basketItems()[str_i_row].wrk_row_relation_id() != '' && basketManagerObject.basketItems()[str_i_row].row_ship_id() != ''){
					var get_inv_control = wrk_safe_query("inv_get_inv_control","dsn2",0, basketManagerObject.basketItems()[str_i_row].wrk_row_relation_id());	
					if(list_len( basketManagerObject.basketItems()[str_i_row].row_ship_id(),';') > 1){
						new_period = list_getat( basketManagerObject.basketItems()[str_i_row].row_ship_id(),2,';');
						var get_period = wrk_safe_query("inv_get_period","dsn",0,new_period);
						new_dsn2 = "<cfoutput>#dsn#</cfoutput>"+"_"+get_period.PERIOD_YEAR+"_"+get_period.OUR_COMPANY_ID;	
					}
					else
						new_dsn2 = "<cfoutput>#dsn2#</cfoutput>";
					var get_ship_control = wrk_safe_query("inv_get_ship_control",new_dsn2,0, basketManagerObject.basketItems()[str_i_row].wrk_row_relation_id());
					var get_ship_control2 = wrk_safe_query("inv_get_ship_control2",new_dsn2,0, basketManagerObject.basketItems()[str_i_row].wrk_row_relation_id());
					ship_amount_ = parseFloat(get_ship_control.AMOUNT)-parseFloat(get_ship_control2.AMOUNT); 
					row_info = list_find(wrk_row_id_list_new, basketManagerObject.basketItems()[str_i_row].wrk_row_relation_id());
					amount_info = list_getat(amount_list_new,row_info);
					var total_inv_amount = parseFloat(get_inv_control.AMOUNT)+parseFloat(amount_info);

					if(get_ship_control != undefined && get_ship_control.recordcount > 0 && ship_amount_ >0 && get_inv_control != undefined && get_inv_control.recordcount > 0 && total_inv_amount >0){
						if(total_inv_amount > ship_amount_)
							ship_product_list = ship_product_list + eval(str_i_row+1) + '.Satır : ' + basketManagerObject.basketItems()[str_i_row].product_name() + '\n';
					}
				}
			}
		}else{
			for(var str_i_row=0; str_i_row < window.basket.items.length; str_i_row++){
				if(window.basket.items[str_i_row].PRODUCT_ID != '' && window.basket.items[str_i_row].WRK_ROW_RELATION_ID != '' && window.basket.items[str_i_row].ROW_SHIP_ID != ''){
					var get_inv_control = wrk_safe_query("inv_get_inv_control","dsn2",0,window.basket.items[str_i_row].WRK_ROW_RELATION_ID);	
					if(list_len(window.basket.items[str_i_row].ROW_SHIP_ID,';') > 1){
						new_period = list_getat(window.basket.items[str_i_row].ROW_SHIP_ID,2,';');
						var get_period = wrk_safe_query("inv_get_period","dsn",0,new_period);
						new_dsn2 = "<cfoutput>#dsn#</cfoutput>"+"_"+get_period.PERIOD_YEAR+"_"+get_period.OUR_COMPANY_ID;	
					}
					else
						new_dsn2 = "<cfoutput>#dsn2#</cfoutput>";
					var get_ship_control = wrk_safe_query("inv_get_ship_control",new_dsn2,0, window.basket.items[str_i_row].WRK_ROW_RELATION_ID);
					var get_ship_control2 = wrk_safe_query("inv_get_ship_control2",new_dsn2,0, window.basket.items[str_i_row].WRK_ROW_RELATION_ID);
					ship_amount_ = parseFloat(get_ship_control.AMOUNT)-parseFloat(get_ship_control2.AMOUNT); 
					row_info = list_find(wrk_row_id_list_new,window.basket.items[str_i_row].WRK_ROW_RELATION_ID);
					amount_info = list_getat(amount_list_new,row_info);
					var total_inv_amount = parseFloat(get_inv_control.AMOUNT)+parseFloat(amount_info);

					if(get_ship_control != undefined && get_ship_control.recordcount > 0 && ship_amount_ >0 && get_inv_control != undefined && get_inv_control.recordcount > 0 && total_inv_amount >0){
						if(total_inv_amount > ship_amount_)
							ship_product_list = ship_product_list + eval(str_i_row+1) + '.Satır : ' + window.basket.items[str_i_row].PRODUCT_NAME + '\n';
					}
				}
			}
		}
		if(ship_product_list != ''){
			alert("<cf_get_lang dictionary_id='57108.Aşağıda Belirtilen Ürünler İçin Toplam Fatura Miktarı İrsaliye Miktarından Fazla ! Lütfen Ürünleri Kontrol Ediniz !'>\n\n" + ship_product_list);
			return false;
		}
	</cfif>
	//irsaliye satır kontrolü
	<cfif xml_control_ship_row eq 1>
		ship_list_ = document.getElementById('irsaliye_id_listesi').value; 
		if(ship_list_ != ''){
			var ship_row_list = '';
			if( window.basketManager !== undefined ){ // basket v2 ye göre kontrol
				for(var str=0; str < basketManagerObject.basketItems().length; str++){
					if( basketManagerObject.basketItems()[str].product_id() != ''){
						if( basketManagerObject.basketItems()[str].product_id() != '' && basketManagerObject.basketItems()[str].wrk_row_relation_id() == ''){
							ship_row_list = ship_row_list + eval(str+1) + '.Satır : ' + basketManagerObject.basketItems()[str].product_name() + '\n';
						}
					}
				}
			}else{
				for(var str=0; str < window.basket.items.length; str++){
					if(window.basket.items[str].PRODUCT_ID != ''){
						if(window.basket.items[str].PRODUCT_ID != '' && window.basket.items[str].WRK_ROW_RELATION_ID == ''){
							ship_row_list = ship_row_list + eval(str+1) + '.Satır : ' + window.basket.items[str].PRODUCT_NAME + '\n';
						}
					}
				}
			}
		if(ship_row_list != ''){
				alert("<cf_get_lang dictionary_id='59792.Aşağıda Belirtilen Ürünler İlişkili İrsaliye Dışında Eklenmiştir'>. <cf_get_lang dictionary_id='59793.Lütfen Ürünleri Kontrol Ediniz'> ! \n\n" + ship_row_list);
				return false;
			}
		}
	</cfif>
	<cfif session.ep.our_company_info.is_lot_no eq 1>//şirket akış parametrelerinde lot no zorunlu olsun seçili ise
		if( window.basketManager !== undefined ){
			row_count = basketManagerObject.basketItems().length;
			if(check_lotno('form_basket') != undefined && check_lotno('form_basket')){//işlem kategorisinde lot no zorunlu olsun seçili ise
				if(row_count != undefined){
					for(i=0;i<row_count;i++){
						if( basketManagerObject.basketItems()[i].stock_id().length != 0){
							get_prod_detail = wrk_safe_query('obj2_get_prod_name','dsn3',0, basketManagerObject.basketItems()[i].stock_id());
							if(get_prod_detail.IS_LOT_NO == 1){//üründe lot no takibi yapılıyor seçili ise
								if(basketManagerObject.basketItems()[i].lot_no() == 0){
									alert((i+1)+'. satırdaki '+ basketManagerObject.basketItems()[i].product_name() + ' ürünü için lot no takibi yapılmaktadır!');
									return false;
								}
							}
						}
					}
				}
			}
		}else{
			row_count = window.basket.items.length;
			if(check_lotno('form_basket') != undefined && check_lotno('form_basket')){//işlem kategorisinde lot no zorunlu olsun seçili ise
				if(row_count != undefined){
					for(i=0;i<row_count;i++){
						if(window.basket.items[i].STOCK_ID.length != 0){
							get_prod_detail = wrk_safe_query('obj2_get_prod_name','dsn3',0,window.basket.items[i].STOCK_ID);
							if(get_prod_detail.IS_LOT_NO == 1)//üründe lot no takibi yapılıyor seçili ise{
								if(window.basket.items[i].LOT_NO.length == 0){
									alert((i+1)+'. satırdaki '+ window.basket.items[i].PRODUCT_NAME + ' ürünü için lot no takibi yapılmaktadır!');
									return false;
								}
							}
						}
					}
				}
			}				
	</cfif>
	change_paper_duedate('invoice_date');
	<cfif isdefined("xml_show_process_stage") and len(xml_show_process_stage) and xml_show_process_stage eq 1>
		return (process_cat_control() && saveForm());
	<cfelse>
		return (saveForm());
	</cfif>
	return false;
}
function ayarla_gizle_goster()
{
	if(form_basket.cash != undefined && form_basket.cash.checked){
		cash_.style.display = '';
		if (document.getElementById("bank")){
			document.getElementById("bank").checked = false;
			document.getElementById("banka2").style.display='none';
			document.getElementById("bank_code").value = "";
		}
		if (document.getElementById("credit")){
			document.getElementById("credit").checked = false;
			document.getElementById("credit2").style.display='none';
		}
	}
	else
		cash_.style.display = 'none';
}
function kontrol_yurtdisi()
{
	deger = form_basket.process_cat.options[form_basket.process_cat.selectedIndex].value;
	if(deger != "")
	{
		var fis_no = eval("form_basket.ct_process_type_" + deger);
		if(fis_no.value == 591)
		{

			$("#item-realization_date").show();
			<cfif xml_show_cash_checkbox eq 1>
				kasa_sec.style.display = 'none';
				cash_.style.display = 'none';
				if(form_basket.cash != undefined)
					form_basket.cash.checked=false;
			</cfif>
			reset_basket_kdv_rates(); //kdv oranları sıfırlanıyor dsp_basket_js_scripts te tanımlı
		}
		else
		{
			if($("#realization_date").val() != '')
				change_money_info('form_basket','invoice_date');
			$("#realization_date").val('');
			$("#item-realization_date").hide();
			<cfif xml_show_cash_checkbox eq 1>
				kasa_sec.style.display = '';
			</cfif>
		}
	}
}
	function rate_control(type){
		if(type == 2){
				if($("#realization_date").val() == '')
				{
					change_money_info('form_basket','invoice_date');
				}
				else
				{
					change_money_info('form_basket','realization_date');
				}
			}
		else
			{
				if($("#realization_date").val() != ''){
					alert("<cf_get_lang dictionary_id='59794.Fatura Tarihi Değiştirildiğinden İntaç Tarihi Tekrar Seçilmelidir'>!");
					$("#realization_date").val('');
				}
			}
		
	}
function check_process_is_sale(){/*satıs iadeleri alıs karakterli oldugu halde satıs fiyatları ile çalışması için*/
	<cfif get_basket.basket_id is 1>
		var selected_ptype = document.form_basket.process_cat.options[document.form_basket.process_cat.selectedIndex].value;
		eval('var proc_control = document.form_basket.ct_process_type_'+selected_ptype+'.value');
		if(proc_control==54 || proc_control==55)
			sale_product= 1;			
		else
			sale_product = 0;
	<cfelse>
		return true;
	</cfif>
}
function add_adress()
{
	if(!(form_basket.company_id.value=="") || !(form_basket.consumer_id.value==""))
	{
		if(form_basket.company_id.value!="")
			{
				str_adrlink = '&field_long_adres=form_basket.ship_address&field_adress_id=form_basket.ship_address_id';
				if(form_basket.ship_address_city_id!=undefined) str_adrlink = str_adrlink+'&field_city=form_basket.ship_address_city_id';
				if(form_basket.ship_address_county_id!=undefined) str_adrlink = str_adrlink+'&field_county=form_basket.ship_address_county_id&field_id=form_basket.deliver_comp_id'<cfif session.ep.isBranchAuthorization>+'&is_store_module='+1</cfif>;
				windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_member_address&is_comp=1&select_list=1&keyword='+encodeURIComponent(form_basket.comp_name.value)+''+ str_adrlink , 'list');
				document.getElementById('deliver_cons_id').value = '';
				return true;
			}
		else
			{
				str_adrlink = '&field_long_adres=form_basket.ship_address&field_adress_id=form_basket.ship_address_id'; 
				if(form_basket.ship_address_city_id!=undefined) str_adrlink = str_adrlink+'&field_city=form_basket.ship_address_city_id';
				if(form_basket.ship_address_county_id!=undefined) str_adrlink = str_adrlink+'&field_county=form_basket.ship_address_county_id&field_id=form_basket.deliver_cons_id'<cfif session.ep.isBranchAuthorization>+'&is_store_module='+1</cfif>;
				windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_member_address&is_comp=0&select_list=2&keyword='+encodeURIComponent(form_basket.partner_name.value)+''+ str_adrlink , 'list');
				document.getElementById('deliver_comp_id').value = '';
				return true;
			}
	}
	else
	{
		alert("<cf_get_lang dictionary_id='50081.Cari Hesap Seçiniz'>");
		return false;
	}
}
function find_invoice_f()
	{
		if($("#find_invoice_number").val().length)
		{
			var get_invoice = wrk_safe_query('sls_get_fatura','dsn2',0,$("#find_invoice_number").val());
			if(get_invoice.recordcount)
				window.location.href = '<cfoutput>#request.self#?fuseaction=invoice.form_add_bill_purchase&event=upd&iid=</cfoutput>'+get_invoice.INVOICE_ID[0];
			else
			{
				alert("<cf_get_lang dictionary_id='58486.Kayıt Bulunamadı'>!");
				return false;
			}
		}
		else
		{
			alert("<cf_get_lang dictionary_id='59795.İnvoice No Eksik'> !");
			return false;
		}
	}

</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
<cfsetting showdebugoutput="yes"> 