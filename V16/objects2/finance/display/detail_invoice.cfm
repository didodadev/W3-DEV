<cfset attributes.var_type = '1,2,3'>
<cfinclude template="decrypt_finance.cfm">

<cfinclude template="../../login/send_login.cfm">
<cfset toplam_indirim_miktari = 0>
<cfinclude template="../query/get_sale_det.cfm">
<cfinclude template="../query/get_store.cfm">
<cfoutput>

<!--- <table cellpadding="0" cellspacing="0" style="width:100%; text-align:right;">
    <tr>
        <!-- sil -->
        <td align="right"><cf_workcube_file_action pdf='1' doc='1' print='1' mail='0'></td> 
        <!-- sil -->                    
    </tr>
</table> --->
<hgroup class="finance_display">
    <b>
    	<cf_get_lang dictionary_id='58065.Gelir Fişi'>
        </b>
    <table style="width:100%;">
        <tr><td>
        <div class="area_colmn">
            <label><cf_get_lang dictionary_id='57519.Cari Hesap'></label>
            <span>: 
				<cfif isdefined("comp")>
                    #get_sale_det_comp.fullname#
                <cfelseif isdefined('get_cons_name')>
                    #get_cons_name.consumer_name#&nbsp;#get_cons_name.consumer_surname#
                </cfif>
            </span>
        </div>
        <div class="area_colmn">
            <label><cf_get_lang dictionary_id='57578.Yetkili'></label>
            <span>: 
				<cfif isdefined("get_cons_name.consumer_name")>
                    #get_cons_name.consumer_name#&nbsp;#get_cons_name.consumer_surname#
                <cfelseif isdefined("get_sale_det_cons.name")>
                    #get_sale_det_cons.name#
                </cfif>
            </span>
        </div>
        <div class="area_colmn">
            <label><cf_get_lang dictionary_id='57775.Teslim Alan'></label>
            <span>: 
				<cfif len(get_sale_det.deliver_emp) and get_sale_det.purchase_sales eq 0>
                    #get_sale_det_deliver_emp.employee_name# #get_sale_det_deliver_emp.employee_surname#
                <cfelse>
                    #get_sale_det.deliver_emp#
                </cfif>
            </span>
        </div>
        <div class="area_colmn">
            <label><cf_get_lang dictionary_id='58609.Üye Kategorisi'></label>
            <span>: 
				<cfif not isdefined("comp")>
                    <cf_get_lang dictionary_id='57586.Bireysel Üye'>
                <cfelse>
                    <cf_get_lang dictionary_id='57585.Kurumsal Üye'>
            	</cfif>
            </span>
        </div>
        <div class="area_colmn">
            <label><cf_get_lang dictionary_id='58762.Vergi Dairesi'></label>
            <span>: 
				<cfif not isdefined("comp") and isdefined('get_cons_name')>
                    #get_cons_name.tax_adress#
                <cfelseif isdefined('get_sale_det_comp')>
                    #get_sale_det_comp.taxoffice#
                </cfif>
        	</span>
        </div>
    </td><td>
        <div class="area_colmn">
            <label><cf_get_lang dictionary_id='57752.Vergi No'></label>
            <span>: 
				<cfif not isdefined("comp") and isdefined('get_cons_name')>
	                #get_cons_name.tax_no#
                <cfelseif isdefined('get_sale_det_comp')>
    	            #get_sale_det_comp.taxno#
                </cfif>
        	</span>
        </div>
        <div class="area_colmn">
            <label><cf_get_lang dictionary_id='58516.Ödeme Yöntemi'></label>
            <span>: 
				<cfif len(get_sale_det.pay_method)>
	                #get_method2.paymethod#
                <cfelseif len(get_sale_det.card_paymethod_id)>
    	            #get_method_card.card_no#
                </cfif>
            </span>
        </div>
        <div class="area_colmn">
            <label><cf_get_lang dictionary_id='58851.Ödeme Tarihi'></label>
            <span>: 
				<cfif len(get_sale_det.pay_method)>
					<cfif len(get_method2.due_day)>#dateformat(date_add('d',get_sale_det.invoice_date,get_method2.due_day),'dd/mm/yyyy')#</cfif>
                </cfif>
            </span>
        </div>
        <div class="area_colmn">
            <label><cf_get_lang dictionary_id='57486.Kategori'></label>
            <span>: 
            	<cfswitch expression="#get_sale_det.invoice_cat#">
                    <cfcase value="690,691,29,37"><cf_get_lang dictionary_id='57816.Gider Pusulası'></cfcase>
                    <cfcase value="50"><cf_get_lang dictionary_id='57827.Verilen Vade Farki Faturası'></cfcase>
                    <cfcase value="51"><cf_get_lang dictionary_id='57763.Alınan Vade Farki Faturası'></cfcase>
                    <cfcase value="52"><cf_get_lang dictionary_id='57765.Perakende Satış Faturası'></cfcase>
                    <cfcase value="53"><cf_get_lang dictionary_id='57825.Toptan Satış Faturası'></cfcase>
                    <cfcase value="54"><cf_get_lang dictionary_id='34584.Per Satış Iade Faturası'></cfcase>
                    <cfcase value="55"><cf_get_lang dictionary_id='57826.Toptan Satış Iade Faturası'></cfcase>
                    <cfcase value="56"><cf_get_lang dictionary_id='57829.Verilen Hizmet Faturası'></cfcase>
                    <cfcase value="57"><cf_get_lang dictionary_id='57770.Verilen Proforma Faturası'></cfcase>
                    <cfcase value="58"><cf_get_lang dictionary_id='57830.Verilen Fiyat Farkı Faturası'></cfcase>
                    <cfcase value="59"><cf_get_lang dictionary_id='57822.Mal Alım Faturası'></cfcase>
                    <cfcase value="60"><cf_get_lang dictionary_id='57813.Alınan Hizmet Faturası'></cfcase>
                    <cfcase value="61"><cf_get_lang dictionary_id='57814.Alınan Proforma Faturası'></cfcase>
                    <cfcase value="62"><cf_get_lang dictionary_id='57815.Alım Iade Fatura'></cfcase>
                    <cfcase value="63"><cf_get_lang dictionary_id='57811.Alınan Fiyat Farkı Faturası'></cfcase>
                    <cfcase value="64"><cf_get_lang dictionary_id='57823.Müstahsil Makbuzu'></cfcase>
                    <cfcase value="68"><cf_get_lang dictionary_id='29577.Serbest Meslek Makbuzu'></cfcase>
                </cfswitch>
            </span>
        </div>
        <div class="area_colmn">
            <label><cf_get_lang dictionary_id='57773.İrsaliye'></label>
            <span>: 
            	<cfquery name="GET_INVOICE_SHIP" datasource="#db_adres#">
                    SELECT SHIP_NUMBER,SHIP_ID FROM INVOICE_SHIPS WHERE INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_sale_det.invoice_id#">
                </cfquery>
                <cfif not len(get_invoice_ship.ship_number)>
                    <cf_get_lang dictionary_id='57774.İrsaliye Yok'>
                <cfelse>
                    #get_invoice_ship.ship_number#
                </cfif>
            </span>
        </div>
    </td><td>
        <div class="area_colmn">
            <label><cf_get_lang dictionary_id='58133.Fatura No'> </label>
            <span>: #get_sale_det.invoice_number#</span>
        </div>
        <div class="area_colmn">
            <label><cf_get_lang dictionary_id='58759.Fatura Tarihi'></label>
            <span>: #dateformat(get_sale_det.invoice_date,'dd/mm/yyyy')#</span>
        </div>
        <div class="area_colmn">
            <label><cf_get_lang dictionary_id='58211.Sipariş No'></label>
            <span>: 
            	<cfquery name="GET_ORDER" datasource="#db_adres#">
                    SELECT 
                        O.ORDER_NUMBER 
                    FROM 
                        INVOICE_SHIPS ISH,
                        #dsn3_alias#.ORDERS_SHIP OS,
                        #dsn3_alias#.ORDERS O
                    WHERE
                        ISH.INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_sale_det.invoice_id#"> AND 
                        ISH.SHIP_ID = OS.SHIP_ID AND 
                        O.ORDER_ID = OS.ORDER_ID
                </cfquery>
                <cfif not len(get_order.order_number)>
                    Sipariş yok
                <cfelse>
                    #get_order.order_number#
                </cfif>
            </span>
        </div>
        <div class="area_colmn">
            <label><cf_get_lang dictionary_id='58761.Sevk'></label>
            <span>: 
            	<cfif len(get_sale_det.ship_method)>
                  	#get_method.ship_method#
                </cfif>
            </span>
        </div>
        <div class="area_colmn">
            <label><cf_get_lang dictionary_id='58763.Depo'></label>
            <span>: 
            	<cfif len(get_sale_det.department_id)>
                  	#get_store.department_head#
                </cfif>
            </span>
        </div>
        <div class="area_colmn">
            <label><cf_get_lang dictionary_id='57629.Açıklama'></label>
            <span>: #get_sale_det.note#</span>
        </div>
