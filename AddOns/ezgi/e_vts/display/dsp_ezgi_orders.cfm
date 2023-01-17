<cfquery name="get_order_rows" datasource="#dsn3#">
	SELECT        
    	S.PRODUCT_CODE, 
        S.PRODUCT_CODE_2, 
        S.PRODUCT_NAME, 
        ORR.SPECT_VAR_NAME, 
        ORR.UNIT, 
        ORR.QUANTITY
	FROM            
    	ORDER_ROW AS ORR INNER JOIN
     	STOCKS AS S ON ORR.STOCK_ID = S.STOCK_ID
	WHERE        
    	ORR.ORDER_ID = #attributes.order_id#
</cfquery>
<table width="100%">
	<tr>
    	<td>
            <cf_box title="#getLang('main',3111)#">
                <cf_ajax_list>
                    <thead>
                        <tr>
                            <th style=" height:20px;width:25;text-align:center;"><cf_get_lang_main no='1165.Sıra'></th>
                         	<th style="width:120px;text-align:left;"><cf_get_lang_main no='106.Stok Kodu'></th>
                          	<th style="width:150px;text-align:left;"><cf_get_lang_main no='245.Ürün'></th>
                          	<th style="width:70px;text-align:right;"><cf_get_lang_main no='223.Miktar'></th>
                            <th style="width:60px;text-align:left;"><cf_get_lang_main no='224.Birim'></th>
                            <th style="text-align:center;"><cf_get_lang_main no='235.Spekt'></th>
                       </tr>
                    </thead>
                    <tbody>
                    	<cfif get_order_rows.recordcount>
							<cfoutput query="get_order_rows">
                   				<tr style="height:30px">
                                	<td style="background-color:FFFFCC;text-align:center;">#currentrow#&nbsp;</td>
                                    <td style="background-color:FFFFCC;text-align:left;">&nbsp;#PRODUCT_CODE#</td>
                                    <td style="background-color:FFFFCC;text-align:left;" nowrap="nowrap">&nbsp;#PRODUCT_NAME#</td>
                                    <td style="background-color:FFFFCC;text-align:right;">#TlFormat(QUANTITY,2)#&nbsp;</td>
                                    <td style="background-color:FFFFCC;text-align:left;">&nbsp;#UNIT#</td>
                                    <td style="background-color:FFFFCC;text-align:left;">&nbsp;#SPECT_VAR_NAME#</td>
                    			</tr>
                          	</cfoutput>
                      	</cfif>
                    </tbody>
                </cf_ajax_list>
            </cf_box>
     	</td>
  	</tr>
</table>
<table border="0" width="100%">
	<tr height="20">
    	<td class="box_yazi_td2" style="width:100%;text-align:right">
        	<input type="button" value="<cfoutput>#getLang('main',141)#</cfoutput>" name="kapat" onClick="window.close();" style=" width:100px; height:50px">&nbsp;&nbsp;
       	</td>
  	</tr>
</table>
