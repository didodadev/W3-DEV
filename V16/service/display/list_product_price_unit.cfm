<!--- <cfinclude template="../../objects/query/get_product_cat.cfm"> --->
<cfinclude template="../../objects/functions/get_prod_order_funcs.cfm">
<cfinclude template="../query/get_product_price_unit.cfm">

<cfparam name="attributes.keyword" default=''>
<cfparam name="attributes.product_cat" default=''>
<cfparam name="attributes.product_cat_id" default=''> 
<cfparam name="attributes.barcode" default=''>

<cfset url_string = "">
<cfset url_string = attributes.fuseaction>
<cfif isdefined("attributes.satir") and len(attributes.satir)>
	<cfset url_string = "#url_string#&satir=#attributes.satir#">
</cfif>

<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default="#get_product_price.recordcount#">
<cfset attributes.startrow = ((attributes.page-1)*attributes.maxrows)+1 >

<table cellSpacing="0" cellpadding="0" border="0" style="width:100%">
  	<tr class="color-border">
    	<td>
      		<table cellspacing="1" cellpadding="2" border="0" style="width:100%">
        		<tr class="color-row"> 
					<cfoutput>
						<td>&nbsp;</td>
						<td align="center" width="15"><a class="tableyazi" href="#request.self#?fuseaction=service.popup_product_price_unit&#url_string#&keyword=A">A</a></td>
						<td align="center" width="15"><a class="tableyazi" href="#request.self#?fuseaction=service.popup_product_price_unit&#url_string#&keyword=B">B</a></td>
						<td align="center" width="15"><a class="tableyazi" href="#request.self#?fuseaction=service.popup_product_price_unit&#url_string#&keyword=C">C</a></td>
						<td align="center" width="15"><a class="tableyazi" href="#request.self#?fuseaction=service.popup_product_price_unit&#url_string#&keyword=D">D</a></td>
						<td align="center" width="15"><a class="tableyazi" href="#request.self#?fuseaction=service.popup_product_price_unit&#url_string#&keyword=E">E</a></td>
						<td align="center" width="15"><a class="tableyazi" href="#request.self#?fuseaction=service.popup_product_price_unit&#url_string#&keyword=F">F</a></td>
						<td align="center" width="15"><a class="tableyazi" href="#request.self#?fuseaction=service.popup_product_price_unit&#url_string#&keyword=G">G</a></td>
						<td align="center" width="15"><a class="tableyazi" href="#request.self#?fuseaction=service.popup_product_price_unit&#url_string#&keyword=H">H</a></td>
						<td align="center" width="15"><a class="tableyazi" href="#request.self#?fuseaction=service.popup_product_price_unit&#url_string#&keyword=I">I</a></td>
						<td align="center" width="15"><a class="tableyazi" href="#request.self#?fuseaction=service.popup_product_price_unit&#url_string#&keyword=İ">İ</a></td>
						<td align="center" width="15"><a class="tableyazi" href="#request.self#?fuseaction=service.popup_product_price_unit&#url_string#&keyword=J">J</a></td>
						<td align="center" width="15"><a class="tableyazi" href="#request.self#?fuseaction=service.popup_product_price_unit&#url_string#&keyword=K">K</a></td>
						<td align="center" width="15"><a class="tableyazi" href="#request.self#?fuseaction=service.popup_product_price_unit&#url_string#&keyword=L">L</a></td>
						<td align="center" width="15"><a class="tableyazi" href="#request.self#?fuseaction=service.popup_product_price_unit&#url_string#&keyword=M">M</a></td>
						<td align="center" width="15"><a class="tableyazi" href="#request.self#?fuseaction=service.popup_product_price_unit&#url_string#&keyword=N">N</a></td>
						<td align="center" width="15"><a class="tableyazi" href="#request.self#?fuseaction=service.popup_product_price_unit&#url_string#&keyword=O">O</a></td>
						<td align="center" width="15"><a class="tableyazi" href="#request.self#?fuseaction=service.popup_product_price_unit&#url_string#&keyword=Ö">Ö</a></td>
						<td align="center" width="15"><a class="tableyazi" href="#request.self#?fuseaction=service.popup_product_price_unit&#url_string#&keyword=P">P</a></td>
						<td align="center" width="15"><a class="tableyazi" href="#request.self#?fuseaction=service.popup_product_price_unit&#url_string#&keyword=Q">Q</a></td>
						<td align="center" width="15"><a class="tableyazi" href="#request.self#?fuseaction=service.popup_product_price_unit&#url_string#&keyword=R">R</a></td>
						<td align="center" width="15"><a class="tableyazi" href="#request.self#?fuseaction=service.popup_product_price_unit&#url_string#&keyword=S">S</a></td>
						<td align="center" width="15"><a class="tableyazi" href="#request.self#?fuseaction=service.popup_product_price_unit&#url_string#&keyword=Ş">Ş</a></td>
						<td align="center" width="15"><a class="tableyazi" href="#request.self#?fuseaction=service.popup_product_price_unit&#url_string#&keyword=T">T</a></td>
						<td align="center" width="15"><a class="tableyazi" href="#request.self#?fuseaction=service.popup_product_price_unit&#url_string#&keyword=U">U</a></td>
						<td align="center" width="15"><a class="tableyazi" href="#request.self#?fuseaction=service.popup_product_price_unit&#url_string#&keyword=Ü">Ü</a></td>
						<td align="center" width="15"><a class="tableyazi" href="#request.self#?fuseaction=service.popup_product_price_unit&#url_string#&keyword=V">V</a></td>
						<td align="center" width="15"><a class="tableyazi" href="#request.self#?fuseaction=service.popup_product_price_unit&#url_string#&keyword=W">W</a></td>
						<td align="center" width="15"><a class="tableyazi" href="#request.self#?fuseaction=service.popup_product_price_unit&#url_string#&keyword=X">X</a></td>
						<td align="center" width="15"><a class="tableyazi" href="#request.self#?fuseaction=service.popup_product_price_unit&#url_string#&keyword=Y">Y</a></td>
						<td align="center" width="15"><a class="tableyazi" href="#request.self#?fuseaction=service.popup_product_price_unit&#url_string#&keyword=Z">Z</a></td>
						<td>&nbsp;</td>
          			</cfoutput> 
				</tr>
      		</table>
    	</td>
  	</tr>
