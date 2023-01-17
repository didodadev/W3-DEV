<cfsetting showdebugoutput="yes">
<cf_get_lang_set module_name="invoice">
<cf_xml_page_edit fuseact="invoice.add_sale_invoice_from_order">
<cfparam name="attributes.barkod" default="0">
<cfparam name="attributes.invoice_date" default="#now()#">
<cfquery name="GET_ORDER_INFO" datasource="#dsn3#">
	SELECT * FROM ORDERS WHERE ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.order_id#">
</cfquery>
<cfset attributes.comp_id = GET_ORDER_INFO.COMPANY_ID>
<cfscript>session_basket_kur_ekle(action_id=attributes.order_id,table_type_id:3,to_table_type_id:1,process_type:1);</cfscript>
<cfif len(get_order_info.order_employee_id)>
	<cfquery name="GET_EMP_INFO" datasource="#dsn#">
		SELECT EMPLOYEE_NAME, EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_order_info.order_employee_id#">
	</cfquery>
</cfif>
<cfif not len(get_order_info.deliver_dept_id) and not len(get_order_info.location_id)>
	<cfset get_order_info.deliver_dept_id = ListGetAt(session.ep.user_location,1,'-')>
	<cfif ListLen(session.ep.user_location,'-') eq 3>
		<cfset get_order_info.location_id =  ListGetAt(session.ep.user_location,3,'-')>
	<cfelse>
		<cfset get_order_info.location_id = "">
	</cfif>
</cfif>
<cfif len(get_order_info.deliver_dept_id) and len(get_order_info.location_id)>
	<cfquery name="get_depo_loc_info" datasource="#dsn#">
		SELECT 
			SL.LOCATION_ID,
			D.DEPARTMENT_ID,
			D.BRANCH_ID,
			SL.COMMENT,
			D.DEPARTMENT_HEAD
		FROM
			STOCKS_LOCATION SL,
			DEPARTMENT D
		WHERE 
			SL.LOCATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_order_info.location_id#"> AND
			SL.DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_order_info.deliver_dept_id#"> AND
			SL.DEPARTMENT_ID = D.DEPARTMENT_ID
	</cfquery>
</cfif>
<!--- Faturaya dönüstürüldügü icin üyenin varsa fatura adresi sevk adresi olarak atanır FA--->
<cfif is_copy_order_address_ eq 0> <!--- XML e baglı olarak Siparis adresi korunarak fatura adresine aktarilir LS --->
	<cfif len(GET_ORDER_INFO.company_id)>
		<cfquery name="get_invoice_address" datasource="#dsn#">
			SELECT COMPBRANCH_ADDRESS,COMPBRANCH_POSTCODE,SEMT,COUNTY_ID,CITY_ID,COUNTRY_ID,COMPBRANCH_ID FROM COMPANY_BRANCH WHERE IS_INVOICE_ADDRESS=1 AND COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_order_info.company_id#">
		</cfquery>
	<cfelse>
		<cfquery name="get_invoice_address" datasource="#dsn#">
			SELECT TAX_ADRESS COMPBRANCH_ADDRESS,TAX_POSTCODE COMPBRANCH_POSTCODE,TAX_SEMT SEMT,TAX_COUNTY_ID COUNTY_ID,TAX_CITY_ID CITY_ID,TAX_COUNTRY_ID COUNTRY_ID, '' COMPBRANCH_ID FROM CONSUMER WHERE CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_order_info.consumer_id#">
		</cfquery>
	</cfif>
	<cfif get_invoice_address.recordcount>
		<cfif len(get_invoice_address.county_id)>
			<cfquery name="get_county_" datasource="#dsn#">
				SELECT COUNTY_NAME FROM SETUP_COUNTY WHERE COUNTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_invoice_address.county_id#">
			</cfquery>
			<cfset county_ = get_county_.county_name>
		<cfelse>
			<cfset county_ = "">
		</cfif>
		<cfif len(get_invoice_address.city_id)>
			<cfquery name="get_city_" datasource="#dsn#">
				SELECT CITY_NAME FROM SETUP_CITY WHERE CITY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_invoice_address.city_id#">
			</cfquery>
			<cfset city_ = get_city_.city_name>
		<cfelse>
			<cfset city_ = "">
		</cfif>
		<cfif len(get_invoice_address.country_id)>
			<cfquery name="get_country_" datasource="#dsn#">
				SELECT COUNTRY_NAME FROM SETUP_COUNTRY WHERE COUNTRY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_invoice_address.country_id#">
			</cfquery>
			<cfset country_ = get_country_.country_name>
		<cfelse>
			<cfset country_ = "">
		</cfif>
		<cfset get_order_info.ship_address = "#get_invoice_address.COMPBRANCH_ADDRESS# #get_invoice_address.COMPBRANCH_POSTCODE# #get_invoice_address.semt# #county_# #city_# #country_#">
		<cfset get_order_info.city_id = get_invoice_address.city_id>
		<cfset get_order_info.county_id = get_invoice_address.country_id>
        <cfset get_order_info.ship_address_id = get_invoice_address.compbranch_id>
	</cfif>
