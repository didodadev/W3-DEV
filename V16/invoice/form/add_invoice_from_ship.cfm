<cf_xml_page_edit fuseact="invoice.form_add_bill_from_ship">
<cfinclude template="../query/get_session_cash.cfm">
<cfinclude template="../query/get_ship_detail.cfm">
<cfif not get_ship_detail.recordcount>
	<br/><font class="txtbold"><cf_get_lang dictionary_id='58943.Böyle Bir Kayıt Bulunmamaktadır'> !</font>
	<cfexit method="exittemplate">
</cfif>
<cfset attributes.comp_id = get_ship_detail.company_id>
<cfset attributes.cons_id = get_ship_detail.consumer_id>
<cfscript>session_basket_kur_ekle(process_type:1,table_type_id:2,to_table_type_id:1,action_id:attributes.ship_id);</cfscript>
<cfinclude template="../query/control_bill_no.cfm">
<!--- Faturaya dönüstürüldügü icin üyenin varsa fatura adresi sevk adresi olarak atanır FA--->
<cfif len(get_ship_detail.company_id)>
	<cfquery name="GET_INVOICE_ADDRESS" datasource="#DSN#">
		SELECT COMPBRANCH_ADDRESS,COMPBRANCH_POSTCODE,SEMT,COUNTY_ID,CITY_ID,COUNTRY_ID,COMPBRANCH_ID FROM COMPANY_BRANCH WHERE IS_INVOICE_ADDRESS=1 AND COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_ship_detail.company_id#">
	</cfquery>
<cfelseif len(get_ship_detail.consumer_id)>
	<cfquery name="GET_INVOICE_ADDRESS" datasource="#DSN#">
		SELECT TAX_ADRESS COMPBRANCH_ADDRESS,TAX_POSTCODE COMPBRANCH_POSTCODE,TAX_SEMT SEMT,TAX_COUNTY_ID COUNTY_ID,TAX_CITY_ID CITY_ID,TAX_COUNTRY_ID COUNTRY_ID, '' COMPBRANCH_ID FROM CONSUMER WHERE CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_ship_detail.consumer_id#">
	</cfquery>
<cfelse>
	<cfquery name="GET_INVOICE_ADDRESS" datasource="#DSN#">
		SELECT '' COMPBRANCH_ADDRESS,'' COMPBRANCH_POSTCODE,'' SEMT,'' COUNTY_ID,'' CITY_ID,'' COUNTRY_ID, '' COMPBRANCH_ID FROM EMPLOYEES WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_ship_detail.employee_id#">
	</cfquery>
</cfif>
<cfif get_invoice_address.recordcount>
	<cfif len(get_invoice_address.county_id)>
        <cfquery name="GET_COUNTY_" datasource="#DSN#">
            SELECT COUNTY_NAME FROM SETUP_COUNTY WHERE COUNTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_invoice_address.county_id#">
        </cfquery>
        <cfset county_ = get_county_.county_name>
    <cfelse>
        <cfset county_ = "">
    </cfif>
    <cfif len(get_invoice_address.city_id)>
        <cfquery name="GET_CITY_" datasource="#DSN#">
            SELECT CITY_NAME FROM SETUP_CITY WHERE CITY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_invoice_address.city_id#">
        </cfquery>
        <cfset city_ = get_city_.city_name>
    <cfelse>
        <cfset city_ = "">
    </cfif>
    <cfif len(get_invoice_address.country_id)>
        <cfquery name="GET_COUNTRY_" datasource="#DSN#">
            SELECT COUNTRY_NAME FROM SETUP_COUNTRY WHERE COUNTRY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_invoice_address.country_id#">
        </cfquery>
        <cfset country_ = get_country_.country_name>
    <cfelse>
        <cfset country_ = "">
    </cfif>
	<cfif not (isdefined("get_ship_detail.address") and len(get_ship_detail.address))>
		<cfset get_ship_detail.address = "#get_invoice_address.compbranch_address# #get_invoice_address.compbranch_postcode# #get_invoice_address.semt# #county_# #city_# #country_#">
		<cfset get_ship_detail.city_id = get_invoice_address.city_id>
		<cfset get_ship_detail.county_id = get_invoice_address.country_id>
        <cfset get_ship_detail.ship_address_id = get_invoice_address.compbranch_id>
	</cfif>
</cfif>
<cfset paper_type = 'invoice'>
<cfif isdefined('get_ship_detail.company_id') and len(get_ship_detail.company_id)>
	<cfquery name="GET_COMP_INFO" datasource="#DSN#">
		SELECT FULLNAME,USE_EFATURA,EFATURA_DATE FROM COMPANY WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_ship_detail.company_id#">
	</cfquery>
	<cfif len(get_comp_info.use_efatura) and get_comp_info.use_efatura eq 1 and datediff('d',get_comp_info.efatura_date,now()) gte 0>
		<cfset paper_type = 'e_invoice'>
	</cfif>
