<cfsetting showdebugoutput="no">
<cfif isdefined('session.ww.userid') or isdefined('session.pp.userid') or isdefined('session.ep.userid')>
	<cfif isdefined('attributes.is_attachment') and attributes.is_attachment eq 1><!--- xml de proje baglantıları secilmisse --->
        <cfinclude template="../query/upd_basketww_row_discounts.cfm">
    </cfif>
    <cfinclude template="../query/get_basket_rows.cfm">
    <cfquery name="GET_BASKET_ROWS_2" datasource="#DSN3#">
        SELECT 
            '0' AS TYPE,
            *,
            '' AS STOCK_CODE,
            '' AS BARCOD,
            '' AS STOCK_CODE_2,
            0 AS IS_INVENTORY,
                '' AS PRODUCT_DETAIL,
            0 AS IS_LIMITED_STOCK,
            '' AS DIMENTION,
            'Adet' AS MAIN_UNIT,
            '' AS PROPERTY,
            PRODUCT_NAME,
            0 AS IS_ZERO_STOCK,
            '' AS USER_FRIENDLY_URL,
            0 AS IS_EXTRANET,
            0 AS IS_INTERNET,
            '' AS PRODUCT_CODE_2,
            '' AS MANUFACT_CODE,
            0 AS IS_INSTALLMENT_PAYMENT
        FROM
            ORDER_PRE_ROWS
        WHERE
            <cfif isdefined("session.pp")>
                RECORD_PAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#"> AND
            <cfelseif isdefined("session.ww.userid")>
                RECORD_CONS = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#"> AND
            <cfelseif isdefined("session.ep")>
                RECORD_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"> AND
            <cfelseif not isdefined("session_base.userid")><!--- sistemde olmayan misafir kullanıcılar için baskete atılan ürünler --->
                RECORD_GUEST = 1 AND 
                RECORD_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#"> AND
                COOKIE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('cookie.wrk_basket_#ReplaceList(cgi.http_host,'-,:','_,_')#')#"> AND
            </cfif>
            STOCK_ID = -1
    </cfquery>
    <cfquery name="GET_ROWS" dbtype="query">
            SELECT * FROM GET_ROWS
        UNION
            SELECT * FROM GET_BASKET_ROWS_2
    </cfquery>
    <cfif attributes.is_product_assort eq 1>
        <cfloop query="get_rows">
            <cfif len(stock_action_type) and listfind('2,3',stock_action_type)>
                <cfset querySetCell(get_rows,"TYPE",'3',currentRow)>
            <cfelseif len(stock_action_type) and listfind('1',stock_action_type)>
                <cfset querySetCell(get_rows,"TYPE",'4',currentRow)>
            <cfelseif get_rows.is_commission eq 1 or get_rows.IS_CARGO eq 1 or get_rows.is_inventory eq 0>
                <cfset querySetCell(get_rows,"TYPE",'2',currentRow)>
            <cfelseif get_rows.is_prom_asil_hediye eq 1>
                <cfset querySetCell(get_rows,"TYPE",'1',currentRow)>	   
            </cfif>
        </cfloop>
        <cfquery name="GET_ROWS" dbtype="query">
            SELECT * FROM GET_ROWS ORDER BY TYPE ASC
        </cfquery>
    </cfif>
    <cfif isdefined('attributes.is_order_row_info_type') and attributes.is_order_row_info_type eq 1><!---basket ek aciklama 2--->
        <cfquery name="GET_BASKET_INFO_TYPES" datasource="#DSN3#">
            SELECT BASKET_INFO_TYPE_ID, BASKET_INFO_TYPE FROM SETUP_BASKET_INFO_TYPES ORDER BY BASKET_INFO_TYPE ASC
        </cfquery>
    </cfif>
    
    <cfif isDefined('session.pp.userid')>
        <cfquery name="GET_CREDIT_MONEY" datasource="#DSN#">
            SELECT 
                MONEY 
            FROM 
                COMPANY_CREDIT 
            WHERE 
                COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.company_id#"> AND
                OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.our_company_id#">
        </cfquery>
    <cfelse>
        <cfset get_credit_money.recordcount = 0>
    </cfif>
    
    <cfscript>
        session_basket_kur_ekle(process_type:0);
        if(isDefined("session.ep"))
            int_comp_id = session_base.company_id;
        else
            int_comp_id = session_base.our_company_id;
        int_period_id = session_base.period_id;
        int_money = session_base.money;
    
        if(isDefined("session.pp.userid") and get_credit_money.recordcount)
            int_money2 = get_credit_money.money;
        else if(len(session_base.other_money))
            int_money2 = session_base.other_money;
        else if(len(session_base.money2))
            int_money2 = session_base.money2;
        else
            int_money2 = session_base.money;
        if (listfindnocase(partner_url,'#cgi.http_host#',';') and not (isDefined("attributes.company_id") and len(attributes.company_id)))
            attributes.company_id = session.pp.company_id;
        else if (listfindnocase(server_url,'#cgi.http_host#',';') and not (isDefined("attributes.consumer_id") and len(attributes.consumer_id)))
            attributes.consumer_id = session.ww.userid;
    </cfscript>
    <cfinclude template="../query/get_order_detail_money.cfm">
    <cfinclude template="../query/get_order_detail_account.cfm">
    <table align="center" class="color-border" cellpadding="2" cellspacing="1" style="width:98%">
        <input type="hidden" name="form_complete" id="form_complete" value="1"/> 
        <cfoutput>
            <cfloop query="get_money_bskt">
                <cfif str_money_bskt_func eq money_type>
                    <input type="hidden" name="rd_money" id="rd_money" value="#currentrow#" >
                </cfif>
                <input type="hidden" name="hidden_rd_money_#currentrow#" id="hidden_rd_money_#currentrow#" value="#money_type#">
                <input type="hidden" name="txt_rate1_#currentrow#" id="txt_rate1_#currentrow#" value="#rate1#">
                <input type="hidden" name="txt_rate2_#currentrow#" id="txt_rate2_#currentrow#" value="#rate2#">
            </cfloop>
            <input type="hidden" name="kur_say" id="kur_say" value="#get_money_bskt.RecordCount#">
            <input type="hidden" name="basket_money" id="basket_money" value="#str_money_bskt_func#">
        </cfoutput>
        <tr class="color-header" style="height:22px;">
            <cfif isdefined('attributes.is_order_checked') and (attributes.is_order_checked eq 1 or attributes.is_order_checked eq 2)><td style="width:10px;"></td></cfif>
            <td class="form-title" style="width:25px;"><cf_get_lang_main no ='75.No'></td>
            <cfif isdefined('attributes.is_stock_barcode') and attributes.is_stock_barcode eq 1>
                <td class="form-title" style="width:90px;"><cf_get_lang_main no ='221.Barkod'></td>
            </cfif>
            <cfif isdefined('attributes.is_special_code') and attributes.is_special_code eq 1>
                <td class="form-title" style="width:90px;"><cf_get_lang_main no ='40.Stok'> <cf_get_lang_main no='377.Özel Kod'></td>
            </cfif>
            <cfif isdefined('attributes.is_prod_special_code') and attributes.is_prod_special_code eq 1>
                <td class="form-title" style="width:90px;"><cf_get_lang_main no ='245.Ürün'> <cf_get_lang_main no ='377.Özel Kod'></td>
            </cfif>
            <cfif isdefined('attributes.is_manufact_code') and attributes.is_manufact_code eq 1>
                <td class="form-title" style="width:90px;"><cf_get_lang_main no ='222.Üretici Kodu'></td>
            </cfif>
            <td class="form-title"><cf_get_lang_main no ='152.Ürünler'></td>
            <cfif isdefined('attributes.is_order_row_detail') and attributes.is_order_row_detail eq 1>
                <td class="form-title" style="width:150px;"><cf_get_lang_main no ='217.Açıklama'></td>
            </cfif>
            <cfif isdefined('attributes.is_order_row_info_type') and attributes.is_order_row_info_type eq 1>
                <td class="form-title" style="width:90px;"><cf_get_lang no ='1642.Talep Nedeni'></td>
            </cfif>
            <cfif isDefined('attributes.is_vat_column') and attributes.is_vat_column eq 1>
                <td class="form-title" style="width:25px;text-align:right;"><cf_get_lang_main no ='227.KDV'></td>
            </cfif>
            <td class="form-title" style="text-align:right;"><cf_get_lang_main no ='223.Miktar'></td>
            <td class="form-title" style="width:35px;text-align:right;"><cf_get_lang_main no ='224.Birim'></td>
            <cfif isdefined('attributes.prj_id') and len(attributes.prj_id)>
                <td class="form-title" style="width:110px;text-align:right;"><cf_get_lang_main no ='226.Birim Fiyat'></td>
                <td align="center" class="form-title" style="width:30px;">İsk-1</td>
                <td align="center" class="form-title" style="width:30px;">İsk-2</td>
                <td align="center" class="form-title" style="width:30px;">İsk-3</td>
                <td align="center" class="form-title" style="width:30px;">İsk-4</td>
                <td align="center" class="form-title" style="width:30px;">İsk-5</td>
            </cfif>
            <cfif isdefined("attributes.is_basket_prices_session_money") and listfindnocase('1,4,5',attributes.is_basket_prices_session_money)>
                <td class="form-title" style="width:110px;text-align:right;">TL <cf_get_lang_main no="226.Birim Fiyat"></td>
            </cfif>
            <cfif isdefined("attributes.is_prices_kdvsiz") and attributes.is_prices_kdvsiz eq 1>
                <td class="form-title" style="width:110px;text-align:right;"><cf_get_lang_main no="2227.KDV siz"> <cf_get_lang_main no="226.Birim Fiyat"></td>
                <td class="form-title" style="text-align:right;"><cf_get_lang no="136.KDV siz Satır Toplam"></td>
            </cfif>
            <cfif isdefined("attributes.is_prices_kdvli") and attributes.is_prices_kdvli eq 1>
                <td class="form-title" style="width:110px;text-align:right;"><cf_get_lang no="135.KDVli Birim Fiyat"></td>
                <td class="form-title" style="text-align:right;"><cf_get_lang no="137.KDVli Satır Toplam"></td>
            </cfif>
            <cfif isdefined("attributes.is_basket_prices_session_money") and listfindnocase('1,2,5',attributes.is_basket_prices_session_money)>
                <td class="form-title" style="width:70px;text-align:right;"><cfoutput>#session_base.money#</cfoutput><cf_get_lang_main no ='672.Fiyat'> </td>
            </cfif>
            <cfif isdefined("attributes.is_basket_prices_session_money") and listfindnocase('1,3',attributes.is_basket_prices_session_money)>
                <td class="form-title" style="width:90px;text-align:right;"><cfoutput>#session_base.money#</cfoutput><cf_get_lang_main no="1304.KDVli"> <cf_get_lang_main no="672.Fiyat"></td>
            </cfif>
            <cfif attributes.is_editable eq 1>
                <td style="width:15px;"></td>
            </cfif>
        </tr>
        <cfscript>
            genel_toplam = 0; /*promosyon bilgisinin goruntulenmesi bu toplama gore kontrol ediliyor*/
            tum_toplam = 0;
            tum_indirim1 = 0;
            tum_indirim2 = 0;
            tum_indirim3 = 0;
            tum_toplam_ps = 0;
            cargo_toplam_kdvli = 0;
            tum_toplam_kdvli = 0;
            tum_toplam_kdvli_risk = 0;
            tum_toplam_kdvli_ps = 0;
            tum_toplam_komisyonsuz = 0;
            kdv_toplam = 0;
            kdv_toplam_ps = 0;
            my_temp_tutar = 0;
            my_temp_tutar_price_standard = 0;
            toplam_desi = 0;
            urun_kontrol_ = 0;
        </cfscript>
        <cfoutput query="get_rows" group="type">
            <cfif attributes.is_product_assort eq 1>
                <tr class="color-list" style="height:22px;">
                    <td colspan="22" class="form-title"><cfif type eq 0><cf_get_lang no = '1511.Sepet Ürünleri'><cfelseif type eq 1><cf_get_lang no = '1512.Kazanılan Promosyonlar'><cfelseif type eq 2><cf_get_lang no = '1513.Ek Hizmet Bedelleri'><cfelseif type eq 3><cf_get_lang no = '10.Bekleyen Siparişe Alınan Ürünler'><cfelseif type eq 4><cf_get_lang no = '12.Stokta Olmayan Ürünler'></cfif></td>
                </tr>
            </cfif> 
            <cfoutput>
            <cfif len(dimention) and listlen(dimention,'*') eq 3>
                <cfset toplam_desi = toplam_desi + ((replace(listgetat(dimention,1,'*'),',','.','all') * replace(listgetat(dimention,2,'*'),',','.','all') * replace(listgetat(dimention,3,'*'),',','.','all') / 3000)*quantity)>
            </cfif>
            <cfquery dbtype="query" name="GET_MONEY_RATE2">
                SELECT 
                    <cfif isDefined("session.pp")>
                        RATEPP2 RATE2
                    <cfelseif isDefined("session.ww")>
                        RATEWW2 RATE2
                    <cfelse>
                        RATE2
                    </cfif>	
                    FROM 
                        GET_MONEY
                    WHERE 
                        MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#price_money#"> AND
                        COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#int_comp_id#">
            </cfquery>
            <cfquery dbtype="query" name="GET_MONEY_RATE2_PRICE_STANDARD">
                SELECT 
                    <cfif isDefined("session.pp")>
                        RATEPP2 RATE2
                    <cfelseif isDefined("session.ww")>
                        RATEWW2 RATE2
                    <cfelse>
                        RATE2
                    </cfif>	
                FROM 
                    GET_MONEY
                WHERE 
                    MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#price_standard_money#"> AND
                    COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#int_comp_id#">
            </cfquery>
            <cfif len(stock_code)>
                <tr class="color-row" style="height:20px; vertical-align:top;">
                    <cfif isdefined('attributes.is_order_checked') and (attributes.is_order_checked eq 1 or attributes.is_order_checked eq 2)>
                        <td>
                            <cfif (attributes.is_order_checked eq 1 or (attributes.is_order_checked eq 2 and is_prom_asil_hediye eq 1))>
                                <input type="checkbox" name="is_checked" id="is_checked" onclick="urun_checked_(#order_row_id#,#is_checked#);" value="#order_row_id#" <cfif is_checked eq 1>checked</cfif> />
                            </cfif>
                            <cfif is_checked eq 1><cfset urun_kontrol_ = 1></cfif>
                        </td>
                    <cfelse>
                        <input type="hidden" name="is_checked" id="is_checked" value="#order_row_id#">
                    </cfif>
                    <input type="hidden" name="is_part" id="is_part" value="#is_part#">
                    <td class="tableyazi">#currentrow#</td>
                    <cfif isdefined('attributes.is_stock_barcode') and attributes.is_stock_barcode eq 1>
                        <td>#barcod#</td>
                    </cfif>
                    <cfif isdefined('attributes.is_special_code') and attributes.is_special_code eq 1>
                        <td align="center" class="tableyazi">#stock_code_2#</td>
                    </cfif>
                    <cfif isdefined('attributes.is_prod_special_code') and attributes.is_prod_special_code eq 1>
                        <td align="center" class="tableyazi">#product_code_2#</td>
                    </cfif>
                    <cfif isdefined('attributes.is_manufact_code') and attributes.is_manufact_code eq 1>
                        <td align="center" class="tableyazi">#manufact_code#</td>
                    </cfif>
                    <td class="tableyazi">
                        #product_name# 
                        <cfif len(spec_var_name) and spec_var_name neq product_name>(#spec_var_name#)</cfif> <cfif is_part eq 1><font color="red">(<cf_get_lang no="17.Parça Talebi">)</font></cfif>
                        <cfif len(prom_id) and not is_prom_asil_hediye>
                            <cfquery name="GET_PRO" datasource="#DSN3#">
                                SELECT						
                                    ICON_ID,
                                    FREE_STOCK_ID,
                                    DISCOUNT,
                                    AMOUNT_DISCOUNT,
                                    AMOUNT_1_MONEY,
                                    AMOUNT_DISCOUNT_MONEY_1
                                FROM
                                    PROMOTIONS
                                WHERE
                                    PROM_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#prom_id#">
                            </cfquery>
                            <cfif get_pro.recordcount>
                              <cfif len(get_pro.icon_id) AND (get_pro.icon_id gt 0)>
                                  <cfquery name="GET_ICON" datasource="#DSN3#">
                                        SELECT ICON, ICON_SERVER_ID FROM SETUP_PROMO_ICON WHERE ICON_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_pro.icon_id#">
                                    </cfquery>
                                    <br/>
                                  <cf_get_server_file output_file="sales/#get_icon.icon#" output_server="#get_icon.icon_server_id#" output_type="0"  image_link="1" alt="#getLang('main',617)#" title="#getLang('main',617)#">
                                </cfif>
                                <font color="FF0000">
                                <cfif len(get_pro.free_stock_id)>
                                    <strong><cf_get_lang no ='131.Hediye'>:</strong> #get_product_name(stock_id:get_pro.free_stock_id,with_property:1)#
                                <cfelseif len(get_pro.discount) and get_pro.discount gt 0>
                                    <strong><cf_get_lang no ='132.Yüzde İndirim'>:</strong> % #get_pro.discount#
                                <cfelseif len(get_pro.amount_discount) and get_pro.amount_discount gt 0>
                                    <strong><cf_get_lang no='133.Tutar Indirimi'>:</strong> #get_pro.amount_discount# <cfif len(get_pro.amount_discount_money_1)>#get_pro.amount_discount_money_1#<cfelse>#price_money#</cfif>
                                </cfif>
                                </font>
                            <cfelse>
                                &nbsp;
                            </cfif>
                        </cfif>
                        <cfif is_prom_asil_hediye and not (len(prom_product_price) and prom_product_price gt 0)><strong>(<cf_get_lang no ='131.Hediye'>)</strong></cfif> <!--- promosyon urunun promosyon bedeli varsa hediye yazılmıyor --->
                        <cfif is_spec eq 1>
                            <cfquery name="GET_INNER_ROWS" datasource="#DSN3#">
                                SELECT PRODUCT_NAME,DIFF_PRICE,ROW_MONEY,AMOUNT,TOTAL_VALUE FROM ORDER_PRE_ROWS_SPECS WHERE MAIN_ORDER_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#order_row_id#">
                            </cfquery>
                            <br/>
                            <a href="javascript://" onclick="gizle_goster(spect_#currentrow#);"><b><font color="##FF0000"><cf_get_lang no="139.Ürün Bileşenleri"></font></b></a>
                            <table style="display:none;" id="spect_#currentrow#">
                                <tr>
                                    <td class="tableyazi"><cf_get_lang_main no="245.Ürün Adı"></td>
                                    <td class="tableyazi" style="width:60px;"><cf_get_lang_main no="223.Miktar"></td>
                                    <td colspan="2" style="text-align:right;" class="tableyazi"><cf_get_lang_main no='1737.Toplam Tutar'></td>
                                <tr>
                                <cfloop query="get_inner_rows">
                                    <tr>
                                        <td class="tableyazi">#get_inner_rows.product_name#</td>
                                        <td class="tableyazi">#get_inner_rows.amount#</td>
                                        <td style="text-align:right;">#tlformat(get_inner_rows.total_value)#</td>
                                        <td class="tableyazi">#get_inner_rows.row_money#</td>
                                    </tr>
                                </cfloop>
                            </table>
                        </cfif>
                    </td>
                    <cfif isdefined('attributes.is_order_row_detail') and attributes.is_order_row_detail eq 1>
                        <td><input type="text" name="order_row_detail_#currentrow#" id="order_row_detail_#currentrow#" value="#order_row_detail#" style="width:150px;" onblur="urunRowDetail(#order_row_id#,#currentrow#,1);"/ maxlength="250"></td>
                    </cfif>
                    <cfif isdefined('attributes.is_order_row_info_type') and attributes.is_order_row_info_type eq 1>
                        <td>
                            <select name="basket_info_type_id_#currentrow#" id="basket_info_type_id_#currentrow#" style="width:75px;" onchange="urunRowDetail(#order_row_id#,#currentrow#,2);">
                                <cfloop query="get_basket_info_types">
                                    <option value="#basket_info_type_id#"<cfif basket_info_type_id eq get_rows.order_info_type_id>selected</cfif>>#basket_info_type#</option>
                                </cfloop>
                            </select>
                        </td>
                    </cfif>
                    <cfif isDefined('attributes.is_vat_column') and attributes.is_vat_column eq 1>
                        <td style="text-align:right;" class="tableyazi">#tax#%</td>
                    </cfif>
                    <td style="text-align:right;" class="tableyazi">
                        <cfif attributes.is_editable eq 1>
                            <cfif not (is_cargo eq 1 or is_commission eq 1)>
                                <input type="hidden" name="old_row_#currentrow#" id="old_row_#currentrow#" value="#quantity * prom_stock_amount#">
                                <input type="text" name="row_#currentrow#" id="row_#currentrow#" class="moneybox" value="#quantity * prom_stock_amount#" style="width:50px;" onkeyup="return FormatCurrency(this,event,#fusebox.Format_Currency #);" onblur="if(filterNum(this.value) <=0) this.value=1;urun_hesapla(#order_row_id#,#currentrow#,#stock_id#);" <cfif len(prom_id)> readonly</cfif>>
                            <cfelse>
                                #quantity * prom_stock_amount#
                            </cfif>
                        <cfelse>
                            #quantity * prom_stock_amount#
                        </cfif>
                    </td>
                    <td align="center">#main_unit#</td>
                    <cfif isdefined('attributes.prj_id') and len(attributes.prj_id)>
                        <td style="text-align:right;" class="tableyazi">
                           <cfif len(price_old)>
                           #TLFormat(price_old)# #price_money#
                           <cfelse>
                                #TLFormat(price)# #price_money#
                           </cfif>
                        </td>
                        <td align="center" class="tableyazi">#discount1#</td>
                        <td align="center" class="tableyazi">#discount2#</td>
                        <td align="center" class="tableyazi">#discount3#</td>
                        <td align="center" class="tableyazi">#discount4#</td>
                        <td align="center" class="tableyazi">#discount5#</td>
                    </cfif>
                    <cfif isdefined("attributes.is_basket_prices_session_money") and listfindnocase('1,4,5',attributes.is_basket_prices_session_money)>
                        <td style="text-align:right;" class="tableyazi">
                            <cfif len(price_old)>
                                <strike>#TLFormat(price_old * get_money_rate2.rate2)# #session_base.money#</strike><br/>
                            </cfif>
                            #TLFormat(price * get_money_rate2.rate2)# #session_base.money#
                        </td>
                    </cfif>
                    <cfif isdefined("attributes.is_prices_kdvsiz") and attributes.is_prices_kdvsiz eq 1>
                        <cfif isdefined('attributes.is_attachment') and attributes.is_attachment eq 1>
                            <td style="text-align:right;" class="tableyazi">
                                <cfif isdefined('attributes.prj_id') and len(attributes.prj_id)>
                                    #TLFormat(price)# #price_money#
                                </cfif>
                            </td>
                            <td style="text-align:right;" class="tableyazi">
                                <cfif isdefined('attributes.prj_id') and len(attributes.prj_id)>
                                    #TLFormat(price * quantity * prom_stock_amount)# #price_money#
                                </cfif>
                            </td>
                        <cfelse>
                            <td style="text-align:right;" class="tableyazi">
                                #TLFormat(price)# #price_money#
                            </td>
                            <td style="text-align:right;" class="tableyazi">
                                #TLFormat(price * quantity * prom_stock_amount)# #price_money#
                            </td>
                        </cfif>
                    </cfif>
                    <cfif isdefined("attributes.is_prices_kdvli") and attributes.is_prices_kdvli eq 1>
                        <cfif isdefined('attributes.is_attachment') and attributes.is_attachment eq 1>
                            <td style="text-align:right;" class="tableyazi">
                                <cfif isdefined('attributes.prj_id') and len(attributes.prj_id)>
                                    <cfif len(price_old)>
                                        <strike>#TLFormat(price_kdv_old)# #price_money#</strike><br/>
                                    </cfif>
                                    #TLFormat(price_kdv)# #price_money#
                                </cfif>
                            </td>
                            <td style="text-align:right;" class="tableyazi">
                                <cfif isdefined('attributes.prj_id') and len(attributes.prj_id)>
                                    <cfif (len(stock_action_type) and not listfind('1,2,3',stock_action_type)) or not len(stock_action_type)>
                                        #TLFormat(price_kdv * quantity * prom_stock_amount)# #price_money#
                                    <cfelse>
                                        ---
                                    </cfif>
                                </cfif>
                            </td>
                        <cfelse>
                            <td style="text-align:right;" class="tableyazi">
                                <cfif len(price_old)>
                                    <strike>#TLFormat(price_kdv_old)# #price_money#</strike><br/>
                                </cfif>
                                #TLFormat(price_kdv)# #price_money#
                            </td>
                            <td style="text-align:right;" class="tableyazi">
                                <cfif (len(stock_action_type) and not listfind('1,2,3',stock_action_type)) or not len(stock_action_type)>
                                    #TLFormat(price_kdv * quantity * prom_stock_amount)# #price_money#
                                <cfelse>
                                    ---
                                </cfif>
                            </td>
                        </cfif>
                    </cfif>
                    <cfif isdefined("attributes.is_basket_prices_session_money") and listfindnocase('1,2,5',attributes.is_basket_prices_session_money)>
                        <td style="text-align:right;" class="tableyazi">#TLFormat(price * quantity * prom_stock_amount * get_money_rate2.rate2)#</td>
                    </cfif>
                    <cfif isdefined("attributes.is_basket_prices_session_money") and listfindnocase('1,3',attributes.is_basket_prices_session_money)>
                        <td style="text-align:right;" class="tableyazi">#TLFormat(price_kdv * quantity * prom_stock_amount * get_money_rate2.rate2)#</td>
                    </cfif>
                    <cfif attributes.is_editable eq 1 or attributes.is_editable eq 2>
                        <td>
                            <cfif attributes.is_editable eq 1 or (attributes.is_editable eq 2 and is_prom_asil_hediye eq 1)>
                                <cfif not (is_cargo eq 1 or is_commission eq 1)><a style="cursor:pointer" onclick="urun_sil('#order_row_id#');" class="silbuton" title="<cf_get_lang_main no='51.Sil'>">aaaa</a></cfif>
                            </cfif>
                        </td>
                    </cfif>
                </tr>
            </cfif>
            <cfscript>
                if((not is_prom_asil_hediye or (len(prom_product_price) and prom_product_price gt 0)) and (not len(stock_action_type) or (len(stock_action_type) and not listfind('1,2,3',stock_action_type))))//promosyon verilen urunun promosyon fiyatı varsa toplama eklenir
                {
                    if(not len(price_standard_kdv))
                    {
                        this_price_standart_kdv = 0;
                        this_price_standart = 0;
                    }
                    else
                    {
                        this_price_standart_kdv = price_standard_kdv;
                        this_price_standart = price_standard;
                    }
                    if(not get_money_rate2_price_standard.recordcount)
                        my_money = 1;
                    else
                        my_money = get_money_rate2_price_standard.rate2;
                    satir_toplam_std = wrk_round((price * quantity * prom_stock_amount * get_money_rate2.rate2),4);
                    satir_toplam_std_ps = this_price_standart * quantity * prom_stock_amount * my_money;
                    
                    if(is_cargo eq 1)
                        satir_cargo_toplam_kdvli = wrk_round((price_kdv * quantity * prom_stock_amount * get_money_rate2.rate2),4);
                    else
                        satir_cargo_toplam_kdvli = 0;
                    
                    satir_toplam_std_kdvli = wrk_round((price_kdv * quantity * prom_stock_amount * get_money_rate2.rate2),4);
                    satir_toplam_std_kdvli_ps = this_price_standart_kdv * quantity * prom_stock_amount * my_money;
                    if(is_commission neq 1)
                        satir_toplam_komisyonsuz = wrk_round((price_kdv * quantity * prom_stock_amount * get_money_rate2.rate2),4);
                    kdv_miktari = wrk_round((satir_toplam_std * (tax/100)),4);
                    kdv_miktari_ps = satir_toplam_std_ps * (tax/100);
                        
                    if(is_checked eq 1)
                    {
                        if(listfind('1',is_discount))
                            tum_indirim1 = tum_indirim1 + (-1 * satir_toplam_std);
                        else if(listfind('2',is_discount))
                            tum_indirim2 = tum_indirim2 + (-1 * satir_toplam_std);
                        else if(listfind('3',is_discount))
                            tum_indirim3 = tum_indirim3 + (-1 * satir_toplam_std);
                        tum_toplam = tum_toplam + satir_toplam_std;
                        tum_toplam_ps = tum_toplam_ps + satir_toplam_std_ps;
                        
                        cargo_toplam_kdvli = cargo_toplam_kdvli + satir_cargo_toplam_kdvli;
                        
                        tum_toplam_kdvli = tum_toplam_kdvli + satir_toplam_std_kdvli;
                        tum_toplam_kdvli_ps = tum_toplam_kdvli_ps + satir_toplam_std_kdvli_ps;
                        if(is_commission neq 1)
                            tum_toplam_komisyonsuz = tum_toplam_komisyonsuz + satir_toplam_komisyonsuz;
                        kdv_toplam = kdv_toplam + kdv_miktari;
                        kdv_toplam_ps = kdv_toplam_ps + kdv_miktari_ps;
                    }
                    else
                    {
                        //islem yok
                    }
                    if(is_commission neq 1)
                    {
                        my_temp_tutar = my_temp_tutar + wrk_round((price_kdv * quantity * prom_stock_amount * get_money_rate2.rate2),4);
                        my_temp_tutar_price_standard = my_temp_tutar_price_standard + this_price_standart_kdv * quantity * prom_stock_amount * my_money;					
                    }
                    if(len(stock_action_type) and stock_action_type eq -2)
                        tum_toplam_kdvli_risk = tum_toplam_kdvli_risk + satir_toplam_std_kdvli;
                }
            </cfscript>
            </cfoutput>
        </cfoutput>
        <!--- satir dongusu burada bitti --->
        <cfset toplam_indirim = 0>
        <cfset toplam_indirim_ps = 0>
        <cfif get_general_prom.recordcount>
            <cfquery name="GET_GENERAL_PROM_MONEY" dbtype="query" >
                SELECT 
                    RATE1,
                <cfif isDefined("session.pp")>
                    RATEPP2 RATE2
                <cfelseif isDefined("session.ww")>
                    RATEWW2 RATE2
                <cfelse>
                    RATE2
                </cfif>	
                FROM 
                    GET_MONEY
                WHERE 
                    MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#get_general_prom.limit_currency#"> AND
                    COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#int_comp_id#">
            </cfquery>
            <cfset get_general_prom_limit_value = get_general_prom.limit_value * (get_general_prom_money.rate2 / get_general_prom_money.rate1)>
            <cfif len(get_general_prom.limit_value) and len(get_general_prom.discount) and get_general_prom_limit_value lte tum_toplam>
                <cfset kdvsiz_toplam_indirimli = tum_toplam * ((100 - get_general_prom.discount)/100)>
                <cfset kdvli_toplam_indirimli = 0>
                <cfset kdv_toplam_indirimli = 0>
                <cfset kdvli_toplam_indirimli_komisyonsuz = 0>
                <cfoutput query="get_rows">
                    <cfif (not is_prom_asil_hediye)>
                        <cfquery dbtype="query" name="GET_MONEY_RATE2">
                            SELECT 
                            <cfif isDefined("session.pp")>
                                RATEPP2 RATE2
                            <cfelseif isDefined("session.ww")>
                                RATEWW2 RATE2
                            <cfelse>
                                RATE2
                            </cfif>	
                            FROM 
                                GET_MONEY
                            WHERE 
                                MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#price_money#"> AND
                                COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#int_comp_id#">
                        </cfquery>
                        <cfscript>
                            satir_toplam_kdvsiz = price * quantity * prom_stock_amount * get_money_rate2.rate2;
                            if(is_commission neq 1)
                                satir_toplam_kdvsiz_com = price * quantity * prom_stock_amount * get_money_rate2.rate2;
                        
                            toplam_indirim = tum_toplam_ps * (get_general_prom.discount/100);
                            toplam_indirim_ps = tum_toplam_ps * (get_general_prom.discount/100);
                            satir_agirligi = satir_toplam_kdvsiz / tum_toplam;
                            satir_indirim = toplam_indirim * satir_agirligi;
                            satir_kdvli_toplam_indirimli = (satir_toplam_kdvsiz - satir_indirim) * (1+(tax/100));
                            satir_kdvli_toplam_indirimli_kom = (satir_toplam_kdvsiz_com - satir_indirim) * (1+(tax/100));
                            kdvli_toplam_indirimli = kdvli_toplam_indirimli + satir_kdvli_toplam_indirimli;
                            kdvli_toplam_indirimli_komisyonsuz = kdvli_toplam_indirimli_komisyonsuz + satir_kdvli_toplam_indirimli_kom;
                            kdv_miktari_indirimli = (satir_toplam_kdvsiz - satir_indirim) * (tax/100);
                            kdv_toplam_indirimli = kdv_toplam_indirimli + kdv_miktari_indirimli;
                        </cfscript>
                    </cfif>
                </cfoutput>
                <cfset genel_toplam = tum_toplam> <!--- sıralamayı degistirmeyin --->
                <cfset tum_toplam = kdvsiz_toplam_indirimli>
                <cfset tum_toplam_kdvli = kdvli_toplam_indirimli>
                <cfset tum_toplam_komisyonsuz = kdvli_toplam_indirimli_komisyonsuz>
                <cfset kdv_toplam = kdv_toplam_indirimli>
                <cfoutput>
                <input type="hidden" name="genel_indirim" id="genel_indirim" value="#toplam_indirim#">
                <input type="hidden" name="general_prom_id" id="general_prom_id" value="#get_general_prom.prom_id#">
                <input type="hidden" name="general_prom_limit" id="general_prom_limit" value="#get_general_prom.limit_value#">
                <input type="hidden" name="general_prom_limit_currency" id="general_prom_limit_currency" value="#get_general_prom.limit_currency#">
                <input type="hidden" name="general_prom_discount" id="general_prom_discount" value="#get_general_prom.discount#">
                <input type="hidden" name="general_prom_amount" id="general_prom_amount" value="#get_general_prom.amount_discount#">
                </cfoutput>
            </cfif>
        </cfif>
        <cfif tum_toplam lt 0><cfset tum_toplam = 0></cfif>
        <cfquery name="GET_GENERAL_PROM_2" datasource="#DSN3#" maxrows="1">
            SELECT 
                P.COMPANY_ID, 
                P.LIMIT_VALUE, 
                P.DISCOUNT, 
                P.AMOUNT_DISCOUNT, 
                P.PROM_ID,
                P.LIMIT_CURRENCY,
                P.LIMIT_TYPE,
                P.FREE_STOCK_ID,
                P.FREE_STOCK_AMOUNT,
                P.FREE_STOCK_PRICE,
                P.AMOUNT_1_MONEY,
                S.PRODUCT_NAME,
                S.PROPERTY,
                P.TOTAL_PROMOTION_COST
            FROM 
                PROMOTIONS P,
                STOCKS S
            WHERE 
                P.FREE_STOCK_ID = S.STOCK_ID AND 
                P.PROM_STATUS = 1 AND 
                P.PROM_TYPE = 0 AND 
                P.FREE_STOCK_ID IS NOT NULL AND 
                P.FREE_STOCK_AMOUNT IS NOT NULL AND 
                P.FREE_STOCK_PRICE IS NOT NULL AND 
                P.LIMIT_VALUE IS NOT NULL AND 
                #now()# BETWEEN P.STARTDATE AND P.FINISHDATE
            ORDER BY
                P.PROM_ID DESC
        </cfquery>
        <cfif get_general_prom_2.recordcount>
            <cfquery dbtype="query" name="GET_GENERAL_PROM_2_MONEY">
                SELECT 
                    RATE1,
                <cfif isDefined("session.pp")>
                    RATEPP2 RATE2
                <cfelseif isDefined("session.ww")>
                    RATEWW2 RATE2
                <cfelse>
                    RATE2
                </cfif>	
                FROM 
                    GET_MONEY
                WHERE 
                    MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#get_general_prom_2.limit_currency#"> AND
                    COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#int_comp_id#">
            </cfquery>
            <cfset get_general_prom_2_limit_value = get_general_prom_2.limit_value * (get_general_prom_2_money.rate2 / get_general_prom_2_money.rate1)>
        </cfif>
    </table>
    <cfif isdefined("session.pp.userid") and (isdefined('attributes.is_view_kur') and attributes.is_view_kur eq 1)>
        <cfquery name="GET_KUR" dbtype="query">
            SELECT * FROM GET_MONEY WHERE MONEY <> <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.pp.money#"> ORDER BY MONEY
        </cfquery>
    <cfelse>
        <cfset get_kur.recordcount = 0>
    </cfif>
    <table cellpadding="0" cellspacing="0" align="center" style="width:98%">
        <tr>
            <td style="vertical-align:top;">
                <!--- kurlar --->
                    <cfif get_kur.recordcount>
                        <table>
                            <tr>
                                <td class="txtbold"><cf_get_lang no ='140.Kurlar'></td>
                            </tr>
                            <cfoutput query="get_kur">
                                <tr>
                                    <td class="tableyazi">#money#</td>
                                    <td style="text-align:right;">
                                        <cfif isDefined("session.pp")>
                                            #TLFormat(ratepp2,4)#
                                        <cfelseif isDefined("session.ww")>
                                            #TLFormat(rateww2,4)#
                                        <cfelse>
                                            #TLFormat(rate2,4)#
                                        </cfif>
                                    </td>
                                </tr>
                            </cfoutput>
                        </table>
                  </cfif>
                <!--- kurlar --->
            </td>
            <td style="vertical-align:top;">
                <!--- toplamlar --->
                <table cellpadding="0" cellspacing="0" align="right">
                    <cfoutput>
                        <cfif isdefined('attributes.is_view_basket_total') and attributes.is_view_basket_total eq 1 and (tum_indirim1 gt 0 or tum_indirim2 gt 0 or tum_indirim3 gt 0)>
                            <tr style="height:20px;">
                                <td style="text-align:right;" class="basket_total"><cf_get_lang no ='53.Sepet Toplamı'></td>
                                <td style="text-align:right;" class="tableyazi">
                                    <cfif isdefined('attributes.is_risc_currency') and attributes.is_risc_currency eq 1>
                                        <cfquery name="GET_RISC_CURR" dbtype="query">
                                            SELECT DSP_RATE_SALE FROM GET_MONEY WHERE MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#get_credit.money#">
                                        </cfquery> 
                                        #TLFormat(tum_toplam_kdvli + tum_indirim1 + tum_indirim2 + tum_indirim3 + toplam_indirim / get_risc_curr.dsp_rate_sale)# #get_credit.money#
                                    <cfelse>
                                        #TLFormat(tum_toplam_kdvli + tum_indirim1 +tum_indirim2 + tum_indirim3)# #get_stdmoney.money#
                                    </cfif>
                                </td>
                                <cfif isdefined('attributes.is_view_basket_other') and attributes.is_view_basket_other eq 1><td></td></cfif>
                            </tr>
                        </cfif>
                        <tr style="height:20px;">
                            <cfif isdefined('attributes.is_view_basket_total') and attributes.is_view_basket_total eq 1 and not (tum_indirim1 gt 0 or tum_indirim2 gt 0 or tum_indirim3 gt 0)>
                                <td style="text-align:right;" class="basket_total"><cf_get_lang_main no ='80.TOPLAM'> (<cf_get_lang no ='141.KDV Hariç'>)</td>
                                <td style="text-align:right;width:100px;" class="tableyazi">
                                    <cfif isdefined('attributes.is_risc_currency') and attributes.is_risc_currency eq 1>
                                        <cfquery name="GET_RISC_CURR" dbtype="query">
                                            SELECT DSP_RATE_SALE FROM GET_MONEY WHERE MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#get_credit.money#">
                                        </cfquery> 
                                        <cfif get_risc_curr.recordcount and len(get_risc_curr.dsp_rate_sale)>
                                            #TLFormat(tum_toplam / get_risc_curr.dsp_rate_sale)# #get_credit.money#
                                        </cfif>
                                    <cfelse>
                                        #TLFormat(tum_toplam)# #get_stdmoney.money#
                                    </cfif>
                                </td>
                            </cfif>
                            <cfif isdefined('attributes.is_view_basket_other') and attributes.is_view_basket_other eq 1>
                                <td style="text-align:right;" class="tableyazi" style="width:100px;">
                                    <cfif len(get_money_money2.rate2)>
                                        #TLFormat(tum_toplam/get_money_money2.rate2/get_money_money2.rate1)# #int_money2#
                                    </cfif>
                                </td>
                            </cfif>
                        </tr>
                        <cfif get_general_prom.recordcount>
                            <cfif len(get_general_prom.limit_value) and len(get_general_prom.discount) and get_general_prom.limit_value lte genel_toplam>
                                <tr style="height:20px;">
                                    <cfif isdefined('attributes.is_view_basket_total') and attributes.is_view_basket_total eq 1>
                                        <td class="basket_total"><cf_get_lang no ='1305.GENEL PROMOSYON İSKONTOSU'></td>
                                        <td style="text-align:right;" class="tableyazi">#TLFormat(toplam_indirim)# #get_stdmoney.money#</td>
                                    </cfif>
                                    <cfif isdefined('attributes.is_view_basket_other') and attributes.is_view_basket_other eq 1>
                                        <td style="text-align:right;" class="tableyazi">#TLFormat(toplam_indirim/get_money_money2.rate2/get_money_money2.rate1)# #int_money2#</td>
                                    </cfif>
                                </tr>
                            </cfif>
                        </cfif>
                        <tr style="height:1px;">
                            <td colspan="3"><hr style="width:100%;"></td>
                        </tr>
                        <tr style="height:20px;">
                            <cfif isdefined('attributes.is_view_basket_total') and attributes.is_view_basket_total eq 1>
                                <td style="text-align:right;" class="basket_total"><cf_get_lang_main no ='227.KDV'></td>
                                <td style="text-align:right;" class="tableyazi"><cfset all_total_kdv = wrk_round(tum_toplam_kdvli-tum_toplam,4)><cfif all_total_kdv lte 0><cfset all_total_kdv = all_total_kdv*-1></cfif>
                                    <cfif isdefined('attributes.is_risc_currency') and attributes.is_risc_currency eq 1>
                                        <cfquery name="GET_RISC_CURR" dbtype="query">
                                            SELECT DSP_RATE_SALE FROM GET_MONEY WHERE MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#get_credit.money#">
                                        </cfquery> 
                                        <cfif get_risc_curr.recordcount and len(get_risc_curr.dsp_rate_sale)>
                                            #TLFormat(all_total_kdv / get_risc_curr.dsp_rate_sale)# #get_credit.money#
                                        </cfif>
                                    <cfelse>
                                        #TLFormat(all_total_kdv)# #get_stdmoney.money#
                                    </cfif>
                                </td>
                            </cfif>
                            <cfif isdefined('attributes.is_view_basket_other') and attributes.is_view_basket_other eq 1>
                                <cfif len(get_money_money2.rate2)>
                                  <td style="text-align:right;" class="tableyazi"><cfset all_total_kdv = wrk_round(tum_toplam_kdvli-tum_toplam,4)><cfif all_total_kdv lte 0><cfset all_total_kdv = all_total_kdv*-1></cfif>
                                    #TLFormat(all_total_kdv/get_money_money2.rate2/get_money_money2.rate1)# #int_money2# </td>
                                </cfif>
                            </cfif>
                        </tr>
                        <tr style="height:1px;">
                            <td colspan="3"><hr style="width:100%;"></td>
                        </tr>
                        <tr style="height:20px;">
                            <cfif isdefined('attributes.is_view_basket_total') and attributes.is_view_basket_total eq 1>
                                <td style="text-align:right;" class="basket_total"><cf_get_lang_main no ='80.TOPLAM'>(<cf_get_lang no ='142.KDV Dahil'>)</td>
                                <td style="text-align:right;" class="tableyazi"><cfif tum_toplam_kdvli lte 0><cfset tum_toplam_kdvli = tum_toplam_kdvli*-1></cfif>
                                    <cfif isdefined('attributes.is_risc_currency') and attributes.is_risc_currency eq 1>
                                        <cfquery name="GET_RISC_CURR" dbtype="query">
                                            SELECT DSP_RATE_SALE FROM GET_MONEY WHERE MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#get_credit.money#">
                                        </cfquery> 
                                        <cfif get_risc_curr.recordcount and len(get_risc_curr.dsp_rate_sale)>
                                            #TLFormat((tum_toplam_kdvli+tum_indirim1+tum_indirim2+tum_indirim3) / get_risc_curr.dsp_rate_sale)# #get_credit.money#
                                        </cfif>
                                    <cfelse>
                                        #TLFormat(tum_toplam_kdvli+tum_indirim1+tum_indirim2+tum_indirim3)# #get_stdmoney.money#
                                    </cfif>
                                </td>
                            </cfif>
                            <cfif isdefined('attributes.is_view_basket_other') and attributes.is_view_basket_other eq 1>
                                <td style="text-align:right;" class="tableyazi">
                                    <cfif len(get_money_money2.rate2)>
                                        #TLFormat(tum_toplam_kdvli/get_money_money2.rate2/get_money_money2.rate1)# #int_money2#
                                    </cfif>
                                </td>
                            </cfif>
                        </tr>
                        <cfif isdefined('attributes.is_view_basket_total') and attributes.is_view_basket_total eq 1 and tum_indirim1 gt 0>
                            <tr style="height:20px;">
                                <td style="text-align:right;" class="basket_total"><cf_get_lang no ='54.Parapuan İndirimi'></td>
                                <td style="text-align:right;" class="tableyazi">
                                    #TLFormat(tum_indirim1)# #get_stdmoney.money#
                                </td>
                                <cfif isdefined('attributes.is_view_basket_other') and attributes.is_view_basket_other eq 1><td></td></cfif>
                            </tr>
                        </cfif>
                        <cfif isdefined('attributes.is_view_basket_total') and attributes.is_view_basket_total eq 1 and tum_indirim2 gt 0>
                            <tr style="height:20px;">
                                <td style="text-align:right;" class="basket_total"><cf_get_lang no ='55.Hediye Kartı İndirimi'></td>
                                <td style="text-align:right;" class="tableyazi">
                                    #TLFormat(tum_indirim2)# #get_stdmoney.money#
                                </td>
                                <cfif isdefined('attributes.is_view_basket_other') and attributes.is_view_basket_other eq 1><td></td></cfif>
                            </tr>
                        </cfif>
                        <cfif isdefined('attributes.is_view_basket_total') and attributes.is_view_basket_total eq 1 and tum_indirim3 gt 0>
                            <tr style="height:20px;">
                                <td style="text-align:right;" class="basket_total">İndirim Kodu İndirimi</td>
                                <td style="text-align:right;" class="tableyazi">
                                    #TLFormat(tum_indirim3)# #get_stdmoney.money#
                                </td>
                                <cfif isdefined('attributes.is_view_basket_other') and attributes.is_view_basket_other eq 1><td></td></cfif>
                            </tr>
                        </cfif>
                        <cfif isdefined('attributes.is_view_basket_total') and attributes.is_view_basket_total eq 1 and (tum_indirim1 gt 0 or tum_indirim2 gt 0 or tum_indirim3 gt 0)>
                            <tr style="height:20px;">
                                <td style="text-align:right;" class="basket_total"><cf_get_lang no ='56.Ödenecek Tutar'></td>
                                <td style="text-align:right;" class="tableyazi">
                                    #TLFormat(tum_toplam_kdvli)# #get_stdmoney.money#
                                </td>
                                <cfif isdefined('attributes.is_view_basket_other') and attributes.is_view_basket_other eq 1><td></td></cfif>
                            </tr>
                        </cfif>
                        <!--- Son kullanıcı fiyat toplam gösteriliyorsa ilgili fiyat listesine göre basket toplamı çekiliyor --->
                        <cfif isdefined("attributes.is_last_price") and isdefined("attributes.price_cat_id") and attributes.is_last_price eq 1 and len(attributes.price_cat_id)>
                            <cfinclude template="../query/get_basket_price_total.cfm">
                            <cfif len(get_basket_price_total_.total_price) and len(tum_toplam_kdvli)>
                                <cfif len(get_other_products.total_p)>
                                    <cfset total_profit = wrk_round(get_basket_price_total_.total_price-(tum_toplam_kdvli-get_other_products.total_p))>
                                <cfelse>
                                    <cfset total_profit = wrk_round(get_basket_price_total_.total_price-tum_toplam_kdvli)>
                                </cfif>
                            <cfelse>
                                <cfset total_profit = 0>
                            </cfif>
                            <tr style="height:20px;">
                                <td class="basket_total"><cf_get_lang no ='968.Son Kullanıcı Fiyat'> <cf_get_lang_main no ='1247.Toplam'></td>
                                <td class="tableyazi" style="text-align:right;">
                                    <cfif len(get_basket_price_total_.total_price)>
                                        #TLFormat(get_basket_price_total_.total_price)#
                                    <cfelse>
                                        0
                                    </cfif>
                                    #get_stdmoney.money#
                                </td>
                                <cfif isdefined('attributes.is_view_basket_other') and attributes.is_view_basket_other eq 1>
                                    <cfif len(get_money_money2.rate2) and len(get_basket_price_total_.total_price)>
                                        <td class="tableyazi" style="text-align:right;"> #TLFormat(get_basket_price_total_.total_price/get_money_money2.rate2/get_money_money2.rate1)# #int_money2# </td>
                                    </cfif>
                                </cfif>
                            </tr>
                            <tr style="height:20px;">
                                <td class="basket_total"><cf_get_lang_main no ='1247.Toplam'> <cf_get_lang no ='1609.Kazancınız'></td>
                                <td class="tableyazi" style="text-align:right;">#TLFormat(total_profit)# #get_stdmoney.money#</td>
                                <cfif isdefined('attributes.is_view_basket_other') and attributes.is_view_basket_other eq 1>
                                    <cfif len(get_money_money2.rate2)>
                                        <td class="tableyazi" style="text-align:right;"> #TLFormat(total_profit/get_money_money2.rate2/get_money_money2.rate1)# #int_money2# </td>
                                    </cfif>
                                </cfif>
                            </tr>
                        </cfif>
                    </cfoutput>
                    <!--- satır (DISCOUNT1-DISCOUNT5 alanlarındaki) indirimlerinin toplam indirime yansıtılması --->
                    <cfset row_discount_total=0>
                    <cfoutput query="get_rows">
                        <cfscript>
                            if(len(discount1)) row_disc1=discount1; else row_disc1=0;
                            if(len(discount2)) row_disc2=discount2; else row_disc2=0;
                            if(len(discount3)) row_disc3=discount3; else row_disc3=0;
                            if(len(discount4)) row_disc4=discount4; else row_disc4=0;
                            if(len(discount5)) row_disc5=discount5; else row_disc5=0;
                            order_disc_rate_=(10000000000-((100-row_disc1) * (100-row_disc2) * (100-row_disc3) * (100-row_disc4) * (100-row_disc5)));
                        </cfscript>
                        <cfif order_disc_rate_ gt 0>
                            <cfif price_money is not session_base.money>
                                <cfquery name="GET_PRC_MONEY_RATE" dbtype="query" >
                                    SELECT
                                        <cfif isDefined("session.pp")>
                                            RATEPP2 RATE2
                                        <cfelseif isDefined("session.ww")>
                                            RATEWW2 RATE2
                                        <cfelse>
                                            RATE2
                                        </cfif>
                                    FROM 
                                        GET_MONEY
                                    WHERE 
                                        MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#price_money#"> AND
                                        COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#int_comp_id#">
                                </cfquery>
                                <cfset price_money_rate_=get_prc_money_rate.rate2>
                            <cfelse>
                                <cfset price_money_rate_=1>
                            </cfif>
                            <cfset row_discount_=wrk_round(((price_old*order_disc_rate_)/10000000000)*price_money_rate_)>
                            <cfset row_discount_total=row_discount_total+row_discount_>
                        </cfif>
                    </cfoutput>
                    <cfset toplam_indirim = toplam_indirim+row_discount_total>
                    <cfset tum_toplam = tum_toplam+row_discount_total>
                    <cfoutput>
                        <input type="hidden" name="total_discount" id="total_discount" value="<cfif isDefined('tum_indirim1')>#tum_indirim1#<cfelseif isDefined('tum_indirim2')>#tum_indirim2#<cfelseif isDefined('tum_indirim3')>#tum_indirim3#</cfif>" />
                        <input type="hidden" name="prj_discount_price_cat" id="prj_discount_price_cat" value="<cfif isdefined('prj_price_cat_') and len(prj_price_cat_)>#prj_price_cat_#</cfif>" />
                        <input type="hidden" name="urun_kontrol" id="urun_kontrol" value="#urun_kontrol_#" />
                        <input type="hidden" name="grosstotal" id="grosstotal" value="#tum_toplam#" />
                        <input type="hidden" name="grosstotal_ps" id="grosstotal_ps" value="#tum_toplam_ps#" />
                        <input type="hidden" name="taxtotal" id="taxtotal" value="#kdv_toplam#" />
                        <input type="hidden" name="taxtotal_ps" id="taxtotal_ps" value="#kdv_toplam_ps#" />
                        <input type="hidden" name="discounttotal" id="discounttotal" value="#toplam_indirim#" />
                        <input type="hidden" name="discounttotal_ps" id="discounttotal_ps" value="#toplam_indirim_ps#" />
                        <input type="hidden" name="nettotal" id="nettotal" value="#tum_toplam_kdvli#" />
                        <input type="hidden" name="nettotal_ps" id="nettotal_ps" value="#tum_toplam_kdvli_ps#" />
                        <input type="hidden" name="other_money" id="other_money" value="#int_money2#" />
                        <input type="hidden" name="other_money_value" id="other_money_value" value="<cfif len(get_money_money2.rate2)>#tum_toplam_kdvli/(get_money_money2.rate2/get_money_money2.rate1)#</cfif>" />
                        <input type="hidden" name="other_money_value_ps" id="other_money_value_ps" value="<cfif len(get_money_money2.rate2)>#tum_toplam_kdvli_ps/(get_money_money2.rate2/get_money_money2.rate1)#</cfif>" />
                    </cfoutput>
                </table>
                <!--- toplamlar --->
            </td>
        </tr>
    </table>
    <script type="text/javascript">
        document.getElementById('cargo_toplam_kdvli').value='<cfoutput>#cargo_toplam_kdvli#</cfoutput>';
        
        document.getElementById('tum_toplam_kdvli').value='<cfoutput>#tum_toplam_kdvli#</cfoutput>';
        document.getElementById('tum_toplam_kdvli_risk').value='<cfoutput>#tum_toplam_kdvli_risk#</cfoutput>';
        document.getElementById('tum_toplam_komisyonsuz').value='<cfoutput>#tum_toplam_komisyonsuz#</cfoutput>';
        document.getElementById('my_temp_tutar').value='<cfoutput>#my_temp_tutar#</cfoutput>';
        document.getElementById('my_temp_tutar_price_standart').value='<cfoutput>#my_temp_tutar_price_standard#</cfoutput>';
        document.getElementById('toplam_desi').value='<cfoutput>#toplam_desi#</cfoutput>';
        sepet_adres_ = document.getElementById('sepet_adres').value + document.getElementById('project_str').value;
        if(isDefined('price_standart_dsp'))
            document.getElementById('price_standart_dsp').value= commaSplit(wrk_round(<cfoutput>#tum_toplam_kdvli_ps#</cfoutput>));
        risk_hesapla();
        <cfif get_havale.recordcount>
            havale_hesapla();
        </cfif>
        <cfif not isdefined("attributes.is_from_credit")>
            if(document.getElementById('pos_type_id') != undefined && document.getElementById('pos_type_id').value != '')
                listAccounts();
        </cfif>
        <cfif get_door_paymethod.recordcount>
            door_paymethod_hesapla();
        </cfif>
        <cfif isdefined('attributes.is_attachment') and attributes.is_attachment eq 1 and isdefined('session.pp.userid') and not(isdefined('attributes.prj_id') and len(attributes.prj_id))>
            document.getElementById('project_attachment').value = '';
        </cfif>
    </script>
<cfelse>
	<cf_get_lang_main no ='126.Oturum Bulunamadı! Sisteme Yeniden Girmeniz Gerekiyor!'>
</cfif>