</cfif>
<cfset paper_type = 'invoice'>
<cfif isdefined('get_order_info.company_id') and len(get_order_info.company_id)>
	<cfquery name="get_comp_info" datasource="#dsn#">
		SELECT FULLNAME,USE_EFATURA,EFATURA_DATE FROM COMPANY WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_order_info.company_id#">
	</cfquery>
	<cfif len(get_comp_info.use_efatura) and get_comp_info.use_efatura eq 1 and datediff('d',get_comp_info.efatura_date,now()) gte 0>
		<cfset paper_type = 'e_invoice'>
	</cfif>
<cfelseif isdefined('get_order_info.consumer_id') and len(get_order_info.consumer_id)>
	<cfquery name="get_cons_info_" datasource="#dsn#">
		SELECT CONSUMER_NAME+' '+CONSUMER_SURNAME FULLNAME,USE_EFATURA,EFATURA_DATE FROM CONSUMER WHERE CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_order_info.consumer_id#">
	</cfquery>
	<cfif len(get_cons_info_.use_efatura) and get_cons_info_.use_efatura eq 1 and datediff('d',get_cons_info_.efatura_date,now()) gte 0>
		<cfset paper_type = 'e_invoice'>
	</cfif>
</cfif>
<cfset kontrol_status = 1>
<cfinclude template="../query/get_session_cash_all.cfm">
<cfinclude template="../query/control_bill_no.cfm">
<table class="dph">
    <tr>
        <td class="dpht"><a href="javascript:gizle_goster_basket(add_bill);">&raquo;</a><cf_get_lang dictionary_id='57016.Satış Faturası Ekle'></td>
        <td class="dphb">
        	<div style="float:left;"><cfinclude template="fatura_ara.cfm"></div>
        </td>
    </tr>
