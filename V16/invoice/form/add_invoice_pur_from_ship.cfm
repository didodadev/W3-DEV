<cf_xml_page_edit fuseact="invoice.form_add_bill_purchase_from_ship">
<cfscript>session_basket_kur_ekle(process_type:1,table_type_id:2,to_table_type_id:1,action_id:attributes.SHIP_ID);</cfscript>
<cfinclude template="../query/get_session_cash.cfm">
<cfinclude template="../query/get_ship_detail.cfm">
<cfif not get_ship_detail.recordcount>
	<br/><font class="txtbold"><cf_get_lang dictionary_id='58943.Böyle Bir Kayıt Bulunmamaktadır'> !</font>
	<cfexit method="exittemplate">
</cfif>
<cfinclude template="../query/control_bill_no.cfm">
<table class="dph">
    <tr>
       <td class="dpht"><a href="javascript:gizle_goster_basket(from_ship);">&raquo;</a><cf_get_lang dictionary_id='57015.Alış Faturası Ekle'></td>
    </tr>
</table>
<div id="basket_main_div">
<cfform name="form_basket" method="post" action="#request.self#?fuseaction=invoice.emptypopup_add_bill_purchase">
	<cf_basket_form id="from_ship">
    	<cfoutput>
        	<input type="hidden" name="form_action_address" id="form_action_address" value="#listgetat(attributes.fuseaction,1,'.')#.emptypopup_add_bill_purchase">
            <input type="hidden" name="control_ship_date" id="control_ship_date" value="#dateformat(get_ship_detail.ship_date,dateformat_style)#">
            <input type="hidden" name="active_period" id="active_period" value="#session.ep.period_id#">
            <input type="hidden" name="search_process_date" id="search_process_date" value="invoice_date">
            <input type="hidden" name="member_account_code" id="member_account_code" <cfif len(GET_SHIP_DETAIL.CONSUMER_ID)>value="#GET_CONSUMER_PERIOD(GET_SHIP_DETAIL.CONSUMER_ID)#"<cfelseif len(GET_SHIP_DETAIL.COMPANY_ID)>value="#GET_COMPANY_PERIOD(GET_SHIP_DETAIL.COMPANY_ID)#" <cfelse>value="#GET_EMPLOYEE_PERIOD(GET_SHIP_DETAIL.EMPLOYEE_ID)#"</cfif>>
       	</cfoutput>
         <table>
              <tr>
                <td width="70"><cf_get_lang dictionary_id='57800.işlem tipi'></td>
                <td width="175"><cf_workcube_process_cat></td>
                <td width="75"><cf_get_lang dictionary_id='57637.Seri No'> *</td>
                <td width="155">
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='57412.Seri No Girmelisiniz!'></cfsavecontent>
                    <cfinput type="text" name="serial_number" id="serial_number" value="#get_ship_detail.serial_number#" maxlength="5" style="width:20px;">
                    - <cfinput type="text" name="serial_no" id="serial_no" value="#get_ship_detail.ship_number#" style="width:70px;" required="Yes" maxlength="50" message="#message#" onBlur="paper_control(this,'INVOICE',false,0,'#GET_SHIP_DETAIL.SHIP_NUMBER#',form_basket.company_id.value,form_basket.consumer_id.value,'','',1,form_basket.serial_number);">
                </td>
                <td width="75"><cf_get_lang dictionary_id='58763.Depo'>*</td>
                <td width="175">
                    <cf_wrkdepartmentlocation 
                        returnInputValue="location_id,department_name,department_id,branch_id"
                        returnQueryValue="LOCATION_ID,LOCATION_NAME,DEPARTMENT_ID,BRANCH_ID"
                        fieldName="department_name"
                        fieldid="location_id"
                        department_fldId="department_id"
                        department_id="#get_ship_detail.department_in#"
                        location_id="#get_ship_detail.location_in#"
                        user_level_control="#session.ep.OUR_COMPANY_INFO.IS_LOCATION_FOLLOW#"
                        line_info = 2
                        width="150">
					<!---<cfif len(get_ship_detail.department_in)>
						<cfset attributes.department_id = get_ship_detail.department_in>
                        <cfinclude template="../query/get_dept_name.cfm" >
                        <cfset txt_department_name = get_dept_name.DEPARTMENT_HEAD >
						<cfif len(GET_SHIP_DETAIL.LOCATION_IN) >
	                        <cfset attributes.location_id = GET_SHIP_DETAIL.LOCATION_IN >
                        <cfinclude template="../query/get_location_name.cfm" >
    	                    <cfset txt_department_name = txt_department_name & "-" & get_location_name.COMMENT >
                        </cfif>
                    <cfelse>
                    <cfset txt_department_name="">
                    </cfif>
                    <input type="hidden" name="department_id" id="department_id" value="<cfoutput>#GET_SHIP_DETAIL.DEPARTMENT_IN#</cfoutput>">
                    <input type="hidden" name="location_id" id="location_id" value="<cfoutput>#GET_SHIP_DETAIL.LOCATION_IN#</cfoutput>">
                    <input type="hidden" name="branch_id" id="branch_id" value="<cfif len(GET_SHIP_DETAIL.DEPARTMENT_IN)><cfoutput>#get_dept_name.BRANCH_ID#</cfoutput></cfif>"> 
                    <cfsavecontent variable="message"><cf_get_lang no='184.Depo Girmelisiniz !'></cfsavecontent>
                    <cfinput type="Text"  style="width:150px;" name="department_name"  value="#txt_department_name#" required="yes" message="#message#">
                    <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_stores_locations&form_name=form_basket&field_name=department_name&field_id=department_id&field_location_id=location_id</cfoutput>','list')"><img src="/images/plus_thin.gif" title="<cf_get_lang_main no='322.seçiniz'>" border="0" align="absmiddle"></a>--->
				</td>
                <td width="70"><cf_get_lang dictionary_id='57629.Açıklama'></td>
                <td rowspan="2" valign="top"><textarea name="note" id="note" style="width:130px;height:45px;"><cfif len(get_ship_detail.ship_detail)><cfoutput>#get_ship_detail.ship_detail#</cfoutput></cfif></textarea></td>
				<td id="add_info_plus" rowspan="6" valign="top"></td><!--- isbak için eklendi kaldırmayınız sm --->
            </tr>
            <tr>
                <td><cf_get_lang dictionary_id='57519.cari hesap'>*</td>
                <td>
                    <input type="hidden" name="company_id" id="company_id" value="<cfoutput>#get_ship_detail.company_id#</cfoutput>">
                    <input  name="comp_name" id="comp_name" type="text" readonly <cfif len(get_ship_detail.company_id)>value="<cfoutput>#get_par_info(get_ship_detail.company_id,1,0,0)#</cfoutput>"</cfif> style="width:150px;">
                    <cfset str_linkeait="&field_paymethod_id=form_basket.paymethod_id&field_paymethod=form_basket.paymethod&field_basket_due_value=form_basket.basket_due_value&field_card_payment_id=form_basket.card_paymethod_id&call_function=add_general_prom()">
                    <cfif xml_show_ship_address eq 1><cfset str_linkeait= str_linkeait&"&field_long_address=form_basket.ship_address&field_city_id=form_basket.ship_address_city_id&field_county_id=form_basket.ship_address_county_id&field_adress_id=form_basket.ship_address_id"></cfif>
                    <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_pars&is_cari_action=1&select_list=2,3,1,9&field_name=form_basket.partner_name&field_partner=form_basket.partner_id&field_comp_name=form_basket.comp_name&field_emp_id=form_basket.employee_id&field_comp_id=form_basket.company_id&field_consumer=form_basket.consumer_id&field_member_account_code=form_basket.member_account_code#str_linkeait#</cfoutput>','list')">
                    <img src="/images/plus_thin.gif" title="<cf_get_lang dictionary_id='57734.seçiniz'>" border="0" align="absmiddle"></a>                        
                </td>
                <td><cf_get_lang dictionary_id='58759.Fatura Tarihi'>*</td>
                <td>
	                <cfsavecontent variable="message"><cf_get_lang dictionary_id='57185.Fatura Tarihi Girmelisiniz !'></cfsavecontent>
                    <cfinput type="text" name="invoice_date" id="invoice_date" style="width:100px;" required="Yes" message="#message#" value="#dateformat(now(),dateformat_style)#" onChange="change_paper_duedate('invoice_date');" validate="#validate_style#" maxlength="10" passthrough="readonly">
                    <cf_wrk_date_image date_field="invoice_date" call_function="change_money_info">
                </td>
                <td><cf_get_lang dictionary_id='29500.Sevk Yöntemi'></td>
                <td>
                    <input type="hidden" name="ship_method" id="ship_method" value="<cfoutput>#get_ship_detail.ship_method#</cfoutput>">
                    <cfif len(GET_SHIP_DETAIL.ship_method)>
                    	<cfset attributes.ship_method_id=GET_SHIP_DETAIL.ship_method>
                    	<cfinclude template="../query/get_ship_methods.cfm">
                    </cfif>
                    <input type="text" name="ship_method_name" id="ship_method_name" style="width:150px;" value="<cfif len(get_ship_detail.ship_method)><cfoutput>#ship_methods.ship_method#</cfoutput></cfif>">
                    <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_ship_methods&field_name=ship_method_name&field_id=ship_method','list');"><img src="/images/plus_thin.gif" title="<cf_get_lang dictionary_id='57734.seçiniz'>"  border="0" align="absmiddle"></a>						
                </td>
            </tr>
            <tr>
                <td><cf_get_lang dictionary_id='57578.Yetkili'>*</td>
                <td>
                    <input type="hidden" name="partner_id" id="partner_id" value="<cfoutput>#GET_SHIP_DETAIL.PARTNER_ID#</cfoutput>">
                    <input type="hidden" name="consumer_id" id="consumer_id" value="<cfoutput>#GET_SHIP_DETAIL.CONSUMER_ID#</cfoutput>">
                    <input type="hidden" name="employee_id" id="employee_id" value="<cfoutput>#GET_SHIP_DETAIL.EMPLOYEE_ID#</cfoutput>">
                    <cfif len(get_ship_detail.consumer_id)>
                        <cfquery name="GET_REF_CODE" datasource="#DSN#">
                            SELECT CONSUMER_REFERENCE_CODE FROM CONSUMER WHERE CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_ship_detail.consumer_id#">
                        </cfquery>
                    </cfif>
                    <input type="hidden" name="consumer_reference_code" id="consumer_reference_code" value="<cfif len(get_ship_detail.consumer_id)><cfoutput>#get_ref_code.consumer_reference_code#</cfoutput></cfif>">
                    <input type="text" name="partner_name" id="partner_name" <cfif len(get_ship_detail.consumer_id)>value="<cfoutput>#get_cons_info(get_ship_detail.consumer_id,0,0)#</cfoutput>" <cfelseif len(get_ship_detail.employee_id)>value="<cfoutput>#get_emp_info(get_ship_detail.employee_id,0,0)#</cfoutput>" <cfelse>value="<cfoutput>#get_par_info(get_ship_detail.partner_id,0,0,0)#</cfoutput>"</cfif> readonly style="width:150px;">						
                </td>
                <td><cf_get_lang dictionary_id='58784.Referans'></td>
                <td><input type="text" name="ref_no" id="ref_no"  maxlength="500" value="<cfif len(get_ship_detail.ref_no)><cfoutput>#get_ship_detail.ref_no#</cfoutput></cfif>" style="width:100px;"></td>
                <td><cf_get_lang dictionary_id='58516.Ödeme Yöntem'></td>
                <td>
                    <cfset due_day_ = "">
                    <cfif len(get_ship_detail.paymethod_id)>
                        <cfset attributes.paymethod_id=get_ship_detail.paymethod_id>
                        <cfinclude template="../query/get_paymethod.cfm">
                        <input type="hidden" name="paymethod_id" id="paymethod_id" value="<cfoutput>#get_ship_detail.paymethod_id#</cfoutput>">
                        <input type="hidden" name="card_paymethod_id" id="card_paymethod_id" value="">
                        <input type="hidden" name="commission_rate" id="commission_rate" value="">
                        <input type="text" name="paymethod" id="paymethod" style="width:150px;" value="<cfoutput>#get_paymethod.paymethod#</cfoutput>" readonly>
                        <!---<cfset due_day_ = GET_PAYMETHOD.due_day>--->
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
                            <input type="hidden" name="paymethod_id" id="paymethod_id" value="">
                            <input type="hidden" name="card_paymethod_id" id="card_paymethod_id" value="#get_ship_detail.card_paymethod_id#">
                            <input type="hidden" name="commission_rate" id="commission_rate" value="#get_card_paymethod.commission_multiplier#">
                            <input type="text" name="paymethod" id="paymethod" style="width:150px;" value="#get_card_paymethod.card_no#" readonly>
                        </cfoutput>
                    <cfelse>
                        <input type="hidden" name="paymethod_id" id="paymethod_id" value="">
                        <input type="hidden" name="card_paymethod_id" id="card_paymethod_id" value="">
                        <input type="hidden" name="commission_rate" id="commission_rate" value="">
                        <input type="text" name="paymethod" id="paymethod" style="width:150px;" value="" readonly>
                    </cfif>						
                    <cfset card_link="&field_dueday=form_basket.basket_due_value&field_card_payment_id=form_basket.card_paymethod_id&field_card_payment_name=form_basket.paymethod&field_commission_rate=form_basket.commission_rate">
                    <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_paymethods&function_name=change_paper_duedate&function_parameter=invoice_date&field_id=form_basket.paymethod_id&field_name=form_basket.paymethod#card_link#</cfoutput>','list');"> <img src="/images/plus_thin.gif" title="<cf_get_lang_main no='322.seçiniz'>"  border="0" align="absmiddle"> </a>						
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
					<cfset order_date_list = ''>
					<cfif get_ship_detail.recordcount>
						<cfquery name="GET_ORDER_DATES" datasource="#DSN3#">
							SELECT ORDER_DATE FROM ORDERS WHERE ORDER_ID IN(SELECT ORDER_ID FROM ORDER_ROW WHERE WRK_ROW_ID IN(SELECT WRK_ROW_RELATION_ID FROM #dsn2_alias#.SHIP_ROW WHERE SHIP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_ship_detail.ship_id#">))
						</cfquery>
						<cfoutput query="get_order_dates">
							<cfset order_date_list = listappend(order_date_list,dateformat(get_order_dates.order_date,dateformat_style))>
						</cfoutput>
					</cfif>
					<input type="hidden" name="siparis_date_listesi" id="siparis_date_listesi" value="<cfoutput>#order_date_list#</cfoutput>">
                    <input type="hidden" name="irsaliye_id_listesi" id="irsaliye_id_listesi" value="<cfoutput>#get_ship_detail.ship_id#;#session.ep.period_id#</cfoutput>">
					<input type="text" name="irsaliye" id="irsaliye" style="width:150px;" value="<cfoutput>#get_ship_detail.ship_number#</cfoutput>" readonly>
                    <cfoutput><a href="javascript://" onclick="add_irsaliye();" ><img src="/images/plus_thin.gif" title="<cf_get_lang dictionary_id='57734.seçiniz'>"  border="0" align="absmiddle"></a></cfoutput></td>
                <td><cf_get_lang dictionary_id='30011.Satın alan'></td>
                <td>
                    <input type="hidden" name="empo_id" id="empo_id">
                    <input type="hidden" name="parto_id" id="parto_id" value="">
                    <input type="text" name="partner_nameo" id="partner_nameo" value="" style="width:130px;"> 
                    <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&select_list=1,2&field_name=form_basket.partner_nameo&field_emp_id=form_basket.empo_id&field_id=form_basket.parto_id</cfoutput>','list');">
                    <img src="/images/plus_thin.gif" title="<cf_get_lang dictionary_id='57734.seçiniz'>"  border="0" align="absmiddle"></a>						
                </td>
				                
                <td><cf_get_lang dictionary_id='57640.Vade'></td>
                <td><cfif Len(due_day_)>
                       <cfset due_value_ = DateAdd('d',due_day_,now())>
                    <cfelseif len(get_ship_detail.due_date) and len(get_ship_detail.ship_date)>
                        <cfset due_value_ = DateDiff('d',get_ship_detail.ship_date,get_ship_detail.due_date)>
                    <cfelse>
                        <cfset due_value_ = "">
                    </cfif>
                    <input type="text" name="basket_due_value" id="basket_due_value" value="<cfoutput>#due_value_#</cfoutput>"onchange="change_paper_duedate('invoice_date');" style="width:35px;">
                    <cfinput type="text" name="basket_due_value_date_" id="basket_due_value_date_" value="#dateformat(due_value_,dateformat_style)#" onChange="change_paper_duedate('invoice_date',1);" validate="#validate_style#" message="#message#" maxlength="10" style="width:85px;" readonly>
                    <cf_wrk_date_image date_field="basket_due_value_date_">
                </td>
				<cfif xml_show_cash_checkbox eq 1>
                    <td nowrap="nowrap"><div id="kasa_sec"><cf_get_lang dictionary_id='57163.Nakit Alış'><input type="Checkbox" name="cash" id="cash" onclick="ayarla_gizle_goster();"></div></td>
                    <td>
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
                 <td><cf_get_lang dictionary_id='57775.Teslim Alan'></td>
                 <td>
                    <input type="hidden" name="deliver_get_id" id="deliver_get_id"  value="<cfoutput>#get_ship_detail.deliver_emp_id#</cfoutput>">
                    <input type="hidden" name="deliver_get_id_consumer" id="deliver_get_id_consumer" value="">						  
                    <cfinput type="text" name="deliver_get" style="width:150px;" passthrough="readonly" value="#get_emp_info(get_ship_detail.deliver_emp,0,0)#">
                    <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_pars&select_list=1&field_name=form_basket.deliver_get&field_partner=form_basket.deliver_get_id&field_consumer=form_basket.deliver_get_id_consumer&come=stock</cfoutput>','list');"><img src="/images/plus_thin.gif" title="<cf_get_lang dictionary_id='57734.seçiniz'>"  border="0" align="absmiddle"></a>						
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
                            <input type="text" name="contract_no" id="contract_no" value="<cfif len(attributes.contract_id)><cfoutput>#getContract.contract_head#</cfoutput></cfif>" style="width:135px;">
                        <cfelse>
                            <input type="hidden" name="contract_id" id="contract_id" value=""> 
                            <input type="text" name="contract_no" id="contract_no" value="" style="width:130px;">
                        </cfif>
                        <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_contract&field_id=form_basket.contract_id&field_name=form_basket.contract_no'</cfoutput>,'large');"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>
                    </td>
                </cfif>
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
                                    <a href="javascript://" onclick="add_adress();"><img border="0" name="imageField2" src="/images/plus_thin.gif" align="absmiddle" ></a>
                                </td>
                        </cfoutput>
                    </cfif>                
                <cfif xml_acc_department_info>
                    <td><cf_get_lang dictionary_id='57572.Departman'></td>
                    <td><cf_wrkdepartmentbranch fieldid='acc_department_id' is_department='1' width='130' is_deny_control='0'></td>
                </cfif>
                <td colspan="5"></td>
            </tr>			
        </table>
        <cf_basket_form_button><cf_workcube_buttons is_upd='0' add_function='kontrol()'></cf_basket_form_button>
	</cf_basket_form>
	<cfset attributes.basket_id = 1>
    <cfset attributes.basket_sub_id = 1>
    <cfinclude template="../../objects/display/basket.cfm">
</cfform>
</div>
<script type="text/javascript">
	function add_irsaliye()
	{
		if(form_basket.company_id.value.length || form_basket.consumer_id.value.length)
		{ 
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_choice_ship&id=purchase&sale_product=0&company_id='+form_basket.company_id.value+'&consumer_id='+ form_basket.consumer_id.value,'page')
			return true;
		}
		else
		{
			alert("<cf_get_lang dictionary_id='57715.Önce Üye Seçiniz'> ! ");
			return false;
		}
	}
	
	function kontrol()
	{	
		if(!paper_control(form_basket.serial_no,'INVOICE',false,0,<cfoutput>'#GET_SHIP_DETAIL.SHIP_NUMBER#'</cfoutput>,form_basket.company_id.value,form_basket.consumer_id.value,'','',1,form_basket.serial_number)) return false;
		if (!chk_process_cat('form_basket')) return false;
		if(!check_display_files('form_basket')) return false;
		if (!chk_period(form_basket.invoice_date,"İşlem")) return false;
		<cfif isdefined("xml_upd_row_project") and xml_upd_row_project eq 1 and session.ep.our_company_info.project_followup eq 1>
			apply_deliver_date('','project_head','');
		</cfif>
		<cfif xml_control_ship_date eq 1>
		if (document.form_basket.comp_name.value == ""  && document.form_basket.consumer_id.value == "" && document.form_basket.employee_id.value == "")
		{ 
			alert ("<cf_get_lang dictionary_id='57183.Cari Hesabı Seçmelisiniz !'>");
			return false;
		}		
			var tarih_ = document.form_basket.control_ship_date.value;
			var sonuc_ = datediff(document.form_basket.invoice_date.value,tarih_,0);
			if(sonuc_ > 0)
			{
				alert("<cf_get_lang dictionary_id='57110.Fatura Tarihi İrsaliye Tarihinden Önce Olamaz!'>");
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
		<cfsavecontent variable="message"><cf_get_lang dictionary_id="59791.Ürünler İçin Seri Numarası Girmelisiniz">!</cfsavecontent>
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
		if(document.getElementById('department_id').value == "" && document.getElementById('department_name').value == "")
		{
			alert("<cf_get_lang dictionary_id='57186.Depo Girmelisiniz !'>");
			document.getElementById('department_name').focus();
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
		kontrol_yurtdisi();
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
				alert("<cf_get_lang dictionary_id='35327.Sevk Yöntemi Seçiniz'>");
				return false;	
			}
		</cfif>
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
							var get_period = wrk_safe_query("inv_get_period","dsn",0,new_period );
							new_dsn2 = "#dsn#"+"_"+get_period.PERIOD_YEAR+"_"+get_period.OUR_COMPANY_ID;	
						}
						else
							new_dsn2 = "#dsn2#";
						var get_ship_control = wrk_safe_query("inv_get_ship_control",new_dsn2,0,document.form_basket.wrk_row_relation_id[str_i_row].value);
						var get_ship_control2 = wrk_safe_query("inv_get_ship_control2",new_dsn2,0,document.form_basket.wrk_row_relation_id[str_i_row].value);
						
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
			else if(document.form_basket.product_id[0] != undefined && document.form_basket.product_id[0].value!='')
			{
				if(document.form_basket.product_id[0].value != '' && document.form_basket.wrk_row_relation_id[0].value != '' && document.form_basket.row_ship_id[0].value != '')
				{
					var get_inv_control = wrk_safe_query("inv_get_inv_control","dsn2",0,document.form_basket.wrk_row_relation_id[0].value);	
					if(list_len(document.form_basket.row_ship_id[0].value,';') > 1)
					{
						new_period = list_getat(document.form_basket.row_ship_id[0].value,2,';');
						var get_period = wrk_safe_query("inv_get_period","dsn",0,new_period);
						new_dsn2 = "#dsn#"+"_"+get_period.PERIOD_YEAR+"_"+get_period.OUR_COMPANY_ID;	
					}
					else
						new_dsn2 = "#dsn2#";
					var get_ship_control = wrk_safe_query("inv_get_ship_control",new_dsn2,0,document.form_basket.wrk_row_relation_id[0].value);
					var get_ship_control2 = wrk_safe_query("inv_get_ship_control2",new_dsn2,0,document.form_basket.wrk_row_relation_id[0].value);
					ship_amount_ = parseFloat(get_ship_control.AMOUNT)-parseFloat(get_ship_control2.AMOUNT); 
					var total_inv_amount = parseFloat(get_inv_control.AMOUNT)+parseFloat(filterNum(document.form_basket.amount[0].value));
					if(get_ship_control != undefined && get_ship_control.recordcount > 0 && ship_amount_ >0 && get_inv_control != undefined && get_inv_control.recordcount > 0 && total_inv_amount >0)
					{
						if(total_inv_amount > ship_amount_)
							ship_product_list = ship_product_list + eval(str_i_row+1) + '.Satır : ' + document.all.product_name[0].value + '\n';
					}
				}
			}
			else if(document.all.product_id != undefined && document.all.product_id.value != '')
			{
				if(document.form_basket.product_id.value != '' && document.form_basket.wrk_row_relation_id.value != '' && document.form_basket.row_ship_id.value != '')
				{
					var get_inv_control = wrk_safe_query("inv_get_inv_control","dsn2",0, document.form_basket.wrk_row_relation_id.value);	
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
		change_paper_duedate('invoice_date');
		saveForm();
		return false;
	}
	function ayarla_gizle_goster()
	{
		if(form_basket.cash.checked) {
			not1.style.display='';		
		}else{
			not1.style.display='none';
		}
	}
	function kontrol_yurtdisi()
	{
		deger = form_basket.process_cat.options[form_basket.process_cat.selectedIndex].value;
		if(deger != ""){
			var fis_no = eval("form_basket.ct_process_type_" + deger);
			if(fis_no.value == 591) 
			{
				<cfif xml_show_cash_checkbox eq 1>
					kasa_sec.style.display = 'none';
					cash_.style.display = 'none';
					if(form_basket.cash != undefined)
						form_basket.cash.checked=false;
				</cfif>
				reset_basket_kdv_rates(); //kdv oranları sıfırlanıyor dsp_basket_js_scripts te tanımlı
			}
			else
			{
				<cfif xml_show_cash_checkbox eq 1>
					kasa_sec.style.display = '';
				</cfif>
			}
		}
		return true;
	}
	change_paper_duedate('invoice_date');
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
					windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_member_address&is_comp=0&select_list=2&keyword='+encodeURIComponent(form_basket.partner_name.value)+''+ str_adrlink , 'list');
					document.getElementById('deliver_comp_id').value = '';
					return true;
				}
		}
		else
		{
			alert("<cf_get_lang dictionary_id='58965.Önce Cari Hesap Seçiniz'>");
			return false;
		}
	}
</script>
