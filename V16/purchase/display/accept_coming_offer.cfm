<cfparam name="attributes.modal_id" default="" />

<cfif isDefined('attributes.is_submit')>
    <!--- <cfif isDefined('attributes.is_accept_offer') and len(attributes.is_accept_offer)> --->
        <cfset cmp = createObject("component","V16.purchase.cfc.offer_management") />
        <cfset result = cmp.updOfferRowAccepted(
                for_offer_id : attributes.for_offer_id,
                is_accept_offer : '#iIf(isDefined("attributes.is_accept_offer") and len(attributes.is_accept_offer), "attributes.is_accept_offer", DE(""))#'
            ) />
    <!--- </cfif> --->
    <script type="text/javascript">
        <cfif isDefined('attributes.draggable')>closeBoxDraggable(<cfoutput>#attributes.modal_id#</cfoutput>)<cfelse>window.close()</cfif>;
    </script>
</cfif>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
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
            ORW.OFFER_ROW_ID,
            ORW.IS_ACCEPTED_ROW,
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
                <cfset "offer_row_id_#get_coming_for_offer_row.wrk_row_id[get_coming_for_offer_row.currentrow]#_#get_coming_offer_row.offer_id#" = get_coming_offer_row.OFFER_ROW_ID>
                <cfset "offer_row_accepted_#get_coming_for_offer_row.wrk_row_id[get_coming_for_offer_row.currentrow]#_#get_coming_offer_row.offer_id#" = get_coming_offer_row.IS_ACCEPTED_ROW>
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
    <cfif not (attributes.fuseaction contains 'emptypopup')>
        <cfsavecontent variable="title"><cf_get_lang dictionary_id='38685.Gelen Teklifler'></cfsavecontent>
        <cf_medium_list_search title="#title#">
            <cf_medium_list_search_area>
                <table>
                    <tr>
                        <td style="text-align:right"><cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'></td>
                    </tr>
                </table>
            </cf_medium_list_search_area>
        </cf_medium_list_search>
    </cfif>
    <cfif not (attributes.fuseaction contains 'emptypopup')><br/></cfif>
    <cfform name="accept_coming_offer" method="post" action="">
        <cf_box id="accept_coming_offer" title="#getLang('','Gelen Teklif Kabulü',63126)#" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
            <cf_box_elements>
                <input type="hidden" name="is_submit" id="is_submit" value="1">
                <input type="hidden" name="for_offer_stock_id" id="for_offer_stock_id" value=""><!--- js ten deger ataniyor kaldirmayin --->
                <input type="hidden" name="for_offer_id" id="for_offer_id" value="<cfoutput>#attributes.offer_id#</cfoutput>"><!--- js ten deger ataniyor kaldirmayin --->
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
                                <th colspan="4" style="text-align:center">
                                    <cfoutput>
                                        #get_par_info(listdeleteduplicates(offer_to_partner),0,1,0,1)#/#OFFER_NUMBER#<cfif REVISION_NUMBER neq ''>/R-#REVISION_NUMBER#</cfif>
                                    </cfoutput>
                                </th>
                            </cfloop>
                        </tr>
                        <tr>
                            <cfloop query="get_coming_offer">
                                <th></th>
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
                                        <cfif isdefined("offer_row_id_#wrk_row_id#_#get_coming_offer.offer_id[fr]#")>
                                            <cfset offer_row_id = evaluate("offer_row_id_#wrk_row_id#_#get_coming_offer.offer_id[fr]#")>
                                        <cfelse>
                                            <cfset offer_row_id = 0>
                                        </cfif>
                                        <cfif isdefined("offer_row_accepted_#wrk_row_id#_#get_coming_offer.offer_id[fr]#")>
                                            <cfset offer_row_accepted = evaluate("offer_row_accepted_#wrk_row_id#_#get_coming_offer.offer_id[fr]#")>
                                        <cfelse>
                                            <cfset offer_row_accepted = 0>
                                        </cfif>
                                        <td>
                                            <input type="checkbox" name="is_accept_offer" id="is_accept_offer#currentrow#" class="is_accept_offer#currentrow#" onclick="accept_offer_control(#offer_row_id#,#currentrow#);" title="<cf_get_lang dictionary_id='58693.Seç'>" value="#offer_row_id#" <cfif offer_row_accepted eq 1>checked</cfif>>
                                        </td>
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
                                </tr>
                            </cfoutput>
                        <cfelse>
                            <tr>
                                <td colspan="<cfoutput>#get_coming_offer.recordcount+9#</cfoutput>"><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>
                            </tr>
                        </cfif>
                    </tbody>
                </cf_grid_list>
            </cf_box_elements>
            <cf_box_footer>
                <cf_workcube_buttons add_function='#iif(isdefined("attributes.draggable"),DE("loadPopupBox('accept_coming_offer', #attributes.modal_id#)"),DE(""))#' is_upd='0'>
            </cf_box_footer>
        </cf_box>
    </cfform>
</div>
<script type="text/javascript">        
    function accept_offer_control(offer_row_id, row_id) {
        var r_count = document.getElementsByClassName('is_accept_offer'+row_id).length;
        $('.is_accept_offer'+row_id).each(function() {
            if(this.value != offer_row_id) this.checked = false;
        });
    }
</script>