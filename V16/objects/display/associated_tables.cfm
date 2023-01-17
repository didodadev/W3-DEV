<cfquery name="get_orders_ship" datasource="#dsn3#">
    SELECT
        OS.ORDER_ID,
        O.ORDER_NUMBER,
        O.IS_INSTALMENT
    FROM
        ORDERS_SHIP OS,
        ORDERS O
    WHERE
        O.ORDER_ID = OS.ORDER_ID AND
        OS.SHIP_ID = #attributes.ship_id# AND 
        OS.PERIOD_ID = #session.ep.period_id#
</cfquery>
<cfquery name="get_ship_det" datasource="#dsn2#">
    SELECT
        SR.AMOUNT,
        SR.NAME_PRODUCT,
        SR.PRODUCT_ID,
        SR.PRODUCT_ID,
        SR.WRK_ROW_RELATION_ID
    FROM 
        SHIP S, 
        SHIP_ROW SR
    WHERE 
        S.SHIP_ID = SR.SHIP_ID AND 
        S.SHIP_ID = #attributes.ship_id#
    ORDER BY 
        SR.SHIP_ROW_ID
</cfquery>
<cfsavecontent variable="message"><cf_get_lang dictionary_id='31106.Siparişler'></cfsavecontent>
<cf_seperator id="iliskili_siparisler" header="#message#" is_closed="1">
<cf_ajax_list id="iliskili_siparisler">
    <cfif get_orders_ship.recordcount>
        <thead>
            <tr> 
                <th width="17"><cf_get_lang dictionary_id='57487.no'></th>
                <th><cf_get_lang dictionary_id='57657.urun'></th>
                <th style="text-align:right;"><cf_get_lang dictionary_id='32724.İrsaliye Miktari'></th>
                <cfloop query="get_orders_ship">
                    <cfoutput>
                        <th width="70" style="text-align:right;">
                            <cf_get_lang dictionary_id='38491.Sipariş'>:#order_id#<br/>
                            <cfif isdefined("attributes.is_sale")>
                                <cfif is_instalment eq 1>
                                <a href="#request.self#?fuseaction=sales.upd_fast_sale&order_id=#order_id#" target="_blank" style="color:##607d8b">#order_number#</a>
                                <cfelse>
                                    <a href="#request.self#?fuseaction=sales.list_order&event=upd&order_id=#order_id#" target="_blank" style="color:##607d8b">#order_number#</a>
                                </cfif>
                            <cfelseif isdefined("attributes.is_purchase")>
                                <a href="#request.self#?fuseaction=purchase.list_order&event=upd&order_id=#order_id#" target="_blank" style="color:##607d8b">#order_number#</a>
                            </cfif>
                        </th>
                    </cfoutput>
                </cfloop>
            </tr>
        </thead>
        <cfif get_ship_det.recordcount>
            <cfoutput query="get_ship_det">
                <cfset irs_top=0>
                <tbody>
                <tr>
                    <td align="center">#currentRow#</td>
                    <td>#NAME_PRODUCT#</td>
                    <td style="text-align:right;"><cfif isdefined('amount') and len(amount)>#AMOUNT#</cfif></td>
                        <cfloop query="get_orders_ship">
                            <cfquery name="get_related_product" datasource="#dsn3#">		
                                SELECT
                                    WRK_ROW_ID,
                                    ORDER_ID,
                                    QUANTITY
                                FROM 
                                    ORDER_ROW
                                WHERE 
                                    ORDER_ID = #order_id# AND 
                                    WRK_ROW_ID = '#get_ship_det.wrk_row_relation_id#'
                            </cfquery>
                            <td style="text-align:right;">
                                <cfif get_ship_det.wrk_row_relation_id eq get_related_product.wrk_row_id and len(get_related_product.quantity)>
                                    #get_related_product.QUANTITY#
                                <cfelse>
                                    -
                                </cfif>
                            </td>
                        </cfloop>
                    </tr>
                </tbody>
            </cfoutput>
        </cfif>
    <cfelse>
        <tbody>
            <tr>
                <td colspan="4"><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>
            </tr>
        </tbody>
    </cfif>
</cf_ajax_list>
<cfquery name="GET_SHIP_INV_DETAILS" datasource="#dsn2#">
    SELECT
        SHIP.SHIP_DATE,
        SHIP.SHIP_ID,
        SHIP.SHIP_NUMBER,
        INVOICE.INVOICE_DATE,
        INVOICE.INVOICE_NUMBER,
        INVOICE.INVOICE_ID
    FROM
        INVOICE_SHIPS,
        INVOICE,
        SHIP
    WHERE
        INVOICE.INVOICE_ID = INVOICE_SHIPS.INVOICE_ID AND
        SHIP.SHIP_ID = INVOICE_SHIPS.SHIP_ID AND
        SHIP.SHIP_ID = #attributes.ship_id#
    ORDER BY
        SHIP.SHIP_ID
</cfquery>
<cfsavecontent variable="message"><cf_get_lang dictionary_id='58917.Faturalar'></cfsavecontent>
<cf_seperator id="iliskili_faturalar" header="#message#" is_closed="1">
<cf_ajax_list id="iliskili_faturalar" >
    <cfif isdefined('GET_SHIP_INV_DETAILS') and GET_SHIP_INV_DETAILS.recordcount>
        <thead>
            <tr> 
                <th><cf_get_lang dictionary_id='58138.İrsaliye No'></th>
                <th><cf_get_lang dictionary_id='33096.İrsaliye Tarihi'></th>
                <th><cf_get_lang dictionary_id='58133.Fatura No'></th>
                <th><cf_get_lang dictionary_id='58759.Fatura Tarihi'></th>
            </tr>
        </thead>
        <tbody>
            <cfoutput query="GET_SHIP_INV_DETAILS">
                <tr>
                    <td>
                        <cfif isdefined("attributes.is_sale")>
                            <a href="#request.self#?fuseaction=stock.form_add_sale&event=upd&ship_id=#GET_SHIP_INV_DETAILS.SHIP_ID#" target="_blank">#SHIP_NUMBER#</a>
                        <cfelseif isdefined("attributes.is_purchase")>
                            <a href="#request.self#?fuseaction=stock.form_add_purchase&event=upd&ship_id=#GET_SHIP_INV_DETAILS.SHIP_ID#" target="_blank">#SHIP_NUMBER#</a>
                        </cfif>
                    </td>
                    <td>#dateformat(SHIP_DATE,dateformat_style)#</td>
                    <td>
                        <cfif isdefined("attributes.is_sale")>
                            <a href="#request.self#?fuseaction=invoice.form_add_bill&event=upd&iid=#INVOICE_ID#" target="_blank">#INVOICE_NUMBER#</a>
                        <cfelseif isdefined("attributes.is_purchase")>
                            <a href="#request.self#?fuseaction=invoice.form_add_bill_purchase&event=upd&iid=#INVOICE_ID#" target="_blank">#INVOICE_NUMBER#</a>
                        </cfif>
                    </td>
                    <td>#dateformat(INVOICE_DATE,dateformat_style)#</td>
                </tr>
            </cfoutput>
        </tbody>
    <cfelse>
        <tbody>
            <tr>
                <td colspan="4"><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>
            </tr>
        </tbody>
    </cfif>
</cf_ajax_list>