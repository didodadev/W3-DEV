<!--- 
	Bu Sayfada yapilan degisiklik bu sayfada da yapilmali.
	<cfinclude template="list_product_sale_with_nolink.cfm">
--->
<cfif len(basket_prod_list.IS_SELECTED) and basket_prod_list.IS_SELECTED eq 1><!--- basket sıfır stokla calısıyorsa, listede urun stok miktarına bakılmaksızın linkli getirilir  --->
	<cfset basket_zero_stock =1>
<cfelse>
	<cfset basket_zero_stock =0>
</cfif>
<cfif not listfind("6,9",basket_prod_list.PRODUCT_SELECT_TYPE,",")>
	<cfset aranacak=products.STOCK_ID>
<cfelse>
	<cfset aranacak="#products.STOCK_ID#-#products.spect_var_id#">
</cfif>

<!--- spec popuplarinda satis olmayan lokasyonlarda gelmelii --->
<cfif isdefined('unsalable')>
	<cfset usable_stock_amount = PRODUCT_STOCK>
<cfelseif len(location_based_stock.TOTAL_STOCK[listfind(location_stock_list,aranacak)])>
	<cfset usable_stock_amount = location_based_stock.TOTAL_STOCK[listfind(location_stock_list,aranacak)]>
<cfelse>
	<cfset usable_stock_amount = 0>
</cfif>
<cfif basket_prod_list.PRODUCT_SELECT_TYPE neq 11>	
<!--- alınan siparis/rezerve miktarı gercek stoktan dusuluyor --->
	<cfif get_stock_azalan.recordcount and len(get_stock_azalan.AZALAN[listfind(azalan_stock_list,aranacak)])>
		<cfset usable_stock_amount = usable_stock_amount - get_stock_azalan.AZALAN[listfind(azalan_stock_list,aranacak)]>
	</cfif>
	<!--- verilen siparis/ beklenen miktar gercek stoga ekleniyor ---> 
	<cfif get_stock_artan.recordcount and len(get_stock_artan.ARTAN[listfind(artan_stock_list,aranacak)])>
		<cfset usable_stock_amount = usable_stock_amount + get_stock_artan.ARTAN[listfind(artan_stock_list,aranacak)]>
	</cfif> 
	<!--- üretim emri sonucu (beklenen miktar-sarf edilen miktar) farkı gerçek stoga ekleniyor --->
	<cfif get_prod_reserved.recordcount and len(get_prod_reserved.FARK[listfind(prod_reserved_list,aranacak)])>
		<cfset usable_stock_amount = usable_stock_amount + get_prod_reserved.FARK[listfind(prod_reserved_list,aranacak)]>
	</cfif>
</cfif>
<cfquery name = "GET_PRODUCT_EXP_CENTER" datasource = "#dsn3#">
	SELECT 
		EXC.EXPENSE_ID,
		EXC.EXPENSE,
		ACTIVITY_ID
	FROM
		PRODUCT_PERIOD CP
		LEFT JOIN #dsn2#.EXPENSE_CENTER EXC ON CP.EXPENSE_CENTER_ID = EXC.EXPENSE_ID
		WHERE CP.PRODUCT_ID = #PRODUCT_ID# AND PERIOD_ID = <cfqueryparam value = "#session.ep.period_id#" CFSQLType = "cf_sql_integer">
