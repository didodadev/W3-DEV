<!--- Satınalma siparisinden fatura oluşturma ara ekranı 
sub_basket_7 vardır ve alış fat ekleme action ına gider--->
<cf_get_lang_set module_name="invoice">
<cf_xml_page_edit fuseact="invoice.add_purchase_invoice_from_order">
<cfparam name="attributes.invoice_date" default="#now()#">
<cfscript>session_basket_kur_ekle(action_id=attributes.order_id,table_type_id:3,to_table_type_id:1,process_type:1);</cfscript>
<cfquery name="GET_ORDER_INFO" datasource="#dsn3#">
	SELECT * FROM ORDERS WHERE ORDER_ID = #attributes.order_id#
</cfquery>
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
			SL.LOCATION_ID = #get_order_info.location_id# AND
			SL.DEPARTMENT_ID = #get_order_info.deliver_dept_id# AND
			SL.DEPARTMENT_ID = D.DEPARTMENT_ID
	</cfquery>
</cfif>
<cfset kontrol_status = 1>
<cfinclude template="../query/get_session_cash_all.cfm">
<cfinclude template="../query/control_bill_no.cfm">
<table class="dph">
  <tr>
      <td class="dpht"><a href="javascript:gizle_goster_basket(add_bill);">&raquo;<cf_get_lang dictionary_id='57015.Alış Faturası Ekle'></a></td>
      <td class="dphb">
     	 <cfinclude template="fatura_ara.cfm">
      </td>
  </tr>
