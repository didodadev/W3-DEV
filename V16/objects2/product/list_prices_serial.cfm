<cfif attributes.is_price eq 0><!--- puanli urun basketi degilse ürün fiyatı basilmadan basket gelmez --->
	<cfset attributes.is_basket = 0>
</cfif>
<!--- Detaylı Ürün arama için gerekli --->
<cfif (isdefined("attributes.price_first_value") and len(attributes.price_first_value)) or (isdefined("attributes.price_last_value") and len(attributes.price_last_value))>
	<cfquery name="get_details_money" datasource="#dsn2#">
		SELECT
			RATE1,
			<cfif isDefined("session.pp")>
				RATEPP2 RATE2
			<cfelse>
				RATEWW2 RATE2
			</cfif>
		FROM
			SETUP_MONEY
		WHERE
			MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.detail_money_type#">
	</cfquery>
	<cfif isdefined("attributes.price_first_value") and len(attributes.price_first_value)>
		<cfset attributes.price_first_value = attributes.price_first_value / get_details_money.rate1 * get_details_money.rate2>
	</cfif>
	<cfif isdefined("attributes.price_last_value") and len(attributes.price_last_value)>
		<cfset attributes.price_last_value = attributes.price_last_value / get_details_money.rate1 * get_details_money.rate2>
	</cfif>
</cfif>
<cfif isdefined("attributes.altgrup") and len(attributes.altgrup)><cfset attributes.product_catid = attributes.altgrup></cfif>
<cfif isdefined("attributes.marka") and len(attributes.marka)><cfset attributes.brand_id = attributes.marka></cfif>
<cfparam name="attributes.price_catid" default="-2">
<cfparam name="attributes.price_catid_2" default="-2">
<cfparam name="attributes.employee" default="">
<cfparam name="attributes.pos_code" default="">
<cfparam name="attributes.get_company_id" default="">
<cfparam name="attributes.get_company" default="">
<cfif isdefined("attributes.product_catid") and not isdefined("attributes.product_cat")><cfset attributes.product_cat=" "></cfif>
<cfparam name="attributes.product_cat" default="">
<cfparam name="attributes.product_catid" default="0">
<cfparam name="attributes.hierarchy" default="">
<cfif isdefined("attributes.brand_id") and not isdefined("attributes.brand_name")><cfset attributes.brand_name=""></cfif>
<cfparam name="attributes.brand_id" default="">
<cfparam name="attributes.brand_name" default="">
<cfparam name="attributes.is_promotion" default="0">
<cfif isdefined("attributes.PRODUCT_CATID") and len(attributes.PRODUCT_CATID)>
	<cfquery name="GET_PRODUCT_CATS" datasource="#DSN3#">
		SELECT PRODUCT_CAT,IS_CUSTOMIZABLE,HIERARCHY FROM PRODUCT_CAT WHERE PRODUCT_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_catid#">
	</cfquery>
</cfif>
<cfparam name="attributes.order_element" default="PRODUCT_NAME">
<cfparam name="attributes.order_type" default="ASC">
<cfparam name="attributes.maxrows" default="20">
<cfinclude template="box.cfm">
<cfif attributes.is_price or (isdefined('attributes.is_basket_standart') and attributes.is_basket_standart eq 0)><!--- fiyat istenmemis ise buraya girmesi gerekmez --->
	<cfinclude template="../query/get_price_cats_moneys.cfm">
