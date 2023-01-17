<cfscript>session_basket_kur_ekle(process_type:0);</cfscript>
<cfif isdefined('attributes.cpid')>
	<cfquery name="GET_COMPANY" datasource="#DSN#">
		SELECT
			C.MANAGER_PARTNER_ID,
			C.FULLNAME
		FROM
			COMPANY C,
			WORKGROUP_EMP_PAR WEP 
		WHERE
			C.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cpid#"> AND
			C.COMPANY_ID=WEP.COMPANY_ID
			<cfif session.pda.admin eq 0 and session.pda.power_user eq 0>
				AND WEP.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pda.our_company_id#">		
				AND WEP.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pda.position_code#">  
			</cfif>
	</cfquery>
	<cfif get_company.recordcount>
		<cfquery name="GET_PARTNER" datasource="#DSN#">
			SELECT 
				PARTNER_ID,
				COMPANY_PARTNER_NAME,
				COMPANY_PARTNER_SURNAME
			FROM 
				COMPANY_PARTNER
			WHERE 
				PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_company.manager_partner_id#">
		</cfquery>
	</cfif>
</cfif>
<cfquery name="GET_PRICE_CAT" datasource="#DSN3#">
	SELECT PRICE_CATID, PRICE_CAT FROM PRICE_CAT
</cfquery>
<table border="0" cellpadding="0" cellspacing="0" align="center" style="width:98%">
	<tr style="height:35px;">
		<td class="headbold">Sipariş Al</td>
	</tr>
