<!---
Description :
	Bu popup istenen inputlara product_id,stock_id,urun adi,stok property,birim id ve/veya seri no takip flag i atar. 20040908
Parameters :
	product_id				'urun id atilacak opener formu input adi
	field_id				'urun stock_id atilacak opener formu input adi
	field_name				'urun adi opener formu input adi
	field_code				'stok kodu opener formu input adi
	field_unit				'ilgili urun-stoga ait birim id opener formu input adi
	field_service_serial	'seri no takibi yapilip yapilmadigini donduren opener formu input adi
	process					'???
	process_var				'???

Syntax :
	...fuseaction=objects.popup_product_names&product_id=report_special.product_id&field_name=report_special.product_name

--->
<cfparam name="attributes.product_cat_code" default="">
<cfparam name="attributes.product_cat" default="">
<cfif isdefined('attributes.is_form_submitted') or (isdefined("attributes.keyword") and len(attributes.keyword))>
	<cfinclude template="../query/get_product_name_with_price.cfm">
<cfelse>
	<cfset PRODUCT_NAMES.recordcount=0>
</cfif>
<cfset url_string = "">
<cfif isdefined("attributes.product_id")>
	<cfset url_string = "#url_string#&product_id=#attributes.product_id#">
</cfif>
<cfif isdefined("attributes.from_promotion")>
	<cfset url_string = "#url_string#&from_promotion=1">
</cfif>
<cfif isdefined("attributes.field_id")>
	<cfset url_string = "#url_string#&field_id=#attributes.field_id#">
</cfif>
<cfif isdefined("attributes.field_name")>
	<cfset url_string = "#url_string#&field_name=#attributes.field_name#">
</cfif>
<cfif isdefined("attributes.field_code")>
	<cfset url_string = "#url_string#&field_code=#attributes.field_code#">
</cfif>
<cfif isdefined("attributes.field_unit")>
	<cfset url_string = "#url_string#&field_unit=#attributes.field_unit#">
</cfif>
<cfif isdefined("attributes.process") and len(attributes.process)>
	<cfset url_string = "#url_string#&process=#attributes.process#">
</cfif>
<cfif isdefined("attributes.process_var") and len(attributes.process_var)>
	<cfset url_string = "#url_string#&process_var=#attributes.process_var#">
</cfif>
<cfif isdefined("attributes.field_service_serial")>
	<cfset url_string = "#url_string#&field_service_serial=#attributes.field_service_serial#">
</cfif>
<cfif isdefined("attributes.is_hizmet")>
	<cfset url_string = "#url_string#&is_hizmet=#attributes.is_hizmet#">
</cfif>
<cfif isdefined("attributes.field_product_price_kdv")>
	<cfset url_string = "#url_string#&field_product_price_kdv=#attributes.field_product_price_kdv#">
</cfif>
<cfif isdefined("attributes.field_product_price")>
	<cfset url_string = "#url_string#&field_product_price=#attributes.field_product_price#">
</cfif>
<cfif isdefined("attributes.field_price_money")>
	<cfset url_string="#url_string#&field_price_money=#attributes.field_price_money#">
</cfif>
<cfif isdefined("attributes.field_price_kdv_money")>
	<cfset url_string="#url_string#&field_price_kdv_money=#attributes.field_price_kdv_money#">
</cfif>
<cfparam name="attributes.keyword" default=''>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.totalrecords" default="#product_names.recordcount#">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow = ((attributes.page-1)*attributes.maxrows)+1 >
<cf_wrk_alphabet keyword="url_string">
<cf_medium_list_search title="#getLang('main',152)#">
	<cf_medium_list_search_area>  
		<cfform name="search_product" action="#request.self#?fuseaction=contract.popup_list_products_with_price&#url_string#" method="post">
			<table>
				<input name="is_form_submitted" id="is_form_submitted" type="hidden" value="1">
				<cfif isdefined("attributes.product_id")><input type="hidden" name="product_id" id="product_id" value="<cfoutput>#attributes.product_id#</cfoutput>"></cfif>
				<cfif isdefined("attributes.product_name")><input type="hidden" name="field_name" id="field_name" value="<cfoutput>#attributes.product_name#</cfoutput>"></cfif>
				<tr>
					<td><cf_get_lang_main no='48.Filtre'></td>
					<td><cfinput type="text" name="keyword" style="width:100px;" value="#attributes.keyword#" maxlength="50"></td>
					<td height="22"><cf_get_lang_main no ='74.Kategori'></td>
					<td>
						<input type="hidden" name="form_submitted" id="form_submitted" value="">
						<input type="hidden" name="product_cat_code" id="product_cat_code" value="<cfif len(attributes.product_cat)><cfoutput>#attributes.product_cat_code#</cfoutput></cfif>">
						<input type="text" name="product_cat" id="product_cat" style="width:160px;"  value="<cfif len(attributes.product_cat)><cfoutput>#attributes.product_cat#</cfoutput></cfif>">
						<a href="javascript://"onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_product_cat_names&is_sub_category=1&field_code=search_product.product_cat_code&field_name=search_product.product_cat</cfoutput>');"><img src="/images/plus_thin.gif" border="0" title="<cf_get_lang no='146.Ürün Kategorisi Ekle'>!" align="absmiddle"></a>			</td>
					<td>
					<cfinput type="text" name="maxrows" onKeyUp="isNumber(this)" style="width:25px;" value="#attributes.maxrows#" validate="integer" range="1," required="yes" message="Sayi_Hatasi_Mesaj">
					</td>
					<td><cf_wrk_search_button></td>
				</tr>
			</table>
		</cfform>
	</cf_medium_list_search_area> 