</cfquery>
<cfset expense_center_id = ( GET_PRODUCT_EXP_CENTER.recordcount ) ? GET_PRODUCT_EXP_CENTER.EXPENSE_ID : ''>
<cfset expense_center_name = ( GET_PRODUCT_EXP_CENTER.recordcount ) ? GET_PRODUCT_EXP_CENTER.EXPENSE : ''>
<cfset activity_type_id = ( GET_PRODUCT_EXP_CENTER.recordcount ) ? GET_PRODUCT_EXP_CENTER.ACTIVITY_ID : ''>
<cfoutput>
	<cfif isDefined('attributes.price_catid') and (not products.add_unit is products.main_unit) and (attributes.price_catid eq '-1')>
		<cfset pro_price = evaluate(products.price * products.multiplier)>
	</cfif>
	<cfset name_product_='#product_name# #products.property#'>
	<cfset name_product_=ReplaceNoCase(name_product_,'"','','all')>
	<cfset name_product_=ReplaceNoCase(name_product_,"'","","all")>
	<!--- satış yapılaiblir stok miktarından sipariş ve uretim icin rezerve edilenler dusulup, beklenen miktarlar ekleniyor --->
	<cfif basket_prod_list.PRODUCT_SELECT_TYPE neq 6 or not len(products.spect_var_id) or (isdefined('attributes.stok_turu') and attributes.stok_turu eq 1) or (len(products.spect_var_id) and usable_stock_amount gt 0 and products.product_stock gt 0)>
        <tr>
		<cfif isdefined('xml_is_dsp_stock_code') and xml_is_dsp_stock_code eq 1>
			<td>#stock_code#</td>
		</cfif>
		<cfif isdefined('xml_use_ozel_code') and xml_use_ozel_code eq 1>
			<td width="70">#product_code_2#</td>
		</cfif>
		<td>
			<cfif (basket_zero_stock eq 1 or usable_stock_amount gt 0 or (usable_stock_amount lte 0 and (IS_ZERO_STOCK eq 1 or (isdefined('attributes.int_basket_id') and ( (attributes.int_basket_id eq 4 and IS_PRODUCTION eq 1) or ((listfind('10,21,48',attributes.int_basket_id) or (listfind('52,53,54,55,62',sepet_process_type))) and IS_INVENTORY eq 1) ) ))) or ( listfind('110,111,112,113,114,115',sepet_process_type) and product_stock gt 0)) or IS_INVENTORY eq 0><!---20070508 sondaki or kosulu 30 gune silinsin stok fislerinde gercek stok kontrolu yapıyor --->
               <a href="##" onclick="sepete_ekle(1,'#product_id#', '#stock_id#','#stock_code#','#barcod#','#MANUFACT_CODE#','#name_product_#','#product_unit_id#','#add_unit#','#PRODUCT_CODE#',1,'#IS_SERIAL_NO#','#musteri_flag_prc_other#','#is_sale_product#','#tax#','#otv#','#musteri_flt_other_money_value#','#musteri_row_money#','#listgetat(session.ep.user_location,1,'-')#','#department_name#','#IS_INVENTORY#','#MULTIPLIER#','','','',1,'',<cfif listfind("6,9",basket_prod_list.PRODUCT_SELECT_TYPE,",")>'#SPECT_VAR_ID#'<cfelse>''</cfif>,'#IS_PRODUCTION#','#ek_tutar#','#unit_other#',<cfif isdefined('attributes.price_catid')>'#attributes.price_catid#'<cfelse>''</cfif>,<cfif basket_prod_list.PRODUCT_SELECT_TYPE eq 11>'#shelf_id#'<cfif  xml_group_shelf eq 0>,'#dateformat(DELIVER_DATE,dateformat_style)#'<cfelse>,''</cfif><cfelse>'',''</cfif>,
                '#row_due_day#','#musteri_flt_other_money_value#',<cfif isdefined('attributes.price_catid') and get_price_cat.recordcount>'#get_price_cat.number_of_installment#'<cfelse>''</cfif>,'#other_amount#','#row_price_catalog_id#','#row_due_day#','<cfif is_lot_no_based eq 1 and isdefined("PRODUCTS.LOT_NO")>#products.lot_no#</cfif>','#products.CUSTOMS_RECIPE_CODE#','#expense_center_id#','#expense_center_name#','','','#activity_type_id#','','#product_detail2#','','#OIV#');">
                <cfif not listfind("6,9",basket_prod_list.PRODUCT_SELECT_TYPE,",") or not len(SPECT_VAR_ID)>#product_name# #property#<cfelse>#SPECT_MAIN_NAME#</cfif></a>
            <cfelse>
                <cfif not listfind("6,9",basket_prod_list.PRODUCT_SELECT_TYPE,",") or not len(SPECT_VAR_ID)>#product_name# #property#<cfelse>#SPECT_MAIN_NAME#></cfif>
            </cfif>
		</td>
        <cfif (basket_prod_list.PRODUCT_SELECT_TYPE eq 13 or basket_prod_list.PRODUCT_SELECT_TYPE eq 11) and attributes.int_basket_id neq 4>
           <cfif is_lot_no_based eq 1>
                <td>#lot_no#</td>
           </cfif>
        </cfif>
		<cfif isdefined('xml_is_list_products') and xml_is_list_products eq 1>
			<td width="200">#product_detail#</td>
		</cfif>
		<cfif listfind("6",basket_prod_list.PRODUCT_SELECT_TYPE,",")>
			<td><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_detail_spec&id=#SPECT_VAR_ID#','medium');" class="tableyazi"><cfif isdefined("xml_spec_name") and xml_spec_name eq 1>#SPECT_VAR_ID#<cfelseif len(spect_var_id)>#SPECT_MAIN_NAME#</cfif></a></td>
		</cfif>
		<cfif listfind("9",basket_prod_list.PRODUCT_SELECT_TYPE,",") and len(SPECT_VAR_ID)><!--- iscilikli specli popupsa bu poptan ozellik aramalı urun popupi aciliyor --->
			<td><a href="#request.self#?fuseaction=objects.popup_products#url_str#&open_stock_popup_type=5&stock_code=#stock_code#&submit_type=1&main_spec_id=#SPECT_VAR_ID#" class="tableyazi"><cfif isdefined("xml_spec_name") and xml_spec_name eq 1>#SPECT_VAR_ID#<cfelse>#SPECT_MAIN_NAME#</cfif></a></td>
		<cfelse>
			
		</cfif>
		<cfif listfind('2,3,8,9',basket_prod_list.PRODUCT_SELECT_TYPE,',') and xml_use_manufact_code eq 1>
			<td  style="text-align:right;">#MANUFACT_CODE#</td>
		</cfif>
		<cfif listfind('8,9',basket_prod_list.PRODUCT_SELECT_TYPE,',')>
			<td  style="text-align:right;"><cfif ek_tutar neq 0>#TLFormat(ek_tutar,session.ep.our_company_info.sales_price_round_num)# #MONEY# (#work_product_unit#)</cfif></td>
		</cfif>
		<cfif isdefined('xml_dsp_prod_price') and xml_dsp_prod_price eq 1><!--- son kullanıcı fiyatı --->
            <td  nowrap style="text-align:right;">
                <cfif (basket_zero_stock eq 1 or usable_stock_amount gt 0 or (usable_stock_amount lte 0 and (products.IS_ZERO_STOCK eq 1 or (isdefined('attributes.int_basket_id') and ( (attributes.int_basket_id eq 4 and IS_PRODUCTION eq 1) or ((listfind('10,21,48',attributes.int_basket_id) or (listfind('52,53,54,55,62',sepet_process_type))) and IS_INVENTORY eq 1) ) )))  or ( listfind('110,111,112,113,114,115',sepet_process_type) and product_stock gt 0)) or IS_INVENTORY eq 0><!---20070508 sondaki or kosulu 30 gune silinsin stok fislerinde gercek stok kontrolu yapıyor --->
                    <cfif isdefined('xml_use_stock_price') and xml_use_stock_price eq 1> <!--- stok ve spec bazında fiyat secilmişse, urun fiyat detay popup ı açılmaz --->
                        <a onclick="sepete_ekle(1,'#product_id#', '#stock_id#','#stock_code#','#barcod#','#MANUFACT_CODE#','#name_product_#','#products.product_unit_id#','#products.add_unit#','#products.PRODUCT_CODE#',1,'#products.IS_SERIAL_NO#','#musteri_flag_prc_other#','#is_sale_product#','#products.tax#','#otv#','#musteri_flt_other_money_value#','#musteri_row_money#','#listgetat(session.ep.user_location,1,'-')#','#department_name#','#IS_INVENTORY#','#MULTIPLIER#','','','',1,'',<cfif listfind("6,9",basket_prod_list.PRODUCT_SELECT_TYPE,",")>'#SPECT_VAR_ID#'<cfelse>''</cfif>,'#IS_PRODUCTION#','#ek_tutar#','#unit_other#',<cfif isdefined('attributes.price_catid')>'#attributes.price_catid#'<cfelse>''</cfif>,<cfif basket_prod_list.PRODUCT_SELECT_TYPE eq 11>'#shelf_id#','#dateformat(DELIVER_DATE,dateformat_style)#'<cfelse>'',''</cfif>,
                        '#row_due_day#','#musteri_flt_other_money_value#',<cfif isdefined('attributes.price_catid') and get_price_cat.recordcount>'#get_price_cat.number_of_installment#'<cfelse>''</cfif>,'#other_amount#','#row_price_catalog_id#','#row_due_day#','<cfif is_lot_no_based eq 1 and isdefined("PRODUCTS.LOT_NO")>#products.lot_no#</cfif>','#products.CUSTOMS_RECIPE_CODE#','#expense_center_id#','#expense_center_name#','','','#activity_type_id#','','#product_detail2#','','#OIV#');" class="tableyazi">
                        <cfif isDefined("row_money") and row_money is default_money.money >
                            #TLFormat(pro_price,session.ep.our_company_info.sales_price_round_num)# #money# (#products.add_unit#)
                        <cfelse>
                            <cfset float_cur_price = pro_price*(row_money_rate2/row_money_rate1) >
                            <cfset str_money = default_money.money >
                            #TLFormat(pro_price,session.ep.our_company_info.sales_price_round_num)# #row_money# (#products.add_unit#)
                        </cfif>
                        </a>
                    <cfelse>
                        <a href="##" onclick="gonder_price_page(1,'#product_id#', '#stock_id#','#stock_code#','#barcod#','#MANUFACT_CODE#','#name_product_#','#products.product_unit_id#','#products.add_unit#','#products.PRODUCT_CODE#',1,'#musteri_flag_prc_other#','#is_sale_product#','#products.tax#','#products.otv#','#musteri_flt_other_money_value#','#musteri_row_money#','#listgetat(session.ep.user_location,1,'-')#','#department_name#','#IS_INVENTORY#','#MULTIPLIER#','','','',1,'',<cfif listfind("6,9",basket_prod_list.PRODUCT_SELECT_TYPE,",")>'#SPECT_VAR_ID#'<cfelse>''</cfif>,'#IS_PRODUCTION#','#ek_tutar#','#unit_other#',<cfif isdefined('attributes.price_catid')>'#attributes.price_catid#'<cfelse>''</cfif>,<cfif basket_prod_list.PRODUCT_SELECT_TYPE eq 11>'#shelf_id#','#dateformat(DELIVER_DATE,dateformat_style)#'<cfelse>'',''</cfif>,'#musteri_flt_other_money_value#',
                        <cfif isdefined('attributes.price_catid') and get_price_cat.recordcount>'#get_price_cat.number_of_installment#'<cfelse>''</cfif>,'#row_due_day#','#other_amount#','#row_price_catalog_id#','#row_due_day#');">
                        <cfif row_money is default_money.money >
                            #TLFormat(pro_price,session.ep.our_company_info.sales_price_round_num)# #money# (#products.add_unit#)
                        <cfelse>
                            <cfset float_cur_price = pro_price*(row_money_rate2/row_money_rate1) >
                            <cfset str_money = default_money.money >
                            #TLFormat(pro_price,session.ep.our_company_info.sales_price_round_num)# #row_money# (#products.add_unit#)
                      </cfif></a>
                    </cfif>
                <cfelse>
                    <cfif row_money is default_money.money >
                        #TLFormat(pro_price,session.ep.our_company_info.sales_price_round_num)# #money# (#products.add_unit#)
                    <cfelse>
                        <cfset float_cur_price = pro_price*(row_money_rate2/row_money_rate1) >
                        <cfset str_money = default_money.money >
                        #TLFormat(pro_price,session.ep.our_company_info.sales_price_round_num)# #row_money# (#products.add_unit#)
                  </cfif>
                </cfif>
            </td>
		</cfif>
		<td style="text-align:right; cursor:pointer">
			<cfif (basket_zero_stock eq 1 or usable_stock_amount gt 0 or (usable_stock_amount lte 0 and (products.IS_ZERO_STOCK eq 1 or (isdefined('attributes.int_basket_id') and ( (attributes.int_basket_id eq 4 and products.IS_PRODUCTION eq 1) or ((listfind('10,21,48',attributes.int_basket_id) or (listfind('52,53,54,55,62',sepet_process_type))) and products.IS_INVENTORY eq 1) ) ))))  or products.IS_INVENTORY eq 0>
                <a onclick="sepete_ekle(1,'#product_id#', '#stock_id#','#stock_code#','#barcod#','#MANUFACT_CODE#','#name_product_#','#products.product_unit_id#','#products.add_unit#','#products.PRODUCT_CODE#',1,'#products.IS_SERIAL_NO#','#musteri_flag_prc_other#','#is_sale_product#','#products.tax#','#products.otv#','#musteri_flt_other_money_value#','#musteri_row_money#','#listgetat(session.ep.user_location,1,'-')#','#department_name#','#IS_INVENTORY#','#MULTIPLIER#','','','',1,'',<cfif listfind("6,9",basket_prod_list.PRODUCT_SELECT_TYPE,",")>'#SPECT_VAR_ID#'<cfelse>''</cfif>,'#IS_PRODUCTION#','#ek_tutar#','#unit_other#',<cfif isdefined('attributes.price_catid')>'#attributes.price_catid#'<cfelse>''</cfif>,<cfif basket_prod_list.PRODUCT_SELECT_TYPE eq 11>'#shelf_id#'<cfif  xml_group_shelf eq 0>,'#dateformat(DELIVER_DATE,dateformat_style)#'<cfelse>,''</cfif><cfelse>'',''</cfif>,
                '#row_due_day#','#musteri_flt_other_money_value#',<cfif isdefined('attributes.price_catid') and get_price_cat.recordcount>'#get_price_cat.number_of_installment#'<cfelse>''</cfif>,'#other_amount#','#row_price_catalog_id#','#row_due_day#','<cfif is_lot_no_based eq 1 and isdefined("PRODUCTS.LOT_NO")>#products.lot_no#</cfif>','#products.CUSTOMS_RECIPE_CODE#','#expense_center_id#','#expense_center_name#','','','#activity_type_id#','','#product_detail2#','','#OIV#');" class="tableyazi">
                    <cfif isdefined("xml_dsp_price_kdv") and xml_dsp_price_kdv eq 1>
                        #TLFormat(musteri_flt_other_money_value_kdv,session.ep.our_company_info.sales_price_round_num)# #musteri_row_money#
                    <cfelse>	
                        #TLFormat(musteri_flt_other_money_value,session.ep.our_company_info.sales_price_round_num)# #musteri_row_money#
                </cfif>
                </a>
            <cfelse>
                <cfif isdefined("xml_dsp_price_kdv") and xml_dsp_price_kdv eq 1>
                    #TLFormat(musteri_flt_other_money_value_kdv,session.ep.our_company_info.sales_price_round_num)# #musteri_row_money#
                <cfelse>	
                    #TLFormat(musteri_flt_other_money_value,session.ep.our_company_info.sales_price_round_num)# #musteri_row_money#
              </cfif>
            </cfif>
		</td>
		<cfif basket_prod_list.PRODUCT_SELECT_TYPE eq 11>
			<cfif  xml_group_shelf eq 0>
				<td  nowrap><cfif len(DELIVER_DATE)>#dateformat(DELIVER_DATE,dateformat_style)#</cfif></td>
			</cfif>
			<td style="text-align:center" nowrap><cfif len(SHELF_ID)>#get_shelves.SHELF_CODE[listfind(shelf_code_list,SHELF_ID)]#</cfif></td>
			<td   nowrap style="cursor:pointer" onclick="open_div_sales_info(#currentrow#,#stock_id#,#product_id#)">#TLFormat(products.product_stock,0)#</td>
		</cfif>
		<cfif basket_prod_list.PRODUCT_SELECT_TYPE neq 11>
			<cfif isdefined('xml_stock_info') and xml_stock_info eq 1>
				<td style="text-align:right; cursor:pointer" onclick="open_div_sales_info(#currentrow#,#stock_id#,#product_id#)">#TLFormat(products.product_stock,0)#</td>
				<td  style="text-align:right;">#TLFormat(usable_stock_amount,0)#</td>
			</cfif>
		</cfif>
		<cfif isdefined('xml_use_other_dept_info') and listlen(xml_use_other_dept_info,'-') eq 2>
			<td  style="text-align:right;"><!--- xmlde tanımlanan 2.depoya ait stok miktarları --->
				<cfif isdefined('get_other_dept_stock_info')>
					#TLFormat(get_other_dept_stock_info.total_dept_stock_2[listfind(other_dept_stock_id_list,STOCK_ID)])#
			  </cfif>
			</td>
		</cfif>	
		<cfif isdefined('xml_use_other_dept_info_ss') and listlen(xml_use_other_dept_info_ss,'-') eq 2><!--XML'e bağlı Satılabilir Stok Miktarı Listelenecek Depo-Lokasyon ERU-->	
			<cfset getComponent = createObject('component','V16.objects.cfc.get_stock_detail')><!--- siparisler stoktan dusulecek veya eklenecekse toplamını alalım--->
			<cfset GET_STOCK_RESERVED = getComponent.GET_STOCK_RESERVED(xml_use_other_dept_info_ss : xml_use_other_dept_info_ss, product_id_list : product_id)>
			<cfset SCRAP_LOCATION_TOTAL_STOCK = getComponent.SCRAP_LOCATION_TOTAL_STOCK(xml_use_other_dept_info_ss : xml_use_other_dept_info_ss, product_id_list : product_id)>
			<cfset PRODUCT_TOTAL_STOCK = getComponent.PRODUCT_TOTAL_STOCK(xml_use_other_dept_info_ss : xml_use_other_dept_info_ss, product_id_list : product_id)>
			<cfset GET_PROD_RESERVED_ = getComponent.GET_PROD_RESERVED_(xml_use_other_dept_info_ss : xml_use_other_dept_info_ss, product_id_list : product_id)>
			<cfset location_based_total_stock = getComponent.location_based_total_stock(xml_use_other_dept_info_ss : xml_use_other_dept_info_ss, product_id_list : product_id)>
			<cfif product_total_stock.recordcount and len(product_total_stock.product_total_stock)>
				<cfset product_stocks = product_total_stock.product_total_stock>
			<cfelse>
				<cfset product_stocks = 0>
			</cfif>
			<cfif scrap_location_total_stock.recordcount and len(scrap_location_total_stock.total_scrap_stock) and scrap_location_total_stock.total_scrap_stock gt 0>
				<cfset product_stocks = product_stocks - scrap_location_total_stock.total_scrap_stock><cfset a = "#scrap_location_total_stock.total_scrap_stock#">
			</cfif>
			<cfif get_stock_reserved.recordcount and len(get_stock_reserved.artan)>
				<cfset product_stocks = product_stocks + get_stock_reserved.artan><cfset b = "#get_stock_reserved.artan#">
			</cfif>
			<cfif get_stock_reserved.recordcount and len(get_stock_reserved.azalan)>
				<cfset product_stocks = product_stocks - get_stock_reserved.azalan><cfset c= "#get_stock_reserved.azalan#">
			</cfif>
			<cfif get_prod_reserved_.recordcount>
				<cfif len(get_prod_reserved_.azalan)>
					<cfset product_stocks = product_stocks - get_prod_reserved_.azalan><cfset d= "#get_prod_reserved_.azalan#">
				</cfif>
				<cfif len(get_prod_reserved_.artan)>
					<cfset product_stocks = product_stocks + get_prod_reserved_.artan><cfset e= "#get_prod_reserved_.artan#">
				</cfif>
			</cfif>
			<cfif location_based_total_stock.recordcount and len(location_based_total_stock.total_location_stock)>
				<cfset product_stocks = product_stocks - location_based_total_stock.total_location_stock><cfset f= "#location_based_total_stock.total_location_stock#">
			</cfif>
			<td  style="text-align:right;"><!--- xmlde tanımlanan 2.depoya ait stok miktarları --->
				<cfif isdefined("product_stocks") and len(product_stocks)>
					#AmountFormat(product_stocks)#
				</cfif>
			</td>
		</cfif>	
		<cfquery name="GET_UNITS" dbtype="query">
			SELECT DISTINCT ADD_UNIT,PRODUCT_UNIT_ID,MULTIPLIER,MAIN_UNIT FROM get_product_units WHERE PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#PRODUCT_ID#">
		</cfquery>
		<td style="cursor:pointer">
			<cfloop from="1" to="#get_units.recordcount#" index="unt_ind"><!---query="get_units">--->
			<!--- Urun birimleri --->
				<cfif (basket_zero_stock eq 1 or usable_stock_amount gt 0 or (usable_stock_amount lte 0 and (products.IS_ZERO_STOCK eq 1 or (isdefined('attributes.int_basket_id') and ((attributes.int_basket_id eq 4 and products.IS_PRODUCTION eq 1) or ((listfind('10,21,48',attributes.int_basket_id) or (listfind('110,111,112,113,114,115,52,53,54,55,62',sepet_process_type))) and products.IS_INVENTORY eq 1) ) )))) or products.IS_INVENTORY eq 0><!---20070508 sondaki or kosulu 30 gune silinsin stok fislerinde gercek stok kontrolu yapıyor --->
					<cfif get_units.add_unit[unt_ind] eq products.main_unit>
						<a onclick="sepete_ekle(1,'#products.product_id#', '#products.stock_id#','#products.stock_code#','#products.barcod#','#products.MANUFACT_CODE#','#name_product_#','#get_units.product_unit_id[unt_ind]#','#get_units.main_unit[unt_ind]#','#products.PRODUCT_CODE#',1,'#products.IS_SERIAL_NO#','#musteri_flag_prc_other#','#is_sale_product#','#products.tax#','#products.otv#','#musteri_flt_other_money_value#','#musteri_row_money#','#listgetat(session.ep.user_location,1,'-')#','#department_name#','#products.IS_INVENTORY#','#get_units.MULTIPLIER[unt_ind]#','','','','#get_units.MULTIPLIER[unt_ind]#','',<cfif listfind("6,9",basket_prod_list.PRODUCT_SELECT_TYPE,",")>'#PRODUCTS.SPECT_VAR_ID#'<cfelse>''</cfif>,'#products.IS_PRODUCTION#','#ek_tutar#','#unit_other#',<cfif isdefined('attributes.price_catid')>'#attributes.price_catid#'<cfelse>''</cfif>,<cfif basket_prod_list.PRODUCT_SELECT_TYPE eq 11>'#products.shelf_id#'<cfif  xml_group_shelf eq 0>,'#dateformat(products.DELIVER_DATE,dateformat_style)#'<cfelse>,''</cfif><cfelse>'',''</cfif>,'#row_due_day#','#musteri_flt_other_money_value#',<cfif isdefined('attributes.price_catid') and get_price_cat.recordcount>'#get_price_cat.number_of_installment#'<cfelse>''</cfif>,'#attributes.amount_multiplier#','#row_price_catalog_id#','#row_due_day#','<cfif is_lot_no_based eq 1 and isdefined("PRODUCTS.LOT_NO")>#products.lot_no#</cfif>','#products.CUSTOMS_RECIPE_CODE#','#expense_center_id#','#expense_center_name#','','','#activity_type_id#','','#product_detail2#','','#OIV#');" class="tableyazi">
							#get_units.add_unit[unt_ind]#
					  </a>
					<cfelse>
						<a onclick="sepete_ekle(1,'#products.product_id#', '#products.stock_id#','#products.stock_code#','#products.barcod#','#products.MANUFACT_CODE#','#name_product_#','#get_units.product_unit_id[unt_ind]#','#get_units.main_unit[unt_ind]#','#products.PRODUCT_CODE#',1,'#products.IS_SERIAL_NO#','#musteri_flag_prc_other#','#is_sale_product#','#products.tax#','#products.otv#','#musteri_flt_other_money_value#','#musteri_row_money#','#listgetat(session.ep.user_location,1,'-')#','#department_name#','#products.IS_INVENTORY#','#get_units.MULTIPLIER[unt_ind]#','','','','#get_units.MULTIPLIER[unt_ind]#','',<cfif listfind("6,9",basket_prod_list.PRODUCT_SELECT_TYPE,",")>'#PRODUCTS.SPECT_VAR_ID#'<cfelse>''</cfif>,'#products.IS_PRODUCTION#','#ek_tutar#','#get_units.add_unit[unt_ind]#',<cfif isdefined('attributes.price_catid')>'#attributes.price_catid#'<cfelse>''</cfif>,<cfif basket_prod_list.PRODUCT_SELECT_TYPE eq 11>'#products.shelf_id#'<cfif  xml_group_shelf eq 0>,'#dateformat(products.DELIVER_DATE,dateformat_style)#'<cfelse>,''</cfif><cfelse>'',''</cfif>,'#row_due_day#','#musteri_flt_other_money_value#',<cfif isdefined('attributes.price_catid') and get_price_cat.recordcount>'#get_price_cat.number_of_installment#'<cfelse>''</cfif>,'#attributes.amount_multiplier#','#row_price_catalog_id#','#row_due_day#','<cfif is_lot_no_based eq 1 and isdefined("PRODUCTS.LOT_NO")>#products.lot_no#</cfif>','#products.CUSTOMS_RECIPE_CODE#','#expense_center_id#','#expense_center_name#','','','#activity_type_id#','','#product_detail2#','','#OIV#');" class="tableyazi">
							#get_units.add_unit[unt_ind]#
					  </a>
					</cfif>
				<cfelse>
					#get_units.add_unit[unt_ind]#
			  </cfif>
			</cfloop>
		</td>
		<cfif len(listgetat(session.ep.user_location,1,'-')) and basket_prod_list.PRODUCT_SELECT_TYPE neq 11 and session.ep.our_company_info.workcube_sector is "it">
            <td  style="text-align:right;">
                <cfquery name="GET_D" dbtype="query">SELECT * FROM GET_ROW_STOCKS WHERE STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#products.stock_id#"> <cfif isdefined("products.spect_var_id") and len(products.spect_var_id)>AND SPECT_VAR_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#products.spect_var_id#"></cfif></cfquery>
                #get_d.PRODUCT_STOCK#
          </td>
		</cfif>
	  	<td>
			<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_detail_product&pid=#PRODUCTS.PRODUCT_ID#&sid=#stock_id#<cfif isdefined("attributes.is_store_module")>&is_store_module=1</cfif>','list')"><i class="icon-detail" title="<cf_get_lang dictionary_id='32848.Ürün Detay Bilgisi'>"></i></a>
	  	</td>  
	</tr>
	<!--- stok satış durumları --->
	<tr style="display:none;" id="sales_info_row#currentrow#">
		<td colspan="12" align="center">
			<div id="stock_sales_info#currentrow#" style="display:none; outset cccccc; width:100%;"></div>
		</td>
	</tr>
	<cfif basket_prod_list.PRODUCT_SELECT_TYPE eq 12 or basket_prod_list.PRODUCT_SELECT_TYPE eq 13>
		<tr style="display:none;" id="my_row#currentrow#">
			<td colspan="10">
				<div id="check_price#currentrow#" style="display:none; outset cccccc;"></div>
			</td>
		</tr>
	</cfif>