</table>
<table cellpadding="2" cellspacing="1" border="0" class="color-border" align="center" style="width:98%">	
	<tr>
		<td class="color-row">
            <cfform name="add_order" method="post" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_add_order" enctype="multipart/form-data">  
				<table align="center" style="width:99%">
					<input type="hidden" name="kur_say" id="kur_say" value="<cfoutput>#get_money_bskt.recordcount#</cfoutput>">
					<input type="hidden" name="row_count" id="row_count" value="<cfif isdefined("attributes.r_r_id") and len(attributes.r_r_id) and get_pre_reserved.recordcount><cfoutput>#get_pre_reserved.recordcount#</cfoutput><cfelse>0</cfif>">
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
					<tr>
						<td class="infotag">Müşteri *</td>
						<td nowrap="nowrap">
							<input type="hidden" name="company_id" id="company_id" value="<cfif isdefined('attributes.cpid') and get_company.recordcount><cfoutput>#attributes.cpid#</cfoutput></cfif>">
							<input type="hidden" name="partner_id" id="partner_id" value="<cfif isdefined('attributes.cpid') and get_company.recordcount><cfoutput>#get_partner.partner_id#</cfoutput></cfif>">
							<input type="hidden" name="member_type" id="member_type" value="<cfif isdefined('attributes.cpid') and get_company.recordcount>partner</cfif>">
							<input type="hidden" name="partner_name" id="partner_name" value="">
                            <input type="text" name="member_name" id="member_name" value="<cfif isdefined('attributes.cpid') and get_company.recordcount><cfoutput>#get_company.fullname#&nbsp;#get_partner.company_partner_name#&nbsp;#get_partner.company_partner_surname#</cfoutput></cfif>" class="wide_input">
							<a href="javascript://" onclick="get_turkish_letters_div('document.add_order.member_name','turkish_letters_div');"><img src="/images/plus_thin.gif" border="0" align="absmiddle" class="form_icon"></a>
							<a href="javascript://" onClick="get_company_all_div('company_all_div');"><img src="/images/plus_list.gif" border="0" align="absmiddle" class="form_icon"></a>						
						</td>
					</tr>
					<tr><td></td><td><div id="turkish_letters_div"></div></td></tr>
					<tr><td colspan="2"><div id="company_all_div"></div></td></tr>
					<tr>
						<td class="infotag">Fiyat Listesi</td>
						<td>
							<select name="price_cat_id" id="price_cat_id" onchange="sil_bastan();">
								<cfoutput query="get_price_cat">
									<option value="#price_catid#">#price_cat#</option>
								</cfoutput>
							</select>					
						</td>
					</tr>				
					<input type="hidden" name="order_date" id="order_date" value="<cfoutput>#dateformat(now(),'dd/mm/yyyy')#</cfoutput>" maxlength="10">
					<tr>
						<td class="infotag">Sevk Tarihi</td>
						<td>
							<cfinput type="text" name="ship_date" id="ship_date" value="#dateformat(date_add('d',1,now()),'dd/mm/yyyy')#"  validate="eurodate" maxlength="10" class="date_field">
							<cf_wrk_date_image date_field="ship_date">
						</td>
					</tr>
					<tr>
						<td class="infotag">Ödeme Yöntemi</td>
						<td>
							<input type="hidden" name="card_paymethod_id" id="card_paymethod_id" value="">
							<input type="hidden" name="commission_rate" id="commission_rate" value="">
							<input type="hidden" name="paymethod_vehicle" id="paymethod_vehicle" value="">
							<input type="hidden" name="paymethod_id" id="paymethod_id" value="">
							<input type="text" name="paymethod" id="paymethod" value="" class="wide_input">
							<a href="javascript://" onclick="get_paymethod_div();"><img src="/images/plus_list.gif" border="0" align="absmiddle" class="form_icon"></a>	
						</td>
					</tr>
					<tr><td colspan="2"><div id="paymethod_div"></div></td></tr>
					<tr>
						<td class="infotag">Açıklama</td>
						<td>
							<textarea name="detail" id="detail" style="width:194px;height:60px;"></textarea>						
						</td>
					</tr>
					<tr>
						<td class="infotag">Barkod</td>
						<td>
							<div id="show_prod_dsp">
								<input type="text" name="search_product" id="search_product" class="wide_input" <cfif isdefined('session.pda.use_onkeydown_enter')>onKeyDown<cfelse>onChange</cfif>="<cfif isDefined('session.pda.use_onkeydown_enter')>if(event.keyCode == 13)</cfif> {return add_barcode(document.getElementById('row_count').value,document.getElementById('search_product').value);}">
								<a href="javascript://" onClick="add_barcode(document.getElementById('row_count').value,document.getElementById('search_product').value);"><img src="/images/plus_list.gif" border="0" align="absmiddle" class="form_icon"></a>
							</div>												
						</td>
					</tr>
					<cfif isdefined('is_stock_code') and is_stock_code eq 1>
						<tr>
							<td class="infotag">Stok Özel Kodu</td>
							<td>
								<input type="text" name="search_stock" id="search_stock" style="width:162px;" <cfif isdefined('session.pda.use_onkeydown_enter')>onKeyDown<cfelse>onChange</cfif>="<cfif isDefined('session.pda.use_onkeydown_enter')>if(event.keyCode == 13)</cfif> {return add_barcode2(document.getElementById('row_count').value,document.getElementById('search_product').value);}">
								<a href="javascript://" onClick="add_stock_code2(document.getElementById('row_count_sto').value,add_order.search_stock.value);"><img src="/images/plus_list.gif" border="0" align="absmiddle" class="form_icon"></a>
								<input type="hidden" name="row_count_sto" id="row_count_sto" value="0">												
							</td>
						</tr>
					</cfif>
					<cfif isdefined('is_product_list') and is_product_list eq 1>
						<tr>
							<td class="infotag">Ürün</td>
							<td>
								<!---<input type="hidden" name="row_count" id="row_count" value="<cfif isdefined("attributes.r_r_id") and len(attributes.r_r_id) and get_pre_reserved.recordcount><cfoutput>#get_pre_reserved.recordcount#</cfoutput><cfelse>0</cfif>">--->
								<input type="hidden" name="tree_stock_id" id="tree_stock_id" <cfif isdefined('attributes.tree_stock_id') and isdefined('attributes.tree_product_name') and len(attributes.tree_stock_id) and len(attributes.tree_product_name)>value="<cfoutput>#attributes.tree_stock_id#</cfoutput>"</cfif>>
								<input type="hidden" name="tree_stock_code" id="tree_stock_code" <cfif isdefined('attributes.tree_stock_code') and isdefined('attributes.tree_product_name') and len(attributes.tree_stock_code) and len(attributes.tree_product_name)>value="<cfoutput>#attributes.tree_stock_code#</cfoutput>"</cfif>>
								<input type="text" name="tree_product_name" id="tree_product_name" value="<cfif isdefined('attributes.tree_stock_id') and isdefined('attributes.tree_product_name') and len(attributes.tree_stock_id) and len(attributes.tree_product_name)><cfoutput>#attributes.tree_product_name#</cfoutput></cfif>" style="width:162px;">
								<a href="javascript://"onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=pda.popup_list_products&field_row_count=add_order.row_count&is_saleable_stock=1&field_stock_id=add_order.tree_stock_id&field_code=add_order.tree_stock_code&field_currrentrow='+document.getElementById('row_count').value+'&field_name=add_order.tree_product_name&is_production=1&price_cat_id='+document.getElementById('price_cat_id').value+'&keyword='+encodeURIComponent(document.add_order.tree_product_name.value),'list');"><img src="/images/plus_list.gif" alt="" align="absmiddle" border="0" class="form_icon"></a>											
							</td>
						</tr>
					</cfif>
					<tr>
						<td colspan="2" id="order_rows">
							<!---<div id="mydiv">
								<cfloop from="1" to="200" index="no">
									<cfoutput>
										<div id="n_my_div#no#" style="display:none">
											<input  type="hidden" name="row_kontrol#no#" id="row_kontrol#no#" value="0">
											<a href="javascript://" onclick="sil_rezerv(#no#);sil(#no#);"><img  src="images/delete_list.gif" border="0"></a>
											<input type="text" name="barcode#no#" id="barcode#no#" value="" style="width:100px;" title="Barcode">
											<input type="text" name="amount#no#" id="amount#no#" value="1" style="width:30px;"  title="Amount" class="moneybox" onkeyup="FormatCurrency(this,0);" <cfif isdefined('session.pda.use_onkeydown_enter')>onkeydown<cfelse>onchange</cfif>="<cfif isDefined('session.pda.Use_onKeyDown_Enter')>if(event.keyCode == 13)</cfif> clear_barcode();" onblur="stock_reserve(#no#)">
											<input type="text" name="detail#no#" id="detail#no#" value="" style="width:100px;" title="Detail">
											<input type="hidden" name="sid#no#" id="sid#no#" value="">
											<input type="hidden" name="is_free_product#no#" id="is_free_product#no#" value="0">
										</div>
									</cfoutput>
								</cfloop>
							</div> --->
						</td>
					</tr>
					<tr>
						<td></td>
						<td align="left">
							<input type="button" value="Hesapla" onclick="calc_order();">
						</td>
					</tr>	
					<tr>
						<td colspan="2">						
							<div id="show_buttons" style="display:none">
								<table cellpadding="0" cellspacing="1" style="width:98%">
									<tr>
										<td><cf_get_lang_main no='80.Toplam'>Tutar (TL)</td>
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
											<input type="button" value="Sipariş Kaydet" onclick="control_inputs();">
										</td>
									</tr>	
								</table>
							</div>
						</td>
					</tr>		
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
	<input type="hidden" name="basket_free_products" id="basket_free_products" value="">
	<input type="hidden" name="price_list_id" id="price_list_id" value="">
	<input type="hidden" name="price_date" id="price_date" value="">
	<cfoutput query="get_money_bskt">
		<input type="hidden" name="txt_rate1_#money_type#" id="txt_rate1_#money_type#" value="#rate1#">
		<input type="hidden" name="txt_rate2_#money_type#" id="txt_rate2_#money_type#" value="#rate2#">
	</cfoutput>
	<input type="hidden" name="basket_money" id="basket_money" value="USD">
</form>

<div id="calc_order_div" style="display:none"></div>

<cfinclude template="basket_js_functions_order.cfm">