<cfelseif isdefined('get_ship_detail.consumer_id') and len(get_ship_detail.consumer_id)>
	<cfquery name="GET_CONS_INFO_" datasource="#DSN#">
		SELECT CONSUMER_NAME+' '+CONSUMER_SURNAME FULLNAME,USE_EFATURA,EFATURA_DATE FROM CONSUMER WHERE CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_ship_detail.consumer_id#">
	</cfquery>
	<cfif len(get_cons_info_.use_efatura) and get_cons_info_.use_efatura eq 1 and datediff('d',get_cons_info_.efatura_date,now()) gte 0>
		<cfset paper_type = 'e_invoice'>
	</cfif>
</cfif>
<table class="dph">
    <tr>
         <td class="dpht"><a href="javascript:gizle_goster_basket(sale_ship);">&raquo;</a><cf_get_lang dictionary_id='57016.Satış Faturası Ekle'></td>
    </tr>
</table>
<div id="basket_main_div">
<cfform name="form_basket" method="post" action="#request.self#?fuseaction=invoice.emptypopup_add_bill">
   <cf_basket_form id="sale_ship">
		<input type="hidden" name="form_action_address" id="form_action_address" value="<cfoutput>#listgetat(attributes.fuseaction,1,'.')#.emptypopup_add_bill</cfoutput>">
		<cf_papers paper_type="#paper_type#" form_name="form_basket" form_field="invoice_number">
		<input type="hidden" name="search_process_date" id="search_process_date" value="invoice_date">
		<cfoutput>
            <input type="hidden" name="xml_calc_due_date" id="xml_calc_due_date" value="#xml_calc_due_date#"><!--- Bazı metal firmalarında vade tarihi siparişten hesaplanıyordu , kocaerde sorun olunca xml e bağlandı action da kullanılıyor --->
            <input type="hidden" name="xml_kontrol_due_date" id="xml_kontrol_due_date" value="#xml_kontrol_due_date#">
            <input type="hidden" name="control_ship_date" id="control_ship_date" value="<cfoutput>#dateformat(get_ship_detail.ship_date,dateformat_style)#</cfoutput>">
            <input type="hidden" name="active_period" id="active_period" value="#session.ep.period_id#">
            <input type="hidden" name="commethod_id" id="commethod_id" value="<cfif len(get_ship_detail.commethod_id)>#get_ship_detail.commethod_id#</cfif>">
            <input type="hidden" name="paper" id="paper" value="<cfif isDefined('paper_number')>#paper_number#</cfif>">
            <input type="hidden" name="paper_printer_id" id="paper_printer_id" value="<cfif isDefined('paper_printer_code')>#paper_printer_code#</cfif>">
		</cfoutput>
		<cfif len(get_ship_detail.company_id)>
			<cfset member_account_code = get_company_period(get_ship_detail.company_id)>
		<cfelseif len(get_ship_detail.consumer_id)>
			<cfset member_account_code = get_consumer_period(get_ship_detail.consumer_id)>
		<cfelse>
			<cfset member_account_code = get_employee_period(get_ship_detail.employee_id)>
		</cfif>
		<input type="hidden" name="member_account_code" id="member_account_code" value="<cfoutput>#member_account_code#</cfoutput>">
        <table>
            <tr>
                <td width="70"><cf_get_lang dictionary_id='57800.işlem tipi'></td>
                <td width="175"><cf_workcube_process_cat onclick_function="kontrol_yurtdisi();"></td>
                <td width="70"><cf_get_lang dictionary_id='57637.Seri No'>*</td>
                <td width="155">
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='57184.Fatura No Girmelisiniz!'></cfsavecontent>
                    <cfif isDefined('paper_full')>
                        <cfinput type="text" name="serial_number" id="serial_number" value="#paper_code#" maxlength="5" style="width:20px;">
                        - <cfinput type="text" name="serial_no" id="serial_no" value="#paper_number#" maxlength="50" style="width:70px;" required="Yes" message="#message#" onBlur="paper_control(this,'INVOICE',true,'','','','','','',1,form_basket.serial_number);">
                    <cfelse>
                        <cfinput type="text" name="serial_number" id="serial_number" value="" maxlength="5" style="width:20px;">
                        - <cfinput type="text" name="serial_no" id="serial_no" value="" maxlength="50" style="width:70px;" required="Yes" message="#message#" onBlur="paper_control(this,'INVOICE',true,'','','','','','',1,form_basket.serial_number);">
                    </cfif>							
                </td>
                <td width="70"><cf_get_lang dictionary_id='58763.Depo'>*</td>
                <td width="170">
                    <cf_wrkdepartmentlocation 
                        returnInputValue="location_id,department_name,department_id,branch_id"
                        returnQueryValue="LOCATION_ID,LOCATION_NAME,DEPARTMENT_ID,BRANCH_ID"
                        fieldName="department_name"
                        fieldid="location_id"
                        department_fldId="department_id"
                        department_id="#get_ship_detail.deliver_store_id#"
                        location_id="#get_ship_detail.location#"
                        user_level_control="#session.ep.OUR_COMPANY_INFO.IS_LOCATION_FOLLOW#"
                        line_info = 2
                        width="150">
                </td>
                <td width="70"><cf_get_lang dictionary_id='57629.Açıklama'></td>
                <td rowspan="2" valign="top"><textarea name="note" id="note" style="width:130px;height:45px;"><cfoutput>#get_ship_detail.ship_detail#</cfoutput></textarea></td>
				<td id="add_info_plus" rowspan="6" valign="top"></td><!--- isbak için eklendi kaldırmayınız sm --->
             </tr>
             <tr>
                <td><cf_get_lang dictionary_id='57519.cari hesap'>*</td>
                <td>
                    <input type="hidden" name="company_id" id="company_id" value="<cfoutput>#get_ship_detail.company_id#</cfoutput>">
                    <input name="comp_name" id="comp_name" type="text" readonly <cfif len(get_ship_detail.company_id)>value="<cfoutput>#get_par_info(get_ship_detail.company_id,1,0,0)#</cfoutput>"</cfif> style="width:150px;">
                    <cfset str_linkeait = "&field_paymethod_id=form_basket.paymethod_id&field_paymethod=form_basket.paymethod&field_basket_due_value=form_basket.basket_due_value&field_card_payment_id=form_basket.card_paymethod_id&call_function=add_general_prom()-check_member_price_cat()">							
                    <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_pars&is_cari_action=1&select_list=2,3,1,9&field_name=form_basket.partner_name&field_partner=form_basket.partner_id&field_comp_name=form_basket.comp_name&field_emp_id=form_basket.employee_id&field_comp_id=form_basket.company_id&field_consumer=form_basket.consumer_id&field_member_account_code=form_basket.member_account_code#str_linkeait#</cfoutput>','list')">
                    <img src="/images/plus_thin.gif" title="<cf_get_lang dictionary_id='57734.seçiniz'>"  border="0" align="absmiddle"></a>
                </td>
                <td nowrap="nowrap"><cf_get_lang dictionary_id='58759.Fatura Tarihi'>*</td>
                <td>
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='57185.Fatura Tarihi Girmelisiniz !'></cfsavecontent>
                    <cfinput type="text" name="invoice_date" id="invoice_date" style="width:100px;" required="Yes" message="#message#" value="#dateformat(now(),dateformat_style)#" onChange="check_member_price_cat();" validate="#validate_style#" maxlength="10" passthrough="readonly" >
                    <cf_wrk_date_image date_field="invoice_date" call_function="change_money_info"></td>
                <td><cf_get_lang dictionary_id='29500.Sevk Yöntemi'></td>
                <td>
                    <input type="hidden" name="ship_method" id="ship_method" value="<cfoutput>#get_ship_detail.ship_method#</cfoutput>">
                    <cfif len(get_ship_detail.ship_method)>
                    	<cfset attributes.ship_method_id=get_ship_detail.ship_method>
                    	<cfinclude template="../query/get_ship_methods.cfm">
                    </cfif>
                    <input type="text" name="ship_method_name" id="ship_method_name" style="width:150px;" value="<cfif len(get_ship_detail.ship_method)><cfoutput>#ship_methods.ship_method#</cfoutput></cfif>">
                    <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_ship_methods&field_name=ship_method_name&field_id=ship_method','list');"><img src="/images/plus_thin.gif" title="<cf_get_lang dictionary_id='322.seçiniz'>"  border="0" align="absmiddle"></a>
                </td>
            </tr>
            <tr>
                <td><cf_get_lang dictionary_id='57578.Yetkili'>*</td>
                <td>
                    <input type="hidden" name="partner_id" id="partner_id" value="<cfoutput>#get_ship_detail.partner_id#</cfoutput>">
                    <input type="hidden" name="consumer_id" id="consumer_id" value="<cfoutput>#get_ship_detail.consumer_id#</cfoutput>">
					<input type="hidden" name="employee_id" id="employee_id" value="<cfoutput>#get_ship_detail.employee_id#</cfoutput>">
                    <input type="text" name="partner_name" id="partner_name" <cfif len(get_ship_detail.consumer_id)>value="<cfoutput>#get_cons_info(get_ship_detail.consumer_id,0,0)#</cfoutput>" <cfelseif len(get_ship_detail.employee_id)>value="<cfoutput>#get_emp_info(get_ship_detail.employee_id,0,0)#</cfoutput>"<cfelse>value="<cfoutput>#get_par_info(get_ship_detail.partner_id,0,0,0)#</cfoutput>"</cfif> readonly style="width:150px;">
                </td>
                <cfif xml_show_ship_date eq 1>
                        <td><cf_get_lang dictionary_id='57009.Fiili Sevk Tarihi'></td>
                        <td>
                            <cfinput type="text" name="ship_date" id="ship_date" style="width:100px;" value="#dateformat(now(),dateformat_style)#" validate="#validate_style#" maxlength="10">
                            <cf_wrk_date_image date_field="ship_date">
                        </td>
                </cfif>
                <td><cf_get_lang dictionary_id='58516.Ödeme Yöntemi'></td>
                <td>
					<cfset due_day_ = get_ship_detail.due_day>
                    <cfif len(get_ship_detail.paymethod_id)>
                        <cfset attributes.paymethod_id=get_ship_detail.paymethod_id>
                        <cfinclude template="../query/get_paymethod.cfm">							  
                        <input type="hidden" name="card_paymethod_id" id="card_paymethod_id" value="">
                        <input type="hidden" name="commission_rate" id="commission_rate" value="">
                        <input type="hidden" name="paymethod_id" id="paymethod_id" value="<cfoutput>#get_ship_detail.paymethod_id#</cfoutput>">
                        <input type="text" name="paymethod" id="paymethod" style="width:150px;" value="<cfoutput>#get_paymethod.paymethod#</cfoutput>" readonly>
                        <cfset due_day_ = get_paymethod.due_day>
                    <cfelseif len(get_ship_detail.card_paymethod_id)>
                       <cfquery name="GET_CARD_PAYMETHOD" datasource="#DSN3#">
                            SELECT 
                                CARD_NO
                                <cfif GET_SHIP_DETAIL.commethod_id eq 6> <!--- WW den gelen --->
                                	,PUBLIC_COMMISSION_MULTIPLIER AS COMMISSION_MULTIPLIER
                                <cfelse>  <!--- EP VE PP den gelen --->
                                	,COMMISSION_MULTIPLIER 
                                </cfif>
                            FROM 
                                CREDITCARD_PAYMENT_TYPE 
                            WHERE 
                                PAYMENT_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_ship_detail.card_paymethod_id#">
                        </cfquery>
                        <cfoutput>
                            <input type="hidden" name="card_paymethod_id" id="card_paymethod_id" value="#get_ship_detail.card_paymethod_id#">
                            <input type="hidden" name="commission_rate" id="commission_rate" value="#get_card_paymethod.commission_multiplier#">
                            <input type="hidden" name="paymethod_id" id="paymethod_id" value="">
                            <input type="text" name="paymethod" id="paymethod" style="width:150px;" value="#get_card_paymethod.card_no#" readonly>
                        </cfoutput>
                    <cfelse>
                        <input type="hidden" name="paymethod_id" id="paymethod_id" value="">
                        <input type="hidden" name="card_paymethod_id" id="card_paymethod_id" value="">
                        <input type="hidden" name="commission_rate" id="commission_rate" value="">
                        <input type="text" name="paymethod" id="paymethod" style="width:150px;" value="" readonly>
                    </cfif>						
                    <cfset card_link="&field_card_payment_id=form_basket.card_paymethod_id&field_card_payment_name=form_basket.paymethod&field_commission_rate=form_basket.commission_rate">
                    <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_paymethods&function_name=change_paper_duedate&function_parameter=invoice_date&field_id=form_basket.paymethod_id&field_name=form_basket.paymethod&field_dueday=form_basket.basket_due_value#card_link#</cfoutput>','list');"> <img src="/images/plus_thin.gif" title="<cf_get_lang dictionary_id='57734.seçiniz'>"  border="0" align="absmiddle"> </a> 
                </td>
                <td>
                    <cfif session.ep.our_company_info.project_followup eq 1>
                    <cf_get_lang dictionary_id='57416.Proje'>
                    </cfif>
                </td>
                <td nowrap="nowrap">
					<cfif session.ep.our_company_info.project_followup eq 1>
                        <cfif len(get_ship_detail.project_id)>
                            <cfquery name="GET_PROJECT_NAME" datasource="#DSN#">
                                SELECT PROJECT_HEAD FROM PRO_PROJECTS WHERE PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_ship_detail.project_id#">
                            </cfquery>
                        </cfif>
                        <input type="hidden" name="project_id" id="project_id" value="<cfif len(get_ship_detail.project_id)><cfoutput>#get_ship_detail.project_id#</cfoutput></cfif>">
                        <input type="text" name="project_head" id="project_head" style="width:130px;" value="<cfif len(get_ship_detail.project_id)><cfoutput>#get_project_name.project_head#</cfoutput></cfif>">
                        <a href="javascript://" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_projects&project_id=form_basket.project_id&project_head=form_basket.project_head');"> <img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>
                    </cfif>
                </td>
            </tr>
            <tr>
                <td><cf_get_lang dictionary_id='57773.İrsaliye'> </td>
                <td>
                	<input type="hidden" name="irsaliye_project_id_listesi" id="irsaliye_project_id_listesi" value="<cfif len(GET_SHIP_DETAIL.PROJECT_ID)><cfoutput>#GET_SHIP_DETAIL.PROJECT_ID#</cfoutput><cfelse>0</cfif>">
                    <input type="hidden" name="irsaliye_id_listesi" id="irsaliye_id_listesi" value="<cfoutput>#GET_SHIP_DETAIL.SHIP_ID#;#session.ep.period_id#</cfoutput>">
                    <input type="text" name="irsaliye" id="irsaliye" style="width:150px;" value="<cfoutput>#GET_SHIP_DETAIL.SHIP_NUMBER#</cfoutput>" readonly>
                    <cfoutput><a href="javascript://" onclick="add_irsaliye();" ><img src="/images/plus_thin.gif" title="<cf_get_lang dictionary_id='322.seçiniz'>" border="0" align="absmiddle"></a></cfoutput>
                </td>
                <td><cf_get_lang dictionary_id='57021.Satışı Yapan'></td>
                <td>
                    <input type="hidden" name="empo_id" id="empo_id" value="<cfif len(get_ship_detail.sale_emp)><cfoutput>#get_ship_detail.sale_emp#</cfoutput></cfif>">
                    <input type="hidden" name="parto_id" id="parto_id">
                    <input type="text" name="partner_nameo" id="partner_nameo" value="<cfif len(get_ship_detail.sale_emp)><cfoutput>#get_emp_info(get_ship_detail.sale_emp,0,0)#</cfoutput></cfif>" style="width:130px;" readonly>
                    <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&select_list=1&field_name=form_basket.partner_nameo&field_id=form_basket.parto_id&field_emp_id=form_basket.empo_id</cfoutput>','list')"> <img src="/images/plus_thin.gif" title="<cf_get_lang dictionary_id='57734.seçiniz'>"  border="0" align="absmiddle"> </a> 
                </td>
                <td>Vade</td>
                <td>
					<cfif Len(due_day_)>
                        <cfset due_value_ = DateAdd('d',due_day_,now())>
                    <cfelseif len(get_ship_detail.due_date) and len(get_ship_detail.ship_date)>
                        <cfset due_value_ = DateDiff('d',get_ship_detail.ship_date,get_ship_detail.due_date)>
                    <cfelse>
                        <cfset due_value_ = "">
                    </cfif>
                    <input name="basket_due_value" id="basket_due_value" type="text" value="<cfoutput>#due_day_#</cfoutput>" onchange="change_paper_duedate('invoice_date');" style="width:35px;">
                    <cfinput type="text" name="basket_due_value_date_" id="basket_due_value_date_" value="#dateformat(due_value_,dateformat_style)#" onChange="change_paper_duedate('invoice_date',1);" validate="#validate_style#" message="#message#" maxlength="10" style="width:85px;" readonly>
                    <cf_wrk_date_image date_field="basket_due_value_date_"> 
                </td>
                <cfif xml_show_cash_checkbox eq 1>   
                	<td nowrap="nowrap"><cf_get_lang dictionary_id='57030.Nakit Satış'><cfif kasa.recordcount><input type="Checkbox" name="cash" id="cash" onclick="ayarla_gizle_goster();"></cfif></td>
                	<td>
					<cfif kasa.recordcount><div style="display:none;" id="not"></div></cfif>
                    <cfif kasa.recordcount>
                        <div style="display:none;" id="not1">
                            <select name="kasa" id="kasa" style="width:130px;">
                                <cfoutput query="kasa">
                                    <option value="#cash_id#">#cash_name#-#cash_currency_id#</option>
                                </cfoutput>
                            </select>
							<cfoutput query="kasa">
                                <input type="hidden" name="str_kasa_parasi#cash_id#" id="str_kasa_parasi#cash_id#" value="#cash_currency_id#">
                            </cfoutput>
                        </div>
                    </cfif>
                </td>
               </cfif> 
            </tr>
            <tr>
                <td><cf_get_lang dictionary_id ='57248.Sevk Adresi'></td>
                <td>
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='57343.Sevk Adresi Girmelisiniz'>!</cfsavecontent>
                    <input type="hidden" name="city_id" id="city_id" value="<cfoutput>#get_ship_detail.city_id#</cfoutput>">
                    <input type="hidden" name="county_id" id="county_id" value="<cfoutput>#get_ship_detail.county_id#</cfoutput>">
                    <input type="hidden" name="ship_address_id" id="ship_address_id" value="<cfoutput>#get_ship_detail.ship_address_id#</cfoutput>">
                    <cfif isdefined("get_ship_detail.address")>
                    	<cfinput type="text" name="adres" id="adres" required="yes" message="#message#" value="#get_ship_detail.address#" maxlength="200" style="width:150px;">
                    <cfelse>
                    	<cfinput type="text" name="adres" id="adres" required="yes" message="#message#" value="" maxlength="200" style="width:150px;">
                    </cfif>
                    <a href="javascript://" onclick="add_adress();"><img border="0" src="/images/plus_thin.gif" align="absmiddle" ></a>
                 </td>
                <td><cf_get_lang dictionary_id='57775.Teslim Alan'></td>
                <td>
                    <cfoutput><input type="text" name="deliver_get" id="deliver_get" style="width:130px;" value="#get_ship_detail.deliver_emp#"></cfoutput>
                    <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_pars&select_list=1&field_name=form_basket.deliver_get&come=stock</cfoutput>','list');">
                    <img src="/images/plus_thin.gif" title="<cf_get_lang dictionary_id='57734.seçiniz'>"  border="0" align="absmiddle"></a>
                    <input type="hidden" name="deliver_get_id" id="deliver_get_id" value="">
                    <input type="hidden" name="deliver_get_id_consumer" id="deliver_get_id_consumer" value="">
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
                                <input type="text" name="contract_no" id="contract_no" value="" style="width:130px;">
                            </cfif>
                            <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_contract&field_id=form_basket.contract_id&field_name=form_basket.contract_no'</cfoutput>,'large');"><img src="/images/plus_thin.gif" align="absbottom" border="0"></a>
                        </td>
            	</cfif>
                <cfif xml_acc_department_info>
                	<td><cf_get_lang dictionary_id='57572.Departman'></td>
                    <td><cf_wrkdepartmentbranch fieldid='acc_department_id' is_department='1' width='150' is_deny_control='0'></td>
                </cfif>
                <td></td>
			</tr>
 			<tr>
                <td><cf_get_lang dictionary_id='57322.Satış Ortagi'></td>
                <td>
                    <input type="hidden" id="sales_member_id" name="sales_member_id" value="">
                    <input type="hidden" id="sales_member_type" name="sales_member_type" value="">
                    <input type="text" id="sales_member" name="sales_member" value="" style="width:150px;" onfocus="AutoComplete_Create('sales_member','MEMBER_NAME,MEMBER_PARTNER_NAME2','MEMBER_PARTNER_NAME2,MEMBER_NAME','get_member_autocomplete','\'1,2\',0,0','PARTNER_CODE,MEMBER_TYPE','sales_member_id,sales_member_type','form','3','250');">
                    <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&is_form_submitted=1&is_rate_select=1&field_id=form_basket.sales_member_id&field_name=form_basket.sales_member&field_type=form_basket.sales_member_type<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&select_list=2,3','list','popup_list_pars');"><img src="/images/plus_thin.gif"  align="absbottom" border="0"></a>	
                 </td>
                 <td><cf_get_lang dictionary_id='58784.Referans'></td>
                 <td><input type="text" name="ref_no" id="ref_no"  maxlength="50" value="<cfif len(get_ship_detail.ref_no)><cfoutput>#get_ship_detail.ref_no#</cfoutput></cfif>" style="width:100px;"></td>
        	     <td colspan="6"></td>
                 </tr>			
        </table>
        <cf_basket_form_button><cf_workcube_buttons is_upd='0' add_function='kontrol()'></cf_basket_form_button>
    </cf_basket_form>
	<cfset attributes.basket_id = 2>
    <cfset attributes.basket_sub_id = 2>
    <cfinclude template="../../objects/display/basket.cfm">
