<cfinclude template="../query/get_rival_price_list.cfm">
<cf_big_list_search title="Günlük Rakip Fiyatlar : #get_product_name(product_id:attributes.pid)#"> </cf_big_list_search>       
<table class="big_list">
    <thead>
        <tr> 
			<th width="35"><cf_get_lang_main no='1165.Sira'></th>
            <th><cf_get_lang_main no='1367.Rakip'></th>
            <th><cfoutput>#market_name#</cfoutput> Fiyat</th>
            <th>Ort. Fiyat</th>
            <th><cf_get_lang_main no='672.Fiyat'></th>
            <th>İnd. <cf_get_lang_main no='672.Fiyat'></th>
            <th width="65">Fiy. Alım Tr.</th>
            <th width="65">Baş. Tr.</th>
            <th width="65">Bit. Tr.</th>
            <th>Fiyat Tipi</th>
        </tr>
    </thead>
    <tbody>
		<cfif get_daily_rival_prices.recordcount>
			<cfoutput query="get_daily_rival_prices"> 
               <tr> 
			   		<td width="35">#currentrow#</td>
                    <td>#rival_name#</td>
                    <td align="right" style="text-align:right;">#TLFormat(get_fiy.price_kdv)#</td>
                    <td align="right" style="text-align:right;"><cfif get_ort.recordcount and len(get_ort.PRICE)>#TLFormat(get_ort.PRICE,4)#</cfif></td>
                    <td align="right" style="text-align:right;"><cfif len(PRICE)>#TLFormat(PRICE)#</cfif></td>
                    <td align="right" style="text-align:right;"><cfif len(PRICE_2)>#TLFormat(PRICE_2)#</cfif></td>
                    <td>#dateformat(RECORD_DATE,'dd/mm/yyyy')#</td>
                    <td>#dateformat(STARTDATE,'dd/mm/yyyy')#</td>
                    <td>#dateformat(FINISHDATE,'dd/mm/yyyy')#</td>
                    <td>#PRICE_TYPE_NAME#</td>
                  </tr>
          	  </cfoutput>
        <cfelse>
			<tr> 
				<td colspan="10"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</td>
			</tr>
        </cfif>
    <tbody>
</table>
<br />
<hr />
<cf_big_list_search title="Geçmiş Rakip Fiyatlar : #get_product_name(product_id:attributes.pid)#"> </cf_big_list_search>       
<table class="big_list">
    <thead>
        <tr> 
			<th width="35"><cf_get_lang_main no='1165.Sira'></th>
            <th><cf_get_lang_main no='1367.Rakip'></th>
            <th><cfoutput>#market_name#</cfoutput> Fiyat</th>
            <th>Ort. Fiyat</th>
            <th><cf_get_lang_main no='672.Fiyat'></th>
            <th>İnd. <cf_get_lang_main no='672.Fiyat'></th>
            <th width="65">Fiy. Alım Tr.</th>
            <th width="65">Baş. Tr.</th>
            <th width="65">Bit. Tr.</th>
            <th>Fiyat Tipi</th>
        </tr>
    </thead>
    <tbody>
		<cfif get_rival_prices.recordcount>
			<cfoutput query="get_rival_prices"> 
               <tr> 
			   		<td width="35">#currentrow#</td>
                    <td>#rival_name#</td>
                    <td align="right" style="text-align:right;">#TLFormat(get_fiy.price_kdv)#</td>
                    <td align="right" style="text-align:right;"><cfif get_ort.recordcount and len(get_ort.PRICE)>#TLFormat(get_ort.PRICE,4)#</cfif></td>
                    <td align="right" style="text-align:right;"><cfif len(PRICE)>#TLFormat(PRICE)#</cfif></td>
                    <td align="right" style="text-align:right;"><cfif len(PRICE_2)>#TLFormat(PRICE_2)#</cfif></td>
                    <td>#dateformat(RECORD_DATE,'dd/mm/yyyy')#</td>
                    <td>#dateformat(STARTDATE,'dd/mm/yyyy')#</td>
                    <td>#dateformat(FINISHDATE,'dd/mm/yyyy')#</td>
                    <td>#PRICE_TYPE_NAME#</td>
                  </tr>
          	  </cfoutput>
        <cfelse>
			<tr> 
				<td colspan="10"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</td>
			</tr>
        </cfif>
    <tbody>
</table