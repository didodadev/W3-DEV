<!--- Üye Risk Detayı FBS 20080522 --->
<cfquery name="get_credit_contract" datasource="#dsn#">
	SELECT 
        COMPANY_ID, 
        CONSUMER_ID, 
        OPEN_ACCOUNT_RISK_LIMIT, 
        OPEN_ACCOUNT_RISK_LIMIT_OTHER, 
        FORWARD_SALE_LIMIT, 
        FORWARD_SALE_LIMIT_OTHER, 
        FIRST_PAYMENT_INTEREST,
        LAST_PAYMENT_INTEREST, 
        PRICE_CAT, 
        MONEY, 
        RECORD_DATE, 
        RECORD_EMP, 
        RECORD_IP, 
        IS_BLACKLIST, 
        BLACKLIST_INFO, 
        BLACKLIST_DATE 
    FROM 
    	COMPANY_CREDIT_HISTORY 
    WHERE 
	  	<cfif isdefined("attributes.member_type") and attributes.member_type is "company">
			COMPANY_ID = #attributes.member_id#
		<cfelse>
			CONSUMER_ID = #attributes.member_id#
		</cfif>
	ORDER BY
		RECORD_DATE DESC
</cfquery>
<cf_box title='#getLang('','Tarihçe',57473)#' scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
    <cfset counter = 1>
        <cfif get_credit_contract.recordcount>
        <cfset temp_ = 0>
            <cfoutput query="get_credit_contract" > 
             <cfset temp_ = temp_ +1>
        <cf_seperator id="history_#temp_#" header="#DateFormat(record_date,dateformat_style)# #TimeFormat(DateAdd('h',session.ep.time_zone,record_date),timeformat_style)# - #get_emp_info(record_emp,0,0)#
                        " is_closed="1">
        <cf_grid_list id="history_#temp_#" style="display:none;">
            <tr>
                <td class="txtbold"><cf_get_lang dictionary_id='57875.Açık Hesap Limiti'></td>
                <td colspan="5">#TLFormat(open_account_risk_limit)#</td>
            </tr>
            <tr>
                <td class="txtbold"><cf_get_lang dictionary_id ='50971.Açık Hesap Limiti Döviz'></td>
                <td>#TLFormat(open_account_risk_limit_other)# #money#</td>
                <td class="txtbold"><cf_get_lang dictionary_id ='54657.Vadeli Ödeme Aracı Limiti'></td>
                <td>#TLFormat(forward_sale_limit)#</td>
                <td class="txtbold"><cf_get_lang no ='274.Talep Fişine Git'></td>
              <td>#TLFormat(forward_sale_limit_other)# #money# </td>
            </tr>
            <tr>
                <td class="txtbold"><cf_get_lang dictionary_id ='54927.Erken Ödeme İndirimi'> %</td>
                <td>#TLFormat(first_payment_interest)# </td>
                <td class="txtbold"><cf_get_lang dictionary_id='58501.Vade Farkı'> %</td>
                <td>#TLFormat(last_payment_interest)#</td>
                <td class="txtbold"><cf_get_lang dictionary_id='57891.Güncelleyen'></td>
                <td>#get_emp_info(record_emp,0,0)# </td>
            </tr>
            <!---<tr>
                <td class="txtbold"><cf_get_lang_main no='291.Güncelleme'></td>
                <td>#DateFormat(record_date,dateformat_style)# #TimeFormat(DateAdd('h',session.ep.time_zone,record_date),timeformat_style)#  </td>
                <td class="txtbold"><cf_get_lang_main no='70.Aşama'></td>
                <td>
                 <!---#GET_STATUS.SERVICE_STATUS#--->
						<cfif len(service_status_id)>
							<cfquery name="GET_STATUS_ROW" dbtype="query">
								SELECT * FROM GET_STATUS WHERE PROCESS_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#service_status_id#">
							</cfquery>
							<cfif get_status_row.recordcount>
								#get_status_row.stage#
							</cfif>
						</cfif>
                        <!--- <cfif listfindnocase(status_ids,service_status_id) neq 0 and (listlen(status_names) neq 0)>
                            #listgetat(status_names,listfindnocase(status_ids,service_status_id))#
                        </cfif> --->
                </td>
                <td class="txtbold"><cf_get_lang_main no='1561.Alt Aşama'></td>
                <td>
                		<cfif len(service_substatus_id)>
                            <cfquery name="GET_SUBSTATUS" dbtype="query">
                                SELECT * FROM GET_SERVICE_SUBSTATUS WHERE SERVICE_SUBSTATUS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#service_substatus_id#">
                            </cfquery>
                            #get_substatus.service_substatus#
                        </cfif>
                </td>
            </tr><!------>
            <tr>
                <td class="txtbold"><cf_get_lang_main no='45.Müşteri'></td>
                <td>#applicator_name#</td>
                <td class="txtbold"><cf_get_lang_main no ='217.Açıklama'></td>
                <td>&nbsp;#service_detail#</td>
                <td class="txtbold"></td>
                <td></td>
            </tr>--->
        </cf_grid_list>	
    </cfoutput>
    </cfif>
</cf_box>