</table>
<cf_papers paper_type="invoice" form_name="form_basket" form_field="invoice_number">
<cfset paper_number = "">
<cfset paper_code = "">
<div id="basket_main_div">
  <cfform name="form_basket" method="post" action="#request.self#?fuseaction=#fusebox.circuit#.emptypopup_add_bill_purchase">
  <cf_basket_form id="add_bill">
	<cfoutput>
    	<cfif IsDefined("attributes.is_rate_extra_cost_to_incoice")>
        	<input type="hidden" name="is_rate_extra_cost_to_incoice" id="is_rate_extra_cost_to_incoice" value="1">
        </cfif>
    	<input type="hidden" name="form_action_address" id="form_action_address" value="#listgetat(attributes.fuseaction,1,'.')#.emptypopup_add_bill_purchase">
        <input type="hidden" name="order_number" id="order_number" value="#GET_ORDER_INFO.ORDER_NUMBER#"><!---fatura kayıtları icin--->
        <input type="hidden" name="order_id" id="order_id" value="#GET_ORDER_INFO.ORDER_ID#">
        <input type="hidden" name="siparis_date_listesi" id="siparis_date_listesi" value="#dateformat(GET_ORDER_INFO.ORDER_DATE,dateformat_style)#">
        <input type="hidden" name="paper" id="paper" value="<cfif isDefined('paper_number')>#paper_number#</cfif>">
        <input type="hidden" name="active_period" id="active_period" value="#session.ep.period_id#">
        <input type="hidden" name="is_asset_transfer" id="is_asset_transfer" value="#x_is_asset_transfer#"><!--- siparisteki varliklari faturaya atar --->
    </cfoutput>
    <input type="hidden" name="search_process_date" id="search_process_date" value="invoice_date">
    <cfif len(GET_ORDER_INFO.company_id)>
        <cfset member_account_code = get_company_period(GET_ORDER_INFO.company_id)>
    <cfelse>
        <cfset member_account_code = get_consumer_period(GET_ORDER_INFO.consumer_id)>
    </cfif>
    <input type="hidden" name="member_account_code" id="member_account_code" value="<cfoutput>#member_account_code#</cfoutput>">
        <table>
        <tr>
            <td><cf_get_lang dictionary_id='57800.işlem tipi'></td>
            <td width="175"><cf_workcube_process_cat onclick_function="kontrol_yurtdisi();check_process_is_sale();"></td>
            <td><cf_get_lang dictionary_id='57637.Seri No'> *</td>
            <td width="150">
                <cfsavecontent variable="message"><cf_get_lang dictionary_id='57412.Seri No Girmelisiniz!'></cfsavecontent>
                <cfinput type="text" maxlength="5" name="serial_number" value="#paper_code#" style="width:20px;">
                - <cfinput type="text" maxlength="50" name="serial_no" value="#paper_number#" required="Yes" message="#message#" style="width:70px;" onBlur="paper_control(this,'INVOICE',false,0,'','','','','',1,form_basket.serial_number);">                    
            </td>
            <td><cf_get_lang dictionary_id='58763.Depo'>*</td>
            <td width="170" nowrap="nowrap">
              <input type="hidden" name="branch_id" id="branch_id" <cfif isdefined("get_depo_loc_info")>value="<cfoutput>#get_depo_loc_info.branch_id#</cfoutput>"</cfif>>
              <input type="hidden" name="department_id" id="department_id" <cfif isdefined("get_depo_loc_info")>value="<cfoutput>#get_depo_loc_info.department_id#</cfoutput>"</cfif>>
              <input type="hidden" name="location_id" id="location_id" <cfif isdefined("get_depo_loc_info")>value="<cfoutput>#get_depo_loc_info.location_id#</cfoutput>"</cfif>>
              <input type="text" name="department_name" id="department_name" readonly style="width:145px;" <cfif isdefined("get_depo_loc_info")>value="<cfoutput>#get_depo_loc_info.department_head# - #get_depo_loc_info.comment#</cfoutput>"</cfif>>
              <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_stores_locations&form_name=form_basket&field_location_id=location_id&field_name=department_name&field_id=department_id&branch_id=branch_id<cfif session.ep.isBranchAuthorization>&is_branch=1</cfif></cfoutput>','list');"> <img src="/images/plus_thin.gif" title="<cf_get_lang dictionary_id='57734322.seçiniz'>" border="0" align="absmiddle"> </a></td>
            <td><cf_get_lang dictionary_id='57629.Açıklama'></td>
            <td rowspan="2" valign="top"><textarea style="width:135px;height:45px;" name="note" id="note"><cfif len(GET_ORDER_INFO.ORDER_DETAIL)><cfoutput>#GET_ORDER_INFO.ORDER_DETAIL#</cfoutput></cfif></textarea></td>
			<td id="add_info_plus" rowspan="6" valign="top"></td><!--- isbak için eklendi kaldırmayınız sm --->
        </tr>
        <tr>
            <td><cf_get_lang dictionary_id='57519.cari hesap'> *</td>
            <td><input type="hidden" name="company_id" id="company_id" value="<cfoutput>#GET_ORDER_INFO.COMPANY_ID#</cfoutput>">
                <input  name="comp_name" id="comp_name" type="text" readonly <cfif len(GET_ORDER_INFO.COMPANY_ID)>value="<cfoutput>#get_par_info(GET_ORDER_INFO.COMPANY_ID,1,0,0)#</cfoutput>"</cfif> style="width:150px;">
                <cfset str_linkeait = "&field_paymethod_id=form_basket.paymethod_id&field_paymethod=form_basket.paymethod&field_basket_due_value=form_basket.basket_due_value&field_card_payment_id=form_basket.card_paymethod_id&call_function=add_general_prom()">							
                <cfif xml_show_ship_address eq 1><cfset str_linkeait= str_linkeait&"&field_long_address=form_basket.ship_address&field_city_id=form_basket.ship_address_city_id&field_county_id=form_basket.ship_address_county_id&field_adress_id=form_basket.ship_address_id"></cfif>
                <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_pars&select_list=2,3&field_name=form_basket.partner_name&field_partner=form_basket.partner_id&field_comp_name=form_basket.comp_name&field_comp_id=form_basket.company_id&field_consumer=form_basket.consumer_id&field_member_account_code=form_basket.member_account_code#str_linkeait#<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif></cfoutput>','list')">
                <img src="/images/plus_thin.gif" title="<cf_get_lang dictionary_id='57734.seçiniz'>"  border="0" align="absmiddle"></a>
            </td>
            <td><cf_get_lang dictionary_id='58759.Fatura Tarihi'>*</td>
            <td><cfsavecontent variable="message"><cf_get_lang dictionary_id='57185.Fatura Tarihi Girmelisiniz !'></cfsavecontent>
              <cfinput type="text" name="invoice_date" style="width:100px;" required="Yes" message="#message#" value="#dateformat(attributes.invoice_date,dateformat_style)#" validate="#validate_style#" maxlength="10" readonly="yes">
              <cf_wrk_date_image date_field="invoice_date" call_function="add_general_prom&change_money_info"></td>
            <td><cf_get_lang dictionary_id='29500.Sevk Yöntemi'></td>
            <td>
              <input type="hidden" name="ship_method" id="ship_method" value="<cfoutput>#GET_ORDER_INFO.SHIP_METHOD#</cfoutput>">
              <cfif len(GET_ORDER_INFO.ship_method)>
                <cfset attributes.ship_method_id=GET_ORDER_INFO.ship_method>
                <cfinclude template="../query/get_ship_methods.cfm">
              </cfif>
              <input type="text" name="ship_method_name" id="ship_method_name" style="width:145px;" value="<cfif len(GET_ORDER_INFO.ship_method)><cfoutput>#ship_methods.ship_method#</cfoutput></cfif>">
              <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_ship_methods&field_name=ship_method_name&field_id=ship_method','list');"><img src="/images/plus_thin.gif" title="<cf_get_lang dictionary_id='57734.seçiniz'>"  border="0" align="absmiddle"></a>
            </td>
            <td>&nbsp;</td>
        </tr>
        <tr>
			<cfoutput>
            <td><cf_get_lang dictionary_id='57578.Yetkili'>*</td>
            <td>
                <input type="hidden" name="partner_id" id="partner_id" value="<cfoutput>#GET_ORDER_INFO.PARTNER_ID#</cfoutput>">
                <input type="hidden" name="consumer_id" id="consumer_id" value="<cfoutput>#GET_ORDER_INFO.CONSUMER_ID#</cfoutput>">
                <input type="hidden" name="employee_id" id="employee_id" value="<cfoutput>#GET_ORDER_INFO.EMPLOYEE_ID#</cfoutput>">
                <input type="text" name="partner_name" id="partner_name" <cfif len(GET_ORDER_INFO.CONSUMER_ID)>value="<cfoutput>#get_cons_info(GET_ORDER_INFO.CONSUMER_ID,0,0)#</cfoutput>"<cfelse>value="<cfoutput>#get_par_info(GET_ORDER_INFO.PARTNER_ID,0,0,0)#</cfoutput>"</cfif> readonly style="width:150px;">
            </td>
            </cfoutput>
            <td><cf_get_lang dictionary_id='58784.Referans'></td>
            <td><input type="text" name="ref_no" id="ref_no" style="width:100px;" value="<cfoutput>#get_order_info.order_number#</cfoutput>"></td>					  
            <td><cf_get_lang dictionary_id='58516.Ödeme Yöntem'></td>
            <td>
                <cfif len(GET_ORDER_INFO.PAYMETHOD)>
                    <cfset attributes.paymethod_id=GET_ORDER_INFO.PAYMETHOD>
                    <cfinclude template="../query/get_paymethod.cfm">
                    <input type="hidden" name="paymethod_id" id="paymethod_id" value="<cfoutput>#GET_ORDER_INFO.PAYMETHOD#</cfoutput>">
                    <input type="hidden" name="card_paymethod_id" id="card_paymethod_id" value="">
                    <input type="hidden" name="commission_rate" id="commission_rate" value="">
                    <input type="text" name="paymethod" id="paymethod" style="width:145px;" value="<cfoutput>#GET_PAYMETHOD.paymethod#</cfoutput>" readonly>
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
                            PAYMENT_TYPE_ID=#GET_ORDER_INFO.card_paymethod_id#
                    </cfquery>
                    <cfoutput>
                        <input type="hidden" name="paymethod_id" id="paymethod_id" value="">
                        <input type="hidden" name="card_paymethod_id" id="card_paymethod_id" value="#GET_ORDER_INFO.card_paymethod_id#">
                        <input type="hidden" name="commission_rate" id="commission_rate" value="#get_card_paymethod.commission_multiplier#">
                        <input type="text" name="paymethod" id="paymethod" style="width:145px;" value="#get_card_paymethod.card_no#" readonly>
                    </cfoutput>
                <cfelse>
                    <input type="hidden" name="paymethod_id" id="paymethod_id" value="">
                    <input type="hidden" name="card_paymethod_id" id="card_paymethod_id" value="">
                    <input type="hidden" name="commission_rate" id="commission_rate" value="">
                    <input type="text" name="paymethod" id="paymethod" style="width:145px;" value="" readonly>
                </cfif>					
                <cfset card_link="&FIELD_DUEDAY=form_basket.basket_due_value&field_card_payment_id=form_basket.card_paymethod_id&field_card_payment_name=form_basket.paymethod&field_commission_rate=form_basket.commission_rate">
                <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_paymethods&function_name=change_paper_duedate&function_parameter=invoice_date&field_id=form_basket.paymethod_id&field_name=form_basket.paymethod#card_link#</cfoutput>','list');"> <img src="/images/plus_thin.gif" title="<cf_get_lang dictionary_id='57734.seçiniz'>"  border="0" align="absmiddle"> </a> 
            </td>
            <td><cfif session.ep.our_company_info.project_followup eq 1>
             		<cf_get_lang dictionary_id='57416.Proje'>
           	    </cfif>
            </td>
            <td>
				<cfif len(get_order_info.project_id)>
                <cfquery name="get_project" datasource="#dsn#">
                    SELECT PROJECT_HEAD FROM PRO_PROJECTS WHERE PROJECT_ID = #get_order_info.project_id#
                </cfquery>
                </cfif>
                <cfif session.ep.our_company_info.project_followup eq 1>
                  <input type="hidden" name="project_id" id="project_id" value="<cfif len(get_order_info.project_id)><cfoutput>#get_order_info.project_id#</cfoutput></cfif>">
                  <input type="text" name="project_head" id="project_head" style="width:135px;" value="<cfif len(get_order_info.project_id)><cfoutput>#get_project.project_head#</cfoutput></cfif>">
                  <a href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_projects&project_id=form_basket.project_id&project_head=form_basket.project_head');"> <img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>
                </cfif>  
            </td>
        </tr>
        <tr>
            <td><cf_get_lang dictionary_id='57773.İrsaliye'> </td>
            <td>
                <input type="text" name="irsaliye" id="irsaliye" style="width:150px;" value="" readonly>
                <cfoutput><a href="javascript://" onClick="add_irsaliye();" ><img src="/images/plus_thin.gif" title="<cf_get_lang dictionary_id='57734.seçiniz'>"  border="0" align="absmiddle"></a></cfoutput>
            <td><cf_get_lang_main no='2214.Satın Alan'></td>
            <td><input type="hidden" name="EMPO_ID" id="EMPO_ID" value="<cfif len(get_order_info.order_employee_id)><cfoutput>#get_order_info.order_employee_id#</cfoutput></cfif>">
                <input type="hidden" name="PARTO_ID" id="PARTO_ID">
                <input type="text" name="PARTNER_NAMEO" id="PARTNER_NAMEO" value="<cfif len(get_order_info.order_employee_id)><cfoutput>#get_emp_info(get_order_info.order_employee_id,0,0)#</cfoutput></cfif>" style="width:130px;" readonly>
                <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&select_list=1&field_name=form_basket.PARTNER_NAMEO&field_id=form_basket.PARTO_ID&field_EMP_id=form_basket.EMPO_ID</cfoutput>','list');"> <img src="/images/plus_thin.gif" title="<cf_get_lang dictionary_id='57734.seçiniz'>" border="0" align="absmiddle"> </a>					    </td>
            <td><cf_get_lang dictionary_id ='57640.Vade'></td>
            <td><input name="basket_due_value" id="basket_due_value" type="text"value="<cfif len(get_order_info.due_date) and len(get_order_info.order_date)><cfoutput>#datediff('d',get_order_info.order_date,get_order_info.due_date)#</cfoutput></cfif>" onChange="change_paper_duedate('invoice_date');" style="width:35px;">
                <cfinput type="text" name="basket_due_value_date_" value="#dateformat(get_order_info.due_date,dateformat_style)#" onChange="change_paper_duedate('invoice_date',1);" validate="#validate_style#" message="#message#" maxlength="10" style="width:85px;" readonly>
                <cf_wrk_date_image date_field="basket_due_value_date_"> 
            </td>
            <cfif xml_show_cash_checkbox eq 1>
                <td>
                    <div id="kasa_sec_text">
                        <cfif kasa.recordcount>
                            <cf_get_lang dictionary_id='57163.Nakit Alış'><input type="checkbox" name="cash" id="cash" onClick="ayarla_gizle_goster();">
                        </cfif>
                    </div>
                </td>
                <td id="cash_">
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
            </cfif>
        </tr>
        <tr>
            <td><cf_get_lang dictionary_id='57775.Teslim Alan'></td>
            <td><input type="hidden" name="deliver_get_id" id="deliver_get_id"  value="">
                <input type="hidden" name="deliver_get_id_consumer" id="deliver_get_id_consumer" value="">
                <input type="text" name="deliver_get" id="deliver_get" style="width:150px;">
                <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_pars&select_list=2,3,4,5,6&field_name=form_basket.deliver_get&field_partner=form_basket.deliver_get_id&field_consumer=form_basket.deliver_get_id_consumer&come=stock</cfoutput>','list');"><img src="/images/plus_thin.gif" title="<cf_get_lang dictionary_id='57734.seçiniz'>" border="0" align="absmiddle"></a>						  
            </td>
			<cfif xml_show_ship_address eq 1>
                <cfoutput>
                        <td><cf_get_lang dictionary_id='29462.Yükleme Yeri'></td>
                        <td>
                            <!--- Uye Bilgilerinden gelindiginde teslim yeri alaninin dolu gelmesi icin eklendi --->
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
                            <input type="hidden" name="ship_address_city_id" id="ship_address_city_id" value="<cfif isdefined('attributes.ship_city_id') and len(attributes.ship_city_id)>#attributes.ship_city_id#</cfif>">
                            <input type="hidden" name="ship_address_county_id" id="ship_address_county_id" value="<cfif isDefined("attributes.ship_address_county_id") and len(attributes.ship_address_county_id)>#attributes.ship_address_county_id#</cfif>">
                            <input type="hidden" name="deliver_comp_id" id="deliver_comp_id" value="<cfif isdefined('attributes.deliver_comp_id') and len(attributes.deliver_comp_id)>#attributes.deliver_comp_id#</cfif>">
                            <input type="hidden" name="deliver_cons_id" id="deliver_cons_id" value="<cfif isDefined("attributes.deliver_cons_id") and len(attributes.deliver_cons_id)>#attributes.deliver_cons_id#</cfif>">
                            <input type="hidden" name="ship_address_id" id="ship_address_id" value="<cfif isdefined('attributes.ship_address_id_') and len(attributes.ship_address_id_)>#attributes.ship_address_id_#</cfif>">
                            <input type="text" name="ship_address" id="ship_address" style="width:130px;" maxlength="200" value="<cfif isdefined('address_') and len(address_)>#address_#</cfif>">
                            <a href="javascript://" onclick="add_adress_ins_loc();"><img border="0" name="imageField2" src="/images/plus_thin.gif" align="absmiddle" ></a>
                        </td>
                </cfoutput>
            </cfif>
            <cfif xml_show_contract eq 1>
                            <td><cf_get_lang dictionary_id='29522.Sözleşme'></td>
                            <td>
                                <cfif isdefined('attributes.progress_id') and len(attributes.progress_id)>
                                    <input type="hidden" name="progress_id" id="progress_id" value="<cfoutput>#attributes.progress_id#</cfoutput>">
                                </cfif> 
                                <cfif isdefined('attributes.contract_id') and len(attributes.contract_id)>
                                    <cfquery name="getContract" datasource="#dsn3#">
                                        SELECT CONTRACT_HEAD FROM RELATED_CONTRACT WHERE CONTRACT_ID = #attributes.contract_id#
                                    </cfquery>
                                    <input type="hidden" name="contract_id" id="contract_id" value="<cfif len(attributes.contract_id)><cfoutput>#attributes.contract_id#</cfoutput></cfif>"> 
                                    <input type="text" name="contract_no" id="contract_no" value="<cfif len(attributes.contract_id)><cfoutput>#getContract.contract_head#</cfoutput></cfif>" style="width:135px;">
                                <cfelse>
                                    <input type="hidden" name="contract_id" id="contract_id" value=""> 
                                    <input type="text" name="contract_no" id="contract_no" value="" style="width:135px;">
                                </cfif>
                                <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_contract&field_id=form_basket.contract_id&field_name=form_basket.contract_no'</cfoutput>,'large');"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>
                            </td>
                        </td>
                    </cfif>
        </tr>
        </table>
        <cf_basket_form_button><cf_workcube_buttons is_upd='0' add_function='kontrol()'></cf_basket_form_button>
    </cf_basket_form>
	<cfset attributes.basket_id = 1>
    <cfset attributes.basket_sub_id = 7>
    <cfinclude template="../../objects/display/basket.cfm">
 </cfform>
