<table border="0" width="98%" cellpadding="0" cellspacing="0" align="center">
	<tr>
		<td height="35" class="headbold">Toplu Barkod Dosyası Oluştur</td>
		<td align="right">
			<a href="javascript://" onClick="alert('Kaydedilecek!');"><img src="/images/save.gif" title="<cf_get_lang no ='1559.Etiket Dosyasını Kaydet'>" style="cursor:pointer;" align="absbottom"></a>
		</td> 
	</tr>
</table>
<table width="98%" cellpadding="2" cellspacing="1" border="0" class="color-border" align="center">	
	<tr>
		<td class="color-row">
		<table>
			<cfform name="add_order" method="post" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_add_barcode_file" enctype="multipart/form-data">  
				<!--- <input type="hidden" name="kur_say" value="<cfoutput>#get_money_bskt.recordcount#</cfoutput>">
				<cfoutput query="get_money_bskt">
					<input type="hidden" name="hidden_rd_money_#currentrow#" value="#money_type#">
					<input type="hidden" name="txt_rate1_#currentrow#" value="#rate1#">
					<input type="hidden" name="txt_rate2_#currentrow#" value="#rate2#">
					<cfif money_type is 'USD'>
						<input type="hidden" name="basket_money" value="USD">
						<input type="hidden" name="basket_rate1" value="#rate1#">
						<input type="hidden" name="basket_rate2" value="#rate2#">
					</cfif>
				</cfoutput> --->
				<!--- <tr>
					<td height="20">Fiyat Listesi</td>
					<td>
						<select name="price_cat_id" onChange="sil_bastan();" style="width:150px;">
							<cfoutput query="get_price_cat">
								<option value="#price_catid#">#price_cat#</option>
							</cfoutput>
						</select>					
					</td>
				</tr> --->				
				<!--- <input type="hidden" name="order_date" id="order_date" value="<cfoutput>#dateformat(now(),'dd/mm/yyyy')#</cfoutput>" maxlength="10">
				<tr>
							<td width="100">Fiyat Listeleri</td>
							<td width="220">
								<select name="price_catid" style="width:150px;">
									<option value="-2">Standart Satış</option>
									<cfoutput query="get_price_cat"> 
										<option value="#price_catid#" <cfif isdefined("attributes.price_catid") and (price_catid eq attributes.price_catid)>selected</cfif>>#price_cat#</option>
									</cfoutput>
								</select>
							</td>
				</tr> --->
				<tr>
					<td width="70">Barkod</td>
					<td>
						<div id="show_prod_dsp">
							<input type="text" name="search_product" id="search_product" style="width:130px;" <cfif session.pda.Use_onKeyDown_Enter>onKeyDown<cfelse>onChange</cfif>="<cfif session.pda.Use_onKeyDown_Enter>if(event.keyCode == 13)</cfif> {return add_barcode2(document.getElementById('row_count').value,add_order.search_product.value);}">
							<a href="javascript://" onClick="add_barcode2(document.getElementById('row_count').value,add_order.search_product.value);"><img src="/images/plus_list.gif" border="0" align="absmiddle"></a>
							<input type="hidden" name="row_count" id="row_count" value="0">
						</div>												
					</td>
				</tr>
				<tr>
					<td colspan="2">
						<div id="mydiv">
							<cfloop from="1" to="200" index="no">
								<cfoutput>
								<div id="n_my_div#no#" style="display:none"><input  type="hidden" value="0" name="row_kontrol#no#" id="row_kontrol#no#"><a href="javascript://" onclick="sil(#no#);"><img  src="images/delete_list.gif" border="0"></a><input type="text" style="width:150px;" name="barcode#no#" id="barcode#no#" value=""><input style="width:30px;" type="text" name="amount#no#" id="amount#no#" value="1" class="moneybox" onKeyUp="FormatCurrency(this,0);" <cfif session.pda.Use_onKeyDown_Enter>onKeyDown<cfelse>onChange</cfif>="<cfif session.pda.Use_onKeyDown_Enter>if(event.keyCode == 13)</cfif> clear_barcode();"><!--- <input type="hidden" value="" name="sid#no#"> ---></div><!---  onBlur="stock_reserve(#no#)" --->
								</cfoutput>
							</cfloop>
						</div>
					</td>
				</tr>
				<!--- <tr>
					<td colspan="2" align="center">
						<input type="button" value="Hesapla" onClick="calc_ship_dispatch();">
					</td>
				</tr>	 --->
				<!--- <tr>
					<td colspan="2">						
						<div id="show_buttons" style="display:none">
							<table cellpadding="0" cellspacing="1" border="0" width="98%">
								<tr>
									<td><cf_get_lang_main no='80.Toplam'>Tutar (YTL)</td>
									<td>T. Adet</td>
									<td>T. Çeşit</td>
								</tr>
								<tr>
									<td>
										<input type="hidden" name="nettotal_usd" id="nettotal_usd" value="0" readonly="yes" class="moneybox" style="width:80px;"> <!--- USD --->
										<input type="text" name="nettotal" id="nettotal" value="0" readonly="yes" class="moneybox" style="width:100px;"> <!--- YTL --->
										<input type="hidden" name="sa_discount" id="sa_discount" value="0"><!---  onChange="FormatCurrency(this);toplam_hesapla();" class="moneybox"  style="width:80px;" --->
										<input type="hidden" name="basket_net_total_usd" id="basket_net_total_usd" value="0"><!---  readonly="yes" class="moneybox" style="width:80px;" --->
										<input type="hidden" name="basket_net_total" id="basket_net_total" value="0" > <!--- readonly="yes" class="moneybox" style="width:80px;" --->
									</td>
									<td>
										<input type="text" name="net_adet" id="net_adet" value="" readonly="yes" class="moneybox" style="width:60px;">
									</td>
									<td>
										<input type="text" name="net_cesit" id="net_cesit" value="" readonly="yes" class="moneybox" style="width:60px;">
									</td>
								</tr>
								<tr>
									<td align="center" colspan="3">
										<input type="button" value="Kaydet" onClick="control_inputs();">
									</td>
								</tr>	
							</table>
						</div>
					</td>
				</tr> --->	
				<!--- </div>	 --->	
			</cfform>
		</table>
		</td>
	</tr>
</table>
<br/>
<!--- <form name="form_calc_order" method="post" action="<cfoutput>#request.self#</cfoutput>?fuseaction=pda.emptypopup_calc_purchase_div">  
	<input type="hidden" name="basket_products" id="basket_products" value="">
	<input type="hidden" name="basket_products_amount" id="basket_products_amount" value="">
	<input type="hidden" name="price_list_id" id="price_list_id" value="">
	<input type="hidden" name="price_date" id="price_date" value="">
	<cfoutput query="get_money_bskt">
		<input type="hidden" name="txt_rate1_#money_type#" value="#rate1#">
		<input type="hidden" name="txt_rate2_#money_type#" value="#rate2#">
	</cfoutput>
	<input type="hidden" name="basket_money" value="USD">
</form>

<div id="calc_order_div" style="display:none"></div>
 --->
<cfinclude template="basket_js_functions_label_print.cfm">