</table>
<div id="basket_main_div">
	<cf_papers paper_type="#paper_type#" form_name="form_basket" form_field="invoice_number">
	<cfform name="form_basket" method="post" action="#request.self#?fuseaction=#fusebox.circuit#.emptypopup_add_bill">
    	<cf_basket_form id="add_bill"> 
			<cfoutput>
                <input type="hidden" name="form_action_address" id="form_action_address" value="#fusebox.circuit#.emptypopup_add_bill">
                <input type="hidden" name="order_number" id="order_number" value="#get_order_info.order_number#"><!---fatura kayıtları icin--->
                <input type="hidden" name="order_id" id="order_id" value="#get_order_info.order_id#">
                <input type="hidden" name="paper" id="paper" value="<cfif isDefined('paper_number')>#paper_number#</cfif>">
                <input type="hidden" name="paper_printer_id" id="paper_printer_id" value="<cfif isDefined('paper_printer_code')>#paper_printer_code#</cfif>">
                <input type="hidden" name="commethod_id" id="commethod_id" value="<cfif len('GET_ORDER_INFO.commethod_id')>#GET_ORDER_INFO.commethod_id#</cfif>">
                <input type="hidden" name="active_period" id="active_period" value="#session.ep.period_id#">
                <input type="hidden" name="search_process_date" id="search_process_date" value="invoice_date">
                <cfif len(GET_ORDER_INFO.company_id)>
                    <cfset member_account_code = get_company_period(GET_ORDER_INFO.company_id)>
                <cfelse>
                    <cfset member_account_code = get_consumer_period(GET_ORDER_INFO.consumer_id)>
                </cfif>
                <input type="hidden" name="member_account_code" id="member_account_code" value="#member_account_code#">  
            </cfoutput>             
            <table>
                <tr>
                    <td><cf_get_lang dictionary_id='57800.işlem tipi'></td>
                    <td width="175">
                        <cf_workcube_process_cat>
                    </td>
                    <td><cf_get_lang dictionary_id='57637.Seri No'> *</td>
                    <td width="150"><cfsavecontent variable="message"><cf_get_lang dictionary_id='57184.Fatura No Girmelisiniz!'></cfsavecontent>
                        <cfif isDefined('paper_full')>
                            <cfinput type="text" maxlength="5" name="serial_number" value="#paper_code#" style="width:20px;">
                            - <cfinput type="text" maxlength="50" name="serial_no" value="#paper_number#" onBlur="paper_control(this,'INVOICE',true,0,'','','','','',1,form_basket.serial_number);" required="Yes" message="#message#" style="width:70px;"><!---  ---><!--- func_paper_control(this); --->
                            <cfelse>
                            <cfinput type="text" maxlength="5" name="serial_number" value="" style="width:20px;">
                            - <cfinput type="text" maxlength="50" name="serial_no" value="" required="Yes" onBlur="paper_control(this,'INVOICE',true,0,'','','','','',1,form_basket.serial_number);" message="#message#" style="width:70px;">
                          </cfif>                     
                    </td>
                    <td><cf_get_lang dictionary_id='58763.Depo'>*</td>
                    <td width="170" nowrap="nowrap">
                        <cfif isdefined("get_depo_loc_info")>
                            <cf_wrkdepartmentlocation
                                returninputvalue="location_id,department_name,department_id,branch_id"
                                returnqueryvalue="LOCATION_ID,LOCATION_NAME,DEPARTMENT_ID,BRANCH_ID"
                                fieldname="department_name"
                                fieldid="location_id"
                                department_fldid="department_id"
                                branch_fldid="branch_id"
                                branch_id="#get_depo_loc_info.branch_id#"
                                department_id="#get_depo_loc_info.department_id#"
                                location_id="#get_depo_loc_info.location_id#"
                                location_name="#get_depo_loc_info.department_head# - #get_depo_loc_info.comment#"
                                user_level_control="#session.ep.OUR_COMPANY_INFO.IS_LOCATION_FOLLOW#"
                                width="140">
                        <cfelse>
                            <cf_wrkdepartmentlocation
                                returninputvalue="location_id,department_name,department_id,branch_id"
                                returnqueryvalue="LOCATION_ID,LOCATION_NAME,DEPARTMENT_ID,BRANCH_ID"
                                fieldname="department_name"
                                fieldid="location_id"
                                department_fldid="department_id"
                                branch_fldid="branch_id"
                                user_level_control="#session.ep.OUR_COMPANY_INFO.IS_LOCATION_FOLLOW#"
                                width="140">
                        </cfif>
                     </td>
                     <td id="add_info_plus" rowspan="6" valign="top"></td><!--- isbak için eklendi kaldırmayınız sm --->
                </tr>
                <tr>
                    <td><cf_get_lang dictionary_id='57519.cari hesap'>*</td>
                    <td><input type="hidden" name="company_id" id="company_id" value="<cfoutput>#GET_ORDER_INFO.COMPANY_ID#</cfoutput>">
                        <input  type="text" name="comp_name" id="comp_name" readonly <cfif len(GET_ORDER_INFO.COMPANY_ID)>value="<cfoutput>#get_par_info(GET_ORDER_INFO.COMPANY_ID,1,0,0)#</cfoutput>"</cfif> style="width:150px;">
                        <cfset str_linkeait = "&field_cons_ref_code=form_basket.consumer_reference_code&field_paymethod_id=form_basket.paymethod_id&field_paymethod=form_basket.paymethod&field_basket_due_value=form_basket.basket_due_value&field_card_payment_id=form_basket.card_paymethod_id&call_function=add_general_prom()-check_member_price_cat()">							
                        <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_pars&select_list=2,3&field_name=form_basket.partner_name&field_partner=form_basket.partner_id&field_comp_name=form_basket.comp_name&field_comp_id=form_basket.company_id&field_consumer=form_basket.consumer_id&field_member_account_code=form_basket.member_account_code#str_linkeait#<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif></cfoutput>','list')">
                        <img src="/images/plus_thin.gif" title="<cf_get_lang dictionary_id='57734.seçiniz'>"  border="0" align="absmiddle"></a>
                    </td>
                    <td><cf_get_lang dictionary_id='58759.Fatura Tarihi'>*</td>
                    <td><cfsavecontent variable="message"><cf_get_lang dictionary_id='57185.Fatura Tarihi Girmelisiniz !'>  </cfsavecontent>
                        <cfinput type="text" name="invoice_date" id="invoice_date" value="#dateformat(attributes.invoice_date,dateformat_style)#" style="width:100px;" required="Yes" message="#message#" onChange="check_member_price_cat();"  validate="#validate_style#" maxlength="10" readonly="yes">
                        <cf_wrk_date_image date_field="invoice_date" call_function="add_general_prom&change_money_info"></td>
                    <td><cf_get_lang dictionary_id='29500.Sevk Yöntemi'></td>
                    <td><input type="hidden" name="ship_method" id="ship_method" value="<cfoutput>#GET_ORDER_INFO.SHIP_METHOD#</cfoutput>">
                        <cfif len(GET_ORDER_INFO.ship_method)>
                        <cfset attributes.ship_method_id=GET_ORDER_INFO.ship_method>
                        <cfinclude template="../query/get_ship_methods.cfm">
                        </cfif>
                        <input type="text" name="ship_method_name" id="ship_method_name" style="width:140px;" value="<cfif len(GET_ORDER_INFO.ship_method)><cfoutput>#ship_methods.ship_method#</cfoutput></cfif>">
                        <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_ship_methods&field_name=ship_method_name&field_id=ship_method','list');"><img src="/images/plus_thin.gif" title="<cf_get_lang dictionary_id='57734.seçiniz'>" border="0" align="absmiddle"></a>
                    </td>
                    <td><cf_get_lang dictionary_id='57629.Açıklama'></td>
                    <td rowspan="2" valign="top"><textarea style="width:140px;height:45px;" name="note" id="note"><cfoutput>#get_order_info.order_detail#</cfoutput></textarea></td>
                </tr>
                <tr>
                    <cfoutput>
                        <td><cf_get_lang dictionary_id='57578.Yetkili'>*</td>
                        <td><input type="hidden" name="partner_reference_code" id="partner_reference_code" value="#GET_ORDER_INFO.partner_reference_code#">
                            <input type="hidden" name="consumer_reference_code" id="consumer_reference_code" value="#GET_ORDER_INFO.consumer_reference_code#">
                            <input type="hidden" name="partner_id" id="partner_id" value="<cfoutput>#GET_ORDER_INFO.PARTNER_ID#</cfoutput>">
                            <input type="hidden" name="consumer_id" id="consumer_id" value="<cfoutput>#GET_ORDER_INFO.CONSUMER_ID#</cfoutput>">
                            <input type="hidden" name="employee_id" id="employee_id" value="">
                            <input type="text" name="partner_name" id="partner_name" <cfif len(GET_ORDER_INFO.CONSUMER_ID)>value="<cfoutput>#get_cons_info(GET_ORDER_INFO.CONSUMER_ID,0,0)#</cfoutput>"<cfelse>value="<cfoutput>#get_par_info(GET_ORDER_INFO.PARTNER_ID,0,0,0)#</cfoutput>"</cfif> readonly style="width:150px;">
                        </td>
                    </cfoutput>
                    <cfif xml_show_ship_date eq 1>
                        <td><cf_get_lang dictionary_id="57009.Fiili Sevk Tarihi"></td>
                        <td>
                            <cfinput type="text" name="ship_date" id="ship_date" style="width:100px;" value="#dateformat(attributes.invoice_date,dateformat_style)#" validate="#validate_style#" maxlength="10">
                            <cf_wrk_date_image date_field="ship_date">
                        </td>
                    </cfif>					  
                    <td nowrap="nowrap"><cf_get_lang dictionary_id='58516.Ödeme Yöntem'></td>
                    <td nowrap="nowrap"><cfif len(GET_ORDER_INFO.PAYMETHOD)>
                            <cfset attributes.paymethod_id=GET_ORDER_INFO.PAYMETHOD>
                            <cfinclude template="../query/get_paymethod.cfm">
                            <input type="hidden" name="paymethod_id" id="paymethod_id" value="<cfoutput>#GET_ORDER_INFO.PAYMETHOD#</cfoutput>">
                            <input type="hidden" name="card_paymethod_id" id="card_paymethod_id" value="">
                            <input type="hidden" name="commission_rate" id="commission_rate" value="">
                            <input type="text" name="paymethod" id="paymethod" style="width:140px;" value="<cfoutput>#GET_PAYMETHOD.paymethod#</cfoutput>" readonly>
                        <cfelseif len(GET_ORDER_INFO.card_paymethod_id)>
                            <cfquery name="get_card_paymethod" datasource="#dsn3#">
                                SELECT 
                                    CARD_NO
                                    <cfif GET_ORDER_INFO.commethod_id eq 6> <!--- WW den gelen siparişlerin guncellemesi --->
                                    ,PUBLIC_COMMISSION_MULTIPLIER AS COMMISSION_MULTIPLIER
                                    <cfelse>  <!--- EP VE PP den gelen siparişlerin guncellemesi --->
                                    ,COMMISSION_MULTIPLIER 
                                    </cfif>
                                FROM 
                                    CREDITCARD_PAYMENT_TYPE 
                                WHERE 
                                    PAYMENT_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_order_info.card_paymethod_id#">
                            </cfquery>
                            <cfoutput>
                                <input type="hidden" name="paymethod_id" id="paymethod_id" value="">
                                <input type="hidden" name="card_paymethod_id" id="card_paymethod_id" value="#GET_ORDER_INFO.card_paymethod_id#">
                                <input type="hidden" name="commission_rate" id="commission_rate" value="#get_card_paymethod.commission_multiplier#">
                                <input type="text" name="paymethod" id="paymethod" style="width:140px;" value="#get_card_paymethod.card_no#" readonly>
                            </cfoutput>
                        <cfelse>
                            <input type="hidden" name="paymethod_id" id="paymethod_id" value="">
                            <input type="hidden" name="card_paymethod_id" id="card_paymethod_id" value="">
                            <input type="hidden" name="commission_rate" id="commission_rate" value="">
                            <input type="text" name="paymethod" id="paymethod" style="width:140px;" value="" readonly>
                        </cfif>						
                        <cfset card_link="&function_name=change_paper_duedate&function_parameter=invoice_date&FIELD_DUEDAY=form_basket.basket_due_value&field_card_payment_id=form_basket.card_paymethod_id&field_card_payment_name=form_basket.paymethod&field_commission_rate=form_basket.commission_rate">
                        <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_paymethods&field_id=form_basket.paymethod_id&field_name=form_basket.paymethod#card_link#</cfoutput>','list');"> <img src="/images/plus_thin.gif" title="<cf_get_lang dictionary_id='57734.seçiniz'>"  border="0" align="absmiddle"> </a> 
                    </td>
                    <td>&nbsp;</td>
                </tr>
                <tr>
                    <td><cf_get_lang dictionary_id='57773.İrsaliye'> </td>
                    <td><input type="text" name="irsaliye" id="irsaliye" style="width:150px;" value="" readonly>
                        <cfoutput><a href="javascript://" onclick="add_irsaliye();" ><img src="/images/plus_thin.gif" title="<cf_get_lang dictionary_id='57734.seçiniz'>"  border="0" align="absmiddle"></a></cfoutput>
                    </td>
                    <td><cf_get_lang no='19.Satışı Yapan'></td>
                    <td nowrap="nowrap"><input type="hidden" name="EMPO_ID" id="EMPO_ID" value="<cfif len(get_order_info.order_employee_id)><cfoutput>#get_order_info.order_employee_id#</cfoutput></cfif>">
                        <input type="hidden" name="PARTO_ID" id="PARTO_ID">
                        <input type="text" name="PARTNER_NAMEO" id="PARTNER_NAMEO" value="<cfif len(get_order_info.order_employee_id)><cfoutput>#get_emp_info.employee_name# #get_emp_info.employee_surname#</cfoutput></cfif>" style="width:140px;" readonly>
                        <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&select_list=1&field_name=form_basket.PARTNER_NAMEO&field_id=form_basket.PARTO_ID&field_EMP_id=form_basket.EMPO_ID</cfoutput>','list');"> <img src="/images/plus_thin.gif" title="<cf_get_lang dictionary_id='57734.seçiniz'>" border="0" align="absmiddle"> </a>
                    </td>
                    <td><cf_get_lang dictionary_id ='57640.Vade'></td>
                    <td><input type="text"  name="basket_due_value"  id="basket_due_value" value="<cfif len(get_order_info.due_date) and len(get_order_info.order_date)><cfoutput>#datediff('d',get_order_info.order_date,get_order_info.due_date)#</cfoutput></cfif>"onchange="change_paper_duedate('invoice_date');" style="width:35px;">
                        <cfinput type="text" name="basket_due_value_date_" value="#dateformat(get_order_info.due_date,dateformat_style)#" onChange="change_paper_duedate('invoice_date',1);" validate="#validate_style#" message="#message#" maxlength="10" style="width:85px;" readonly>
                        <cf_wrk_date_image date_field="basket_due_value_date_">
                    </td>
                    <td><cfif session.ep.our_company_info.project_followup eq 1>
                            <cf_get_lang dictionary_id='57416.Proje'>
                         </cfif>
                    </td>
                    <td><cfif len(get_order_info.project_id)>
                            <cfquery name="get_project" datasource="#dsn#">
                                SELECT PROJECT_HEAD FROM PRO_PROJECTS WHERE PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_order_info.project_id#">
                            </cfquery>
                        </cfif>
                        <input type="hidden" name="project_id" id="project_id" value="<cfif len(get_order_info.project_id)><cfoutput>#get_order_info.project_id#</cfoutput></cfif>">
                        <input type="text" name="project_head" id="project_head" style="width:140px;" value="<cfif len(get_order_info.project_id)><cfoutput>#get_project.project_head#</cfoutput></cfif>">
                        <a href="javascript://" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_projects&project_id=form_basket.project_id&project_head=form_basket.project_head');"> <img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>
                    </td>
                    <td></td>
                </tr>
                <tr>
                    <td><cf_get_lang dictionary_id='57775.Teslim Alan'></td>
                    <td><input type="hidden" name="deliver_get_id" id="deliver_get_id" value="">
                        <input type="hidden" name="deliver_get_id_consumer" id="deliver_get_id_consumer" value="">
                        <input type="text" name="deliver_get" id="deliver_get" style="width:150px;">
                        <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_pars&select_list=2,3,4,5,6&field_name=form_basket.deliver_get&field_partner=form_basket.deliver_get_id&field_consumer=form_basket.deliver_get_id_consumer&come=stock</cfoutput>','list');"><img src="/images/plus_thin.gif" title="<cf_get_lang dictionary_id='57734.seçiniz'>" border="0" align="absmiddle"></a>						  
                    </td>
                    <td><cf_get_lang dictionary_id='57322.Satis Ortagi'></td>
                    <td><cfif len(get_order_info.sales_partner_id)>
                            <input type="hidden" name="sales_member_id" id="sales_member_id" value="<cfoutput>#get_order_info.sales_partner_id#</cfoutput>">
                            <input type="hidden" name="sales_member_type" id="sales_member_type" value="partner">
                            <input type="text" name="sales_member" id="sales_member" style="width:140px;" value="<cfoutput>#get_par_info(get_order_info.sales_partner_id,0,-1,0)#</cfoutput>">
                        <cfelseif len(get_order_info.sales_consumer_id)>
                            <input type="hidden" name="sales_member_id" id="sales_member_id" value="<cfoutput>#get_order_info.sales_consumer_id#</cfoutput>">
                            <input type="hidden" name="sales_member_type" id="sales_member_type" value="consumer">
                            <input type="text" name="sales_member" id="sales_member" style="width:140px;" value="<cfoutput>#get_cons_info(get_order_info.sales_consumer_id,0,0)#</cfoutput>">
                        <cfelse>
                            <input type="hidden" name="sales_member_id" id="sales_member_id" value="">
                            <input type="hidden" name="sales_member_type" id="sales_member_type" value="">
                            <input type="text" name="sales_member" id="sales_member" style="width:140px;" value="">
                        </cfif>
                        <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_id=form_basket.sales_member_id&field_name=form_basket.sales_member&field_type=form_basket.sales_member_type<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&select_list=2,3','list','popup_list_pars');"><img src="/images/plus_thin.gif"  align="absmiddle" border="0"></a>	
                    </td>
                    <td><cf_get_lang dictionary_id ='57248.Sevk Adresi'></td>
                    <td>
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id ='57343.Sevk adresi girmelisiniz'>!</cfsavecontent>
                        <input type="hidden" name="city_id" id="city_id" value="<cfoutput>#get_order_info.city_id#</cfoutput>">
                        <input type="hidden" name="county_id" id="county_id" value="<cfoutput>#get_order_info.county_id#</cfoutput>">
                        <input type="hidden" name="ship_address_id" id="ship_address_id" value="<cfoutput>#get_order_info.ship_address_id#</cfoutput>">
                        <input type="text" name="adres" id="adres" style="width:140px;" required="yes" message="#message#" value="<cfoutput>#get_order_info.ship_address#</cfoutput>">
                        <a href="javascript://" onclick="add_adress();"><img border="0" name="imageField2" src="/images/plus_thin.gif" align="absmiddle" ></a>
                    </td>
                    <td><cf_get_lang dictionary_id='58784.Referans'></td>
                    <td><input type="text" name="ref_no" id="ref_no" style="width:140px;" value="<cfoutput>#get_order_info.order_number#</cfoutput>"></td>
                </tr>
                <tr>
                    <cfif xml_acc_department_info>
                        <td><cf_get_lang dictionary_id='57572.Departman'></td>
                        <td>
                            <cf_wrkdepartmentbranch fieldid='acc_department_id' is_department='1' width='150' is_deny_control='0'>
                        </td>
                        <cfif xml_show_contract eq 1>
                                <td><cf_get_lang dictionary_id ='29522.Sözleşme'></td>
                                <td>
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
                                    <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_contract&field_id=form_basket.contract_id&field_name=form_basket.contract_no'</cfoutput>,'large');"><img src="/images/plus_thin.gif" align="absbottom" border="0"></a>
                                </td>
                        </cfif>
                        <td colspan="4"></td>
                    <cfelse>
                        <td colspan="6"></td>
                    </cfif>
                    <td>
                        <div id="kasa_sec_text">
                            <cfif kasa.recordcount>
                                <cf_get_lang dictionary_id='57030.Nakit Satış'><input type="checkbox" name="cash" id="cash" onclick="ayarla_gizle_goster();">
                            </cfif>
                        </div>
                    </td>
                    <td>
                        <div style="display:none;" id="kasa_sec">
                            <cfif kasa.recordcount>
                                <select name="kasa" id="kasa" style="width:140px;">
                                    <cfoutput query="kasa">
                                        <option value="#cash_id#">#cash_name# </option>
                                    </cfoutput>
                                </select>
                            </cfif>
                            <cfoutput query="kasa">
                                <input type="hidden" name="str_kasa_parasi#cash_id#" id="str_kasa_parasi#cash_id#" value="#cash_currency_id#">
                            </cfoutput>						 
                         </div>
                     </td>
                </tr>
            </table>
            <cf_basket_form_button>
                 <cfif (xml_chk_prod_w_barkod eq 1 and attributes.barkod eq 1) or xml_chk_prod_w_barkod eq 0>
                     <cf_workcube_buttons is_upd='0' add_function='kontrol()'>
                 </cfif>
            </cf_basket_form_button>
        </cf_basket_form>
        <cfset attributes.basket_id = 2>
        <cfset attributes.basket_sub_id = 7>
        <cfinclude template="../../objects/display/basket.cfm">
	</cfform>
