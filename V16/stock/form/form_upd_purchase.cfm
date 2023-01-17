<cfsetting showdebugoutput="no">
<cf_get_lang_set module_name="stock"><!--- sayfanin en altinda kapanisi var --->
<cf_xml_page_edit fuseact="stock.form_add_purchase">
<cfif isnumeric(attributes.ship_id)>
	<cfset attributes.upd_id = url.ship_id>
	<cfset attributes.cat = "">
	<cfinclude template="../query/get_upd_purchase.cfm">
	<cfscript>
	if(get_upd_purchase.is_with_ship eq 1 and GET_INV_SHIPS.recordcount neq 0)
		session_basket_kur_ekle(action_id=GET_INV_SHIPS.INVOICE_ID,table_type_id:1,process_type:1);
	else
		session_basket_kur_ekle(action_id=attributes.ship_id,table_type_id:2,process_type:1);
	xml_all_depo = iif(isdefined("xml_location_auth"),xml_location_auth,DE('-1'));
	</cfscript>
	<cfset attributes.ship_type = get_upd_purchase.ship_type>
<cfelse>
	<cfset get_upd_purchase.recordcount = 0>
</cfif>
<cfif len(get_upd_purchase.SHIP_ID)>
    <cfquery name="GET_SF" datasource="#dsn2#">
        SELECT FIS_ID FROM STOCK_FIS WHERE RELATED_SHIP_ID = #get_upd_purchase.SHIP_ID# AND FIS_TYPE = 1182
    </cfquery>
</cfif>
<cfif not get_upd_purchase.recordcount>
	<cfset hata  = 11>
	<cfsavecontent variable="message"><cf_get_lang dictionary_id='57997.Şube Yetkiniz Uygun Değil'> <cf_get_lang dictionary_id='57998.veya'> <cf_get_lang dictionary_id='58943.Böyle Bir Kayıt Bulunmamaktadır'> !</cfsavecontent>
	<cfset hata_mesaj  = message>
	<cfinclude template="../../dsp_hata.cfm">
