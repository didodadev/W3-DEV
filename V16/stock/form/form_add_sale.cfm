<div style="display:none;z-index:999;left:250px;" id="phl_div"></div>
<cf_get_lang_set module_name="stock"><!--- sayfanin en altinda kapanisi var --->
<cf_xml_page_edit fuseact="stock.form_add_sale">
<cfset attributes.subscription_id=""><!--- cf_wrk_subscriptions custom tag'ine tanımlı gidebilmesi icin atandı --->
<cfset attributes.paymethod_id = "">
<cfset attributes.card_paymethod_id = "">
<cfset attributes.commission_rate = "">
<cfset attributes.commethod_id = "">
<cfif isdefined('attributes.service_ids') and len(attributes.service_ids)><!--- servis modulunden cagrılmıssa --->
	<cfset process_type_info = '141,85,71'>
	<cfif isdefined("attributes.related_partner_id") and len(attributes.related_partner_id)>
		<cfquery name="GET_SERVICE" datasource="#DSN3#" maxrows="1">
			SELECT
				S.PROJECT_ID,
				S.SERVICE_NO,
				CP.COMPANY_PARTNER_ADDRESS + ' ' + CP.SEMT AS SERVICE_ADDRESS,
				CP.COUNTY AS SERVICE_COUNTY,
				CP.CITY AS SERVICE_CITY,
				CP.COUNTRY AS SERVICE_COUNTRY,
				S.SERVICE_BRANCH_ID,
				S.DEPARTMENT_ID,
				D.DEPARTMENT_HEAD,
				S.LOCATION_ID,
				CP.PARTNER_ID AS SERVICE_PARTNER_ID,
				CP.COMPANY_ID AS SERVICE_COMPANY_ID,
				'' AS SERVICE_CONSUMER_ID,
				S.SERVICE_ADDRESS,
				ISNULL(C.ISPOTANTIAL,0) AS IS_POTENTIAL,
				S.SUBSCRIPTION_ID
			FROM
				SERVICE S,
				#dsn_alias#.DEPARTMENT D,
				#dsn_alias#.COMPANY_PARTNER CP,
				#dsn_alias#.COMPANY C
			WHERE
				S.RELATED_COMPANY_ID = C.COMPANY_ID AND
				C.COMPANY_ID = CP.COMPANY_ID AND
				CP.PARTNER_ID = #attributes.related_partner_id# AND
				S.SERVICE_ID IN (#attributes.service_ids#) AND
				S.DEPARTMENT_ID = D.DEPARTMENT_ID
		</cfquery>
	<cfelse>
		<cfquery name="GET_SERVICE" datasource="#DSN3#" maxrows="1">
			SELECT
				S.PROJECT_ID,
				S.SERVICE_NO,
				S.SERVICE_ADDRESS,
				'' AS SERVICE_COUNTY,
				'' AS SERVICE_CITY,
				'' AS SERVICE_COUNTRY,
				S.SERVICE_BRANCH_ID,
				S.DEPARTMENT_ID,
				D.DEPARTMENT_HEAD,
				S.LOCATION_ID,
				S.SERVICE_PARTNER_ID,
				S.SERVICE_COMPANY_ID,
				S.SERVICE_CONSUMER_ID,
				S.SERVICE_ADDRESS,
				(SELECT ISNULL(ISPOTANTIAL,0) AS ISPOTANTIAL FROM #dsn_alias#.COMPANY WHERE COMPANY_ID = S.SERVICE_COMPANY_ID) AS ISPOTANTIAL,
				S.SUBSCRIPTION_ID
			FROM
				SERVICE S,
				#dsn_alias#.DEPARTMENT D
			WHERE
				S.SERVICE_ID IN (#attributes.service_ids#) AND
				S.DEPARTMENT_ID = D.DEPARTMENT_ID
		</cfquery>
	</cfif>
	<cfif not GET_SERVICE.recordcount>
		<script type="text/javascript">
			alert("<cf_get_lang dictionary_id='45268.Servis Bulunamadı veya Servis Lokasyonu Eksik Hatalı Lütfen Düzenleyiniz'>!");
			location.href="<cfoutput>#request.self#?fuseaction=service.list_service&event=upd&service_id=#attributes.service_ids#</cfoutput>";
		</script>
		<cfabort>
	</cfif>
	<cfif GET_SERVICE.ISPOTANTIAL eq 1>
		<script type="text/javascript">
			alert("<cf_get_lang dictionary_id='45355.Potansiyel Üyelerde bu işlemi yapamazsınız'>!");
			location.href="<cfoutput>#request.self#?fuseaction=service.list_service&event=upd&service_id=#attributes.service_ids#</cfoutput>";
		</script>
		<cfabort>
	</cfif>
	<cfscript>
		attributes.ref_no = GET_SERVICE.service_no;
		attributes.company_id = get_service.service_company_id;
		attributes.comp_name= get_par_info(get_service.service_company_id,1,1,0);
		attributes.consumer_id = get_service.service_consumer_id;
		attributes.partner_id = get_service.service_partner_id;
		if(len(get_service.service_partner_id) and get_service.service_partner_id neq 0)
			attributes.partner_name=get_par_info(get_service.service_partner_id,0,-1,0);
		else
			attributes.partner_name=get_cons_info(get_service.service_consumer_id,0,0);
			
		attributes.deliver_date =  dateformat(now(),dateformat_style);
		attributes.ship_date = dateformat(now(),dateformat_style);
		attributes.service_paper_no =get_service.service_no;
		location_info_ = get_location_info(get_service.department_id,get_service.location_id,1,1);
		attributes.location_id = get_service.location_id;
		attributes.branch_id = listlast(location_info_,',');
		attributes.department_id = get_service.department_id;
		attributes.adres = get_service.SERVICE_ADDRESS;
		attributes.city_id = '#get_service.SERVICE_CITY#';
		attributes.county_id ='#get_service.SERVICE_COUNTY#';
		attributes.country_id=	'#get_service.SERVICE_COUNTRY#'	;
		attributes.txt_departman_ =listfirst(location_info_,',');
		attributes.project_id = get_service.project_id;
		attributes.subscription_id = get_service.subscription_id;
		attributes.service_app_id = attributes.service_ids;
		txt_paper=get_service.service_no;
	</cfscript>
	<cfif len(attributes.county_id)>
		<cfquery name="GET_COUNTY" datasource="#DSN#">
			SELECT COUNTY_NAME FROM SETUP_COUNTY WHERE COUNTY_ID = #attributes.county_id#
		</cfquery>
		<cfset attributes.adres = '#attributes.adres# #GET_COUNTY.COUNTY_NAME#'> 
	</cfif>
	<cfif len(attributes.city_id)>
		<cfquery name="GET_CITY" datasource="#DSN#">
			SELECT CITY_ID, CITY_NAME FROM SETUP_CITY WHERE CITY_ID = #attributes.city_id#
		</cfquery>
		<cfset attributes.adres = '#attributes.adres# #GET_CITY.CITY_NAME#'>
	</cfif>
	<cfif len(attributes.country_id)>
		<cfquery name="GET_COUNTRY" datasource="#DSN#">
			SELECT COUNTRY_NAME FROM SETUP_COUNTRY WHERE COUNTRY_ID = #attributes.COUNTRY_id#
		</cfquery>
	</cfif>
</cfif>
<cfif isdefined('attributes.is_ship_copy')>
	<cfinclude template="../query/get_upd_purchase.cfm">
	<cfscript>
		location_info_ = get_location_info(get_upd_purchase.deliver_store_id,get_upd_purchase.location,1,1);
		attributes.location_id = get_upd_purchase.location;
		attributes.department_id = get_upd_purchase.deliver_store_id;
		attributes.branch_id = listlast(location_info_,',');
		attributes.txt_departman_ =listfirst(location_info_,',');
		attributes.company_id =get_upd_purchase.company_id;
		attributes.comp_name =get_par_info(get_upd_purchase.company_id,1,0,0);
		attributes.partner_id = get_upd_purchase.partner_id;
		attributes.consumer_id=get_upd_purchase.consumer_id;
		attributes.employee_id=get_upd_purchase.employee_id;
		if(len(get_upd_purchase.partner_id) and get_upd_purchase.partner_id neq 0)
			attributes.partner_name=get_par_info(get_upd_purchase.partner_id,0,-1,0);
		else
			attributes.partner_name=get_cons_info(get_upd_purchase.consumer_id,0,0);
		attributes.city_id = GET_UPD_PURCHASE.CITY_ID;
		attributes.county_id = GET_UPD_PURCHASE.COUNTY_ID;
		attributes.ship_address_id = get_upd_purchase.ship_address_id;
		attributes.adres = trim(get_upd_purchase.address);
		attributes.project_id = get_upd_purchase.project_id;
		attributes.ship_method_name ='';
		attributes.ship_method_id=get_upd_purchase.ship_method;
		attributes.deliver_get = get_upd_purchase.deliver_emp;
		attributes.sale_emp = get_upd_purchase.sale_emp;
		attributes.deliver_date = dateformat(get_upd_purchase.deliver_date,dateformat_style);
		attributes.sale_emp = get_upd_purchase.sale_emp;
		attributes.subscription_id = get_upd_purchase.subscription_id;
		attributes.order_detail = get_upd_purchase.ship_detail;
		attributes.ref_no = get_upd_purchase.ref_no;
		attributes.service_app_id = get_upd_purchase.service_id;
		attributes.due_date = get_upd_purchase.due_date;
		attributes.paymethod_id = get_upd_purchase.paymethod_id;
		attributes.card_paymethod_id = get_upd_purchase.card_paymethod_id;
		attributes.commethod_id = get_upd_purchase.commethod_id;
		attributes.due_date_diff = datediff('d',get_upd_purchase.ship_date,attributes.due_date);
		attributes.ship_date =  dateformat(get_upd_purchase.ship_date,dateformat_style);
	</cfscript>
</cfif>
<cfif not (isdefined('attributes.service_id') and len(attributes.service_id)) and not isdefined("attributes.ship_id") and isdefined("attributes.project_id") and len(attributes.project_id) and not isdefined('attributes.service_ids')>
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
<cfif isdefined('attributes.order_id') and len(attributes.order_id)>
	<cfinclude template="../query/get_det_order_sale.cfm">
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
	attributes.ship_date = dateformat(now(),dateformat_style);
	attributes.ref_no = get_upd_purchase.ref_no;
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
	attributes.ship_address_id = get_upd_purchase.ship_address_id;
	attributes.adres = trim(get_upd_purchase.ship_address);
	attributes.ship_method_id = get_upd_purchase.ship_method;
	attributes.order_detail = get_upd_purchase.order_detail;
	attributes.project_id = get_upd_purchase.project_id;
	attributes.subscription_id = get_upd_purchase.subscription_id;
	attributes.paymethod_id = get_upd_purchase.paymethod;
	attributes.card_paymethod_id = get_upd_purchase.card_paymethod_id;
	attributes.commethod_id = get_upd_purchase.commethod_id;
	attributes.due_date = get_upd_purchase.due_date;
	</cfscript>
</cfif>
<cfif isdefined('attributes.paymethod_id') and len(attributes.paymethod_id)>
	<cfquery name="get_pay_meyhod" datasource="#dsn#">
		SELECT PAYMETHOD FROM SETUP_PAYMETHOD WHERE PAYMETHOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.paymethod_id#">
	</cfquery>	
	<cfset attributes.paymethod_name = get_pay_meyhod.paymethod>
<cfelse>
	<cfset attributes.paymethod_name = ''>
</cfif>
<cf_papers paper_type = "ship">
<cfif isdefined("attributes.company_id")>
	<cfset attributes.comp_id = attributes.company_id>
</cfif>
<cfif isdefined("attributes.consumer_id")>
	<cfset attributes.cons_id = attributes.consumer_id>
</cfif>
<cfif isdefined('attributes.service_ids') and len(attributes.service_ids)>
	<cfset attributes.service_ids = attributes.service_ids>
</cfif>
<cfscript>
	if(isdefined('attributes.is_ship_copy') )
		session_basket_kur_ekle(action_id=attributes.ship_id,table_type_id:2,process_type:1);
	else if(isDefined("attributes.order_id"))//siparisten gelen
		session_basket_kur_ekle(action_id=attributes.order_id,table_type_id:3,to_table_type_id:1,process_type:1);
	else if(isDefined("attributes.service_ids")) //servis başvurusunan gelen
		session_basket_kur_ekle(process_type:0);
	else
		session_basket_kur_ekle(process_type:0);
	xml_all_depo = iif(isdefined("xml_location_auth"),xml_location_auth,DE('-1'));
</cfscript>
<cf_catalystHeader>
<!---<cfif listgetat(attributes.fuseaction,1,'.') is not 'service'>
	<cfinclude template="../query/get_find_ship_js.cfm">
</cfif>--->
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box>
		<div id="basket_main_div">
			<cfform name="form_basket" id="form_basket" method="post" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_add_sale_process">
				<cf_basket_form id="detail_inv_purchase_ship">
					<cf_box_elements>
						<cfoutput>
							<input type="hidden" name="form_action_address" id="form_action_address" value="#listgetat(attributes.fuseaction,1,'.')#.emptypopup_add_sale_process">
							<!--- Ziyaret Sonucundan olusturulan irsaliyelerin iliskilerinin tutulmasi icin gonderiliyor, kaldirmayin FBS 20110422 --->
							<cfif isDefined("url.related_action_table")><input type="hidden" name="related_action_table_main" id="related_action_table_main" value="#url.related_action_table#"></cfif>
							<cfif isDefined("url.related_action_id")><input type="hidden" name="related_action_id_main" id="related_action_id_main" value="#url.related_action_id#"></cfif>
							<!--- //Ziyaret Sonucundan olusturulan irsaliyelerin iliskilerinin tutulmasi icin gonderiliyor, kaldirmayin FBS 20110422 --->
							<input type="hidden" name="paper_number" id="paper_number" value="<cfif isdefined("paper_number")>#paper_number#</cfif>">
							<input type="hidden" name="paper_printer_id" id="paper_printer_id" value="<cfif isDefined('paper_printer_code')>#paper_printer_code#</cfif>">
							<input type="hidden" name="active_period" id="active_period" value="#session.ep.period_id#">
							<input type="hidden" name="sale" id="sale" value="1"><!--- satış --->
							<cfif fusebox.fuseaction contains 'popup'>
								<input type="hidden" name="is_popup" id="is_popup" value="1">
							</cfif>
							<input type="hidden" name="service_id" id="service_id" value="<cfif isdefined('attributes.service_ids') and len(attributes.service_ids)>#attributes.service_ids#</cfif>">
						</cfoutput>
						<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" id="column-1" sort="true">
							<cfif isdefined("xml_show_process_stage") and len(xml_show_process_stage) and xml_show_process_stage eq 1>
								<div class="form-group require" id="item-process_stage">
									<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id="58859.Süreç"></label>
									<div class="col col-8 col-sm-12">
										<cf_workcube_process is_upd='0' process_cat_width='125' is_detail='0'>
									</div>                
								</div> 
							</cfif>
							<div class="form-group" id="item-process_cat">
								<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57800.İşlem Tipi'></label>
								<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
									<cfif isdefined("attributes.process_cat")>
										<cfoutput><cf_workcube_process_cat onclick_function="check_process_is_sale();" process_cat="#attributes.process_cat#"></cfoutput>
									<cfelseif isdefined("attributes.service_ids") and len(attributes.service_ids)>
										<cf_workcube_process_cat onclick_function="check_process_is_sale();"  process_type_info="#process_type_info#"> 
									<cfelse>
										<cf_workcube_process_cat onclick_function="check_process_is_sale();"> 
									</cfif>
								</div>                
							</div> 
							<div class="form-group" id="item-comp_name">
								<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57519.cari hesap'></label>
								<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
									<div class="input-group">
										<input type="hidden" name="company_id" id="company_id" value="<cfif isdefined("attributes.company_id") and len(attributes.company_id)><cfoutput>#attributes.company_id#</cfoutput></cfif>">
										<input type="text" name="comp_name" id="comp_name" readonly="" value="<cfif isdefined("attributes.company_id") and len(attributes.company_id)><cfoutput>#get_par_info(attributes.company_id,1,1,0)#</cfoutput></cfif>">
										<cfset str_linkeait = "&field_paymethod_id=form_basket.paymethod_id&field_paymethod=form_basket.paymethod_name&field_revmethod_id=form_basket.paymethod_id&field_revmethod=form_basket.paymethod_name&field_basket_due_value=form_basket.basket_due_value&ship_method_id=form_basket.ship_method&ship_method_name=form_basket.ship_method_name&field_card_payment_id=form_basket.card_paymethod_id&field_comp_id2=form_basket.deliver_comp_id&field_consumer2=form_basket.deliver_cons_id">
										<span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_pars&is_cari_action=1&select_list=2,3,1,9&field_name=form_basket.partner_name&field_emp_id=form_basket.employee_id&field_partner=form_basket.partner_id&field_comp_name=form_basket.comp_name&field_comp_id=form_basket.company_id&field_country_id=form_basket.country_id&field_consumer=form_basket.consumer_id&come=stock&field_adress_id=form_basket.ship_address_id&is_potansiyel=0&field_long_address=form_basket.adres&field_city_id=form_basket.city_id&field_county_id=form_basket.county_id#str_linkeait#<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif></cfoutput>&call_function=add_general_prom()-check_member_price_cat()-change_paper_duedate()');"></span>
									</div>             
								</div>                
							</div> 
							<cfoutput>
								<input type="hidden" name="partner_id" id="partner_id" value="<cfif isdefined("attributes.partner_id") and len(attributes.partner_id)>#attributes.partner_id#</cfif>">
								<input type="hidden" name="consumer_id" id="consumer_id" value="<cfif isdefined("attributes.consumer_id") and len(attributes.consumer_id)>#attributes.consumer_id#</cfif>">
								<input type="hidden" name="employee_id" id="employee_id" value="<cfif isdefined("attributes.employee_id") and len(attributes.employee_id)>#attributes.employee_id#</cfif>">
							</cfoutput>
							<div class="form-group" id="item-partner_name">
								<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57578.yetkili'></label>
								<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
									<cfoutput>
										<input type="text" name="partner_name" id="partner_name" readonly value="<cfif isdefined('attributes.partner_id') and len(attributes.partner_id)>#get_par_info(attributes.partner_id,0,-1,0)#<cfelseif isdefined('attributes.consumer_id') and len(attributes.consumer_id)>#get_cons_info(attributes.consumer_id,0,0,0)#<cfelseif isdefined("attributes.employee_id") and len(attributes.employee_id)>#get_emp_info(attributes.employee_id,0,0)#</cfif>"><!--- <cfif isdefined("attributes.partner_name")><cfoutput>#attributes.partner_name#</cfoutput></cfif> --->
									</cfoutput>          
								</div>                
							</div>   
							<div class="form-group" id="item-deliver_get">
								<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57775.teslim alan'></label>
								<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
									<div class="input-group">
										<input type="hidden" name="deliver_get_id" id="deliver_get_id"  value="">
										<input type="text" name="deliver_get" id="deliver_get" onfocus="AutoComplete_Create('deliver_get','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_PARTNER_NAME2,MEMBER_NAME2','get_member_autocomplete','\'1,2,3\'','PARTNER_ID','deliver_get_id','','3','250');" value="<cfif isdefined('attributes.deliver_get') and len(attributes.deliver_get)><cfoutput>#attributes.deliver_get#</cfoutput></cfif>" autocomplete="off" >
										<span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_pars&select_list=2,3,1&field_name=form_basket.deliver_get&field_partner=form_basket.deliver_get_id&come=stock</cfoutput>');"></span>
									</div>             
								</div>                
							</div> 
							<div class="form-group" id="item-order_id">
								<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57611.sipariş'></label>
								<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
									<div class="input-group">
										<input type="hidden" name="order_system_id_list" id="order_system_id_list" value="<cfif isdefined("attributes.subscription_id")><cfoutput>#attributes.subscription_id#</cfoutput></cfif>">
										<input type="hidden" name="order_id_listesi" id="order_id_listesi" value="<cfif isdefined('attributes.order_id') and len(attributes.order_id)><cfoutput>#attributes.order_id#</cfoutput></cfif>">
										<input type="text" name="order_id" id="order_id" value="<cfif isdefined('attributes.order_number') and len(attributes.order_number)><cfoutput>#attributes.order_number#</cfoutput></cfif>" readonly>
										<span class="input-group-addon btnPointer icon-ellipsis" onclick="add_order();"></span>
									</div>             
								</div>                
							</div>
							<div class="form-group" id="item-sale_emp_name">
								<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id = '45229.Satış Çalışan'></label>
								<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
									<div class="input-group">
										<input type="hidden" name="sale_emp" id="sale_emp" value="<cfif isdefined('attributes.sale_emp') and len(attributes.sale_emp)><cfoutput>#attributes.sale_emp#</cfoutput></cfif>">
										<input type="text" name="sale_emp_name" id="sale_emp_name" value="<cfif isdefined('attributes.sale_emp') and len(attributes.sale_emp)><cfoutput>#get_emp_info(attributes.sale_emp,0,0)#</cfoutput></cfif>"  onfocus="AutoComplete_Create('sale_emp_name','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','sale_emp','','3','150');" autocomplete="off">
										<span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=form_basket.sale_emp&field_name=form_basket.sale_emp_name&select_list=1','list');"></span>            
									</div>
								</div>                
							</div>
							<cfif session.ep.our_company_info.subscription_contract eq 1>
							<div class="form-group" id="item-subscription_no">
								<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='29502.Abone No'></label>
								<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
									<cfif isdefined("attributes.subscription_id")>
										<cf_wrk_subscriptions subscription_id='#attributes.subscription_id#' width_info='135' fieldid='subscription_id' fieldname='subscription_no' form_name='form_basket' img_info='plus_thin'>
									<cfelse>
										<cf_wrk_subscriptions width_info='135' subscription_id='#attributes.subscription_id#' fieldid='subscription_id' fieldname='subscription_no' form_name='form_basket' img_info='plus_thin'>
									</cfif>
								</div>                
							</div>
							</cfif>  
						</div>
						<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="2" id="column-2" sort="true">
							<div class="form-group" id="item-ship_number">
								<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58138.Irsaliye No'></label>
								<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
										<cfif isdefined("paper_full")><cfset txt_paper=paper_full><cfelse><cfset txt_paper=""></cfif>		
										<cfif isdefined("attributes.service_ids") and len(attributes.service_ids) >
												<cfset txt_paper = get_service.service_no>
										</cfif>
									<cfsavecontent variable="message"><cf_get_lang dictionary_id='45295.irsaliye no girmelisiniz'></cfsavecontent>
									<cfinput type="text" name="ship_number"  required="Yes" maxlength="50" message="#message#" value="#txt_paper#" onBlur="paper_control(this,'SHIP');">
								</div>                
							</div>
							<div class="form-group" style="display:none;" id="td_ship_text_">
								<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57773.İrsaliye'></label>
								<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
									<div class="input-group" id="td_ship_id_">
										<input type="hidden" name="irsaliye_id_listesi" value="">
										<input type="text" name="irsaliye" value="" readonly>
										<cfoutput><span class="input-group-addon icon-ellipsis btnPointer" onclick="add_irsaliye();"></span></cfoutput>
									</div>
								</div>                
							</div>
							<div class="form-group" id="item-ship_date">
								<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57742.tarih'></label>
								<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
									<div class="input-group">
										<input type="hidden" name="search_process_date" id="search_process_date" value="ship_date">
										<cfsavecontent variable="message"><cf_get_lang dictionary_id='58503.Lutfen Tarih Giriniz'></cfsavecontent>
										<cfif isdefined("attributes.ship_date")>
											<cfinput name="ship_date" type="text" value="#attributes.ship_date#" required="Yes" message="#message#" validate="#validate_style#"  readonly onChange="change_date();">	
										<cfelse>
											<cfinput name="ship_date" type="text" value="#dateformat(now(),dateformat_style)#" required="Yes" message="#message#" validate="#validate_style#"  onChange="change_date();" onblur="change_money_info('form_basket','ship_date');">
										</cfif>
										<span class="input-group-addon"><cf_wrk_date_image date_field="ship_date" call_function="add_general_prom&change_money_info&change_date"></span>            
									</div>
								</div>                
							</div>
							<div class="form-group" id="item-deliver_date_frm">
								<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='45304.fiili sevk tarih'></label>
								<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
									<div class="input-group">
										<cfif isdefined('attributes.deliver_date') and len(attributes.deliver_date)>
											<cfinput type="text" validate="#validate_style#" name="deliver_date_frm"  value="#attributes.deliver_date#">
										<cfelse>
											<cfinput type="text" validate="#validate_style#" name="deliver_date_frm"  value="#dateformat(now(),dateformat_style)#">
										</cfif>
										<span class="input-group-addon"><cf_wrk_date_image date_field="deliver_date_frm"></span>&nbsp;
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
								<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58784.Ref No'></label>
								<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
									<input type="text" name="ref_no" id="ref_no" maxlength="600"  value="<cfif isdefined('attributes.ref_no') and len(attributes.ref_no)><cfoutput>#attributes.ref_no#</cfoutput></cfif>">
								</div>                
							</div>
							<cfif session.ep.our_company_info.project_followup eq 1>
								<div class="form-group" id="item-project_head">
									<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57416.Proje'></label>
									<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
										<div class="input-group">
											<cfoutput>
												<input type="hidden" name="project_id" id="project_id" value="<cfif isdefined('attributes.project_id')>#attributes.project_id#</cfif>"> 
												<input type="text" name="project_head" id="project_head" value="<cfif isdefined('attributes.project_id') and  len(attributes.project_id)>#GET_PROJECT_NAME(attributes.project_id)#</cfif>" onfocus="AutoComplete_Create('project_head','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','','3','200');" autocomplete="off">
												<span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_projects&project_id=form_basket.project_id&project_head=form_basket.project_head');"></span>            
												<span class="input-group-addon btnPointer" onclick="if(document.getElementById('project_id').value!='')windowopen('#request.self#?fuseaction=project.popup_list_project_actions&from_paper=SHIP&id='+document.getElementById('project_id').value+'','wwide');else alert('<cf_get_lang dictionary_id="58797.Proje Seçiniz">');">?</span> 
											</cfoutput>
										</div>
									</div>                
								</div>
							</cfif>							
							<div class="form-group" id="item-service_app_no">
								<cfif isDefined("attributes.service_app_id") and Len(attributes.service_app_id)>
									<cfquery name="get_service" datasource="#dsn3#">
										SELECT SERVICE_NO FROM SERVICE WHERE SERVICE_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#attributes.service_app_id#">)
									</cfquery>
								</cfif>
								<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cfoutput>#getLang("stock",168)#</cfoutput></label>
								<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
									<div class="input-group">
										<cfoutput>
											<input type="hidden" name="service_app_id" id="service_app_id" value="<cfif isDefined("attributes.service_app_id") and Len(attributes.service_app_id)>#attributes.service_app_id#</cfif>">
											<input type="text" name="service_app_no" id="service_app_no" value="<cfif isDefined("attributes.service_app_id") and Len(attributes.service_app_id) and get_service.recordcount>#get_service.service_no#</cfif>" autocomplete="off">   
											<span class="input-group-addon icon-ellipsis btnPointer" onclick="windowopen('#request.self#?fuseaction=objects.popup_list_service&field_id=form_basket.service_app_id&field_no=form_basket.service_app_no&company_id='+document.getElementById('company_id').value +'<cfif session.ep.our_company_info.subscription_contract eq 1>&subscription_id='+ document.getElementById('subscription_id').value +'</cfif>','list');"></span> 
										</cfoutput>
									</div>
								</div>                
							</div>							                    
						</div>
						<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="3" id="column-3" sort="true">
							<div class="form-group" id="item-txt_departman_">
								<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58763.Depo'></label>
								<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
									<cfif isdefined("attributes.location_id") and isdefined("attributes.branch_id")>
										<cf_wrkdepartmentlocation 
											returninputvalue="location_id,txt_departman_,department_id,branch_id"
											returnqueryvalue="LOCATION_ID,LOCATION_NAME,DEPARTMENT_ID,BRANCH_ID"
											fieldname="txt_departman_"
											fieldid="location_id"
											department_fldid="department_id"
											branch_fldid="branch_id"
											branch_id="#attributes.branch_id#"
											location_id="#attributes.location_id#"
											department_id="#attributes.department_id#"
											xml_all_depo = "#xml_all_depo#"
											location_name="#attributes.txt_departman_#"
											user_level_control="#session.ep.OUR_COMPANY_INFO.IS_LOCATION_FOLLOW#"
											width="135">
									<cfelse>
									<cf_wrkdepartmentlocation 
											returninputvalue="location_id,txt_departman_,department_id,branch_id"
											returnqueryvalue="LOCATION_ID,LOCATION_NAME,DEPARTMENT_ID,BRANCH_ID"
											fieldname="txt_departman_"
											fieldid="location_id"
											department_fldid="department_id"
											branch_fldid="branch_id"
											xml_all_depo = "#xml_all_depo#"
											user_level_control="#session.ep.OUR_COMPANY_INFO.IS_LOCATION_FOLLOW#"
											width="135">
									</cfif>              
								</div>                
							</div>
							<div class="form-group" id="item-adres">
								<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='45302.sevk adresi'></label>
								<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
									<div class="input-group">
										<cfoutput>
										<cfsavecontent variable="message"><cf_get_lang dictionary_id='45291.sevk adresi girmelisiniz'>!</cfsavecontent>
										<input type="hidden" name="city_id" id="city_id" value="<cfif isdefined('attributes.city_id') and len(attributes.city_id)>#attributes.city_id#</cfif>">
										<input type="hidden" name="county_id" id="county_id" value="<cfif isdefined('attributes.county_id') and len(attributes.county_id)>#attributes.county_id#</cfif>">
										<input type="hidden" name="country_id" id="country_id" value="<cfif isdefined('attributes.country_id') and len(attributes.country_id)>#attributes.country_id#</cfif>">
										<input type="hidden" name="deliver_comp_id" id="deliver_comp_id" value="<cfif isdefined('attributes.deliver_comp_id') and len(attributes.deliver_comp_id)>#attributes.deliver_comp_id#</cfif>">
										<input type="hidden" name="deliver_cons_id" id="deliver_cons_id" value="<cfif isDefined("attributes.deliver_cons_id") and len(attributes.deliver_cons_id)>#attributes.deliver_cons_id#</cfif>">
										<input type="hidden" name="ship_address_id" id="ship_address_id" value="<cfif isDefined("attributes.ship_address_id") and len(attributes.ship_address_id)>#attributes.ship_address_id#</cfif>">
										<cfif isdefined("attributes.adres")>
											<cfif not x_change_deliver_address>
												<cfinput type="text" name="adres" id="adres" required="yes" message="#message#" value="#trim(attributes.adres)#" maxlength="200" readonly="yes">
											<cfelse>
												<cfinput type="text" name="adres" id="adres" required="yes" message="#message#" value="#trim(attributes.adres)#" maxlength="200">
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
								<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='29500.sevk metod'></label>
								<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
									<div class="input-group">
										<input type="hidden" name="ship_method" id="ship_method" value="<cfif isdefined('attributes.ship_method_id') and len(attributes.ship_method_id)><cfoutput>#attributes.ship_method_id#</cfoutput></cfif>">
										<cfif isdefined('attributes.ship_method_id') and len(attributes.ship_method_id)>
											<cfinclude template="../query/get_ship_method.cfm">
											<cfset attributes.ship_method_name = get_ship_method.ship_method>
										</cfif>
										<input type="text" name="ship_method_name" id="ship_method_name" value="<cfif isdefined('attributes.ship_method_name') and len(attributes.ship_method_name)><cfoutput>#attributes.ship_method_name#</cfoutput></cfif>" onfocus="AutoComplete_Create('ship_method_name','SHIP_METHOD','SHIP_METHOD','get_ship_method','','SHIP_METHOD_ID','ship_method','','3','135');" autocomplete="off">
										<span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_ship_methods&field_name=ship_method_name&field_id=ship_method','list');"></span>            
									</div>
								</div>                
							</div>
							<div class="form-group" id="item-payment_method">
								<cfoutput>
									<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58516.Ödeme Yöntemi'></label><!----Ödeme yöntemi ve vade tarihi sonradan eklendi.. ERU ------->
									<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
										<div class="input-group">
											<input type="hidden" name="card_paymethod_id" id="card_paymethod_id" value="#attributes.card_paymethod_id#">
											<input type="hidden" name="commission_rate" id="commission_rate" value="#attributes.commission_rate#">
											<input type="hidden" name="commethod_id" id="commethod_id" value="#attributes.commethod_id#">
											<input type="hidden" name="paymethod_id" id="paymethod_id" value="#attributes.paymethod_id#">
											<input type="text" name="paymethod_name" id="paymethod_name"  value="#attributes.paymethod_name#" readonly>
											<span class="input-group-addon btnPointer icon-ellipsis" title="<cf_get_lang dictionary_id='57734.seçiniz'>" onclick="windowopen('#request.self#?fuseaction=objects.popup_paymethods&function_name=change_paper_duedate&field_dueday=form_basket.basket_due_value&field_id=form_basket.paymethod_id&field_name=form_basket.paymethod_name','list');"></span>
										</div>
									</div>
								</cfoutput>
							</div>
							<div class="form-group" id="item-basket_due_value">
								<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57640.Vade'></label>
									<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
										<input type="text" name="basket_due_value" id="basket_due_value"  onchange="change_paper_duedate('ship_date');"  
										value="<cfif isdefined('attributes.due_date') and len(attributes.due_date) and isdefined('attributes.ship_date') and len(attributes.ship_date) and not  isdefined("attributes.is_ship_copy")><cfoutput>#datediff('d',dateformat(attributes.due_date,dateformat_style),attributes.ship_date)#</cfoutput><cfelseif isdefined("attributes.is_ship_copy") and len(attributes.due_date_diff)><cfoutput>#attributes.due_date_diff#</cfoutput></cfif>">
									</div>
								<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
									<div class="input-group">										
										<input type="text" name="basket_due_value_date_" id="basket_due_value_date_" onChange="change_paper_duedate('ship_date',1);" value="<cfif isDefined('attributes.due_date') and len(attributes.due_date)><cfoutput>#dateformat(attributes.due_date,dateformat_style)#</cfoutput></cfif>" validate="#dateformat_style#" message="<cfoutput>#message#</cfoutput>" maxlength="10" readonly>
										<span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="basket_due_value_date_"></span>
									</div>
								</div>
							</div>
							<div class="form-group" id="item-detail">
								<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57629.Acıklama'></label>
								<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
									<textarea name="detail" id="detail"><cfif isdefined('attributes.order_detail') and len(attributes.order_detail)><cfoutput>#attributes.order_detail#</cfoutput></cfif></textarea>               
								</div>                
							</div>
							<div class="form-group" id="item-add_info">
								<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57810.Ek Bilgi'></label>
								<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
									<cf_wrk_add_info info_type_id="-31" upd_page = "0" colspan="9">
								</div>
							</div>
						</div>
					</cf_box_elements>
					<cf_box_footer>
						<cf_workcube_buttons is_upd='0' add_function='kontrol_firma()'>
					</cf_box_footer>
				</cf_basket_form>					 
				<cfif isdefined('attributes.service_ids') and len(attributes.service_ids)> <!--- servis modulunden cagırılıyorsa --->
					<cfset attributes.basket_id = 48> 
				<cfelseif isdefined('attributes.order_id') and len(attributes.order_id)><!--- stock - emirlerden cagırılıyorsa --->
					<cfset attributes.basket_id = 14>
				<cfelseif session.ep.isBranchAuthorization><!--- subeden cagırılıyorsa sube basket sablonunu kullansın--->
					<cfset attributes.basket_id = 21> 
				<cfelseif isdefined('attributes.is_from_report') and len(attributes.is_from_report)>	<!--- isbak için yapılan özel raporda kullanılıyor. --->
					<cfset attributes.basket_id = 10>
				<cfelse>
					<cfset attributes.basket_id = 10>
				</cfif>
				<cfif not isdefined('attributes.is_ship_copy') and not isdefined('attributes.service_ids') and not isdefined('attributes.order_id') and not isdefined('attributes.is_from_report')> <!--- irsaliye kopyalamadan gelmiyorsa --->
					<cfif not isdefined("attributes.file_format")>
						<cfset attributes.form_add = 1>
					<cfelse>
						<cfset attributes.basket_sub_id = 21>
					</cfif> 
				</cfif>
				<cfinclude template="../../objects/display/basket.cfm">
			</cfform>
		</div>
	</cf_box>
</div>
<script type="text/javascript">
function add_order()
{	
	if((form_basket.company_id.value.length!="" && form_basket.company_id.value!="") || (form_basket.consumer_id.value.length!="" && form_basket.consumer_id.value!="") || (form_basket.employee_id.value.length!="" && form_basket.employee_id.value!=""))
	{	
		str_irslink = '&order_id_liste=' + form_basket.order_id_listesi.value + '&is_purchase=0&company_id='+form_basket.company_id.value + '&consumer_id='+form_basket.consumer_id.value<cfif session.ep.isBranchAuthorization>+'&is_sale_store='+1</cfif>; 
		<cfif session.ep.our_company_info.project_followup eq 1>
			if(form_basket.project_id.value!='' && form_basket.project_head.value!='')
				str_irslink = str_irslink+'&project_id='+form_basket.project_id.value;
		</cfif>
		str_irslink = str_irslink + '&order_system_id_list=form_basket.order_system_id_list';
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_orders_for_ship' + str_irslink , 'list_horizantal');
		return true;
	}
	else (form_basket.company_id.value =="")
	{
		alert("<cf_get_lang dictionary_id='45308.Cari Hesap Seçmelisiniz'> !");
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
				alert("<cf_get_lang dictionary_id='45500.İşlem Tipi Seçmelisiniz'> !");
				return false;
			}
		</cfif>
		str_irslink = str_irslink+'&process_cat='+form_basket.process_cat.value;
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_choice_ship&from_ship=1' + str_irslink,'page');
		return true;
	}
	else
	{
		alert("<cf_get_lang dictionary_id='45308.Cari Hesap Seçmelisiniz'> !");
		return false;
	}
}
function open_phl() {	
		openBoxDraggable('<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#</cfoutput>.add_ship_from_file&from_where=3');
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

	if(!paper_control(form_basket.ship_number,'SHIP')) return false;
	if(!chk_period(form_basket.ship_date,"İşlem")) return false;
	if(!chk_process_cat('form_basket')) return false;
	<!--- FB 20080125 donem kontrolu eklendi alan zorunlulugu olmadigindan bu sekilde ekledim --->
	
	<cfif session.ep.our_company_info.subscription_contract eq 1>
		<cfif xml_control_order_system eq 1>
		if(document.form_basket.order_system_id_list.value != '' && document.form_basket.subscription_id.value == '')
			{
			alert('<cf_get_lang dictionary_id="50995.Abone Seçiniz"> !');
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
						alert('<cf_get_lang dictionary_id="45272.İlgili İrsaliyeye Bağlı Siparişlerin Sistemleri İle İrsaliyede Seçilen Sistem Aynı Olmalıdır">!');
						return false;
						}
				}
			}
		</cfif>
	</cfif>
	<cfif isDefined("xml_show_process_stage") and len(xml_show_process_stage) and xml_show_process_stage eq 1>
			if(document.form_basket.process_stage.value == "")
			{
				alert("<cf_get_lang dictionary_id ='41036.Lütfen Süreçlerinizi Tanimlayiniz veya Tanimlanan Süreçler Üzerinde Yetkiniz Yok'>!");
				return false;
			}
		</cfif>	
	if(form_basket.deliver_date_frm.value.length)
	{
		if (!global_date_check_value("01/01/<cfoutput>#SESSION.EP.PERIOD_YEAR#</cfoutput>",form_basket.deliver_date_frm.value, 'Lütfen Geçerli Bir Tarih Giriniz!'))
		return false;
	}
	if(form_basket.partner_id.value =="" && form_basket.consumer_id.value =="" && form_basket.employee_id.value =="")
	{
		alert("<cf_get_lang dictionary_id='45308.Cari Hesap Seçmelisiniz'> !");
		return false;
	}
	if(document.form_basket.txt_departman_.value=="" || document.form_basket.department_id.value=="")
	{
		alert("<cf_get_lang dictionary_id='45684.Depo Seçmelisiniz'>!");
		return false;
	}
//		if(document.getElementById("service_app_id").value == "" || document.getElementById("service_app_no").value == "")
//		{
//			alert("Girilmesi Zorunlu Alan: Servis Başvurusu !");
//			return false;
//		}
	if (!check_display_files('form_basket')) return false;
	if(check_stock_action('form_basket'))
	{
		var basket_zero_stock_status = wrk_safe_query('stk_basket_zero_stock_status','dsn3',0,<cfoutput>#attributes.basket_id#</cfoutput>);
		if(basket_zero_stock_status.IS_SELECTED != 1)
		{
			var temp_process_cat = document.form_basket.process_cat.options[document.form_basket.process_cat.selectedIndex].value;
			var temp_process_type = eval("document.form_basket.ct_process_type_" + temp_process_cat);
			if(!zero_stock_control(form_basket.department_id.value,form_basket.location_id.value,0,temp_process_type.value)) return false;
		}
	}
	if(check_inventory('form_basket'))//demirbaş kontrolleri
	{
		var control_inv_type = wrk_safe_query('stk_kontrol_inv_type','dsn3');
		if(control_inv_type.recordcount == 0)
		{
			alert("<cf_get_lang dictionary_id='45274.Demirbaş Stok Fişi İşlem Kategorisi Tanımlayınız'> !");
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
			alert("<cf_get_lang dictionary_id='45275.Aşağıda Belirtilen Ürünler İçin Sabit Kıymet Tanımlarını Kontrol Ediniz'>! \n\n" + inv_product_list);
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
	
	<!---Satır bazında seri girilmesi zorunluluğu kontrolü --->
	<cfif isdefined("xml_serialno_control") and (xml_serialno_control eq 1)>
			prod_name_list = '';
			if( window.basketManager !== undefined ){ 
				for(var str=0; str < basketManagerObject.basketItems().length; str++){
					if( basketManagerObject.basketItems()[str].product_id() != '' )	{
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
			}
			else{
				for(var str=0; str < window.basket.items.length; str++){
					if(window.basket.items[str].PRODUCT_ID != '')	{
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
			if(prod_name_list!='')
			{
				alert(prod_name_list +" Adlı Ürünler İçin Seri Numarası Girmelisiniz!");
				return false;
			}
			</cfif>
		<!---Satır bazında seri girilmesi zorunluluğu kontrolü --->
		<cfif isdefined("xml_upd_row_project") and xml_upd_row_project eq 1>
			project_field_name = 'project_head';
			project_field_id = 'project_id';
			apply_deliver_date('',project_field_name,project_field_id);
		</cfif>
		<cfif isdefined("xml_show_process_stage") and len(xml_show_process_stage) and xml_show_process_stage eq 1>
			return (process_cat_control() && saveForm());
		<cfelse>
			return (saveForm());
		</cfif>
	return false;
}
<cfif not isdefined("attributes.process_cat")>
function toptan_satis_sec()
{
	if(form_basket.process_cat.options.length != undefined && form_basket.process_cat.options.value == '')
	{
		max_sel = form_basket.process_cat.options.length;
		for(my_i=0;my_i<max_sel;my_i++)
		{
			deger = form_basket.process_cat.options[my_i].value;
			if(deger!="")
			{
				var fis_no = eval("form_basket.ct_process_type_" + deger );
				if(fis_no.value == <cfif listgetat(attributes.fuseaction,1,'.') is 'service'>141<cfelse>71</cfif>)
				{
					form_basket.process_cat.options[my_i].selected = true;
					my_i = max_sel + 1;
				}
			}
		}
	}
}
toptan_satis_sec();
</cfif>

function check_process_is_sale()
{ 
	/*alım iadeleri satis karakterli oldugu halde alış fiyatları ile çalışması için*/
	if(document.form_basket.process_cat.options[document.form_basket.process_cat.selectedIndex].value!='')
	{
		var selected_ptype = document.form_basket.process_cat.options[document.form_basket.process_cat.selectedIndex].value;
		eval('var proc_control = document.form_basket.ct_process_type_'+selected_ptype+'.value');
		<cfif get_basket.basket_id is 10>
			if(proc_control==78)
				sale_product= 0;
			else
				sale_product = 1;
		</cfif>
		//if(list_find('72,79',proc_control))
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
		alert("<cf_get_lang dictionary_id='45308.Cari Hesap Seçmelisiniz'>!");
		return false;
	}
}
function change_date()
{
	document.form_basket.deliver_date_frm.value = document.form_basket.ship_date.value;
}
function find_ship_f()
	{
		if($("#find_ship_number").val().length)
		{
			<cfif IsDefined("attributes.ship_id")>
				var Get_Ship_Purchase_Sales = wrk_query('SELECT PURCHASE_SALES FROM SHIP WHERE SHIP_ID = <cfoutput>#attributes.ship_id#</cfoutput>','dsn2');		
				if(Get_Ship_Purchase_Sales.PURCHASE_SALES == 1)
					var listPurchaseSales = 1;
				else
					var listPurchaseSales = 0;
			</cfif>		
			<cfif session.ep.isBranchAuthorization>
				var new_sql = "stk_get_ship";
			<cfelse>
				var new_sql = "stk_get_ship_2";
			</cfif>

			var get_ship = wrk_safe_query(new_sql,'dsn2',0,$("#listParam").val());
		
			if(get_ship.recordcount)
			{
				if(get_ship.PURCHASE_SALES[0] == 1)<!--- satis --->
					if(get_ship.SHIP_TYPE[0] == 81)<!--- sevk irsaliyesi ise --->
						window.location.href = '<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.upd_ship_dispatch&ship_id=</cfoutput>'+get_ship.SHIP_ID[0];
					else if(get_ship.SHIP_TYPE[0] == 811)<!--- ithal mal girisi ise --->
						window.location.href = '<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.upd_stock_in_from_customs&ship_id=</cfoutput>'+get_ship.SHIP_ID[0];
					else
						window.location.href = '<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_upd_sale&ship_id=</cfoutput>'+get_ship.SHIP_ID[0];
				else<!--- alis --->
					window.location.href = '<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_upd_purchase&ship_id=</cfoutput>'+get_ship.SHIP_ID[0];
			}
			else 
			{
				alert("<cf_get_lang dictionary_id='58486.Kayıt Bulunamadı'>");
				return false;
			}
		}
		else 
			{ 
				alert("<cf_get_lang dictionary_id='58643.İrsaliye Nosu Eksik'>");
				return false;
			}
	}
<cfif isdefined('attributes.is_ship_copy') and len(attributes.is_ship_copy)>
	change_paper_duedate('ship_date');
</cfif>
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