</div>
<script type="text/javascript">
	<cfif xml_chk_prod_w_barkod eq 1 and attributes.barkod neq 1>
		windowopen('<cfoutput>#request.self#?fuseaction=invoice.popup_check_product_count&oid=#attributes.order_id#</cfoutput>','medium')
	</cfif>	
	function add_irsaliye()
	{
		if(form_basket.company_id.value.length || form_basket.consumer_id.value.length)
			{ 
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_choice_ship&id=sale&sale_product=1&company_id='+form_basket.company_id.value+'&consumer_id='+ form_basket.consumer_id.value,'page')
			return true;
			}
		else
			{
			alert("<cf_get_lang dictionary_id ='57715.Önce Üye Seçiniz'> !");
			return false;
			}
	}
	function kontrol()
	{
		<cfif xml_show_ship_date eq 1>
			if (!date_check(form_basket.invoice_date,form_basket.ship_date, "<cf_get_lang dictionary_id='57119.Fiili Sevk Tarihi, Fatura Tarihinden Önce Olamaz!'>"))
				return false;
		</cfif>
		<cfif is_referance eq 1>
			if(form_basket.ref_no.value == '')
				{
						alert("<cf_get_lang dictionary_id='59797.Referans alanı zorunludur'>!");
						return false;
				}
		</cfif>
		<cfif session.ep.our_company_info.project_followup eq 1 and isdefined("xml_upd_row_project") and xml_upd_row_project eq 1>
			apply_deliver_date('','project_head','');
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
				alert("<cf_get_lang dictionary_id='35327.Sevk Yöntemi Seçiniz'>!");
				return false;	
			}
		</cfif>	
		if (!chk_process_cat('form_basket')) return false;
		if (!check_display_files('form_basket')) return false;
		if (!chk_period(form_basket.invoice_date,"İşlem")) return false;
		if (document.form_basket.comp_name.value == ""  && document.form_basket.consumer_id.value == "" )
			{ 
			alert ("<cf_get_lang dictionary_id='57183.Cari Hesabı Seçmelisiniz !'>");
			return false;
			}
		if (document.form_basket.department_name.value == ""  && (document.form_basket.department_id.value == "" || document.form_basket.location_id.value == ""))
			{ 
			alert ("<cf_get_lang dictionary_id='57723.Önce Depo Seçmelisiniz'>!");
			return false;
			}
		<cfif isdefined('xml_acc_department_info') and xml_acc_department_info eq 2> //xmlde muhasebe icin departman secimi zorunlu ise
			if( document.form_basket.acc_department_id.options[document.form_basket.acc_department_id.selectedIndex].value=='')
			{
				alert("<cf_get_lang dictionary_id='58836.Lutfen Departman Seciniz'>");
				return false;
			} 
		</cfif>
		if (!check_accounts('form_basket')) return false;
		if (!check_product_accounts()) return false;
		//<!--- toptan satıs fat ve alım iade fat icin sıfır stok kontrolu--->
		var temp_process_cat = document.form_basket.process_cat.options[document.form_basket.process_cat.selectedIndex].value;
		if(temp_process_cat.length)
		{
			if(check_stock_action('form_basket')) //islem kategorisi stok hareketi yapıyorsa
			{
				var fis_no = eval("document.form_basket.ct_process_type_" + temp_process_cat);
				var basket_zero_stock_status = wrk_safe_query('inv_basket_zero_stock_status','dsn3',0,<cfoutput>#attributes.basket_id#</cfoutput>);
				if(basket_zero_stock_status.IS_SELECTED != 1)
				{
					if(!zero_stock_control(form_basket.department_id.value,form_basket.location_id.value,0,fis_no.value)) return false;
				}
			}
		}
		//sipariş satır kontrolü
		<cfif xml_control_ship_row eq 1>
		ship_list_ = document.getElementById('order_id').value; 
		if(ship_list_ != '')
		{
			var ship_row_list = '';
			if(form_basket.product_id.length != undefined && form_basket.product_id.length >1)
			{
				var bsk_rowCount = form_basket.product_id.length; 
				for(var str_i_row=0; str_i_row < bsk_rowCount; str_i_row++)
				{
					if(document.form_basket.product_id[str_i_row].value != '' && document.form_basket.wrk_row_relation_id[str_i_row].value == '')
					{
						ship_row_list = ship_row_list + eval(str_i_row+1) + '.Satır : ' + document.all.product_name[str_i_row].value + '\n';
					}
				}
				
			}	
			else if(document.form_basket.product_id[0] != undefined && document.form_basket.product_id[0].value!='')
			{
				if(document.form_basket.product_id[0].value != '' && document.form_basket.wrk_row_relation_id[0].value == '')
				{
					ship_row_list = ship_row_list + eval(str_i_row+1) + '.Satır : ' + document.all.product_name[0].value + '\n';
				}
			}
			else if(document.all.product_id != undefined && document.all.product_id.value != '')
			{
				if(document.form_basket.product_id.value != '' && document.form_basket.wrk_row_relation_id.value == '' )
				{
					ship_row_list = ship_row_list + eval(str_i_row+1) + '.Satır : ' + document.all.product_name.value + '\n';
				}
			}
			if(ship_row_list != '')
			{
				alert("<cf_get_lang dictionary_id='59805.Aşağıda Belirtilen Ürünler İlişkili Sipariş Dışında Eklenmiştir'>. <cf_get_lang dictionary_id='59793.Lütfen Ürünleri Kontrol Ediniz'> ! \n\n" + ship_row_list);
				return false;
			}
		}
		</cfif>
		change_paper_duedate('invoice_date');
		<cfif xml_sale_employee eq 1>
			if(document.getElementById('EMPO_ID').value == '' || document.getElementById('PARTNER_NAMEO').value == '')
			{	
				alert("<cf_get_lang dictionary_id='57321.Satis Calisani'> <cf_get_lang dictionary_id='57734.Seciniz'> !");
				return false;				
			}
		</cfif>
		saveForm();
		return false;
	}
	function ayarla_gizle_goster()
	{
		if(form_basket.cash.checked)
			kasa_sec.style.display='';
		else
			kasa_sec.style.display='none';
	}
	function kontrol_ithalat()
	{
		deger = form_basket.process_cat.options[form_basket.process_cat.selectedIndex].value;
		sistem_para_birimi = "<cfoutput>#SESSION.EP.MONEY#</cfoutput>";	
		if(deger != ""){
			var fis_no = eval("form_basket.ct_process_type_" + deger);
			if(fis_no.value == 531)
			{
				if(form_basket.cash != undefined && form_basket.cash.checked)
				{

				}
				else
				{
					if(sistem_para_birimi==document.all.basket_money.value)
					{
						alert("<cf_get_lang dictionary_id ='57344.Sistem Para Birimi ile Fatura Para Birimi İhracat Faturası için Farklı Olmalı'>!");
					}
				}
				reset_basket_kdv_rates(); //kdv oranları sıfırlanıyor dsp_basket_js_scripts te tanımlı
			}
		}
		return true;
	}	
	function kontrol_yurtdisi()
	{
		var deger = document.form_basket.process_cat.options[document.form_basket.process_cat.selectedIndex].value;
		if(deger.length)
		{
			var fis_no = eval("document.form_basket.ct_process_type_" + deger);
			if(fis_no.value == 531)
			{ 
				kasa_sec_text.style.display = 'none';
				kasa_sec.style.display='none';
				form_basket.cash.checked=false;
				reset_basket_kdv_rates(); //kdv oranları sıfırlanıyor dsp_basket_js_scripts te tanımlı
			}
			else
				kasa_sec_text.style.display = '';
		}
	}
	
	function check_process_is_sale(){/*alım iadeleri satis karakterli oldugu halde alış fiyatları ile çalışması için*/
		<cfif get_basket.basket_id is 2>
			var selected_ptype = document.form_basket.process_cat.options[document.form_basket.process_cat.selectedIndex].value;
			sale_product = 1;
			if(selected_ptype.length)
			{
				var proc_control = eval('document.form_basket.ct_process_type_'+selected_ptype+'.value');
				if(proc_control==62)
					sale_product= 0;
			}
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
				str_adrlink = '&field_long_adres=form_basket.adres';
				if(form_basket.city_id!=undefined) str_adrlink = str_adrlink+'&field_city=form_basket.city_id';
				if(form_basket.county_id!=undefined) str_adrlink = str_adrlink+'&field_county=form_basket.county_id';
				if(form_basket.ship_address_id!=undefined) str_adrlink = str_adrlink+'&field_adress_id=form_basket.ship_address_id';
				windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_member_address&is_comp=1&keyword='+encodeURIComponent(form_basket.comp_name.value)+''+ str_adrlink , 'list');
				return true;
			}
			else
			{
				str_adrlink = '&field_long_adres=form_basket.adres';
				if(form_basket.city_id!=undefined) str_adrlink = str_adrlink+'&field_city=form_basket.city_id';
				if(form_basket.county_id!=undefined) str_adrlink = str_adrlink+'&field_county=form_basket.county_id';
				if(form_basket.ship_address_id!=undefined) str_adrlink = str_adrlink+'&field_adress_id=form_basket.ship_address_id';
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
	change_paper_duedate('invoice_date');
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
