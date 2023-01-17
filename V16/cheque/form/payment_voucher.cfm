<!---ERU2019 Senet Tahsil İşlemi sayfası, Senet listeme ekranından direkt olarak senet tahsilat işlemi yapılabilmesi için eklenmiştir---->
<cfsavecontent variable="head_">
    <cf_get_lang no='82.Senet Tahsil İşlemi'>
    <cfset process_type_info = 1057>
</cfsavecontent>
<cfinclude template="../../sales/query/get_cashes.cfm">
<cfset money_info_ = ''>
<!---------------CFC İÇERİSİNE ALINACAK------------------------>
<cfquery name="GET_HISTORY_INFO" datasource="#dsn2#" maxrows="1">
    SELECT 
        V.VOUCHER_VALUE AS ACTION_VALUE,
        V.VOUCHER_PAYROLL_ID AS FIRST_PAYROLL_ID,
        V.*,
        VH.OTHER_MONEY_VALUE AS HISTORY_OTHER_MONEY_VALUE,
        VH.OTHER_MONEY AS HISTORY_OTHER_MONEY,
        VH.OTHER_MONEY_VALUE2 AS HISTORY_OTHER_MONEY_VALUE2,
        VH.OTHER_MONEY2 AS HISTORY_OTHER_MONEY2,
        VH.PAYROLL_ID,
        VH.DETAIL,
        (
            SELECT
                MAX(ISNULL(ACT_DATE,RECORD_DATE))
            FROM
                VOUCHER_HISTORY
            WHERE
                VOUCHER_ID = V.VOUCHER_ID
        )MAX_ACT_DATE
    FROM
        VOUCHER_HISTORY VH,
        VOUCHER V
    WHERE
        V.VOUCHER_ID = VH.VOUCHER_ID AND
        VH.VOUCHER_ID = #url.voucher_id#
    ORDER BY
        HISTORY_ID DESC 
</cfquery>
<cfquery name="get_selected_money" datasource="#dsn2#">
    SELECT MONEY_TYPE MONEY,RATE1,RATE2,IS_SELECTED FROM VOUCHER_PAYROLL_MONEY WHERE ACTION_ID = #GET_HISTORY_INFO.FIRST_PAYROLL_ID# AND IS_SELECTED = 1
</cfquery>
<cfquery name="GET_PAYROLL_CASH" datasource="#dsn2#">
    SELECT PAYROLL_CASH_ID FROM VOUCHER_PAYROLL WHERE ACTION_ID = #GET_HISTORY_INFO.FIRST_PAYROLL_ID#
</cfquery>
<cfif get_selected_money.recordcount eq 0>
    <cfquery name="get_cari_money" datasource="#dsn2#">
        SELECT OTHER_MONEY FROM CARI_ROWS WHERE ACTION_ID = #url.voucher_id# AND ACTION_TYPE_ID = 107
    </cfquery>
    <cfif get_cari_money.recordcount>
        <cfset money_info_ = get_cari_money.OTHER_MONEY>
    </cfif>
</cfif>
<cfif len(get_history_info.first_payroll_id)>
    <cfquery name="get_payroll_no" datasource="#dsn2#">
        SELECT PAYROLL_NO FROM VOUCHER_PAYROLL WHERE ACTION_ID = #get_history_info.first_payroll_id#
    </cfquery>
    <cfif get_payroll_no.PAYROLL_NO neq -1>
        <cfquery name="get_first_rate" datasource="#dsn2#">
            SELECT RATE2,RATE1,MONEY_TYPE FROM VOUCHER_PAYROLL_MONEY WHERE ACTION_ID = #get_history_info.first_payroll_id# AND IS_SELECTED=1
        </cfquery>
    <cfelse>
        <cfquery name="get_first_rate" datasource="#dsn2#">
            SELECT RATE2,RATE1,MONEY_TYPE FROM VOUCHER_MONEY WHERE ACTION_ID = #url.voucher_id# AND IS_SELECTED=1
        </cfquery>
    </cfif>
