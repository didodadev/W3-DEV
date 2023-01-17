<!--- urun detay partnerdan istenen fiyat degisiklikleri --->
<cfinclude template="../query/get_offer_price.cfm">
<cfif get_price_offer.recordcount>
   <br/>
	<table cellspacing="0" cellpadding="0" width="98%"  border="0">
	  <cfform name="upd_price_offer" method="post" action="#request.self#?fuseaction=product.upd_price_product_offer">
		<tr class="color-border">
		  <td>
			<table cellspacing="1" cellpadding="2" width="100%" border="0">
			  <tr class="color-header" >
				<td colspan="2" height="22">
				  <table width="100%" cellpadding="0" cellspacing="0" border="0">
					<tr class="color-header" >
					  <td class="form-title"><cf_get_lang dictionary_id='37097.Yeni Fiyat Teklifi'>dddd</td>
					</tr>
				  </table>
				</td>
			  </tr>
			  <tr height="20" class="color-row">
				<td colspan="2">
				<cfoutput>
					#GET_PRICE_OFFER.NICKNAME# - #GET_PRICE_OFFER.COMPANY_PARTNER_NAME#&nbsp;#GET_PRICE_OFFER.COMPANY_PARTNER_SURNAME# (#dateformat(date_add('h',session.ep.time_zone,GET_PRICE_OFFER.RECORD_DATE),dateformat_style)#-#timeformat(date_add('h',session.ep.time_zone,GET_PRICE_OFFER.RECORD_DATE),timeformat_style)#)
				</cfoutput>
				</td>
			  </tr>
			  <tr height="20" class="color-row">
				<td class="txtbold"><cf_get_lang dictionary_id='37098.Alış Teklif Fiyatı'></td>
				<td>
				<input type="text" name="purchase_price" id="purchase_price" value="<cfoutput>#GET_PRICE_OFFER.PRICE_STANDART_PURCHASE#</cfoutput>" style="width:70px;">
				  <select name="money_purchase" id="money_purchase" style="width:40px;">
					<cfoutput query="get_money">
					  <option value="#get_money.money#" <cfif get_money.money is GET_PRICE_OFFER.MONEY_PURCHASE>selected</cfif> >#get_money.money#</option>
					</cfoutput>
				  </select>
				</td>
			  </tr>
			  <tr height="20" class="color-row">
				<td class="txtbold" width="100"><cf_get_lang dictionary_id='37099.Satış Teklif Fiyatı'></td>
				<td>
				  <input type="text" name="sales_price" id="sales_price" value="<cfoutput>#GET_PRICE_OFFER.PRICE_STANDART_SALES#</cfoutput>" style="width:70px;">
					<select name="money_sales" id="money_sales" style="width:40px;">
					  <cfoutput query="get_money">
						<option value="#get_money.money#" <cfif get_money.money is GET_PRICE_OFFER.MONEY_SALES>selected</cfif> >#get_money.money#</option>
					  </cfoutput>
					</select>
				</td></tr>
			  <tr height="20" class="color-row">
				<td class="txtbold"><cf_get_lang dictionary_id='57500.Onay'>/<cf_get_lang dictionary_id='29537.Red'></td>
				<td>
				<cfoutput>
				  <input type="hidden" name="price_offer_id" id="price_offer_id" value="#GET_PRICE_OFFER.ID#">
				  <input type="hidden" name="pid" id="pid" value="#url.pid#">
				  <input type="hidden" name="UNIT_ID" id="UNIT_ID" value="#get_product.product_unit_id#">
				  <input type="image" src="/images/valid.gif" alt="<cf_get_lang dictionary_id='58475.Onayla'>" border="0">
				  <input type="image" src="/images/refusal.gif" alt="<cf_get_lang dictionary_id='58461.Reddet'>" border="0">
				 </cfoutput>
				</td>
			  </tr>
			</table>
		  </td>
		</tr>
	  </cfform>
	</table>
</cfif>
