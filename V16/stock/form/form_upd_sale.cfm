<cfsetting showdebugoutput="yes">
<cf_get_lang_set module_name="stock"><!--- sayfanin en altinda kapanisi var --->
<cf_xml_page_edit fuseact="stock.form_add_sale">
<cfset attributes.upd_id = url.ship_id>
<cfset attributes.cat ="">
<cfinclude template="../query/get_upd_purchase.cfm">
<cfscript>
if(get_upd_purchase.is_with_ship eq 1 and GET_INV_SHIPS.recordcount neq 0)
	session_basket_kur_ekle(action_id=GET_INV_SHIPS.INVOICE_ID,table_type_id:1,process_type:1);
else
	session_basket_kur_ekle(action_id=attributes.ship_id,table_type_id:2,process_type:1);
xml_all_depo = iif(isdefined("xml_location_auth"),xml_location_auth,DE('-1'));
</cfscript>
<cfquery name="CONTROL_SHIP_RESULT" datasource="#DSN2#">
	SELECT
		SR.SHIP_ID,
		S.SHIP_RESULT_ID
	FROM
		SHIP_RESULT_ROW SR,
		SHIP_RESULT S
	WHERE
		S.SHIP_RESULT_ID = SR.SHIP_RESULT_ID AND
		SR.SHIP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ship_id#"> AND
		S.IS_TYPE IS NULL
</cfquery>
<cfif isDefined('get_upd_purchase.paymethod_id') and len(get_upd_purchase.paymethod_id)>
	<cfquery name="get_pay_meyhod" datasource="#dsn#">
		SELECT PAYMETHOD,DUE_DAY FROM SETUP_PAYMETHOD WHERE PAYMETHOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_upd_purchase.paymethod_id#">
	</cfquery>
</cfif>
<cfset attributes.ship_type = get_upd_purchase.ship_type>
<cfif not get_upd_purchase.recordcount>
	<cfset hata  = 11>
	<cfsavecontent variable="message"><cf_get_lang_main no='585.Şube Yetkiniz Uygun Değil'> <cf_get_lang_main no='586.Veya'> <cf_get_lang_main no='1531.Böyle Bir Kayıt Bulunmamaktadır'> !</cfsavecontent>
	<cfset hata_mesaj  = message>
	<cfinclude template="../../dsp_hata.cfm">
