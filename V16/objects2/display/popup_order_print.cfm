<cfif not isdefined("attributes.print")>
<table width="100%" border="0" cellspacing="0" cellpadding="0" height="35" align="center">
  <tr class="color-list">
    <td class="headbold">&nbsp;<cf_get_lang no='364.Ürünü Özelleştir'>: <cfoutput>#get_product_name(product_id:attributes.pid)#</cfoutput></td>
	<td  style="text-align:right;">
		<a href="javascript://" onClick="<cfoutput>windowopen('#request.self#?fuseaction=objects2.popup_order_print&print=true#page_code#','page')</cfoutput>"><img src="/images/print.gif" title="Gönder" border="0"></a>
  	</td>
  </tr>
</table>
</cfif>
<br/>
<cfinclude template="../../objects/display/view_company_logo.cfm">
<br/>
<table cellpadding="0" cellspacing="0" width="700" align="center">
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
      <table width="700" border="0" align="center">
        <tr height="22">
          <td class="txtbold"><cf_get_lang_main no='152.Ürünler'></td>
          <td class="txtbold" width="50"><cf_get_lang_main no='223.Miktar'></td>
          <td width="100"  class="txtbold" style="text-align:right;"><cf_get_lang_main no='226.Birim Fiyat'></td>
          <td width="150"  class="txtbold" style="text-align:right;"><cf_get_lang_main no='672.Fiyat'></td>
		</tr>
		  <cfscript>
			  total_price = 0;
			  total_price_kdvli = 0;
			  total_price_stdmoney = 0;
			  total_price_kdvli_stdmoney = 0;
		  </cfscript>
            <tr height="20">
			<cfoutput>
              <td>#attributes.main_product_name#</td>
			  <td>#attributes.main_amount#</td>
			  <td  style="text-align:right;">#TLFormat(attributes.total_amount)#</td>
			  <td  style="text-align:right;">#TLFormat(attributes.total_amount*attributes.main_amount)# #attributes.money_type#</td>
			</tr>
			<cfloop from="1" to="#attributes.record_num#" index="i">
				<cfif listlen(evaluate('attributes.product_id#i#')) eq 7>
				<cfscript>
					product_name=listgetat(evaluate('attributes.product_id#i#'),3,',');
					amount=evaluate('attributes.amount#i#');
					price=listgetat(evaluate('attributes.product_id#i#'),4,',');
					if(not len(amount))amount=0;
					total_price=amount*price;
					money_type=listgetat(evaluate('attributes.product_id#i#'),7,',');
				</cfscript>
				<cfif amount neq 0>
				<tr>

					<td>#product_name#</td>
					<td>#amount#</td>
					<td  style="text-align:right;">#TLFormat(price)#</td>
					<td  style="text-align:right;">#TLFormat(total_price)# #money_type#</td>
				</tr>
				</cfif>
				</cfif>
			</cfloop>
		</cfoutput>
		 </table>
<br/>
<table cellpadding="0" cellspacing="0" width="700" align="center">
	<tr>
		<td>
		<table style="text-align:right;">
			  <cfoutput>
				<tr height="20">
					<td class="formbold"><cf_get_lang_main no='80.TOPLAM'></td>
					<td style="text-align:right;" width="125">#attributes.TOTAL_PRICE_STDMONEY# #session_base.money#</td>
				</tr>
				<tr height="20">
					<td class="formbold"><cf_get_lang no='137.TOPLAM KDV li'></td>
					<td style="text-align:right;">#attributes.TOTAL_PRICE_KDVLI_STDMONEY# #session_base.money#</td>
				</tr>
				<tr height="20">
					<td class="formbold"><cf_get_lang_main no='80.TOPLAM'> #session_base.money2#</td>
					<td style="text-align:right;">#attributes.TOTAL_PRICE_STDMONEY_OTHER# #session_base.money2#</td>
				</tr>
				<tr height="20">
					<td class="formbold"><cf_get_lang no='137.TOPLAM KDV li'> #session_base.money2#</td>
					<td style="text-align:right;">#attributes.TOTAL_PRICE_KDVLI_STDMONEY_OTHER# #session_base.money2#</td>
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
