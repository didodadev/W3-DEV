<!--- 
	Bu Sayfada yapilan degisiklik bu sayfada da yapilmali. 
	<cfinclude template="list_product_sale_with_nolink.cfm">
	Amac: 
	Stok miktari sifirdan kucuk olan ve sifir stok la calismayan firmalarda urunler popupdan baskete atilmayacak.
	Bu sayfa sadece urunleri lsitelemek icindir.(11/12/2003)
--->
<cfif len(location_based_stock.TOTAL_STOCK[listfind(location_stock_list,products.STOCK_ID)])>
	<cfset usable_stock_amount = location_based_stock.TOTAL_STOCK[listfind(location_stock_list,products.STOCK_ID)]>
<cfelse>
	<cfset usable_stock_amount = 0>
</cfif>
<!--- alınan siparis/rezerve miktarı gercek stoktan dusuluyor --->
<cfif get_stock_azalan.recordcount and len(get_stock_azalan.AZALAN[listfind(azalan_stock_list,products.STOCK_ID)])>
	<cfset usable_stock_amount = usable_stock_amount - get_stock_azalan.AZALAN[listfind(azalan_stock_list,products.STOCK_ID)]>
</cfif>
<!--- verilen siparis/ beklenen miktar gercek stoga ekleniyor ---> 
<cfif get_stock_artan.recordcount and len(get_stock_artan.ARTAN[listfind(artan_stock_list,products.STOCK_ID)])>
	<cfset usable_stock_amount = usable_stock_amount + get_stock_artan.ARTAN[listfind(artan_stock_list,products.STOCK_ID)]>
</cfif> 
<!--- üretim emri sonucu (beklenen miktar-sarf edilen miktar) farkı gerçek stoga ekleniyor --->
<cfif get_prod_reserved.recordcount and len(get_prod_reserved.FARK[listfind(prod_reserved_list,products.STOCK_ID)])>
	<cfset usable_stock_amount = usable_stock_amount + get_prod_reserved.FARK[listfind(prod_reserved_list,products.STOCK_ID)]>
</cfif> 

<cfoutput>
<tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
  <td>#stock_code#</td>
  <td>#product_name# #property#
  <cfif not isdefined("attributes.is_promotion")>
	  <br/>
		<cfif get_pro.recordcount>
			<font color="FF0000"><cf_get_lang dictionary_id='32744.Promosyon'>:</font> <a href="javascript:windowopen('#request.self#?fuseaction=objects.popup_detail_promotion_unique&prom_id=#GET_PRO.PROM_ID#','medium');"  class="tableyazi">#get_pro.prom_head# </a>(%#TLFormat(GET_PRO.DISCOUNT)#)
		<cfelse>
		</cfif>
  </cfif>  
  </td>
  <td  style="text-align:right;" >                 
	<cfif not isdefined("attributes.is_promotion")>
		<cfquery name="GET_PRO" datasource="#DSN3#">
			SELECT
				PROMOTIONS.DISCOUNT,
				PROMOTIONS.PROM_HEAD,
				PROMOTIONS.PROM_ID
			FROM
				STOCKS,PROMOTIONS
			WHERE
				STOCKS.PRODUCT_ID = #PRODUCTS.PRODUCT_ID# AND
				STOCKS.STOCK_ID = PROMOTIONS.STOCK_ID AND
				PROMOTIONS.STARTDATE <= #now()# AND
				PROMOTIONS.FINISHDATE >= #now()# AND
				PROMOTIONS.PRICE_CATID = #attributes.price_catid#
		</cfquery> 
		<cfif not len(get_pro.DISCOUNT)>
			<cfset pro_price = products.price>
		<cfelse>
			<cfset attributes.discount = get_pro.DISCOUNT>
			<cfset discount_per = (( (products.price) * attributes.discount) / 100)>
			<cfset pro_price = (products.price - discount_per)>
		</cfif>
	<cfelse>				
		<cfset pro_price = products.price>
	</cfif>

	<cfif isDefined('attributes.price_catid') and (not products.add_unit is products.main_unit) and (attributes.price_catid eq '-1')>
		<cfset pro_price = evaluate(products.price * products.multiplier)>
	</cfif>
	<cfif row_money is default_money.money >
		#TLFormat(pro_price)# #money# (#products.add_unit#)
	<cfelse>
		<!--- <cfif isdefined("attributes.is_fcurrency") and attributes.is_fcurrency eq 1>
			<cfset float_cur_price = pro_price >
			<cfset str_money = row_money >
		<cfelse> --->
			<cfset float_cur_price = pro_price*(row_money_rate2/row_money_rate1) >
			<cfset str_money = default_money.money >
		<!--- </cfif> --->#TLFormat(pro_price)# #row_money#
		<!--- #TLFormat(float_cur_price#&nbsp;&nbsp;#str_money#  --->(#products.add_unit#) 			
		<cfset pro_price = pro_price*(row_money_rate2/row_money_rate1) >					
	</cfif>
  </td>
  <td  style="text-align:right;">#TLFormat(musteri_flt_other_money_value)# #musteri_row_money#</td>
	<td  style="text-align:right;">
	<!--- <cfif usable_stock_amount gt 0 or (usable_stock_amount lte 0 and products.IS_ZERO_STOCK eq 1)>
		<a href="javascript:depo_sayfasini_ac(1,'#product_id#', '#stock_id#','#stock_code#','#barcod#','#MANUFACT_CODE#','#product_name# #products.property#','#products.product_unit_id#','#products.add_unit#','#products.PRODUCT_CODE#',1,'#products.IS_SERIAL_NO#','#musteri_flag_prc_other#','#is_sale_product#','#products.tax#','#musteri_flt_other_money_value#','#musteri_row_money#','#listgetat(session.ep.user_location,1,'-')#','#department_name#','#IS_INVENTORY#','#MULTIPLIER#');">
		#TLFormat(products.product_stock,0)#
		</a>
	<cfelse> --->
		#TLFormat(products.product_stock,0)#
	<!--- </cfif> --->
	</td>
	<td  style="text-align:right;">#TLFormat(usable_stock_amount,0)#</td>
	<td>#products.main_unit#</td>
	<cfif len(listgetat(session.ep.user_location,1,'-')) and session.ep.our_company_info.workcube_sector is "it">
	<td>
		<cfquery name="get_d" dbtype="query">
			SELECT 	* FROM GET_ROW_STOCKS WHERE STOCK_ID = #products.stock_id#			
		</cfquery>
		#get_d.PRODUCT_STOCK#
	</td>
	</cfif>
	<td> 
	<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_detail_product&pid=#PRODUCTS.PRODUCT_ID#&sid=#stock_id#','medium')"><img src="/images/report_square2.gif"  border="0"></a>
	</td>
</tr>
</cfoutput>
