<cfset module_name="objects"> 
<cfset toplam = 0>
<cfset purchase_total= 0>
<cfset cost_total= 0>
<cfquery name="get_money" datasource="#dsn#">
	SELECT MONEY, RATE2 FROM SETUP_MONEY WHERE PERIOD_ID = #session.ep.period_id# AND (MONEY_STATUS = 1)
</cfquery> 
<cfoutput query="get_money">
	<cfset 'RATE2_#MONEY#' = RATE2>
</cfoutput>
<cfquery name="get_product" datasource="#dsn3#">
	SELECT        
    	VIRTUAL_OFFER_ROW_ID, 
        PRODUCT_TYPE, 
        PRODUCT_ID, 
        STOCK_ID, 
        STOCK_CODE,
       	BOY, 
      	EN, 
       	DERINLIK,
		ISNULL(YON,1) YON, 
        PRODUCT_CODE_2, 
        PRODUCT_NAME,
		ISNULL((SELECT OFFER_ID FROM OFFER_ROW WHERE WRK_ROW_ID = EZGI_VIRTUAL_OFFER_ROW.WRK_ROW_RELATION_ID),0) AS OFFER_ID,
        ISNULL((SELECT IS_PROTOTYPE FROM STOCKS WHERE STOCK_ID = EZGI_VIRTUAL_OFFER_ROW.STOCK_ID),0) AS IS_PROTOTIP,
        ISNULL((SELECT MAIN_PROTOTIP_TYPE FROM EZGI_DESIGN_MAIN_ROW WHERE DESIGN_MAIN_RELATED_ID = EZGI_VIRTUAL_OFFER_ROW.STOCK_ID AND DESIGN_MAIN_STATUS =1 AND MAIN_PROTOTIP_TYPE = 1),0) AS MAIN_PROTOTIP_TYPE,
        ISNULL((SELECT DESIGN_MAIN_ROW_ID FROM EZGI_DESIGN_MAIN_ROW WHERE DESIGN_MAIN_RELATED_ID = EZGI_VIRTUAL_OFFER_ROW.STOCK_ID AND DESIGN_MAIN_STATUS =1 AND MAIN_PROTOTIP_TYPE = 1),0) AS DESIGN_MAIN_ROW_ID,
        ISNULL((SELECT MEASURE_ID FROM EZGI_DESIGN_MAIN_ROW WHERE DESIGN_MAIN_RELATED_ID = EZGI_VIRTUAL_OFFER_ROW.STOCK_ID AND DESIGN_MAIN_STATUS =1 AND MAIN_PROTOTIP_TYPE = 1),0) AS MEASURE_ID,
        ISNULL(PRICE,0) PRICE_,
        ISNULL(OTHER_MONEY,'#session.ep.money#') OTHER_MONEY_,
        ISNULL(PURCHASE_PRICE,0) PURCHASE_PRICE_,
        ISNULL(PURCHASE_PRICE_MONEY,'#session.ep.money#') PURCHASE_PRICE_MONEY_,
        ISNULL(COST_PRICE,0) COST_PRICE_,
        ISNULL(COST_PRICE_MONEY,'#session.ep.money#') COST_PRICE_MONEY_,
        (SELECT VIRTUAL_OFFER_STAGE FROM EZGI_VIRTUAL_OFFER WHERE VIRTUAL_OFFER_ID = EZGI_VIRTUAL_OFFER_ROW.VIRTUAL_OFFER_ID) AS VIRTUAL_OFFER_STAGE,
        ISNULL(P_PURCHASE_PRICE,0) P_PURCHASE_PRICE_, 
        ISNULL(P_PURCHASE_PRICE_MONEY,'#session.ep.money#') AS P_PURCHASE_PRICE_MONEY_, 
        ISNULL(P_DISCOUNT_1,0) P_DISCOUNT_1, 
        ISNULL(P_DISCOUNT_2,0) P_DISCOUNT_2, 
        ISNULL(P_DISCOUNT_3,0) P_DISCOUNT_3, 
        ISNULL(P_DISCOUNT_4,0) P_DISCOUNT_4, 
        ISNULL(P_DISCOUNT_5,0) P_DISCOUNT_5
	FROM         
   		EZGI_VIRTUAL_OFFER_ROW
	WHERE        
    	EZGI_ID = #attributes.ezgi_id#
