<table border="0" cellspacing="1" cellpadding="2" class="color-header">
    <tr class="color-header" height="20">
        <td colspan="13" class="form-title"><cf_get_lang dictionary_id='36456.Sipariş Karşılama Tablosu'></td>
    </tr>
    <tr class="color-list" height="20">
        <td width="90" class="txtboldblue"><cf_get_lang dictionary_id='57518.Stok Kodu'></td>
        <td class="txtboldblue"><cf_get_lang dictionary_id='57657.Ürün'></td>
        <td width="70" class="txtboldblue"><cf_get_lang dictionary_id='57647.spec'></td>
        <cfif session.ep.our_company_info.workcube_sector eq 'tex'>
        <td width="70" class="txtboldblue"><cf_get_lang dictionary_id='36588.asorti'></td>
        </cfif>
        <td width="50" align="right" class="txtboldblue" style="text-align:right;"><cf_get_lang dictionary_id='58046.Sipariş Talebi'></td>
        <td width="50" align="right" class="txtboldblue" style="text-align:right;"><cf_get_lang dictionary_id='36459.Sipariş Verilen'></td>
        <td width="50" align="right" class="txtboldblue" style="text-align:right;"><cf_get_lang dictionary_id='58048.Rezerve Edilen'></td>
        <td width="50" align="right" class="txtboldblue" style="text-align:right;"><cf_get_lang dictionary_id='58120.Gerçek Stok'></td>
        <td width="50" align="right" class="txtboldblue" style="text-align:right;"><cf_get_lang dictionary_id='60526.Kullanılabilir Stok'></td>
        <td width="50" align="right" class="txtboldblue" style="text-align:right;"><cf_get_lang dictionary_id='36800.Verilen Ü.E'></td>
        <td width="50" align="right" class="txtboldblue" style="text-align:right;"><cf_get_lang dictionary_id='36801.Kalan Ü.E'></td>
        <td width="150" class="txtboldblue" align="center"><cf_get_lang dictionary_id='58834.İstasyon'></td>
        <td width="15"></td>
        <td width="15"></td>
    </tr>
    <cfif GET_ORDERS_PRODUCTS.recordcount>
        <cfset order_product_id_list = ValueList(GET_ORDERS_PRODUCTS.PRODUCT_ID,',')>
        <cfset order_stock_id_list = ValueList(GET_ORDERS_PRODUCTS.STOCK_ID,',')>
        <cfset order_stock_id_list=listsort(order_stock_id_list,"numeric","ASC",",")>
        <cfset order_product_id_list=listsort(order_product_id_list,"numeric","ASC",",")>
        <cfquery name="_PRODUCT_TOTAL_STOCK_" datasource="#DSN2#">
            SELECT 
                PRODUCT_TOTAL_STOCK,PRODUCT_ID
            FROM 
                GET_PRODUCT_STOCK 
            WHERE 
              <cfif isdefined("order_product_id_list") and len(order_product_id_list)>
                PRODUCT_ID IN (#order_product_id_list#)
              <cfelse>
                PRODUCT_ID IS NULL
              </cfif>
        </cfquery>
        <cfset order_product_id_list = listsort(listdeleteduplicates(valuelist(_PRODUCT_TOTAL_STOCK_.PRODUCT_ID,',')),'numeric','ASC',',')>
        <cfquery name="_GET_STOCK_RESERVED_" datasource="#DSN3#">
            SELECT
                ISNULL(SUM(STOCK_ARTIR),0) AS ARTAN,
                ISNULL(SUM(STOCK_AZALT),0) AS AZALAN,
                STOCK_ID
            FROM
                GET_STOCK_RESERVED
            WHERE
                STOCK_ID IN (#order_stock_id_list#)
            GROUP BY STOCK_ID	
        </cfquery>
        <cfset order_stock_id_list = listsort(listdeleteduplicates(valuelist(_GET_STOCK_RESERVED_.STOCK_ID,',')),'numeric','ASC',',')>
    </cfif>
    <cfoutput query="GET_ORDERS_PRODUCTS">
        <cfset attributes.stock_id = STOCK_ID>
        <cfset attributes.product_id = PRODUCT_ID>
        <cfif len(_PRODUCT_TOTAL_STOCK_.PRODUCT_TOTAL_STOCK[listfind(order_product_id_list,GET_ORDERS_PRODUCTS.PRODUCT_ID,',')])>
            <cfset PRODUCT_STOCK = _PRODUCT_TOTAL_STOCK_.PRODUCT_TOTAL_STOCK[listfind(order_product_id_list,GET_ORDERS_PRODUCTS.PRODUCT_ID,',')]>
        <cfelse>
            <cfset PRODUCT_STOCK = 0 >
        </cfif>
        <cfif _GET_STOCK_RESERVED_.recordcount and len(_GET_STOCK_RESERVED_.ARTAN)>
            <cfif len(_GET_STOCK_RESERVED_.ARTAN[listfind(order_stock_id_list,GET_ORDERS_PRODUCTS.STOCK_ID,',')])>
                <cfset GET_STOCK_RESERVED_ARTAN = _GET_STOCK_RESERVED_.ARTAN[listfind(order_stock_id_list,GET_ORDERS_PRODUCTS.STOCK_ID,',')]>
            <cfelse>
                <cfset GET_STOCK_RESERVED_ARTAN = 0>	
            </cfif>
            <cfset PRODUCT_ARTAN = GET_STOCK_RESERVED_ARTAN >
            <cfset PRODUCT_STOCK = PRODUCT_STOCK + GET_STOCK_RESERVED_ARTAN>
        </cfif>
        <cfif _GET_STOCK_RESERVED_.recordcount and len(_GET_STOCK_RESERVED_.AZALAN)>
            <cfif len(_GET_STOCK_RESERVED_.AZALAN[listfind(order_stock_id_list,GET_ORDERS_PRODUCTS.STOCK_ID,',')])>
                <cfset GET_STOCK_RESERVED_AZALAN = _GET_STOCK_RESERVED_.AZALAN[listfind(order_stock_id_list,GET_ORDERS_PRODUCTS.STOCK_ID,',')] >
            <cfelse>
                <cfset GET_STOCK_RESERVED_AZALAN = 0 >
            </cfif>
            <cfset PRODUCT_AZALAN = GET_STOCK_RESERVED_AZALAN>
            <cfset PRODUCT_STOCK = PRODUCT_STOCK - GET_STOCK_RESERVED_AZALAN >
        </cfif>
     </cfoutput>
        <tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
            <td><a class="tableyazi" href="#request.self#?fuseaction=stock.list_stock&event=det&pid=#PRODUCT_ID#">#STOCK_CODE#</a> </td>
            <td><a class="tableyazi" href="#request.self#?fuseaction=prod.add_product_tree&stock_id=#STOCK_ID#">#PRODUCT_NAME##PROPERTY#</a></td>
            <td><a href="javascript://" class="tableyazi" onClick="windowopen('#request.self#?fuseaction=objects.popup_upd_spect&id=#SPECT_VAR_ID#&order_id=#order_id#','list');">#SPECT_VAR_NAME#</a></td>
            <td align="right" style="text-align:right;">#QUANTITY#</td>
            <td align="right" style="text-align:right;"><cfif isdefined('PRODUCT_ARTAN')>#PRODUCT_ARTAN#</cfif></td>
            <td align="right" style="text-align:right;"><cfif isdefined('PRODUCT_AZALAN')>#PRODUCT_AZALAN#</cfif></td>
            <td align="right" style="text-align:right;">#_PRODUCT_TOTAL_STOCK_.PRODUCT_TOTAL_STOCK[listfind(order_product_id_list,GET_ORDERS_PRODUCTS.PRODUCT_ID,',')]#	<!--- Liste Yöntemi Gerçek Stok: ---></td>
            <td align="right" style="text-align:right;">#WRK_ROUND(PRODUCT_STOCK)#</td>
            <cfquery name="GET_PRODUCTION_INFO" datasource="#DSN3#">
               SELECT
                    SUM(PO.QUANTITY) QUANTITY
                FROM 
                    PRODUCTION_ORDERS PO 
                WHERE 
                    P_ORDER_ID IN(SELECT PRODUCTION_ORDER_ID FROM PRODUCTION_ORDERS_ROW WHERE ORDER_ROW_ID IN (#attributes.order_row_id#))
                    AND PRODUCTION_LEVEL = 0
            </cfquery>
            <cfif GET_PRODUCTION_INFO.recordcount and len(GET_PRODUCTION_INFO.QUANTITY)>
                <cfset 'verilen_uretim_emri#currentrow#' = GET_PRODUCTION_INFO.QUANTITY>
            <cfelse>
                <cfset 'verilen_uretim_emri#currentrow#' =  0>
            </cfif>
            <cfif len(_PRODUCT_TOTAL_STOCK_.PRODUCT_TOTAL_STOCK[listfind(order_product_id_list,GET_ORDERS_PRODUCTS.PRODUCT_ID,',')]) and _PRODUCT_TOTAL_STOCK_.PRODUCT_TOTAL_STOCK[listfind(order_product_id_list,GET_ORDERS_PRODUCTS.PRODUCT_ID,',')] lt 0>
                <cfset gerekli_uretim_miktarı = QUANTITY - _PRODUCT_TOTAL_STOCK_.PRODUCT_TOTAL_STOCK[listfind(order_product_id_list,GET_ORDERS_PRODUCTS.PRODUCT_ID,',')]>
            <cfelse>
                <cfset gerekli_uretim_miktarı = QUANTITY >
            </cfif>
            <cfset gerekli_uretim_miktarı = gerekli_uretim_miktarı - Evaluate('verilen_uretim_emri#currentrow#')>
            <td align="right" style="text-align:right;">#Evaluate('verilen_uretim_emri#currentrow#')#</td>
            <td align="right" style="text-align:right;">
            <input type="hidden" style="width:50px;" name="product_amount_old" id="product_amount_old" value="#TlFormat(gerekli_uretim_miktarı,2)#">
            <input type="text" style="width:50px;" name="product_amount0" id="product_amount0" value="#TlFormat(gerekli_uretim_miktarı,2)#" onChange="calculate_production_amounts();" class="box"></td>
            <cfif isdefined('is_product_station_relation') and is_product_station_relation eq 0><!--- Eğerki XML ayarlarından İStasyon Ürün ilişkisi kullanma seçilmiş ise tüm istasyonları gelicek her seferinde. --->
            <cfquery name="get_stations" datasource="#dsn3#">
                SELECT
                    -1 AS WS_P_ID,
                    0 AS PRODUCTION_TYPE,
                    0 AS MIN_PRODUCT_AMOUNT,
                    0 AS SETUP_TIME,
                    STATION_ID,
                    STATION_NAME
                    FROM 
                WORKSTATIONS
                    WHERE 
                ACTIVE = 1
            </cfquery>
        <cfelse>
            <cfquery name="get_stations" datasource="#dsn3#">
                SELECT STATION_ID,STATION_NAME,PRODUCTION_TYPE,MIN_PRODUCT_AMOUNT,SETUP_TIME FROM WORKSTATIONS_PRODUCTS WSP,WORKSTATIONS WS WHERE WS.STATION_ID = WSP.WS_ID AND WSP.STOCK_ID = #stock_id#
            </cfquery>
        </cfif>
        <td><div style="display:none"><input type="checkbox" name="product_is_production0" id="product_is_production0" checked></div><!--- Ana ürün için ürünün üretileceğini belirtiyoruz. --->
            <select name="station_id0" id="station_id0" style="width:120px;">
                <cfloop query="get_stations">
                    <option value="#STATION_ID#,#PRODUCTION_TYPE#,#MIN_PRODUCT_AMOUNT#,#SETUP_TIME#">#STATION_NAME#&nbsp;[#MIN_PRODUCT_AMOUNT#]</option>
                </cfloop>
            </select>
        </td>
        <td align="right" style="text-align:right;"><cfif IS_PRODUCTION eq 1><a href="javascript://" class="tableyazi" onClick="gizle_goster(_PRODUCT_TREE_#STOCK_ID#);AjaxPageLoad('#request.self#?fuseaction=prod.popup_ajax_display_product_tree#xml_str#&company_id=#GET_ORDERER.COMPANY_ID#&order_row_id=#attributes.ORDER_ROW_ID#&stock_id=#stock_id#&order_amount=#QUANTITY#&order_id=#ORDER_DETAIL.ORDER_ID#&spect_var_id=#SPECT_VAR_ID#&deliver_date=#DateFormat(ORDER_DETAIL.DELIVERDATE,dateformat_style)#','PRODUCT_TREE#STOCK_ID#',1);"><img src="/images/shema_list.gif" title="<cf_get_lang dictionary_id='36323.Alt Ağaç'>" border="0"></a></cfif></td>
        <td align="right" style="text-align:right;"><cfif IS_PRODUCTION eq 1><a href="javascript://" class="tableyazi" onClick="gizle_goster(_PRODUCT_STOCKS_STATUS_#STOCK_ID#);AjaxPageLoad('#request.self#?fuseaction=prod.popup_ajax_order_products_stock_status&stock_id=#stock_id#&order_amount=#QUANTITY#&spect_var_id=#SPECT_VAR_ID#','PRODUCT_STOCKS_STATUS#STOCK_ID#',1);"><img src="/images/ques_list.gif" title="<cf_get_lang dictionary_id='36497.Malzeme İhtiyaçları'>" border="0"></a></cfif></td>
    </tr>
</table>
