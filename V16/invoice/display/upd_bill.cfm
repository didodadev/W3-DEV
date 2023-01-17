<cfsetting showdebugoutput="yes">
<cf_get_lang_set module_name="invoice">
<cf_xml_page_edit fuseact="invoice.detail_invoice_sale">
<cfif isnumeric(attributes.iid)>
	<cfinclude template="../query/get_sale_det.cfm">
	<cfscript>
		get_bill_action = createObject("component", "V16.invoice.cfc.get_bill");
		CHK_SEND_INV= get_bill_action.CHK_SEND_INV(iid:attributes.iid);
		CHK_SEND_ARC= get_bill_action.CHK_SEND_ARC(iid:attributes.iid);
		CONTROL_EARCHIVE= get_bill_action.CONTROL_EARCHIVE(iid:attributes.iid);
		CONTROL_EINVOICE= get_bill_action.CONTROL_EINVOICE(iid:attributes.iid);
	</cfscript>
<cfelse>
	<cfset get_sale_det.recordcount = 0>
</cfif>
<cfif not get_sale_det.recordcount>
	<cfset hata  = 11>
	<cfsavecontent variable="message"><cf_get_lang dictionary_id='57997.Şube Yetkiniz Uygun Değil'> <cf_get_lang dictionary_id='57998.Veya'>  <cf_get_lang dictionary_id='57999.Çalıştığınız Muhasebe Dönemine Ait Böyle Bir Fatura Bulunamadı'> !</cfsavecontent>
	<cfset hata_mesaj  = message>
	<cfinclude template="../../dsp_hata.cfm">
<cfelse>
<!--- Faturaya ait herhangi bir odeme plani satiri bankaya gonderilmisse fatura silinemez --->
<cfquery name="get_invoice_payment_plan" datasource="#dsn3#">
	SELECT IS_BANK FROM INVOICE_PAYMENT_PLAN WHERE INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.iid#"> AND PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">
</cfquery>
<cfif get_invoice_payment_plan.recordcount>
	<cfoutput query="get_invoice_payment_plan">
		<cfif is_bank eq 1><cfset is_not_delete = 1></cfif>
	</cfoutput>
</cfif>
<cfif listfind('SATIS,IADE',get_sale_det.invoice_type_code) and (len(get_sale_det.company_id) and get_sale_det_comp.use_efatura eq 1 and datediff('d',get_sale_det_comp.efatura_date,get_sale_det.invoice_date) gte 0) or (len(get_sale_det.consumer_id) and get_cons_name.use_efatura eq 1 and datediff('d',get_cons_name.efatura_date,get_sale_det.invoice_date) gte 0) and datediff('d',createodbcdatetime('#year(session.ep.our_company_info.efatura_date)#-#month(session.ep.our_company_info.efatura_date)#-#day(session.ep.our_company_info.efatura_date)#'),get_sale_det.invoice_date) gt 0>
	<cfif isdefined("xml_warning_type")>
		<cfquery name="kontrol_warning" datasource="#dsn2#">
			SELECT COUNT(*) COUNT FROM EINVOICE_SENDING_DETAIL WHERE ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.iid#"> AND ACTION_TYPE = 'INVOICE'
		</cfquery> 
		<cfif xml_warning_type eq 1 and chk_send_inv.count eq 0><!--- Gönderilmemiş olan tüm faturalar için uyarı verilecek --->
			<cfset is_einvoice_warning = 1>
		<cfelseif xml_warning_type eq 2 and chk_send_inv.count eq 0><!--- Hiç gönderilmemiş faturalar için uyarı verilecek --->	
			<cfset is_einvoice_warning = 1>
		<cfelseif xml_warning_type eq 3 and kontrol_warning.count neq 0 and chk_send_inv.count eq 0><!--- Daha önce gönderilip hata alınan faturalar için uyarı verilecek --->	
			<cfset is_einvoice_warning = 1>
		</cfif>
	</cfif>
<cfelseif listfind('SATIS,IADE',get_sale_det.invoice_type_code) and session.ep.our_company_info.is_earchive eq 1 and datediff('d',createodbcdatetime('#year(session.ep.our_company_info.earchive_date)#-#month(session.ep.our_company_info.earchive_date)#-#day(session.ep.our_company_info.earchive_date)#'),get_sale_det.invoice_date) gte 0>
	<cfif isdefined("xml_warning_type_archive")>
		<cfquery name="kontrol_warning" datasource="#dsn2#">
			SELECT COUNT(*) COUNT FROM EARCHIVE_SENDING_DETAIL WHERE ACTION_ID = #attributes.iid# AND ACTION_TYPE = 'INVOICE'
		</cfquery> 
		<cfif xml_warning_type_archive eq 1 and (chk_send_arc.count eq 0 or (get_sale_det.is_iptal eq 1 and control_earchive.recordcount and control_earchive.is_cancel eq 0))><!--- Gönderilmemiş olan tüm faturalar için uyarı verilecek --->
			<cfset is_einvoice_warning_arc = 1>
		</cfif>
	</cfif>
</cfif>
<cfif listfind('BEDELSIZIHRACAT,IHRACAT,YOLCUBERABERFATURA',get_sale_det.profile_id,',')>
	<cfset get_sale_det_comp.use_efatura = 1>
	<cfset get_sale_det_comp.efatura_date = dateadd('yyyy',-1,now())>
