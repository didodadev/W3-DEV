<cfscript>session_basket_kur_ekle(process_type:0);</cfscript>
<cfif isdefined('attributes.cpid')>
	<cfquery name="GET_COMPANY" datasource="#DSN#">
		SELECT
			C.*
		FROM
			COMPANY C,
			WORKGROUP_EMP_PAR WEP 
		WHERE
			C.COMPANY_ID = #attributes.cpid# AND
			C.COMPANY_ID=WEP.COMPANY_ID
			<cfif session.pda.admin eq 0 and session.pda.power_user eq 0><!---  and session.pda.member_view_control --->
			AND WEP.OUR_COMPANY_ID = #session.pda.our_company_id#		
			AND WEP.POSITION_CODE = #session.pda.position_code#  
			</cfif>
	</cfquery>
	<cfif get_company.recordcount>
		<cfquery name="GET_PARTNER" datasource="#DSN#">
			SELECT 
				*
			FROM 
				COMPANY_PARTNER
			WHERE 
				PARTNER_ID = #get_company.MANAGER_PARTNER_ID#
		</cfquery>
	</cfif>
</cfif>
<cfquery name="get_price_cat" datasource="#dsn3#">
	SELECT * FROM PRICE_CAT
</cfquery>
<table border="0" width="98%" cellpadding="0" cellspacing="0" align="center">
	<tr>
		<td height="35" class="headbold">Depo Sevk Talebi Ekle</td>
		<!--- <td align="right">
			<cfoutput query="get_money_bskt">
				<cfif money_type is 'USD'>
					USD: #rate2#
				</cfif>
			</cfoutput>
		</td> --->
	</tr>
