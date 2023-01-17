<style type="text/css">
.th {
	background-color: #999999;
	border: 1px solid #999999;
}
.thc {
	background-color: #FFFFFF;
	border: 1px solid #999999;
}
.textbox {
	background-color: #FFFFFF;
	border: 0px none #FFFFFF;
}
.butonbeyaz {
	background-color: #999999;
	border: 1px solid #FFFFFF;
	color: #FFFFFF;
}
</style>
<cfparam name="attributes._miktar" default="1">
<cfset iid = attributes.virtual_offer_row_id>

<cfset satir_ilk = 1>
<cfset satir_son = 30>

<cfset toplam = 0>
<cfset maliyet_toplam = 0>
<cfquery name="get_money" datasource="#dsn#">
	SELECT MONEY, RATE2 FROM SETUP_MONEY WHERE PERIOD_ID = #session.ep.period_id# AND (MONEY_STATUS = 1)
</cfquery> 
<cfoutput query="get_money">
	<cfset 'RATE2_#MONEY#' = RATE2>
</cfoutput>
<cfquery name="get_product" datasource="#dsn3#">
	SELECT  
    	EZGI_ID,      
    	VIRTUAL_OFFER_ROW_ID, 
        PRODUCT_TYPE, 
        PRODUCT_ID, 
        STOCK_ID, 
        STOCK_CODE,
       	BOY, 
      	EN, 
       	DERINLIK, 
        PRODUCT_CODE_2, 
        PRODUCT_NAME,
        ISNULL((SELECT IS_PROTOTYPE FROM STOCKS WHERE STOCK_ID = EZGI_VIRTUAL_OFFER_ROW.STOCK_ID),0) AS IS_PROTOTIP,
        ISNULL((SELECT MAIN_PROTOTIP_TYPE FROM EZGI_DESIGN_MAIN_ROW WHERE DESIGN_MAIN_RELATED_ID = EZGI_VIRTUAL_OFFER_ROW.STOCK_ID AND MAIN_PROTOTIP_ID IS NULL),0) AS MAIN_PROTOTIP_TYPE
	FROM            
   		EZGI_VIRTUAL_OFFER_ROW
	WHERE        
    	VIRTUAL_OFFER_ROW_ID = #attributes.virtual_offer_row_id#
</cfquery>  
<cfquery name="get_row" datasource="#dsn3#">
	<cfif get_product.IS_PROTOTIP>
    	<cfif get_product.MAIN_PROTOTIP_TYPE eq 1> <!---Kapı İse--->
        	SELECT 
                PRODUCT_CODE,
                PRODUCT_NAME,
                PURCHASE_PRICE,
                PURCHASE_PRICE_MONEY,
                COST_PRICE,
                COST_PRICE_MONEY,
                MAIN_UNIT,
                LAST_AMOUNT AMOUNT
            FROM 
                EZGI_VIRTUAL_OFFER_ROW_DETAIL 
            WHERE 
                EZGI_ID = #get_product.EZGI_ID#
        <cfelse>
            SELECT 
                PRODUCT_CODE,
                PRODUCT_NAME,
                PURCHASE_PRICE,
                PURCHASE_PRICE_MONEY,
                COST_PRICE,
                COST_PRICE_MONEY,
                MAIN_UNIT,
                AMOUNT
            FROM 
                EZGI_VIRTUAL_OFFER_ROW_DETAIL 
            WHERE 
                EZGI_ID = #get_product.EZGI_ID#
      	</cfif>
 	<cfelse>
        SELECT 
            STOCK_CODE PRODUCT_CODE,
            PRODUCT_NAME,
            PURCHASE_PRICE,
            PURCHASE_PRICE_MONEY,
            COST_PRICE,
            COST_PRICE_MONEY,
            UNIT MAIN_UNIT,
            QUANTITY AMOUNT
        FROM 
            EZGI_VIRTUAL_OFFER_ROW
        WHERE 
            EZGI_ID = #get_product.EZGI_ID#	
  	</cfif>
