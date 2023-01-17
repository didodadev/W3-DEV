<cfinclude template="/V16/objects/functions/barcode.cfm">
<cfquery name="GET_DETAIL" datasource="#dsn3#">
	SELECT 
		PRODUCTION_ORDERS.P_ORDER_NO,
		PRODUCTION_ORDERS.SPECT_VAR_ID,
		PRODUCTION_ORDERS.SPECT_VAR_NAME,
		PRODUCTION_ORDERS.ORDER_ID,
		PRODUCTION_ORDER_RESULTS.*
	FROM
		PRODUCTION_ORDERS,
		PRODUCTION_ORDER_RESULTS
	WHERE
		<!--- PRODUCTION_ORDERS.P_ORDER_ID = #attributes.action_id# AND  --->
		PRODUCTION_ORDER_RESULTS.PR_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_id#"> AND
		PRODUCTION_ORDERS.P_ORDER_ID = PRODUCTION_ORDER_RESULTS.P_ORDER_ID
</cfquery>
<cfquery name="GET_ROW_ENTER" datasource="#dsn3#">
	SELECT * FROM PRODUCTION_ORDER_RESULTS_ROW WHERE PR_ORDER_ID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#get_detail.pr_order_id#"> AND TYPE = 1
</cfquery>
<cfquery name="GET_CAT" datasource="#dsn3#">
	SELECT PROCESS_CAT_ID FROM SETUP_PROCESS_CAT WHERE PROCESS_TYPE = 110
</cfquery>
<cfquery name="GET_FIS" datasource="#dsn2#">
	SELECT FIS_NUMBER,FIS_TYPE,FIS_ID,FIS_DATE FROM STOCK_FIS WHERE PROD_ORDER_NUMBER = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_id#"> AND PROCESS_CAT = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_CAT.PROCESS_CAT_ID#">
</cfquery>
<cfquery name="get_stock_info" datasource="#dsn3#">
	SELECT STOCK_CODE,PRODUCT_NAME,PROPERTY FROM STOCKS WHERE STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_ROW_ENTER.stock_id#">
</cfquery>

<cfquery name="GET_SERIAL_INFO" datasource="#DSN3#">
	SELECT
		SG.LOT_NO,
		SG.SERIAL_NO
	FROM
		SERVICE_GUARANTY_NEW AS SG
	WHERE
		STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_ROW_ENTER.stock_id#"> AND
		PROCESS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_id#"> AND
		PROCESS_CAT = 171 AND
		SG.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">
</cfquery>
<cfif (not GET_SERIAL_INFO.recordcount) and GET_FIS.recordcount>
	<cfquery name="GET_SERIAL_INFO" datasource="#DSN3#">
        SELECT
            SG.LOT_NO,
            SG.SERIAL_NO
        FROM
            SERVICE_GUARANTY_NEW AS SG
        WHERE
            STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_ROW_ENTER.stock_id#"> AND
            PROCESS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_FIS.FIS_ID#"> AND
            PROCESS_CAT = 110 AND
            SG.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">
    </cfquery>
</cfif>
<cfloop query="GET_DETAIL">
<table border="0" cellpadding="0" cellspacing="0" style="width:100mm;" align="center">
	<tr>
		<td style="height:14mm;"></td>
	</tr>
	<tr>
    	<td style="height:87.5mm;" align="center" valign="top">
			<table border="0" width="98%" align="center">
				<cfoutput>
                <tr>
                    <td>&nbsp;</td>
                    <td>&nbsp;</td>
                    <td><cf_get_lang_main no='1677.Emir No'></td>
                    <td>:#get_detail.production_order_no#</td>
				</tr>
				<tr>
                    <td style="width:15mm;"><cf_get_lang_main no='799.Sipariş No'></td>
                    <td style="width:26mm;">:#get_detail.order_no#</td>
                    <td style="width:15mm;"><cf_get_lang no='1924.Sonuç No'></td>
                    <td>:#get_detail.result_no#</td>
                </tr>
                <tr>
                    <td><cf_get_lang_main no='106.Stok Kodu'></td>
                    <td>:#get_stock_info.stock_code#</td>
                    <td><cf_get_lang no='83.Uretim Tarihi'></td>
                    <td>:<!--- <cfset finish_ = date_add("d",session.ep.time_zone,get_detail.finish_date)> --->
                    	#dateformat(get_detail.finish_date,dateformat_style)# #timeformat(get_detail.finish_date,timeformat_style)#
                    </td>
                </tr>
                <tr>
                	<td class="formbold" colspan="4">
					<cfif len(GET_DETAIL.SPECT_VAR_ID)>
                        #GET_DETAIL.SPECT_VAR_NAME#
                    <cfelse>
                        #get_stock_info.product_name#
                    </cfif>
                	</td>
                </tr>
                <tr class="txtbold">
                    <td colspan="2" valign="bottom" style="height:10mm;"><cf_get_lang_main no='221.Barkod'></td>
                    <td colspan="2" valign="bottom" style="text-align:right;"><cf_get_lang_main no='225.Seri No'>&nbsp;&nbsp;</td>
                </tr>
                <tr>
                    <td colspan="2">&nbsp;
                        <cfif (len(GET_ROW_ENTER.barcode) eq 13) or (len(GET_ROW_ENTER.barcode) eq 12)>
                            <cf_barcode type="EAN13" barcode="#GET_ROW_ENTER.barcode#" extra_height="0"><cfif len(errors)>#errors#</cfif>
                        <cfelseif (len(GET_ROW_ENTER.barcode) eq 8) or (len(GET_ROW_ENTER.barcode) eq 7)>
                            <cf_barcode type="EAN8" barcode="#GET_ROW_ENTER.barcode#" extra_height="0"><cfif len(errors)>#errors#</cfif>
                        <cfelseif (len(GET_ROW_ENTER.barcode) eq 9)>
                            <cf_barcode type="EAN13" barcode="#GET_ROW_ENTER.barcode#000" extra_height="0"><cfif len(errors)><cfoutput>#errors#</cfoutput></cfif>
                        <cfelseif (len(GET_ROW_ENTER.barcode) eq 10)>
                            <cf_barcode type="EAN13" barcode="#GET_ROW_ENTER.barcode#00" extra_height="0"><cfif len(errors)><cfoutput>#errors#</cfoutput></cfif>
                        <cfelseif (len(GET_ROW_ENTER.barcode) eq 11)>
                            <cf_barcode type="EAN13" barcode="#GET_ROW_ENTER.barcode#0" extra_height="0"><cfif len(errors)><cfoutput>#errors#</cfoutput></cfif>
                        </cfif>
                    </td>
                    <td colspan="2" style="text-align:right;">
                        <cfif isnumeric(GET_SERIAL_INFO.SERIAL_NO) and (len(GET_SERIAL_INFO.SERIAL_NO) mod 2) eq 0>
                            <CF_BarcodeGenerator BarCode="#GET_SERIAL_INFO.SERIAL_NO#">
                        <cfelse>
                            <CF_BarcodeGenerator BarCode="#GET_SERIAL_INFO.SERIAL_NO#" BarCodeType="8">
                        </cfif>
                    </td>
                </tr>
			  </cfoutput>			
		  </table>
		</td>
	</tr>
</table>
</cfloop>
