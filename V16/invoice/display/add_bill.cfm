<cf_get_lang_set module_name="invoice"><!--- sayfanin en altinda kapanisi var --->
<cf_xml_page_edit fuseact="invoice.form_add_bill">
<cfset kontrol_status = 1>
<cfinclude template="../query/get_session_cash_all.cfm">
<cfinclude template="../query/control_bill_no.cfm">
<cfparam name="attributes.member_account_code" default="">
<cfparam name="attributes.invoice_counter_number" default="">
<cfparam name="attributes.subscription_id" default="">
<cfparam name="attributes.list_payment_row_id" default="">
<cfparam name="attributes.company_id" default="">	
<cfparam name="attributes.comp_name" default="">
<cfparam name="attributes.payment_company_id" default="">	
<cfparam name="attributes.payment_comp_name" default="">
<cfparam name="attributes.consumer_id" default="">
<cfparam name="attributes.partner_id" default="">
<cfparam name="attributes.partner_name" default="">
<cfparam name="attributes.employee_id" default="">
<cfparam name="attributes.consumer_reference_code" default="">
<cfparam name="attributes.partner_reference_code" default="">
<cfparam name="attributes.ref_no" default="">
<cfparam name="attributes.city_id" default="">
<cfparam name="attributes.county_id" default="">
<cfparam name="attributes.department_name" default="">
<cfparam name="attributes.process_cat" default="">
<cfparam name="attributes.note" default="">
<cfparam name="attributes.ship_id" default="">
<cfparam name="attributes.address" default="">
<cfparam name="attributes.project_id" default="">
<cfparam name="attributes.card_paymethod_id" default="">
<cfparam name="attributes.paymethod_id" default="">
<cfparam name="attributes.ship_method_name" default="">
<cfparam name="attributes.ship_method" default="">
<cfparam name="attributes.sales_member_type" default="">
<cfparam name="attributes.sales_member" default="">
<cfparam name="attributes.sales_member_id" default="">
<cfparam name="attributes.empo_id" default="">
<cfparam name="attributes.partner_nameo" default="">
<cfset basket_due_value_date_ = now()>
<!--- üye bilgileri sayfasından gelince kullanılıyor --->
<cfset paper_type = 'invoice'>
<cfif isdefined('attributes.subscription_id') and len(attributes.subscription_id)>
	<cfquery name="GET_SUBSCRIPTION" datasource="#DSN3#">
		SELECT SUBSCRIPTION_INVOICE_DETAIL, PROJECT_ID, SUBSCRIPTION_TYPE_ID, PAYMENT_TYPE_ID FROM SUBSCRIPTION_CONTRACT WHERE SUBSCRIPTION_ID = #attributes.subscription_id#
	</cfquery>
	<cfif isdefined("attributes.note") and not len(attributes.note)>
		<cfset attributes.note = GET_SUBSCRIPTION.SUBSCRIPTION_INVOICE_DETAIL>
	</cfif>
	<cfif GET_SUBSCRIPTION.recordcount and len(GET_SUBSCRIPTION.PROJECT_ID)>
		<cfquery name="get_project_info" datasource="#dsn#">
			SELECT PROJECT_HEAD FROM PRO_PROJECTS WHERE PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_subscription.project_id#">
		</cfquery>
	</cfif>
</cfif>
<cfif isdefined("attributes.event") and attributes.event is 'copy' and isdefined("attributes.iid") and len(attributes.iid)><!---copy dosyası add e taşındı. PY  --->
<cfinclude template="../query/get_sale_det.cfm">
	<cfscript>
		attributes.company_id = get_sale_det.company_id;
		attributes.partner_id = get_sale_det.partner_id;
		attributes.employee_id = get_sale_det.employee_id;
		attributes.consumer_id = get_sale_det.consumer_id;
		attributes.partner_reference_code = get_sale_det.partner_reference_code;
		attributes.consumer_reference_code = get_sale_det.consumer_reference_code;
		attributes.subscription_id = get_sale_det.subscription_id;
		attributes.empo_id = get_sale_det.sale_emp ;
		if(len(get_sale_det.sales_partner_id)){
			attributes.sales_member_id = get_sale_det.sales_partner_id;
			attributes.sales_member_type = 'partner';
			attributes.sales_member = get_par_info(get_sale_det.sales_partner_id,0,-1,0);
		}
		else if(len(get_sale_det.sales_consumer_id)){
			attributes.sales_member_id = get_sale_det.sales_consumer_id;
			attributes.sales_member_type = 'consumer';
			attributes.sales_member = get_cons_info(get_sale_det.sales_consumer_id,0,0);
		}
		attributes.department_id = get_sale_det.department_id;
		attributes.location_id = get_sale_det.department_location;
		attributes.ship_method = get_sale_det.ship_method;
		attributes.note = get_sale_det.note;
		attributes.project_id = get_sale_det.project_id;
		attributes.ref_no = get_sale_det.ref_no;
		attributes.paymethod_id = get_sale_det.pay_method;
		attributes.card_paymethod_id = get_sale_det.card_paymethod_id;
		basket_due_value_date_ = get_sale_det.due_date;
		attributes.city_id = get_sale_det.city_id;
		attributes.county_id = get_sale_det.county_id;
		attributes.adres = get_sale_det.ship_address;
		attributes.deliver_emp = get_sale_det.deliver_emp;
		attributes.process_cat = get_sale_det.process_cat;
	</cfscript>
</cfif>
<cfif isdefined("attributes.order_id") and len(attributes.order_id)>
	<cfscript>
		SQLStr = "SELECT  DATEDIFF(DAY,ORDER_DATE,DUE_DATE) DUE_DAY, * FROM ORDERS WHERE ORDER_ID = #attributes.order_id#";
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
		 get_company_list_action = CreateObject("component","V16.member.cfc.get_company");
                get_company_list_action.dsn = dsn;
                get_company = get_company_list_action.get_company_list_fnc(
					cpid : (len(attributes.company_id) ? attributes.company_id : (len(attributes.empo_id) ? attributes.empo_id : (len(attributes.consumer_id) ? attributes.consumer_id : (len(attributes.employee_id) ? attributes.employee_id : "" ) ) )) );
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
		attributes.ref_no = get_order_info.ref_no;
		attributes.paymethod_id = get_order_info.paymethod;
		attributes.card_paymethod_id = get_order_info.card_paymethod_id;
		basket_due_value_date_ = get_order_info.due_date;
		due_value_ = get_order_info.due_day;
		attributes.city_id = get_order_info.city_id;
		attributes.county_id = get_order_info.county_id;
		attributes.adres = get_order_info.ship_address;
		attributes.ship_address_id = get_order_info.ship_address_id;
	</cfscript>
</cfif>
<cfif isdefined("attributes.ship_id") and len(attributes.ship_id)>
	<cfscript>
		SQLStr = "SELECT ISNULL((SELECT TOP 1 DATEDIFF(DAY,O.ORDER_DATE,O.DUE_DATE) FROM #dsn3_alias#.ORDERS O,#dsn3_alias#.ORDERS_SHIP OS WHERE O.ORDER_ID = OS.ORDER_ID AND OS.PERIOD_ID = #session.ep.period_id# AND OS.SHIP_ID = SHIP.SHIP_ID),DATEDIFF(DAY,SHIP_DATE,DUE_DATE)) DUE_DAY,* FROM SHIP WHERE  SHIP_ID = #attributes.ship_id#";
		get_ship_info = cfquery(SQLString : SQLStr, Datasource : dsn2);
		// irsaliyenin ilişkili siparişi varsa
		if(get_ship_info.recordcount){
			attributes.company_id = get_ship_info.company_id;
			attributes.partner_id = get_ship_info.partner_id;
			attributes.employee_id = get_ship_info.employee_id;
			attributes.consumer_id = get_ship_info.consumer_id;
			attributes.ship_method = get_ship_info.ship_method;
			attributes.project_id = get_ship_info.project_id;
			basket_due_value_date_ = get_ship_info.due_date;
			due_value_ = get_ship_info.due_day;
			attributes.city_id = get_ship_info.city_id;
			attributes.ship_number = get_ship_info.ship_number;
			attributes.ship_date = get_ship_info.ship_date;
			attributes.deliver_emp = get_ship_info.deliver_emp;
			attributes.sale_emp = get_ship_info.sale_emp;
			attributes.deliver_store_id = get_ship_info.deliver_store_id;
			attributes.location = get_ship_info.location;
			attributes.paymethod_id =  get_ship_info.paymethod_id;
			attributes.card_paymethod_id =  get_ship_info.CARD_paymethod_id;
			attributes.address =  get_ship_info.address;
			attributes.ship_address_id =  get_ship_info.ship_address_id;
			attributes.service_id = get_ship_info.service_id;
			attributes.ship_detail =  get_ship_info.ship_detail;
			attributes.ref_no = get_ship_info.ref_no;
		}
	</cfscript>
	<cfif len(attributes.company_id)>
		<cfset attributes.member_account_code = GET_COMPANY_PERIOD(attributes.company_id)>
	<cfelseif len(attributes.consumer_id)>
		<cfset attributes.member_account_code = GET_consumer_PERIOD(attributes.consumer_id)>
	<cfelse>
		<cfset attributes.member_account_code = GET_employee_PERIOD(attributes.employee_id)>
	</cfif>
</cfif>
<cfif isdefined("attributes.service_no") and len(attributes.service_no)>
	<cfquery name="GET_SERVICE" datasource="#DSN3#">
		SELECT
			SUBSCRIPTION_ID
		FROM
			SERVICE
		WHERE
			SERVICE_ID = #attributes.service_id#
	</cfquery> 
	<cfif GET_SERVICE.recordcount>
		<cfset attributes.subscription_id_ = get_service.subscription_id>
	</cfif>
</cfif>
<cfif isdefined('attributes.payment_company_id') and len(attributes.payment_company_id)>
	<cfquery name="get_payment_comp_info" datasource="#dsn#">
		SELECT FULLNAME,USE_EFATURA,EFATURA_DATE FROM COMPANY WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.payment_company_id#">
	</cfquery>	
	<cfset attributes.payment_comp_name = get_payment_comp_info.FULLNAME>