</table>
<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center" height="35">
  <tr>
    <td class="headbold"><cf_get_lang_main no='152.Ürünler'></td>
    <td align="right" valign="bottom" style="text-align:right;">
      <table>
        <cfform name="search_product" method="post" action="#request.self#?fuseaction=service.popup_product_price_unit&#url_string#">
          <cfif isdefined("attributes.product_id")><input type="hidden" name="product_id" id="product_id" value="<cfoutput>#attributes.product_id#</cfoutput>"></cfif>
          <tr>
            <td><cf_get_lang_main no='48.Filtre'>:</td>
			<td><cfinput type="text" name="keyword" style="width:100px;" value="#attributes.keyword#" maxlength="255"></td>
			<td>Barkod</td>
			<td><cfinput type="text" name="barcode" value="#attributes.barcode#" style="width:100px;"></td>
            <td><cf_get_lang_main no='74.Kategori'></td>
			<td><input type="hidden" name="product_cat_id" id="product_cat_id" value="<cfoutput>#attributes.product_cat_id#</cfoutput>">
			  <cfinput type="text" name="product_cat" value="#attributes.product_cat#" style="width:135px;">  
			  <a href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_product_cat_names&is_sub_category=1&field_code=search_product.product_cat_id&field_name=search_product.product_cat</cfoutput>&keyword='+encodeURIComponent(document.search_product.product_cat.value));"><img src="/images/plus_thin.gif" border="0" title="Ürün Kategorisi" align="absmiddle"></a>
			</td>
			<td><cfinput type="text" name="maxrows" style="width:25px;" value="#attributes.maxrows#" validate="integer" range="1," required="yes" message="Sayi_Hatasi_Mesaj"></td>
            <td><cf_wrk_search_button></td>
			  <cfif isdefined("attributes.satir") and len(attributes.satir)>
				<input type="hidden" name="satir" id="satir" value="<cfoutput>#attributes.satir#</cfoutput>">
			  </cfif>
          </tr>
        </cfform>
      </table>
    </td>
  </tr>
