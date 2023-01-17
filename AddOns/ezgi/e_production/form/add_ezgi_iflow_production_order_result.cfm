<cfset module_name="prod">
<cfset station_type = 1>
<cf_papers paper_type="production_result">
<table class="dph">
    <tr>
        <td class="dpht">&nbsp;<cf_get_lang_main no='3342.Üretim Emir Sonucu Ekle'></td>
        <td class="dphb">
        	<cfoutput>

            </cfoutput>
            &nbsp;&nbsp;
        </td>
	</tr>
</table>

<cfquery name="get_production_orders" datasource="#dsn3#">
	SELECT        
    	ISNULL(PO.PRINT_COUNT, 0) AS PRINT_COUNT, 
        S.PRODUCT_ID, 
        S.PRODUCT_NAME, 
        S.PRODUCT_CODE, 
        PO.STOCK_ID, 
        PO.PO_RELATED_ID, 
        PO.QUANTITY, 
        PO.LOT_NO, 
        P.MAIN_UNIT AS UNIT, 
     	PO.P_ORDER_ID, 
        PO.P_ORDER_NO, 
        ISNULL(PO.IS_GROUP_LOT, 0) AS IS_GROUP_LOT, 
        PO.GROUP_LOT_NO, 
        PO.IS_STAGE, 
        PO.STATION_ID, 
        ISNULL(TBL.AMOUNT, 0) AS AMOUNT
	FROM            
    	PRODUCTION_ORDERS AS PO INNER JOIN
      	PRODUCT_UNIT AS P INNER JOIN
      	STOCKS AS S ON P.PRODUCT_ID = S.PRODUCT_ID ON PO.STOCK_ID = S.STOCK_ID LEFT OUTER JOIN
    	(
        	SELECT        
            	POR.P_ORDER_ID, SUM(PORR.AMOUNT) AS AMOUNT
         	FROM            
            	PRODUCTION_ORDER_RESULTS AS POR INNER JOIN
             	PRODUCTION_ORDER_RESULTS_ROW AS PORR ON POR.PR_ORDER_ID = PORR.PR_ORDER_ID
          	WHERE        
            	PORR.TYPE = 1 AND 
                POR.IS_STOCK_FIS = 1
         	GROUP BY 
            	POR.P_ORDER_ID
    	) AS TBL ON PO.P_ORDER_ID = TBL.P_ORDER_ID
	WHERE     
    	PO.P_ORDER_ID = #attributes.p_order_id#