</cfif>
<cfif isdefined('attributes.company_id') and len(attributes.company_id)>
	<cfset attributes.company_id = attributes.company_id>
	<cfquery name="get_comp_info" datasource="#dsn#">
		SELECT FULLNAME,USE_EFATURA,EFATURA_DATE FROM COMPANY WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
	</cfquery>
	<cfset attributes.comp_name = get_comp_info.FULLNAME>
	<cfif session.ep.our_company_info.is_efatura eq 1  and len(get_comp_info.use_efatura) and get_comp_info.use_efatura eq 1 and datediff('d',dateformat(get_comp_info.efatura_date,dateformat_style),dateformat(now(),dateformat_style)) gte 0>
		<cfset paper_type = 'e_invoice'>
	</cfif>
	<cfif len(attributes.partner_id)>
		<cfset attributes.partner_id = attributes.partner_id>
		<cfset attributes.partner_name = get_par_info(attributes.partner_id,0,-1,0)>
	<cfelse>
		<cfquery name="get_manager_partner" datasource="#dsn#">
			SELECT MANAGER_PARTNER_ID FROM COMPANY WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
		</cfquery>
		<cfset attributes.partner_id = get_manager_partner.manager_partner_id>
		<cfset attributes.partner_name = get_par_info(get_manager_partner.manager_partner_id,0,-1,0)>
	</cfif>
	<cfset attributes.member_account_code = GET_COMPANY_PERIOD(attributes.company_id)>
	<cfif isdefined("attributes.service_operation_ids") and len(attributes.service_operation_ids)>
		<cfquery name="get_comp_info" datasource="#dsn#">
			SELECT FULLNAME,COMPANY_ADDRESS,COMPANY_POSTCODE,SEMT,COUNTY,CITY,COUNTRY FROM COMPANY WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
		</cfquery>
		<cfset attributes.comp_name = get_comp_info.FULLNAME>
		<cfset attributes.partner_name = get_par_info(attributes.partner_id,0,-1,0)>
		
		<cfset attributes.city_id = get_comp_info.CITY>
		<cfset attributes.county_id = get_comp_info.COUNTY>
		<cfset attributes.country_id = get_comp_info.COUNTRY>
		<cfscript>
		if(len(attributes.county_id))
		{
			get_comp_county_id = cfquery(SQLString:'SELECT COUNTY_NAME FROM SETUP_COUNTY WHERE COUNTY_ID=#attributes.county_id#',Datasource:dsn);
			attributes.county=get_comp_county_id.COUNTY_NAME;
		}
		else
			attributes.county="";

		if(len(attributes.city_id))
		{
			get_comp_city_id = cfquery(SQLString:'SELECT CITY_NAME FROM SETUP_CITY WHERE CITY_ID=#attributes.city_id#',Datasource:dsn);
			attributes.city=get_comp_city_id.CITY_NAME;
		}
		else
			attributes.city="";

		if(len(attributes.country_id))
		{
			get_comp_country_id =cfquery(SQLString:'SELECT COUNTRY_NAME FROM SETUP_COUNTRY WHERE COUNTRY_ID=#attributes.country_id#',Datasource:dsn);
			attributes.country=get_comp_country_id.COUNTRY_NAME;
		}
		else
			attributes.country="";
		</cfscript>
		<cfset attributes.adres = "#get_comp_info.COMPANY_ADDRESS# #get_comp_info.COMPANY_POSTCODE# #get_comp_info.semt# #attributes.county# #attributes.city# #attributes.country#">	
	</cfif>
<cfelseif isdefined('attributes.consumer_id') and len(attributes.consumer_id)>
	<cfquery name="get_cons_info_" datasource="#dsn#">
		SELECT CONSUMER_NAME+' '+CONSUMER_SURNAME FULLNAME,USE_EFATURA,EFATURA_DATE FROM CONSUMER WHERE CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
	</cfquery>
	<cfif session.ep.our_company_info.is_efatura eq 1 and len(get_cons_info_.use_efatura) and get_cons_info_.use_efatura eq 1 and datediff('d',dateformat(get_cons_info_.efatura_date,dateformat_style),dateformat(now(),dateformat_style)) gte 0>
		<cfset paper_type = 'e_invoice'>
	</cfif>
	<cfset attributes.consumer_id = attributes.consumer_id>
	<cfset attributes.partner_name = get_cons_info_.FULLNAME>
	<cfset attributes.member_account_code = GET_CONSUMER_PERIOD(attributes.consumer_id)>
<cfelseif isdefined('attributes.employee_id') and len(attributes.employee_id)>
	<cfquery name="get_emp_info_" datasource="#dsn#">
		SELECT EMPLOYEE_NAME+' '+EMPLOYEE_SURNAME FULLNAME FROM EMPLOYEES WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">
	</cfquery>
	<cfset attributes.employee_id = attributes.employee_id>
	<cfset attributes.partner_name = get_emp_info_.FULLNAME>
	<cfset attributes.member_account_code = GET_EMPLOYEE_PERIOD(attributes.employee_id)>
<cfelseif isdefined("attributes.project_id") and len(attributes.project_id)>
	<cfquery name="get_project_info" datasource="#dsn#">
		SELECT COMPANY_ID,PARTNER_ID,CONSUMER_ID FROM PRO_PROJECTS WHERE PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
	</cfquery>
	<cfif len(get_project_info.partner_id)>
		<cfset attributes.company_id = get_project_info.company_id>
		<cfset attributes.partner_id = get_project_info.partner_id>
		<cfset attributes.partner_name = get_par_info(get_project_info.partner_id,0,-1,0)>
		<cfset attributes.comp_name =get_par_info(get_project_info.company_id,1,0,0)>
        <cfset attributes.member_account_code = GET_COMPANY_PERIOD(get_project_info.company_id)>
	<cfelseif len(get_project_info.consumer_id)>
		<cfset attributes.consumer_id = get_project_info.consumer_id>
		<cfset attributes.partner_name = get_cons_info(get_project_info.consumer_id,0,0)>
		<cfset attributes.comp_name =get_cons_info(get_project_info.consumer_id,2,0)>
        <cfset attributes.member_account_code = GET_CONSUMER_PERIOD(get_project_info.consumer_id)>
	</cfif>
<cfelseif isdefined("attributes.assetp_id") and len(attributes.assetp_id)>
	<cfquery name="get_assetp_member" datasource="#dsn#" maxrows="1">
		SELECT * FROM RELATION_ASSETP_MEMBER WHERE ASSETP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.assetp_id#">
	</cfquery>
	<cfif get_assetp_member.recordcount>
		<cfset attributes.company_id = get_assetp_member.company_id>
		<cfset attributes.partner_id = get_assetp_member.partner_id>
		<cfquery name="get_comp_info" datasource="#dsn#">
			SELECT FULLNAME,COMPANY_ADDRESS,COMPANY_POSTCODE,SEMT,COUNTY,CITY,COUNTRY FROM COMPANY WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
		</cfquery>
		<cfset attributes.comp_name = get_comp_info.FULLNAME>
		<cfset attributes.partner_name = get_par_info(attributes.partner_id,0,-1,0)>
		
		<cfset attributes.city_id = get_comp_info.CITY>
		<cfset attributes.county_id = get_comp_info.COUNTY>
		<cfset attributes.country_id = get_comp_info.COUNTRY>
		<cfscript>
		if(len(attributes.county_id))
		{
			get_comp_county_id = cfquery(SQLString:'SELECT COUNTY_NAME FROM SETUP_COUNTY WHERE COUNTY_ID=#attributes.county_id#',Datasource:dsn);
			attributes.county=get_comp_county_id.COUNTY_NAME;
		}
		else
			attributes.county="";

		if(len(attributes.city_id))
		{
			get_comp_city_id = cfquery(SQLString:'SELECT CITY_NAME FROM SETUP_CITY WHERE CITY_ID=#attributes.city_id#',Datasource:dsn);
			attributes.city=get_comp_city_id.CITY_NAME;
		}
		else
			attributes.city="";

		if(len(attributes.country_id))
		{
			get_comp_country_id =cfquery(SQLString:'SELECT COUNTRY_NAME FROM SETUP_COUNTRY WHERE COUNTRY_ID=#attributes.country_id#',Datasource:dsn);
			attributes.country=get_comp_country_id.COUNTRY_NAME;
		}
		else
			attributes.country="";
		</cfscript>
		<cfset attributes.adres = "#get_comp_info.COMPANY_ADDRESS# #get_comp_info.COMPANY_POSTCODE# #get_comp_info.semt# #attributes.county# #attributes.city# #attributes.country#">	
		
		<cfif listlen(session.ep.USER_LOCATION,"-") gt 2>
			<cfset attributes.location_id = '#listgetat(session.ep.USER_LOCATION,3,"-")#'>
			<cfquery name="get_loc" datasource="#dsn#">
				SELECT 
					D.DEPARTMENT_HEAD + ' ' + SL.COMMENT AS LOKASYON,
					SL.LOCATION_ID,
					SL.DEPARTMENT_ID,
					D.BRANCH_ID
				FROM 
					STOCKS_LOCATION SL,
					DEPARTMENT D
				WHERE 
					SL.LOCATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.location_id#"> AND
					SL.DEPARTMENT_ID = D.DEPARTMENT_ID
			</cfquery>
			<cfset attributes.branch_id = get_loc.branch_id>
			<cfset attributes.department_id = get_loc.department_id>
			<cfset attributes.location_id = get_loc.location_id>
			<cfset attributes.department_name = get_loc.lokasyon>
		</cfif>
	</cfif>	
</cfif>
<cfif isdefined('attributes.department_ID') and len(attributes.department_ID)>
	<cfset attributes.branch_id = get_location_info(attributes.department_ID,attributes.location_id,1,1)>
	<cfset attributes.department_ID = attributes.department_ID>
	<cfset attributes.location_id = attributes.location_id>
