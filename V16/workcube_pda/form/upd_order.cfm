<cfscript>session_basket_kur_ekle(process_type:1,table_type_id:3,action_id:attributes.order_id);</cfscript> 
<cfquery name="GET_ORDER_DETAIL" datasource="#DSN3#" blockfactor="1">
	SELECT 
		ORDERS.COMPANY_ID,
		ORDERS.ORDER_NUMBER,
		ORDERS.PARTNER_ID,
		ORDERS.ORDER_ZONE,
		ORDERS.ORDER_HEAD,
		ORDERS.ORDER_DATE,
		ORDERS.SHIP_DATE,
		ORDERS.PAYMETHOD,
		ORDERS.CARD_PAYMETHOD_ID,
		ORDERS.ORDER_DETAIL,
		ORDERS.OTHER_MONEY_VALUE,
		ORDERS.NETTOTAL,
		ORDER_ROW.STOCK_ID,
		ORDER_ROW.PRODUCT_ID,
		ORDER_ROW.QUANTITY,
		ORDER_ROW.PRICE_CAT,
		ORDER_ROW.ORDER_ROW_ID,
		SB.BARCODE
	FROM 
		ORDERS,
		ORDER_ROW,
		STOCKS_BARCODES SB
	WHERE 
		ORDERS.ORDER_ID = ORDER_ROW.ORDER_ID AND
		SB.STOCK_ID = ORDER_ROW.STOCK_ID AND
		ORDERS.ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.order_id#"> AND
		ORDERS.PURCHASE_SALES = 1 AND 
		ORDERS.ORDER_ZONE = 0
</cfquery>
<cfquery name="GET_PRICE_CAT" datasource="#DSN3#">
	SELECT PRICE_CATID, PRICE_CAT FROM PRICE_CAT
</cfquery>
<table border="0" cellpadding="0" cellspacing="0" align="center" style="width:98%">
	<tr style="height:35px;">
		<td class="headbold"><cf_get_lang_main no='199.siparis'>: <cfoutput>#get_order_detail.order_number#</cfoutput></td>
	</tr>
