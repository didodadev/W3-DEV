<cf_get_lang_set module_name="invoice"> 
<cf_xml_page_edit fuseact="invoice.detail_invoice_purchase">
<cfparam name="kontrol_update" default=0>
<cfif isnumeric(attributes.iid)>
	<cfinclude template="../query/get_purchase_det.cfm">
<cfelse>
	<cfset get_sale_det.recordcount = 0>
</cfif>
<cfif not get_sale_det.recordcount>
	<cfset hata  = 11>
	<cfsavecontent variable="message"><cf_get_lang dictionary_id='57997.Şube Yetkiniz Uygun Değil'> <cf_get_lang dictionary_id='57998.Veya'>  <cf_get_lang dictionary_id='57999.Çalıştığınız Muhasebe Dönemine Ait Böyle Bir Fatura Bulunamadı'> !</cfsavecontent>
	<cfset hata_mesaj  = message>
	<cfinclude template="../../dsp_hata.cfm">
<cfelse>
	<cfif session.ep.isBranchAuthorization>
	<!--- subeden cagırılıyorsa alıs faturası sube basket sablonunu kullansın--->
		<cfset attributes.basket_id = 20> 
	<cfelse>
		<cfset attributes.basket_id = 1>
	</cfif>
	<cfinclude template="../query/get_session_cash_all.cfm">
	<cfinclude template="../query/get_inv_cancel_types.cfm">
	<cfparam name="attributes.company_id" default="#get_sale_det.company_id#">
	<cfscript>session_basket_kur_ekle(action_id=attributes.iid,table_type_id:1,process_type:1);</cfscript>
	<cfparam name="attributes.invoice_number" default="#get_sale_det.invoice_number#">
    <cfif IsDefined("Get_Sale_Det.Is_Rate_Extra_Cost") and Get_Sale_Det.Is_Rate_Extra_Cost eq 1><!---SatınAlma Siparişinden Fatura kesildiğinde Maliyet satırları yansımasın--->
        <cfparam name="attributes.is_rate_extra_cost_to_incoice" default="#get_sale_det.is_rate_extra_cost#">
	</cfif>
	