<cfelse>
	<cfset attributes.branch_id = ''>
	<cfset attributes.department_ID = ''>
	<cfset attributes.location_id = ''>
</cfif>
<cfif isdefined("attributes.COMPANY_ID")>
<cfset attributes.comp_id = attributes.COMPANY_ID>
</cfif>
<cfscript>
	if(isDefined("url.ship_id"))//irsaliyeden gelen
		session_basket_kur_ekle(action_id=attributes.ship_id,table_type_id:2,to_table_type_id:1,process_type:1);
	else if(isDefined("url.order_id"))//siparişten gelen
		session_basket_kur_ekle(action_id=attributes.order_id,table_type_id:3,to_table_type_id:1,process_type:1);
	else
		session_basket_kur_ekle(process_type:0);
</cfscript>
<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
<cf_box>
<div id="basket_main_div">
    <cfform name="form_basket" method="post" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_add_bill">
      <cf_basket_form id="add_bill">
      	<input type="hidden" name="form_action_address" id="form_action_address" value="<cfoutput>#listgetat(attributes.fuseaction,1,'.')#.emptypopup_add_bill</cfoutput>">
		<input type="hidden" name="xml_get_branch_from_department" value="<cfoutput>#xml_get_branch_from_department#</cfoutput>">
            <cf_papers paper_type="#paper_type#" form_name="form_basket" form_field="invoice_number">
                <cfoutput>
                    <!--- matris is faturalama icin duzenlendi --->
                    <cfif isdefined("attributes.CONVERT_PRODUCTS_ID") and len(attributes.CONVERT_PRODUCTS_ID) and isDefined("attributes.list_no") and Len(attributes.list_no)>
                        <cfset currtrow_ = 1>
                        <cfloop list="#attributes.list_no#" index="x">
                            <input type="hidden" name="related_action_id#currtrow_#" id="related_action_id#currtrow_#" value="#evaluate('attributes.related_action_id#x#')#">
                            <input type="hidden" name="related_action_table#currtrow_#" id="related_action_table#currtrow_#" value="#evaluate('attributes.related_action_table#x#')#">
                            <cfset currtrow_ = currtrow_ + 1>
                        </cfloop>
                    </cfif>
                    <!--- matris is faturalama icin duzenlendi --->
                    <input type="hidden" name="paper" id="paper" value="<cfif isDefined('paper_number')>#paper_number#</cfif>">
                    <input type="hidden" name="paper_printer_id" id="paper_printer_id" value="<cfif isDefined('paper_printer_code')>#paper_printer_code#</cfif>">
                    <input type="hidden" name="xml_calc_due_date" id="xml_calc_due_date" value="#xml_calc_due_date#"><!--- Bazı metal firmalarında vade tarihi siparişten hesaplanıyordu , kocaerde sorun olunca xml e bağlandı action da kullanılıyor --->
                    <input type="hidden" name="xml_kontrol_due_date" id="xml_kontrol_due_date" value="#xml_kontrol_due_date#">
                    <input type="hidden" name="active_period" id="active_period" value="#session.ep.period_id#">
                    <input type="hidden" name="search_process_date" id="search_process_date" value="invoice_date">
                    <cfif isdefined("attributes.bill_save")>
                        <input type="hidden" name="bill_save" id="bill_save" value="#attributes.bill_save#">
                    </cfif>
                    <cfif isdefined("attributes.exp_rows_id")>
                        <input type="hidden" name="exp_rows_id" id="exp_rows_id" value="#attributes.exp_rows_id#">
                    </cfif>
                    <input type="hidden" name="member_account_code" id="member_account_code" value="#attributes.member_account_code#">
                    <!--- Sistem odeme planı icin eklendi --->
                    <input type="hidden" name="list_payment_row_id" id="list_payment_row_id" value="#attributes.list_payment_row_id#">
                    <!--- Sistem sayac icin eklendi --->
                    <input type="hidden" name="invoice_counter_number" id="invoice_counter_number" value="#attributes.invoice_counter_number#">
                    <input type="hidden" name="commethod_id" id="commethod_id" value="">
					<cfif isdefined("attributes.order_id") and len(attributes.order_id)>
						<input type="hidden" name="order_id" id="order_id" value="#attributes.order_id#">
					</cfif>
                    <input type="hidden" name="assetp_service_operation_id" id="assetp_service_operation_id" value="<cfif isdefined("attributes.service_operation_id")>#attributes.service_operation_id#</cfif>">
                    <input type="hidden" name="service_operation_ids" id="service_operation_ids" value="<cfif isdefined("attributes.service_operation_ids")>#attributes.service_operation_ids#</cfif>">
				</cfoutput>
				<cf_box_elements>
					<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
						<cfif isdefined("xml_show_process_stage") and len(xml_show_process_stage) and xml_show_process_stage eq 1>
							<div class="form-group require" id="item-process_stage">
								<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id="58859.Süreç"></label>
								<div class="col col-8 col-sm-12">
									<cf_workcube_process is_upd='0' process_cat_width='125' is_detail='0'>
								</div>                
							</div> 
						</cfif>
						<div class="form-group" id="item-process_cat">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57800.işlem tipi'> *</label>
							<div class="col col-8 col-xs-12">
								<cfif isdefined("attributes.process_cat") and len(attributes.process_cat)>
									<cf_workcube_process_cat onclick_function="kontrol_yurtdisi();check_process_is_sale();"  process_cat="#attributes.process_cat#"  slct_width="140">
								<cfelse>
									<cf_workcube_process_cat onclick_function="kontrol_yurtdisi();check_process_is_sale();" slct_width="140">
								</cfif>
								<cfif isdefined("attributes.invoice_id")>
									<input type="hidden" name="bool_from_control_bill" id="bool_from_control_bill" value="<cfoutput>#attributes.invoice_id#</cfoutput>">
								</cfif>
								<input type="hidden" name="invoice_control_id" id="invoice_control_id" value="">
								<input type="hidden" name="contract_row_ids" id="contract_row_ids" value="">
							</div>
						</div>
						<div class="form-group" id="item-comp_name">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57519.cari hesap'> *</label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<input type="hidden" name="company_id" id="company_id" value="<cfoutput>#attributes.company_id#</cfoutput>">
									<input type="text" name="comp_name" id="comp_name" readonly value="<cfoutput>#attributes.comp_name#</cfoutput>" style="width:140px;">
									<cfset str_linkeait = "&field_paymethod_id=form_basket.paymethod_id&field_paymethod=form_basket.paymethod&field_revmethod_id=form_basket.paymethod_id&field_revmethod=form_basket.paymethod&field_commission_rate=form_basket.commission_rate&field_basket_due_value_rev=form_basket.basket_due_value&field_card_payment_id=form_basket.card_paymethod_id">
									<span class="input-group-addon btnPointer icon-ellipsis" title="<cf_get_lang dictionary_id='57734.seçiniz'>" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_pars&field_adress_id=form_basket.ship_address_id&is_cari_action=1&is_potansiyel=0&select_list=2,3,1,9&field_name=form_basket.partner_name&field_emp_id=form_basket.employee_id&field_partner=form_basket.partner_id&field_comp_name=form_basket.comp_name&field_comp_id=form_basket.company_id&field_consumer=form_basket.consumer_id&field_member_account_code=form_basket.member_account_code#str_linkeait#&ship_method_id=form_basket.ship_method&ship_method_name=form_basket.ship_method_name&field_long_address=form_basket.adres&field_city_id=form_basket.city_id&field_county_id=form_basket.county_id&field_cons_ref_code=form_basket.consumer_reference_code<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&is_invoice=1</cfoutput>&call_function=add_general_prom()-check_member_price_cat()-change_paper_duedate()');"></span>
								</div>
							</div>
						</div>
						<div class="form-group" id="item-partner_name">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57578.Yetkili'> *</label>
							<div class="col col-8 col-xs-12">
								<input type="hidden" name="partner_reference_code" id="partner_reference_code" value="<cfoutput>#attributes.partner_reference_code#</cfoutput>">
								<input type="hidden" name="partner_id" id="partner_id" value="<cfoutput>#attributes.partner_id#</cfoutput>">
								<input type="hidden" name="consumer_reference_code" id="consumer_reference_code" value="<cfoutput>#attributes.consumer_reference_code#</cfoutput>">
								<input type="hidden" name="consumer_id" id="consumer_id" value="<cfoutput>#attributes.consumer_id#</cfoutput>">
								<input type="hidden" name="employee_id" id="employee_id" value="<cfoutput>#attributes.employee_id#</cfoutput>">
								<input type="text" name="partner_name" id="partner_name" value="<cfoutput>#attributes.partner_name#</cfoutput>" readonly style="width:140px;">
							</div>
						</div>
						<div class="form-group" id="item-payment_comp_name">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='34748.Ödeme Kuruluşu'></label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<input type="hidden" name="payment_company_id" id="payment_company_id" value="<cfoutput>#attributes.payment_company_id#</cfoutput>">
									<input type="text" name="payment_comp_name" id="payment_comp_name" readonly value="<cfoutput>#attributes.payment_comp_name#</cfoutput>" style="width:140px;">
									<span class="input-group-addon btnPointer icon-ellipsis" title="<cf_get_lang dictionary_id='57734.seçiniz'>" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_pars&is_cari_action=1&select_list=2&field_comp_name=form_basket.payment_comp_name&field_comp_id=form_basket.payment_company_id</cfoutput>')"></span>
								</div>
							</div>
						</div>
						<div class="form-group" id="item-irsaliye">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57773.İrsaliye'></label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<input type="hidden" name="irsaliye_project_id_listesi" id="irsaliye_project_id_listesi" value="<cfoutput>#attributes.PROJECT_ID#</cfoutput>">
									<input type="hidden" name="irsaliye_date_listesi" id="irsaliye_date_listesi" value="<cfif isdefined("attributes.ship_date") and len(attributes.ship_date)><cfoutput>#dateformat(attributes.ship_date,dateformat_style)#</cfoutput></cfif>">
									<input type="hidden" name="irsaliye_id_listesi" id="irsaliye_id_listesi" value="<cfoutput>#attributes.ship_id#;#session.ep.period_id#</cfoutput>">
									<input type="text" name="irsaliye" id="irsaliye" style="width:140px;" value="<cfif isdefined("attributes.ship_id") and len(attributes.ship_id)><cfoutput>#attributes.ship_number#</cfoutput></cfif>" readonly>
									<span class="input-group-addon btnPointer icon-ellipsis" onclick="add_irsaliye();"></span>
								</div>
							</div>
						</div>
						<div class="form-group" id="item-deliver_get">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57775.Teslim Alan'></label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<input type="hidden" name="deliver_get_id" id="deliver_get_id"  value="">
									<input type="hidden" name="deliver_get_id_consumer" id="deliver_get_id_consumer" value="">
									<input type="text" name="deliver_get" id="deliver_get" value="<cfif isdefined("attributes.deliver_emp")><cfoutput>#attributes.deliver_emp#</cfoutput></cfif>" style="width:140px;">
									<span class="input-group-addon btnPointer icon-ellipsis" title="<cf_get_lang dictionary_id='57734.seçiniz'>" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_pars&is_rate_select=1&select_list=2,3,4,5,6&field_name=form_basket.deliver_get&field_partner=form_basket.deliver_get_id&field_consumer=form_basket.deliver_get_id_consumer&come=stock</cfoutput>');"></span>
								</div>
							</div>
						</div>
						<cfif session.ep.our_company_info.subscription_contract eq 1>
							<div class="form-group" id="item-subscription_id">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='29502.Abone No'></label>
								<div class="col col-8 col-xs-12">
									<cfif isdefined("attributes.subscription_id") and len(attributes.subscription_id)>
										<cf_wrk_subscriptions width_info='140' subscription_id='#attributes.subscription_id#'  fieldid='subscription_id' fieldname='subscription_no' form_name='form_basket' img_info='plus_thin'>
									<cfelseif isdefined("attributes.subscription_id_")>
										<cf_wrk_subscriptions width_info='140' subscription_id='#attributes.subscription_id_#'  fieldid='subscription_id' fieldname='subscription_no' form_name='form_basket' img_info='plus_thin'>
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
									<input type="hidden" name="order_id_listesi" id="order_id_listesi" value="<cfif isdefined('attributes.order_id') and len(attributes.order_id)><cfoutput>#attributes.order_id#</cfoutput></cfif>">
									<input type="text" name="order_id_form" id="order_id_form" value="<cfif isdefined('attributes.order_number') and len(attributes.order_number)><cfoutput>#attributes.order_number#</cfoutput></cfif>" style="width:140px;" readonly>
									<span class="input-group-addon btnPointer icon-ellipsis" onclick="add_order();"></span>
								</div>
							</div>
						</div>                                    
						<div class="form-group" id="add_info_plus">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57810.Ek Bilgi'></label>
							<div class="col col-8 col-xs-12">
								<cf_wrk_add_info info_type_id="-32" upd_page = "0">
							</div>
						</div>                                    
					</div>
					<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
						<div class="form-group" id="item-serial_number">
							<label class="col col-4  col-md-8 col-xs-8 col-xs-12"><cf_get_lang dictionary_id='57880.Belge no'> *</label>
							<div class="col col-3 col-md-4 col-xs-4 col-xs-12">
								<cfsavecontent variable="message"><cf_get_lang dictionary_id='57184.Fatura No Girmelisiniz!'></cfsavecontent>
								<cfif isDefined('paper_full')>
									<cfinput type="text" maxlength="5" name="serial_number" id="serial_number" value="#paper_code#" style="width:20px;">
								<cfelse>
									<cfinput type="text" maxlength="5" name="serial_number" id="serial_number" value="" style="width:20px;">
								</cfif>
							</div>
							<div class="col col-5 col-md-6 col-xs-6" id="item-invoice_no">
								<cfif isDefined('paper_full') and len(paper_number)>
									<cfsavecontent variable="message"><cf_get_lang dictionary_id='57412.Seri No Girmelisiniz'></cfsavecontent>
									<cfinput type="text" maxlength="50" name="serial_no" id="serial_no" value="#paper_number#" required="Yes" message="#message#" style="margin-bottom:5px;" onBlur="check_invoice_type();">		
								<cfelse>
									<cfsavecontent variable="message"><cf_get_lang dictionary_id='57412.Seri No Girmelisiniz'></cfsavecontent>
									<cfif isdefined('attributes.ship_number') and len(attributes.ship_number)>
										<cfinput type="text" maxlength="50" name="serial_no" id="serial_no" value="#attributes.ship_number#" required="Yes" message="#message#" onBlur="check_invoice_type();">
									<cfelse>
										<cfinput type="text" maxlength="50" name="serial_no" id="serial_no" value="" required="Yes" message="#message#" onBlur="check_invoice_type();">
									</cfif>
								</cfif>
							</div>
						</div>

						<div class="form-group" id="item-invoice_no" >
							
						</div>
						<div class="form-group" id="item-invoice_date">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58759.Fatura Tarihi'> *</label>
							<div class="col col-8 col-xs-12">
								<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
									<div class="input-group">
										<cfsavecontent variable="message"><cf_get_lang dictionary_id='57185.Fatura Tarihi Girmelisiniz !'></cfsavecontent>
										<cfinput type="text" name="invoice_date" style="width:100px;" required="Yes" message="#message#" value="#dateformat(now(),dateformat_style)#" onChange="check_member_price_cat();change_paper_duedate('invoice_date');" validate="#validate_style#" maxlength="10" readonly="yes">
										<span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="invoice_date" call_function="add_general_prom&change_money_info&rate_control"></span>
									</div>
								</div>
									<cfset get_date_bugun = dateformat(now(),dateformat_style)>
									<cfoutput>
										<cfif IsDefined("get_sale_det.PROCESS_TIME") and len(get_sale_det.PROCESS_TIME)>
											<cfset value_invoice_date_h = hour(dateadd('h',session.ep.time_zone,get_sale_det.PROCESS_TIME))>
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
										<cfinput type="text" name="ship_date" id="ship_date" style="width:100px;" value="#dateformat(now(),dateformat_style)#" validate="#validate_style#" maxlength="10">
										<span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="ship_date"></span>
									</div>
								</div>
							</div>
						</cfif>
						<div class="form-group" id="item-realization_date" style="display:none;">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="57167.İntaç Tarihi"></label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<cfinput type="text" name="realization_date" id="realization_date" style="width:100px;" value="" onChange="check_member_price_cat();" onblur="rate_control('2');" validate="#validate_style#" maxlength="10">
									<span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="realization_date" call_function="change_money_info"></span>
								</div>
							</div>
						</div>
						<div class="form-group" id="item-PARTNER_NAMEO">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57321.Satış Çalışanı'></label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<input type="hidden" id="EMPO_ID" name="EMPO_ID" value="<cfif isdefined("attributes.ship_id") and len(attributes.ship_id) and len(attributes.sale_emp)><cfoutput>#attributes.sale_emp#</cfoutput><cfelse><cfoutput>#attributes.empo_id#</cfoutput></cfif>">
									<input type="hidden" id="PARTO_ID" name="PARTO_ID"  value="">
									<input type="text" id="PARTNER_NAMEO" name="PARTNER_NAMEO"  value="<cfif isdefined("attributes.ship_id") and len(attributes.ship_id) and len(attributes.sale_emp)><cfoutput>#get_emp_info(attributes.sale_emp,0,0)#</cfoutput></cfif><cfif len(attributes.empo_id)><cfoutput>#get_emp_info(attributes.empo_id,0,0)#</cfoutput></cfif>" style="width:140px;" onfocus="AutoComplete_Create('PARTNER_NAMEO','POSITION_NAME','POSITION_NAME','get_emp_pos','','POSITION_CODE,EMPLOYEE_ID','PARTO_ID,EMPO_ID','','3','130');">
									<span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&select_list=1&field_name=form_basket.PARTNER_NAMEO&field_id=form_basket.PARTO_ID&field_EMP_id=form_basket.EMPO_ID</cfoutput>');"></span>
								</div>
							</div>
						</div>
						<div class="form-group" id="item-sales_member">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57322.Satış Ortagi'></label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<input type="hidden" id="sales_member_id" name="sales_member_id" value="<cfoutput>#attributes.sales_member_id#</cfoutput>">
									<input type="hidden" id="sales_member_type" name="sales_member_type" value="<cfoutput>#attributes.sales_member_type#</cfoutput>">
									<input type="text" id="sales_member" name="sales_member" value="<cfoutput>#attributes.sales_member#</cfoutput>" style="width:140px;" onfocus="AutoComplete_Create('sales_member','MEMBER_NAME,MEMBER_PARTNER_NAME2','MEMBER_PARTNER_NAME2,MEMBER_NAME','get_member_autocomplete','\'1,2\',0,0','PARTNER_CODE,MEMBER_TYPE','sales_member_id,sales_member_type','form','3','250');">
									<span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&is_rate_select=1&field_id=form_basket.sales_member_id&field_name=form_basket.sales_member&field_type=form_basket.sales_member_type<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&select_list=2,3');"></span>
								</div>
							</div>
						</div>
						<cfif xml_acc_department_info>
							<div class="form-group" id="item-acc_department_id">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57572.Departman'></label>
								<div class="col col-8 col-xs-12">
									<cf_wrkdepartmentbranch fieldid='acc_department_id' is_department='1' width='140' is_deny_control='0'>
								</div>
							</div>
						</cfif>
					</div>
					<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
						<div class="form-group" id="item-department_location">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58763.Depo'> *</label>
							<div class="col col-8 col-xs-12">
								<cfif isdefined("attributes.ship_id") and len(attributes.ship_id)>
									<cfset location_info_ = get_location_info(attributes.deliver_store_id,attributes.location,1,1)>  
									<cf_wrkdepartmentlocation 
										returninputvalue="location_id,txt_departman_,department_id,branch_id"
										returnqueryvalue="LOCATION_ID,LOCATION_NAME,DEPARTMENT_ID,BRANCH_ID"
										fieldname="txt_departman_"
										fieldid="location_id"
										department_fldid="department_id"
										branch_fldid="branch_id"
										branch_id="#listlast(location_info_,',')#"
										department_id="#attributes.deliver_store_id#"
										location_id="#attributes.location#"
										location_name="#listfirst(location_info_,',')#"
										user_level_control="#session.ep.OUR_COMPANY_INFO.IS_LOCATION_FOLLOW#"
										dsp_service_loc="1"
										>
								<cfelseif isdefined("attributes.location_id")>
									<cf_wrkdepartmentlocation
										returninputvalue="location_id,department_name,department_id,branch_id"
										returnqueryvalue="LOCATION_ID,LOCATION_NAME,DEPARTMENT_ID,BRANCH_ID"
										fieldname="department_name"
										fieldid="location_id"
										department_fldid="department_id"
										branch_fldid="branch_id"
										branch_id="#attributes.branch_id#"
										department_id="#attributes.department_id#"
										location_id="#attributes.location_id#"
										location_name="#attributes.department_name#"
										user_level_control="#session.ep.OUR_COMPANY_INFO.IS_LOCATION_FOLLOW#"
										>
								<cfelse>
									<cf_wrkdepartmentlocation
										returninputvalue="location_id,department_name,department_id,branch_id"
										returnqueryvalue="LOCATION_ID,LOCATION_NAME,DEPARTMENT_ID,BRANCH_ID"
										fieldname="department_name"
										fieldid="location_id"
										department_fldid="department_id"
										branch_fldid="branch_id"
										user_level_control="#session.ep.OUR_COMPANY_INFO.IS_LOCATION_FOLLOW#"
										>
								</cfif>
							</div>
						</div>
						<div class="form-group" id="item-ship_method">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='29500.Sevk Yöntemi'></label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<cfif len(attributes.ship_method)>
										<cfset attributes.ship_method_id=attributes.ship_method>
										<cfinclude template="../query/get_ship_methods.cfm">
									</cfif>
									<input type="hidden" name="ship_method" id="ship_method" value="<cfoutput>#attributes.ship_method#</cfoutput>">
									<input type="text" name="ship_method_name" id="ship_method_name" readonly style="width:140px;" value="<cfif len(attributes.ship_method)><cfoutput>#ship_methods.ship_method#</cfoutput></cfif>">
									<span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_ship_methods&field_name=ship_method_name&field_id=ship_method','list');"></span>
								</div>
							</div>
						</div>
						<div class="form-group" id="item-paymethod">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58516.Ödeme Yöntemi'></label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<cfif len(attributes.list_payment_row_id)>
										<cfset paymethod_row_id = ListFirst(attributes.list_payment_row_id)>
										<cfquery name="get_paymethod_id" datasource="#dsn3#">
											SELECT PAYMETHOD_ID FROM SUBSCRIPTION_PAYMENT_PLAN_ROW WHERE SUBSCRIPTION_PAYMENT_ROW_ID = #paymethod_row_id#
										</cfquery>
										<cfif len(get_paymethod_id.paymethod_id)>
											<cfquery name="get_payment_type" datasource="#DSN#">
												SELECT ISNULL(DUE_DAY,0) DUE_DAY,PAYMETHOD FROM SETUP_PAYMETHOD WHERE PAYMETHOD_ID = #get_paymethod_id.paymethod_id#
											</cfquery>
												<cfset basket_due_value_date_ = DateAdd('D',get_payment_type.due_day,now())>
										</cfif>
									</cfif>
									<cfif len(attributes.paymethod_id)>
										<cfinclude template="../query/get_paymethod.cfm">
									<cfelseif len(attributes.card_paymethod_id)>
										<cfquery name="get_card_paymethod" datasource="#dsn3#">
											SELECT 
												CARD_NO
												<cfif isdefined("GET_ORDER_INFO.commethod_id") and GET_ORDER_INFO.commethod_id eq 6> <!--- WW den gelen siparişlerin guncellemesi --->
												,PUBLIC_COMMISSION_MULTIPLIER AS COMMISSION_MULTIPLIER
												<cfelse>  <!--- EP VE PP den gelen siparişlerin guncellemesi --->
												,COMMISSION_MULTIPLIER 
												</cfif>
											FROM 
												CREDITCARD_PAYMENT_TYPE 
											WHERE 
												PAYMENT_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.card_paymethod_id#">
										</cfquery>
									</cfif>
									<cfoutput>
									<input type="hidden" name="card_paymethod_id" id="card_paymethod_id" value="#attributes.card_paymethod_id#">
									<input type="hidden" name="commission_rate" id="commission_rate" value="<cfif isdefined("get_card_paymethod.COMMISSION_MULTIPLIER") and len(get_card_paymethod.COMMISSION_MULTIPLIER)>#get_card_paymethod.COMMISSION_MULTIPLIER#</cfif>">
									<input type="hidden" name="paymethod_id" id="paymethod_id" value="#attributes.paymethod_id#">
									<input type="hidden" name="paymethod_vehicle" id="paymethod_vehicle" value="">
									<input type="text" name="paymethod" id="paymethod" value="<cfif isdefined('get_payment_type.paymethod') and len(get_payment_type.paymethod)>#get_payment_type.paymethod#<cfelseif isdefined("get_paymethod.paymethod") and len(get_paymethod.paymethod)>#get_paymethod.paymethod#<cfelseif isdefined("get_card_paymethod.card_no") and len(get_card_paymethod.card_no)>#get_card_paymethod.card_no#</cfif>" readonly style="width:140px;">
									<cfset card_link="&field_card_payment_id=form_basket.card_paymethod_id&field_card_payment_name=form_basket.paymethod&function_name=change_paper_duedate&function_parameter=invoice_date&field_commission_rate=form_basket.commission_rate&field_paymethod_vehicle=form_basket.paymethod_vehicle">
									<span class="input-group-addon btnPointer icon-ellipsis" title="<cf_get_lang dictionary_id='57734.seçiniz'>" onclick="windowopen('#request.self#?fuseaction=objects.popup_paymethods&field_dueday=form_basket.basket_due_value&field_id=form_basket.paymethod_id&field_name=form_basket.paymethod#card_link#','list');"></span>
									</cfoutput>
								</div>
							</div>
						</div>
						<div class="form-group" id="item-basket_due_value">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57640.Vade'></label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<cfif isdefined('get_payment_type.paymethod') and len(get_payment_type.paymethod)>
										<cfset due_day = get_payment_type.due_day>
									<cfelseif isdefined("get_paymethod.due_day") and len(get_paymethod.due_day)>
										<cfset due_day = get_paymethod.due_day>
									<cfelse>
										<cfset due_day = 0>
									</cfif>
									<cfif (isdefined("due_value_") and len(due_value_) and isdefined("attributes.ship_id")) OR (isdefined("due_value_") and len(due_value_) and isdefined("attributes.ORDER_ID"))>
										<cfset due_day = due_value_>
									<cfelse>
										<cfset due_day = 0>
									</cfif>
									<input type="text" name="basket_due_value" id="basket_due_value" value="<cfoutput>#due_day#</cfoutput>" onchange="change_paper_duedate('invoice_date');" style="width:47px;">
									<span class="input-group-addon no-bg"></span>
										<cfif isdefined("attributes.iid") and len(attributes.iid) or isdefined("attributes.order_id") or isdefined("attributes.ship_id")>
										<cfset basket_due_value_date_ = dateadd('d',due_day,now())>
									</cfif>
									<cfinput type="text" name="basket_due_value_date_" value="#dateformat(basket_due_value_date_,dateformat_style)#" onChange="change_paper_duedate('invoice_date',1);" validate="#validate_style#" message="#message#" maxlength="10" style="width:90px;" readonly>
									<span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="basket_due_value_date_"></span>
								</div>
							</div>
						</div>
						<div class="form-group" id="item-ship_address_id">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='57248.Sevk Adresi'> *</label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<cfsavecontent variable="message"><cf_get_lang dictionary_id ='57343.Sevk Adresi Girmelisiniz'>!</cfsavecontent>
									<input type="hidden" name="city_id" id="city_id" value="<cfoutput>#attributes.city_id#</cfoutput>">
									<input type="hidden" name="county_id" id="county_id" value="<cfoutput>#attributes.county_id#</cfoutput>">
									<input type="hidden" name="ship_address_id" id="ship_address_id" value="<cfif isdefined('attributes.ship_address_id') and len(attributes.ship_address_id)><cfoutput>#attributes.ship_address_id#</cfoutput><cfelse>-1</cfif>">
									<cfif isdefined("attributes.address") and len(attributes.address)>	
										<cfinput type="text" name="adres" required="yes" message="#message#" value="#attributes.address#" maxlength="200" style="width:140px;">
									<cfelseif isdefined("attributes.adres") and len(attributes.adres)>
										<cfinput type="text" name="adres" required="yes" message="#message#" value="#attributes.adres#" maxlength="200" style="width:140px;">
									<cfelse>
										<cfinput type="text" name="adres" required="yes" message="#message#" value="" maxlength="200" style="width:140px;">
									</cfif>
									<span class="input-group-addon btnPointer icon-ellipsis" onclick="add_adress();"></span>
								</div>
							</div>
						</div>
						<cfif session.ep.our_company_info.asset_followup eq 1>
							<div class="form-group" id="item-asset_id">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='58833.Fiziki Varlık'></label>
								<div class="col col-8 col-xs-12">
									<cfif isdefined("attributes.assetp_id") and len(attributes.assetp_id)>
										<cf_wrkassetp fieldid='asset_id' fieldname='asset_name' width='140' form_name='form_basket' asset_id='#attributes.assetp_id#' button_type="plus_thin">
									<cfelse>
										<cf_wrkassetp fieldid='asset_id' fieldname='asset_name' width='140' form_name='form_basket' button_type="plus_thin">
									</cfif>
								</div>
							</div>
						</cfif>
						<div class="form-group" id="item-service_no">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57656.Servis'></label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<input type="hidden" name="service_id" id="service_id"  value="<cfif isdefined("attributes.service_id")><cfoutput>#attributes.service_id#</cfoutput></cfif>">
									<input type="text" name="service_no" id="service_no" value="<cfif isdefined("attributes.service_no")><cfoutput>#attributes.service_no#</cfoutput></cfif>" style="width:135px;"  maxlength="50">
									<span class="input-group-addon btnPointer icon-ellipsis" title="<cf_get_lang dictionary_id='51183.İş/Görev'>" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_service&field_id=form_basket.service_id&field_no=form_basket.service_no&field_subs_id=form_basket.subscription_id&field_subs_no=form_basket.subscription_no','list');"></span>
								</div>
							</div>
						</div>
					</div>
					<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="4" sort="true">
						<div class="form-group" id="item-note">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
							<div class="col col-8 col-xs-12">
								<textarea name="note" id="note" style="width:140px;height:45px;"><cfif isdefined("attributes.ship_id") and len(attributes.ship_id)><cfoutput>#attributes.ship_detail#</cfoutput><cfelse><cfoutput>#attributes.note#</cfoutput></cfif></textarea>
							</div>
						</div>
						<cfif session.ep.our_company_info.project_followup eq 1>
							<div class="form-group" id="item-project_head">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57416.Proje'></label>
								<div class="col col-8 col-xs-12">
									<div class="input-group">
										<cfif session.ep.our_company_info.project_followup eq 1>
											<cfoutput>
												<input type="hidden" name="project_id" id="project_id" value="<cfif isdefined('attributes.project_id')>#attributes.project_id#</cfif>">
												<input name="project_head" type="text" id="project_head" value="<cfif isdefined('attributes.project_id') and len(attributes.project_id)>#GET_PROJECT_NAME(attributes.project_id)#<cfelseif isdefined('get_project_info.project_head') and len(get_project_info.project_head)>#get_project_info.project_head#</cfif>" onfocus="if(check_project_changes()){AutoComplete_Create('project_head','PROJECT_ID,PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','form_basket','3','135')}" autocomplete="off">
												<span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_projects&project_id=form_basket.project_id&project_head=form_basket.project_head');"></span>
												<span class="input-group-addon btnPointer bold" onclick="if(document.getElementById('project_id').value!='')windowopen('#request.self#?fuseaction=project.popup_list_project_actions&from_paper=INVOICE&id='+document.getElementById('project_id').value+'','horizantal');else alert('<cf_get_lang dictionary_id='58797.Proje Seçiniz'>');">?</span>
											</cfoutput>
										</cfif>
									</div>
								</div>
							</div>
						</cfif>
						<div class="form-group" id="item-ref_no">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58784.Referans'></label>
							<div class="col col-8 col-xs-12">
								<input type="text" name="ref_no" id="ref_no" value="<cfoutput>#attributes.ref_no#</cfoutput>" style="width:140px;" maxlength="500">
							</div>
						</div>
						<cfif xml_show_contract eq 1>
							<div class="form-group" id="item-contract_no">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='29522.Sözleşme'></label>
								<div class="col col-8 col-xs-12">
									<div class="input-group">
										<cfif isdefined('attributes.progress_id') and len(attributes.progress_id)>
											<input type="hidden" name="progress_id" id="progress_id" value="<cfoutput>#attributes.progress_id#</cfoutput>">
										</cfif> 
										<cfif isdefined('attributes.contract_id') and len(attributes.contract_id)>
											<cfquery name="getContract" datasource="#dsn3#">
												SELECT CONTRACT_HEAD FROM RELATED_CONTRACT WHERE CONTRACT_ID = #attributes.contract_id#
											</cfquery>
											<input type="hidden" name="contract_id" id="contract_id" value="<cfif len(attributes.contract_id)><cfoutput>#attributes.contract_id#</cfoutput></cfif>"> 
											<input type="text" name="contract_no" id="contract_no" value="<cfif len(attributes.contract_id)><cfoutput>#getContract.contract_head#</cfoutput></cfif>" style="width:140px;">
										<cfelse>
											<input type="hidden" name="contract_id" id="contract_id" value=""> 
											<input type="text" name="contract_no" id="contract_no" value="" style="width:140px;">
										</cfif>
										<span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_contract&field_id=form_basket.contract_id&field_name=form_basket.contract_no'</cfoutput>,'large');"></span>
									</div>
								</div>
							</div>
						</cfif>
						<div class="form-group" id="item-bank_no">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='29449.Banka'></label>
							<div class="col col-8 col-xs-12"><cf_wrkbankaccounts control_status='1' selected_value=''></div>
						</div>
						<cfif xml_show_cash_checkbox eq 1>     
							<div class="form-group" id="item-kasa">    
								<label class="col col-4 col-xs-12" id="kasa_sec"><cfif kasa.recordcount><cf_get_lang dictionary_id='57030.Nakit Satış'><input type="checkbox" name="cash" id="cash" onclick="ayarla_gizle_goster();"></cfif></label>
								<div class="col col-8 col-xs-12" style="display:none;" id="cash_">
									<select name="kasa" id="kasa" style="width:140px;">
										<cfoutput query="kasa">
											<option value="#cash_id#">#cash_name#-#cash_currency_id# </option>
										</cfoutput>
									</select>
									<cfoutput query="kasa">
										<input type="hidden" name="str_kasa_parasi#cash_id#" id="str_kasa_parasi#cash_id#" value="#cash_currency_id#">
									</cfoutput>
								</div>
							</div>
						</cfif>
					</div>
				</cf_box_elements>
				<cf_box_footer>
					<cf_workcube_buttons is_upd='0' add_function='kontrol()'>
				</cf_box_footer>
				<cfif isdefined("attributes.order_id") and len(attributes.order_id)>					
					<input type="hidden" id="is_potansiyel" name="is_potansiyel" value="<cfif len(get_company.recordcount) and  get_company.ISPOTANTIAL eq 1>1<cfelse>0</cfif>">
					<input type="hidden" id="is_potansiyel_comp" name="is_potansiyel_comp" value="<cfif len(get_company.recordcount) and  get_company.ISPOTANTIAL eq 1><cfoutput>#get_company.COMPANY_ID#</cfoutput><cfelse>0</cfif>">
					<div style="display:none" class="ui-cfmodal ui-cfmodal__alert">
						<cf_box>
							<div class="ui-cfmodal-close">×</div>
							<ul class="required_list"></ul>
							<div class="ui-form-list-btn">
								<div id="div_1">
									<a href="javascript:void(0);"  onClick="cancel();" class="ui-btn ui-btn-delete">Reddet</a>
								</div>
								<div id="div_2">
									<input type="submit" class="ui-btn ui-btn-success" value="Kaydet" onClick="<cfif isdefined("xml_show_process_stage") and len(xml_show_process_stage) and xml_show_process_stage eq 1> return (process_cat_control() && saveForm()); <cfelse> saveForm();</cfif>">		
								</div>
							</div>
						</cf_box>
					</div>
				</cfif>
        </cf_basket_form>
        <cfif session.ep.isBranchAuthorization>
            <cfset attributes.basket_id = 18> 
        <cfelse>
            <cfset attributes.basket_id = 2>
        </cfif>
		<cfif not (isdefined("attributes.event") and attributes.event is 'copy') >
			<cfif (len(attributes.subscription_id) and not isdefined("attributes.order_id")) or (isdefined("attributes.contract_id") and len(attributes.contract_id))>
				<cfset attributes.basket_sub_id = 31>
			<cfelseif isdefined("attributes.assetp_id") and len(attributes.assetp_id) and isdefined("attributes.service_operation_id")>
				<cfset attributes.basket_sub_id = 32>
			<cfelseif isdefined("attributes.service_operation_ids") and isdefined("attributes.is_from_operations")>
				<cfset attributes.basket_sub_id = 32>
			<cfelseif isdefined("attributes.order_id") and isdefined("attributes.order_id")>
				<cfset attributes.basket_sub_id = 7>
			<cfelseif isdefined("attributes.ship_id") and len(attributes.ship_id)>
				<cfset attributes.basket_id = 2>
				<cfset attributes.basket_sub_id = 2>
			</cfif>
		</cfif>
        <cfif not (isdefined("attributes.event") and attributes.event is 'copy') and not isdefined('attributes.stock_id') and not isdefined('attributes.convert_stocks_id') and not isdefined('attributes.stock_name') and not isdefined("attributes.basket_sub_id")>
            <cfset attributes.form_add = 1>
        </cfif>
        <cfinclude template="../../objects/display/basket.cfm">
    </cfform>