</cfquery>  
<cfquery name="get_row" datasource="#dsn3#">
	SELECT 
		*,
		1 AS PIECE_ROW_PROTOTIP_ID,
		AMOUNT AS PIECE_AMOUNT,
		PRODUCT_NAME AS PIECE_NAME,
		'#session.ep.money#' as PRIVATE_PRICE_MONEY
	FROM 
		EZGI_VIRTUAL_OFFER_ROW_DETAIL 
	WHERE 
		EZGI_ID = #attributes.ezgi_id# 
	ORDER BY 
		VIRTUAL_OFFER_ROW_DETAIL_ID
</cfquery>
<cfquery name="get_import" datasource="#dsn3#">
	SELECT * FROM EZGI_VIRTUAL_OFFER_ROW_IMPORT_FILE WHERE EZGI_ID = #attributes.ezgi_id# AND FILE_TYPE_ID = 2
</cfquery>
<cfquery name="GET_PROCESS_TYPE" datasource="#DSN#">
	SELECT        
    	PT.PROCESS_ID
	FROM            
    	PROCESS_TYPE AS PT INNER JOIN
      	PROCESS_TYPE_ROWS AS PTR ON PT.PROCESS_ID = PTR.PROCESS_ID INNER JOIN
      	PROCESS_TYPE_ROWS_POSID AS PTRP ON PTR.PROCESS_ROW_ID = PTRP.PROCESS_ROW_ID
	WHERE        
    	PT.FACTION LIKE N'%prod.upd_ezgi_virtual_offer%' AND 
        PT.IS_ACTIVE = 1 AND 
        PTRP.PRO_POSITION_ID = #session.ep.POSITION_CODE# AND 
        PTR.PROCESS_ROW_ID = #get_product.VIRTUAL_OFFER_STAGE#
</cfquery>
<cfif get_product.MAIN_PROTOTIP_TYPE eq 1>
	<cfif get_product.MEASURE_ID>
		<cfinclude template="add_ezgi_spect_standart.cfm"> <!---Kapı Konfigürasyon Sayfasına Gidiyor--->
    <cfelse>
    	<script type="text/javascript">
			alert("Ölçü Seçimi Bulunamadı!");
			window.close()
		</script>
		<cfabort>
    </cfif>
<cfelse>
	<cfinclude template="add_ezgi_spect_file_import.cfm"><!--- Mutfak Aktarım Sayfasına Gidiyor--->