</cfif><!--- fiyat istenmemis ise buraya girmesi gerekmez --->
<cfquery name="get_homepage_products" datasource="#DSN3#">
	SELECT
		DISTINCT
			STOCKS.STOCK_ID,
			PRODUCT.PRODUCT_ID,
			STOCKS.STOCK_CODE,
			GS.AMOUNT,
			GS.PRICE AS REAL_PRICE,
			GS.OTHER_MONEY AS REAL_MONEY,
			GS.DEPARTMENT_ID AS SERI_SONU_DEPARTMENT_ID,
			GS.LOCATION_ID AS SERI_SONU_LOCATION_ID,
			PRODUCT.PRODUCT_NAME,
			STOCKS.PROPERTY,
			STOCKS.BARCOD,
			PRODUCT.TAX,
			PRODUCT.IS_ZERO_STOCK,
			PRODUCT.BRAND_ID,
			PRODUCT.PRODUCT_CODE,
			PRODUCT.PRODUCT_DETAIL,
			PRODUCT.PRODUCT_CATID,
			PRODUCT.RECORD_DATE,
			PRODUCT.IS_PRODUCTION,
			STOCKS.PRODUCT_UNIT_ID,
			PRICE_STANDART.PRICE PRICE,
			PRICE_STANDART.MONEY MONEY,
			PRICE_STANDART.IS_KDV IS_KDV,
			PRICE_STANDART.PRICE_KDV PRICE_KDV,
			PRODUCT.PRODUCT_DETAIL2,
			PRODUCT.PRODUCT_CODE_2
		FROM
			PRODUCT,
			PRODUCT_CAT,
			#dsn1_alias#.PRODUCT_CAT_OUR_COMPANY AS PRODUCT_CAT_OUR_COMPANY,
			STOCKS,
			PRICE_STANDART,
			#dsn2_alias#.GET_END_SERIES_PROCESSES GS,
			PRODUCT_UNIT
			<cfif (isdefined("attributes.price_first_value") and len(attributes.price_first_value)) or (isdefined("attributes.price_last_value") and len(attributes.price_last_value))>
			,#dsn2_alias#.SETUP_MONEY SETUP_MONEY
			</cfif>
		WHERE
			PRODUCT_CAT.PRODUCT_CATID = PRODUCT_CAT_OUR_COMPANY.PRODUCT_CATID AND
			PRODUCT_CAT_OUR_COMPANY.OUR_COMPANY_ID = <cfqueryparam value="#session_base.our_company_id#" cfsqltype="cf_sql_integer"> AND
			PRICE_STANDART.PRICE ><cfqueryparam value="0" cfsqltype="cf_sql_float"> AND
			PRODUCT.PRODUCT_ID = STOCKS.PRODUCT_ID AND
			PRODUCT_CAT.PRODUCT_CATID = PRODUCT.PRODUCT_CATID AND
			PRODUCT_UNIT.PRODUCT_ID = STOCKS.PRODUCT_ID AND
			STOCKS.PRODUCT_UNIT_ID = PRODUCT_UNIT.PRODUCT_UNIT_ID AND
			GS.PRODUCT_ID = PRODUCT.PRODUCT_ID AND
			GS.STOCK_ID = STOCKS.STOCK_ID AND
			PRODUCT_UNIT.IS_MAIN = 1 AND			
			<cfif isdefined("session.pp")>PRODUCT.IS_EXTRANET = <cfqueryparam value="1" cfsqltype="cf_sql_smallint"> AND<cfelse>PRODUCT.IS_INTERNET = <cfqueryparam value="1" cfsqltype="cf_sql_smallint"> AND</cfif>
			PRODUCT.PRODUCT_STATUS = 1
			AND PRICE_STANDART.PRICESTANDART_STATUS = 1	
			AND PRICE_STANDART.PURCHASESALES = 1
			AND PRICE_STANDART.PRODUCT_ID = STOCKS.PRODUCT_ID
			AND PRODUCT_UNIT.PRODUCT_UNIT_ID = PRICE_STANDART.UNIT_ID
			<cfif isdefined("attributes.keyword") and len(attributes.keyword)>
				AND PRODUCT.PRODUCT_NAME LIKE <cfqueryparam value="%#attributes.keyword#%" cfsqltype="cf_sql_varchar"> 
			</cfif>
			<cfif isdefined("attributes.detail_search_keyword") and len(attributes.detail_search_keyword)>
				AND 
				(
				 PRODUCT.PRODUCT_NAME LIKE <cfqueryparam value="%#attributes.detail_search_keyword#%" cfsqltype="cf_sql_varchar"> 
			     OR 
				 PRODUCT.PRODUCT_CODE_2 LIKE <cfqueryparam value="%#attributes.detail_search_keyword#%" cfsqltype="cf_sql_varchar">
				) 
			</cfif>
			<cfif len(attributes.product_cat) and len(attributes.product_catid)>
				AND 
				(
				PRODUCT_CAT.PRODUCT_CATID = <cfqueryparam value="#attributes.product_catid#" cfsqltype="cf_sql_integer">
				OR 
				PRODUCT_CAT.HIERARCHY LIKE <cfqueryparam value="#GET_PRODUCT_CATS.HIERARCHY#.%" cfsqltype="cf_sql_varchar">
				)
			</cfif>
			<cfif len(attributes.brand_id) or len(attributes.brand_name)>
				AND PRODUCT.BRAND_ID = <cfqueryparam value="#attributes.brand_id#" cfsqltype="cf_sql_integer">
			</cfif>
			<cfif (isdefined("attributes.price_first_value") and len(attributes.price_first_value)) or (isdefined("attributes.price_last_value") and len(attributes.price_last_value))>
				AND PRICE_STANDART.MONEY = SETUP_MONEY.MONEY
			</cfif>
			<cfif isdefined("session.pp")>
				<cfif isdefined("attributes.price_first_value") and len(attributes.price_first_value) and isdefined("attributes.price_last_value") and len(attributes.price_last_value)>
					AND PRICE_STANDART.PRICE/SETUP_MONEY.RATE1*SETUP_MONEY.RATEPP2 BETWEEN <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.price_first_value#"> AND <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.price_last_value#">
				<cfelseif isdefined("attributes.price_first_value") and len(attributes.price_first_value)>
					AND PRICE_STANDART.PRICE/SETUP_MONEY.RATE1*SETUP_MONEY.RATEPP2 >= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.price_first_value#"> 
				<cfelseif isdefined("attributes.price_last_value") and len(attributes.price_last_value)>
					AND PRICE_STANDART.PRICE/SETUP_MONEY.RATE1*SETUP_MONEY.RATEPP2 <= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.price_last_value#"> 
				</cfif>
			<cfelseif isdefined("session.ww")>
				<cfif isdefined("attributes.price_first_value") and len(attributes.price_first_value) and isdefined("attributes.price_last_value") and len(attributes.price_last_value)>
					AND PRICE_STANDART.PRICE/SETUP_MONEY.RATE1*SETUP_MONEY.RATEWW2 BETWEEN <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.price_first_value#"> AND <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.price_last_value#">
				<cfelseif isdefined("attributes.price_first_value") and len(attributes.price_first_value)>
					AND PRICE_STANDART.PRICE/SETUP_MONEY.RATE1*SETUP_MONEY.RATEWW2 >= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.price_first_value#"> 
				<cfelseif isdefined("attributes.price_last_value") and len(attributes.price_last_value)>
					AND PRICE_STANDART.PRICE/SETUP_MONEY.RATE1*SETUP_MONEY.RATEWW2 <= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.price_last_value#"> 
				</cfif>
			</cfif>
			<cfif isdefined("attributes.is_saleable_stock")>AND GS.SALEABLE_STOCK > 0</cfif>
		ORDER BY
			<cfif isdefined("attributes.new_products")>
				PRODUCT.PRODUCT_ID DESC
			<cfelseif isdefined("attributes.high_sales")>
				SATIS DESC
			<cfelseif not isdefined("attributes.order_element")>
				PRODUCT.PRODUCT_NAME
			<cfelseif attributes.order_element is 'PRODUCT_STOCK'>
				GS.AMOUNT <cfoutput>#attributes.order_type#</cfoutput>
			<cfelseif attributes.order_element is 'PRODUCT_NAME'>
				PRODUCT.PRODUCT_NAME <cfoutput>#attributes.order_type#</cfoutput>	
			<cfelseif attributes.order_element is 'PRICE'>
				PRICE_STANDART.PRICE <cfoutput>#attributes.order_type#</cfoutput>
			<cfelse>
				PRODUCT.PRODUCT_NAME
			</cfif>