</div>
</cf_box>
</div>
<script type="text/javascript">

<cfif isdefined("url.ship_id")>
$(document).ready(function(){
	if(typeof(change_paper_duedate) == "function")
	change_paper_duedate('invoice_date');
});
</cfif>
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
	if(form_basket.company_id.value.length || form_basket.consumer_id.value.length)
	{ 
		str_irslink = '&ship_id_liste=' + form_basket.irsaliye_id_listesi.value + '&id=sale&sale_product=1&company_id='+form_basket.company_id.value+'&consumer_id='+ form_basket.consumer_id.value + '&invoice_date=' + form_basket.invoice_date.value<cfif session.ep.isBranchAuthorization>+'&is_store='+1</cfif>;


		 <cfif session.ep.our_company_info.project_followup eq 1>
		 	if(form_basket.project_id.value!='' && form_basket.project_head.value!='')
				str_irslink = str_irslink+'&project_id='+form_basket.project_id.value;
		 </cfif>
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_choice_ship&ship_project_liste=1' + str_irslink,'wide');
		return true;
	}
	else
	{
		alert("<cf_get_lang dictionary_id='57183.Cari Hesap Seçmelisiniz '> !");
		return false;
	}
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
	is_efatura = '<cfoutput>#session.ep.our_company_info.is_efatura#</cfoutput>';
	if( is_efatura == 1 && get_member_control != undefined && get_member_control.USE_EFATURA == 1 && datediff(date_format(get_member_control.EFATURA_DATE),document.getElementById('invoice_date').value,0) >= 0)
		paper_type = 'E_INVOICE';
	else
		paper_type = 'INVOICE';
	paper_control(form_basket.serial_no,paper_type,true,'','','','','','',1,form_basket.serial_number);
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
            alert("<cf_get_lang dictionary_id='45400.Bu lokasyondan satış yapılamaz.'>");
            return false;
        }
    }
	<cfif xml_control_konsinye_invoice eq 1>
	deger2 = form_basket.process_cat.options[form_basket.process_cat.selectedIndex].value;			
		if(eval("form_basket.ct_process_type_" + deger2).value == 532)
		{
			if(form_basket.irsaliye.value == ''){
			alert("<cf_get_lang dictionary_id='59796.Konsinye Fatura İşlem Tipinde Cari İle İlişkili İrsaliyesi Seçmelisiniz'>.!");
			return false;
			}
		}
	</cfif>
	<cfif xml_show_ship_date eq 1>
		if (!date_check(form_basket.invoice_date,form_basket.ship_date,"Fiili Sevk Tarihi, Fatura Tarihinden Önce Olamaz!"))
			return false;
	</cfif>
	
	if(form_basket.company_id!=undefined && form_basket.company_id.value.length)
	{
		var get_member_control = wrk_safe_query('obj_get_company_efatura','dsn' , 0, form_basket.company_id.value);
	}
	else if(form_basket.consumer_id!=undefined && form_basket.consumer_id.value.length)
	{
		var get_member_control = wrk_safe_query('obj_get_consumer_efatura','dsn',0,form_basket.consumer_id.value);
	}
	if(form_basket.order_id_listesi.value!='' && list_getat(form_basket.irsaliye_id_listesi.value,1,';') != '')
	{
		alert("<cf_get_lang dictionary_id='57101.İrsaliye ve Sipariş Aynı Anda Seçilemez. Lütfen Seçimlerinizi Kontrol Ediniz !'>");
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
			alert("<cf_get_lang dictionary_id='35327.Sevk Yöntemi Seçiniz!'>");
			return false;	
		}
	</cfif>
	<cfif is_referance eq 1>
		if(form_basket.ref_no.value == '')
			{
					alert("<cf_get_lang dictionary_id='59797.Referans alanı zorunludur!'>");
					return false;
			}
	</cfif>	
	if(get_member_control != undefined && get_member_control.USE_EFATURA == 1 && datediff(date_format(get_member_control.EFATURA_DATE),document.getElementById('invoice_date').value,0) >= 0)
		paper_type = 'E_INVOICE';
	else
		paper_type = 'INVOICE';
		
	//paper_control(form_basket.serial_no,paper_type,true,'','','','','','',0,form_basket.serial_number);
	if(!paper_control(form_basket.serial_no,paper_type,true,'','','','','','',0,form_basket.serial_number)) return false;
	if(!chk_period(form_basket.invoice_date,"İşlem")) return false;
	if(!chk_process_cat('form_basket')) return false;
	<cfif isdefined('xml_acc_department_info') and xml_acc_department_info eq 2> //xmlde muhasebe icin departman secimi zorunlu ise
		if( document.form_basket.acc_department_id.options[document.form_basket.acc_department_id.selectedIndex].value=='')
		{
			alert("<cf_get_lang dictionary_id='58836.Lutfen Departman Seciniz'>");
			return false;
		} 
	</cfif>
	
	if(!check_display_files('form_basket')) return false;
	if(!kontrol_ithalat()) return false;
	try
		{
			try
				{a=form_basket.row_ship_id[0].value;}
			catch(e)
				{a=form_basket.row_ship_id.value;}
			if (a == "" || a == "0" )
			{
				if(form_basket.department_id.value=="")
				{
					alert("<cf_get_lang dictionary_id='57208.Departman Seçiniz'>!");
					return false;
				}
				if(form_basket.location_id.value=="")
				{
					alert("Lokasyon Seçiniz!");
					return false;
				}
			}
			if(form_basket.department_id.value=="")
				{
					alert("<cf_get_lang dictionary_id='57208.Departman Seçiniz'>!");
					return false;
				}
				if(form_basket.location_id.value=="")
				{
					alert("<cf_get_lang dictionary_id='51741.Lokasyon Seçiniz'>!");
					return false;
				}
		}
		catch(e)
			{
			if(form_basket.department_id.value=="")
				{
				alert("<cf_get_lang dictionary_id='57208.Departman Seçiniz'>!");
				return false;
				}
			if(form_basket.location_id.value=="")
				{
					alert("<cf_get_lang dictionary_id='51741.Lokasyon Seçiniz'>!");
					return false;
				}
			}	

	if(document.form_basket.comp_name.value == ""  && document.form_basket.consumer_id.value == "" && document.form_basket.employee_id.value == "")
	{ 
		alert ("<cf_get_lang dictionary_id='57183.Cari Hesabı Seçmelisiniz !'>");
		return false;
	}

	
	if(!check_accounts('form_basket')) return false;
	<cfif session.ep.our_company_info.project_followup eq 1 and isdefined("xml_upd_row_project") and xml_upd_row_project eq 1>
		apply_deliver_date('','project_head','');
	</cfif>
	if(!check_product_accounts()) return false;
	//<!--- toptan satıs fat ve alım iade fat icin sıfır stok kontrolu--->
	var temp_process_cat = document.form_basket.process_cat.options[document.form_basket.process_cat.selectedIndex].value;
	if(temp_process_cat.length)
	{
		if(check_stock_action('form_basket')) //islem kategorisi stok hareketi yapıyorsa
		{
			var fis_no = eval("document.form_basket.ct_process_type_" + temp_process_cat);
			var basket_zero_stock_status = wrk_safe_query('inv_basket_zero_stock_status','dsn3',0,<cfoutput>#attributes.basket_id#</cfoutput>);
			if(basket_zero_stock_status.IS_SELECTED != 1)//<!--- basket sablonlarında sıfır stok ile calıs secilmemisse zero_stock kontrolu yapılıyor --->
			{
				if(!zero_stock_control(form_basket.department_id.value,form_basket.location_id.value,0,fis_no.value)) return false;
			}
		}
	}
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
		var inv_ship_amount_list = '';

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

					if( get_inv_control != undefined && get_inv_control.AMOUNT > 0){
						inv_ship_amount = parseFloat(get_ship_control.AMOUNT)-parseFloat(get_inv_control.AMOUNT); 
						if(inv_ship_amount <= 0 ){
							inv_ship_amount_list = inv_ship_amount_list + eval(str_i_row+1) + '.Satır : ' + basketManagerObject.basketItems()[str_i_row].product_name() + '\n';
						}
					}
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

					if( get_inv_control != undefined && get_inv_control.AMOUNT > 0){
						inv_ship_amount = parseFloat(get_ship_control.AMOUNT)-parseFloat(get_inv_control.AMOUNT); 
						if(inv_ship_amount <= 0 ){
							inv_ship_amount_list = inv_ship_amount_list + eval(str_i_row+1) + '.Satır : ' + window.basket.items[str_i_row].PRODUCT_NAME + '\n';
						}
					}
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
		if(inv_ship_amount_list != ''){
			alert("<cf_get_lang dictionary_id='57108.Aşağıda Belirtilen Ürünler İçin Toplam Fatura Miktarı İrsaliye Miktarından Fazla ! Lütfen Ürünleri Kontrol Ediniz'> \n\n" + inv_ship_amount_list);
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
								alert("<cf_get_lang dictionary_id='57113.İlgili Faturaya Bağlı İrsaliyelerin Projeleri İle Faturada Seçilen Proje Aynı Olmalıdır'>");
								return false;
							}
					}
			}
	</cfif>
	<cfif isdefined("attributes.order_id") and len(attributes.order_id)>		
		$('.ui-cfmodal__alert .required_list li').remove();	
		if(document.getElementById("is_potansiyel").value == 1 && document.getElementById("company_id").value == document.getElementById("is_potansiyel_comp").value)
		{		
			$('.ui-cfmodal__alert .required_list').append('<cf_get_lang dictionary_id="61485.Potansiyel Cari için Fatura Kesilsin mi?">');	
			$('.ui-cfmodal__alert').fadeIn();
			return false;		
		}

		var order_id = $("#order_id").val();
		var sql_2 ="SELECT II.INVOICE_ID,II.INVOICE_NUMBER,II.INVOICE_DATE,II.RECORD_EMP FROM INVOICE II,INVOICE_ROW IR WHERE II.INVOICE_ID = IR.INVOICE_ID AND IR.ORDER_ID = "+order_id+"GROUP BY II.INVOICE_ID,II.INVOICE_NUMBER,II.INVOICE_DATE,II.RECORD_EMP"
		cnt_order_inv = wrk_query(sql_2,'dsn2');
		if (cnt_order_inv.recordcount != 0)
			{	if( window.basketManager !== undefined )
				{ 
					for(var str=0; str < basketManagerObject.basketItems().length; str++)
					{						
						var sql = "SELECT ISNULL(SUM(IR.AMOUNT),0) AS INV_QUANTITY FROM INVOICE II,INVOICE_ROW IR WHERE II.INVOICE_ID = IR.INVOICE_ID AND IR.ORDER_ID="+order_id+"AND IR.PRODUCT_ID="+basketManagerObject.basketItems()[str].product_id();
						cnt_order_inv_2 = wrk_query(sql,'dsn2');
						/* console.log(basketManagerObject.basketItems()[str].product_id());
						console.log(cnt_order_inv_2); */
						var sql_1 = "SELECT ISNULL(SUM(ORS.QUANTITY),0) AS ORD_QUANTITY FROM ORDERS ORD JOIN ORDER_ROW ORS ON ORD.ORDER_ID = ORS.ORDER_ID WHERE ORD.ORDER_ID="+order_id+"AND ORS.PRODUCT_ID="+basketManagerObject.basketItems()[str].product_id();
						cnt_order_inv_1 = wrk_query(sql_1,'dsn3');

						/* console.log(cnt_order_inv_1); */
						var rest_quantity = parseFloat(cnt_order_inv_1.ORD_QUANTITY)-parseFloat(cnt_order_inv_2.INV_QUANTITY);
						/* alert(rest_quantity); */
						if(rest_quantity <= 0)
						{
							$('.ui-cfmodal__alert .ui-form-list-btn div').remove();
							$('.ui-cfmodal__alert .required_list').append('<li class="required">Seçilen Sipariş Daha Önce Faturaya Bağlanmış</li>');
							for(var str_i_row=0; str_i_row < cnt_order_inv.recordcount; str_i_row++)
							{
								var sql_ = "SELECT EMPLOYEE_NAME + ' ' + EMPLOYEE_SURNAME AS EMP_NAME FROM EMPLOYEES WHERE EMPLOYEE_ID = "+cnt_order_inv.RECORD_EMP[str_i_row];
								get_emp = wrk_query(sql_,'dsn');
										
								$('.ui-cfmodal__alert .required_list').append('<li class="required"><cf_get_lang dictionary_id='58133.Fatura No'> : '+cnt_order_inv.INVOICE_NUMBER[str_i_row]+'</li>');
								$('.ui-cfmodal__alert .required_list').append('<li class="required"><cf_get_lang dictionary_id='58759.Fatura Tarihi'> : '+date_format(cnt_order_inv.INVOICE_DATE[str_i_row])+'</li>');
								$('.ui-cfmodal__alert .required_list').append('<li class="required"><cf_get_lang dictionary_id='57899.Fatura Kaydeden'> :'+get_emp.EMP_NAME+'</li>');
								$('.ui-cfmodal__alert .required_list').append('<li class="required">--------------------------------------------------------</li>');
								$('.ui-cfmodal__alert .ui-form-list-btn #div_1').hide();$('.ui-cfmodal__alert .ui-form-list-btn #div_2').hide();
								$('.ui-cfmodal__alert .ui-form-list-btn').append('<div><a href="<cfoutput>#request.self#?fuseaction=invoice.form_add_bill&event=upd&iid=</cfoutput>'+cnt_order_inv.INVOICE_ID[str_i_row]+'" class="ui-btn ui-btn-success" target="_blank">'+cnt_order_inv.INVOICE_ID[str_i_row]+' id li Faturaya Tıklayınız</a></div>');								
							}
							$('.ui-cfmodal__alert').fadeIn();
							return false;							
						} 
					}
				}
				else
				{
					for(var str=0; str < window.basket.items.length; str++)
					{						
						var sql = "SELECT ISNULL(SUM(IR.AMOUNT),0) AS INV_QUANTITY FROM INVOICE II,INVOICE_ROW IR WHERE II.INVOICE_ID = IR.INVOICE_ID AND IR.ORDER_ID="+order_id+"AND IR.PRODUCT_ID="+window.basket.items[str].PRODUCT_ID;
						cnt_order_inv_2 = wrk_query(sql,'dsn2');
						/* console.log(window.basket.items[str].PRODUCT_ID);
						console.log(cnt_order_inv_2); */
						var sql_1 = "SELECT ISNULL(SUM(ORS.QUANTITY),0) AS ORD_QUANTITY FROM ORDERS ORD JOIN ORDER_ROW ORS ON ORD.ORDER_ID = ORS.ORDER_ID WHERE ORD.ORDER_ID="+order_id+"AND ORS.PRODUCT_ID="+window.basket.items[str].PRODUCT_ID;
						cnt_order_inv_1 = wrk_query(sql_1,'dsn3');

						/* console.log(cnt_order_inv_1); */
						var rest_quantity = parseFloat(cnt_order_inv_1.ORD_QUANTITY)-parseFloat(cnt_order_inv_2.INV_QUANTITY);
						/* alert(rest_quantity); */
						if(rest_quantity <= 0)
						{
							$('.ui-cfmodal__alert .ui-form-list-btn div').remove();
							$('.ui-cfmodal__alert .required_list').append('<li class="required">Seçilen Sipariş Daha Önce Faturaya Bağlanmış</li>');
							for(var str_i_row=0; str_i_row < cnt_order_inv.recordcount; str_i_row++)
							{
								var sql_ = "SELECT EMPLOYEE_NAME + ' ' + EMPLOYEE_SURNAME AS EMP_NAME FROM EMPLOYEES WHERE EMPLOYEE_ID = "+cnt_order_inv.RECORD_EMP[str_i_row];
								get_emp = wrk_query(sql_,'dsn');
										
								$('.ui-cfmodal__alert .required_list').append('<li class="required"><cf_get_lang dictionary_id='58133.Fatura No'> : '+cnt_order_inv.INVOICE_NUMBER[str_i_row]+'</li>');
								$('.ui-cfmodal__alert .required_list').append('<li class="required"><cf_get_lang dictionary_id='58759.Fatura Tarihi'> : '+date_format(cnt_order_inv.INVOICE_DATE[str_i_row])+'</li>');
								$('.ui-cfmodal__alert .required_list').append('<li class="required"><cf_get_lang dictionary_id='57899.Fatura Kaydeden'> :'+get_emp.EMP_NAME+'</li>');
								$('.ui-cfmodal__alert .required_list').append('<li class="required">--------------------------------------------------------</li>');
								$('.ui-cfmodal__alert .ui-form-list-btn #div_1').hide();$('.ui-cfmodal__alert .ui-form-list-btn #div_2').hide();
								$('.ui-cfmodal__alert .ui-form-list-btn').append('<div><a href="<cfoutput>#request.self#?fuseaction=invoice.form_add_bill&event=upd&iid=</cfoutput>'+cnt_order_inv.INVOICE_ID[str_i_row]+'" class="ui-btn ui-btn-success" target="_blank">'+cnt_order_inv.INVOICE_ID[str_i_row]+' id li Faturaya Tıklayınız</a></div>');								
							}
							$('.ui-cfmodal__alert').fadeIn();
							return false;							
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
function cancel() {
		   $('.ui-cfmodal__alert').fadeOut();
		   return false;		
	}
function ayarla_gizle_goster()
{
	if(form_basket.cash != undefined &&  form_basket.cash.checked)
		cash_.style.display='';
	else
		cash_.style.display='none';
}
function kontrol_ithalat()
{
	sistem_para_birimi = "<cfoutput>#SESSION.EP.MONEY#</cfoutput>";	
	deger = form_basket.process_cat.options[form_basket.process_cat.selectedIndex].value;
	if(deger != "")
	{
		var fis_no = eval("form_basket.ct_process_type_" + deger);
		//kdvden muaf satis faturasi : 533
		if(list_find('531,533',fis_no.value))
			$(document).ready(function()
			{
				reset_basket_kdv_rates() && reset_basket_otv_rates();
				 //kdv oranları sıfırlanıyor dsp_basket_js_scripts te tanımlı
			});
	}
	return true;
}	
function kontrol_yurtdisi()
{
	var deger = document.form_basket.process_cat.options[document.form_basket.process_cat.selectedIndex].value;
	if(deger.length)
	{
		var fis_no = eval("document.form_basket.ct_process_type_" + deger);
		if(list_find('531,533',fis_no.value))
		{ 
			<cfif xml_show_cash_checkbox eq 1>
				kasa_sec.style.display = 'none';
				cash_.style.display = 'none';
				if(form_basket.cash != undefined)
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

function check_process_is_sale(){/*alım iadeleri satis karakterli oldugu halde alış fiyatları ile çalışması için*/
	<cfif attributes.basket_id is 2>
		var selected_ptype = document.form_basket.process_cat.options[document.form_basket.process_cat.selectedIndex].value;
		sale_product = 1;
		if(selected_ptype.length)
		{
			var proc_control = eval('document.form_basket.ct_process_type_'+selected_ptype+'.value');
			if(proc_control==62)
			{
				sale_product= 0;
			}
		}
	<cfelse>
		return true;
	</cfif>
}
function add_adress()
{
	if(!(form_basket.company_id.value=="") || !(form_basket.consumer_id.value=="") || !(form_basket.employee_id.value==""))
	{
		if(form_basket.company_id.value!="")
		{
			str_adrlink = '&field_long_adres=form_basket.adres&field_adress_id=form_basket.ship_address_id';
			if(form_basket.city_id!=undefined) str_adrlink = str_adrlink+'&field_city=form_basket.city_id';
			if(form_basket.county_id!=undefined) str_adrlink = str_adrlink+'&field_county=form_basket.county_id'<cfif session.ep.isBranchAuthorization>+'&is_store_module='+1</cfif>;
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_member_address&is_comp=1&keyword='+encodeURIComponent(form_basket.comp_name.value)+''+ str_adrlink , 'list');
			return true;
		}
		else
		{
			str_adrlink = '&field_long_adres=form_basket.adres&field_adress_id=form_basket.ship_address_id';
			if(form_basket.city_id!=undefined) str_adrlink = str_adrlink+'&field_city=form_basket.city_id';
			if(form_basket.county_id!=undefined) str_adrlink = str_adrlink+'&field_county=form_basket.county_id'<cfif session.ep.isBranchAuthorization>+'&is_store_module='+1</cfif>;
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_member_address&is_comp=0&keyword='+encodeURIComponent(form_basket.partner_name.value)+''+ str_adrlink , 'list');
			return true;
		}
	}
	else
	{
		alert("<cf_get_lang dictionary_id='57183.Cari Hesap Seçmelisiniz'>");
		return false;
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
<cfif isdefined('attributes.company_id') and len(attributes.company_id)>
	<!--- Eğer üye seçili geliyorsa otomatik olarak carinin işlem dövizi gelecek --->
//	get_money_info('form_basket','invoice_date');
</cfif>
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
<br />
<cfsetting showdebugoutput="yes">