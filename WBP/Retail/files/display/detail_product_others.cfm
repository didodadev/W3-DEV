<cfset bugun_ = createodbcdatetime(createdate(year(now()),month(now()),day(now())))>
<cfif isdefined("attributes.search_startdate") and isdate(attributes.search_startdate)>
	<cf_date tarih = "attributes.search_startdate">
<cfelse>
	<cfset attributes.search_startdate = dateadd("m",-3,now())>
</cfif>
<cfif isdefined("attributes.search_finishdate") and isdate(attributes.search_finishdate)>
	<cf_date tarih = "attributes.search_finishdate">
<cfelse>
	<cfset attributes.search_finishdate = now()>
</cfif>

<cfquery name="get_products" datasource="#dsn_dev#">
	SELECT
    	EPTR.SUB_TYPE_NAME,
        EPTR.SUB_TYPE_ID
    FROM
    	#DSN1_ALIAS#.PRODUCT P1,
        EXTRA_PRODUCT_TYPES_ROWS EPTR
    WHERE
    	EPTR.PRODUCT_ID = P1.PRODUCT_ID AND
        EPTR.TYPE_ID = 10 AND
        P1.PRODUCT_ID = #attributes.pid#
</cfquery>
<cfif get_products.recordcount and len(get_products.SUB_TYPE_ID) and len(get_products.SUB_TYPE_NAME)>
	<cfquery name="get_related_products" datasource="#dsn_dev#">
    	SELECT DISTINCT
            (SELECT TOP 1 ETR.SUB_TYPE_NAME FROM EXTRA_PRODUCT_TYPES_ROWS ETR WHERE P1.PRODUCT_ID = ETR.PRODUCT_ID AND ETR.TYPE_ID = #ambalaj_type_id#) AS SUB_TYPE_NAME,
            
            PT_SATIS.PRICE_TYPE AS OZEL_PRICE_TYPE,
            PT_SATIS.ROW_ID AS OZEL_PRICE_ROW_ID,           
        
            P1.PRODUCT_NAME,
            P1.PRODUCT_CODE,
            P1.PRODUCT_ID,
            
            ISNULL((SELECT SUM(PRODUCT_STOCK) FROM #DSN2_ALIAS#.GET_STOCK_PRODUCT WHERE P1.PRODUCT_ID = GET_STOCK_PRODUCT.PRODUCT_ID AND GET_STOCK_PRODUCT.DEPARTMENT_ID = #merkez_depo_id#),0) AS DEPO_STOCK,
        	ISNULL((SELECT SUM(PRODUCT_STOCK) FROM #DSN2_ALIAS#.GET_STOCK_PRODUCT WHERE P1.PRODUCT_ID = GET_STOCK_PRODUCT.PRODUCT_ID AND GET_STOCK_PRODUCT.DEPARTMENT_ID <> #merkez_depo_id#),0) AS MAGAZA_STOK,
            
            PS1.PRICE PRICE_STANDART,
            PS1.PRICE_KDV PRICE_STANDART_KDV,
            PS2.PRICE STANDART_SALE_PRICE,
            PS2.PRICE_KDV AS STANDART_SALE_PRICE_KDV,
    
            PT_ALIS.NEW_ALIS OZEL_FIYAT_ALIS,
            PT_ALIS.NEW_ALIS_KDV OZEL_FIYAT_ALIS_KDV,
            
            PT_SATIS.NEW_PRICE OZEL_FIYAT_SATIS,
            PT_SATIS.NEW_PRICE_KDV OZEL_FIYAT_SATIS_KDV,
            PT_SATIS.MARGIN SATIS_KAR,
            
            ISNULL((
        	SELECT	
                SUM(ORR.QUANTITY)
            FROM
                #dsn3_alias#.ORDERS O INNER JOIN
                #dsn3_alias#.ORDER_ROW ORR ON ORR.ORDER_ID = O.ORDER_ID
            WHERE
                O.PURCHASE_SALES = 0 AND
                ORR.ORDER_ROW_CURRENCY NOT IN (-3,-10) AND
                ORR.PRODUCT_ID = P1.PRODUCT_ID AND
                O.ORDER_DATE BETWEEN #dateadd('d',-1 * 15,now())# AND #now()#
        	),0) PURCHASE_ORDER_QUANTITY
        FROM
            #DSN1_ALIAS#.PRICE_STANDART PS1,
            #DSN1_ALIAS#.PRICE_STANDART PS2,
            EXTRA_PRODUCT_TYPES_ROWS EPTR,
            #DSN1_ALIAS#.PRODUCT P1
            	LEFT JOIN PRICE_TABLE AS PT_ALIS ON 
                (
                    PT_ALIS.IS_ACTIVE_P = 1 AND 
                    P1.PRODUCT_ID = PT_ALIS.PRODUCT_ID AND 
                    PT_ALIS.P_STARTDATE <= #bugun_# AND 
                    PT_ALIS.P_FINISHDATE >= #bugun_# AND 
                    PT_ALIS.ROW_ID = (SELECT TOP 1 PT_IC.ROW_ID FROM PRICE_TABLE AS PT_IC WHERE P1.PRODUCT_ID = PT_IC.PRODUCT_ID AND PT_IC.P_STARTDATE <= #bugun_# AND PT_IC.P_FINISHDATE >= #bugun_# AND PT_IC.IS_ACTIVE_P = 1 ORDER BY PT_IC.NEW_ALIS ASC)
                )
            	LEFT JOIN PRICE_TABLE AS PT_SATIS ON 
                (
                    PT_SATIS.IS_ACTIVE_S = 1 AND 
                    P1.PRODUCT_ID = PT_SATIS.PRODUCT_ID AND 
                    PT_SATIS.STARTDATE <= #bugun_# AND 
                    PT_SATIS.FINISHDATE >= #bugun_# AND 
                    PT_SATIS.ROW_ID = (SELECT TOP 1 PT_IC2.ROW_ID FROM PRICE_TABLE AS PT_IC2 WHERE P1.PRODUCT_ID = PT_IC2.PRODUCT_ID AND PT_IC2.STARTDATE <= #bugun_# AND PT_IC2.FINISHDATE >= #bugun_# AND PT_IC2.IS_ACTIVE_S = 1  ORDER BY PT_IC2.NEW_PRICE ASC)
                ) 
        WHERE
            P1.PRODUCT_STATUS = 1 AND
            PS2.PRODUCT_ID = P1.PRODUCT_ID AND
            PS2.PRICESTANDART_STATUS = 1 AND
        	PS2.PURCHASESALES = 1 AND
            PS1.PRICESTANDART_STATUS = 1 AND
            PS1.PRODUCT_ID = P1.PRODUCT_ID AND
            PS1.PURCHASESALES = 0 AND
            EPTR.PRODUCT_ID = P1.PRODUCT_ID AND
            EPTR.TYPE_ID = 10 AND
            EPTR.SUB_TYPE_ID = #get_products.SUB_TYPE_ID#
        ORDER BY
        	P1.PRODUCT_CODE,
            P1.PRODUCT_NAME,
            SUB_TYPE_NAME
    </cfquery>
<cfelse>
	<cfset get_related_products.recordcount = 0>
</cfif>

<table>
<tr>
<td>
<cf_medium_list>
	<thead>
    	<tr style="background-color:#000000;">
        	<th nowrap="nowrap">
            	<input type="button" value="Liste" onclick="gonder_muadil('<cfoutput>#get_related_products.recordcount#</cfoutput>');"/>
            	<input type="button" value="T" onclick="sec_muadil('<cfoutput>#get_related_products.recordcount#</cfoutput>');"/>
            </th>
            <th>Ürün Kodu</th>
            <th>Ürün Adı</th>
            <th style="text-align:right;">KDVsiz Alış</th>
            <th style="text-align:right;">KDVli Alış</th>
            <th style="text-align:right;">Satış</th>
            <th style="text-align:right;">Satış Kar</th>
            <th style="text-align:right;">Depo Stok</th>
            <th style="text-align:right;">Genel Stok</th>
            <th style="text-align:right;">Sipariş Bakiye</th>
            <th style="text-align:right;">Ortalama Satış</th>
            <th style="text-align:right;">Stok Gün</th>
        </tr>
    </thead>
    <tbody>
    <cfif get_related_products.recordcount>
		<cfoutput query="get_related_products">
            <cfif len(OZEL_PRICE_TYPE)>
				<cfset price_style = "color:red;">
                <cfset PRICE_CONTROL = -1 * OZEL_PRICE_ROW_ID>
                
                <cfquery name="get_active_price" datasource="#dsn_dev#">
                    SELECT
                        *,
                        (SELECT PT.TYPE_NAME FROM PRICE_TYPES PT WHERE PT.TYPE_ID = PRICE_TABLE.PRICE_TYPE) AS FIYAT_TIPI
                    FROM
                        PRICE_TABLE
                    WHERE
                        ROW_ID = #OZEL_PRICE_ROW_ID#
                </cfquery>
                
                <cfquery name="get_next_price" datasource="#dsn_dev#">
                    SELECT 
                        *,
                        (SELECT PT.TYPE_NAME FROM PRICE_TYPES PT WHERE PT.TYPE_ID = PT1.PRICE_TYPE) AS FIYAT_TIPI
                    FROM
                        PRICE_TABLE PT1
                    WHERE
                        PT1.PRODUCT_ID = #get_active_price.PRODUCT_ID# AND
                        PT1.ROW_ID <> #OZEL_PRICE_ROW_ID# AND
                        PT1.FINISHDATE > #createodbcdatetime(get_active_price.FINISHDATE)# AND
                        PT1.IS_ACTIVE_S = #get_active_price.IS_ACTIVE_S#
                </cfquery>
            </cfif>
            <tr>
                <td <cfif attributes.pid eq product_id>style="background-color:##ADFF2F;"</cfif>>
                	<input type="checkbox" name="s_product_id_#currentrow#" id="s_product_id_#currentrow#" value="#product_id#"/>
                </td>
                <td <cfif attributes.pid eq product_id>style="background-color:##ADFF2F;"</cfif>>
                	#listlast(PRODUCT_CODE,'.')#
                </td>
                <td style="background-color:<cfif attributes.pid eq product_id>##ADFF2F;<cfelse>##FAF0E6;</cfif>">
                	<a href="#request.self#?fuseaction=product.form_upd_product&pid=#product_id#" class="tableyazi" target="p_window">#PRODUCT_NAME#</a>
                </td>
                <td style="background-color:<cfif attributes.pid eq product_id>##ADFF2F;<cfelse>##EEE8AA;</cfif>text-align:right;"><cfif len(OZEL_FIYAT_ALIS)>#tlformat(OZEL_FIYAT_ALIS)#<cfelse>#tlformat(PRICE_STANDART)#</cfif></td>
                <td style="background-color:<cfif attributes.pid eq product_id>##ADFF2F;<cfelse>##EEE8AA;</cfif>text-align:right;"><cfif len(OZEL_FIYAT_ALIS_KDV)>#tlformat(OZEL_FIYAT_ALIS_KDV)#<cfelse>#tlformat(PRICE_STANDART_KDV)#</cfif></td>
                <td style="background-color:<cfif attributes.pid eq product_id>##ADFF2F;<cfelse>##F0E68C;</cfif>text-align:right;" nowrap>
                	<cfif len(OZEL_PRICE_TYPE) and get_next_price.recordcount>
                    	<img src="/images/fiyatlar.gif" />
                    </cfif>
                    <a href="javascript://" onclick="$('##f_detail_#product_id#').toggle();" class="tableyazi"><cfif len(OZEL_FIYAT_SATIS_KDV)>#tlformat(OZEL_FIYAT_SATIS_KDV)#<cfelse>#tlformat(STANDART_SALE_PRICE_KDV)#</cfif></a>
               	</td>
                <td style="text-align:right;<cfif attributes.pid eq product_id>background-color:##ADFF2F;</cfif>">#tlformat(SATIS_KAR)#</td>
                <td style="background-color:<cfif attributes.pid eq product_id>##ADFF2F;<cfelse>##AFEEEE;</cfif>text-align:right;">#tlformat(DEPO_STOCK)#</td>
                <td style="background-color:<cfif attributes.pid eq product_id>##ADFF2F;<cfelse>##AFEEEE;</cfif>text-align:right;" id="stock_#product_id#"><a href="javascript://" onclick="get_stock_list('#product_id#','product');" class="tableyazi" target="p_window">#tlformat(DEPO_STOCK + MAGAZA_STOK)#</a></td>
                <td style="text-align:right;<cfif attributes.pid eq product_id>background-color:##ADFF2F;</cfif>">#tlformat(PURCHASE_ORDER_QUANTITY)#</td>
                <td style="background-color:<cfif attributes.pid eq product_id>##ADFF2F;<cfelse>##FFA07A;</cfif>text-align:right;"><div id="ort_#product_id#"></div></td>
                <td style="background-color:<cfif attributes.pid eq product_id>##ADFF2F;<cfelse>##FFA07A;</cfif>text-align:right;" id="ortalama2_#product_id#"></td>
            </tr>
            <tr id="f_detail_#product_id#" style="display:none;">
            	<td colspan="12">
                	<cfif len(OZEL_PRICE_TYPE)>
						<cfset price_style = "color:red;">
                        <cfset PRICE_CONTROL = -1 * OZEL_PRICE_ROW_ID>
                        <cfset product_info = "">
                        <cfset product_info = "#product_info#<b>Geçerli Fiyat</b><br><br><table border='1' cellpadding='4' cellspacing='0'>">
                        <cfset product_info = "#product_info#<tr><td height='30'>&nbsp;<i>Fiyat Tipi</i>&nbsp;</td><td>&nbsp;<i>Alış Tarih</i>&nbsp;</td><td>&nbsp;<i>Satış Tarih</i>&nbsp;</td><td>&nbsp;<i>Alış H.</i>&nbsp;</td><td>&nbsp;<i>Satış H.</i>&nbsp;</td></tr>">
                        <cfset product_info = "#product_info#<tr><td height='25'>&nbsp;#get_active_price.FIYAT_TIPI#&nbsp;</td><td>&nbsp;#dateformat(get_active_price.P_STARTDATE,'dd/mm/yyyy')#-#dateformat(get_active_price.P_FINISHDATE,'dd/mm/yyyy')#&nbsp;</td><td>&nbsp;#dateformat(get_active_price.STARTDATE,'dd/mm/yyyy')#-#dateformat(get_active_price.FINISHDATE,'dd/mm/yyyy')#&nbsp;</td><td>&nbsp;<i>#tlformat(get_active_price.new_alis)#</i>&nbsp;</td><td>&nbsp;<i>#tlformat(get_active_price.new_price)#</i>&nbsp;</td></tr>">
                        <cfset product_info = "#product_info#</table>">
                        <cfif get_next_price.recordcount>
                            <cfset PRICE_CONTROL = get_next_price.ROW_ID>
                            <cfset product_info = "#product_info#<br><br><b>Sonraki Fiyat</b><br><br><table border='1' cellpadding='4' cellspacing='0'>">
                            <cfset product_info = "#product_info#<tr><td height='30'>&nbsp;<i>Fiyat Tipi</i>&nbsp;</td><td>&nbsp;<i>Alış Tarih</i>&nbsp;</td><td>&nbsp;<i>Satış Tarih</i>&nbsp;</td><td>&nbsp;<i>Alış H.</i>&nbsp;</td><td>&nbsp;<i>Satış H.</i>&nbsp;</td></tr>">
                            <cfset product_info = "#product_info#<tr><td height='25'>&nbsp;#get_next_price.FIYAT_TIPI#&nbsp;</td><td>&nbsp;#dateformat(get_next_price.P_STARTDATE,'dd/mm/yyyy')#-#dateformat(get_next_price.P_FINISHDATE,'dd/mm/yyyy')#&nbsp;</td><td>&nbsp;#dateformat(get_next_price.STARTDATE,'dd/mm/yyyy')#-#dateformat(get_next_price.FINISHDATE,'dd/mm/yyyy')#&nbsp;</td><td>&nbsp;<i>#tlformat(get_next_price.new_alis)#</i>&nbsp;</td><td>&nbsp;<i>#tlformat(get_next_price.new_price)#</i>&nbsp;</td></tr>">
                            <cfset product_info = "#product_info#</table>">
                        </cfif>
                    <cfelse>
                        <cfset price_style = "color:##000;">
                        <cfset PRICE_CONTROL = 0>
                        <cfset product_info = "Fiyatlandırma Bulunamadı!">
                    </cfif>
                    #product_info#
                </td>
            </tr>
        </cfoutput>
    </cfif>
    </tbody>
</cf_medium_list>
</td>
</tr>
</table>
<cfif get_related_products.recordcount>
<script>
	$(document).ready(function()
	{
		<cfoutput query="get_related_products">
			AjaxPageLoad('index.cfm?fuseaction=retail.emptypopup_get_product_sales&product_id=#product_id#','ort_#product_id#');
			AjaxPageLoad('index.cfm?fuseaction=retail.emptypopup_get_product_sales2&product_id=#product_id#','ortalama2_#product_id#');
		</cfoutput>	
	});
</script>
</cfif>