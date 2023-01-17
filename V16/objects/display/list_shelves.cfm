<!--- Baskete Raf Kodu bilgisinin eklenmesi için yapıldı  20071001 YD --->
<cf_xml_page_edit fuseact="objects.popup_list_shelves">
<cfset url_str = "">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.stok_turu" default="2">
<cfquery name="GET_SHELF_LIST" datasource="#dsn3#">
	SELECT
		DISTINCT
		D.DEPARTMENT_HEAD,
		SL.COMMENT,
		PP.PRODUCT_PLACE_ID,
		PP.PRODUCT_ID,
		PP.STORE_ID,
		PP.LOCATION_ID,
		PP.SHELF_TYPE,
		PP.SHELF_CODE,
		PP.QUANTITY,
		PP.DETAIL,
		PP.START_DATE,
		PP.FINISH_DATE,
		PP.RECORD_DATE
        <cfif isdefined("attributes.is_basket_kontrol")>
			<cfif isdefined('attributes.shelf_stock_id') and len(attributes.shelf_stock_id) and is_stock_amount eq 1>
				,(SELECT ISNULL(SUM(SR.STOCK_IN - SR.STOCK_OUT),0) AS PRODUCT_TOTAL_STOCK FROM #dsn2_alias#.STOCKS_ROW SR WHERE SR.STOCK_ID = #attributes.shelf_stock_id# AND SR.SHELF_NUMBER = PP.PRODUCT_PLACE_ID) STOCK_AMOUNT
			</cfif>
		</cfif>
	FROM
		PRODUCT_PLACE PP,
        <cfif is_kontrol_product_relation eq 1>
			<cfif isdefined("attributes.is_basket_kontrol")>
				<cfif isdefined('attributes.shelf_stock_id') and len(attributes.shelf_stock_id) and is_stock_amount eq 1>
					PRODUCT_PLACE_ROWS PPR,
				</cfif>
			<cfelse>
				<cfif isdefined('attributes.shelf_product_id') and len(attributes.shelf_product_id)>
					PRODUCT_PLACE_ROWS PPR,
				</cfif>
			</cfif>
		</cfif>
		#dsn_alias#.DEPARTMENT D,
		#dsn_alias#.STOCKS_LOCATION SL
	WHERE 
		 PP.PLACE_STATUS=1
		 AND PP.STORE_ID = D.DEPARTMENT_ID
		 AND D.DEPARTMENT_ID = SL.DEPARTMENT_ID 
		 AND PP.LOCATION_ID = SL.LOCATION_ID
		 AND D.IS_STORE<>2
		 <cfif len(attributes.keyword)>
		 	AND 
			(
				PP.SHELF_CODE LIKE '%#attributes.keyword#%'
				OR
				PP.SHELF_TYPE IN(SELECT SHELF_ID FROM #dsn_alias#.SHELF WHERE SHELF_NAME LIKE '%#attributes.keyword#%')
			)
		 </cfif>
		<cfif isdefined("attributes.location_id") and len(attributes.location_id)>
			AND PP.LOCATION_ID = #attributes.location_id#
		</cfif>
		<cfif isdefined("attributes.department_id") and len(attributes.department_id)>
			AND PP.STORE_ID = #attributes.department_id#
		</cfif>
		<cfif is_kontrol_product_relation eq 1>
			<cfif isdefined("attributes.is_basket_kontrol")>
				<cfif isdefined('attributes.shelf_product_id') and len(attributes.shelf_product_id) and is_stock_amount eq 1>
					AND PP.PRODUCT_PLACE_ID = PPR.PRODUCT_PLACE_ID
					<cfif is_kontrol_stock_relation eq 1>
						AND PPR.STOCK_ID = #attributes.shelf_stock_id#
					<cfelse>
						AND PPR.PRODUCT_ID = #attributes.shelf_product_id#
					</cfif>
				</cfif>
			<cfelse>
				<cfif isdefined('attributes.shelf_product_id') and len(attributes.shelf_product_id)>
					AND PP.PRODUCT_PLACE_ID = PPR.PRODUCT_PLACE_ID
					<cfif is_kontrol_stock_relation eq 1>
						AND PPR.STOCK_ID = #attributes.shelf_stock_id#
					<cfelse>
						AND PPR.PRODUCT_ID = #attributes.shelf_product_id#
					</cfif>
				</cfif>
			</cfif>
		</cfif>
		<cfif isdefined("attributes.is_basket_kontrol") and attributes.stok_turu eq 2>
			<cfif isdefined('attributes.shelf_stock_id') and len(attributes.shelf_stock_id) and is_stock_amount eq 1 and isdefined("attributes.kontrol_out") and attributes.kontrol_out eq 1>
				AND (SELECT ISNULL(SUM(SR.STOCK_IN - SR.STOCK_OUT),0) AS PRODUCT_TOTAL_STOCK FROM #dsn2_alias#.STOCKS_ROW SR WHERE SR.STOCK_ID = #attributes.shelf_stock_id# AND SR.SHELF_NUMBER = PP.PRODUCT_PLACE_ID) > 0
			</cfif>
		</cfif>
	ORDER BY PP.SHELF_CODE
</cfquery>
<script type="text/javascript">
	$(document).ready(function(){
		$( "#keyword" ).focus();
	});
	function add_shelves(in_coming_shelf_id,in_coming_shelf_code,shelf_name)
	{
		<cfif isdefined("attributes.satir") and len(attributes.satir)>
			var satir = <cfoutput>#attributes.satir#</cfoutput>;
		<cfelse>
			var satir = -1;
		</cfif>
		if(window.opener.basket && satir > -1) {
			shelf_name_ = in_coming_shelf_code + '-' +shelf_name;
			<cfif isdefined("attributes.field_id") and attributes.field_id is 'to_shelf_number'>
				window.opener.updateBasketItemFromPopup(satir, { TO_SHELF_NUMBER: in_coming_shelf_id, TO_SHELF_NUMBER_TXT:shelf_name_ }); // Basket Çalışmaları için eklendi. Kaldırmayınız. 20140826
			<cfelse>
				window.opener.updateBasketItemFromPopup(satir, { SHELF_NUMBER: in_coming_shelf_id, SHELF_NUMBER_TXT:shelf_name_}); // Basket Çalışmaları için eklendi. Kaldırmayınız. 20140826
			</cfif>
		}
		else
		{
			<cfif isdefined('attributes.is_array_type') and attributes.is_array_type eq 0> <!--- basket haricinde cagrıldıgı yerlerden  attributes.is_array_type  0 gonderilir, input isimlendirilmesi acısından--->
				<cfif isdefined("attributes.field_id")> /*raf id -- raf_id bilgisini baskete yolluyoruz*/
					opener.document.<cfoutput>#form_name#.#field_id##attributes.row_id#</cfoutput>.value = in_coming_shelf_id;
				</cfif>
				<cfif isdefined('is_shelf_code') and is_shelf_code eq 1>
					<cfif isdefined("attributes.field_code")>/*raf kodu -- raf kodu bilgisini baskete yolluyoruz*/
						opener.document.<cfoutput>#form_name#.#field_code##attributes.row_id#</cfoutput>.value = in_coming_shelf_code+' - '+shelf_name;	
					</cfif>	
				<cfelse>
					<cfif isdefined("attributes.field_code")>/*raf kodu -- raf kodu bilgisini baskete yolluyoruz*/
						opener.document.<cfoutput>#form_name#.#field_code##attributes.row_id#</cfoutput>.value = shelf_name;	
					</cfif>	
				</cfif>
			<cfelse>
				<cfif isdefined("attributes.row_id") and isdefined('attributes.row_count') and attributes.row_count neq 1> //row_id ve row_count parametreleri birlikte gonderilmelidir.
				/*row_id raf bilgilerinin gonderilecegi alanın isimlendirilmesinde kullanılıyor. row_count ise basket gibi yapılarda tek satır oldugunda sorun cıkmaması icin  kullanılıyor */
					<cfif isdefined("attributes.field_id")> /*raf id -- raf_id bilgisini baskete yolluyoruz*/
						opener.document.<cfoutput>#form_name#.#field_id#[#attributes.row_id-1#]</cfoutput>.value = in_coming_shelf_id;
					</cfif>
					<cfif isdefined('is_shelf_code') and is_shelf_code eq 1>
						<cfif isdefined("attributes.field_code")>/*raf kodu -- raf kodu bilgisini baskete yolluyoruz*/
							opener.document.<cfoutput>#form_name#.#field_code#[#attributes.row_id-1#]</cfoutput>.value = in_coming_shelf_code+' - '+shelf_name;	
						</cfif>	
					<cfelse>
						<cfif isdefined("attributes.field_code")>/*raf kodu -- raf kodu bilgisini baskete yolluyoruz*/
							opener.document.<cfoutput>#form_name#.#field_code#[#attributes.row_id-1#]</cfoutput>.value = shelf_name;	
						</cfif>
					</cfif>
				<cfelse>
					<cfif isdefined("attributes.field_id")>
						opener.document.<cfoutput>#form_name#.#field_id#</cfoutput>.value = in_coming_shelf_id;
					</cfif>
					<cfif isdefined('is_shelf_code') and is_shelf_code eq 1>
						<cfif isdefined("attributes.field_code")>
							opener.document.<cfoutput>#form_name#.#field_code#</cfoutput>.value = in_coming_shelf_code+' - '+shelf_name;
						</cfif>
					<cfelse>
						<cfif isdefined("attributes.field_code")>
							opener.document.<cfoutput>#form_name#.#field_code#</cfoutput>.value = shelf_name;
						</cfif>
					</cfif>
				</cfif>
			</cfif>
		}
		window.close();
	}
</script>
<cfset url_string = ''>
<cfif isdefined("attributes.location_id") and len(attributes.location_id)>
	<cfset url_string = '#url_string#&location_id=#attributes.location_id#'>
</cfif>
<cfif isdefined("attributes.department_id") and len(attributes.department_id)>
	<cfset url_string = '#url_string#&department_id=#attributes.department_id#'>
</cfif>
<cfif isdefined('attributes.shelf_product_id') and len(attributes.shelf_product_id)>
	<cfset url_string = '#url_string#&shelf_product_id=#attributes.shelf_product_id#'>
</cfif>
<cfif isdefined('attributes.shelf_stock_id') and len(attributes.shelf_stock_id)>
	<cfset url_string = '#url_string#&shelf_stock_id=#attributes.shelf_stock_id#'>
</cfif>
<cfif isdefined('attributes.is_array_type') and len(attributes.is_array_type)>
	<cfset url_string = '#url_string#&is_array_type=#attributes.is_array_type#'>
</cfif>
<cfif isdefined('attributes.row_id')>
	<cfset url_string = '#url_string#&row_id=#attributes.row_id#'>
</cfif>
<cfif isdefined('attributes.row_count') and len(attributes.row_count)>
	<cfset url_string = '#url_string#&row_count=#attributes.row_count#'>
</cfif>
<cfif isdefined('attributes.field_id') and len(attributes.field_id)>
	<cfset url_string = '#url_string#&field_id=#attributes.field_id#'>
</cfif>
<cfif isdefined('attributes.is_basket_kontrol') and len(attributes.is_basket_kontrol)>
	<cfset url_string = '#url_string#&is_basket_kontrol=#attributes.is_basket_kontrol#'>
</cfif>
<cfif isdefined('attributes.field_code') and len(attributes.field_code)>
	<cfset url_string = '#url_string#&field_code=#attributes.field_code#'>
</cfif>
<cfif isdefined('attributes.form_name') and len(attributes.form_name)>
	<cfset url_string = '#url_string#&form_name=#attributes.form_name#'>
</cfif>
<cfif isdefined('attributes.kontrol_out') and len(attributes.kontrol_out)>
	<cfset url_string = '#url_string#&kontrol_out=#attributes.kontrol_out#'>
</cfif>
<cfif isdefined('attributes.satir') and len(attributes.satir)>
	<cfset url_string = '#url_string#&satir=#attributes.satir#'>
</cfif>
<cfform name="form" action="#request.self#?fuseaction=objects.popup_list_shelves#url_string#" method="post">
	<cfsavecontent variable="message"><cf_get_lang dictionary_id='29944.Raflar'></cfsavecontent>
	<cf_medium_list_search title="#message#">
		<cf_medium_list_search_area>
			<table>
				<tr> 
					<td><cf_get_lang_main no='48.Filtre'></td>
					<td><cfinput type="text" name="keyword" style="width:100px;" value="#attributes.keyword#" maxlength="255"></td>
					<cfif is_stock_amount eq 1 and isdefined("attributes.kontrol_out") and attributes.kontrol_out eq 1>
						<td>
							<select name="stok_turu" id="stok_turu">
								<option value="1" <cfif attributes.stok_turu eq 1 >selected</cfif>><cf_get_lang dictionary_id='58081.Hepsi'></option>
								<option value="2" <cfif attributes.stok_turu eq 2 > selected </cfif>><cf_get_lang dictionary_id='45183.Stoğu Olanlar'></option>									
							</select>
						</td>
					</cfif>
					<td><cf_wrk_search_button is_excel='0'></td>
				</tr>
			</table>
		</cf_medium_list_search_area>
	</cf_medium_list_search>
</cfform>
<cf_medium_list>
	<thead>
		<tr>
			<cfif isdefined('is_shelf_code') and is_shelf_code eq 1>
				<th width="15"><cf_get_lang dictionary_id='57487.no'></th>
			</cfif>
			<th><cf_get_lang dictionary_id='57630.tip'></th>
			<th><cf_get_lang dictionary_id='58763.depo'></th>
			<th><cf_get_lang dictionary_id='30031.lokasyon'></th>
			<cfif is_stock_amount eq 1 and isdefined("attributes.kontrol_out") and attributes.kontrol_out eq 1>
				<th style="text-align:right;"><cf_get_lang dictionary_id='57452.Stok'></th>
			</cfif>
		</tr>
	</thead>
	<tbody>
		<cfif get_shelf_list.recordcount>
			<cfset shelf_type_list=''>
			<cfoutput query="get_shelf_list">
				<cfif not listfind(shelf_type_list,shelf_type)>
					<cfset shelf_type_list=listappend(shelf_type_list,shelf_type)>
				</cfif>
			</cfoutput>
			<cfset shelf_type_list=listsort(shelf_type_list,"numeric")>
			<cfif isdefined("shelf_type_list") and len(shelf_type_list)>
				<cfquery name="get_shelf_type" datasource="#DSN#">
					SELECT
						*
					FROM
						SHELF		
					WHERE 
						SHELF_ID IN (#shelf_type_list#)
					ORDER BY
						SHELF_ID
				</cfquery>
				<cfset shelf_type_list = listsort(listdeleteduplicates(valuelist(get_shelf_type.SHELF_ID,',')),'numeric','ASC',',')>
			</cfif>
			<cfoutput query="get_shelf_list">
				<tr>
					<cfif isdefined('is_shelf_code') and is_shelf_code eq 1><td>#shelf_code#</td></cfif>
					<td><a href="javascript://" onClick="add_shelves('#PRODUCT_PLACE_ID#','#SHELF_CODE#','#get_shelf_type.SHELF_NAME[listfind(shelf_type_list,shelf_type,',')]#')" class="tableyazi">#get_shelf_type.SHELF_NAME[listfind(shelf_type_list,shelf_type,',')]#</a></td>
					<td>#department_head#</td>
					<td>#comment#</td>
					<cfif is_stock_amount eq 1 and isdefined("attributes.kontrol_out") and attributes.kontrol_out eq 1>
						<td style="text-align:right;">
							<cfif isdefined("attributes.is_basket_kontrol")>
								<cfif isdefined('attributes.shelf_stock_id') and len(attributes.shelf_stock_id) and is_stock_amount eq 1>
									#tlformat(stock_amount)#
								</cfif>
							</cfif>
						</td> 
					</cfif>
				</tr>
			</cfoutput>
		<cfelse>
			<tr>
				<td colspan="11"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>
			</tr>
		</cfif>
	</tbody>
</cf_medium_list>