</cfquery>
<cfset adres = "#fusebox.circuit#.#fusebox.fuseaction#">
<cfset adres_2 = "">
<cfif isdefined("attributes.keyword") and len(attributes.keyword)>
	<cfset adres = adres & "&keyword=#attributes.keyword#">
</cfif>
<cfif isdefined("attributes.product_catid") and len(attributes.product_catid) and len(attributes.product_cat)>
	<cfset adres = adres & "&product_catid=#attributes.product_catid#">
	<cfset adres = adres & "&product_cat=#attributes.product_cat#">
</cfif>
<cfif isdefined("GET_PRODUCT_CATS.hierarchy") and len(GET_PRODUCT_CATS.hierarchy)>
	<cfset adres = adres & "&hierarchy=#GET_PRODUCT_CATS.hierarchy#">
</cfif>
<cfif isdefined("attributes.brand_id") and len(attributes.brand_id)>
	<cfset adres = adres & "&brand_id=#attributes.brand_id#">
</cfif>
<cfif isdefined("attributes.segment_id") and len(attributes.segment_id)>
	<cfset adres = adres & "&segment_id=#attributes.segment_id#">
</cfif>
<cfif isdefined("attributes.brand_id") and len(attributes.brand_name)>
	<cfset adres = adres & "&brand_name=#attributes.brand_name#">
</cfif>
<cfif isdefined("attributes.list_property_id") and len(attributes.list_property_id)>
	<cfset adres = adres & "&list_property_id=#attributes.list_property_id#">
</cfif>
<cfif isdefined("attributes.list_variation_id") and len(attributes.list_variation_id)>
	<cfset adres = adres & "&list_variation_id=#attributes.list_variation_id#">
</cfif>
<cfif isdefined("attributes.company_id") and len(attributes.company_id)>
	<cfset adres = adres & "&company_id=#attributes.company_id#">
</cfif>
<cfif isdefined("attributes.consumer_id") and len(attributes.consumer_id)>
	<cfset adres = adres & "&consumer_id=#attributes.consumer_id#">
</cfif>
<cfif isdefined('attributes.is_saleable_stock')>
	<cfset adres_2 = "&is_saleable_stock=#attributes.is_saleable_stock#">
</cfif>
<cfif isdefined("attributes.price_first_value") and len(attributes.price_first_value)>
	<cfset adres = adres & "&price_first_value=#attributes.price_first_value#">
</cfif>
<cfif isdefined("attributes.price_last_value") and len(attributes.price_last_value)>
	<cfset adres = adres & "&price_last_value=#attributes.price_last_value#">
</cfif>
<cfif isdefined("attributes.detail_money_type") and len(attributes.detail_money_type)>
	<cfset adres = adres & "&detail_money_type=#attributes.detail_money_type#">
</cfif>
<cfif isdefined("attributes.detail_search_keyword") and len(attributes.detail_search_keyword)>
	<cfset adres = adres & "&detail_search_keyword=#attributes.detail_search_keyword#">
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.totalrecords" default='#get_homepage_products.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<cfset stock_list=''>
<cfset brand_list = ''>
<cfset product_id_list = ''>

<cfif get_homepage_products.recordcount>
	<cfoutput query="get_homepage_products" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
		<cfset stock_list = listappend(stock_list,STOCK_ID)>
		<cfif attributes.is_brand>
			<cfif not listfindnocase(brand_list,get_homepage_products.brand_id)>
				<cfset brand_list = listappend(brand_list,get_homepage_products.brand_id,',')>
			</cfif>
		</cfif>
		<cfif attributes.is_image>
			<cfif not listfindnocase(product_id_list,get_homepage_products.product_id)>
				<cfset product_id_list = listappend(product_id_list,get_homepage_products.product_id,',')>
			</cfif>
		</cfif>
	</cfoutput> 
</cfif>

<cfset product_all_list = "">
<table width="100%" border="0" align="center">
  <tr>
	<td height="25" class="formbold">
	<cf_get_lang no='410.Seri Sonu Ürünler'>
	<cfif isdefined("attributes.brand_id") and len(attributes.brand_id)>
		<cfinclude template="../query/get_brand.cfm">
		<cfoutput>> #get_brand.brand_name#</cfoutput> > 
	</cfif>
	<cfif isdefined("attributes.PRODUCT_CATID") and len(attributes.PRODUCT_CATID)>
		<cfoutput>> #get_product_cats.product_cat#</cfoutput>
	</cfif>
	<cfif isdefined("attributes.keyword") and len(attributes.keyword)>
		 <span class="label"><font color="#CC6600"><cfoutput>> #attributes.keyword#</cfoutput></font></span>
	</cfif>
		</td>
	<cfform name="sayfalama_" method="post" action="#request.self#?fuseaction=#adres#">
		<td  style="text-align:right;">
			&nbsp;&nbsp;&nbsp;&nbsp;
			<cf_get_lang no='414.Sayfalama'>
			<select name="maxrows" id="maxrows" onchange="sayfalama.submit();">
				<option value="20" <cfif attributes.maxrows eq 20>selected</cfif>>20</option>
				<option value="50" <cfif attributes.maxrows eq 50>selected</cfif>>50</option>
				<option value="100" <cfif attributes.maxrows eq 100>selected</cfif>>100</option>
			</select>
		</td>
	</td>
	</cfform>
  </tr>