</cfquery> 
<cfset sayfa_sayisi = ceiling(get_row.recordcount / satir_son)>  
<cfif sayfa_sayisi eq 0>
	<cfset sayfa_sayisi = 1>
</cfif>
<cfloop from="1" to="#sayfa_sayisi#" index="j">
  <table border="0" bordercolor="black" cellpadding="1" cellspacing="0" style="width:280mm;height:180mm;">
    <tr>
	  <td rowspan="4" style="width:5mm;">
	  </td>
	  <td style="height:0mm;">
	  </td>
	  <td rowspan="3" style="width:0mm;">
	  </td>
	</tr>
    <tr>
	  <td>
        <table border="1" bordercolor="black" cellpadding="1" cellspacing="0" style="width:273mm;height:175mm;">
		  <tr>
		  	<td colspan="12"  style="height:3mm">&nbsp;</td>
		  </tr>
		  <tr>
          	<td align="left" valign="middle" height="14" class="th" colspan="<cfif Listfind(session.ep.POWER_USER_LEVEL_ID,56)>9<cfelse>5</cfif>"><cfoutput><strong><font size="2">&nbsp;#get_product.STOCK_CODE# - &nbsp;#get_product.PRODUCT_NAME# Tasarım Maliyet Listesi</font></strong></cfoutput></td>
			<td align="right" valign="middle" class="th" colspan="3"><cfoutput><strong>&nbsp;&nbsp;</strong></cfoutput></td>
		  </tr>
		  <tr> 
			<td rowspan="2" class="thc" width="20" style="text-align:center"><strong><cf_get_lang_main no='75.No'></strong></td>
            <td rowspan="2" class="thc" width="120" style="text-align:center"><strong><cf_get_lang_main no='106.Stok Kodu'></strong></td>
			<td rowspan="2" class="thc" style="text-align:center"><strong><cf_get_lang_main no='809.Ürün Adı'></strong></td>
			<td rowspan="2" class="thc" width="100" style="text-align:center"><strong><cf_get_lang_main no='223.Miktar'></strong></td>
            <td colspan="4" height="10px" class="thc" width="40" style="text-align:center"><strong><cfoutput>#getLang('objects',136)#</cfoutput></strong></td>
            <cfif Listfind(session.ep.POWER_USER_LEVEL_ID,56)>
            	<td colspan="4" class="thc" width="40" style="text-align:center"><strong><cfoutput>#getLang('product',806)#</cfoutput></strong></td>
            </cfif>
       	</tr>
        <tr>
			<td class="thc" width="70" height="10px" style="text-align:center"><strong><cf_get_lang_main no='672.Fiyat'></strong></td>
            <td class="thc" width="40" style="text-align:center"><strong><cf_get_lang_main no='265.Döviz'></strong></td>
            <td class="thc" width="70" style="text-align:center"><strong><cf_get_lang_main no='261.Tutar'></strong></td>
            <td class="thc" width="40" style="text-align:center"><strong><cf_get_lang_main no='265.Döviz'></strong></td>
            <cfif Listfind(session.ep.POWER_USER_LEVEL_ID,56)>
            	<td class="thc" width="70" style="text-align:center"><strong><cf_get_lang_main no='672.Fiyat'></strong></td>
                <td class="thc" width="40" style="text-align:center"><strong><cf_get_lang_main no='265.Döviz'></strong></td>
                <td class="thc" width="70" style="text-align:center"><strong><cf_get_lang_main no='261.Tutar'></strong></td>
                <td class="thc" width="40" style="text-align:center"><strong><cf_get_lang_main no='265.Döviz'></strong></td>
            </cfif>
         </tr>
		<cfif get_row.recordcount>        
        <cfloop query="get_row" startrow="#satir_ilk#" endrow="#satir_son#">
            <cfoutput>
                  <tr> 
                    <td class="thc" height="15px" style="text-align:center">#currentrow#&nbsp;</td>
                    <td class="thc" >&nbsp;#get_row.PRODUCT_CODE#</td>
                    <td class="thc">&nbsp;#get_row.PRODUCT_NAME#</td>
                    <td class="thc"  style="text-align:right">#TlFormat(get_row.AMOUNT,2)# &nbsp;#Left(get_row.MAIN_UNIT,2)#</td>
                    <td class="thc"  style="text-align:right">#TlFormat(get_row.PURCHASE_PRICE,2)#</td>
                    <td class="thc" >&nbsp;#get_row.PURCHASE_PRICE_MONEY#</td>
                    <td class="thc"  style="text-align:right">
                    	<cfif isdefined('RATE2_#get_row.PURCHASE_PRICE_MONEY#')>
                          	#TlFormat(PURCHASE_PRICE*AMOUNT*Evaluate('RATE2_#get_row.PURCHASE_PRICE_MONEY#'),2)#
                          	<cfset toplam = toplam+(PURCHASE_PRICE*AMOUNT*Evaluate('RATE2_#get_row.PURCHASE_PRICE_MONEY#'))>
                      	<cfelse>
                          	#TlFormat(0,2)#
                      	</cfif>
                    </td>
                    <td class="thc" >&nbsp;#session.ep.money#</td>
                    <cfif Listfind(session.ep.POWER_USER_LEVEL_ID,56)>
                        <td class="thc"  style="text-align:right">#TlFormat(get_row.COST_PRICE,2)#</td>
                        <td class="thc" >&nbsp;#get_row.COST_PRICE_MONEY#</td>
                        <td class="thc"  style="text-align:right">
                            <cfif isdefined('RATE2_#get_row.COST_PRICE_MONEY#')>
                                #TlFormat(COST_PRICE*AMOUNT*Evaluate('RATE2_#get_row.COST_PRICE_MONEY#'),2)#
                                <cfset maliyet_toplam = maliyet_toplam+(COST_PRICE*AMOUNT*Evaluate('RATE2_#get_row.COST_PRICE_MONEY#'))>
                            <cfelse>
                                #TlFormat(0,2)#
                            </cfif>
                        </td>
                        <td class="thc" >&nbsp;#session.ep.money#</td>
                    </cfif>
              	</tr>
            </cfoutput>
        </cfloop>
        
        <cfelse>
        		<tr>
                	<td  colspan="12">Listelenecek Kayıt Bulunamadı.</td>
                </tr>
        </cfif>
        <tr>
        	<td colspan="12" >&nbsp;</td>
        </tr>
         <tr>
		  	<td class="thc" colspan="6" align="left" valign="middle" height="10">&nbsp;&nbsp;
            	<cfif j eq sayfa_sayisi> 
            		<strong>Genel Toplam</strong>
               	<cfelse>
                	<strong>Sayfa Toplam</strong>
                </cfif>     
            </td>
            <td class="thc" valign="middle" style="text-align:right"><strong><cfoutput>#TlFormat(TOPLAM,2)#</cfoutput></strong></td>
            <td class="thc" align="left" valign="middle" ><strong><cfoutput>&nbsp;#session.ep.money#</cfoutput></strong></td>
            <cfif Listfind(session.ep.POWER_USER_LEVEL_ID,56)>
            	<td colspan="2"></td>
            	<td class="thc" valign="middle" style="text-align:right"><strong><cfoutput>#TlFormat(MALIYET_TOPLAM,2)#</cfoutput></strong></td>
            	<td class="thc" align="left" valign="middle" ><strong><cfoutput>&nbsp;#session.ep.money#</cfoutput></strong></td>
            </cfif>
		</tr>  
		</table>  	    
	  </td>
	</tr>
    <tr>
	  	<td style="height:10mm;"></td>
	</tr>
  </table>
  <cfif sayfa_sayisi neq j>
    <div style="page-break-after:always"></div>
  </cfif>
  <cfset satir_ilk = satir_ilk + 30>
  <cfset satir_son = satir_son + 30>
</cfloop>
