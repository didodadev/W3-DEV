<cfset attributes.B_TYPE = 0 >
<script type="text/javascript">
function sec()
{
	for (i=0; i < add_basket_details.module_content.length; i=i+1)
		add_basket_details.module_content[i].checked = true;
}
</script>
<cfsavecontent variable="img_">
<a href="<cfoutput>#request.self#</cfoutput>?fuseaction=settings.form_add_bskt_temp_detail"><img src="/images/plus1.gif" align="absbottom" border="0" alt="<cf_get_lang no ='1928.Basket Output Şablonu Ekle'>">
 </a>
 <a href="<cfoutput>#request.self#?fuseaction=settings.form_add_bskt_temp_detail&id=#attributes.id#</cfoutput>"><img src="/images/plus.gif" align="absbottom" border="0" alt="<cf_get_lang_main no='64.Kopyala'>">
 </a>
</cfsavecontent>
<cf_form_box title="#getLang('settings',297)#" right_images="#img_#">	
    <cf_area width="150">
        <cfinclude template="../display/list_basket_temp_modules.cfm">
    </cf_area>
	<cfset attributes.basket_id = attributes.ID>
	<cfset attributes.bskt_list = 2>
	<cfinclude template="../query/get_basket_details.cfm">
    <cfquery name="get_module_dsp" datasource="#DSN3#">
        SELECT * FROM SETUP_BASKET_ROWS WHERE BASKET_ID = #GET_BASKET.BASKET_ID# AND B_TYPE=0
    </cfquery>
  <cf_area>
      <cfform name="add_basket_details"  method="post" action="#request.self#?fuseaction=settings.upd_bskt_temp_detail_act&id=#attributes.id#">
        <input type="hidden" name="B_TYPE" id="B_TYPE" value="0">
        <input type="hidden" name="BASKET_ID" id="BASKET_ID" value="<cfoutput>#GET_BASKET.BASKET_ID#</cfoutput>">
        <table>
        <tr>
          <td><b><cf_get_lang_main no='1160.Kullanım'></b> 
            <select name="MODULE_ID_" id="MODULE_ID_" style="width=200px;" disabled>
              <option<cfif get_basket.basket_id eq 1> selected</cfif> value="1"><cf_get_lang no='84.Satınalma Faturası'></option>
              <option<cfif get_basket.basket_id eq 2> selected</cfif> value="2"><cf_get_lang no='85.Satış Faturası'></option>
              <option<cfif get_basket.basket_id eq 3> selected</cfif> value="3" > <cf_get_lang no='86.Satış Teklifi'> </option>
              <option<cfif get_basket.basket_id eq 4> selected</cfif> value="4"><cf_get_lang no='87.Satış Siparişi'></option>
              <option<cfif get_basket.basket_id eq 5> selected</cfif> value="5"><cf_get_lang no='88.Satınalma Teklifi'></option>
              <option<cfif get_basket.basket_id eq 6> selected</cfif> value="6"><cf_get_lang no='71.Satınalma Siparişi'></option>
              <option<cfif get_basket.basket_id eq 7> selected</cfif> value="7"><cf_get_lang no='89.Satınalma İç Talepleri'></option>
              <option<cfif get_basket.basket_id eq 8> selected</cfif> value="8"><cf_get_lang no='90.Yazışmalar İç Talepler'></option>
              <option<cfif get_basket.basket_id eq 10> selected</cfif> value="10"><cf_get_lang no='92.Stok Satış İrsaliyesi'></option>
              <option<cfif get_basket.basket_id eq 31> selected</cfif> value="31"><cf_get_lang no='747.Stok Sevk İrsaliyesi'></option>					  					  
              <option<cfif get_basket.basket_id eq 11> selected</cfif> value="11"><cf_get_lang no='93.Stok Alım İrsaliyesi'></option>
              <option<cfif get_basket.basket_id eq 12> selected</cfif> value="12"><cf_get_lang no='528.Stok Fişi Ekle'></option>
              <option<cfif get_basket.basket_id eq 13> selected</cfif> value="13"><cf_get_lang no='95.Stok Açılış Fişi'></option>
              <option<cfif get_basket.basket_id eq 14> selected</cfif> value="14"><cf_get_lang no='96.Stok Satış Siparişi'></option>
              <option<cfif get_basket.basket_id eq 15> selected</cfif> value="15"><cf_get_lang no='98.Stok Alım Siparişi'></option>
              <option<cfif get_basket.basket_id eq 17> selected</cfif> value="17"><cf_get_lang no='99.Şube Alım İrsaliyesi'> </option>
              <option<cfif get_basket.basket_id eq 18> selected</cfif> value="18"><cf_get_lang no='100.Şube Satış Faturası'></option>
              <option<cfif get_basket.basket_id eq 19> selected</cfif> value="19"><cf_get_lang no='101.Şube Stok Fişi'> </option>
              <option<cfif get_basket.basket_id eq 20> selected</cfif> value="20"><cf_get_lang no='102.Şube Alış Faturası'></option>
              <option<cfif get_basket.basket_id eq 21> selected</cfif> value="21"><cf_get_lang no='103.Şube Satış İrsaliyesi'></option>
              <option<cfif get_basket.basket_id eq 32> selected</cfif> value="32"><cf_get_lang no='748.Şube Sevk İrsaliyesi'></option>					  
              <option<cfif get_basket.basket_id eq 24> selected</cfif>	value="24"><cf_get_lang no='443.Partner Portal Teklifler'> (<cf_get_lang_main no='36.Satış'>)</option>
              <option<cfif get_basket.basket_id eq 25> selected</cfif> value="25" > <cf_get_lang no='77.Partner Portal Siparişler'> (<cf_get_lang_main no='36.Satış'>)</option>
              <option<cfif get_basket.basket_id eq 26> selected</cfif> value="26"><cf_get_lang no='107.Partner Portal Ürün Katalogları'></option>
              <option<cfif get_basket.basket_id eq 28> selected</cfif> value="28" ><cf_get_lang no='109.Public Portal Basket'> </option>
              <option<cfif get_basket.basket_id eq 29> selected</cfif> value="29"><cf_get_lang no='110.Kataloglar'> </option>
              <option<cfif get_basket.basket_id eq 33> selected</cfif> value="33"><cf_get_lang_main no='411.Müstahsil Makbuzu'></option>
              <option<cfif get_basket.basket_id eq 34> selected</cfif> value="34"><cf_get_lang no='760.Bütçe Satış Kotaları'></option>
              <option<cfif get_basket.basket_id eq 35> selected</cfif> value="35"><cf_get_lang no='820.Partner Portal(Alım) Siparişleri'></option>
              <option<cfif get_basket.basket_id eq 36> selected</cfif> value="36"><cf_get_lang no='821.Partner Portal(Alım) Teklifleri'></option>					  					  
              <option<cfif get_basket.basket_id eq 38> selected</cfif> value="38"><cf_get_lang no='758.Sube Satış Siparişi'></option>
              <option<cfif get_basket.basket_id eq 37> selected</cfif> value="37"><cf_get_lang no='832.Sube Alım Siparişi'></option>
              <option<cfif get_basket.basket_id eq 39> selected</cfif> value="39"><cf_get_lang no='314.Şube İç Talepler'></option>
              <option<cfif get_basket.basket_id eq 40> selected</cfif> value="40"><cf_get_lang no='348.Stok Hal İrsaliyesi'></option>
              <option<cfif get_basket.basket_id eq 41> selected</cfif> value="41"><cf_get_lang no='356.Şube Hal İrsaliyesi'></option>
              <option<cfif get_basket.basket_id eq 42> selected</cfif> value="42"><cf_get_lang_main no='407.Hal Faturası'></option>
              <option<cfif get_basket.basket_id eq 43> selected</cfif> value="43"><cf_get_lang no='422.Şube Hal Faturası'></option>
              <option<cfif get_basket.basket_id eq 44> selected</cfif> value="44"><cf_get_lang no='475.Sevk İç Talep'></option>
              <option<cfif get_basket.basket_id eq 45> selected</cfif> value="45"><cf_get_lang no='475.Sevk İç Talep'></option>
              <option<cfif get_basket.basket_id eq 46> selected</cfif> value="46"><cf_get_lang_main no='1420.Abone'></option>				  
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
            <td style="width:25px;"><cf_get_lang_main no='1165.Sıra'></td>
            <td style="width:35px;"><cf_get_lang no='670.En'></td>
            <td><cf_get_lang no='818.Basket Adı'></td>
            <td><cf_get_lang_main no='1160.Kullanım'></td>
          </tr>
          <tr>
            <td>
            	<cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'basket_cursor'</cfquery>
            	<input type="checkbox" name="module_content"  id="module_content" <cfif len(get_detail.is_selected) and get_detail.is_selected eq 1> Checked </cfif>value="basket_cursor">
            </td>
            <td></td>
            <td></td>
            <td><input type="textbox"  name="basket_cursor" id="basket_cursor" value="<cfoutput>#get_detail.title_name#</cfoutput>" ></td>
            <td><cf_get_lang no='393.Barkod Cihazı'></td>
          </tr>
          <tr>
            <td>
            	<cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'stock_code'</cfquery>
            	<input type="checkbox" name="module_content" id="module_content" <cfif len(get_detail.is_selected) and get_detail.is_selected eq 1> checked</cfif> value="stock_code"></td>
                <cfsavecontent variable="message1"><cf_get_lang no ='1932.Sıra Numarası nümerik olmalıdır'></cfsavecontent>
                <cfsavecontent variable="message2"><cf_get_lang no ='1933.Numarası nümerik olmalıdır'></cfsavecontent>  
            <td><cfinput type="text" name="stock_code_sira" id="stock_code_sira" value="#get_detail.line_order_no#"  validate="integer" message="#message1#" style="width:25px;"></td>
            <td><cfinput type="text"  name="stock_code_genislik" id="stock_code_genislik"  value="#get_detail.genislik#"   validate="integer" message="#message2#" style="width:35px;"></td>
            <td><input type="textbox"  name="stock_code" id="stock_code" value="<cfoutput>#get_detail.title_name#</cfoutput>"></td>
            <td><cf_get_lang_main no='106.Stok Kodu'></td>
          </tr>
          <tr>
            <cfsavecontent variable="message1"><cf_get_lang no ='1932.Sıra Numarası nümerik olmalıdır'></cfsavecontent>
            <cfsavecontent variable="message2"><cf_get_lang no ='1933.Numarası nümerik olmalıdır'></cfsavecontent> 
            <td>
            	<cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'Barcod'</cfquery>
            	<input type="checkbox" name="module_content" id="module_content" <cfif len(get_detail.is_selected) and get_detail.is_selected eq 1> Checked </cfif> value="Barcod">
            </td>
            <td><cfinput type="text" name="Barcod_sira" id="Barcod_sira" value="#get_detail.line_order_no#" validate="integer" message="#message1#" style="width:25px;"></td>
            <td><cfinput type="text" name="Barcod_genislik" id="Barcod_genislik"  value="#get_detail.genislik#" validate="integer" message="#message2#" style="width:35px;"></td>
            <td><input type="textbox" name="Barcod" id="Barcod" value="<cfoutput>#get_detail.title_name#</cfoutput>"></td>
            <td><cf_get_lang_main no='221.Barkod'></td>
          </tr>
          <tr>
            <cfsavecontent variable="message1"><cf_get_lang no ='1932.Sıra Numarası nümerik olmalıdır'></cfsavecontent>
            <cfsavecontent variable="message2"><cf_get_lang no ='1933.Numarası nümerik olmalıdır'></cfsavecontent> 
            <td>
            	<cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'manufact_code'</cfquery>
            	<input type="checkbox" name="module_content" id="module_content" <cfif len(get_detail.is_selected) and get_detail.is_selected eq 1> Checked </cfif> value="manufact_code">
            </td>
            <td><cfinput type="text" name="manufact_code_sira" id="manufact_code_sira" validate="integer" message="#message1#" value="#get_detail.line_order_no#" style="width:25px;"></td>
            <td><cfinput type="text" name="manufact_code_genislik" id="manufact_code_genislik"  validate="integer" message="#message2#" value="#get_detail.genislik#" style="width:35px;"></td>
            <td><input type="textbox" name="manufact_code" id="manufact_code" value="<cfoutput>#get_detail.title_name#</cfoutput>"></td>
            <td><cf_get_lang_main no='222.Üretici Kodu'></td>
          </tr>
          <tr>
            <cfsavecontent variable="message1"><cf_get_lang no ='1932.Sıra Numarası nümerik olmalıdır'></cfsavecontent>
            <cfsavecontent variable="message2"><cf_get_lang no ='1933.Numarası nümerik olmalıdır'></cfsavecontent> 
            <td>
            	<cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'product_name'</cfquery>
            	<input type="checkbox" name="module_content" id="module_content" <cfif len(get_detail.is_selected) and get_detail.is_selected eq 1> Checked </cfif> value="product_name">
            </td>
            <td><cfinput type="text" name="product_name_sira" id="product_name_sira" validate="integer" message="#message1#"  value="#get_detail.line_order_no#" style="width:25px;"></td>
            <td><cfinput type="text" name="product_name_genislik" id="product_name_genislik" value="#get_detail.genislik#" validate="integer" message="#message2#" style="width:35px;"></td>
            <td>
          		<input type="textbox" name="product_name" id="product_name" <cfif len(get_detail.is_selected) and get_detail.is_selected eq 1> Checked </cfif> value="<cf_get_lang_main no='245.Ürün'>">
            </td>
            <td><cf_get_lang_main no='245.Ürün'></td>
          </tr>
          <tr>
            <cfsavecontent variable="message1"><cf_get_lang no ='1932.Sıra Numarası nümerik olmalıdır'></cfsavecontent>
            <cfsavecontent variable="message2"><cf_get_lang no ='1933.Numarası nümerik olmalıdır'></cfsavecontent> 
            <td>
            	<cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'Amount'</cfquery>
            	<input type="checkbox" name="module_content" id="module_content" <cfif len(get_detail.is_selected) and get_detail.is_selected eq 1> Checked </cfif> value="Amount">
            </td>
            <td><cfinput type="text" name="Amount_sira" id="Amount_sira" value="#get_detail.line_order_no#" validate="integer" message="#message1#" style="width:25px;"></td>
            <td><cfinput type="text" name="Amount_genislik" id="Amount_genislik" value="#get_detail.genislik#" validate="integer" message="#message2#" style="width:35px;"></td>
            <td><input type="textbox" name="Amount" id="Amount" value="<cfoutput>#get_detail.title_name#</cfoutput>" maxlength="200"></td>
            <td><cf_get_lang_main no='223.Miktar'></td>
          </tr>
          <tr>
            <cfsavecontent variable="message1"><cf_get_lang no ='1932.Sıra Numarası nümerik olmalıdır'></cfsavecontent>
            <cfsavecontent variable="message2"><cf_get_lang no ='1933.Numarası nümerik olmalıdır'></cfsavecontent> 
            <td>
            	<cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'Unit'</cfquery>
            	<input type="checkbox" name="module_content" id="module_content" <cfif len(get_detail.is_selected) and get_detail.is_selected eq 1> Checked </cfif> value="Unit">
            </td>
            <td><cfinput type="text" name="Unit_sira" id="Unit_sira"   validate="integer" message="#message1#" value="#get_detail.line_order_no#" style="width:25px;"></td>					
            <td><cfinput type="text" name="Unit_genislik" id="Unit_genislik" value="#get_detail.genislik#"  validate="integer" message="#message2#" style="width:35px;"></td>
            <td><input type="textbox" name="Unit" id="Unit" value="<cfoutput>#get_detail.title_name#</cfoutput>"></td>
           <td><cf_get_lang_main no='224.Birim'></td>
          </tr>
          <tr>
            <cfsavecontent variable="message1"><cf_get_lang no ='1932.Sıra Numarası nümerik olmalıdır'></cfsavecontent>
            <cfsavecontent variable="message2"><cf_get_lang no ='1933.Numarası nümerik olmalıdır'></cfsavecontent> 
            <td>
            	<cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'Tax'</cfquery>
            	<input type="checkbox" name="module_content" id="module_content" <cfif len(get_detail.is_selected) and get_detail.is_selected eq 1> Checked </cfif> value="Tax">
            </td>
            <td><cfinput type="text" name="Tax_sira" id="Tax_sira" value="#get_detail.line_order_no#"   validate="integer" message="#message1#" style="width:25px;"></td>					
            <td><cfinput type="text" name="Tax_genislik" id="Tax_genislik" value="#get_detail.genislik#"  validate="integer" message="#message2#" style="width:35px;"></td>
            <td><input type="textbox" name="Tax" id="Tax" value="<cfoutput>#get_detail.title_name#</cfoutput>"></td>
            <td><cf_get_lang no='395.Vergi(KDV%)'> </td>
          </tr>
          <tr>
            <cfsavecontent variable="message1"><cf_get_lang no ='1932.Sıra Numarası nümerik olmalıdır'></cfsavecontent>
            <cfsavecontent variable="message2"><cf_get_lang no ='1933.Numarası nümerik olmalıdır'></cfsavecontent> 
            <td>
            	<cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'Price'</cfquery>
            	<input type="checkbox" name="module_content" id="module_content" <cfif len(get_detail.is_selected) and get_detail.is_selected eq 1> Checked </cfif> value="Price">
            </td>
            <td><cfinput type="text" name="Price_sira" id="Price_sira" value="#get_detail.line_order_no#"  validate="integer" message="#message1#" style="width:25px;"></td>					
            <td><cfinput type="text" name="Price_genislik" id="Price_genislik" value="#get_detail.genislik#" validate="integer" message="#message2#" style="width:35px;"></td>
            <td><input type="textbox" name="Price" id="Price" value="<cfoutput>#get_detail.title_name#</cfoutput>"></td>
            <td><cf_get_lang_main no='672.Fiyat'></td>
          </tr>
          <tr>
            <cfsavecontent variable="message1"><cf_get_lang no ='1932.Sıra Numarası nümerik olmalıdır'></cfsavecontent>
            <cfsavecontent variable="message2"><cf_get_lang no ='1933.Numarası nümerik olmalıdır'></cfsavecontent> 
            <td>
            	<cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'other_money'</cfquery>
            	<input type="checkbox" name="module_content" id="module_content" <cfif len(get_detail.is_selected) and get_detail.is_selected eq 1> Checked </cfif> value="other_money">
            </td>
            <td><cfinput type="text" name="other_money_sira" id="other_money_sira"  value="#get_detail.line_order_no#"  validate="integer" message="#message1#" style="width:25px;"></td>					
            <td><cfinput type="text" name="other_money_genislik" id="other_money_genislik" value="#get_detail.genislik#" validate="integer" message="#message2#" style="width:35px;"></td>
            <td><input type="textbox" name="other_money" id="other_money" value="<cfoutput>#get_detail.title_name#</cfoutput>"></td>
            <td><cf_get_lang no='835.Satırda kullanılan diğer Para Birimi'></td>
          </tr>						
          <tr>
            <cfsavecontent variable="message1"><cf_get_lang no ='1932.Sıra Numarası nümerik olmalıdır'></cfsavecontent>
            <cfsavecontent variable="message2"><cf_get_lang no ='1933.Numarası nümerik olmalıdır'></cfsavecontent> 
            <td>
            	<cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'price_other'</cfquery>
            	<input type="checkbox" name="module_content" id="module_content" <cfif len(get_detail.is_selected) and get_detail.is_selected eq 1> Checked </cfif> value="price_other">
            </td>
            <td><cfinput type="text" name="price_other_sira" id="PRICE_OTHER_sira" value="#get_detail.line_order_no#" validate="integer" message="#message1#" style="width:25px;"></td>				  
            <td><cfinput type="text" name="price_other_genislik" value="#get_detail.genislik#" validate="integer" message="#message2#" style="width:35px;"></td>
            <td><input type="textbox" name="price_other" id="price_other" value="<cfoutput>#get_detail.title_name#</cfoutput>"></td>
            <td><cf_get_lang_main no='265.Döviz'><cf_get_lang_main no='672.Fiyat'></td>
          </tr>
          <tr>
            <cfsavecontent variable="message1"><cf_get_lang no ='1932.Sıra Numarası nümerik olmalıdır'></cfsavecontent>
            <cfsavecontent variable="message2"><cf_get_lang no ='1933.Numarası nümerik olmalıdır'></cfsavecontent> 
            <td>
            	<cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'disc_ount'</cfquery>
            	<input type="checkbox" name="module_content" id="module_content" <cfif len(get_detail.is_selected) and get_detail.is_selected eq 1>Checked</cfif>  value="disc_ount">
            </td>
            <td><cfinput type="text" name="disc_ount_sira" id="disc_ount_sira" validate="integer" message="#message1#" value="#get_detail.line_order_no#" style="width:25px;"></td>					
            <td><cfinput type="text" name="disc_ount_genislik" id="disc_ount_genislik" validate="integer" message="#message2#" value="#get_detail.genislik#" style="width:35px;"></td>
            <td><input type="textbox" name="disc_ount" id="disc_ount" value="<cfoutput>#get_detail.title_name#</cfoutput>"></td>
            <td><cf_get_lang_main no='229.İndirim'>1</td>
          </tr>
          <tr>
            <cfsavecontent variable="message1"><cf_get_lang no ='1932.Sıra Numarası nümerik olmalıdır'></cfsavecontent>
            <cfsavecontent variable="message2"><cf_get_lang no ='1933.Numarası nümerik olmalıdır'></cfsavecontent> 
            <td>
            	<cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'disc_ount2_'</cfquery>
				<input type="checkbox" name="module_content" id="module_content" <cfif len(get_detail.is_selected) and get_detail.is_selected eq 1>Checked</cfif> value="disc_ount2_">
            </td>
            <td><cfinput type="text" name="disc_ount2__sira" id="disc_ount2__sira"  validate="integer" message="#message1#" value="#get_detail.line_order_no#" style="width:25px;"></td>					
            <td><cfinput type="text" name="disc_ount2__genislik" id="disc_ount2__genislik" value="#get_detail.genislik#"  validate="integer" message="#message2#" style="width:35px;"></td>
            <td><input type="textbox" name="disc_ount2_" id="disc_ount2_" value="<cfoutput>#get_detail.title_name#</cfoutput>"></td>
            <td><cf_get_lang_main no='229.İndirim'>2</td>
          </tr>
          <tr>
            <cfsavecontent variable="message1"><cf_get_lang no ='1932.Sıra Numarası nümerik olmalıdır'></cfsavecontent>
            <cfsavecontent variable="message2"><cf_get_lang no ='1933.Numarası nümerik olmalıdır'></cfsavecontent> 
            <td>
            	<cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'disc_ount3_'</cfquery>
            	<input type="checkbox" name="module_content" id="module_content" <cfif len(get_detail.is_selected) and get_detail.is_selected eq 1>Checked</cfif> value="disc_ount3_">
            </td>
            <td><cfinput type="text" name="disc_ount3__sira" id="disc_ount3__sira"  value="#get_detail.line_order_no#"  validate="integer" message="#message1#" style="width:25px;"></td>					
            <td><cfinput type="text" name="disc_ount3__genislik" id="disc_ount3__genislik" value="#get_detail.genislik#" validate="integer" message="#message2#" style="width:35px;"></td>
            <td><input type="textbox" name="disc_ount3_" id="disc_ount3_" value="<cfoutput>#get_detail.title_name#</cfoutput>"></td>
            <td><cf_get_lang_main no='229.İndirim'>3</td>
          </tr>
          <tr>		  
            <cfsavecontent variable="message1"><cf_get_lang no ='1932.Sıra Numarası nümerik olmalıdır'></cfsavecontent>
            <cfsavecontent variable="message2"><cf_get_lang no ='1933.Numarası nümerik olmalıdır'></cfsavecontent> 
            <td>
            	<cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'disc_ount4_'</cfquery>
            	<input type="checkbox" name="module_content" id="module_content" <cfif len(get_detail.is_selected) and get_detail.is_selected eq 1>Checked</cfif> value="disc_ount4_">
            </td>
            <td><cfinput type="text" name="disc_ount4__sira" id="disc_ount4__sira" value="#get_detail.line_order_no#"  validate="integer" message="#message1#" style="width:25px;"></td>					
            <td><cfinput type="text" name="disc_ount4__genislik" id="disc_ount4__genislik" value="#get_detail.genislik#" validate="integer" message="#message2#" style="width:35px;"></td>
            <td><input type="textbox" name="disc_ount4_" id="disc_ount4_" value="<cfoutput>#get_detail.title_name#</cfoutput>"></td>
            <td><cf_get_lang_main no='229.İndirim'>4</td>
          </tr>
          <tr>
            <cfsavecontent variable="message1"><cf_get_lang no ='1932.Sıra Numarası nümerik olmalıdır'></cfsavecontent>
            <cfsavecontent variable="message2"><cf_get_lang no ='1933.Numarası nümerik olmalıdır'></cfsavecontent> 
            <td>
            	<cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'disc_ount5_'</cfquery>
            	<input type="checkbox" name="module_content" id="module_content" <cfif len(get_detail.is_selected) and get_detail.is_selected eq 1>Checked</cfif> value="disc_ount5_">
            </td>
            <td><cfinput type="text" name="disc_ount5__sira" value="#get_detail.line_order_no#" validate="integer" message="#message1#" style="width:25px;"></td>					
            <td><cfinput type="text" name="disc_ount5__genislik" value="#get_detail.genislik#" validate="integer" message="#message2#" style="width:35px;"></td>
            <td><input type="textbox" name="disc_ount5_" id="disc_ount5_" value="<cfoutput>#get_detail.title_name#</cfoutput>"></td>
            <td><cf_get_lang_main no='229.İndirim'>5</td>
          </tr>
          <tr>
            <cfsavecontent variable="message1"><cf_get_lang no ='1932.Sıra Numarası nümerik olmalıdır'></cfsavecontent>
            <cfsavecontent variable="message2"><cf_get_lang no ='1933.Numarası nümerik olmalıdır'></cfsavecontent> 
            <td>
            	<cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'disc_ount6_'</cfquery>
            	<input type="checkbox" name="module_content" id="module_content" <cfif len(get_detail.is_selected) and get_detail.is_selected eq 1>Checked</cfif> value="disc_ount6_">
            </td>
            <td><cfinput type="text" name="disc_ount6__sira" id="disc_ount6__sira" value="#get_detail.line_order_no#"  validate="integer" message="#message1#" style="width:25px;"></td>					
            <td><cfinput type="text" name="disc_ount6__genislik" id="disc_ount6__genislik" value="#get_detail.genislik#" validate="integer" message="#message2#" style="width:35px;"></td>
            <td><input type="textbox" name="disc_ount6_" id="disc_ount6_" value="<cfoutput>#get_detail.title_name#</cfoutput>"></td>
            <td><cf_get_lang_main no='229.İndirim'>6</td>
          </tr>
          <tr>
            <cfsavecontent variable="message1"><cf_get_lang no ='1932.Sıra Numarası nümerik olmalıdır'></cfsavecontent>
            <cfsavecontent variable="message2"><cf_get_lang no ='1933.Numarası nümerik olmalıdır'></cfsavecontent> 
            <td>
            	<cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'disc_ount7_'</cfquery>
            	<input type="checkbox" name="module_content" id="module_content" <cfif len(get_detail.is_selected) and get_detail.is_selected eq 1>Checked</cfif> value="disc_ount7_">
            </td>
            <td><cfinput type="text" name="disc_ount7__sira" id="disc_ount7__sira"  value="#get_detail.line_order_no#"  validate="integer" message="#message1#" style="width:25px;"></td>					
            <td><cfinput type="text" name="disc_ount7__genislik" id="disc_ount7__genislik" value="#get_detail.genislik#" validate="integer" message="#message2#" style="width:35px;"></td>
            <td><input type="textbox" name="disc_ount7_" id="disc_ount7_" value="<cfoutput>#get_detail.title_name#</cfoutput>"></td>
            <td><cf_get_lang_main no='229.İndirim'>7</td>
          </tr>	
          <tr>
            <cfsavecontent variable="message1"><cf_get_lang no ='1932.Sıra Numarası nümerik olmalıdır'></cfsavecontent>
            <cfsavecontent variable="message2"><cf_get_lang no ='1933.Numarası nümerik olmalıdır'></cfsavecontent> 
            <td>
            	<cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'disc_ount8_'</cfquery>
            	<input type="checkbox" name="module_content" id="module_content" <cfif len(get_detail.is_selected) and get_detail.is_selected eq 1>Checked</cfif> value="disc_ount8_">
            </td>
            <td><cfinput type="text" name="disc_ount8__sira" id="disc_ount8__sira" value="#get_detail.line_order_no#" validate="integer" message="#message1#" style="width:25px;"></td>					
            <td><cfinput type="text" name="disc_ount8__genislik" id="disc_ount8__genislik" value="#get_detail.genislik#" validate="integer" message="#message2#" style="width:35px;"></td>
            <td><input type="textbox" name="disc_ount8_" id="disc_ount8_" value="<cfoutput>#get_detail.title_name#</cfoutput>"></td>
            <td><cf_get_lang_main no='229.İndirim'>8</td>
          </tr>
          <tr>
            <cfsavecontent variable="message1"><cf_get_lang no ='1932.Sıra Numarası nümerik olmalıdır'></cfsavecontent>
            <cfsavecontent variable="message2"><cf_get_lang no ='1933.Numarası nümerik olmalıdır'></cfsavecontent> 
            <td>
            	<cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'disc_ount9_'</cfquery>
            	<input type="checkbox" name="module_content" id="module_content" <cfif len(get_detail.is_selected) and get_detail.is_selected eq 1>Checked</cfif> value="disc_ount9_">
            </td>
            <td><cfinput type="text" name="disc_ount9__sira" id="disc_ount9__sira" value="#get_detail.line_order_no#"  validate="integer" message="#message1#" style="width:25px;"></td>					
            <td><cfinput type="text" name="disc_ount9__genislik" id="disc_ount9__genislik" value="#get_detail.genislik#" validate="integer" message="#message2#" style="width:35px;"></td>
            <td><input type="textbox" name="disc_ount9_" id="disc_ount9_" value="<cfoutput>#get_detail.title_name#</cfoutput>"></td>
            <td><cf_get_lang_main no='229.İndirim'>9</td>
          </tr>
          <tr>
            <cfsavecontent variable="message1"><cf_get_lang no ='1932.Sıra Numarası nümerik olmalıdır'></cfsavecontent>
            <cfsavecontent variable="message2"><cf_get_lang no ='1933.Numarası nümerik olmalıdır'></cfsavecontent> 
            <td>
            	<cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'disc_ount10_'</cfquery>
            	<input type="checkbox" name="module_content" id="module_content" <cfif len(get_detail.is_selected) and get_detail.is_selected eq 1>Checked</cfif> value="disc_ount10_">
            </td>
            <td><cfinput type="text" name="disc_ount10__sira" id="disc_ount10__sira" validate="integer" message="#message1#" value="#get_detail.line_order_no#" style="width:25px;"></td>					
            <td><cfinput type="text" name="disc_ount10__genislik" id="disc_ount10__genislik" value="#get_detail.genislik#" validate="integer" message="#message2#" style="width:35px;"></td>
            <td><input type="textbox" name="disc_ount10_" id="disc_ount10_" value="<cfoutput>#get_detail.title_name#</cfoutput>"></td>
            <td><cf_get_lang_main no='229.İndirim'>10</td>
          </tr>									
          <tr>
            <cfsavecontent variable="message1"><cf_get_lang no ='1932.Sıra Numarası nümerik olmalıdır'></cfsavecontent>
            <cfsavecontent variable="message2"><cf_get_lang no ='1933.Numarası nümerik olmalıdır'></cfsavecontent> 
            <td>
            	<cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'price_net'</cfquery>
            	<input type="checkbox" name="module_content" id="module_content" <cfif len(get_detail.is_selected) and get_detail.is_selected eq 1>Checked</cfif> value="price_net" >
            </td>
            <td><cfinput type="text" name="price_net_sira" id="price_net_sira" validate="integer" message="#message1#" value="#get_detail.line_order_no#" style="width:25px;"></td>				  
            <td><cfinput type="text" name="price_net_genislik" id="price_net_genislik" value="#get_detail.genislik#" validate="integer" message="#message2#" style="width:35px;"></td>
            <td><input type="textbox" name="price_net" id="price_net" value="<cfoutput>#get_detail.title_name#</cfoutput>"></td>
            <td><cf_get_lang_main no='671.Net'> <cf_get_lang_main no='672.Fiyat'></td>
          </tr>
          <tr>
            <cfsavecontent variable="message1"><cf_get_lang no ='1932.Sıra Numarası nümerik olmalıdır'></cfsavecontent>
            <cfsavecontent variable="message2"><cf_get_lang no ='1933.Numarası nümerik olmalıdır'></cfsavecontent> 
            <td>
            	<cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'price_net_doviz'</cfquery>
            	<input type="checkbox" name="module_content" id="module_content" <cfif len(get_detail.is_selected) and get_detail.is_selected eq 1>Checked</cfif> value="price_net_doviz" >
            </td>
            <td><cfinput type="text" name="price_net_doviz_sira" id="price_net_doviz_sira" value="#get_detail.line_order_no#" validate="integer" message="#message1#" style="width:25px;"></td>
            <td><cfinput type="text" name="price_net_doviz_genislik" id="price_net_doviz_genislik" value="#get_detail.genislik#" validate="integer" message="#message2#" style="width:35px;"></td>
            <td><input type="textbox" name="price_net_doviz" id="price_net_doviz" value="<cfoutput>#get_detail.title_name#</cfoutput>"></td>
            <td><cf_get_lang no='744.Net Döviz'> <cf_get_lang no='824.Fiyat(Döviz Fiyata Bağlı)'></td>
          </tr>		
          <tr>
            <cfsavecontent variable="message1"><cf_get_lang no ='1932.Sıra Numarası nümerik olmalıdır'></cfsavecontent>
            <cfsavecontent variable="message2"><cf_get_lang no ='1933.Numarası nümerik olmalıdır'></cfsavecontent> 
            <td>
            	<cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'Duedate'</cfquery>
            	<input type="checkbox" name="module_content" id="module_content" <cfif len(get_detail.is_selected) and get_detail.is_selected eq 1>Checked</cfif> value="Duedate">
            </td>
            <td><cfinput type="text" name="Duedate_sira" id="Duedate_sira" value="#get_detail.line_order_no#" validate="integer" message="#message1#" style="width:25px;"></td>					
            <td><cfinput type="text" name="Duedate_genislik" id="Duedate_genislik" value="#get_detail.genislik#"  validate="integer" message="#message2#" style="width:35px;"></td>
            <td><input type="textbox" name="Duedate" id="Duedate" value="<cfoutput>#get_detail.title_name#</cfoutput>"></td>
            <td><cf_get_lang_main no='228.Vade'></td>
          </tr>
          <tr>
            <cfsavecontent variable="message1"><cf_get_lang no ='1932.Sıra Numarası nümerik olmalıdır'></cfsavecontent>
            <cfsavecontent variable="message2"><cf_get_lang no ='1933.Numarası nümerik olmalıdır'></cfsavecontent> 
            <td>
            	<cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'net_maliyet'</cfquery>
            	<input type="checkbox" name="module_content" id="module_content" <cfif len(get_detail.is_selected) and get_detail.is_selected eq 1>Checked</cfif> value="net_maliyet">
            </td>
            <td><cfinput type="text" name="net_maliyet_sira" id="net_maliyet_sira" value="#get_detail.line_order_no#" validate="integer" message="#message1#" style="width:25px;"></td>					
            <td><cfinput type="text" name="net_maliyet_genislik" id="net_maliyet_genislik" value="#get_detail.genislik#" validate="integer" message="#message2#" style="width:35px;"></td>
            <td><input type="textbox" name="net_maliyet" id="net_maliyet" value="<cfoutput>#get_detail.title_name#</cfoutput>"></td>
            <td><cf_get_lang no='680.Net Maliyet'></td>
          </tr>				
          <tr>
            <cfsavecontent variable="message1"><cf_get_lang no ='1932.Sıra Numarası nümerik olmalıdır'></cfsavecontent>
            <cfsavecontent variable="message2"><cf_get_lang no ='1933.Numarası nümerik olmalıdır'></cfsavecontent> 
            <td>
            	<cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'extra_cost'</cfquery>
            	<input type="checkbox" name="module_content" id="module_content" <cfif len(get_detail.is_selected) and get_detail.is_selected eq 1>Checked</cfif>  value="extra_cost">
            </td>
            <td><cfinput type="text" name="extra_cost_sira" id="extra_cost_sira" value="#get_detail.line_order_no#" validate="integer" message="#message1#" style="width:25px;"></td>
            <td><cfinput type="text" name="extra_cost_genislik" id="extra_cost_genislik" value="#get_detail.genislik#" validate="integer" message="#message2#" style="width:35px;"></td>					
            <td><input type="textbox" name="extra_cost" id="extra_cost" value="<cfoutput>#get_detail.title_name#</cfoutput>"></td>
            <td><cf_get_lang no='993.Ek Maliyet'></td>
          </tr>
          <tr>
            <cfsavecontent variable="message1"><cf_get_lang no ='1932.Sıra Numarası nümerik olmalıdır'></cfsavecontent>
            <cfsavecontent variable="message2"><cf_get_lang no ='1933.Numarası nümerik olmalıdır'></cfsavecontent> 
            <td>
            	<cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'marj'</cfquery>
            	<input type="checkbox" name="module_content" id="module_content" <cfif len(get_detail.is_selected) and get_detail.is_selected eq 1>Checked</cfif> value="marj">
            </td>
            <td><cfinput type="text" name="marj_sira" id="marj_sira" validate="integer" value="#get_detail.line_order_no#" message="#message1#" style="width:25px;"></td>
            <td><cfinput type="text" name="marj_genislik" id="marj_genislik" value="#get_detail.genislik#" validate="integer" message="#message2#" style="width:35px;"></td>					
            <td><input type="textbox" name="marj" id="marj" value="<cfoutput>#get_detail.title_name#</cfoutput>"></td>
            <td><cf_get_lang no='544.Marj'></td>
          </tr>				
          <tr>
            <cfsavecontent variable="message1"><cf_get_lang no ='1932.Sıra Numarası nümerik olmalıdır'></cfsavecontent>
            <cfsavecontent variable="message2"><cf_get_lang no ='1933.Numarası nümerik olmalıdır'></cfsavecontent> 
            <td>
            	<cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'row_total'</cfquery>
            	<input type="checkbox" name="module_content" id="module_content" <cfif len(get_detail.is_selected) and get_detail.is_selected eq 1>Checked</cfif> value="row_total">			       		</td>
            <td><cfinput type="text" name="row_total_sira" id="row_total_sira" value="#get_detail.line_order_no#" validate="integer" message="#message1#" style="width:25px;"></td>					
            <td><cfinput type="text" name="row_total_genislik" id="row_total_genislik" value="#get_detail.genislik#" validate="integer" message="#message2#" style="width:35px;"></td>
            <td><input type="textbox" name="row_total" id="row_total" value="<cfoutput>#get_detail.title_name#</cfoutput>"></td>
            <td><cf_get_lang no='825.Satır Toplam(Fiyata Bağlı)'></td>
          </tr>
          <tr>
            <cfsavecontent variable="message1"><cf_get_lang no ='1932.Sıra Numarası nümerik olmalıdır'></cfsavecontent>
            <cfsavecontent variable="message2"><cf_get_lang no ='1933.Numarası nümerik olmalıdır'></cfsavecontent> 
            <td>
            	<cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'row_nettotal'</cfquery>
            	<input type="checkbox" name="module_content" id="module_content" <cfif len(get_detail.is_selected) and get_detail.is_selected eq 1>Checked</cfif> value="row_nettotal">
            </td>
            <td><cfinput type="text" name="row_nettotal_sira" id="row_nettotal_sira" value="#get_detail.line_order_no#" validate="integer" message="#message1#" style="width:25px;"></td>					
            <td><cfinput type="text" name="row_nettotal_genislik" id="row_nettotal_genislik" value="#get_detail.genislik#" validate="integer" message="#message2#" style="width:35px;"></td>
            <td><input type="textbox" name="row_nettotal" id="row_nettotal" value="<cfoutput>#get_detail.title_name#</cfoutput>"></td>
            <td><cf_get_lang no='826.Net Satır Toplam(Fiyata Bağlı)'></td>
          </tr>
          <tr>
            <cfsavecontent variable="message1"><cf_get_lang no ='1932.Sıra Numarası nümerik olmalıdır'></cfsavecontent>
            <cfsavecontent variable="message2"><cf_get_lang no ='1933.Numarası nümerik olmalıdır'></cfsavecontent> 
            <td>
            	<cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'row_taxtotal'</cfquery>
            	<input type="checkbox" name="module_content" id="module_content" <cfif len(get_detail.is_selected) and get_detail.is_selected eq 1>Checked</cfif>  value="row_taxtotal">
            </td>
            <td><cfinput type="text" name="row_taxtotal_sira" id="row_taxtotal_sira" value="#get_detail.line_order_no#" validate="integer" message="#message1#" style="width:25px;"></td>					
            <td><cfinput type="text" name="row_taxtotal_genislik" id="row_taxtotal_genislik" value="#get_detail.genislik#" validate="integer" message="#message2#" style="width:35px;"></td>
            <td><input type="textbox" name="row_taxtotal" id="row_taxtotal" value="<cfoutput>#get_detail.title_name#</cfoutput>"></td>
            <td><cf_get_lang no='827.Vergi Toplam(Fiyat ve KDVye Bağlı)'></td>
          </tr>
          <tr>
            <cfsavecontent variable="message1"><cf_get_lang no ='1932.Sıra Numarası nümerik olmalıdır'></cfsavecontent>
            <cfsavecontent variable="message2"><cf_get_lang no ='1933.Numarası nümerik olmalıdır'></cfsavecontent> 
            <td>
            	<cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'row_lasttotal'</cfquery>
            	<input type="checkbox" name="module_content" id="module_content" <cfif len(get_detail.is_selected) and get_detail.is_selected eq 1>Checked</cfif> value="row_lasttotal">
            </td>
            <td><cfinput type="text" name="row_lasttotal_sira" id="row_lasttotal_sira" value="#get_detail.line_order_no#" validate="integer" message="#message1#" style="width:25px;"></td>					
            <td><cfinput type="text" name="row_lasttotal_genislik" id="row_lasttotal_genislik" value="#get_detail.genislik#" validate="integer" message="#message2#" style="width:35px;"></td>
            <td><input type="textbox" name="row_lasttotal" id="row_lasttotal" value="<cfoutput>#get_detail.title_name#</cfoutput>"></td>
            <td><cf_get_lang no='599.KDV,Fiyat ve Net Toplama Bağlı'></td>
          </tr>
          <tr>
            <cfsavecontent variable="message1"><cf_get_lang no ='1932.Sıra Numarası nümerik olmalıdır'></cfsavecontent>
            <cfsavecontent variable="message2"><cf_get_lang no ='1933.Numarası nümerik olmalıdır'></cfsavecontent> 
            <td>
            	<cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'other_money_value'</cfquery>
            	<input type="checkbox" name="module_content" id="module_content" <cfif len(get_detail.is_selected) and get_detail.is_selected eq 1>Checked</cfif> value="other_money_value">
            </td>
            <td><cfinput type="text" name="other_money_value_sira" id="other_money_value_sira" value="#get_detail.line_order_no#" style="width:25px;" validate="integer" message="#message1#"></td>
            <td><cfinput type="text" name="other_money_value_genislik" id="other_money_value_genislik" value="#get_detail.genislik#" style="width:35px;" validate="integer" message="#message2#"></td>
            <td><input type="textbox" name="other_money_value" id="other_money_value" value="<cfoutput>#get_detail.title_name#</cfoutput>"></td>
            <td><cf_get_lang no='836.Satır Döviz Tutarı Satırın Döviz cinsinde değeri'></td>
          </tr>
          <tr>
            <cfsavecontent variable="message1"><cf_get_lang no ='1932.Sıra Numarası nümerik olmalıdır'></cfsavecontent>
            <cfsavecontent variable="message2"><cf_get_lang no ='1933.Numarası nümerik olmalıdır'></cfsavecontent> 
            <td>
            	<cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'other_money_gross_total'</cfquery>
            	<input type="checkbox" name="module_content" id="module_content" <cfif len(get_detail.is_selected) and get_detail.is_selected eq 1>Checked</cfif>  value="other_money_gross_total">
            </td>
            <td><cfinput type="text" name="other_money_gross_total_sira" value="#get_detail.line_order_no#" style="width:25px;" validate="integer" message="#message1#"></td>
            <td><cfinput type="text" name="other_money_gross_total_genislik" value="#get_detail.genislik#" style="width:35px;" validate="integer" message="#message2#"></td>										
            <td><input type="textbox" name="other_money_gross_total" id="other_money_gross_total" value="<cfoutput>#get_detail.title_name#</cfoutput>"></td>
            <td><cf_get_lang no='829.Satır Vergi Toplamı(Döviz Fiyata Bağlı)'></td>
          </tr>		
          <tr>
            <cfsavecontent variable="message1"><cf_get_lang no ='1932.Sıra Numarası nümerik olmalıdır'></cfsavecontent>
            <cfsavecontent variable="message2"><cf_get_lang no ='1933.Numarası nümerik olmalıdır'></cfsavecontent> 
            <td>
            	<cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'deliver_date'</cfquery>
            	<input type="checkbox" name="module_content" id="module_content" <cfif len(get_detail.is_selected) and get_detail.is_selected eq 1>Checked</cfif> value="deliver_date">
            </td>
            <td><cfinput type="text" name="deliver_date_sira" id="deliver_date_sira" validate="integer" style="width:25px;" message="#message1#" value="#get_detail.line_order_no#"></td>					
            <td><cfinput type="text" name="deliver_date_genislik" id="deliver_date_genislik" value="#get_detail.genislik#" style="width:35px;" validate="integer" message="#message2#"></td>
            <td><input type="textbox" name="deliver_date" id="deliver_date" value="<cfoutput>#get_detail.title_name#</cfoutput>"></td>
            <td><cf_get_lang no='833.Teslim Tarihi İrsaliye ve Faturada kullanılmaz'> </td>
          </tr>
          <tr>
            <cfsavecontent variable="message1"><cf_get_lang no ='1932.Sıra Numarası nümerik olmalıdır'></cfsavecontent>
            <cfsavecontent variable="message2"><cf_get_lang no ='1933.Numarası nümerik olmalıdır'></cfsavecontent> 
            <td>
            	<cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'deliver_dept'</cfquery>
            	<input type="checkbox" name="module_content" id="module_content" <cfif len(get_detail.is_selected) and get_detail.is_selected eq 1>Checked</cfif> value="deliver_dept">
            </td>
            <td><cfinput type="text" name="deliver_dept_sira" id="deliver_dept_sira" validate="integer" style="width:25px;" message="#message1#" value="#get_detail.line_order_no#"></td>					
            <td><cfinput type="text" name="deliver_dept_genislik" id="deliver_dept_genislik" style="width:35px;" value="#get_detail.genislik#"  validate="integer" message="#message2#"></td>
            <td><input type="textbox" name="deliver_dept" id="deliver_dept" value="<cfoutput>#get_detail.title_name#</cfoutput>"></td>
            <td><cf_get_lang no="834.Teslim depo İrsaliye ve Faturada kullanılmaz"></td>
          </tr>
          <tr>
            <cfsavecontent variable="message1"><cf_get_lang no ='1932.Sıra Numarası nümerik olmalıdır'></cfsavecontent>
            <cfsavecontent variable="message2"><cf_get_lang no ='1933.Numarası nümerik olmalıdır'></cfsavecontent> 
            <td>
            	<cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'deliver_dept_assortment'</cfquery>
            	<input type="checkbox" name="module_content" id="module_content" <cfif len(get_detail.is_selected) and get_detail.is_selected eq 1>Checked</cfif>  value="deliver_dept_assortment">
            </td>
            <td>
            <cfinput type="text" name="deliver_dept_assortment_sira" id="deliver_dept_assortment_sira" style="width:25px;" value="#get_detail.line_order_no#" validate="integer" message="#message1#">
            </td>
            <td>
            <cfinput type="text" name="deliver_dept_assortment_genislik" id="deliver_dept_assortment_genislik" style="width:35px;" value="#get_detail.genislik#" validate="integer" message="#message2#">		 			</td>
            <td><input type="textbox" name="deliver_dept_assortment" id="deliver_dept_assortment" value="<cfoutput>#get_detail.title_name#</cfoutput>"></td>
            <td><cf_get_lang no='530.Teslim Depo Dağılım'></td>
          </tr>				
          <tr>
            <cfsavecontent variable="message1"><cf_get_lang no ='1932.Sıra Numarası nümerik olmalıdır'></cfsavecontent>
            <cfsavecontent variable="message2"><cf_get_lang no ='1933.Numarası nümerik olmalıdır'></cfsavecontent> 
            <td>
            	<cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'spec'</cfquery>
            	<input type="checkbox" name="module_content" id="module_content" <cfif len(get_detail.is_selected) and get_detail.is_selected eq 1>Checked</cfif> value="spec">
            </td>
            <td><cfinput type="text" name="spec_sira" id="spec_sira" validate="integer" style="width:25px;" message="#message1#" value="#get_detail.line_order_no#"></td>					
            <td><cfinput type="text" name="spec_genislik" id="spec_genislik" value="#get_detail.genislik#" style="width:35px;" validate="integer" message="#message2#"></td>
            <td><input type="textbox" name="spec" id="spec" value="<cfoutput>#get_detail.title_name#</cfoutput>"></td>
            <td><cf_get_lang_main no='235.Spec'></td>
          </tr>
          <tr>
            <cfsavecontent variable="message1"><cf_get_lang no ='1932.Sıra Numarası nümerik olmalıdır'></cfsavecontent>
            <cfsavecontent variable="message2"><cf_get_lang no ='1933.Numarası nümerik olmalıdır'></cfsavecontent> 
            <td>
            	<cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'lot_no'</cfquery>
            	<input type="checkbox" name="module_content" id="module_content" <cfif len(get_detail.is_selected) and get_detail.is_selected eq 1>Checked</cfif> value="lot_no">
            </td>
            <td><cfinput type="text" name="lot_no_sira" id="lot_no_sira" validate="integer" message="#message1#" style="width:25px;" value="#get_detail.line_order_no#"></td>					
            <td><cfinput type="text" name="lot_no_genislik" id="lot_no_genislik" value="#get_detail.genislik#" style="width:35px;" validate="integer" message="#message2#"></td>
            <td><input type="textbox" name="lot_no" id="lot_no" value="<cfoutput>#get_detail.title_name#</cfoutput>"></td>
            <td><cf_get_lang no='46.Lot No'></td>
          </tr>
          <tr>
            <cfsavecontent variable="message1"><cf_get_lang no ='1932.Sıra Numarası nümerik olmalıdır'></cfsavecontent>
            <cfsavecontent variable="message2"><cf_get_lang no ='1933.Numarası nümerik olmalıdır'></cfsavecontent> 
            <td>
            	<cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'price_total'</cfquery>
            	<input type="checkbox" name="module_content" <cfif len(get_detail.is_selected) and get_detail.is_selected eq 1>Checked</cfif> id="module_content" value="price_total">
            </td>
            <td><cfinput type="text" name="price_total_sira" id="price_total_sira" validate="integer" style="width:25px;" message="#message1#" value="#get_detail.line_order_no#"></td>					
            <td><cfinput type="text" name="price_total_genislik" id="price_total_genislik"  style="width:35px;" value="#get_detail.genislik#" validate="integer" message="#message2#"></td>
            <td><input type="textbox" name="price_total" id="price_total" value="<cfoutput>#get_detail.title_name#</cfoutput>"></td>
            <td><cf_get_lang no='831.Basket Toplam Belgenin bütün toplamı'>(<cf_get_lang no='620.KDV ve Fiyata Bağlı'>)</td>
          </tr>
          <tr>
            <cfsavecontent variable="message1"><cf_get_lang no ='1932.Sıra Numarası nümerik olmalıdır'></cfsavecontent>
            <cfsavecontent variable="message2"><cf_get_lang no ='1933.Numarası nümerik olmalıdır'></cfsavecontent> 
            <td>
            	<cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'darali'</cfquery>
            	<input type="checkbox" name="module_content" id="module_content" <cfif len(get_detail.is_selected) and get_detail.is_selected eq 1>Checked</cfif> value="darali">
            </td>
            <td><cfinput type="text" name="darali_sira" id="darali_sira" value="#get_detail.line_order_no#" style="width:25px;" validate="integer" message="#message1#"></td>
            <td><cfinput type="text" name="darali_genislik" id="darali_genislik" value="#get_detail.genislik#" style="width:35px;" validate="integer" message="#message2#"></td>
            <td><input type="textbox" name="darali" id="darali" value="<cfoutput>#get_detail.title_name#</cfoutput>"></td>
            <td><cf_get_lang no='638.Daralı'></td>
          </tr>
          <tr>
            <cfsavecontent variable="message1"><cf_get_lang no ='1932.Sıra Numarası nümerik olmalıdır'></cfsavecontent>
            <cfsavecontent variable="message2"><cf_get_lang no ='1933.Numarası nümerik olmalıdır'></cfsavecontent> 
            <td>
            	<cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'dara'</cfquery>
            	<input type="checkbox" name="module_content" id="module_content" <cfif len(get_detail.is_selected) and get_detail.is_selected eq 1>Checked</cfif> value="dara">
            </td>
            <td><cfinput type="text" name="dara_sira" id="dara_sira" value="#get_detail.line_order_no#" style="width:25px;" validate="integer" message="#message1#"></td>
            <td><cfinput type="text" name="dara_genislik" id="dara_genislik"  value="#get_detail.genislik#" style="width:35px;" validate="integer" message="#message2#"></td>
            <td><input type="textbox" name="dara" id="dara" value="<cfoutput>#get_detail.title_name#</cfoutput>"></td>
            <td><cf_get_lang no='654.Dara'></td>
          </tr>
           <tr>
            <cfsavecontent variable="message1"><cf_get_lang no ='1932.Sıra Numarası nümerik olmalıdır'></cfsavecontent>
            <cfsavecontent variable="message2"><cf_get_lang no ='1933.Numarası nümerik olmalıdır'></cfsavecontent> 
            <td>
            	<cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'shelf_number'</cfquery>
            	<input type="checkbox" name="module_content" id="module_content" <cfif len(get_detail.is_selected) and get_detail.is_selected eq 1>Checked</cfif> value="shelf_number">
            </td>
            <td><cfinput type="text" name="shelf_number_sira" id="shelf_number_sira" style="width:25px;" value="#get_detail.line_order_no#" validate="integer" message="#message1#"></td>
            <td><cfinput type="text" name="shelf_number_genislik" id="shelf_number_genislik" style="width:35px;"  value="#get_detail.genislik#" validate="integer" message="#message2#"></td>
            <td><input type="textbox" name="shelf_number" id="shelf_number" value="<cfoutput>#get_detail.title_name#</cfoutput>"></td>
            <td><cf_get_lang no='1059.Raf No'></td>
          </tr>
           <tr>
            <cfsavecontent variable="message1"><cf_get_lang no ='1932.Sıra Numarası nümerik olmalıdır'></cfsavecontent>
            <cfsavecontent variable="message2"><cf_get_lang no ='1933.Numarası nümerik olmalıdır'></cfsavecontent> 
            <td>
            	<cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'order_currency'</cfquery>
            	<input type="checkbox" name="module_content" id="module_content" <cfif len(get_detail.is_selected) and get_detail.is_selected eq 1>Checked</cfif> value="order_currency">
            </td>
            <td><cfinput type="text" name="order_currency_sira" id="order_currency_sira" style="width:25px;" value="#get_detail.line_order_no#" validate="integer" message="#message1#"></td>
            <td><cfinput type="text" name="order_currency_genislik" id="order_currency_genislik" style="width:35px;"  value="#get_detail.genislik#" validate="integer" message="#message2#"></td>
            <td><input type="textbox" name="order_currency" id="order_currency" value="<cfoutput>#get_detail.title_name#</cfoutput>"></td>
            <td><cf_get_lang no='1041.Sipariş Aşama'></td>
          </tr>
           <tr>
            <cfsavecontent variable="message1"><cf_get_lang no ='1932.Sıra Numarası nümerik olmalıdır'></cfsavecontent>
            <cfsavecontent variable="message2"><cf_get_lang no ='1933.Numarası nümerik olmalıdır'></cfsavecontent> 
            <td>
            	<cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'reserve_type'</cfquery>
            	<input type="checkbox" name="module_content" id="module_content" <cfif len(get_detail.is_selected) and get_detail.is_selected eq 1>Checked</cfif> value="reserve_type">
            </td>
            <td><cfinput type="text" name="reserve_type_sira" id="reserve_type_sira" value="#get_detail.line_order_no#" style="width:25px;" validate="integer" message="#message1#"></td>
            <td><cfinput type="text" name="reserve_type_genislik" id="reserve_type_genislik"  value="#get_detail.genislik#" style="width:35px;" validate="integer" message="#message2#"></td>
            <td><input type="textbox" name="reserve_type" id="reserve_type" value="<cfoutput>#get_detail.title_name#</cfoutput>"></td>
            <td><cf_get_lang no ='1599.Rezerve Tipi'></td>
          </tr>
           <tr>
            <cfsavecontent variable="message1"><cf_get_lang no ='1932.Sıra Numarası nümerik olmalıdır'></cfsavecontent>
            <cfsavecontent variable="message2"><cf_get_lang no ='1933.Numarası nümerik olmalıdır'></cfsavecontent> 
            <td>
            	<cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'reserve_date'</cfquery>
            	<input type="checkbox" name="module_content" id="module_content" <cfif len(get_detail.is_selected) and get_detail.is_selected eq 1>Checked</cfif> value="reserve_date">
            </td>
            <td><cfinput type="text" name="reserve_date_sira" value="#get_detail.line_order_no#" style="width:25px;" validate="integer" message="#message1#"></td>
            <td><cfinput type="text" name="reserve_date_genislik"  value="#get_detail.genislik#" style="width:35px;" validate="integer" message="#message2#"></td>
            <td><input type="textbox" name="reserve_date" id="reserve_date" value="<cfoutput>#get_detail.title_name#</cfoutput>"></td>
            <td><cf_get_lang no ='1598.Rezerve Tarihi'></td>
          </tr>					
          <tr>
            <cfsavecontent variable="message1"><cf_get_lang no ='1932.Sıra Numarası nümerik olmalıdır'></cfsavecontent>
            <cfsavecontent variable="message2"><cf_get_lang no ='1933.Numarası nümerik olmalıdır'></cfsavecontent> 
            <td>
            	<cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'is_parse'</cfquery>
            	<input type="checkbox" name="module_content" id="module_content" <cfif len(get_detail.is_selected) and get_detail.is_selected eq 1>Checked</cfif>  value="is_parse">			 			</td>
            <td><cfinput type="text" name="is_parse_sira" id="is_parse_sira" validate="integer" style="width:25px;" message="#message1#" value="#get_detail.line_order_no#"></td>				
            <td><cfinput type="text" name="is_parse_genislik" id="is_parse_genislik" value="#get_detail.genislik#"  style="width:35px;" validate="integer" message="#message2#"></td>					
            <td><input type="hidden" name="is_parse" id="is_parse" value="<cfoutput>#get_detail.title_name#</cfoutput>"></td>
            <td><cf_get_lang no='280.Dağılım'></td>
          </tr>
          <tr>
            <cfsavecontent variable="message1"><cf_get_lang no ='1932.Sıra Numarası nümerik olmalıdır'></cfsavecontent>
            <cfsavecontent variable="message2"><cf_get_lang no ='1933.Numarası nümerik olmalıdır'></cfsavecontent> 
            <td>
            	<cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'Kdv'</cfquery>
            	<input type="checkbox" name="module_content" id="module_content" <cfif len(get_detail.is_selected) and get_detail.is_selected eq 1>Checked</cfif> value="Kdv">
            </td>
            <td><cfinput type="text" name="Kdv_sira" validate="integer" message="#message1#" style="width:25px;" value="#get_detail.line_order_no#"></td>
            <td><cfinput type="text" name="Kdv_genislik" validate="integer" message="#message2#" style="width:35px;" value="#get_detail.genislik#"></td>					
            <td><input type="hidden" name="Kdv" id="Kdv"  value="<cfoutput>#get_detail.title_name#</cfoutput>"></td>
            <td><cf_get_lang no='667.KDV Toplam KDV ye Bağl Satır Vergi Toplamına Bağlı'></td>
          </tr>
          <tr>
          <td>
          	<cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'is_promotion'</cfquery>
          	<input type="checkbox" name="module_content" id="module_content" <cfif len(get_detail.is_selected) and get_detail.is_selected eq 1>Checked</cfif> value="is_promotion">
          </td>
            <td colspan="3"><input type="hidden" name="is_promotion" id="is_promotion" value="Ödeme Yöntemi"><cf_get_lang_main no='171.Promosyonlu'></td>
          </tr>
		  <tr>
            <td>
            	<cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'zero_stock_status'</cfquery>
            	<input type="checkbox" name="module_content" id="module_content" <cfif len(get_detail.is_selected) and get_detail.is_selected eq 1>Checked</cfif> value="zero_stock_status">
            </td>
            <td colspan="3"><cf_get_lang no='749.Sıfır Stok ile Çalış'></td>
          </tr>	
        </table>
       <cf_form_box_footer>
       		<cf_record_info query_name="GET_BASKET"><cf_workcube_buttons is_upd='0'>
       </cf_form_box_footer>
      </cfform>
 </cf_area>   
</cf_form_box>