</table>
<table cellspacing="0" cellpadding="0" width="98%" border="0" align="center">
  <tr class="color-border">
    <td>
      <table cellpadding="2" cellspacing="1" border="0" width="100%" align="center">
        <tr class="color-header" height="22">
			<td class="form-title">Ürün</td>
			<td class="form-title">Ana Birim</td>
			<td class="form-title">Fiyat (KDV Dahil)</td>			
        </tr>
        <cfif get_product_price.recordcount>
            <cfoutput query="get_product_price" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
			<cfif is_kdv eq 0>
				<cfset satis_f=price*(1+(tax/100))>
			<cfelse>
				<cfset satis_f=price_kdv>		
			</cfif>
             <tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
                <td><a href="javascript://" class="tableyazi" onclick="gonder('#product_id#','#product_name#','#tlFormat(satis_f)#','#add_unit#','#product_unit_id#','#currentrow#','#money#');">#product_name#</a></td>
				<td>#add_unit#</td>
				<!--- <td align="right">#tlFormat(price)# #money#</td> --->
				<td align="right" style="text-align:right;">#tlFormat(satis_f)# #money#</td>		
              </tr>
			  
            </cfoutput>
          <cfelse>
          <tr>
            <td colspan="3" class="color-row">
				<cf_get_lang_main no='72.Kayıt Bulunamadı'>!
			  </td>
          </tr>
        </cfif>
      </table>
    </td>
  </tr>
</table>
<cfif attributes.maxrows lt attributes.totalrecords >
  <table cellpadding="2" cellspacing="0" border="0" width="98%" align="center">
    <tr height="2" >
      <td>
		<cfif len(attributes.keyword)>
			<cfset url_string = "#url_string#&keyword=#attributes.keyword#">
		</cfif>
		<cfif len(attributes.product_cat)>
			<cfset url_string = "#url_string#&product_cat=#attributes.product_cat#">
		</cfif>
		<cfif len(attributes.product_cat_id)>
			<cfset url_string = "#url_string#&product_cat_id=#attributes.product_cat_id#">
		</cfif>
		<cfif len(attributes.barcode)>
			<cfset url_string = "#url_string#&barcode=#attributes.barcode#">
		</cfif>
	  	<cf_pages
			page="#attributes.page#"
			maxrows="#attributes.maxrows#"
			totalrecords="#attributes.totalrecords#"
			startrow="#attributes.startrow#"
			adres="#url_string#">
		</td>
      <!-- sil --><td align="right" style="text-align:right;"><cfoutput> <cf_get_lang_main no='128.Toplam Kayıt'>:#attributes.totalrecords# - <cf_get_lang_main no='169.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td><!-- sil -->
    </tr>
  </table>
</cfif>
<script type="text/javascript">
search_product.keyword.focus();
function gonder(p_id,p_name,satis_f,p_unit,punit_id,satir,money)
{
	<cfoutput>
		opener.add_service.product_id#satir#.value = p_id;
		opener.add_service.product#satir#.value = p_name;
		opener.add_service.price#satir#.value = satis_f;
		opener.add_service.unit_id#satir#.value = punit_id;
		opener.add_service.unit_name#satir#.value = p_unit;
		opener.add_service.money#satir#.value = money;
		opener.add_service.amount#satir#.value = 1;
		opener.add_service.total#satir#.value = satis_f;
	</cfoutput>	
	window.close();
}
</script>