</table>
<table cellpadding="2" cellspacing="1" border="0" class="color-border" align="center" style="width:98%">	
	<tr>
		<td class="color-row">
			<table align="center" style="width:99%">
				<cfform name="add_order" method="post" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_upd_order" enctype="multipart/form-data">  
					<input type="hidden" name="kur_say" id="kur_say" value="<cfoutput>#get_money_bskt.recordcount#</cfoutput>">
					<cfoutput query="get_money_bskt">
						<input type="hidden" name="hidden_rd_money_#currentrow#" id="hidden_rd_money_#currentrow#" value="#money_type#">
						<input type="hidden" name="txt_rate1_#currentrow#" id="txt_rate1_#currentrow#" value="#rate1#">
						<input type="hidden" name="txt_rate2_#currentrow#" id="txt_rate2_#currentrow#" value="#rate2#">
						<cfif money_type is 'USD'>
							<input type="hidden" name="basket_money" id="basket_money" value="USD">
							<input type="hidden" name="basket_rate1" id="basket_rate1" value="#rate1#">
							<input type="hidden" name="basket_rate2" id="basket_rate2" value="#rate2#">
						</cfif>
					</cfoutput>
						
					<cfif len(get_order_detail.company_id)>
						<input type="hidden" name="member_type" id="member_type" value="partner">
						<input type="hidden" name="member_id" id="member_id" value="<cfoutput>#get_order_detail.partner_id#</cfoutput>">
						<input type="hidden" name="company_id" id="company_id" value="<cfoutput>#get_order_detail.company_id#</cfoutput>">			
						<cfif len(get_order_detail.partner_id)>
							<cfset member_name = get_par_info(get_order_detail.partner_id,0,-1,0)>
						<cfelse>
							<cfset member_name = "" >
						</cfif>
						<cfset company_name = get_par_info(get_order_detail.company_id,1,0,0)>
					</cfif>
					<input type="hidden" name="member_name" id="member_name" value="<cfoutput>#company_name#-#member_name#</cfoutput>">
					<input type="hidden" name="order_id" id="order_id" value="<cfoutput>#attributes.order_id#</cfoutput>">
					<input type="hidden" name="order_zone" id="order_zone" value="<cfif get_order_detail.order_zone>psv<cfelse>sa</cfif>">							  
					<input type="hidden" name="order_head" id="order_head" value="<cfoutput>#get_order_detail.order_head#</cfoutput>">
					<tr>
						<td>Müşteri </td>
						<td><cfoutput>#company_name# - #member_name#</cfoutput></td>
					</tr>
					<tr>
						<td>Fiyat Listesi</td>
						<td><cfset order_price_cat_id = get_order_detail.price_cat>
							<select name="price_cat_id" id="price_cat_id" onChange="sil_bastan();" style="width:200px;">
								<cfoutput query="get_price_cat">
									<option value="#price_catid#" <cfif order_price_cat_id is price_catid>selected</cfif>>#price_cat#</option>
								</cfoutput>
							</select>					
						</td>
					</tr>				
					<input type="hidden" name="order_date" id="order_date" value="<cfoutput>#dateformat(get_order_detail.order_date,'dd/mm/yyyy')#</cfoutput>" maxlength="10">
					<tr>
						<td>Sevk Tarihi</td>
						<td>
							<cfinput type="text" name="ship_date" id="ship_date" value="#dateformat(get_order_detail.ship_date,'dd/mm/yyyy')#"  validate="eurodate" maxlength="10" style="width:80px;">
							<cf_wrk_date_image date_field="ship_date">
						</td>
					</tr>
					<tr>
						<td>Ödeme Yöntemi</td>
						<td>
							<cfif len(get_order_detail.paymethod)>
								<cfquery name="GET_PAYMETHOD" datasource="#DSN#">
									SELECT PAYMENT_VEHICLE, PAYMETHOD FROM SETUP_PAYMETHOD WHERE PAYMETHOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_order_detail.paymethod#">
								</cfquery>
								<input type="hidden" name="card_paymethod_id" id="card_paymethod_id" value="">
								<input type="hidden" name="commission_rate" id="commission_rate" value="">
								<cfoutput>
									<input type="hidden" name="paymethod_vehicle" id="paymethod_vehicle" value="#get_paymethod.payment_vehicle#"> <!--- sadece taksitli fiatı hesaplarken kullanılıyor, order_row'da tutulmuyor --->
									<input type="hidden" name="paymethod_id" id="paymethod_id"value="#get_order_detail.paymethod#">
									<input type="text" name="paymethod" id="paymethod" value="#get_paymethod.paymethod#" style="width:162px;">
								</cfoutput>
							<cfelseif len(get_order_detail.card_paymethod_id)>
								<cfquery name="GET_CARD_PAYMETHOD" datasource="#DSN3#">
									SELECT 
										CARD_NO
										<cfif get_order_detail.commethod_id eq 6> <!--- WW den gelen siparişlerin guncellemesi --->
											,PUBLIC_COMMISSION_MULTIPLIER AS COMMISSION_MULTIPLIER
										<cfelse>  <!--- EP VE PP den gelen siparişlerin guncellemesi --->
											,COMMISSION_MULTIPLIER 
										</cfif>
									FROM 
										CREDITCARD_PAYMENT_TYPE 
									WHERE 
										PAYMENT_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_order_detail.card_paymethod_id#">
								</cfquery>
								<cfoutput>
									<input type="hidden" name="paymethod_vehicle" id="paymethod_vehicle" value="-1"> 
									<input type="hidden" name="card_paymethod_id" id="card_paymethod_id" value="#get_order_detail.card_paymethod_id#">
									<input type="hidden" name="commission_rate" id="commission_rate" value="#get_card_paymethod.commission_multiplier#">
									<input type="hidden" name="paymethod_id" id="paymethod_id" value="">
									<input type="text" name="paymethod" id="paymethod" value="#get_card_paymethod.card_no#" style="width:162px;">
								</cfoutput>
							<cfelse>
								<input type="hidden" name="paymethod_vehicle" id="paymethod_vehicle" value="">
								<input type="hidden" name="card_paymethod_id" id="card_paymethod_id" value="">
								<input type="hidden" name="commission_rate" id="commission_rate" value="">
								<input type="hidden" name="paymethod_id" id="paymethod_id" value="">
								<input type="text" name="paymethod" id="paymethod" value="" style="width:162px;">
							</cfif>
							<a href="javascript://" onClick="get_paymethod_div();"><img src="/images/plus_list.gif" border="0" align="absmiddle" class="form_icon"></a>
						</td>
					</tr>
					<tr><td colspan="2"><div id="paymethod_div"></div></td></tr>
					<tr>
						<td>Açıklama</td>
						<td>
							<textarea name="order_detail" id="order_detail" style="width:194px;height:60px;"><cfoutput>#get_order_detail.order_detail#</cfoutput></textarea>						
						</td>
					</tr>
					<tr>
						<td>Barkod</td>
						<td>
							<div id="show_prod_dsp">
								<input type="text" name="search_product" id="search_product" style="width:162px;" <cfif session.pda.Use_onKeyDown_Enter>onKeyDown<cfelse>onChange</cfif>="<cfif session.pda.Use_onKeyDown_Enter>if(event.keyCode == 13)</cfif> {return add_barcode2(document.getElementById('row_count').value,add_order.search_product.value);}">
								<a href="javascript://" onClick="add_barcode2(document.getElementById('row_count').value,add_order.search_product.value);"><img src="/images/plus_list.gif" border="0" align="absmiddle" class="form_icon"></a>
								<input type="hidden" name="row_count" id="row_count" value="<cfoutput>#get_order_detail.recordcount#</cfoutput>">
							</div>												
						</td>
					</tr>
					<tr>
						<td colspan="2">
							<div id="mydiv">
								<cfloop from="1" to="200" index="no">
									<cfif no lte get_order_detail.recordcount>
										<cfoutput>
											<div id="n_my_div#no#">
												<input  type="hidden" value="1" name="row_kontrol#no#" id="row_kontrol#no#">
												<a href="javascript://" onclick="sil_rezerv_upd(#no#,#get_order_detail.quantity[no]#,#get_order_detail.stock_id[no]#,#get_order_detail.product_id[no]#);sil(#no#);"><img  src="images/delete_list.gif" border="0"></a>
												<input type="text" name="barcode#no#" id="barcode#no#" value="#get_order_detail.barcode[no]#" style="width:150px;">
												<input type="text" name="amount#no#" id="amount#no#" value="#get_order_detail.quantity[no]#" class="moneybox" onKeyUp="FormatCurrency(this,0);" style="width:30px;" <cfif session.pda.Use_onKeyDown_Enter>onKeyDown<cfelse>onChange</cfif>="<cfif session.pda.Use_onKeyDown_Enter>if(event.keyCode == 13)</cfif> clear_barcode();" onBlur="stock_reserve_upd(#no#,#get_order_detail.quantity[no]#,#get_order_detail.stock_id[no]#,#get_order_detail.product_id[no]#)">
												<input type="hidden" name="sid#no#" id="sid#no#" value="">
												<input type="hidden" name="action_row_id#no#" id="action_row_id#no#" value="#get_order_detail.order_row_id[no]#">
											</div>
										</cfoutput>
									<cfelse>
										<cfoutput>
											<div id="n_my_div#no#" style="display:none">
												<input type="hidden" name="row_kontrol#no#" id="row_kontrol#no#" value="0">
												<a href="javascript://" onclick="sil_rezerv(#no#);sil(#no#);"><img  src="images/delete_list.gif" border="0"></a>
												<input type="text" name="barcode#no#" id="barcode#no#" value="" style="width:150px;">
												<input type="text" name="amount#no#" id="amount#no#" value="1" class="moneybox" onKeyUp="FormatCurrency(this,0);" style="width:30px;" <cfif session.pda.use_onkeydown_enter>onKeyDown<cfelse>onChange</cfif>="<cfif session.pda.use_onkeydown_enter>if(event.keyCode == 13)</cfif> clear_barcode();" onBlur="stock_reserve(#no#)">
												<input type="hidden" name="sid#no#" id="sid#no#" value="">
												<input type="hidden" name="action_row_id#no#" id="action_row_id#no#" value="">
											</div>
										</cfoutput>
									</cfif>
								</cfloop>
							</div>
						</td>
					</tr>
					<tr>
						<td colspan="2" align="center">
							<input type="button" value="Hesapla" onClick="calc_order();">
						</td>
					</tr>	
					<tr>
						<td colspan="2">						
							<div id="show_buttons">
								<table cellpadding="0" cellspacing="1" border="0" style="width:98%">								
									<tr>
										<td><cf_get_lang_main no='80.Toplam'>Tutar (YTL)</td>
										<td>T. Adet</td>
										<td>T. Çeşit</td>
									</tr>
									<tr>
										<td>
											<input type="hidden" name="nettotal_usd" id="nettotal_usd" value="<cfoutput>#tlformat(get_order_detail.other_money_value)#</cfoutput>" readonly="yes" class="moneybox" style="width:80px;"> <!--- USD --->
											<input type="text" name="nettotal" id="nettotal"  value="<cfoutput>#tlformat(get_order_detail.nettotal)#</cfoutput>"   readonly="yes" class="moneybox" style="width:100px;"> 
											<input type="hidden" name="sa_discount" id="sa_discount" value="0"><!---  onChange="FormatCurrency(this);toplam_hesapla();" class="moneybox"  style="width:80px;" --->
											<input type="hidden" name="basket_net_total_usd" id="basket_net_total_usd" value="0"><!---  readonly="yes" class="moneybox" style="width:80px;" --->
											<input type="hidden" name="basket_net_total" id="basket_net_total" value="0" > <!--- readonly="yes" class="moneybox" style="width:80px;" --->
										</td>
										<td>
											<input type="text" name="net_adet" id="net_adet" value="<cfoutput>#ArraySum(ListToArray(valuelist(get_order_detail.quantity)))#</cfoutput>" readonly="yes" class="moneybox" style="width:60px;">
										</td>
										<td>
											<input type="text" name="net_cesit" id="net_cesit" value="<cfoutput>#get_order_detail.recordcount#</cfoutput>" readonly="yes" class="moneybox" style="width:60px;">
										</td>
									</tr>
									<tr>
										<td align="center" colspan="3">
											<cfoutput><!--- waitForDisableAction(this); --->
											<input type="button" value="Sipariş Sil" onClick="javascript:if(confirm('Silmek İstediğinize Emin Misiniz?')){ window.location.href='#request.self#?fuseaction=pda.emptypopup_del_order&order_id=#order_id#&company_id=#get_order_detail.company_id#&head=#replace(get_order_detail.order_head," "," ","all")# - #get_order_detail.order_number#';} else return false;">
											</cfoutput>
											<input type="button" value="S. Güncelle" onClick="control_inputs();">
										</td>
									</tr>	
								</table>
							</div>
						</td>
					</tr>	
					<!---</div>--->		
				</cfform>
			</table>
		</td>
	</tr>
</table>
<br/>
<form name="form_calc_order" method="post" action="<cfoutput>#request.self#</cfoutput>?fuseaction=pda.emptypopup_calc_order_div">  
	<input type="hidden" name="company_id" id="company_id" value="">
	<input type="hidden" name="basket_products" id="basket_products" value="">
	<input type="hidden" name="basket_products_amount" id="basket_products_amount" value="">
	<input type="hidden" name="price_list_id" id="price_list_id" value="">
	<input type="hidden" name="price_date" id="price_date" value="">
	<input type="hidden" name="basket_free_products" id="basket_free_products" value="">
	<cfoutput query="get_money_bskt">
		<input type="hidden" name="txt_rate1_#money_type#" id="txt_rate1_#money_type#" value="#rate1#">
		<input type="hidden" name="txt_rate2_#money_type#" id="txt_rate2_#money_type#" value="#rate2#">
	</cfoutput>
	<input type="hidden" name="basket_money" id="basket_money" value="USD">
</form>

<div id="calc_order_div" style="display:none"></div>

<cfinclude template="basket_js_functions_order.cfm">
