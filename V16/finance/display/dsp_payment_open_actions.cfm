
<cf_box_search more="0">
    <div class="form-group">
        <select name="action_type" id="action_type" style="width:165px;">
            <option value="" selected><cf_get_lang dictionary_id='57692.İşlem'></option><!--- gruplara gore alfabetiktir, lutfen riayet ediniz --->
            <OPTGROUP LABEL="<cf_get_lang dictionary_id='58917.Faturalar'>">
                <option value="63" <cfif attributes.action_type eq 63>selected</cfif>><cf_get_lang dictionary_id='57811.Alınan Fiyat Farkı Faturası'></option>
                <option value="601" <cfif attributes.action_type eq 601>selected</cfif>><cf_get_lang dictionary_id='57812.Alınan Hakediş Faturası'></option>
                <option value="60" <cfif attributes.action_type eq 60> selected</cfif>><cf_get_lang dictionary_id='57813.Alınan Hizmet Faturası'></option>
                <option value="61" <cfif attributes.action_type eq 61>selected</cfif>><cf_get_lang dictionary_id='57814.Alınan Proforma Faturası'></option>
                <option value="51" <cfif attributes.action_type eq 51>selected</cfif>><cf_get_lang dictionary_id='57763.Alınan Vade Farki Faturası'></option>
                <option value="62" <cfif attributes.action_type eq 62>selected </cfif>><cf_get_lang dictionary_id='57815.Alım İade Faturası'></option>
                <option value="37" <cfif attributes.action_type eq 37>selected</cfif>><cf_get_lang dictionary_id='57816.Gider Pusulası'></option>
                <option value="690" <cfif attributes.action_type eq 690>selected</cfif>><cf_get_lang dictionary_id='57817.Gider Pusulası (Mal)'></option>
                <option value="691" <cfif attributes.action_type eq 691>selected</cfif>><cf_get_lang dictionary_id='57818.Gider Pusulası (Hizmet)'></option>
                <cfif session.ep.our_company_info.workcube_sector is "per">
                <option value="592" <cfif attributes.action_type eq 592>selected</cfif>><cf_get_lang dictionary_id='57819.Hal Faturası'></option>
                </cfif>
                <option value="591" <cfif attributes.action_type eq 591>selected</cfif>><cf_get_lang dictionary_id='57820.İthalat Faturası'></option>
                <option value="531" <cfif attributes.action_type eq 531>selected</cfif>><cf_get_lang dictionary_id='57821.İhracat Faturası'></option>
                <option value="59" <cfif attributes.action_type eq 59>selected</cfif>><cf_get_lang dictionary_id='57822.Mal Alım Faturası'></option>
                <option value="64" <cfif attributes.action_type eq 64> selected</cfif>><cf_get_lang dictionary_id='57823.Müstahsil Makbuzu'></option>
                <option value="52" <cfif attributes.action_type eq 52>selected</cfif>><cf_get_lang dictionary_id='57765.Perakende Satış Faturası'></option>
                <option value="54" <cfif attributes.action_type eq 54>selected</cfif>><cf_get_lang dictionary_id='34584.Per Satış Iade Faturası'></option>
                <option value="53" <cfif attributes.action_type eq 53>selected</cfif>><cf_get_lang dictionary_id='57825.Toptan Satış Faturası'></option>
                <option value="55" <cfif attributes.action_type eq 55>selected</cfif>><cf_get_lang dictionary_id='57826.Toptan Satış Iade Faturası'></option>
                <option value="50" <cfif attributes.action_type eq 50>selected</cfif>><cf_get_lang dictionary_id='57827.Verilen Vade Farki Faturası'></option>
                <option value="561"<cfif attributes.action_type eq 561>selected</cfif>><cf_get_lang dictionary_id='49549.Verilen Hakediş Faturası'></option>
                <option value="56" <cfif attributes.action_type eq 56>selected</cfif>><cf_get_lang dictionary_id='57829.Verilen Hizmet Faturası'></option>
                <option value="57" <cfif attributes.action_type eq 57>selected</cfif>><cf_get_lang dictionary_id='57770.Verilen Proforma Faturası'></option>
                <option value="58" <cfif attributes.action_type eq 58>selected</cfif>><cf_get_lang dictionary_id='57830.Verilen Fiyat Farkı Faturası'></option>
            </OPTGROUP>
            <OPTGROUP LABEL="<cf_get_lang dictionary_id='58896.Banka İşlemleri'>">
                <option value="20" <cfif attributes.action_type eq 20>selected</cfif>><cf_get_lang dictionary_id='57831.Banka Hesap Açılış Fişi'></option>
                <option value="38" <cfif attributes.action_type eq 38>selected</cfif>><cf_get_lang dictionary_id='57832.Döviz Alış'></option>
                <option value="39" <cfif attributes.action_type eq 39>selected</cfif>><cf_get_lang dictionary_id='57833.Döviz Satış'></option>
                <option value="24" <cfif attributes.action_type eq 24>selected</cfif>><cf_get_lang dictionary_id='57834.Gelen Havale'></option>
                <option value="25" <cfif attributes.action_type eq 25>selected</cfif>><cf_get_lang dictionary_id='57835.Giden Havale'></option>
                <option value="241" <cfif attributes.action_type eq 241>selected</cfif>><cf_get_lang dictionary_id='57836.Kredi Kartı Tahsilat'></option>
                <option value="242" <cfif attributes.action_type eq 242>selected</cfif>><cf_get_lang dictionary_id='57837.Kredi Kartı Ödeme'></option>
                <option value="291" <cfif attributes.action_type eq 291>selected</cfif>><cf_get_lang dictionary_id='57838.Kredi Ödemesi'></option>
                <option value="292" <cfif attributes.action_type eq 292>selected</cfif>><cf_get_lang dictionary_id='57839.Kredi Tahsilatı'></option>
                <option value="293" <cfif attributes.action_type eq 293>selected</cfif>><cf_get_lang dictionary_id='34401.Menkul Kıymet Alışı'></option>
                <option value="294" <cfif attributes.action_type eq 294>selected</cfif>><cf_get_lang dictionary_id='34402.Menkul Kıymet Satışı'></option>
            </OPTGROUP>
            <OPTGROUP LABEL="<cf_get_lang dictionary_id='58897.Kasa İşlemleri'>">
                <option value="34" <cfif attributes.action_type eq 34>selected</cfif>><cf_get_lang dictionary_id='57842.Alış Fatura Kapama'></option>
                <option value="36" <cfif attributes.action_type eq 36>selected</cfif>><cf_get_lang dictionary_id='57843.Gider Ödeme'></option>
                <option value="30" <cfif attributes.action_type eq 30>selected</cfif>><cf_get_lang dictionary_id='57844.Kasa Açılış Fişi'></option>
                <option value="31" <cfif attributes.action_type eq 31>selected</cfif>><cf_get_lang dictionary_id='57845.Tahsilat'></option>
                <option value="35" <cfif attributes.action_type eq 35>selected</cfif>><cf_get_lang dictionary_id='57846.Satış Fatura Kapama'></option>
                <option value="32" <cfif attributes.action_type eq 32>selected</cfif>><cf_get_lang dictionary_id='57847.Ödeme'></option>
            </OPTGROUP>
            <OPTGROUP LABEL="<cf_get_lang dictionary_id='58898.Cari İşlemleri'>">
                <option value="42" <cfif attributes.action_type eq 42>selected</cfif>><cf_get_lang dictionary_id='57848.Alacak Dekontu'></option>
                <option value="41" <cfif attributes.action_type eq 41>selected</cfif>><cf_get_lang dictionary_id='57849.Borç Dekontu'></option>
                <option value="43" <cfif attributes.action_type eq 43>selected</cfif>><cf_get_lang dictionary_id='57850.Cari Virman Fişi'></option>
                <option value="40" <cfif attributes.action_type eq 40>selected</cfif>><cf_get_lang dictionary_id='57851.C/H Açılış Fişi'></option>
            </OPTGROUP>
            <OPTGROUP LABEL="<cf_get_lang dictionary_id='58899.Masraf- Gelir Fişleri'>">
                <option value="120" <cfif attributes.action_type eq 120>selected</cfif>><cf_get_lang dictionary_id='58064.Masraf Fişi'></option>
                <option value="121" <cfif attributes.action_type eq 121>selected</cfif>><cf_get_lang dictionary_id='58065.Gelir Fişi'></option>
            </OPTGROUP>
            <OPTGROUP LABEL="<cf_get_lang dictionary_id='58900.Çek Senet İşlemleri'>">
                <option value="90" <cfif attributes.action_type eq 90>selected</cfif>><cf_get_lang dictionary_id='34416.Çek Bord Girişi'></option>
                <option value="92" <cfif attributes.action_type eq 92>selected</cfif>><cf_get_lang dictionary_id='34417.Çek Çıkış Bord (Tahsil)'></option>
                <option value="93" <cfif attributes.action_type eq 93>selected</cfif>><cf_get_lang dictionary_id='40058.Çek Çıkış Bordro (Banka Tem)'></option>
                <option value="91" <cfif attributes.action_type eq 91>selected</cfif>><cf_get_lang dictionary_id='34419.Çek Çıkış Bord(Ciro)'></option>
                <option value="95" <cfif attributes.action_type eq 95>selected</cfif>><cf_get_lang dictionary_id='57856.Çek İade Giriş Bordrosu'></option>
                <option value="94" <cfif attributes.action_type eq 94>selected</cfif>><cf_get_lang dictionary_id='57857.Çek İade Çıkış Bordrosu'></option>
                <option value="97" <cfif attributes.action_type eq 97>selected</cfif>><cf_get_lang dictionary_id='58010.Senet Giriş Bordrosu'> </option>
                <option value="98" <cfif attributes.action_type eq 98>selected</cfif>><cf_get_lang dictionary_id='49465.Senet Çıkış Bordrosu (c/h a)'></option>
                <option value="99" <cfif attributes.action_type eq 99>selected</cfif>><cf_get_lang dictionary_id='29600.Senet Çıkış Bordrosu-Banka Tahsil'></option>
                <option value="100" <cfif attributes.action_type eq 100>selected</cfif>><cf_get_lang dictionary_id='29601.Senet Çıkış Bordrosu-Banka Teminat'></option>
                <option value="101" <cfif attributes.action_type eq 101>selected</cfif>><cf_get_lang dictionary_id='29602.Senet Çıkış İade Bordrosu'></option>
                <option value="108" <cfif attributes.action_type eq 108>selected</cfif>><cf_get_lang dictionary_id='58921.Senet Giriş İade Bordrosu'></option>
                <option value="109" <cfif attributes.action_type eq 109>selected</cfif>><cf_get_lang dictionary_id='58922.Senet Giriş İade Bordrosu (Banka)'></option>
            </OPTGROUP>
        </select> 
    </div>
    <div class="form-group">
        <cf_wrk_search_button button_type="4" search_function="get_type_search()">
    </div>