</td></tr></table>
    <div class="area_colmn">
        <label><cf_get_lang dictionary_id='63895.Adres'></label>
        <span>: 
        	<cfif not isdefined("comp") and isdefined('get_cons_name')><!--- Bireysel Uye Fatura Adr. --->
                #get_cons_name.tax_adress# #get_cons_name.tax_semt# #get_cons_name.tax_postcode#<br/>
                <cfif len(get_cons_name.tax_county_id)>
                    <cfquery name="GET_COUNTY" datasource="#DSN#">
                        SELECT COUNTY_NAME FROM SETUP_COUNTY WHERE COUNTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_cons_name.tax_county_id#">
                    </cfquery>
                    #get_county.county_name#			  
                </cfif>
                <cfif len(get_cons_name.tax_city_id)>
                    <cfquery name="GET_CITY" datasource="#DSN#">
                        SELECT CITY_NAME FROM SETUP_CITY WHERE CITY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_cons_name.tax_city_id#">
                    </cfquery>
                    #get_city.city_name#
                </cfif>
                <cfif len(get_cons_name.tax_country_id)>
                    <cfquery name="GET_COUNTRY" datasource="#DSN#">
                        SELECT COUNTRY_NAME FROM SETUP_COUNTRY WHERE COUNTRY_ID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#get_cons_name.tax_country_id#">
                    </cfquery>					  
                    #get_country.country_name#
                </cfif>
            <cfelseif isdefined('get_sale_det_comp')><!--- Kurumsal Uye Adr. --->
                #get_sale_det_comp.company_address# #get_sale_det_comp.semt# #get_sale_det_comp.company_postcode#<br/>
                <cfif len(get_sale_det_comp.county)>
                    <cfquery name="GET_COUNTY" datasource="#DSN#">
                        SELECT COUNTY_NAME FROM SETUP_COUNTY WHERE COUNTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_sale_det_comp.county#">
                    </cfquery>
                    #get_county.county_name#			  
                </cfif>
                <cfif len(get_sale_det_comp.city)>
                    <cfquery name="GET_CITY" datasource="#DSN#">
                        SELECT CITY_NAME FROM SETUP_CITY WHERE CITY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_sale_det_comp.city#">
                    </cfquery>
                    #get_city.city_name#
                </cfif>
                <cfif len(get_sale_det_comp.country)>
                    <cfquery name="GET_COUNTRY" datasource="#DSN#">
                        SELECT COUNTRY_NAME FROM SETUP_COUNTRY WHERE COUNTRY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_sale_det_comp.country#">
                    </cfquery>					  
                    #get_country.country_name#
                </cfif>
            </cfif>				  
        </span>
    </div>
    <div class="list_scroll">
        <table class="objects2_list">
            <thead>
                <tr>
                    <th><cf_get_lang dictionary_id='57629.Açıklama'></th>
                    <th><cf_get_lang dictionary_id='57647.Spec'></th>
                    <th style="text-align:right;"><cf_get_lang dictionary_id='57635.Miktar'></th>
                    <th><cf_get_lang dictionary_id='57636.Birim'></th>
                    <th style="text-align:right;"><cf_get_lang dictionary_id='57638.B Fiyat'></th>
                    <th style="text-align:right;"><cf_get_lang dictionary_id='57639.KDV'></th>
                    <th style="text-align:right;"><cf_get_lang dictionary_id='64379.ISK 1'></th>
                    <th style="text-align:right;"><cf_get_lang dictionary_id='64380.ISK 2'></th>
                    <th style="text-align:right;"><cf_get_lang dictionary_id='64347.ISK 3'></th>
                    <th style="text-align:right;"><cf_get_lang dictionary_id='64348.ISK 4'></th>
                    <th style="text-align:right;"><cf_get_lang dictionary_id='64349.ISK 5'></th>
                    <th><cf_get_lang dictionary_id='58560.İndirim'><cf_get_lang dictionary_id='57492.Toplam'></th> 
                    <th style="text-align:right;"><cf_get_lang dictionary_id='58083.Net'> <cf_get_lang dictionary_id='57638.Birim Fiyat'></th>
                    <th style="text-align:right;"><cf_get_lang dictionary_id='57492.Toplam'></th>
                    <th style="text-align:right;"><cf_get_lang dictionary_id='57677.Döviz'></th> 
                    <th style="text-align:right;"><cf_get_lang dictionary_id='57642.Net Toplam'></th>
                </tr>
            </thead>
            <tbody>
            	<cfinclude template="../query/show_sales_basket.cfm">
                <cfset toplam_indirim_miktari=0>
                <cfset list_kdv = ListSort(list_kdv,"textnocase", "asc")>
                <cfloop from="1" to="#arraylen(invoice_bill_upd)#" index="i">
                    <tr class="odd">
                        <td style="width:30px;">#invoice_bill_upd[i][2]#</td>
                        <td>
                        	<cfif invoice_bill_upd[i][32] eq 1>
                                #invoice_bill_upd[i][33]#
                            </cfif>
                        </td>
                        <td style="text-align:right">#invoice_bill_upd[i][4]#</td>
                        <td>#invoice_bill_upd[i][5]#</td>
                        <td style="text-align:right">#TLFormat(invoice_bill_upd[i][6])#</td>
                        <td>#invoice_bill_upd[i][7]#</td>
                        <td>#invoice_bill_upd[i][20]#</td>
                        <td>#invoice_bill_upd[i][21]#</td>
                        <td>#invoice_bill_upd[i][22]#</td>
                        <td>#invoice_bill_upd[i][23]#</td>
                        <td>#invoice_bill_upd[i][24]#</td>
                        <td>
                        	#TLFormat(invoice_bill_upd[i][8])#
                            <cfif not len(invoice_bill_upd[i][8])><cfset invoice_bill_upd[i][8]=0></cfif>
                            <cfset toplam_indirim_miktari = toplam_indirim_miktari+invoice_bill_upd[i][8]>
                        </td>
                        <td>#TLFormat(invoice_bill_upd[i][16] / invoice_bill_upd[i][4])#</td>
                        <td>#TLFormat(invoice_bill_upd[i][15])#</td>
                        <td>#TLFormat(invoice_bill_upd[i][30])#&nbsp;<cfif (isdefined("session.pp.money2") and len(session.pp.money2)) or (isdefined("session.ww.money2") and len(session.ww.money2)) >#invoice_bill_upd[i][31]#</cfif></td>
                        <td>#TLFormat(invoice_bill_upd[i][16])#</td>
                    </tr>
                </cfloop>
            </tbody>
        </table>
    </div>
    <div class="area_colmn">
        <table style="width:100%;">
            <tr>
                <td style="vertical-align:top;"><div class="area_colmn">#get_money_info.money_type#&nbsp;&nbsp;&nbsp;&nbsp;1&nbsp;/&nbsp;&nbsp;#TLFormat(get_money_info.rate2,4)#</div></td>
                <td>
                    <div class="area_colmn">
                        <label><cf_get_lang dictionary_id='57492.Toplam'></label>
                        <span>: 
                        	#TLFormat(get_sale_det.grosstotal)# &nbsp;&nbsp;&nbsp;&nbsp; #TLFormat(get_sale_det.grosstotal/get_money_info.rate2)#
                        </span>
                    </div>
                    <div class="area_colmn">
                        <label><cf_get_lang dictionary_id='57649.Toplam İndirim'></label>
                        <span>: 
                        	#TLFormat(toplam_indirim_miktari+get_sale_det.sa_discount)# &nbsp;&nbsp;&nbsp;&nbsp;
                        	<cfset doviz_indirim = (toplam_indirim_miktari+get_sale_det.sa_discount)/get_money_info.rate2>
                        	&nbsp;&nbsp;&nbsp;&nbsp;#TLFormat(doviz_indirim)#
                        </span>
                    </div>
                    <div class="area_colmn">
                        <label><cf_get_lang dictionary_id='58765.Satıraltı İndirim'></label><span>: #TLFormat(get_sale_det.sa_discount)#</span>
                    </div>
                    <div class="area_colmn">
                        <label><cf_get_lang dictionary_id='57710.Yuvarlama'></label><span>: #TLFormat(get_sale_det.round_money)#</span>
                    </div>
                    <cfif (get_sale_det.nettotal-get_sale_det.taxtotal+get_sale_det.sa_discount) neq 0>
						<cfset kdvcarpan = 1-(get_sale_det.sa_discount/(get_sale_det.nettotal-get_sale_det.taxtotal+get_sale_det.sa_discount))>
                    <cfelse>
                        <cfset kdvcarpan = 1>
                    </cfif>
                    <cfloop from="1" to="#arraylen(sepet.kdv_array)#" index="m">
                        <div class="area_colmn">
                            <label><cf_get_lang dictionary_id='57639.KDV'> % #sepet.kdv_array[m][1]#</label>
                            <span>: #TLFormat(sepet.kdv_array[m][2]*kdvcarpan)#</span>
                        </div>
                    </cfloop>
                    <div class="area_colmn">
                        <label><cf_get_lang dictionary_id='57643.Toplam KDV'></label>
                        <span>: 
                        	#TLFormat(get_sale_det.taxtotal)# &nbsp;&nbsp;&nbsp;&nbsp;
                        	<cfset doviz_toplamkdv = get_sale_det.taxtotal/get_money_info.rate2>
                            &nbsp;&nbsp;#TLFormat(doviz_toplamkdv)#
                        </span>
                    </div>
                    <div class="area_colmn">
                        <label><cf_get_lang dictionary_id='57680.Genel Toplam'></label>
                        <span>: 
                        	#TLFormat(get_sale_det.nettotal)# &nbsp;&nbsp;&nbsp;&nbsp;
                        	<cfset doviz_tutar = get_sale_det.nettotal/get_money_info.rate2>
                            &nbsp;&nbsp;#TLFormat(doviz_tutar)#
                        </span>
                    </div>
                </td>
            </tr>
        </table>
    </div>
</hgroup>

</cfoutput>