<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box>
		<div id="basket_main_div">
			<cfform name="form_basket" method="post" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_upd_bill_purchase">
				<cf_basket_form id="upd_purchase">
					<input type="hidden" name="form_action_address" id="form_action_address" value="<cfoutput>#listgetat(attributes.fuseaction,1,'.')#.emptypopup_upd_bill_purchase</cfoutput>">			
					<input type="hidden" name="control_ship_date" id="control_ship_date" value="<cfoutput>#dateformat(get_sale_det.invoice_date,dateformat_style)#</cfoutput>">
					<input type="hidden" name="search_process_date" id="search_process_date" value="invoice_date">
					<input type="hidden" name="del_invoice_id" id="del_invoice_id" value="0">
					<input type="hidden" name="old_net_total" id="old_net_total" value="<cfoutput>#GET_SALE_DET.NETTOTAL#</cfoutput>">
					<input type="hidden" name="old_pay_method" id="old_pay_method" value="<cfoutput>#GET_SALE_DET.PAY_METHOD#</cfoutput>">
					<input type="hidden" name="is_cost" id="is_cost" value="<cfif get_sale_det.is_cost eq 1>1<cfelse>0</cfif>">
					<cfoutput>
						<input type="hidden" name="invoice_id" id="invoice_id" value="#attributes.iid#">
						<input type="hidden" name="active_period" id="active_period" value="#session.ep.period_id#">
						<input type="hidden" name="order_id" id="order_id" value="<cfif get_sale_det.recordcount>#get_order.ORDER_ID#</cfif>">
						<input type="hidden" name="siparis_date_listesi" id="siparis_date_listesi" value="<cfif get_sale_det.recordcount>#dateformat(get_order.ORDER_DATE,dateformat_style)#</cfif>">
						<input type="hidden" name="order_number" id="order_number" value="<cfif get_sale_det.recordcount>#get_order.ORDER_NUMBER#</cfif>">
						<input type="hidden" name="invoice_cari_action_type" id="invoice_cari_action_type" value="<cfif len(GET_SALE_DET.CARI_ACTION_TYPE)>#GET_SALE_DET.CARI_ACTION_TYPE#</cfif>">
						<input type="hidden" name="invoice_payment_plan" id="invoice_payment_plan" value="1">
						<cfquery name="get_contract_comp" datasource="#dsn2#">
							SELECT RELATED_ACTION_ID FROM INVOICE_ROW WHERE INVOICE_ID = #attributes.iid# AND RELATED_ACTION_TABLE = 'INVOICE_CONTRACT_COMPARISON'
						</cfquery>
						<input type="hidden" name="contract_row_ids" id="contract_row_ids" value="#valuelist(get_contract_comp.related_action_id)#">
						<input type="hidden" name="xml_get_branch_from_department" value="#xml_get_branch_from_department#">
					</cfoutput>
					<cfif len(get_sale_det.company_id)>
						<cfset member_account_code = get_company_period(get_sale_det.company_id)>
					<cfelseif len(get_sale_det.consumer_id)>
						<cfset member_account_code = get_consumer_period(get_sale_det.consumer_id)>
					<cfelse>
						<cfif len(get_sale_det.acc_type_id)>
							<cfset member_account_code = get_employee_period(get_sale_det.employee_id,get_sale_det.acc_type_id)>
						<cfelse>
							<cfset member_account_code = get_employee_period(get_sale_det.employee_id)>
						</cfif>	
					</cfif>
					<input type="hidden" name="member_account_code" id="member_account_code" value="<cfoutput>#member_account_code#</cfoutput>">
					<cf_box_elements>
						<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
							<div class="form-group" id="item">
								<div class="col col-12 col-xs-12">
									<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='59328.E-Archive'></label>
									<div class="col col-8 col-xs-12">
										<input type="checkbox" name="is_earchive" id="is_earchive" <cfif isdefined("get_sale_det") and get_sale_det.is_earchive eq 1>checked</cfif>>
									</div>
								</div>
							</div>
							<div class="form-group" id="item-process_cat">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57800.işlem tipi'> *</label>
								<div class="col col-8 col-xs-12">
									<cf_workcube_process_cat slct_width="140" onclick_function="kontrol_yurtdisi();check_process_is_sale();" process_cat="#get_sale_det.process_cat#">
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
											<cfelseif len(get_sale_det.consumer_id) and get_sale_det.consumer_id neq 0>
												<input type="text" name="comp_name" id="comp_name" value="#get_cons_name.company#" readonly style="width:140px;">
											<cfelse>
												<input type="text" name="comp_name" id="comp_name" value="" readonly style="width:140px;">
											</cfif>
										</cfoutput>
										<cfset str_linkeait="&field_comp_id=form_basket.company_id&field_consumer=form_basket.consumer_id&come=invoice&field_member_account_code=form_basket.member_account_code&field_paymethod_id=form_basket.paymethod_id&field_paymethod=form_basket.paymethod&field_basket_due_value=form_basket.basket_due_value&field_card_payment_id=form_basket.card_paymethod_id&field_city_id=form_basket.ship_address_city_id&field_county_id=form_basket.ship_address_county_id&field_comp_id2=form_basket.deliver_comp_id&field_consumer2=form_basket.deliver_cons_id&field_adress_id=form_basket.ship_address_id&field_long_address=form_basket.ship_address&call_function=change_paper_duedate()">
										<span class="input-group-addon btnPointer icon-ellipsis" title="<cf_get_lang dictionary_id='57734.seçiniz'>" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_pars&is_cari_action=1&select_list=2,3,1,9&field_name=form_basket.partner_name&field_emp_id=form_basket.employee_id&field_partner=form_basket.partner_id&field_comp_name=form_basket.comp_name#str_linkeait#&ship_method_id=form_basket.ship_method&ship_method_name=form_basket.ship_method_name&is_potansiyel=0&field_cons_ref_code=form_basket.consumer_reference_code<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif></cfoutput>')"></span>
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
										<input type="hidden" name="consumer_reference_code" id="consumer_reference_code" value="#get_sale_det.consumer_reference_code#">
										<input type="hidden" name="partner_id" id="partner_id" value="#get_sale_det.partner_id#">
										<input type="hidden" name="consumer_id" id="consumer_id" value="#get_sale_det.consumer_id#">
										<input type="hidden" name="employee_id" id="employee_id" value="#emp_id#">
										<cfif len(GET_SALE_DET.PARTNER_ID) and isnumeric(GET_SALE_DET.PARTNER_ID)>
											<input type="text" name="partner_name" id="partner_name" value="#GET_SALE_DET_CONS.COMPANY_PARTNER_NAME# #GET_SALE_DET_CONS.COMPANY_PARTNER_SURNAME#" readonly style="width:140px;">
										<cfelseif len(GET_SALE_DET.consumer_id) and isnumeric(GET_SALE_DET.consumer_id) >
											<input type="text" name="partner_name" id="partner_name" value="#get_cons_name.consumer_name# #get_cons_name.consumer_surname#" readonly style="width:140px;">
										<cfelseif len(GET_SALE_DET.employee_id) and isnumeric(GET_SALE_DET.employee_id) >
											<input type="text" name="partner_name" id="partner_name" value="#get_emp_info(GET_SALE_DET.employee_id,0,0,0,get_sale_det.acc_type_id)#" readonly style="width:140px;">
										<cfelse>
											<input type="text" name="partner_name" id="partner_name" value="" readonly style="width:140px;">							
										</cfif>
									</cfoutput>							
								</div>
							</div>
							<div class="form-group" id="item-irsaliye">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57773.İrsaliye'></label>
								<div class="col col-8 col-xs-12">
									<div <cfif get_with_ship.is_with_ship neq 1>class="input-group"</cfif>>
										<input type="hidden" name="irsaliye_date_listesi" id="irsaliye_date_listesi" value="<cfoutput>#ship_date_without_period#</cfoutput>">
										<input type="hidden" name="irsaliye_id_listesi" id="irsaliye_id_listesi" value="<cfoutput>#ship_id_with_period#</cfoutput>">
										<input type="text" name="irsaliye" id="irsaliye" style="width:140px;" value="<cfoutput>#ValueList(GET_WITH_SHIP_ALL.SHIP_NUMBER)#</cfoutput>" readonly>
										<cfif get_with_ship.is_with_ship neq 1><span class="input-group-addon btnPointer icon-ellipsis" onclick="add_irsaliye();"></span></cfif>
									</div>
								</div>
							</div>
							<div class="form-group" id="item-deliver_get">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57775.Teslim Alan'> *</label>
								<div class="col col-8 col-xs-12">
									<div class="input-group">
										<cfif len(get_sale_det.deliver_emp) and isnumeric(get_sale_det.deliver_emp)>
											<cfset str_del_name=get_emp_info(get_sale_det.deliver_emp,0,0)>
										<cfelse>
											<cfset str_del_name="">
										</cfif>	
										<cfoutput>
											<input type="hidden" name="deliver_get_id" id="deliver_get_id"  value="<cfif isnumeric(get_sale_det.deliver_emp)>#get_sale_det.deliver_emp#</cfif>">
											<input type="text" name="deliver_get" id="deliver_get" value="<cfif len(get_sale_det.deliver_emp)>#str_del_name#</cfif>"  style="width:140px;" onfocus="AutoComplete_Create('deliver_get','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','deliver_get_id','','3','135');" autocomplete="off">
										</cfoutput>
										<span class="input-group-addon btnPointer icon-ellipsis" title="<cf_get_lang dictionary_id='57734.seçiniz'>" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&select_list=1&field_name=form_basket.deliver_get&field_emp_id2=form_basket.deliver_get_id</cfoutput>');"></span>
									</div>
								</div>
							</div>
							<cfif session.ep.our_company_info.subscription_contract eq 1>
								<div class="form-group" id="item-subscription_id">
									<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='29502.Abone No'></label>
									<div class="col col-8 col-xs-12">
										<cfif isdefined("get_sale_det.subscription_id") and len(get_sale_det.subscription_id)>
											<cfif xml_upd_subscription eq 1>
												<cf_wrk_subscriptions width_info='140' subscription_id='#get_sale_det.subscription_id#'  fieldid='subscription_id' fieldname='subscription_no' form_name='form_basket' img_info='plus_thin' is_upd="1">
											<cfelse>
												<cf_wrk_subscriptions width_info='140' subscription_id='#get_sale_det.subscription_id#'  fieldid='subscription_id' fieldname='subscription_no' form_name='form_basket' img_info='plus_thin'>
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
										<cf_workcube_process is_upd='0' select_value='#get_sale_det.process_stage#' process_cat_width='150' is_detail='1'>
									</div>
								</div>
							</cfif>
							<div class="form-group" id="item-serial_number">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57637.Seri No'></label>
								<div class="col col-8 col-xs-12">
									<div class="input-group">
										<cfsavecontent variable="message"><cf_get_lang dictionary_id='57184.Fatura No Girmelisiniz !'></cfsavecontent>
										<cfinput type="text" name="serial_number" maxlength="5" value="#get_sale_det.serial_number#">
										<span class="input-group-addon no-bg"> - </span>
										<cfsavecontent variable="message"><cf_get_lang dictionary_id='57184.Fatura No Girmelisiniz !'></cfsavecontent>
										<cfinput type="text" name="serial_no" maxlength="50" style="margin-bottom:5px" value="#get_sale_det.serial_no#" required="Yes" message="#message#" onBlur="paper_control(this,'INVOICE',false,#attributes.iid#,'#get_sale_det.serial_no#',form_basket.company_id.value,form_basket.consumer_id.value,'','',1,form_basket.serial_number);" >
									</div>
								</div>
							</div>
							<div class="form-group" id="item-invoice_date">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58759.Fatura Tarihi'> *</label>
								<div class="col col-8 col-xs-12">
									<div class="input-group">
										<cfsavecontent variable="message"><cf_get_lang dictionary_id='57185.Fatura Tarihi Girmelisiniz'> !</cfsavecontent>
										<cfinput type="text" name="invoice_date" style="width:65px;" required="Yes" message="#message#" value="#dateformat(get_sale_det.invoice_date,dateformat_style)#" validate="#validate_style#" readonly="readonly">
										<span class="input-group-addon btnPointer" title="<cf_get_lang dictionary_id='57734.seçiniz'>"><cf_wrk_date_image date_field="invoice_date" id="invoice_date_image" call_function="change_money_info&rate_control&changeProcessDate" control_date="#dateformat(get_sale_det.invoice_date,dateformat_style)#"></span>
									</div>
								</div>
							</div>
							<div class="form-group" id="item-process_date">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57879.İşlem Tarihi'> *</label>
								<div class="col col-8 col-xs-12">
									<div class="input-group">
										<cfif not len(get_sale_det.process_date)>
											<cfset p_date = get_sale_det.invoice_date>
										<cfelse>
											<cfset p_date = get_sale_det.process_date>
										</cfif>
										<cfsavecontent variable="message"><cf_get_lang dictionary_id='57906.İşlem Tarihi Girmelisiniz'> !</cfsavecontent>
										<cfinput type="text" name="process_date" style="width:65px;" required="Yes" message="#message#" value="#dateformat(p_date,dateformat_style)#" validate="#validate_style#" readonly="readonly">
										<span class="input-group-addon btnPointer" title="<cf_get_lang dictionary_id='57734.seçiniz'>"><cf_wrk_date_image date_field="process_date" id="process_date_image" control_date="#dateformat(p_date,dateformat_style)#"></span>
									</div>
								</div>
							</div>
							<div class="form-group" id="item-realization_date" style="display:none;">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="57167.İntaç Tarihi"></label>
								<div class="col col-8 col-xs-12">
									<div class="input-group">
										<cfinput type="text" name="realization_date" id="realization_date" value="#dateformat(get_sale_det.realization_date,dateformat_style)#"  onblur="rate_control('2');" onChange="check_member_price_cat();" validate="#validate_style#" maxlength="10">
										<span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="realization_date" call_function="change_money_info"></span>
									</div>
								</div>
							</div>
							<div class="form-group" id="item-ref_no">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58784.Referans'></label>
								<div class="col col-8 col-xs-12">
									<input type="text" name="ref_no" id="ref_no" maxlength="500" value="<cfif len(get_sale_det.ref_no)><cfoutput>#get_sale_det.ref_no#</cfoutput></cfif>" style="width:135px;">	
								</div>
							</div>
							<div class="form-group" id="item-PARTNER_NAMEO">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='30011.Satın Alan'></label>
								<div class="col col-8 col-xs-12">
									<div class="input-group">
										<cfif get_sale_det.sale_emp eq "" and get_sale_det.sale_partner eq "">
											<input type="hidden" name="EMPO_ID" id="EMPO_ID">
											<input type="hidden" name="PARTO_ID" id="PARTO_ID">
											<input type="text" name="PARTNER_NAMEO" id="PARTNER_NAMEO" value="" style="width:135px;" onfocus="AutoComplete_Create('PARTNER_NAMEO','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_PARTNER_NAME2,MEMBER_NAME2','get_member_autocomplete','\'1,3\',0,0','EMPLOYEE_ID,PARTNER_CODE','EMPO_ID,PARTO_ID','','3','250');" autocomplete="off">
											<span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&is_rate_select=1&select_list=1,2&field_name=form_basket.PARTNER_NAMEO&field_id=form_basket.PARTO_ID&field_EMP_id=form_basket.EMPO_ID</cfoutput>');"></span>
										<cfelse>
											<cfoutput>
												<input type="hidden" name="EMPO_ID" id="EMPO_ID" value="#get_sale_det.sale_emp#">
												<input type="hidden" name="PARTO_ID" id="PARTO_ID" value="#get_sale_det.sale_partner#">
											</cfoutput>
											<input type="text" name="PARTNER_NAMEO" id="PARTNER_NAMEO" <cfif len(get_sale_det.sale_partner)>value="<cfoutput>#get_par_info(get_sale_det.sale_partner,0,0,0)#</cfoutput>"<cfelse>value="<cfoutput>#get_emp_info(get_sale_det.sale_emp,0,0)#</cfoutput>"</cfif> style="width:135px;" onfocus="AutoComplete_Create('PARTNER_NAMEO','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_PARTNER_NAME2,MEMBER_NAME2','get_member_autocomplete','\'1,3\',0,0','EMPLOYEE_ID,PARTNER_CODE','EMPO_ID,PARTO_ID','','3','250');" autocomplete="off">
											<span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_name=form_basket.PARTNER_NAMEO&field_id=form_basket.PARTO_ID&field_EMP_id=form_basket.EMPO_ID&select_list=1,2</cfoutput>')"></span>
										</cfif>						
									</div>
								</div>
							</div>
							<cfif session.ep.our_company_info.project_followup eq 1>
								<div class="form-group" id="item-Proje">
									<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57416.Proje'></label>
									<div class="col col-8 col-xs-12">
										<div class="input-group">
											<cfoutput>
												<input type="hidden" name="project_id" id="project_id" value="#get_sale_det.project_id#"> 
												<input type="text" name="project_head" id="project_head" style="width:135px;" value="<cfif len(get_sale_det.project_id)>#GET_PROJECT_NAME(get_sale_det.project_id)#</cfif>"  onfocus="AutoComplete_Create('project_head','PROJECT_ID,PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','form_basket','3','200')" autocomplete="off">
												<span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_projects&project_id=form_basket.project_id&project_head=form_basket.project_head');"></span>
												<span class="input-group-addon btnPointer bold" onclick="if(document.getElementById('project_id').value!='')windowopen('#request.self#?fuseaction=project.popup_list_project_actions&from_paper=INVOICE&id='+document.getElementById('project_id').value+'','horizantal');else alert('Proje Seçiniz');">?</span>
											</cfoutput>
										</div>
									</div>
								</div>
							</cfif>
							<cfoutput>
							<cfif xml_show_ship_address eq 1>
								<div class="form-group" id="item-ship_address">
									<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='29462.Yükleme Yeri'></label>
									<div class="col col-8 col-xs-12">
										<div class="input-group">
											<cfoutput>
												<input type="hidden" name="ship_address_city_id" id="ship_address_city_id" value="#get_sale_det.city_id#">
												<input type="hidden" name="ship_address_county_id" id="ship_address_county_id" value="#get_sale_det.county_id#">
												<input type="hidden" name="deliver_comp_id" id="deliver_comp_id" value="#get_sale_det.deliver_comp_id#">
												<input type="hidden" name="deliver_cons_id" id="deliver_cons_id" value="#get_sale_det.deliver_cons_id#">
												<input type="hidden" name="ship_address_id" id="ship_address_id" value="#get_sale_det.ship_address_id#">
												<input type="text" name="ship_address" id="ship_address" style="width:135px;" maxlength="200" value="<cfoutput>#get_sale_det.ship_address#</cfoutput>">
												<span class="input-group-addon btnPointer icon-ellipsis" title="<cf_get_lang dictionary_id='57734.seçiniz'>" onclick="add_adress();"></span>
											</cfoutput>
										</div>
									</div>
								</div>
							</cfif>
							</cfoutput>
						</div>
						<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
							<div class="form-group" id="item-department_ID">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58763.Depo'> *</label>
								<div class="col col-8 col-xs-12">
									<cfset location_info_ = get_location_info(get_sale_det.department_ID,get_sale_det.department_location,1,1)>
									<cf_wrkdepartmentlocation
										returninputvalue="location_id,department_name,department_id,branch_id"
										returninputquery="LOCATION_ID,LOCATION_NAME,DEPARTMENT_ID,BRANCH_ID"
										fieldname="department_name"
										fieldid="location_id"
										department_fldid="department_id"
										branch_fldid="branch_id"
										branch_id="#listlast(location_info_,',')#"
										department_id="#get_sale_det.department_ID#"
										location_id="#get_sale_det.department_location#"
										location_name="#listfirst(location_info_,',')#"
										user_level_control="#session.ep.OUR_COMPANY_INFO.IS_LOCATION_FOLLOW#"
										width="135">
								</div>
							</div>
							<div class="form-group" id="item-ship_method">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='29500.Sevk Yöntemi'></label>
								<div class="col col-8 col-xs-12">
									<div class="input-group">
										<input type="hidden" name="ship_method" id="ship_method"   value="<cfoutput>#get_sale_det.ship_method#</cfoutput>">
										<cfif len(get_sale_det.ship_method)>
											<cfset attributes.ship_method_id=get_sale_det.ship_method>
											<cfinclude template="../query/get_ship_methods.cfm">
										</cfif>
										<input type="text" name="ship_method_name" id="ship_method_name" value="<cfif len(get_sale_det.ship_method)><cfoutput>#ship_methods.ship_method#</cfoutput></cfif>" style="width:135px;" onfocus="AutoComplete_Create('ship_method_name','SHIP_METHOD','SHIP_METHOD','get_ship_method','','SHIP_METHOD_ID','ship_method','','3','135');" autocomplete="off">
										<span class="input-group-addon btnPointer icon-ellipsis" title="<cf_get_lang dictionary_id='57734.seçiniz'>" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_ship_methods&field_name=ship_method_name&field_id=ship_method','','ui-draggable-box-small');"></span>
									</div>
								</div>
							</div>
							<div class="form-group" id="item-paymethod">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58516.Ödeme Yöntem'></label>
								<div class="col col-8 col-xs-12">
									<div class="input-group">
										<cfif len(get_sale_det.pay_method)>
											<cfset attributes.paymethod_id = get_sale_det.pay_method>
											<cfinclude template="../query/get_paymethod.cfm">
											<input type="hidden" name="paymethod_id" id="paymethod_id" value="<cfoutput>#get_sale_det.pay_method#</cfoutput>">
											<input type="hidden" name="card_paymethod_id" id="card_paymethod_id" value="">
											<input type="hidden" name="commission_rate" id="commission_rate" value="">
											<input type="hidden" name="paymethod_vehicle" id="paymethod_vehicle" value="<cfoutput>#get_paymethod.payment_vehicle#</cfoutput>"><!--- Ödeme aracını tutuyor ve basket hesaplamalarında kullanılıyor lütfen silmeyiniz --->
											<input type="text" name="paymethod" id="paymethod" style="width:135px;"  value="<cfoutput>#get_paymethod.paymethod#</cfoutput>">
										<cfelseif len(get_sale_det.card_paymethod_id)>
											<cfquery name="get_card_paymethod" datasource="#dsn3#">
												SELECT 
													CARD_NO
													<cfif get_sale_det.commethod_id eq 6> <!--- WW den gelen siparişlerin guncellemesi, (siparisin commethod_id si faturaya tasınıyor) --->
													,PUBLIC_COMMISSION_MULTIPLIER AS COMMISSION_MULTIPLIER
													<cfelse>  <!--- EP VE PP den gelen siparişlerin guncellemesi --->
													,COMMISSION_MULTIPLIER 
													</cfif>
												FROM 
													CREDITCARD_PAYMENT_TYPE 
												WHERE 
													PAYMENT_TYPE_ID=#get_sale_det.card_paymethod_id#
											</cfquery>
											<cfoutput>
												<input type="hidden" name="paymethod_id" id="paymethod_id" value="">
												<input type="hidden" name="paymethod_vehicle" id="paymethod_vehicle" value="-1"> <!--- kredi kartı icin set edilen bu deger dsp_basket_js_scripts.cfm sayfasındaki taksit_hesapla() fonskiyonunda kullanılıyor. burda bi degisiklik yapılırsa orası da degistirilmelidir. 	OZDEN20071218 --->
												<input type="text" name="paymethod" id="paymethod" value="#get_card_paymethod.card_no#" style="width:135px;">
												<input type="hidden" name="card_paymethod_id" id="card_paymethod_id" value="#get_sale_det.card_paymethod_id#">
												<input type="hidden" name="commission_rate" id="commission_rate" value="#get_card_paymethod.commission_multiplier#">
											</cfoutput>
										<cfelse>
											<input type="hidden" name="paymethod_id" id="paymethod_id" value="">
											<input type="hidden" name="card_paymethod_id" id="card_paymethod_id" value="">
											<input type="hidden" name="commission_rate" id="commission_rate" value="">
											<input type="hidden" name="paymethod_vehicle" id="paymethod_vehicle" value="">
											<input type="text" name="paymethod" id="paymethod" value="" style="width:135px;">
										</cfif>
										<cfset card_link="&field_card_payment_id=form_basket.card_paymethod_id&field_card_payment_name=form_basket.paymethod&field_commission_rate=form_basket.commission_rate&field_paymethod_vehicle=form_basket.paymethod_vehicle">
										<span class="input-group-addon btnPointer icon-ellipsis" title="<cf_get_lang dictionary_id='57734.seçiniz'>" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_paymethods&function_name=change_paper_duedate&function_parameter=invoice_date&field_dueday=form_basket.basket_due_value&field_id=form_basket.paymethod_id&field_name=form_basket.paymethod#card_link#</cfoutput>','list');"></span>
									</div>	
								</div>
							</div>
							<div class="form-group" id="item-basket_due_value_date_">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='57337.Vade/Tarih'></label>
								<div class="col col-8 col-xs-12">
									<div class="input-group">
										<input name="basket_due_value" id="basket_due_value" type="text" value="<cfif len(get_sale_det.due_date) and len(get_sale_det.invoice_date)><cfoutput>#datediff('d',get_sale_det.invoice_date,get_sale_det.due_date)#</cfoutput></cfif>"onchange="change_paper_duedate('invoice_date');" style="width:43px;">
										<cfsavecontent variable="message"><cf_get_lang dictionary_id ='57338.Vade Tarihi İçin Geçerli Bir Format Giriniz'>!</cfsavecontent>
										<span class="input-group-addon no-bg"></span>
										<cfinput type="text" name="basket_due_value_date_" value="#dateformat(get_sale_det.due_date,dateformat_style)#" onChange="change_paper_duedate('invoice_date',1);" validate="#validate_style#" message="#message#" maxlength="10" style="width:90px;" readonly>
										<span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="basket_due_value_date_" id="basket_due_value_date_image"></span>
									</div>
								</div>
							</div>
							<cfif xml_show_contract eq 1>
								<div class="form-group" id="item-contract">
									<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='29522.Sözleşme'></label>
									<div class="col col-8 col-xs-12">
										<div class="input-group">
											<cfif len(get_sale_det.contract_id)>
												<cfquery name="getContract" datasource="#dsn3#">
													SELECT CONTRACT_HEAD FROM RELATED_CONTRACT WHERE CONTRACT_ID = #get_sale_det.contract_id#
												</cfquery>
											</cfif>
											<input type="hidden" name="progress_id" id="progress_id" value="<cfoutput>#get_sale_det.progress_id#</cfoutput>">
											<input type="hidden" name="contract_id" id="contract_id" value="<cfif len(get_sale_det.contract_id)><cfoutput>#get_sale_det.contract_id#</cfoutput></cfif>"> 
											<input type="text" name="contract_no" id="contract_no" value="<cfif len(get_sale_det.contract_id)><cfoutput>#getContract.contract_head#</cfoutput></cfif>" style="width:135px;">
											<span class="input-group-addon btnPointer icon-ellipsis" title="<cf_get_lang dictionary_id='57734.seçiniz'>" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_contract&field_id=form_basket.contract_id&field_name=form_basket.contract_no'</cfoutput>,'large');"></span>
										</div>
									</div>
								</div>
							</cfif>
							<cfif xml_acc_department_info>
								<div class="form-group" id="item-acc_department_id">
									<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57572.Departman'></label>
									<div class="col col-8 col-xs-12">
										<cf_wrkdepartmentbranch fieldid='acc_department_id' is_department='1' width='135' selected_value='#get_sale_det.ACC_DEPARTMENT_ID#'>
									</div>
								</div>
							</cfif>
						</div>
						<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="4" sort="true">
							<div class="form-group" id="item-note">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
								<div class="col col-8 col-xs-12">
									<textarea style="width:135px;height:65px;" name="note" id="note"><cfoutput>#get_sale_det.note#</cfoutput></textarea>
								</div>
							</div>
							<cfif session.ep.our_company_info.asset_followup eq 1>
								<div class="form-group" id="item-asset_name">
									<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58833.Fiziki Varlık'></label>
									<div class="col col-8 col-xs-12">
										<cf_wrkassetp asset_id="#get_sale_det.assetp_id#" fieldid='asset_id' fieldname='asset_name' form_name='form_basket' width='135' button_type="plus_thin">
									</div>
								</div>
							</cfif>
							<cfif xml_show_cash_checkbox eq 1>
								<div class="form-group" id="item-kasa">
									<label class="col col-4 col-xs-12" id="kasa_sec"><cf_get_lang dictionary_id='57163.Nakit Alış'><input type="checkbox" name="cash" id="cash" onclick="ayarla_gizle_goster2(1);"<cfif get_sale_det.is_cash eq 1>checked</cfif>></label>
									<div class="col col-8 col-xs-12" <cfif get_sale_det.is_cash neq 1> style="display:none;" </cfif> id="not">
										<cfif kasa.recordcount>
											<select name="kasa" id="kasa"style="width:135px;">
												<cfoutput query="kasa">
													<option value="#cash_id#" <cfif get_sale_det.kasa_id eq cash_id>selected</cfif>>#cash_name#-#cash_currency_id#</option>
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
										<label><cf_get_lang dictionary_id="58199.Kredi Kartı"><input type="checkbox" name="credit" id="credit" onclick="ayarla_gizle_goster2(3);" <cfif isdefined("get_sale_det") and get_sale_det.is_creditcard eq 1>checked</cfif>></label>
										<label><cf_get_lang dictionary_id="57521.Banka"><input type="checkbox" name="bank" id="bank" onclick="ayarla_gizle_goster2(2);" <cfif isdefined("get_sale_det") and get_sale_det.is_bank eq 1>checked</cfif>></label>
										<cfif isdefined("get_sale_det") and get_sale_det.is_creditcard eq 1>
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
														INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_sale_det.invoice_id#">
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
									</div>
								</div>
								<div <cfif isdefined("get_sale_det") and get_sale_det.is_bank eq 1>style="display:'';"<cfelse>style="display:none;"</cfif> class="padding-bottom-5" id="banka2">
									<div class="form-group">
										<div class="col col-4 col-xs-12">
											<label><cf_get_lang dictionary_id='57652.Hesap'></label>
										</div>
										<div class="col col-8 col-xs-12"><cf_wrkbankaccounts width='135' control_status='1' selected_value='#get_sale_det.kasa_id#'></div>
									</div>
								</div>
								<div <cfif isdefined("get_sale_det") and get_sale_det.is_creditcard eq 1>style="display:'';"<cfelse>style="display:none;"</cfif> class="padding-bottom-5" id="credit2">
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
							<div class="form-group" id="item-cancel_type">
								<cfif get_sale_det.is_iptal eq 1>
									<label class="col col-4 col-xs-12 font-red"><cf_get_lang dictionary_id='58750.Fatura İptal'><input name="fatura_iptal" id="fatura_iptal" value="1" checked type="checkbox" onclick="gizle_goster(cancel_type);"></label>
								<cfelse>
									<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58750.Fatura İptal'><input name="fatura_iptal" id="fatura_iptal" value="1" type="checkbox" onclick="gizle_goster(cancel_type);"></label>
								</cfif>
								<div id="cancel_type" <cfif get_sale_det.is_iptal neq 1> style="display:none;"</cfif>>
									<cfif isdefined("is_add_cancel_types") and is_add_cancel_types eq 1>
										<select name="cancel_type_id" id="cancel_type_id" style="width:135px;">
											<option value=""><cf_get_lang dictionary_id='58825.İptal Nedeni'></option>
											<cfoutput query="get_inv_cancel_types">
												<option value="#inv_cancel_type_id#" <cfif get_sale_det.cancel_type_id eq inv_cancel_type_id>selected</cfif>>#inv_cancel_type#</option>
											</cfoutput>
										</select>
									</cfif>
								</div>    
							</div>
							<div class="form-group" id="item-add_info_plus">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="57810.Ek Bilgi"></label>
								<div class="col col-8 col-xs-12">
									<cf_wrk_add_info info_type_id="-8" info_id="#attributes.iid#" upd_page = "1">
								</div>
								<div id="add_info_plus"></div><!--- isbak için eklendi kaldırmayınız sm --->
							</div>
						</div>
					</cf_box_elements>
					<cf_box_footer>
						<div class="col col-6 col-xs-12">
							<cf_record_info query_name="get_sale_det">
						</div>
						<div class="col col-6 col-xs-12">
							<cf_basket_form_button>
								<cfif not len(isClosed('INVOICE',attributes.iid)) and (GET_SALE_DET.RELATED_ACTION_TABLE eq '' or not len(isClosed(GET_SALE_DET.RELATED_ACTION_TABLE,GET_SALE_DET.RELATED_ACTION_ID)))>
									<cfif get_sale_det.upd_status neq 0 and is_related_customs_ships eq 0>
										<cf_workcube_buttons is_upd='1' add_function='kontrol()' is_delete='1' del_function='kontrol2()'>
									<cfelseif is_related_customs_ships neq 0>
										<font color="red">
										<cf_get_lang dictionary_id="59845.Belgenin İlişkili İthal Mal Girişi Bulunmaktadır">.<br />
										<strong><cf_get_lang dictionary_id="59322.İlişkili Belgeler"> : <cfoutput>#is_related_customs_ships#</cfoutput></strong>
										</font>
									</cfif>
								<cfelse>
									<font color="FF0000"><cf_get_lang dictionary_id='47262.Fatura kapama işlemi yapılan belgede değişiklik yapılamaz'>!</font>
								</cfif>
							</cf_basket_form_button>
						</div>
					</cf_box_footer>
			</cf_basket_form>	
				<cfinclude template="../../objects/display/basket.cfm">		
			</cfform>
		</div>
	</cf_box>
