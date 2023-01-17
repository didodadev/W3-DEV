<!--- popup_list_sales_offer_rows--->
<cf_get_lang_set module_name="purchase"><!--- sayfanin en altinda kapanisi var --->
<cfquery name="GET_OFFER_ROWS" datasource="#DSN3#">
	SELECT
		P.PRODUCT_NAME,
		S.PROPERTY,
		OHR.*
	FROM
		OFFER_ROW_HISTORY OHR,
		PRODUCT P,
		STOCKS S
	WHERE
		 OHR.OFFER_ID=#attributes.offer_id#	
	AND 
		OHR.PRODUCT_ID=P.PRODUCT_ID
	AND
		OHR.STOCK_ID=S.STOCK_ID
	ORDER BY 
		OHR.STOCK_ID,
		OHR.OFFER_ROW_ID
</cfquery>

<cfset stock_id_list = ''>
<cfset stock_id_count = ''>
<cfoutput query="GET_OFFER_ROWS">
	<cfif not listfindnocase(stock_id_list,stock_id)>
		<cfset stock_id_list = listappend(stock_id_list,stock_id)>
		<cfset stock_id_count = listappend(stock_id_count,1)>
	<cfelse>
		<cfset sira_ = listfindnocase(stock_id_list,stock_id)>
		<cfset sayi_ = listgetat(stock_id_count,sira_) + 1>
		<cfset stock_id_count = listsetat(stock_id_count,sira_,sayi_)>
	</cfif>
</cfoutput>
<cf_medium_list>
    <thead>
        <tr> 
            <th><cf_get_lang dictionary_id ='57657.Ürün'></th>
            <th><cf_get_lang dictionary_id ='38709.İlk Miktar'></th>
            <th><cf_get_lang dictionary_id ='38710.Son Miktar'></th>		  
            <th><cf_get_lang dictionary_id ='38711.İlk Fiyat'> <cfoutput>#session.ep.money#</cfoutput></th>		  
            <th><cf_get_lang dictionary_id ='38712.Son Fiyat'> <cfoutput>#session.ep.money#</cfoutput></th>
            <th><cf_get_lang dictionary_id ='38713.İlk Fiyat Döviz'></th>					  
            <th><cf_get_lang dictionary_id ='38714.Son Fiyat Döviz'></th>
            <th>% <cf_get_lang dictionary_id ='58016.Değişim'></th>
        </tr>
    </thead>
    <tbody>
		<cfif GET_OFFER_ROWS.recordcount>
            <cfoutput query="GET_OFFER_ROWS"> 
                <cfif currentrow eq 1 or stock_id neq GET_OFFER_ROWS.stock_id[currentrow-1]>				
                    <cfset stock_count_ = listgetat(stock_id_count,listfindnocase(stock_id_list,stock_id))>
                    <tr>
                        <td>#PRODUCT_NAME# #PROPERTY#</td>
                        <td>#quantity# #unit#</td>
                        <td><cfif stock_count_ gt 1>#GET_OFFER_ROWS.quantity[currentrow+stock_count_-1]# #GET_OFFER_ROWS.unit[currentrow+stock_count_-1]#</cfif></td>
                        <td style="text-align:right;">#TLFormat(PRICE)# #session.ep.money#</td>
                        <td style="text-align:right;"><cfif stock_count_ gt 1>#TLFormat(GET_OFFER_ROWS.PRICE[currentrow+stock_count_-1])# #session.ep.money#</cfif></td>
                        <td style="text-align:right;">#TLFormat(PRICE_OTHER)# #OTHER_MONEY#</td>
                        <td style="text-align:right;"><cfif stock_count_ gt 1>#TLFormat(GET_OFFER_ROWS.PRICE_OTHER[currentrow+stock_count_-1])# #GET_OFFER_ROWS.OTHER_MONEY[currentrow+stock_count_-1]#</cfif></td>
                        <td style="text-align:right;"><cfif stock_count_ gt 1>% #(GET_OFFER_ROWS.quantity[currentrow+stock_count_-1]*100)/quantity#</cfif></td>
                    </tr>
                </cfif>
            </cfoutput> 
        <cfelse>
            <tr> 
                <td colspan="10" class="label" ><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>
            </tr>
        </cfif>
    </tbody>
</cf_medium_list>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