<cfelse>
    <cfquery name="get_first_rate" datasource="#dsn2#">
        SELECT RATE2,RATE1,MONEY_TYPE FROM VOUCHER_MONEY WHERE ACTION_ID = #url.voucher_id# AND IS_SELECTED=1
    </cfquery>
</cfif>
<cfif get_first_rate.recordcount eq 0>
    <cfquery name="get_first_rate" datasource="#dsn2#">
        SELECT RATE2,RATE1,MONEY AS MONEY_TYPE FROM SETUP_MONEY WHERE MONEY = '#GET_HISTORY_INFO.CURRENCY_ID#'
    </cfquery>
</cfif>
<cfif len(get_history_info.payroll_id)>
    <cfquery name="get_last_rate" datasource="#dsn2#">
        SELECT RATE2,RATE1,MONEY_TYPE FROM VOUCHER_PAYROLL_MONEY WHERE ACTION_ID = #get_history_info.payroll_id# AND IS_SELECTED=1
    </cfquery>
<cfelse>
    <cfquery name="get_last_rate" datasource="#dsn2#">
        SELECT RATE2,RATE1,MONEY_TYPE FROM VOUCHER_MONEY WHERE ACTION_ID = #url.voucher_id# AND IS_SELECTED=1
    </cfquery>
</cfif>
<cfif get_last_rate.recordcount eq 0>
    <cfquery name="get_last_rate" datasource="#dsn2#">
        SELECT RATE2,RATE1,MONEY_TYPE FROM VOUCHER_MONEY WHERE ACTION_ID = #url.voucher_id# AND IS_SELECTED=1
    </cfquery>
</cfif>
<cfif get_last_rate.recordcount eq 0>
    <cfquery name="get_last_rate" datasource="#dsn2#">
        SELECT RATE2,RATE1,MONEY AS MONEY_TYPE FROM SETUP_MONEY WHERE MONEY = '#GET_HISTORY_INFO.CURRENCY_ID#'
    </cfquery>
</cfif>
<cfset first_value = wrk_round(GET_HISTORY_INFO.OTHER_MONEY_VALUE/ get_first_rate.rate2)>
<cfset last_value = wrk_round(GET_HISTORY_INFO.HISTORY_OTHER_MONEY_VALUE/ get_last_rate.rate2)>
<cfif GET_HISTORY_INFO.CURRENCY_ID eq get_last_rate.MONEY_TYPE>
    <cfset diff_value = 0>
<cfelse>
    <cfset diff_value = last_value - first_value>
</cfif>
<cfquery name="get_money_bskt" datasource="#dsn#">
    SELECT MONEY,RATE1,RATE2,1 AS IS_SELECTED FROM SETUP_MONEY WHERE COMPANY_ID = #session.ep.company_id# AND PERIOD_ID = #session.ep.period_id# AND MONEY_STATUS = 1 ORDER BY MONEY DESC
</cfquery>
<cfparam name="attributes.modal_id" default="">

