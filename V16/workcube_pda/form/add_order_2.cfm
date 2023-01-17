<cfscript>session_basket_kur_ekle(process_type:0);</cfscript>
<cfparam name="attributes.is_disable" default=1>
<cfif isdefined('attributes.cpid')>
	<cfquery name="GET_COMPANY" datasource="#DSN#">
		SELECT 
			MANAGER_PARTNER_ID, 
			FULLNAME
		FROM 
			COMPANY  
		WHERE 
			COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cpid#">
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
<cfif cgi.http_host eq 'pdacube.timesaat.com'>
	<table border="0" width="98%" class="headbold" cellpadding="0" cellspacing="0" align="center">
		<tr>
			<td height="35">Sipariş Al (Stok Kontrolsüz)</td>
		</tr>
	</table>
	<table width="98%" cellpadding="2" cellspacing="1" border="0" class="color-border" align="center">	
		<tr>
			<td class="color-row">
				<table>
					<cfform name="add_order" method="post" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_add_order_2" enctype="multipart/form-data">  
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
						<tr>
							<td>Müşteri *</td>
							<td><input type="hidden" name="company_id" id="company_id" value="<cfif isdefined('attributes.cpid') and get_company.recordcount><cfoutput>#attributes.cpid#</cfoutput></cfif>">
								<input type="hidden" name="partner_id" id="partner_id" value="<cfif isdefined('attributes.cpid') and get_company.recordcount><cfoutput>#get_partner.partner_id#</cfoutput></cfif>">
								<input type="hidden" name="member_type" id="member_type" value="<cfif isdefined('attributes.cpid') and get_company.recordcount>partner</cfif>">
								<input type="text" name="member_name" id="member_name" value="<cfif isdefined('attributes.cpid') and get_company.recordcount><cfoutput>#get_company.fullname#&nbsp;#get_partner.company_partner_name#&nbsp;#get_partner.company_partner_surname#</cfoutput></cfif>"  style="width:120px;">
								<a href="javascript://" onClick="get_turkish_letters_div('document.add_order.member_name','turkish_letters_div');"><img src="/images/plus_thin.gif" border="0" align="absmiddle"></a>
								<a href="javascript://" onClick="get_company_all_div();"><img src="/images/plus_list.gif" border="0" align="absmiddle"></a>						
							</td>
						</tr>
						<tr><td></td><td><div id="turkish_letters_div"></div></td></tr>
						<tr><td colspan="2"><div id="company_all_div"></div></td></tr>
						<tr>
							<td height="20">Fiyat Listesi</td>
							<td>
								<select name="price_cat_id" id="price_cat_id" onChange="sil_bastan();" style="width:150px;">
									<cfoutput query="get_price_cat">
										<option value="#price_catid#">#price_cat#</option>
									</cfoutput>
								</select>					
							</td>
						</tr>				
						<input type="hidden" name="order_date" id="order_date" value="<cfoutput>#dateformat(now(),'dd/mm/yyyy')#</cfoutput>" maxlength="10">
						<tr>
							<td width="70">Sevk Tarihi</td>
							<td width="110">
								<cfinput type="text" name="ship_date" id="ship_date" value="#dateformat(dateadd('d',1,now()),'dd/mm/yyyy')#"  validate="eurodate" maxlength="10" style="width:73px;">
							</td>
						</tr>
						<tr>
							<td width="70">Ödeme Yöntemi</td>
							<td>
								<input type="hidden" name="card_paymethod_id" id="card_paymethod_id" value="">
								<input type="hidden" name="commission_rate" id="commission_rate" value="">
								<input type="hidden" name="paymethod_vehicle" id="paymethod_vehicle" value="">
								<input type="hidden" name="paymethod_id" id="paymethod_id" value="">
								<input type="text" name="paymethod" id="paymethod" value=""  style="width:130px;">
								<a href="javascript://" onClick="get_paymethod_div();"><img src="/images/plus_list.gif" border="0" align="absmiddle"></a>	
							</td>
						</tr>
						<tr><td colspan="2"><div id="paymethod_div"></div></td></tr>
						<tr>
							<td width="70">Açıklama</td>
							<td width="110">
								<textarea name="detail" id="detail" style="width:150px;height:30px;"></textarea>						
							</td>
						</tr>
						<!--- Asılı Kalan Ürünlerden Sipariş Oluşturuluyorsa --->
						<cfif isdefined("attributes.r_r_id") and len(attributes.r_r_id)>
							<cfquery name="GET_PRE_RESERVED" datasource="#DSN3#">
								SELECT 
									S.PRODUCT_NAME,
									S.BARCOD,
									ORR.* 
								FROM 
									ORDER_ROW_RESERVED ORR,
									STOCKS S
								WHERE 
									ORR.PRE_ORDER_ID = '<cfoutput>#CFTOKEN#</cfoutput>' AND
									S.STOCK_ID = ORR.STOCK_ID AND
									ORR.RESERVE_STOCK_OUT > 0 AND
									ORR.ROW_RESERVED_ID IN (#attributes.r_r_id#)
								ORDER BY
									ORR.ROW_RESERVED_ID
							</cfquery>
						</cfif>
						<tr>
							<td width="70">Barkod</td>
							<td>
								<div id="show_prod_dsp">
									<input type="text" name="search_product" id="search_product" style="width:130px;" onKeyDown="if(event.keyCode == 13) {return add_barcode2(document.getElementById('row_count').value,add_order.search_product.value);}"><!--- ,1 --->
									<a href="javascript://" onClick="add_barcode2(document.getElementById('row_count').value,add_order.search_product.value);"><img src="/images/plus_list.gif" border="0" align="absmiddle"></a><!--- ,1 --->
									<input type="hidden" name="row_count" id="row_count" value="<cfif isdefined("attributes.r_r_id") and len(attributes.r_r_id) and get_pre_reserved.recordcount><cfoutput>#get_pre_reserved.recordcount#</cfoutput><cfelse>0</cfif>">
								</div>												
							</td>
						</tr>
						<tr>
							<td colspan="2">
								<div id="mydiv">
									<cfloop from="1" to="200" index="no">
										<cfif isdefined("attributes.r_r_id") and len(attributes.r_r_id) and get_pre_reserved.recordcount and no lte get_pre_reserved.recordcount>
											<cfoutput>
												<div id="n_my_div#no#"><cfif len(no) is 1>&nbsp;&nbsp;</cfif>#no#
												<input type="hidden" name="row_kontrol#no#" id="row_kontrol#no#" value="1">
												<a href="javascript://" onclick="sil(#no#);"><img  src="images/delete_list.gif" border="0" align="absmiddle"></a>
												<input type="text" name="barcode#no#" id="barcode#no#" value="#get_pre_reserved.barcod[no]#" style="width:130px;">
												<input type="text" name="amount#no#" id="amount#no#" value="#get_pre_reserved.reserve_stock_out[no]#" onChange="javascript:eval('document.add_order.amnt'+#no#).value=eval('document.add_order.amount'+#no#).value;" class="moneybox" onKeyUp="FormatCurrency(this,0);" onKeyDown="if(event.keyCode == 13) clear_barcode();" style="width:30px;">
												<input type="text" name="amnt#no#" id="amnt#no#" value="#get_pre_reserved.reserve_stock_out[no]#" class="moneybox" onKeyUp="FormatCurrency(this,0);" style="background-color:CCCCCC;width:30px;" disabled>
												<input type="hidden" name="sid#no#" id="sid#no#" value="">
												<input type="hidden" name="action_row_id#no#" id="action_row_id#no#" value="#get_pre_reserved.order_row_id[no]#">
												<input type="hidden" name="wrk_row_id#no#" id="wrk_row_id#no#" value="#get_pre_reserved.order_wrk_row_id[no]#"></div>
											</cfoutput>
										<cfelse>
											<cfoutput>
												<div id="n_my_div#no#" style="display:none"><cfif len(no) is 1>&nbsp;&nbsp;</cfif>#no#
												<input  type="hidden" name="row_kontrol#no#" id="row_kontrol#no#" value="0">
												<a href="javascript://" onclick="sil(#no#);"><img  src="images/delete_list.gif" border="0" align="absmiddle"></a>
												<input type="text" name="barcode#no#" id="barcode#no#" style="width:130px;" value="">
												<input type="text" name="amount#no#" id="amount#no#" value="1" class="moneybox" onKeyUp="FormatCurrency(this,0);" style="width:30px;" onChange="javascript:eval('document.add_order.amnt'+#no#).value=eval('document.add_order.amount'+#no#).value;" onKeyDown="if(event.keyCode == 13) clear_barcode();" >
												<input type="text" name="amnt#no#" id="amnt#no#" value="1" class="moneybox" style="background-color:CCCCCC;width:30px;" onKeyUp="FormatCurrency(this,0);" disabled>
												<input type="hidden" name="sid#no#" id="sid#no#" value="">
												</div>
											</cfoutput>
										</cfif>
									</cfloop>
								</div>
							</td>
						</tr>
						<!--- Asılı Kalan Ürünlerden Sipariş Oluşturuluyorsa --->
						<cfif isdefined("attributes.r_r_id") and len(attributes.r_r_id) and listlen(valuelist(get_pre_reserved.row_reserved_id))>
							<cfquery name="GET_EMPLOYEE_EMAIL" datasource="#DSN#">
								SELECT 
									EMPLOYEE_EMAIL
								FROM 
									EMPLOYEES
								WHERE             
									EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pda.userid#">
							</cfquery> 
							<cfif len(trim(get_employee_email.employee_email))>
								<cfmail from="workcube@timesaat.com" to="#get_employee_email.employee_email#,bahadir.ceng@timesaat.com,mehmet.ulucay@timesaat.com" subject="Asılı Kalan Ürünlerden Sipariş Oluştururken Rezerveden Silinenler" charset="utf-8" type="html">
									Kullanıcı: #session.pda.name# #session.pda.surname#<br/>
									Asılı Kalan Ürünlerden Sipariş Oluştururken Rezerveden Silinenler: #valuelist(get_pre_reserved.barcod)#<br/><br/>
								</cfmail>
							<cfelse>
								<cfmail from="workcube@timesaat.com" to="bahadir.ceng@timesaat.com,mehmet.ulucay@timesaat.com" subject="Asılı Kalan Ürünlerden Sipariş Oluştururken Rezerveden Silinenler" charset="utf-8" type="html">
									Kullanıcı: #session.pda.name# #session.pda.surname#<br/>
									Asılı Kalan Ürünlerden Sipariş Oluştururken Rezerveden Silinenler: #valuelist(get_pre_reserved.barcod)#<br/><br/>
								</cfmail>
							</cfif>
							<cfquery name="DEL_PRE_RESERVED" datasource="#DSN3#">
								DELETE FROM 
									ORDER_ROW_RESERVED
								WHERE 
									ROW_RESERVED_ID IN (#valuelist(get_pre_reserved.ROW_RESERVED_ID)#)
							</cfquery>
						</cfif>
						<tr>
							<td colspan="2" align="center">
								<input type="button" value="Hesapla" onClick="calc_order(1);">
							</td>
						</tr>	
						<div id="problem_barcodes_div" style="display:none">                    
							<tr>
								<td colspan="2"id="problem_barcodes_td"></td>
							</tr>	
						</div>
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
												<input type="button" value="Sipariş Kaydet" onClick="control_inputs();">
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
<cfelse>
	<table border="0" width="98%" class="headbold" cellpadding="0" cellspacing="0" align="center">
		<tr>
			<td height="35" style="font-size:14px;">Sipariş Al (Stok Kontrolsüz)</td>
		</tr>
	</table>
	<table width="98%" cellpadding="2" cellspacing="1" border="0" class="color-border" align="center">	
		<tr>
			<td class="color-row">
				<table>
					<cfform name="add_order" method="post" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_add_order_2" enctype="multipart/form-data">  
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
					<tr>
						<td style="font-size:14px;" width="150">Müşteri *</td>
						<td><input type="hidden" name="company_id" id="company_id" value="<cfif isdefined('attributes.cpid') and get_company.recordcount><cfoutput>#attributes.cpid#</cfoutput></cfif>">
							<input type="hidden" name="partner_id" id="partner_id" value="<cfif isdefined('attributes.cpid') and get_company.recordcount><cfoutput>#get_partner.partner_id#</cfoutput></cfif>">
							<input type="hidden" name="member_type" id="member_type" value="<cfif isdefined('attributes.cpid') and get_company.recordcount>partner</cfif>">
							<input type="text" name="member_name" id="member_name" value="<cfif isdefined('attributes.cpid') and get_company.recordcount><cfoutput>#get_company.fullname#&nbsp;#get_partner.company_partner_name#&nbsp;#get_partner.company_partner_surname#</cfoutput></cfif>"  style="width:170px;font-size:14px;height:30px;">
							<a href="javascript://" onClick="get_turkish_letters_div('document.add_order.member_name','turkish_letters_div');"><img src="/images/plus_thin.gif" border="0" align="absmiddle" height="30"></a>
							<a href="javascript://" onClick="get_company_all_div();"><img src="/images/plus_list.gif" border="0" align="absmiddle" height="30"></a>						
						</td>
					</tr>
					<tr><td></td><td><div id="turkish_letters_div"></div></td></tr>
					<tr><td colspan="2"><!---<div id="company_all_div"></div>---></td></tr>
					<tr>
						<td height="20" style="font-size:14px;">Fiyat Listesi</td>
						<td>
							<select name="price_cat_id" id="price_cat_id" onChange="sil_bastan();" style="width:220px;font-size:14px;height:30px;">
								<cfoutput query="get_price_cat">
									<option value="#price_catid#">#price_cat#</option>
								</cfoutput>
							</select>					
						</td>
					</tr>				
					<input type="hidden" name="order_date" id="order_date" value="<cfoutput>#dateformat(now(),'dd/mm/yyyy')#</cfoutput>" maxlength="10">
					<tr>
						<td width="70" style="font-size:14px;">Sevk Tarihi</td>
						<td width="110">
							<cfinput type="text" name="ship_date" id="ship_date" value="#dateformat(dateadd('d',1,now()),'dd/mm/yyyy')#"  validate="eurodate" maxlength="10" style="width:220px;font-size:14px;height:30px;">
						</td>
					</tr>
					<tr>
						<td width="70" style="font-size:14px;">Ödeme Yöntemi</td>
						<td>
							<input type="hidden" name="card_paymethod_id" id="card_paymethod_id" value="">
							<input type="hidden" name="commission_rate" id="commission_rate" value="">
							<input type="hidden" name="paymethod_vehicle" id="paymethod_vehicle" value="">
							<input type="hidden" name="paymethod_id" id="paymethod_id" value="">
							<input type="text" name="paymethod" id="paymethod" value=""  style="width:190px;font-size:14px;height:30px;">
							<a href="javascript://" onClick="get_paymethod_div();"><img src="/images/plus_list.gif" border="0" align="absmiddle" height="30"></a>	
						</td>
					</tr>
					<tr><td colspan="2"><!---<div id="paymethod_div"></div>---></td></tr>
					<tr>
						<td width="70" style="font-size:14px;">Açıklama</td>
						<td width="110">
							<textarea name="detail" id="detail" style="width:220px;height:60px;font-size:14px;"></textarea>						
						</td>
					</tr>
					<!--- Asılı Kalan Ürünlerden Sipariş Oluşturuluyorsa --->
					<cfif isdefined("attributes.r_r_id") and len(attributes.r_r_id)>
						<cfquery name="GET_PRE_RESERVED" datasource="#DSN3#">
							SELECT 
								S.PRODUCT_NAME,S.BARCOD,ORR.* 
							FROM 
								ORDER_ROW_RESERVED ORR,
								STOCKS S
							WHERE 
								ORR.PRE_ORDER_ID = '<cfoutput>#CFTOKEN#</cfoutput>' AND
								S.STOCK_ID = ORR.STOCK_ID AND
								ORR.RESERVE_STOCK_OUT > 0 AND
								ORR.ROW_RESERVED_ID IN (#attributes.r_r_id#)
							ORDER BY
								ORR.ROW_RESERVED_ID
						</cfquery>
					</cfif>
					<!---<tr>
						<td width="70" style="font-size:14px;">Barkod</td>
						<td>
							<div id="show_prod_dsp">
								<input type="text" name="search_product" id="search_product" style="width:190px;font-size:14px;height:30px;" onKeyDown="if(event.keyCode == 13) {return add_barcode2(document.getElementById('row_count').value,add_order.search_product.value);}"><!--- ,1 --->
								<a href="javascript://" onClick="add_barcode2(document.getElementById('row_count').value,add_order.search_product.value);"><img src="/images/plus_list.gif" border="0" align="absmiddle" height="30"></a><!--- ,1 --->
								<input type="hidden" name="row_count" id="row_count" value="<cfif isdefined("attributes.r_r_id") and len(attributes.r_r_id) and get_pre_reserved.recordcount><cfoutput>#get_pre_reserved.recordcount#</cfoutput><cfelse>0</cfif>">
							</div>												
						</td>
					</tr>--->
					<tr>
						<td width="70" style="font-size:14px;">Ürün</td>
						<td>
							<div id="show_product_search">
								<input type="hidden" name="row_count" id="row_count" value="<cfif isdefined("attributes.r_r_id") and len(attributes.r_r_id) and get_pre_reserved.recordcount><cfoutput>#get_pre_reserved.recordcount#</cfoutput><cfelse>0</cfif>">
								<input type="hidden" name="tree_stock_id" id="tree_stock_id" <cfif isdefined('attributes.tree_stock_id') and isdefined('attributes.tree_product_name') and len(attributes.tree_stock_id) and len(attributes.tree_product_name)>value="<cfoutput>#attributes.tree_stock_id#</cfoutput>"</cfif>>
								<input type="hidden" name="tree_stock_code" id="tree_stock_code" <cfif isdefined('attributes.tree_stock_code') and isdefined('attributes.tree_product_name') and len(attributes.tree_stock_code) and len(attributes.tree_product_name)>value="<cfoutput>#attributes.tree_stock_code#</cfoutput>"</cfif>>
								<input type="text" name="tree_product_name" id="tree_product_name" style="width:190px;height:30px;font-size:14px;" value="<cfif isdefined('attributes.tree_stock_id') and isdefined('attributes.tree_product_name') and len(attributes.tree_stock_id) and len(attributes.tree_product_name)><cfoutput>#attributes.tree_product_name#</cfoutput></cfif>">
								<a href="javascript://"onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects2.popup_product_price_unit&field_row_count=add_order.row_count&is_saleable_stock=1&field_stock_id=add_order.tree_stock_id&field_code=add_order.tree_stock_code&field_currrentrow='+document.getElementById('row_count').value+'&field_name=add_order.tree_product_name&is_production=1&price_cat_id='+document.getElementById('price_cat_id').value+'&keyword='+encodeURIComponent(document.add_order.tree_product_name.value),'list');"><img src="/images/plus_list.gif" alt="" align="absmiddle" border="0"height="30"></a>
							</div>												
						</td>
					</tr>
					<tr>
						<td colspan="2">
							<div id="mydiv">
								<cfloop from="1" to="200" index="no">
									<cfif isdefined("attributes.r_r_id") and len(attributes.r_r_id) and get_pre_reserved.recordcount and no lte get_pre_reserved.recordcount>
										<cfoutput>
										<div id="n_my_div#no#"><cfif len(no) is 1>&nbsp;&nbsp;</cfif>
										<input  type="hidden" name="row_kontrol#no#" id="row_kontrol#no#" value="1" >
										<a href="javascript://" onclick="sil(#no#);"><img  src="images/delete_list.gif" border="0" align="absmiddle" height="30"></a>
										<input type="text" name="barcode#no#" id="barcode#no#" value="#get_pre_reserved.barcod[no]#" style="width:130px;height:30px;font-size:14px;">&nbsp;&nbsp;&nbsp;
										<input type="text" name="prod_name#no#" id="prod_name#no#" value="" style="width:170px;height:30px;font-size:14px;" readonly>&nbsp;&nbsp;&nbsp;
										<input type="text" name="amount#no#" id="amount#no#" value="#get_pre_reserved.reserve_stock_out[no]#" class="moneybox" onKeyUp="FormatCurrency(this,0);" style="width:30px;height:30px;font-size:14px;" onKeyDown="if(event.keyCode == 13) clear_barcode();">
										<input type="hidden" name="sid#no#" id="sid#no#" value="" >
										<input type="hidden" name="action_row_id#no#" id="action_row_id#no#" value="#get_pre_reserved.order_row_id[no]#">
										<input type="hidden" name="wrk_row_id#no#" id="wrk_row_id#no#" value="#get_pre_reserved.order_wrk_row_id[no]#" ></div>
										</cfoutput>
									<cfelse>
										<cfoutput>
										<div id="n_my_div#no#" style="display:none"><cfif len(no) is 1>&nbsp;&nbsp;</cfif>
										<input  type="hidden" name="row_kontrol#no#" id="row_kontrol#no#" value="0">
										<a href="javascript://" onclick="sil(#no#);"><img  src="images/delete_list.gif" border="0" align="absmiddle" height="30"></a>
										<input type="text" name="barcode#no#" id="barcode#no#" value="" style="width:130px;height:30px;font-size:14px;">&nbsp;&nbsp;&nbsp;
										<input type="text" name="prod_name#no#" id="prod_name#no#" value="" style="width:170px;height:30px;font-size:14px;" readonly>&nbsp;&nbsp;&nbsp;
										<input type="text" name="amount#no#" id="amount#no#" value="1" class="moneybox" onKeyUp="FormatCurrency(this,0);" style="width:30px;height:30px;font-size:14px;"  onKeyDown="if(event.keyCode == 13) clear_barcode();" >
										<input type="hidden" name="sid#no#" id="sid#no#" value=""></div>
										</cfoutput>
									</cfif>
								</cfloop>
							</div>
						</td>
					</tr>
                			<!--- Asılı Kalan Ürünlerden Sipariş Oluşturuluyorsa --->
					<cfif isdefined("attributes.r_r_id") and len(attributes.r_r_id) and listlen(valuelist(get_pre_reserved.ROW_RESERVED_ID))>
						<cfquery name="GET_EMPLOYEE_EMAIL" datasource="#DSN#">
							SELECT 
								EMPLOYEE_EMAIL
							FROM 
								EMPLOYEES
							WHERE             
								EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pda.userid#">
						</cfquery> 
						<cfif len(trim(get_employee_email.employee_email))>
							<cfmail from="workcube@timesaat.com" to="#get_employee_email.employee_email#,bahadir.ceng@timesaat.com,mehmet.ulucay@timesaat.com" subject="Asılı Kalan Ürünlerden Sipariş Oluştururken Rezerveden Silinenler" charset="utf-8" type="html">
							Kullanıcı: #session.pda.name# #session.pda.surname#<br/>
							Asılı Kalan Ürünlerden Sipariş Oluştururken Rezerveden Silinenler: #valuelist(get_pre_reserved.barcod)#<br/><br/>
							</cfmail>
						<cfelse>
							<cfmail from="workcube@timesaat.com" to="bahadir.ceng@timesaat.com,mehmet.ulucay@timesaat.com" subject="Asılı Kalan Ürünlerden Sipariş Oluştururken Rezerveden Silinenler" charset="utf-8" type="html">
							Kullanıcı: #session.pda.name# #session.pda.surname#<br/>
							Asılı Kalan Ürünlerden Sipariş Oluştururken Rezerveden Silinenler: #valuelist(get_pre_reserved.barcod)#<br/><br/>
							</cfmail>
						</cfif>
						<cfquery name="DEL_PRE_RESERVED" datasource="#DSN3#">
							DELETE FROM 
								ORDER_ROW_RESERVED
							WHERE 
								ROW_RESERVED_ID IN (#valuelist(get_pre_reserved.ROW_RESERVED_ID)#)
						</cfquery>
					</cfif>
					<tr>
						<td colspan="2" align="center">
							<input type="button" value="Hesapla" onClick="calc_order(1);" style="height:30px;width:80px;font-size:14px;">
						</td>
					</tr>	
					<div id="problem_barcodes_div" style="display:none">                    
						<tr>
							<td colspan="2"id="problem_barcodes_td"></td>
						</tr>	
					</div>
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
											<input type="text" name="nettotal" id="nettotal" value="0" readonly="yes" class="moneybox" style="width:100px;height:30px;font-size:14px;"> <!--- YTL --->
											<input type="hidden" name="sa_discount" id="sa_discount" value="0">
											<input type="hidden" name="basket_net_total_usd" id="basket_net_total_usd" value="0">
											<input type="hidden" name="basket_net_total" id="basket_net_total" value="0" > 
										</td>
										<td>
											<input type="text" name="net_adet" id="net_adet" value="" readonly="yes" class="moneybox" style="width:60px;height:30px;font-size:14px;">
										</td>
										<td>
											<input type="text" name="net_cesit" id="net_cesit" value="" readonly="yes" class="moneybox" style="width:60px;height:30px;font-size:14px;">
										</td>
									</tr>
									<tr>
										<td align="center" colspan="3">
											<input type="button" name="add_sale" id="add_sale" value="Sipariş Kaydet" onClick="control_inputs();" style="height:30px;font-size:14px;width:100px;">
										</td>
									</tr>	
								</table>
							</div>
						</td>
					</tr>		
					</cfform>
				</table>
			</td>
			<td class="color-row" width="50%" valign="top"><div id="company_all_div"></div><br/>
				<div id="paymethod_div"></div></td>
			</td>
		</tr>
	</table>
</cfif>
<br/>
<form name="form_calc_order" method="post" action="<cfoutput>#request.self#</cfoutput>?fuseaction=pda.emptypopup_calc_order_div_2">  
	<input type="hidden" name="company_id" id="company_id" value="">
	<input type="hidden" name="basket_products" id="basket_products" value="">
	<input type="hidden" name="basket_products_amount" id="basket_products_amount" value="">
	<input type="hidden" name="basket_products_all" id="basket_products_all" value="">
	<input type="hidden" name="basket_products_amount_all" id="basket_products_amount_all" value="">
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
<script>
	function windowopen(theURL,winSize) { /*v3.0*/
		//fonsiyon 3 parametrede alabiliyor 3. parametre de isim yollana bilir ozaman aynı pencere tekrar acilmaz
		
		if (winSize == 'page') 					{ myWidth=750 ; myHeight=500 ; features = 'scrollbars=1, resizable=1, menubar=1' ; }
		else if (winSize == 'list') 			{ myWidth=700 ; myHeight=555 ; features = 'scrollbars=1, resizable=1, menubar=1' ; }
		else if (winSize == 'medium') 			{ myWidth=600 ; myHeight=470 ; features = 'scrollbars=1, resizable=1, menubar=1' ; }
		else if (winSize == 'small') 			{ myWidth=400 ; myHeight=300 ; features = 'scrollbars=1, resizable=1, menubar=1' ; }
		else if (winSize == 'date') 			{ myWidth=275 ; myHeight=190 ; features = 'scrollbars=1, resizable=1, menubar=1' ; }
		else if (winSize == 'project') 			{ myWidth=800 ; myHeight=620 ; features = 'scrollbars=1, resizable=1, menubar=1' ; }
		else if (winSize == 'large') 			{ myWidth=615 ; myHeight=550 ; features = 'scrollbars=1, resizable=1, menubar=1' ; }
		else if (winSize == 'horizantal') 		{ myWidth=950 ; myHeight=300 ; features = 'scrollbars=1, resizable=1, menubar=1' ; }
		else if (winSize == 'list_horizantal')	{ myWidth=1100 ; myHeight=400 ; features = 'scrollbars=1, resizable=1, menubar=1' ; }
		else if (winSize == 'wide') 			{ myWidth=980 ; myHeight=600 ; features = 'scrollbars=1, resizable=1, menubar=1' ; }
		else if (winSize == 'wide2') 			{ myWidth=1100 ; myHeight=600 ; features = 'scrollbars=1, resizable=1, menubar=1' ; }
		else if (winSize == 'longpage') 		{ myWidth=1100 ; myHeight=500 ; features = 'scrollbars=1, resizable=1, menubar=1' ; }
		else if (winSize == 'page_horizantal') 	{ myWidth=800 ; myHeight=500 ; features = 'scrollbars=1, resizable=1, menubar=1' ; }
		else if (winSize == 'video') 			{ myWidth=490 ; myHeight=445 ; features = 'scrollbars=0, resizable=0, menubar=0' ; }
		else if (winSize == 'wwide') 			{ myWidth=1600 ; myHeight=860 ; features = 'scrollbars=1, resizable=1, menubar=1' ; }  
		else if (winSize == 'long_menu') 		{ myWidth=200 ; myHeight=500 ; features = 'scrollbars=0, resizable=0' ; }
		else if (winSize == 'adminTv') 			{ myWidth=1040 ; myHeight=870 ; features = 'scrollbars=1, resizable=1, menubar=0' ; }
		else if (winSize == 'userTv') 			{ myWidth=565 ; myHeight=487 ; features = 'scrollbars=0, resizable=0, menubar=0' ; }
		else if (winSize == 'video_conference')	{ myWidth=740 ; myHeight=610 ; features = 'scrollbars=0, resizable=0, menubar=0' ; }
		else if (winSize == 'white_board')		{ myWidth=1000 ; myHeight=730 ; features = 'scrollbars=0, resizable=1, menubar=0' ; }
		else if (winSize == 'wwide1') 			{ myWidth=1200 ; myHeight=700 ; features = 'scrollbars=1, resizable=1, menubar=1' ; }
		else { myWidth=400 ; myHeight=500 ; features = 'scrollbars=0, resizable=0' ; }
	
		if(window.screen)
		{
			var myLeft = (screen.width-myWidth)/2;
			var myTop =  (screen.height-myHeight)/2;
			
			features+=(features!='')?',':''; 
			features+=',left='+myLeft+',top='+myTop; 
		}
		
		if (arguments[2]==null)
			window.open(theURL,'',features+((features!='')?',':'')+'width='+myWidth+',height='+myHeight); 
		else		
			window.open(theURL,arguments[2],features+((features!='')?',':'')+'width='+myWidth+',height='+myHeight); 
	}

	function add_barcode4(no,prodname)
	{	
		var barcode_found = 0;
		if(no > 0)
		{	
			for(var i=1; i<=no; i++)
			{	
				if(eval('document.add_order.row_kontrol'+i).value == 1)
				{
					if(prodname == eval('document.all.barcode'+i).value)
					{
						eval('document.add_order.amount'+i).focus();
						barcode_found = 1;
						break;
					}	
				}	
				else if(eval('document.all.row_kontrol'+i).value == 0)// && stock_cntrl
				{
					if(prodname == eval('document.all.barcode'+i).value)
					{
						goster(eval('n_my_div' + i));
						eval('document.add_order.row_kontrol'+i).value = 1;
						eval('document.add_order.amount'+i).focus();
						barcode_found = 1;
						break;
					}	
				}	
			}	
		}		
		if(barcode_found == 0)
		{
			alert('Aradığınız barkod sepette bulunamadı. Yeni satıra ekleniyor !');
			no++;
				goster(eval('n_my_div' + no));
				eval('document.add_order.row_kontrol'+no).value = 1;
				eval('document.add_order.barcode'+no).value = barcode;
				eval('document.add_order.amount'+no).focus();
				document.getElementById('row_count').value = parseInt(document.getElementById('row_count').value) + 1;
			}	
			document.getElementById('search_product_ara').value="";
		}

		var obj;
		/* 20050523 CFMX7 geciste cf in kendi degiskenini kullaniyoruz
		var _CF_ERROR = 0; */
		var _CF_error_exists = false;
		function waitForDisableAction(el){
		 	obj = el;
			setTimeout("disableAction()",10);
			return true;
		}
		function disableAction(){
			if(!_CF_error_exists)
				{
				obj.value="<cfoutput>#getLang('main',293)#</cfoutput>";
				obj.disabled = true;
				}
			return true;
		}
	</script>
