﻿<!--- 
	/* Popup Basket Sayfasinda acilan Ürün Fiyati secme popup sayfasi*/
	// Yazan       : Arzu BT
	// Tarih       : 05/12/2003
	// Güncelleyen : FS
	// Günc.Tarihi : 20080408
	// Amaç        : Basketlerde ki ürün fiyatini degistirebilmeyi saglamak
	// Js : Javascript versiyonu uyarlayan Ergün KOÇAK 20040209
--->
<cf_xml_page_edit fuseact="objects.popup_product_price_history_js,objects.popup_product_price_history_public_js">

	<cfif isdefined("x_control_ims") and x_control_ims eq 1 and session.ep.our_company_info.sales_zone_followup eq 1>
		<cfinclude template="../../member/query/get_ims_control.cfm">
	</cfif>
	
	<cfinclude template="../query/get_rival_prices.cfm">
	<cfinclude template="../query/get_product_price_sales.cfm">
	<cfquery name="GET_COMPETITIVE_LIST" datasource="#DSN3#">
		SELECT
			PRP.COMPETITIVE_ID
		FROM
			PRODUCT_COMP_PERM PRP,
			PRODUCT P 
		WHERE
			PRP.COMPETITIVE_ID=P.PROD_COMPETITIVE AND 
			PRP.POSITION_CODE = #session.ep.position_code# AND
			P.PRODUCT_ID= #attributes.product_id# 
	</cfquery>
	
	<cfif isdefined("session.ep.money")>
		<cfset money_value = session.ep.money>
	<cfelseif isdefined("session.pp.money")>
		<cfset money_value = session.pp.money>
	</cfif>
	<cfform name="list_price_history">
		<cf_box title="#getLang('','Fiyat Detay',33016)# #get_product_name(attributes.pid)# - (#attributes.unit#)" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
			  <!--- Ürün Bilgileri --->
			<cfinclude template="../query/get_product_prices_sa_ss.cfm">
			  <cf_grid_list>
				<thead>
					<tr> 
						<th width="150"><cf_get_lang dictionary_id='57509.Liste'></th>
						<th class="text-right"><cf_get_lang dictionary_id='58084.Fiyat'></th>
						<th class="text-right"><cf_get_lang dictionary_id='58716.KDV li'><cf_get_lang dictionary_id='58084.Fiyat'></th>
						<th width="130"> <cf_get_lang dictionary_id='33021.Marj'>(<cf_get_lang dictionary_id='33023.Son Alışa Göre'>)</th>
						<th width="20" class="text-right">
							<cfif get_competitive_list.recordcount>
								<cfset str_url_open = "product.popup_form_add_product_price&pid=#attributes.product_id#" >
							<cfelse>
								<cfset str_url_open = "product.popup_add_price_request&pid=#attributes.product_id#" >
							</cfif>
							<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=#str_url_open#</cfoutput>','page');">
								<img src="/images/plus_list.gif" border="0" title="<cf_get_lang dictionary_id='37124.Fiyat Ekle'>">
							</a> 
						</th>				 			 
					</tr>
				</thead>
				<tbody>
					  <cfoutput>
						<cfif get_module_user(5)>
							<tr>
								<td><cf_get_lang dictionary_id='58722.Standart Alış'></td>
	
								<td class="text-right"><a href="##" onClick="set_opener_money('#get_price_sa.price#', '#get_price_sa.money#')" class="tableyazi">#TLFormat(get_price_sa.price,session.ep.our_company_info.purchase_price_round_num)#&nbsp;#get_price_sa.money#</a></td>
								<td class="text-right">#TLFormat(get_price_sa.price_kdv,session.ep.our_company_info.purchase_price_round_num)#&nbsp;#get_price_sa.money#</td>
								<td>&nbsp;</td><td>&nbsp;</td>
							</tr>
							<tr>
								<td><cf_get_lang dictionary_id='58721.Standart Satış'></td>
								<td class="text-right"><a href="##" onClick="set_opener_money('#get_price_ss.price#', '#get_price_ss.money#')" class="tableyazi">#TLFormat(get_price_ss.price,session.ep.our_company_info.sales_price_round_num)# #get_price_ss.money#</a></td>
								<td class="text-right"><!--- <a href="##" onClick="set_opener_money('#get_price_ss.price_kdv#', '#get_price_ss.money#')" class="tableyazi"> --->#TLFormat(get_price_ss.price_kdv,session.ep.our_company_info.sales_price_round_num)# #get_price_ss.money#<!--- </a> ---></td>
								<td>&nbsp;</td><td>&nbsp;</td>
							</tr>
						</cfif>
					</cfoutput>
					<cfquery name="get_pur_price" datasource="#DSN2#" maxrows="1">
						SELECT
							INVOICE_ROW.PRICE
						FROM 
							INVOICE_ROW,
							INVOICE 
						WHERE
							INVOICE_ROW.INVOICE_ID = INVOICE.INVOICE_ID AND
							INVOICE_ROW.STOCK_ID = #attributes.stock_id# AND
							INVOICE.PURCHASE_SALES = 0 
						ORDER BY
							INVOICE.INVOICE_DATE DESC 
					</cfquery>
					<cfif isDefined("xml_price_list_max_rows") And Len(xml_price_list_max_rows) And isNumeric(xml_price_list_max_rows)>
						<cfset list_max_rows = xml_price_list_max_rows />
					<cfelse>
						<cfset list_max_rows = 10 />
					</cfif>
					<cfoutput query="GET_PRODUCT_PRICE" maxrows="#list_max_rows#">
						<tr>
							<td>#price_cat#</td>
							<td class="text-right"><a href="##" onClick="set_opener_money('#price#', '#money#')" class="tableyazi">#TLFormat(price,session.ep.our_company_info.sales_price_round_num)#&nbsp;#money#</a></td>
							<td class="text-right">#TLFormat(price_kdv,session.ep.our_company_info.sales_price_round_num)#&nbsp;#money#</td>
							<td><cfif isnumeric(get_pur_price.PRICE) and isnumeric(PRICE) and (get_pur_price.PRICE neq 0)>
									%
									<cfif money neq money_value>
										<cfif session.ep.period_year gte 2009 and money is 'YTL'>
											<cfset attributes.YTL = 1>
										<cfelseif session.ep.period_year lt 2009 and money is 'TL'>
											<cfset attributes.TL = 1>
										</cfif>
										#TLFormat((((PRICE*evaluate("attributes.#money#"))-get_pur_price.PRICE)/get_pur_price.PRICE)*100,session.ep.our_company_info.sales_price_round_num)# 
									<cfelse>
											#TLFormat(((PRICE-get_pur_price.PRICE)/get_pur_price.PRICE)*100,session.ep.our_company_info.sales_price_round_num)# 
									</cfif>
								</cfif>
							</td>
							<td>&nbsp;</td>
						</tr>
					</cfoutput> 
				  </tbody>
			</cf_grid_list>
		</cf_box>
		<cfif isdefined("attributes.company_id") or isdefined("attributes.consumer_id")>
			<cf_box title="#getLang('','Müşteri Satış Fiyatları',33022)#">
				<cfquery name="GET_COMP_PRICES" datasource="#DSN2#">
					SELECT
						IR.PRICE,
						IR.PRICE_OTHER, 
						I.INVOICE_DATE,
						I.COMPANY_ID,
						I.SALE_EMP,
						I.CONSUMER_ID,
						IR.UNIT,
						IR.OTHER_MONEY
					FROM
						INVOICE I,
						INVOICE_ROW IR
					WHERE
						I.INVOICE_ID = IR.INVOICE_ID AND
						I.INVOICE_CAT NOT IN (54,55,62) AND <!--- 49,51,54,55,59,60,601,62,63 --->
						IR.STOCK_ID = #attributes.stock_id#
					<cfif isdefined("attributes.company_id") and len(attributes.company_id)>
						AND I.COMPANY_ID = #attributes.company_id#
					<cfelseif  isdefined("attributes.consumer_id") and len(attributes.consumer_id)>
						AND I.CONSUMER_ID = #attributes.consumer_id#
					<cfelse>
						AND 1=0
					</cfif>
					<cfif isdefined("x_control_ims") and x_control_ims eq 1 and session.ep.our_company_info.sales_zone_followup eq 1>
						AND
							(
							(I.CONSUMER_ID IS NULL AND I.COMPANY_ID IS NULL) 
							OR (I.COMPANY_ID IN (#PreserveSingleQuotes(my_ims_comp_list)#))
							OR (I.CONSUMER_ID IN (#PreserveSingleQuotes(my_ims_cons_list)#))
							)
					</cfif>
					ORDER BY
					I.INVOICE_DATE DESC
				</cfquery> 
				<cf_grid_list>
					<thead>
						<tr> 
							<th width="150"><cf_get_lang dictionary_id='33008.satış yapan'></th>
							<th><cf_get_lang dictionary_id='58084.Fiyat'></th>                
							<th width="65"><cf_get_lang dictionary_id='57742.Tarih'></th>
						</tr>
					</thead>
					<tbody>
						<cfoutput query="GET_COMP_PRICES" maxrows="10">
							<tr>
								<td><cfif len(sale_emp)>#get_emp_info(sale_emp,0,1)#</cfif></td>
								<td class="text-right">
									<a href="##" onClick="set_opener_money('#price_other#', '#other_money#')" class="tableyazi">#TLFormat(price_other,session.ep.our_company_info.sales_price_round_num)#&nbsp;#other_money#</a></td>
								<td>#dateformat(invoice_date,dateformat_style)#</td>						
							</tr>
						</cfoutput> 
					</tbody>
				</cf_grid_list>
			</cf_box>
		</cfif>
		<cf_box title="#getLang('','Son Satış Fiyatları',33018)#">
			<cf_grid_list>
				<thead>
					<tr> 
						<th width="150"><cf_get_lang dictionary_id='33008.satış yapan'></th>
						<th width="150"><cf_get_lang dictionary_id='57800.İşlem Tipi'></th>
						<th width="150"><cf_get_lang dictionary_id='57519.Cari Hesap'></th>
						<th width="90" class="text-right"><cf_get_lang dictionary_id='57635.Miktar'></th>
						<th width="90" class="text-right"><cf_get_lang dictionary_id='58084.Fiyat'></th>
						<th width="90" class="text-right"><cf_get_lang dictionary_id='57796.Dövizli'> <cf_get_lang dictionary_id='58084.Fiyat'></th>
						<th class="text-right"><cf_get_lang dictionary_id='33030.İndirimli Fiyat'></th>
						<th width="65"><cf_get_lang dictionary_id='57742.Tarih'></th>				
					</tr>
				</thead>
				<tbody>
					<cfinclude template="../query/get_sale_cost.cfm">
					<cfoutput query="get_sale_cost" maxrows="10">
						<tr>
						<td><cfif len(sale_emp)>#get_emp_info(sale_emp,0,1)#</cfif></td>
						<td><a class="tableyazi" href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_detail_invoice&ID=#INVOICE_ID#','medium');">#PROCESS_CAT#</a></td>
						<td><cfif len(COMPANY_ID)>#get_par_info(member_id:COMPANY_ID,company_or_partner:1,with_link:1,with_company_partner:1)#<cfelse>#get_cons_info(CONSUMER_ID,1,1)#</cfif></td>
							<td class="text-right">#amount#</td>
							<td class="text-right"><a href="##" onClick="set_opener_money('#price#', '#money_value#')" class="tableyazi">#TLFormat(PRICE,session.ep.our_company_info.sales_price_round_num)#&nbsp;#money_value#</a></td>
							<td class="text-right">
							<cfif len(OTHER_MONEY) and len(PRICE_OTHER)>
								#TLFormat(PRICE_OTHER,session.ep.our_company_info.sales_price_round_num)#&nbsp;#OTHER_MONEY#
							</cfif>
							</td>
							<cfscript>
								indirimli_satis_fiyat = PRICE;
								indirim1 = DISCOUNT1;
								indirim2 = DISCOUNT2;
								indirim3 = DISCOUNT3;
								indirim4 = DISCOUNT4;
								indirim5 = DISCOUNT5;
								if (not len(indirim1)){indirim1 = 0;}
								if (not len(indirim2)){indirim2 = 0;}
								if (not len(indirim3)){indirim3 = 0;}
								if (not len(indirim4)){indirim4 = 0;}
								if (not len(indirim5)){indirim5 = 0;}
								indirimli_satis_fiyat = indirimli_satis_fiyat*(100-indirim1)/100;
								indirimli_satis_fiyat = indirimli_satis_fiyat*(100-indirim2)/100;
								indirimli_satis_fiyat = indirimli_satis_fiyat*(100-indirim3)/100;
								indirimli_satis_fiyat = indirimli_satis_fiyat*(100-indirim4)/100;
								indirimli_satis_fiyat = indirimli_satis_fiyat*(100-indirim5)/100;
							</cfscript>
							<td class="text-right">#TLFormat(indirimli_satis_fiyat,session.ep.our_company_info.sales_price_round_num)#&nbsp;#money_value#</td>
							<td>#dateformat(INVOICE_DATE,dateformat_style)#</td> 
						</tr>
					</cfoutput>
				</tbody>
			</cf_grid_list>
		</cf_box>
		<cfif get_module_user(5)>
			<cf_box title="#getLang('','Son Alış Fiyatı',32531)#">
				<cf_grid_list>
					<thead>
						<tr> 
							<th width="150"><cf_get_lang dictionary_id='57519.Cari Hesap'></th>
							<th width="150"><cf_get_lang dictionary_id='57800.İşlem Tipi'></th>
							<th width="150" class="text-right"><cf_get_lang dictionary_id='58084.Fiyat'></th>
							<th width="150" class="text-right"><cf_get_lang dictionary_id='57796.Dövizli'> <cf_get_lang dictionary_id='58084.Fiyat'></th>
							<th class="text-right"><cf_get_lang dictionary_id='33030.İndirimli Fiyat'></th>
							<th width="65"><cf_get_lang dictionary_id='57742.Tarih'></th>
						</tr>
					</thead>
					<tbody>
						<cfinclude template="../query/get_purchase_cost.cfm">
						<cfoutput query="get_purchase_cost" maxrows="10">
						<tr>
							<td><cfif len(COMPANY_ID)>#get_par_info(member_id:COMPANY_ID,company_or_partner:1,with_link:1,with_company_partner:1)#<cfelse>#get_cons_info(consumer_id:CONSUMER_ID,with_company:1,with_link:1)#</cfif></td>
							<td><a class="tableyazi" href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_detail_invoice&ID=#INVOICE_ID#','medium');">#PROCESS_CAT#</a></td>
							<td class="text-right"><a href="##" onClick="set_opener_money('#GET_PURCHASE_COST.price#', '#money_value#')" class="tableyazi">#TLFormat(get_purchase_cost.price,session.ep.our_company_info.purchase_price_round_num)#&nbsp;#money_value#</a></td>
							<td class="text-right">
							<cfif len(OTHER_MONEY) and len(PRICE_OTHER)>
								#TLFormat(PRICE_OTHER,session.ep.our_company_info.sales_price_round_num)#&nbsp;#OTHER_MONEY#
							</cfif>
							</td>
							<cfscript>
								indirimli_alis_fiyat = PRICE;
								indirim1 = DISCOUNT1;
								indirim2 = DISCOUNT2;
								indirim3 = DISCOUNT3;
								indirim4 = DISCOUNT4;
								indirim5 = DISCOUNT5;
								if (not len(indirim1)){indirim1 = 0;}
								if (not len(indirim2)){indirim2 = 0;}
								if (not len(indirim3)){indirim3 = 0;}
								if (not len(indirim4)){indirim4 = 0;}
								if (not len(indirim5)){indirim5 = 0;}
								indirimli_alis_fiyat = indirimli_alis_fiyat*(100-indirim1)/100;
								indirimli_alis_fiyat = indirimli_alis_fiyat*(100-indirim2)/100;
								indirimli_alis_fiyat = indirimli_alis_fiyat*(100-indirim3)/100;
								indirimli_alis_fiyat = indirimli_alis_fiyat*(100-indirim4)/100;
								indirimli_alis_fiyat = indirimli_alis_fiyat*(100-indirim5)/100;
							</cfscript>
							<td class="text-right">#TLFormat(indirimli_alis_fiyat,session.ep.our_company_info.purchase_price_round_num)#&nbsp;#money_value#</td>
							<td>#dateformat(GET_PURCHASE_COST.INVOICE_DATE,dateformat_style)#</td>						
						</tr>
						</cfoutput>
					</tbody>
				</cf_grid_list>
			</cf_box>
		</cfif>
		<cf_box title="#getLang('','Rakip Fiyatlar',32089)#">
			<cf_grid_list>
				<thead>
					<tr> 
						<th width="150"><cf_get_lang dictionary_id='58779.Rakip'></th>                
						<th class="text-right"><cf_get_lang dictionary_id='58084.Fiyat'></th>
					</tr>
				</thead>
				<tbody>
					<cfoutput query="GET_RIVAL_PRICES" maxrows="10">
						<tr>
							<td height="20">#RIVAL_NAME#</td>                
							<td class="text-right"><a href="##" onClick="set_opener_money('#price#', '#money#')" class="tableyazi">#TLFormat(PRICE,session.ep.our_company_info.sales_price_round_num)#&nbsp;#MONEY#</a></td>
						</tr>
					</cfoutput> 
				</tbody>
			</cf_grid_list>
		</cf_box>
		<cf_box title="#getLang('','Seri No Fiyatları',32427)#">
			<cf_box_search>
				<div class="form-group">
					<input type="text" name="serial_no" id="serial_no" onkeydown="if(event.keyCode == 13) {find_serial_no();return false;}" />
				</div>
				<div class="form-group">
					<cf_wrk_search_button search_function='find_serial_no()' is_excel='0' button_type="4">
				</div>
			</cf_box_search>
			<div id="serial_no_price"></div>
		</cf_box>
	</cfform>
	<script type="text/javascript">
	  $(document).ready(function(){
		find_serial_no();
	  });
	function set_opener_money(fiyat, kur)
	{
		<cfif not isdefined("attributes.is_from_product")>
		if(kur == 'TL'){
			//window.opener.basket.items[<cfoutput>#attributes.row_id#</cfoutput>].PRICE = parseFloat(fiyat);
			//window.opener.basket.items[<cfoutput>#attributes.row_id#</cfoutput>].OTHER_MONEY = kur;
			//window.opener.showBasketItems();
			//window.opener.hesapla('price',<cfoutput>#attributes.row_id#</cfoutput>);
			window.opener.updateBasketItemFromPopup(<cfoutput>#attributes.row_id#</cfoutput>,
				{
					PRICE : parseFloat(fiyat),
					OTHER_MONEY: 'TL'
				}
			);
			window.opener.hesapla('price',<cfoutput>#attributes.row_id#</cfoutput>);
		}
		else{
			//window.opener.basket.items[<cfoutput>#attributes.row_id#</cfoutput>].PRICE_OTHER = parseFloat(fiyat);
			//window.opener.basket.items[<cfoutput>#attributes.row_id#</cfoutput>].OTHER_MONEY = kur;
			//window.opener.showBasketItems();
			//window.opener.hesapla('other_money',<cfoutput>#attributes.row_id#</cfoutput>);
			//window.opener.hesapla('price',<cfoutput>#attributes.row_id#</cfoutput>);
			window.opener.updateBasketItemFromPopup(<cfoutput>#attributes.row_id#</cfoutput>,
				{
					PRICE_OTHER : parseFloat(fiyat),
					OTHER_MONEY: kur
				}
			);
			window.opener.hesapla('price_other',<cfoutput>#attributes.row_id#</cfoutput>);
		}
		<cfelse><!--- Karma koli detayından geliyorsa --->
			temp_price_round_ ='<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>';
			new_row = '<cfoutput>#attributes.row_no#</cfoutput>';
			for (i=0; i < opener.moneyArray.length; i++)
				if (opener.moneyArray[i] == kur)
				{
					if(opener.rate1Array[i] == opener.rate2Array[i] && opener.rate1Array[i] == 1)
					{/*default para birimi*/
						eval("window.opener.form_basket.list_price"+new_row).value = commaSplit(fiyat,temp_price_round_);
						eval("window.opener.form_basket.s_price"+new_row).value = commaSplit(fiyat,temp_price_round_);
						eval("window.opener.form_basket.other_list_price"+new_row).value = commaSplit(fiyat,temp_price_round_);
						eval("window.opener.form_basket.money"+new_row).value = kur+';'+1;
					}
					else
					{
						rate2 = opener.rate2Array[i];
						eval("window.opener.form_basket.list_price"+new_row).value = commaSplit((fiyat / opener.rate1Array[i]) * opener.rate2Array[i],temp_price_round_);
						eval("window.opener.form_basket.s_price"+new_row).value = commaSplit((fiyat / opener.rate1Array[i]) * opener.rate2Array[i],temp_price_round_);
						eval("window.opener.form_basket.other_list_price"+new_row).value = commaSplit(fiyat,temp_price_round_);
						eval("window.opener.form_basket.money"+new_row).value = kur+';'+rate2;
					}
					opener.calculate_amount(new_row);
				}
		</cfif>
		window.close();
	}
	function find_serial_no()
	{
		if(document.getElementById('serial_no').value == "")
		{
			
			var serial_no_ = "";
			var stock_id_ = "<cfoutput>#attributes.stock_id#</cfoutput>";
		}
		else
		{
			serial_no_ = document.getElementById('serial_no').value;
			var stock_id_ = "";
		}
			var page = '<cfoutput>#request.self#</cfoutput>?fuseaction=objects.emptypopup_get_price_from_serial_no&stock_id='+stock_id_+'&serial_no='+serial_no_;
			AjaxPageLoad(page,'serial_no_price',1);
	
	}
	</script>