
<cfsetting showdebugoutput="no">
<cfif not isdefined("attributes.action_id")>
	<cfset attributes.order_id = listdeleteduplicates(attributes.iid)>
<cfelse>
	<cfset attributes.order_id = attributes.action_id>
</cfif>
<cfset cfc = createObject("component","V16.sales.cfc.get_order")>
<cfset GetOrders = cfc.Get_Order(order_id:attributes.order_id)>
<cfset GetOurComapany = cfc.Our_Company()>
<cfset GetPaymethodName = cfc.GetPaymethod("#IIF(len(GetOrders.Paymethod),GetOrders.Paymethod,DE('0'))#")>
<cfset GetMoney_ = cfc.GetMoney(action_id:GetOrders.order_id,other_money:GetOrders.other_money)>
<cfset GetOrderRow_ = cfc.GetOrderRow(order_id:GetOrders.order_id)>
<cfset GetUpperPosition = cfc.GetUpperPosition()>
<cfif len(GetUpperPosition.UPPER_POSITION_CODE)>
    <cfset GetChiefName = cfc.GetChiefName(upper_position_code:GetUpperPosition.UPPER_POSITION_CODE)>
</cfif>
<style>
    .print_title{font-size:16px;}
    table{border-collapse:collapse;border-spacing:0;}
    table tr td{padding:5px 3px;}
    .print_border tr th{border:1px solid ##c0c0c0;padding:3px;color:##000}
    .print_border tr td{border:1px solid ##c0c0c0;}
    .row_border{border-bottom:1px solid ##c0c0c0;}
    table tr td img{max-width:50px;}
</style>
<cfset form_nettotal = 0>
<cfset sepet_total = 0>
<cfset sepet_toplam_indirim = 0>
<cfset sepet_total_tax = 0>
<cfset sepet_net_total = 0>
<table style="width:210mm">
  <tr>
    <td>
        <table width="100%">
            <tr class="row_border">
                <td style="padding:10px 0 0 0!important">
                    <cfoutput>
                        <table style="width:100%;">
                            <tr>
                                <td class="print_title">Dövizli Satış Sipariş İşlemleri</td>
                                <td style="text-align:right;">
                                    <cfif len(GetOurComapany.asset_file_name3)>
                                        <cf_get_server_file output_file="/settings/#GetOurComapany.asset_file_name3#" output_server="#GetOurComapany.asset_file_name3_server_id#" output_type="5">
                                    </cfif>
                                    <td style="text-align:right;">
                                        <b>#GetOurComapany.company_name#</b><br/>
                                        #GetOurComapany.address#<br/>
                                        <cf_get_lang_main no='87.Telefon'>: #GetOurComapany.tel_code# #GetOurComapany.tel#<br/>
                                        <cf_get_lang_main no='76.Fax'>: #GetOurComapany.tel_code# #GetOurComapany.fax#<br/>
                                        #GetOurComapany.web#&nbsp;&nbsp;#GetOurComapany.email#
                                    </td>
                                </td>
                            </tr>
                        </table>
                        <table cellpadding="3" cellspacing="0" border="1" width="100%">
                            <tr>
                                <td style="width:60mm;"bgcolor="000000"><font color="FFFFFF" size="+2"><cf_get_lang_main no="795.SATIŞ SİPARİŞ"></font></td>
                                <td style="text-align:left;"><b><cf_get_lang_main no='468.Belge No'> :</b> #GetOrders.order_number#</td>
                                <td style="text-align:right;"><b><cf_get_lang_main no='330.Tarih'> :</b> #dateformat(GetOrders.order_date,dateformat_style)#</td>
                            </tr>
                        </table>
                    </cfoutput>
                    <table border="0" cellspacing="0" cellpadding="0" style="width:180mm; height:45mm;">
                        <cfoutput query="GetOrders">
                            <tr><td colspan="4" style="height:10mm;">&nbsp;</td></tr>
                            <tr style="height:7mm;">
                                <td style="width:20mm;" class="txtbold"><cf_get_lang_main no='1195.Firma'></td>
                                <td style="width:70mm;">: #fullname#</td>
                                <td style="width:30mm;" class="txtbold"><cf_get_lang_main no='1978.Hazırlayan'></td>
                                <td style="width:70mm;">: #get_emp_info(Order_Employee_id,0,0)# </td>
                            </tr>
                            <tr style="height:7mm;">
                                <td class="txtbold"><cf_get_lang_main no='166.Yetkili'></td>
                                <td>: <cfif len(company_partner_name) and len(company_partner_surname)>#company_partner_name# #company_partner_surname#</cfif></td>
                                <td class="txtbold"><cf_get_lang_main no='233.Teslim Tarihi'></td>
                                <td>: <cfif len(DELIVERDATE)>#DateFormat(DELIVERDATE,dateformat_style)#</cfif></td>
                            </tr>
                            <tr style="height:7mm;">
                                <td class="txtbold"><cf_get_lang_main no='87.Telefon'></td>
                                <td>: <cfif Len(Company_Tel1)>#Company_TelCode# #Company_Tel1#</cfif></td>
                                <td class="txtbold"><cf_get_lang_main no='1703.Sevk Yöntemi'></td>
                                <td>: <cfif len(ship_method_)>#Ship_Method_#</cfif></td>
                            </tr>
                            <tr>
                            <td class="txtbold" valign="top"><cf_get_lang_main no='1311.Adres'></td>
                            <td style="width:70mm;height:7mm;" valign="top">
                                <table border="0" cellpadding="0" cellspacing="0">
                                    <tr>
                                        <td>:</td>
                                        <td>#Ship_Address#</td>
                                    </tr>
                                </table>
                            </td>
                            <td class="txtbold"><cf_get_lang_main no='1104.Ödeme Yöntemi'></td>
                            <td>: <cfif len(Paymethod)>#GetPaymethodName.Paymethod#</cfif></td>
                            </tr>
                            <tr style="height:7mm;">
                                <td class="txtbold"><cf_get_lang_main no='217.Açıklama'></td>
                                <td>: <cfif len(Order_Detail)>#Order_Detail#</cfif></td>
                                <td>&nbsp;</td>
                                <td>&nbsp;</td>
                            </tr>
                        </cfoutput>
                    </table>
                    <table align="center" width="100%">
                        <tr bgcolor="CCCCCC">
                            <td class="bold" style="height:5mm;"><cf_get_lang_main no='1173.KOD'></td>
                            <td class="bold"><cf_get_lang_main no='217.Açıklama'></td>
                            <td class="bold" style="text-align:right;"><cf_get_lang_main no='223.Miktar'></td>
                            <td class="bold" style="text-align:right;"><cf_get_lang dictionary_id='59342.Dövizli Birim Fiyat'></td>
                            <td class="bold" style="text-align:right;"><cf_get_lang dictionary_id='57489.Para Birimi'></td>
                            <td class="bold" style="text-align:right;width:30mm;"><cf_get_lang_main no='80.Toplam'><cf_get_lang dictionary_id='33366.Dövizli Fiyat'></td>
                        </tr>
                        <cfoutput query="GetOrderRow_">           
                            <tr>
                                <td style="width:25mm; height:5mm;">#STOCK_CODE#</td>
                                <td style="width:65mm;">#PRODUCT_NAME#</td>
                                <td style="text-align:right;">#QUANTITY# #UNIT#</td>
                                <td style="text-align:right;width:30mm;">#TLFormat(PRICE_OTHER)#</td>
                                <td style="text-align:right;width:30mm;">#other_money#</td>
                                <td style="text-align:right;width:30mm;"><cfset form_nettotal = form_nettotal + nettotal> #TLFormat(OTHER_MONEY_VALUE)#</td>
                            </tr>
                        </cfoutput>
                    </table>
                    <table border="0" cellspacing="0" cellpadding="0" width="100%">               
                        <tr>
                            <td>
                                <cfloop query="GetOrderRow_">
                                    <cfscript>
                                        if (not len(QUANTITY)) QUANTITY = 1;
                                        if (not len(PRICE)) 
                                        price = 0;
                                        tax_percent = TAX;
                                        if (not len(discount_1)) indirim1 = 0; else indirim1 = discount_1;
                                        if (not len(discount_2)) indirim2 = 0; else indirim2 = discount_2;
                                        if (not len(discount_3)) indirim3 = 0; else indirim3 = discount_3;
                                        if (not len(discount_4)) indirim4 = 0; else indirim4 = discount_4;
                                        if (not len(discount_5)) indirim5 = 0; else indirim5 = discount_5;
                                        indirim_carpan = (100-indirim1) * (100-indirim2) * (100-indirim3) * (100-indirim4) * (100-indirim5);

                                        other_money_value = price_other;	
                                        other_money_price = OTHER_MONEY_VALUE;
                                        net_maliyet = COST_PRICE;
                                        marj = MARJ;
                                        if(len(price_other))
                                        other_money_rowtotal = price_other;
                                        else
                                        other_money_rowtotal = price;
                                        row_total = QUANTITY * price;
                                        row_nettotal = wrk_round((row_total/10000000000) * indirim_carpan);
                                        row_taxtotal = wrk_round(row_nettotal * (tax_percent/100));
                                        row_lasttotal = row_nettotal + row_taxtotal;
                                        sepet_total = sepet_total + row_total; //subtotal_
                                        sepet_toplam_indirim = sepet_toplam_indirim + wrk_round(row_total) - wrk_round(row_nettotal); //discount_
                                        sepet_total_tax = sepet_total_tax + row_taxtotal; //totaltax_
                                        sepet_net_total = sepet_net_total + row_lasttotal; //nettotal_
                                    </cfscript>
                                </cfloop>
                                <table border="0" cellpadding="0" cellspacing="0" align="right">
                                    <tr>
                                        <td class="bold" style="text-align:right;"><cf_get_lang dictionary_id='54171.Alt Toplam'></td>
                                        <td style="text-align:right;width:30mm;"><cfif GetMoney_.IS_SELECTED EQ 1><cfoutput>#TLFormat(form_nettotal/GetMoney_.RATE2)#</cfoutput></cfif></td>
                                    </tr>
                                    <tr>
                                        <td class="bold" style="text-align:right;"><cf_get_lang dictionary_id="57643.KDV Toplam"></td>
                                        <td style="text-align:right;width:30mm;"><cfif GetMoney_.IS_SELECTED EQ 1><cfoutput>#TLFormat(sepet_total_tax/GetMoney_.RATE2)#</cfoutput></cfif></td>
                                    </tr>
                                    <tr>
                                        <td class="bold" style="text-align:right;"><cf_get_lang_main no='229.İskonto'></td>
                                        <td style="text-align:right;width:30mm;"><cfif GetMoney_.IS_SELECTED EQ 1><cfoutput>#TLFormat(sepet_toplam_indirim/GetMoney_.RATE2)#</cfoutput></cfif></td>
                                    </tr>                                
                                    <tr>
                                        <td class="bold" style="text-align:right;"><cf_get_lang dictionary_id='57680.Genel Toplam'></td>
                                        <td style="text-align:right;width:30mm;"><cfif GetMoney_.IS_SELECTED EQ 1><cfoutput>#TLFormat(sepet_net_total/GetMoney_.RATE2)#</cfoutput></cfif></td> 
                                    </tr>
                                    <tr>
                                        <td class="bold" style="text-align:right;"><cf_get_lang no="924.Kur Bilgisi"></td>
                                        <td style="text-align:right;width:30mm;"><cfoutput>#GetOrders.other_money#
                                            #GetMoney_.RATE1# / #TLFormat(GetMoney_.RATE2,4)#</cfoutput>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>  
                    </table>
                    <table border="0" cellpadding="0" cellspacing="0" width="100%">
                        <tr><td colspan="3" style="height:5mm;">&nbsp;</td></tr>
                        <tr style="height:7mm;">
                            <td class="bold"><cf_get_lang no="916.ONAYLAR"></td>
                        </tr>
                        <tr style="height:7mm;">
                            <td style="width:50mm;" class="bold"><cf_get_lang_main no='1714.YÖNETİCİ'><cf_get_lang_main no='88.ONAY'></td>
                            <td style="width:50mm;" class="bold"><cf_get_lang_main no='1714.YÖNETİCİ'><cf_get_lang_main no='88.ONAY'></td>
                        </tr>
                        <tr style="height:7mm;">
                            <td><cfif len(GetUpperPosition.UPPER_POSITION_CODE)><cfoutput>#GetChiefName.EMPLOYEE_NAME# #GetChiefName.EMPLOYEE_SURNAME#</cfoutput></cfif></td>
                            <td>&nbsp;</td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
    </td>
  </tr>
</table>