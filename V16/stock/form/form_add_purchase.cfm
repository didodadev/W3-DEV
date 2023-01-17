<div style="display:none;z-index:999;" id="phl_div"></div>
<cf_xml_page_edit fuseact="stock.form_add_purchase">
<CFSETTING SHOWDEBUGOUTPUT="YES">
<cf_get_lang_set module_name="stock"><!--- sayfanin en altinda kapanisi var --->
	<cfset get_date_bugun = dateformat(now(),dateformat_style)>
<cfscript>
	if(isdefined('attributes.is_ship_copy'))
		session_basket_kur_ekle(action_id=attributes.ship_id,table_type_id:2,process_type:1);
	else if(isdefined('attributes.order_id'))
		session_basket_kur_ekle(action_id=attributes.order_id,table_type_id:3,to_table_type_id:1,process_type:1);
	else
		session_basket_kur_ekle(process_type:0);
	xml_all_depo = iif(isdefined("xml_location_auth"),xml_location_auth,DE('-1'));
</cfscript>
<cfif isdefined('attributes.service_id') and len(attributes.service_id)>
	<cfquery name="GET_SERVICE" datasource="#DSN3#">
		SELECT
			SERVICE_PARTNER_ID,
			SERVICE_COMPANY_ID,
			SERVICE_CONSUMER_ID,
			PRO_SERIAL_NO,
			SERVICE_NO,
            PROJECT_ID,
			SHIP_METHOD,
			STOCK_ID,
			(SELECT ISNULL(ISPOTANTIAL,0) AS ISPOTANTIAL FROM #dsn_alias#.COMPANY WHERE COMPANY_ID = SERVICE_COMPANY_ID) AS ISPOTANTIAL,
			SUBSCRIPTION_ID
		FROM
			SERVICE
		WHERE
			SERVICE_ID = #attributes.service_id#
	</cfquery> 
	<cfif GET_SERVICE.ISPOTANTIAL eq 1>
		<script type="text/javascript">
			alert("<cf_get_lang no='178.Potansiyel Üyelerde bu işlemi yapamazsınız'>!");
			location.href = document.referrer;
		</script>
		<cfabort>
	</cfif>
	<cfscript>
		attributes.company_id = get_service.service_company_id;
		attributes.comp_name= get_par_info(get_service.service_company_id,1,1,0);
		attributes.consumer_id = get_service.service_consumer_id;
		attributes.partner_id = get_service.service_partner_id;
		if(len(get_service.service_partner_id) and get_service.service_partner_id neq 0)
			attributes.partner_name=get_par_info(get_service.service_partner_id,0,-1,0);
		else
			attributes.partner_name=get_cons_info(get_service.service_consumer_id,0,0);
			
		service_serial_no = get_service.pro_serial_no;
		service_stock_id =get_service.stock_id;
		attributes.deliver_date =  dateformat(now(),dateformat_style);
		attributes.ship_date = dateformat(now(),dateformat_style);
		attributes.service_paper_no =get_service.service_no;
		attributes.ship_method_id = get_service.ship_method;
		attributes.subscription_id = get_service.subscription_id;
		attributes.project_id = get_service.project_id;
	</cfscript>
</cfif>
<cfif isdefined('attributes.is_ship_copy')>
	<cfinclude template="../query/get_upd_purchase.cfm">
	<cfset attributes.ship_type = get_upd_purchase.ship_type>
	<cfscript>
		location_info_ = get_location_info(get_upd_purchase.department_in,get_upd_purchase.location_in,1,1);
		attributes.location_id = get_upd_purchase.location_in;
		attributes.branch_id = listlast(location_info_,',');
		attributes.department_id = get_upd_purchase.department_in;
		attributes.txt_departman_ =listfirst(location_info_,',');
		attributes.company_id =get_upd_purchase.company_id;
		attributes.comp_name =get_par_info(get_upd_purchase.company_id,1,0,0);
		attributes.partner_id = get_upd_purchase.partner_id;
		attributes.consumer_id=get_upd_purchase.consumer_id;
		if(len(get_upd_purchase.partner_id) and get_upd_purchase.partner_id neq 0)
			attributes.partner_name=get_par_info(get_upd_purchase.partner_id,0,-1,0);
		else
			attributes.partner_name=get_cons_info(get_upd_purchase.consumer_id,0,0);
		attributes.project_id = get_upd_purchase.project_id;
		attributes.ship_method_name ='';
		attributes.ship_method_id=get_upd_purchase.ship_method;
		attributes.deliver_emp_id=get_upd_purchase.deliver_emp_id;	
		attributes.deliver_par_id=get_upd_purchase.deliver_par_id;
		attributes.deliver_date = dateformat(get_upd_purchase.deliver_date,dateformat_style);
		attributes.ship_date =dateformat(get_upd_purchase.ship_date,dateformat_style);
	</cfscript>
</cfif>
<cfparam name="attributes.ship_date" default="#get_date_bugun#">

<cfif not (isdefined('attributes.service_id') and len(attributes.service_id)) and not isdefined("attributes.ship_id") and isdefined("attributes.project_id") and len(attributes.project_id)>
	<cfquery name="get_project_info" datasource="#dsn#">
		SELECT COMPANY_ID,PARTNER_ID,CONSUMER_ID FROM PRO_PROJECTS WHERE PROJECT_ID =#attributes.project_id#
	</cfquery>
	<cfif len(get_project_info.partner_id)>
		<cfset attributes.company_id = get_project_info.company_id>
		<cfset attributes.partner_id = get_project_info.partner_id>
		<cfset attributes.partner_name = get_par_info(get_project_info.partner_id,0,-1,0)>
		<cfset attributes.comp_name =get_par_info(get_project_info.company_id,1,0,0)>
	<cfelseif len(get_project_info.consumer_id)>
		<cfset attributes.consumer_id = get_project_info.consumer_id>
		<cfset attributes.partner_name = get_cons_info(get_project_info.consumer_id,0,0)>
		<cfset attributes.comp_name =get_cons_info(get_project_info.consumer_id,2,0)>
	</cfif>
</cfif>

<cfif isdefined("attributes.return_row_ids") and not isdefined("attributes.subscription_id")>
	<cfif attributes.member_type is 'partner'>
		<cfset partner_list = listsort(listdeleteduplicates(attributes.return_partner_ids),'numeric','ASC',',')>
		<cfif listlen(partner_list)>
			<cfset attributes.partner_id = listfirst(partner_list)>
			<cfset attributes.partner_name = get_par_info(attributes.partner_id,0,-1,0)>
		</cfif>
		<cfset attributes.comp_name = "#attributes.member_name#">
	<cfelse>
		<cfset attributes.partner_name = "#attributes.member_name#">
	</cfif>
</cfif>
<cfif isdefined("attributes.return_row_ids") and isdefined("attributes.subscription_id") and len(attributes.subscription_id) and len(attributes.subscription_no)>
	<cfquery name="get_subs_" datasource="#dsn3#">
		SELECT
			PARTNER_ID,
			COMPANY_ID,
			PROJECT_ID
		FROM
			SUBSCRIPTION_CONTRACT
		WHERE
			SUBSCRIPTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.subscription_id#">
	</cfquery>
	<cfif len(get_subs_.PARTNER_ID)>
		<cfset attributes.member_type = "partner">
		<cfset attributes.partner_id = get_subs_.PARTNER_ID>
		<cfset attributes.company_id = get_subs_.COMPANY_ID>
		<cfset attributes.partner_name = get_par_info(attributes.partner_id,0,-1,0)>
		<cfset attributes.comp_name = get_par_info(attributes.company_id,1,0,0)>
		<cfif not isdefined("attributes.project_id")>
			<cfset attributes.project_id = get_subs_.PROJECT_ID>
		</cfif>
	</cfif>
</cfif>
<cfif (isdefined("attributes.invent_return_row_ids") or isdefined("attributes.kons_row_ids")) and isdefined("attributes.subscription_id") and len(attributes.subscription_id)>
	<cfquery name="get_subs_" datasource="#dsn3#">
		SELECT
			PARTNER_ID,
			COMPANY_ID,
			PROJECT_ID
		FROM
			SUBSCRIPTION_CONTRACT
		WHERE
			SUBSCRIPTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.subscription_id#">
	</cfquery>
	<cfif len(get_subs_.PARTNER_ID)>
		<cfset attributes.member_type = "partner">
		<cfset attributes.partner_id = get_subs_.PARTNER_ID>
		<cfset attributes.company_id = get_subs_.COMPANY_ID>
		<cfset attributes.partner_name = get_par_info(attributes.partner_id,0,-1,0)>
		<cfset attributes.comp_name = get_par_info(attributes.company_id,1,0,0)>
		<cfif not isdefined("attributes.project_id")>
			<cfset attributes.project_id = get_subs_.PROJECT_ID>
		</cfif>
	</cfif>
</cfif>
<cfset attributes.paymethod_id = "">
<cfset attributes.card_paymethod_id = "">
<cfset attributes.commission_rate = "">
<cfset attributes.commethod_id = "">
<cfif isdefined('attributes.order_id') and len(attributes.order_id)>
	<cfinclude template="../query/get_det_order.cfm">
	<cfscript>
	attributes.company_id = get_upd_purchase.company_id;
	attributes.comp_name= get_par_info(get_upd_purchase.company_id,1,1,0);
	attributes.partner_id = get_upd_purchase.partner_id;
	attributes.consumer_id = get_upd_purchase.consumer_id;
	if(len(get_upd_purchase.partner_id))
			attributes.partner_name=get_par_info(get_upd_purchase.partner_id,0,-1,0);
		else
			attributes.partner_name=get_cons_info(get_upd_purchase.consumer_id,0,0);
	attributes.order_number = get_upd_purchase.order_number;
	attributes.ref_no = get_upd_purchase.ref_no;
	attributes.ship_date = dateformat(now(),dateformat_style);
	attributes.sale_emp = get_upd_purchase.order_employee_id;
	attributes.location_id = get_upd_purchase.location_id;
	attributes.department_id = get_upd_purchase.DELIVER_DEPT_ID;
	location_info_ = get_location_info(get_upd_purchase.DELIVER_DEPT_ID,get_upd_purchase.location_id,1,1);
	attributes.branch_id = listlast(location_info_,',');
	attributes.txt_departman_ =listfirst(location_info_,',');
	attributes.city_id = get_upd_purchase.city_id;
	attributes.county_id = get_upd_purchase.county_id;
	attributes.deliver_comp_id = get_upd_purchase.deliver_comp_id;
	attributes.deliver_cons_id = get_upd_purchase.deliver_cons_id;
	attributes.adres = trim(get_upd_purchase.ship_address);
	attributes.ship_method_id = get_upd_purchase.ship_method;
	attributes.detail = get_upd_purchase.order_detail;
	attributes.project_id = get_upd_purchase.project_id;
	attributes.subscription_id = get_upd_purchase.subscription_id;
	attributes.paymethod_id = get_upd_purchase.paymethod;
	attributes.card_paymethod_id = get_upd_purchase.card_paymethod_id;
	attributes.commethod_id = get_upd_purchase.commethod_id;
	</cfscript>
</cfif>
<cfif isdefined("attributes.receiving_detail_id")>
	<cfquery name="GET_ESHIP_DET" datasource="#DSN2#">
		SELECT ISSUE_DATE,ESHIPMENT_ID FROM ESHIPMENT_RECEIVING_DETAIL WHERE RECEIVING_DETAIL_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.receiving_detail_id#"> 
	</cfquery>
	<cfif isdefined('attributes.company_id') and len(attributes.company_id)>
		<cfif len(attributes.partner_id)>
			<cfset attributes.partner_name = get_par_info(attributes.partner_id,0,-1,0)>
		<cfelse>
			<cfquery name="get_manager_partner" datasource="#dsn#">
				SELECT MANAGER_PARTNER_ID FROM COMPANY WHERE COMPANY_ID = #attributes.company_id#
			</cfquery>
			<cfset attributes.partner_id = get_manager_partner.manager_partner_id>
			<cfset attributes.partner_name = get_par_info(get_manager_partner.manager_partner_id,0,-1,0)>
		</cfif>
	<cfelseif isdefined('attributes.consumer_id') and len(attributes.consumer_id)>
		<cfset attributes.partner_name = get_cons_info(attributes.consumer_id,0,0)>
	</cfif>
	<cfif GET_ESHIP_DET.recordcount>
		<cfset ship_date = dateformat(GET_ESHIP_DET.issue_date,dateformat_style)>
		<cfset ship_number = GET_ESHIP_DET.eshipment_id>
		<cfif isdefined("attributes.order_id_listesi") and len(attributes.order_id_listesi)>
			<cfset attributes.order_create_from_row=attributes.order_create_from_row>
			<cfset attributes.order_create_row_list=attributes.order_create_row_list>
			<cfset attributes.order_id_listesi=attributes.order_id_listesi>
			<cfset attributes.order_number=attributes.order_id_form>
		</cfif>
		<script type="text/javascript">
			try{
				window.onload = function () { change_money_info('form_basket','ship_date');}
			}
			catch(e){}
		</script>
	</cfif>
</cfif>
<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box>
		<div id="basket_main_div">
			<cfform name="form_basket" method="post" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_add_purchase">
				<cf_basket_form id="add_purchase">
					<cf_box_elements vertical="0">
					<cfoutput>
						<input type="hidden" name="form_action_address" id="form_action_address" value="#listgetat(attributes.fuseaction,1,'.')#.emptypopup_add_purchase">
						<input type="hidden" name="service_id" id="service_id" value="<cfif isdefined('attributes.service_id') and len(attributes.service_id)>#attributes.service_id#</cfif>">
						<input type="hidden" name="service_serial_no" id="service_serial_no" value="<cfif isdefined('attributes.service_id') and len(attributes.service_id)>#service_serial_no#</cfif>">
						<input type="hidden" name="service_stock_id" id="service_stock_id" value="<cfif isdefined('attributes.service_id') and len(attributes.service_id)>#service_stock_id#</cfif>">
						<input type="hidden" name="active_period" id="active_period" value="#session.ep.period_id#">
						<cfif isdefined("attributes.receiving_detail_id")>
							<input type="hidden" name="receiving_detail_id" id="receiving_detail_id" value="<cfoutput>#attributes.receiving_detail_id#</cfoutput>">
						</cfif>
						<cfif isdefined("attributes.return_row_ids")>
							<input type="hidden" name="return_row_ids" id="return_row_ids" value="#attributes.return_row_ids#">
						</cfif>
						<cfif isdefined("attributes.invent_return_row_ids") and isdefined("attributes.subscription_id")>
							<input type="hidden" name="invent_return_row_ids" id="invent_return_row_ids" value="#attributes.invent_return_row_ids#">
						</cfif>
						<cfif isdefined("attributes.kons_row_ids")>
							<input type="hidden" name="kons_row_ids" id="kons_row_ids" value="#attributes.kons_row_ids#">
						</cfif>
						<cfif isdefined("attributes.kons_return_type") and attributes.kons_return_type eq 1>
							<cfset process_type_info = 75>
						<cfelseif isdefined("attributes.kons_return_type") and attributes.kons_return_type eq 2>
							<cfset process_type_info = '73,74'>
						<cfelse>
							<cfset process_type_info = ''>
						</cfif>
						<input type="hidden" name="basket_due_value" id="basket_due_value" value="">
						<input type="hidden" name="search_process_date" id="search_process_date" value="ship_date">	
						<input type="hidden" name="paymethod_id" id="paymethod_id" value="#attributes.paymethod_id#">
						<input type="hidden" name="card_paymethod_id" id="card_paymethod_id" value="#attributes.card_paymethod_id#">
						<input type="hidden" name="commission_rate" id="commission_rate" value="#attributes.commission_rate#">
						<input type="hidden" name="commethod_id" id="commethod_id" value="#attributes.commethod_id#">
					</cfoutput>
					<div class="col col-4 col-md-3 col-sm-3 col-xs-12" type="column" index="1" sort="true">
						<div class="form-group" id="form_ul_process_cat">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang_main no='388.işlem tipi'></label>
							<div class="col col-8 col-md-8 col-sm-8 process_catcol-xs-12">
								<cfif IsDefined("attributes.process_cat")>
									<cf_workcube_process_cat process_cat="#attributes.process_cat#" slct_width="150" onclick_function="control_consignment();" process_type_info="#process_type_info#">
								<cfelse>
									<cf_workcube_process_cat slct_width="150" onclick_function="control_consignment();" process_type_info="#process_type_info#">
								</cfif>
							</div>
						</div>
						<div class="form-group" id="form_ul_comp_name">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang_main no='107.cari hesap'>*</label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<div class="input-group">
									<input type="hidden" name="company_id" id="company_id" <cfif isdefined("attributes.company_id")>value="<cfoutput>#attributes.company_id#</cfoutput>"</cfif>>
									<input type="text" name="comp_name" id="comp_name" <cfif isdefined("attributes.comp_name")>value="<cfoutput>#attributes.comp_name#</cfoutput>"</cfif> readonly>
									<cfset str_linkeait = "&field_paymethod_id=form_basket.paymethod_id&field_basket_due_value=form_basket.basket_due_value&field_card_payment_id=form_basket.card_paymethod_id&field_city_id=form_basket.ship_address_city_id&field_county_id=form_basket.ship_address_county_id&field_comp_id2=form_basket.deliver_comp_id&field_consumer2=form_basket.deliver_cons_id&field_adress_id=form_basket.ship_address_id&field_long_address=form_basket.ship_address">
									<span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_pars#str_linkeait#&select_list=2,3,1,9&field_name=form_basket.partner_name&field_emp_id=form_basket.employee_id&field_partner=form_basket.partner_id&field_comp_name=form_basket.comp_name&field_comp_id=form_basket.company_id&field_consumer=form_basket.consumer_id&come=stock&is_potansiyel=0&var_new=ship&ship_method_id=form_basket.ship_method&ship_method_name=form_basket.ship_method_name<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif></cfoutput>');"></span>
								</div>
							</div>
						</div>
						<div class="form-group" id="form_ul_partner_name">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang_main no='166.yetkili'></label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<input type="hidden" name="partner_id" id="partner_id" value="<cfif isdefined("attributes.partner_id")><cfoutput>#attributes.partner_id#</cfoutput></cfif>">
								<input type="hidden" name="consumer_id" id="consumer_id" value="<cfif isdefined("attributes.consumer_id")><cfoutput>#attributes.consumer_id#</cfoutput></cfif>">
								<input type="hidden" name="employee_id" id="employee_id" value="<cfif isdefined("attributes.employee_id")><cfoutput>#attributes.employee_id#</cfoutput></cfif>">
								<input type="text" name="partner_name" id="partner_name" readonly value="<cfif isdefined("attributes.partner_name")><cfoutput>#attributes.partner_name#</cfoutput></cfif>">
							</div>
						</div>
						<div class="form-group" id="form_ul_deliver_get">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang_main no='363.Teslim Alan'></label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<div class="input-group">
									<input type="hidden" name="deliver_get_id" id="deliver_get_id"  value="<cfoutput><cfif isdefined('attributes.deliver_emp_id') and len(attributes.deliver_emp_id)>#attributes.deliver_emp_id#<cfelseif isdefined('attributes.deliver_par_id') and len(attributes.deliver_par_id)>#attributes.deliver_par_id#<cfelse>#session.ep.userid#</cfif></cfoutput>">
									<input type="hidden" name="deliver_member_type" id="deliver_member_type" value="<cfif isdefined('attributes.deliver_par_id') and len(attributes.deliver_par_id)>partner<cfelse>employee</cfif>">
									<input type="text" name="deliver_get" id="deliver_get" value="<cfoutput><cfif isdefined('attributes.deliver_emp_id') and len(attributes.deliver_emp_id)>#get_emp_info(attributes.deliver_emp_id,0,0)#<cfelseif isdefined('attributes.deliver_par_id') and len(attributes.deliver_par_id)>#get_par_info(attributes.deliver_par_id,0,0,0)#<cfelse>#session.ep.name# #session.ep.surname#</cfif></cfoutput>" onfocus="AutoComplete_Create('deliver_get','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_PARTNER_NAME2,MEMBER_NAME2','get_member_autocomplete','\'1,3\',0,0','PARTNER_ID2,MEMBER_TYPE','deliver_get_id,deliver_member_type','','3','250');" autocomplete="off">
									<span class="input-group-addon icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_name=form_basket.deliver_get&field_emp_id2=form_basket.deliver_get_id&field_type=form_basket.deliver_member_type&select_list=1,7</cfoutput>','list')"></span>
								</div>
							</div>
						</div>
						<cfif session.ep.our_company_info.subscription_contract eq 1>
							<cfif not (isdefined("attributes.invent_return_row_ids") and len(attributes.invent_return_row_ids)) or (xml_disable_system_change eq 1 and isdefined("attributes.invent_return_row_ids") and len(attributes.invent_return_row_ids) and isdefined("attributes.subscription_id"))>
								<div class="form-group" id="form_ul_subscription_no">
									<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang_main no='1420.Abone'><cf_get_lang_main no='75.No'></label>
									<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
										<cfif isdefined("attributes.subscription_id") and len(attributes.subscription_id)>
											<cf_wrk_subscriptions width_info='150' subscription_id='#attributes.subscription_id#'  fieldId='subscription_id' fieldName='subscription_no' form_name='form_basket' img_info='plus_thin'>
										<cfelse>
											<cf_wrk_subscriptions width_info='150' fieldId='subscription_id' fieldName='subscription_no' form_name='form_basket' img_info='plus_thin'>
										</cfif>
									</div>
								</div>
							<cfelse>
								<cfif isdefined("attributes.subscription_id") and len(attributes.subscription_id)>
									<div class="form-group" id="form_ul_subscription_no">
										<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang_main no='1420.Abone'><cf_get_lang_main no='75.No'></label>
										<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
											<cfquery name="ct_get_subs" datasource="#DSN3#">
												SELECT SUBSCRIPTION_NO FROM SUBSCRIPTION_CONTRACT WHERE SUBSCRIPTION_ID = #attributes.subscription_id# 
											</cfquery>
											<cfif get_module_user(11)>
												<cfoutput><a href="#request.self#?fuseaction=sales.list_subscription_contract&event=upd&subscription_id=#attributes.subscription_id#" class="tableyazi" target="_blank">#ct_get_subs.subscription_no#</a></cfoutput>
											<cfelse>
												<cfoutput>#ct_get_subs.subscription_no#</cfoutput>
											</cfif>
											<input type="hidden" value="<cfoutput>#attributes.subscription_id#</cfoutput>" name="subscription_id" id="subscription_id">
											<input type="hidden" value="<cfoutput>#ct_get_subs.subscription_no#</cfoutput>" name="subscription_no" id="subscription_no">
										</div>
									</div>
								</cfif>
							</cfif>
						</cfif>
						<cfif ListFind("1,2",xml_show_service_app)>
							<cfif isDefined("attributes.service_app_id") and Len(attributes.service_app_id)>
								<cfquery name="get_service" datasource="#dsn3#">
									SELECT SERVICE_NO FROM SERVICE WHERE SERVICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.service_app_id#">
								</cfquery>
							</cfif>
							<div class="form-group" id="form_ul_subscription_no">
								<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cfoutput>#getLang("stock",168,"Servis Başvuruları")#</cfoutput><cfif xml_show_service_app eq 2>*</cfif></label>
								<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
									<div class="input-group">
										<cfoutput>
											<input type="hidden" name="service_app_id" id="service_app_id" value="<cfif isDefined("attributes.service_app_id") and Len(attributes.service_app_id)>#attributes.service_app_id#</cfif>">
											<input type="text" name="service_app_no" id="service_app_no" value="<cfif isDefined("attributes.service_app_id") and Len(attributes.service_app_id) and get_service.recordcount>#get_service.service_no#</cfif>" autocomplete="off">
											<span class="input-group-addon icon-ellipsis" onclick="windowopen('#request.self#?fuseaction=objects.popup_list_service&field_id=form_basket.service_app_id&field_no=form_basket.service_app_no&company_id='+document.getElementById('company_id').value +'<cfif session.ep.our_company_info.subscription_contract eq 1>&subscription_id='+ document.getElementById('subscription_id').value +'</cfif>','list');"></span>
										</cfoutput>
									</div>
								</div>
							</div>
						</cfif>
						<div class="form-group" id="item_td_ship_text_" style="display:none;">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang_main no='361.İrsaliye'></label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<div class="input-group">
									<input type="hidden" name="irsaliye_id_listesi" id="irsaliye_id_listesi" value="">
									<input type="hidden" name="irsaliye_project_id_listesi" id="irsaliye_project_id_listesi" value="">
									<input type="text" name="irsaliye" id="irsaliye" value="" readonly>
									<span class="input-group-addon icon-ellipsis" onclick="add_irsaliye();"></span>
								</div>
							</div>
						</div>
						<div class="form-group" id="form_ul_project_head">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cfif session.ep.our_company_info.project_followup eq 1><cf_get_lang_main no='4.Proje'></cfif></label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
									<div class="input-group">
									<cfif session.ep.our_company_info.project_followup eq 1>
										<cfoutput>
											<input type="hidden" name="project_id" id="project_id" value="<cfif isdefined('attributes.project_id')>#attributes.project_id#</cfif>"> 
											<input name="project_head" type="text" id="project_head" value="<cfif isdefined('attributes.project_id') and  len(attributes.project_id)>#GET_PROJECT_NAME(attributes.project_id)#</cfif>" onfocus="AutoComplete_Create('project_head','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','','3','200');" autocomplete="off">
											<span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_projects&project_id=form_basket.project_id&project_head=form_basket.project_head');"></span>
											<span class="input-group-addon btnPointer icon-question" onclick="if(document.getElementById('project_id').value!='')windowopen('#request.self#?fuseaction=project.popup_list_project_actions&from_paper=SHIP&id='+document.getElementById('project_id').value+'','wwide1');else alert('<cf_get_lang_main no="1385.Proje Seçiniz">');"></span>
										</cfoutput>
									</cfif>
									</div>
							</div>
						</div>
					</div>
					<div class="col col-4 col-md-4 col-sm-4 col-xs-12" type="column" index="2" sort="true">
						<div class="form-group" id="item-form_ul_ship_number">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang_main no='726.İrsaliye No'></label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<cfsavecontent variable="message"><cf_get_lang no='118.irsaliye no girmelisiniz'>!</cfsavecontent>
								<cfif isdefined('attributes.service_id') and len(attributes.service_id)>
									<cfinput type="text" name="ship_number" value="#attributes.service_paper_no#" required="yes" maxlength="50" message="#message#" onBlur="paper_control(this,'SHIP',false,0,'',form_basket.company_id.value,form_basket.consumer_id.value);">
								<cfelseif isdefined('ship_number') and len(ship_number)>
									<cfinput type="text" name="ship_number" value="#ship_number#" required="yes" maxlength="50" message="#message#" onBlur="paper_control(this,'SHIP',false,0,'',form_basket.company_id.value,form_basket.consumer_id.value);">	
								<cfelse>
									<cfinput type="text" name="ship_number" required="yes" maxlength="50" message="#message#" onBlur="paper_control(this,'SHIP',false,0,'',form_basket.company_id.value,form_basket.consumer_id.value);">
								</cfif>
							</div>
						</div>
						<div class="form-group" id="item-form_ul_ship_date">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='33096.İrsaliye Tarihi'></label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<div class="input-group">
									<cfsavecontent variable="message"><cf_get_lang_main no='1091.Lütfen Tarih Giriniz '></cfsavecontent>
										<cfif isdefined("ship_date") and len(ship_date)>
											<cfset date = ship_date>
										<cfelse>
											<cfset date = attributes.ship_date>
										</cfif>
									<cfinput type="text" name="ship_date" id="ship_date" maxlength="10" validate="#validate_style#" value="#date#" message="#message#" required="yes" readonly onblur="change_deliver_date()&change_money_info('form_basket','ship_date');">
									<span class="input-group-addon"><cf_wrk_date_image date_field="ship_date" call_function='change_deliver_date&change_money_info'></span>
								</div>
							</div>
						</div>
						<div class="form-group" id="item-action_date">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57879.İşlem Tarihi'></label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<cfsavecontent variable="message"><cf_get_lang dictionary_id='57906.İşlem Tarihi Girmelisiniz !'></cfsavecontent>
									<cfinput type="text" name="action_date" required="Yes" message="#message#" value="#dateformat(now(),dateformat_style)#" validate="#validate_style#">
									<span class="input-group-addon btnPointer" title="<cf_get_lang dictionary_id='57734.seçiniz'>"><cf_wrk_date_image date_field="action_date"></span>
								</div>
							</div>
						</div>
						<cfif isDefined("xml_show_process_stage") and len(xml_show_process_stage) and xml_show_process_stage eq 1>
							<div class="form-group" id="item-process_stage">
								<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58859.Süreç'></label>
								<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
									<cf_workcube_process is_upd='0' process_cat_width='150' is_detail='0'>
								</div>
							</div>
						</cfif>  
						<div class="form-group" id="form_ul_ref_no">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang_main no='1372.Ref No'></label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<input type="text" name="ref_no" id="ref_no" maxlength="2000" value="<cfif isdefined('attributes.ref_no') and len(attributes.ref_no)><cfoutput>#attributes.ref_no#</cfoutput></cfif>" >
							</div>
						</div>
						<div class="form-group" id="form_ul_order_id">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang_main no='199.sipariş'></label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<div class="input-group">
									<input type="hidden" name="siparis_date_listesi" id="siparis_date_listesi" value="<cfif isdefined("get_upd_purchase.ORDER_DATE")><cfoutput>#dateformat(get_upd_purchase.ORDER_DATE,dateformat_style)#</cfoutput></cfif>">
									<input type="hidden" name="order_id_listesi" id="order_id_listesi" value="<cfif isdefined('attributes.order_id') and len(attributes.order_id)><cfoutput>#attributes.order_id#</cfoutput><cfelseif isdefined('attributes.order_id_listesi') and len(attributes.order_id_listesi)><cfoutput>#attributes.order_id_listesi#</cfoutput></cfif>">
									<input type="text" name="order_id" id="order_id" readonly="yes" value="<cfif isdefined('attributes.order_number') and len(attributes.order_number)><cfoutput>#attributes.order_number#</cfoutput></cfif>">
									<span class="input-group-addon icon-ellipsis" onclick="add_order();" id="stock_order_add_btn"></span>
								</div>
							</div>
						</div>
						<cfif xml_show_ship_address eq 1>
							<div class="form-group" id="form_ul_ship_address">
								<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang_main no='1665.Yükleme Yeri'></label>
								<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
									<div class="input-group">
										<input type="hidden" name="ship_address_city_id" id="ship_address_city_id" value="">
										<input type="hidden" name="ship_address_county_id" id="ship_address_county_id" value="">
										<input type="hidden" name="deliver_comp_id" id="deliver_comp_id" value="">
										<input type="hidden" name="deliver_cons_id" id="deliver_cons_id" value="">
										<input type="hidden" name="ship_address_id" id="ship_address_id" value="">
										<input type="text" name="ship_address" id="ship_address" maxlength="200" value="">
										<span class="input-group-addon icon-ellipsis" onclick="add_adress();"></span>
									</div>
								</div>
							</div>
						</cfif>
					</div>
					<div class="col col-4 col-md-5 col-sm-5 col-xs-12" type="column" index="3" sort="true">
						<div class="form-group" id="form_ul_txt_departman_">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang_main no='1351.Depo'>*</label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<cfif isdefined("attributes.location_id")>
									<cf_wrkdepartmentlocation 
										returnInputValue="location_id,txt_departman_,department_id,branch_id"
										returnQueryValue="LOCATION_ID,LOCATION_NAME,DEPARTMENT_ID,BRANCH_ID"
										fieldName="txt_departman_"
										fieldid="location_id"
										department_fldId="department_id"
										branch_fldId="branch_id"
										branch_id="#attributes.branch_id#"
										department_id="#attributes.department_id#"
										location_id="#attributes.location_id#"
										location_name="#attributes.txt_departman_#"
										xml_all_depo = "#xml_all_depo#"
										user_level_control="#session.ep.OUR_COMPANY_INFO.IS_LOCATION_FOLLOW#"
										width="135">
								<cfelse>
									<cf_wrkdepartmentlocation 
										returnInputValue="location_id,txt_departman_,department_id,branch_id"
										returnQueryValue="LOCATION_ID,LOCATION_NAME,DEPARTMENT_ID,BRANCH_ID"
										fieldName="txt_departman_"
										fieldid="location_id"
										department_fldId="department_id"
										branch_fldId="branch_id"
										xml_all_depo = "#xml_all_depo#"
										user_level_control="#session.ep.OUR_COMPANY_INFO.IS_LOCATION_FOLLOW#"
										width="135">
								</cfif>
							</div>
						</div>
						<div class="form-group" id="form_ul_deliver_date_frm">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang no='127.Fiili Sevk Tarihi'></label>
							<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
								<div class="input-group">
									<cfsavecontent variable="message"><cf_get_lang no='110.fiili sevk tarihi girmelisiniz'></cfsavecontent>
									<cfif isdefined('attributes.deliver_date') and len(attributes.deliver_date)>
										<cfinput type="text" name="deliver_date_frm" id="deliver_date_frm" maxlength="10" value="#attributes.deliver_date#" required="yes" message="#message#" validate="#validate_style#">
									<cfelse>
										<cfinput type="text" name="deliver_date_frm" id="deliver_date_frm" maxlength="10" value="#get_date_bugun#" required="yes" message="#message#" validate="#validate_style#">
									</cfif>
									<cfif isdefined('get_upd_purchase.deliver_date') and len(get_upd_purchase.deliver_date)>
									<cfset value_deliver_date_h=hour(get_upd_purchase.deliver_date)>
									<cfset value_deliver_date_m=minute(get_upd_purchase.deliver_date)>
									<cfelse>											
										<cfset adate = dateadd('h',session.ep.time_zone,now())>
										<cfset value_deliver_date_h=datepart("H",adate)>
										<cfset value_deliver_date_m=datepart("N",adate)>
									</cfif>
										<span class="input-group-addon"><cf_wrk_date_image date_field="deliver_date_frm"></span>
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
						<div class="form-group" id="form_ul_ship_method_name">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang_main no='1703.Sevk Yontemi'></label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<div class="input-group">
									<input type="hidden" name="ship_method" id="ship_method" value="<cfif isdefined('attributes.ship_method_id') and len(attributes.ship_method_id)><cfoutput>#attributes.ship_method_id#</cfoutput></cfif>">
									<cfif isdefined('attributes.ship_method_id') and len(attributes.ship_method_id)>
										<cfinclude template="../query/get_ship_method.cfm">
										<cfset attributes.ship_method_name =get_ship_method.ship_method>
									</cfif>
									<input type="text" name="ship_method_name" id="ship_method_name" value="<cfif isdefined('attributes.ship_method_name') and len(attributes.ship_method_name)><cfoutput>#attributes.ship_method_name#</cfoutput></cfif>" onfocus="AutoComplete_Create('ship_method_name','SHIP_METHOD','SHIP_METHOD','get_ship_method','','SHIP_METHOD_ID','ship_method','','3','135');" autocomplete="off">
									<span class="input-group-addon icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_ship_methods&field_name=ship_method_name&field_id=ship_method','medium');"></span>
								</div>
							</div>
						</div>				
						<div class="form-group" id="form_ul_detail">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang_main no='217.Açıklama'></label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<textarea name="detail" id="detail"><cfif isdefined('attributes.detail') and len(attributes.detail)><cfoutput>#attributes.detail#</cfoutput></cfif></textarea>
							</div>
						</div>
						<div class="form-group" id="item-add_info">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cfoutput>#getLang('main',398)#</cfoutput></label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<cf_wrk_add_info info_type_id="-14" upd_page = "0">
							</div>
						</div>
					</div>
					</cf_box_elements>			
					<cf_box_footer>
						<cf_workcube_buttons is_upd='0' add_function='kontrol()'>
					</cf_box_footer>
				</cf_basket_form>
				<cfif isdefined('attributes.service_id') and len(attributes.service_id)> <!--- servis modulunden cagırılıyorsa --->
					<cfset attributes.basket_id = 47> 
				<cfelseif isdefined('attributes.order_id') and len(attributes.order_id)> <!--- stock - emirlerden cagırılıyorsa --->
					<cfset attributes.basket_id = 15> 
				<cfelseif session.ep.isBranchAuthorization><!--- subeden cagırılıyorsa sube basket sablonunu kullansın--->
					<cfset attributes.basket_id = 17> 
				<cfelse>
					<cfset attributes.basket_id = 11>
				</cfif>
				<cfif not isdefined('attributes.is_ship_copy') and not isdefined('attributes.service_id') and not isdefined('attributes.order_id') and not isdefined("attributes.receiving_detail_id")>
					<cfif not isdefined("attributes.file_format") and not isdefined("attributes.return_row_ids") and not isdefined("attributes.invent_return_row_ids") and not isdefined("attributes.kons_row_ids")>
						<cfset attributes.form_add = 1>
					<cfelse>
						<cfif isdefined("attributes.return_row_ids") and not isdefined("attributes.subscription_id")>
							<cfset attributes.basket_sub_id = 8>
						<cfelseif isdefined("attributes.invent_return_row_ids") and isdefined("attributes.subscription_id")>
							<cfset attributes.basket_sub_id = '8_2'>
						<cfelseif isdefined("attributes.kons_row_ids") and isdefined("attributes.subscription_id")>
							<cfset attributes.basket_sub_id = '8_2'>
						<cfelse>
							<cfset is_from_ship = 1>
							<cfset attributes.basket_sub_id = 4>
						</cfif>
					</cfif>
				</cfif>
				<cfinclude template="../../objects/display/basket.cfm">
			</cfform>
		</div>
	</cf_box>
</div>
<script type="text/javascript">
	<cfif isdefined('attributes.service_id') and len(attributes.service_id)>
		function mal_alimi_sec()
		{
			max_sel = form_basket.process_cat.options.length;
			for(my_i=0;my_i<=max_sel;my_i++)
			{
				deger = form_basket.process_cat.options[my_i].value;
				if(deger!="")
				{
					var fis_no = eval("form_basket.ct_process_type_" + deger );
					if(fis_no.value == 140)
					{
						form_basket.process_cat.options[my_i].selected = true;
						my_i = max_sel + 1;
					}
				}
			}
		}
		mal_alimi_sec();
	</cfif>
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
	}
	function add_order()
	{	
		if(((form_basket.company_id.value.length && form_basket.company_id.value!="") || (form_basket.consumer_id.value.length && form_basket.consumer_id.value!="")) &&(form_basket.department_id.value.length && form_basket.department_id.value!=""))
		{	
		str_irslink = '&order_id_liste=' + form_basket.order_id_listesi.value + '&order_date_liste=' + form_basket.siparis_date_listesi.value + '&is_purchase=1&dept_id='+form_basket.department_id.value +'&company_id='+form_basket.company_id.value + '&consumer_id='+form_basket.consumer_id.value<cfif session.ep.isBranchAuthorization>+'&is_sale_store='+1</cfif>; 
			<cfif session.ep.our_company_info.project_followup eq 1>
				if(form_basket.project_id.value!='' && form_basket.project_head.value!='')
					str_irslink = str_irslink+'&project_id='+form_basket.project_id.value;
			 </cfif>
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_orders_for_ship' + str_irslink , 'horizantal');
			return true;
		}
		else if (form_basket.company_id.value =="" && form_basket.consumer_id.value =="" && form_basket.employee_id.value =="")
		{
			alert("<cf_get_lang no='131.Cari Hesap Seçmelisiniz'>!");
			return false;
		}
		else if (form_basket.department_id.value =="")
		{
			alert("<cf_get_lang no='195.Depo Seçiniz!'>");
			return false;
		}
	}
    function open_phl() {
		openBoxDraggable('<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#</cfoutput>.add_ship_from_file&from_where=2&draggable=1');
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
					alert("<cf_get_lang no='323.İşlem Tipi Seçmelisiniz'> !");
					return false;
				}
				str_irslink = str_irslink;
			</cfif>
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_choice_ship&from_ship=1&ship_project_liste=1'+ str_irslink+'&process_cat='+form_basket.process_cat.value,'page');
			return true;
		}
		else
		{
			alert("<cf_get_lang no='131.Önce Üye Seçiniz'>!");
			return false;
		}
	}
	function kontrol()
	{
		<cfif isDefined("xml_show_process_stage") and len(xml_show_process_stage) and xml_show_process_stage eq 1>
			if(document.form_basket.process_stage.value == "")
			{
				alert("<cf_get_lang dictionary_id ='41036.Lütfen Süreçlerinizi Tanimlayiniz veya Tanimlanan Süreçler Üzerinde Yetkiniz Yok'>!");
				return false;
			}
		</cfif>	
		if(!paper_control(form_basket.ship_number,'SHIP',false,0,'',form_basket.company_id.value,form_basket.consumer_id.value)) return false;
		if(!chk_period(form_basket.ship_date)) return false;
		if(form_basket.deliver_date_frm.value.length)
			if(!chk_period(form_basket.deliver_date_frm)) return false;
		if(!chk_process_cat('form_basket')) return false;
		if (!check_display_files('form_basket')) return false;
		if(form_basket.partner_id.value =="" && form_basket.consumer_id.value =="" && form_basket.employee_id.value =="")
		{
			alert("<cf_get_lang no='131.Cari Hesap Seçmelisiniz'>! \ <cf_get_lang no='271.Eğer Cari Hesap Seçili İse Üye Şirkete Çalışan Ekleyiniz'>!");
			return false;
		}
		if(document.form_basket.txt_departman_.value=="" || document.form_basket.department_id.value=="")
		{
			alert("<cf_get_lang no='507.Depo Seçmelisiniz'>!");
			return false;
		}
		<cfif xml_show_service_app eq 2> // Servis Basvuru Zorunlu ise
			if(document.getElementById("service_app_id").value == "" || document.getElementById("service_app_no").value == "")
			{
				alert("Girilmesi Zorunlu Alan: Servis Başvurusu !");
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
									alert("<cf_get_lang no='115.İlişkili Konsinye Çıkışı Yok'>! <cf_get_lang_main no='818.Satır No'>: "+(str_i_row+1));
									return false;
								}
							}
							else if( basketManagerObject.basketItems()[str_i_row].product_id() != '' && basketManagerObject.basketItems()[str_i_row].wrk_row_relation_id() == ''){
								alert("<cf_get_lang no='115.İlişkili Konsinye Çıkışı Yok'>! <cf_get_lang_main no='818.Satır No'>: "+(str_i_row+1));
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
									alert("<cf_get_lang no='115.İlişkili Konsinye Çıkışı Yok'>! <cf_get_lang_main no='818.Satır No'>: "+(str_i_row+1));
									return false;
								}
							}
							else if(window.basket.items[str_i_row].PRODUCT_ID != '' && window.basket.items[str_i_row].WRK_ROW_RELATION_ID == ''){
								alert("<cf_get_lang no='115.İlişkili Konsinye Çıkışı Yok'>! <cf_get_lang_main no='818.Satır No'>: "+(str_i_row+1));
								return false;
							}
						}
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
						amount_other_ = window.basket.items[str].AMOUNT_OTHER;
						product_serial_control = wrk_safe_query("chk_product_serial1",'dsn3',0, window.basket.items[str].PRODUCT_ID);
						str1_ = "SELECT SERIAL_NO FROM SERVICE_GUARANTY_NEW WHERE WRK_ROW_ID = '"+ wrk_row_id_ +"'";
						var get_serial_control = wrk_query(str1_,'dsn3');
						if( product_serial_control.IS_SERIAL_NO == '1' && get_serial_control.recordcount != amount_ && get_serial_control.recordcount != amount_other_ ){
							prod_name_list = prod_name_list + eval(str +1) + '.Satır : ' + window.basket.items[str].PRODUCT_NAME + '\n';
						}
					}
				}
			}
			if(prod_name_list!=''){
				alert(prod_name_list +" Adlı Ürünler İçin Seri Numarası Girmelisiniz!");
				return false;
			}
		</cfif>
		<!---Satır bazında seri girilmesi zorunluluğu kontrolü --->
		
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
						alert("<cf_get_lang no='106.Aşağıda Belirtilen Ürünler İçin İade Miktarı Konsinye Miktarından Fazla Lütfen Ürünleri Kontrol Ediniz'> ! \n\n" + ship_product_list);
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
						alert("<cf_get_lang no='119.Aşağıda Belirtilen Ürünler İçin İade Miktarı Toptan Satış Miktarından Fazla Lütfen Ürünleri Kontrol Ediniz'> ! \n\n" + ship_product_list);
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
						alert("<cf_get_lang no='106.Aşağıda Belirtilen Ürünler İçin İade Miktarı Konsinye Miktarından Fazla Lütfen Ürünleri Kontrol Ediniz'> ! \n\n" + ship_product_list);
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
						alert("<cf_get_lang no='119.Aşağıda Belirtilen Ürünler İçin İade Miktarı Toptan Satış Miktarından Fazla Lütfen Ürünleri Kontrol Ediniz'> ! \n\n" + ship_product_list);
						return false;
					}
				}
			}
			
		</cfif>
		// xml de proje kontrolleri yapılsın seçilmişse
		<cfif xml_control_project eq 1>
			if(fis_no == 75){ //konsinye irsaliye ise iliskili irsaliye kontrolu yapar
			var irsaliye_deger_list = document.form_basket.irsaliye_project_id_listesi.value;
			if(irsaliye_deger_list != ''){
				var liste_uzunlugu = list_len(irsaliye_deger_list);
				for(var str_i_row=1; str_i_row <= liste_uzunlugu; str_i_row++){
					var project_id_ = list_getat(irsaliye_deger_list,str_i_row,',');
					if(document.form_basket.project_id.value != '' && document.form_basket.project_head.value != '')
						var sonuc_ = document.form_basket.project_id.value;
					else
						var sonuc_ = 0;
					if(project_id_ != sonuc_)
						{
							alert('<cf_get_lang no="124.İlgili İrsaliyeye Bağlı İrsaliyelerin Projeleri İle İrsaliyede Seçilen Proje Aynı Olmalıdır">!');
							return false;
						}
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
							var sonuc_ = datediff(document.form_basket.ship_date.value,tarih_,0);
							if(sonuc_ > 0)
								{
									alert('<cf_get_lang no="126.İrsaliye Tarihi Sipariş Tarihinden Önce Olamaz">!');
									return false;
								}
						}
				}
		</cfif>
		<cfif (xml_disable_change eq 1 and isdefined("attributes.invent_return_row_ids") and isdefined("attributes.subscription_id")) or (xml_disable_change eq 1 and isdefined("attributes.kons_row_ids"))>
			var bsk_rowCount = form_basket.amount.length;
			if(bsk_rowCount){
				for(var str_i_row=0; str_i_row < bsk_rowCount; str_i_row++)
				{
					document.form_basket.amount[str_i_row].removeAttribute('disabled','yes');
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
	function change_deliver_date()
	{//eklemede,irsaliye tarihi değiştiğinde fiili sevk tarihi de değişir
		document.form_basket.deliver_date_frm.value = document.form_basket.ship_date.value;
	}
	function add_adress()
	{
		if(!(document.form_basket.company_id.value=="") || !(document.form_basket.consumer_id.value==""))
		{
			if(document.form_basket.company_id.value!="")
				{
					str_adrlink = '&field_long_adres=form_basket.ship_address&field_adress_id=form_basket.ship_address_id';
					if(document.form_basket.ship_address_city_id!=undefined) str_adrlink = str_adrlink+'&field_city=form_basket.ship_address_city_id';
					if(document.form_basket.ship_address_county_id!=undefined) str_adrlink = str_adrlink+'&field_county=form_basket.ship_address_county_id&field_id=form_basket.deliver_comp_id'<cfif session.ep.isBranchAuthorization>+'&is_store_module='+1</cfif>;
					windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_member_address&is_comp=1&select_list=1&keyword='+encodeURIComponent(document.form_basket.comp_name.value)+''+ str_adrlink , 'list');
					document.getElementById('deliver_cons_id').value = '';
					return true;
				}
			else
				{
					str_adrlink = '&field_long_adres=form_basket.ship_address&field_adress_id=form_basket.ship_address_id'; 
					if(document.form_basket.ship_address_city_id!=undefined) str_adrlink = str_adrlink+'&field_city=form_basket.ship_address_city_id';
					if(document.form_basket.ship_address_county_id!=undefined) str_adrlink = str_adrlink+'&field_county=form_basket.ship_address_county_id&field_id=form_basket.deliver_cons_id'<cfif session.ep.isBranchAuthorization>+'&is_store_module='+1</cfif>;
					windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_member_address&is_comp=0&select_list=2&keyword='+encodeURIComponent(document.form_basket.comp_name.value)+''+ str_adrlink , 'list');
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
	
	<cfif (xml_disable_change eq 1 and isdefined("attributes.invent_return_row_ids") and isdefined("attributes.subscription_id")) or (xml_disable_change eq 1 and isdefined("attributes.kons_row_ids"))>
		if(document.form_basket.Amount.length != undefined && document.form_basket.Amount.length >1)
		{
			var bsk_rowCount = document.form_basket.Amount.length;
			for(var str_i_row=0; str_i_row < bsk_rowCount; str_i_row++)
			{
				document.form_basket.Amount[str_i_row].setAttribute('disabled','yes');
			}
		}
		else if(document.form_basket.Amount != undefined && document.form_basket.Amount.value != '')
		{
			document.form_basket.Amount.setAttribute('disabled','yes');
		}		
		function my_gizle_function(className)
		{
			$(document).ready(function()
			{
				if($("."+className).css("display","undefined")) 
					$("."+className).css("display","none");
			});
		}
		gizle(stock_order_add_btn);
		my_gizle_function("basket_header_add");
		my_gizle_function("sepetim_search");		
	</cfif>
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->