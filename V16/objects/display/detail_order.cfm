<cfset toplam_indirim_miktari = 0 >
<cfinclude template="../query/get_order_det.cfm">
<cfinclude template="../../stock/query/get_priorities.cfm">
<cfoutput>
<cfsavecontent variable="message"><cf_get_lang dictionary_id='58211.Sipariş No'></cfsavecontent>
<cf_popup_box title='#message# : #get_sale_det.order_number#'>
	<table>
		<tr>
			<td width="120" class="txtbold"><cf_get_lang dictionary_id='57519.Cari Hesap'></td>
			<td width="220">
				<cfif len(get_sale_det.partner_id)>
					#get_par_info(get_sale_det.partner_id,0,0,1)#
				<cfelseif len(get_sale_det.consumer_id)>
					#get_cons_info(get_sale_det.consumer_id,0,1)#
				</cfif>
			</td>
			<td class="txtbold" width="90"><cf_get_lang dictionary_id='57645.Teslim Tarihi'></td>
			<td width="150">#dateformat(get_sale_det.deliverdate,dateformat_style)#</td>
			<td class="txtbold" width="90"><cf_get_lang dictionary_id='57756.Durum'></td>
			<td width="140"><cf_get_lang dictionary_id='57544.Sorumlu'> -
				<cfif get_sale_det.order_status eq 0>
					<cf_get_lang dictionary_id='45325.Gündemde Değil'>
				<cfelse>
					<cf_get_lang dictionary_id='45326.Gündemde'>
				</cfif>
			</td>
		</tr>
	<tr>
	<tr>
		<td class="txtbold"><cf_get_lang dictionary_id='58211.Sipariş No'></td>
		<td>
			<cfif get_module_user(11) and len(get_sale_det.order_id) and get_sale_det.purchase_sales eq 1>
				<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=sales.list_order&event=upd&order_id=#get_sale_det.order_id#','wwide');" class="tableyazi">#get_sale_det.order_number#</a>
			<cfelseif get_module_user(12) and len(get_sale_det.order_id) and get_sale_det.purchase_sales eq 0>
				<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=purchase.list_order&event=upd&order_id=#get_sale_det.order_id#','wwide');" class="tableyazi">#get_sale_det.order_number#</a>
			<cfelse>
				#get_sale_det.order_number#	
			</cfif>
		</td>
		<td class="txtbold"><cf_get_lang dictionary_id='58449.Teslim Yeri'></td>
		<td>#get_sale_det.ship_address#</td>
		<td class="txtbold" width="90"><cf_get_lang dictionary_id='57485.öncelik'></td>
		<td>
			<cfloop from="1" to="#get_priorities.recordcount#" index="i">
				<cfif get_priorities.priority_id[i] eq get_sale_det.priority_id>
					<cfoutput>#get_priorities.priority[i]#</cfoutput>
				</cfif>
			</cfloop>
		</td>
	</tr>
	<tr>
		<td class="txtbold"><cf_get_lang dictionary_id='58212.Teklif No'></td>
		<td>
			<cfif len(get_sale_det.offer_id)>
				<cfset attributes.offer_id = get_sale_det.offer_id>
				<cfinclude template="../../stock/query/get_offer_head.cfm">
				#get_offer_head.offer_id#
			</cfif>
		</td>
		<td class="txtbold"><cf_get_lang dictionary_id='29500.Sevk'></td>
		<td>
			<cfif len(get_sale_det.SHIP_METHOD)>
				#get_method.ship_method#
			</cfif>
		</td>
		<td class="txtbold"><cf_get_lang dictionary_id ='34125.Satışı Yapan'></td>
		<td>#get_emp_info(get_sale_det.order_employee_id,0,0,0)#</td>
	</tr>
	<tr>
		<td class="txtbold"><cf_get_lang dictionary_id='58516.Ödeme Yöntemi'></td>
		<td>
			<cfif len(get_sale_det.PAYMETHOD)>
				#get_method2.paymethod#
			<cfelseif len(get_sale_det.CARD_PAYMETHOD_ID)>
				#get_method_card.CARD_NO#
			</cfif>
		</td>
		<td class="txtbold"><cf_get_lang dictionary_id='58851.Ödeme Tarihi'></td>
		<td>
			<cfif len(get_sale_det.DUE_DATE)>
				#dateformat(get_sale_det.due_date,dateformat_style)#
			</cfif>
		</td>
		<td class="txtbold"><cf_get_lang dictionary_id='58763.Depo'></td>
		<td>
			<cfif len(GET_SALE_DET.DELIVER_DEPT_ID)>
				#get_store.department_head#
			</cfif>
		</td>
	</tr>
	<tr>
		<td class="txtbold" valign="top"><cf_get_lang dictionary_id='58723.Adres'></td>
		<td valign="top">
			<cfif not isdefined("comp")><!--- Bireysel Uye Fatura Adr. --->
				#get_cons_name.tax_adress# #get_cons_name.tax_semt# #get_cons_name.tax_postcode#<br/>
				<cfif len(get_cons_name.tax_county_id)>
					<cfquery name="GET_COUNTY" datasource="#DSN#">
						SELECT COUNTY_NAME FROM SETUP_COUNTY WHERE COUNTY_ID = #get_cons_name.tax_county_id#
					</cfquery>
					#get_county.county_name#			  
				</cfif>
				<cfif len(get_cons_name.tax_city_id)>
					<cfquery name="GET_CITY" datasource="#DSN#">
						SELECT CITY_NAME FROM SETUP_CITY WHERE CITY_ID = #get_cons_name.tax_city_id#
					</cfquery>
					#get_city.city_name#
				</cfif>
				<cfif len(get_cons_name.tax_country_id)>
					<cfquery name="GET_COUNTRY" datasource="#DSN#">
						SELECT COUNTRY_NAME FROM SETUP_COUNTRY WHERE COUNTRY_ID =  #get_cons_name.tax_country_id#
					</cfquery>					  
					#get_country.country_name#
				</cfif>
			<cfelse><!--- Kurumsal Uye Adr. --->
				#get_sale_det_comp.company_address# #get_sale_det_comp.semt# #get_sale_det_comp.company_postcode#<br/>
				<cfif len(get_sale_det_comp.county)>
					<cfquery name="GET_COUNTY" datasource="#DSN#">
						SELECT COUNTY_NAME FROM SETUP_COUNTY WHERE COUNTY_ID = #get_sale_det_comp.county#
					</cfquery>
					#get_county.county_name#			  
				</cfif>
				<cfif len(get_sale_det_comp.city)>
					<cfquery name="GET_CITY" datasource="#DSN#">
						SELECT CITY_NAME FROM SETUP_CITY WHERE CITY_ID = #get_sale_det_comp.city#
					</cfquery>
					#get_city.city_name#
				</cfif>
				<cfif len(get_sale_det_comp.country)>
					<cfquery name="GET_COUNTRY" datasource="#DSN#">
						SELECT COUNTRY_NAME FROM SETUP_COUNTRY WHERE COUNTRY_ID =  #get_sale_det_comp.country#
					</cfquery>					  
					#get_country.country_name#
				</cfif>
			</cfif>				  
		</td>
		<td class="txtbold" valign="top"><cf_get_lang dictionary_id='57629.Açıklama'></td>
		<td valign="top">#get_sale_det.order_detail#&nbsp;</td>
		<td class="txtbold" valign="top"><cf_get_lang dictionary_id='57416.Proje'></td>
		<td valign="top"><cfif len(GET_SALE_DET.project_id)>#GET_PROJECT_NAME(GET_SALE_DET.project_id)#</cfif></td>
	</tr>
	</table>
	<br/>
	<br/>
	<cf_medium_list>
	<thead>
		<tr>
			<th><cf_get_lang dictionary_id='57629.Açıklama'></th>
			<th style="text-align:right;"><cf_get_lang dictionary_id='57635.Miktar'></th>
			<th><cf_get_lang dictionary_id='57636.Birim'></th>
			<th style="text-align:right;"><cf_get_lang dictionary_id='57638.B Fiyat'></th>
			<th style="text-align:right;"><cf_get_lang dictionary_id='57639.KDV'></th>
			<th style="text-align:right;"><cf_get_lang dictionary_id='57641.İndirim'><cf_get_lang dictionary_id='57492.Toplam'></th> 
			<th style="text-align:right;"><cf_get_lang dictionary_id='57492.Toplam'></th>
			<th style="text-align:right;"><cf_get_lang dictionary_id='57677.Döviz'></th> 
			<th style="text-align:right;"><cf_get_lang dictionary_id='57642.N Toplam'></th>
		</tr>
	</thead>
	<tbody>
		<cfinclude template="../query/show_order_basket.cfm">
		<cfset toplam_indirim_miktari=0>
		<cfset list_kdv = ListSort(list_kdv,"textnocase", "asc")>
		<cfloop from="1" to="#arraylen(invoice_bill_upd)#" index="i">
			<tr class="color-row">
				<td nowrap>#invoice_bill_upd[i][2]#
					<cfif get_module_user(5)>
						<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_detail_product&pid=#invoice_bill_upd[i][1]#&sid=#invoice_bill_upd[i][10]#<cfif isdefined("attributes.is_store_module")>&is_store_module=1</cfif>','medium');"><img src="/images/plus_thin.gif" title="<cf_get_lang dictionary_id='58764.Ürün Detayları'>" border="0" align="absmiddle"></a>
						<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_std_sale&price_type=purc&pid=#invoice_bill_upd[i][1]#','list');"><img src="/images/plus_thin_p.gif" title="<cf_get_lang dictionary_id ='57721.Ürün Fiyat Tarihçe'>" border="0" align="absmiddle"></a>
					</cfif>
				</td>
				<td style="text-align:right;">#invoice_bill_upd[i][4]#</td>
				<td>#invoice_bill_upd[i][5]#</td>
				<td style="text-align:right;">#TLFormat(invoice_bill_upd[i][6],4)#</td>
				<td style="text-align:right;">#invoice_bill_upd[i][7]#</td>
				<td style="text-align:right;">
					#TLFormat(invoice_bill_upd[i][8])#
					<cfif not len(invoice_bill_upd[i][8])><cfset invoice_bill_upd[i][8]=0></cfif>
					<cfset toplam_indirim_miktari = toplam_indirim_miktari+invoice_bill_upd[i][8]>
				</td>
				<td style="text-align:right;">#TLFormat(invoice_bill_upd[i][15])#</td>
				<td style="text-align:right;">#TLFormat(invoice_bill_upd[i][30])#&nbsp;<cfif len(session.ep.money2)>#invoice_bill_upd[i][31]#</cfif></td>
				<td style="text-align:right;">#TLFormat(invoice_bill_upd[i][16])#</td>
			</tr>
		</cfloop>
	</tbody>
	</cf_medium_list>
	<br/>
	<br/>
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td width="55%" style="text-align:right;">
				<cfloop query="GET_MONEY_INFO_SEC">
					<cfif GET_SALE_DET.OTHER_MONEY eq MONEY_TYPE><font color="##FF0033"><cfelse><font color="##000000"></cfif>#MONEY_TYPE#&nbsp;&nbsp;&nbsp;&nbsp;1&nbsp;/&nbsp;&nbsp;#TLFormat(RATE2,session.ep.our_company_info.rate_round_num)#</font><br/>
				</cfloop>
			</td>
			<td width="45%" style="text-align:right;">
				<table border="0">
					<tr>
						<td></td>
						<td class="txtbold" width="100"><cf_get_lang dictionary_id='57492.Toplam'></td>
						<td width="100" style="text-align:right;">&nbsp;#TLFormat(get_sale_det.grosstotal)#</td>
						<td width="80" style="text-align:right;">
							&nbsp;&nbsp;#TLFormat(get_sale_det.grosstotal/GET_MONEY_INFO.rate2)#
						</td>
					</tr>
					<tr>
						<cfif not len(get_sale_det.SA_DISCOUNT)><cfset get_sale_det.SA_DISCOUNT = 0></cfif>
						<td></td>
						<td class="txtbold" width="100"><cf_get_lang dictionary_id='57649.Toplam İndirim'></td>
						<td width="100" style="text-align:right;">&nbsp;#TLFormat(toplam_indirim_miktari+get_sale_det.SA_DISCOUNT)#</td>
						<td width="80" style="text-align:right;">
						<cfset doviz_indirim = (toplam_indirim_miktari+get_sale_det.SA_DISCOUNT)/GET_MONEY_INFO.RATE2>
						&nbsp;&nbsp;&nbsp;&nbsp;#TLFormat(doviz_indirim)#
						</td>
					</tr>					  
					<tr>
						<td></td>
						<td class="txtbold" width="100"><cf_get_lang dictionary_id='58765.Satıraltı İndirim'></td>
						<td style="text-align:right;">&nbsp;#TLFormat(get_sale_det.SA_DISCOUNT)#</td>
						<td></td>
					</tr>
					<cfif (GET_SALE_DET.NETTOTAL-GET_SALE_DET.TAXTOTAL+GET_SALE_DET.SA_DISCOUNT) neq 0>
						<cfset kdvcarpan = 1-(GET_SALE_DET.SA_DISCOUNT/(GET_SALE_DET.NETTOTAL-GET_SALE_DET.TAXTOTAL+GET_SALE_DET.SA_DISCOUNT))>
					<cfelse>
						<cfset kdvcarpan = 1>
					</cfif>
					<cfloop from="1" to="#arraylen(sepet.kdv_array)#" index="m">
						<tr>
							<td></td>
							<td class="txtbold"><cf_get_lang dictionary_id='57639.KDV'> % #sepet.kdv_array[m][1]#</td>
							<td style="text-align:right;">&nbsp;#TLFormat(sepet.kdv_array[m][2]*kdvcarpan)#</td>
							<td></td>
						</tr>						 
					</cfloop>
					<tr>
						<td></td>
						<td class="txtbold"><cf_get_lang dictionary_id='57643.Toplam KDV'></td>
						<td style="text-align:right;">&nbsp;#TLFormat(get_sale_det.taxtotal)#</td>
						<td width="80" style="text-align:right;">
						<cfset doviz_toplamkdv = get_sale_det.taxtotal/GET_MONEY_INFO.RATE2>
						&nbsp;&nbsp;&nbsp;&nbsp;#TLFormat(doviz_toplamkdv)#
						</td>
					</tr>
					<tr>
						<td></td>
						<td class="txtbold"><cf_get_lang dictionary_id='58213.Toplam ÖTV'></td>
						<td style="text-align:right;">&nbsp;<cfif not len(get_sale_det.otv_total)><cfset otv_total_ = 0><cfelse><cfset otv_total_ = get_sale_det.otv_total></cfif>#TLFormat(otv_total_)#</td>
						<td width="80" style="text-align:right;">
						<cfset doviz_toplamotv = otv_total_/GET_MONEY_INFO.RATE2>
						&nbsp;&nbsp;&nbsp;&nbsp;#TLFormat(doviz_toplamotv)#
						</td>
					</tr>
					<tr>
						<td></td>
						<td class="txtbold"><cf_get_lang dictionary_id='57680.Genel Toplam'></td>
						<td style="text-align:right;">&nbsp;#TLFormat(get_sale_det.nettotal)#</td>
						<td width="80" style="text-align:right;">
						<cfset doviz_tutar = get_sale_det.nettotal/GET_MONEY_INFO.RATE2>
						&nbsp;&nbsp;#TLFormat(doviz_tutar)#
						</td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
</cf_popup_box>
</cfoutput>