</cfif>
<cfif get_pro.recordcount and basket_prod_list.PRODUCT_SELECT_TYPE neq 11> <!--- promosyon bolumu raf ve son kullanma tarihli popupda gecici olarak kapatıldı.20071002 --->
	<cfloop query="moneys">
		<cfif moneys.money is get_pro.TOTAL_PROMOTION_COST_MONEY>
			<cfset get_pro_rate = moneys.rate2/moneys.rate1 >
		</cfif>
	</cfloop>
	<cfloop from="1" to="#get_pro.recordcount#" index="i">
	<tr>
		<cfif isdefined('xml_is_dsp_stock_code') and xml_is_dsp_stock_code eq 1>
			<td>#stock_code#</td>
		</cfif>
		<cfif isdefined('xml_use_ozel_code') and xml_use_ozel_code eq 1>
			<td width="70">#product_code_2#</td>
		</cfif>
		<td>
			<cfscript>
				promotion_cost = 0;
				free_stock_amount = 1;
				if (len(get_pro.FREE_STOCK_ID))
				{
					if (len(get_pro.FREE_STOCK_AMOUNT[i]))
						free_stock_amount = get_pro.FREE_STOCK_AMOUNT[i];
					if (len(get_pro.TOTAL_PROMOTION_COST[i]) and isDefined('get_pro_rate') and len(get_pro_rate))
						promotion_cost = get_pro.TOTAL_PROMOTION_COST[i] * get_pro_rate;
					promotion_gift_info = "#get_pro.FREE_STOCK_ID[i]# |#get_pro.PROM_ID[i]# |#get_pro.FREE_STOCK_PRICE[i]# |#get_pro.AMOUNT_1_MONEY[i]# |#free_stock_amount# ";
					prom_limit_value = get_pro.LIMIT_VALUE[i];
				}
				else
				{
					promotion_gift_info = "";
					prom_limit_value = 1;
				}
			</cfscript>
			<!--- kullanılabilir stok sıfırdan buyukse veya
				kullanılabilir stok sıfır veya negatif oldugu halde; satıs siparisi ise ve urun uretiliyorsa ya da sıfır stok ile çalış secilmiş ise urune lik verilir...
			 --->
			<cfif (basket_zero_stock eq 1 or usable_stock_amount gt 0 or (usable_stock_amount lte 0 and (products.IS_ZERO_STOCK eq 1 or (isdefined('attributes.int_basket_id') and ( (attributes.int_basket_id eq 4 and products.IS_PRODUCTION eq 1) or ((listfind('10,21,48',attributes.int_basket_id) or (listfind('52,53,54,55,62',sepet_process_type))) and products.IS_INVENTORY eq 1) ) ))))  or products.IS_INVENTORY eq 0>
				<a href="##" onclick="sepete_ekle(1,'#product_id#', '#stock_id#','#stock_code#','#barcod#','#MANUFACT_CODE#','#name_product_#','#products.product_unit_id#','#products.add_unit#','#products.PRODUCT_CODE#',1,'#products.IS_SERIAL_NO#','#musteri_flag_prc_other#','#is_sale_product#','#products.tax#','#products.otv#','#musteri_flt_other_money_value#','#musteri_row_money#','#listgetat(session.ep.user_location,1,'-')#','#department_name#','#IS_INVENTORY#','#MULTIPLIER#','#get_pro.prom_id[i]#','#get_pro.DISCOUNT[i]#','#promotion_cost#','#prom_limit_value#','#promotion_gift_info#',<cfif listfind("6,9",basket_prod_list.PRODUCT_SELECT_TYPE,",")>'#SPECT_VAR_ID#'<cfelse>''</cfif>,'#IS_PRODUCTION#','#ek_tutar#','#unit_other#',<cfif isdefined('attributes.price_catid')>'#attributes.price_catid#'<cfelse>''</cfif>,<cfif basket_prod_list.PRODUCT_SELECT_TYPE eq 11>'#shelf_id#','#dateformat(DELIVER_DATE,dateformat_style)#'<cfelse>'',''</cfif>,
				'#row_due_day#','#musteri_flt_other_money_value#',<cfif isdefined('attributes.price_catid') and get_price_cat.recordcount>'#get_price_cat.number_of_installment#'<cfelse>''</cfif>,'#other_amount#','#row_price_catalog_id#','<cfif is_lot_no_based eq 1 and isdefined("PRODUCTS.LOT_NO")>#products.lot_no#</cfif>','#products.CUSTOMS_RECIPE_CODE#','#expense_center_id#','#expense_center_name#','','','#activity_type_id#','','#product_detail2#','','#OIV#');">
					#product_name# #property#
				</a>
			<cfelse>
				#product_name# #property#
			</cfif>
			<br/>
			<input type="Hidden" name="prom_id" id="prom_id" value="#get_pro.prom_id[i]#">
			<font color="FF0000">Promosyon: <a href="javascript:windowopen('#request.self#?fuseaction=objects.popup_detail_promotion_unique&prom_id=#get_pro.PROM_ID[i]#','medium');">
			#get_pro.prom_head[i]# </a>
		</td>
        <cfif (basket_prod_list.PRODUCT_SELECT_TYPE eq 13 or basket_prod_list.PRODUCT_SELECT_TYPE eq 11 ) and attributes.int_basket_id neq 4>
           <cfif is_lot_no_based eq 1>
                <td>#lot_no#</td>
           </cfif>
        </cfif>
		<cfif isdefined('xml_is_list_products') and xml_is_list_products eq 1>
			<td width="550">#products.product_detail#</td>
		</cfif>
		<cfif listfind('6,9',basket_prod_list.PRODUCT_SELECT_TYPE,',')>
			<td><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_detail_spec&id=#products.SPECT_VAR_ID#','medium');" class="tableyazi">#products.SPECT_VAR_ID#</a></td>
		</cfif>
		<cfif listfind('2,8,9',basket_prod_list.PRODUCT_SELECT_TYPE,',')>
			<td  style="text-align:right;">#MANUFACT_CODE#</td>
		</cfif>
		<cfif listfind('8,9',basket_prod_list.PRODUCT_SELECT_TYPE,',')>
			<td  style="text-align:right;"><cfif ek_tutar neq 0>#TLFormat(ek_tutar,session.ep.our_company_info.sales_price_round_num)# #MONEY# (#work_product_unit#)</cfif></td>
		</cfif>
		<td  nowrap style="text-align:right;">
		<cfif len(get_pro.amount_discount[i])><cfset musteri_flt_other_money_value = get_pro.amount_discount[i]></cfif> 
		<cfif (basket_zero_stock eq 1 or usable_stock_amount gt 0 or (usable_stock_amount lte 0 and (products.IS_ZERO_STOCK eq 1 or (isdefined('attributes.int_basket_id') and ( (attributes.int_basket_id eq 4 and products.IS_PRODUCTION eq 1) or ((listfind('10,21,48',attributes.int_basket_id) or (listfind('52,53,54,55,62',sepet_process_type))) and products.IS_INVENTORY eq 1) ) )))) or products.IS_INVENTORY eq 0>
			<a href="##" onclick="gonder_price_page(1,'#product_id#', '#stock_id#','#stock_code#','#barcod#','#MANUFACT_CODE#','#name_product_#','#products.product_unit_id#','#products.add_unit#','#products.PRODUCT_CODE#',1,'#musteri_flag_prc_other#','#is_sale_product#','#products.tax#','#products.otv#','#musteri_flt_other_money_value#','#musteri_row_money#','#listgetat(session.ep.user_location,1,'-')#','#department_name#','#IS_INVENTORY#','#MULTIPLIER#','#get_pro.prom_id[i]#','#get_pro.DISCOUNT[i]#','#promotion_cost#',1,'',<cfif listfind("6,9",basket_prod_list.PRODUCT_SELECT_TYPE,",")>'#SPECT_VAR_ID#'<cfelse>''</cfif>,'#IS_PRODUCTION#','#ek_tutar#','#unit_other#',<cfif isdefined('attributes.price_catid')>'#attributes.price_catid#'<cfelse>''</cfif>,<cfif basket_prod_list.PRODUCT_SELECT_TYPE eq 11>'#shelf_id#','#dateformat(DELIVER_DATE,dateformat_style)#'<cfelse>'',''</cfif>,'#musteri_flt_other_money_value#',
			<cfif isdefined('attributes.price_catid') and get_price_cat.recordcount>'#get_price_cat.number_of_installment#'<cfelse>''</cfif>,'#row_due_day#','#other_amount#','#row_price_catalog_id#');">
			<cfif row_money is default_money.money>
				#TLFormat(pro_price,session.ep.our_company_info.sales_price_round_num)# #money# (#products.add_unit#)
			<cfelse>
				<cfset float_cur_price = pro_price*(row_money_rate2/row_money_rate1)>
				<cfset str_money = default_money.money>
				#TLFormat(pro_price,session.ep.our_company_info.sales_price_round_num)# #row_money# (#products.add_unit#)
			</cfif></a>
		<cfelse>
			<cfif row_money is default_money.money>
				#TLFormat(pro_price,session.ep.our_company_info.sales_price_round_num)# #money# (#products.add_unit#)
			<cfelse>
				<cfset float_cur_price = pro_price*(row_money_rate2/row_money_rate1)>
				<cfset str_money = default_money.money>
				#TLFormat(pro_price,session.ep.our_company_info.sales_price_round_num)# #row_money# (#products.add_unit#)
			</cfif>
		</cfif>
		</td>
		<td  style="text-align:right;">
		<cfif (basket_zero_stock eq 1 or usable_stock_amount gt 0 or (usable_stock_amount lte 0 and (products.IS_ZERO_STOCK eq 1 or (isdefined('attributes.int_basket_id') and ( (attributes.int_basket_id eq 4 and products.IS_PRODUCTION eq 1) or ((listfind('10,21,48',attributes.int_basket_id) or (listfind('52,53,54,55,62',sepet_process_type))) and products.IS_INVENTORY eq 1) ) )))) or products.IS_INVENTORY eq 0>
			<a onclick="sepete_ekle(1,'#product_id#', '#stock_id#','#stock_code#','#barcod#','#MANUFACT_CODE#','#name_product_#','#products.product_unit_id#','#products.add_unit#','#products.PRODUCT_CODE#',1,'#products.IS_SERIAL_NO#','#musteri_flag_prc_other#','#is_sale_product#','#products.tax#','#products.otv#','#musteri_flt_other_money_value#','#musteri_row_money#','#listgetat(session.ep.user_location,1,'-')#','#department_name#','#IS_INVENTORY#','#MULTIPLIER#','#get_pro.prom_id[i]#','#get_pro.DISCOUNT[i]#','#promotion_cost#','#prom_limit_value#','#promotion_gift_info#',<cfif listfind("6,9",basket_prod_list.PRODUCT_SELECT_TYPE,",")>'#SPECT_VAR_ID#'<cfelse>''</cfif>,'#IS_PRODUCTION#','#ek_tutar#','#unit_other#',<cfif isdefined('attributes.price_catid')>'#attributes.price_catid#'<cfelse>''</cfif>,<cfif basket_prod_list.PRODUCT_SELECT_TYPE eq 11>'#shelf_id#','#dateformat(DELIVER_DATE,dateformat_style)#'<cfelse>'',''</cfif>,
			'#row_due_day#','#musteri_flt_other_money_value#',<cfif isdefined('attributes.price_catid') and get_price_cat.recordcount>'#get_price_cat.number_of_installment#'<cfelse>''</cfif>,'#other_amount#','#row_price_catalog_id#','<cfif is_lot_no_based eq 1 and isdefined("PRODUCTS.LOT_NO")>#products.lot_no#</cfif>','#products.CUSTOMS_RECIPE_CODE#','#expense_center_id#','#expense_center_name#','','','#activity_type_id#','','#product_detail2#','','#OIV#');" class="tableyazi">
				#TLFormat(musteri_flt_other_money_value,session.ep.our_company_info.sales_price_round_num)# #musteri_row_money#
			</a>
		<cfelse>
			#TLFormat(musteri_flt_other_money_value,session.ep.our_company_info.sales_price_round_num)# #musteri_row_money#
		</cfif>
		</td>
		<cfif not isdefined("attributes.is_store_module")>
			<td  style="text-align:right;">#TLFormat(products.product_stock,0)#</td> 
			<td  style="text-align:right;">#TLFormat(usable_stock_amount,0)#</td> 
		</cfif>
		<td>#products.main_unit#</td>
		<cfif len(listgetat(session.ep.user_location,1,'-')) and session.ep.our_company_info.workcube_sector is "it">
		<td  style="text-align:right;">
			<cfquery name="GET_D" dbtype="query">SELECT * FROM GET_ROW_STOCKS WHERE STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#products.stock_id#"> <cfif isdefined("products.spect_var_id") and len(products.spect_var_id)>AND SPECT_VAR_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#products.spect_var_id#"></cfif></cfquery>
			#get_d.PRODUCT_STOCK#
		</td>
		</cfif>
		<td>
			<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_detail_product&pid=#PRODUCTS.PRODUCT_ID#&sid=#stock_id#<cfif isdefined("attributes.is_store_module")>&is_store_module=1</cfif>','list')">
				<i class="icon-detail" title="<cf_get_lang dictionary_id='32848.Ürün Detay Bilgisi'>"></i>
			</a>
		</td>  
	</tr>
	<cfset get_pro.recordcount = 0>
	</cfloop>
</cfif>
</cfoutput>