</div>
<script type="text/javascript">
function add_irsaliye()
{
	if(form_basket.company_id.value.length || form_basket.consumer_id.value.length)
		{ 
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_choice_ship&id=sale&sale_product=0&company_id='+form_basket.company_id.value+'&consumer_id='+ form_basket.consumer_id.value,'page')
		return true;
		}
	else
		{
		alert("<cf_get_lang dictionary_id='57715.Önce Üye Seçiniz'>!");
		return false;
		}
}
function kontrol()
{
	if (!chk_process_cat('form_basket')) return false;
	if(!check_display_files('form_basket')) return false;
	if(!kontrol_ithalat()) return false;
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
	
	if (!check_accounts('form_basket')) return false;
	if (!check_product_accounts()) return false;
	<!---Satır bazında seri girilmesi zorunluluğu kontrolü --->
	<cfif isdefined("xml_serialno_control") and (xml_serialno_control eq 1)>
		prod_name_list = '';
		for(var str=0; str < window.basket.items.length; str++)
		{
			if(window.basket.items[str].PRODUCT_ID != '')
			{
				wrk_row_id_ = window.basket.items[str].WRK_ROW_ID;
				console.log(window.basket.items[str].AMOUNT);
				amount_ = window.basket.items[str].AMOUNT;
				product_serial_control = wrk_safe_query("chk_product_serial1",'dsn3',0, window.basket.items[str].PRODUCT_ID);
				str1_ = "SELECT SERIAL_NO FROM SERVICE_GUARANTY_NEW WHERE WRK_ROW_ID = '"+ wrk_row_id_ +"'";
				var get_serial_control = wrk_query(str1_,'dsn3');
				if(product_serial_control.IS_SERIAL_NO=='1'&&get_serial_control.recordcount!=amount_)
				{
					prod_name_list = prod_name_list + eval(str +1) + '.Satır : ' + window.basket.items[str].PRODUCT_NAME + '\n';
				}
			}
		}
		if(prod_name_list!='')
		{
			alert(prod_name_list + "<cf_get_lang dictionary_id='59791.Ürünler İçin Seri Numarası Girmelisiniz'>!");
			return false;
		}
	</cfif>
	<!---Satır bazında seri girilmesi zorunluluğu kontrolü --->
	<cfif xml_paymethod_control>
		if(form_basket.paymethod.value == '' && form_basket.paymethod_id.value == '' || form_basket.paymethod.value == '' && form_basket.card_paymethod_id.value == '')
		{
			alert("<cf_get_lang dictionary_id='58027.Ödeme Yöntemi Seçiniz'>!");
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
	<cfif isdefined("xml_upd_row_project") and xml_upd_row_project eq 1 and session.ep.our_company_info.project_followup eq 1>
		apply_deliver_date('','project_head','');
	</cfif>
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
	//<!--- toptan satıs fat ve alım iade fat icin sıfır stok kontrolu--->
	var temp_process_cat = document.form_basket.process_cat.options[document.form_basket.process_cat.selectedIndex].value;
	change_paper_duedate('invoice_date');
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
				kasa_sec_text.style.display = 'none';
				if(form_basket.cash != undefined)
					form_basket.cash.checked=false;
			</cfif>
			reset_basket_kdv_rates(); //kdv oranları sıfırlanıyor dsp_basket_js_scripts te tanımlı
		}
		else
		{
			<cfif xml_show_cash_checkbox eq 1>
				kasa_sec_text.style.display = '';
				kasa_sec.style.display = '';
			</cfif>	
		}
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

function add_adress_ins_loc()
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
		alert("<cf_get_lang dictionary_id ='58965.Önce Cari Hesap Seçiniz'>");
		return false;
	}
}

function add_adress()//neden var?
{
		if(!(form_basket.company_id.value=="") || !(form_basket.consumer_id.value==""))
	{
		if(form_basket.company_id.value!="")
		{
			str_adrlink = '&field_long_adres=form_basket.adres';
			if(form_basket.city_id!=undefined) str_adrlink = str_adrlink+'&field_city=form_basket.city_id';
			if(form_basket.county_id!=undefined) str_adrlink = str_adrlink+'&field_county=form_basket.county_id';
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_member_address&is_comp=1&keyword='+encodeURIComponent(form_basket.comp_name.value)+''+ str_adrlink , 'list');
			return true;
		}
		else
		{
			str_adrlink = '&field_long_adres=form_basket.adres';
			if(form_basket.city_id!=undefined) str_adrlink = str_adrlink+'&field_city=form_basket.city_id';
			if(form_basket.county_id!=undefined) str_adrlink = str_adrlink+'&field_county=form_basket.county_id';
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