</cfform>
</div>

<script type="text/javascript">
	function add_irsaliye()
	{
		if(form_basket.company_id.value.length || form_basket.consumer_id.value.length)
		{ 
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_choice_ship&id=sale&sale_product=1&company_id='+document.getElementById('company_id').value+'&consumer_id='+ document.getElementById('consumer_id').value,'page')
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
		if(!paper_control(form_basket.serial_no,'INVOICE',true,'','','','','','',1,form_basket.serial_number)) return false;
		if (!chk_process_cat('form_basket')) return false;
		if(!check_display_files('form_basket')) return false;
		if (!chk_period(form_basket.invoice_date,"İşlem")) return false;
		<cfif session.ep.our_company_info.project_followup eq 1 and isdefined("xml_upd_row_project") and xml_upd_row_project eq 1>
			apply_deliver_date('','project_head','');
		</cfif>
		<cfif xml_show_ship_date eq 1>
			if (!date_check(form_basket.invoice_date,form_basket.ship_date,"Fiili Sevk Tarihi, Fatura Tarihinden Önce Olamaz!"))
				return false;
		</cfif>
		if (document.getElementById('comp_name').value == ""  && document.getElementById('consumer_id').value == "" && document.getElementById('employee_id').value == "" )
		{ 
			alert ("<cf_get_lang dictionary_id='57183.Cari Hesabı Seçmelisiniz !'>");
			return false;
		}

		if(document.getElementById('department_id').value == "" && document.getElementById('department_name').value == "")
		{
			alert("<cf_get_lang dictionary_id='57208.Departman Seçiniz'>!");
			return false;
		}

		<cfif isdefined('xml_acc_department_info') and xml_acc_department_info eq 2> //xmlde muhasebe icin departman secimi zorunlu ise
			if( document.form_basket.acc_department_id.options[document.form_basket.acc_department_id.selectedIndex].value=='')
			{
				alert("<cf_get_lang dictionary_id='58836.Lutfen Departman Seciniz'>");
				return false;
			} 
		</cfif>
		<cfif xml_control_ship_date eq 1>
			var tarih_ = document.getElementById('control_ship_date').value;
			var sonuc_ = datediff(document.getElementById('invoice_date').value,tarih_,0);
			if(sonuc_ > 0)
			{
				alert("<cf_get_lang dictionary_id='57110.Fatura Tarihi İrsaliye Tarihinden Önce Olamaz'>!");
				return false;
			}
		</cfif>
		//irsaliye satır kontrolü
		<cfif xml_control_ship_row eq 1>
			ship_list_ = document.getElementById('irsaliye_id_listesi').value; 
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
					alert("<cf_get_lang dictionary_id='59792.Aşağıda Belirtilen Ürünler İlişkili İrsaliye Dışında Eklenmiştir'>. <cf_get_lang dictionary_id='59793.Lütfen Ürünleri Kontrol Ediniz'> ! \n\n" + ship_row_list);
					return false;
				}
			}
		</cfif>
		// xml de proje kontrolleri yapılsın seçilmişse
		<cfif xml_control_ship_project eq 1>
			var irsaliye_deger_list = document.getElementById('irsaliye_project_id_listesi').value;
			if(irsaliye_deger_list != '')
			{
				var liste_uzunlugu = list_len(irsaliye_deger_list);
				for(var str_i_row=1; str_i_row <= liste_uzunlugu; str_i_row++)
				{
					var project_id_ = list_getat(irsaliye_deger_list,str_i_row,',');
					if(document.getElementById('project_id').value != '' && document.getElementById('project_head').value != '')
						var sonuc_ = document.getElementById('project_id').value;
					else
						var sonuc_ = 0;
					if(project_id_ != sonuc_)
					{
						alert("<cf_get_lang dictionary_id='57113.İlgili Faturaya Bağlı İrsaliyelerin Projeleri İle Faturada Seçilen Proje Aynı Olmalıdır'>!");
						return false;
					}
				}
			}
		</cfif>
		<cfif is_referance eq 1>
			if(form_basket.ref_no.value == '')
				{
						alert("<cf_get_lang dictionary_id='59797.Referans alanı zorunludur'>!");
						return false;
				}
		</cfif>	
		<cfif xml_paymethod_control eq 1>
			if(form_basket.paymethod.value == '' && form_basket.paymethod_id.value == '' || form_basket.paymethod.value == '' && form_basket.card_paymethod_id.value == '')
			{
				alert("<cf_get_lang dictionary_id='58027.Lütfen Ödeme Yöntemi Seçiniz'>!");
				return false;	
			}
		</cfif>
		<cfif xml_shipmethod_control eq 1>
			if(form_basket.ship_method.value == '' && form_basket.ship_method_name.value == '')
			{
				alert("<cf_get_lang dictionary_id='58027.Lütfen Sevk Yöntemi Seçiniz'>!");
				return false;	
			}
		</cfif>
		<cfsavecontent variable="message"><cf_get_lang dictionary_id='59791.Ürünler İçin Seri Numarası Girmelisiniz'>!</cfsavecontent>
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
					alert(prod_name_list + "<cfoutput>#message#</cfoutput>");
					return false;
				}
			</cfif>
		<!---Satır bazında seri girilmesi zorunluluğu kontrolü --->
		<cfif isdefined("xml_control_ship_amount") and xml_control_ship_amount eq 1>
		<cfoutput>
			var ship_product_list = '';
			var wrk_row_id_list_new = '';
			var amount_list_new = '';
			if(form_basket.product_id.length != undefined && form_basket.product_id.length >1)
			{
				var bsk_rowCount = form_basket.product_id.length;
				for(var str_i_row=0; str_i_row < bsk_rowCount; str_i_row++)
				{
					if(document.form_basket.product_id[str_i_row].value != '' && document.form_basket.wrk_row_relation_id[str_i_row].value != '' && document.form_basket.row_ship_id[str_i_row].value != '')
					{
						if(list_find(wrk_row_id_list_new,document.form_basket.wrk_row_relation_id[str_i_row].value))
						{
							row_info = list_find(wrk_row_id_list_new,document.form_basket.wrk_row_relation_id[str_i_row].value);
							amount_info = list_getat(amount_list_new,row_info);
							amount_info = parseFloat(amount_info) + parseFloat(filterNum(document.form_basket.amount[str_i_row].value));
							amount_list_new = list_setat(amount_list_new,row_info,amount_info);
						}
						else
						{
							wrk_row_id_list_new = wrk_row_id_list_new + ',' + document.form_basket.wrk_row_relation_id[str_i_row].value;
							amount_list_new = amount_list_new + ',' + filterNum(document.form_basket.amount[str_i_row].value);
						}
					}
				}
				for(var str_i_row=0; str_i_row < bsk_rowCount; str_i_row++)
				{
					if(document.form_basket.product_id[str_i_row].value != '' && document.form_basket.wrk_row_relation_id[str_i_row].value != '' && document.form_basket.row_ship_id[str_i_row].value != '')
					{
						var get_inv_control = wrk_safe_query("inv_get_inv_control","dsn2",0,document.form_basket.wrk_row_relation_id[str_i_row].value);	
						if(list_len(document.form_basket.row_ship_id[str_i_row].value,';') > 1)
						{
							new_period = list_getat(document.form_basket.row_ship_id[str_i_row].value,2,';');
							var get_period = wrk_safe_query("inv_get_period","dsn",0,new_period);
							new_dsn2 = "#dsn#"+"_"+get_period.PERIOD_YEAR+"_"+get_period.OUR_COMPANY_ID;	
						}
						else
							new_dsn2 = "#dsn2#";
						var get_ship_control = wrk_safe_query("inv_get_ship_control",new_dsn2,0, document.form_basket.wrk_row_relation_id[str_i_row].value);
						var get_ship_control2 = wrk_safe_query("inv_get_ship_control2",new_dsn2,0, document.form_basket.wrk_row_relation_id[str_i_row].value);
						ship_amount_ = parseFloat(get_ship_control.AMOUNT)-parseFloat(get_ship_control2.AMOUNT); 
						row_info = list_find(wrk_row_id_list_new,document.form_basket.wrk_row_relation_id[str_i_row].value);
						amount_info = list_getat(amount_list_new,row_info);
						var total_inv_amount = parseFloat(get_inv_control.AMOUNT)+parseFloat(amount_info);
						
						if(get_ship_control != undefined && get_ship_control.recordcount > 0 && ship_amount_ >0 && get_inv_control != undefined && get_inv_control.recordcount > 0 && total_inv_amount >0)
						{
							if(total_inv_amount > ship_amount_)
								ship_product_list = ship_product_list + eval(str_i_row+1) + '.Satır : ' + document.all.product_name[str_i_row].value + '\n';
						}
					}
				}
			}	
			else if(document.all.product_id != undefined && document.all.product_id.value != '')
			{
				if(document.form_basket.product_id.value != '' && document.form_basket.wrk_row_relation_id.value != '' && document.form_basket.row_ship_id.value != '')
				{
					var get_inv_control = wrk_safe_query("inv_get_inv_control","dsn2",0,document.form_basket.wrk_row_relation_id.value);	
					if(list_len(document.form_basket.row_ship_id.value,';') > 1)
					{
						new_period = list_getat(document.form_basket.row_ship_id.value,2,';');
						var get_period = wrk_safe_query("inv_get_period","dsn",0,new_period);
						new_dsn2 = "#dsn#"+"_"+get_period.PERIOD_YEAR+"_"+get_period.OUR_COMPANY_ID;	
					}
					else
						new_dsn2 = "#dsn2#";
					var get_ship_control = wrk_safe_query("inv_get_ship_control",new_dsn2,0,document.form_basket.wrk_row_relation_id.value);	
					var get_ship_control2 = wrk_safe_query("inv_get_ship_control2",new_dsn2,0,document.form_basket.wrk_row_relation_id.value);
					ship_amount_ = parseFloat(get_ship_control.AMOUNT)-parseFloat(get_ship_control2.AMOUNT); 
					var total_inv_amount = parseFloat(get_inv_control.AMOUNT)+parseFloat(filterNum(document.form_basket.amount.value));
					if(get_ship_control != undefined && get_ship_control.recordcount > 0 && ship_amount_ >0 && get_inv_control != undefined && get_inv_control.recordcount > 0 && total_inv_amount >0)
					{
						if(total_inv_amount > ship_amount_)
							ship_product_list = ship_product_list + eval(str_i_row+1) + '.Satır : ' + document.all.product_name.value + '\n';
					}
				}
			}
			if(ship_product_list != '')
			{
				alert("<cf_get_lang dictionary_id='57108.Aşağıda Belirtilen Ürünler İçin Toplam Fatura Miktarı İrsaliye Miktarından Fazla ! Lütfen Ürünleri Kontrol Ediniz !'> \n\n" + ship_product_list);
				return false;
			}
		</cfoutput>
		</cfif>
		if (!check_accounts('form_basket')) return false;
		if (!check_product_accounts()) return false;
		kontrol_yurtdisi();
		change_paper_duedate('invoice_date');
		return saveForm();
		return false;
		
	}
	function ayarla_gizle_goster()
	{
		if(form_basket.cash.checked) {
			not.style.display='';
			not1.style.display='';		
		}else{
			not.style.display='none';
			not1.style.display='none';
		}
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
	function kontrol_yurtdisi()
	{
		var deger = document.form_basket.process_cat.options[document.form_basket.process_cat.selectedIndex].value;
		if(deger.length)
		{
			var fis_no = eval("document.form_basket.ct_process_type_" + deger);
			if(fis_no.value == 531)
				reset_basket_kdv_rates(); //kdv oranları sıfırlanıyor dsp_basket_js_scripts te tanımlı
		}
	}
	change_paper_duedate('invoice_date');
</script>
