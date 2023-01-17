<div class="tableBox">
    <!--- Satinalma Teklifi Karsilastirma Tablosu --->
    <cfsetting showdebugoutput="no">
    <cfquery name="get_basket_offer_info_" datasource="#dsn3#">
        SELECT PRICE_ROUND_NUMBER, BASKET_TOTAL_ROUND_NUMBER FROM SETUP_BASKET WHERE BASKET_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.basket_id#">
    </cfquery>
    <cfquery name="get_coming_for_offer_row" datasource="#dsn3#">
        SELECT
            ORW.WRK_ROW_ID,
            (SELECT STOCK_CODE FROM STOCKS WHERE STOCK_ID = ORW.STOCK_ID) STOCK_CODE,
            ORW.STOCK_ID,
            ORW.PRODUCT_NAME,
            ORW.QUANTITY,
            ORW.UNIT,
            ((((ORW.QUANTITY*ORW.PRICE)+ ORW.EXTRA_PRICE_TOTAL)/100000000000000000000)*((100-DISCOUNT_1)*(100- DISCOUNT_2)*(100-DISCOUNT_3)*(100-DISCOUNT_4)*(100-DISCOUNT_5)*(100-DISCOUNT_6)*(100-DISCOUNT_7)*(100-DISCOUNT_8)*(100-DISCOUNT_9)*(100-DISCOUNT_10))/ORW.QUANTITY) NET_PRICE
        FROM
            OFFER O,
            OFFER_ROW ORW
        WHERE
            O.OFFER_ID = ORW.OFFER_ID AND
            O.OFFER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.offer_id#">
        ORDER BY
            ORW.OFFER_ROW_ID
    </cfquery>
    <cfquery name="get_coming_offer_row" datasource="#dsn3#">
        SELECT
            ORW.WRK_ROW_RELATION_ID,
            ORW.STOCK_ID,
            <!--- ((((ORW.QUANTITY*ORW.PRICE)+ ORW.EXTRA_PRICE_TOTAL)/100000000000000000000)*((100-DISCOUNT_1)*(100- DISCOUNT_2)*(100-DISCOUNT_3)*(100-DISCOUNT_4)*(100-DISCOUNT_5)*(100-DISCOUNT_6)*(100-DISCOUNT_7)*(100-DISCOUNT_8)*(100-DISCOUNT_9)*(100-DISCOUNT_10))/ORW.QUANTITY) NET_PRICE, --->
            ((((ORW.QUANTITY*ORW.PRICE)+ ORW.EXTRA_PRICE_TOTAL))/ORW.QUANTITY) NET_PRICE,
            O.OFFER_ID,
            ((((ORW.PRICE)+ ORW.EXTRA_PRICE_TOTAL)/100000000000000000000)*((100-DISCOUNT_1)*(100- DISCOUNT_2)*(100-DISCOUNT_3)*(100-DISCOUNT_4)*(100-DISCOUNT_5)*(100-DISCOUNT_6)*(100-DISCOUNT_7)*(100-DISCOUNT_8)*(100-DISCOUNT_9)*(100-DISCOUNT_10))) - (ORW.DISCOUNT_COST*OM.RATE2/OM.RATE1) NOT_ISK_NET_PRICE, 
            ORW.QUANTITY
        FROM
            OFFER O,
            OFFER_ROW ORW,
            OFFER_MONEY OM 
        WHERE
            O.OFFER_ID = ORW.OFFER_ID AND
            O.FOR_OFFER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.offer_id#"> AND
            OM.MONEY_TYPE=ORW.OTHER_MONEY AND
            OM.ACTION_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.offer_id#"> AND 
            ORW.STOCK_ID IN (<cfqueryparam value="#valuelist(get_coming_for_offer_row.stock_id)#" cfsqltype="cf_sql_integer" list="yes">)
        ORDER BY
            O.OFFER_TO_PARTNER,
            ORW.STOCK_ID,
            ORW.OFFER_ROW_ID
    </cfquery>
    <cfquery name="get_coming_offer" datasource="#dsn3#">
        SELECT FOR_OFFER_ID,OFFER_TO_PARTNER,OFFER_ID,SHIP_METHOD,PAYMETHOD,OFFER_TO,DELIVERDATE,DELIVER_PLACE,LOCATION_ID,OFFER_NUMBER,REVISION_NUMBER FROM OFFER WHERE FOR_OFFER_ID = #attributes.offer_id# <cfif len(get_coming_offer_row.offer_id)>AND OFFER_ID IN (#ValueList(get_coming_offer_row.offer_id)#)</cfif> ORDER BY OFFER_TO_PARTNER,REVISION_OFFER_ID,REVISION_NUMBER
    </cfquery>
    <cfoutput query="get_coming_for_offer_row">
        <cfset 'max_satir_miktar_#get_coming_for_offer_row.currentrow#' = 0>
        <cfset 'offer_id_max_satir#get_coming_for_offer_row.currentrow#' = 0>
        <cfset currentrow_ = 0>
        <cfloop query="get_coming_offer_row">
            <cfif get_coming_for_offer_row.wrk_row_id[get_coming_for_offer_row.currentrow] eq get_coming_offer_row.wrk_row_relation_id[get_coming_offer_row.currentrow]>
                <cfset "total_price_#get_coming_for_offer_row.wrk_row_id[get_coming_for_offer_row.currentrow]#_#get_coming_offer_row.offer_id#" = get_coming_offer_row.net_price>
                <cfset "total_not_isk_total_price_#get_coming_for_offer_row.wrk_row_id[get_coming_for_offer_row.currentrow]#_#get_coming_offer_row.offer_id#"=get_coming_offer_row.not_isk_net_price>
                <cfset "total_price_quantity_#get_coming_for_offer_row.wrk_row_id[get_coming_for_offer_row.currentrow]#_#get_coming_offer_row.offer_id#" = get_coming_offer_row.quantity>
                <!--- satır olarak en uygun fiyat belirlenir--->
                <cfset currentrow_ = currentrow_ + 1>
                <cfif currentrow_ eq 1>
                    <cfset 'offer_id_max_satir#get_coming_for_offer_row.currentrow#' = get_coming_offer_row.offer_id>
                    <cfset 'max_satir_miktar_#get_coming_for_offer_row.currentrow#' = get_coming_offer_row.not_isk_net_price> 
                <cfelseif get_coming_offer_row.not_isk_net_price lt evaluate('max_satir_miktar_#get_coming_for_offer_row.currentrow#')> 
                    <cfset 'offer_id_max_satir#get_coming_for_offer_row.currentrow#' = get_coming_offer_row.offer_id>
                    <cfset 'max_satir_miktar_#get_coming_for_offer_row.currentrow#' = get_coming_offer_row.not_isk_net_price>
                <cfelseif get_coming_offer_row.not_isk_net_price lte evaluate('max_satir_miktar_#get_coming_for_offer_row.currentrow#')>
                    <cfset 'offer_id_max_satir#get_coming_for_offer_row.currentrow#' = listappend(evaluate('offer_id_max_satir#get_coming_for_offer_row.currentrow#'),get_coming_offer_row.offer_id)>
                    <cfset 'max_satir_miktar_#get_coming_for_offer_row.currentrow#' = get_coming_offer_row.not_isk_net_price>
                </cfif>
                <!--- satır olarak en uygun fiyat belirlenir--->
            </cfif>
            <cfset 'toplam_isk_fiyat_#get_coming_offer_row.offer_id[get_coming_offer_row.currentrow]#' = 0>
            <cfset 'toplam_fiyat_#get_coming_offer_row.offer_id[get_coming_offer_row.currentrow]#' = 0>
            <cfset 'toplam_miktar_#get_coming_offer_row.offer_id[get_coming_offer_row.currentrow]#' = 0>
            <cfset 'sum_quantity_#get_coming_offer_row.offer_id[get_coming_offer_row.currentrow]#' = 0>
        </cfloop>
    </cfoutput>
    <cfsavecontent variable="title"><cf_get_lang dictionary_id='38685.Gelen Teklifler'></cfsavecontent>
    <cf_box title="#title#" uidrop="1" hide_table_column="1" responsive_table="1" woc_setting = "#{ checkbox_name : 'is_selected_product', print_type : 90 }#">
        <cfform name="form_basket_inner" method="post" action="#request.self#?fuseaction=purchase.list_order&event=add">
            <input type="hidden" name="for_offer_stock_id" id="for_offer_stock_id" value=""><!--- js ten deger ataniyor kaldirmayin --->
            <input type="hidden" name="for_offer_id" id="for_offer_id" value=""><!--- js ten deger ataniyor kaldirmayin --->
            <!-- sil -->
            <cf_grid_list>
                <thead>
                    <tr>
                        <th rowspan="2"><cf_get_lang dictionary_id='57487.No'></th>
                        <th rowspan="2" width="100"><cf_get_lang dictionary_id='57518.Stok Kodu'></th>
                        <th rowspan="2"><cf_get_lang dictionary_id='57657.Ürün'></th>
                        <th rowspan="2" width="50"><cf_get_lang dictionary_id='57635.Miktar'></th>
                        <th rowspan="2" style="text-align:center;"><cf_get_lang dictionary_id='57636.Birim'></th>
                        <th rowspan="2" style="text-align:right;"><cf_get_lang dictionary_id='38500.Ortalama Alış'></th>
                        <th rowspan="2" style="text-align:right;"><cf_get_lang dictionary_id='57638.Birim Fiyat'></th>
                        <th rowspan="2" width="40" style="text-align:center;"><cf_get_lang dictionary_id='58474.PBirimi'></th>
                        <cfloop query="get_coming_offer">
                            <th colspan="3" style="text-align:center">
                                <cfoutput>
                                <input type="checkbox" name="is_member_offer" id="is_member_offer#currentrow#" onclick="member_control(#offer_id#);" title="<cf_get_lang dictionary_id='58693.Seç'>" value="#offer_id#">
                                    #get_par_info(listdeleteduplicates(offer_to_partner),0,1,0,1)#/#OFFER_NUMBER#<cfif REVISION_NUMBER neq ''>/R-#REVISION_NUMBER#</cfif>
                                </cfoutput>
                            </th>
                        </cfloop>
                        <!-- sil -->
                        <th rowspan="2" width="20" style="text-align:center">
                            <cfif get_coming_offer.recordcount><input type="checkbox" name="is_convert_all" id="is_convert_all" onclick="hepsini_sec(this.checked);" title="<cf_get_lang dictionary_id='58081.Hepsi'>" value="1"></cfif>
                        </th>
                        <!-- sil -->
                    </tr>
                    <tr>
                        <cfloop query="get_coming_offer">
                            <th style="text-align:right;" nowrap="nowrap"><cf_get_lang dictionary_id="58083.Net"> <cf_get_lang dictionary_id="58084.Fiyat"></th>
                            <th style="text-align:right;" nowrap="nowrap"><cf_get_lang dictionary_id="57635.Miktar"></th>
                            <th style="text-align:right;" nowrap="nowrap"><cf_get_lang dictionary_id='57492.Toplam'></th>
                        </cfloop>
                    </tr> 
                </thead>
                <!--- ortalama alis fiyati hesaplanir --->
                <cfset stock_id_list_ = ''>
                <cfoutput query="get_coming_for_offer_row">
                    <cfif len(stock_id) and not listfind(stock_id_list_,stock_id)>
                        <cfset stock_id_list_=listappend(stock_id_list_,stock_id)>
                    </cfif>
                </cfoutput>
                <cfquery name="get_price_average_" datasource="#dsn2#">
                    SELECT PRICE,STOCK_ID FROM INVOICE_ROW WHERE STOCK_ID IN (#stock_id_list_#)
                </cfquery>
                <!--- ortalama alis fiyati hesaplanir --->
                <tbody>
                    <cfif get_coming_for_offer_row.recordcount and get_coming_offer_row.recordcount>
                        <cfoutput query="get_coming_for_offer_row">
                            <tr>
                                <td style="width:10px;">#currentrow#</td>
                                <td>#stock_code#</td>
                                <td>#product_name#</td>
                                <td style="text-align:center;">#quantity#</td>
                                <td style="text-align:center;">#unit#</td>
                                <td style="text-align:right;">
                                <cfquery name="get_price_average" dbtype="query">
                                    SELECT AVG(PRICE) AVG_PRICE FROM get_price_average_ WHERE STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#stock_id#">
                                </cfquery>
                                #TLFormat(get_price_average.AVG_PRICE,2)#
                                </td>
                                <td style="text-align:right;">#TLFormat(net_price,get_basket_offer_info_.price_round_number)#</td>
                                <td style="text-align:center;">#session.ep.money#  </td>
                                <cfloop from="1" to="#get_coming_offer.recordcount#" index="fr">
                                    <cfif isdefined("total_price_#wrk_row_id#_#get_coming_offer.offer_id[fr]#")>
                                        <cfset price_row = evaluate("total_price_#wrk_row_id#_#get_coming_offer.offer_id[fr]#")>
                                    <cfelse>
                                        <cfset price_row = 0>
                                    </cfif>
                                    <cfif isdefined("total_not_isk_total_price_#wrk_row_id#_#get_coming_offer.offer_id[fr]#")>
                                        <cfset not_isk_row=evaluate("total_not_isk_total_price_#wrk_row_id#_#get_coming_offer.offer_id[fr]#")>
                                    <cfelse>
                                        <cfset not_isk_row=0>
                                    </cfif>
                                    <cfif isdefined("total_price_quantity_#wrk_row_id#_#get_coming_offer.offer_id[fr]#")>
                                        <cfset quantity_row = evaluate("total_price_quantity_#wrk_row_id#_#get_coming_offer.offer_id[fr]#")>
                                    <cfelse>
                                        <cfset quantity_row = 0>
                                    </cfif>
                                    <td style="text-align:right">
                                        <cfif (not_isk_row-net_price) neq 0 and not_isk_row neq 0><font color="##FF0000">(<cfif (not_isk_row-net_price) gt 0>+</cfif>#TLFormat(not_isk_row-net_price,get_basket_offer_info_.price_round_number)#) </font></cfif>#TLFormat(not_isk_row,get_basket_offer_info_.price_round_number)#
                                    </td>
                                    <td style="text-align:right">
                                        <cfif (quantity_row - quantity) neq 0 and quantity_row neq 0><font color="##FF0000">(#quantity_row - quantity#) </font></cfif>#quantity_row#
                                    </td>
                                    <td style="text-align:right">
                                        #tlformat(not_isk_row*quantity_row,get_basket_offer_info_.price_round_number)#
                                    </td>
                                    <cfset 'toplam_isk_fiyat_#get_coming_offer.offer_id[fr]#' = evaluate('toplam_isk_fiyat_#get_coming_offer.offer_id[fr]#') + not_isk_row>
                                    <cfset 'toplam_fiyat_#get_coming_offer.offer_id[fr]#' = evaluate('toplam_fiyat_#get_coming_offer.offer_id[fr]#') + price_row>
                                    <cfset 'toplam_miktar_#get_coming_offer.offer_id[fr]#' = evaluate('toplam_miktar_#get_coming_offer.offer_id[fr]#') + (not_isk_row*quantity_row)>
                                    <cfset 'sum_quantity_#get_coming_offer.offer_id[fr]#' = evaluate('sum_quantity_#get_coming_offer.offer_id[fr]#') + quantity_row>
                                </cfloop>
                                <!-- sil --><td style="text-align:center"><input type="checkbox" name="is_selected_product" id="is_selected_product" title="#product_name#" value="#stock_id#-#wrk_row_id#"></td><!-- sil -->
                            </tr>
                        </cfoutput>
                        <tr>
                            <td colspan="8"><cf_get_lang dictionary_id='57492.Toplam'>&nbsp;</td>
                             <!--- genel toplam olarak en uygun fiyat belirlenir--->
                            <cfset max_toplam_miktar_ = 0>
                            <cfset offer_id_max_toplam = ''>
                            <cfset currentrow_ = 0>
                            <cfoutput query="get_coming_offer">
                                 <cfif currentrow eq 1>
                                    <cfset offer_id_max_toplam = get_coming_offer.offer_id>
                                    <cfset max_toplam_miktar_= evaluate('toplam_miktar_#get_coming_offer.offer_id#')>
                                <cfelseif evaluate('toplam_miktar_#get_coming_offer.offer_id[currentrow]#') eq max_toplam_miktar_>
                                    <cfset offer_id_max_toplam = listappend(offer_id_max_toplam,get_coming_offer.offer_id)>
                                    <cfset max_toplam_miktar_= evaluate('toplam_miktar_#get_coming_offer.offer_id#')>
                                <cfelseif evaluate('toplam_miktar_#get_coming_offer.offer_id[currentrow]#') lt max_toplam_miktar_>
                                    <cfset offer_id_max_toplam = get_coming_offer.offer_id>
                                   <cfset max_toplam_miktar_= evaluate('toplam_miktar_#get_coming_offer.offer_id#')>
                                </cfif>
                            </cfoutput>
                             <!--- genel toplam olarak en uygun fiyat belirlenir--->
                            <cfoutput query="get_coming_offer">
                                <td style="text-align:right">
                                    #TLFormat(evaluate('toplam_isk_fiyat_#offer_id#'),get_basket_offer_info_.basket_total_round_number)#
                                </td>
                                <td style="text-align:right">
                                    #evaluate('sum_quantity_#offer_id#')#
                                </td>
                                <td style="text-align:right">
                                    #TLFormat(evaluate('toplam_miktar_#offer_id#'),get_basket_offer_info_.basket_total_round_number)#
                                </td>
                            </cfoutput>
                            <td></td>
                        </tr>
                        <tr>
                            <td colspan="8"><cf_get_lang dictionary_id='29500.Sevk Yöntemi'> - <cf_get_lang dictionary_id='57645.Teslim Tarihi'></td>
                            <cfif get_coming_offer.recordcount>
                                <cfset ship_method_list = "">
                                <cfset paymethod_list = "">
                                <cfset company_list = "">
                                <cfoutput query="get_coming_offer">
                                    <cfif len(ship_method) and not listfind(ship_method_list,ship_method)>
                                        <cfset ship_method_list=listappend(ship_method_list,ship_method)>
                                    </cfif>
                                </cfoutput>
                                <cfif len(ship_method_list)>
                                    <cfquery name="get_ship_method" datasource="#dsn#">
                                        SELECT SHIP_METHOD_ID, SHIP_METHOD FROM SHIP_METHOD WHERE SHIP_METHOD_ID IN (<cfqueryparam value="#ship_method_list#" cfsqltype="cf_sql_integer" list="yes">) ORDER BY SHIP_METHOD_ID
                                    </cfquery>
                                    <cfset ship_method_list = listsort(listdeleteduplicates(valuelist(get_ship_method.ship_method_id,',')),'numeric','ASC',',')>
                                </cfif>
                                <cfoutput query="get_coming_offer">
                                    <td colspan="3" style="text-align:right;">
                                        <cfif len(ship_method)>#get_ship_method.ship_method[listfind(ship_method_list,ship_method,',')]# - #DateFormat(deliverdate,dateformat_style)#</cfif>
                                    </td>
                                </cfoutput>
                            </cfif>
                            <td></td>
                        </tr>
                        <tr>
                             
                            <cfoutput>
                                <td colspan="#9+(get_coming_offer.recordcount*3)#">
                                    <!-- del -->
                                    <cfsavecontent variable="ButtonName"><cf_get_lang dictionary_id='41173.Sipariş oluştur'></cfsavecontent>
                                    <div class="pull-left"><cf_workcube_buttons add_function='kontrol_coming_offer()' is_upd='0' is_cancel='0' insert_info='#ButtonName#' insert_alert=''></div>
                                    <!-- del -->
                                </td>
                            </cfoutput>
                           
                        </tr> 
                        <cfif len(offer_id_max_toplam)>
                            <tr><!--- en uygun fiyatli gelen teklif --->
                                <cfquery name="get_offer_to_partner" datasource="#dsn3#">
                                    SELECT OFFER_TO_PARTNER FROM OFFER WHERE OFFER_ID IN(#offer_id_max_toplam#)
                                </cfquery>
                                <cfoutput>
                                    <td colspan="#9+(get_coming_offer.recordcount*3)#" style="text-align:center">
                                        <font color="##FF0000">
                                            <cf_get_lang dictionary_id='38525.En Uygun Teklif(Fiyat Performans Açısından)'>
                                            <cfloop query="get_offer_to_partner">
                                                #get_par_info(listdeleteduplicates(get_offer_to_partner.offer_to_partner),0,1,0)# <cfif get_offer_to_partner.currentrow neq get_offer_to_partner.recordcount>,</cfif>
                                            </cfloop>
                                             <cf_get_lang dictionary_id='38524.Tedarikçisinden Gelmiştir'>
                                        </font>
                                    </td>
                                </cfoutput>
                            </tr>
                        </cfif>
                    <cfelse>
                        <tr>
                            <td colspan="<cfoutput>#get_coming_offer.recordcount+9#</cfoutput>"><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>
                        </tr>
                    </cfif>
                </tbody>
            </cf_grid_list> 
            <!-- sil -->
            <!--- <cf_medium_list>
                <thead>
                    <tr>
                        <th><cf_get_lang dictionary_id='75.No'></th>
                        <th nowrap><cf_get_lang dictionary_id='1736.Tedarikçi'></th>
                        <th nowrap><cf_get_lang dictionary_id='1703.Sevk Yöntemi'></th>
                        <th nowrap><cf_get_lang dictionary_id='1104.Ödeme Yöntemi'></th>
                        <th nowrap width="80" align="center"><cf_get_lang dictionary_id='233.Teslim Tarihi'></th>
                        <th nowrap><cf_get_lang dictionary_id='1037.Teslim Yeri'></th>
                        <th nowrap style="text-align:right;"><cf_get_lang dictionary_id='175.Borç'></th>
                        <th nowrap style="text-align:right;"><cf_get_lang dictionary_id='176.Alacak'></th>
                        <th nowrap style="text-align:right;"><cf_get_lang dictionary_id='177.Bakiye'></th>
                    </tr>
                </thead>
                <tbody>
                    <cfif get_coming_offer.recordcount>
                        <cfset ship_method_list = "">
                        <cfset paymethod_list = "">
                        <cfset company_list = "">
                        <cfoutput query="get_coming_offer">
                            <cfif len(ship_method) and not listfind(ship_method_list,ship_method)>
                                <cfset ship_method_list=listappend(ship_method_list,ship_method)>
                            </cfif>
                            <cfif len(paymethod) and not listfind(paymethod_list,paymethod)>
                                <cfset paymethod_list=listappend(paymethod_list,paymethod)>
                            </cfif>
                            <cfif len(offer_to) and not listfind(company_list,offer_to)>
                                <cfset company_list=listappend(company_list,offer_to)>
                            </cfif>
                        </cfoutput>
                        <cfif len(ship_method_list)>
                            <cfquery name="get_ship_method" datasource="#dsn#">
                                SELECT SHIP_METHOD_ID, SHIP_METHOD FROM SHIP_METHOD WHERE SHIP_METHOD_ID IN (<cfqueryparam value="#ship_method_list#" cfsqltype="cf_sql_integer" list="yes">) ORDER BY SHIP_METHOD_ID
                            </cfquery>
                            <cfset ship_method_list = listsort(listdeleteduplicates(valuelist(get_ship_method.ship_method_id,',')),'numeric','ASC',',')>
                        </cfif>
                        <cfif len(paymethod_list)>
                            <cfquery name="get_paymethod" datasource="#dsn#">
                                SELECT PAYMETHOD_ID, PAYMETHOD FROM SETUP_PAYMETHOD WHERE PAYMETHOD_ID IN (<cfqueryparam value="#paymethod_list#" cfsqltype="cf_sql_integer" list="yes">) ORDER BY PAYMETHOD_ID
                            </cfquery>
                            <cfset paymethod_list = listsort(listdeleteduplicates(valuelist(get_paymethod.paymethod_id,',')),'numeric','ASC',',')>
                        </cfif>
                        <cfif len(company_list)>
                            <cfset company_list = listsort(listdeleteduplicates(company_list),"numeric","asc",",")>
                            <cfquery name="get_remainder" datasource="#dsn2#">
                                SELECT COMPANY_ID, BORC, ALACAK, (BORC-ALACAK) BAKIYE FROM COMPANY_REMAINDER WHERE COMPANY_ID IN (<cfqueryparam value="#company_list#" cfsqltype="cf_sql_integer" list="yes">) ORDER BY COMPANY_ID
                            </cfquery>
                            <cfset company_list = listsort(listdeleteduplicates(valuelist(get_remainder.company_id,',')),"numeric","asc",",")>
                        </cfif>
                        <cfoutput query="get_coming_offer">
                            <tr>
                                <td>#currentrow#</td>
                                <td width="200">#get_par_info(listdeleteduplicates(offer_to_partner),0,1,0)#</td>
                                <td><cfif len(ship_method)>#get_ship_method.ship_method[listfind(ship_method_list,ship_method,',')]#</cfif></td>
                                <td><cfif len(paymethod)>#get_paymethod.paymethod[listfind(paymethod_list,paymethod,',')]#</cfif></td>
                                <td align="center">#DateFormat(deliverdate,dateformat_style)#</td>
                                <td><cfset location_info_ = get_location_info(deliver_place,location_id,1,1)>
                                    <cfset deliver_state = listfirst(location_info_,',')>
                                    #deliver_state#
                                </td>
                                <td nowrap style="text-align:right;"><cfif len(get_remainder.borc[listfind(company_list,listdeleteduplicates(offer_to),',')])>#TLFormat(abs(get_remainder.borc[listfind(company_list,listdeleteduplicates(offer_to),',')]))#<cfelse>-</cfif></td>
                                <td nowrap style="text-align:right;"><cfif len(get_remainder.alacak[listfind(company_list,listdeleteduplicates(offer_to),',')])>#TLFormat(abs(get_remainder.alacak[listfind(company_list,listdeleteduplicates(offer_to),',')]))#<cfelse>-</cfif></td>
                                <td nowrap style="text-align:right;"><cfif len(get_remainder.bakiye[listfind(company_list,listdeleteduplicates(offer_to),',')])>#TLFormat(abs(get_remainder.bakiye[listfind(company_list,listdeleteduplicates(offer_to),',')]))# <cfif get_remainder.bakiye[listfind(company_list,listdeleteduplicates(offer_to),',')] gt 0>(B)<cfelse>(A)</cfif><cfelse>-</cfif></td>
                            </tr>
                        </cfoutput>
                    <cfelse>
                        <tr>
                            <td colspan="9"><cf_get_lang dictionary_id='72.Kayıt Yok'>!</td>
                        </tr>
                    </cfif>
                </tbody>
            </cf_medium_list> --->
        </cfform>
    </cf_box>
    <!-- sil -->
    <script type="text/javascript">
        function hepsini_sec(is_checked_)
        {
            var product_leng = document.getElementsByName('is_selected_product').length;
            for(Pind=0;Pind<product_leng;Pind=Pind+1){
                my_obj_prod = (product_leng == 1)?document.getElementById('is_selected_product'):document.form_basket_inner.is_selected_product[Pind];
                my_obj_prod.checked = (is_checked_ == true)?true:false;
            }
        }
        function member_control(x)
        {
            var comp_leng=document.getElementsByName('is_member_offer').length;
            for(sind=1;sind<=comp_leng;sind=sind+1){
                my_obj = document.getElementById('is_member_offer'+sind);
                if(my_obj.value != x)
                    my_obj.checked = false;
            }
        }
        function kontrol_coming_offer()
        {
            var offer_id_list = '';
            var selected_comp = 0;
            var comp_leng=document.getElementsByName('is_member_offer').length;
            for(sind=1;sind<=comp_leng;sind=sind+1){
                //my_obj = (comp_leng == 1)?document.getElementById('is_member_offer'):document.form_basket_inner.is_member_offer[sind];
                my_obj = document.getElementById('is_member_offer'+sind);
                if(my_obj.checked == true){
                    selected_comp++;
                    offer_id_list=my_obj.value;
                }
                document.getElementById('for_offer_id').value = offer_id_list;
            }
            if(selected_comp==0){
                alert("<cf_get_lang dictionary_id='57785.Üye Seçmelisiniz'>!");
                return false;
            }
            
            var stock_id_list = '';
            var selected_prod = 0;
            var product_leng = document.getElementsByName('is_selected_product').length;
            for(Pind=0;Pind<product_leng;Pind=Pind+1){
                my_obj_prod = (product_leng == 1)?document.getElementById('is_selected_product'):document.form_basket_inner.is_selected_product[Pind];
                if(my_obj_prod.checked == true){
                    selected_prod++;
                    stock_id_list+=my_obj_prod.value+',';
                }
            document.getElementById('for_offer_stock_id').value = stock_id_list;
            }	
            if(selected_prod==0){
                alert("<cf_get_lang dictionary_id='58227.Ürün Seçmelisiniz'>!");
                return false;
            }
            return true;
        }
    </script>
    <!-- sil -->
</div>    