</cfif>
<cfif Listfind(session.ep.POWER_USER_LEVEL_ID,56)> <!---Maliyet Power User ise--->
    <cf_popup_box title=" Fiyat Detayları">
        <cfform name="price_update" method="post" action="#request.self#?fuseaction=prod.emptypopup_upd_ezgi_virtual_offer_row_spect_aktar&ezgi_id=#attributes.ezgi_id#&price_upd=1">
            <table style="width:100%; height:20px">
                <tr>
                    <td style="width:100%; height:40px">
                        <cf_medium_list>
                            <cfoutput>
                                <thead>
                                    <tr>
                                        <th style="text-align:center">#getLang('product',30)#</th>
                                        <th style="width:50px; text-align:center"><cf_get_lang_main no='265.Döviz'></th>
                                        <th style="width:60px; text-align:center">#getLang('invoice',124)#</th>
                                        <th style="width:60px; text-align:center">#getLang('invoice',125)#</th>
                                        <th style="width:60px; text-align:center">#getLang('invoice',135)#</th>
                                        <th style="width:150px; text-align:center">#getLang('product',30)#</th>
                                        <!---<th style="width:50px; text-align:center"><cf_get_lang_main no='265.Döviz'></th>--->
                                        <th style="width:150px; text-align:center">#getLang('product',806)#</th>
                                        <th style="width:50px; text-align:center"><cf_get_lang_main no='265.Döviz'></th>
                                        <th style="width:50px; text-align:center">#getLang('product',31)#</th>
                                        <th style="width:40px; text-align:center"><cf_get_lang_main no='265.Döviz'></th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td style="text-align:right">
                                            <input type="text" name="p_purchase_price_" id="p_purchase_price_" value="#TlFormat(get_product.P_PURCHASE_PRICE_,2)#" style="width:150px; text-align:right" onChange="hesapla_bayi_alis()" />
                                        </td>
                                        <td>
                                            <select name="p_purchase_price_money_" id="p_purchase_price_money_" style=" width:50px; height:20px">
                                                <cfloop query="get_money">
                                                    <option value="#MONEY#" <cfif MONEY eq get_product.P_PURCHASE_PRICE_MONEY_>selected</cfif>>#MONEY#</option>
                                                </cfloop>
                                            </select>
                                        </td>
                                        <td><input type="text" name="p_discount_1_" id="p_discount_1_" value="#TlFormat(get_product.P_DISCOUNT_1,2)#" style="width:60px; text-align:right" onChange="hesapla_bayi_alis()"/></td>
                                        <td><input type="text" name="p_discount_2_" id="p_discount_2_" value="#TlFormat(get_product.P_DISCOUNT_2,2)#" style="width:60px; text-align:right" onChange="hesapla_bayi_alis()"/></td>
                                        <td><input type="text" name="p_discount_3_" id="p_discount_3_" value="#TlFormat(get_product.P_DISCOUNT_3,2)#" style="width:60px; text-align:right" onChange="hesapla_bayi_alis()"/></td>
                                        <td style="text-align:right">
                                            <input type="text" name="purchase_price_" id="purchase_price_" value="#TlFormat(get_product.PURCHASE_PRICE_,2)#" style="width:150px; text-align:right" readonly />
                                        </td>
                                        <!---<td>
                                            <select name="purchase_price_money_" id="purchase_price_money_" style=" width:50px; height:20px">
                                                <cfloop query="get_money">
                                                    <option value="#MONEY#" <cfif MONEY eq get_product.PURCHASE_PRICE_MONEY_>selected</cfif>>#MONEY#</option>
                                                </cfloop>
                                            </select>
                                        </td>--->
                                        <td style="text-align:right">
                                            <input type="text" name="cost_price_" id="cost_price_" value="#TlFormat(get_product.COST_PRICE_,2)#" style="width:150px; text-align:right" />
                                        </td>
                                        <td>
                                            <select name="cost_price_money_" id="cost_price_money_" style=" width:50px; height:20px">
                                                <cfloop query="get_money">
                                                    <option value="#MONEY#" <cfif MONEY eq get_product.COST_PRICE_MONEY_>selected</cfif>>#MONEY#</option>
                                                </cfloop>
                                            </select>
                                        </td>
                                        <td style="text-align:right; font-weight:bold">#TlFormat(get_product.PRICE_,2)#</td>
                                        <td style="text-align:left; font-weight:bold">#get_product.OTHER_MONEY_#</td>
                                    </tr>
                                </tbody>
                                <tfoot>
                                	<tr>
                                        <td style="text-align:right" colspan="10">
                                            <input type="submit" value=" Fiyat Güncelle " style="width:100px" name="fiyat_guncelle">
                                        </td>
                                    </tr>
                                </tfoot>
                            </cfoutput>
                        </cf_medium_list>
                    </td>
                </tr>
            </table>
        </cfform>
    </cf_popup_box>
    <cf_popup_box title="Kayıt Bilgisi">
    <cfif get_product.MAIN_PROTOTIP_TYPE eq 1>
    	<cf_record_info query_name="get_row">
  	<cfelse>
    	<cf_record_info query_name="get_row"><br /><cf_record_info query_name="get_import">
    </cfif>
    </cf_popup_box>
</cfif>
<script language="javascript">
	function hesapla_bayi_alis()
	{
		
		document.getElementById('purchase_price_').value = commaSplit(parseFloat(filterNum(document.getElementById('p_purchase_price_').value,2)) - (parseFloat(filterNum(document.getElementById('p_purchase_price_').value,2))*parseFloat(filterNum(document.getElementById('p_discount_1_').value,2))/100),2);
		
		document.getElementById('purchase_price_').value = commaSplit(parseFloat(filterNum(document.getElementById('purchase_price_').value,2)) - (parseFloat(filterNum(document.getElementById('purchase_price_').value,2))*parseFloat(filterNum(document.getElementById('p_discount_2_').value,2))/100),2);
		
		document.getElementById('purchase_price_').value = commaSplit(parseFloat(filterNum(document.getElementById('purchase_price_').value,2)) - (parseFloat(filterNum(document.getElementById('purchase_price_').value,2))*parseFloat(filterNum(document.getElementById('p_discount_3_').value,2))/100),2);

	}
</script>