<cf_get_lang_set module_name="invoice"><!--- sayfanin en altinda kapanisi var ---> 
	<cf_xml_page_edit fuseact = "invoice.form_add_bill_other">
	<cfif isdefined('attributes.iid') and len(attributes.iid)>
		<cfscript>
			session_basket_kur_ekle(action_id=attributes.iid,table_type_id:1,process_type:1);
		</cfscript>
	<cfelse>
		<cfscript>session_basket_kur_ekle(process_type:0);</cfscript>
	</cfif>
	<cfinclude template="../query/get_session_cash.cfm">
	<cfinclude template="../query/control_bill_no.cfm">
	<cfparam name="attributes.company_id" default="">
	<cfparam name="attributes.company" default="">
	<cfparam name="attributes.partner_name" default="">
	<cfparam name="attributes.partner_id" default="">
	<cfparam name="attributes.ref_no" default="">
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
	<cfset invoice_number = "">
	<cfif isdefined('attributes.iid') and len(attributes.iid) and isnumeric(attributes.iid)>
		<cfinclude template="../query/get_purchase_det.cfm">
	<cfelse>
		<cfset get_sale_det.recordcount = 0>
	</cfif>
	<cfif isdefined("attributes.receiving_detail_id")>
		<cfquery name="GET_INV_DET" datasource="#DSN2#">
			SELECT ISSUE_DATE,EINVOICE_ID FROM EINVOICE_RECEIVING_DETAIL WHERE RECEIVING_DETAIL_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.receiving_detail_id#"> 
		</cfquery>
		<cfif get_inv_det.recordcount>
			<cfset invoice_date = get_inv_det.issue_date>
			<cfset serial_no = right(get_inv_det.einvoice_id,13)>
			<cfset serial_number = left(get_inv_det.einvoice_id,3)>
			<cfset invoice_number = "#serial_number#-#serial_no#">
			<script type="text/javascript">
				try{
					window.onload = function () { change_money_info('form_basket','invoice_date');}
				}
				catch(e){}
			</script>
		</cfif>
	</cfif>
	
	<cf_catalystHeader>
	<div class="col col-12 col-xs-12">
		<cf_box>
			<div id="basket_main_div">
				<cfform name="form_basket" method="post" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_add_bill_other">	
					<cf_basket_form id="add_bill_other">
						<input type="hidden" name="form_action_address" id="form_action_address" value="<cfoutput>#listgetat(attributes.fuseaction,1,'.')#.emptypopup_add_bill_other</cfoutput>">
						<cf_papers paper_type="invoice" form_name="form_basket" form_field="invoice_number">
						<input type="hidden" name="active_period" id="active_period" value="<cfoutput>#session.ep.period_id#</cfoutput>">
						<input type="hidden" name="search_process_date" id="search_process_date" value="invoice_date">
						<input type="hidden" name="member_account_code" id="member_account_code" value="">
						<input type="hidden" name="other_account_code" id="other_account_code" value="">
						<cfif isdefined("attributes.receiving_detail_id")>
							<input type="hidden" name="receiving_detail_id" id="receiving_detail_id" value="<cfoutput>#attributes.receiving_detail_id#</cfoutput>">
						</cfif>
						<cf_box_elements>
							<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" sort="true" index="1">
								<div class="form-group" id="item-process_cat">
									<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57800.işlem tipi'></label>
									<div class="col col-8 col-xs-12">
										<cfif isdefined('get_sale_det.process_cat') and len(get_sale_det.process_cat)>
											<cf_workcube_process_cat  slct_width="140" onclick_function="order_show();" process_cat="#get_sale_det.process_cat#">
										<cfelse>
												<cf_workcube_process_cat onclick_function="order_show();">
										</cfif>
									</div>
								</div>
								<cfif isdefined("xml_show_process_stage") and len(xml_show_process_stage) and xml_show_process_stage eq 1>
									<div class="form-group" id="item-process_stage">
										<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58859.Süreç'></label>
										<div class="col col-8 col-xs-12">
											<cf_workcube_process is_upd='0' process_cat_width='150' is_detail='0'>
										</div>
									</div>
								</cfif>
								<div class="form-group" id="item-company">
									<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57519.Cari hesap'> *</label>
									<div class="col col-8 col-xs-12">
										<div class="input-group">
											<cfoutput>
												<cfif isdefined('attributes.company') and len(attributes.company)>
													<input  name="company" id="company" type="text" readonly value="#attributes.company#">
													<input type="hidden" name="company_id" id="company_id" value="#attributes.company_id#">
												<cfelseif isdefined('get_sale_det_comp.fullname') and len(get_sale_det_comp.fullname)>
													<input  name="company" id="company" type="text" readonly value="#get_sale_det_comp.fullname#">
													<input type="hidden" name="company_id" id="company_id" value="#get_sale_det_comp.company_id#">
												<cfelse>
													<input  name="company" id="company" type="text" readonly value="">
													<input type="hidden" name="company_id" id="company_id" value="">
												</cfif>
											</cfoutput>
											<cfset str_linkeait="&ship_method_id=form_basket.ship_method&ship_method_name=form_basket.ship_method_name&field_paymethod_id=form_basket.paymethod_id&field_paymethod=form_basket.paymethod&field_basket_due_value=form_basket.basket_due_value&field_card_payment_id=form_basket.card_paymethod_id">
											<span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_pars&select_list=2,3&field_name=form_basket.partner_name&field_partner=form_basket.partner_id&field_comp_name=form_basket.company&field_comp_id=form_basket.company_id&field_consumer=form_basket.consumer_id&field_member_account_code=form_basket.member_account_code#str_linkeait#<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif></cfoutput>','list')"></span>
										</div>
									</div>
								</div>
								<div class="form-group" id="item-partner_name">
									<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57578.Yetkili'> *</label>
									<div class="col col-8 col-xs-12">
										<cfoutput>
											<cfif isdefined('attributes.partner_id') and len(attributes.partner_id)>
												<input type="hidden" name="partner_id" id="partner_id" value="#attributes.partner_id#">
												<input type="hidden" name="consumer_id" id="consumer_id">
												<input type="text" name="partner_name" id="partner_name" value="#attributes.partner_name#" readonly>
											<cfelseif isdefined('get_sale_det.partner_id') and len(get_sale_det.partner_id)>
												<input type="hidden" name="partner_id" id="partner_id" value="#get_sale_det.partner_id#">
												<cfif len(GET_SALE_DET.PARTNER_ID) and isnumeric(GET_SALE_DET.PARTNER_ID)>
													<input type="text" name="partner_name" id="partner_name" value="#GET_SALE_DET_CONS.COMPANY_PARTNER_NAME# #GET_SALE_DET_CONS.COMPANY_PARTNER_SURNAME#" readonly>
												<cfelse>
													<input type="text" name="partner_name" id="partner_name" value="" readonly>							
												</cfif>
											<cfelseif isdefined('get_sale_det.consumer_id') and len(get_sale_det.consumer_id)>
												<input type="hidden" name="consumer_id" id="consumer_id" value="#get_sale_det.consumer_id#">
												<cfif len(GET_SALE_DET.consumer_id) and isnumeric(GET_SALE_DET.consumer_id) >
													<input type="text" name="partner_name" id="partner_name" value="#get_cons_name.consumer_name# #get_cons_name.consumer_surname#" readonly>
												<cfelse>
													<input type="text" name="partner_name" id="partner_name" value="" readonly>							
												</cfif>
											<cfelse>
												<input type="hidden" name="partner_id" id="partner_id" value="">
												<input type="hidden" name="consumer_id" id="consumer_id">
												<input type="text" name="partner_name" id="partner_name" value="" readonly>

											</cfif>
										</cfoutput>
									</div>
								</div>	
								<div class="form-group" id="item-deliver_get">
									<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57775.Teslim Alan'> *</label>
									<div class="col col-8 col-xs-12">
										<div class="input-group">
											<cfif isdefined('get_sale_det.deliver_emp') and len(get_sale_det.deliver_emp) and isnumeric(get_sale_det.deliver_emp)>
												<cfset str_del_name=get_emp_info(get_sale_det.deliver_emp,0,0)>
											<cfelse>
												<cfset str_del_name="">
											</cfif>	
											<cfoutput>
												<input type="hidden" name="deliver_get_id" id="deliver_get_id"  value="<cfif isdefined('get_sale_det.deliver_emp') and isnumeric(get_sale_det.deliver_emp)>#get_sale_det.deliver_emp#</cfif>">
												<input type="text" name="deliver_get" id="deliver_get" value="<cfif isdefined('get_sale_det.deliver_emp') and len(get_sale_det.deliver_emp)>#str_del_name#</cfif>" onfocus="AutoComplete_Create('deliver_get','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','deliver_get_id','','3','150');" autocomplete="off">
											</cfoutput>
											<span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&select_list=1&field_name=form_basket.deliver_get&field_emp_id2=form_basket.deliver_get_id</cfoutput>','list')"></span>
										</div>
									</div>
								</div>
								<div class="form-group" id="item-acc_department_id">
									<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57572.Departman'></label>
									<div class="col col-8 col-xs-12">
										<cfif isdefined('get_sale_det.acc_department_id') and len(get_sale_det.acc_department_id)>
											<cf_wrkdepartmentbranch fieldid='acc_department_id' is_department='1' width='135' selected_value='#get_sale_det.acc_department_id#'>
										<cfelseif isDefined("attributes.acc_department_id") and len(attributes.acc_department_id)>
											<cf_wrkdepartmentbranch fieldid='acc_department_id' is_department='1' width='135' selected_value='#attributes.acc_department_id#'>
										<cfelse>
											<cf_wrkdepartmentbranch fieldid='acc_department_id' is_department='1' width='150' is_deny_control='0' >
										</cfif>
									</div>
								</div>
								<div class="form-group" id="order_id_form">
									<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57611.sipariş'></label>
									<div class="col col-8 col-xs-12">
										<div class="input-group">
											<input type="hidden" name="order_id_listesi" id="order_id_listesi" value="<cfif isdefined('attributes.order_id') and len(attributes.order_id)><cfoutput>#attributes.order_id#</cfoutput><cfelseif isdefined("get_order_num") and get_order_num.recordcount><cfoutput>#ValueList(get_order_num.ORDER_ID)#</cfoutput></cfif>">
											<input type="text" name="order_id_form" id="order_id_form" value="<cfif isdefined('attributes.order_number') and len(attributes.order_number)><cfoutput>#attributes.order_number#</cfoutput> <cfelseif isdefined("get_order_num") and get_order_num.recordcount><cfoutput>#ListSort(valuelist(GET_ORDER_NUM.ORDER_NUMBER),'text')#</cfoutput></cfif>" readonly>
											<span class="input-group-addon btnPointer icon-ellipsis" title="<cf_get_lang dictionary_id='57734.seçiniz'>" onclick="add_order();"></span>
										</div>
									</div>
								</div>
							</div>
							<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" sort="true" index="2">
								<div class="form-group" id="item-invoice_number">
									<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57880.Belge No'> *</label>
									<div class="col col-8 col-xs-12">
										<cfsavecontent variable="message"><cf_get_lang dictionary_id='468.Belge No'> !</cfsavecontent>
										<cfif isDefined('paper_full') and len(paper_number)>
											<cfinput type="text" maxlength="50" name="invoice_number" required="Yes" value="#paper_code#-#paper_number#" message="#message#">
										<cfelse>
											<cfinput type="text" maxlength="50" name="invoice_number" required="Yes" value="#invoice_number#" message="#message#">
										</cfif>
									</div>
								</div>
								<div class="form-group" id="item-invoice_date">
									<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58759.Fatura Tarihi'> *</label>
									<div class="col col-8 col-xs-12">
										<div class="input-group">
											<cfsavecontent variable="message"><cf_get_lang dictionary_id='57185.Fatura Tarihi Girmelisiniz !'></cfsavecontent>
											<cfif isdefined('get_sale_det.invoice_date') and len(get_sale_det.invoice_date)>
												<cfinput type="text" maxlength="10" name="invoice_date" value="#dateformat(get_sale_det.invoice_date,dateformat_style)#" required="yes" validate="#validate_style#" message="#message#" passthrough="onBlur=""change_money_info('form_basket','invoice_date');changeProcessDate();""">			
											<cfelse>
												<cfinput type="text" maxlength="10" name="invoice_date" value="#dateformat(invoice_date,dateformat_style)#" required="yes" validate="#validate_style#" message="#message#" passthrough="onBlur=""change_money_info('form_basket','invoice_date');changeProcessDate();""">
											</cfif>
											<span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="invoice_date" call_function="change_money_info&changeProcessDate"></span>
										</div>
									</div>
								</div>
								<div class="form-group" id="item-process_date">
									<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57879.İşlem Tarihi'> *</label>
									<div class="col col-8 col-xs-12">
										<div class="input-group">
											<cfif isdefined('get_sale_det.process_date') and len(get_sale_det.process_date)>
												<cfset p_date = get_sale_det.process_date>
											<cfelseif isdefined('get_sale_det.invoice_date') and len(get_sale_det.invoice_date)>
												<cfset p_date = get_sale_det.invoice_date>
											<cfelse>
												<cfset p_date = now()>
											</cfif>
											<cfsavecontent variable="message"><cf_get_lang dictionary_id='57906.İşlem Tarihi Girmelisiniz !'></cfsavecontent>
											<cfinput type="text" name="process_date" required="Yes" message="#message#" value="#dateformat(p_date,dateformat_style)#" validate="#validate_style#">
											<span class="input-group-addon btnPointer" title="<cf_get_lang dictionary_id='57734.seçiniz'>"><cf_wrk_date_image date_field="process_date"></span>
										</div>
									</div>
								</div>
								<cfif session.ep.our_company_info.project_followup eq 1>
									<div class="form-group" id="item-project_head">
										<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57416.Proje'></label>
										<div class="col col-8 col-xs-12">
											<div class="input-group">
												<cfif isDefined("attributes.pj_id")><cfset attributes.project_id = attributes.pj_id></cfif>
												<cfif isdefined('get_sale_det.project_id') and len(get_sale_det.project_id)>
													<cfquery name="GET_PROJECT" datasource="#dsn#">
														SELECT PROJECT_HEAD FROM PRO_PROJECTS WHERE PROJECT_ID = #get_sale_det.project_id#
													</cfquery>
													<input type="hidden" name="project_id" id="project_id" value="<cfoutput>#get_sale_det.project_id#</cfoutput>"> 
													<input type="text" name="project_head" id="project_head" value="<cfoutput>#get_project.project_head#</cfoutput>">
												<cfelse>
													<input type="hidden" name="project_id" id="project_id"  value="<cfif isdefined('attributes.project_id')><cfoutput>#attributes.project_id#</cfoutput></cfif>"> 
													<input type="text" name="project_head" id="project_head" value="<cfif isdefined('attributes.project_id') and  len(attributes.project_id)><cfoutput>#GET_PROJECT_NAME(attributes.project_id)#</cfoutput></cfif>" onfocus="AutoComplete_Create('project_head','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','form_basket','3','135');">
												</cfif>
												<span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_projects&project_id=form_basket.project_id&project_head=form_basket.project_head');"></span>
											</div>
										</div>
									</div>
								</cfif>
								<div class="form-group" id="item-ref_no">
									<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58784.Referans'></label>
									<div class="col col-8 col-xs-12">
										<cfif isDefined('get_sale_det.ref_no') and len(get_sale_det.ref_no)>
											<input type="text" name="ref_no" id="ref_no" value="<cfoutput>#get_sale_det.ref_no#</cfoutput>" maxlength="50">											
										<cfelse>
											<input type="text" name="ref_no" id="ref_no" value="<cfoutput>#attributes.ref_no#</cfoutput>" maxlength="50">
										</cfif>
									</div>
								</div>
								<div class="form-group" id="item-PARTNER_NAMEO">
									<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='30011.Satın alan'></label>
									<div class="col col-8 col-xs-12">
										<div class="input-group">
											<cfif isdefined('get_sale_det.SALE_EMP') and len(get_sale_det.SALE_EMP) or isdefined('get_sale_det.SALE_PARTNER') and len(get_sale_det.SALE_PARTNER)>
												<cfoutput>
													<input type="hidden" name="EMPO_ID" id="EMPO_ID" value="#get_sale_det.SALE_EMP#">
													<input type="hidden" name="PARTO_ID" id="PARTO_ID" value="#get_sale_det.SALE_PARTNER#">
													<input type="text" name="PARTNER_NAMEO" id="PARTNER_NAMEO" <cfif isdefined('get_sale_det.sale_partner') and len(get_sale_det.sale_partner)>value="<cfoutput>#get_par_info(get_sale_det.sale_partner,0,0,0)#</cfoutput>"<cfelse>value="<cfoutput>#get_emp_info(get_sale_det.sale_emp,0,0)#</cfoutput>"</cfif>>
												</cfoutput>
											<cfelse>
												<input type="hidden" name="EMPO_ID" id="EMPO_ID">
												<input type="hidden" name="PARTO_ID" id="PARTO_ID" value="">
												<input type="text" name="PARTNER_NAMEO" id="PARTNER_NAMEO" value="">
											</cfif>
											<span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&select_list=1,2&field_name=form_basket.PARTNER_NAMEO&field_EMP_id=form_basket.EMPO_ID&field_id=form_basket.PARTO_ID</cfoutput>','list')"></span>											
										</div>
									</div>
								</div>
								<cfif session.ep.our_company_info.asset_followup eq 1>
									<div class="form-group" id="item-asset_name">
										<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='58833.Fiziki Varlık'></label>
										<div class="col col-8 col-xs-12">
											<cfif isdefined('get_sale_det.assetp_id') and len(get_sale_det.assetp_id)>
												<cf_wrkassetp fieldid='#get_sale_det.assetp_id#' fieldname='asset_name' width='135' form_name='form_basket'>											
											<cfelse>
												<cf_wrkassetp fieldid='asset_id' fieldname='asset_name' width='135' form_name='form_basket'>
											</cfif>
										</div>
									</div>
								</cfif>
							</div>
							<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" sort="true" index="3">
								<div class="form-group" id="item-department_location">
									<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58763.Depo'> *</label>
									<div class="col col-8 col-xs-12">
										<cfif isdefined('get_sale_det.DEPARTMENT_ID') and len(get_sale_det.DEPARTMENT_ID)>
											<cfset attributes.department_id = get_sale_det.DEPARTMENT_ID>
											<cfinclude template="../query/get_dept_name.cfm">
											<cfset txt_department_name = get_dept_name.DEPARTMENT_HEAD>
											<cfset branch_id = get_dept_name.BRANCH_ID>
											<cfif len(get_sale_det.DEPARTMENT_LOCATION)>
												<cfset attributes.location_id = get_sale_det.DEPARTMENT_LOCATION>
												<cfinclude template="../query/get_location_name.cfm">
												<cfset txt_department_name = txt_department_name & "-" & get_location_name.COMMENT>
											</cfif>
											<cf_wrkdepartmentlocation
												returninputvalue="location_id,department_name,department_id,branch_id"
												returnqueryvalue="LOCATION_ID,LOCATION_NAME,DEPARTMENT_ID,BRANCH_ID"
												fieldname="department_name"
												fieldid="location_id"
												department_fldid="department_id"
												branch_fldid="branch_id"
												branch_id="#branch_id#"
												department_id="#get_sale_det.department_ID#"
												location_id="#get_sale_det.department_location#"
												location_name="#txt_department_name#"
												user_level_control="#session.ep.OUR_COMPANY_INFO.IS_LOCATION_FOLLOW#"
												width="135">
										<cfelse>
											<cf_wrkdepartmentlocation
												returninputvalue="location_id,department_name,department_id,branch_id"
												returnqueryvalue="LOCATION_ID,LOCATION_NAME,DEPARTMENT_ID,BRANCH_ID"
												fieldname="department_name"
												fieldid="location_id"
												department_fldid="department_id"
												branch_fldid="branch_id"
												user_level_control="#session.ep.OUR_COMPANY_INFO.IS_LOCATION_FOLLOW#"
												width="135">
										</cfif>
									</div>
								</div>
								<div class="form-group" id="item-ship_method">
									<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='29500.Sevk Yöntemi'></label>
									<div class="col col-8 col-xs-12">
										<div class="input-group">
											<cfif isdefined('get_sale_det.ship_method') and len(get_sale_det.ship_method)>
												<cfset attributes.ship_method_id=get_sale_det.ship_method>
												<cfinclude template="../query/get_ship_methods.cfm">
												<input type="hidden" name="ship_method" id="ship_method"  value="<cfoutput>#get_sale_det.ship_method#</cfoutput>">
												<input type="text" name="ship_method_name" id="ship_method_name" readonly value="<cfif isdefined('get_sale_det.ship_method') and len(get_sale_det.ship_method)><cfoutput>#ship_methods.ship_method#</cfoutput></cfif>">												
											<cfelse>
												<input type="hidden" name="ship_method" id="ship_method" value="">
												<input type="text" name="ship_method_name" id="ship_method_name" readonly value="" >												
											</cfif>
											<span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_ship_methods&field_name=ship_method_name&field_id=ship_method','list');"></span>
										</div>
									</div>
								</div>
								<div class="form-group" id="item-paymethod">
									<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58516.Ödeme Yöntem'></label>
									<div class="col col-8 col-xs-12">
										<div class="input-group">
											<cfif isdefined('get_sale_det.pay_method') and len(get_sale_det.pay_method)>
												<cfset attributes.paymethod_id = get_sale_det.pay_method>
												<cfinclude template="../query/get_paymethod.cfm">
												<input type="hidden" name="paymethod_id" id="paymethod_id" value="<cfoutput>#get_sale_det.pay_method#</cfoutput>">
												<input type="text" name="paymethod" id="paymethod" value="<cfoutput>#get_paymethod.paymethod#</cfoutput>" readonly>
												<input type="hidden" name="card_paymethod_id" id="card_paymethod_id" value="">
												<input type="hidden" name="commission_rate" id="commission_rate" value="">
											<cfelseif isdefined('get_sale_det.pay_method') and len(get_sale_det.card_paymethod_id)>
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
													<input type="text" name="paymethod" id="paymethod" value="#get_card_paymethod.card_no#" readonly >
													<input type="hidden" name="card_paymethod_id" id="card_paymethod_id" value="#get_sale_det.card_paymethod_id#">
													<input type="hidden" name="commission_rate" id="commission_rate" value="#get_card_paymethod.commission_multiplier#">
												</cfoutput>
											<cfelse>
												<input type="hidden" name="card_paymethod_id" id="card_paymethod_id" value="">
												<input type="hidden" name="commission_rate" id="commission_rate" value="">
												<input type="hidden" name="paymethod_id" id="paymethod_id" value="">
												<input type="text" name="paymethod" id="paymethod" value="" readonly>
											</cfif>
											<cfset card_link="&field_card_payment_id=form_basket.card_paymethod_id&field_card_payment_name=form_basket.paymethod&field_commission_rate=form_basket.commission_rate">
											<span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_paymethods&function_name=change_paper_duedate&function_parameter=invoice_date&field_id=form_basket.paymethod_id&field_name=form_basket.paymethod&field_dueday=form_basket.basket_due_value#card_link#</cfoutput>','list');"></span>
										</div>
									</div>
								</div>
								<div class="form-group" id="item-basket_due_value">
									<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='57640.Vade'></label>
									<div class="col col-8 col-xs-12">
										<div class="col col-3 col-sm-6">
											<input type="text" name="basket_due_value" id="basket_due_value" value="<cfif isdefined('get_sale_det.due_date') and isdefined('get_sale_det.invoice_date') and len(get_sale_det.due_date) and len(get_sale_det.invoice_date)><cfoutput>#datediff('d',get_sale_det.invoice_date,get_sale_det.due_date)#</cfoutput></cfif>" onchange="change_paper_duedate('invoice_date');">
										</div>
										<div class="input-group">
											<cfif isdefined('get_sale_det.due_date') and len(get_sale_det.due_date)>
												<cfinput type="text" name="basket_due_value_date_" value="#dateformat(get_sale_det.due_date,dateformat_style)#" onChange="change_paper_duedate('invoice_date',1);" validate="#validate_style#" message="#message#" maxlength="10" readonly>
											<cfelse>
												<cfinput type="text" name="basket_due_value_date_" value="#dateformat(now(),dateformat_style)#" onChange="change_paper_duedate('invoice_date',1);" validate="#validate_style#" message="#message#" maxlength="10" readonly>
											</cfif>
											<span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="basket_due_value_date_"></span>
										</div>						
									</div>
								</div>
								<cfif session.ep.our_company_info.subscription_contract eq 1>
									<div class="form-group" id="item-subscription_id">
										<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='29502.Abone No'></label>
										<div class="col col-8 col-xs-12">
											
											<cfif isdefined("get_sale_det.subscription_id") and len(get_sale_det.subscription_id)>
												<cf_wrk_subscriptions width_info='140' subscription_id='#get_sale_det.subscription_id#' fieldid='subscription_id' fieldname='subscription_no' form_name='form_basket' img_info='plus_thin'>
											<cfelse>
												<cfif isdefined("attributes.subscription_id") and len(attributes.subscription_id)>
													<cf_wrk_subscriptions width_info='140' subscription_id='#attributes.subscription_id#'  fieldid='subscription_id' fieldname='subscription_no' form_name='form_basket' img_info='plus_thin'>
												<cfelse>
													<cf_wrk_subscriptions width_info='140' fieldid='subscription_id' fieldname='subscription_no' form_name='form_basket' img_info='plus_thin'>
												</cfif>
											</cfif>
										</div>
									</div>
								</cfif>
							</div>
							<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" sort="true" index="4">
								<div class="form-group" id="item-note">
									<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
									<div class="col col-8 col-xs-12">
										<textarea name="note" id="note"><cfif isdefined('get_sale_det.note') and len(get_sale_det.note)><cfoutput>#get_sale_det.note#</cfoutput></cfif></textarea>
									</div>
								</div>							
								<div class="form-group" id="item-tax_code">
									<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='30006.Vergi Kodu'></label>
									<div class="col col-8 col-xs-12">
										<input type="text" name="tax_code" id="tax_code" value="<cfif isdefined('get_sale_det.tax_code') and len(get_sale_det.tax_code)><cfoutput>#get_sale_det.tax_code#</cfoutput></cfif>">
									</div>
								</div>
								<cfif kasa.recordcount>
									<div class="form-group" id="item-cash_id">
										<label class="col col-4"><cf_get_lang dictionary_id='57163.Nakit Alış'><input type="Checkbox" name="cash" id="cash" onclick="ayarla_gizle_goster();" value="1" <cfif isdefined('get_sale_det.is_cash') and get_sale_det.is_cash eq 1> checked</cfif> ></label>
										<div class="col col-8" <cfif isdefined('get_sale_det.is_cash') and get_sale_det.is_cash neq 1> style="display:none;"</cfif> id="not_2">
											<select name="kasa" id="kasa">
												<cfoutput query="kasa">
													<option value="#cash_id#">#cash_name#-#cash_currency_id#
												</cfoutput>
											</select>
											<cfoutput query="kasa">
												<input type="hidden" name="str_kasa_parasi#cash_id#" id="str_kasa_parasi#cash_id#" value="#cash_currency_id#">
											</cfoutput>
										</div>
									</div>
								</cfif>
								<div class="form-group" id="item-is_return">
									<label class="col col-12"><cf_get_lang dictionary_id ='57318.Satış İade'><input type="Checkbox" name="is_return" id="is_return" value="1" <cfif isdefined('get_sale_det.IS_RETURN') and get_sale_det.IS_RETURN eq 1>checked</cfif> ></label>
								</div>
								<div class="form-group" id="item-add_info">
									<label class="col col-4"><cf_get_lang dictionary_id='57810.Ek Bilgi'></label>
									<div class="col col-8 col-xs-12">
										<cfif isdefined('attributes.iid') and len(attributes.iid)>
											<cf_wrk_add_info info_type_id="-8" info_id="#attributes.iid#" upd_page = "0" colspan="9">
										<cfelse>
											<cf_wrk_add_info info_type_id="-8" upd_page = "0" colspan="9">
										</cfif>
									</div>
								</div>
							</div>
						</cf_box_elements>
						<cf_box_footer>
							<cf_workcube_buttons is_upd='0' add_function='kontrol()'>
						</cf_box_footer>
					</cf_basket_form>
					<cfset attributes.basket_id = 33>
					<cfif not isdefined('attributes.iid') and not isdefined('attributes.stock_id') and not isdefined('attributes.stock_name') and not isdefined('attributes.convert_stocks_id') and not isdefined("attributes.receiving_detail_id")>
						<cfset attributes.form_add = 1>
					</cfif>
					<cfinclude template="../../objects/display/basket.cfm">
				</cfform>
			</div>
		</cf_box>
	</div>
	<script type="text/javascript">
	function changeProcessDate(){
			$("#process_date").val($("#invoice_date").val());
		}
		function order_show() {
			deger = form_basket.process_cat.options[form_basket.process_cat.selectedIndex].value;
			if(deger == 45 || deger == 49){
				goster(order_id_form);
			}
			else {
				gizle(order_id_form);
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
				if((form_basket.company_id.value.length!="" && form_basket.company_id.value!="") || (form_basket.consumer_id.value.length!="" && form_basket.consumer_id.value!=""))
				{
					str_irslink = '&is_from_invoice=1&is_purchase=1&is_return=0&order_id_liste=' + form_basket.order_id_listesi.value + '&company_id='+form_basket.company_id.value + '&consumer_id='+form_basket.consumer_id.value<cfif session.ep.isBranchAuthorization>+'&is_sale_store='+1</cfif>; 
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
	function kontrol()
	{
		<cfif isdefined("xml_show_process_stage") and len(xml_show_process_stage) and xml_show_process_stage eq 1>
			if(document.form_basket.process_stage.value == "") 
				{
					alert("<cf_get_lang dictionary_id ='41036.Lütfen Süreçlerinizi Tanimlayiniz veya Tanimlanan Süreçler Üzerinde Yetkiniz Yok'>!");
					return false;
				}
		</cfif>
        if(!paper_control(form_basket.invoice_number,'INVOICE',false)) return false;	
		if (!chk_period(form_basket.process_date,"İşlem")) return false;
		if (document.form_basket.company.value == ""  && document.form_basket.consumer_id.value == "")
		{ 
			alert ("<cf_get_lang dictionary_id='57183.Cari Hesap Seçmelisiniz'>!");
			return false;
		}
		if(form_basket.deliver_get.value==""){
			alert("<cf_get_lang dictionary_id='57285.Teslim Alan Seçiniz'>!");
			return false;			
		}		
		if(form_basket.department_id.value=="")
		{
			alert("<cf_get_lang dictionary_id='57284.Depo Seçiniz'>!");
			return false;
		}
		
		if(!chk_process_cat('form_basket')) return false;
		if(!check_display_files('form_basket')) return false;
		var int_cat_type = form_basket.process_cat.options[form_basket.process_cat.selectedIndex].value;
		if(int_cat_type == 64 || int_cat_type == 690)
		{
			if(form_basket.department_id.value=="")
			{
				alert("<cf_get_lang dictionary_id='57284.Depo Seçiniz'>!");
				return false;
			}
		}
		<cfif session.ep.our_company_info.is_lot_no eq 1>//şirket akış parametrelerinde lot no zorunlu olsun seçili ise
				row_count = window.basket.items.length;
				if(check_lotno('form_basket') != undefined && check_lotno('form_basket'))//işlem kategorisinde lot no zorunlu olsun seçili ise
					{
						if(row_count != undefined)
						{
							for(i=0;i<row_count;i++)
							{
								if(window.basket.items[i].STOCK_ID.length != 0)
								{
									get_prod_detail = wrk_safe_query('obj2_get_prod_name','dsn3',0,window.basket.items[i].STOCK_ID);
									if(get_prod_detail.IS_LOT_NO == 1)//üründe lot no takibi yapılıyor seçili ise
									{
										if(window.basket.items[i].LOT_NO.length == 0)
										{
											alert((i+1)+'. satırdaki '+ window.basket.items[i].PRODUCT_NAME + ' ürünü için lot no takibi yapılmaktadır!');
											return false;
										}
									}
								}
							}
						}
					}
				else
					{
						if(window.basket.items[0].STOCK_ID.length != 0)
						{
							get_prod_detail = wrk_safe_query('obj2_get_prod_name','dsn3',0,window.basket.items[0].STOCK_ID);
							if(get_prod_detail.IS_LOT_NO == 1)//üründe lot no takibi yapılıyor seçili ise
							{
								if(window.basket.items[0].LOT_NO == '')
								{
									alert((1)+'. satırdaki '+ window.basket.items[0].PRODUCT_NAME + ' ürünü için lot no takibi yapılmaktadır!');
									return false;
								}
							}
						}
					}
								
			</cfif>
		<cfif xml_paymethod_control>
			if(form_basket.paymethod.value == '' && form_basket.paymethod_id.value == '' || form_basket.paymethod.value == '' && form_basket.card_paymethod_id.value == '')
			{
				alert('<cf_get_lang dictionary_id="58027.Lüften Ödeme Yöntemi Seçiniz">');
				return false;	
			}
		</cfif>
		
		<cfif xml_shipmethod_control>
			if(form_basket.ship_method.value == '' && form_basket.ship_method_name.value == '')
			{
				alert('<cf_get_lang dictionary_id="45482.Lütfen Sevk Yöntemi Seçiniz">');
				return false;	
			}
		</cfif>
	<!---	if (!check_accounts('form_basket')) return false; process_cat eklenince açılacak
		if (!check_product_accounts()) return false; process_cat eklenince açılacak--->
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
		if(form_basket.cash != undefined && form_basket.cash.checked)
			not_2.style.display='';
		else
			not_2.style.display='none';	
	}
	</script>
	<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
	