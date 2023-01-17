<!--- Depolara Göre Stok Durumu --->
<cfsavecontent  variable="variable"><cf_get_lang dictionary_id ='33975.Depolara Göre Stok Durumu'>
</cfsavecontent>
<cfif isdefined("attributes.crtrow")>
	<cfset attributes.crtrow = attributes.crtrow>
<cfelseif isdefined("attributes.row_number")>
	<cfset attributes.crtrow = attributes.row_number>
</cfif>
<cf_seperator title="#variable#" id="stock_#attributes.crtrow#">
    <cf_flat_list id="stock_#attributes.crtrow#">
        <cfquery name="GET_STOCKS_ALL" datasource="#DSN2#">
            SELECT 
                SR.PRODUCT_STOCK,
                SR.STOCK_ID,
                SR.STOCK_CODE,
                SR.BARCOD,
                SR.PROPERTY,
                SR.PRODUCT_ID,
                D.DEPARTMENT_ID,
                D.DEPARTMENT_HEAD
            FROM 
                GET_STOCK_PRODUCT SR,
                #dsn_alias#.DEPARTMENT D
            WHERE 
                SR.DEPARTMENT_ID = D.DEPARTMENT_ID AND
                <cfif isdefined('attributes.sid') and len(attributes.sid)>
                SR.STOCK_ID=#attributes.sid#
                <cfelse>
                SR.PRODUCT_ID=#attributes.pid#
                </cfif>
            ORDER BY
                SR.DEPARTMENT_ID,
                SR.STOCK_ID
        </cfquery>
        <cfif  get_stocks_all.recordcount>
            <thead>
                <tr>
                    <th width="175"><cf_get_lang dictionary_id='58763.depo'></td>
                    <th style="text-align:right;" nowrap="nowrap">&nbsp;<cf_get_lang dictionary_id='57635.miktar'>-<cf_get_lang dictionary_id='57636.birim'></th>
                </tr>
            </thead>
            <tbody>
            <cfset department_stock_total = 0>
            <cfoutput query="get_stocks_all">
                <cfset serial_product_stock = 0>
                <cfif isDefined("attributes.solo_serial_no") and len(attributes.solo_serial_no)>
                    <cfquery name="get_purchase_serial" datasource="#dsn3#">
                        SELECT ISNULL(SUM(SGN.UNIT_ROW_QUANTITY),0) AS PURC_ROW_Q FROM SERVICE_GUARANTY_NEW SGN WHERE SERIAL_NO = '#attributes.solo_serial_no#' AND IN_OUT = 1 AND DEPARTMENT_ID = #DEPARTMENT_ID#
                    </cfquery>
                    <cfquery name="get_sale_serial" datasource="#dsn3#">
                        SELECT ISNULL(SUM(SGN.UNIT_ROW_QUANTITY),0) AS PURC_ROW_Q FROM SERVICE_GUARANTY_NEW SGN WHERE SERIAL_NO = '#attributes.solo_serial_no#' AND IN_OUT = 0 AND DEPARTMENT_ID = #DEPARTMENT_ID#
                    </cfquery>
                    <cfset serial_product_stock = get_purchase_serial.PURC_ROW_Q - get_sale_serial.PURC_ROW_Q>
                </cfif>
                <tr>
                    <td>#department_head#</td>
                    <td style="text-align:right;">
                        <cfif isDefined("attributes.solo_serial_no") and len(attributes.solo_serial_no)>
                            #AmountFormat(serial_product_stock)#
                            <cfif len(serial_product_stock)><cfset department_stock_total += serial_product_stock>	</cfif>
                        <cfelse>
                            <cfif product_stock lt 0>
                                <font color="red">#AmountFormat(product_stock)# <!--- #get_product.main_unit# ---></font>
                            <cfelse>
                                #AmountFormat(product_stock)# <!--- #get_product.main_unit# --->
                            </cfif>
                            <cfif len(product_stock)><cfset department_stock_total = department_stock_total + product_stock>	</cfif>
                        </cfif>
                    </td>
                </tr>
            
            </cfoutput>
            <tr>
                <td class="txtbold"><cf_get_lang dictionary_id ='57492.Toplam'></td>
                <td class="txtbold" style="text-align:right;"><cfoutput>#AmountFormat(department_stock_total)#</cfoutput></td>
            </tr>
            </tbody>
        <cfelse>
            <tr>
                <td colspan="3"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>
            </tr>
        </cfif>
    </cf_flat_list>