</table>
<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
  <tr>
	<td>
	<table width="100%" border="0" cellpadding="1" cellspacing="1">
          <tr class="color-header" height="20">
			<cfif attributes.product_compare eq 1 and attributes.is_image><td colspan="2"><a href="javascript://" onClick="karsilastir();"><img src="../objects2/image/karsila.gif" style="cursor:pointer"></a></td>
			<cfelseif attributes.is_image><td>&nbsp;</td>
			<cfelseif attributes.product_compare><td>&nbsp;</td>
			</cfif>
            <cfif attributes.is_brand eq 1><td class="form-title"><cf_get_lang_main no='1435.Marka'></td></cfif>
			<td class="form-title">
			<cfoutput>
			<cfif isdefined("attributes.order_element") and attributes.order_element is 'PRODUCT_NAME' and attributes.order_type is 'DESC'>
				<a href="#request.self#?fuseaction=#adres##adres_2#&order_element=PRODUCT_NAME&order_type=ASC"><img src="/images/open_close_2.gif" border="0" align="absmiddle"></a>
			<cfelseif isdefined("attributes.order_element") and attributes.order_element is 'PRODUCT_NAME' and attributes.order_type is 'ASC'>
				<a href="#request.self#?fuseaction=#adres##adres_2#&order_element=PRODUCT_NAME&order_type=DESC"><img src="/images/open_close_3.gif" border="0" align="absmiddle"></a>
			<cfelse>
				<a href="#request.self#?fuseaction=#adres##adres_2#&order_element=PRODUCT_NAME&order_type=DESC"><img src="/images/open_close_1.gif" border="0" align="absmiddle"></a>
			</cfif>
			</cfoutput>
			<cf_get_lang_main no='245.Ürün'></td>
			<cfif isdefined("attributes.is_product_code") and attributes.is_product_code eq 1><td width="50"  class="form-title" style="text-align:right;"><cf_get_lang_main no='377.Özel Kod'></td></cfif>
			<cfif attributes.is_stock_count eq 1><td width="40"  class="form-title" style="text-align:right;"><cf_get_lang_main no='40.Stok'></td></cfif>
			<cfif attributes.is_price eq 1>
				<td  class="form-title" style="text-align:right;">
				<cfoutput>
				<cfif isdefined("attributes.order_element") and attributes.order_element is 'PRICE' and attributes.order_type is 'DESC'>
					<a href="#request.self#?fuseaction=#adres##adres_2#&order_element=PRICE&order_type=ASC"><img src="/images/open_close_2.gif" border="0" align="absmiddle"></a>
				<cfelseif isdefined("attributes.order_element") and attributes.order_element is 'PRICE' and attributes.order_type is 'ASC'>
					<a href="#request.self#?fuseaction=#adres##adres_2#&order_element=PRICE&order_type=DESC"><img src="/images/open_close_3.gif" border="0" align="absmiddle"></a>
				<cfelse>
					<a href="#request.self#?fuseaction=#adres##adres_2#&order_element=PRICE&order_type=DESC"><img src="/images/open_close_1.gif" border="0" align="absmiddle"></a>
				</cfif>
				</cfoutput>
				<cfif isdefined('session.pp.userid') or isdefined('session.ww.userid')><cf_get_lang no='421.Son Kullanıcı'><cfelse><cf_get_lang_main no='672.Fiyat'></cfif></td>
				<cfif isdefined('session.ww.userid') or isdefined('session.pp.userid')><td  class="form-title" style="text-align:right;"><cf_get_lang no='412.Size Özel Fiyat'></td></cfif>
			</cfif>
			<cfif attributes.is_price_kdvsiz eq 1>
				<td class="form-title" width="40"><cf_get_lang no='408.KDV siz Fiyat'> <cfoutput>#session_base.money#</cfoutput></td>
			</cfif>
            <cfif attributes.is_basket eq 1>
				<td class="form-title" width="40"><cf_get_lang_main no='223.Miktar'></td>
				<td width="20"></td>
			</cfif>
			<cfif (isdefined("session.ww.userid") or isdefined("session.pp.userid")) and attributes.is_demand eq 1><td></td></cfif>
          </tr>
	<cfif get_homepage_products.recordcount>
		<cfif attributes.is_brand eq 1 and listlen(brand_list)>
			<cfset brand_list=listsort(brand_list,"numeric","ASC",",")>
			<cfif listlen(brand_list)>
				<cfquery name="get_brands" datasource="#dsn3#">
					SELECT BRAND_NAME,BRAND_ID FROM PRODUCT_BRANDS WHERE BRAND_ID IN (#brand_list#)
				</cfquery>
			</cfif>
			<cfset main_brand_list = listsort(listdeleteduplicates(valuelist(GET_BRANDS.BRAND_ID,',')),'numeric','ASC',',')>
		</cfif>
			
		<cfif attributes.is_image eq 1>
			<cfif listlen(product_id_list)>
				<cfquery name="get_product_images" datasource="#dsn3#">
					SELECT PATH,PRODUCT_ID,PATH_SERVER_ID FROM PRODUCT_IMAGES WHERE IMAGE_SIZE = 1 AND PRODUCT_ID IN (#product_id_list#) ORDER BY PRODUCT_ID
				</cfquery>
				<cfquery name="get_product_images_big" datasource="#dsn3#">
					SELECT PATH,PRODUCT_ID,PATH_SERVER_ID FROM PRODUCT_IMAGES WHERE IMAGE_SIZE = 2 AND PRODUCT_ID IN (#product_id_list#) ORDER BY PRODUCT_ID
				</cfquery>
				<cfset product_id_list = listdeleteduplicates(valuelist(get_product_images.PRODUCT_ID,','),'numeric','ASC',',')>
				<cfset product_id_list=listsort(product_id_list,"numeric","ASC",",")>
				<cfset big_product_id_list = listdeleteduplicates(valuelist(get_product_images_big.PRODUCT_ID,','),'numeric','ASC',',')>
				<cfset big_product_id_list=listsort(big_product_id_list,"numeric","ASC",",")>
			</cfif>
		</cfif>
		
		<cfoutput query="get_homepage_products" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
				 <cfif attributes.is_price><!--- fiyat istenmemis ise buraya girmesi gerekmez --->
					<cfif isDefined("money")>
						<cfset attributes.money = money>
					</cfif>
					<cfloop query="moneys">
						<cfif moneys.money is attributes.money>
							<cfset row_money = money >
							<cfset row_money_rate1 = moneys.rate1>
							<cfset row_money_rate2 = moneys.rate2>
						</cfif>
					</cfloop>
					<cfset pro_price = price>
					<cfset pro_price_kdv = price_kdv>
				</cfif><!--- fiyat istenmemis ise buraya girmesi gerekmez --->
					 <tr>
							  <cfif attributes.is_stock_count eq 1 or attributes.is_basket eq 1>
							  <!--- stok durum blogu --->
								<cfset usable_stock_amount = AMOUNT>
							  <!--- stok durum blogu --->
							  </cfif>
							  <cfset product_all_list = listappend(product_all_list,product_id)>
							  <cfif attributes.product_compare eq 1>
								<td><input type="checkbox" name="serisonu_product_id" id="serisonu_product_id" value="#product_id#"></td><!--- #currentrow#-#PRODUCT_STOCK# --->
							  </cfif>
							  <cfif attributes.is_image eq 1>
							  <td width="50" align="center" height="60" id="product_image_#currentrow#">
							  <cfif listfindnocase(product_id_list,product_id)>
								#box_ust#
								<cfset small_image_server = listgetat(fusebox.server_machine_list,get_product_images.path_server_id[listfind(product_id_list,product_id,',')],';')>
								<cfif listfindnocase(big_product_id_list,product_id)>
									<cfset big_image_server = listgetat(fusebox.server_machine_list,get_product_images_big.path_server_id[listfind(big_product_id_list,product_id,',')],';')>
									<!--- <a href="javascript://" onClick="windowopen('#big_image_server#/documents/product/#get_product_images_big.path[listfind(big_product_id_list,product_id,',')]#','small');"><img src="#small_image_server#/documents/product/#get_product_images.path[listfind(product_id_list,product_id,',')]#" border="0" width="65" height="50"></a> --->
									<a href="#request.self#?fuseaction=objects2.detail_product&product_id=#product_id#&stock_id=#stock_id#" title="#PRODUCT_DETAIL#"><img src="#small_image_server#/documents/product/#get_product_images.path[listfind(product_id_list,product_id,',')]#" border="0" width="65" height="50"></a>
								<cfelse>
									<img src="#small_image_server#/documents/product/#get_product_images.path[listfind(product_id_list,product_id,',')]#" border="0" width="65" height="50">
								</cfif>
								#box_alt#
							  </cfif>
							  </td>
							  </cfif>
							  <cfif attributes.is_brand eq 1>
								  <td><cfif len(brand_id)>#get_brands.brand_name[listfind(main_brand_list,brand_id,',')]#</cfif></td>
							  </cfif>
							  <td> 
								<cfif attributes.is_price>
									<a href="##" onclick="urun_gonder2_serisonu('#currentrow#','0');" class="inner_menu_link" title="#PRODUCT_DETAIL#"><cfif not isdefined("attributes.is_detail2") or attributes.is_detail2 eq 0 or not len (PRODUCT_DETAIL2)>#PRODUCT_NAME#<cfif PROPERTY is '-'><cfelseif len(PROPERTY) gt 1>&nbsp;#PROPERTY#</cfif><cfelse>#PRODUCT_DETAIL2#</cfif></a>
								<cfelse>
									<a href="#request.self#?fuseaction=objects2.detail_product&product_id=#product_id#&stock_id=#stock_id#" class="inner_menu_link" title="#PRODUCT_DETAIL#"><cfif not isdefined("attributes.is_detail2") or attributes.is_detail2 eq 0 or not len (PRODUCT_DETAIL2)>#PRODUCT_NAME#<cfif PROPERTY is '-'><cfelseif len(PROPERTY) gt 1>&nbsp;#PROPERTY#</cfif><cfelse>#PRODUCT_DETAIL2#</cfif></a>
								</cfif>
								<cfif isdefined('attributes.is_bundle') and attributes.is_bundle eq 1>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="#request.self#?fuseaction=objects2.detail_product&product_id=#product_id#&stock_id=#stock_id#" class="inner_menu_link" title="#PRODUCT_DETAIL#"><cf_get_lang_main no='643.Bundle Detayını Görmek İçin Tıklayınız'>!</a></cfif>
								<cfif attributes.is_price><!--- fiyat istenmemis ise buraya girmesi gerekmez --->
									<input type="hidden" name="serisonu_pid_#currentrow#" id="serisonu_pid_#currentrow#" value="#product_id#">
									<input type="hidden" name="serisonu_sid_#currentrow#" id="serisonu_sid_#currentrow#" value="#stock_id#">
									<input type="hidden" name="serisonu_location_id_#currentrow#" id="serisonu_location_id_#currentrow#" value="#SERI_SONU_LOCATION_ID#">
									<input type="hidden" name="serisonu_department_id_#currentrow#" id="serisonu_department_id_#currentrow#" value="#SERI_SONU_DEPARTMENT_ID#">
									<input type="hidden" name="serisonu_prom_id_#currentrow#" id="serisonu_prom_id_#currentrow#" value="">
									<input type="hidden" name="serisonu_prom_discount_#currentrow#" id="serisonu_prom_discount_#currentrow#" value="">
									<input type="hidden" name="serisonu_prom_amount_discount_#currentrow#" id="serisonu_prom_amount_discount_#currentrow#" value="">
									<input type="hidden" name="serisonu_prom_cost_#currentrow#" id="serisonu_prom_cost_#currentrow#" value="">
									<input type="hidden" name="serisonu_prom_free_stock_id_#currentrow#" id="serisonu_prom_free_stock_id_#currentrow#" value="">				
									<input type="hidden" name="serisonu_prom_stock_amount_#currentrow#" id="serisonu_prom_stock_amount_#currentrow#" value="1">
									<input type="hidden" name="serisonu_prom_free_stock_amount_#currentrow#" id="serisonu_prom_free_stock_amount_#currentrow#" value="1">
									<input type="hidden" name="serisonu_prom_free_stock_price_#currentrow#" id="serisonu_prom_free_stock_price_#currentrow#" value="0">
									<input type="hidden" name="serisonu_prom_free_stock_money_#currentrow#" id="serisonu_prom_free_stock_money_#currentrow#" value="">
									<input type="hidden" name="serisonu_price_old_#currentrow#" id="serisonu_price_old_#currentrow#" value="">
									<input type="hidden" name="serisonu_price_#currentrow#" id="serisonu_price_#currentrow#" value="#real_price#">
									<input type="hidden" name="serisonu_price_kdv_#currentrow#" id="serisonu_price_kdv_#currentrow#" value="#real_price*(1+(tax/100))#">
									<input type="hidden" name="serisonu_price_money_#currentrow#" id="serisonu_price_money_#currentrow#" value="#row_money#">
									<input type="hidden" name="serisonu_price_standard_#currentrow#" id="serisonu_price_standard_#currentrow#" value="#PRICE#">
									<input type="hidden" name="serisonu_price_standard_kdv_#currentrow#" id="serisonu_price_standard_kdv_#currentrow#" value="#PRICE*(1+(tax/100))#">
									<input type="hidden" name="serisonu_price_standard_money_#currentrow#" id="serisonu_price_standard_money_#currentrow#" value="#money#">
								</cfif><!--- fiyat istenmemis ise buraya girmesi gerekmez --->
								<cfif attributes.is_detail><br/>#PRODUCT_DETAIL#</cfif>
							  </td>
							  <cfif isdefined("attributes.is_product_code") and attributes.is_product_code eq 1>
							  	<td  style="text-align:right;"><cfif len(product_code_2)>#product_code_2#<cfelse>&nbsp;</cfif></td>
							  </cfif>
							  <cfif attributes.is_stock_count eq 1>
							  <td  style="text-align:right;">
								  <cfif usable_stock_amount lt 0>0
								  <cfelseif usable_stock_amount lt 5>
									<cfif isnumeric(usable_stock_amount)>
										#amountformat(usable_stock_amount,0)#
									<cfelse>
										#usable_stock_amount#
									</cfif>
								  <cfelseif usable_stock_amount lt 10>5+
								  <cfelseif usable_stock_amount lt 20>10+
								  <cfelseif usable_stock_amount lt 50>20+
								  <cfelseif usable_stock_amount lt 100>50+
								  <cfelse>100+
								  </cfif>
							  </td>
							  </cfif>
							  <cfif attributes.is_price><!--- fiyat istenmemis ise buraya girmesi gerekmez --->
								<td  style="text-align:right;">#TLFormat(price)# #row_money# <cfif isdefined("attributes.is_kdv_alert") and attributes.is_kdv_alert eq 1>+ KDV</cfif></td>
								<td>#TLFormat(real_price)# #real_money# <cfif isdefined("attributes.is_kdv_alert") and attributes.is_kdv_alert eq 1>+ KDV</cfif></td>
							  </cfif>
							  <cfif attributes.is_price_kdvsiz eq 1>
								<td  style="text-align:right;">
								<cfquery name="get_money_info" datasource="#dsn2#">
									SELECT
										(RATE2/RATE1) RATE
									FROM 
										SETUP_MONEY
									WHERE
										MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#money#">
								</cfquery>
									#TLFormat(real_price*get_money_info.RATE)# 
									<cfif isdefined("session.ww")>#session.ww.money#<cfelse>#session.pp.money#</cfif>
									<!--- kdv yazısı gözüksün dediği zaman gelir --->
									<cfif isdefined("attributes.is_kdv_alert") and attributes.is_kdv_alert eq 1>+ KDV</cfif>
								</td>
							</cfif>
							  <cfif attributes.is_basket eq 1>
									<cfif (IS_ZERO_STOCK eq 1 or (IS_ZERO_STOCK neq 1 and usable_stock_amount gt 0) or IS_PRODUCTION eq 1) and real_price gt 0>
										<td><input type="text" name="serisonu_miktar_#currentrow#" id="serisonu_miktar_#currentrow#" value="1" style="width:40px;" class="moneybox" onkeyup="return(FormatCurrency(this,event,0));"></td>
										<td width="20" align="center" nowrap>
										<a href="javascript://" onClick="urun_gonder_serisonu('#currentrow#','0');" class="formbold" style="font-size:13px;"><img src="../../images/online_basket.gif" title="<cf_get_lang_main no='1376.Sepete At'>" border="0"></a>
										</td>
									<cfelse>
										<td colspan="2" class="table_warning" align="center"><cf_get_lang no='409.STOKTA YOK'></td>
									</cfif>
							  </cfif>
							<cfif (isdefined("session.ww.userid") or isdefined("session.pp.userid")) and attributes.is_demand eq 1>
								<td nowrap>
									<cfif attributes.is_price eq 1><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects2.popup_add_order_demand&stock_id=#stock_id#&price=#musteri_flt_other_money_value#&price_money=#musteri_row_money#&unit_id=#PRODUCT_UNIT_ID#&demand_type=1','small');"><img src="/images/uyar.gif" title="<cf_get_lang no ='1144.Fiyat Düşünce Haber Ver'>" border="0"></a></cfif>
									<cfif (attributes.is_stock_count eq 1 or attributes.is_basket eq 1) and IS_ZERO_STOCK neq 1 and isdefined("usable_stock_amount") and usable_stock_amount lte 0 and attributes.is_price eq 1>
										<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects2.popup_add_order_demand&stock_id=#stock_id#&price=#price_form#&price_money=#musteri_row_money#&unit_id=#PRODUCT_UNIT_ID#&demand_type=2','small');"><img src="/images/ship.gif" title="<cf_get_lang no ='1145.Stoklara Gelince Haber Ver'>" border="0"></a>
										<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects2.popup_add_order_demand&stock_id=#stock_id#&price=#price_form#&price_money=#musteri_row_money#&unit_id=#PRODUCT_UNIT_ID#&demand_type=3','small');"><img src="/images/target_customer.gif" title="<cf_get_lang no ='1146.Ön Sipariş/ Rezerve'>" border="0"></a>
									</cfif>
								</td>
							</cfif>
							</tr>
							<tr height="1">
							<td colspan="10"><hr style="height:1px;" color="E9E9E9"></td>
						  </tr>
		  </cfoutput>
		 <cfelse>
		 <tr class="color-row">
		 <td colspan="10" height="20"><cf_get_lang no='273.Bu Kategoriye Ait Ürün Bulunamadı'>!</td>
		 </tr>
		</cfif> 
       </table>
	</td>
</tr>
<cfif attributes.product_compare eq 1>
	<tr>
		<td height="35"><a href="javascript://" onClick="karsilastir_serisonu();"><img src="../objects2/image/karsila.gif" style="cursor:pointer"></a></td>
	</tr>
</cfif>
</table>

<cfif attributes.totalrecords gt attributes.maxrows>
<table cellpadding="0" cellspacing="0" border="0" width="98%" height="25" align="center">
  <tr> 
	<td>
	  <cf_pages page="#attributes.page#"
		    maxrows="#attributes.maxrows#"
			totalrecords="#attributes.totalrecords#"
			startrow="#attributes.startrow#"
			adres="#adres##adres_2#&order_element=#attributes.order_element#&order_type=#attributes.order_type#">
	</td>
	<!-- sil -->
	<td  style="text-align:right;"> <cfoutput><cf_get_lang_main no='128.Toplam Kayıt'>:#attributes.totalrecords#&nbsp;-&nbsp;<cf_get_lang_main no='169.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td>
	<!-- sil -->
  </tr>
</table>
<br/>
</cfif>

<cfif attributes.is_basket eq 1>
	<iframe name="form_basket_ww_serisonu" id="form_basket_ww_serisonu" src="<cfoutput>#request.self#</cfoutput>?fuseaction=objects2.popup_iframe_form_basket" width="0" height="0" scrolling="yes" frameborder="1"></iframe>
</cfif>

<form action="" method="post" name="satir_gonder_serisonu">
	<input type="hidden" name="is_from_seri_sonu" id="is_from_seri_sonu" value="1">
	<input type="hidden" name="seri_sonu_location_id" id="seri_sonu_location_id" value="">
	<input type="hidden" name="seri_sonu_department_id" id="seri_sonu_department_id" value="">
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
	<input type="hidden" name="prom_cost" id="prom_cost" iprom_cost value="">
	<input type="hidden" name="prom_free_stock_id" id="prom_free_stock_id" value="">
	<input type="hidden" name="prom_stock_amount" id="prom_stock_amount" value="1">
	<input type="hidden" name="prom_free_stock_amount" id="prom_free_stock_amount" value="1">
	<input type="hidden" name="prom_free_stock_price" id="prom_free_stock_price" value="0">
	<input type="hidden" name="prom_free_stock_money" id="prom_free_stock_money" value="">	
	<input type="hidden" name="price_standard" id="price_standard" value="">
	<input type="hidden" name="price_standard_kdv" id="price_standard_kdv" value="">
	<input type="hidden" name="price_standard_money" id="price_standard_money" value="">
</form>



<script type="text/javascript">
<cfif attributes.is_basket eq 1>
function urun_gonder_serisonu(satir_no,pro_no)
{
	if(pro_no>0)satir_no=satir_no+'_'+pro_no;
	istenen_miktar = filterNum(eval("document.getElementById('serisonu_miktar_"+satir_no+"')").value);
	if(istenen_miktar.length==0 || istenen_miktar =='')
		{
			alert("<cf_get_lang no ='1147.Miktar Giriniz'>!");
			return false;
		}
	form_basket_ww_serisonu.satir_gonder.istenen_miktar.value = istenen_miktar;
	form_basket_ww_serisonu.satir_gonder.price_catid_2.value = '<cfoutput>#attributes.price_catid_2#</cfoutput>';
	form_basket_ww_serisonu.satir_gonder.sid.value = eval("document.getElementById('serisonu_sid_"+satir_no+"')").value;
	form_basket_ww_serisonu.satir_gonder.price.value = eval("document.getElementById('serisonu_price_"+satir_no+"')").value;
	form_basket_ww_serisonu.satir_gonder.price_kdv.value = eval("document.getElementById('serisonu_price_kdv_"+satir_no+"')").value;
	form_basket_ww_serisonu.satir_gonder.is_from_seri_sonu.value = 1;
	form_basket_ww_serisonu.satir_gonder.seri_sonu_department_id.value = eval("document.getElementById('serisonu_department_id_"+satir_no+"')").value;
	form_basket_ww_serisonu.satir_gonder.seri_sonu_location_id.value = eval("document.getElementById('serisonu_location_id_"+satir_no+"')").value;
	form_basket_ww_serisonu.satir_gonder.sid.value = eval("document.getElementById('serisonu_sid_"+satir_no+"')").value;
	form_basket_ww_serisonu.satir_gonder.price_money.value = eval("document.getElementById('serisonu_price_money_"+satir_no+"')").value;
	form_basket_ww_serisonu.satir_gonder.price_standard.value = eval("document.getElementById('serisonu_price_standard_"+satir_no+"')").value;
	form_basket_ww_serisonu.satir_gonder.price_standard_kdv.value = eval("document.getElementById('serisonu_price_standard_kdv_"+satir_no+"')").value;
	form_basket_ww_serisonu.satir_gonder.price_standard_money.value = eval("document.getElementById('serisonu_price_standard_money_"+satir_no+"')").value;
	form_basket_ww_serisonu.satir_gonder.prom_id.value = eval("document.getElementById('serisonu_prom_id_"+satir_no+"')").value;
	form_basket_ww_serisonu.satir_gonder.prom_discount.value = eval("document.getElementById('serisonu_prom_discount_"+satir_no+"')").value;
	form_basket_ww_serisonu.satir_gonder.prom_amount_discount.value = eval("document.getElementById('serisonu_prom_amount_discount_"+satir_no+"')").value;
	form_basket_ww_serisonu.satir_gonder.prom_cost.value = eval("document.getElementById('serisonu_prom_cost_"+satir_no+"')").value;
	form_basket_ww_serisonu.satir_gonder.prom_free_stock_id.value = eval("document.getElementById('serisonu_prom_free_stock_id_"+satir_no+"')").value;
	form_basket_ww_serisonu.satir_gonder.prom_stock_amount.value = eval("document.getElementById('serisonu_prom_stock_amount_"+satir_no+"')").value;
	form_basket_ww_serisonu.satir_gonder.prom_free_stock_amount.value = eval("document.getElementById('serisonu_prom_free_stock_amount_"+satir_no+"')").value;
	form_basket_ww_serisonu.satir_gonder.prom_free_stock_price.value = eval("document.getElementById('serisonu_prom_free_stock_price_"+satir_no+"')").value;
	form_basket_ww_serisonu.satir_gonder.prom_free_stock_money.value = eval("document.getElementById('serisonu_prom_free_stock_money_"+satir_no+"')").value;
	if ((form_basket_ww_serisonu.satir_gonder.prom_discount.value.length) || (form_basket_ww_serisonu.satir_gonder.prom_amount_discount.value.length))
		form_basket_ww_serisonu.satir_gonder.price_old.value = eval("document.getElementById('serisonu_price_old_"+satir_no+"')").value;
	else
		form_basket_ww_serisonu.satir_gonder.price_old.value = '';


	form_basket_ww_serisonu.satir_gonder.action = '<cfoutput>#request.self#</cfoutput>?fuseaction=objects2.emptypopup_add_basketww_row';
	form_basket_ww_serisonu.satir_gonder.submit();
}
</cfif>
function urun_gonder2_serisonu(satir_no,pro_no)
{
	if(pro_no>0)satir_no=satir_no+'_'+pro_no;
	istenen_miktar = 1;
	satir_gonder_serisonu.istenen_miktar.value = istenen_miktar;
	satir_gonder_serisonu.price_catid_2.value = '<cfoutput>#attributes.price_catid_2#</cfoutput>';
	satir_gonder_serisonu.pid.value = eval("document.getElementById('serisonu_pid_"+satir_no+"')").value;
	satir_gonder_serisonu.product_id.value = eval("document.getElementById('serisonu_pid_"+satir_no+"')").value;
	satir_gonder_serisonu.sid.value = eval("document.getElementById('serisonu_sid_"+satir_no+"')").value;
	satir_gonder_serisonu.price.value = eval("document.getElementById('serisonu_price_"+satir_no+"')").value;
	satir_gonder_serisonu.price_kdv.value = eval("document.getElementById('serisonu_price_kdv_"+satir_no+"')").value;
	satir_gonder_serisonu.price_money.value = eval("document.getElementById('serisonu_price_money_"+satir_no+"')").value;

	satir_gonder_serisonu.price_standard.value = eval("document.getElementById('serisonu_price_standard_"+satir_no+"')").value;
	satir_gonder_serisonu.price_standard_kdv.value = eval("document.getElementById('serisonu_price_standard_kdv_"+satir_no+"')").value;
	satir_gonder_serisonu.price_standard_money.value = eval("document.getElementById('serisonu_price_standard_money_"+satir_no+"')").value;

	satir_gonder_serisonu.prom_id.value = eval("document.getElementById('serisonu_prom_id_"+satir_no+"')").value;
	satir_gonder_serisonu.prom_discount.value = eval("document.getElementById('serisonu_prom_discount_"+satir_no+"')").value;
	satir_gonder_serisonu.prom_amount_discount.value = eval("document.getElementById('serisonu_prom_amount_discount_"+satir_no+"')").value;
	satir_gonder_serisonu.prom_cost.value = eval("document.getElementById('serisonu_prom_cost_"+satir_no+"')").value;
	satir_gonder_serisonu.prom_free_stock_id.value = eval("document.getElementById('serisonu_prom_free_stock_id_"+satir_no+"')").value;
	satir_gonder_serisonu.prom_stock_amount.value = eval("document.getElementById('serisonu_prom_stock_amount_"+satir_no+"')").value;
	satir_gonder_serisonu.prom_free_stock_amount.value = eval("document.getElementById('serisonu_prom_free_stock_amount_"+satir_no+"')").value;
	satir_gonder_serisonu.prom_free_stock_price.value = eval("document.getElementById('serisonu_prom_free_stock_price_"+satir_no+"')").value;
	satir_gonder_serisonu.prom_free_stock_money.value = eval("document.getElementById('serisonu_prom_free_stock_money_"+satir_no+"')").value;
	if ((satir_gonder_serisonu.prom_discount.value.length) || (satir_gonder_serisonu.prom_amount_discount.value.length))
		satir_gonder_serisonu.price_old.value = eval("document.getElementById('serisonu_price_old_"+satir_no+"')").value;

	satir_gonder_serisonu.action = '<cfoutput>#request.self#?fuseaction=objects2.detail_product</cfoutput>';
	<cfif attributes.is_popup eq 1>
		windowopen('','list','product_window');
	satir_gonder_serisonu.target = 'product_window';
	satir_gonder_serisonu.action = '<cfoutput>#request.self#?fuseaction=objects2.popup_detail_product</cfoutput>';
	</cfif>
	satir_gonder_serisonu.submit();
}

<cfif attributes.product_compare eq 1>
function karsilastir_serisonu()
{   
	secilenler = '';
	kontrol = 0;
	<cfloop from="1" to="#listlen(product_all_list)#" index="pk">
		<cfoutput>
			<cfif listlen(product_all_list) gt 1>
			if(document.getElementsByName('serisonu_product_id')[#pk-1#]!=undefined && document.getElementsByName('serisonu_product_id')[#pk-1#].checked == true)
				{
				kontrol = kontrol + 1;
				if(secilenler.length==0)
					secilenler = document.getElementsByName('serisonu_product_id')[#pk-1#].value;
				else
					secilenler = secilenler + ',' + document.getElementsByName('serisonu_product_id')[#pk-1#].value;
				}
			<cfelseif listlen(product_all_list) eq 1>
			if(document.getElementsByName('serisonu_product_id').checked == true)
				secilenler = document.getElementsByName('serisonu_product_id').value;
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