<!---------------------------------------------->
<cf_box title="#head_#" popup_box="#iif(isdefined('attributes.draggable'),1,0)#">
    <cfform name="add_mas" action="#request.self#?fuseaction=cheque.upd_payment_voucher">
        <input type="hidden" name="kontrol_process_date" id="kontrol_process_date" value="<cfif isdefined("get_history_info.max_act_date")><cfoutput>#dateformat(get_history_info.max_act_date,dateformat_style)#</cfoutput></cfif>">
        <input type="hidden" name="cheque_no" id="cheque_no" value="<cfif isdefined("get_history_info.cheque_no")><cfoutput>#get_history_info.cheque_no#</cfoutput></cfif>">
        <input type="hidden" name="voucher_no" id="voucher_no" value="<cfif isdefined("get_history_info.voucher_no")><cfoutput>#get_history_info.voucher_no#</cfoutput></cfif>">
        <input type="hidden" name="voucher_id" id="voucher_id" value="<cfif isdefined("url.voucher_id")><cfoutput>#url.voucher_id#</cfoutput></cfif>">
        <input type="hidden" name="cheque_id" id="cheque_id" value="<cfif isdefined("url.cheque_id")><cfoutput>#url.cheque_id#</cfoutput></cfif>">
        <input type="hidden" name="status" id="status" value="<cfif isdefined("get_history_info.cheque_status_id")><cfoutput>#get_history_info.cheque_status_id#</cfoutput><cfelse><cfoutput>#get_history_info.voucher_status_id#</cfoutput></cfif>">
        <input type="hidden" name="extra_status" id="extra_status" value="<cfif isdefined("url.extra_status")><cfoutput>#url.extra_status#</cfoutput></cfif>">
        <input type="hidden" name="cash_id" id="cash_id" value="<cfif isdefined("GET_PAYROLL_CASH.payroll_cash_id") and len(GET_PAYROLL_CASH.payroll_cash_id)><cfoutput>#GET_PAYROLL_CASH.payroll_cash_id#</cfoutput></cfif>">
        <input type="hidden" name="company_id" id="company_id" value="<cfif isdefined("get_history_info.company_id") and len(get_history_info.company_id)><cfoutput>#get_history_info.company_id#</cfoutput></cfif>">
        <input type="hidden" name="consumer_id" id="consumer_id" value="<cfif isdefined("get_history_info.consumer_id") and len(get_history_info.consumer_id)><cfoutput>#get_history_info.consumer_id#</cfoutput></cfif>">
        <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
            <cf_flat_list>
                <cfoutput>
                    <tr>
                        <td width="100" class="bold"><cf_get_lang_main no='1090.Senet No'></td>
                        <td width="180"><b>:</b>&nbsp;#GET_HISTORY_INFO.VOUCHER_NO#</td>
                    </tr>
                    <tr>
                        <td class="bold"><cf_get_lang no='77.İşlem Para Br'></td>
                        <td><b>:</b>&nbsp;#TLFormat(GET_HISTORY_INFO.ACTION_VALUE)#&nbsp;#GET_HISTORY_INFO.CURRENCY_ID#</td>
                    </tr>
                    <tr>
                        <td class="bold"><cf_get_lang no='68. Sistem Para Br'></td>
                        <td><b>:</b>&nbsp;#TLFormat(GET_HISTORY_INFO.OTHER_MONEY_VALUE)#&nbsp;#GET_HISTORY_INFO.OTHER_MONEY#</td>
                    </tr>
                    <tr>
                        <td class="bold"><cf_get_lang no ='181.Sistem 2 Para Br'> </td>
                        <td><b>:</b>&nbsp;<cfif len(GET_HISTORY_INFO.OTHER_MONEY_VALUE2)>#TLFormat(GET_HISTORY_INFO.OTHER_MONEY_VALUE2)#&nbsp;#GET_HISTORY_INFO.OTHER_MONEY2#</cfif></td>
                    </tr>
                    <tr>
                        <td class="bold"><cf_get_lang_main no='228.Vade'></td>
                        <td><b>:</b>&nbsp;#dateformat(GET_HISTORY_INFO.VOUCHER_DUEDATE,dateformat_style)#</td>
                    </tr>
                    <tr>
                        <td class="bold"><cf_get_lang_main no='217.Açıklama'></td>
                        <td><b>:</b>&nbsp;#GET_HISTORY_INFO.DETAIL#</td>
                    </tr>
                </cfoutput>
            </cf_flat_list>
        </div>
        <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
            <cf_box_elements>
                <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                    <div class="form-group" id="item-process_cat">
                        <label class="col col-4 col-xs-12"><cf_get_lang_main no='388.işlem tipi'>*</label>
                        <div class="col col-8 col-xs-12">
                            <cf_workcube_process_cat process_type_info='#process_type_info#'>
                        </div>	
                    </div>
                    <div class="form-group" id="cash_td_2">
                        <cfoutput>
                            <label class="col col-4 col-xs-12">
                                <cf_get_lang_main no ='108.Kasa'>
                            </label>
                            <div class="col col-8 col-xs-12">
                                <input type="hidden" name="cash_action_id" id="cash_action_id" value="">
                                <select name="kasa" id="kasa" onchange="kasa_dovizi_hesapla(2);">
                                    <cfloop query="get_cashes">
                                        <option value="#get_cashes.cash_id#;#get_cashes.cash_currency_id#" <cfif get_cashes.cash_currency_id eq GET_HISTORY_INFO.CURRENCY_ID>selected</cfif>>#get_cashes.cash_name#-#get_cashes.cash_currency_id#</option>
                                    </cfloop>
                                </select>
                                <input type="hidden" name="system_cash_amount" id="system_cash_amount" value="">
                                <input type="hidden" name="currency_type" id="currency_type" value="#GET_HISTORY_INFO.CURRENCY_ID#">
                            </div>
                        </cfoutput>
                    </div>
                    <div class="form-group" id="item-act_date">
                        <label class="col col-4 col-xs-12"><cf_get_lang_main no='467.İşlem Tarihi'></label>
                        <div class="col col-8 col-xs-12">
                            <cfsavecontent variable="message"><cf_get_lang_main no='494.İşlem tarihi seçmelisiniz'>!</cfsavecontent>
                            <div class="input-group">
                                <cfinput type="text" name="act_date" required="yes" message="#message#" value="#dateformat(now(),dateformat_style)#" onBlur="change_money_info('add_mas','act_date');">
                                <span class="input-group-addon"><cf_wrk_date_image date_field="act_date" call_function="change_money_info"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-voucher_value">
                        <label class="col col-4 col-xs-12"><cf_get_lang no='77.İşlem Para Br'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <div class="input-group">
                                <input type="text" name="voucher_value"  id="voucher_value"  class="moneybox" readonly onBlur="if(this.value.length==0 || filterNum(this.value)=='') this.value='0';f_kur_hesapla_multi();" onKeyup="return(FormatCurrency(this,event));" value="<cfif len(GET_HISTORY_INFO.ACTION_VALUE)><cfoutput>#tlformat(GET_HISTORY_INFO.ACTION_VALUE)#</cfoutput></cfif>">
                                <input type="hidden" name="money_type" id="money_type" value="<cfoutput>#GET_HISTORY_INFO.CURRENCY_ID#</cfoutput>">   
                                <span class="input-group-addon"><cfoutput>#GET_HISTORY_INFO.CURRENCY_ID#</cfoutput></span>
                            </div>                                                         	
                        </div>
                    </div>
                    <div class="form-group" id="item-system_currency_value">
                        <label class="col col-4 col-xs-12"><cf_get_lang no='68. Sistem Para Br'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <div class="input-group">
                                <input type="text" name="system_currency_value" id="system_currency_value" class="moneybox" readonly onKeyup="return(FormatCurrency(this,event));" value="<cfif len(GET_HISTORY_INFO.HISTORY_OTHER_MONEY_VALUE)><cfoutput>#tlformat(GET_HISTORY_INFO.HISTORY_OTHER_MONEY_VALUE)#</cfoutput></cfif>">
                                <span class="input-group-addon"><cfoutput>#GET_HISTORY_INFO.HISTORY_OTHER_MONEY#</cfoutput></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-system_currency_value2">
                        <label class="col col-4 col-xs-12"><cf_get_lang no ='181.Sistem 2 Para Br'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <div class="input-group">
                                <input type="text" name="system_currency_value2" id="system_currency_value2" class="moneybox" onKeyup="return(FormatCurrency(this,event));" value="<cfif len(GET_HISTORY_INFO.HISTORY_OTHER_MONEY_VALUE2)><cfoutput>#tlformat(GET_HISTORY_INFO.HISTORY_OTHER_MONEY_VALUE2)#</cfoutput><cfelse>0</cfif>" readonly>
                                <span class="input-group-addon"><cfoutput>#GET_HISTORY_INFO.HISTORY_OTHER_MONEY2#</cfoutput></span>
                            </div>                           
                        </div>
                    </div>
                    <div class="form-group" id="item-other_currency_value_diff">
                        <label class="col col-4 col-xs-12"><cf_get_lang no ='188.İşlem Para Br Farkı'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <div class="input-group">
                                <input type="hidden" name="total_other_currency_value_diff" id="total_other_currency_value_diff" class="moneybox" value="<cfoutput><cfif len(GET_HISTORY_INFO.HISTORY_OTHER_MONEY)>#tlformat(first_value)#</cfif></cfoutput>">
                                <input type="text" name="other_currency_value_diff" id="other_currency_value_diff" class="moneybox" value="<cfoutput>#tlformat(diff_value)#</cfoutput>" readonly>    
                                <span class="input-group-addon"><cfoutput>#get_last_rate.MONEY_TYPE#</cfoutput></span>
                            </div>                  
                        </div>
                    </div>
                    <div class="form-group" id="item-system_currency_value_diff">
                        <label class="col col-4 col-xs-12"><cf_get_lang no ='189.Sistem Para Br Farkı'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <div class="input-group">
                                <input type="hidden" name="total_system_currency_value_diff" id="total_system_currency_value_diff" class="moneybox" value="<cfoutput><cfif len(GET_HISTORY_INFO.HISTORY_OTHER_MONEY)>#tlformat(GET_HISTORY_INFO.OTHER_MONEY_VALUE)#</cfif></cfoutput>">
                                <input type="text" name="system_currency_value_diff" id="system_currency_value_diff" class="moneybox" value="<cfoutput><cfif len(GET_HISTORY_INFO.HISTORY_OTHER_MONEY)>#tlformat(GET_HISTORY_INFO.OTHER_MONEY_VALUE-GET_HISTORY_INFO.HISTORY_OTHER_MONEY_VALUE)#</cfif></cfoutput>" readonly>
                                <input type="hidden" name="system_currency_value_diff2" id="system_currency_value_diff2" class="moneybox" value="<cfoutput><cfif len(GET_HISTORY_INFO.HISTORY_OTHER_MONEY2)>#tlformat(GET_HISTORY_INFO.OTHER_MONEY_VALUE2-GET_HISTORY_INFO.HISTORY_OTHER_MONEY_VALUE2)#<cfelse>0</cfif></cfoutput>" readonly>        
                                <span class="input-group-addon"><cfoutput>#GET_HISTORY_INFO.HISTORY_OTHER_MONEY#</cfoutput></span>
                            </div>                                                   	
                        </div>
                    </div>
                    <div class="form-group" id="item-detail">
                        <label class="col col-4 col-xs-12"><cf_get_lang_main no='217.Açıklama'></label>
                        <div class="col col-8 col-xs-12">
                            <textarea name="detail" id="detail"></textarea>
                        </div>
                    </div>
                    <div class="form-group" id="item-masraf">
                        <label class="col col-4 col-xs-12"><cf_get_lang_main no ='2263.Masraf Tutarı'></label>
                        <div class="col col-8 col-xs-12">
                            <cfinput type="text" name="masraf" id="masraf" class="moneybox" value="" onkeyup="return(FormatCurrency(this,event));">
                        </div>
                    </div>
                    <div class="form-group" id="item-expense_item_name">
                        <label class="col col-4 col-xs-12"><cf_get_lang_main no='1139.Gider Kalemi'></label>
                        <div class="col col-8 col-xs-12">
                            <input type="hidden" name="expense_item_id" id="expense_item_id" value="">
                            <div class="input-group">
                                <input type="text" name="expense_item_name" id="expense_item_name" value="">
                                <span class="input-group-addon icon-ellipsis btnPointer" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_exp_item&field_id=add_mas.expense_item_id&field_name=add_mas.expense_item_name','medium');"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-expense_center">
                        <label class="col col-4 col-xs-12"><cf_get_lang_main no='1048.Masraf Merkezi'></label>
                        <div class="col col-8 col-xs-12">
                            <input type="hidden" name="expense_center_id" id="expense_center_id" value="">
                            <div class="input-group">
                                <input type="text" name="expense_center" id="expense_center" value="">
                                <span class="input-group-addon icon-ellipsis btnPointer" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_expense_center&field_name=add_mas.expense_center&field_id=add_mas.expense_center_id&is_invoice=1</cfoutput>','medium');"></span>
                            </div>
                        </div>
                    </div>   
                </div>
                <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                    <div clas="form-group">
                        <label class ="col col-12 bold"><cf_get_lang_main no='265.Dövizler'></label>
                        <input type="hidden" name="kur_say" id="kur_say" value="<cfoutput>#get_money_bskt.recordcount#</cfoutput>">
                        <cfif session.ep.rate_valid eq 1>
                            <cfset readonly_info = "yes">
                        <cfelse>
                            <cfset readonly_info = "no">
                        </cfif>                    
                        <cfif get_selected_money.recordcount>
                            <cfset selected_money = get_selected_money.money>
                        <cfelseif len(money_info_)>
                            <cfset selected_money = money_info_>
                        <cfelse>
                            <cfset selected_money = session.ep.money>
                        </cfif>
                        <input type="hidden" name="selected_money" id="selected_money" value="<cfoutput>#selected_money#</cfoutput>">
                        <cfif get_money_bskt.recordcount>
                            <cfoutput query="get_money_bskt">
                                <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
                                    <label class="col col-4 col-md-4 col-sm-4 col-xs-4">
                                        <input type="hidden" name="hidden_rd_money_#currentrow#" id="hidden_rd_money_#currentrow#" value="#money#">
                                        <input type="hidden" name="txt_rate1_#currentrow#" id="txt_rate1_#currentrow#" value="#rate1#">
                                        <input type="radio" name="rd_money" id="rd_money" value="#money#;#currentrow#" onClick="f_kur_hesapla_multi('#money#');" <cfif get_money_bskt.money eq selected_money>checked</cfif>>#money# #TLFormat(rate1,0)#/
                                    </label>
                                    <div class="col col-8 col-md-8 col-sm-8 col-xs-8">
                                        <input type="text" <cfif readonly_info>readonly</cfif> name="txt_rate2_#currentrow#" id="txt_rate2_#currentrow#" value="#TLFormat(rate2,'#session.ep.our_company_info.rate_round_num#')#" class="box" onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.rate_round_num#));" onBlur="if(filterNum(this.value) <=0) this.value=commaSplit(1);f_kur_hesapla_multi('#money#');" <cfif get_money_bskt.money is session.ep.money>readonly</cfif>>                                    
                                    </div>
                                </div>
                            </cfoutput>
                        </cfif>               
                    </div>
                </div>
            </cf_box_elements>
        </div>
        <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
            <cf_box_footer>
                <input type="hidden" name="other_money" id="other_money" value="<cfoutput>#get_last_rate.MONEY_TYPE#</cfoutput>">
                <!----  <input type="hidden" name="sta" id="sta" value="<cfoutput>#attributes.sta#</cfoutput>">----->
                <cf_workcube_buttons  is_upd='0' add_function='kontrol()'>
            </cf_box_footer>
        </div>                      
    </cfform>
</cf_box>
<script type="text/javascript">
    function kontrol()
	{
   
        document.add_mas.voucher_value.value=filterNum(document.add_mas.voucher_value.value,4);
        document.add_mas.masraf.value=filterNum(document.add_mas.masraf.value,4);
		document.add_mas.system_currency_value.value=filterNum((document.add_mas.system_currency_value.value),4);
		document.add_mas.system_currency_value2.value=filterNum((document.add_mas.system_currency_value2.value),4);
		document.add_mas.system_currency_value_diff.value=filterNum((document.add_mas.system_currency_value_diff.value),4);
		document.add_mas.system_currency_value_diff2.value=filterNum((document.add_mas.system_currency_value_diff2.value),4);
		document.add_mas.other_currency_value_diff.value=filterNum((document.add_mas.other_currency_value_diff.value),4);
    }
    
</script>