</cf_box_search>
<cfset satir_kontrol =0>
<cf_grid_list>
    <thead>
        <cfoutput>
            <tr>
                <th width="20" rowspan="2"></th>
                <th width="60" rowspan="2"><cf_get_lang dictionary_id='57880.Belge No'></th>			
                <th width="30%"rowspan="2" nowrap="nowrap"><cf_get_lang dictionary_id='61806.İşlem Tipi'></th>
                <th width="60" rowspan="2"><cf_get_lang dictionary_id='57879.İşlem Tarihi'></th>
                <th width="40" rowspan="2"><cf_get_lang dictionary_id='57640.Vade'></th>
                <th width="60" rowspan="2"><cf_get_lang dictionary_id='57881.Vade Tarihi'></th>
                <th width="180" align="center" colspan="2"><cf_get_lang dictionary_id='58923.Belge Tutarı'></th>
                <th width="180" align="center" colspan="2"><cf_get_lang dictionary_id='54451.Kapanmış Tutar'></th>
                <th width="220" align="center" colspan="3"><cfif attributes.act_type eq 1><cf_get_lang dictionary_id='54411.Kapama'><cfelseif attributes.act_type eq 2><cf_get_lang dictionary_id='54403.Talep'><cfelseif attributes.act_type eq 3><cf_get_lang dictionary_id='57123.Emir'></cfif></th>
            </tr>
            <tr>
                <th width="90" style="text-align:right;">#session.ep.money# <cf_get_lang dictionary_id='57673.Tutar'></th>
                <th width="90" style="text-align:right;"><cf_get_lang dictionary_id='54948.İşlem Tutar'></th>
                <th width="90" style="text-align:right;">#session.ep.money# <cf_get_lang dictionary_id='57673.Tutar'></th>
                <th width="90" style="text-align:right;"><cf_get_lang dictionary_id='54948.İşlem Tutar'></th>
                <th width="90" style="text-align:right;">#session.ep.money# <cf_get_lang dictionary_id='57673.Tutar'></th>
                <th width="90" style="text-align:right;"><cf_get_lang dictionary_id='54948.İşlem Tutar'></th>
                <th width="40"></th>
            </tr>
        </cfoutput>
        </thead>
        <tbody>
        <cfset currentrow_info = get_cari_closed_row_1.recordcount + 1>
        <cfoutput query="get_cari_closed_row_2">
            <cfif wrk_round(CR_ACTION_VALUE,2) neq wrk_round(total_closed_amount,2)>
                <cfset satir_kontrol =1>
                <cfif (len(from_cmp_id) and len(get_invoice_close.company_id) and from_cmp_id eq get_invoice_close.company_id) or (len(from_consumer_id) and len(get_invoice_close.consumer_id) and from_consumer_id eq get_invoice_close.consumer_id) or (len(from_employee_id) and len(get_invoice_close.employee_id) and from_employee_id eq get_invoice_close.employee_id)>
                    <tr>
                        <td>
                            <input type="hidden" name="kontrol_#currentrow_info#" id="kontrol_#currentrow_info#" value="0">
                            <input type="hidden" name="closed_row_id_#currentrow_info#" id="closed_row_id_#currentrow_info#" value="#closed_row_id#">
                            <input type="hidden" name="type_#currentrow_info#" id="type_#currentrow_info#" value="0">
                            <input type="hidden" name="action_id_#currentrow_info#" id="action_id_#currentrow_info#" value="#action_id#">
                            <input type="hidden" name="cari_action_id_#currentrow_info#" id="cari_action_id_#currentrow_info#" value="#cari_action_id#">
                            <input type="hidden" name="due_date_#currentrow_info#" id="due_date_#currentrow_info#" value="#dateformat(due_date,dateformat_style)#">
                            <input type="hidden" name="action_type_id_#currentrow_info#" id="action_type_id_#currentrow_info#" value="#action_type_id#">
                            <input type="hidden" name="action_value_#currentrow_info#" id="action_value_#currentrow_info#" value="#cr_action_value#">
                            <input type="hidden" name="rate2_#currentrow_info#" id="rate2_#currentrow_info#" value="<cfif other_cash_act_value gt 0>#wrk_round(CR_ACTION_VALUE/other_cash_act_value,session.ep.our_company_info.rate_round_num)#</cfif>">
                            <input type="hidden" name="other_money_#currentrow_info#" id="other_money_#currentrow_info#" value="#other_money#">
                            <input type="checkbox" name="is_closed_#currentrow_info#" id="is_closed_#currentrow_info#" value="" onClick="check_kontrol(this);total_amount();"> 
                        </td>
                        <td>
                            <cfset type="">
                            <cfswitch expression = "#ACTION_TYPE_ID#">
                                <cfcase value="24"><cfset type="objects.popup_dsp_gelenh"></cfcase>
                                <cfcase value="25"><cfset type="objects.popup_dsp_gidenh"></cfcase>
                                <cfcase value="26,27"><cfset type="ch.popup_check_preview"></cfcase>
                                <cfcase value="31"><cfset type="objects.popup_dsp_cash_revenue"></cfcase><!---tahsilat--->
                                <cfcase value="32"><cfset type="objects.popup_dsp_cash_payment"></cfcase><!---odeme--->
                                <cfcase value="40"><cfset type="ch.popup_dsp_account_open"></cfcase>
                                <cfcase value="43"><cfset type="objects.popup_cari_action"></cfcase>
                                <cfcase value="41,42,45,46"><cfset type="ch.popup_print_upd_debit_claim_note"></cfcase>
                                <cfcase value="90"><cfset type="#module_name#.popup_dsp_payroll_entry"></cfcase>
                                <cfcase value="106"><cfset type="#module_name#.popup_dsp_payroll_entry"></cfcase>
                                <cfcase value="91"><cfset type="#module_name#.popup_dsp_payroll_endorsement"></cfcase>
                                <cfcase value="94"><cfset type="#module_name#.popup_dsp_payroll_endor_return"></cfcase>
                                <cfcase value="95"><cfset type="#module_name#.popup_dsp_payroll_entry_return"></cfcase>
                                <cfcase value="97"><cfset type="objects.popup_dsp_voucher_payroll_action"></cfcase>
                                <cfcase value="98"><cfset type="objects.popup_dsp_voucher_payroll_action"></cfcase>
                                <cfcase value="101"><cfset type="objects.popup_dsp_voucher_payroll_action"></cfcase>
                                <cfcase value="108"><cfset type="objects.popup_dsp_voucher_payroll_action"></cfcase>
                                <cfcase value="131"><cfset type="ch.popup_dsp_collacted_dekont"></cfcase>
                                <cfcase value="160"><cfset type="objects.popup_detail_budget_plan"></cfcase> 
                                <cfcase value="241"><cfset type="ch.popup_dsp_credit_card_payment_type"></cfcase>
                                <cfcase value="242"><cfset type="ch.popup_dsp_credit_card_payment"></cfcase>
                                <cfcase value="251,260"><cfset type="bank.popup_dsp_assign_order"></cfcase>
                                <cfcase value="120,121"><cfset type="#module_name2#.popup_list_cost_expense"></cfcase><!--- Masraf Fişi, Gelir Fişi --->
                                <cfcase value="291,292"><cfset type="credit.popup_dsp_credit_payment"></cfcase><!--- Kredi Odeme, Kredi Tahsilat --->
                                <cfcase value="293,294"><cfset type="credit.popup_dsp_stockbond_purchase"></cfcase><!--- Menkul Kıymet Alımı, Menkul Kıymet Satışı --->
                                <cfcase value="48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,591,531,561,592,68,601,690,691">
                                    <cfif isdefined("invoice_partner_link")>
                                        <cfset type = invoice_partner_link>
                                    <cfelse>
                                        <cfset type="objects.popup_detail_invoice">
                                    </cfif>
                                </cfcase>
                                <cfdefaultcase><cfset type=""></cfdefaultcase>
                            </cfswitch>
                            <cfif listfind('24,25,26,27,31,32,34,35,36,43,241,242,177,250,260,251,131',ACTION_TYPE_ID,',')>
                                <cfset page_type = 'small'>
                            <cfelse>
                                <cfset page_type = 'page'>
                            </cfif>
                            <cfif len(type)>
                                <a class="tableyazi" href="javascript://" onclick="windowopen('#request.self#?fuseaction=#type#&id=#ACTION_ID#','#page_type#');">#paper_no#</a>
                            <cfelse>
                                #paper_no#
                          </cfif>
                        </td>			
                        <td>#action_name#</td>
                        <td>#dateformat(action_date,dateformat_style)#</td>
                        <td align="center"><cfif len(due_date)>#datediff("d",action_date, due_date)#<cfelse>0</cfif></td>
                        <td><cfif len(due_date)>#dateformat(due_date,dateformat_style)#<cfelse>&nbsp;</cfif></td>
                        <td style="text-align:right;">#TLFormat(CR_ACTION_VALUE)#&nbsp;#session.ep.money#</td>
                        <td style="text-align:right;"><cfif len(other_cash_act_value)>#TLFormat(other_cash_act_value)#&nbsp;#other_money#</cfif></td>
                        <td style="text-align:right;"><cfif attributes.act_type eq 1>#TLFormat(total_closed_amount)#<cfelseif attributes.act_type eq 2>#TLFormat(total_payment_value)#<cfelseif attributes.act_type eq 3>#TLFormat(total_p_order_value)#</cfif>&nbsp;#session.ep.money#</td>
                        <td style="text-align:right;"><cfif attributes.act_type eq 1>#TLFormat(OTHER_CLOSED_AMOUNT)#<cfelseif attributes.act_type eq 2>#TLFormat(OTHER_PAYMENT_VALUE)#<cfelseif attributes.act_type eq 3>#TLFormat(OTHER_P_ORDER_VALUE)#</cfif>&nbsp;#I_OTHER_MONEY#</td>
                        <td style="text-align:right;">
                            <cfif get_invoice_close.other_money eq session.ep.money>
                                <cfif closed_amount lt total_closed_amount>
                                    <input type="hidden" name="h_max_closed_amount_#currentrow_info#" id="h_max_closed_amount_#currentrow_info#" value="#wrk_round(cr_action_value-total_closed_amount)#">
                                <cfelse>
                                    <input type="hidden" name="h_max_closed_amount_#currentrow_info#" id="h_max_closed_amount_#currentrow_info#" value="#wrk_round(cr_action_value)#">
                                </cfif>			
                            <cfelse>
                                <cfif closed_amount lt total_closed_amount>
                                    <input type="hidden" name="h_max_closed_amount_#currentrow_info#" id="h_max_closed_amount_#currentrow_info#" value="#wrk_round(other_cash_act_value-other_closed_amount)#">
                                <cfelse>
                                    <input type="hidden" name="h_max_closed_amount_#currentrow_info#" id="h_max_closed_amount_#currentrow_info#" value="#wrk_round(other_cash_act_value)#">
                                </cfif>			
                            </cfif>
                            <input type="hidden" name="h_to_closed_amount_#currentrow_info#" id="h_to_closed_amount_#currentrow_info#" value="#total_closed_amount#">
                            <input type="text" name="to_closed_amount_#currentrow_info#" id="to_closed_amount_#currentrow_info#" value="#TLFormat(cr_action_value-total_closed_amount)#" onBlur="convert_to_other_money(#currentrow_info#);total_amount();" onkeyup="return(FormatCurrency(this,event));convert_to_other_money(#currentrow_info#);" class="moneybox" style="width:100px;">
                        </td>
                        <td style="text-align:right;">			 
                            <input type="text" name="other_closed_amount_#currentrow_info#" id="other_closed_amount_#currentrow_info#" value="#tlformat(other_cash_act_value-other_closed_amount)#" onBlur="convert_to_system_money(#currentrow_info#);total_amount();" onkeyup="return(FormatCurrency(this,event));convert_to_system_money(#currentrow_info#);" class="moneybox" style="width:100px">
                        </td>
                        <td>#other_money#</td>
                    </tr>
                <cfelse>
                    <tr>
                        <td>
                            <input type="hidden" name="kontrol_#currentrow_info#" id="kontrol_#currentrow_info#" value="0">
                            <input type="hidden" name="type_#currentrow_info#" id="type_#currentrow_info#" value="1">
                            <input type="hidden" name="action_id_#currentrow_info#" id="action_id_#currentrow_info#" value="#action_id#">
                            <input type="hidden" name="cari_action_id_#currentrow_info#" id="cari_action_id_#currentrow_info#" value="#cari_action_id#">
                            <input type="hidden" name="action_type_id_#currentrow_info#" id="action_type_id_#currentrow_info#" value="#action_type_id#">
                            <input type="hidden" name="due_date_#currentrow_info#" id="due_date_#currentrow_info#" value="#dateformat(due_date,dateformat_style)#">
                            <input type="hidden" name="closed_row_id_#currentrow_info#" id="closed_row_id_#currentrow_info#" value="#closed_row_id#">
                            <input type="hidden" name="action_value_#currentrow_info#" id="action_value_#currentrow_info#" value="#cr_action_value#">
                            <input type="hidden" name="rate2_#currentrow_info#" id="rate2_#currentrow_info#" value="<cfif len(other_cash_act_value) and other_cash_act_value gt 0>#wrk_round(CR_ACTION_VALUE/other_cash_act_value,session.ep.our_company_info.rate_round_num)#</cfif>">
                            <input type="hidden" name="other_money_#currentrow_info#" id="other_money_#currentrow_info#" value="#other_money#">
                            <input name="is_closed_#currentrow_info#" id="is_closed_#currentrow_info#" type="checkbox" value=""  onClick="check_kontrol(this);total_amount();"> 
                        </td>
                        <td>
                            <cfset type="">
                            <cfswitch expression = "#ACTION_TYPE_ID#">
                                <cfcase value="24"><cfset type="objects.popup_dsp_gelenh"></cfcase>
                                <cfcase value="25"><cfset type="objects.popup_dsp_gidenh"></cfcase>
                                <cfcase value="26,27"><cfset type="ch.popup_check_preview"></cfcase>
                                <cfcase value="31"><cfset type="objects.popup_dsp_cash_revenue"></cfcase><!---tahsilat--->
                                <cfcase value="32"><cfset type="objects.popup_dsp_cash_payment"></cfcase><!---odeme--->
                                <cfcase value="40"><cfset type="ch.popup_dsp_account_open"></cfcase>
                                <cfcase value="43"><cfset type="objects.popup_cari_action"></cfcase>
                                <cfcase value="41,42,45,46"><cfset type="ch.popup_print_upd_debit_claim_note"></cfcase>
                                <cfcase value="90"><cfset type="#module_name#.popup_dsp_payroll_entry"></cfcase>
                                <cfcase value="106"><cfset type="#module_name#.popup_dsp_payroll_entry"></cfcase>
                                <cfcase value="91"><cfset type="#module_name#.popup_dsp_payroll_endorsement"></cfcase>
                                <cfcase value="94"><cfset type="#module_name#.popup_dsp_payroll_endor_return"></cfcase>
                                <cfcase value="95"><cfset type="#module_name#.popup_dsp_payroll_entry_return"></cfcase>
                                <cfcase value="97"><cfset type="objects.popup_dsp_voucher_payroll_action"></cfcase>
                                <cfcase value="98"><cfset type="objects.popup_dsp_voucher_payroll_action"></cfcase>
                                <cfcase value="101"><cfset type="objects.popup_dsp_voucher_payroll_action"></cfcase>
                                <cfcase value="108"><cfset type="objects.popup_dsp_voucher_payroll_action"></cfcase>
                                <cfcase value="131"><cfset type="ch.popup_dsp_collacted_dekont"></cfcase>
                                <cfcase value="160"><cfset type="objects.popup_detail_budget_plan"></cfcase> 
                                <cfcase value="241"><cfset type="ch.popup_dsp_credit_card_payment_type"></cfcase>
                                <cfcase value="242"><cfset type="ch.popup_dsp_credit_card_payment"></cfcase>
                                <cfcase value="251,260"><cfset type="bank.popup_dsp_assign_order"></cfcase>
                                <cfcase value="120,121"><cfset type="#module_name2#.popup_list_cost_expense"></cfcase><!--- Masraf Fişi, Gelir Fişi --->
                                <cfcase value="291,292"><cfset type="credit.popup_dsp_credit_payment"></cfcase><!--- Kredi Odeme, Kredi Tahsilat --->
                                <cfcase value="293,294"><cfset type="credit.popup_dsp_stockbond_purchase"></cfcase><!--- Menkul Kıymet Alımı, Menkul Kıymet Satışı --->
                                <cfcase value="48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,591,531,561,592,68,601,690,691">
                                    <cfif isdefined("invoice_partner_link")>
                                        <cfset type = invoice_partner_link>
                                    <cfelse>
                                        <cfset type="objects.popup_detail_invoice">
                                    </cfif>
                                </cfcase>
                                <cfdefaultcase><cfset type=""></cfdefaultcase>
                            </cfswitch>
                            <cfif listfind('24,25,26,27,31,32,34,35,36,43,241,242,177,250,260,251,131',ACTION_TYPE_ID,',')>
                                <cfset page_type = 'small'>
                            <cfelse>
                                <cfset page_type = 'page'>
                            </cfif>
                            <cfif len(type)>
                                <a class="tableyazi" href="javascript://" onclick="windowopen('#request.self#?fuseaction=#type#&id=#ACTION_ID#','#page_type#');"><font color="red">#paper_no#</font></a>
                            <cfelse>
                                <font color="red">#paper_no#</font>
                            </cfif>
                        </td>
                        <td><font color="red">#action_name#</font></td>
                        <td><font color="red">#dateformat(action_date,dateformat_style)#</font></td>
                        <td align="center"><font color="red"><cfif len(due_date)>#datediff("d",action_date, due_date)#<cfelse>0</cfif></font></td>
                        <td><cfif len(due_date)><font color="red">#dateformat(due_date,dateformat_style)#</font><cfelse>&nbsp;</cfif></td>
                        <td style="text-align:right;"><font color="red">#TLFormat(CR_ACTION_VALUE)#&nbsp;#session.ep.money#</font></td>		
                        <td style="text-align:right;"><font color="red"><cfif len(other_cash_act_value)>#TLFormat(other_cash_act_value)#&nbsp;#other_money#</cfif></font></td>
                        <td style="text-align:right;"><font color="red"><cfif attributes.act_type eq 1>#TLFormat(total_closed_amount)#<cfelseif attributes.act_type eq 2>#TLFormat(total_payment_value)#<cfelseif attributes.act_type eq 3>#TLFormat(total_p_order_value)#</cfif>&nbsp;#session.ep.money#</font></td>			
                        <td style="text-align:right;"><font color="red"><cfif attributes.act_type eq 1>#TLFormat(OTHER_CLOSED_AMOUNT)#<cfelseif attributes.act_type eq 2>#TLFormat(OTHER_PAYMENT_VALUE)#<cfelseif attributes.act_type eq 3>#TLFormat(OTHER_P_ORDER_VALUE)#</cfif>&nbsp;#I_OTHER_MONEY#</font></td>
                        <td style="text-align:right;">
                            <cfif get_invoice_close.other_money eq session.ep.money>
                                <cfif closed_amount lt total_closed_amount>
                                    <input type="hidden" name="h_max_closed_amount_#currentrow_info#" id="h_max_closed_amount_#currentrow_info#" value="#wrk_round(cr_action_value-total_closed_amount)#">
                                <cfelse>
                                    <input type="hidden" name="h_max_closed_amount_#currentrow_info#" id="h_max_closed_amount_#currentrow_info#" value="#wrk_round(cr_action_value)#">
                                </cfif>			  
                            <cfelse>
                                <cfif closed_amount lt total_closed_amount>
                                    <input type="hidden" name="h_max_closed_amount_#currentrow_info#" id="h_max_closed_amount_#currentrow_info#" value="#wrk_round(other_cash_act_value-other_closed_amount)#">
                                <cfelse>
                                    <input type="hidden" name="h_max_closed_amount_#currentrow_info#" id="h_max_closed_amount_#currentrow_info#" value="#wrk_round(other_cash_act_value)#">
                                </cfif>			  
                            </cfif>
                            <input type="hidden" name="h_to_closed_amount_#currentrow_info#" id="h_to_closed_amount_#currentrow_info#" value="#wrk_round(total_closed_amount)#">
                            <input type="text" name="to_closed_amount_#currentrow_info#" id="to_closed_amount_#currentrow_info#" value="#TLFormat(cr_action_value-total_closed_amount)#" onBlur="convert_to_other_money(#currentrow_info#);total_amount();" onkeyup="return(FormatCurrency(this,event));convert_to_other_money(#currentrow_info#);" class="moneybox" style="width:100px;">
                        </td> 
                        <td style="text-align:right;">			 
                        <input type="text" name="other_closed_amount_#currentrow_info#" id="other_closed_amount_#currentrow_info#" value="#tlformat(other_cash_act_value-other_closed_amount)#" onBlur="convert_to_system_money(#currentrow_info#);total_amount();" onkeyup="return(FormatCurrency(this,event));convert_to_system_money(#currentrow_info#);" class="moneybox" style="width:100px">
                        </td>
                        <td>#other_money#</td>
                    </tr>
                </cfif>
            </cfif>
            <cfset currentrow_info = currentrow_info + 1>
        </cfoutput>
        <cfif satir_kontrol eq 0>
            <tr>
                <td colspan="13"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'> !</td>
            </tr>
        </cfif>
    </tbody>
</cf_grid_list>