<cfelse> 
	<cfset attributes.company_id = get_upd_purchase.company_id>
	<cfset company_id = get_upd_purchase.company_id>
    <cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box>
		<div id="basket_main_div">
			<cfform name="form_basket" id="form_basket" method="post" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_upd_purchase">
				<cfquery name="get_ship_services" datasource="#dsn2#">
					SELECT DISTINCT SERVICE_ID FROM SHIP_ROW WHERE SHIP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ship_id#"> AND SERVICE_ID IS NOT NULL
				</cfquery>
				<cfquery name="get_ship_relation" datasource="#dsn2#">
				SELECT SHIP_NUMBER,ISNULL(PROJECT_ID,0),SHIP_ID,* FROM SHIP WHERE SHIP_ID IN(select ROW_ORDER_ID from SHIP_ROW where SHIP_ID  = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ship_id#">)
				</cfquery>
				<cfif get_ship_services.recordcount><cfset attributes.service_id = get_ship_services.service_id></cfif>
				<cf_basket_form id="form_upd_purchase">
					<cfoutput>
						<input type="hidden" name="form_action_address" id="form_action_address" value="#listgetat(attributes.fuseaction,1,'.')#.emptypopup_upd_purchase">
						<input type="hidden" name="service_id" id="service_id" value="<cfif isdefined('attributes.service_id') and len(attributes.service_id)>#attributes.service_id#</cfif>">
						<input type="hidden" name="active_period" id="active_period" value="#session.ep.period_id#">
						<input type="hidden" name="search_process_date" id="search_process_date" value="ship_date">
						<input type="hidden" name="upd_id" id="upd_id" value="#attributes.UPD_ID#">
						<input type="hidden" name="cat" id="cat" value="#get_upd_purchase.ship_type#">
					</cfoutput>
					<!------>
					<cf_box_elements vertical="0">
						<div class="col col-4 col-md-3 col-sm-3 col-xs-12" type="column" index="1" sort="true">					
							<div class="form-group" id="form_ul_process_cat">
								<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='61806.İşlem Tipi'></label>
								<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
									<cfif xml_kontrol_process_type eq 1>
										<cf_workcube_process_cat slct_width='150' process_cat="#get_upd_purchase.process_cat#" is_upd='1' process_type_info="#get_upd_purchase.ship_type#" onclick_function="control_consignment();">
									<cfelse>
										<cf_workcube_process_cat slct_width='150' process_cat="#get_upd_purchase.process_cat#" is_upd='1' onclick_function="control_consignment();">
									</cfif>
								</div>
							</div>                     
							<div class="form-group" id="form_ul_comp_name">
								<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57519.Cari Hesap'></label>
								<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
									<div class="input-group">
											<input type="hidden" name="company_id" id="company_id" value="<cfoutput>#get_upd_purchase.company_id#</cfoutput>">
											<cfif len(get_upd_purchase.company_id) and get_upd_purchase.company_id neq 0>
												<cfinput type="text" name="comp_name"  value="#get_par_info(get_upd_purchase.company_id,1,0,0)#">
											<cfelseif len(get_upd_purchase.consumer_id) and get_upd_purchase.consumer_id neq 0>
												<cfquery name="GET_CONS_NAME_UPD" datasource="#DSN#">
												SELECT
													CONSUMER_NAME,
													CONSUMER_SURNAME,
													COMPANY,
													CONSUMER_ID
												FROM
													CONSUMER WHERE CONSUMER_ID=#get_upd_purchase.consumer_id#
												</cfquery>
												<cfinput type="text" name="comp_name" value="#get_cons_name_upd.company#">
											<cfelse>
												<cfinput type="text" name="comp_name" value="">
											</cfif>
											<cfif xml_show_ship_address eq 1>
												<cfset str_linkeait = "&field_paymethod_id=form_basket.paymethod_id&field_basket_due_value=form_basket.basket_due_value&field_card_payment_id=form_basket.card_paymethod_id&field_city_id=form_basket.ship_address_city_id&field_county_id=form_basket.ship_address_county_id&field_comp_id2=form_basket.deliver_comp_id&field_consumer2=form_basket.deliver_cons_id&field_adress_id=form_basket.ship_address_id&field_long_address=form_basket.ship_address">
											<cfelse>
												<cfset str_linkeait = "&field_paymethod_id=form_basket.paymethod_id&field_basket_due_value=form_basket.basket_due_value&field_card_payment_id=form_basket.card_paymethod_id&field_comp_id2=form_basket.deliver_comp_id&field_consumer2=form_basket.deliver_cons_id">
											</cfif>
											<span class="input-group-addon icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_pars#str_linkeait#&select_list=2,3,1,9&field_emp_id=form_basket.employee_id&field_name=form_basket.partner_name&field_partner=form_basket.partner_id&field_comp_name=form_basket.comp_name&field_comp_id=form_basket.company_id&field_consumer=form_basket.consumer_id&come=stock&is_potansiyel=0&var_new=form_basket&ship_method_id=form_basket.ship_method&ship_method_name=form_basket.ship_method_name<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif></cfoutput>','list')"></span>
									</div>
								</div>
							</div>
							<div class="form-group" id="form_ul_partner_name">
								<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57578.Yetkili'></label>
								<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
									<cfoutput>
										<input type="hidden" name="partner_id" id="partner_id" value="#get_upd_purchase.partner_id#">
										<input type="hidden" name="consumer_id" id="consumer_id" value="#get_upd_purchase.consumer_id#">
										<input type="hidden" name="employee_id" id="employee_id" value="#get_upd_purchase.employee_id#">
									</cfoutput>
									<cfif len(get_upd_purchase.company_id) and get_upd_purchase.company_id neq 0>
										<input type="text" name="partner_name" id="partner_name" value="<cfoutput>#get_par_info(get_upd_purchase.partner_id,0,-1,0)#</cfoutput>">
									<cfelseif len(get_upd_purchase.consumer_id) and get_upd_purchase.consumer_id neq 0>
										<input type="text" name="partner_name" id="partner_name" value="<cfoutput>#get_cons_name_upd.consumer_name# #get_cons_name_upd.consumer_surname#</cfoutput>">
									<cfelse>
										<input type="text" name="partner_name" id="partner_name" value="<cfoutput>#get_emp_info(get_upd_purchase.employee_id,0,0)#</cfoutput>" readonly>
									</cfif>
								</div>
							</div>
							<div class="form-group" id="form_ul_deliver_get">
								<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57775.Teslim Alan'></label>
								<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
									<div class="input-group">
										<input type="hidden" name="deliver_get_id" id="deliver_get_id"  value="<cfoutput><cfif len(get_upd_purchase.deliver_emp_id)>#get_upd_purchase.deliver_emp_id#<cfelseif len(get_upd_purchase.deliver_par_id)>#get_upd_purchase.deliver_par_id#</cfif></cfoutput>">
										<input type="hidden" name="deliver_member_type" id="deliver_member_type" value="<cfif len(get_upd_purchase.deliver_emp_id)>employee<cfelseif len(get_upd_purchase.deliver_par_id)>partner</cfif>">
										<input type="text" name="deliver_get" id="deliver_get" value="<cfoutput><cfif len(get_upd_purchase.deliver_emp_id)>#get_emp_info(get_upd_purchase.deliver_emp_id,0,0)#<cfelseif len(get_upd_purchase.deliver_par_id)>#get_par_info(get_upd_purchase.deliver_par_id,0,0,0)#</cfif></cfoutput>" readonly>
										<span class="input-group-addon icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_name=form_basket.deliver_get&field_emp_id2=form_basket.deliver_get_id&field_type=form_basket.deliver_member_type&select_list=1,7</cfoutput>','list')"></span>
									</div>
								</div>
							</div>
							<cfif session.ep.our_company_info.subscription_contract eq 1>
								<div class="form-group" id="form_ul_subscription_no">
									<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='29502.Abone No'></label>
									<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
										<cfif xml_disable_system_change eq 0 and GET_SF.recordcount and len(get_upd_purchase.subscription_id)>
											<cfquery name="ct_get_subs" datasource="#DSN3#">
												SELECT SUBSCRIPTION_NO FROM SUBSCRIPTION_CONTRACT WHERE SUBSCRIPTION_ID = #get_upd_purchase.subscription_id# 
											</cfquery>
											<cfif get_module_user(11)>
												<cfoutput><a href="#request.self#?fuseaction=sales.list_subscription_contract&event=upd&subscription_id=#get_upd_purchase.subscription_id#" class="tableyazi" target="_blank">#ct_get_subs.SUBSCRIPTION_NO#</a></cfoutput>
											<cfelse>
												<cfoutput>#ct_get_subs.SUBSCRIPTION_NO#</cfoutput>
											</cfif>
										<cfelse>
											<cf_wrk_subscriptions subscription_id='#get_upd_purchase.subscription_id#' width_info='150' fieldId='subscription_id' fieldName='subscription_no' form_name='form_basket' img_info='plus_thin'>
										</cfif>
									</div>
								</div>
							</cfif>
							<cfif ListFind("1,2",xml_show_service_app)>
								<cfif Len(get_upd_purchase.service_id)>
									<cfquery name="get_service" datasource="#dsn3#">
										SELECT SERVICE_NO FROM SERVICE WHERE SERVICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_upd_purchase.service_id#">
									</cfquery>
								</cfif>
								<div class="form-group" id="form_ul_subscription_no">
									<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='45345.Servis Başvurusu'><cfif xml_show_service_app eq 2>*</cfif></label>
									<cfoutput>
									<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
										<div class="input-group">
											<input type="hidden" name="service_app_id" id="service_app_id" value="<cfif Len(get_upd_purchase.service_id)>#get_upd_purchase.service_id#</cfif>">
											<input type="text" name="service_app_no" id="service_app_no" value="<cfif Len(get_upd_purchase.service_id) and get_service.recordcount>#get_service.service_no#</cfif>" autocomplete="off">
											<span class="input-group-addon icon-ellipsis" onclick="windowopen('#request.self#?fuseaction=objects.popup_list_service&field_id=form_basket.service_app_id&field_no=form_basket.service_app_no&company_id='+document.getElementById('company_id').value +'<cfif session.ep.our_company_info.subscription_contract eq 1>&subscription_id='+ document.getElementById('subscription_id').value +'</cfif>','list');"></span>
										</div>
									</div>
									</cfoutput>
								</div>
							</cfif>
							<div class="form-group" id="item_td_ship_text_" <cfif not len(related_ship_id_with_period) and not listfind('73,74,75,77',get_upd_purchase.ship_type)>style="display:none;"</cfif>>
								<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57773.İrsaliye'></label>
								<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
									<div class="input-group">
										<cfoutput>
											<!---<input type="hidden" name="irsaliye_project_id_listesi" id="irsaliye_project_id_listesi" value="#get_ship_relation.PROJECT_ID#">
											<input type="hidden" name="irsaliye_id_listesi" id="irsaliye_id_listesi" value="#get_ship_relation.SHIP_ID#">
											<input type="text" name="irsaliye" id="irsaliye" value="#get_ship_relation.SHIP_NUMBER#" readonly>--->
											<cfif get_ship_relation.recordcount>
												<cfset related_ship_project_id_with_period = listappend(related_ship_project_id_with_period,get_ship_relation.PROJECT_ID)>
												<cfset related_ship_id_with_period =  listappend(related_ship_project_id_with_period,get_ship_relation.SHIP_ID)>
												<cfset related_ship_numbers =  listappend(related_ship_project_id_with_period,get_ship_relation.SHIP_NUMBER)>
											</cfif>
											<input type="hidden" name="irsaliye_project_id_listesi" id="irsaliye_project_id_listesi" value="#related_ship_project_id_with_period#">
											<input type="hidden" name="irsaliye_id_listesi" id="irsaliye_id_listesi" value="#related_ship_id_with_period#">
											<input type="text" name="irsaliye" id="irsaliye" value="#related_ship_numbers#" readonly>
											<span class="input-group-addon icon-ellipsis" onclick="add_irsaliye();"></span>
										</cfoutput>
									</div>
								</div>
							</div>
							<div class="form-group" id="form_ul_project_head">
								<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cfif session.ep.our_company_info.project_followup eq 1><cf_get_lang dictionary_id='57416.Proje'></cfif></label>
								<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
									<div class="input-group">
										<cfif session.ep.our_company_info.project_followup eq 1>
											<cfoutput>
											<input type="hidden" name="project_id" id="project_id" value="#get_upd_purchase.project_id#">
											<input type="text" name="project_head" id="project_head" value="<cfif len(get_upd_purchase.project_id)>#GET_PROJECT_NAME(get_upd_purchase.project_id)#</cfif>"  onFocus="AutoComplete_Create('project_head','PROJECT_ID,PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','form_basket','3','135')" autocomplete="off">
											<span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_projects&project_id=form_basket.project_id&project_head=form_basket.project_head');"></span>            
											<span class="input-group-addon" onclick="if(document.getElementById('project_id').value!='')windowopen('#request.self#?fuseaction=project.popup_list_project_actions&from_paper=SHIP&id='+document.getElementById('project_id').value+'','horizantal');else alert('Proje Seçiniz');">?</span> 
										
											</cfoutput>
										</cfif>
									</div>
								</div>
							</div>
						</div>
						<div class="col col-4 col-md-3 col-sm-3 col-xs-12" type="column" index="2" sort="true">
							<cfoutput>
								<div class="form-group" id="form_ul_ship_number">
									<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58138.İrsaliye No'></label>
									<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
										<cfsavecontent variable="message"><cf_get_lang dictionary_id='45975.İrsaliye No Girmelisiniz'></cfsavecontent>
										<cfinput type="text" name="ship_number" value="#get_upd_purchase.ship_number#" required="Yes" maxlength="50" message="#message#" onBlur="paper_control(this,'SHIP',false,#attributes.UPD_ID#,'#get_upd_purchase.ship_number#',form_basket.company_id.value,form_basket.consumer_id.value);">
									</div>
								</div>
							</cfoutput>
							<div class="form-group" id="form_ul_ship_date">
								<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='45874.İrsaliye Tarihi'></label>
								<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
									<div class="input-group">
										<cfsavecontent variable="message"><cf_get_lang dictionary_id='58503.Lütfen Tarih Giriniz'></cfsavecontent>
										<cfinput type="text" name="ship_date" id="ship_date" validate="#validate_style#" readonly value="#dateformat(get_upd_purchase.ship_date,dateformat_style)#" message="#message#" required="yes" onblur="change_deliver_date()&change_money_info('form_basket','ship_date');">
										<span class="input-group-addon"><cf_wrk_date_image date_field="ship_date" control_date="#dateformat(get_upd_purchase.ship_date,dateformat_style)#" call_function="change_deliver_date&change_money_info"></span>
									</div>
								</div>
							</div>
							<div class="form-group" id="item-action_date">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57879.İşlem Tarihi'></label>
								<div class="col col-8 col-xs-12">
									<div class="input-group">
										<cfsavecontent variable="message"><cf_get_lang dictionary_id='57906.İşlem Tarihi Girmelisiniz !'></cfsavecontent>
										<cfinput type="text" name="action_date" required="Yes" message="#message#" value="#dateformat( len( get_upd_purchase.action_date ) ? get_upd_purchase.action_date : now(),dateformat_style)#" validate="#validate_style#">
										<span class="input-group-addon btnPointer" title="<cf_get_lang dictionary_id='57734.seçiniz'>"><cf_wrk_date_image date_field="action_date"></span>
									</div>
								</div>
							</div>
							<cfif isDefined("xml_show_process_stage") and len(xml_show_process_stage) and xml_show_process_stage eq 1>
								<div class="form-group" id="item-process_stage">
									<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58859.Süreç'></label>
									<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
										<cf_workcube_process is_upd='0' select_value='#get_upd_purchase.process_stage#' process_cat_width='150' is_detail='1'>
									</div>
								</div>
							</cfif>
							<div class="form-group" id="form_ul_ref_no">
								<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58794.Referans No'></label>
								<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
									<input type="text"  maxlength="2000" name="ref_no"  id="ref_no" value="<cfoutput>#get_upd_purchase.ref_no#</cfoutput>">
								</div>
							</div>
							<div class="form-group" id="form_ul_order_id">
								<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57611.Sipariş'></label>
								<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
									<div class="input-group">
										<cfset order_date_list = ''>
										<cfif isdefined("get_order")>
											<cfoutput query="get_order">
												<cfset order_date_list = listappend(order_date_list,dateformat(get_order.ORDER_DATE,dateformat_style))>
											</cfoutput>
										</cfif>
										<input type="hidden" name="siparis_date_listesi" id="siparis_date_listesi" value="<cfif get_upd_purchase.recordcount><cfoutput>#order_date_list#</cfoutput></cfif>">
										<input type="hidden" name="order_id_listesi" id="order_id_listesi" value="<cfif get_upd_purchase.recordcount><cfoutput>#ValueList(get_order.order_id)#</cfoutput></cfif>">
										<input type="text" name="order_id" id="order_id" value="<cfif get_upd_purchase.recordcount><cfoutput>#ListSort(valuelist(get_order_num.order_number),'text')#</cfoutput></cfif>" readonly>
										<span class="input-group-addon icon-ellipsis" onClick="add_order();" id="stock_order_add_btn"></span>
									</div>
								</div>
							</div>
							<cfif xml_show_ship_address eq 1>
								<cfoutput>
									<div class="form-group" id="form_ul_ship_address">
										<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='29462.Yükleme Yeri'></label>
										<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
											<div class="input-group">
												<input type="hidden" name="ship_address_city_id" id="ship_address_city_id" value="#get_upd_purchase.city_id#">
												<input type="hidden" name="ship_address_county_id" id="ship_address_county_id" value="#get_upd_purchase.county_id#">
												<input type="hidden" name="deliver_comp_id" id="deliver_comp_id" value="#get_upd_purchase.deliver_comp_id#">
												<input type="hidden" name="deliver_cons_id" id="deliver_cons_id" value="#get_upd_purchase.deliver_cons_id#">
												<input type="hidden" name="ship_address_id" id="ship_address_id" value="#get_upd_purchase.ship_address_id#">
												<input type="text" name="ship_address" id="ship_address" maxlength="200" value="#get_upd_purchase.address#">
												<span class="input-group-addon icon-ellipsis" onClick="add_adress();"></span>
											</div>
										</div>
									</div>
								</cfoutput>
							</cfif>
						</div>
						<div class="col col-4 col-md-3 col-sm-3 col-xs-12" type="column" index="3" sort="true">
							<div class="form-group" id="form_ul_txt_departman_">
								<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58763.Depo'></label>
								<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
									<cfset location_info_ = get_location_info(get_upd_purchase.department_in,get_upd_purchase.location_in,1,1)>
									<cf_wrkdepartmentlocation
										returnInputValue="location_id,department_name,department_id,branch_id"
										returnQueryValue="LOCATION_ID,LOCATION_NAME,DEPARTMENT_ID,BRANCH_ID"
										fieldName="department_name"
										fieldid="location_id"
										department_fldId="department_id"
										branch_fldId="branch_id"
										branch_id="#listlast(location_info_,',')#"
										department_id="#get_upd_purchase.department_in#"
										location_id="#get_upd_purchase.location_in#"
										location_name="#listfirst(location_info_,',')#"
										xml_all_depo = "#xml_all_depo#"
										user_level_control="#session.ep.OUR_COMPANY_INFO.IS_LOCATION_FOLLOW#" 
										width="135"
										is_branch="1">
								</div>
							</div>
							<div class="form-group" id="form_ul_ship_method_name">
								<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57009.Fiili Sevk Tarihi'></label>
								<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
									<div class="input-group">
										<cfsavecontent variable="message"><cf_get_lang dictionary_id='45967.Fiili Sevk Tarihi Girmelisiniz'></cfsavecontent>
										<cfinput type="text" name="deliver_date_frm" id="deliver_date_frm"   value="#dateformat(get_upd_purchase.deliver_date,dateformat_style)#" validate="#validate_style#" message="#message#" required="yes">
										<span class="input-group-addon"><cf_wrk_date_image date_field="deliver_date_frm"></span>
									</div>
								</div>
								<cfoutput>
									<div class="col col-2 col-md-2 col-sm-2 col-xs-12">											
										<cfif len(get_upd_purchase.deliver_date)>
											<cfset value_deliver_date_h=hour(get_upd_purchase.deliver_date)>
											<cfset value_deliver_date_m=minute(get_upd_purchase.deliver_date)>
										<cfelse>
											<cfset value_deliver_date_h=0>
											<cfset value_deliver_date_m=0>
										</cfif>
											<cf_wrkTimeFormat name="deliver_date_h" value="#value_deliver_date_h#">
									</div>
									<div class="col col-2 col-md-2 col-sm-2 col-xs-12">	
										<select name="deliver_date_m" id="deliver_date_m">
											<cfloop from="0" to="59" index="i">
												<option value="#i#" <cfif value_deliver_date_m eq i>selected</cfif>><cfif i lt 10>0</cfif>#i#</option>
											</cfloop>
										</select>
									</div>	
								</cfoutput>										
							</div>
							<cfoutput>
								<div class="form-group" id="form_ul_ship_method_name">
									<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='29500.Sevk Yöntemi'></label>
									<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
										<div class="input-group">
											<input type="hidden" name="ship_method" id="ship_method" value="<cfif isdefined('get_upd_purchase.SHIP_METHOD') and len(get_upd_purchase.SHIP_METHOD)><cfoutput>#get_upd_purchase.SHIP_METHOD#</cfoutput></cfif>">
												<cfif isdefined('get_upd_purchase.SHIP_METHOD') and len(get_upd_purchase.SHIP_METHOD)>
													<cfset attributes.ship_method_id = get_upd_purchase.SHIP_METHOD>
													<cfinclude template="../query/get_ship_method.cfm">
													<cfset attributes.ship_method_name =get_ship_method.ship_method>
												</cfif>
												<input type="text" name="ship_method_name" id="ship_method_name" value="<cfif isdefined('attributes.ship_method_name') and len(attributes.ship_method_name)><cfoutput>#attributes.ship_method_name#</cfoutput></cfif>"  onfocus="AutoComplete_Create('ship_method_name','SHIP_METHOD','SHIP_METHOD','get_ship_method','','SHIP_METHOD_ID','ship_method','','3','135');" autocomplete="off">
												<span class="input-group-addon icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_ship_methods&field_name=ship_method_name&field_id=ship_method','medium');"></span>
										</div>
									</div>
								</div>
							</cfoutput>								
							<div class="form-group" id="form_ul_detail">
								<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='36199.Açıklama'></label>
								<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
									<textarea name="detail" id="detail"><cfoutput>#get_upd_purchase.ship_detail#</cfoutput></textarea>
								</div>
							</div>
							<div class="form-group" id="item-add_info">
								<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57810.Ek Bilgi'></label>
								<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
									<cf_wrk_add_info info_type_id="-14" info_id="#attributes.ship_id#" upd_page = "1" colspan="9">
								</div>
							</div>
							<div class="form-group" id="form_ul_irsaliye_iptal">
								<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='45679.İrsaliye İptal'></label>
								<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
									<input name="irsaliye_iptal" id="irsaliye_iptal" value="1" type="checkbox" <cfif len(get_upd_purchase.is_ship_iptal) and get_upd_purchase.is_ship_iptal eq 1>checked</cfif>>
								</div>
							</div>    
						</div>
					</cf_box_elements>
					<!------>
					<input type="hidden" name="basket_due_value" id="basket_due_value" value="<cfif len(get_upd_purchase.due_date) and len(get_upd_purchase.ship_date)><cfoutput>#datediff('d',get_upd_purchase.ship_date,get_upd_purchase.due_date)#</cfoutput></cfif>">
					<cfif len(get_upd_purchase.paymethod_id)>
						<cfset attributes.paymethod_id = get_upd_purchase.paymethod_id>
						<cfinclude template="../query/get_paymethod.cfm">
						<input type="hidden" name="paymethod_id" id="paymethod_id" value="<cfoutput>#paymethod.paymethod_id#</cfoutput>">
						<input type="hidden" name="card_paymethod_id" id="card_paymethod_id" value="">
						<input type="hidden" name="commission_rate" id="commission_rate" value="">
					<cfelseif len(get_upd_purchase.card_paymethod_id)>
						<cfquery name="get_card_paymethod" datasource="#dsn3#">
						SELECT 
							CARD_NO
						<cfif get_upd_purchase.commethod_id eq 6> <!--- WW den gelen siparişlerin guncellemesi, (siparisin commethod_id si irsaliyeye tasınıyor) --->
							,PUBLIC_COMMISSION_MULTIPLIER AS COMMISSION_MULTIPLIER
						<cfelse>  <!--- EP VE PP den gelen siparişlerin guncellemesi --->
							,COMMISSION_MULTIPLIER 
						</cfif>
						FROM 
							CREDITCARD_PAYMENT_TYPE 
						WHERE 
							PAYMENT_TYPE_ID=#get_upd_purchase.card_paymethod_id#
						</cfquery>
						<cfoutput>
							<input type="hidden" name="paymethod_id" id="paymethod_id" value="">
							<input type="hidden" name="card_paymethod_id" id="card_paymethod_id" value="#get_upd_purchase.card_paymethod_id#">
							<input type="hidden" name="commission_rate" id="commission_rate" value="#get_card_paymethod.commission_multiplier#">
						</cfoutput>
					<cfelse>
						<input type="hidden" name="paymethod_id" id="paymethod_id" value="">
						<input type="hidden" name="card_paymethod_id" id="card_paymethod_id" value="">
						<input type="hidden" name="commission_rate" id="commission_rate" value="">
					</cfif>					
					<!--- Irsaliyenin bulundugu donem ile birlikte sonraki donemlerde de kullanilmis olabilir, hepsi gelmelidir, bu sekilde yeniden duzenledim FBS 20120316 --->
					<cfquery name="Get_Ship_Period" datasource="#dsn#">
						SELECT OUR_COMPANY_ID,PERIOD_YEAR FROM SETUP_PERIOD WHERE OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND PERIOD_YEAR >= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_year#"> ORDER BY PERIOD_YEAR ASC
					</cfquery>
					<cfif Get_Ship_Period.RecordCount>
						<cfquery name="get_inv" datasource="#dsn2#">
							<cfloop query="Get_Ship_Period">
								<cfset new_period_dsn = '#dsn#_#Get_Ship_Period.Period_Year#_#Get_Ship_Period.Our_Company_Id#'>
								SELECT INVOICE_NUMBER,SHIP_NUMBER,IS_WITH_SHIP FROM #new_period_dsn#.INVOICE_SHIPS WHERE SHIP_ID = #get_upd_purchase.ship_id# AND SHIP_PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">
								<cfif Get_Ship_Period.currentrow neq Get_Ship_Period.recordcount>UNION ALL</cfif>
							</cfloop>
						</cfquery>
					</cfif>					
					<cf_box_footer>
						<div class="col col-6 col-xs-12">
							<cf_record_info query_name="get_upd_purchase">
							<input type="hidden" name="del" id="del" value="">
						</div>
						<div class="col col-6 col-xs-12">
							<cfquery name="get_our_comp_inf" datasource="#dsn#">
								SELECT IS_SHIP_UPDATE FROM OUR_COMPANY_INFO WHERE COMP_ID = #session.ep.company_id#
							</cfquery>
							<cfif len(get_upd_purchase.is_with_ship) and get_upd_purchase.is_with_ship eq 1>
								<font color="FF0000"><cf_get_lang dictionary_id='64074.Bu İrsaliye, ilgili olduğu faturadan güncellenir'>!<cfif get_inv.recordcount><b> <cf_get_lang dictionary_id='58133.Fatura No'>: <cfoutput query="get_inv">#get_inv.invoice_number#<cfif get_inv.recordcount neq currentrow> , </cfif></cfoutput></b></cfif></font>
							<cfelseif isdefined('to_ship_id_list_') and len(to_ship_id_list_)>
								<font color="FF0000"><cf_get_lang dictionary_id='45681.Bu İrsaliye'>; <cfoutput> <cfloop from="1" to="#listlen(to_ship_id_list_)#" index="to_ship_i"><b> #listgetat(to_ship_id_list_,to_ship_i)#</b><cfif to_ship_i neq listlen(to_ship_id_list_)>, </cfif> </cfloop> </cfoutput> <cf_get_lang dictionary_id='49280.Nolu'><br/> <cfif listlen(to_ship_id_list_) eq 1><cf_get_lang dictionary_id='57773.İrsaliye'><cfelse><cf_get_lang dictionary_id='45872.İrsaliyeler'></cfif> <cf_get_lang dictionary_id='45683.İle İlişkilidir'> </font>
								<cfif get_inv.recordcount and get_inv.is_with_ship neq 1>
									<br/><br/><font color="FF0000"><cf_get_lang dictionary_id='41888.İrsaliyenin İlişkili Oldugu Faturalar'>:<cfoutput query="get_inv">#get_inv.invoice_number#<cfif get_inv.recordcount neq currentrow>,</cfif></cfoutput></font> 
								</cfif>
								<cfif( get_upd_purchase.ship_type eq 73 or get_upd_purchase.ship_type eq 74 or get_upd_purchase.ship_type eq 75 ) and len(get_our_comp_inf.IS_SHIP_UPDATE) and get_our_comp_inf.IS_SHIP_UPDATE eq 1><!--- Perakende Satış İade İrsaliyesi/Toptan Satış İade İrsaliyesi/Konsinye Çıkış İade İrsaliyesi MK 071119 --->
									<cf_workcube_buttons 
										is_upd='1' 
										is_delete='1'
										add_function='upd_form_function()' 
										del_function='cagir()'>
								</cfif>
							<cfelse>
								<cfif get_inv.recordcount and get_inv.is_with_ship neq 1>
									<font color="FF0000"><cf_get_lang dictionary_id='41888.İrsaliyenin İlişkili Oldugu Faturalar'>:<cfoutput query="get_inv">#get_inv.invoice_number#<cfif get_inv.recordcount neq currentrow>,</cfif></cfoutput></font> 
								</cfif>
								<cfquery name="delivered_control" datasource="#dsn2#"><!--- ürünlerin irsaliye dağıtımı bulunuyorsa irsaliyeyi silemesin. --->
									SELECT
										SHIP_ROW.WRK_ROW_ID
									FROM 	
										SHIP WITH (NOLOCK),
										SHIP_ROW WITH (NOLOCK)
									WHERE 
										SHIP.SHIP_TYPE = 76 
										AND SHIP.SHIP_ID = SHIP_ROW.SHIP_ID
										AND SHIP_ROW.DELIVER_DEPT IS NOT NULL
										AND SHIP.SHIP_ID = #attributes.ship_id#
										AND SHIP_ROW.WRK_ROW_ID IN (SELECT SHR.WRK_ROW_RELATION_ID FROM SHIP_ROW SHR,SHIP SH WHERE SHR.SHIP_ID=SH.SHIP_ID AND SH.SHIP_TYPE = 81)
								</cfquery>
								<cfif not get_inv.recordcount>
									<cfif delivered_control.recordcount>
										<cf_workcube_buttons 
											is_upd='1' 
											is_delete=false
											add_function='upd_form_function()' 
											del_function='cagir()'>
									<cfelse>
										<cf_workcube_buttons 
											is_upd='1' 
											is_delete=1 
											add_function='upd_form_function()' 
											del_function='cagir()'>
									</cfif>
								<cfelseif len(get_our_comp_inf.IS_SHIP_UPDATE) and get_our_comp_inf.IS_SHIP_UPDATE eq 1>
									<cf_workcube_buttons 
										is_upd='1' 
										is_delete=false 
										add_function='upd_form_function()' >
								</cfif>
							</cfif>
						</div>
					</cf_box_footer>
				</cf_basket_form>
				<cfif listgetat(attributes.fuseaction,1,'.') is 'service'>
					<cfset attributes.basket_id = 47>
				<cfelseif session.ep.isBranchAuthorization>
				<!--- subeden cagırılıyorsa sube basket sablonunu kullansın--->
					<cfset attributes.basket_id = 17> 
				<cfelse>
					<cfset attributes.basket_id = 11>
				</cfif>
				<cfinclude template="../../objects/display/basket.cfm">
			</cfform>
		</div>
    </cf_box>
</div>
<script type="text/javascript">
	function change_deliver_date()
	{//irsaliye tarihi değiştiğinde fiili sevk tarihi de değişir
		document.form_basket.deliver_date_frm.value = document.form_basket.ship_date.value;
	}
	function control_consignment()
	{
		var deger = document.form_basket.process_cat.options[document.form_basket.process_cat.selectedIndex].value;
		if(deger.length)
		{
			var fis_no = eval("document.form_basket.ct_process_type_" + deger);
			if(list_find('75,74,73',fis_no.value))
				document.getElementById('item_td_ship_text_').style.display = '';
			else
				document.getElementById('item_td_ship_text_').style.display = 'none';
		}
		<cfif xml_kontrol_inv_process_type eq 1 and GET_SF.recordcount>
			alert("<cf_get_lang dictionary_id='64070.Demirbaş Stok İade Fişi Olan İrsaliyenin İşlem Tipini Değiştiremezsiniz'> !");
			return false;
		<cfelseif xml_kontrol_inv_process_type eq 1 and GET_SF.recordcount eq 0>
			var get_inv_control = wrk_safe_query("obj_get_process_cat","dsn3",0,deger);
			if(get_inv_control.IS_ADD_INVENTORY == 1)
			{
				alert("<cf_get_lang dictionary_id='64069.Demirbaş Stok İade Fişi Kaydeden İşlem Tipini Seçemezsiniz'> !");
				return false;
			}
		</cfif>
	}
	function add_irsaliye()
	{
		if(form_basket.company_id.value.length || form_basket.consumer_id.value.length || form_basket.employee_id.value.length)
		{ 
			str_irslink = '&irsaliye_project_id_listesi='+form_basket.irsaliye_project_id_listesi.value+'&ship_id_liste=' + form_basket.irsaliye_id_listesi.value + '&id=sale&sale_product=0&company_id='+form_basket.company_id.value+'&consumer_id='+ form_basket.consumer_id.value+'&employee_id='+form_basket.employee_id.value<cfif session.ep.isBranchAuthorization>+'&is_store='+1</cfif>;
			<cfif session.ep.our_company_info.project_followup eq 1>
				if(form_basket.project_id.value!='' && form_basket.project_head.value!='')
					str_irslink = str_irslink+'&project_id='+form_basket.project_id.value;
			</cfif>
			<cfif xml_control_process_type eq 1>
				if(document.form_basket.process_cat.value == '')
				{
					alert("İşlem Tipi Seçmelisiniz !");
					return false;
				}
				str_irslink = str_irslink+'&process_cat='+form_basket.process_cat.value;
			</cfif>
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_choice_ship&from_ship=1&ship_project_liste=1' + str_irslink,'page');
			return true;
		}
		else
		{
			alert("<cf_get_lang dictionary_id='57715.Önce Üye Seçiniz'>!");
			return false;
		}
	
	}
	function add_order()
	{
		if((form_basket.company_id.value.length && form_basket.company_id.value!="") &&(form_basket.department_id.value.length && form_basket.department_id.value!=""))
		{	
			str_irslink = '&order_id_liste=' + form_basket.order_id_listesi.value + '&order_date_liste=' + form_basket.siparis_date_listesi.value + '&is_purchase=1&dept_id='+form_basket.department_id.value +'&company_id='+form_basket.company_id.value<cfif session.ep.isBranchAuthorization>+'&is_sale_store='+1</cfif>; //&id=purchase&sale_product=0
			<cfif session.ep.our_company_info.project_followup eq 1>
				if(form_basket.project_id.value!='' && form_basket.project_head.value!='')
					str_irslink = str_irslink+'&project_id='+form_basket.project_id.value;
			 </cfif>
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_orders_for_ship' + str_irslink , 'list_horizantal');
			return true;
		}
		else if (form_basket.company_id.value =="")
		{
			alert("<cf_get_lang dictionary_id='57715.Önce Üye Seçiniz'>!");
			return false;
		}
		else if (form_basket.department_id.value =="")
		{
			alert("<cf_get_lang dictionary_id='45372.Depo Seçiniz'>!");
			return false;
		}
	}
		
	function upd_form_function()
	{
		<cfif isDefined("xml_show_process_stage") and len(xml_show_process_stage) and xml_show_process_stage eq 1>
			if(document.form_basket.process_stage.value == "")
			{
				alert("<cf_get_lang dictionary_id='64071.Lütfen Süreçlerinizi Tanımlayiniz veya Tanımlanan Süreçler Üzerinde Yetkiniz Yok'>!");
				return false;
			}
		</cfif>	
		if(!paper_control(form_basket.ship_number,'SHIP',false,<cfoutput>#attributes.UPD_ID#,'#get_upd_purchase.ship_number#'</cfoutput>,form_basket.company_id.value,form_basket.consumer_id.value)) return false;
		if(!chk_period(form_basket.ship_date,"İşlem")) return false;
		<!--- FB 20080125 donem kontrolu eklendi alan zorunlulugu olmadigindan bu sekilde ekledim --->
		if(form_basket.deliver_date_frm.value.length)
		{
			if (!global_date_check_value("01/01/<cfoutput>#SESSION.EP.PERIOD_YEAR#</cfoutput>",form_basket.deliver_date_frm.value, '<cf_get_lang dictionary_id='59077.Lütfen Geçerli Bir Tarih Giriniz'>!'))
			return false;
		}
		if(!chk_process_cat('form_basket')) return false;
		if(form_basket.ship_date.value.length)
		{
			if (!global_date_check_value("01/01/<cfoutput>#SESSION.EP.PERIOD_YEAR#</cfoutput>",form_basket.ship_date.value, '<cf_get_lang dictionary_id='34133.İşlem Tarihi döneminize uygun değil'>!'))
				return false;
		}
		if(document.form_basket.department_name.value=="" || document.form_basket.department_id.value=="")
		{
			alert("<cf_get_lang dictionary_id='51805.Depo Seçmelisiniz'>!");
			return false;
		}
		<cfif xml_show_service_app eq 2> // Servis Basvuru Zorunlu ise
			if(document.getElementById("service_app_id").value == "" || document.getElementById("service_app_no").value == "")
			{
				alert("<cf_get_lang dictionary_id='63587.Girilmesi zorunlu alan'>: <cf_get_lang dictionary_id='49277.Servis Başvurusu'> !");
				return false;
			}
		</cfif>
		var deger = document.form_basket.process_cat.options[document.form_basket.process_cat.selectedIndex].value;
		if(deger != "<cfoutput>#get_upd_purchase.process_cat#</cfoutput>")
		{
			<cfif xml_kontrol_inv_process_type eq 1 and GET_SF.recordcount>
				alert("<cf_get_lang dictionary_id='64070.Demirbaş Stok İade Fişi Olan İrsaliyenin İşlem Tipini Değiştiremezsiniz'> !");
				return false;
			<cfelseif xml_kontrol_inv_process_type eq 1 and GET_SF.recordcount eq 0>
				var get_inv_control = wrk_safe_query("obj_get_process_cat","dsn3",0,deger);
				if(get_inv_control.IS_ADD_INVENTORY == 1)
				{
					alert("<cf_get_lang dictionary_id='64069.Demirbaş Stok İade Fişi Kaydeden İşlem Tipini Seçemezsiniz'> !");
					return false;
				}
			</cfif>
		}
		if (!check_display_files('form_basket')) return false;
		if(!chck_zero_stock()) return false;
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
		var deger = document.form_basket.process_cat.options[document.form_basket.process_cat.selectedIndex].value;
		var fis_no = eval("document.form_basket.ct_process_type_" + deger).value;
		<cfif xml_save_konsinye_iade eq 1>
			if(fis_no == 75){//konsinye irsaliye ise iliskili irsaliye kontrolu yapar
				if( window.basketManager !== undefined ){ 
					var bsk_rowCount = basketManagerObject.basketItems().length;
					if(bsk_rowCount){
						for(var str_i_row=0; str_i_row < bsk_rowCount; str_i_row++){
							if( basketManagerObject.basketItems()[str_i_row].product_id() != '' && basketManagerObject.basketItems()[str_i_row].wrk_row_relation_id() != ''){
								var get_inv_control  = wrk_safe_query("inv_get_ship_control2","dsn2",0,basketManagerObject.basketItems()[str_i_row].wrk_row_relation_id());	//ilişkili irsaliyeler
								if(get_inv_control.recordcount == 0){
									alert("<cf_get_lang dictionary_id='45292.İlişkili Konsinye Çıkışı Yok'>! <cf_get_lang dictionary_id='58230.Satır No'>: "+(str_i_row+1));
									return false;
								}
							}
							else if( basketManagerObject.basketItems()[str_i_row].product_id() != '' && basketManagerObject.basketItems()[str_i_row].wrk_row_relation_id() == ''){
								alert("<cf_get_lang dictionary_id='45292.İlişkili Konsinye Çıkışı Yok'>! <cf_get_lang dictionary_id='58230.Satır No'>: "+(str_i_row+1));
								return false;
							}
						}
					}
				}else{
					var bsk_rowCount = window.basket.items.length;
					if(bsk_rowCount){
						for(var str_i_row=0; str_i_row < bsk_rowCount; str_i_row++){
							if(window.basket.items[str_i_row].PRODUCT_ID != '' && window.basket.items[str_i_row].WRK_ROW_RELATION_ID != ''){
								var get_inv_control  = wrk_safe_query("inv_get_ship_control2","dsn2",0,window.basket.items[str_i_row].WRK_ROW_RELATION_ID);	//ilişkili irsaliyeler
								if(get_inv_control.recordcount == 0){
									alert("<cf_get_lang dictionary_id='45292.İlişkili Konsinye Çıkışı Yok'>! <cf_get_lang dictionary_id='58230.Satır No'>: "+(str_i_row+1));
									return false;
								}
							}
							else if(window.basket.items[str_i_row].PRODUCT_ID != '' && window.basket.items[str_i_row].WRK_ROW_RELATION_ID == ''){
								alert("<cf_get_lang dictionary_id='45292.İlişkili Konsinye Çıkışı Yok'>! <cf_get_lang dictionary_id='58230.Satır No'>: "+(str_i_row+1));
								return false;
							}
						}
					}
				}
			}
		</cfif>
		<cfif xml_control_process_type eq 1>
			if( window.basketManager !== undefined ){ 
				if(fis_no == 75)//konsinye irsaliye ise kontrol yapacak
				{
					var ship_product_list = '';
					var wrk_row_id_list_new = '';
					var amount_list_new = '';
					var bsk_rowCount = basketManagerObject.basketItems().length;
					if(bsk_rowCount){
						for(var str_i_row=0; str_i_row < bsk_rowCount; str_i_row++){
							if( basketManagerObject.basketItems()[str_i_row].product_id() != '' && basketManagerObject.basketItems()[str_i_row].wrk_row_relation_id() != '' && basketManagerObject.basketItems()[str_i_row].row_ship_id() != '' ){
								if(list_find(wrk_row_id_list_new,basketManagerObject.basketItems()[str_i_row].wrk_row_relation_id())){
									row_info = list_find(wrk_row_id_list_new,basketManagerObject.basketItems()[str_i_row].wrk_row_relation_id());
									amount_info = list_getat(amount_list_new,row_info);
									amount_info = parseFloat(amount_info) + parseFloat(filterNum(basketManagerObject.basketItems()[str_i_row].amount()));
									amount_list_new = list_setat(amount_list_new,row_info,amount_info);
								}
								else{
									wrk_row_id_list_new = wrk_row_id_list_new + ',' + basketManagerObject.basketItems()[str_i_row].wrk_row_relation_id();
									amount_list_new = amount_list_new + ',' + filterNum(basketManagerObject.basketItems()[str_i_row].amount());
								}
							}
						}
						for(var str_i_row=0; str_i_row < bsk_rowCount; str_i_row++){
							if( basketManagerObject.basketItems()[str_i_row].product_id() != '' && basketManagerObject.basketItems()[str_i_row].wrk_row_relation_id() != '' && basketManagerObject.basketItems()[str_i_row].row_ship_id() != '' ){
								var get_inv_control  = wrk_safe_query("inv_get_ship_control2","dsn2",0,basketManagerObject.basketItems()[str_i_row].wrk_row_relation_id());	//ilişkili irsaliyeler
								var get_inv_control2 = wrk_safe_query("inv_get_inv_control","dsn2",0,basketManagerObject.basketItems()[str_i_row].wrk_row_relation_id());	// ilişkili faturalar	
								if(list_len(basketManagerObject.basketItems()[str_i_row].row_ship_id(),';') > 1){
									new_period = list_getat(basketManagerObject.basketItems()[str_i_row].row_ship_id(),2,';');
									var get_period = wrk_safe_query("stk_get_period","dsn",0,new_period);
									new_dsn2 = "<cfoutput>#dsn#</cfoutput>"+"_"+get_period.PERIOD_YEAR+"_"+get_period.OUR_COMPANY_ID;	
								}
								else
									new_dsn2 = "<cfoutput>#dsn2#</cfoutput>";
								var get_ship_control = wrk_safe_query("stk_get_ship_control",new_dsn2,0, basketManagerObject.basketItems()[str_i_row].wrk_row_relation_id());
								
								row_info = list_find(wrk_row_id_list_new, basketManagerObject.basketItems()[str_i_row].wrk_row_relation_id());
								amount_info = list_getat(amount_list_new,row_info);
								var total_inv_amount =parseFloat(get_inv_control2.AMOUNT)+parseFloat(get_inv_control.AMOUNT)+parseFloat(amount_info);
								if(get_ship_control != undefined && get_ship_control.recordcount > 0 && get_ship_control.AMOUNT >0 && get_inv_control != undefined && get_inv_control.recordcount > 0 && total_inv_amount >0)
								{
									if(total_inv_amount > get_ship_control.AMOUNT)
										ship_product_list = ship_product_list + eval(str_i_row+1) + '.Satır : ' + basketManagerObject.basketItems()[str_i_row].product_name() + '\n';
								}
							}
						}
					}	
					if(ship_product_list != ''){
						alert("<cf_get_lang dictionary_id='64072.Aşağıda Belirtilen Ürünler İçin İade Miktarı Konsinye Miktarından Fazla Lütfen Ürünleri Kontrol Ediniz'> ! \n\n" + ship_product_list);
						return false;
					}
				}
				else if(fis_no == 74){//toptan satis iade irsaliye ise kontrol yapacak
					var ship_product_list = '';
					var wrk_row_id_list_new = '';
					var amount_list_new = '';
					var bsk_rowCount = basketManagerObject.basketItems().length;
					if(bsk_rowCount){
						for(var str_i_row=0; str_i_row < bsk_rowCount; str_i_row++){
							if( basketManagerObject.basketItems()[str_i_row].product_id() != '' && basketManagerObject.basketItems()[str_i_row].wrk_row_relation_id() != '' && basketManagerObject.basketItems()[str_i_row].row_ship_id() != '' ){
								if(list_find(wrk_row_id_list_new,basketManagerObject.basketItems()[str_i_row].wrk_row_relation_id())){
									row_info = list_find(wrk_row_id_list_new, basketManagerObject.basketItems()[str_i_row].wrk_row_relation_id());
									amount_info = list_getat(amount_list_new,row_info);
									amount_info = parseFloat(amount_info) + parseFloat(filterNum(basketManagerObject.basketItems()[str_i_row].amount()));
									amount_list_new = list_setat(amount_list_new,row_info,amount_info);
								}
								else{
									wrk_row_id_list_new = wrk_row_id_list_new + ',' + basketManagerObject.basketItems()[str_i_row].wrk_row_relation_id();
									amount_list_new = amount_list_new + ',' + filterNum(basketManagerObject.basketItems()[str_i_row].amount());
								}
							}
						}
						for(var str_i_row=0; str_i_row < bsk_rowCount; str_i_row++){
							if( basketManagerObject.basketItems()[str_i_row].product_id() != '' && basketManagerObject.basketItems()[str_i_row].wrk_row_relation_id() != '' && basketManagerObject.basketItems()[str_i_row].row_ship_id() != '' ){
								var get_inv_control  = wrk_safe_query("inv_get_ship_control3","dsn2",0, basketManagerObject.basketItems()[str_i_row].wrk_row_relation_id());	//ilişkili irsaliyeler
								if(list_len(basketManagerObject.basketItems()[str_i_row].row_ship_id(),';') > 1){
									new_period = list_getat(basketManagerObject.basketItems()[str_i_row].row_ship_id(),2,';');
									var get_period = wrk_safe_query("stk_get_period","dsn",0,new_period);
									new_dsn2 = "<cfoutput>#dsn#</cfoutput>"+"_"+get_period.PERIOD_YEAR+"_"+get_period.OUR_COMPANY_ID;	
								}
								else
									new_dsn2 = "<cfoutput>#dsn2#</cfoutput>";
								var get_ship_control = wrk_safe_query("stk_get_ship_control",new_dsn2,0, basketManagerObject.basketItems()[str_i_row].wrk_row_relation_id() );
								
								row_info = list_find(wrk_row_id_list_new,basketManagerObject.basketItems()[str_i_row].wrk_row_relation_id());
								amount_info = list_getat(amount_list_new,row_info);
								//var total_inv_amount =parseFloat(get_inv_control2.AMOUNT)+parseFloat(get_inv_control.AMOUNT)+parseFloat(amount_info);
								var total_inv_amount =parseFloat(get_inv_control.AMOUNT)+parseFloat(amount_info);
								if(get_ship_control != undefined && get_ship_control.recordcount > 0 && get_ship_control.AMOUNT >0 && get_inv_control != undefined && get_inv_control.recordcount > 0 && total_inv_amount >0){
									if(total_inv_amount > get_ship_control.AMOUNT)
										ship_product_list = ship_product_list + eval(str_i_row+1) + '.Satır : ' + basketManagerObject.basketItems()[str_i_row].product_name() + '\n';
								}
							}
						}
					}	
					if(ship_product_list != ''){
						alert("<cf_get_lang dictionary_id='64073.Aşağıda Belirtilen Ürünler İçin İade Miktarı Toptan Satış Miktarından Fazla Lütfen Ürünleri Kontrol Ediniz'> ! \n\n" + ship_product_list);
						return false;
					}
				}
			}
			else{
				if(fis_no == 75)//konsinye irsaliye ise kontrol yapacak
				{
					var ship_product_list = '';
					var wrk_row_id_list_new = '';
					var amount_list_new = '';
					var bsk_rowCount = window.basket.items.length;
					if(bsk_rowCount)
					{
						for(var str_i_row=0; str_i_row < bsk_rowCount; str_i_row++)
						{
							if(window.basket.items[str_i_row].PRODUCT_ID != '' && window.basket.items[str_i_row].WRK_ROW_RELATION_ID != '' && window.basket.items[str_i_row].ROW_SHIP_ID != '')
							{
								if(list_find(wrk_row_id_list_new,window.basket.items[str_i_row].WRK_ROW_RELATION_ID))
								{
									row_info = list_find(wrk_row_id_list_new,window.basket.items[str_i_row].WRK_ROW_RELATION_ID);
									amount_info = list_getat(amount_list_new,row_info);
									amount_info = parseFloat(amount_info) + parseFloat(filterNum(window.basket.items[str_i_row].AMOUNT));
									amount_list_new = list_setat(amount_list_new,row_info,amount_info);
								}
								else
								{
									wrk_row_id_list_new = wrk_row_id_list_new + ',' + window.basket.items[str_i_row].WRK_ROW_RELATION_ID;
									amount_list_new = amount_list_new + ',' + filterNum(window.basket.items[str_i_row].AMOUNT);
								}
							}
						}
						for(var str_i_row=0; str_i_row < bsk_rowCount; str_i_row++)
						{
							if(window.basket.items[str_i_row].PRODUCT_ID != '' && window.basket.items[str_i_row].WRK_ROW_RELATION_ID != '' && window.basket.items[str_i_row].ROW_SHIP_ID != '')
							{
								var get_inv_control  = wrk_safe_query("inv_get_ship_control2","dsn2",0,window.basket.items[str_i_row].WRK_ROW_RELATION_ID);	//ilişkili irsaliyeler
								var get_inv_control2 = wrk_safe_query("inv_get_inv_control","dsn2",0,window.basket.items[str_i_row].WRK_ROW_RELATION_ID);	// ilişkili faturalar	
								if(list_len(window.basket.items[str_i_row].ROW_SHIP_ID,';') > 1)
								{
									new_period = list_getat(window.basket.items[str_i_row].ROW_SHIP_ID,2,';');
									var get_period = wrk_safe_query("stk_get_period","dsn",0,new_period);
									new_dsn2 = "<cfoutput>#dsn#</cfoutput>"+"_"+get_period.PERIOD_YEAR+"_"+get_period.OUR_COMPANY_ID;	
								}
								else
									new_dsn2 = "<cfoutput>#dsn2#</cfoutput>";
								var get_ship_control = wrk_safe_query("stk_get_ship_control",new_dsn2,0, window.basket.items[str_i_row].WRK_ROW_RELATION_ID );
								
								row_info = list_find(wrk_row_id_list_new,window.basket.items[str_i_row].WRK_ROW_RELATION_ID);
								amount_info = list_getat(amount_list_new,row_info);
								var total_inv_amount =parseFloat(get_inv_control2.AMOUNT)+parseFloat(get_inv_control.AMOUNT)+parseFloat(amount_info);
								if(get_ship_control != undefined && get_ship_control.recordcount > 0 && get_ship_control.AMOUNT >0 && get_inv_control != undefined && get_inv_control.recordcount > 0 && total_inv_amount >0)
								{
									if(total_inv_amount > get_ship_control.AMOUNT)
										ship_product_list = ship_product_list + eval(str_i_row+1) + '.Satır : ' + window.basket.items[str_i_row].PRODUCT_NAME + '\n';
								}
							}
						}
					}	
					if(ship_product_list != '')
					{
						alert("<cf_get_lang dictionary_id='64072.Aşağıda Belirtilen Ürünler İçin İade Miktarı Konsinye Miktarından Fazla Lütfen Ürünleri Kontrol Ediniz'> ! \n\n" + ship_product_list);
						return false;
					}
				}
				else if(fis_no == 74)//toptan satis iade irsaliye ise kontrol yapacak
				{
					var ship_product_list = '';
					var wrk_row_id_list_new = '';
					var amount_list_new = '';
					var bsk_rowCount = window.basket.items.length;
					if(bsk_rowCount)
					{
						for(var str_i_row=0; str_i_row < bsk_rowCount; str_i_row++)
						{
							if(window.basket.items[str_i_row].PRODUCT_ID != '' && window.basket.items[str_i_row].WRK_ROW_RELATION_ID != '' && window.basket.items[str_i_row].ROW_SHIP_ID != '')
							{
								if(list_find(wrk_row_id_list_new,window.basket.items[str_i_row].WRK_ROW_RELATION_ID))
								{
									row_info = list_find(wrk_row_id_list_new,window.basket.items[str_i_row].WRK_ROW_RELATION_ID);
									amount_info = list_getat(amount_list_new,row_info);
									amount_info = parseFloat(amount_info) + parseFloat(filterNum(window.basket.items[str_i_row].AMOUNT));
									amount_list_new = list_setat(amount_list_new,row_info,amount_info);
								}
								else
								{
									wrk_row_id_list_new = wrk_row_id_list_new + ',' + window.basket.items[str_i_row].WRK_ROW_RELATION_ID;
									amount_list_new = amount_list_new + ',' + filterNum(window.basket.items[str_i_row].AMOUNT);
								}
							}
						}
						for(var str_i_row=0; str_i_row < bsk_rowCount; str_i_row++)
						{
							if(window.basket.items[str_i_row].PRODUCT_ID != '' && window.basket.items[str_i_row].WRK_ROW_RELATION_ID != '' && window.basket.items[str_i_row].ROW_SHIP_ID != '')
							{
								var get_inv_control  = wrk_safe_query("inv_get_ship_control3","dsn2",0,window.basket.items[str_i_row].WRK_ROW_RELATION_ID);	//ilişkili irsaliyeler
								//var get_inv_control2 = wrk_safe_query("inv_get_inv_control","dsn2",0,window.basket.items[str_i_row].WRK_ROW_RELATION_ID);	// ilişkili faturalar	
								if(list_len(window.basket.items[str_i_row].ROW_SHIP_ID,';') > 1)
								{
									new_period = list_getat(window.basket.items[str_i_row].ROW_SHIP_ID,2,';');
									var get_period = wrk_safe_query("stk_get_period","dsn",0,new_period);
									new_dsn2 = "<cfoutput>#dsn#</cfoutput>"+"_"+get_period.PERIOD_YEAR+"_"+get_period.OUR_COMPANY_ID;	
								}
								else
									new_dsn2 = "<cfoutput>#dsn2#</cfoutput>";
								var get_ship_control = wrk_safe_query("stk_get_ship_control",new_dsn2,0, window.basket.items[str_i_row].WRK_ROW_RELATION_ID );
								
								row_info = list_find(wrk_row_id_list_new,window.basket.items[str_i_row].WRK_ROW_RELATION_ID);
								amount_info = list_getat(amount_list_new,row_info);
								//var total_inv_amount =parseFloat(get_inv_control2.AMOUNT)+parseFloat(get_inv_control.AMOUNT)+parseFloat(amount_info);
								var total_inv_amount =parseFloat(get_inv_control.AMOUNT)+parseFloat(amount_info);
								if(get_ship_control != undefined && get_ship_control.recordcount > 0 && get_ship_control.AMOUNT >0 && get_inv_control != undefined && get_inv_control.recordcount > 0 && total_inv_amount >0)
								{
									if(total_inv_amount > get_ship_control.AMOUNT)
										ship_product_list = ship_product_list + eval(str_i_row+1) + '.Satır : ' + window.basket.items[str_i_row].PRODUCT_NAME + '\n';
								}
							}
						}
					}	
					if(ship_product_list != '')
					{
						alert("<cf_get_lang dictionary_id='64073.Aşağıda Belirtilen Ürünler İçin İade Miktarı Toptan Satış Miktarından Fazla Lütfen Ürünleri Kontrol Ediniz'> ! \n\n" + ship_product_list);
						return false;
					}
				}
			}
		</cfif>
		// xml de proje kontrolleri yapılsın seçilmişse
		<cfif xml_control_project eq 1>
		if(fis_no == 75)//konsinye irsaliye ise iliskili irsaliye kontrolu yapar
			{
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
									alert('<cf_get_lang dictionary_id='45301.İlgili İrsaliyeye Bağlı İrsaliyelerin Projeleri İle İrsaliyede Seçilen Proje Aynı Olmalıdır'>!');
									return false;
								}
						}						
				}
				else if(document.form_basket.project_head.value != '' && irsaliye_deger_list == ''){
					alert('<cf_get_lang dictionary_id='45301.İlgili İrsaliyeye Bağlı İrsaliyelerin Projeleri İle İrsaliyede Seçilen Proje Aynı Olmalıdır'>!')
						return false;
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
							var sonuc_ = datediff(document.form_basket.ship_date.value,tarih_,0);
							if(sonuc_ > 0)
								{
									alert('İrsaliye Tarihi Sipariş Tarihinden Önce Olamaz!');
									return false;
								}
						}
				}
		</cfif>
		<cfif (xml_disable_change eq 1 and GET_SF.recordcount) or (xml_return_disable_change eq 1 and isdefined("get_upd_purchase") and get_upd_purchase.is_from_return eq 1)>
			var bsk_rowCount = window.basket.items.length;
			if(bsk_rowCount != undefined){
				for(var str_i_row=0; str_i_row < bsk_rowCount; str_i_row++)
				{
					window.basket.items[str_i_row].AMOUNT.removeAttribute('disabled');
				}
			}
		</cfif>
		<cfif isdefined("xml_show_process_stage") and len(xml_show_process_stage) and xml_show_process_stage eq 1>
			return (process_cat_control() && saveForm());
		<cfelse>
			return (saveForm());
		</cfif>
		return false;
	}
	
	function cagir()
	{
		<cfoutput>
		<cfquery name="GET_SERIALS" datasource="#DSN2#">
        	SELECT SERIAL_NO FROM #dsn3_alias#.SERVICE_GUARANTY_NEW WHERE PROCESS_ID = #url.ship_id# AND PROCESS_CAT = #attributes.SHIP_TYPE#
        </cfquery>
        <cfif GET_SERIALS.recordcount>
            <cfquery name="get_out_serials" datasource="#dsn2#"><!---çıkışı yapılmış serisi varmı? py 092014 --->
                SELECT SERIAL_NO FROM #dsn3_alias#.SERVICE_GUARANTY_NEW WHERE SERIAL_NO IN ('#valuelist(GET_SERIALS.SERIAL_NO)#') AND IN_OUT = 0
            </cfquery>
            <cfif get_out_serials.recordcount>
				if(!confirm("Çıkışı Yapılmış Seriler Bulunmaktadır. Silmek İstediğinize Emin Misiniz?")) return false;
            </cfif>
        </cfif>
        </cfoutput>
		if(!chk_period(form_basket.ship_date,"İşlem")) return false;
		if(!chk_process_cat('form_basket')) return false;
		if(!check_display_files('form_basket')) return false;
		if(!chck_zero_stock(1)) return false; //sadece silme işleminden cagrılırken 1 gönderiliyor
		<cfif len(get_inv.invoice_number)>
			if(!confirm("<cf_get_lang dictionary_id='45437.Bu irsaliye fatura ile ilişkilendirilmiş silmek istediğinizden emin misiniz'>?")) return false;
		</cfif>
		form_basket.del.value=1;
		saveForm();
		return false;
	}
	function chck_zero_stock(is_del)
	{ 
		if(check_stock_action('form_basket'))
		{
			var basket_zero_stock_status = wrk_safe_query('inv_basket_zero_stock_status','dsn3',0,<cfoutput>#attributes.basket_id#</cfoutput>);
			if(basket_zero_stock_status.IS_SELECTED != 1)//<!--- basket sablonunda sıfır stok ile calıs secilmemisse zero_stock kontrolu yapılır --->
			{
				var temp_process_cat = document.form_basket.process_cat.options[document.form_basket.process_cat.selectedIndex].value;
				var temp_process_type = eval("document.form_basket.ct_process_type_" + temp_process_cat);
				if(!zero_stock_control(form_basket.department_id.value,form_basket.location_id.value,form_basket.upd_id.value,temp_process_type.value,0,is_del)) return false;
			}
		}
		return true;
	}
	<cfif (xml_disable_change eq 1 and GET_SF.recordcount) or (xml_return_disable_change eq 1 and isdefined("get_upd_purchase") and get_upd_purchase.is_from_return eq 1)>
		
			var bsk_rowCount = form_basket.amount.length;
			if(bsk_rowCount){
				for(var str_i_row=0; str_i_row < bsk_rowCount; str_i_row++)
				{
					document.form_basket.amount[str_i_row].setAttribute('disabled','yes');
				}
			}
		gizle(stock_order_add_btn);
		gizle(basket_header_add);
		gizle(sepetim_search);
		<cfloop from="1" to="#ArrayLen(sepet.satir)#" index="ccc">
			<cfoutput>gizle(basket_row_add_#ccc#);</cfoutput>
		</cfloop>
	</cfif>
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
			alert("<cf_get_lang dictionary_id='56901.Cari Hesap Seçmelisiniz'>");
			return false;
		}
	}
</script>
</cfif>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