</table>
<table width="98%" cellpadding="2" cellspacing="1" border="0" class="color-border" align="center">	
	<tr>
		<td class="color-row">
		<table>
			<cfform name="add_order" method="post" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_add_order" enctype="multipart/form-data">  
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
				<input type="hidden" name="order_date" id="order_date" value="<cfoutput>#dateformat(now(),'dd/mm/yyyy')#</cfoutput>" maxlength="10">
				<tr>
					<td width="70">Fiili Sevk Tarihi</td>
					<td width="110">
						<cfinput type="text" name="ship_date" value="#dateformat(date_add('d',1,now()),'dd/mm/yyyy')#"  validate="eurodate" maxlength="10" style="width:60px;">
						<cf_wrk_date_image date_field="ship_date">
					</td>
				</tr>
				 	<cfif not (isdefined('txt_department_name') and len(txt_department_name))>
						<cfset search_dep_id = listgetat(session.pda.user_location,1,'-')>
						<cfquery name="GET_NAME_OF_DEP" datasource="#DSN#">
							SELECT
								DEPARTMENT_HEAD,
								BRANCH_ID
							FROM
								DEPARTMENT
							WHERE
								DEPARTMENT_ID = #search_dep_id#	AND 
								IS_STORE <> 2
						</cfquery>
						<cfquery name="get_loc" datasource="#DSN#">
							SELECT  LOCATION_ID FROM STOCKS_LOCATION WHERE DEPARTMENT_ID=#search_dep_id# AND PRIORITY = 1
						</cfquery>						
						<cfif get_loc.recordcount and get_name_of_dep.recordcount>
							<cfset txt_department_name = get_name_of_dep.department_head>
							<cfset attributes.department_id = search_dep_id>
							<cfset attributes.location_id = get_loc.location_id>
						<cfelse>
							<cfset txt_department_name = ''>
						</cfif>
					</cfif>
			  	<tr>
					<td>Çıkış Depo *</td>
					<td><input type="hidden" name="location_id" id="location_id" value="<cfif isdefined('attributes.location_id') and len(attributes.location_id)><cfoutput>#attributes.location_id#</cfoutput></cfif>">
				  		<input type="hidden" name="department_id" id="department_id" value="<cfif isdefined('attributes.department_id') and len(attributes.department_id)><cfoutput>#attributes.department_id#</cfoutput></cfif>">
				  		<cfsavecontent variable="message">Depo Girmelisiniz !</cfsavecontent>
				  		<cfinput type="Text" name="txt_departman_" value="#txt_department_name#" required="yes" message="#message#" style="width:120px;">
						<a href="javascript://" onClick="get_turkish_letters_div('document.add_order.member_name','turkish_letters_div_1');"><img src="/images/plus_thin.gif" border="0" align="absmiddle"></a>
						<a href="javascript://" onClick="get_stores_locations_div_1();"><img src="/images/plus_list.gif" border="0" align="absmiddle"></a>						
					</td>
			  	</tr>
				<tr><td></td><td><div id="turkish_letters_div_1"></div></td></tr>
				<tr><td colspan="2"><div id="stores_locations_div_cikis"></div></td></tr>

			  	<tr>
					<td>Giriş Depo *</td>
					<td>
						  <cfsavecontent variable="message">Depo Girmelisiniz !</cfsavecontent>
						  <input type="hidden" name="department_in_id" id="department_in_id" value="<cfif isdefined('attributes.department_in_id') and len(attributes.department_in_id)><cfoutput>#attributes.department_in_id#</cfoutput></cfif>">
						  <input type="hidden" name="location_in_id" id="location_in_id" value="<cfif isdefined('attributes.location_in_id') and len(attributes.location_in_id)><cfoutput>#attributes.location_in_id#</cfoutput></cfif>">
						  <cfif isdefined('attributes.department_in_txt') and len(attributes.department_in_txt)>
							  <cfinput type="text" name="department_in_txt" value="#attributes.department_in_txt#" required="yes" message="#message#" style="width:120px;">
						  <cfelse>
							  <cfinput type="text" name="department_in_txt" value="" required="yes" message="#message#" style="width:120px;">
						  </cfif>
						<a href="javascript://" onClick="get_turkish_letters_div('document.add_order.member_name','turkish_letters_div_2');"><img src="/images/plus_thin.gif" border="0" align="absmiddle"></a>
						<a href="javascript://" onClick="get_stores_locations_div_2(stores_locations_div_giris);"><img src="/images/plus_list.gif" border="0" align="absmiddle"></a>						
					</td>
			  	</tr>
				<tr><td></td><td><div id="turkish_letters_div_2"></div></td></tr>
				<tr><td colspan="2"><div id="stores_locations_div_giris"></div></td></tr>

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
								<div id="n_my_div#no#" style="display:none"><input  type="hidden" value="0" name="row_kontrol#no#" id="row_kontrol#no#"><a href="javascript://" onclick="sil_rezerv(#no#);sil(#no#);"><img  src="images/delete_list.gif" border="0"></a><input type="text" style="width:150px;" name="barcode#no#" id="barcode#no#" value=""><input style="width:30px;" type="text" name="amount#no#" id="amount#no#" value="1" class="moneybox" onKeyUp="FormatCurrency(this,0);" <cfif session.pda.Use_onKeyDown_Enter>onKeyDown<cfelse>onChange</cfif>="<cfif session.pda.Use_onKeyDown_Enter>if(event.keyCode == 13)</cfif> clear_barcode();"><input type="hidden" value="" name="sid#no#" id="sid#no#"></div><!---  onBlur="stock_reserve(#no#)" --->
								</cfoutput>
							</cfloop>
						</div>
					</td>
				</tr>
				<tr>
					<td colspan="2" align="center">
						<input type="button" value="Hesapla" onClick="calc_ship_dispatch();">
					</td>
				</tr>	
				<tr>
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
				</tr>	
				</div>		
			</cfform>
		</table>
		</td>
	</tr>
</table>
<br/>
<form name="form_calc_order" method="post" action="<cfoutput>#request.self#</cfoutput>?fuseaction=pda.emptypopup_calc_purchase_div">  
	<input type="hidden" name="basket_products" id="basket_products" value="">
	<input type="hidden" name="basket_products_amount" id="basket_products_amount" value="">
	<input type="hidden" name="price_list_id" id="price_list_id" value="">
	<input type="hidden" name="price_date" id="price_date" value="">
	<cfoutput query="get_money_bskt">
		<input type="hidden" name="txt_rate1_#money_type#" id="txt_rate1_#money_type#" value="#rate1#">
		<input type="hidden" name="txt_rate2_#money_type#" id="txt_rate2_#money_type#" value="#rate2#">
	</cfoutput>
	<input type="hidden" name="basket_money" id="basket_money" value="USD">
</form>

<div id="calc_order_div" style="display:none"></div>

<cfinclude template="basket_js_functions_ship_dispatch.cfm">