</cf_medium_list_search>
<cf_medium_list>
	<thead>
		<tr>
			<th width="150"><cf_get_lang_main no ='106.Stok Kodu'></th>
			<th><cf_get_lang_main no ='245.Ürün'></th>
			<th width="75"><cf_get_lang no ='317.Ana Birim'></th>
			<th width="150"><cf_get_lang_main no='1736.Tedarikçi'></th>
		</tr>
	</thead>
	<tbody>
        <cfif product_names.recordcount>
			<cfset company_id_list=''>
			<cfoutput query="product_names" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
				<cfif len(product_names.COMPANY_ID) and not listfind(company_id_list,product_names.COMPANY_ID)>
					<cfset company_id_list=listappend(company_id_list,product_names.COMPANY_ID)>
				</cfif>
			</cfoutput>
			<cfif len(company_id_list)>
				<cfquery name="get_company_detail" datasource="#dsn#">
					SELECT COMPANY_ID,NICKNAME,FULLNAME FROM COMPANY WHERE COMPANY_ID IN (#company_id_list#)
				</cfquery>
			</cfif>
            <cfoutput query="product_names" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
             <cfif len(product_names.COMPANY_ID)>
			 	<cfquery name="get_company_name" dbtype="query">
					SELECT NICKNAME,FULLNAME FROM get_company_detail WHERE COMPANY_ID=#product_names.COMPANY_ID#
				</cfquery>
			 </cfif>
				<tr>
					<td>#product_names.STOCK_CODE#</td>
					<td>
						<a href="javascript://" class="tableyazi" onclick="gonder_with_price('#product_id#','#stock_id#','#product_name#','#stock_code#','#property#','#product_unit_id#','#is_serial_no#','#price#','#price_kdv#','#money#','#money#');">#product_name#&nbsp;#property#</a>
					</td>
					<td>#product_names.MAIN_UNIT#</td>
					<td><cfif len(product_names.COMPANY_ID)>#get_company_name.FULLNAME#</cfif></td>
				</tr>
			</cfoutput>
		<cfelse>
			<tr>
				<td colspan="4" class="color-row"><cf_get_lang_main no ='289.Filtre Ediniz'> !</td>
			</tr>
		</cfif>
	</tbody>
</cf_medium_list>
<cfif attributes.maxrows lt attributes.totalrecords >
  <table cellpadding="2" cellspacing="0" border="0" width="99%" align="center">
    <tr height="2" >
      <td>
		<cfset adres = attributes.fuseaction>
		<cfset adres = "#adres#&keyword=#attributes.keyword#">
		<cfif len(attributes.product_cat) and (isDefined('attributes.product_cat_code') and len(attributes.product_cat_code))>
			<cfset adres = "#adres#&product_cat_code=#attributes.product_cat_code#">
		</cfif>
		<cfif isDefined('attributes.product_cat') and len(attributes.product_cat)>
			<cfset adres = "#adres#&product_cat=#attributes.product_cat#">
		</cfif>
		
		<cfif len(url_string)>
			<cfset adres = "#adres#&#url_string#">
		</cfif>
	  	<cf_pages
			page="#attributes.page#"
			maxrows="#attributes.maxrows#"
			totalrecords="#attributes.totalrecords#"
			startrow="#attributes.startrow#"
			adres="#adres#&is_form_submitted=1">
		</td>
      <!-- sil --><td style="text-align:right;"><cfoutput> <cf_get_lang_main no='128.Toplam Kayıt'>:#attributes.totalrecords# - <cf_get_lang_main no='169.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td><!-- sil -->
    </tr>
  </table>
</cfif>
<script type="text/javascript">
document.getElementById('keyword').focus();
function gonder_with_price(p_id,id,urun,code,property,unit_id,is_product_service,price,price_kdv,price_money,price_money_kdv)
{
	<cfoutput>
	<cfif isdefined("attributes.product_id")>
		opener.#attributes.product_id#.value = p_id;
	</cfif>
	<cfif isdefined("attributes.field_product_price_kdv")>
		opener.#attributes.field_product_price_kdv#.value=price_kdv;
	</cfif>
	<cfif isdefined("attributes.field_product_price")>
		opener.#attributes.field_product_price#.value=price;
	</cfif>
	<cfif isdefined("attributes.field_price_money")>
		opener.#attributes.field_price_money#.value=price_money;
	</cfif>
	<cfif isdefined("attributes.field_price_kdv_money")>
		opener.#attributes.field_price_kdv_money#.value=price_money_kdv;
	</cfif>
	<cfif isdefined("attributes.field_id")>
		opener.#attributes.field_id#.value = id;
	</cfif>
	<cfif isdefined("attributes.field_name")>
		opener.#attributes.field_name#.value = urun +' '+ property;
	</cfif>
	<cfif isdefined("attributes.field_code")>
		opener.#attributes.field_code#.value = code;
	</cfif>
	<cfif isdefined("attributes.field_unit")>
		opener.#attributes.field_unit#.value = unit_id;
	</cfif>
	<cfif isdefined("attributes.field_service_serial")>
		opener.#attributes.field_service_serial#.value = is_product_service;
	</cfif>
	<cfif isdefined("attributes.process") and (attributes.process is "purchase_contract" or attributes.process is "sales_contract")>
		opener.findDuplicate(#attributes.process_var#);
	</cfif>
	<cfif isdefined("attributes.field_calistir")>
		opener.bosalt();
		opener.butonlari_goster();
	</cfif>
	</cfoutput>
	window.close();
}
</script>