</cfif>
<cfinclude template="../query/get_session_cash_all.cfm">
<cfinclude template="../query/get_moneys.cfm">
<cfinclude template="../query/get_inv_cancel_types.cfm">
<cfparam name="attributes.company_id" default="#get_sale_det.company_id#">
<cfparam name="attributes.invoice_number" default="#get_sale_det.invoice_number#">
<cfscript>session_basket_kur_ekle(action_id=attributes.iid,table_type_id:1,process_type:1);</cfscript>
<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box>
		<div id="basket_main_div">
			<cfform name="form_basket" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_upd_bill" method="post">
				<cf_basket_form id="upd_bill">
					<cfoutput>
						<input type="hidden" name="form_action_address" id="form_action_address" value="#listgetat(attributes.fuseaction,1,'.')#.emptypopup_upd_bill">
						<input type="hidden" name="active_period" id="active_period" value="#session.ep.period_id#">
						<input type="hidden" name="xml_calc_due_date" id="xml_calc_due_date" value="#xml_calc_due_date#"><!--- Bazı metal firmalarında vade tarihi siparişten hesaplanıyordu , kocaerde sorun olunca xml e bağlandı action da kullanılıyor --->
						<input type="hidden" name="xml_kontrol_due_date" id="xml_kontrol_due_date" value="#xml_kontrol_due_date#">
						<input type="hidden" name="invoice_id" id="invoice_id" value="#attributes.iid#">
						<input type="hidden" name="old_net_total" id="old_net_total" value="#get_sale_det.nettotal#">
						<input type="hidden" name="old_pay_method" id="old_pay_method" value="#get_sale_det.pay_method#">
						<input type="hidden" name="commethod_id" id="commethod_id" value="<cfif len(get_sale_det.commethod_id)>#get_sale_det.commethod_id#</cfif>">
						<input type="hidden" name="invoice_cari_action_type" id="invoice_cari_action_type" value="<cfif len(get_sale_det.cari_action_type)>#get_sale_det.cari_action_type#</cfif>">
						<input type="hidden" name="invoice_payment_plan" id="invoice_payment_plan" value="1">
						<input type="hidden" name="search_process_date" id="search_process_date" value="invoice_date">
						<input type="hidden" name="del_invoice_id" id="del_invoice_id" value="0">
						<input type="hidden" name="is_cost" id="is_cost" value="<cfif get_sale_det.is_cost eq 1>1<cfelse>0</cfif>">
						<input type="hidden" name="print_invoice_id" id="print_invoice_id" value="#attributes.iid#">
						<cfquery name="get_contract_comp" datasource="#dsn2#">
							SELECT RELATED_ACTION_ID FROM INVOICE_ROW WHERE INVOICE_ID = #attributes.iid# AND RELATED_ACTION_TABLE = 'INVOICE_CONTRACT_COMPARISON'
						</cfquery>
						<input type="hidden" name="contract_row_ids" id="contract_row_ids" value="#valuelist(get_contract_comp.related_action_id)#">
						<cfif len(get_sale_det.company_id)>
							<cfset member_account_code = get_company_period(get_sale_det.company_id)>
						<cfelseif len(get_sale_det.consumer_id)>
							<cfset member_account_code = get_consumer_period(get_sale_det.consumer_id)>
						<cfelseif len(get_sale_det.employee_id)>
							<cfif len(get_sale_det.acc_type_id)>
								<cfset member_account_code = get_employee_period(get_sale_det.employee_id,get_sale_det.acc_type_id)>
							<cfelse>
								<cfset member_account_code = get_employee_period(get_sale_det.employee_id)>
							</cfif>	
						</cfif>
						<input type="hidden" name="member_account_code" id="member_account_code" value="#member_account_code#">
						<input type="hidden" name="order_id" id="order_id" value="#get_order.order_id#">
						<input type="hidden" name="order_number" id="order_number" value="#get_order.order_number#">
						<input type="hidden" name="print_count" id="print_count" value="#get_sale_det.print_count#">
						<input type="hidden" name="old_department_id" id="old_department_id" value="#get_sale_det.department_id#">
						<input type="hidden" name="old_location_id" id="old_location_id" value="#get_sale_det.department_location#">
						<input type="hidden" name="xml_get_branch_from_department" value="#xml_get_branch_from_department#">
						<input type="hidden" name="is_export_custom_invoice" value="#is_export_custom_invoice#">
					</cfoutput>
					<cf_box_elements>
						<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
							<cfif isdefined("xml_show_process_stage") and len(xml_show_process_stage) and xml_show_process_stage eq 1>
								<div class="form-group require" id="item-process_stage">
									<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id="58859.Süreç"></label>
									<div class="col col-8 col-sm-12">
										<cf_workcube_process is_upd='0' process_cat_width='125' is_detail='1' select_value='#get_sale_det.process_stage#'>
									</div>                
								</div>
							</cfif>
							<div class="form-group" id="item-process_cat">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57800.işlem tipi'> *</label>
								<div class="col col-8 col-xs-12">
									<cf_workcube_process_cat onclick_function="kontrol_yurtdisi();check_process_is_sale();" process_cat="#get_sale_det.process_cat#" slct_width="140">
								</div>
							</div>
							<div class="form-group" id="item-comp_name">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57519.cari hesap'> *</label>
								<div class="col col-8 col-xs-12">
									<div class="input-group">
										<cfoutput>
											<input type="hidden" name="company_id" id="company_id" value="#get_sale_det.company_id#">
											<cfif len(get_sale_det.company_id) and get_sale_det.company_id neq 0>
												<input type="text" name="comp_name" id="comp_name" value="#get_sale_det_comp.fullname#" readonly style="width:140px;">
											<cfelseif len(get_sale_det.consumer_id)>
												<input type="text" name="comp_name" id="comp_name" value="#get_cons_name.company#" readonly style="width:140px;">
											<cfelseif len(get_sale_det.employee_id)>
												<input type="text" name="comp_name" id="comp_name" value="" readonly style="width:140px;">
											</cfif>
										</cfoutput>
										<cfset str_linkeait="&field_paymethod_id=form_basket.paymethod_id&field_paymethod=form_basket.paymethod&field_revmethod_id=form_basket.paymethod_id&field_revmethod=form_basket.paymethod&field_basket_due_value_rev=form_basket.basket_due_value&field_card_payment_id=form_basket.card_paymethod_id&call_function=add_general_prom()-check_member_price_cat()-change_paper_duedate()">
										<span class="input-group-addon btnPointer icon-ellipsis" title="<cf_get_lang dictionary_id='57734.seçiniz'>" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_pars&field_adress_id=form_basket.ship_address_id&is_cari_action=1&is_potansiyel=0&select_list=2,3,1,9&field_name=form_basket.partner_name&field_partner=form_basket.partner_id&field_emp_id=form_basket.employee_id&field_comp_name=form_basket.comp_name&field_comp_id=form_basket.company_id&field_consumer=form_basket.consumer_id&field_member_account_code=form_basket.member_account_code#str_linkeait#&come=invoice&ship_method_id=form_basket.ship_method&ship_method_name=form_basket.ship_method_name&field_long_address=form_basket.adres&field_city_id=form_basket.city_id&field_county_id=form_basket.county_id&field_cons_ref_code=form_basket.consumer_reference_code<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif></cfoutput>')"></span>
									</div>
								</div>
							</div>
							<div class="form-group" id="item-partner_name">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57578.Yetkili'> *</label>
								<div class="col col-8 col-xs-12">
									<cfoutput>
										<cfset emp_id = get_sale_det.employee_id>
										<cfif len(get_sale_det.acc_type_id)>
											<cfset emp_id = "#emp_id#_#get_sale_det.acc_type_id#">
										</cfif>
										<input type="hidden" name="partner_reference_code" id="partner_reference_code" value="#get_sale_det.partner_reference_code#">
										<input type="hidden" name="partner_id" id="partner_id" value="#get_sale_det.partner_id#">
										<input type="hidden" name="consumer_reference_code" id="consumer_reference_code" value="#get_sale_det.consumer_reference_code#">
										<input type="hidden" name="consumer_id" id="consumer_id" value="#get_sale_det.consumer_id#">
										<input type="hidden" name="employee_id" id="employee_id" value="#emp_id#">
										<cfset str_par_names = "">
										<cfif len(get_sale_det.partner_id)>
											<cfset str_par_names = "#get_sale_det_cons.company_partner_name# #get_sale_det_cons.company_partner_surname#">
										<cfelseif len(get_sale_det.consumer_id)>
											<cfset str_par_names = "#get_cons_name.consumer_name# #get_cons_name.consumer_surname#">
										<cfelseif len(get_sale_det.employee_id)>
											<cfset str_par_names = "#get_emp_info(get_sale_det.employee_id,0,0,0,get_sale_det.acc_type_id)#">
										</cfif>
										<input type="text" name="partner_name" id="partner_name" value="#str_par_names#" readonly style="width:140px;">						
									</cfoutput>
								</div>
							</div>
							<div class="form-group" id="item-payment_comp_name">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='34748.Ödeme Kuruluşu'></label>
								<div class="col col-8 col-xs-12">
									<div class="input-group">
										<cfoutput>
											<input type="hidden" name="payment_company_id" id="payment_company_id" value="#get_sale_det.payment_company_id#">
											<input type="text" name="payment_comp_name" id="payment_comp_name" value="#payment_get_sale_det_comp.fullname#" readonly style="width:140px;">
										</cfoutput>
										<span class="input-group-addon btnPointer icon-ellipsis" title="<cf_get_lang dictionary_id='57734.seçiniz'>" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_pars&is_cari_action=1&select_list=2&field_comp_name=form_basket.payment_comp_name&field_comp_id=form_basket.payment_company_id</cfoutput>')"></span>
									</div>
								</div>
							</div>
							<div class="form-group" id="item-irsaliye">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57773.İrsaliye'></label>
								<div class="col col-8 col-xs-12">
									<cfif get_with_ship.is_with_ship neq 1 >
										<div class="input-group">
											<input type="hidden" name="irsaliye_project_id_listesi" id="irsaliye_project_id_listesi" value="<cfoutput>#ship_project_without_period#</cfoutput>">
											<input type="hidden" name="irsaliye_date_listesi" id="irsaliye_date_listesi" value="<cfoutput>#ship_date_without_period#</cfoutput>">
											<input type="hidden" name="irsaliye_id_listesi" id="irsaliye_id_listesi" value="<cfoutput>#ship_id_with_period#</cfoutput>">
											<input type="text" name="irsaliye" id="irsaliye"  style="width:140px;" value="<cfoutput>#ListSort(ValueList(GET_WITH_SHIP_ALL.SHIP_NUMBER),'text')#</cfoutput>" readonly>
											<span class="input-group-addon btnPointer icon-ellipsis" title="<cf_get_lang dictionary_id='57734.seçiniz'>" onclick="add_irsaliye();"></span>
										</div>
									<cfelse>
										<input type="hidden" name="irsaliye_project_id_listesi" id="irsaliye_project_id_listesi" value="<cfoutput>#ship_project_without_period#</cfoutput>">
										<input type="hidden" name="irsaliye_date_listesi" id="irsaliye_date_listesi" value="<cfoutput>#ship_date_without_period#</cfoutput>">
										<input type="hidden" name="irsaliye_id_listesi" id="irsaliye_id_listesi" value="<cfoutput>#ship_id_with_period#</cfoutput>">
										<input type="text" name="irsaliye" id="irsaliye"  style="width:140px;" value="<cfoutput>#ListSort(ValueList(GET_WITH_SHIP_ALL.SHIP_NUMBER),'text')#</cfoutput>" readonly>
									</cfif>
								</div>
							</div>
							<div class="form-group" id="item-deliver_get">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57775.Teslim Alan'></label>
								<div class="col col-8 col-xs-12">
									<div class="input-group">
										<cfoutput><input type="text" name="deliver_get" id="deliver_get" value="#get_sale_det.deliver_emp#"></cfoutput>
										<span class="input-group-addon btnPointer icon-ellipsis" title="<cf_get_lang dictionary_id='57734.seçiniz'>" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_pars&is_rate_select=1&select_list=2,3,4,5,6&field_name=form_basket.deliver_get&come=stock&field_paymethod_id=form_basket.paymethod_id&field_paymethod=form_basket.paymethod&field_basket_due_value=form_basket.basket_due_value</cfoutput>');"></span>
									</div>
								</div>
							</div>
							<cfif session.ep.our_company_info.subscription_contract eq 1>
								<div class="form-group" id="item-subscription_id">
									<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='29502.Abone No'></label>
									<div class="col col-8 col-xs-12">
										<cfif isdefined("get_sale_det.subscription_id") and len(get_sale_det.subscription_id)>
											<cfif xml_upd_subscription eq 1>
												<cf_wrk_subscriptions width_info='140' subscription_id='#get_sale_det.subscription_id#' fieldid='subscription_id' fieldname='subscription_no' form_name='form_basket' img_info='plus_thin' is_upd="1">
											<cfelse>
												<cf_wrk_subscriptions width_info='140' subscription_id='#get_sale_det.subscription_id#' fieldid='subscription_id' fieldname='subscription_no' form_name='form_basket' img_info='plus_thin'>
											</cfif>
										<cfelse>
											<cfif xml_upd_subscription eq 1>
												<cf_wrk_subscriptions width_info='140' fieldid='subscription_id' fieldname='subscription_no' form_name='form_basket' img_info='plus_thin' is_upd="1">
											<cfelse>
												<cf_wrk_subscriptions width_info='140' fieldid='subscription_id' fieldname='subscription_no' form_name='form_basket' img_info='plus_thin'>
											</cfif>
										</cfif>
									</div>
								</div>
							</cfif>
							<div class="form-group" id="item-order_id_form">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57611.sipariş'></label>
								<div class="col col-8 col-xs-12">
									<div class="input-group">
										<input type="hidden" name="order_id_listesi" id="order_id_listesi" value="<cfif isdefined("get_order_num") and get_order_num.recordcount><cfoutput>#ValueList(get_order_num.ORDER_ID)#</cfoutput></cfif>">
										<input type="text" name="order_id_form" id="order_id_form" value="<cfif isdefined("get_order_num") and get_order_num.recordcount><cfoutput>#ListSort(valuelist(GET_ORDER_NUM.ORDER_NUMBER),'text')#</cfoutput></cfif>"readonly style="width:140px;">
										<span class="input-group-addon btnPointer icon-ellipsis" onclick="add_order();"></span>
									</div>
								</div>
							</div>
							<div class="form-group" id="add_info_plus">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57810.Ek Bilgi'></label>
								<div class="col col-8 col-xs-12">
									<cf_wrk_add_info info_type_id="-32" info_id="#attributes.iid#" upd_page = "1">
								</div>
							</div>
						</div>
						<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
							<div class="form-group" id="item-serial_number" >
								<label class="col col-4 col-md-8 col-xs-8 col-xs-12"><cf_get_lang dictionary_id='57880.Belge no'> *</label>
								<div class="col col-3 col-md-4 col-xs-4 col-xs-12">
									<cfsavecontent variable="message"><cf_get_lang dictionary_id='57412.Seri No Girmelisiniz'></cfsavecontent>
									<cfinput type="text" name="serial_number" id="serial_number" maxlength="5" style="width:40px;" value="#get_sale_det.serial_number#">											
								</div>
								<div class="col col-5 col-md-6 col-xs-6" id="item-invoice_no">
									<cfsavecontent variable="message"><cf_get_lang dictionary_id='57412.Seri No Girmelisiniz'></cfsavecontent>
									<cfinput type="text" name="serial_no" id="serial_no" value="#get_sale_det.serial_no#" required="yes" message="#message#" onBlur="check_invoice_type();">
								</div>
							</div>
							<div class="form-group" id="item-invoice_date">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58759.Fatura Tarihi'> *</label>
								<div class="col col-8 col-xs-12">
									<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
										<div class="input-group">
											<cfsavecontent variable="message"><cf_get_lang dictionary_id='57185.Fatura Tarihi Girmelisiniz !'></cfsavecontent>
											<cfinput type="text" name="invoice_date" value="#dateformat(get_sale_det.invoice_date,dateformat_style)#" validate="#validate_style#" required="yes" message="#message#" style="width:140px;" maxlength="10" readonly="yes"><!--- 20060314 readonly olmali tarih degisince fonk cagriliyor popup da --->
											<span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="invoice_date" call_function="add_general_prom&change_money_info&rate_control" control_date="#dateformat(get_sale_det.invoice_date,dateformat_style)#"></span>&nbsp;
										</div>
									</div>
									<cfoutput>
										<cfif len(get_sale_det.PROCESS_TIME)>
											<cfset value_invoice_date_h = hour(get_sale_det.PROCESS_TIME)>
											<cfset value_invoice_date_m = minute(get_sale_det.PROCESS_TIME)>
										<cfelse>
											<cfset value_invoice_date_h = hour(dateadd('h',session.ep.time_zone,now()))>
											<cfset value_invoice_date_m = minute(now())>
										</cfif>
										<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
											<cf_wrkTimeFormat name="invoice_date_h" value="#value_invoice_date_h#">
										</div>
										<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
											<select name="invoice_date_m" id="invoice_date_m">
												<cfloop from="0" to="59" index="i">
													<option value="#i#" <cfif value_invoice_date_m eq i>selected</cfif>><cfif i lt 10>0</cfif>#i# </option>
												</cfloop>
											</select>														
										</div>
									</cfoutput>  
								</div>
							</div>
							<cfif xml_show_ship_date eq 1>
								<div class="form-group" id="item-ship_date">
									<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57009.Fiili Sevk Tarihi'></label>
									<div class="col col-8 col-xs-12">
										<div class="input-group">
											<cfinput type="text" name="ship_date" id="ship_date" style="width:140px;" value="#dateformat(get_sale_det.ship_date,dateformat_style)#" validate="#validate_style#" maxlength="10">
											<span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="ship_date"></span>
										</div>
									</div>
								</div>
							</cfif>
							<div class="form-group" id="item-realization_date" style="display:none;">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="57167.İntaç Tarihi"></label>
								<div class="col col-8 col-xs-12">
									<div class="input-group">
										<cfinput type="text" name="realization_date" id="realization_date"  value="#dateformat(get_sale_det.realization_date,dateformat_style)#"  onblur="rate_control('2');" onChange="check_member_price_cat();" validate="#validate_style#" maxlength="10">
										<span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="realization_date" call_function="change_money_info"></span>
									</div>
								</div>
							</div>
							<div class="form-group" id="item-PARTNER_NAMEO">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57321.Satış Çalışanı'></label>
								<div class="col col-8 col-xs-12">
									<div class="input-group">
										<cfif not len(get_sale_det.sale_emp) and not len(get_sale_det.sale_partner)>
											<input type="hidden" name="EMPO_ID" id="EMPO_ID">
											<input type="hidden" name="PARTO_ID" id="PARTO_ID">
											<input type="text" name="PARTNER_NAMEO" id="PARTNER_NAMEO" value="" style="width:140px;" onfocus="AutoComplete_Create('PARTNER_NAMEO','POSITION_NAME','POSITION_NAME','get_emp_pos','','POSITION_CODE,EMPLOYEE_ID','PARTO_ID,EMPO_ID','','3','130');" <cfif xml_change_sales_emp eq 0> readonly="readonly"</cfif>>
											<cfif xml_change_sales_emp eq 1>
												<span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_name=form_basket.PARTNER_NAMEO&field_id=form_basket.PARTO_ID&field_EMP_id=form_basket.EMPO_ID</cfoutput>')"></span>
											</cfif>
										<cfelse>
											<cfoutput>
												<input type="hidden" name="EMPO_ID" id="EMPO_ID" value="#get_sale_det.sale_emp#">
												<input type="hidden" name="PARTO_ID" id="PARTO_ID" value="#get_sale_det.sale_partner#">
												<input type="text" name="PARTNER_NAMEO" id="PARTNER_NAMEO" onfocus="AutoComplete_Create('PARTNER_NAMEO','POSITION_NAME','POSITION_NAME','get_emp_pos','','POSITION_CODE,EMPLOYEE_ID','PARTO_ID,EMPO_ID','','3','130');" <cfif len(get_sale_det.sale_partner) >value="#get_par_info(get_sale_det.sale_partner,0,0,0)#"<cfelse> value="#get_emp_info(get_sale_det.SALE_EMP,0,0)#"</cfif> style="width:140px;" <cfif xml_change_sales_emp eq 0> readonly="readonly"</cfif>>
												<cfif xml_change_sales_emp eq 1>
													<span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_positions&select_list=1&field_name=form_basket.PARTNER_NAMEO&field_id=form_basket.PARTO_ID&field_EMP_id=form_basket.EMPO_ID')"></span>
												</cfif>
											</cfoutput>
										</cfif>						
									</div>
								</div>
							</div>
							<div class="form-group" id="item-sales_member">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57322.Satis Ortagi'></label>
								<div class="col col-8 col-xs-12">
									<div class="input-group">
										<cfif not (len(get_sale_det.sales_partner_id) or len(get_sale_det.sales_consumer_id)) and len(ship_id_with_period)>
											<cfquery name="get_sales_emp_id" datasource="#dsn2#">
												SELECT 
													SHIP_ROW.ROW_ORDER_ID,
													ORDERS.SALES_PARTNER_ID,
													ORDERS.SALES_CONSUMER_ID
												FROM 
													SHIP_ROW,
													#dsn3_alias#.ORDERS ORDERS
												WHERE 
													SHIP_ROW.SHIP_ID = #listgetat(ship_id_with_period,1,';')#
													AND SHIP_ROW.ROW_ORDER_ID = ORDERS.ORDER_ID
											</cfquery>       
											<cfset get_sale_det.sales_partner_id = get_sales_emp_id.sales_partner_id>
											<cfset get_sale_det.sales_consumer_id = get_sales_emp_id.sales_consumer_id>
										</cfif>
										<cfif len(get_sale_det.sales_partner_id)>
											<input type="hidden" id="sales_member_id" name="sales_member_id" value="<cfoutput>#get_sale_det.sales_partner_id#</cfoutput>">
											<input type="hidden" id="sales_member_type" name="sales_member_type" value="partner">
											<input type="text" id="sales_member" name="sales_member" style="width:140px;" value="<cfoutput>#get_par_info(get_sale_det.sales_partner_id,0,0,0)#</cfoutput>" onfocus="AutoComplete_Create('sales_member','MEMBER_NAME,MEMBER_PARTNER_NAME2','MEMBER_PARTNER_NAME2,MEMBER_NAME','get_member_autocomplete','\'1,2\',0,0','PARTNER_CODE,MEMBER_TYPE','sales_member_id,sales_member_type','form','3','250');">
										<cfelseif len(get_sale_det.sales_consumer_id)>
											<input type="hidden" id="sales_member_id" name="sales_member_id" value="<cfoutput>#get_sale_det.sales_consumer_id#</cfoutput>">
											<input type="hidden" id="sales_member_type" name="sales_member_type" value="consumer">
											<input type="text" id="sales_member" name="sales_member" style="width:140px;" value="<cfoutput>#get_cons_info(get_sale_det.sales_consumer_id,1,0)#</cfoutput>" onfocus="AutoComplete_Create('sales_member','MEMBER_NAME,MEMBER_PARTNER_NAME2','MEMBER_PARTNER_NAME2,MEMBER_NAME','get_member_autocomplete','\'1,2\',0,0','PARTNER_CODE,MEMBER_TYPE','sales_member_id,sales_member_type','form','3','250');">
										<cfelse>
											<input type="hidden" id="sales_member_id" name="sales_member_id" value="">
											<input type="hidden" id="sales_member_type" name="sales_member_type" value="">
											<input type="text" id="sales_member" name="sales_member" style="width:140px;" value="" onfocus="AutoComplete_Create('sales_member','MEMBER_NAME,MEMBER_PARTNER_NAME2','MEMBER_PARTNER_NAME2,MEMBER_NAME','get_member_autocomplete','\'1,2\',0,0','PARTNER_CODE,MEMBER_TYPE','sales_member_id,sales_member_type','form','3','250');">
										</cfif>
										<span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&is_rate_select=1&field_id=form_basket.sales_member_id&field_name=form_basket.sales_member&field_type=form_basket.sales_member_type<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&select_list=2,3','list','popup_list_pars');"></span>
									</div>
								</div>
							</div>
							<cfif xml_acc_department_info>
							<div class="form-group" id="item-acc_department_id">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57572.Departman'></label>
								<div class="col col-8 col-xs-12">
									<cf_wrkdepartmentbranch fieldid='acc_department_id' is_department='1' width='140' selected_value='#get_sale_det.acc_department_id#'>
								</div>
							</div>
							</cfif>
						</div>
						<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
							<div class="form-group" id="item-department_location">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58763.Depo'> *</label>
								<div class="col col-8 col-xs-12">
									<cfset location_info_ = get_location_info(get_sale_det.department_id,get_sale_det.department_location,1,1)>
									<cf_wrkdepartmentlocation
										returninputvalue="location_id,department_name,department_id,branch_id"
										returnqueryvalue="LOCATION_ID,LOCATION_NAME,DEPARTMENT_ID,BRANCH_ID"
										fieldname="department_name"
										fieldid="location_id"
										department_fldid="department_id"
										branch_fldid="branch_id"
										branch_id="#listlast(location_info_,',')#"
										department_id="#get_sale_det.department_id#"
										location_id="#get_sale_det.department_location#"
										location_name="#listfirst(location_info_,',')#"
										user_level_control="#session.ep.OUR_COMPANY_INFO.IS_LOCATION_FOLLOW#"
										width="140">
								</div>
							</div>
							<div class="form-group" id="item-ship_method">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='29500.Sevk Yöntemi'></label>
								<div class="col col-8 col-xs-12">
									<div class="input-group">
										<input type="hidden" name="ship_method" id="ship_method" value="<cfoutput>#get_sale_det.ship_method#</cfoutput>">
										<cfif len(get_sale_det.ship_method)>
										<cfset attributes.ship_method_id=get_sale_det.ship_method>
										<cfinclude template="../query/get_ship_methods.cfm">
										</cfif>
										<input type="text" name="ship_method_name" id="ship_method_name" value="<cfif len(get_sale_det.ship_method)><cfoutput>#ship_methods.ship_method#</cfoutput></cfif>" >
										<span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_ship_methods&field_name=ship_method_name&field_id=ship_method','','ui-draggable-box-small');"></span>
									</div>
								</div>
							</div>
							<div class="form-group" id="item-paymethod">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58516.Ödeme Yöntemi'></label>
								<div class="col col-8 col-xs-12">
									<div class="input-group">
										<cfif len(get_sale_det.pay_method)>
											<cfset attributes.paymethod_id=get_sale_det.pay_method>
											<cfinclude template="../query/get_paymethod.cfm">
											<input type="hidden" name="card_paymethod_id" id="card_paymethod_id" value="">
											<input type="hidden" name="commission_rate" id="commission_rate" value="">
											<input type="hidden" name="paymethod_id" id="paymethod_id" value="<cfoutput>#get_sale_det.pay_method#</cfoutput>">
											<input type="hidden" name="paymethod_vehicle"  id="paymethod_vehicle" value="<cfoutput>#get_paymethod.payment_vehicle#</cfoutput>"><!--- Ödeme aracını tutuyor ve basket hesaplamalarında kullanılıyor lütfen silmeyiniz --->
											<input type="text" name="paymethod" id="paymethod" style="width:140px;" value="<cfoutput>#get_paymethod.paymethod#</cfoutput>">
										<cfelseif len(get_sale_det.card_paymethod_id)>
											<cfquery name="get_card_paymethod" datasource="#dsn3#">
												SELECT 
													CARD_NO
													<cfif get_sale_det.commethod_id eq 6>
													,PUBLIC_COMMISSION_MULTIPLIER AS COMMISSION_MULTIPLIER
													<cfelse>
													,COMMISSION_MULTIPLIER 
													</cfif>
												FROM 
													CREDITCARD_PAYMENT_TYPE 
												WHERE 
													PAYMENT_TYPE_ID = #get_sale_det.card_paymethod_id#
											</cfquery>
											<cfoutput>
												<input type="hidden" name="paymethod_id" id="paymethod_id"  value="">
												<input type="hidden" name="paymethod_vehicle" id="paymethod_vehicle" value="-1"> <!--- kredi kartı icin set edilen bu deger dsp_basket_js_scripts.cfm sayfasındaki taksit_hesapla() fonskiyonunda kullanılıyor. burda bi degisiklik yapılırsa orası da degistirilmelidir. 	OZDEN20071218 --->
												<input type="hidden" name="card_paymethod_id"  id="card_paymethod_id" value="#get_sale_det.card_paymethod_id#">
												<input type="hidden" name="commission_rate" id="commission_rate" value="#get_card_paymethod.commission_multiplier#">
												<input type="text" name="paymethod" id="paymethod" style="width:140px;"  value="#get_card_paymethod.card_no#">
											</cfoutput>
										<cfelse>
											<input type="hidden" name="paymethod_id" id="paymethod_id" value="">
											<input type="hidden" name="card_paymethod_id" id="card_paymethod_id" value="">
											<input type="hidden" name="paymethod_vehicle" id="paymethod_vehicle" value="">
											<input type="hidden" name="commission_rate" id="commission_rate" value="">
											<input type="text" name="paymethod" id="paymethod" value="" style="width:140px;">
										</cfif>
										<cfset card_link="&field_card_payment_id=form_basket.card_paymethod_id&field_card_payment_name=form_basket.paymethod&field_commission_rate=form_basket.commission_rate&field_paymethod_vehicle=form_basket.paymethod_vehicle">
										<span class="input-group-addon btnPointer icon-ellipsis" title="<cf_get_lang dictionary_id='57734.seçiniz'>" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_paymethods&function_name=change_paper_duedate&function_parameter=invoice_date&field_dueday=form_basket.basket_due_value&field_id=form_basket.paymethod_id&field_name=form_basket.paymethod#card_link#</cfoutput>','list');"></span>
									</div>
								</div>
							</div>
							<div class="form-group" id="item-basket_due_value">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57640.Vade'></label>
								<div class="col col-8 col-xs-12">
									<div class="input-group">
										<input name="basket_due_value" id="basket_due_value" type="text" value="<cfif len(get_sale_det.due_date) and len(get_sale_det.invoice_date)><cfoutput>#datediff('d',get_sale_det.invoice_date,get_sale_det.due_date)#</cfoutput></cfif>" <cfif session.ep.our_company_info.workcube_sector is 'metal'> readonly</cfif> onchange="change_paper_duedate('invoice_date');" style="width:37px;">
										<span class="input-group-addon no-bg"></span>
										<cfinput type="text" name="basket_due_value_date_" value="#dateformat(get_sale_det.due_date,dateformat_style)#" onChange="change_paper_duedate('invoice_date',1);" validate="#validate_style#" message="#message#" maxlength="10" style="width:100px;" readonly>
										<span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="basket_due_value_date_"></span>
									</div>
								</div>
							</div>
							<input type="hidden" name="city_id" id="city_id" value="">
							<input type="hidden" name="county_id" id="county_id" value="">
							<input type="hidden" name="ship_address_id" id="ship_address_id" value="<cfoutput>#get_sale_det.ship_address_id#</cfoutput>">
							<div class="form-group" id="item-ship_address_id">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='57248.Sevk Adresi'> *</label>
								<div class="col col-8 col-xs-12">
									<div class="input-group">
										<cfinput type="text" name="adres" message="#message#" value="#trim(get_sale_det.ship_address)#" maxlength="200" style="width:140px;">
										<span class="input-group-addon btnPointer icon-ellipsis" onclick="add_adress();"></span>
									</div>
								</div>
							</div>
							<cfif session.ep.our_company_info.asset_followup eq 1>
								<div class="form-group" id="item-asset_id">
									<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='58833.Fiziki Varlık'></label>
									<div class="col col-8 col-xs-12">
										<cf_wrkassetp asset_id="#get_sale_det.assetp_id#" fieldid='asset_id' fieldname='asset_name' form_name='form_basket' button_type="plus_thin" width="140">
									</div>
								</div>
							</cfif>
							<cfif len(get_sale_det.service_id)>
								<cfquery name="get_service" datasource="#dsn3#">
									SELECT SERVICE_NO,SERVICE_HEAD FROM SERVICE WHERE SERVICE_ID = #get_sale_det.service_id#
								</cfquery>
							</cfif>
							<div class="form-group" id="item-service_no">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57656.Servis'></label>
								<div class="col col-8 col-xs-12">
									<div class="input-group">
										<cfoutput>
											<input type="hidden" name="service_id" id="service_id"  value="<cfif len(get_sale_det.service_id)>#get_sale_det.service_id#</cfif>">
											<input type="text" name="service_no" id="service_no" value="<cfif len(get_sale_det.service_id)>#get_service.service_no#</cfif>" style="width:140px;"  maxlength="50">
											<span class="input-group-addon btnPointer icon-ellipsis" title="<cf_get_lang dictionary_id='51183.İş/Görev'>" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_service&field_id=form_basket.service_id&field_no=form_basket.service_no&field_subs_id=form_basket.subscription_id&field_subs_no=form_basket.subscription_no');"></span>
										</cfoutput>
									</div>
								</div>
							</div>
						</div>
						<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="4" sort="true">
							<div class="form-group" id="item-note">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
								<div class="col col-8 col-xs-12">
									<textarea name="note" id="note" style="width:140px;height:60px;"><cfoutput>#get_sale_det.note#</cfoutput></textarea>
								</div>
							</div>
							<cfif session.ep.our_company_info.project_followup eq 1>
								<div class="form-group" id="item-project_head">
									<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57416.Proje'></label>
									<div class="col col-8 col-xs-12">
										<div class="input-group">
											<cfif isdefined('get_subscription.project_id') and len(get_subscription.project_id)> 
												<cfquery name="get_project_info" datasource="#dsn#">
													SELECT PROJECT_HEAD FROM PRO_PROJECTS WHERE PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_subscription.project_id#">
												</cfquery>
											</cfif>
											<cfif session.ep.our_company_info.project_followup eq 1>
												<cfoutput>
													<input type="hidden" name="project_id" id="project_id" value="#get_sale_det.project_id#">
													<input type="text" name="project_head" id="project_head" style="width:140px;" value="<cfif len(get_sale_det.project_id)>#GET_PROJECT_NAME(get_sale_det.project_id)#</cfif>" onfocus="AutoComplete_Create('project_head','PROJECT_ID,PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','form_basket','3','140')" autocomplete="off">
													<span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_projects&project_id=form_basket.project_id&project_head=form_basket.project_head');"></span>
													<span class="input-group-addon btnPointer bold" onclick="if(document.getElementById('project_id').value!='')windowopen('#request.self#?fuseaction=objects.popup_list_project_actions&from_paper=INVOICE&id='+document.getElementById('project_id').value+'','horizantal');else alert('<cf_get_lang dictionary_id="58797.Proje Seçiniz">');">?</span>
												</cfoutput>
											</cfif>
										</div>
									</div>
								</div>
							</cfif>
							<div class="form-group" id="item-ref_no">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58784.Referans'></label>
								<div class="col col-8 col-xs-12">
									<input type="text" name="ref_no" id="ref_no"  maxlength="500" value="<cfif len(get_sale_det.ref_no)><cfoutput>#get_sale_det.ref_no#</cfoutput></cfif>" style="width:140px;">
								</div>
							</div>
							<cfif xml_show_contract eq 1>
								<div class="form-group" id="item-contract_no">
									<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='29522.Sözleşme'></label>
									<div class="col col-8 col-xs-12">
										<div class="input-group">
											<cfif len(get_sale_det.contract_id)>
												<cfquery name="getContract" datasource="#dsn3#">
													SELECT CONTRACT_HEAD FROM RELATED_CONTRACT WHERE CONTRACT_ID = #get_sale_det.contract_id#
												</cfquery>
											</cfif>
											<input type="hidden" name="contract_id" id="contract_id" value="<cfif len(get_sale_det.contract_id)><cfoutput>#get_sale_det.contract_id#</cfoutput></cfif>"> 
											<input type="text" name="contract_no" id="contract_no" value="<cfif len(get_sale_det.contract_id)><cfoutput>#getContract.contract_head#</cfoutput></cfif>" style="width:140px;">
											<span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_contract&field_id=form_basket.contract_id&field_name=form_basket.contract_no'</cfoutput>,'large');"></span>
										</div>
									</div>
								</div>
							</cfif>
							<div class="form-group" id="item-bank_no">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='29449.Banka'></label>
								<div class="col col-8 col-xs-12"><cf_wrkbankaccounts control_status='1' selected_value='#get_sale_det.BANK_ID#'></div>
							</div>
							<cfif xml_show_cash_checkbox eq 1>     
								<div class="form-group" id="item-kasa">    
									<label class="col col-4 col-xs-12" id="kasa_sec"><cfif kasa.recordcount><cf_get_lang dictionary_id='57030.Nakit Satış'>&nbsp;</cfif><input type="checkbox" name="cash" id="cash" onclick="gizle_goster(not);"<cfif get_sale_det.is_cash eq 1>checked</cfif>></label>
									<div class="col col-8 col-xs-12" <cfif get_sale_det.is_cash neq 1> style="display:none;"</cfif> id="not">
										<cfif kasa.recordcount>
											<select name="kasa" id="kasa" style="width:140px;">
												<cfoutput query="kasa">
													<option value="#cash_id#" <cfif get_sale_det.kasa_id eq cash_id>selected</cfif>>#cash_name#-#cash_currency_id#</option>
												</cfoutput>
											</select>
											<cfoutput query="kasa">
												<input type="hidden" name="str_kasa_parasi#cash_id#" id="str_kasa_parasi#cash_id#" value="#CASH_CURRENCY_ID#">
											</cfoutput>	
										</cfif>
									</div>
								</div>
							</cfif>
							<cfif session.ep.our_company_info.is_earchive neq 1>
								<div class="form-group" id="item-kasa">  
									<cfif get_sale_det.is_iptal eq 1>
										<label class="col col-4 col-xs-12 font-red-mind"> <cf_get_lang dictionary_id='58750.Fatura İptal'><input name="fatura_iptal" id="fatura_iptal" onclick="gizle_goster(cancel_type);" value="1" checked type="checkbox"></label>
									<cfelse>
										<label class="col col-4 col-xs-12"> <cf_get_lang dictionary_id='58750.Fatura İptal'><input name="fatura_iptal" id="fatura_iptal" value="1" type="checkbox" onclick="gizle_goster(cancel_type);"></label>
									</cfif>  
									<div class="col col-8 col-xs-12" id="cancel_type" <cfif get_sale_det.is_iptal neq 1> style="display:none;"</cfif>>
										<cfif isdefined("is_add_cancel_types") and is_add_cancel_types eq 1>
											<select name="cancel_type_id" id="cancel_type_id" style="width:140px;">
												<option value=""><cf_get_lang dictionary_id='58825.İptal Nedeni'></option>
												<cfoutput query="get_inv_cancel_types">
													<option value="#inv_cancel_type_id#" <cfif get_sale_det.cancel_type_id eq inv_cancel_type_id>selected</cfif>>#inv_cancel_type#</option>
												</cfoutput>
											</select>
										</cfif>
									</div>
								</div>
							</cfif>
						</div>
					</cf_box_elements>
					<cf_box_footer>
						<div class="col col-6 col-xs-12">
							<cf_record_info query_name='get_sale_det' is_consumer = '1'>
							<cfif len(get_sale_det.print_count)>
								<label class="bold font-blue">
									<cf_get_lang dictionary_id='57223.Fatura Print Sayısı'> : <cfoutput>#get_sale_det.print_count#</cfoutput>
									<cf_get_lang dictionary_id="57039.Print Tarihi">: <cfoutput>#dateformat(get_sale_det.print_date,dateformat_style)#</cfoutput>
								</label>
							</cfif>
						</div>
						<div class="col col-6 col-xs-12">
							<cfif get_sale_det.upd_status neq 0>
								<cfset kontrol_prov = 0>
								<cfset kontrol_hobim = 0>
								<cfif xml_control_payment_rows eq 1><!--- xml den ödeme planı satırları kontrol edilsin mi seçeneği seçilmişse --->
									<cfquery name="control_prov_rows" datasource="#dsn3#">
										SELECT 
											SPR.SUBSCRIPTION_ID,
											SC.SUBSCRIPTION_NO
										FROM 
											SUBSCRIPTION_PAYMENT_PLAN_ROW SPR,
											SUBSCRIPTION_CONTRACT SC
										WHERE 
											SPR.INVOICE_ID = #get_sale_det.invoice_id#
											AND SPR.SUBSCRIPTION_ID = SC.SUBSCRIPTION_ID
											AND SPR.PERIOD_ID = #session.ep.period_id#
											AND ISNULL(SPR.IS_COLLECTED_PROVISION,0) = 1
											AND ISNULL(SPR.IS_PAID,0) = 0
									</cfquery>
									<cfset kontrol_prov = control_prov_rows.recordcount>
								</cfif>
								<cfif xml_control_hobim eq 1 and len(get_sale_det.invoice_multi_id)><!--- xml den hobim dosyası kontrol edilsin mi seçeneği seçilmişse --->
									<cfquery name="control_hobim" datasource="#dsn2#">
										SELECT 
											IM.HOBIM_ID,
											I.INVOICE_ID,
											FE.IS_IPTAL,
											FE.IS_PRINTED,
											FE.IS_SENT,
											FE.RECORD_DATE
										FROM 
											INVOICE_MULTI IM
											RIGHT JOIN INVOICE I ON I.INVOICE_MULTI_ID = IM.INVOICE_MULTI_ID
											RIGHT JOIN FILE_EXPORTS FE ON FE.E_ID = IM.HOBIM_ID
										WHERE 
											I.INVOICE_ID = #get_sale_det.invoice_id#
									</cfquery>
									<cfset kontrol_hobim = control_hobim.recordcount>
								</cfif>
								<cfif not len(isClosed('INVOICE',attributes.iid)) and (GET_SALE_DET.RELATED_ACTION_TABLE eq '' or not len(isClosed(GET_SALE_DET.RELATED_ACTION_TABLE,GET_SALE_DET.RELATED_ACTION_ID)))>
									<cfif get_sale_det.is_iptal eq 1 and session.ep.our_company_info.is_earchive eq 1>
									<b><font color="FF0000"><cf_get_lang dictionary_id="59833.Fatura İptal Edildi"> <cfif control_earchive.recordcount and control_earchive.is_cancel eq 0>(<cf_get_lang dictionary_id="59847.İptal Bilgisi E-Arşiv Sistemine Gönderilmedi">)</cfif></font></b>
								<cfelseif kontrol_prov eq 0>
									<cfif kontrol_hobim eq 0>
										<cfif isdefined("is_not_delete") and is_not_delete eq 1>
											<cf_workcube_buttons is_upd='1' is_delete=0 add_function='kontrol()' del_function='kontrol2()'>
										<cfelse>
											<cfif chk_send_arc.recordcount and chk_send_arc.count gt 0>
												<cf_workcube_buttons is_upd='1' is_delete=0 add_function='kontrol()' del_function='kontrol2()'>
											<cfelse>
												<cf_workcube_buttons is_upd='1' is_delete=1 add_function='kontrol()' del_function='kontrol2()'>
											</cfif>
										</cfif>
									<cfelse>
										<cfif control_hobim.is_iptal eq 1>
											<cfif chk_send_arc.recordcount and chk_send_arc.count gt 0>
												<cf_workcube_buttons is_upd='1' is_delete=0 add_function='kontrol()' del_function='kontrol2()'>
											<cfelse>
												<cf_workcube_buttons is_upd='1' is_delete=1 add_function='kontrol()' del_function='kontrol2()'>
											</cfif>
										<cfelseif control_hobim.is_printed eq 1>
											<font color="FF0000"><cf_get_lang dictionary_id="57092.Hobim ID"> : <cfoutput>#control_hobim.hobim_id#</cfoutput> / <cf_get_lang dictionary_id="57097.Basıldı"></font>&nbsp;&nbsp;
											<cf_workcube_buttons is_upd='1' is_delete=0 add_function='kontrol()' del_function='kontrol2()'>
										<cfelse>
											<font color="FF0000">
												<cf_get_lang dictionary_id="57092.Hobim ID"> : <cfoutput>#control_hobim.hobim_id#</cfoutput> / 
												<cfif control_hobim.is_printed eq 1><cf_get_lang dictionary_id="57097.Basıldı"><cfelseif control_hobim.is_sent eq 1><cf_get_lang dictionary_id="57096.Gönderildi"></cfif>
											</font>
										</cfif>
									</cfif>
								<cfelse>
									<font color="FF0000"><cf_get_lang dictionary_id="57040.Ödenmemiş Provizyon">. <cf_get_lang dictionary_id="59774.Sistem No"> : <cfoutput>#control_prov_rows.SUBSCRIPTION_NO#</cfoutput></font> 	
								</cfif>
								<cfelse>
									<font color="FF0000"><cf_get_lang dictionary_id='47262.Fatura kapama işlemi yapılan belgede değişiklik yapılamaz'>!</font>
								</cfif>     
							</cfif>
						</div>
					</cf_box_footer>
				</cf_basket_form>
				<cfif session.ep.isBranchAuthorization><!--- subeden cagırılıyorsa sube basket sablonunu kullansın--->
					<cfset attributes.basket_id = 18> 
				<cfelse>
					<cfset attributes.basket_id = 2>
				</cfif>
				<cfinclude template="../../objects/display/basket.cfm">
			</cfform>
		</div>
	</cf_box>