</cfquery>
<cfquery name="get_stations" datasource="#dsn3#">
	SELECT 
    	STATION_ID, UP_STATION, STATION_NAME 
  	FROM 
    	WORKSTATIONS 
  	WHERE 
    	(STATION_ID = #get_production_orders.STATION_ID# OR UP_STATION = #get_production_orders.STATION_ID#)
        <cfif station_type eq 1>
        	AND UP_STATION IS NULL
        </cfif>
  	ORDER BY
    	UP_STATION, STATION_NAME
</cfquery>
<cfform name="upd_operation" method="post" action="#request.self#?fuseaction=prod.emptypopup_add_ezgi_iflow_production_order_result">
	
    <table class="dpm" align="center" style="height:100%">
        <tr>
        	<td style="display:none;">
            	<cf_workcube_process_cat slct_width="140">
    			<cf_workcube_process is_upd='0' process_cat_width='130' is_detail='0'>
            </td>
            <td valign="top" class="dpml" style="height:100%">
                <cf_form_box>	
                    <cfinput type="hidden" name="p_order_id" value="#attributes.p_order_id#">
                    <cfoutput>
                	<table style="height:100%">
                        <tr height="25px">
                            <td valign="top" style="font-weight:bold">#getLang('prod',385)#</td>
                            <td valign="top">:&nbsp;
                            	<cfinput name="lot_no" readonly="yes" type="text" style="width:65px; text-align:center" value="#get_production_orders.LOT_NO#">
                            </td>
                      	</tr>
                     	<tr height="25px">
                            <td valign="top" style="font-weight:bold"><cf_get_lang_main no='1677.Emir No'> </td>
                            <td valign="top">:&nbsp;
                            	<cfinput name="P_ORDER_NO" readonly="yes" type="text" style="width:65px; text-align:center" value="#get_production_orders.P_ORDER_NO#">
                            </td>
                      	</tr>
                        <tr height="25px">
                            <td valign="top" style="font-weight:bold"><cf_get_lang_main no='809.Ürün Adı'> </td>
                            <td valign="top">:&nbsp;
                            	<cfinput name="product_name" readonly="yes" type="text" id="product_name" style="width:350px" value="#get_production_orders.PRODUCT_NAME#">
                            </td>
                      	</tr>
                        <tr height="25px">
                            <td valign="top" style="font-weight:bold"><cf_get_lang_main no='2995.Emir Miktarı'>	 / <cfoutput>#getLang('prod',295)#</cfoutput></td>
                            <td valign="top">:&nbsp;
                            	<cfinput name="order_amount" readonly="yes" type="text" style="width:85px; text-align:right" value="#TlFormat(get_production_orders.QUANTITY,8)#" class="box">&nbsp;
                                <cfinput name="produced_amount" readonly="yes" type="text" style="width:85px; text-align:right" value="#TlFormat(get_production_orders.AMOUNT,8)#" class="box">
                            </td>
                      	</tr>
              
                        <tr height="25px">
                            <td valign="top" style="font-weight:bold"><cf_get_lang_main no='1422.İstasyon'></td>
                            <td valign="top">:&nbsp;
                            	<select name="station_id" id="station_id" style="width:200px; height:20px">
									<cfloop query="get_stations">
                                    	<cfif station_type neq 1>
                                    		<option value="#STATION_ID#" <cfif not len(UP_STATION)>disabled="disabled"</cfif>>#STATION_NAME#</option>
                                        <cfelse>
                                        	<option value="#STATION_ID#">#STATION_NAME#</option>
                                        </cfif>
                                    </cfloop>
                                </select>
                            </td>
                      	</tr>
                        <tr height="25px">
                            <td valign="top" style="font-weight:bold"><cf_get_lang_main no='3296.Üretim Tarihi'></td>
                            <td valign="top">:&nbsp;
                            	<input type="text" name="action_date" id="action_date"  validate="eurodate" style="width:65px;" value="#DateFormat(now(), 'DD/MM/YYYY')#"> 
                                <cf_wrk_date_image date_field="action_date">
                            </td>
                      	</tr>
                        <tr height="25px">
                            <td valign="top" style="font-weight:bold"><cf_get_lang_main no='44.Üretim'></td>
                            <td valign="top">:&nbsp;
                            	<cfinput name="amount" id="amount" type="text" style="width:85px; text-align:right" value="#TlFormat(get_production_orders.QUANTITY-get_production_orders.AMOUNT,8)#">
                            </td>
                      	</tr>
                    </table>
                    </cfoutput>
                    <cf_form_box_footer>
                       	<cf_workcube_buttons 
                         	is_upd='0' 
                       		is_delete = '0' 
                        	add_function='kontrol()'>
          			</cf_form_box_footer>
            	</cf_form_box>
         	</td>
      	</tr>
    </table>
</cfform>
<script type="text/javascript">
	function kontrol()
	{
		if(document.getElementById("amount").value <= 0)
		{
			alert("<cf_get_lang_main no='3343.Üretim 0 dan büyük olmalıdır.'> !");
			document.getElementById('amount').focus();
			return false;
		}
		if(document.getElementById("action_date").value <= 0)
		{
			alert("<cf_get_lang_main no='3344.Tarih Değerini Kontrol Ediniz.'> !");
			document.getElementById('action_date').focus();
			return false;
		}
	}
</script>