<cfelse>
<cfset company_id = get_upd_purchase.company_id>
<cfset attributes.company_id = get_upd_purchase.company_id>
<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box>
		<div id="basket_main_div">
			<cfform name="form_basket" method="post" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_upd_sale">
				
				<cf_basket_form id="upd_sale">
					<cf_box_elements vertical="0">
						<cfquery name="get_ship_services" datasource="#DSN2#">
							SELECT DISTINCT SERVICE_ID FROM SHIP_ROW WHERE SHIP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ship_id#"> AND SERVICE_ID IS NOT NULL
						</cfquery>
						<cfif get_ship_services.recordcount><cfset attributes.service_id = get_ship_services.service_id></cfif>
						<cfoutput>
							<input type="hidden" name="form_action_address" id="form_action_address" value="#listgetat(attributes.fuseaction,1,'.')#.emptypopup_upd_sale">
							<input type="hidden" name="service_id" id="service_id" value="<cfif isdefined('attributes.service_id') and len(attributes.service_id)>#attributes.service_id#</cfif>">
							<input type="hidden" name="active_period" id="active_period" value="#session.ep.period_id#">
							<input type="hidden" name="type_id" id="type_id" value="#get_upd_purchase.ship_type#">
							<input type="hidden" name="upd_id" id="upd_id" value="#url.ship_id#">
							<input type="hidden" name="cat" id="cat" value="#get_upd_purchase.ship_type#">
							<input type="hidden" name="commethod_id" id="commethod_id" value="<cfif len(get_upd_purchase.commethod_id)>#get_upd_purchase.commethod_id#</cfif>">
							<input type="hidden" name="search_process_date" id="search_process_date" value="ship_date">
							<input type="hidden" name="del_ship" id="del_ship" value="0">
						</cfoutput>
						<div class="col col-4 col-md-4 col-sm-6 col-xs-12" id="column-1" type="column" index="1" sort="true">
							<cfif isdefined("xml_show_process_stage") and len(xml_show_process_stage) and xml_show_process_stage eq 1>
								<div class="form-group require" id="item-process_stage">
									<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id="58859.Süreç"></label>
									<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
										<cf_workcube_process is_upd='0' process_cat_width='125' is_detail='1' select_value='#get_upd_purchase.process_stage#'>
									</div>                
								</div>
							</cfif>
							<div class="form-group" id="item-process_cat">
								<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang_main no='388.İşlem Tipi'></label>
								<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
									<cfif xml_kontrol_process_type eq 1>
										<cf_workcube_process_cat process_cat="#get_upd_purchase.process_cat#" is_upd='1' process_type_info="#get_upd_purchase.ship_type#" process_cat_width='100' onclick_function="check_process_is_sale();">
									<cfelse>
										<cf_workcube_process_cat process_cat="#get_upd_purchase.process_cat#" is_upd='1' process_cat_width='100' onclick_function="check_process_is_sale();">
									</cfif>              
								</div>                
							</div> 
							<div class="form-group" id="item-comp_name">
								<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang_main no='107.cari hesap'></label>
								<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
									<div class="input-group">
										<input type="hidden" name="company_id" id="company_id" value="<cfoutput>#get_upd_purchase.company_id#</cfoutput>">
										<cfif len(get_upd_purchase.company_id) and get_upd_purchase.company_id neq 0>
											<input type="text" name="comp_name" id="comp_name" value="<cfoutput>#get_par_info(get_upd_purchase.company_id,1,0,0)#</cfoutput>" readonly>
										<cfelseif len(get_upd_purchase.consumer_id) and get_upd_purchase.consumer_id neq 0>
											<cfquery name="GET_CONS_NAME_UPD" datasource="#DSN#">
												SELECT
													CONSUMER_NAME,
													CONSUMER_SURNAME,
													COMPANY,
													CONSUMER_ID
												FROM
													CONSUMER
												WHERE
										
													CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_upd_purchase.consumer_id#">
											</cfquery>
											<input type="text" name="comp_name" id="comp_name" value="<cfoutput>#get_cons_name_upd.company#</cfoutput>" readonly>
										<cfelse>
											<input type="text" name="comp_name" id="comp_name" value="" readonly>
										</cfif>
										<cfset str_linkeait = "&field_paymethod_id=form_basket.paymethod_id&field_country_id=form_basket.country_id&field_paymethod=form_basket.paymethod_name&&field_revmethod_id=form_basket.paymethod_id&field_revmethod=form_basket.paymethod_name&field_basket_due_value=form_basket.basket_due_value&ship_method_id=form_basket.ship_method&ship_method_name=form_basket.ship_method_name&field_card_payment_id=form_basket.card_paymethod_id&field_comp_id2=form_basket.deliver_comp_id&field_consumer2=form_basket.deliver_cons_id" >
										<span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_pars#str_linkeait#&is_cari_action=1&select_list=2,3,1,9&field_name=form_basket.partner_name&field_emp_id=form_basket.employee_id&field_partner=form_basket.partner_id&field_comp_name=form_basket.comp_name&field_comp_id=form_basket.company_id&field_consumer=form_basket.consumer_id&come=stock&is_potansiyel=0&field_long_address=form_basket.adres&field_city_id=form_basket.city_id&field_county_id=form_basket.county_id<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif></cfoutput>&call_function=add_general_prom()-check_member_price_cat()-change_paper_duedate()','list');"></span>

									</div>             
								</div>                
							</div> 
								<cfoutput>
									<input type="hidden" name="partner_id" id="partner_id" value="#get_upd_purchase.partner_id#">
									<input type="hidden" name="consumer_id" id="consumer_id" value="#get_upd_purchase.consumer_id#">
									<input type="hidden" name="employee_id" id="employee_id" value="#get_upd_purchase.employee_id#">
								</cfoutput>
							<div class="form-group" id="item-partner_name">
								<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang_main no='166.yetkili'></label>
								<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
									<cfif len(get_upd_purchase.partner_id) and  get_upd_purchase.partner_id neq 0>
										<input type="text" name="partner_name" id="partner_name" value="<cfoutput>#get_par_info(get_upd_purchase.partner_id,0,-1,0)#</cfoutput>" readonly>
									<cfelseif len(get_upd_purchase.consumer_id)>
										<input type="text" name="partner_name" id="partner_name" value="<cfoutput>#get_cons_info(get_upd_purchase.consumer_id,0,0)#</cfoutput>" readonly>
									<cfelse>
										<input type="text" name="partner_name" id="partner_name" value="<cfoutput>#get_emp_info(get_upd_purchase.employee_id,0,0)#</cfoutput>" readonly>
									</cfif>
								</div>                
							</div>   
							<div class="form-group" id="item-deliver_get">
								<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang_main no='363.teslim alan'></label>
								<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
									<div class="input-group">
										<input type="hidden" name="deliver_get_id" id="deliver_get_id" value="">
										<cfinput type="text" name="deliver_get" value="#get_upd_purchase.deliver_emp#" onFocus="AutoComplete_Create('deliver_get','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_PARTNER_NAME2,MEMBER_NAME2','get_member_autocomplete','\'1,2,3\'','PARTNER_ID','deliver_get_id','','3','250');" autocomplete="off">
										<span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_pars&select_list=1,2,3,4,5,6&field_name=form_basket.deliver_get&field_partner=form_basket.deliver_get_id&come=stock</cfoutput>','list');"></span>
									</div>             
								</div>                
							</div> 
							<div class="form-group" id="item-order_id">
								<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang_main no='199.sipariş'></label>
								<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
									<div class="input-group">
										<input type="hidden" name="order_system_id_list" id="order_system_id_list" value="<cfif GET_UPD_PURCHASE.recordcount><cfoutput>#ListSort(valuelist(get_order_num.subscription_id),'text')#</cfoutput></cfif>">
										<input type="hidden" name="order_id_listesi" id="order_id_listesi" value="<cfif GET_UPD_PURCHASE.recordcount><cfoutput>#ValueList(get_order.ORDER_ID)#</cfoutput></cfif>">
										<input type="text" name="order_id" id="order_id" value="<cfif GET_UPD_PURCHASE.recordcount><cfoutput>#ListSort(valuelist(get_order_num.ORDER_NUMBER),'text')#</cfoutput></cfif>"readonly>
										<span class="input-group-addon btnPointer icon-ellipsis" onclick="add_order();"></span>
									</div>             
								</div>                
							</div>
							<div class="form-group" id="item-sale_emp_name">
								<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang no = '52.Satış Çalışan'></label>
								<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
									<div class="input-group">
										<cfif len(get_upd_purchase.sale_emp)>
											<input type="hidden" name="sale_emp" id="sale_emp" value="<cfoutput>#get_upd_purchase.sale_emp#</cfoutput>">
											<input type="text" name="sale_emp_name" id="sale_emp_name" value="<cfoutput>#get_emp_info(get_upd_purchase.sale_emp,0,0)#</cfoutput>" onfocus="AutoComplete_Create('sale_emp_name','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','sale_emp','','3','150');" autocomplete="off">
										<cfelse>
											<input type="hidden" name="sale_emp" id="sale_emp" value="">
											<input type="text" name="sale_emp_name" id="sale_emp_name" value="" onfocus="AutoComplete_Create('sale_emp_name','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','sale_emp','','3','150');" autocomplete="off">
										</cfif>
										<span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=form_basket.sale_emp&field_name=form_basket.sale_emp_name&select_list=1','list');"></span>            
									</div>
								</div>                
							</div>
							<cfif session.ep.our_company_info.subscription_contract eq 1>
								<div class="form-group" id="item-subscription_no">
									<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang_main no='1420.Abone'><cf_get_lang_main no='75.No'></label>
									<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
										<cf_wrk_subscriptions subscription_id='#get_upd_purchase.subscription_id#' width_info='135' fieldid='subscription_id' fieldname='subscription_no' form_name='form_basket' img_info='plus_thin'>	
									</div>                
								</div>
							</cfif>    
						</div>
						<div class="col col-4 col-md-4 col-sm-6 col-xs-12" id="column-2" type="column" index="2" sort="true">
							<div class="form-group" id="item-ship_number">
								<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang_main no='726.Irsaliye No'></label>
								<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
									<cfsavecontent variable="message"><cf_get_lang no='118.irsaliye no girmelisiniz'></cfsavecontent>
									<cfinput type="text" name="ship_number" required="Yes" maxlength="50" value="#get_upd_purchase.ship_number#" message="#message#" onBlur="paper_control(this,'SHIP',true,'#url.ship_id#','#get_upd_purchase.ship_number#');">
								</div>                
							</div>
							<div class="form-group" id="item-ship_date">
								<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang_main no='330.tarih'></label>
								<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
									<div class="input-group">
										<cfsavecontent variable="message"><cf_get_lang_main no='1091.Lutfen Tarih Giriniz'></cfsavecontent>
										<cfinput type="text" name="ship_date" required="Yes" message="#message#" validate="#validate_style#" value="#dateformat(get_upd_purchase.ship_date,dateformat_style)#" onChange="change_date();" readonly>
										<span class="input-group-addon"><cf_wrk_date_image date_field="ship_date" call_function="add_general_prom&change_money_info&change_date" control_date="#dateformat(get_upd_purchase.ship_date,dateformat_style)#"></span>            
									</div>
								</div>                
							</div>
							<div class="form-group" id="item-deliver_date_frm">
								<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang no='127.fiili sevk tarih'></label>
								<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
									<div class="input-group">
										<cfsavecontent variable="message"><cf_get_lang no ='446.Lütfen Fiili Sevk Tarihini Giriniz'></cfsavecontent>
										<cfinput type="text" name="deliver_date_frm" validate="#validate_style#" value="#dateformat(get_upd_purchase.deliver_date,dateformat_style)#" message="#message#">
										<span class="input-group-addon"><cf_wrk_date_image date_field="deliver_date_frm"></span>
										<cfif isdefined('get_upd_purchase.deliver_date') and len(get_upd_purchase.deliver_date)>
											<cfset value_deliver_date_h=hour(get_upd_purchase.deliver_date)>
											<cfset value_deliver_date_m=minute(get_upd_purchase.deliver_date)>
										<cfelse>											
											<cfset adate = dateadd('h',session.ep.time_zone,now())>
											<cfset value_deliver_date_h=datepart("H",adate)>
											<cfset value_deliver_date_m=datepart("N",adate)>
										</cfif>
									</div>
								</div>								
								<cfoutput>
									<div class="col col-2 col-md-2 col-sm-2 col-xs-12">
										<cf_wrkTimeFormat name="deliver_date_h" value="#value_deliver_date_h#">
									</div>
									<div class="col col-2 col-md-2 col-sm-2 col-xs-12">
										<select name="deliver_date_m" id="deliver_date_m">
											<cfloop from="0" to="59" index="i">
												<option value="#NumberFormat(i)#" <cfif value_deliver_date_m eq i>selected</cfif>><cfif i lt 10>0</cfif>#NumberFormat(i)# </option>
											</cfloop>
										</select>														
									</div>
								</cfoutput>               
							</div>
							<div class="form-group" id="item-ref_no">
								<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang_main no='1372.Referans'></label>
								<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
									<input type="text" name="ref_no" id="ref_no" maxlength="600" value="<cfoutput>#get_upd_purchase.ref_no#</cfoutput>">
								</div>                
							</div>
							<div class="form-group" id="item-project_head">
								<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cfif session.ep.our_company_info.project_followup eq 1><cf_get_lang_main no='4.Proje'></cfif></label>
								<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
									<div class="input-group">
										<cfif session.ep.our_company_info.project_followup eq 1>
											<cfoutput>
												<input type="hidden" name="project_id" id="project_id" value="#get_upd_purchase.project_id#">
												<input type="text" name="project_head" id="project_head" value="<cfif len(get_upd_purchase.project_id)>#GET_PROJECT_NAME(get_upd_purchase.project_id)#</cfif>"  onfocus="AutoComplete_Create('project_head','PROJECT_ID,PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','form_basket','3','135')" autocomplete="off">
												<span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_projects&project_id=form_basket.project_id&project_head=form_basket.project_head');"></span>            
												<span class="input-group-addon" onclick="if(document.getElementById('project_id').value!='')windowopen('#request.self#?fuseaction=project.popup_list_project_actions&from_paper=SHIP&id='+document.getElementById('project_id').value+'','horizantal');else alert('Proje Seçiniz');">?</span> 
											</cfoutput>
										</cfif>  
									</div>
								</div>                
							</div>
							<div class="form-group" id="item-service_app_no">    
								<cfif Len(get_upd_purchase.service_id)>
									<cfquery name="get_service" datasource="#dsn3#">
										SELECT SERVICE_NO FROM SERVICE WHERE SERVICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_upd_purchase.service_id#">
									</cfquery>
								</cfif>             	
								<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='49277.Servis Başvuru'></label>
								<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
									<div class="input-group">
										<cfoutput>
											<input type="hidden" name="service_app_id" id="service_app_id" value="<cfif Len(get_upd_purchase.service_id)>#get_upd_purchase.service_id#</cfif>">
											<input type="text" name="service_app_no" id="service_app_no"  value="<cfif Len(get_upd_purchase.service_id) and get_service.recordcount>#get_service.service_no#</cfif>" autocomplete="off">  
											<span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('#request.self#?fuseaction=objects.popup_list_service&field_id=form_basket.service_app_id&field_no=form_basket.service_app_no&company_id='+document.getElementById('company_id').value +'<cfif session.ep.our_company_info.subscription_contract eq 1>&subscription_id='+ document.getElementById('subscription_id').value +'</cfif>','list');"></span> 
										</cfoutput>
									</div>
								</div>                
							</div> 
							<div class="form-group" id="item-irsaliye_iptal">
								<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang no ='502.İrsaliye İptal'></label>
								<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
									<input name="irsaliye_iptal" id="irsaliye_iptal" value="1" type="checkbox" <cfif len(get_upd_purchase.is_ship_iptal) and get_upd_purchase.is_ship_iptal eq 1>checked</cfif>>             
								</div>                
							</div>           
						</div>
						<div class="col col-4 col-md-4 col-sm-6 col-xs-12" id="column-3" type="column" index="3" sort="true">
							<div class="form-group" id="item-txt_departman_">
								<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang_main no='1351.Depo'></label>
								<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
									<cfset location_info_ = get_location_info(get_upd_purchase.deliver_store_id,get_upd_purchase.location,1,1)>  
									<cf_wrkdepartmentlocation 
										returninputvalue="location_id,txt_departman_,department_id,branch_id"
										returnqueryvalue="LOCATION_ID,LOCATION_NAME,DEPARTMENT_ID,BRANCH_ID"
										fieldname="txt_departman_"
										fieldid="location_id"
										department_fldid="department_id"
										branch_fldid="branch_id"
										branch_id="#listlast(location_info_,',')#"
										department_id="#get_upd_purchase.deliver_store_id#"
										location_id="#get_upd_purchase.location#"
										location_name="#listfirst(location_info_,',')#"
										xml_all_depo = "#xml_all_depo#"
										user_level_control="#session.ep.OUR_COMPANY_INFO.IS_LOCATION_FOLLOW#"
										dsp_service_loc="1"
										width="135">
								</div>                
							</div>
							<div class="form-group" id="item-adres">
								<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang no='125.sevk adresi'></label>
								<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
									<div class="input-group">
										<cfoutput>
											<cfsavecontent variable="message"><cf_get_lang no='114.sevk adresi girmelisiniz'></cfsavecontent>
											<input type="hidden" name="city_id" id="city_id" value="#get_upd_purchase.city_id#">
											<input type="hidden" name="county_id" id="county_id" value="#get_upd_purchase.county_id#">
											<input type="hidden" name="country_id" id="country_id" value="#get_upd_purchase.country_id#">
											<input type="hidden" name="ship_address_id" id="ship_address_id" value="#get_upd_purchase.ship_address_id#">
											<input type="hidden" name="deliver_comp_id" id="deliver_comp_id" value="#get_upd_purchase.deliver_comp_id#">
											<input type="hidden" name="deliver_cons_id" id="deliver_cons_id" value="#get_upd_purchase.deliver_cons_id#">
												<cfif len(trim(get_upd_purchase.address))>
													<cfif not x_change_deliver_address>
														<cfinput type="text" name="adres" id="adres" required="yes" message="#message#" value="#trim(get_upd_purchase.address)#" maxlength="200" readonly="yes">
													<cfelse>
														<cfinput type="text" name="adres" id="adres" required="yes" message="#message#" value="#trim(get_upd_purchase.address)#" maxlength="200">
													</cfif>
												<cfelse>
													<cfif not x_change_deliver_address>
														<cfinput type="text" name="adres" id="adres" required="yes" message="#message#" value="" maxlength="200" readonly="yes">
													<cfelse>
														<cfinput type="text" name="adres" id="adres" required="yes" message="#message#" value="" maxlength="200">
													</cfif>
												</cfif>
												<span class="input-group-addon btnPointer icon-ellipsis" onclick="add_adress();"></span>            
										</cfoutput>
									</div>
								</div>                
							</div>
							<div class="form-group" id="item-ship_method_name">
								<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang_main no='1703.sevk metod'></label>
								<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
									<div class="input-group">
										<input type="hidden" name="ship_method" id="ship_method" value="<cfoutput>#get_upd_purchase.ship_method#</cfoutput>">
										<cfif len(get_upd_purchase.ship_method)>
											<cfset attributes.ship_method_id=get_upd_purchase.ship_method>					
											<cfinclude template="../query/get_ship_method.cfm">
										</cfif>
										<input type="text" name="ship_method_name" id="ship_method_name" value="<cfif len(get_upd_purchase.ship_method)><cfoutput>#get_ship_method.ship_method#</cfoutput></cfif>" maxlength="200" onfocus="AutoComplete_Create('ship_method_name','SHIP_METHOD','SHIP_METHOD','get_ship_method','','SHIP_METHOD_ID','ship_method','','3','150');" autocomplete="off">
										<span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_ship_methods&field_name=form_basket.ship_method_name&field_id=form_basket.ship_method','list');"></span>            
									</div>
								</div>                
							</div>		
							<div class="form-group" id="item-paymethod">
								<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang_main no='1104.Ödeme Yöntemi'></label><!----Ödeme yöntemi ve vade tarihi sonradan eklendi.. ERU ------->
								<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
									<div class="input-group">
										<cfif len(get_upd_purchase.paymethod_id)>
											<cfset attributes.paymethod_id=get_upd_purchase.paymethod_id>
											<cfinclude template="../query/get_paymethod.cfm">
											<input type="hidden" name="card_paymethod_id" id="card_paymethod_id" value="">
											<input type="hidden" name="commission_rate" id="commission_rate" value="">
											<input type="hidden" name="paymethod_id" id="paymethod_id" value="<cfoutput>#get_upd_purchase.paymethod_id#</cfoutput>">
											<input type="text" name="paymethod_name" id="paymethod_name" value="<cfoutput>#get_pay_meyhod.paymethod#</cfoutput>" readonly>
										<cfelseif len(get_upd_purchase.card_paymethod_id)>
											<cfquery name="get_card_paymethod" datasource="#dsn3#">
												SELECT 
													CARD_NO
													<cfif get_upd_purchase.commethod_id eq 6>
													,PUBLIC_COMMISSION_MULTIPLIER AS COMMISSION_MULTIPLIER
													<cfelse>
													,COMMISSION_MULTIPLIER 
													</cfif>
												FROM 
													CREDITCARD_PAYMENT_TYPE 
												WHERE 
													PAYMENT_TYPE_ID = #get_upd_purchase.card_paymethod_id#
											</cfquery>
											<cfoutput>
												<input type="hidden" name="paymethod_id" id="paymethod_id"  value="">
												<input type="hidden" name="card_paymethod_id"  id="card_paymethod_id" value="#get_upd_purchase.card_paymethod_id#">
												<input type="hidden" name="commission_rate" id="commission_rate" value="#get_card_paymethod.commission_multiplier#">
												<input type="text" name="paymethod_name" id="paymethod_name"  value="#get_card_paymethod.card_no#" readonly >
											</cfoutput>
										<cfelse>
											<input type="hidden" name="paymethod_id" id="paymethod_id" value="">
											<input type="hidden" name="card_paymethod_id" id="card_paymethod_id" value="">
											<input type="hidden" name="commission_rate" id="commission_rate" value="">
											<input type="text" name="paymethod_name" id="paymethod_name" value="" readonly>
										</cfif>
										<span class="input-group-addon btnPointer icon-ellipsis" title="<cf_get_lang_main no='322.seçiniz'>" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_paymethods&function_name=change_paper_duedate&field_dueday=form_basket.basket_due_value&field_id=form_basket.paymethod_id&field_name=form_basket.paymethod_name</cfoutput>','list');"></span>
									</div>
								</div>
							</div>
							<div class="form-group" id="item-basket_due_value">
								<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang_main no='228.Vade'></label>
								<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
									<input type="text" name="basket_due_value" id="basket_due_value"  onchange="change_paper_duedate('ship_date');" value="<cfif isDefined('get_upd_purchase.due_date') and len(get_upd_purchase.due_date) and isDefined('get_upd_purchase.ship_date') and len(get_upd_purchase.ship_date)><cfoutput>#datediff('d',get_upd_purchase.ship_date,get_upd_purchase.due_date)#</cfoutput></cfif>">
								</div>
								<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
									<div class="input-group">										
										<cfinput type="text" name="basket_due_value_date_"  onChange="change_paper_duedate('ship_date',1);" value="" validate="" message="#message#" maxlength="10" readonly>
										<span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="basket_due_value_date_"></span>
									</div>
								</div>
							</div>
							<div class="form-group" id="item-detail">
								<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang_main no='217.Acıklama'></label>
								<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
									<textarea name="detail" id="detail" ><cfoutput>#get_upd_purchase.ship_detail#</cfoutput></textarea>	              
								</div>                
							</div>							
							<div class="form-group" id="item-irsaliye">
								<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><div id="td_ship_text_" <cfif not len(related_ship_id_with_period) and not listfind('75,77',get_upd_purchase.ship_type)>style="display:none;"</cfif>><cf_get_lang_main no='361.İrsaliye'></div></label>
								<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
									<div class="input-group" style="display:none;" id="td_ship_id_">
											<cfoutput>
											<input type="hidden" name="irsaliye_id_listesi" id="irsaliye_id_listesi" value="#related_ship_id_with_period#">
											<input type="text" name="irsaliye" id="irsaliye"  value="#related_ship_numbers#" readonly>
											<span class="input-group-addon icon-ellipsis btnPointer" onclick="add_irsaliye();"></span>
											</cfoutput>
									</div>
								</div>                
							</div>
							<div class="form-group" id="item-wrk_add_info">
								<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cfoutput>#getlang('main',398)#</cfoutput></label>
								<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
									<cf_wrk_add_info info_type_id="-31" info_id="#attributes.ship_id#" upd_page = "1" colspan="9">
								</div>
							</div>
							<input type="hidden" name="del" id="del" value="">
							<cfquery name="PACKEGE_CONTROL" datasource="#DSN2#">
								SELECT SHIP_ID FROM SHIP_PACKAGE_LIST WHERE SHIP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ship_id#">
							</cfquery>
							<cfif PACKEGE_CONTROL.recordcount>
								<span class="font-green bold"> <cf_get_lang no ='503.Paket Kontrol Yapıldı'>!</span>
							</cfif>
							<cfquery name="GET_SF" datasource="#dsn2#">
								SELECT FIS_ID FROM STOCK_FIS WHERE RELATED_SHIP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_upd_purchase.ship_id#">
							</cfquery><!--- irsaliye ve demirbaş bağlantısı kontrol ediliyor, eğerki irsalieye bağlı demirbş stok fişinin demirbaşların ilişkili olduğu başka bir irsaliye varsa silme güncelleme vs işlemi yapılmaz, yoksa demirbaşlar silinip yeniden oluşturulur. --->
							<cfif get_sf.recordcount>
								<cfquery name="GET_INVENTORY" datasource="#dsn3#">
									SELECT		
										INVENTORY_ID
									FROM
										INVENTORY_ROW
									WHERE
										PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">
										AND ACTION_ID <> <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_SF.FIS_ID#">
										AND PROCESS_TYPE = 1182
										AND INVENTORY_ID IN (SELECT INVENTORY_ID FROM INVENTORY_ROW WHERE ACTION_ID = #GET_SF.FIS_ID# AND PERIOD_ID = #session.ep.period_id#)
										AND SUBSCRIPTION_ID IS NOT NULL
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
										AND IR.ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_sf.fis_id#">
										AND IR.PERIOD_ID = #session.ep.period_id#
										AND IR.PROCESS_TYPE = 118
								</cfquery>
								<cfquery name="GET_SALE_COUNT" datasource="#DSN3#">
									SELECT 
										IR.INVENTORY_ROW_ID
									FROM 
										INVENTORY I,
										INVENTORY_ROW IR
									WHERE 
										I.INVENTORY_ID = IR.INVENTORY_ID
										AND IR.INVENTORY_ID IN(SELECT INVENTORY_ID FROM INVENTORY_ROW WHERE ACTION_ID = #GET_SF.FIS_ID#)
										AND IR.PROCESS_TYPE = 66
								</cfquery>
							<cfelse>
								<cfset get_sale_count.recordcount = 0>
								<cfset get_amortization_count.recordcount = 0>
								<cfset get_inventory.recordcount = 0>
							</cfif>
							<!-----<cfif len(get_upd_purchase.paymethod_id)>
								<cfset attributes.paymethod_id = get_upd_purchase.paymethod_id>
								<cfinclude template="../query/get_paymethod.cfm">
								<input type="hidden" name="paymethod_id" id="paymethod_id" value="<cfoutput>#paymethod.paymethod_id#</cfoutput>">
								<input type="hidden" name="card_paymethod_id" id="card_paymethod_id" value="">
								<input type="hidden" name="commission_rate" id="commission_rate" value="">
							<cfelseif len(get_upd_purchase.card_paymethod_id)>
								<cfquery name="GET_CARD_PAYMETHOD" datasource="#DSN3#">
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
										PAYMENT_TYPE_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#get_upd_purchase.card_paymethod_id#">
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
							</cfif>------>
							
							<!--- Irsaliyenin bulundugu donem ile birlikte sonraki donemlerde de kullanilmis olabilir, hepsi gelmelidir, bu sekilde yeniden duzenledim FBS 20120316 --->
							<cfquery name="Get_Ship_Period" datasource="#dsn#">
								SELECT OUR_COMPANY_ID,PERIOD_YEAR FROM SETUP_PERIOD WHERE OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND PERIOD_YEAR >= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_year#"> ORDER BY PERIOD_YEAR ASC
							</cfquery>
							<cfif Get_Ship_Period.RecordCount>
								<cfquery name="get_inv" datasource="#dsn2#">
									<cfloop query="Get_Ship_Period">
										<cfset new_period_dsn = '#dsn#_#Get_Ship_Period.Period_Year#_#Get_Ship_Period.Our_Company_Id#'>
										SELECT INVOICE_NUMBER,SHIP_NUMBER,IS_WITH_SHIP FROM #new_period_dsn#.INVOICE_SHIPS WHERE SHIP_ID = #GET_UPD_PURCHASE.SHIP_ID# AND SHIP_PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">
										<cfif Get_Ship_Period.currentrow neq Get_Ship_Period.recordcount>UNION ALL</cfif>
									</cfloop>
								</cfquery>
							</cfif>
							<cfif get_inv.recordcount and get_inv.is_with_ship neq 1>
								<label><cf_get_lang no ='501.İrsaliyenin İlişkili Oldugu Fatura Noları'>:<cfoutput query="get_inv">#get_inv.invoice_number#<cfif get_inv.recordcount neq currentrow>,</cfif></cfoutput></label>
							</cfif>
						</div>
					</cf_box_elements>			
					<cf_box_footer>
						<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
							<cf_record_info query_name="get_upd_purchase">									
						</div>
						<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
							<cfif get_inventory.recordcount or get_sale_count.recordcount gt 0 or (get_amortization_count.recordcount gt 0 and get_amortization_count.amortization_count gt 0 and len(get_amortization_count.amortization_count))>
								<font color="FF0000">İadesi,Satışı veya Değerlemesi Yapılmış Kayıtlar<br/> Olduğu İçin Güncelleme Yapamazsınız !</font><!--- irsaliyedeki demirbaşlar kendisinden başka bir  --->
							<cfelseif len(get_upd_purchase.IS_WITH_SHIP) and  get_upd_purchase.IS_WITH_SHIP eq 1 and get_inv.recordcount>
								<font color="FF0000"><cf_get_lang no ='257.Bu İrsaliye, ilgili olduğu faturadan güncellenir'>!<cfif get_inv.recordcount><b><cf_get_lang_main no='721.Fatura No'> : <cfoutput query="get_inv">#get_inv.invoice_number#</cfoutput></b></cfif></font>
							<cfelseif isdefined('to_ship_id_list_') and len(to_ship_id_list_)>
								<font color="FF0000"><cf_get_lang no ='504.Bu İrsaliye'>; <cfoutput> <cfloop from="1" to="#listlen(to_ship_id_list_)#" index="to_ship_i"> <b>#listgetat(to_ship_id_list_,to_ship_i)#</b><cfif to_ship_i neq listlen(to_ship_id_list_)>, </cfif> </cfloop> </cfoutput> <cfif listlen(to_ship_id_list_) eq 1><cf_get_lang_main no ='361.İrsaliye'><cfelse><cf_get_lang no ='308.İrsaliyeler'></cfif><cf_get_lang no ='506.İle İlişkilidir'>  </font>
								<cfif get_upd_purchase.process_cat eq 59 or get_upd_purchase.process_cat eq 60>
									<cf_workcube_buttons 
										is_upd='1'
										is_delete=1
										add_function='kontrol_firma()'
										del_function='kontrol2()'>
								</cfif>
							<cfelse>
								<cfquery name="GET_OUR_COMP_INF" datasource="#DSN#">
									SELECT IS_SHIP_UPDATE FROM OUR_COMPANY_INFO WHERE COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
								</cfquery>
								<cfif not get_inv.recordcount>
									<cf_workcube_buttons 
										is_upd='1'
										is_delete=1
										add_function='kontrol_firma()'
										del_function='kontrol2()'
										>
								<cfelseif len(get_our_comp_inf.is_ship_update) and get_our_comp_inf.is_ship_update eq 1>
									<cf_workcube_buttons 
										is_upd='1'
										is_delete=false
										add_function='kontrol_firma()'
										>
								</cfif>	
							</cfif>
						</div>
					</cf_box_footer> 
				</cf_basket_form>
				<cfif listgetat(attributes.fuseaction,1,'.') is 'service'>
					<cfset attributes.basket_id = 48> 
				<cfelseif session.ep.isBranchAuthorization><!--- subeden cagırılıyorsa sube basket sablonunu kullansın--->
					<cfset attributes.basket_id = 21> 
				<cfelse>
					<cfset attributes.basket_id = 10>
				</cfif>
				<cfinclude template="../../objects/display/basket.cfm">				
			</cfform>
		</div>
	</cf_box>
</div>
<!--- Bu form sevkiyat ekle icin eklendi. --->
<form name="add_packetship" id="add_packetship" method="post" action="<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_add_packetship</cfoutput>">
<cfoutput>
	<input type="hidden" name="ship_number"  value="#get_upd_purchase.ship_number#">
	<input type="hidden" name="city_id" id="city_id" value="#get_upd_purchase.city_id#">
	<input type="hidden" name="county_id" id="county_id" value="#get_upd_purchase.county_id#">
	<input type="hidden" name="country_id" id="country_id" value="#get_upd_purchase.country_id#">
	<input type="hidden" name="is_logistic2" id="is_logistic2" value="#attributes.ship_id#">
	<input type="hidden" name="branch_id" id="branch_id" value="#listlast(location_info_,',')#">
	<input type="hidden" name="department_id" id="department_id" value="#get_upd_purchase.deliver_store_id#">
	<input type="hidden" name="location_id" id="location_id" value="#get_upd_purchase.location#">
	<input type="hidden" name="department_name" id="department_name" value="#listfirst(location_info_,',')#">
	<input type="hidden" name="ship_method_id" id="ship_method_id" value="#get_upd_purchase.ship_method#">
	<input type="hidden" name="ship_method_name" id="ship_method_name" value="<cfif len(get_upd_purchase.ship_method)>#get_ship_method.ship_method#</cfif>">
	<input type="hidden" name="consumer_id" id="consumer_id" value="#get_upd_purchase.consumer_id#">
	<input type="hidden" name="company_id" id="company_id" value="#get_upd_purchase.company_id#">
	<input type="hidden" name="partner_id" id="partner_id" value="#get_upd_purchase.partner_id#">
	<input type="hidden" name="sending_address" id="sending_address" value="#trim(get_upd_purchase.address)#">
	<cfif len(get_upd_purchase.company_id)>
	<input type="hidden" name="company" id="company" value="#get_par_info(get_upd_purchase.company_id,1,0,0)#">
	<cfelse>
	<input type="hidden" name="company" id="company" value="">	
	</cfif>
	<cfif len(get_upd_purchase.partner_id)>
	<input type="hidden" name="member_name" id="member_name" value="#get_par_info(get_upd_purchase.partner_id,0,-1,0)#">
	<cfelse>
	<input type="hidden" name="member_name" id="member_name" value="#get_cons_info(get_upd_purchase.consumer_id,0,0)#">	
	</cfif>  
</cfoutput>
</form>
<script type="text/javascript">
function get_packetship() 
{
	<cfif control_ship_result.recordcount>
		document.location.href = '<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_packetship&event=upd&ship_result_id=#control_ship_result.SHIP_RESULT_ID#</cfoutput>';
	</cfif>
}
function change_date()
{
	document.form_basket.deliver_date_frm.value = document.form_basket.ship_date.value;
}
function add_order()
{
	if((form_basket.company_id.value.length!="" && form_basket.company_id.value!="") || (form_basket.consumer_id.value.length!="" && form_basket.consumer_id.value!="") || (form_basket.employee_id.value.length!="" && form_basket.employee_id.value!=""))
	{	
		str_irslink = '&order_id_liste=' + form_basket.order_id_listesi.value + '&is_purchase=0&company_id='+form_basket.company_id.value + '&consumer_id='+form_basket.consumer_id.value;
		<cfif session.ep.our_company_info.project_followup eq 1>
			if(form_basket.project_id.value!='' && form_basket.project_head.value!='')
				str_irslink = str_irslink+'&project_id='+form_basket.project_id.value;
		 </cfif>
		 str_irslink = str_irslink + '&order_system_id_list=form_basket.order_system_id_list';
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_orders_for_ship' + str_irslink , 'list_horizantal');
		return true;
	}
	//else if(form_basket.company_id.value =="" && form_basket.consumer_id.value == "" && form_basket.employee_id.value == "")
	else
	{
		alert("<cf_get_lang no='303.Önce Üye Seçiniz'>");
		return false;
	}
}
function add_irsaliye()
{
	if(form_basket.company_id.value.length || form_basket.consumer_id.value.length || form_basket.employee_id.value.length)
	{ 
		str_irslink = '&ship_id_liste=' + form_basket.irsaliye_id_listesi.value + '&id=sale&sale_product=1&company_id='+form_basket.company_id.value+'&consumer_id='+ form_basket.consumer_id.value+'&employee_id='+form_basket.employee_id.value<cfif session.ep.isBranchAuthorization>+'&is_store='+1</cfif>;
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
		</cfif>
		str_irslink = str_irslink+'&process_cat='+form_basket.process_cat.value;
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_choice_ship&from_ship=1' + str_irslink,'page');
		return true;
	}
	else
	{
		alert("<cf_get_lang no='303.Önce Üye Seçiniz'>!");
		return false;
	}
}
function kontrol_firma()
{
	change_paper_duedate('ship_date');
        var get_is_no_sale=wrk_query("SELECT NO_SALE FROM STOCKS_LOCATION WHERE DEPARTMENT_ID ="+document.getElementById('department_id').value+" AND LOCATION_ID ="+document.getElementById('location_id').value,"dsn");
        if(get_is_no_sale.recordcount)
        {
            var is_sale_=get_is_no_sale.NO_SALE;
            if(is_sale_==1)
            {
                alert("<cfoutput>#getlang('stock',223)#</cfoutput>!");
                return false;
            }
        }
	if(!paper_control(form_basket.ship_number,'SHIP',true,<cfoutput>'#url.ship_id#','#get_upd_purchase.ship_number#'</cfoutput>)) return false;
	if(!chk_period(form_basket.ship_date,"İşlem")) return false;
	if(form_basket.deliver_date_frm.value.length)
	{
		if (!global_date_check_value("01/01/<cfoutput>#SESSION.EP.PERIOD_YEAR#</cfoutput>",form_basket.deliver_date_frm.value, 'Lütfen Geçerli Bir Tarih Giriniz!'))
		return false;
	}
	if(!chk_process_cat('form_basket')) return false;
	<cfif isDefined("xml_show_process_stage") and len(xml_show_process_stage) and xml_show_process_stage eq 1>
			if(document.form_basket.process_stage.value == "")
			{
				alert("<cf_get_lang dictionary_id ='41036.Lütfen Süreçlerinizi Tanimlayiniz veya Tanimlanan Süreçler Üzerinde Yetkiniz Yok'>!");
				return false;
			}
		</cfif>	
	<cfif session.ep.our_company_info.subscription_contract eq 1>
		<cfif xml_control_order_system eq 1>
		if(document.form_basket.order_system_id_list.value != '' && document.form_basket.subscription_id.value == '')
			{
			alert('<cf_get_lang_main no="1420.Abone"><cf_get_lang_main no="322.Seçiniz">!');
			return false;
			}
		if(document.form_basket.order_system_id_list.value != '' && document.form_basket.subscription_id.value != '')
			{
			var system_list_uzunluk_ = list_len(document.form_basket.order_system_id_list.value);
			for(var str_i_row=1; str_i_row <= system_list_uzunluk_; str_i_row++)
				{
					var deger_ = list_getat(document.form_basket.order_system_id_list.value,str_i_row);
					if(deger_ != document.form_basket.subscription_id.value)
						{
						alert('İlgili İrsaliyeye Bağlı Siparişlerin Sistemleri İle İrsaliyede Seçilen Sistem Aynı Olmalıdır!');
						return false;
						}
				}
			}
		</cfif>
	</cfif>
	
	if(document.form_basket.txt_departman_.value=="" || document.form_basket.department_id.value=="")
	{
		alert("<cf_get_lang no ='507.Depo Seçmelisiniz'>!");
		return false;
	}
//		if(document.getElementById("service_app_id").value == "" || document.getElementById("service_app_no").value == "")
//		{
//			alert("Girilmesi Zorunlu Alan: Servis Başvurusu !");
//			return false;
//		}
	if (!check_display_files('form_basket')) return false;
	if(document.form_basket.irsaliye_iptal.checked == false)
	{
		if(check_stock_action('form_basket'))
		{
			var basket_zero_stock_status = wrk_safe_query('inv_basket_zero_stock_status','dsn3',0,<cfoutput>#attributes.basket_id#</cfoutput>);
			if(basket_zero_stock_status.IS_SELECTED != 1)//<!--- basket sablonunda sıfır stok ile calıs secilmemisse zero_stock kontrolu yapılır --->
			{
				var temp_process_cat = document.form_basket.process_cat.options[document.form_basket.process_cat.selectedIndex].value;
				var temp_process_type = eval("document.form_basket.ct_process_type_" + temp_process_cat);
				if(!zero_stock_control(form_basket.department_id.value,form_basket.location_id.value,form_basket.upd_id.value,temp_process_type.value)) return false;
			}
		}
	}
	if(check_inventory('form_basket'))//demirbaş kontrolleri
	{
		var control_inv_type = wrk_safe_query('stk_kontrol_inv_type','dsn3');
		if(control_inv_type.recordcount == 0)
		{
			alert("Demirbaş Stok Fişi İşlem Kategorisi Tanımlayınız !");
			return false;
		}
		inv_product_list='';
		
		if( window.basketManager !== undefined ){ 
			if( basketManagerObject.basketItems()[0].product_id() > 1){
				var bsk_rowCount = basketManagerObject.basketItems().length;
					for(var str_i_row=0; str_i_row < bsk_rowCount; str_i_row++){
					if( basketManagerObject.basketItems()[str_i_row].product_id() != '' ){
						var listParam = basketManagerObject.basketItems()[str_i_row].product_id() + "*" + "<cfoutput>#session.ep.period_id#</cfoutput>";
						var get_inventory_kontrol =  wrk_safe_query("stk_kontrol_inv_type2","dsn3",0,listParam);
						if(get_inventory_kontrol.recordcount == 0 || get_inventory_kontrol.INVENTORY_CAT_ID == '')
							inv_product_list = inv_product_list + eval(str_i_row+1) + '.Satır : ' + basketManagerObject.basketItems()[str_i_row].product_name() + '\n';
					}
				}
			}else if( basketManagerObject.basketItems()[0].product_id() != '' ){
				var listParam = basketManagerObject.basketItems()[0].product_id() != '' + "*" + "<cfoutput>#session.ep.period_id#</cfoutput>";
				var get_inventory_kontrol =  wrk_safe_query("stk_kontrol_inv_type2","dsn3",0,listParam);
				if(get_inventory_kontrol.recordcount == 0 || get_inventory_kontrol.INVENTORY_CAT_ID == '')
				inv_product_list = inv_product_list + eval(1) + '.Satır : ' + $('#product_name').val() + '\n';
			}
		}else{
			if(document.form_basket.product_id != undefined && document.form_basket.product_id >1){
					var bsk_rowCount = form_basket.product_id.length;
					for(var str_i_row=0; str_i_row < bsk_rowCount; str_i_row++){
					if(window.basket.items[str_i_row].PRODUCT_ID != ''){
						var listParam = document.form_basket.product_id[str_i_row].value + "*" + "<cfoutput>#session.ep.period_id#</cfoutput>";
						var get_inventory_kontrol =  wrk_safe_query("stk_kontrol_inv_type2","dsn3",0,listParam);
						if(get_inventory_kontrol.recordcount == 0 || get_inventory_kontrol.INVENTORY_CAT_ID == '')
							inv_product_list = inv_product_list + eval(str_i_row+1) + '.Satır : ' + document.all.product_name[str_i_row].value + '\n';
					}
				}
			}else if(document.all.product_id != undefined && document.all.product_id.value != ''){
				if(document.form_basket.product_id.value != ''){ 
					var listParam = document.form_basket.product_id.value + "*" + "<cfoutput>#session.ep.period_id#</cfoutput>";
					var get_inventory_kontrol =  wrk_safe_query("stk_kontrol_inv_type2","dsn3",0,listParam);
					if(get_inventory_kontrol.recordcount == 0 || get_inventory_kontrol.INVENTORY_CAT_ID == '')
					inv_product_list = inv_product_list + eval(1) + '.Satır : ' + $('#product_name').val() + '\n';
				}
			}
		}

		if(inv_product_list != ''){
			alert("Aşağıda Belirtilen Ürünler İçin Sabit Kıymet Tanımlarını Kontrol Ediniz! \n\n" + inv_product_list);
			return false;
		}
	}
	var deger = document.form_basket.process_cat.options[document.form_basket.process_cat.selectedIndex].value;
	var fis_no = eval("document.form_basket.ct_process_type_" + deger).value;
	<cfif xml_control_process_type eq 1>
		if(fis_no == 79){//konsinye irsaliye ise kontrol yapacak
			var ship_product_list = '';
			var wrk_row_id_list_new = '';
			var amount_list_new = '';

			if( window.basketManager !== undefined ){ 
				if( basketManagerObject.basketItems().filter(m => m.product_id()).length != undefined && basketManagerObject.basketItems().filter(m => m.product_id()).length > 1 ){
					var bsk_rowCount = basketManagerObject.basketItems().filter(m => m.product_id()).length;
					for(var str_i_row=0; str_i_row < bsk_rowCount; str_i_row++){
						if( basketManagerObject.basketItems()[str_i_row].product_id() != '' && basketManagerObject.basketItems()[str_i_row].wrk_row_relation_id() != '' && basketManagerObject.basketItems()[str_i_row].row_ship_id() != '' ){
							if(list_find(wrk_row_id_list_new, basketManagerObject.basketItems()[str_i_row].wrk_row_relation_id())){
								row_info = list_find(wrk_row_id_list_new,basketManagerObject.basketItems()[str_i_row].wrk_row_relation_id());
								amount_info = list_getat(amount_list_new,row_info);
								amount_info = parseFloat(amount_info) + parseFloat(filterNum(basketManagerObject.basketItems()[str_i_row].amount()));
								amount_list_new = list_setat(amount_list_new,row_info,amount_info);
							}else{
								wrk_row_id_list_new = wrk_row_id_list_new + ',' + basketManagerObject.basketItems()[str_i_row].wrk_row_relation_id();
								amount_list_new = amount_list_new + ',' + filterNum(basketManagerObject.basketItems()[str_i_row].amount());
							}
						}
					}
					for(var str_i_row=0; str_i_row < bsk_rowCount; str_i_row++){
						if( basketManagerObject.basketItems()[str_i_row].product_id() != '' && basketManagerObject.basketItems()[str_i_row].wrk_row_relation_id() != '' && basketManagerObject.basketItems()[str_i_row].row_ship_id() != ''){
							var get_inv_control = wrk_safe_query("inv_get_ship_control2","dsn2",0,basketManagerObject.basketItems()[str_i_row].wrk_row_relation_id() );	
							var get_inv_control2 =  wrk_safe_query("inv_get_inv_control","dsn2",0,basketManagerObject.basketItems()[str_i_row].wrk_row_relation_id() );
							if(list_len(basketManagerObject.basketItems()[str_i_row].row_ship_id(),';') > 1){
								new_period = list_getat(basketManagerObject.basketItems()[str_i_row].row_ship_id(),2,';');
								var get_period = wrk_safe_query("stk_get_period","dsn",0,new_period);
								new_dsn2 = "<cfoutput>#dsn#</cfoutput>"+"_"+get_period.PERIOD_YEAR+"_"+get_period.OUR_COMPANY_ID;	
							}else
								new_dsn2 = "<cfoutput>#dsn2#</cfoutput>";
							var get_ship_control =  wrk_safe_query("stk_get_ship_control",new_dsn2,0, basketManagerObject.basketItems()[str_i_row].wrk_row_relation_id());
							row_info = list_find(wrk_row_id_list_new,basketManagerObject.basketItems()[str_i_row].wrk_row_relation_id());
							amount_info = list_getat(amount_list_new,row_info);
							var total_inv_amount = parseFloat(get_inv_control2.AMOUNT)+parseFloat(get_inv_control.AMOUNT)+parseFloat(amount_info);
							if(get_ship_control != undefined && get_ship_control.recordcount > 0 && get_ship_control.AMOUNT >0 && get_inv_control != undefined && get_inv_control.recordcount > 0 && total_inv_amount >0){
								if(total_inv_amount > get_ship_control.AMOUNT)
									ship_product_list = ship_product_list + eval(str_i_row + 1) + '.Satır : ' + basketManagerObject.basketItems()[str_i_row].product_name() + '\n';
							}
						}
					}
				}
				else if( basketManagerObject.basketItems().filter(m => m.product_id()) != undefined && basketManagerObject.basketItems().filter(m => m.product_id()) != '' ){
					if( basketManagerObject.basketItems()[0].product_id() != '' && basketManagerObject.basketItems()[0].wrk_row_relation_id() != '' && basketManagerObject.basketItems()[0].row_ship_id() != ''){
						var get_inv_control = wrk_safe_query("inv_get_ship_control2","dsn2",0,basketManagerObject.basketItems()[0].wrk_row_relation_id());	
						var get_inv_control2 =  wrk_safe_query("inv_get_inv_control","dsn2",0,basketManagerObject.basketItems()[0].wrk_row_relation_id());	
						if(list_len(basketManagerObject.basketItems()[0].row_ship_id(),';') > 1){
							new_period = list_getat(basketManagerObject.basketItems()[0].row_ship_id(),2,';');
							var get_period = wrk_safe_query("stk_get_period","dsn",0,new_period);
							new_dsn2 = "<cfoutput>#dsn#</cfoutput>"+"_"+get_period.PERIOD_YEAR+"_"+get_period.OUR_COMPANY_ID;	
						}else
							new_dsn2 = "<cfoutput>#dsn2#</cfoutput>";
						var get_ship_control = wrk_safe_query("stk_get_ship_control",new_dsn2,0, basketManagerObject.basketItems()[0].row_ship_id());
						var total_inv_amount = parseFloat(get_inv_control2.AMOUNT)+parseFloat(get_inv_control.AMOUNT)+parseFloat(filterNum(basketManagerObject.basketItems()[0].amount()));
						if(get_ship_control != undefined && get_ship_control.recordcount > 0 && get_ship_control.AMOUNT >0 && get_inv_control != undefined && get_inv_control.recordcount > 0 && total_inv_amount >0){
							if(total_inv_amount > get_ship_control.AMOUNT)
								ship_product_list = ship_product_list + eval(str_i_row+1) + '.Satır : ' + basketManagerObject.basketItems()[0].product_name() + '\n';
							}
						}
					}
			}
			else{
				if(document.form_basket.product_id.length != undefined && document.form_basket.product_id.length >1){
					var bsk_rowCount = form_basket.product_id.length;
					for(var str_i_row=0; str_i_row < bsk_rowCount; str_i_row++){
						if(window.basket.items[str_i_row].PRODUCT_ID != '' && window.basket.items[str_i_row].WRK_ROW_RELATION_ID != '' && window.basket.items[str_i_row].row_ship_id != ''){
							if(list_find(wrk_row_id_list_new,document.form_basket.wrk_row_relation_id[str_i_row].value)){
								row_info = list_find(wrk_row_id_list_new,document.form_basket.wrk_row_relation_id[str_i_row].value);
								amount_info = list_getat(amount_list_new,row_info);
								amount_info = parseFloat(amount_info) + parseFloat(filterNum(document.form_basket.amount[str_i_row].value));
								amount_list_new = list_setat(amount_list_new,row_info,amount_info);
							}else{
								wrk_row_id_list_new = wrk_row_id_list_new + ',' + document.form_basket.wrk_row_relation_id[str_i_row].value;
								amount_list_new = amount_list_new + ',' + filterNum(document.form_basket.amount[str_i_row].value);
							}
						}
					}
					for(var str_i_row=0; str_i_row < bsk_rowCount; str_i_row++){
						if(window.basket.items[str_i_row].PRODUCT_ID != '' && window.basket.items[str_i_row].WRK_ROW_RELATION_ID != '' && window.basket.items[str_i_row].row_ship_id != ''){
							var get_inv_control = wrk_safe_query("inv_get_ship_control2","dsn2",0,document.form_basket.wrk_row_relation_id[str_i_row].value );	
							var get_inv_control2 =  wrk_safe_query("inv_get_inv_control","dsn2",0,document.form_basket.wrk_row_relation_id[str_i_row].value );
							if(list_len(document.form_basket.row_ship_id[str_i_row].value,';') > 1){
								new_period = list_getat(document.form_basket.row_ship_id[str_i_row].value,2,';');
								var get_period = wrk_safe_query("stk_get_period","dsn",0,new_period);
								new_dsn2 = "<cfoutput>#dsn#</cfoutput>"+"_"+get_period.PERIOD_YEAR+"_"+get_period.OUR_COMPANY_ID;	
							}else
								new_dsn2 = "<cfoutput>#dsn2#</cfoutput>";
							var get_ship_control =  wrk_safe_query("stk_get_ship_control",new_dsn2,0,  document.form_basket.wrk_row_relation_id[str_i_row].value);
							row_info = list_find(wrk_row_id_list_new,document.form_basket.wrk_row_relation_id[str_i_row].value);
							amount_info = list_getat(amount_list_new,row_info);
							var total_inv_amount = parseFloat(get_inv_control2.AMOUNT)+parseFloat(get_inv_control.AMOUNT)+parseFloat(amount_info);
							if(get_ship_control != undefined && get_ship_control.recordcount > 0 && get_ship_control.AMOUNT >0 && get_inv_control != undefined && get_inv_control.recordcount > 0 && total_inv_amount >0){
								if(total_inv_amount > get_ship_control.AMOUNT)
									ship_product_list = ship_product_list + eval(str_i_row+1) + '.Satır : ' + document.all.product_name[str_i_row].value + '\n';
							}
						}
					}
				}
				else if(document.all.product_id != undefined && document.all.product_id.value != ''){
					if(document.form_basket.product_id.value != '' && document.form_basket.wrk_row_relation_id.value != '' && document.form_basket.row_ship_id.value != ''){
						var get_inv_control = wrk_safe_query("inv_get_ship_control2","dsn2",0,document.form_basket.wrk_row_relation_id.value );	
						var get_inv_control2 =  wrk_safe_query("inv_get_inv_control","dsn2",0,document.form_basket.wrk_row_relation_id.value);	
						if(list_len(document.form_basket.row_ship_id.value,';') > 1){
							new_period = list_getat(document.form_basket.row_ship_id.value,2,';');
							var get_period = wrk_safe_query("stk_get_period","dsn",0,new_period);
							new_dsn2 = "<cfoutput>#dsn#</cfoutput>"+"_"+get_period.PERIOD_YEAR+"_"+get_period.OUR_COMPANY_ID;	
						}else
							new_dsn2 = "<cfoutput>#dsn2#</cfoutput>";
						var get_ship_control = wrk_safe_query("stk_get_ship_control",new_dsn2,0, document.form_basket.wrk_row_relation_id.value);
						var total_inv_amount = parseFloat(get_inv_control2.AMOUNT)+parseFloat(get_inv_control.AMOUNT)+parseFloat(filterNum(document.form_basket.amount.value));
						if(get_ship_control != undefined && get_ship_control.recordcount > 0 && get_ship_control.AMOUNT >0 && get_inv_control != undefined && get_inv_control.recordcount > 0 && total_inv_amount >0){
							if(total_inv_amount > get_ship_control.AMOUNT)
								ship_product_list = ship_product_list + eval(str_i_row+1) + '.Satır : ' + document.all.product_name.value + '\n';
							}
						}
					}
			}
			if(ship_product_list != ''){
				alert("<cf_get_lang dictionary_id='45283.Aşağıda Belirtilen Ürünler İçin İade Miktarı Konsinye Miktarından Fazla Lütfen Ürünleri Kontrol Ediniz'> ! \n\n" + ship_product_list);
				return false;
			}
		}
		else if(fis_no == 78){//toptan satis iade irsaliye ise kontrol yapacak
			var ship_product_list = '';
			var wrk_row_id_list_new = '';
			var amount_list_new = '';
			if( window.basketManager !== undefined ){ 
				if( basketManagerObject.basketItems().filter(m => m.product_id()).length != undefined && basketManagerObject.basketItems().filter(m => m.product_id()).length > 1 ){
					var bsk_rowCount = basketManagerObject.basketItems().filter(m => m.product_id()).length;
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
							var get_inv_control = wrk_safe_query("inv_get_ship_control3","dsn2",0,basketManagerObject.basketItems()[str_i_row].wrk_row_relation_id());	
							var get_inv_control2 =  wrk_safe_query("inv_get_inv_control","dsn2",0,basketManagerObject.basketItems()[str_i_row].wrk_row_relation_id());
							
							if(list_len(basketManagerObject.basketItems()[str_i_row].row_ship_id(),';') > 1){
								new_period = list_getat(basketManagerObject.basketItems()[str_i_row].row_ship_id(),2,';');
								var get_period = wrk_safe_query("stk_get_period","dsn",0,new_period);
								new_dsn2 = "<cfoutput>#dsn#</cfoutput>"+"_"+get_period.PERIOD_YEAR+"_"+get_period.OUR_COMPANY_ID;	
							}
							else
								new_dsn2 = "<cfoutput>#dsn2#</cfoutput>";
							var get_ship_control =  wrk_safe_query("stk_get_ship_control",new_dsn2,0, basketManagerObject.basketItems()[str_i_row].wrk_row_relation_id());
							row_info = list_find(wrk_row_id_list_new,basketManagerObject.basketItems()[str_i_row].wrk_row_relation_id());
							amount_info = list_getat(amount_list_new,row_info);
							var total_inv_amount = parseFloat(get_inv_control2.AMOUNT)+parseFloat(get_inv_control.AMOUNT)+parseFloat(amount_info);
							if(get_ship_control != undefined && get_ship_control.recordcount > 0 && get_ship_control.AMOUNT >0 && get_inv_control != undefined && get_inv_control.recordcount > 0 && total_inv_amount >0){
								if(total_inv_amount > get_ship_control.AMOUNT)
									ship_product_list = ship_product_list + eval(str_i_row+1) + '.Satır : ' + basketManagerObject.basketItems()[str_i_row].product_name() + '\n';
							}
						}
					}
				}	
				else if( basketManagerObject.basketItems().filter(m => m.product_id()) != undefined && basketManagerObject.basketItems().filter(m => m.product_id()) != '' ){
					if( basketManagerObject.basketItems()[str_i_row].product_id() != '' && basketManagerObject.basketItems()[str_i_row].wrk_row_relation_id() != '' && basketManagerObject.basketItems()[str_i_row].row_ship_id() != ''  ){
						var get_inv_control = wrk_safe_query("inv_get_ship_control3","dsn2",0,basketManagerObject.basketItems()[str_i_row].wrk_row_relation_id());	
						var get_inv_control2 = wrk_safe_query("inv_get_inv_control","dsn2",0,basketManagerObject.basketItems()[str_i_row].wrk_row_relation_id());	
						if(list_len(basketManagerObject.basketItems()[str_i_row].row_ship_id(),';') > 1){
							new_period = list_getat(basketManagerObject.basketItems()[str_i_row].row_ship_id(),2,';');
							var get_period = wrk_safe_query("stk_get_period","dsn",0,new_period);
							new_dsn2 = "<cfoutput>#dsn#</cfoutput>"+"_"+get_period.PERIOD_YEAR+"_"+get_period.OUR_COMPANY_ID;	
						}
						else
							new_dsn2 = "<cfoutput>#dsn2#</cfoutput>";
						var get_ship_control = wrk_safe_query("stk_get_ship_control",new_dsn2,0, basketManagerObject.basketItems()[str_i_row].wrk_row_relation_id());
						var total_inv_amount = parseFloat(get_inv_control2.AMOUNT)+parseFloat(get_inv_control.AMOUNT)+parseFloat(filterNum(document.form_basket.amount.value));
						if(get_ship_control != undefined && get_ship_control.recordcount > 0 && get_ship_control.AMOUNT >0 && get_inv_control != undefined && get_inv_control.recordcount > 0 && total_inv_amount >0){
							if(total_inv_amount > get_ship_control.AMOUNT)
								ship_product_list = ship_product_list + eval(str_i_row+1) + '.Satır : ' + basketManagerObject.basketItems()[str_i_row].product_name() + '\n';
						}
					}
				}
			}
			else{
				if(document.form_basket.product_id.length != undefined && document.form_basket.product_id.length >1){
					var bsk_rowCount = form_basket.product_id.length;
					for(var str_i_row=0; str_i_row < bsk_rowCount; str_i_row++){
						if(window.basket.items[str_i_row].PRODUCT_ID != '' && window.basket.items[str_i_row].WRK_ROW_RELATION_ID != '' && window.basket.items[str_i_row].row_ship_id != ''){
							if(list_find(wrk_row_id_list_new,document.form_basket.wrk_row_relation_id[str_i_row].value)){
								row_info = list_find(wrk_row_id_list_new,document.form_basket.wrk_row_relation_id[str_i_row].value);
								amount_info = list_getat(amount_list_new,row_info);
								amount_info = parseFloat(amount_info) + parseFloat(filterNum(document.form_basket.amount[str_i_row].value));
								amount_list_new = list_setat(amount_list_new,row_info,amount_info);
							}
							else{
								wrk_row_id_list_new = wrk_row_id_list_new + ',' + document.form_basket.wrk_row_relation_id[str_i_row].value;
								amount_list_new = amount_list_new + ',' + filterNum(document.form_basket.amount[str_i_row].value);
							}
						}
					}
					for(var str_i_row=0; str_i_row < bsk_rowCount; str_i_row++){
						if(window.basket.items[str_i_row].PRODUCT_ID != '' && window.basket.items[str_i_row].WRK_ROW_RELATION_ID != '' && window.basket.items[str_i_row].row_ship_id != ''){
							var get_inv_control = wrk_safe_query("inv_get_ship_control3","dsn2",0,document.form_basket.wrk_row_relation_id[str_i_row].value );	
							var get_inv_control2 =  wrk_safe_query("inv_get_inv_control","dsn2",0,document.form_basket.wrk_row_relation_id[str_i_row].value );
							
							if(list_len(document.form_basket.row_ship_id[str_i_row].value,';') > 1){
								new_period = list_getat(document.form_basket.row_ship_id[str_i_row].value,2,';');
								var get_period = wrk_safe_query("stk_get_period","dsn",0,new_period);
								new_dsn2 = "<cfoutput>#dsn#</cfoutput>"+"_"+get_period.PERIOD_YEAR+"_"+get_period.OUR_COMPANY_ID;	
							}
							else
								new_dsn2 = "<cfoutput>#dsn2#</cfoutput>";
							var get_ship_control =  wrk_safe_query("stk_get_ship_control",new_dsn2,0,  document.form_basket.wrk_row_relation_id[str_i_row].value);
							row_info = list_find(wrk_row_id_list_new,document.form_basket.wrk_row_relation_id[str_i_row].value);
							amount_info = list_getat(amount_list_new,row_info);
							var total_inv_amount = parseFloat(get_inv_control2.AMOUNT)+parseFloat(get_inv_control.AMOUNT)+parseFloat(amount_info);
							if(get_ship_control != undefined && get_ship_control.recordcount > 0 && get_ship_control.AMOUNT >0 && get_inv_control != undefined && get_inv_control.recordcount > 0 && total_inv_amount >0){
								if(total_inv_amount > get_ship_control.AMOUNT)
									ship_product_list = ship_product_list + eval(str_i_row+1) + '.Satır : ' + document.all.product_name[str_i_row].value + '\n';
							}
						}
					}
				}	
				else if(document.all.product_id != undefined && document.all.product_id.value != ''){
					if(document.form_basket.product_id.value != '' && document.form_basket.wrk_row_relation_id.value != '' && document.form_basket.row_ship_id.value != ''){
						var get_inv_control = wrk_safe_query("inv_get_ship_control3","dsn2",0,document.form_basket.wrk_row_relation_id.value );	
						var get_inv_control2 =  wrk_safe_query("inv_get_inv_control","dsn2",0,document.form_basket.wrk_row_relation_id.value);	
						if(list_len(document.form_basket.row_ship_id.value,';') > 1){
							new_period = list_getat(document.form_basket.row_ship_id.value,2,';');
							var get_period = wrk_safe_query("stk_get_period","dsn",0,new_period);
							new_dsn2 = "<cfoutput>#dsn#</cfoutput>"+"_"+get_period.PERIOD_YEAR+"_"+get_period.OUR_COMPANY_ID;	
						}
						else
							new_dsn2 = "<cfoutput>#dsn2#</cfoutput>";
						var get_ship_control = wrk_safe_query("stk_get_ship_control",new_dsn2,0, document.form_basket.wrk_row_relation_id.value);
						var total_inv_amount = parseFloat(get_inv_control2.AMOUNT)+parseFloat(get_inv_control.AMOUNT)+parseFloat(filterNum(document.form_basket.amount.value));
						if(get_ship_control != undefined && get_ship_control.recordcount > 0 && get_ship_control.AMOUNT >0 && get_inv_control != undefined && get_inv_control.recordcount > 0 && total_inv_amount >0){
							if(total_inv_amount > get_ship_control.AMOUNT)
								ship_product_list = ship_product_list + eval(str_i_row+1) + '.Satır : ' + document.all.product_name.value + '\n';
						}
					}
				}
			}
			if(ship_product_list != ''){
				alert("<cf_get_lang dictionary_id='45289.Aşağıda Belirtilen Ürünler İçin İade Miktarı Alım Miktarından Fazla Lütfen Ürünleri Kontrol Ediniz'> ! \n\n" + ship_product_list);
				return false;
			}
		}
	</cfif>
	<cfif isdefined("xml_upd_row_project") and xml_upd_row_project eq 1>
		project_field_name = 'project_head';
		project_field_id = 'project_id';
		apply_deliver_date('',project_field_name,project_field_id);
	</cfif>
	<cfif session.ep.our_company_info.is_eshipment>
		var xml_chk_eshipment = wrk_safe_query("chk_eshipment_count",'dsn2',0,'<cfoutput>#attributes.ship_id#</cfoutput>');

		if(xml_chk_eshipment.recordcount > 0){
			<cfif xml_upd_eshipment eq 0>
				alert("<cf_get_lang dictionary_id='61202.e-İrsaliye olarak gönderilmiş irsaliye güncellenemez'>");
					return false;
			<cfelse>
				if( confirm( "<cf_get_lang dictionary_id='61203.e-İrsaliye olarak gönderilmiş İrsaliyeyi güncellemek istiyor musunuz ?'>" ) );
				else return false;
			</cfif>
		}

	</cfif>
	<cfif isdefined("xml_show_process_stage") and len(xml_show_process_stage) and xml_show_process_stage eq 1>
		return (process_cat_control() && saveForm());
	<cfelse>
		return (saveForm());
	</cfif>
}
function kontrol2()
{	
	if(document.form_basket.process_cat.value == '')
	{
		alert("İşlem Tipi Seçmelisiniz !");
		return false;
	}

	<cfif session.ep.our_company_info.is_eshipment>
		var check_eshipment = wrk_safe_query("chk_eshipment_count",'dsn2',0,'<cfoutput>#attributes.ship_id#</cfoutput>');
		if(check_eshipment.recordcount > 0)
		{
			alert("<cf_get_lang dictionary_id='61035.İrsaliye ile ilişkili e-irsaliye oldugundan silinemez'>");
			return false;
		}
	</cfif>

	if (!check_display_files('form_basket')) return false;
	if (!chk_period(form_basket.ship_date,"İşlem")) return false;
	else if (form_basket.del_ship.value =1);
	return true;
}
function check_process_is_sale()
{/*alım iadeleri satis karakterli oldugu halde alış fiyatları ile çalışması için*/
	var selected_ptype = document.form_basket.process_cat.options[document.form_basket.process_cat.selectedIndex].value;
	if(selected_ptype!='')
	{
		eval('var proc_control = document.form_basket.ct_process_type_'+selected_ptype+'.value');
		<cfif get_basket.basket_id is 10>
			if(proc_control==78||proc_control==79)
				sale_product= 0;
			else
				sale_product = 1;
		</cfif>
		<cfif x_add_dispatch_ship eq 1 and get_upd_purchase.ship_type eq 72>		
			if(proc_control ==72)
				show_dispatch_ship_link.style.display='';
			else
				show_dispatch_ship_link.style.display='none';
		</cfif>
		if(list_find('78,79',proc_control))
		{ 
			td_ship_text_.style.display = '';
			td_ship_id_.style.display='';
		}
		else
		{
			td_ship_text_.style.display = 'none';
			td_ship_id_.style.display = 'none';
		}
	}
	return true;
}
function add_adress()
{
	if(!(form_basket.company_id.value=="") || !(form_basket.consumer_id.value=="") || !(form_basket.employee_id.value==""))
	{
		if(form_basket.company_id.value!="")
			{
				str_adrlink = '&field_long_adres=form_basket.adres&field_adress_id=form_basket.ship_address_id';
				if(form_basket.city_id!=undefined) str_adrlink = str_adrlink+'&field_city=form_basket.city_id';
				if(form_basket.county_id!=undefined) str_adrlink = str_adrlink+'&field_county=form_basket.county_id&field_id=form_basket.deliver_comp_id';
				windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_member_address&is_comp=1&select_list=1&keyword='+encodeURIComponent(form_basket.comp_name.value)+''+ str_adrlink , 'list');
				document.getElementById('deliver_cons_id').value = '';
				return true;
			}
		else
			{
				str_adrlink = '&field_long_adres=form_basket.adres&field_adress_id=form_basket.ship_address_id'; 
				if(form_basket.city_id!=undefined) str_adrlink = str_adrlink+'&field_city=form_basket.city_id';
				if(form_basket.county_id!=undefined) str_adrlink = str_adrlink+'&field_county=form_basket.county_id&field_id=form_basket.deliver_cons_id';
				windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_member_address&is_comp=0&select_list=2&keyword='+encodeURIComponent(form_basket.partner_name.value)+''+ str_adrlink , 'list');
				document.getElementById('deliver_comp_id').value = '';
				return true;
			}
	}
	else
	{
		alert("<cf_get_lang no='131.Cari Hesap Secmelisiniz'>");
		return false;
	}
}
change_paper_duedate('ship_date');
check_process_is_sale();
</script>
</cfif>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
