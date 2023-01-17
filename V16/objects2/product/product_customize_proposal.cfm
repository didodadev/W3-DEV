<cfinclude template="../query/get_product_custom.cfm">

<cfif not isdefined("attributes.print")>
    <table border="0" cellspacing="0" cellpadding="0" height="35" align="center" style="width:100%; height:35px;">
      	<tr class="color-list">
        	<td class="headbold">&nbsp;<cf_get_lang no='364.Ürünü Özelleştir'>: <cfoutput>#get_product_name(product_id:attributes.pid)#</cfoutput></td>
    		<td  style="text-align:right;">
        		<a href="javascript://" onClick="<cfoutput>windowopen('#request.self#?fuseaction=objects2.popup_product_customize_proposal&print=true#page_code#','page')</cfoutput>"><img src="/images/print.gif" title="<cf_get_lang_main no='1331.Gönder'>" border="0"></a>
        	</td>
      	</tr>
    </table>
</cfif>
<br/>
<cfinclude template="../../objects/display/view_company_logo.cfm">
<br/>
<table cellpadding="0" cellspacing="0" align="center" style="width:700px;">
	<tr>
		<td  class="txtbold" style="text-align:right;"><cfoutput>#dateformat(now(),'dd/mm/yyyy')#</cfoutput></td>
	</tr>
	<tr>
		<td>
			<cfoutput>#get_product_name(product_id:attributes.pid)#</cfoutput> <cf_get_lang no='365.ürünü ile ilgili olarak aşağıda belirtilen değişikliklerin yapılarak hazırlanacak olan yeni sistemi ile ilgili teklif'>...
		</td>
	</tr>
</table>
<br/>
<table border="0" align="center" style="width:700px;">
	<tr style="height:22px;">
  		<td class="txtbold" style="width:150px;"><cf_get_lang no='139.Bileşenler'></td>
  		<td class="txtbold"><cf_get_lang_main no='152.Ürünler'></td>
  		<td class="txtbold" style="width:50px;"><cf_get_lang_main no='223.Miktar'></td>
  		<td  class="txtbold" style="text-align:right; width:100px;"><cf_get_lang_main no='226.Birim Fiyat'></td>
  		<td  class="txtbold" style="text-align:right; width:150px;"><cf_get_lang_main no='672.Fiyat'></td>
	</tr>
  	<cfscript>
      	total_price = 0;
      	total_price_kdvli = 0;
      	total_price_stdmoney = 0;
      	total_price_kdvli_stdmoney = 0;
  	</cfscript>
  	<cfoutput query="get_product_cat_custom_property">
    	<cfset pcatid_prop = get_product_cat_custom_property.product_cat_id_prop>
    	<cfset pcat_curr_row = get_product_cat_custom_property.currentrow>
    	<tr style="height:20px;">
      		<td class="txtbold">#product_cat#</td>
      		<cfinclude template="../query/get_pcat_products_custom.cfm">	
      		<td>
                <cfloop query="get_pcat_products">
                    <cfif isDefined('attributes.pcat_products_#pcat_curr_row#') and evaluate('attributes.pcat_products_#pcat_curr_row#') is stock_id>
                    #product_name# <cfif property is '-'><cfelseif len(property) gt 1>#property#</cfif>
                    </cfif>
                </cfloop>	
      		</td>
          	<td>
				<cfif isNumeric(amount)>
                    <cfloop from="1" to="#amount#" index="amount_index">
                        <cfif isDefined('attributes.pcat_products_amount_#pcat_curr_row#') and evaluate('attributes.pcat_products_amount_#pcat_curr_row#') is amount_index>
                        #amount_index#
                        </cfif>
                    </cfloop>	
                <cfelse>
                	1
                </cfif>
          	</td>
     		<td  style="text-align:right;">
        		#evaluate('attributes.unit_price_#pcat_curr_row#')#
        		#evaluate('attributes.unit_price_money_#pcat_curr_row#')#
      		</td>
      		<td  style="text-align:right;">
        		#evaluate('attributes.price_#pcat_curr_row#')#
        		#evaluate('attributes.price_money_#pcat_curr_row#')#
      		</td>
    	</tr>
  	</cfoutput>
</table>
<br/>
<table cellpadding="0" cellspacing="0" align="center" style="width:700px;">
	<tr>
		<td>
			<table style="text-align:right;">
			  	<cfoutput>
                    <tr style="height:20px;">
                        <td class="formbold"><cf_get_lang_main no='80.Toplam'></td>
                        <td style="text-align:right;" width="125">#attributes.total_price# #attributes.total_price_money#</td>
                    </tr>
                    <tr style="height:20px;">
                        <td class="formbold"><cf_get_lang no='137.Toplam KDV li'></td>
                        <td style="text-align:right;">#attributes.total_price_kdvli# #attributes.total_price_kdvli_money#</td>
                    </tr>
                    <tr style="height:20px;">
                        <td class="formbold"><cf_get_lang_main no='80.Toplam'> (#get_stdmoney.money#)</td>
                        <td style="text-align:right;">#attributes.total_price_stdmoney# #get_stdmoney.money#</td>
                    </tr>
                    <tr style="height:20px;">
                        <td class="formbold"><cf_get_lang no='137.Toplam KDV li'>(#get_stdmoney.money#)</td>
                        <td style="text-align:right;">#attributes.total_price_kdvli_stdmoney# #get_stdmoney.money#</td>
                    </tr>
			  	</cfoutput>
      		</table>
		</td>
	</tr>
</table>
<br/>
<cfinclude template="../../objects/display/view_company_info.cfm">
<br/>
<cfif isdefined("attributes.print")>
	<script type="text/javascript">
		function waitfor()
		{
		  	window.close();
		}
		setTimeout("waitfor()",3000);
		window.print();
	</script>
</cfif>