</div>
<script type="text/javascript">

	function ayarla_gizle_goster2(id){
		if(id==3){
			if(document.getElementById("credit").checked == true){
				if (document.getElementById("bank")){
					document.getElementById("bank").checked = false;
					document.getElementById("banka2").style.display='none';
					document.getElementById("bank_code").value = "";
				}
				if (document.getElementById("cash")) {
					document.getElementById("cash").checked = false;
					document.getElementById("not").style.display='none';
				}
				document.getElementById("credit2").style.display='';
			}
			else{
				document.getElementById("credit2").style.display='none';
			}
		}
		else if(id==1)
		{
			if(document.getElementById("cash").checked == true)
			{
				if (document.getElementById("bank")) 
				{
					document.getElementById("bank").checked = false;
					document.getElementById("banka2").style.display='none';
					document.getElementById("bank_code").value = "";
				}
				if (document.getElementById("credit")) 
				{
					document.getElementById("credit").checked = false;
					document.getElementById("credit2").style.display='none';
				}
				document.getElementById("not").style.display='';
			}
			else
			{
				document.getElementById("not").style.display='none';
			}
		}
		else{
			if(document.getElementById("bank").checked == true){
				if (document.getElementById("cash")) {
					document.getElementById("cash").checked = false;
					document.getElementById("not").style.display='none';
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

	function changeProcessDate(){
		$("#process_date").val($("#invoice_date").val());
	}
	function add_order()
	{	
		deger = form_basket.process_cat.options[form_basket.process_cat.selectedIndex].value;
		if(deger == '')
		{
			alert("<cf_get_lang dictionary_id='58770.İşlem Tipi Seçiniz'> !");
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
		var irs_list='';
		if(window.basket.items.length)
		{
			for(i=0;i<window.basket.items.length;i++)
			{
				if(!list_find(irs_list,window.basket.items[i].ROW_SHIP_ID,','))
				{
					if(i!=0)
						irs_list = irs_list + ',' ;
					irs_list = irs_list + window.basket.items[i].ROW_SHIP_ID;
				}
			}
		}
		else
			irs_list = irs_list + 0;
	
		str_irslink = '&ship_id_liste=' + irs_list + '&id=purchase_upd&sale_product=0&company_id='+form_basket.company_id.value+'&consumer_id='+ form_basket.consumer_id.value<cfif session.ep.isBranchAuthorization>+'&is_store='+1</cfif>;
		<cfif session.ep.our_company_info.project_followup eq 1>
			if(form_basket.project_id.value!='' && form_basket.project_head.value!='')
				str_irslink = str_irslink+'&project_id='+form_basket.project_id.value;
		</cfif>
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_choice_ship' + str_irslink , 'wide');
		return true;
	}
		
	function kontrol_ithalat()
	{
		deger = form_basket.process_cat.options[form_basket.process_cat.selectedIndex].value;
		sistem_para_birimi = "<cfoutput>#SESSION.EP.MONEY#</cfoutput>";	
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
		var is_invoice_cost = true;
		if (!paper_control(form_basket.serial_no,'INVOICE',false,<cfoutput>'#attributes.iid#','#get_sale_det.serial_no#'</cfoutput>,form_basket.company_id.value,form_basket.consumer_id.value,'','',1,form_basket.serial_number)) return false;
		if(document.form_basket.is_cost.value==0) is_invoice_cost = false;
		
		//Odeme Plani Guncelleme Kontrolleri
		if (document.form_basket.invoice_cari_action_type.value == 5 && document.form_basket.old_pay_method.value != "")
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
		if (document.getElementById('fatura_iptal') != undefined && document.getElementById('fatura_iptal').checked == false && document.form_basket.invoice_payment_plan.value == 0)
		{
			var listParam = "<cfoutput>#attributes.iid#</cfoutput>" + "*" + "<cfoutput>#session.ep.period_id#</cfoutput>" ;
			var payment_plan_info = wrk_safe_query("inv_payment_plan",'dsn3',0,listParam);
			if(payment_plan_info.recordcount)
			{
				if((document.form_basket.old_pay_method.value != document.form_basket.paymethod_id.value) || document.form_basket.old_net_total.value != wrk_round(document.all.basket_net_total.value,document.form_basket.basket_total_round_number_.value) || (payment_plan_info.COMPANY_ID != '' && payment_plan_info.COMPANY_ID != form_basket.company_id.value) || (form_basket.old_process_type.value != eval("document.form_basket.ct_process_type_" + temp_process_cat).value))
				{
					alert("<cf_get_lang dictionary_id='57103.Ödeme Planı Girilen Belgenin Tutarı,Carisi,Ödeme Yöntemi veya İşlem Tipi Değiştirilemez'>!");
					return false;
				}				
			}
		}
		
		
		if (is_invoice_cost && !confirm("<cf_get_lang dictionary_id='57271.Güncellediğiniz Faturanın Masraf Gelir Dağıtımı Yapılmış,Devam Ederseniz Bu Dağıtım Silinecektir'>!")) return false;
		<cfif isdefined('xml_acc_department_info') and xml_acc_department_info eq 2> //xmlde muhasebe icin departman secimi zorunlu ise
			if( document.form_basket.acc_department_id.options[document.form_basket.acc_department_id.selectedIndex].value=='')
			{
				alert("<cf_get_lang dictionary_id='58836.Lutfen Departman Seciniz'>");
				return false;
			} 
		</cfif>
		
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
				alert("<cf_get_lang dictionary_id='45482.Lütfen Sevk Yöntemi Seçiniz'>!");
				return false;	
			}
		</cfif>
		
		if(form_basket.department_id.value=="")
		{
			alert("<cf_get_lang dictionary_id='57186.Depo Seçmelisiniz!'>");
			return false;
		}
		<cfif isdefined("xml_show_process_stage") and len(xml_show_process_stage) and xml_show_process_stage eq 1>
			if(document.form_basket.process_stage.value == "")
			{
				alert("<cf_get_lang dictionary_id ='41036.Lütfen Süreçlerinizi Tanimlayiniz veya Tanimlanan Süreçler Üzerinde Yetkiniz Yok'>!");
				return false;
			}
		</cfif>	
		if (!chk_process_cat('form_basket')) return false;
		if (!check_display_files('form_basket')) return false;
		if (!chk_period(form_basket.process_date,"İşlem")) return false;
		if (!check_accounts('form_basket')) return false;
		if (!kontrol_ithalat()) return false;
		<cfif isdefined("xml_upd_row_project") and xml_upd_row_project eq 1 and session.ep.our_company_info.project_followup eq 1>
			apply_deliver_date('','project_head','');
		</cfif>
		if(!check_product_accounts()) return false;
		change_paper_duedate('invoice_date');	
		<cfif not get_module_power_user(20)>
			var listParam = "<cfoutput>#attributes.iid#</cfoutput>" + "*" + form_basket.old_process_type.value ;
			var closed_info = wrk_safe_query("inv_closed_info",'dsn2',0,listParam);
			if(closed_info.recordcount)
				if((document.form_basket.old_pay_method.value != document.form_basket.paymethod_id.value) || (document.form_basket.old_net_total.value != wrk_round(document.all.basket_net_total.value,document.form_basket.basket_total_round_number_.value)) || (closed_info.COMPANY_ID != '' && closed_info.COMPANY_ID != form_basket.company_id.value) || (closed_info.CONSUMER_ID != '' && closed_info.CONSUMER_ID != form_basket.consumer_id.value) || (form_basket.old_process_type.value != eval("document.form_basket.ct_process_type_" + deger).value))
				{
					alert("<cf_get_lang dictionary_id='57405.Belge Kapama,Talep veya Emir Girilen Belgenin Tutarı,Carisi,Ödeme Yöntemi veya İşlem Tipi Değiştirilemez'>!");
					return false;
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
										alert("<cf_get_lang dictionary_id='57110.Fatura Tarihi İrsaliye Tarihinden Önce Olamaz'>!");
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
		<cfif isdefined("xml_show_process_stage") and len(xml_show_process_stage) and xml_show_process_stage eq 1>
			return (control_account_process(<cfoutput>'#attributes.iid#','#get_sale_det.invoice_cat#'</cfoutput>) && process_cat_control() && saveForm());
		<cfelse>
			return (control_account_process(<cfoutput>'#attributes.iid#','#get_sale_det.invoice_cat#'</cfoutput>) && saveForm());
		</cfif>
	}
	function kontrol2()
	{
		<cfif session.ep.our_company_info.is_efatura and isdefined("get_efatura_det") and get_efatura_det.recordcount>
			alert("<cf_get_lang dictionary_id='57114.Fatura ile İlişkili e-Fatura Olduğu için Silinemez'> !");
			return false;
		</cfif>
		form_basket.del_invoice_id.value = <cfoutput>#attributes.iid#</cfoutput>;
		if (!chk_process_cat('form_basket')) return false;
		if (!check_display_files('form_basket')) return false;
		if (!chk_period(form_basket.invoice_date,"İşlem")) return false;
		var listParam = "<cfoutput>#attributes.iid#</cfoutput>" + "*" + form_basket.old_process_type.value;
		<cfif not get_module_power_user(20)>
			var closed_info = wrk_safe_query("inv_closed_info_2",'dsn2',0,listParam);
			if(closed_info.recordcount)
			{
				alert("<cf_get_lang dictionary_id='59846.Fatura ile İlişkili Ödeme Talebi Olduğu İçin Silinemez'> ! <cf_get_lang dictionary_id='30828.Talep'> <cf_get_lang dictionary_id ='58527.ID'> :"+closed_info.CLOSED_ID);
				return false;
			}
		</cfif>
		<cfif isdefined("xml_show_process_stage") and len(xml_show_process_stage) and xml_show_process_stage eq 1>
			return (control_account_process(<cfoutput>'#attributes.iid#','#get_sale_det.invoice_cat#'</cfoutput>) && process_cat_control() && saveForm()); 
		<cfelse>
			return (control_account_process(<cfoutput>'#attributes.iid#','#get_sale_det.invoice_cat#'</cfoutput>) && saveForm()); 
		</cfif>
	}
	function kontrol_yurtdisi()
	{
		deger = form_basket.process_cat.options[form_basket.process_cat.selectedIndex].value;
		if(deger != "")
		{
			var fis_no = eval("form_basket.ct_process_type_" + deger);
			
			if(fis_no.value == 591) 
			{
				<cfif xml_show_cash_checkbox eq 1>
					kasa_sec.style.display = 'none';
					not.style.display = 'none';
					form_basket.cash.checked=false;
				</cfif>
				$("#item-realization_date").show();
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
	function openVoucher()
	{
		openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_payment_with_voucher&is_purchase_=1&payment_process_id=#attributes.iid#&inv_order_id=#get_order.ORDER_ID#&str_table=INVOICE&rate_round_num='+window.basket.hidden_values.basket_rate_round_number_+'&round_number='+window.basket.hidden_values.basket_total_round_number_+'&branch_id='+document.form_basket.branch_id.value</cfoutput>);		
	}
	function check_process_is_sale()/*satıs iadeleri alıs karakterli oldugu halde satıs fiyatları ile çalışması için*/
	{
		<cfif get_basket.basket_id is 1>
			var selected_ptype = document.form_basket.process_cat.options[document.form_basket.process_cat.selectedIndex].value;
			if(selected_ptype!='')
				{
				eval('var proc_control = document.form_basket.ct_process_type_'+selected_ptype+'.value');
				if(proc_control==54 || proc_control==55)
					sale_product= 1;
				else
					sale_product = 0;
				}
			else
				return true;
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
					windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_member_address&is_comp=0&select_list=2&keyword='+encodeURIComponent(form_basket.comp_name.value)+''+ str_adrlink , 'list');
					document.getElementById('deliver_comp_id').value = '';
					return true;
				}
		}
		else
		{
			alert("<cf_get_lang dictionary_id ='50081.Cari Hesap Seçiniz'>");
			return false;
		}
	}
	$(function(){
	kontrol_yurtdisi();
	check_process_is_sale();
	change_paper_duedate('invoice_date');
	})
</script>
</cfif>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
<cfsetting showdebugoutput="yes">
