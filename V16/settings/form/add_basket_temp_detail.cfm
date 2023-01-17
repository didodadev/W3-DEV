<!--- 
	Bu sayfada basket ayarlamaları  goruntu duzenlemeleri icin  secme ekranıdır.
	setup_basket tablosundaki B_TYPE alani 1 olan kayıtlar eklenir.
	B_TYPE =1 demek isleme sayfasi demektir.B_TYPE=0 olsa idi goruntu sayfası olurdu.
--->
<cfset attributes.B_TYPE = 0>
<script type="text/javascript">
function sec()
{
	for (i=0; i < add_basket_details.module_content.length ; i=i+1)
		add_basket_details.module_content[i].checked = true;
}
</script>
<cfquery name="get_basket_ids" datasource="#DSN3#">
	SELECT BASKET_ID FROM SETUP_BASKET WHERE B_TYPE = 0
</cfquery>
<cfset liste_basket_ids = ValueList(get_basket_ids.BASKET_ID)>
<cf_form_box title="#getLang('settings',392)#">
	<cf_area width="150">
      <cfinclude template="../display/list_basket_temp_modules.cfm">
      <cfif not isdefined('attributes.sec_id')>
        <cfset attributes.sec_id = 0>
      </cfif>
	</cf_area>
    <cfif isdefined("attributes.id")>
		<cfset attributes.basket_id = attributes.id>
        <cfset attributes.bskt_list = 2>
        <cfinclude template="../query/get_basket_details.cfm">
        <cfquery name="get_module_dsp" datasource="#DSN3#">
            SELECT * FROM SETUP_BASKET_ROWS WHERE BASKET_ID = #GET_BASKET.BASKET_ID# AND B_TYPE=0
        </cfquery>
        <cfoutput query="get_module_dsp">
        	<cfset "#title#_selected"=is_selected>
            <cfset "#title#_genislik"=genislik>
            <cfset "#title#_line_order_no"=line_order_no>
            <cfset "#title#_title_name"=title_name>
        </cfoutput>
    </cfif>
	<cf_area>
        <cfform action="#request.self#?fuseaction=settings.add_bskt_temp_detail_act" method="post"  name="add_basket_details" >
		<input type="hidden" name="B_TYPE" id="B_TYPE" value="0">
		<table> 
          <tr>
			<td colspan="5"><b><cf_get_lang_main no='1160.Kullanım'></b>&nbsp;&nbsp;&nbsp;
			  <select name="BASKET_ID" id="BASKET_ID" style="width=200px;">
				<cfif not listfind(liste_basket_ids,1,",")><option<cfif attributes.sec_id eq 1> selected</cfif> value="1"><cf_get_lang no='84.Satınalma Faturası'></option></cfif>
				<cfif not listfind(liste_basket_ids,2,",")><option<cfif attributes.sec_id eq 2> selected</cfif> value="2"><cf_get_lang no='85.Satış Faturası'></option></cfif>
				<cfif not listfind(liste_basket_ids,3,",")><option<cfif attributes.sec_id eq 3> selected</cfif> value="3"><cf_get_lang no='86.Satış Teklifi'> </option></cfif>
				<cfif not listfind(liste_basket_ids,4,",")><option<cfif attributes.sec_id eq 4> selected</cfif> value="4"><cf_get_lang no='87.Satış Siparişi'></option></cfif>
				<cfif not listfind(liste_basket_ids,5,",")><option<cfif attributes.sec_id eq 5> selected</cfif> value="5"><cf_get_lang no='88.Satınalma Teklifi'></option></cfif>
				<cfif not listfind(liste_basket_ids,6,",")><option<cfif attributes.sec_id eq 6> selected</cfif> value="6"><cf_get_lang no='71.Satınalma Siparişi'></option></cfif>
				<cfif not listfind(liste_basket_ids,7,",")><option<cfif attributes.sec_id eq 7> selected</cfif> value="7"><cf_get_lang no='89.Satınalma İç Talepleri'></option></cfif>
				<cfif not listfind(liste_basket_ids,8,",")><option<cfif attributes.sec_id eq 8> selected</cfif> value="8"><cf_get_lang no='90.Yazışmalar İç Talepler'></option></cfif>
				<cfif not listfind(liste_basket_ids,10,",")><option<cfif attributes.sec_id eq 10> selected</cfif> value="10"><cf_get_lang no='92.Stok Satış İrsaliyesi'></option></cfif>
				<cfif not listfind(liste_basket_ids,31,",")><option<cfif attributes.sec_id eq 31> selected</cfif> value="31"><cf_get_lang no='747.Stok Sevk İrsaliyesi'></option></cfif>
				<cfif not listfind(liste_basket_ids,11,",")><option<cfif attributes.sec_id eq 11> selected</cfif> value="11"><cf_get_lang no='93.Stok Alım İrsaliyesi'></option></cfif>
				<cfif not listfind(liste_basket_ids,12,",")><option<cfif attributes.sec_id eq 12> selected</cfif> value="12"><cf_get_lang no='528.Stok Fişi Ekle'></option></cfif>
				<cfif not listfind(liste_basket_ids,13,",")><option<cfif attributes.sec_id eq 13> selected</cfif> value="13"><cf_get_lang no='95.Stok Açılış Fişi'></option></cfif>
				<cfif not listfind(liste_basket_ids,14,",")><option<cfif attributes.sec_id eq 14> selected</cfif> value="14"><cf_get_lang no='96.Stok Satış Siparişi'></option></cfif>
				<cfif not listfind(liste_basket_ids,15,",")><option<cfif attributes.sec_id eq 15> selected</cfif> value="15"><cf_get_lang no='98.Stok Alım Siparişi'></option></cfif>
				<cfif not listfind(liste_basket_ids,17,",")><option<cfif attributes.sec_id eq 17> selected</cfif> value="17"><cf_get_lang no='99.Şube Alım İrsaliyesi'></option></cfif>
				<cfif not listfind(liste_basket_ids,18,",")><option<cfif attributes.sec_id eq 18> selected</cfif> value="18"><cf_get_lang no='100.Şube Satış Faturası'></option></cfif>
				<cfif not listfind(liste_basket_ids,19,",")><option<cfif attributes.sec_id eq 19> selected</cfif> value="19"><cf_get_lang no='101.Şube Stok Fişi'> </option></cfif>
				<cfif not listfind(liste_basket_ids,20,",")><option<cfif attributes.sec_id eq 20> selected</cfif> value="20"><cf_get_lang no='102.Şube Alış Faturası'></option></cfif>
				<cfif not listfind(liste_basket_ids,21,",")><option<cfif attributes.sec_id eq 21> selected</cfif> value="21"><cf_get_lang no='103.Şube Satış İrsaliyesi'></option></cfif>
				<cfif not listfind(liste_basket_ids,32,",")><option<cfif attributes.sec_id eq 32> selected</cfif> value="32"><cf_get_lang no='748.Şube Sevk İrsaliyesi'></option></cfif>					  
				<cfif not listfind(liste_basket_ids,24,",")><option<cfif attributes.sec_id eq 24> selected</cfif> value="24"><cf_get_lang no='822.Partner Portal Teklifler Satış'></option></cfif>
				<cfif not listfind(liste_basket_ids,25,",")><option<cfif attributes.sec_id eq 25> selected</cfif> value="25"><cf_get_lang no='823.Partner Portal Siparişler Satış'></option></cfif>
				<cfif not listfind(liste_basket_ids,26,",")><option<cfif attributes.sec_id eq 26> selected</cfif> value="26"><cf_get_lang no='107.Partner Portal Ürün Katalogları'></option></cfif>
				<cfif not listfind(liste_basket_ids,28,",")><option<cfif attributes.sec_id eq 28> selected</cfif> value="28"><cf_get_lang no='109.Public Portal Basket'></option></cfif>
				<cfif not listfind(liste_basket_ids,29,",")><option<cfif attributes.sec_id eq 29> selected</cfif> value="29"><cf_get_lang no='110.Kataloglar'></option></cfif>
				<cfif not listfind(liste_basket_ids,33,",")><option<cfif attributes.sec_id eq 33> selected</cfif> value="33"><cf_get_lang_main no='411.Müstahsil Makbuzu'></option></cfif>
				<cfif not listfind(liste_basket_ids,34,",")><option<cfif attributes.sec_id eq 34> selected</cfif> value="34"><cf_get_lang no='760.Bütçe Satış Kotaları'></option></cfif>
				<cfif not listfind(liste_basket_ids,35,",")><option<cfif attributes.sec_id eq 35> selected</cfif> value="35"><cf_get_lang no='820.Partner Portal(Alım) Siparişleri'></option></cfif>
				<cfif not listfind(liste_basket_ids,36,",")><option<cfif attributes.sec_id eq 36> selected</cfif> value="36"><cf_get_lang no='821.Partner Portal(Alım) Teklifleri'></option></cfif>
				<cfif not listfind(liste_basket_ids,38,",")><option<cfif attributes.sec_id eq 38> selected</cfif> value="38"><cf_get_lang no='758.Sube Satış Siparişi'></option></cfif>
				<cfif not listfind(liste_basket_ids,37,",")><option<cfif attributes.sec_id eq 37> selected</cfif> value="37"><cf_get_lang no='832.Sube Alım Siparişi'></option></cfif>
				<cfif not listfind(liste_basket_ids,39,",")><option<cfif attributes.sec_id eq 39> selected</cfif> value="39"><cf_get_lang no='314.Şube İç Talepler'></option></cfif>
				<cfif not listfind(liste_basket_ids,40,",")><option<cfif attributes.sec_id eq 40> selected</cfif> value="40"><cf_get_lang no='348.Stok Hal İrsaliyesi'></option></cfif>
				<cfif not listfind(liste_basket_ids,41,",")><option<cfif attributes.sec_id eq 41> selected</cfif> value="41"><cf_get_lang no='356.Şube Hal İrsaliyesi'></option></cfif>
				<cfif not listfind(liste_basket_ids,42,",")><option<cfif attributes.sec_id eq 42> selected</cfif> value="42"><cf_get_lang_main no='407.Hal Faturası'></option></cfif>
				<cfif not listfind(liste_basket_ids,43,",")><option<cfif attributes.sec_id eq 43> selected</cfif> value="43"><cf_get_lang no='422.Şube Hal Faturası'></option></cfif>
				<cfif not listfind(liste_basket_ids,44,",")><option<cfif attributes.sec_id eq 44> selected</cfif> value="44"><cf_get_lang no='475.Sevk İç Talep'></option></cfif>
				<cfif not listfind(liste_basket_ids,45,",")><option<cfif attributes.sec_id eq 45> selected</cfif> value="45"><cf_get_lang no='498.Şube Sevk İç Talep'></option></cfif>
				<cfif not listfind(liste_basket_ids,46,",")><option<cfif attributes.sec_id eq 46> selected</cfif> value="46"><cf_get_lang_main no='1420.Abone'></option></cfif>
			  </select>
			</td>
		  </tr>
        </table>
        <table width="100%">
            <tr class="color-list">
                <td class="txtbold"><input type="checkbox" onClick="sec();" value="<cf_get_lang no='705.Hepsini Seç'>"><cf_get_lang no='705.Hepsini Seç'></td>
            </tr>
        </table>
        <table>
		  <tr height="22" class="txtboldblue">
			<td><cf_get_lang_main no='1281.Seç'></td>
			<td><cf_get_lang_main no='1165.Sıra'></td>
			<td><cf_get_lang no='670.En'></td>
			<td><cf_get_lang no='818.Basket Adı'></td>
			<td><cf_get_lang_main no='1160.Kullanım'></td>
		  </tr>
		  <tr>
			<td><input type="checkbox" name="module_content" id="module_content" <cfif isdefined("basket_cursor_selected") and basket_cursor_selected eq 1>checked</cfif> value="basket_cursor"></td>
			<td></td>
			<td></td>
			<td><input type="textbox"  name="basket_cursor" id="basket_cursor"  value="<cfif isdefined("basket_cursor_title_name")><cfoutput>#basket_cursor_title_name#</cfoutput><cfelse><cf_get_lang_main no='221.Barkod'></cfif>"></td>
			<td><cf_get_lang no='393.Barkod Cihazı'></td>
		  </tr>
		  <tr>
			<td><input type="checkbox" name="module_content" id="module_content" <cfif isdefined("stock_code_selected") and stock_code_selected eq 1>checked</cfif> value="stock_code"></td>
			    <cfsavecontent variable="message1"><cf_get_lang no ='1932.Sıra Numarası nümerik olmalıdır'></cfsavecontent>
			    <cfsavecontent variable="message2"><cf_get_lang no ='1933.Numarası nümerik olmalıdır'></cfsavecontent>  
			<td>
				<cfif isdefined("stock_code_line_order_no")>
            		<cfinput type="text" name="stock_code_sira"  validate="integer" value="#stock_code_line_order_no#" message="#message1#" style="width:25px;">
                <cfelse>
                	<cfinput type="text" name="stock_code_sira"  validate="integer" value="" message="#message1#" style="width:25px;">
                </cfif>
            </td>
			<td>
				<cfif isdefined("stock_code_genislik")>
                	<cfinput type="text"  name="stock_code_genislik" validate="integer" value="#stock_code_genislik#" message="#message2#" style="width:35px;">
                <cfelse>
                	<cfinput type="text"  name="stock_code_genislik" validate="integer" value="50" message="#message2#" style="width:35px;">
                </cfif>
            </td>
			<td><input type="textbox"  name="stock_code" id="stock_code" value="<cfif isdefined("stock_code_title_name")><cfoutput>#stock_code_title_name#</cfoutput><cfelse><cf_get_lang_main no='106.Stok Kodu'></cfif>"></td>
			<td><cf_get_lang_main no='106.Stok Kodu'></td>
		  </tr>
		  <tr>
				<cfsavecontent variable="message1"><cf_get_lang no ='1932.Sıra Numarası nümerik olmalıdır'></cfsavecontent>
				<cfsavecontent variable="message2"><cf_get_lang no ='1933.Numarası nümerik olmalıdır'></cfsavecontent> 
			<td><input type="checkbox" name="module_content" id="module_content" <cfif isdefined("barcod_selected") and barcod_selected eq 1>checked</cfif> value="Barcod"></td>
			<td>
            	<cfif isdefined("barcod_line_order_no")>
                	<cfinput type="text" name="Barcod_sira" validate="integer" message="#message1#" value="#barcod_line_order_no#" style="width:25px;">
                <cfelse>
            		<cfinput type="text" name="Barcod_sira" validate="integer" message="#message1#" value="" style="width:25px;">
                </cfif>
            </td>
			<td>
            	<cfif isdefined("barcod_genislik")>
            		<cfinput type="text" name="Barcod_genislik"  value="#barcod_genislik#" validate="integer" message="#message2#" style="width:35px;">
                <cfelse>
                	<cfinput type="text" name="Barcod_genislik" value="50"  validate="integer" message="#message2#" style="width:35px;">
                </cfif>
           </td>
			<td><input type="textbox" name="Barcod" id="Barcod" value="<cfif isdefined("barcod_title_name")><cfoutput>#barcod_title_name#</cfoutput><cfelse><cf_get_lang_main no='221.Barkod'></cfif>"></td>
			<td><cf_get_lang_main no='221.Barkod'></td>
		  </tr>
		  <tr>
			<cfsavecontent variable="message1"><cf_get_lang no ='1932.Sıra Numarası nümerik olmalıdır'></cfsavecontent>
			<cfsavecontent variable="message2"><cf_get_lang no ='1933.Numarası nümerik olmalıdır'></cfsavecontent> 
			<td><input type="checkbox" name="module_content" id="module_content" <cfif isdefined("manufact_code_selected") and manufact_code_selected eq 1>checked</cfif> value="manufact_code"></td>
			<td>
            	<cfif isdefined("manufact_code_line_order_no")>
            		<cfinput type="text" name="manufact_code_sira" id="manufact_code_sira" value="#manufact_code_line_order_no#" validate="integer" message="#message1#" style="width:25px;">
                <cfelse>
                	<cfinput type="text" name="manufact_code_sira" id="manufact_code_sira" value="" validate="integer" message="#message1#" style="width:25px;">
                </cfif>
            </td>
			<td>
            	<cfif isdefined("manufact_code_genislik")>
            		<cfinput type="text" name="manufact_code_genislik" id="manufact_code_genislik" value="#manufact_code_genislik#" validate="integer" message="#message2#" style="width:35px;">
                <cfelse>
                	<cfinput type="text" name="manufact_code_genislik" id="manufact_code_genislik" value="50" validate="integer" message="#message2#" style="width:35px;">
                </cfif>	
            </td>
			<td>
            	<input type="textbox" name="manufact_code" id="manufact_code" value="<cfif isdefined("manufact_code_title_name")><cfoutput>#manufact_code_title_name#</cfoutput><cfelse><cf_get_lang_main no='222.Üretici Kodu'></cfif>">
            </td>
			<td><cf_get_lang_main no='222.Üretici Kodu'></td>
		  </tr>
		  <tr>
			<cfsavecontent variable="message1"><cf_get_lang no ='1932.Sıra Numarası nümerik olmalıdır'></cfsavecontent>
			<cfsavecontent variable="message2"><cf_get_lang no ='1933.Numarası nümerik olmalıdır'></cfsavecontent> 
			<td><input type="checkbox" name="module_content" id="module_content" <cfif isdefined("product_name_selected") and product_name_selected eq 1>checked</cfif> value="product_name"></td>
			<td>
            	<cfif isdefined("product_name_line_order_no")>
                	<cfinput type="text" name="product_name_sira" id="product_name_sira" value="#product_name_line_order_no#" validate="integer" message="#message1#" style="width:25px;">
                <cfelse>
                	<cfinput type="text" name="product_name_sira" id="product_name_sira" validate="integer" message="#message1#" style="width:25px;">
                </cfif>
            </td>
			<td>
            	<cfif isdefined("product_name_genislik")>
                	<cfinput type="text" name="product_name_genislik" id="product_name_genislik" value="#product_name_genislik#" validate="integer" message="#message2#" style="width:35px;">
                <cfelse>
            		<cfinput type="text" name="product_name_genislik" id="product_name_genislik" value="100" validate="integer" message="#message2#" style="width:35px;">
                </cfif>
            </td>
			<td>
            <input type="textbox" name="product_name" id="product_name" value="<cfif isdefined("product_name_title_name")><cfoutput>#product_name_title_name#</cfoutput><cfelse>	<cf_get_lang_main no='245.Ürün'></cfif>">
            </td>
			<td><cf_get_lang_main no='245.Ürün'></td>
		  </tr>
		  <tr>
			<cfsavecontent variable="message1"><cf_get_lang no ='1932.Sıra Numarası nümerik olmalıdır'></cfsavecontent>
			<cfsavecontent variable="message2"><cf_get_lang no ='1933.Numarası nümerik olmalıdır'></cfsavecontent> 
			<td><input type="checkbox" name="module_content" id="module_content" <cfif isdefined("amount_selected") and amount_selected eq 1>checked</cfif>  value="Amount"></td>
			<td>
            	<cfif isdefined("amount_line_order_no")>
                	<cfinput type="text" name="Amount_sira" id="amount_sira" validate="integer" message="#message1#" value="#amount_line_order_no#" style="width:25px;">
                <cfelse>
                	<cfinput type="text" name="Amount_sira" id="amount_sira" validate="integer" message="#message1#" style="width:25px;">
                </cfif>
            </td>				  
			<td>
            	<cfif isdefined("amount_genislik")>
            		<cfinput type="text" name="amount_genislik" id="amount_genislik" validate="integer" message="#message2#" value="#amount_genislik#" style="width:35px;">
                <cfelse>
                	<cfinput type="text" name="Amount_genislik" id="amount_genislik" value="20" validate="integer" message="#message2#" style="width:35px;">
                </cfif>
            </td>
			<td><input type="textbox" name="amount" id="amount" value="<cfif isdefined("amount_title_name") and amount_title_name eq 1><cfoutput>#amount_title_name#</cfoutput><cfelse><cf_get_lang_main no='223.Miktar'></cfif>"></td>
			<td><cf_get_lang_main no='223.Miktar'></td>
		  </tr>
		  <tr>
			<cfsavecontent variable="message1"><cf_get_lang no ='1932.Sıra Numarası nümerik olmalıdır'></cfsavecontent>
			<cfsavecontent variable="message2"><cf_get_lang no ='1933.Numarası nümerik olmalıdır'></cfsavecontent> 
			<td><input type="checkbox" name="module_content" id="module_content" <cfif isdefined("unit_selected") and unit_selected eq 1>checked</cfif> value="Unit"></td>
			<td>
            	<cfif isdefined("unit_line_order_no")>
                	<cfinput type="text" name="unit_sira" id="unit_sira" value="#unit_line_order_no#"  validate="integer" message="#message1#" style="width:25px;">
                <cfelse>
                	<cfinput type="text" name="unit_sira" id="unit_sira" validate="integer" message="#message1#" value="" style="width:25px;">
                </cfif>
            </td>					
			<td>
            	<cfif isdefined("unit_genislik")>
                	<cfinput type="text" name="unit_genislik" id="unit_genislik" value="#unit_genislik#" validate="integer" message="#message2#" style="width:35px;">
                <cfelse>
                	<cfinput type="text" name="unit_genislik" id="unit_genislik" value="20" validate="integer" message="#message2#" style="width:35px;">
                </cfif>
            </td>
			<td><input type="textbox" name="unit" id="unit" value="<cfif isdefined("unit_title_name")><cfoutput>#unit_title_name#</cfoutput><cfelse><cf_get_lang_main no='224.Birim'></cfif>"></td>
		   <td><cf_get_lang_main no='224.Birim'></td>
		  </tr>
		  <tr>
			<cfsavecontent variable="message1"><cf_get_lang no ='1932.Sıra Numarası nümerik olmalıdır'></cfsavecontent>
			<cfsavecontent variable="message2"><cf_get_lang no ='1933.Numarası nümerik olmalıdır'></cfsavecontent> 
			<td><input type="checkbox" name="module_content" id="module_content" <cfif isdefined("tax_selected") and tax_selected eq 1>checked</cfif> value="Tax"></td>
			<td>
            	<cfif isdefined("tax_line_order_no")>
            		<cfinput type="text" name="tax_sira" id="tax_sira" validate="integer" message="#message1#" value="#tax_line_order_no#" style="width:25px;">
                <cfelse>
                	<cfinput type="text" name="tax_sira" id="tax_sira" validate="integer" message="#message1#" value="" style="width:25px;">
                </cfif>
            </td>					
			<td>
            	<cfif isdefined("tax_genislik")>
                	<cfinput type="text" name="tax_genislik" id="tax_genislik" value="#tax_genislik#" validate="integer" message="#message2#" style="width:35px;">
                <cfelse>
                	<cfinput type="text" name="tax_genislik" id="tax_genislik" value="20" validate="integer" message="#message2#" style="width:35px;">
                </cfif>
            </td>
			<td>
            	<input type="textbox" name="Tax" id="Tax" value="<cfif isdefined("tax_title_name")><cfoutput>#tax_title_name#</cfoutput><cfelse><cf_get_lang_main no='227.KDV'></cfif>">
            </td>
			<td><cf_get_lang no='395.Vergi(KDV%)'> </td>
		  </tr>
		  <tr>
			<cfsavecontent variable="message1"><cf_get_lang no ='1932.Sıra Numarası nümerik olmalıdır'></cfsavecontent>
			<cfsavecontent variable="message2"><cf_get_lang no ='1933.Numarası nümerik olmalıdır'></cfsavecontent> 
			<td><input type="checkbox" name="module_content" id="module_content" <cfif isdefined("Price_selected") and Price_selected eq 1>checked</cfif> value="Price"></td>
			<td>
            	<cfif isdefined("price_line_order_no")>
            		<cfinput type="text" name="Price_sira" id="price_sira" validate="integer" message="#message1#" value="#Price_line_order_no#" style="width:25px;">
                <cfelse>
                	<cfinput type="text" name="Price_sira" id="price_sira" validate="integer" message="#message1#" value="" style="width:25px;">
                </cfif>
            </td>					
			<td>
            	<cfif isdefined("price_genislik")>
                	<cfinput type="text" name="Price_genislik" id="Price_genislik" value="#Price_genislik#" validate="integer" message="#message2#" style="width:35px;">
                <cfelse>
                	<cfinput type="text" name="Price_genislik" id="price_genislik" value="50" validate="integer" message="#message2#" style="width:35px;">
                </cfif>
            </td>
			<td><input type="textbox" name="price" id="price" value="<cfif isdefined("Price_title_name")><cfoutput>#Price_title_name#</cfoutput><cfelse><cf_get_lang_main no='672.Fiyat'></cfif>"></td>
			<td><cf_get_lang_main no='672.Fiyat'></td>
		  </tr>
		  <tr>
			<cfsavecontent variable="message1"><cf_get_lang no ='1932.Sıra Numarası nümerik olmalıdır'></cfsavecontent>
			<cfsavecontent variable="message2"><cf_get_lang no ='1933.Numarası nümerik olmalıdır'></cfsavecontent> 
			<td><input type="checkbox" name="module_content" id="module_content" <cfif isdefined("other_money_selected") and other_money_selected eq 1>checked</cfif> value="other_money" ></td>
			<td>
            	<cfif isdefined("other_money_line_order_no")>
            		<cfinput type="text" name="other_money_sira" id="other_money_sira" validate="integer" message="#message1#" value="#other_money_line_order_no#" style="width:25px;">
                <cfelse>
                	<cfinput type="text" name="other_money_sira" id="other_money_sira" validate="integer" message="#message1#" value="" style="width:25px;">
                </cfif>
            </td>					
			<td>
            	<cfif isdefined("other_money_genislik")>
                	<cfinput type="text" name="other_money_genislik" id="other_money_genislik" value="#other_money_genislik#" validate="integer" message="#message2#" style="width:35px;">
                <cfelse>
                	<cfinput type="text" name="other_money_genislik" id="other_money_genislik" value="20" validate="integer" message="#message2#" style="width:35px;">
                </cfif>
            </td>
			<td>
            	<input type="textbox" name="other_money" id="other_money" value="<cfif isdefined("other_money_title_name")><cfoutput>#other_money_title_name#</cfoutput><cfelse><cf_get_lang_main no='265.Döviz'></cfif>">
            </td>
			<td><cf_get_lang no='835.Satırda kullanılan diğer Para Birimi'></td>
		  </tr>						
		  <tr>
		  	<cfsavecontent variable="message1"><cf_get_lang no ='1932.Sıra Numarası nümerik olmalıdır'></cfsavecontent>
			<cfsavecontent variable="message2"><cf_get_lang no ='1933.Numarası nümerik olmalıdır'></cfsavecontent> 
			<td><input type="checkbox" name="module_content" id="module_content" <cfif isdefined("price_other_selected") and price_other_selected eq 1>checked</cfif> value="price_other"></td>
			<td>
            	<cfif isdefined("price_other_line_order_no")>
                	<cfinput type="text" name="PRICE_OTHER_sira"  validate="integer" message="#message1#" value="#price_other_line_order_no#" style="width:25px;">
                <cfelse>
                	<cfinput type="text" name="PRICE_OTHER_sira"  validate="integer" message="#message1#" style="width:25px;">
                </cfif>
            	
            </td>				  
			<td>
            	<cfif isdefined("price_other_genislik")>
                	<cfinput type="text" name="PRICE_OTHER_genislik" value="#price_other_genislik#"  validate="integer" message="#message2#" style="width:35px;">
                <cfelse>
                	<cfinput type="text" name="PRICE_OTHER_genislik" value="20"  validate="integer" message="#message2#" style="width:35px;">
                </cfif>
            </td>
			<td>
            	<input type="textbox" name="PRICE_OTHER" id="PRICE_OTHER" value="<cfif isdefined("price_other_title_name")><cfoutput>#price_other_title_name#</cfoutput><cfelse><cf_get_lang_main no='265.Döviz'><cf_get_lang_main no='672.Fiyat'></cfif>">
            </td>
			<td><cf_get_lang_main no='265.Döviz'><cf_get_lang_main no='672.Fiyat'></td>
		  </tr>
		  <tr>
			<cfsavecontent variable="message1"><cf_get_lang no ='1932.Sıra Numarası nümerik olmalıdır'></cfsavecontent>
			<cfsavecontent variable="message2"><cf_get_lang no ='1933.Numarası nümerik olmalıdır'></cfsavecontent> 
			<td><input type="checkbox" name="module_content" id="module_content" <cfif isdefined("disc_ount_selected") and disc_ount_selected eq 1>checked</cfif> value="disc_ount"></td>
			<td>
            <cfif isdefined("disc_ount_line_order_no")>
            	<cfinput type="text" name="disc_ount_sira"  validate="integer" message="#message1#" value="#disc_ount_line_order_no#" style="width:25px;">
            <cfelse>
            	<cfinput type="text" name="disc_ount_sira"  validate="integer" message="#message1#" style="width:25px;">
            </cfif>
            </td>					
			<td>
            <cfif isdefined("disc_ount_genislik")>
            	<cfinput type="text" name="disc_ount_genislik" validate="integer" message="#message2#" value="#disc_ount_genislik#" style="width:35px;">
            <cfelse>
            	<cfinput type="text" name="disc_ount_genislik" value="20"  validate="integer" message="#message2#" style="width:35px;">
            </cfif>
            </td>
			<td><input type="textbox" name="disc_ount" id="disc_ount" value="<cfif isdefined("disc_ount_title_name")><cfoutput>#disc_ount_title_name#</cfoutput><cfelse><cf_get_lang_main no='229.İSK'>1</cfif>"></td>
			<td><cf_get_lang_main no='229.İndirim'>1</td>
		  </tr>
		  <tr>
			<cfsavecontent variable="message1"><cf_get_lang no ='1932.Sıra Numarası nümerik olmalıdır'></cfsavecontent>
			<cfsavecontent variable="message2"><cf_get_lang no ='1933.Numarası nümerik olmalıdır'></cfsavecontent> 
			<td><input type="checkbox" name="module_content" id="module_content" <cfif isdefined("disc_ount2__selected") and disc_ount2__selected eq 1>checked</cfif> value="disc_ount2_"></td>
			<td>
            	<cfif isdefined("disc_ount2__line_order_no")>
                	<cfinput type="text" name="disc_ount2__sira" validate="integer" message="#message1#" value="#disc_ount2__line_order_no#" style="width:25px;">
                <cfelse>
                	<cfinput type="text" name="disc_ount2__sira" validate="integer" message="#message1#" style="width:25px;">
                </cfif>
             </td>					
			<td>
            	<cfif isdefined("disc_ount2__genislik")>
                	<cfinput type="text" name="disc_ount2__genislik" value="#disc_ount2__genislik#" validate="integer" message="#message2#" style="width:35px;">
                <cfelse>
                	<cfinput type="text" name="disc_ount2__genislik" value="20" validate="integer" message="#message2#" style="width:35px;">
                </cfif>
            </td>
			<td><input type="textbox" name="disc_ount2_" id="disc_ount2_" value="<cfif isdefined("disc_ount2__title_name")><cfoutput>#disc_ount2__title_name#</cfoutput><cfelse><cf_get_lang_main no='229.İSK'>2</cfif>"></td>
			<td><cf_get_lang_main no='229.İndirim'>2</td>
		  </tr>
		  <tr>
		 	<cfsavecontent variable="message1"><cf_get_lang no ='1932.Sıra Numarası nümerik olmalıdır'></cfsavecontent>
			<cfsavecontent variable="message2"><cf_get_lang no ='1933.Numarası nümerik olmalıdır'></cfsavecontent> 
			<td><input type="checkbox" name="module_content" id="module_content" <cfif isdefined("disc_ount3__selected") and disc_ount3__selected eq 1>checked</cfif> value="disc_ount3_"></td>
			<td>
            	<cfif isdefined("disc_ount3__line_order_no")>
                	<cfinput type="text" name="disc_ount3__sira" value="#disc_ount3__line_order_no#"  validate="integer" message="#message1#" style="width:25px;">
                <cfelse>
                	<cfinput type="text" name="disc_ount3__sira"  validate="integer" message="#message1#" style="width:25px;">
                </cfif>
            </td>					
			<td>
            	<cfif isdefined("disc_ount3__genislik")>
                	<cfinput type="text" name="disc_ount3__genislik" value="#disc_ount3__genislik#" validate="integer" message="#message2#" style="width:35px;">
                <cfelse>
            		<cfinput type="text" name="disc_ount3__genislik" value="20" validate="integer" message="#message2#" style="width:35px;">
                </cfif>
            </td>
			<td><input type="textbox" name="disc_ount3_" id="disc_ount3_" value="<cfif isdefined("disc_ount3__title_name")><cfoutput>#disc_ount3__title_name#</cfoutput><cfelse><cf_get_lang_main no='229.İSK'>3</cfif>"></td>
			<td><cf_get_lang_main no='229.İndirim'>3</td>
		  </tr>
		  <tr>		  
			<cfsavecontent variable="message1"><cf_get_lang no ='1932.Sıra Numarası nümerik olmalıdır'></cfsavecontent>
			<cfsavecontent variable="message2"><cf_get_lang no ='1933.Numarası nümerik olmalıdır'></cfsavecontent> 
			<td><input type="checkbox" name="module_content" id="module_content" <cfif isdefined("disc_ount4__selected") and disc_ount4__selected eq 1>checked</cfif> value="disc_ount4_"></td>
			<td>
				<cfif isdefined("disc_ount4__line_order_no")>
                    <cfinput type="text" name="disc_ount4__sira"  value="#disc_ount4__line_order_no#"  validate="integer" message="#message1#" style="width:25px;">
                <cfelse>
                    <cfinput type="text" name="disc_ount4__sira"   validate="integer" message="#message1#" style="width:25px;">
                </cfif>
            </td>					
			<td>
            	<cfif isdefined("disc_ount4__genislik")>
            		<cfinput type="text" name="disc_ount4__genislik" value="#disc_ount4__genislik#"  validate="integer" message="#message2#" style="width:35px;">
                <cfelse>
                	<cfinput type="text" name="disc_ount4__genislik" value="20"  validate="integer" message="#message2#" style="width:35px;">
                </cfif> 
            </td>
			<td><input type="textbox" name="disc_ount4_" id="disc_ount4_" value="<cfif isdefined("disc_ount4__title_name")><cfoutput>#disc_ount4__title_name#</cfoutput><cfelse><cf_get_lang_main no='229.İSK'>4</cfif>"></td>
			<td><cf_get_lang_main no='229.İndirim'>4</td>
		  </tr>
		  <tr>
			<cfsavecontent variable="message1"><cf_get_lang no ='1932.Sıra Numarası nümerik olmalıdır'></cfsavecontent>
			<cfsavecontent variable="message2"><cf_get_lang no ='1933.Numarası nümerik olmalıdır'></cfsavecontent> 
			<td><input type="checkbox" name="module_content" id="module_content" <cfif isdefined("disc_ount5__selected") and disc_ount5__selected eq 1>checked</cfif> value="disc_ount5_"></td>
			<td>
            	<cfif isdefined("disc_ount5__line_order_no")>
            		<cfinput type="text" name="disc_ount5__sira" value="#disc_ount5__line_order_no#" validate="integer" message="#message1#" style="width:25px;">
                <cfelse>
                	<cfinput type="text" name="disc_ount5__sira" validate="integer" message="#message1#" style="width:25px;">
                </cfif>
            </td>					
			<td>
            	<cfif isdefined("disc_ount5__genislik")>
            		<cfinput type="text" name="disc_ount5__genislik" value="#disc_ount5__genislik#"  validate="integer" message="#message2#" style="width:35px;">
                <cfelse>
                	<cfinput type="text" name="disc_ount5__genislik" value="20"  validate="integer" message="#message2#" style="width:35px;">
                </cfif>
            </td>
			<td><input type="textbox" name="disc_ount5_" id="disc_ount5_" value="<cfif isdefined("disc_ount5_title_name")><cfoutput>#disc_ount5_title_name#</cfoutput><cfelse><cf_get_lang_main no='229.İSK'>5</cfif>"></td>
			<td><cf_get_lang_main no='229.İndirim'>5</td>
		  </tr>
		  <tr>
			<cfsavecontent variable="message1"><cf_get_lang no ='1932.Sıra Numarası nümerik olmalıdır'></cfsavecontent>
			<cfsavecontent variable="message2"><cf_get_lang no ='1933.Numarası nümerik olmalıdır'></cfsavecontent> 
			<td><input type="checkbox" name="module_content" id="module_content" <cfif isdefined("disc_ount6__selected") and disc_ount6__selected eq 1>checked</cfif> value="disc_ount6_"></td>
			<td>
            	<cfif isdefined("disc_ount6__line_order_no")>
                	<cfinput type="text" name="disc_ount6__sira"  validate="integer" message="#message1#" value="#disc_ount6__line_order_no#" style="width:25px;">
                <cfelse>
                	<cfinput type="text" name="disc_ount6__sira"  validate="integer" message="#message1#" style="width:25px;">
                </cfif>
            </td>					
			<td>
            	<cfif isdefined("disc_ount6__genislik")>
            		<cfinput type="text" name="disc_ount6__genislik" value="#disc_ount6__genislik#" validate="integer" message="#message2#" style="width:35px;">
                <cfelse>
                	<cfinput type="text" name="disc_ount6__genislik" value="20" validate="integer" message="#message2#" style="width:35px;">
                </cfif>
            </td>
			<td><input type="textbox" name="disc_ount6_" id="disc_ount6_" value="<cfif isdefined("disc_ount6__title_name")><cfoutput>#disc_ount6__title_name#</cfoutput><cfelse><cf_get_lang_main no='229.İSK'>6</cfif>"></td>
			<td><cf_get_lang_main no='229.İndirim'>6</td>
		  </tr>
		  <tr>
			<cfsavecontent variable="message1"><cf_get_lang no ='1932.Sıra Numarası nümerik olmalıdır'></cfsavecontent>
			<cfsavecontent variable="message2"><cf_get_lang no ='1933.Numarası nümerik olmalıdır'></cfsavecontent> 
			<td><input type="checkbox" name="module_content" id="module_content" <cfif isdefined("disc_ount7__selected") and disc_ount7__selected eq 1>checked</cfif> value="disc_ount7_"></td>
			<td>
            	<cfif isdefined("disc_ont7__line_order_no")>
                	<cfinput type="text" name="disc_ount7__sira" validate="integer" message="#message1#" value="#disc_ont7__line_order_no#" style="width:25px;">
                <cfelse>
                	<cfinput type="text" name="disc_ount7__sira" validate="integer" message="#message1#" style="width:25px;">
                </cfif>
            </td>					
			<td>
            	<cfif isdefined("disc_ount7__genislik")>
                	<cfinput type="text" name="disc_ount7__genislik" validate="integer" message="#message2#" value="#disc_ount7__genislik#" style="width:35px;">
                <cfelse>
                	<cfinput type="text" name="disc_ount7__genislik" value="20"  validate="integer" message="#message2#" style="width:35px;">
              </cfif>
            </td>
			<td><input type="textbox" name="disc_ount7_" id="disc_ount7_" value="<cfif isdefined("disc_ount7__title_name")><cfoutput>#disc_ount7__title_name#</cfoutput><cfelse><cf_get_lang_main no='229.İSK'>7</cfif>"></td>
			<td><cf_get_lang_main no='229.İndirim'>7</td>
		  </tr>	
		  <tr>
			<cfsavecontent variable="message1"><cf_get_lang no ='1932.Sıra Numarası nümerik olmalıdır'></cfsavecontent>
			<cfsavecontent variable="message2"><cf_get_lang no ='1933.Numarası nümerik olmalıdır'></cfsavecontent> 
			<td><input type="checkbox" name="module_content" id="module_content" <cfif isdefined("disc_ount8__selected") and disc_ount8__selected eq 1>checked</cfif> value="disc_ount8_"></td>
			<td>
            	<cfif isdefined("disc_ont8__line_order_no")>
            		<cfinput type="text" name="disc_ount8__sira" value="#disc_ont8__line_order_no#"   validate="integer" message="#message1#" style="width:25px;">
                <cfelse>
                	<cfinput type="text" name="disc_ount8__sira"   validate="integer" message="#message1#" style="width:25px;">	
                </cfif>
            </td>					
			<td>
            	<cfif isdefined("disc_ount8__genislik")>
                	<cfinput type="text" name="disc_ount8__genislik" value="#disc_ount8__genislik#"  validate="integer" message="#message2#" style="width:35px;">
                <cfelse>
                	<cfinput type="text" name="disc_ount8__genislik" value="20"  validate="integer" message="#message2#" style="width:35px;">
                </cfif>
            	
            </td>
			<td>
            	<input type="textbox" name="disc_ount8_" id="disc_ount8_" value="<cfif isdefined("disc_ount8__title_name")><cfoutput>#disc_ount8__title_name#</cfoutput><cfelse><cf_get_lang_main no='229.İSK'>8</cfif>">
            </td>
			<td><cf_get_lang_main no='229.İndirim'>8</td>
		  </tr>
		  <tr>
			<cfsavecontent variable="message1"><cf_get_lang no ='1932.Sıra Numarası nümerik olmalıdır'></cfsavecontent>
			<cfsavecontent variable="message2"><cf_get_lang no ='1933.Numarası nümerik olmalıdır'></cfsavecontent> 
			<td><input type="checkbox" name="module_content" id="module_content" <cfif isdefined("disc_ount9__selected") and disc_ount9__selected eq 1>checked</cfif> value="disc_ount9_"></td>
			<td>
            	<cfif isdefined("disc_ount9__line_order_to")>
                	<cfinput type="text" name="disc_ount9__sira" value="#disc_ount9__line_order_to#"  validate="integer" message="#message1#" style="width:25px;">
                <cfelse>
                	<cfinput type="text" name="disc_ount9__sira"  validate="integer" message="#message1#" style="width:25px;">
                </cfif>
            	
            </td>					
			<td>
            	<cfif isdefined("disc_ount9__genislik")>
                	<cfinput type="text" name="disc_ount9__genislik" value="#disc_ount9__genislik#" validate="integer" message="#message2#" style="width:35px;">
                <cfelse>
                	<cfinput type="text" name="disc_ount9__genislik" value="20" validate="integer" message="#message2#" style="width:35px;">
                </cfif>
            	
            </td>
			<td>
            	<input type="textbox" name="disc_ount9_" id="disc_ount9_" value="<cfif isdefined("disc_ount9__title_name")><cfoutput>#disc_ount9__title_name#</cfoutput><cfelse><cf_get_lang_main no='229.İSK'>9</cfif>">
            </td>
		    <td><cf_get_lang_main no='229.İndirim'>9</td>
		  </tr>
		  <tr>
			<cfsavecontent variable="message1"><cf_get_lang no ='1932.Sıra Numarası nümerik olmalıdır'></cfsavecontent>
			<cfsavecontent variable="message2"><cf_get_lang no ='1933.Numarası nümerik olmalıdır'></cfsavecontent> 
			<td><input type="checkbox" name="module_content" id="module_content" <cfif isdefined("disc_ount10__selected") and disc_ount10__selected eq 1>checked</cfif> value="disc_ount10_"></td>
			<td>
            	<cfif isdefined("disc_ount10__line_order_no")>
                	<cfinput type="text" name="disc_ount10__sira"  validate="integer" message="#message1#" value="#disc_ount10__line_order_no#" style="width:25px;">
                <cfelse>
                	<cfinput type="text" name="disc_ount10__sira"  validate="integer" message="#message1#" value="" style="width:25px;">
                </cfif>
            </td>					
			<td>
            	<cfif isdefined("disc_ount10__genislik")>
                	<cfinput type="text" name="disc_ount10__genislik" value="#disc_ount10__genislik#"  validate="integer" message="#message2#" style="width:35px;">
                <cfelse>
                	<cfinput type="text" name="disc_ount10__genislik" value="20"  validate="integer" message="#message2#" style="width:35px;">
                </cfif>
            	
            </td>
			<td>
            	<input type="textbox" name="disc_ount10_" id="disc_ount10_" value="<cfif isdefined("disc_ount10__title_name")><cfoutput>#disc_ount10__title_name#</cfoutput><cfelse><cf_get_lang_main no='229.İSK'>10</cfif>">
            </td>
			<td><cf_get_lang_main no='229.İndirim'>10</td>
		  </tr>									
		  <tr>
		 	<cfsavecontent variable="message1"><cf_get_lang no ='1932.Sıra Numarası nümerik olmalıdır'></cfsavecontent>
			<cfsavecontent variable="message2"><cf_get_lang no ='1933.Numarası nümerik olmalıdır'></cfsavecontent> 
			<td><input type="checkbox" name="module_content" id="module_content" <cfif isdefined("price_net_selected") and price_net_selected eq 1>checked</cfif> value="price_net" ></td>
			<td>
            	<cfif isdefined("price_net_line_order_to")>
                	<cfinput type="text" name="price_net_sira" validate="integer" message="#message1#" value="#price_net_line_order_to#" style="width:25px;">
                <cfelse>
                	<cfinput type="text" name="price_net_sira" validate="integer" message="#message1#" style="width:25px;">
                </cfif>
            </td>				  
			<td>
            	<cfif isdefined("price_net_genislik")>
                	<cfinput type="text" name="price_net_genislik" value="#price_net_genislik#" validate="integer" message="#message2#" style="width:35px;">
                <cfelse>
                	<cfinput type="text" name="price_net_genislik" value="50" validate="integer" message="#message2#" style="width:35px;">
                </cfif>
            </td>
			<td>
            	<input type="textbox" name="PRICE_NET" id="PRICE_NET" value="<cfif isdefined("PRICE_NET_title_name")><cfoutput>#PRICE_NET_title_name#</cfoutput><cfelse><cf_get_lang_main no='671.Net'> <cf_get_lang_main no='672.Fiyat'></cfif>">
            </td>
		   	<td><cf_get_lang_main no='671.Net'> <cf_get_lang_main no='672.Fiyat'></td>
		  </tr>
		  <tr>
		  	<cfsavecontent variable="message1"><cf_get_lang no ='1932.Sıra Numarası nümerik olmalıdır'></cfsavecontent>
			<cfsavecontent variable="message2"><cf_get_lang no ='1933.Numarası nümerik olmalıdır'></cfsavecontent> 
			<td>
            <input type="checkbox" name="module_content" id="module_content" <cfif isdefined("price_net_doviz_selected") and price_net_doviz_selected eq 1>checked</cfif> value="price_net_doviz" >
            </td>
			<td>
            	<cfif isdefined("price_net_line_order_no")>
                	<cfinput type="text" name="price_net_doviz_sira" validate="integer" message="#message1#" value="#price_net_line_order_no#" style="width:25px;">
                <cfelse>
                	<cfinput type="text" name="price_net_doviz_sira" validate="integer" message="#message1#" style="width:25px;">
                </cfif>
            </td>
			<td>
            	<cfif isdefined("price_net_genislik")>
            		<cfinput type="text" name="price_net_doviz_genislik" value="#price_net_genislik#" validate="integer" message="#message2#" style="width:35px;">
                <cfelse>
                	<cfinput type="text" name="price_net_doviz_genislik" value="20" validate="integer" message="#message2#" style="width:35px;">
                </cfif>
            </td>
			<td>
            	<input type="textbox" name="price_net_doviz" id="price_net_doviz" value="<cfif isdefined("price_net_doviz_title_name")><cfoutput>#price_net_doviz_title_name#</cfoutput><cfelse><cf_get_lang no='744.Net Döviz'> <cf_get_lang_main no='672.Fiyat'></cfif>">
            </td>
		   	<td><cf_get_lang no='744.Net Döviz'> <cf_get_lang no='824.Fiyat(Döviz Fiyata Bağlı)'></td>
		  </tr>		
		  <tr>
			<cfsavecontent variable="message1"><cf_get_lang no ='1932.Sıra Numarası nümerik olmalıdır'></cfsavecontent>
			<cfsavecontent variable="message2"><cf_get_lang no ='1933.Numarası nümerik olmalıdır'></cfsavecontent> 
			<td><input type="checkbox" name="module_content" id="module_content" <cfif isdefined("duedate_selected") and duedate_selected eq 1>checked</cfif> value="Duedate"></td>
			<td>
            	<cfif isdefined("duedate_line_order_no")>
                	<cfinput type="text" name="Duedate_sira" validate="integer" message="#message1#" value="#duedate_line_order_no#" style="width:25px;">
                <cfelse>
                	<cfinput type="text" name="Duedate_sira" validate="integer" message="#message1#" value="" style="width:25px;">
                </cfif>
            </td>					
			<td>
            	<cfif isdefined("duedate_genislik")>
            		<cfinput type="text" name="Duedate_genislik" value="#duedate_genislik#" validate="integer" message="#message2#" style="width:35px;">
                <cfelse>
                	<cfinput type="text" name="Duedate_genislik" value="20" validate="integer" message="#message2#" style="width:35px;">
                </cfif>
            </td>
			<td>
            	<input type="textbox" name="Duedate" id="Duedate" value="<cfif isdefined("duedate_title_name")><cfoutput>#duedate_title_name#</cfoutput><cfelse><cf_get_lang_main no='228.Vade'></cfif>">
            </td>
			<td><cf_get_lang_main no='228.Vade'></td>
		  </tr>
		  <tr>
			<cfsavecontent variable="message1"><cf_get_lang no ='1932.Sıra Numarası nümerik olmalıdır'></cfsavecontent>
			<cfsavecontent variable="message2"><cf_get_lang no ='1933.Numarası nümerik olmalıdır'></cfsavecontent> 
			<td><input type="checkbox" name="module_content" id="module_content" <cfif isdefined("net_maliyet_selected") and net_maliyet_selected eq 1>checked</cfif> value="net_maliyet"></td>
			<td>
				<cfif isdefined("net_maliyet_line_order_no")>
                    <cfinput type="text" name="net_maliyet_sira" validate="integer" message="#message1#" value="#net_maliyet_line_order_no#" style="width:25px;">
                <cfelse>
                    <cfinput type="text" name="net_maliyet_sira" validate="integer" message="#message1#" style="width:25px;">
                </cfif>
            </td>					
			<td>
            	<cfif isdefined("net_maliyet_genislik")>
                	<cfinput type="text" name="net_maliyet_genislik" value="#net_maliyet_genislik#" validate="integer" message="#message2#" style="width:35px;">
                <cfelse>
                	<cfinput type="text" name="net_maliyet_genislik" value="40" validate="integer" message="#message2#" style="width:35px;">
                </cfif>
            </td>
			<td>
            <input type="textbox" name="net_maliyet" id="net_maliyet" value="<cfif isdefined("net_maliyet_title_name")><cfoutput>#net_maliyet_title_name#</cfoutput><cfelse><cf_get_lang no='680.Net Maliyet'></cfif>">
            </td>
			<td><cf_get_lang no='680.Net Maliyet'></td>
		  </tr>				
		  <tr>
			<cfsavecontent variable="message1"><cf_get_lang no ='1932.Sıra Numarası nümerik olmalıdır'></cfsavecontent>
			<cfsavecontent variable="message2"><cf_get_lang no ='1933.Numarası nümerik olmalıdır'></cfsavecontent> 
			<td><input type="checkbox" name="module_content" id="module_content" <cfif isdefined("extra_cost_selected") and extra_cost_selected eq 1>checked</cfif> value="extra_cost"></td>
			<td>
            	<cfif isdefined("extra_cost_line_order_no")>
                	<cfinput type="text" name="extra_cost_sira" id="extra_cost_sira" validate="integer" message="#message1#" value="#extra_cost_line_order_no#" style="width:25px;">
                <cfelse>
                	<cfinput type="text" name="extra_cost_sira" id="extra_cost_sira" validate="integer" message="#message1#" value="" style="width:25px;">
                </cfif>
            </td>
			<td>
            	<cfif isdefined("extra_cost_genislik")>
            		<cfinput type="text" name="extra_cost_genislik" id="extra_cost_genislik" value="#extra_cost_genislik#" validate="integer" message="#message2#" style="width:35px;">
                <cfelse>
                	<cfinput type="text" name="extra_cost_genislik" id="extra_cost_genislik" value="50" validate="integer" message="#message2#" style="width:35px;">
                </cfif>
            </td>					
			<td>
            <input type="textbox" name="extra_cost" id="extra_cost" value="<cfif isdefined("extra_cost_title_name")><cfoutput>#extra_cost_title_name#</cfoutput><cfelse><cf_get_lang no='993.Ek Maliyet'></cfif>">
            </td>
			<td><cf_get_lang no='993.Ek Maliyet'></td>
		  </tr>
		  <tr>
			<cfsavecontent variable="message1"><cf_get_lang no ='1932.Sıra Numarası nümerik olmalıdır'></cfsavecontent>
			<cfsavecontent variable="message2"><cf_get_lang no ='1933.Numarası nümerik olmalıdır'></cfsavecontent> 
			<td><input type="checkbox" name="module_content" id="module_content" <cfif isdefined("marj_selected")>checked</cfif> value="marj"></td>
			<td>
            	<cfif isdefined("marj_line_order_no")>
                	<cfinput type="text" name="marj_sira" validate="integer" message="#message1#" value="#marj_line_order_no#" style="width:25px;">
                <cfelse>
                	<cfinput type="text" name="marj_sira" validate="integer" message="#message1#" style="width:25px;">
                </cfif>
            </td>
			<td>
            	<cfif isdefined("marj_genislik")>
                	<cfinput type="text" name="marj_genislik" value="#marj_genislik#" validate="integer" message="#message2#" style="width:35px;">
                <cfelse>
                	<cfinput type="text" name="marj_genislik" value="20" validate="integer" message="#message2#" style="width:35px;">
                </cfif>
            </td>					
			<td><input type="textbox" name="marj" id="marj" value="<cfif isdefined("marj_title_name")><cfoutput>#marj_title_name#</cfoutput><cfelse><cf_get_lang no='544.Marj'></cfif>"></td>
			<td><cf_get_lang no='544.Marj'></td>
		  </tr>				
		  <tr>
			<cfsavecontent variable="message1"><cf_get_lang no ='1932.Sıra Numarası nümerik olmalıdır'></cfsavecontent>
			<cfsavecontent variable="message2"><cf_get_lang no ='1933.Numarası nümerik olmalıdır'></cfsavecontent> 
			<td><input type="checkbox" name="module_content" id="module_content" <cfif isdefined("row_total_selected") and row_total_selected eq 1>checked</cfif> value="row_total"></td>
			<td>
            	<cfif isdefined("row_total_line_order_no")>
                	<cfinput type="text" name="row_total_sira" validate="integer" message="#message1#" value="#row_total_line_order_no#" style="width:25px;">
                <cfelse>
                	<cfinput type="text" name="row_total_sira" validate="integer" message="#message1#" style="width:25px;">
                </cfif>
            </td>					
			<td>
            	<cfif isdefined("row_total_genislik")>
            		<cfinput type="text" name="row_total_genislik" value="#row_total_genislik#" validate="integer" message="#message2#" style="width:35px;">
                <cfelse>
                	<cfinput type="text" name="row_total_genislik" value="50" validate="integer" message="#message2#" style="width:35px;">
                </cfif>
            </td>
			<td>
            	<input type="textbox" name="row_total" id="row_total" value="<cfif isdefined("row_total_title_name")><cfoutput>#row_total_title_name#</cfoutput><cfelse><cf_get_lang_main no='758.Satir Toplam'></cfif>">
            </td>
			<td><cf_get_lang no='825.Satır Toplam(Fiyata Bağlı)'></td>
		  </tr>
		  <tr>
			<cfsavecontent variable="message1"><cf_get_lang no ='1932.Sıra Numarası nümerik olmalıdır'></cfsavecontent>
			<cfsavecontent variable="message2"><cf_get_lang no ='1933.Numarası nümerik olmalıdır'></cfsavecontent> 
			<td><input type="checkbox" name="module_content" id="module_content" <cfif isdefined("row_nettotal_selected") and row_nettotal_selected eq 1>checked</cfif> value="row_nettotal"></td>
			<td>
            	<cfif isdefined("row_nettotal_line_order_no")>
                	<cfinput type="text" name="row_nettotal_sira" validate="integer" message="#message1#" value="#row_nettotal_line_order_no#" style="width:25px;">
                <cfelse>
            		<cfinput type="text" name="row_nettotal_sira" validate="integer" message="#message1#" style="width:25px;">
               </cfif>
            </td>					
			<td>
            	<cfif isdefined("row_nettotal_genislik")>
                	<cfinput type="text" name="row_nettotal_genislik" value="#row_nettotal_genislik#" validate="integer" message="#message2#" style="width:35px;">
               	<cfelse>
                	<cfinput type="text" name="row_nettotal_genislik" value="50" validate="integer" message="#message2#" style="width:35px;">
                </cfif>
            </td>
			<td>
            	<input type="textbox" name="row_nettotal" id="row_nettotal" value="<cfif isdefined("row_nettotal_title_name")><cfoutput>#row_nettotal_title_name#</cfoutput><cfelse><cf_get_lang no='306.Net Satır Toplamı'></cfif>">
            </td>
			<td><cf_get_lang no='826.Net Satır Toplam(Fiyata Bağlı)'></td>
		  </tr>
		  <tr>
			<cfsavecontent variable="message1"><cf_get_lang no ='1932.Sıra Numarası nümerik olmalıdır'></cfsavecontent>
			<cfsavecontent variable="message2"><cf_get_lang no ='1933.Numarası nümerik olmalıdır'></cfsavecontent> 
			<td><input type="checkbox" name="module_content" id="module_content" <cfif isdefined("row_taxtotal_selected") and row_taxtotal_selected eq 1>checked</cfif> value="row_taxtotal"></td>
			<td>
            	<cfif isdefined("row_taxtotal_line_order_no")>
                	<cfinput type="text" name="row_taxtotal_sira" validate="integer" message="#message1#" value="#row_taxtotal_line_order_no#" style="width:25px;">
                <cfelse>
            		<cfinput type="text" name="row_taxtotal_sira" validate="integer" message="#message1#" style="width:25px;">
                </cfif>
            </td>					
			<td>
            	<cfif isdefined("row_taxtotal_genislik")>
                	<cfinput type="text" name="row_taxtotal_genislik" value="#row_taxtotal_genislik#" validate="integer" message="#message2#" style="width:35px;">
                <cfelse>
                	<cfinput type="text" name="row_taxtotal_genislik" value="50" validate="integer" message="#message2#" style="width:35px;">
                </cfif>
            </td>
			<td>
            	<input type="textbox" name="row_taxtotal" id="row_taxtotal" value="<cfif isdefined("row_taxtotal_title_name")><cfoutput>#row_taxtotal_title_name#</cfoutput><cfelse><cf_get_lang no='307.Vergi Toplam'></cfif>">
            </td>
			<td><cf_get_lang no='827.Vergi Toplam(Fiyat ve KDVye Bağlı)'></td>
		  </tr>
		  <tr>
			<cfsavecontent variable="message1"><cf_get_lang no ='1932.Sıra Numarası nümerik olmalıdır'></cfsavecontent>
			<cfsavecontent variable="message2"><cf_get_lang no ='1933.Numarası nümerik olmalıdır'></cfsavecontent> 
			<td><input type="checkbox" name="module_content" id="module_content" <cfif isdefined("row_lasttotal_selected") and row_lasttotal_selected eq 1>checked</cfif> value="row_lasttotal"></td>
			<td>
            	<cfif isdefined("row_lasttotal_line_order_no")>
                	<cfinput type="text" name="row_lasttotal_sira" validate="integer" message="#message1#" value="#row_lasttotal_line_order_no#" style="width:25px;">
                <cfelse>
                	<cfinput type="text" name="row_lasttotal_sira" validate="integer" message="#message1#" style="width:25px;">
                </cfif>
            </td>					
			<td>
            	<cfif isdefined("row_lasttotal_genislik")>
            		<cfinput type="text" name="row_lasttotal_genislik" value="#row_lasttotal_genislik#" validate="integer" message="#message2#" style="width:35px;">
               	<cfelse>
                	<cfinput type="text" name="row_lasttotal_genislik" value="50" validate="integer" message="#message2#" style="width:35px;">
                </cfif>
            </td>
			<td><input type="textbox" name="row_lasttotal" id="row_lasttotal" value="<cfif isdefined("row_lasttotal_title_name")><cfoutput>#row_lasttotal_title_name#</cfoutput><cfelse><cf_get_lang_main no='232.Son Toplam'></cfif>"></td>
			<td><cf_get_lang no='599.KDV,Fiyat ve Net Toplama Bağlı'></td>
		  </tr>
		  <tr>
		  	<cfsavecontent variable="message1"><cf_get_lang no ='1932.Sıra Numarası nümerik olmalıdır'></cfsavecontent>
			<cfsavecontent variable="message2"><cf_get_lang no ='1933.Numarası nümerik olmalıdır'></cfsavecontent> 
			<td><input type="checkbox" name="module_content" id="module_content" <cfif isdefined("other_money_value_selected") and other_money_value_selected eq 1>checked</cfif> value="other_money_value"  ></td>
			<td>
            	<cfif isdefined("other_money_value_line_order_no")>
                	<cfinput type="text" name="other_money_value_sira" validate="integer" message="#message1#" value="#other_money_value_line_order_no#" style="width:25px;">
                <cfelse>
            		<cfinput type="text" name="other_money_value_sira" validate="integer" message="#message1#" style="width:25px;">
                </cfif>
            </td>
			<td>
            	<cfif isdefined("other_money_value_genislik")>
            		<cfinput type="text" name="other_money_value_genislik" value="#other_money_value_genislik#" validate="integer" message="#message2#" style="width:35px;">
                <cfelse>
                	<cfinput type="text" name="other_money_value_genislik" value="50" validate="integer" message="#message2#" style="width:35px;">
                </cfif>
            </td>
			<td>
            	<input type="textbox" name="other_money_value" id="other_money_value" value="<cfif isdefined("other_money_value_title_name")><cfoutput>#other_money_value_title_name#</cfoutput><cfelse><cf_get_lang no='45.Satır Döviz Tutarı'></cfif>">
            </td>
		   	<td><cf_get_lang no='836.Satır Döviz Tutarı Satırın Döviz cinsinde değeri'></td>
		  </tr>
		  <tr>
			<cfsavecontent variable="message1"><cf_get_lang no ='1932.Sıra Numarası nümerik olmalıdır'></cfsavecontent>
			<cfsavecontent variable="message2"><cf_get_lang no ='1933.Numarası nümerik olmalıdır'></cfsavecontent> 
			<td><input type="checkbox" name="module_content" id="module_content" <cfif isdefined("other_money_gross_total_selected") and other_money_gross_total_selected eq 1>checked</cfif> value="other_money_gross_total"></td>
			<td>
            	<cfif isdefined("other_money_gross_total_line_order_no")>
                	<cfinput type="text" name="other_money_gross_total_sira" value="#other_money_gross_total_line_order_no#" validate="integer" message="#message1#" style="width:25px;">
                <cfelse>
            		<cfinput type="text" name="other_money_gross_total_sira" value="" validate="integer" message="#message1#" style="width:25px;">
                </cfif>
            </td>
			<td>
            	<cfif isdefined("other_money_gross_total_genislik")>
            		<cfinput type="text" name="other_money_gross_total_genislik" value="#other_money_gross_total_genislik#" validate="integer" message="#message2#" style="width:35px;">
                <cfelse>
                	<cfinput type="text" name="other_money_gross_total_genislik" value="50" validate="integer" message="#message2#" style="width:35px;">
                </cfif>
            </td>										
		  	<td>
            	<input type="textbox" name="other_money_gross_total" id="other_money_gross_total" value="<cfif isdefined("other_money_gross_total_title_name")><cfoutput>#other_money_gross_total_title_name#</cfoutput><cfelse><cf_get_lang no='761.Satır Döviz Vergili Toplam'></cfif>">
            </td>
		   	<td><cf_get_lang no='829.Satır Vergi Toplamı(Döviz Fiyata Bağlı)'></td>
		  </tr>		
		  <tr>
			<cfsavecontent variable="message1"><cf_get_lang no ='1932.Sıra Numarası nümerik olmalıdır'></cfsavecontent>
			<cfsavecontent variable="message2"><cf_get_lang no ='1933.Numarası nümerik olmalıdır'></cfsavecontent> 
			<td><input type="checkbox" name="module_content" id="module_content" <cfif isdefined("deliver_date_selected") and deliver_date_selected eq 1>checked</cfif> value="deliver_date"></td>
			<td>
            	<cfif isdefined("deliver_date_line_order_no")>
                	<cfinput type="text" name="deliver_date_sira" validate="integer" message="#message1#" value="#deliver_date_line_order_no#" style="width:25px;">
                <cfelse>
            		<cfinput type="text" name="deliver_date_sira" validate="integer" message="#message1#" style="width:25px;">
                </cfif>
            </td>					
			<td>
            	<cfif isdefined("deliver_date_genislik")>
            		<cfinput type="text" name="deliver_date_genislik"  value="#deliver_date_genislik#" validate="integer" message="#message2#" style="width:35px;">
                <cfelse>
                	<cfinput type="text" name="deliver_date_genislik" value="40" validate="integer" message="#message2#" style="width:35px;">
                </cfif>
            </td>
			<td><input type="textbox" name="deliver_date" id="deliver_date" value="<cfif isdefined("deliver_date_title_name")><cfoutput>#deliver_date_title_name#</cfoutput><cfelse><cf_get_lang_main no='233.Teslim Tarihi'></cfif>"></td>
			<td><cf_get_lang no='833.Teslim Tarihi İrsaliye ve Faturada kullanılmaz'> </td>
		  </tr>
		  <tr>
			<cfsavecontent variable="message1"><cf_get_lang no ='1932.Sıra Numarası nümerik olmalıdır'></cfsavecontent>
			<cfsavecontent variable="message2"><cf_get_lang no ='1933.Numarası nümerik olmalıdır'></cfsavecontent> 
			<td><input type="checkbox" name="module_content" id="module_content" <cfif isdefined("deliver_dept_selected") and deliver_dept_selected eq 1>checked</cfif> value="deliver_dept"></td>
			<td>
            	<cfif isdefined("deliver_dept_line_order_no")>
                	<cfinput type="text" name="deliver_dept_sira" validate="integer" message="#message1#" value="#deliver_dept_line_order_no#" style="width:25px;">
                <cfelse>
                	<cfinput type="text" name="deliver_dept_sira" validate="integer" message="#message1#" style="width:25px;">
                </cfif>
            	
            </td>					
			<td>
            	<cfif isdefined("deliver_dept_genislik")>
            		<cfinput type="text" name="deliver_dept_genislik" value="#deliver_dept_genislik#"  validate="integer" message="#message2#" style="width:35px;">
                <cfelse>
                	<cfinput type="text" name="deliver_dept_genislik" value="40"  validate="integer" message="#message2#" style="width:35px;">
                </cfif>
            </td>
			<td>
            	<input type="textbox" name="deliver_dept" id="deliver_dept" value="<cfif isdefined("deliver_dept_title_name")><cfoutput>#deliver_dept_title_name#</cfoutput><cfelse><cf_get_lang_main no='234.Teslim Depo'></cfif>">
            </td>
			<td><cf_get_lang no="834.Teslim depo İrsaliye ve Faturada kullanılmaz"></td>
		  </tr>
		  <tr>
		 	<cfsavecontent variable="message1"><cf_get_lang no ='1932.Sıra Numarası nümerik olmalıdır'></cfsavecontent>
			<cfsavecontent variable="message2"><cf_get_lang no ='1933.Numarası nümerik olmalıdır'></cfsavecontent> 
			<td><input type="checkbox" name="module_content" id="module_content" <cfif isdefined("deliver_dept_assortment_selected") and deliver_dept_assortment_selected eq 1>checked</cfif> value="deliver_dept_assortment"></td>
			<td>
            	<cfif isdefined("deliver_dept_assortment_line_order_no")>
                	<cfinput type="text" name="deliver_dept_assortment_sira" value="#deliver_dept_assortment_line_order_no#" validate="integer" message="#message1#" style="width:25px;">
                <cfelse>
                	<cfinput type="text" name="deliver_dept_assortment_sira" value="" validate="integer" message="#message1#" style="width:25px;">
                </cfif>
            </td>
			<td>
            	<cfif isdefined("deliver_dept_assortment_genislik")>
            		<cfinput type="text" name="deliver_dept_assortment_genislik" value="#deliver_dept_assortment_genislik#" validate="integer" message="#message2#" style="width:35px;">
                <cfelse>
                	<cfinput type="text" name="deliver_dept_assortment_genislik" value="40" validate="integer" message="#message2#" style="width:35px;">
                </cfif>
            </td>
		   	<td>
            	<input type="textbox" name="deliver_dept_assortment" id="deliver_dept_assortment" value="<cfif isdefined("deliver_dept_assortment_title_name")><cfoutput>#deliver_dept_assortment_title_name#</cfoutput><cfelse><cf_get_lang no='530.Teslim Depo Dağılım'></cfif>">
            </td>
			<td><cf_get_lang no='530.Teslim Depo Dağılım'></td>
		  </tr>				
		  <tr>
		  	<cfsavecontent variable="message1"><cf_get_lang no ='1932.Sıra Numarası nümerik olmalıdır'></cfsavecontent>
			<cfsavecontent variable="message2"><cf_get_lang no ='1933.Numarası nümerik olmalıdır'></cfsavecontent> 
			<td><input type="checkbox" name="module_content" id="module_content" <cfif isdefined("spec_selected") and spec_selected eq 1>checked</cfif> value="spec"></td>
			<td>
            	<cfif isdefined("spec_line_order_no")>
                	<cfinput type="text" name="spec_sira" id="spec_sira" validate="integer" message="#message1#" value="#spec_line_order_no#" style="width:25px;">
                <cfelse>
                	<cfinput type="text" name="spec_sira" id="spec_sira" validate="integer" message="#message1#" style="width:25px;">
                </cfif>
            	
            </td>					
			<td>
            	<cfif isdefined("spec_genislik")>
                	<cfinput type="text" name="spec_genislik" value="#spec_genislik#" validate="integer" message="#message2#" style="width:35px;">
                <cfelse>
                	<cfinput type="text" name="spec_genislik" value="40" validate="integer" message="#message2#" style="width:35px;">
                </cfif>
            </td>
			<td>
            	<cfif isdefined("spec_title_name")>
                	<input type="textbox" name="spec" id="spec" value="<cfoutput>#spec_title_name#</cfoutput>">
                <cfelse>
                	<input type="textbox" name="spec" id="spec" value="<cf_get_lang_main no='235.Spec'>">
                </cfif>
            </td>
			<td><cf_get_lang_main no='235.Spec'></td>
		  </tr>
		  <tr>
		  	<cfsavecontent variable="message1"><cf_get_lang no ='1932.Sıra Numarası nümerik olmalıdır'></cfsavecontent>
			<cfsavecontent variable="message2"><cf_get_lang no ='1933.Numarası nümerik olmalıdır'></cfsavecontent> 
			<td>
            	<input type="checkbox" name="module_content" id="module_content" <cfif isdefined("lot_no_selected") and lot_no_selected eq 1>checked</cfif> value="lot_no">
            </td>
			<td>
				<cfif isdefined("lot_no_line_order_no")>
                	<cfinput type="text" name="lot_no_sira" validate="integer" message="#message1#" value="#lot_no_line_order_no#" style="width:25px;">
                <cfelse>
            		<cfinput type="text" name="lot_no_sira" validate="integer" message="#message1#" style="width:25px;">
                </cfif>
            </td>					
			<td>
            	<cfif isdefined("lot_no_genislik")>
            		<cfinput type="text" name="lot_no_genislik" value="#lot_no_genislik#" validate="integer" message="#message2#" style="width:35px;">
                <cfelse>
                	<cfinput type="text" name="lot_no_genislik" value="40" validate="integer" message="#message2#" style="width:35px;">
                </cfif>
            </td>
			<td>
            	<input type="textbox" name="lot_no" id="lot_no" value="<cfif isdefined("lot_no_title_name")><cfoutput>#lot_no_title_name#</cfoutput><cfelse><cf_get_lang no='46.Lot No'></cfif>">
            </td>
			<td><cf_get_lang no='46.Lot No'></td>
		  </tr>
		  <tr>
			<cfsavecontent variable="message1"><cf_get_lang no ='1932.Sıra Numarası nümerik olmalıdır'></cfsavecontent>
			<cfsavecontent variable="message2"><cf_get_lang no ='1933.Numarası nümerik olmalıdır'></cfsavecontent> 
			<td><input type="checkbox" name="module_content" id="module_content" <cfif isdefined("price_total_selected") and price_total_selected eq 1>checked</cfif> value="price_total"></td>
			<td>
            	<cfif isdefined("price_total_line_order_no")>
                	<cfinput type="text" name="price_total_sira" validate="integer" message="#message1#" value="#price_total_line_order_no#" style="width:25px;">
                <cfelse>
            		<cfinput type="text" name="price_total_sira" validate="integer" message="#message1#" style="width:25px;">
                </cfif>
            </td>					
			<td>
            	<cfif isdefined("price_total_genislik")>
                	<cfinput type="text" name="price_total_genislik" value="#price_total_genislik#" validate="integer" message="#message2#" style="width:35px;">
                <cfelse>
            		<cfinput type="text" name="price_total_genislik" value="50" validate="integer" message="#message2#" style="width:35px;">
                </cfif>
            </td>
			<td><input type="textbox" name="price_total" id="price_total" value="<cfif isdefined("price_total_title_name")><cfoutput>#price_total_title_name#</cfoutput><cfelse><cf_get_lang no='837.Basket Toplam'></cfif>"></td>
			<td><cf_get_lang no='831.Basket Toplam Belgenin bütün toplamı'>(<cf_get_lang no='620.KDV ve Fiyata Bağlı'>)</td>
		  </tr>
		  <tr>
			<cfsavecontent variable="message1"><cf_get_lang no ='1932.Sıra Numarası nümerik olmalıdır'></cfsavecontent>
			<cfsavecontent variable="message2"><cf_get_lang no ='1933.Numarası nümerik olmalıdır'></cfsavecontent> 
			<td><input type="checkbox" name="module_content" id="module_content" <cfif isdefined("darali_selected") and darali_selected eq 1>checked</cfif> value="darali"></td>
			<td>
            	<cfif isdefined("darali_line_order_no")>
                	<cfinput type="text" name="darali_sira" value="#darali_line_order_no#" validate="integer" message="#message1#" style="width:25px;">
                <cfelse>
                	<cfinput type="text" name="darali_sira" value="" validate="integer" message="#message1#" style="width:25px;">
                </cfif>
            	
            </td>
			<td>
            	<cfif isdefined("darali_genislik")>
                	<cfinput type="text" name="darali_genislik" value="#darali_genislik#" validate="integer" message="#message2#" style="width:35px;">
                <cfelse>
                	<cfinput type="text" name="darali_genislik" value="20" validate="integer" message="#message2#" style="width:35px;">
                </cfif>
            </td>
			<td>
            	<input type="textbox" name="darali" id="darali" value="<cfif isdefined("darali_title_name")><cfoutput>#darali_title_name#</cfoutput><cfelse><cf_get_lang no='638.Daralı'></cfif>"></td>
			<td><cf_get_lang no='638.Daralı'></td>
		  </tr>
		  <tr>
			<cfsavecontent variable="message1"><cf_get_lang no ='1932.Sıra Numarası nümerik olmalıdır'></cfsavecontent>
			<cfsavecontent variable="message2"><cf_get_lang no ='1933.Numarası nümerik olmalıdır'></cfsavecontent> 
			<td><input type="checkbox" name="module_content" id="module_content" <cfif isdefined("dara_selected") and dara_selected eq 1>checked</cfif> value="dara" ></td>
			<td>
            	<cfif isdefined("dara_line_order_no")>
                	<cfinput type="text" name="dara_sira" value="#dara_line_order_no#" validate="integer" message="#message1#" style="width:25px;">
                <cfelse>
                	<cfinput type="text" name="dara_sira" value="" validate="integer" message="#message1#" style="width:25px;">
                </cfif>
            	
            </td>
			<td>
            	<cfif isdefined("dara_genislik")>
            		<cfinput type="text" name="dara_genislik"  value="#dara_genislik#" validate="integer" message="#message2#" style="width:35px;">
                <cfelse>
                	<cfinput type="text" name="dara_genislik"  value="25" validate="integer" message="#message2#" style="width:35px;">
                </cfif>
            </td>
			<td>
            	<input type="textbox" name="dara" id="dara" value="<cfif isdefined("dara_title_name")><cfoutput>#dara_title_name#</cfoutput><cfelse><cf_get_lang no='654.Dara'></cfif>">
            </td>
			<td><cf_get_lang no='654.Dara'></td>
		  </tr>
		  <tr>
			<cfsavecontent variable="message1"><cf_get_lang no ='1932.Sıra Numarası nümerik olmalıdır'></cfsavecontent>
			<cfsavecontent variable="message2"><cf_get_lang no ='1933.Numarası nümerik olmalıdır'></cfsavecontent> 
			<td><input type="checkbox" name="module_content" id="module_content" <cfif isdefined("shelf_number_selected") and shelf_number_selected eq 1>checked</cfif> value="shelf_number"></td>
			<td>
            	<cfif isdefined("shelf_number_line_order_no")>
                	<cfinput type="text" name="shelf_number_sira" value="#shelf_number_line_order_no#" validate="integer" message="#message1#" style="width:25px;">
                <cfelse>
                	<cfinput type="text" name="shelf_number_sira" value="" validate="integer" message="#message1#" style="width:25px;">
                </cfif>
            </td>
			<td>
            	<cfif isdefined("shelf_number_genislik")>
                	<cfinput type="text" name="shelf_number_genislik"  value="#shelf_number_genislik#" validate="integer" message="#message2#" style="width:35px;">
                <cfelse>
                	<cfinput type="text" name="shelf_number_genislik"  value="25" validate="integer" message="#message2#" style="width:35px;">
                </cfif>
            </td>
			<td>
            	<input type="textbox" name="shelf_number" id="shelf_number" value="<cfif isdefined("shelf_number_title_name")><cfoutput>#shelf_number_title_name#</cfoutput><cfelse><cf_get_lang no='1059.Raf No'></cfif>">
            </td>
			<td><cf_get_lang no='1059.Raf No'></td>
		  </tr>
		   <tr>
			<cfsavecontent variable="message1"><cf_get_lang no ='1932.Sıra Numarası nümerik olmalıdır'></cfsavecontent>
			<cfsavecontent variable="message2"><cf_get_lang no ='1933.Numarası nümerik olmalıdır'></cfsavecontent> 
			<td><input type="checkbox" name="module_content" id="module_content" <cfif isdefined("order_currency_selected") and order_currency_selected eq 1>checked</cfif> value="order_currency"></td>
			<td>
            	<cfif isdefined("order_currency_line_order_no")>
                	<cfinput type="text" name="order_currency_sira" value="#order_currency_line_order_no#" validate="integer" message="#message1#" style="width:25px;">
                <cfelse>
                	<cfinput type="text" name="order_currency_sira" value="" validate="integer" message="#message1#" style="width:25px;">
                </cfif>
            </td>
			<td>
            	<cfif isdefined("order_currency_genislik")>
            		<cfinput type="text" name="order_currency_genislik"  value="#order_currency_genislik#" validate="integer" message="#message2#" style="width:35px;">
                <cfelse>
                	<cfinput type="text" name="order_currency_genislik"  value="25" validate="integer" message="#message2#" style="width:35px;">
                </cfif>
            </td>
			<td><input type="textbox" name="order_currency" id="order_currency" value="<cfif isdefined("order_currency_title_name")><cfoutput>#order_currency_title_name#</cfoutput><cfelse><cf_get_lang no='1041.Sipariş Aşama'></cfif>"></td>
			<td><cf_get_lang no='1041.Sipariş Aşama'></td>
		  </tr>
		   <tr>
			<cfsavecontent variable="message1"><cf_get_lang no ='1932.Sıra Numarası nümerik olmalıdır'></cfsavecontent>
			<cfsavecontent variable="message2"><cf_get_lang no ='1933.Numarası nümerik olmalıdır'></cfsavecontent> 
			<td><input type="checkbox" name="module_content" id="module_content" <cfif isdefined("reserve_type_selected") and reserve_type_selected eq 1>checked</cfif> value="reserve_type"></td>
			<td>
            	<cfif isdefined("reserve_type_line_order_no")>
                	<cfinput type="text" name="reserve_type_sira" value="#reserve_type_line_order_no#" validate="integer" message="#message1#" style="width:25px;">
                <cfelse>
            		<cfinput type="text" name="reserve_type_sira" value="" validate="integer" message="#message1#" style="width:25px;">
                </cfif>
            </td>
			<td>
            	<cfif isdefined("reserve_type_genislik")>
                	<cfinput type="text" name="reserve_type_genislik"  value="#reserve_type_genislik#" validate="integer" message="#message2#" style="width:35px;">
                <cfelse>
                	<cfinput type="text" name="reserve_type_genislik"  value="25" validate="integer" message="#message2#" style="width:35px;">
                </cfif>
            </td>
			<td><input type="textbox" name="reserve_type" id="reserve_type" value="<cfif isdefined("reserve_type_title_name")><cfoutput>#reserve_type_title_name#</cfoutput><cfelse><cf_get_lang no='1599.Rezerve Tipi'></cfif>"></td>
			<td><cf_get_lang no ='1599.Rezerve Tipi'></td>
		  </tr>
		   <tr>
			<cfsavecontent variable="message1"><cf_get_lang no ='1932.Sıra Numarası nümerik olmalıdır'></cfsavecontent>
			<cfsavecontent variable="message2"><cf_get_lang no ='1933.Numarası nümerik olmalıdır'></cfsavecontent> 
			<td><input type="checkbox" name="module_content" id="module_content" <cfif isdefined("reserve_date_selected") and reserve_date_selected eq 1>checked</cfif> value="reserve_date"></td>
			<td>
            	<cfif isdefined("reserve_date_line_order_no")>
                	<cfinput type="text" name="reserve_date_sira" value="#reserve_date_line_order_no#" validate="integer" message="#message1#" style="width:25px;">
                <cfelse>
            		<cfinput type="text" name="reserve_date_sira" value="" validate="integer" message="#message1#" style="width:25px;">
                </cfif>
            </td>
			<td>
            	<cfif isdefined("reserve_date_genislik")>
                	<cfinput type="text" name="reserve_date_genislik"  value="#reserve_date_genislik#" validate="integer" message="#message2#" style="width:35px;">
                <cfelse>
            		<cfinput type="text" name="reserve_date_genislik"  value="25" validate="integer" message="#message2#" style="width:35px;">
                </cfif>
            </td>
			<td><input type="textbox" name="reserve_date" id="reserve_date" value="<cfif isdefined("reserve_date_title_name")><cfoutput>#reserve_date_title_name#</cfoutput><cfelse><cf_get_lang no='1598.Rezerve Tarihi'></cfif>"></td>
			<td><cf_get_lang no ='1598.Rezerve Tarihi'></td>
		  </tr>					
		  <tr>
			<cfsavecontent variable="message1"><cf_get_lang no ='1932.Sıra Numarası nümerik olmalıdır'></cfsavecontent>
			<cfsavecontent variable="message2"><cf_get_lang no ='1933.Numarası nümerik olmalıdır'></cfsavecontent> 
			<td><input type="checkbox" name="module_content" id="module_content" <cfif isdefined("is_parse_selected") and is_parse_selected eq 1>checked</cfif> value="is_parse"></td>
			<td>
            	<cfif isdefined("is_parse_line_order_no")>
                	<cfinput type="text" name="is_parse_sira" validate="integer" message="#message1#" value="#is_parse_line_order_no#" style="width:25px;">
                <cfelse>
                	<cfinput type="text" name="is_parse_sira" validate="integer" message="#message1#" style="width:25px;">
                </cfif>
            </td>				
			<td>
            	<cfif isdefined("is_parse_genislik")>
                	<cfinput type="text" name="is_parse_genislik" value="#is_parse_genislik#" validate="integer" message="#message2#" style="width:35px;">
                <cfelse>
                	<cfinput type="text" name="is_parse_genislik" value="20" validate="integer" message="#message2#" style="width:35px;">
                </cfif>
            </td>					
			<td><input type="hidden" name="is_parse" id="is_parse" value="Dağılım"></td>
			<td><cf_get_lang no='280.Dağılım'></td>
		  </tr>
		  <tr>
			<cfsavecontent variable="message1"><cf_get_lang no ='1932.Sıra Numarası nümerik olmalıdır'></cfsavecontent>
			<cfsavecontent variable="message2"><cf_get_lang no ='1933.Numarası nümerik olmalıdır'></cfsavecontent> 
			<td><input type="checkbox" name="module_content" id="module_content" <cfif isdefined("kdv_selected") and kdv_selected eq 1> checked</cfif> value="Kdv"></td>
			<td>
            	<cfif isdefined("Kdv_line_order_no")>
                	<cfinput type="text" name="Kdv_sira" validate="integer" message="#message1#" value="#Kdv_line_order_no#" style="width:25px;">
                <cfelse>
            		<cfinput type="text" name="Kdv_sira" validate="integer" message="#message1#" style="width:25px;">
                </cfif>
            </td>
			<td>
            	<cfif isdefined("Kdv_genislik")>
                	<cfinput type="text" name="Kdv_genislik"  value="#Kdv_genislik#" validate="integer" message="#message2#" style="width:35px;">
                <cfelse>
                	<cfinput type="text" name="Kdv_genislik"  value="20" validate="integer" message="#message2#" style="width:35px;">
                </cfif>
            </td>					
			<td><input type="hidden" name="Kdv" id="Kdv" value="KDV Toplam"></td>
			<td><cf_get_lang no='667.KDV Toplam KDV ye Bağl Satır Vergi Toplamına Bağlı'></td>
		  </tr>
		  <tr>
		  <td><input type="checkbox" name="module_content" id="module_content" <cfif isdefined("is_promotion_selected") and is_promotion_selected eq 1> checked</cfif> value="is_promotion"></td>
		   	<td colspan="3"><input type="hidden" name="is_promotion" id="is_promotion" value="Ödeme Yöntemi"><cf_get_lang_main no='171.Promosyonlu'></td>
		  </tr>
		  <tr>
			<td><input type="checkbox" name="module_content" id="module_content" <cfif isdefined("zero_stock_status_selected") and zero_stock_status_selected eq 1> checked</cfif> value="zero_stock_status"></td>
			<td colspan="3"><cf_get_lang no='749.Sıfır Stok ile Çalış'></td>
		  </tr>	
        </table>
        <cf_form_box_footer><cf_workcube_buttons add_function='kontrol()'></cf_form_box_footer>							
		</cfform>
    </cf_area>
</cf_form_box>
<script type="text/javascript">
function kontrol()
{
	if (document.add_basket_details.BASKET_ID.value.length ==0)
	{ 
		alert ("<cf_get_lang no ='1314.Lütfen Kullanım Tipi Seçiniz'>!");
		return false;
	}
	return true;
}
</script>
