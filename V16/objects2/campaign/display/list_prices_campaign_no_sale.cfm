<cfparam name="attributes.product_compare" default="1">
<cfparam name="attributes.is_basket" default="1">
<cfparam name="attributes.is_brand" default="1">
<cfparam name="attributes.is_stock_count" default="0">
<cfparam name="attributes.is_image" default="1">
<cfparam name="attributes.is_popup" default="0">
<cfparam name="attributes.is_price" default="1">
<cfparam name="attributes.is_demand" default="1">
<cfif attributes.is_price eq 0 and attributes.is_basket eq 1>
	<cfset attributes.is_basket = 0>
</cfif>
<cfif attributes.is_basket eq 1>
	<cfset attributes.is_stock_count = 1>
</cfif>

<cfparam name="attributes.price_catid_2" default="-2">
<cfif attributes.is_price eq 1> <!--- fiyat yapilmamis ise bu bloga girmez --->
	<cfinclude template="../../query/get_price_cats_moneys.cfm">
</cfif>	<!--- fiyat yapilmamis ise bu bloga girmez --->
	
<cfquery name="GET_HOMEPAGE_PRODUCTS" datasource="#DSN3#">
	SELECT 
		DISTINCT
			CP.CATALOG_HEAD,
			CPP.ACTION_PRICE_DISCOUNT AS TUTAR_INDIRIMI,
			CPP.ACTION_PRICE AS KAMPANYA_FIYATI,
			CPP.ACTION_PRICE_KDVSIZ AS KAMPANYA_FIYATI_KDVSIZ,
			CPP.MONEY AS KAMPANYA_MONEY,
			STOCKS.STOCK_ID,
			STOCKS.PRODUCT_ID,
			STOCKS.STOCK_CODE,
			GS.PRODUCT_STOCK, 
			PRODUCT.PRODUCT_NAME,
			STOCKS.PROPERTY,
			STOCKS.BARCOD,
			PRODUCT.TAX,
			PRODUCT.BRAND_ID,
			PRODUCT.IS_ZERO_STOCK,
			PRODUCT.PRODUCT_CODE,
			PRODUCT.PRODUCT_DETAIL,
			PRODUCT.PRODUCT_CATID,
			PRODUCT.RECORD_DATE,
			PRODUCT.IS_PRODUCTION,
			STOCKS.PRODUCT_UNIT_ID,
			PRICE_STANDART.PRICE PRICE,
			PRICE_STANDART.MONEY MONEY,
			PRICE_STANDART.IS_KDV IS_KDV,
			PRICE_STANDART.PRICE_KDV PRICE_KDV
		FROM
			PRODUCT,
			PRODUCT_CAT,
			PRICE_STANDART,
			STOCKS,
			#dsn2_alias#.GET_STOCK GS,
			PRODUCT_UNIT,
			CATALOG_PROMOTION_PRODUCTS AS CPP,
			CATALOG_PROMOTION AS CP
		WHERE
			CP.CATALOG_STATUS = 1 AND
			CP.STAGE_ID=-2 AND<!---  YAYIN AŞAMASINDAKİLER GELSİN --->
			<cfif isdefined("attributes.price_catid")>
				CP.CATALOG_ID IN (SELECT CPL.CATALOG_PROMOTION_ID FROM CATALOG_PRICE_LISTS AS CPL WHERE CPL.CATALOG_PROMOTION_ID = CP.CATALOG_ID AND PRICE_LIST_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.price_catid#">) AND
			</cfif>
			CP.CAMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.camp_id#"> AND
			#now()# BETWEEN CP.STARTDATE AND CP.FINISHDATE AND
			<!--- <cfif isDefined("session.pp")>CP.IS_APPLIED = 1 AND</cfif> kapattırıldı aysenur--->
			CP.CATALOG_ID = CPP.CATALOG_ID AND 
			PRODUCT.PRODUCT_ID = CPP.PRODUCT_ID AND
			PRICE > 0 AND
			PRODUCT.PRODUCT_ID = STOCKS.PRODUCT_ID AND
			PRODUCT_CAT.PRODUCT_CATID = PRODUCT.PRODUCT_CATID AND
			PRODUCT_UNIT.PRODUCT_ID = STOCKS.PRODUCT_ID AND
			STOCKS.PRODUCT_UNIT_ID = PRODUCT_UNIT.PRODUCT_UNIT_ID AND
			GS.STOCK_ID = STOCKS.STOCK_ID AND
			PRODUCT_UNIT.IS_MAIN = 1 AND			
			<cfif isdefined("session.pp")>PRODUCT.IS_EXTRANET = 1 AND<cfelse>PRODUCT.IS_INTERNET = 1 AND</cfif>
			PRODUCT.PRODUCT_STATUS = 1 AND
			PRICE_STANDART.PRICESTANDART_STATUS = 1	AND
			PRICE_STANDART.PURCHASESALES = 1 AND
			PRICE_STANDART.PRODUCT_ID = STOCKS.PRODUCT_ID AND
			PRODUCT_UNIT.PRODUCT_UNIT_ID = PRICE_STANDART.UNIT_ID
			ORDER BY
			<cfif not isdefined("attributes.order_element")>
				PRODUCT.PRODUCT_NAME
			<cfelseif attributes.order_element is 'PRODUCT_STOCK'>
				GS.PRODUCT_STOCK <cfoutput>#attributes.order_type#</cfoutput>
			<cfelseif attributes.order_element is 'PRODUCT_NAME'>
				PRODUCT.PRODUCT_NAME <cfoutput>#attributes.order_type#</cfoutput>	
			<cfelseif attributes.order_element is 'PRICE'>
				PRICE_STANDART.PRICE <cfoutput>#attributes.order_type#</cfoutput>
			<cfelse>
				PRODUCT.PRODUCT_NAME
			</cfif>
</cfquery>

<cfset adres = "#fusebox.circuit#.#fusebox.fuseaction#">
<cfif isdefined("attributes.keyword") and len(attributes.keyword)>
	<cfset adres = adres & "&keyword=#attributes.keyword#">
</cfif>
<cfif isdefined("attributes.product_catid") and len(attributes.product_catid) and len(attributes.product_cat)>
	<cfset adres = adres & "&product_catid=#attributes.product_catid#">
	<cfset adres = adres & "&product_cat=#attributes.product_cat#">
</cfif>
<cfif isdefined("attributes.brand_id") and len(attributes.brand_id) and len(attributes.brand_name)>
	<cfset adres = adres & "&brand_id=#attributes.brand_id#">
	<cfset adres = adres & "&brand_name=#attributes.brand_name#">
</cfif>
<cfif isdefined("attributes.company_id") and len(attributes.company_id)>
	<cfset adres = adres & "&company_id=#attributes.company_id#">
</cfif>
<cfif isdefined("attributes.consumer_id") and len(attributes.consumer_id)>
	<cfset adres = adres & "&consumer_id=#attributes.consumer_id#">
</cfif>

<cfset stock_list="">
<cfset brand_list = ''>
<cfset product_id_list = ''>
<cfoutput query="get_homepage_products">
	<cfset stock_list = listappend(stock_list,stock_id)>
	<cfif attributes.is_brand>
		<cfset brand_list = listappend(brand_list,get_homepage_products.brand_id,',')>
	</cfif>
	<cfif attributes.is_image>
		<cfif not listfindnocase(product_id_list,get_homepage_products.product_id)>
			<cfset product_id_list = listappend(product_id_list,get_homepage_products.product_id,',')>
		</cfif>	
	</cfif>
</cfoutput>

<cfif listlen(stock_list) and attributes.is_stock_count>
	<cfinclude template="../../product/get_artan_azalan_stock.cfm">
</cfif>
<cfset product_all_list = "">
<table border="0" cellspacing="0" cellpadding="0" align="center" style="width:100%;">
  	<tr>
		<td>
			<table border="0" cellpadding="2" cellspacing="1" style="width:100%;">
          		<tr class="color-header" style="height:20px;">
					<cfif attributes.product_compare eq 1><td style="width:20px;"></td></cfif>
					<cfif attributes.is_image eq 1><td style="width:20px;"></td></cfif>
					<cfif attributes.is_brand eq 1><td class="form-title"><cf_get_lang_main no='1435.Marka'></td></cfif>
					<td class="form-title"><cf_get_lang_main no='245.Ürün'></td>
					<cfif attributes.is_price eq 1>
						<cfif isdefined('session.pp.userid')><td  class="form-title" style="text-align:right; width:100px;"><cf_get_lang no='412.Sizin Fiyatınız'></td></cfif>
						<td  class="form-title" style="text-align:right; width:80px;"><cf_get_lang no='272.Kampanya Fiyatı'></td>
					</cfif>
				</tr>
				<cfif get_homepage_products.recordcount>
					<cfif attributes.is_brand>
						<cfset brand_list=listsort(brand_list,"numeric","ASC",",")>
						<cfif listlen(brand_list)>
							<cfquery name="GET_BRANDS" datasource="#DSN3#">
								SELECT BRAND_NAME,BRAND_ID FROM PRODUCT_BRANDS WHERE BRAND_ID IN (#brand_list#)
							</cfquery>
							<cfset main_brand_list = listsort(listdeleteduplicates(valuelist(get_brands.brand_id,',')),'numeric','ASC',',')>
						</cfif>
					</cfif>
					<cfif attributes.is_image eq 1>
						<cfif listlen(product_id_list)>
							<cfquery name="GET_PRODUCT_IMAGES" datasource="#DSN3#">
								SELECT PATH,PRODUCT_ID,PATH_SERVER_ID FROM PRODUCT_IMAGES WHERE IMAGE_SIZE = 0 AND PRODUCT_ID IN (#product_id_list#)
							</cfquery>
							<cfset product_id_list = listdeleteduplicates(valuelist(get_product_images.product_id,','),'numeric','ASC',',')>
							<cfset product_id_list=listsort(product_id_list,"numeric","ASC",",")>
						</cfif>
					</cfif> 	
		  			<cfoutput query="get_homepage_products">
						<tr <cfif currentrow mod 2> class="color-list" <cfelse>class="color-row" </cfif>>
							<cfif attributes.product_compare eq 1>
                            	<td>
									<cfset product_all_list = listappend(product_all_list,product_id)>
                                    <input type="checkbox" name="product_id" id="product_id" value="#product_id#">
                                </td>
							</cfif>
							<cfif attributes.is_image eq 1>
								<td>
									<cfif listfindnocase(product_id_list,product_id)>
										<cf_get_server_file output_file="product/#get_product_images.path[listfind(product_id_list,product_id,',')]#" output_server="#get_product_images.path_server_id[listfind(product_id_list,product_id,',')]#"  output_type="0" image_width="50" image_height="50" image_link=1  alt="#getLang('objects2',207)#" title="#getLang('objects2',207)#">
									</cfif>
								</td>
							</cfif>
							<cfif attributes.is_brand eq 1><td><cfif len(brand_id)>#get_brands.brand_name[listfind(main_brand_list,brand_id,',')]#</cfif></td></cfif>
							<td>
								<input type="hidden" name="pid_#currentrow#_#i#" id="pid_#currentrow#_#i#" value="#product_id#">
								<input type="hidden" name="sid_#currentrow#_#i#" id="sid_#currentrow#_#i#" value="#stock_id#">
								<cfif attributes.is_price>
									<a href="##" onclick="camp_urun_gonder2('#currentrow#','0');" class="tableyazi" title="#PRODUCT_DETAIL#">#PRODUCT_NAME#<cfif PROPERTY is '-'><cfelseif len(PROPERTY) gt 1>&nbsp;#PROPERTY#</cfif></a>
								<cfelse>
									<a href="#request.self#?fuseaction=objects2.detail_product&product_id=#product_id#&stock_id=#stock_id#" class="tableyazi" title="#PRODUCT_DETAIL#">#PRODUCT_NAME#<cfif PROPERTY is '-'><cfelseif len(PROPERTY) gt 1>&nbsp;#PROPERTY#</cfif></a>
								</cfif>
							</td>
							<cfif attributes.is_stock_count eq 1></cfif>
							<cfif attributes.is_price eq 1>
								<cfif isdefined("session.pp")>
									<td  style="text-align:right;">
										#tlformat(kampanya_fiyati_kdvsiz-tutar_indirimi)#
										#kampanya_money#
									</td>
								</cfif>
								<td  style="text-align:right;">
									<input type="hidden" name="camp_campaign_id_#currentrow#" id="camp_campaign_id_#currentrow#" value="#attributes.camp_id#">
									<input type="hidden" name="camp_pid_#currentrow#" id="camp_pid_#currentrow#" value="#product_id#">
									<input type="hidden" name="camp_sid_#currentrow#" id="camp_sid_#currentrow#" value="#stock_id#">
									<input type="hidden" name="camp_prom_id_#currentrow#" id="camp_prom_id_#currentrow#" value="">
									<input type="hidden" name="camp_prom_discount_#currentrow#" id="camp_prom_discount_#currentrow#" value="">
									<input type="hidden" name="camp_prom_amount_discount_#currentrow#" id="camp_prom_amount_discount_#currentrow#" value="">
									<input type="hidden" name="camp_prom_cost_#currentrow#" id="camp_prom_cost_#currentrow#" value="">
									<input type="hidden" name="camp_prom_free_stock_id_#currentrow#" id="camp_prom_free_stock_id_#currentrow#" value="">				
									<input type="hidden" name="camp_prom_stock_amount_#currentrow#" id="camp_prom_free_stock_id_#currentrow#"value="1">
									<input type="hidden" name="camp_prom_free_stock_amount_#currentrow#" id="camp_prom_free_stock_amount_#currentrow#" value="">
									<input type="hidden" name="camp_prom_free_stock_price_#currentrow#" id="camp_prom_free_stock_price_#currentrow#" value="">
									<input type="hidden" name="camp_prom_free_stock_money_#currentrow#" id="camp_prom_free_stock_money_#currentrow#" value="">
									<input type="hidden" name="camp_price_old_#currentrow#" id="camp_price_old_#currentrow#" value="">
									<cfif isdefined("session.pp")>
										<input type="hidden" name="camp_price_#currentrow#" id="camp_price_#currentrow#" value="#(kampanya_fiyati_kdvsiz-tutar_indirimi)#">
										<input type="hidden" name="camp_price_kdv_#currentrow#" id="camp_price_kdv_#currentrow#" value="#kampanya_fiyati-(tutar_indirimi*(1+(tax/100)))#">
									<cfelse>
										<input type="hidden" name="camp_price_#currentrow#" id="camp_price_#currentrow#" value="#kampanya_fiyati_kdvsiz#">
										<input type="hidden" name="camp_price_kdv_#currentrow#" id="camp_price_kdv_#currentrow#" value="#kampanya_fiyati#">
									</cfif>
									<input type="hidden" name="camp_price_money_#currentrow#" id="camp_price_money_#currentrow#" value="#kampanya_money#">
									<input type="hidden" name="camp_price_standard_#currentrow#" id="camp_price_standard_#currentrow#" value="#kampanya_fiyati_kdvsiz#">
									<input type="hidden" name="camp_price_standard_kdv_#currentrow#" id="camp_price_standard_kdv_#currentrow#" value="#kampanya_fiyati#">
									<input type="hidden" name="camp_price_standard_money_#currentrow#" id="camp_price_standard_money_#currentrow#" value="#kampanya_money#">
									#tlformat(kampanya_fiyati_kdvsiz)#  #kampanya_money#
								</td>
							</cfif>
						</tr>
		  			</cfoutput>
		 		<cfelse>
		 			<tr class="color-row" style="height:20px;">
						<td colspan="9"><cf_get_lang no='273.Bu Kategoriye Ait Ürün Bulunamadı'>!</td>
		 			</tr>
				</cfif> 
       		</table>
		</td>
	</tr>
	<cfif attributes.product_compare eq 1>
		<tr style="height:25px;">
			<td><a href="javascript://" onClick="karsilastir();" title="<cf_get_lang no='407.Karşılaştırma'>"><img src="../objects2/image/karsila.gif" style="cursor:pointer" alt="<cf_get_lang no='407.Karşılaştırma'>" /></a></td>
		</tr>
	</cfif>
</table>
<form action="" method="post" name="camp_satir_gonder">
	<input type="hidden" name="campaign_basket" id="campaign_basket" value="1">
	<input type="hidden" name="price_catid_2" id="price_catid_2" value="">
	<input type="hidden" name="istenen_miktar" id="istenen_miktar" value="">
	<input type="hidden" name="pid" id="pid" value="">
	<input type="hidden" name="product_id" id="product_id" value="">
	<input type="hidden" name="sid" id="sid" value="">
	<input type="hidden" name="price" id="price" value="">
	<input type="hidden" name="price_old" id="price_old" value="">
	<input type="hidden" name="price_kdv" id="price_kdv" value="">
	<input type="hidden" name="price_money" id="price_money" value="">
	<input type="hidden" name="prom_id" id="prom_id" value="">
	<input type="hidden" name="prom_discount" id="prom_discount" value="">
	<input type="hidden" name="prom_amount_discount" id="prom_amount_discount" value="">
	<input type="hidden" name="prom_cost" id="prom_cost" value="">
	<input type="hidden" name="prom_free_stock_id" id="prom_free_stock_id" value="">
	<input type="hidden" name="prom_stock_amount" id="prom_stock_amount" value="1">
	<input type="hidden" name="prom_free_stock_amount" id="prom_free_stock_amount" value="1">
	<input type="hidden" name="prom_free_stock_price" id="prom_free_stock_price" value="0">
	<input type="hidden" name="prom_free_stock_money" id="prom_free_stock_money" value="">	
	<input type="hidden" name="price_standard" id="price_standard" value="">
	<input type="hidden" name="price_standard_kdv" id="price_standard_kdv" value="">
	<input type="hidden" name="price_standard_money" id="price_standard_money" value="">
</form>

<iframe name="form_basket_camp_ww" id="form_basket_camp_ww" src="<cfoutput>#request.self#</cfoutput>?fuseaction=objects2.popup_iframe_form_basket" width="0" height="0" scrolling="yes" frameborder="1"></iframe>

<script type="text/javascript">
	<cfif attributes.is_basket eq 1>
		function camp_urun_gonder(satir_no,pro_no)
		{
			if(pro_no>0)satir_no=satir_no+'_'+pro_no;
			camp_istenen_miktar = filterNum(eval("document.getElementById('camp_miktar_"+satir_no+"')").value);
			if(camp_istenen_miktar.length==0 || camp_istenen_miktar =='')
			{
				alert("<cf_get_lang no ='1147.Miktar Giriniz'>!");
				return false;
			}
			window.frames['form_basket_ww'].satir_gonder.istenen_miktar.value = camp_istenen_miktar;
			window.frames['form_basket_ww'].satir_gonder.price_catid_2.value = '<cfoutput>#attributes.price_catid_2#</cfoutput>';
			window.frames['form_basket_ww'].satir_gonder.sid.value = eval("document.getElementById('camp_sid_"+satir_no+"')").value;
			window.frames['form_basket_ww'].satir_gonder.campaign_id.value = eval("document.getElementById('camp_campaign_id_"+satir_no+"')").value;
			window.frames['form_basket_ww'].satir_gonder.price.value = eval("document.getElementById('camp_price_"+satir_no+"')").value;
			window.frames['form_basket_ww'].satir_gonder.price_kdv.value = eval("document.getElementById('camp_price_kdv_"+satir_no+"')").value;
			window.frames['form_basket_ww'].satir_gonder.price_money.value = eval("document.getElementById('camp_price_money_"+satir_no+"')").value;
			window.frames['form_basket_ww'].satir_gonder.price_standard.value = eval("document.getElementById('camp_price_standard_"+satir_no+"')").value;
			window.frames['form_basket_ww'].satir_gonder.price_standard_kdv.value = eval("document.getElementById('camp_price_standard_kdv_"+satir_no+"')").value;
			window.frames['form_basket_ww'].satir_gonder.price_standard_money.value = eval("document.getElementById('camp_price_standard_money_"+satir_no+"')").value;			
			window.frames['form_basket_ww'].satir_gonder.prom_id.value = eval("document.getElementById('camp_prom_id_"+satir_no+"')").value;
			window.frames['form_basket_ww'].satir_gonder.prom_discount.value = eval("document.getElementById('camp_prom_discount_"+satir_no+"')").value;
			window.frames['form_basket_ww'].satir_gonder.prom_amount_discount.value = eval("document.getElementById('camp_prom_amount_discount_"+satir_no+"')").value;
			window.frames['form_basket_ww'].satir_gonder.prom_cost.value = eval("document.getElementById('camp_prom_cost_"+satir_no+"')").value;
			window.frames['form_basket_ww'].satir_gonder.prom_free_stock_id.value = eval("document.getElementById('camp_prom_free_stock_id_"+satir_no+"')").value;
			window.frames['form_basket_ww'].satir_gonder.prom_stock_amount.value = eval("document.getElementById('camp_prom_stock_amount_"+satir_no+"')").value;
			window.frames['form_basket_ww'].satir_gonder.prom_free_stock_amount.value = eval("document.getElementById('camp_prom_free_stock_amount_"+satir_no+"')").value;
			window.frames['form_basket_ww'].satir_gonder.prom_free_stock_price.value = eval("document.getElementById('camp_prom_free_stock_price_"+satir_no+"')").value;
			window.frames['form_basket_ww'].satir_gonder.prom_free_stock_money.value = eval("document.getElementById('camp_prom_free_stock_money_"+satir_no+"')").value;
			if ((form_basket_camp_ww.satir_gonder.prom_discount.value.length) || (form_basket_camp_ww.satir_gonder.prom_amount_discount.value.length))
				window.frames['form_basket_ww'].satir_gonder.price_old.value = eval("document.getElementById('camp_price_old_"+satir_no+"')").value;
			else
				window.frames['form_basket_ww'].satir_gonder.price_old.value = '';
			window.frames['form_basket_ww'].satir_gonder.action = '<cfoutput>#request.self#</cfoutput>?fuseaction=objects2.emptypopup_add_basketww_row_camp';
			window.frames['form_basket_ww'].satir_gonder.submit();
		}
	</cfif>

	function camp_urun_gonder2(satir_no,pro_no)
	{
		if(pro_no>0)satir_no=satir_no+'_'+pro_no;
		istenen_miktar = 1;
		camp_satir_gonder.istenen_miktar.value = istenen_miktar;
		camp_satir_gonder.price_catid_2.value = '<cfoutput>#attributes.price_catid_2#</cfoutput>';
		camp_satir_gonder.pid.value = eval("document.getElementById('camp_pid_"+satir_no+"')").value;
		camp_satir_gonder.product_id.value = eval("document.getElementById('camp_pid_"+satir_no+"')").value;
		camp_satir_gonder.sid.value = eval("document.getElementById('camp_sid_"+satir_no+"')").value;
		camp_satir_gonder.price.value = eval("document.getElementById('camp_price_"+satir_no+"')").value;
		camp_satir_gonder.price_kdv.value = eval("document.getElementById('camp_price_kdv_"+satir_no+"')").value;
		camp_satir_gonder.price_money.value = eval("document.getElementById('camp_price_money_"+satir_no+"')").value;
	
		camp_satir_gonder.price_standard.value = eval("document.getElementById('camp_price_standard_"+satir_no+"')").value;
		camp_satir_gonder.price_standard_kdv.value = eval("document.getElementById('camp_price_standard_kdv_"+satir_no+"')").value;
		camp_satir_gonder.price_standard_money.value = eval("document.getElementById('camp_price_standard_money_"+satir_no+"')").value;
	
		camp_satir_gonder.prom_id.value = eval("document.getElementById('camp_prom_id_"+satir_no+"')").value;
		camp_satir_gonder.prom_discount.value = eval("document.getElementById('camp_prom_discount_"+satir_no+"')").value;
		camp_satir_gonder.prom_amount_discount.value = eval("document.getElementById('camp_prom_amount_discount_"+satir_no+"')").value;
		camp_satir_gonder.prom_cost.value = eval("document.getElementById('camp_prom_cost_"+satir_no+"')").value;
		camp_satir_gonder.prom_free_stock_id.value = eval("document.getElementById('camp_prom_free_stock_id_"+satir_no+"')").value;
		camp_satir_gonder.prom_stock_amount.value = eval("document.getElementById('camp_prom_stock_amount_"+satir_no+"')").value;
		camp_satir_gonder.prom_free_stock_amount.value = eval("document.getElementById('camp_prom_free_stock_amount_"+satir_no+"')").value;
		camp_satir_gonder.prom_free_stock_price.value = eval("document.getElementById('camp_prom_free_stock_price_"+satir_no+"')").value;
		camp_satir_gonder.prom_free_stock_money.value = eval("document.getElementById('camp_prom_free_stock_money_"+satir_no+"')").value;
		if ((camp_satir_gonder.prom_discount.value.length) || (camp_satir_gonder.prom_amount_discount.value.length))
			camp_satir_gonder.price_old.value = eval("document.getElementById('camp_price_old_"+satir_no+"')").value;
	
		camp_satir_gonder.action = '<cfoutput>#request.self#</cfoutput>?fuseaction=objects2.detail_product';
		<cfif attributes.is_popup eq 1>
			windowopen('','list','product_window');
		camp_satir_gonder.target = 'product_window';
		camp_satir_gonder.action = '<cfoutput>#request.self#</cfoutput>?fuseaction=objects2.popup_detail_product';
		</cfif>
		camp_satir_gonder.submit();
	}


	<cfif attributes.product_compare eq 1>
		function karsilastir()
		{   
			secilenler = '';
			kontrol = 0;
			<cfloop from="1" to="#listlen(product_all_list)#" index="pk">
				<cfoutput>
					<cfif listlen(product_all_list) gt 1>
					if(document.getElementsByName('product_id')[#pk-1#]!=undefined && document.getElementsByName('product_id')[#pk-1#].checked == true)
						{
						kontrol = kontrol + 1;
						if(secilenler.length==0)
							secilenler = document.getElementsByName('product_id')[#pk-1#].value;
						else
							secilenler = secilenler + ',' + document.getElementsByName('product_id')[#pk-1#].value;
						}
					<cfelseif listlen(product_all_list) eq 1>
					if(document.getElementById('product_id').checked == true)
						secilenler = document.getElementById('product_id').value;
						kontrol = 1;
					</cfif>
				</cfoutput>
			</cfloop>
				if(kontrol > 4)
					{
					alert("<cf_get_lang no ='1148.Dörtten Fazla Ürünle Karşılaştırma Yapılamaz'>!");
					return false;
					}
				if(kontrol >= 2)
					window.location.href='<cfoutput>#request.self#?fuseaction=objects2.product_compare&product_id=</cfoutput>'+secilenler;
				else
					{
					alert("<cf_get_lang_main no ='313.Ürün seçmelisiniz'> !");
					return false;
					}
		}
	</cfif>
</script>