</div>
<script type="text/javascript">
	<cfif isdefined("is_einvoice_warning") and is_einvoice_warning eq 1>
		alert("<cf_get_lang dictionary_id='57116.Detayına Girmek İstediğiniz E-Fatura Gönderilmemiştir Lütfen Kontrol Ediniz!'>");
	<cfelseif isdefined("is_einvoice_warning_arc") and is_einvoice_warning_arc eq 1>
		alert("<cf_get_lang dictionary_id='59848.Detayına Girmek İstediğiniz E-Arşiv Fatura Gönderilmemiştir. Lütfen Kontrol Ediniz'>!");
	</cfif>
	function add_adress()
	{
		if(!(form_basket.company_id.value=="") || !(form_basket.consumer_id.value=="") || !(form_basket.employee_id.value==""))
		{
			if(form_basket.company_id.value!="")
			{
				str_adrlink = '&field_long_adres=form_basket.adres&field_adress_id=form_basket.ship_address_id';
				if(form_basket.city_id!=undefined) str_adrlink = str_adrlink+'&field_city=form_basket.city_id';
				if(form_basket.county_id!=undefined) str_adrlink = str_adrlink+'&field_county=form_basket.county_id'<cfif session.ep.isBranchAuthorization>+'&is_store_module='+1</cfif>;
				windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_member_address&is_comp=1&company_id='+encodeURIComponent(form_basket.company_id.value)+'&member_name='+encodeURIComponent(form_basket.comp_name.value)+'&keyword='+encodeURIComponent(form_basket.comp_name.value)+''+ str_adrlink , 'list');
				return true;
			}
			else
			{
				str_adrlink = '&field_long_adres=form_basket.adres&field_adress_id=form_basket.ship_address_id';
				if(form_basket.city_id!=undefined) str_adrlink = str_adrlink+'&field_city=form_basket.city_id';
				if(form_basket.county_id!=undefined) str_adrlink = str_adrlink+'&field_county=form_basket.county_id'<cfif session.ep.isBranchAuthorization>+'&is_store_module='+1</cfif>;
				windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_member_address&is_comp=0&company_id='+encodeURIComponent(form_basket.company_id.value)+'&member_name='+encodeURIComponent(form_basket.comp_name.value)+'&keyword='+encodeURIComponent(form_basket.partner_name.value)+''+ str_adrlink , 'list');
				return true;
			}
		}
		else
		{
			alert("<cf_get_lang dictionary_id='57183.Cari Hesap Seçmelisiniz'>");
			return false;
		}
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
			if(eval("form_basket.ct_process_type_" + deger).value == 62)
			{
				is_purchase = 1;
				is_return = 1;
			}
			else
			{
				is_purchase = 0;
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
		var irs_list='';
		if (form_basket.row_ship_id.length != undefined) 
			for (i=0; i < form_basket.row_ship_id.length; i++) {
				if(!list_find(irs_list,form_basket.row_ship_id[i].value,','))
					{
					if(i!=0)
						irs_list = irs_list + ',' ;
					irs_list = irs_list + form_basket.row_ship_id[i].value;
					}
			}
		else
			irs_list = irs_list + form_basket.row_ship_id.value;
	
		str_irslink = '&ship_id_liste=' + irs_list + '&id=sale_upd&sale_product=1&company_id='+form_basket.company_id.value+'&consumer_id='+ form_basket.consumer_id.value<cfif session.ep.isBranchAuthorization>+'&is_store='+1</cfif>;
		 <cfif session.ep.our_company_info.project_followup eq 1>
				if(form_basket.project_id.value!='' && form_basket.project_head.value!='')
					str_irslink = str_irslink+'&project_id='+form_basket.project_id.value;
			 </cfif>
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_choice_ship&ship_project_liste=1' + str_irslink , 'page');
		return true;
	}
	function check_invoice_type()
	{
		if(form_basket.company_id!=undefined && form_basket.company_id.value.length)
		{
			var get_member_control = wrk_safe_query('obj_get_company_efatura','dsn' , 0, form_basket.company_id.value);
		}
		else if(form_basket.consumer_id!=undefined && form_basket.consumer_id.value.length)
		{
			var get_member_control = wrk_safe_query('obj_get_consumer_efatura','dsn',0,form_basket.consumer_id.value);
		}
		if(get_member_control != undefined && get_member_control.USE_EFATURA == 1 && datediff(date_format(get_member_control.EFATURA_DATE),document.getElementById('invoice_date').value,0) >= 0)
			paper_type = 'E_INVOICE';
		else
			paper_type = 'INVOICE';
		<cfoutput>
			paper_control(form_basket.serial_no,paper_type,true,'#attributes.iid#','#get_sale_det.serial_no#','','','','','',form_basket.serial_number);
		</cfoutput>
	}
	function kontrol()
	{
		var chk_export_registered = wrk_safe_query("invoice_process_cat",'dsn3',0,$("#process_cat").val());
		
		if(chk_export_registered.IS_EXPORT_REGISTERED == 1) {
			var total_bsmv = 0;
			$( "[id='row_bsmv_amount']" ) .each(function(){
				if(filterNum($(this).val()) > 0) {
					total_bsmv = total_bsmv + filterNum($(this).val());
				}
			});

			if(total_bsmv > 0) {
				alert("<cf_get_lang dictionary_id='57181.İhraç kayıtlı faturada BSMV seçilemez'>!");
				return false;
			}
		}

        var get_is_no_sale=wrk_query("SELECT NO_SALE FROM STOCKS_LOCATION WHERE DEPARTMENT_ID ="+document.getElementById('department_id').value+" AND LOCATION_ID ="+document.getElementById('location_id').value,"dsn");
        if(get_is_no_sale.recordcount)
        {
            var is_sale_=get_is_no_sale.NO_SALE;
            if(is_sale_==1)
            {
                alert("<cf_get_lang dictionary_id='45400.Bu Lokasyondan Satış Yapılamaz'>.");
                return false;
            }
        }
		<cfif xml_show_ship_date eq 1>
			if (!date_check(form_basket.invoice_date,form_basket.ship_date,"<cf_get_lang dictionary_id='57119.Fiili Sevk Tarihi, Fatura Tarihinden Önce Olamaz!'>"))
				return false;
		</cfif>
		<cfif session.ep.our_company_info.is_efatura>
			var chk_efatura = wrk_safe_query("chk_efatura_count",'dsn2',0,'<cfoutput>#attributes.iid#</cfoutput>');
			if(chk_efatura.recordcount > 0)
			{
				<cfif xml_upd_einvoice eq 0 and isdefined("chk_send_inv") and chk_send_inv.count>
					<!---XML'den Gönderilen E-Faturalar Güncellenebilsin 'hayır' olarak seçildiğinde güncellenememesi istenilmiştir. 
					if(document.getElementById('fatura_iptal') != undefined && document.getElementById('fatura_iptal').checked == false)
					{
						alert("<cf_get_lang no='96.e-Faturası Oluşturulmuş Faturayı Güncelleyemezsiniz!'>");
						return false;
					}
					else
					{
						if(confirm("<cf_get_lang no='98.e-Faturası Oluşturulmuş Faturayı Güncellemek İstiyor musunuz!'>") == true);
						else
						return false;
					}----->
					alert("<cf_get_lang dictionary_id='57098.e-Faturası Oluşturulmuş Faturayı Güncelleyemezsiniz!'>");
					return false;
				<cfelse>	
					if(confirm("<cf_get_lang dictionary_id='57100.e-Faturası Oluşturulmuş Faturayı Güncellemek İstiyor musunuz!'>") == true);
					else
					return false;
				</cfif>
			}
		</cfif>
		<cfif session.ep.our_company_info.is_earchive>
			var chk_efatura = wrk_safe_query("chk_earchive_count",'dsn2',0,'<cfoutput>#attributes.iid#</cfoutput>');
			if(chk_efatura.recordcount > 0)
			{
				<cfif xml_upd_earchive eq 0>
					{
						alert("<cf_get_lang dictionary_id='59849.e-Arşiv Faturası Oluşturulmuş Faturayı Güncelleyemezsiniz'> !");
						return false;
					}
				<cfelse>	
					if(confirm("<cf_get_lang dictionary_id='59850.e-Arşiv Faturası Oluşturulmuş Faturayı Güncellemek İstiyor musunuz'> !") == true);
					else
					return false;
				</cfif>
			}
		</cfif>
		<cfif get_with_ship.is_with_ship neq 1> 
			if(form_basket.order_id_listesi.value!='' && list_getat(form_basket.irsaliye_id_listesi.value,1,';') != '')
			{
				alert("<cf_get_lang dictionary_id='57101.İrsaliye ve Sipariş Aynı Anda Seçilemez. Lütfen Seçimlerinizi Kontrol Ediniz!'>");
				return false;
			}
		</cfif>
		//Odeme Plani Guncelleme Kontrolleri
		//Eger bankaya gonderilmis herhangi bir odeme plani satiri varsa odeme planinin yeniden olusturulmasi soz konusu olamaz
		var listParams_ = "<cfoutput>#attributes.iid#</cfoutput>";
		var payment_plan_is_bank = wrk_safe_query("get_inv_payment_plan_bank",'dsn3',0,listParams_);
		var temp_process_cat = document.form_basket.process_cat.options[document.form_basket.process_cat.selectedIndex].value;
	
		if (payment_plan_is_bank.recordcount > 0)
		{
			document.form_basket.invoice_payment_plan.value = 0;
		}
		else
		{
			if (document.getElementById('invoice_cari_action_type').value == 5 && document.getElementById('old_pay_method').value != "")
			{
				if (confirm("<cf_get_lang dictionary_id='29460.Güncellediğiniz Belgenin Ödeme Planı Yeniden Oluşturulacaktır'>!"))
					document.form_basket.invoice_payment_plan.value = 1;
				else
				{
					document.form_basket.invoice_payment_plan.value = 0;
					<cfif xml_control_payment_plan_status eq 1>
						return false;
					</cfif>
				}
			}
		}
		if (document.getElementById('fatura_iptal') != undefined && document.getElementById('fatura_iptal').checked == false && document.form_basket.invoice_payment_plan.value == 0)
		{
			var listParam = "<cfoutput>#attributes.iid#</cfoutput>" + "*" + "<cfoutput>#session.ep.period_id#</cfoutput>" ;
			var payment_plan_info = wrk_safe_query("inv_payment_plan",'dsn3',0,listParam);
			if(payment_plan_info.recordcount)
			{
				if((document.form_basket.old_pay_method.value != document.form_basket.paymethod_id.value) || document.form_basket.old_net_total.value != wrk_round(document.all.basket_net_total.value,window.basket.hidden_values.basket_total_round_number_) || (payment_plan_info.COMPANY_ID != '' && payment_plan_info.COMPANY_ID != document.form_basket.company_id.value) || (eval("document.form_basket.ct_process_type_" + temp_process_cat) != undefined && form_basket.old_process_type.value != eval("document.form_basket.ct_process_type_" + temp_process_cat).value))
				{
					alert("<cf_get_lang dictionary_id='57103.Ödeme Planı Girilen Belgenin Tutarı,Carisi,Ödeme Yöntemi veya İşlem Tipi Değiştirilemez !'>");
					return false;
				}
			}
		}
		else if(document.getElementById('fatura_iptal') != undefined && document.getElementById('fatura_iptal').checked == true)
		{
			if(payment_plan_is_bank.recordcount > 0)
				alert("<cf_get_lang dictionary_id='57105.Bankaya Gönderilen Ödeme Planı Satırları İptal Edilecektir !'>");
		}
		if(form_basket.company_id!=undefined && form_basket.company_id.value.length)
		{
			var get_member_control = wrk_safe_query('obj_get_company_efatura','dsn' , 0, form_basket.company_id.value);
		}
		else if(form_basket.consumer_id!=undefined && form_basket.consumer_id.value.length)
		{
			var get_member_control = wrk_safe_query('obj_get_consumer_efatura','dsn',0,form_basket.consumer_id.value);
		}
		if(get_member_control != undefined && get_member_control.USE_EFATURA == 1 && datediff(date_format(get_member_control.EFATURA_DATE),document.getElementById('invoice_date').value,0) >= 0)
			paper_type = 'E_INVOICE';
		else
			paper_type = 'INVOICE';
		if(!paper_control(document.form_basket.serial_no,paper_type,true,<cfoutput>'#attributes.iid#','#get_sale_det.serial_no#'</cfoutput>,'','','','','',form_basket.serial_number)) return false;
	
		//sm tutar kısmını kapattı her durumda kontrol edilmeli 20130411
		//Butce Dagilim Kontrolu
		if(document.form_basket.is_cost.value == 1)
			if(confirm("<cf_get_lang dictionary_id ='57271.Güncellediğiniz Faturanın Masraf- Gelir Dağıtımı Yapılmış Devam Ederseniz Bu Dağıtım Silinecektir'>!"))
				document.form_basket.is_cost.value = 0;
			else
			{
				//document.form_basket.is_cost.value = 1;
				return false;
			}
	

		if (!chk_process_cat('form_basket')) return false;
		<cfif isdefined('xml_acc_department_info') and xml_acc_department_info eq 2>//xmlde muhasebe icin departman secimi zorunlu ise
			if( document.form_basket.acc_department_id.options[document.form_basket.acc_department_id.selectedIndex].value=='')
			{
				alert("<cf_get_lang dictionary_id='58836.Lutfen Departman Seciniz'>");
				return false;
			} 
		</cfif>
		if (!check_display_files('form_basket')) return false;
		if (!chk_period(form_basket.invoice_date,"İşlem")) return false;
		if (!check_accounts('form_basket')) return false;
		<cfif session.ep.our_company_info.project_followup eq 1 and isdefined("xml_upd_row_project") and xml_upd_row_project eq 1>
			apply_deliver_date('','project_head','');
		</cfif>
		if(form_basket.department_id.value=="")
			{
			alert("<cf_get_lang dictionary_id='57208.Departman Seçiniz'>!");
			return false;
			}
		if(form_basket.location_id.value=="")
			{
				alert("<cf_get_lang dictionary_id='59851.Lokasyon Seçiniz'>!");
				return false;
			}
		<cfif xml_paymethod_control>
			if(form_basket.paymethod.value == '' && form_basket.paymethod_id.value == '' || form_basket.paymethod.value == '' && form_basket.card_paymethod_id.value == '')
			{
				alert("<cf_get_lang dictionary_id='58027.Lütfen Ödeme Yöntemi Seçiniz'>!");
				return false;	
			}
		</cfif>
		
		<cfif xml_shipmethod_control>
			if(form_basket.ship_method.value == '' && form_basket.ship_method_name.value == '')
			{
				alert("<cf_get_lang dictionary_id='35327.Lütfen Sevk Yöntemi Seçiniz'>!");
				return false;	
			}
		</cfif>
		if(!check_product_accounts()) return false;
		

		<cfif get_sale_det.is_iptal neq 1>
			if(check_stock_action('form_basket')) //islem kategorisi stok hareketi yapıyorsa
			{
				var fis_no = eval("document.form_basket.ct_process_type_" + temp_process_cat);
				var basket_zero_stock_status = wrk_safe_query('inv_basket_zero_stock_status','dsn3',0,<cfoutput>#attributes.basket_id#</cfoutput>);
				if(basket_zero_stock_status.IS_SELECTED != 1)
				{
					if(!zero_stock_control(form_basket.department_id.value,form_basket.location_id.value,form_basket.irsaliye_id_listesi.value,fis_no.value)) return false;
				}
			}
		</cfif>
		if (!kontrol_ithalat()) return false;
		change_paper_duedate('invoice_date');	
		<cfif not get_module_power_user(20)>
			var listParam = "<cfoutput>#attributes.iid#</cfoutput>" + "*" + form_basket.old_process_type.value ;
			var closed_info = wrk_safe_query("inv_closed_info",'dsn2',0,listParam);
			if(closed_info.recordcount)
				//process_info.IS_PAYMETHOD_BASED_CARI == 1 &&  kaldirildi fbs20110420 bu secili olmasa da islem yapilmamasi gerekiyor
				if((document.form_basket.old_pay_method.value != document.form_basket.paymethod_id.value) || document.form_basket.old_net_total.value != wrk_round(document.all.basket_net_total.value,window.basket.hidden_values.basket_total_round_number_) || (closed_info.COMPANY_ID != '' && closed_info.COMPANY_ID != form_basket.company_id.value) || (closed_info.CONSUMER_ID != '' && closed_info.CONSUMER_ID != form_basket.consumer_id.value) || (form_basket.old_process_type.value != eval("document.form_basket.ct_process_type_" + temp_process_cat).value))
				{
					alert("<cf_get_lang dictionary_id='57106.Belge Kapama,Talep veya Emir Girilen Belgenin Tutarı,Carisi,Ödeme Yöntemi veya İşlem Tipi Değiştirilemez !'>");
					return false;
				}
		</cfif>
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
						if( basketManagerObject.basketItems()[str].product_id() != '' && list_getat( basketManagerObject.basketItems()[str].row_ship_id(),1,';') != 0){
							if( basketManagerObject.basketItems()[str].product_id() != '' && basketManagerObject.basketItems()[str].wrk_row_relation_id() == ''){
								ship_row_list = ship_row_list + eval(str+1) + '.Satır : ' + basketManagerObject.basketItems()[str].product_name() + '\n';
							}
						}
					}
				}else{
					for(var str=0; str < window.basket.items.length; str++){
						if(window.basket.items[str].PRODUCT_ID != '' && list_getat(window.basket.items[str].ROW_SHIP_ID,1,';') != 0){
							if(window.basket.items[str].PRODUCT_ID != '' && window.basket.items[str].WRK_ROW_RELATION_ID == ''){
								ship_row_list = ship_row_list + eval(str+1) + '.Satır : ' + window.basket.items[str].PRODUCT_NAME + '\n';
							}
						}
					}
				}
			
				if(ship_row_list != ''){
					alert("<cf_get_lang dictionary_id='59792.Aşağıda Belirtilen Ürünler İlişkili İrsaliye Dışında Eklenmiştir'> ! <cf_get_lang dictionary_id='59793.Lütfen Ürünleri Kontrol Ediniz'> ! \n\n" + ship_row_list);
					return false;
				}
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
									alert("<cf_get_lang dictionary_id='57110.Fatura Tarihi İrsaliye Tarihinden Önce Olamaz!'>");
									return false;
								}
						}
				}
		</cfif>
		// xml de proje kontrolleri yapılsın seçilmişse
		<cfif xml_control_ship_project eq 1 and session.ep.our_company_info.project_followup eq 1>
			var irsaliye_deger_list = document.form_basket.irsaliye_project_id_listesi.value;
			if(irsaliye_deger_list != '')
				{
					var liste_uzunlugu = list_len(irsaliye_deger_list);
					for(var str_i_row=1; str_i_row <= liste_uzunlugu; str_i_row++)
						{
							var project_id_ = list_getat(irsaliye_deger_list,str_i_row,',');
							if(document.form_basket.project_id.value != '' && document.form_basket.project_head.value != '')
								var sonuc_ = document.form_basket.project_id.value;
							else
								var sonuc_ = 0;
							if(project_id_ != sonuc_)
								{
									alert("<cf_get_lang dictionary_id='57113.İlgili Faturaya Bağlı İrsaliyelerin Projeleri İle Faturada Seçilen Proje Aynı Olmalıdır!'>");
									return false;
								}
						}
				}
		</cfif>
		<cfif isdefined("xml_show_process_stage") and len(xml_show_process_stage) and xml_show_process_stage eq 1>
			return (control_account_process(<cfoutput>'#attributes.iid#','#get_sale_det.invoice_cat#'</cfoutput>) && process_cat_control() && saveForm());
		<cfelse>
			return (control_account_process(<cfoutput>'#attributes.iid#','#get_sale_det.invoice_cat#'</cfoutput>) && saveForm());
		</cfif>
	}
	function kontrol2()
	{
		if (!chk_process_cat('form_basket')) return false;
		if (!check_display_files('form_basket')) return false;
		if (!chk_period(form_basket.invoice_date,"İşlem")) return false;
		var listParam = "<cfoutput>#attributes.iid#</cfoutput>" + "*" + form_basket.old_process_type.value ;
		<cfif not get_module_power_user(20)>
			var closed_info = wrk_safe_query("inv_closed_info_2",'dsn2',0,listParam);
			if(closed_info.recordcount)
			{
				alert("<cf_get_lang dictionary_id='59852.Faturayla İlişkili Ödeme Talebi Olduğu İçin Silinemez'> ! <cf_get_lang dictionary_id='30828.Talep'> <cf_get_lang dictionary_id='58527.ID'> :"+closed_info.CLOSED_ID);
				return false;
			}
		</cfif>
		<cfif session.ep.our_company_info.is_efatura>
			var chk_efatura = wrk_safe_query("chk_efatura_count",'dsn2',0,'<cfoutput>#attributes.iid#</cfoutput>');
			if(chk_efatura.recordcount > 0)
			{
				alert("<cf_get_lang dictionary_id='57114.Fatura ile İlişkili e-Fatura Olduğu için Silinemez !'>");
				return false;
			}
		</cfif>
		form_basket.del_invoice_id.value = <cfoutput>#attributes.iid#</cfoutput>;
		return (control_account_process(<cfoutput>'#attributes.iid#','#get_sale_det.invoice_cat#'</cfoutput>) && saveForm()); 
	}
	
	function kontrol_ithalat()
	{
		deger = form_basket.process_cat.options[form_basket.process_cat.selectedIndex].value;
		sistem_para_birimi = "<cfoutput>#SESSION.EP.MONEY#</cfoutput>";	
		if(deger != "")
		{
			var fis_no = eval("form_basket.ct_process_type_" + deger);
			//kdvden muaf satis faturasi : 533
			if(list_find('531,533',fis_no.value))
			{
				$(document).ready(function()
				{
					reset_basket_kdv_rates() && reset_basket_otv_rates();
					 //kdv oranları sıfırlanıyor dsp_basket_js_scripts te tanımlı
				});
			}
		}
		return true;
	}
	function kontrol_yurtdisi()
	{
		deger = form_basket.process_cat.options[form_basket.process_cat.selectedIndex].value;
		if(deger != "")
		{
			var fis_no = eval("form_basket.ct_process_type_" + deger);
			if(list_find('531,533',fis_no.value))
			{
				<cfif xml_show_cash_checkbox eq 1>
					kasa_sec.style.display = 'none';
					not.style.display = 'none';
					form_basket.cash.checked=false;
				</cfif>
				$("#item-realization_date").show();
					$(document).ready(function()
						{
							reset_basket_kdv_rates() && reset_basket_otv_rates();
							 //kdv oranları sıfırlanıyor dsp_basket_js_scripts te tanımlı
						});
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
					alert("<cf_get_lang dictionary_id='59794.Fatura Tarihi Değiştirildiğinden İntaç Tarihi Tekrar Seçilmelidir'>");
					$("#realization_date").val('');
				}
			}
		
	}

	function find_invoice_f()
	{
		if($("#find_invoice_number").val().length)
		{
			var get_invoice = wrk_safe_query('sls_get_fatura','dsn2',0,$("#find_invoice_number").val());
			if(get_invoice.recordcount)
				window.location.href = '<cfoutput>#request.self#?fuseaction=invoice.form_add_bill&event=upd&iid=</cfoutput>'+get_invoice.INVOICE_ID[0];
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

	function check_process_is_sale(){/*alım iadeleri satis karakterli oldugu halde alış fiyatları ile çalışması için*/
		<cfif get_basket.basket_id is 2>
			var selected_ptype = document.form_basket.process_cat.options[document.form_basket.process_cat.selectedIndex].value;
			if(selected_ptype!='')
				{
				eval('var proc_control = document.form_basket.ct_process_type_'+selected_ptype+'.value');
				if(proc_control == 62)
					sale_product = 0;
				else
					sale_product = 1;
				}
			else
				return true;
		<cfelse>
			return true;
		</cfif>
	}
	kontrol_yurtdisi();
	check_process_is_sale();
	change_paper_duedate('invoice_date');
	function openVoucher()
	{
	openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_payment_with_voucher&is_purchase_=0&payment_process_id=<cfoutput>#attributes.iid#</cfoutput>&inv_order_id=<cfoutput>#get_order.ORDER_ID#</cfoutput>&str_table=INVOICE&rate_round_num='+window.basket.hidden_values.basket_rate_round_number_+'&round_number='+window.basket.hidden_values.basket_total_round_number_+'&branch_id='+document.form_basket.branch_id.value);		
	}
	</script>
</cfif>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
