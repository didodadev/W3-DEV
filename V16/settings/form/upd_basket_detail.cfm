<cf_xml_page_edit fuseact="settings.form_add_bskt_detail">
<cfset attributes.B_TYPE = 1 >
<script type="text/javascript">
function sec()
{
	for (i=0; i < add_basket_details.module_content.length; i=i+1)
		add_basket_details.module_content[i].checked = true;
}
</script>
<cfsavecontent variable="right">
    <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=settings.popup_setup_basket_history&id=#attributes.id#</cfoutput>','medium','popup_member_history');"><img src="/images/history.gif" alt="<cf_get_lang_main no='61.Tarihçe'>" title="<cf_get_lang_main no='61.Tarihçe'>" align="absmiddle" border="0"></a>
    <a href="<cfoutput>#request.self#</cfoutput>?fuseaction=settings.form_add_bskt_detail"><img src="/images/plus1.gif" align="absmiddle" border="0" title="<cf_get_lang_main no='170.Ekle'>"></a>
	<a href="<cfoutput>#request.self#</cfoutput>?fuseaction=settings.form_add_bskt_detail&basket_id=<cfoutput>#attributes.id#</cfoutput>"><img src="/images/plus.gif" align="absmiddle" border="0" title="<cf_get_lang_main no='64.Kopyala'>"></a>	
</cfsavecontent>
<cf_form_box title="#getLang('settings',392)#" right_images="#right#">
	<cf_area width="100">
   	   <cfinclude template="../display/list_basket_modules.cfm">
    </cf_area>
    <cfset attributes.basket_id = attributes.ID>
		<cfset attributes.bskt_list = 2>
		<cfinclude template="../query/get_basket_details.cfm">
		<cfif not GET_BASKET.recordcount>
		<script type="text/javascript">
			alert("Böyle Bir Basket Sablonu Bulunamadı!");
			window.location.href='<cfoutput>#request.self#?fuseaction=settings.form_add_bskt_detail</cfoutput>';
		</script>
		<cfabort>
		</cfif>
		<cfquery name="GET_MODULE_DSP" datasource="#DSN3#">
			SELECT * FROM SETUP_BASKET_ROWS WHERE BASKET_ID = #GET_BASKET.BASKET_ID# AND B_TYPE=1
		</cfquery>
   <cfform name="add_basket_details" method="post" action="#request.self#?fuseaction=settings.upd_bskt_detail_act&id=#attributes.id#">
   <input type="hidden" name="B_TYPE" id="B_TYPE" value="1">
   <input type="hidden" name="BASKET_ID" id="BASKET_ID" value="<cfoutput>#get_basket.basket_id#</cfoutput>">
   <cf_area>
    	 <table width="100%">
                <tr>
					<td>
						<b><cf_get_lang_main no='1160.Kullanım'></b> 
						<select name="MODULE_ID_" id="MODULE_ID_" style="width=200px;" disabled>
							<option<cfif get_basket.basket_id eq 1> selected</cfif> value="1"><cf_get_lang no='84.Satınalma Faturası'></option>
							<option<cfif get_basket.basket_id eq 2> selected</cfif> value="2"><cf_get_lang no='85.Satış Faturası'></option>
							<option<cfif get_basket.basket_id eq 3> selected</cfif> value="3"> <cf_get_lang no='86.Satış Teklifi'> </option>
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
							<option<cfif get_basket.basket_id eq 24> selected</cfif> value="24"><cf_get_lang no='443.Partner Portal Teklifler'> (<cf_get_lang_main no='36.Satış'>)</option>
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
							<option<cfif get_basket.basket_id eq 45> selected</cfif> value="45"><cf_get_lang no='498.Sevk İç Talep'></option>
							<option<cfif get_basket.basket_id eq 46> selected</cfif> value="46"><cf_get_lang_main no='1420.Abone'></option>
							<option<cfif get_basket.basket_id eq 47> selected</cfif> value="47"><cf_get_lang no='1055.Servis Giriş'></option>
							<option<cfif get_basket.basket_id eq 48> selected</cfif> value="48"><cf_get_lang no='1056.Servis Çıkış'></option>
							<option<cfif get_basket.basket_id eq 49> selected</cfif> value="49"><cf_get_lang_main no='1791.İthal Mal Girişi'></option>
							<option<cfif get_basket.basket_id eq 50> selected</cfif> value="50"><cf_get_lang no='1465.Proje Malzeme Planı'></option>
							<option<cfif get_basket.basket_id eq 51> selected</cfif> value="51"><cf_get_lang no='1588.Taksitli Satış'></option>
							<option<cfif get_basket.basket_id eq 52> selected</cfif> value="52"><cf_get_lang_main no='1026.Z Raporu'></option>
						</select>
					</td>
				</tr>
         </table>
         <table width="100%">
            <tr class="color-list">
                <td class="txtbold"> <input type="checkbox" onClick="sec();" value="<cf_get_lang no='705.Hepsini Seç'>">Hepsini Seç</td>
            </tr>
         </table>
         <table>
            <tr class="txtbold">
                <td><cf_get_lang_main no='1281.Seç'></td>
                <td><cf_get_lang_main no='1165.Sıra'></td>
                <td><cf_get_lang no='670.En'></td>
                <td><cf_get_lang no='818.Basket Adı'></td>
                <cfif x_show_language><td width="30">&nbsp;</td></cfif>
                <td><cf_get_lang no='819.Sistem Adı'></td>
            </tr>
            <cfif not listfind('14,15',get_basket.basket_id)>
                <tr>
                    <cfif x_show_language>
                        <cfquery name="get_detail" datasource="#dsn3#">
                            SELECT #dsn_alias#.Get_Dynamic_Language(BASKET_ROW_ID,'#session.ep.language#','SETUP_BASKET_ROWS','TITLE_NAME',NULL,NULL,TITLE_NAME) AS TITLE_NAME,LINE_ORDER_NO,IS_SELECTED,GENISLIK,IS_READONLY,B_TYPE,BASKET_ROW_ID FROM (SELECT * FROM SETUP_BASKET_ROWS WHERE BASKET_ID = #GET_BASKET.BASKET_ID# AND B_TYPE=1) AS XXX WHERE TITLE = 'basket_cursor'
                        </cfquery>
                    <cfelse>
                        <cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'basket_cursor'</cfquery>
                    </cfif>
                    <td><input type="checkbox" name="module_content" id="module_content" value="basket_cursor" <cfif len(get_detail.is_selected) and get_detail.is_selected eq 1> Checked </cfif>></td>
                    <td>&nbsp;</td>
                    <td>&nbsp;</td>
                    <td><input type="textbox" name="BASKET_CURSOR" id="BASKET_CURSOR" value="<cfoutput>#get_detail.title_name#</cfoutput>" maxlength="200"></td>
                    <cfif x_show_language>
                        <td>
                            <cf_language_info 
                                table_name="SETUP_BASKET_ROWS" 
                                column_name="TITLE_NAME" 
                                column_id_value="#get_detail.BASKET_ROW_ID#" 
                                maxlength="500" 
                                datasource="#dsn3#" 
                                column_id="BASKET_ROW_ID" 
                                control_type="0">
                        </td>
                    </cfif>
                    <td><cf_get_lang no='393.Barkod Cihazı'></td>
                </tr>
            </cfif>
            <tr>
                <td>
                	<cfif x_show_language>
                        <cfquery name="get_detail" datasource="#dsn3#">
                            SELECT #dsn_alias#.Get_Dynamic_Language(BASKET_ROW_ID,'#session.ep.language#','SETUP_BASKET_ROWS','TITLE_NAME',NULL,NULL,TITLE_NAME) AS TITLE_NAME,LINE_ORDER_NO,IS_SELECTED,GENISLIK,IS_READONLY,B_TYPE,BASKET_ROW_ID FROM (SELECT * FROM SETUP_BASKET_ROWS WHERE BASKET_ID = #GET_BASKET.BASKET_ID# AND B_TYPE=1) AS XXX WHERE TITLE = 'stock_code'
                        </cfquery>
                    <cfelse>
	                    <cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'stock_code'</cfquery>
                    </cfif>
                    <input type="checkbox" name="module_content" id="module_content" value="stock_code" <cfif len(get_detail.is_selected) and get_detail.is_selected eq 1> Checked </cfif>>
                </td>
                <td><cfinput type="text" name="stock_code_sira" value="#get_detail.line_order_no#" style="width:25px" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>
                <td><cfinput type="text" name="stock_code_genislik" value="#get_detail.genislik#" style="width:35px" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>
                <td><input type="textbox" name="STOCK_CODE" id="STOCK_CODE" value="<cfoutput>#get_detail.title_name#</cfoutput>" maxlength="200"></td>
				<cfif x_show_language>
                    <td>
                    <cf_language_info 
                        table_name="SETUP_BASKET_ROWS" 
                        column_name="TITLE_NAME" 
                        column_id_value="#get_detail.BASKET_ROW_ID#" 
                        maxlength="500" 
                        datasource="#dsn3#" 
                        column_id="BASKET_ROW_ID" 
                        control_type="0">
                    </td>
				</cfif>
                <td><cf_get_lang_main no='106.Stok Kodu'></td>
            </tr>
            <tr>
                <td>
                	<cfif x_show_language>
                        <cfquery name="get_detail" datasource="#dsn3#">
                            SELECT #dsn_alias#.Get_Dynamic_Language(BASKET_ROW_ID,'#session.ep.language#','SETUP_BASKET_ROWS','TITLE_NAME',NULL,NULL,TITLE_NAME) AS TITLE_NAME,LINE_ORDER_NO,IS_SELECTED,GENISLIK,IS_READONLY,B_TYPE,BASKET_ROW_ID FROM (SELECT * FROM SETUP_BASKET_ROWS WHERE BASKET_ID = #GET_BASKET.BASKET_ID# AND B_TYPE=1) AS XXX WHERE TITLE = 'special_code'
                        </cfquery>
                    <cfelse>
	                    <cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'special_code'</cfquery>
                    </cfif>
                    <input type="checkbox" name="module_content" id="module_content" value="special_code" <cfif len(get_detail.is_selected) and get_detail.is_selected eq 1> Checked </cfif>> 
                </td>
                <td><cfinput type="text" name="special_code_sira" value="#get_detail.line_order_no#" style="width:25px" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>
                <td><cfinput type="text" name="special_code_genislik" value="#get_detail.genislik#" style="width:35px" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>
                <td><input type="textbox" name="special_code" id="special_code" value="<cfoutput>#get_detail.title_name#</cfoutput>" maxlength="200"></td>
				<cfif x_show_language>
                    <td>
                        <cf_language_info 
                            table_name="SETUP_BASKET_ROWS" 
                            column_name="TITLE_NAME" 
                            column_id_value="#get_detail.BASKET_ROW_ID#" 
                            maxlength="500" 
                            datasource="#dsn3#" 
                            column_id="BASKET_ROW_ID" 
                            control_type="0">
					</td>
				</cfif>
                <td><cf_get_lang_main no='377.Özel Kod'></td>
            </tr>
            <cfif listfind('7,12,3',get_basket.basket_id)>
            <tr>
                <td>
                    <cfif x_show_language>
                        <cfquery name="get_detail" datasource="#dsn3#">
                            SELECT #dsn_alias#.Get_Dynamic_Language(BASKET_ROW_ID,'#session.ep.language#','SETUP_BASKET_ROWS','TITLE_NAME',NULL,NULL,TITLE_NAME) AS TITLE_NAME,LINE_ORDER_NO,IS_SELECTED,GENISLIK,IS_READONLY,B_TYPE,BASKET_ROW_ID FROM (SELECT * FROM SETUP_BASKET_ROWS WHERE BASKET_ID = #GET_BASKET.BASKET_ID# AND B_TYPE=1) AS XXX WHERE TITLE = 'pbs_code'
                        </cfquery>
                    <cfelse>
                        <cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'pbs_code'</cfquery>
                    </cfif>
                    <input type="checkbox" name="module_content" id="module_content" value="pbs_code" <cfif get_detail.is_selected>checked</cfif>>
                </td>
                <td><input type="text" name="pbs_code_sira" id="pbs_code_sira" value="<cfoutput>#get_detail.line_order_no#</cfoutput>" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3" style="width:25px;"></td>
                <td><input type="text" name="pbs_code_genislik" id="pbs_code_genislik" value="<cfoutput>#get_detail.genislik#</cfoutput>" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3" style="width:35px"></td>
                <td><input type="textbox" name="pbs_code" id="pbs_code" value="<cfoutput>#get_detail.title_name#</cfoutput>" maxlength="200"></td>
				<cfif x_show_language>
                    <td>
                        <cf_language_info 
                            table_name="SETUP_BASKET_ROWS" 
                            column_name="TITLE_NAME" 
                            column_id_value="#get_detail.BASKET_ROW_ID#" 
                            maxlength="500" 
                            datasource="#dsn3#" 
                            column_id="BASKET_ROW_ID" 
                            control_type="0">
                    </td>
                </cfif>
				<td><cf_get_lang no='3170.PBS Kodu'></td>
            </tr>
            </cfif>
            <tr>
                <td>
                    <cfif x_show_language>
                        <cfquery name="get_detail" datasource="#dsn3#">
                            SELECT #dsn_alias#.Get_Dynamic_Language(BASKET_ROW_ID,'#session.ep.language#','SETUP_BASKET_ROWS','TITLE_NAME',NULL,NULL,TITLE_NAME) AS TITLE_NAME,LINE_ORDER_NO,IS_SELECTED,GENISLIK,IS_READONLY,B_TYPE,BASKET_ROW_ID FROM (SELECT * FROM SETUP_BASKET_ROWS WHERE BASKET_ID = #GET_BASKET.BASKET_ID# AND B_TYPE=1) AS XXX WHERE TITLE = 'Barcod'
                        </cfquery>
                    <cfelse>
                        <cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'Barcod'</cfquery>
                    </cfif>
                    <input type="checkbox" name="module_content" id="module_content" value="Barcod" <cfif len(get_detail.is_selected) and get_detail.is_selected eq 1> Checked </cfif> >
                </td>
                <td><cfinput type="text" name="barcod_sira" value="#get_detail.line_order_no#" style="width:25px" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>
                <td><cfinput type="text" name="barcod_genislik" value="#get_detail.genislik#" style="width:35px" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>
                <td><input type="textbox" name="BARCOD" id="BARCOD" value="<cfoutput>#get_detail.title_name#</cfoutput>" maxlength="200"></td>
				<cfif x_show_language>
                    <td>
                        <cf_language_info 
                            table_name="SETUP_BASKET_ROWS" 
                            column_name="TITLE_NAME" 
                            column_id_value="#get_detail.BASKET_ROW_ID#" 
                            maxlength="500" 
                            datasource="#dsn3#" 
                            column_id="BASKET_ROW_ID" 
                            control_type="0">
                    </td>
                </cfif>
                <td><cf_get_lang_main no='221.Barkod'></td>
            </tr>
            <tr>
                <td>
                    <cfif x_show_language>
                        <cfquery name="get_detail" datasource="#dsn3#">
                            SELECT #dsn_alias#.Get_Dynamic_Language(BASKET_ROW_ID,'#session.ep.language#','SETUP_BASKET_ROWS','TITLE_NAME',NULL,NULL,TITLE_NAME) AS TITLE_NAME,LINE_ORDER_NO,IS_SELECTED,GENISLIK,IS_READONLY,B_TYPE,BASKET_ROW_ID FROM (SELECT * FROM SETUP_BASKET_ROWS WHERE BASKET_ID = #GET_BASKET.BASKET_ID# AND B_TYPE=1) AS XXX WHERE TITLE = 'manufact_code'
                        </cfquery>
                    <cfelse>
                        <cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'manufact_code'</cfquery>
                    </cfif>
                    <input type="checkbox" name="module_content" id="module_content" value="manufact_code" <cfif len(get_detail.is_selected) and get_detail.is_selected eq 1> Checked </cfif><cfif get_basket.basket_id eq 52>disabled</cfif>>
                </td>
                <td><cfinput type="text" name="MANUFACT_CODE_sira" value="#get_detail.line_order_no#" style="width:25px" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>
                <td><cfinput type="text" name="MANUFACT_CODE_genislik" value="#get_detail.genislik#" style="width:35px" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>
                <td><input type="textbox" name="MANUFACT_CODE" id="MANUFACT_CODE" value="<cfoutput>#get_detail.title_name#</cfoutput>" maxlength="200"></td>
				<cfif x_show_language>
                    <td>
                        <cf_language_info 
                            table_name="SETUP_BASKET_ROWS" 
                            column_name="TITLE_NAME" 
                            column_id_value="#get_detail.BASKET_ROW_ID#" 
                            maxlength="500" 
                            datasource="#dsn3#" 
                            column_id="BASKET_ROW_ID" 
                            control_type="0">
                    </td>
                </cfif>
                <td><cf_get_lang_main no='222.Üretici Kodu'></td>
            </tr>
            <tr>
                <td>
                    <cfif x_show_language>
                        <cfquery name="get_detail" datasource="#dsn3#">
                            SELECT #dsn_alias#.Get_Dynamic_Language(BASKET_ROW_ID,'#session.ep.language#','SETUP_BASKET_ROWS','TITLE_NAME',NULL,NULL,TITLE_NAME) AS TITLE_NAME,LINE_ORDER_NO,IS_SELECTED,GENISLIK,IS_READONLY,B_TYPE,BASKET_ROW_ID FROM (SELECT * FROM SETUP_BASKET_ROWS WHERE BASKET_ID = #GET_BASKET.BASKET_ID# AND B_TYPE=1) AS XXX WHERE TITLE = 'product_name'
                        </cfquery>
                    <cfelse>
                        <cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'product_name'</cfquery>
                    </cfif>
                    <input type="checkbox" name="module_content" id="module_content" value="product_name" <cfif len(get_detail.is_selected) and get_detail.is_selected eq 1> Checked </cfif>>
                </td>
                <td><cfinput type="text" name="product_name_sira" value="#get_detail.line_order_no#" style="width:25px" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>
                <td><cfinput type="text" name="product_name_genislik" value="#get_detail.genislik#" style="width:35px" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>
                <td><input type="textbox" name="product_name" id="product_name" value="<cfoutput>#get_detail.title_name#</cfoutput>" maxlength="200"></td>
				<cfif x_show_language>
                    <td>
                        <cf_language_info 
                            table_name="SETUP_BASKET_ROWS" 
                            column_name="TITLE_NAME" 
                            column_id_value="#get_detail.BASKET_ROW_ID#" 
                            maxlength="500" 
                            datasource="#dsn3#" 
                            column_id="BASKET_ROW_ID" 
                            control_type="0">
                    </td>
                </cfif>
                <td>
					<select name="product_name_readonly" id="product_name_readonly"><!--- ilerde, sıra ve genişlik özellikleri gibi diger alanlara da readonly degeri atanabilir --->
                        <option value="0" <cfif len(get_detail.is_readonly) and get_detail.is_readonly eq 0>selected</cfif>><cf_get_lang no="2923.Değiştirilebilir"></option>
                        <option value="1" <cfif len(get_detail.is_readonly) and get_detail.is_readonly eq 1>selected</cfif>><cf_get_lang no="2924.Değiştirilemez"></option>
                    </select>
                	<cf_get_lang no='394.Ürün İsmi'>
              	</td>
            </tr>
            <tr>
                <td>
                    <cfif x_show_language>
                        <cfquery name="get_detail" datasource="#dsn3#">
                            SELECT #dsn_alias#.Get_Dynamic_Language(BASKET_ROW_ID,'#session.ep.language#','SETUP_BASKET_ROWS','TITLE_NAME',NULL,NULL,TITLE_NAME) AS TITLE_NAME,LINE_ORDER_NO,IS_SELECTED,GENISLIK,IS_READONLY,B_TYPE,BASKET_ROW_ID FROM (SELECT * FROM SETUP_BASKET_ROWS WHERE BASKET_ID = #GET_BASKET.BASKET_ID# AND B_TYPE=1) AS XXX WHERE TITLE = 'Amount'
                        </cfquery>
                    <cfelse>
                        <cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'Amount'</cfquery>
                    </cfif>
                    <input type="checkbox" name="module_content" id="module_content" value="Amount" <cfif len(get_detail.is_selected) and get_detail.is_selected eq 1> Checked </cfif>>
                </td>
                <td><cfinput type="text" name="AMOUNT_sira" value="#get_detail.line_order_no#" style="width:25px" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>
                <td><cfinput type="text" name="AMOUNT_genislik" value="#get_detail.genislik#" style="width:35px" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>
                <td><input type="textbox" name="AMOUNT" id="AMOUNT" value="<cfoutput>#get_detail.title_name#</cfoutput>" maxlength="200"></td>
				<cfif x_show_language>
                    <td>
                        <cf_language_info 
                            table_name="SETUP_BASKET_ROWS" 
                            column_name="TITLE_NAME" 
                            column_id_value="#get_detail.BASKET_ROW_ID#" 
                            maxlength="500" 
                            datasource="#dsn3#" 
                            column_id="BASKET_ROW_ID" 
                            control_type="0">
                    </td>
                </cfif>
                <td>
                    <select name="amount_round" id="amount_round">
                        <option value="0" <cfif get_basket.amount_round eq 0>selected</cfif>>0</option>
                        <option value="1" <cfif get_basket.amount_round eq 1>selected</cfif>>1</option>
                        <option value="2" <cfif get_basket.amount_round eq 2>selected</cfif>>2</option>
                        <option value="3" <cfif get_basket.amount_round eq 3>selected</cfif>>3</option>
                        <option value="4" <cfif get_basket.amount_round eq 4>selected</cfif>>4</option>
                    </select>
                    <cf_get_lang_main no='223.Miktar'><cf_get_lang_main no='577.ve'><cf_get_lang_main no='298.Yuvarlama'>(1 - 1,1 - 1,111 - 1,1111 <cf_get_lang no='1070.şeklinde miktar düzenlenir'>)
                </td>
            </tr>
            <tr>
                <td>
                    <cfif x_show_language>
                        <cfquery name="get_detail" datasource="#dsn3#">
                            SELECT #dsn_alias#.Get_Dynamic_Language(BASKET_ROW_ID,'#session.ep.language#','SETUP_BASKET_ROWS','TITLE_NAME',NULL,NULL,TITLE_NAME) AS TITLE_NAME,LINE_ORDER_NO,IS_SELECTED,GENISLIK,IS_READONLY,B_TYPE,BASKET_ROW_ID FROM (SELECT * FROM SETUP_BASKET_ROWS WHERE BASKET_ID = #GET_BASKET.BASKET_ID# AND B_TYPE=1) AS XXX WHERE TITLE = 'Unit'
                        </cfquery>
                    <cfelse>
                        <cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'Unit'</cfquery>
                    </cfif>
                    <input type="checkbox" name="module_content" id="module_content" value="Unit" <cfif len(get_detail.is_selected) and get_detail.is_selected eq 1> Checked </cfif>>
                </td>
                <td><cfinput type="text" name="unit_sira" id="unit_sira" value="#get_detail.line_order_no#" style="width:25px" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>
                <td><cfinput type="text" name="unit_genislik" id="unit_sira" value="#get_detail.genislik#" style="width:35px" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>
                <td><input type="textbox" name="unit" id="unit" value="<cfoutput>#get_detail.title_name#</cfoutput>" maxlength="200"></td>
				<cfif x_show_language>
                    <td>
                        <cf_language_info 
                            table_name="SETUP_BASKET_ROWS" 
                            column_name="TITLE_NAME" 
                            column_id_value="#get_detail.BASKET_ROW_ID#" 
                            maxlength="500" 
                            datasource="#dsn3#" 
                            column_id="BASKET_ROW_ID" 
                            control_type="0">
                    </td>
                </cfif>
                <td><cf_get_lang_main no='224.Birim'></td>
            </tr>
            <tr>
                <td>
                    <cfif x_show_language>
                        <cfquery name="get_detail" datasource="#dsn3#">
                            SELECT #dsn_alias#.Get_Dynamic_Language(BASKET_ROW_ID,'#session.ep.language#','SETUP_BASKET_ROWS','TITLE_NAME',NULL,NULL,TITLE_NAME) AS TITLE_NAME,LINE_ORDER_NO,IS_SELECTED,GENISLIK,IS_READONLY,B_TYPE,BASKET_ROW_ID FROM (SELECT * FROM SETUP_BASKET_ROWS WHERE BASKET_ID = #GET_BASKET.BASKET_ID# AND B_TYPE=1) AS XXX WHERE TITLE = 'Tax'
                        </cfquery>
                    <cfelse>
                        <cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'Tax'</cfquery>
                    </cfif>
                    <input type="checkbox" name="module_content" id="module_content" value="Tax" <cfif len(get_detail.is_selected) and get_detail.is_selected eq 1> Checked </cfif>>
                </td>
                <td><cfinput type="text" name="TAX_sira" value="#get_detail.line_order_no#" style="width:25px" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>
                <td><cfinput type="text" name="TAX_genislik" value="#get_detail.genislik#" style="width:35px" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>
                <td><input type="textbox" name="TAX" id="TAX" value="<cfoutput>#get_detail.title_name#</cfoutput>" maxlength="200"></td>
				<cfif x_show_language>
                    <td>
                        <cf_language_info 
                            table_name="SETUP_BASKET_ROWS" 
                            column_name="TITLE_NAME" 
                            column_id_value="#get_detail.BASKET_ROW_ID#" 
                            maxlength="500" 
                            datasource="#dsn3#" 
                            column_id="BASKET_ROW_ID" 
                            control_type="0">
                    </td>
                </cfif>
                <td><cf_get_lang no='610.Vergi KDV'>(%)</td>
            </tr>
            <cfif not listfind('12',get_basket.basket_id)>
                <tr>
                    <td>
                        <cfif x_show_language>
                            <cfquery name="get_detail" datasource="#dsn3#">
                                SELECT #dsn_alias#.Get_Dynamic_Language(BASKET_ROW_ID,'#session.ep.language#','SETUP_BASKET_ROWS','TITLE_NAME',NULL,NULL,TITLE_NAME) AS TITLE_NAME,LINE_ORDER_NO,IS_SELECTED,GENISLIK,IS_READONLY,B_TYPE,BASKET_ROW_ID FROM (SELECT * FROM SETUP_BASKET_ROWS WHERE BASKET_ID = #GET_BASKET.BASKET_ID# AND B_TYPE=1) AS XXX WHERE TITLE = 'OTV'
                            </cfquery>
                        <cfelse>
                            <cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'OTV'</cfquery>
                        </cfif>
                        <input type="checkbox" name="module_content" id="module_content" value="OTV"<cfif len(get_detail.is_selected) and get_detail.is_selected > Checked </cfif><cfif get_basket.basket_id eq 52>disabled</cfif>>
                    </td>
                    <td><cfinput type="text" name="OTV_sira" value="#get_detail.line_order_no#" style="width:25px" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>
                    <td><cfinput type="text" name="OTV_genislik" value="#get_detail.genislik#" style="width:35px" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>
                    <td><input type="textbox" name="OTV" id="OTV" value="<cfoutput>#get_detail.title_name#</cfoutput>" maxlength="200"></td>
                    <cfif x_show_language>
                        <td>
                            <cf_language_info 
                                table_name="SETUP_BASKET_ROWS" 
                                column_name="TITLE_NAME" 
                                column_id_value="#get_detail.BASKET_ROW_ID#" 
                                maxlength="500" 
                                datasource="#dsn3#" 
                                column_id="BASKET_ROW_ID" 
                                control_type="0">
                        </td>
                    </cfif>
                    <td><cf_get_lang_main no ='609.ÖTV'> (%)</td>
                </tr>
            </cfif>
            <tr>
                <td>
                    <cfif x_show_language>
                        <cfquery name="get_detail" datasource="#dsn3#">
                            SELECT #dsn_alias#.Get_Dynamic_Language(BASKET_ROW_ID,'#session.ep.language#','SETUP_BASKET_ROWS','TITLE_NAME',NULL,NULL,TITLE_NAME) AS TITLE_NAME,LINE_ORDER_NO,IS_SELECTED,GENISLIK,IS_READONLY,B_TYPE,BASKET_ROW_ID FROM (SELECT * FROM SETUP_BASKET_ROWS WHERE BASKET_ID = #GET_BASKET.BASKET_ID# AND B_TYPE=1) AS XXX WHERE TITLE = 'List_price'
                        </cfquery>
                    <cfelse>
                        <cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'List_price'</cfquery>
                    </cfif>
                    <input type="checkbox" name="module_content" id="module_content" value="List_price" <cfif get_detail.recordcount and get_detail.is_selected > Checked </cfif><cfif get_basket.basket_id eq 52>disabled</cfif>>
                </td>
                <td><cfinput type="text" name="List_price_sira" value="#get_detail.line_order_no#" style="width:25px" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>
                <td><cfinput type="text" name="List_price_genislik" value="#get_detail.genislik#" style="width:35px" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>
                <td><input type="textbox" name="List_price" id="List_price" value="<cfoutput>#get_detail.title_name#</cfoutput>" maxlength="200"></td>
				<cfif x_show_language>
                    <td>
                        <cf_language_info 
                            table_name="SETUP_BASKET_ROWS" 
                            column_name="TITLE_NAME" 
                            column_id_value="#get_detail.BASKET_ROW_ID#" 
                            maxlength="500" 
                            datasource="#dsn3#" 
                            column_id="BASKET_ROW_ID" 
                            control_type="0">
                    </td>
                </cfif>
                <td><cf_get_lang_main no='97.Liste'><cf_get_lang no='1583.Fiyatı'></td>
            </tr>
            <tr>
                <td>
                    <cfif x_show_language>
                        <cfquery name="get_detail" datasource="#dsn3#">
                            SELECT #dsn_alias#.Get_Dynamic_Language(BASKET_ROW_ID,'#session.ep.language#','SETUP_BASKET_ROWS','TITLE_NAME',NULL,NULL,TITLE_NAME) AS TITLE_NAME,LINE_ORDER_NO,IS_SELECTED,GENISLIK,IS_READONLY,B_TYPE,BASKET_ROW_ID FROM (SELECT * FROM SETUP_BASKET_ROWS WHERE BASKET_ID = #GET_BASKET.BASKET_ID# AND B_TYPE=1) AS XXX WHERE TITLE = 'list_price_discount'
                        </cfquery>
                    <cfelse>
                        <cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'list_price_discount'</cfquery>
                    </cfif>
                    <input type="checkbox" name="module_content" id="module_content" value="list_price_discount" <cfif get_detail.recordcount and get_detail.is_selected > Checked </cfif><cfif get_basket.basket_id eq 52>disabled</cfif>>
                </td>
                <td><cfinput type="text" name="list_price_discount_sira" value="#get_detail.line_order_no#" style="width:25px" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>
                <td><cfinput type="text" name="list_price_discount_genislik" value="#get_detail.genislik#" style="width:35px" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>
                <td><input type="textbox" name="list_price_discount" id="list_price_discount" value="<cfoutput>#get_detail.title_name#</cfoutput>" maxlength="200"></td>
				<cfif x_show_language>
                    <td>
                        <cf_language_info 
                            table_name="SETUP_BASKET_ROWS" 
                            column_name="TITLE_NAME" 
                            column_id_value="#get_detail.BASKET_ROW_ID#" 
                            maxlength="500" 
                            datasource="#dsn3#" 
                            column_id="BASKET_ROW_ID" 
                            control_type="0">
                    </td>
                </cfif>
                <td><cf_get_lang no='1701.Liste Fiyatı İskontosu'></td>
            </tr>
            <tr>
                <td>
                    <cfif x_show_language>
                        <cfquery name="get_detail" datasource="#dsn3#">
                            SELECT #dsn_alias#.Get_Dynamic_Language(BASKET_ROW_ID,'#session.ep.language#','SETUP_BASKET_ROWS','TITLE_NAME',NULL,NULL,TITLE_NAME) AS TITLE_NAME,LINE_ORDER_NO,IS_SELECTED,GENISLIK,IS_READONLY,B_TYPE,BASKET_ROW_ID FROM (SELECT * FROM SETUP_BASKET_ROWS WHERE BASKET_ID = #GET_BASKET.BASKET_ID# AND B_TYPE=1) AS XXX WHERE TITLE = 'Price'
                        </cfquery>
                    <cfelse>
                        <cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'Price'</cfquery>
                    </cfif>
                    <input type="checkbox" name="module_content" id="module_content" value="Price" <cfif len(get_detail.is_selected) and get_detail.is_selected eq 1> Checked </cfif>>
                </td>
                <td><cfinput type="text" name="PRICE_sira" value="#get_detail.line_order_no#" style="width:25px" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>
                <td><cfinput type="text" name="PRICE_genislik" value="#get_detail.genislik#" style="width:35px" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>
                <td><input type="textbox" name="PRICE" id="PRICE" value="<cfoutput>#get_detail.title_name#</cfoutput>" maxlength="200"></td>
				<cfif x_show_language>
                    <td>
                        <cf_language_info 
                            table_name="SETUP_BASKET_ROWS" 
                            column_name="TITLE_NAME" 
                            column_id_value="#get_detail.BASKET_ROW_ID#" 
                            maxlength="500" 
                            datasource="#dsn3#" 
                            column_id="BASKET_ROW_ID" 
                            control_type="0">
                    </td>
                </cfif>
                <td><cf_get_lang_main no='672.Fiyat'></td>
            </tr>
            <tr>
                <td>
                    <cfif x_show_language>
                        <cfquery name="get_detail" datasource="#dsn3#">
                            SELECT #dsn_alias#.Get_Dynamic_Language(BASKET_ROW_ID,'#session.ep.language#','SETUP_BASKET_ROWS','TITLE_NAME',NULL,NULL,TITLE_NAME) AS TITLE_NAME,LINE_ORDER_NO,IS_SELECTED,GENISLIK,IS_READONLY,B_TYPE,BASKET_ROW_ID FROM (SELECT * FROM SETUP_BASKET_ROWS WHERE BASKET_ID = #GET_BASKET.BASKET_ID# AND B_TYPE=1) AS XXX WHERE TITLE = 'tax_price'
                        </cfquery>
                    <cfelse>
                        <cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'tax_price'</cfquery>
                    </cfif>
                    <input type="checkbox" name="module_content" id="module_content" value="tax_price" <cfif get_detail.recordcount and get_detail.is_selected > Checked </cfif>>
                </td>
                <td><cfinput type="text" name="tax_price_sira" value="#get_detail.line_order_no#" style="width:25px" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>
                <td><cfinput type="text" name="tax_price_genislik" value="#get_detail.genislik#" style="width:35px" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>
                <td><input type="textbox" name="tax_price" id="tax_price" value="<cfif get_detail.recordcount><cfoutput>#get_detail.title_name#</cfoutput></cfif>" maxlength="200"></td>
				<cfif x_show_language>
                    <td>
                        <cf_language_info 
                            table_name="SETUP_BASKET_ROWS" 
                            column_name="TITLE_NAME" 
                            column_id_value="#get_detail.BASKET_ROW_ID#" 
                            maxlength="500" 
                            datasource="#dsn3#" 
                            column_id="BASKET_ROW_ID" 
                            control_type="0">
                    </td>
                </cfif>
                <td><cf_get_lang no ='1914.KDV li Birim Fiyat'></td>
            </tr>
            <tr>
                <td>
                    <cfif x_show_language>
                        <cfquery name="get_detail" datasource="#dsn3#">
                            SELECT #dsn_alias#.Get_Dynamic_Language(BASKET_ROW_ID,'#session.ep.language#','SETUP_BASKET_ROWS','TITLE_NAME',NULL,NULL,TITLE_NAME) AS TITLE_NAME,LINE_ORDER_NO,IS_SELECTED,GENISLIK,IS_READONLY,B_TYPE,BASKET_ROW_ID FROM (SELECT * FROM SETUP_BASKET_ROWS WHERE BASKET_ID = #GET_BASKET.BASKET_ID# AND B_TYPE=1) AS XXX WHERE TITLE = 'other_money'
                        </cfquery>
                    <cfelse>
                        <cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'other_money'</cfquery>
                    </cfif>
                    <input type="checkbox" name="module_content" id="module_content" value="other_money" <cfif len(get_detail.is_selected) and get_detail.is_selected eq 1> Checked </cfif>>
                </td>
                <td><cfinput type="text" name="other_money_sira" value="#get_detail.line_order_no#" style="width:25px" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>
                <td><cfinput type="text" name="other_money_genislik" value="#get_detail.genislik#" style="width:35px" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>
                <td><input type="textbox" name="other_money" id="other_money" value="<cfoutput>#get_detail.title_name#</cfoutput>" maxlength="200"></td>
				<cfif x_show_language>
                    <td>
                        <cf_language_info 
                            table_name="SETUP_BASKET_ROWS" 
                            column_name="TITLE_NAME" 
                            column_id_value="#get_detail.BASKET_ROW_ID#" 
                            maxlength="500" 
                            datasource="#dsn3#" 
                            column_id="BASKET_ROW_ID" 
                            control_type="0">
                    </td>
                </cfif>
                <td><cf_get_lang_main no='265.Döviz'></td>
            </tr>
            <tr>
                <td>
                    <cfif x_show_language>
                        <cfquery name="get_detail" datasource="#dsn3#">
                            SELECT #dsn_alias#.Get_Dynamic_Language(BASKET_ROW_ID,'#session.ep.language#','SETUP_BASKET_ROWS','TITLE_NAME',NULL,NULL,TITLE_NAME) AS TITLE_NAME,LINE_ORDER_NO,IS_SELECTED,GENISLIK,IS_READONLY,B_TYPE,BASKET_ROW_ID FROM (SELECT * FROM SETUP_BASKET_ROWS WHERE BASKET_ID = #GET_BASKET.BASKET_ID# AND B_TYPE=1) AS XXX WHERE TITLE = 'price_other'
                        </cfquery>
                    <cfelse>
                        <cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'price_other'</cfquery>
                    </cfif>
                    <input type="checkbox" name="module_content" id="module_content" value="price_other" <cfif len(get_detail.is_selected) and get_detail.is_selected eq 1> Checked </cfif>>
                </td>
                <td><cfinput type="text" name="PRICE_OTHER_sira" value="#get_detail.line_order_no#" style="width:25px" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>
                <td><cfinput type="text" name="PRICE_OTHER_genislik" value="#get_detail.genislik#" style="width:35px" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>
                <td><input type="textbox" name="PRICE_OTHER" id="PRICE_OTHER" value="<cfoutput>#get_detail.title_name#</cfoutput>" maxlength="200"></td>
				<cfif x_show_language>
                    <td>
                        <cf_language_info 
                            table_name="SETUP_BASKET_ROWS" 
                            column_name="TITLE_NAME" 
                            column_id_value="#get_detail.BASKET_ROW_ID#" 
                            maxlength="500" 
                            datasource="#dsn3#" 
                            column_id="BASKET_ROW_ID" 
                            control_type="0">
                    </td>
                </cfif>
                <td><cf_get_lang_main no='265.Döviz'> <cf_get_lang_main no='672.Fiyat'></td>
            </tr>
            <tr>
                <td>
                    <cfif x_show_language>
                        <cfquery name="get_detail" datasource="#dsn3#">
                            SELECT #dsn_alias#.Get_Dynamic_Language(BASKET_ROW_ID,'#session.ep.language#','SETUP_BASKET_ROWS','TITLE_NAME',NULL,NULL,TITLE_NAME) AS TITLE_NAME,LINE_ORDER_NO,IS_SELECTED,GENISLIK,IS_READONLY,B_TYPE,BASKET_ROW_ID FROM (SELECT * FROM SETUP_BASKET_ROWS WHERE BASKET_ID = #GET_BASKET.BASKET_ID# AND B_TYPE=1) AS XXX WHERE TITLE = 'product_name2'
                        </cfquery>
                    <cfelse>
                        <cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'product_name2'</cfquery>
                    </cfif>
                    <input type="checkbox" name="module_content" id="module_content" value="product_name2" <cfif len(get_detail.is_selected) and get_detail.is_selected eq 1> Checked </cfif><cfif get_basket.basket_id eq 52>disabled</cfif>>
                </td>
                <td><cfinput type="text" name="product_name2_sira" value="#get_detail.line_order_no#" style="width:25px" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>
                <td><cfinput type="text" name="product_name2_genislik" value="#get_detail.genislik#" style="width:35px" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>
                <td><input type="textbox" name="product_name2" id="product_name2" value="<cfoutput>#get_detail.title_name#</cfoutput>" maxlength="200"></td>
				<cfif x_show_language>
                    <td>
                        <cf_language_info 
                            table_name="SETUP_BASKET_ROWS" 
                            column_name="TITLE_NAME" 
                            column_id_value="#get_detail.BASKET_ROW_ID#" 
                            maxlength="500" 
                            datasource="#dsn3#" 
                            column_id="BASKET_ROW_ID" 
                            control_type="0">
                    </td>
                </cfif>
                <td><cf_get_lang_main no='217.Açıklama'>2 (<cf_get_lang no='1060.Etiket No, Özel Açıklama, Üründeki'>2. <cf_get_lang no='1076.Açıklama yazılabilir'>)</td>
            </tr>
            <tr>
                <td>
                    <cfif x_show_language>
                        <cfquery name="get_detail" datasource="#dsn3#">
                            SELECT #dsn_alias#.Get_Dynamic_Language(BASKET_ROW_ID,'#session.ep.language#','SETUP_BASKET_ROWS','TITLE_NAME',NULL,NULL,TITLE_NAME) AS TITLE_NAME,LINE_ORDER_NO,IS_SELECTED,GENISLIK,IS_READONLY,B_TYPE,BASKET_ROW_ID FROM (SELECT * FROM SETUP_BASKET_ROWS WHERE BASKET_ID = #GET_BASKET.BASKET_ID# AND B_TYPE=1) AS XXX WHERE TITLE = 'Amount2'
                        </cfquery>
                    <cfelse>
                        <cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'Amount2'</cfquery>
                    </cfif>
                    <input type="checkbox" name="module_content" id="module_content" value="Amount2" <cfif len(get_detail.is_selected) and get_detail.is_selected eq 1> Checked </cfif><cfif get_basket.basket_id eq 52>disabled</cfif>>
                </td>
                <td><cfinput type="text" name="AMOUNT2_sira" value="#get_detail.line_order_no#" style="width:25px" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>
                <td><cfinput type="text" name="AMOUNT2_genislik" value="#get_detail.genislik#" style="width:35px" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>
                <td><input type="textbox" name="AMOUNT2" id="AMOUNT2" value="<cfoutput>#get_detail.title_name#</cfoutput>" maxlength="200"></td>
				<cfif x_show_language>
                    <td>
                        <cf_language_info 
                            table_name="SETUP_BASKET_ROWS" 
                            column_name="TITLE_NAME" 
                            column_id_value="#get_detail.BASKET_ROW_ID#" 
                            maxlength="500" 
                            datasource="#dsn3#" 
                            column_id="BASKET_ROW_ID" 
                            control_type="0">
                    </td>
                </cfif>
                <td><cf_get_lang_main no='223.Miktar'> 2</td>
            </tr>
            <tr>
                <td>
                    <cfif x_show_language>
                        <cfquery name="get_detail" datasource="#dsn3#">
                            SELECT 
                            	#dsn_alias#.Get_Dynamic_Language(BASKET_ROW_ID,'#session.ep.language#','SETUP_BASKET_ROWS','TITLE_NAME',NULL,NULL,TITLE_NAME) AS TITLE_NAME,
                                XXX.LINE_ORDER_NO,
                                XXX.IS_SELECTED,
                                XXX.GENISLIK,
                                XXX.IS_READONLY,
                                XXX.B_TYPE,
                                XXX.BASKET_ROW_ID,
                                S.AMOUNT_READONLY
                            FROM 
                            	(SELECT * FROM SETUP_BASKET_ROWS WHERE BASKET_ID = #GET_BASKET.BASKET_ID# AND B_TYPE=1) AS XXX 
                                LEFT JOIN SETUP_BASKET AS S ON XXX.BASKET_ID = S.BASKET_ID
                            WHERE 
                            	TITLE = 'Unit2'
                                AND S.B_TYPE = 1
                        </cfquery>
                    <cfelse>
                        <cfquery name="get_detail" datasource="#dsn3#">
                        	SELECT 
                            	XXX.TITLE_NAME,
                                XXX.LINE_ORDER_NO,
                                XXX.IS_SELECTED,
                                XXX.GENISLIK,
                                XXX.IS_READONLY,
                                XXX.B_TYPE,
                                XXX.BASKET_ROW_ID,
                                S.AMOUNT_READONLY
                            FROM 
                            	(SELECT * FROM SETUP_BASKET_ROWS WHERE BASKET_ID = #GET_BASKET.BASKET_ID# AND B_TYPE=1) AS XXX 
                                LEFT JOIN SETUP_BASKET AS S ON XXX.BASKET_ID = S.BASKET_ID
                            WHERE 
                            	TITLE = 'Unit2'
                                AND S.B_TYPE = 1
                        </cfquery>
                    </cfif>
                    <input type="checkbox" name="module_content" id="module_content" value="Unit2" <cfif len(get_detail.is_selected) and get_detail.is_selected eq 1> Checked </cfif><cfif get_basket.basket_id eq 52>disabled</cfif>>
                </td>
                <td><cfinput type="text" name="UNIT2_sira" value="#get_detail.line_order_no#" style="width:25px" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>
                <td><cfinput type="text" name="UNIT2_genislik" value="#get_detail.genislik#" style="width:35px" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>
                <td><input type="textbox" name="UNIT2" id="UNIT2" value="<cfoutput>#get_detail.title_name#</cfoutput>" maxlength="200"></td>
				<cfif x_show_language>
                    <td>
                        <cf_language_info 
                            table_name="SETUP_BASKET_ROWS" 
                            column_name="TITLE_NAME" 
                            column_id_value="#get_detail.BASKET_ROW_ID#" 
                            maxlength="500" 
                            datasource="#dsn3#" 
                            column_id="BASKET_ROW_ID" 
                            control_type="0">
                    </td>
                </cfif>
                <td>
                    <select name="amount_readonly" id="amount_readonly">
                        <option value="0"><cf_get_lang no="2923.Değiştirilebilir"></option>
                        <option value="1" <cfif len(get_detail.amount_readonly) and get_detail.amount_readonly eq 1>selected</cfif>><cf_get_lang no="2924.Değiştirilemez"></option>
                    </select>
                    <cf_get_lang_main no='224.Birim'>2 (<cf_get_lang no='1923.Stoğun Birimi'>)
                </td>
            </tr>
            <tr>
                <td>
                    <cfif x_show_language>
                        <cfquery name="get_detail" datasource="#dsn3#">
                            SELECT #dsn_alias#.Get_Dynamic_Language(BASKET_ROW_ID,'#session.ep.language#','SETUP_BASKET_ROWS','TITLE_NAME',NULL,NULL,TITLE_NAME) AS TITLE_NAME,LINE_ORDER_NO,IS_SELECTED,GENISLIK,IS_READONLY,B_TYPE,BASKET_ROW_ID FROM (SELECT * FROM SETUP_BASKET_ROWS WHERE BASKET_ID = #GET_BASKET.BASKET_ID# AND B_TYPE=1) AS XXX WHERE TITLE = 'basket_extra_info'
                        </cfquery>
                    <cfelse>
                        <cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'basket_extra_info'</cfquery>
                    </cfif>
                    <input type="checkbox" name="module_content" id="module_content" value="basket_extra_info" <cfif len(get_detail.is_selected) and get_detail.is_selected eq 1> Checked </cfif><cfif get_basket.basket_id eq 52>disabled</cfif>>
                </td>
                <td><cfinput type="text" name="basket_extra_info_sira" value="#get_detail.line_order_no#" style="width:25px" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>
                <td><cfinput type="text" name="basket_extra_info_genislik" value="#get_detail.genislik#" style="width:35px" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>
                <td><input type="textbox" name="basket_extra_info" id="basket_extra_info" value="<cfoutput>#get_detail.title_name#</cfoutput>" maxlength="200"></td>
				<cfif x_show_language>
                    <td>
                        <cf_language_info 
                            table_name="SETUP_BASKET_ROWS" 
                            column_name="TITLE_NAME" 
                            column_id_value="#get_detail.BASKET_ROW_ID#" 
                            maxlength="500" 
                            datasource="#dsn3#" 
                            column_id="BASKET_ROW_ID" 
                            control_type="0">
                    </td>
                </cfif>
                <td><cf_get_lang no ='1915.Ek Açıklama (Basket Ek Açıklama Bölümünde Tanımlanmış Standart Açıklamalar)'></td>
            </tr>
            <!--- Ek Aciklama 2 Eklendi Mifa Fbs 20181004 --->
            <tr>
                <td>
                    <cfif x_show_language>
                        <cfquery name="get_detail" datasource="#dsn3#">
                            SELECT #dsn_alias#.Get_Dynamic_Language(BASKET_ROW_ID,'#session.ep.language#','SETUP_BASKET_ROWS','TITLE_NAME',NULL,NULL,TITLE_NAME) AS TITLE_NAME,LINE_ORDER_NO,IS_SELECTED,GENISLIK,IS_READONLY,B_TYPE,BASKET_ROW_ID FROM (SELECT * FROM SETUP_BASKET_ROWS WHERE BASKET_ID = #GET_BASKET.BASKET_ID# AND B_TYPE=1) AS XXX WHERE TITLE = 'select_info_extra'
                        </cfquery>
                    <cfelse>
                        <cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'select_info_extra'</cfquery>
                    </cfif>
                    <input type="checkbox" name="module_content" id="module_content" value="select_info_extra" <cfif len(get_detail.is_selected) and get_detail.is_selected eq 1> Checked </cfif><cfif get_basket.basket_id eq 52>disabled</cfif>>
                </td>
                <td><cfinput type="text" name="select_info_extra_sira" value="#get_detail.line_order_no#" style="width:25px" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>
                <td><cfinput type="text" name="select_info_extra_genislik" value="#get_detail.genislik#" style="width:35px" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>
                <td><input type="textbox" name="select_info_extra" id="select_info_extra" value="<cfoutput>#get_detail.title_name#</cfoutput>" maxlength="200"></td>
				<cfif x_show_language>
                    <td>
                        <cf_language_info 
                            table_name="SETUP_BASKET_ROWS" 
                            column_name="TITLE_NAME" 
                            column_id_value="#get_detail.BASKET_ROW_ID#" 
                            maxlength="500" 
                            datasource="#dsn3#" 
                            column_id="BASKET_ROW_ID" 
                            control_type="0">
                    </td>
                </cfif>
                <td><cf_get_lang no ='698.Ek Açıklama'> 2</td>
            </tr>
            <!--- Satir Aciklama 3 Eklendi Mifa Fbs 20181004 --->
            <tr>
                <td>
                    <cfif x_show_language>
                        <cfquery name="get_detail" datasource="#dsn3#">
                            SELECT #dsn_alias#.Get_Dynamic_Language(BASKET_ROW_ID,'#session.ep.language#','SETUP_BASKET_ROWS','TITLE_NAME',NULL,NULL,TITLE_NAME) AS TITLE_NAME,LINE_ORDER_NO,IS_SELECTED,GENISLIK,IS_READONLY,B_TYPE,BASKET_ROW_ID FROM (SELECT * FROM SETUP_BASKET_ROWS WHERE BASKET_ID = #GET_BASKET.BASKET_ID# AND B_TYPE=1) AS XXX WHERE TITLE = 'detail_info_extra'
                        </cfquery>
                    <cfelse>
                        <cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'detail_info_extra'</cfquery>
                    </cfif>
                    <input type="checkbox" name="module_content" id="module_content" value="detail_info_extra" <cfif len(get_detail.is_selected) and get_detail.is_selected eq 1> Checked </cfif><cfif get_basket.basket_id eq 52>disabled</cfif>>
                </td>
                <td><cfinput type="text" name="detail_info_extra_sira" value="#get_detail.line_order_no#" style="width:25px" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>
                <td><cfinput type="text" name="detail_info_extra_genislik" value="#get_detail.genislik#" style="width:35px" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>
                <td><input type="textbox" name="detail_info_extra" id="detail_info_extra" value="<cfoutput>#get_detail.title_name#</cfoutput>" maxlength="200"></td>
				<cfif x_show_language>
                    <td>
                        <cf_language_info 
                            table_name="SETUP_BASKET_ROWS" 
                            column_name="TITLE_NAME" 
                            column_id_value="#get_detail.BASKET_ROW_ID#" 
                            maxlength="500" 
                            datasource="#dsn3#" 
                            column_id="BASKET_ROW_ID" 
                            control_type="0">
                    </td>
                </cfif>
                <td><cf_get_lang_main no='217.Açıklama'> 3</td>
            </tr>

            <cfif listfind('2',get_basket.basket_id)>
            <tr>
                <td>
                    <cfif x_show_language>
                        <cfquery name="get_detail" datasource="#dsn3#">
                            SELECT #dsn_alias#.Get_Dynamic_Language(BASKET_ROW_ID,'#session.ep.language#','SETUP_BASKET_ROWS','TITLE_NAME',NULL,NULL,TITLE_NAME) AS TITLE_NAME,LINE_ORDER_NO,IS_SELECTED,GENISLIK,IS_READONLY,B_TYPE,BASKET_ROW_ID FROM (SELECT * FROM SETUP_BASKET_ROWS WHERE BASKET_ID = #GET_BASKET.BASKET_ID# AND B_TYPE=1) AS XXX WHERE TITLE = 'reason_code'
                        </cfquery>
                    <cfelse>
                        <cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'reason_code'</cfquery>
                    </cfif>
                    <input type="checkbox" name="module_content" id="module_content" value="reason_code" <cfif get_detail.is_selected>checked</cfif>>
                </td>
                <td><input type="text" name="reason_code_sira" id="reason_code_sira" value="<cfoutput>#get_detail.line_order_no#</cfoutput>" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3" style="width:25px;"></td>
                <td><input type="text" name="reason_code_genislik" id="pbs_code_genislik" value="<cfoutput>#get_detail.genislik#</cfoutput>" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3" style="width:35px"></td>
                <td><input type="textbox" name="reason_code" id="pbs_code" value="<cfoutput>#get_detail.title_name#</cfoutput>" maxlength="200"></td>
				<cfif x_show_language>
                    <td>
                        <cf_language_info 
                            table_name="SETUP_BASKET_ROWS" 
                            column_name="TITLE_NAME" 
                            column_id_value="#get_detail.BASKET_ROW_ID#" 
                            maxlength="500" 
                            datasource="#dsn3#" 
                            column_id="BASKET_ROW_ID" 
                            control_type="0">
                    </td>
                </cfif>
				<td><cf_get_lang no='1475.İstisna Kodu'></td>
            </tr>
            </cfif>            
         </table>
         <cf_seperator header="#getLang('settings',681)#" id="urun_boyut_bilgileri">
         <table id="urun_boyut_bilgileri">
            <tr>
            	<td>
                    <cfif x_show_language>
                        <cfquery name="get_detail" datasource="#dsn3#">
                            SELECT #dsn_alias#.Get_Dynamic_Language(BASKET_ROW_ID,'#session.ep.language#','SETUP_BASKET_ROWS','TITLE_NAME',NULL,NULL,TITLE_NAME) AS TITLE_NAME,LINE_ORDER_NO,IS_SELECTED,GENISLIK,IS_READONLY,B_TYPE,BASKET_ROW_ID FROM (SELECT * FROM SETUP_BASKET_ROWS WHERE BASKET_ID = #GET_BASKET.BASKET_ID# AND B_TYPE=1) AS XXX WHERE TITLE = 'row_width'
                        </cfquery>
                    <cfelse>
                        <cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'row_width'</cfquery>
                    </cfif>
                    <input type="checkbox" name="module_content" id="module_content" value="row_width" <cfif len(get_detail.is_selected) and get_detail.is_selected eq 1> Checked </cfif><cfif get_basket.basket_id eq 52>disabled</cfif>>
                </td>
                <td><cfinput type="text" name="row_width_sira" value="#get_detail.line_order_no#" style="width:25px" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>
                <td><cfinput type="text" name="row_width_genislik" value="#get_detail.genislik#" style="width:35px" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>
                <td><input type="textbox" name="row_width" id="row_width" value="<cfoutput>#get_detail.title_name#</cfoutput>" maxlength="200"></td>
				<cfif x_show_language>
                    <td>
                        <cf_language_info 
                            table_name="SETUP_BASKET_ROWS" 
                            column_name="TITLE_NAME" 
                            column_id_value="#get_detail.BASKET_ROW_ID#" 
                            maxlength="500" 
                            datasource="#dsn3#" 
                            column_id="BASKET_ROW_ID" 
                            control_type="0">
                    </td>
                </cfif>
                <td><cf_get_lang_main no='283.Genişlik'></td>
            </tr>
            <tr>
            	<td>
                    <cfif x_show_language>
                        <cfquery name="get_detail" datasource="#dsn3#">
                            SELECT #dsn_alias#.Get_Dynamic_Language(BASKET_ROW_ID,'#session.ep.language#','SETUP_BASKET_ROWS','TITLE_NAME',NULL,NULL,TITLE_NAME) AS TITLE_NAME,LINE_ORDER_NO,IS_SELECTED,GENISLIK,IS_READONLY,B_TYPE,BASKET_ROW_ID FROM (SELECT * FROM SETUP_BASKET_ROWS WHERE BASKET_ID = #GET_BASKET.BASKET_ID# AND B_TYPE=1) AS XXX WHERE TITLE = 'row_depth'
                        </cfquery>
                    <cfelse>
                        <cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'row_depth'</cfquery>
                    </cfif>
                    <input type="checkbox" name="module_content" id="module_content" value="row_depth" <cfif len(get_detail.is_selected) and get_detail.is_selected eq 1> Checked </cfif><cfif get_basket.basket_id eq 52>disabled</cfif>>
                </td>
                <td><cfinput type="text" name="row_depth_sira" value="#get_detail.line_order_no#" style="width:25px" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>
                <td><cfinput type="text" name="row_depth_genislik" value="#get_detail.genislik#" style="width:35px" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>
                <td><input type="textbox" name="row_depth" id="row_depth" value="<cfoutput>#get_detail.title_name#</cfoutput>" maxlength="200"></td>
				<cfif x_show_language>
                    <td>
                        <cf_language_info 
                            table_name="SETUP_BASKET_ROWS" 
                            column_name="TITLE_NAME" 
                            column_id_value="#get_detail.BASKET_ROW_ID#" 
                            maxlength="500" 
                            datasource="#dsn3#" 
                            column_id="BASKET_ROW_ID" 
                            control_type="0">
                    </td>
                </cfif>
                <td><cf_get_lang no='692.Derinlik'></td>
            </tr>
            <tr>
                <td>
                    <cfif x_show_language>
                        <cfquery name="get_detail" datasource="#dsn3#">
                            SELECT #dsn_alias#.Get_Dynamic_Language(BASKET_ROW_ID,'#session.ep.language#','SETUP_BASKET_ROWS','TITLE_NAME',NULL,NULL,TITLE_NAME) AS TITLE_NAME,LINE_ORDER_NO,IS_SELECTED,GENISLIK,IS_READONLY,B_TYPE,BASKET_ROW_ID FROM (SELECT * FROM SETUP_BASKET_ROWS WHERE BASKET_ID = #GET_BASKET.BASKET_ID# AND B_TYPE=1) AS XXX WHERE TITLE = 'row_height'
                        </cfquery>
                    <cfelse>
                        <cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'row_height'</cfquery>
                    </cfif>
                    <input type="checkbox" name="module_content" id="module_content" value="row_height" <cfif len(get_detail.is_selected) and get_detail.is_selected eq 1> Checked </cfif><cfif get_basket.basket_id eq 52>disabled</cfif>>
                </td>
                <td><cfinput type="text" name="row_height_sira" value="#get_detail.line_order_no#" style="width:25px" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>
                <td><cfinput type="text" name="row_height_genislik" value="#get_detail.genislik#" style="width:35px" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>
                <td><input type="textbox" name="row_height" id="row_height" value="<cfoutput>#get_detail.title_name#</cfoutput>" maxlength="200"></td>
				<cfif x_show_language>
                    <td>
                        <cf_language_info 
                            table_name="SETUP_BASKET_ROWS" 
                            column_name="TITLE_NAME" 
                            column_id_value="#get_detail.BASKET_ROW_ID#" 
                            maxlength="500" 
                            datasource="#dsn3#" 
                            column_id="BASKET_ROW_ID" 
                            control_type="0">
                    </td>
                </cfif>
                <td><cf_get_lang_main no='284.Yükseklik'></td>
            </tr>
         </table>
         <cf_seperator header="#getLang('settings',1054)#" id="indirim_maliyet_ve_hesaplama">
         <table id="indirim_maliyet_ve_hesaplama">
            <tr>
				<cfif x_show_language>
                    <cfquery name="get_detail" datasource="#dsn3#">
                        SELECT #dsn_alias#.Get_Dynamic_Language(BASKET_ROW_ID,'#session.ep.language#','SETUP_BASKET_ROWS','TITLE_NAME',NULL,NULL,TITLE_NAME) AS TITLE_NAME,LINE_ORDER_NO,IS_SELECTED,GENISLIK,IS_READONLY,B_TYPE,BASKET_ROW_ID FROM (SELECT * FROM SETUP_BASKET_ROWS WHERE BASKET_ID = #GET_BASKET.BASKET_ID# AND B_TYPE=1) AS XXX WHERE TITLE = 'ek_tutar'
                    </cfquery>
                <cfelse>
                    <cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'ek_tutar'</cfquery>
                </cfif>
                <td><input type="checkbox" name="module_content" id="module_content" value="ek_tutar" <cfif len(get_detail.is_selected) and get_detail.is_selected eq 1> Checked </cfif><cfif get_basket.basket_id eq 52>disabled</cfif>></td>
                <td><cfinput type="text" name="ek_tutar_sira" value="#get_detail.line_order_no#" style="width:25px" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>
                <td><cfinput type="text" name="ek_tutar_genislik" value="#get_detail.genislik#" style="width:35px" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>
                <td><input type="textbox" name="ek_tutar" id="ek_tutar" value="<cfoutput>#get_detail.title_name#</cfoutput>" maxlength="200"></td>
				<cfif x_show_language>
                    <td>
                        <cf_language_info 
                            table_name="SETUP_BASKET_ROWS" 
                            column_name="TITLE_NAME" 
                            column_id_value="#get_detail.BASKET_ROW_ID#" 
                            maxlength="500" 
                            datasource="#dsn3#" 
                            column_id="BASKET_ROW_ID" 
                            control_type="0">
                    </td>
                </cfif>
                <td><cf_get_lang no='1037.Ek Tutar'> (<cf_get_lang no='1071.Mal veya Hizmete İlişkin Ek Bir Fiyat'>: <cf_get_lang_main no='372.İşcilik'>vb.)</td>
            </tr>
            <tr>
				<cfif x_show_language>
                    <cfquery name="get_detail" datasource="#dsn3#">
                        SELECT #dsn_alias#.Get_Dynamic_Language(BASKET_ROW_ID,'#session.ep.language#','SETUP_BASKET_ROWS','TITLE_NAME',NULL,NULL,TITLE_NAME) AS TITLE_NAME,LINE_ORDER_NO,IS_SELECTED,GENISLIK,IS_READONLY,B_TYPE,BASKET_ROW_ID FROM (SELECT * FROM SETUP_BASKET_ROWS WHERE BASKET_ID = #GET_BASKET.BASKET_ID# AND B_TYPE=1) AS XXX WHERE TITLE = 'ek_tutar_price'
                    </cfquery>
                <cfelse>
                    <cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'ek_tutar_price'</cfquery>
                </cfif>
                <td><input type="checkbox" name="module_content" id="module_content" value="ek_tutar_price" <cfif len(get_detail.is_selected) and get_detail.is_selected eq 1> Checked </cfif><cfif get_basket.basket_id eq 52>disabled</cfif>></td>
                <td><cfinput type="text" name="ek_tutar_price_sira" value="#get_detail.line_order_no#" style="width:25px" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>
                <td><cfinput type="text" name="ek_tutar_price_genislik" value="#get_detail.genislik#" style="width:35px" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>
                <td><input type="textbox" name="ek_tutar_price" id="ek_tutar_price" value="<cfoutput>#get_detail.title_name#</cfoutput>" maxlength="200"></td>
				<cfif x_show_language>
                    <td>
                        <cf_language_info 
                            table_name="SETUP_BASKET_ROWS" 
                            column_name="TITLE_NAME" 
                            column_id_value="#get_detail.BASKET_ROW_ID#" 
                            maxlength="500" 
                            datasource="#dsn3#" 
                            column_id="BASKET_ROW_ID" 
                            control_type="0">
                    </td>
                </cfif>
                <td><cf_get_lang no='1700.İşçilik Birim Ücreti'></td>
            </tr>
            <tr>
				<cfif x_show_language>
                    <cfquery name="get_detail" datasource="#dsn3#">
                        SELECT #dsn_alias#.Get_Dynamic_Language(BASKET_ROW_ID,'#session.ep.language#','SETUP_BASKET_ROWS','TITLE_NAME',NULL,NULL,TITLE_NAME) AS TITLE_NAME,LINE_ORDER_NO,IS_SELECTED,GENISLIK,IS_READONLY,B_TYPE,BASKET_ROW_ID FROM (SELECT * FROM SETUP_BASKET_ROWS WHERE BASKET_ID = #GET_BASKET.BASKET_ID# AND B_TYPE=1) AS XXX WHERE TITLE = 'ek_tutar_cost'
                    </cfquery>
                <cfelse>
                    <cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'ek_tutar_cost'</cfquery>
                </cfif>				
                <td><input type="checkbox" name="module_content" id="module_content" value="ek_tutar_cost" <cfif len(get_detail.is_selected) and get_detail.is_selected eq 1> Checked </cfif><cfif get_basket.basket_id eq 52>disabled</cfif>></td>
                <td><cfinput type="text" name="ek_tutar_cost_sira" value="#get_detail.line_order_no#" style="width:25px" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>
                <td><cfinput type="text" name="ek_tutar_cost_genislik" value="#get_detail.genislik#" style="width:35px" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>
                <td><input type="textbox" name="ek_tutar_cost" id="ek_tutar_cost" value="<cfoutput>#get_detail.title_name#</cfoutput>" maxlength="200"></td>
				<cfif x_show_language>
                    <td>
                        <cf_language_info 
                            table_name="SETUP_BASKET_ROWS" 
                            column_name="TITLE_NAME" 
                            column_id_value="#get_detail.BASKET_ROW_ID#" 
                            maxlength="500" 
                            datasource="#dsn3#" 
                            column_id="BASKET_ROW_ID" 
                            control_type="0">
                    </td>
                </cfif>
                <td><cf_get_lang no='1634.İşçilik Maliyet'></td>
            </tr>
            <tr>
				<cfif x_show_language>
                    <cfquery name="get_detail" datasource="#dsn3#">
                        SELECT #dsn_alias#.Get_Dynamic_Language(BASKET_ROW_ID,'#session.ep.language#','SETUP_BASKET_ROWS','TITLE_NAME',NULL,NULL,TITLE_NAME) AS TITLE_NAME,LINE_ORDER_NO,IS_SELECTED,GENISLIK,IS_READONLY,B_TYPE,BASKET_ROW_ID FROM (SELECT * FROM SETUP_BASKET_ROWS WHERE BASKET_ID = #GET_BASKET.BASKET_ID# AND B_TYPE=1) AS XXX WHERE TITLE = 'ek_tutar_marj'
                    </cfquery>
                <cfelse>
                    <cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'ek_tutar_marj'</cfquery>
                </cfif>
                <td><input type="checkbox" name="module_content" id="module_content" value="ek_tutar_marj" <cfif len(get_detail.is_selected) and get_detail.is_selected eq 1> Checked </cfif><cfif get_basket.basket_id eq 52>disabled</cfif>></td>
                <td><cfinput type="text" name="ek_tutar_marj_sira" value="#get_detail.line_order_no#" style="width:25px" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>
                <td><cfinput type="text" name="ek_tutar_marj_genislik" value="#get_detail.genislik#" style="width:35px" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>
                <td><input type="textbox" name="ek_tutar_marj" id="ek_tutar_marj" value="<cfoutput>#get_detail.title_name#</cfoutput>" maxlength="200"></td>
				<cfif x_show_language>
                    <td>
                        <cf_language_info 
                            table_name="SETUP_BASKET_ROWS" 
                            column_name="TITLE_NAME" 
                            column_id_value="#get_detail.BASKET_ROW_ID#" 
                            maxlength="500" 
                            datasource="#dsn3#" 
                            column_id="BASKET_ROW_ID" 
                            control_type="0">
                    </td>
                </cfif>
                <td><cf_get_lang no='1635.Ek Tutar Marj'></td>
            </tr>
            <tr><!--- ek_tutar_other_total --->
				<cfif x_show_language>
                    <cfquery name="get_detail" datasource="#dsn3#">
                        SELECT #dsn_alias#.Get_Dynamic_Language(BASKET_ROW_ID,'#session.ep.language#','SETUP_BASKET_ROWS','TITLE_NAME',NULL,NULL,TITLE_NAME) AS TITLE_NAME,LINE_ORDER_NO,IS_SELECTED,GENISLIK,IS_READONLY,B_TYPE,BASKET_ROW_ID FROM (SELECT * FROM SETUP_BASKET_ROWS WHERE BASKET_ID = #GET_BASKET.BASKET_ID# AND B_TYPE=1) AS XXX WHERE TITLE = 'ek_tutar_other_total'
                    </cfquery>
                <cfelse>
                    <cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'ek_tutar_other_total'</cfquery>
                </cfif>
                <td><input type="checkbox" name="module_content" id="module_content" value="ek_tutar_other_total" <cfif len(get_detail.is_selected) and get_detail.is_selected eq 1> Checked </cfif><cfif get_basket.basket_id eq 52>disabled</cfif>></td>
                <td><cfinput type="text" name="ek_tutar_other_total_sira" value="#get_detail.line_order_no#" style="width:25px" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>
                <td><cfinput type="text" name="ek_tutar_other_total_genislik" value="#get_detail.genislik#" style="width:35px" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>
                <td><input type="textbox" name="ek_tutar_other_total" id="ek_tutar_other_total" value="<cfoutput>#get_detail.title_name#</cfoutput>"maxlength="200"></td>
				<cfif x_show_language>
                    <td>
                        <cf_language_info 
                            table_name="SETUP_BASKET_ROWS" 
                            column_name="TITLE_NAME" 
                            column_id_value="#get_detail.BASKET_ROW_ID#" 
                            maxlength="500" 
                            datasource="#dsn3#" 
                            column_id="BASKET_ROW_ID" 
                            control_type="0">
                    </td>
                </cfif>
                <td><cf_get_lang no='1606.Satır Ek Tutar Toplamı'> (<cf_get_lang no='1037.Ek Tutar'> * <cf_get_lang_main no='223.Miktar'>)</td>
            </tr>
            <tr>
				<cfif x_show_language>
                    <cfquery name="get_detail" datasource="#dsn3#">
                        SELECT #dsn_alias#.Get_Dynamic_Language(BASKET_ROW_ID,'#session.ep.language#','SETUP_BASKET_ROWS','TITLE_NAME',NULL,NULL,TITLE_NAME) AS TITLE_NAME,LINE_ORDER_NO,IS_SELECTED,GENISLIK,IS_READONLY,B_TYPE,BASKET_ROW_ID FROM (SELECT * FROM SETUP_BASKET_ROWS WHERE BASKET_ID = #GET_BASKET.BASKET_ID# AND B_TYPE=1) AS XXX WHERE TITLE = 'iskonto_tutar'
                    </cfquery>
                <cfelse>
                    <cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'iskonto_tutar'</cfquery>
                </cfif>
                <td><input type="checkbox" name="module_content" id="module_content" value="iskonto_tutar" <cfif len(get_detail.is_selected) and get_detail.is_selected eq 1> Checked </cfif><cfif get_basket.basket_id eq 52>disabled</cfif>></td>
                <td><cfinput type="text" name="iskonto_tutar_sira" value="#get_detail.line_order_no#" style="width:25px" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>
                <td><cfinput type="text" name="iskonto_tutar_genislik" value="#get_detail.genislik#" style="width:35px" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>
                <td><input type="textbox" name="iskonto_tutar" id="iskonto_tutar" value="<cfoutput>#get_detail.title_name#</cfoutput>" maxlength="200"></td>
				<cfif x_show_language>
                    <td>
                        <cf_language_info 
                            table_name="SETUP_BASKET_ROWS" 
                            column_name="TITLE_NAME" 
                            column_id_value="#get_detail.BASKET_ROW_ID#" 
                            maxlength="500" 
                            datasource="#dsn3#" 
                            column_id="BASKET_ROW_ID" 
                            control_type="0">
                    </td>
                </cfif>
                <td><cf_get_lang_main no='261.tutar'><cf_get_lang_main no='229.İndirim'></td>
            </tr>
            <tr>
				<cfif x_show_language>
                    <cfquery name="get_detail" datasource="#dsn3#">
                        SELECT #dsn_alias#.Get_Dynamic_Language(BASKET_ROW_ID,'#session.ep.language#','SETUP_BASKET_ROWS','TITLE_NAME',NULL,NULL,TITLE_NAME) AS TITLE_NAME,LINE_ORDER_NO,IS_SELECTED,GENISLIK,IS_READONLY,B_TYPE,BASKET_ROW_ID FROM (SELECT * FROM SETUP_BASKET_ROWS WHERE BASKET_ID = #GET_BASKET.BASKET_ID# AND B_TYPE=1) AS XXX WHERE TITLE = 'disc_ount'
                    </cfquery>
                <cfelse>
                    <cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'disc_ount'</cfquery>
                </cfif>
                <td><input type="checkbox" name="module_content" id="module_content" value="disc_ount" <cfif len(get_detail.is_selected) and get_detail.is_selected eq 1> Checked </cfif>></td>
                <td><cfinput type="text" name="DISC_OUNT_sira" value="#get_detail.line_order_no#" style="width:25px" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>
                <td><cfinput type="text" name="DISC_OUNT_genislik" value="#get_detail.genislik#" style="width:35px" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>
                <td><input type="textbox" name="DISC_OUNT" id="DISC_OUNT" value="<cfoutput>#get_detail.title_name#</cfoutput>" maxlength="200"></td>
				<cfif x_show_language>
                    <td>
                        <cf_language_info 
                            table_name="SETUP_BASKET_ROWS" 
                            column_name="TITLE_NAME" 
                            column_id_value="#get_detail.BASKET_ROW_ID#" 
                            maxlength="500" 
                            datasource="#dsn3#" 
                            column_id="BASKET_ROW_ID" 
                            control_type="0">
                    </td>
                </cfif>
                <td><cf_get_lang_main no='229.İndirim'> 1</td>
            </tr>
            <tr>
				<cfif x_show_language>
                    <cfquery name="get_detail" datasource="#dsn3#">
                        SELECT #dsn_alias#.Get_Dynamic_Language(BASKET_ROW_ID,'#session.ep.language#','SETUP_BASKET_ROWS','TITLE_NAME',NULL,NULL,TITLE_NAME) AS TITLE_NAME,LINE_ORDER_NO,IS_SELECTED,GENISLIK,IS_READONLY,B_TYPE,BASKET_ROW_ID FROM (SELECT * FROM SETUP_BASKET_ROWS WHERE BASKET_ID = #GET_BASKET.BASKET_ID# AND B_TYPE=1) AS XXX WHERE TITLE = 'disc_ount2_'
                    </cfquery>
                <cfelse>
                    <cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'disc_ount2_'</cfquery>
                </cfif>
                <td><input type="checkbox" name="module_content" id="module_content" value="disc_ount2_" <cfif len(get_detail.is_selected) and get_detail.is_selected eq 1> Checked </cfif>></td>
                <td><cfinput type="text" name="DISC_OUNT2__sira" value="#get_detail.line_order_no#" style="width:25px" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>
                <td><cfinput type="text" name="DISC_OUNT2__genislik" value="#get_detail.genislik#" style="width:35px" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>
                <td><input type="textbox" name="DISC_OUNT2_" id="DISC_OUNT2_" value="<cfoutput>#get_detail.title_name#</cfoutput>" maxlength="200"></td>
				<cfif x_show_language>
                    <td>
                        <cf_language_info 
                            table_name="SETUP_BASKET_ROWS" 
                            column_name="TITLE_NAME" 
                            column_id_value="#get_detail.BASKET_ROW_ID#" 
                            maxlength="500" 
                            datasource="#dsn3#" 
                            column_id="BASKET_ROW_ID" 
                            control_type="0">
                    </td>
                </cfif>
                <td><cf_get_lang_main no='229.İndirim'> 2</td>
            </tr>
            <tr>
				<cfif x_show_language>
                    <cfquery name="get_detail" datasource="#dsn3#">
                        SELECT #dsn_alias#.Get_Dynamic_Language(BASKET_ROW_ID,'#session.ep.language#','SETUP_BASKET_ROWS','TITLE_NAME',NULL,NULL,TITLE_NAME) AS TITLE_NAME,LINE_ORDER_NO,IS_SELECTED,GENISLIK,IS_READONLY,B_TYPE,BASKET_ROW_ID FROM (SELECT * FROM SETUP_BASKET_ROWS WHERE BASKET_ID = #GET_BASKET.BASKET_ID# AND B_TYPE=1) AS XXX WHERE TITLE = 'disc_ount3_'
                    </cfquery>
                <cfelse>
                    <cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'disc_ount3_'</cfquery>
                </cfif>
                <td><input type="checkbox" name="module_content" id="module_content" value="disc_ount3_"<cfif len(get_detail.is_selected) and get_detail.is_selected eq 1> Checked </cfif>></td>
                <td><cfinput type="text" name="DISC_OUNT3__sira" value="#get_detail.line_order_no#" style="width:25px" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>
                <td><cfinput type="text" name="DISC_OUNT3__genislik" value="#get_detail.genislik#" style="width:35px" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>
                <td><input type="textbox" name="DISC_OUNT3_" id="DISC_OUNT3_" value="<cfoutput>#get_detail.title_name#</cfoutput>" maxlength="200"></td>
				<cfif x_show_language>
                    <td>
                        <cf_language_info 
                            table_name="SETUP_BASKET_ROWS" 
                            column_name="TITLE_NAME" 
                            column_id_value="#get_detail.BASKET_ROW_ID#" 
                            maxlength="500" 
                            datasource="#dsn3#" 
                            column_id="BASKET_ROW_ID" 
                            control_type="0">
                    </td>
                </cfif>
                <td><cf_get_lang_main no='229.İndirim'> 3</td>
            </tr>
            <tr>
				<cfif x_show_language>
                    <cfquery name="get_detail" datasource="#dsn3#">
                        SELECT #dsn_alias#.Get_Dynamic_Language(BASKET_ROW_ID,'#session.ep.language#','SETUP_BASKET_ROWS','TITLE_NAME',NULL,NULL,TITLE_NAME) AS TITLE_NAME,LINE_ORDER_NO,IS_SELECTED,GENISLIK,IS_READONLY,B_TYPE,BASKET_ROW_ID FROM (SELECT * FROM SETUP_BASKET_ROWS WHERE BASKET_ID = #GET_BASKET.BASKET_ID# AND B_TYPE=1) AS XXX WHERE TITLE = 'disc_ount4_'
                    </cfquery>
                <cfelse>
                    <cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'disc_ount4_'</cfquery>
                </cfif>
                <td><input type="checkbox" name="module_content" id="module_content" value="disc_ount4_" <cfif len(get_detail.is_selected) and get_detail.is_selected eq 1> Checked </cfif>></td>
                <td><cfinput type="text" name="DISC_OUNT4__sira" value="#get_detail.line_order_no#" style="width:25px" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>
                <td><cfinput type="text" name="DISC_OUNT4__genislik" value="#get_detail.genislik#" style="width:35px" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>
                <td><input type="textbox" name="DISC_OUNT4_" id="DISC_OUNT4_" value="<cfoutput>#get_detail.title_name#</cfoutput>" maxlength="200"></td>
				<cfif x_show_language>
                    <td>
                        <cf_language_info 
                            table_name="SETUP_BASKET_ROWS" 
                            column_name="TITLE_NAME" 
                            column_id_value="#get_detail.BASKET_ROW_ID#" 
                            maxlength="500" 
                            datasource="#dsn3#" 
                            column_id="BASKET_ROW_ID" 
                            control_type="0">
                    </td>
                </cfif>
                <td><cf_get_lang_main no='229.İndirim'> 4</td>
            </tr>
            <tr>
				<cfif x_show_language>
                    <cfquery name="get_detail" datasource="#dsn3#">
                        SELECT #dsn_alias#.Get_Dynamic_Language(BASKET_ROW_ID,'#session.ep.language#','SETUP_BASKET_ROWS','TITLE_NAME',NULL,NULL,TITLE_NAME) AS TITLE_NAME,LINE_ORDER_NO,IS_SELECTED,GENISLIK,IS_READONLY,B_TYPE,BASKET_ROW_ID FROM (SELECT * FROM SETUP_BASKET_ROWS WHERE BASKET_ID = #GET_BASKET.BASKET_ID# AND B_TYPE=1) AS XXX WHERE TITLE = 'disc_ount5_'
                    </cfquery>
                <cfelse>
                    <cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'disc_ount5_'</cfquery>
                </cfif>
                <td><input type="checkbox" name="module_content" id="module_content" value="disc_ount5_" <cfif len(get_detail.is_selected) and get_detail.is_selected eq 1> Checked </cfif>></td>
                <td><cfinput type="text" name="DISC_OUNT5__sira" value="#get_detail.line_order_no#" style="width:25px" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>
                <td><cfinput type="text" name="DISC_OUNT5__genislik" value="#get_detail.genislik#" style="width:35px" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>
                <td><input type="textbox" name="DISC_OUNT5_" id="DISC_OUNT5_" value="<cfoutput>#get_detail.title_name#</cfoutput>" maxlength="200"></td>
				<cfif x_show_language>
                    <td>
                        <cf_language_info 
                            table_name="SETUP_BASKET_ROWS" 
                            column_name="TITLE_NAME" 
                            column_id_value="#get_detail.BASKET_ROW_ID#" 
                            maxlength="500" 
                            datasource="#dsn3#" 
                            column_id="BASKET_ROW_ID" 
                            control_type="0">
                    </td>
                </cfif>
                <td><cf_get_lang_main no='229.İndirim'> 5</td>
            </tr>
            <tr>
				<cfif x_show_language>
                    <cfquery name="get_detail" datasource="#dsn3#">
                        SELECT #dsn_alias#.Get_Dynamic_Language(BASKET_ROW_ID,'#session.ep.language#','SETUP_BASKET_ROWS','TITLE_NAME',NULL,NULL,TITLE_NAME) AS TITLE_NAME,LINE_ORDER_NO,IS_SELECTED,GENISLIK,IS_READONLY,B_TYPE,BASKET_ROW_ID FROM (SELECT * FROM SETUP_BASKET_ROWS WHERE BASKET_ID = #GET_BASKET.BASKET_ID# AND B_TYPE=1) AS XXX WHERE TITLE = 'disc_ount6_'
                    </cfquery>
                <cfelse>
                    <cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'disc_ount6_'</cfquery>
                </cfif>
                <td><input type="checkbox" name="module_content" id="module_content" value="disc_ount6_" <cfif len(get_detail.is_selected) and get_detail.is_selected eq 1> Checked </cfif>></td>
                <td><cfinput type="text" name="DISC_OUNT6__sira" value="#get_detail.line_order_no#" style="width:25px" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>
                <td><cfinput type="text" name="DISC_OUNT6__genislik" value="#get_detail.genislik#" style="width:35px" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>
                <td><input type="textbox" name="DISC_OUNT6_" id="DISC_OUNT6_" value="<cfoutput>#get_detail.title_name#</cfoutput>" maxlength="200"></td>
				<cfif x_show_language>
                    <td>
                        <cf_language_info 
                            table_name="SETUP_BASKET_ROWS" 
                            column_name="TITLE_NAME" 
                            column_id_value="#get_detail.BASKET_ROW_ID#" 
                            maxlength="500" 
                            datasource="#dsn3#" 
                            column_id="BASKET_ROW_ID" 
                            control_type="0">
                    </td>
                </cfif>
                <td><cf_get_lang_main no='229.İndirim'> 6</td>
            </tr>
            <tr>
				<cfif x_show_language>
                    <cfquery name="get_detail" datasource="#dsn3#">
                        SELECT #dsn_alias#.Get_Dynamic_Language(BASKET_ROW_ID,'#session.ep.language#','SETUP_BASKET_ROWS','TITLE_NAME',NULL,NULL,TITLE_NAME) AS TITLE_NAME,LINE_ORDER_NO,IS_SELECTED,GENISLIK,IS_READONLY,B_TYPE,BASKET_ROW_ID FROM (SELECT * FROM SETUP_BASKET_ROWS WHERE BASKET_ID = #GET_BASKET.BASKET_ID# AND B_TYPE=1) AS XXX WHERE TITLE = 'disc_ount7_'
                    </cfquery>
                <cfelse>
                    <cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'disc_ount7_'</cfquery>
                </cfif>
                <td><input type="checkbox" name="module_content" id="module_content" value="disc_ount7_" <cfif len(get_detail.is_selected) and get_detail.is_selected eq 1> Checked </cfif>></td>
                <td><cfinput type="text" name="DISC_OUNT7__sira" value="#get_detail.line_order_no#" style="width:25px" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>
                <td><cfinput type="text" name="DISC_OUNT7__genislik" value="#get_detail.genislik#" style="width:35px" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>
                <td><input type="textbox" name="DISC_OUNT7_" id="DISC_OUNT7_" value="<cfoutput>#get_detail.title_name#</cfoutput>" maxlength="200"></td>
				<cfif x_show_language>
                    <td>
                        <cf_language_info 
                            table_name="SETUP_BASKET_ROWS" 
                            column_name="TITLE_NAME" 
                            column_id_value="#get_detail.BASKET_ROW_ID#" 
                            maxlength="500" 
                            datasource="#dsn3#" 
                            column_id="BASKET_ROW_ID" 
                            control_type="0">
                    </td>
                </cfif>
                <td><cf_get_lang_main no='229.İndirim'> 7</td>
            </tr>
            <tr>
				<cfif x_show_language>
                    <cfquery name="get_detail" datasource="#dsn3#">
                        SELECT #dsn_alias#.Get_Dynamic_Language(BASKET_ROW_ID,'#session.ep.language#','SETUP_BASKET_ROWS','TITLE_NAME',NULL,NULL,TITLE_NAME) AS TITLE_NAME,LINE_ORDER_NO,IS_SELECTED,GENISLIK,IS_READONLY,B_TYPE,BASKET_ROW_ID FROM (SELECT * FROM SETUP_BASKET_ROWS WHERE BASKET_ID = #GET_BASKET.BASKET_ID# AND B_TYPE=1) AS XXX WHERE TITLE = 'disc_ount8_'
                    </cfquery>
                <cfelse>
                    <cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'disc_ount8_'</cfquery>
                </cfif>
                <td><input type="checkbox" name="module_content" id="module_content" value="disc_ount8_" <cfif len(get_detail.is_selected) and get_detail.is_selected eq 1> Checked </cfif>></td>
                <td><cfinput type="text" name="DISC_OUNT8__sira" value="#get_detail.line_order_no#" style="width:25px" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>
                <td><cfinput type="text" name="DISC_OUNT8__genislik" value="#get_detail.genislik#" style="width:35px" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>
                <td><input type="textbox" name="DISC_OUNT8_" id="DISC_OUNT8_" value="<cfoutput>#get_detail.title_name#</cfoutput>" maxlength="200"></td>
				<cfif x_show_language>
                    <td>
                        <cf_language_info 
                            table_name="SETUP_BASKET_ROWS" 
                            column_name="TITLE_NAME" 
                            column_id_value="#get_detail.BASKET_ROW_ID#" 
                            maxlength="500" 
                            datasource="#dsn3#" 
                            column_id="BASKET_ROW_ID" 
                            control_type="0">
                    </td>
                </cfif>
                <td><cf_get_lang_main no='229.İndirim'> 8</td>
            </tr>
            <tr>
				<cfif x_show_language>
                    <cfquery name="get_detail" datasource="#dsn3#">
                        SELECT #dsn_alias#.Get_Dynamic_Language(BASKET_ROW_ID,'#session.ep.language#','SETUP_BASKET_ROWS','TITLE_NAME',NULL,NULL,TITLE_NAME) AS TITLE_NAME,LINE_ORDER_NO,IS_SELECTED,GENISLIK,IS_READONLY,B_TYPE,BASKET_ROW_ID FROM (SELECT * FROM SETUP_BASKET_ROWS WHERE BASKET_ID = #GET_BASKET.BASKET_ID# AND B_TYPE=1) AS XXX WHERE TITLE = 'disc_ount9_'
                    </cfquery>
                <cfelse>
                    <cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'disc_ount9_'</cfquery>
                </cfif>
                <td><input type="checkbox" name="module_content" id="module_content" value="disc_ount9_" <cfif len(get_detail.is_selected) and get_detail.is_selected eq 1> Checked </cfif>></td>
                <td><cfinput type="text" name="DISC_OUNT9__sira" value="#get_detail.line_order_no#" style="width:25px" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>
                <td><cfinput type="text" name="DISC_OUNT9__genislik" value="#get_detail.genislik#" style="width:35px" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>
                <td><input type="textbox" name="DISC_OUNT9_" id="DISC_OUNT9_" value="<cfoutput>#get_detail.title_name#</cfoutput>" maxlength="200"></td>
				<cfif x_show_language>
                    <td>
                        <cf_language_info 
                            table_name="SETUP_BASKET_ROWS" 
                            column_name="TITLE_NAME" 
                            column_id_value="#get_detail.BASKET_ROW_ID#" 
                            maxlength="500" 
                            datasource="#dsn3#" 
                            column_id="BASKET_ROW_ID" 
                            control_type="0">
                    </td>
                </cfif>
                <td><cf_get_lang_main no='229.İndirim'> 9 </td>
            </tr>	
            <tr>
				<cfif x_show_language>
                    <cfquery name="get_detail" datasource="#dsn3#">
                        SELECT #dsn_alias#.Get_Dynamic_Language(BASKET_ROW_ID,'#session.ep.language#','SETUP_BASKET_ROWS','TITLE_NAME',NULL,NULL,TITLE_NAME) AS TITLE_NAME,LINE_ORDER_NO,IS_SELECTED,GENISLIK,IS_READONLY,B_TYPE,BASKET_ROW_ID FROM (SELECT * FROM SETUP_BASKET_ROWS WHERE BASKET_ID = #GET_BASKET.BASKET_ID# AND B_TYPE=1) AS XXX WHERE TITLE = 'disc_ount10_'
                    </cfquery>
                <cfelse>
                    <cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'disc_ount10_'</cfquery>
                </cfif>
                <td><input type="checkbox" name="module_content" id="module_content" value="disc_ount10_" <cfif len(get_detail.is_selected) and get_detail.is_selected eq 1> Checked </cfif>></td>
                <td><cfinput type="text" name="DISC_OUNT10__sira" value="#get_detail.line_order_no#" style="width:25px" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>
                <td><cfinput type="text" name="DISC_OUNT10__genislik" value="#get_detail.genislik#" style="width:35px" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>
                <td><input type="textbox" name="DISC_OUNT10_" id="DISC_OUNT10_" value="<cfoutput>#get_detail.title_name#</cfoutput>" maxlength="200"></td>
				<cfif x_show_language>
                    <td>
                        <cf_language_info 
                            table_name="SETUP_BASKET_ROWS" 
                            column_name="TITLE_NAME" 
                            column_id_value="#get_detail.BASKET_ROW_ID#" 
                            maxlength="500" 
                            datasource="#dsn3#" 
                            column_id="BASKET_ROW_ID" 
                            control_type="0">
                    </td>
                </cfif>
                <td><cf_get_lang_main no='229.İndirim'> 10 </td>
            </tr>							
            <tr>
				<cfif x_show_language>
                    <cfquery name="get_detail" datasource="#dsn3#">
                        SELECT #dsn_alias#.Get_Dynamic_Language(BASKET_ROW_ID,'#session.ep.language#','SETUP_BASKET_ROWS','TITLE_NAME',NULL,NULL,TITLE_NAME) AS TITLE_NAME,LINE_ORDER_NO,IS_SELECTED,GENISLIK,IS_READONLY,B_TYPE,BASKET_ROW_ID FROM (SELECT * FROM SETUP_BASKET_ROWS WHERE BASKET_ID = #GET_BASKET.BASKET_ID# AND B_TYPE=1) AS XXX WHERE TITLE = 'price_net'
                    </cfquery>
                <cfelse>
                    <cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'price_net'</cfquery>
                </cfif>
                <td><input type="checkbox" name="module_content" id="module_content" value="price_net" <cfif len(get_detail.is_selected) and get_detail.is_selected eq 1> Checked </cfif>></td>
                <td><cfinput type="text" name="PRICE_NET_sira" value="#get_detail.line_order_no#" style="width:25px" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>
                <td><cfinput type="text" name="PRICE_NET_genislik" value="#get_detail.genislik#" style="width:35px" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>
                <td><input type="textbox" name="PRICE_NET" id="PRICE_NET" value="<cfoutput>#get_detail.title_name#</cfoutput>" maxlength="200"></td>
				<cfif x_show_language>
                    <td>
                        <cf_language_info 
                            table_name="SETUP_BASKET_ROWS" 
                            column_name="TITLE_NAME" 
                            column_id_value="#get_detail.BASKET_ROW_ID#" 
                            maxlength="500" 
                            datasource="#dsn3#" 
                            column_id="BASKET_ROW_ID" 
                            control_type="0">
                    </td>
                </cfif>
                <td><cf_get_lang_main no='671.Net'> <cf_get_lang_main no='672.Fiyat'> </td>
            </tr>		
            <tr>
				<cfif x_show_language>
                    <cfquery name="get_detail" datasource="#dsn3#">
                        SELECT #dsn_alias#.Get_Dynamic_Language(BASKET_ROW_ID,'#session.ep.language#','SETUP_BASKET_ROWS','TITLE_NAME',NULL,NULL,TITLE_NAME) AS TITLE_NAME,LINE_ORDER_NO,IS_SELECTED,GENISLIK,IS_READONLY,B_TYPE,BASKET_ROW_ID FROM (SELECT * FROM SETUP_BASKET_ROWS WHERE BASKET_ID = #GET_BASKET.BASKET_ID# AND B_TYPE=1) AS XXX WHERE TITLE = 'price_net_doviz'
                    </cfquery>
                <cfelse>
                    <cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'price_net_doviz'</cfquery>
                </cfif>
                <td><input type="checkbox" name="module_content" id="module_content" value="price_net_doviz" <cfif len(get_detail.is_selected) and get_detail.is_selected eq 1> Checked </cfif>></td>
                <td><cfinput type="text" name="PRICE_NET_DOVIZ_sira" value="#get_detail.line_order_no#" style="width:25px" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>
                <td><cfinput type="text" name="PRICE_NET_DOVIZ_genislik" value="#get_detail.genislik#" style="width:35px" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>
                <td><input type="textbox" name="PRICE_NET_DOVIZ" id="PRICE_NET_DOVIZ" value="<cfoutput>#get_detail.title_name#</cfoutput>" maxlength="200"></td>
				<cfif x_show_language>
                    <td>
                        <cf_language_info 
                            table_name="SETUP_BASKET_ROWS" 
                            column_name="TITLE_NAME" 
                            column_id_value="#get_detail.BASKET_ROW_ID#" 
                            maxlength="500" 
                            datasource="#dsn3#" 
                            column_id="BASKET_ROW_ID" 
                            control_type="0">
                    </td>
                </cfif>
                <td><cf_get_lang no='744.Net Döviz'> <cf_get_lang no='824.Fiyat (Döviz Fiyata Bağlı)'></td>
            </tr>
            <cfif listfind('1,2,3,4,5,6,10,11,14,15,17,18,20,21,37,38,51',get_basket.basket_id)>
                <tr>
                    <cfif x_show_language>
                        <cfquery name="get_detail" datasource="#dsn3#">
                            SELECT #dsn_alias#.Get_Dynamic_Language(BASKET_ROW_ID,'#session.ep.language#','SETUP_BASKET_ROWS','TITLE_NAME',NULL,NULL,TITLE_NAME) AS TITLE_NAME,LINE_ORDER_NO,IS_SELECTED,GENISLIK,IS_READONLY,B_TYPE,BASKET_ROW_ID FROM (SELECT * FROM SETUP_BASKET_ROWS WHERE BASKET_ID = #GET_BASKET.BASKET_ID# AND B_TYPE=1) AS XXX WHERE TITLE = 'number_of_installment'
                        </cfquery>
                    <cfelse>
                        <cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'number_of_installment'</cfquery>
                    </cfif>
                    <td><input type="checkbox" name="module_content" id="module_content" value="number_of_installment" <cfif len(get_detail.is_selected) and get_detail.is_selected eq 1>Checked </cfif><cfif get_basket.basket_id eq 52>disabled</cfif>></td>
                    <td><cfinput type="text" name="number_of_installment_sira" value="#get_detail.line_order_no#" style="width:25px" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>
                    <td><cfinput type="text" name="number_of_installment_genislik" value="#get_detail.genislik#" style="width:35px" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>
                    <td><input type="textbox" name="number_of_installment" id="number_of_installment" value="<cfoutput>#get_detail.title_name#</cfoutput>" maxlength="200"></td>
                    <cfif x_show_language>
                        <td>
                            <cf_language_info 
                                table_name="SETUP_BASKET_ROWS" 
                                column_name="TITLE_NAME" 
                                column_id_value="#get_detail.BASKET_ROW_ID#" 
                                maxlength="500" 
                                datasource="#dsn3#" 
                                column_id="BASKET_ROW_ID" 
                                control_type="0">
                        </td>
                    </cfif>
                    <td><cf_get_lang no='506.Taksit Sayısı'> </td>
                </tr>	
            </cfif>
            <tr>
				<cfif x_show_language>
                    <cfquery name="get_detail" datasource="#dsn3#">
                        SELECT #dsn_alias#.Get_Dynamic_Language(BASKET_ROW_ID,'#session.ep.language#','SETUP_BASKET_ROWS','TITLE_NAME',NULL,NULL,TITLE_NAME) AS TITLE_NAME,LINE_ORDER_NO,IS_SELECTED,GENISLIK,IS_READONLY,B_TYPE,BASKET_ROW_ID FROM (SELECT * FROM SETUP_BASKET_ROWS WHERE BASKET_ID = #GET_BASKET.BASKET_ID# AND B_TYPE=1) AS XXX WHERE TITLE = 'Duedate'
                    </cfquery>
                <cfelse>
                    <cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'Duedate'</cfquery>
                </cfif>
                <td><input type="checkbox" name="module_content" id="module_content" value="Duedate" <cfif len(get_detail.is_selected) and get_detail.is_selected eq 1> Checked </cfif><cfif get_basket.basket_id eq 52>disabled</cfif>></td>
                <td><cfinput type="text" name="DUEDATE_sira" value="#get_detail.line_order_no#" style="width:25px" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>
                <td><cfinput type="text" name="DUEDATE_genislik" value="#get_detail.genislik#" style="width:35px" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>
                <td><input type="textbox" name="DUEDATE" id="DUEDATE" value="<cfoutput>#get_detail.title_name#</cfoutput>" maxlength="200"></td>
				<cfif x_show_language>
                    <td>
                        <cf_language_info 
                            table_name="SETUP_BASKET_ROWS" 
                            column_name="TITLE_NAME" 
                            column_id_value="#get_detail.BASKET_ROW_ID#" 
                            maxlength="500" 
                            datasource="#dsn3#" 
                            column_id="BASKET_ROW_ID" 
                            control_type="0">
                    </td>
                </cfif>
                <td><cf_get_lang_main no='228.Vade'> (<cf_get_lang no='1065.Satırın Vadesi Gün'>) (<cf_get_lang no='1066.Stok açılış fişinde fiziksel stok yaşı gün olarak kullanılır'>)</td>
            </tr>
            <tr>
				<cfif x_show_language>
                    <cfquery name="get_detail" datasource="#dsn3#">
                        SELECT #dsn_alias#.Get_Dynamic_Language(BASKET_ROW_ID,'#session.ep.language#','SETUP_BASKET_ROWS','TITLE_NAME',NULL,NULL,TITLE_NAME) AS TITLE_NAME,LINE_ORDER_NO,IS_SELECTED,GENISLIK,IS_READONLY,B_TYPE,BASKET_ROW_ID FROM (SELECT * FROM SETUP_BASKET_ROWS WHERE BASKET_ID = #GET_BASKET.BASKET_ID# AND B_TYPE=1) AS XXX WHERE TITLE = 'net_maliyet'
                    </cfquery>
                <cfelse>
                    <cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'net_maliyet'</cfquery>
                </cfif>				
                <td><input type="checkbox" name="module_content" id="module_content" value="net_maliyet" <cfif len(get_detail.is_selected) and get_detail.is_selected eq 1> Checked </cfif><cfif get_basket.basket_id eq 52>disabled</cfif>></td>
                <td><cfinput type="text" name="net_maliyet_sira" value="#get_detail.line_order_no#" style="width:25px" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>
                <td><cfinput type="text" name="net_maliyet_genislik" value="#get_detail.genislik#" style="width:35px" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>
                <td><input type="textbox" name="net_maliyet" id="net_maliyet" value="<cfoutput>#get_detail.title_name#</cfoutput>" maxlength="200"></td>
				<cfif x_show_language>
                    <td>
                        <cf_language_info 
                            table_name="SETUP_BASKET_ROWS" 
                            column_name="TITLE_NAME" 
                            column_id_value="#get_detail.BASKET_ROW_ID#" 
                            maxlength="500" 
                            datasource="#dsn3#" 
                            column_id="BASKET_ROW_ID" 
                            control_type="0">
                    </td>
                </cfif>
                <td><cf_get_lang no='680.Net Maliyet'></td>
            </tr>				
            <tr>
				<cfif x_show_language>
                    <cfquery name="get_detail" datasource="#dsn3#">
                        SELECT #dsn_alias#.Get_Dynamic_Language(BASKET_ROW_ID,'#session.ep.language#','SETUP_BASKET_ROWS','TITLE_NAME',NULL,NULL,TITLE_NAME) AS TITLE_NAME,LINE_ORDER_NO,IS_SELECTED,GENISLIK,IS_READONLY,B_TYPE,BASKET_ROW_ID FROM (SELECT * FROM SETUP_BASKET_ROWS WHERE BASKET_ID = #GET_BASKET.BASKET_ID# AND B_TYPE=1) AS XXX WHERE TITLE = 'extra_cost'
                    </cfquery>
                <cfelse>
                    <cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'extra_cost'</cfquery>
                </cfif>			
                <td><input type="checkbox" name="module_content" id="module_content" value="extra_cost" <cfif len(get_detail.is_selected) and get_detail.is_selected eq 1> Checked </cfif><cfif get_basket.basket_id eq 52>disabled</cfif>></td>
                <td><cfinput type="text" name="extra_cost_sira" value="#get_detail.line_order_no#" style="width:25px" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>
                <td><cfinput type="text" name="extra_cost_genislik" value="#get_detail.genislik#" style="width:35px" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>
                <td><input type="textbox" name="extra_cost" id="extra_cost" value="<cfoutput>#get_detail.title_name#</cfoutput>" maxlength="200"></td>
				<cfif x_show_language>
                    <td>
                        <cf_language_info 
                            table_name="SETUP_BASKET_ROWS" 
                            column_name="TITLE_NAME" 
                            column_id_value="#get_detail.BASKET_ROW_ID#" 
                            maxlength="500" 
                            datasource="#dsn3#" 
                            column_id="BASKET_ROW_ID" 
                            control_type="0">
                    </td>
                </cfif>
                <td><cf_get_lang no='993.Ek Maliyet'></td>
            </tr>
            <tr>
				<cfif x_show_language>
                    <cfquery name="get_detail" datasource="#dsn3#">
                        SELECT #dsn_alias#.Get_Dynamic_Language(BASKET_ROW_ID,'#session.ep.language#','SETUP_BASKET_ROWS','TITLE_NAME',NULL,NULL,TITLE_NAME) AS TITLE_NAME,LINE_ORDER_NO,IS_SELECTED,GENISLIK,IS_READONLY,B_TYPE,BASKET_ROW_ID FROM (SELECT * FROM SETUP_BASKET_ROWS WHERE BASKET_ID = #GET_BASKET.BASKET_ID# AND B_TYPE=1) AS XXX WHERE TITLE = 'extra_cost_rate'
                    </cfquery>
                <cfelse>
                    <cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'extra_cost_rate'</cfquery>
                </cfif>			
                <td><input type="checkbox" name="module_content" id="module_content" value="extra_cost_rate" <cfif len(get_detail.is_selected) and get_detail.is_selected eq 1> Checked </cfif><cfif get_basket.basket_id eq 52>disabled</cfif>></td>
                <td><cfinput type="text" name="extra_cost_rate_sira" value="#get_detail.line_order_no#" style="width:25px" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>
                <td><cfinput type="text" name="extra_cost_rate_genislik" value="#get_detail.genislik#" style="width:35px" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>
                <td><input type="textbox" name="extra_cost_rate" id="extra_cost_rate" value="<cfoutput>#get_detail.title_name#</cfoutput>" maxlength="200"></td>
				<cfif x_show_language>
                    <td>
                        <cf_language_info 
                            table_name="SETUP_BASKET_ROWS" 
                            column_name="TITLE_NAME" 
                            column_id_value="#get_detail.BASKET_ROW_ID#" 
                            maxlength="500" 
                            datasource="#dsn3#" 
                            column_id="BASKET_ROW_ID" 
                            control_type="0">
                    </td>
                </cfif>
                <td><cf_get_lang no='1633.Ek Maliyet Oranı'></td>
            </tr>
            <tr>
				<cfif x_show_language>
                    <cfquery name="get_detail" datasource="#dsn3#">
                        SELECT #dsn_alias#.Get_Dynamic_Language(BASKET_ROW_ID,'#session.ep.language#','SETUP_BASKET_ROWS','TITLE_NAME',NULL,NULL,TITLE_NAME) AS TITLE_NAME,LINE_ORDER_NO,IS_SELECTED,GENISLIK,IS_READONLY,B_TYPE,BASKET_ROW_ID FROM (SELECT * FROM SETUP_BASKET_ROWS WHERE BASKET_ID = #GET_BASKET.BASKET_ID# AND B_TYPE=1) AS XXX WHERE TITLE = 'row_cost_total'
                    </cfquery>
                <cfelse>
                    <cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'row_cost_total'</cfquery>
                </cfif>
                <td><input type="checkbox" name="module_content" id="module_content" value="row_cost_total" <cfif len(get_detail.is_selected) and get_detail.is_selected eq 1> Checked </cfif><cfif get_basket.basket_id eq 52>disabled</cfif>></td>
                <td><cfinput type="text" name="row_cost_total_sira" value="#get_detail.line_order_no#" style="width:25px" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>
                <td><cfinput type="text" name="row_cost_total_genislik" value="#get_detail.genislik#" style="width:35px" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>
                <td><input type="textbox" name="row_cost_total" id="row_cost_total" value="<cfoutput>#get_detail.title_name#</cfoutput>" maxlength="200"></td>
				<cfif x_show_language>
                    <td>
                        <cf_language_info 
                            table_name="SETUP_BASKET_ROWS" 
                            column_name="TITLE_NAME" 
                            column_id_value="#get_detail.BASKET_ROW_ID#" 
                            maxlength="500" 
                            datasource="#dsn3#" 
                            column_id="BASKET_ROW_ID" 
                            control_type="0">
                    </td>
                </cfif>
                <td><cf_get_lang no='1632.Toplam Maliyet'></td>
            </tr>
            <tr>
				<cfif x_show_language>
                    <cfquery name="get_detail" datasource="#dsn3#">
                        SELECT #dsn_alias#.Get_Dynamic_Language(BASKET_ROW_ID,'#session.ep.language#','SETUP_BASKET_ROWS','TITLE_NAME',NULL,NULL,TITLE_NAME) AS TITLE_NAME,LINE_ORDER_NO,IS_SELECTED,GENISLIK,IS_READONLY,B_TYPE,BASKET_ROW_ID FROM (SELECT * FROM SETUP_BASKET_ROWS WHERE BASKET_ID = #GET_BASKET.BASKET_ID# AND B_TYPE=1) AS XXX WHERE TITLE = 'marj'
                    </cfquery>
                <cfelse>
                    <cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'marj'</cfquery>
                </cfif>
                <td><input type="checkbox" name="module_content" id="module_content" value="marj" <cfif len(get_detail.is_selected) and get_detail.is_selected eq 1> Checked </cfif><cfif get_basket.basket_id eq 52>disabled</cfif>></td>
                <td><cfinput type="text" name="marj_sira" value="#get_detail.line_order_no#" style="width:25px" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>
                <td><cfinput type="text" name="marj_genislik" value="#get_detail.genislik#" style="width:35px" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>
                <td><input type="textbox" name="marj" id="marj" value="<cfoutput>#get_detail.title_name#</cfoutput>" maxlength="200"></td>
				<cfif x_show_language>
                    <td>
                        <cf_language_info 
                            table_name="SETUP_BASKET_ROWS" 
                            column_name="TITLE_NAME" 
                            column_id_value="#get_detail.BASKET_ROW_ID#" 
                            maxlength="500" 
                            datasource="#dsn3#" 
                            column_id="BASKET_ROW_ID" 
                            control_type="0">
                    </td>
                </cfif>
                <td><cf_get_lang no='544.Marj'></td>
            </tr>					
            <tr>
				<cfif x_show_language>
                    <cfquery name="get_detail" datasource="#dsn3#">
                        SELECT #dsn_alias#.Get_Dynamic_Language(BASKET_ROW_ID,'#session.ep.language#','SETUP_BASKET_ROWS','TITLE_NAME',NULL,NULL,TITLE_NAME) AS TITLE_NAME,LINE_ORDER_NO,IS_SELECTED,GENISLIK,IS_READONLY,B_TYPE,BASKET_ROW_ID FROM (SELECT * FROM SETUP_BASKET_ROWS WHERE BASKET_ID = #GET_BASKET.BASKET_ID# AND B_TYPE=1) AS XXX WHERE TITLE = 'row_total'
                    </cfquery>
                <cfelse>
                    <cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'row_total'</cfquery>
                </cfif>
                <td><input type="checkbox" name="module_content" id="module_content" value="row_total" <cfif len(get_detail.is_selected) and get_detail.is_selected eq 1>Checked </cfif>></td>
                <td><cfinput type="text" name="ROW_TOTAL_sira" value="#get_detail.line_order_no#" style="width:25px" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>
                <td><cfinput type="text" name="ROW_TOTAL_genislik" value="#get_detail.genislik#" style="width:35px" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>
                <td><input type="textbox" name="ROW_TOTAL" id="ROW_TOTAL" value="<cfoutput>#get_detail.title_name#</cfoutput>" maxlength="200"></td>
				<cfif x_show_language>
                    <td>
                        <cf_language_info 
                            table_name="SETUP_BASKET_ROWS" 
                            column_name="TITLE_NAME" 
                            column_id_value="#get_detail.BASKET_ROW_ID#" 
                            maxlength="500" 
                            datasource="#dsn3#" 
                            column_id="BASKET_ROW_ID" 
                            control_type="0">
                    </td>
                </cfif>
                <td><cf_get_lang no='825.Satır Toplamı(Fiyata Bağlı)'></td>
            </tr>
            <tr>
				<cfif x_show_language>
                    <cfquery name="get_detail" datasource="#dsn3#">
                        SELECT #dsn_alias#.Get_Dynamic_Language(BASKET_ROW_ID,'#session.ep.language#','SETUP_BASKET_ROWS','TITLE_NAME',NULL,NULL,TITLE_NAME) AS TITLE_NAME,LINE_ORDER_NO,IS_SELECTED,GENISLIK,IS_READONLY,B_TYPE,BASKET_ROW_ID FROM (SELECT * FROM SETUP_BASKET_ROWS WHERE BASKET_ID = #GET_BASKET.BASKET_ID# AND B_TYPE=1) AS XXX WHERE TITLE = 'row_nettotal'
                    </cfquery>
                <cfelse>
                    <cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'row_nettotal'</cfquery>
                </cfif>
                <td><input type="checkbox" name="module_content" id="module_content" value="row_nettotal" <cfif len(get_detail.is_selected) and get_detail.is_selected eq 1>Checked </cfif>></td>
                <td><cfinput type="text" name="ROW_NETTOTAL_sira" value="#get_detail.line_order_no#" style="width:25px" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>
                <td><cfinput type="text" name="ROW_NETTOTAL_genislik" value="#get_detail.genislik#" style="width:35px" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>
                <td><input type="textbox" name="ROW_NETTOTAL" id="ROW_NETTOTAL" value="<cfoutput>#get_detail.title_name#</cfoutput>" maxlength="200"></td>
				<cfif x_show_language>
                    <td>
                        <cf_language_info 
                            table_name="SETUP_BASKET_ROWS" 
                            column_name="TITLE_NAME" 
                            column_id_value="#get_detail.BASKET_ROW_ID#" 
                            maxlength="500" 
                            datasource="#dsn3#" 
                            column_id="BASKET_ROW_ID" 
                            control_type="0">
                    </td>
                </cfif>
                <td><cf_get_lang no='826.Net Satır Toplamı(Fiyata Bağlı)'></td>
            </tr>
            <tr>
				<cfif x_show_language>
                    <cfquery name="get_detail" datasource="#dsn3#">
                        SELECT #dsn_alias#.Get_Dynamic_Language(BASKET_ROW_ID,'#session.ep.language#','SETUP_BASKET_ROWS','TITLE_NAME',NULL,NULL,TITLE_NAME) AS TITLE_NAME,LINE_ORDER_NO,IS_SELECTED,GENISLIK,IS_READONLY,B_TYPE,BASKET_ROW_ID FROM (SELECT * FROM SETUP_BASKET_ROWS WHERE BASKET_ID = #GET_BASKET.BASKET_ID# AND B_TYPE=1) AS XXX WHERE TITLE = 'row_taxtotal'
                    </cfquery>
                <cfelse>
                    <cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'row_taxtotal'</cfquery>
                </cfif>
                <td><input type="checkbox" name="module_content" id="module_content" value="row_taxtotal" <cfif len(get_detail.is_selected) and get_detail.is_selected eq 1>Checked </cfif>></td>
                <td><cfinput type="text" name="ROW_TAXTOTAL_sira" value="#get_detail.line_order_no#" style="width:25px" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>
                <td><cfinput type="text" name="ROW_TAXTOTAL_genislik" value="#get_detail.genislik#" style="width:35px" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>
                <td><input type="textbox" name="ROW_TAXTOTAL" id="ROW_TAXTOTAL" value="<cfoutput>#get_detail.title_name#</cfoutput>" maxlength="200"></td>
				<cfif x_show_language>
                    <td>
                        <cf_language_info 
                            table_name="SETUP_BASKET_ROWS" 
                            column_name="TITLE_NAME" 
                            column_id_value="#get_detail.BASKET_ROW_ID#" 
                            maxlength="500" 
                            datasource="#dsn3#" 
                            column_id="BASKET_ROW_ID" 
                            control_type="0">
                    </td>
                </cfif>
                <td><cf_get_lang no='827.Satır Vergi Toplamı(Fiyat ve KDV ye Bağlı)'></td>
            </tr>
            <cfif not listfind('12',get_basket.basket_id)>
                <tr>
                    <cfif x_show_language>
                        <cfquery name="get_detail" datasource="#dsn3#">
                            SELECT #dsn_alias#.Get_Dynamic_Language(BASKET_ROW_ID,'#session.ep.language#','SETUP_BASKET_ROWS','TITLE_NAME',NULL,NULL,TITLE_NAME) AS TITLE_NAME,LINE_ORDER_NO,IS_SELECTED,GENISLIK,IS_READONLY,B_TYPE,BASKET_ROW_ID FROM (SELECT * FROM SETUP_BASKET_ROWS WHERE BASKET_ID = #GET_BASKET.BASKET_ID# AND B_TYPE=1) AS XXX WHERE TITLE = 'row_otvtotal'
                        </cfquery>
                    <cfelse>
                        <cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'row_otvtotal'</cfquery>
                    </cfif>
                    <td><input type="checkbox" name="module_content" id="module_content" value="row_otvtotal" <cfif len(get_detail.is_selected) and get_detail.is_selected eq 1> Checked </cfif><cfif get_basket.basket_id eq 52>disabled</cfif>></td>
                    <td><cfinput type="text" name="row_otvtotal_sira" value="#get_detail.line_order_no#" style="width:25px" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>
                    <td><cfinput type="text" name="row_otvtotal_genislik" value="#get_detail.genislik#" style="width:35px" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>
                    <td><input type="textbox" name="ROW_OTVTOTAL" id="ROW_OTVTOTAL" value="<cfoutput>#get_detail.title_name#</cfoutput>" maxlength="200"></td>
                    <cfif x_show_language>
                        <td>
                            <cf_language_info 
                                table_name="SETUP_BASKET_ROWS" 
                                column_name="TITLE_NAME" 
                                column_id_value="#get_detail.BASKET_ROW_ID#" 
                                maxlength="500" 
                                datasource="#dsn3#" 
                                column_id="BASKET_ROW_ID" 
                                control_type="0">
                        </td>
                    </cfif>
                    <td><cf_get_lang no ='1924.Satır ÖTV Toplamı'></td>
                </tr>
            </cfif>
            <tr>
				<cfif x_show_language>
                    <cfquery name="get_detail" datasource="#dsn3#">
                        SELECT #dsn_alias#.Get_Dynamic_Language(BASKET_ROW_ID,'#session.ep.language#','SETUP_BASKET_ROWS','TITLE_NAME',NULL,NULL,TITLE_NAME) AS TITLE_NAME,LINE_ORDER_NO,IS_SELECTED,GENISLIK,IS_READONLY,B_TYPE,BASKET_ROW_ID FROM (SELECT * FROM SETUP_BASKET_ROWS WHERE BASKET_ID = #GET_BASKET.BASKET_ID# AND B_TYPE=1) AS XXX WHERE TITLE = 'row_lasttotal'
                    </cfquery>
                <cfelse>
                    <cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'row_lasttotal'</cfquery>
                </cfif>
                <td><input type="checkbox" name="module_content" id="module_content" value="row_lasttotal" <cfif len(get_detail.is_selected) and get_detail.is_selected eq 1>Checked </cfif>></td>
                <td><cfinput type="text" name="ROW_LASTTOTAL_sira" value="#get_detail.line_order_no#" style="width:25px" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>
                <td><cfinput type="text" name="ROW_LASTTOTAL_genislik" value="#get_detail.genislik#" style="width:35px" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>
                <td><input type="textbox" name="ROW_LASTTOTAL" id="ROW_LASTTOTAL" value="<cfoutput>#get_detail.title_name#</cfoutput>" maxlength="200"></td>
				<cfif x_show_language>
                    <td>
                        <cf_language_info 
                            table_name="SETUP_BASKET_ROWS" 
                            column_name="TITLE_NAME" 
                            column_id_value="#get_detail.BASKET_ROW_ID#" 
                            maxlength="500" 
                            datasource="#dsn3#" 
                            column_id="BASKET_ROW_ID" 
                            control_type="0">
                    </td>
                </cfif>
                <td><cf_get_lang no='599.KDV Fiyat ve Net Toplama Bağlı'></td>
            </tr>
            <tr>
				<cfif x_show_language>
                    <cfquery name="get_detail" datasource="#dsn3#">
                        SELECT #dsn_alias#.Get_Dynamic_Language(BASKET_ROW_ID,'#session.ep.language#','SETUP_BASKET_ROWS','TITLE_NAME',NULL,NULL,TITLE_NAME) AS TITLE_NAME,LINE_ORDER_NO,IS_SELECTED,GENISLIK,IS_READONLY,B_TYPE,BASKET_ROW_ID FROM (SELECT * FROM SETUP_BASKET_ROWS WHERE BASKET_ID = #GET_BASKET.BASKET_ID# AND B_TYPE=1) AS XXX WHERE TITLE = 'other_money_value'
                    </cfquery>
                <cfelse>
                    <cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'other_money_value'</cfquery>
                </cfif>
                <td><input type="checkbox" name="module_content" id="module_content" value="other_money_value" <cfif len(get_detail.is_selected) and get_detail.is_selected eq 1>Checked </cfif>></td>
                <td><cfinput type="text" name="other_money_value_sira" value="#get_detail.line_order_no#" style="width:25px" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>
                <td><cfinput type="text" name="other_money_value_genislik" value="#get_detail.genislik#" style="width:35px" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>
                <td><input type="textbox" name="other_money_value" id="other_money_value" value="<cfoutput>#get_detail.title_name#</cfoutput>" maxlength="200"></td>
				<cfif x_show_language>
                    <td>
                        <cf_language_info 
                            table_name="SETUP_BASKET_ROWS" 
                            column_name="TITLE_NAME" 
                            column_id_value="#get_detail.BASKET_ROW_ID#" 
                            maxlength="500" 
                            datasource="#dsn3#" 
                            column_id="BASKET_ROW_ID" 
                            control_type="0">
                    </td>
                </cfif>
                <td><cf_get_lang no='45.Satır Döviz Tutarı'></td>
            </tr>
            <tr>
				<cfif x_show_language>
                    <cfquery name="get_detail" datasource="#dsn3#">
                        SELECT #dsn_alias#.Get_Dynamic_Language(BASKET_ROW_ID,'#session.ep.language#','SETUP_BASKET_ROWS','TITLE_NAME',NULL,NULL,TITLE_NAME) AS TITLE_NAME,LINE_ORDER_NO,IS_SELECTED,GENISLIK,IS_READONLY,B_TYPE,BASKET_ROW_ID FROM (SELECT * FROM SETUP_BASKET_ROWS WHERE BASKET_ID = #GET_BASKET.BASKET_ID# AND B_TYPE=1) AS XXX WHERE TITLE = 'other_money_gross_total'
                    </cfquery>
                <cfelse>
                    <cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'other_money_gross_total'</cfquery>
                </cfif>
                <td><input type="checkbox" name="module_content" id="module_content" value="other_money_gross_total" <cfif len(get_detail.is_selected) and get_detail.is_selected eq 1>Checked </cfif>></td>
                <td><cfinput type="text" name="other_money_gross_total_sira" value="#get_detail.line_order_no#" style="width:25px" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>
                <td><cfinput type="text" name="other_money_gross_total_genislik" value="#get_detail.genislik#" style="width:35px" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>
                <td><input type="textbox" name="other_money_gross_total" id="other_money_gross_total" value="<cfoutput>#get_detail.title_name#</cfoutput>" maxlength="200"></td>
				<cfif x_show_language>
                    <td>
                        <cf_language_info 
                            table_name="SETUP_BASKET_ROWS" 
                            column_name="TITLE_NAME" 
                            column_id_value="#get_detail.BASKET_ROW_ID#" 
                            maxlength="500" 
                            datasource="#dsn3#" 
                            column_id="BASKET_ROW_ID" 
                            control_type="0">
                    </td>
                </cfif>
                <td><cf_get_lang no='829.Satır Vergi Toplamı(Döviz Fiyata Bağlı)'></td>
            </tr>


            <tr>
				<cfif x_show_language>
                    <cfquery name="get_detail" datasource="#dsn3#">
                        SELECT #dsn_alias#.Get_Dynamic_Language(BASKET_ROW_ID,'#session.ep.language#','SETUP_BASKET_ROWS','TITLE_NAME',NULL,NULL,TITLE_NAME) AS TITLE_NAME,LINE_ORDER_NO,IS_SELECTED,GENISLIK,IS_READONLY,B_TYPE,BASKET_ROW_ID FROM (SELECT * FROM SETUP_BASKET_ROWS WHERE BASKET_ID = #GET_BASKET.BASKET_ID# AND B_TYPE=1) AS XXX WHERE TITLE = 'price_total'
                    </cfquery>
                <cfelse>
                    <cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'price_total'</cfquery>
                </cfif>
                <td><input type="checkbox" name="module_content" id="module_content" value="price_total" <cfif len(get_detail.is_selected) and get_detail.is_selected eq 1>Checked</cfif>></td>
                <td><cfinput type="text" name="PRICE_TOTAL_sira" value="#get_detail.line_order_no#" style="width:25px" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>
                <td><cfinput type="text" name="PRICE_TOTAL_genislik" value="#get_detail.genislik#" style="width:35px" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>
                <td><input type="textbox" name="PRICE_TOTAL" id="PRICE_TOTAL" value="<cfoutput>#get_detail.title_name#</cfoutput>" maxlength="200"></td>
				<cfif x_show_language>
                    <td>
                        <cf_language_info 
                            table_name="SETUP_BASKET_ROWS" 
                            column_name="TITLE_NAME" 
                            column_id_value="#get_detail.BASKET_ROW_ID#" 
                            maxlength="500" 
                            datasource="#dsn3#" 
                            column_id="BASKET_ROW_ID" 
                            control_type="0">
                    </td>
                </cfif>
                <td><cf_get_lang no='831.Basket Toplam Belgenin bütün toplamı'> (<cf_get_lang no='620.KDV ve Fiyata Bağlı'>)</td>
            </tr>
            <tr>
				<cfif x_show_language>
                    <cfquery name="get_detail" datasource="#dsn3#">
                        SELECT #dsn_alias#.Get_Dynamic_Language(BASKET_ROW_ID,'#session.ep.language#','SETUP_BASKET_ROWS','TITLE_NAME',NULL,NULL,TITLE_NAME) AS TITLE_NAME,LINE_ORDER_NO,IS_SELECTED,GENISLIK,IS_READONLY,B_TYPE,BASKET_ROW_ID FROM (SELECT * FROM SETUP_BASKET_ROWS WHERE BASKET_ID = #GET_BASKET.BASKET_ID# AND B_TYPE=1) AS XXX WHERE TITLE = 'Kdv'
                    </cfquery>
                <cfelse>
                    <cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'Kdv'</cfquery>
                </cfif>
                <td><input type="checkbox" name="module_content" id="module_content" value="Kdv" <cfif len(get_detail.is_selected) and get_detail.is_selected eq 1>Checked</cfif>></td>
                <td><cfinput type="text" name="KDV_sira" value="#get_detail.line_order_no#" style="width:25px" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>
                <td><cfinput type="text" name="KDV_genislik" value="#get_detail.genislik#" style="width:35px" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>
                <td><input type="hidden" name="KDV" id="KDV" value="<cfoutput>#get_detail.title_name#</cfoutput>" maxlength="200"></td>
				<cfif x_show_language>
                    <td>
                        <cf_language_info 
                            table_name="SETUP_BASKET_ROWS" 
                            column_name="TITLE_NAME" 
                            column_id_value="#get_detail.BASKET_ROW_ID#" 
                            maxlength="500" 
                            datasource="#dsn3#" 
                            column_id="BASKET_ROW_ID" 
                            control_type="0">
                    </td>
                </cfif>
                <td><cf_get_lang no='667.KDVlerin Toplamı( KDV ye Bağlı) (Satır Vergi Toplamına Bağlı) '></td>
            </tr>
            <tr>
                <cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'is_price_total_other_money'</cfquery>
                <td colspan="5"><input type="checkbox" name="module_content" value="is_price_total_other_money" id="is_price_total_other_money" <cfif len(get_detail.is_selected) and get_detail.is_selected eq 1>checked</cfif>><cf_get_lang no ='2429.Basket Toplamda Döviz Bilgileri Gösterilsin'></td>
            </tr>
            <tr>
                <cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'is_amount_total'</cfquery>
                <td colspan="5"><input type="checkbox" name="module_content" value="is_amount_total" id="is_amount_total" <cfif len(get_detail.is_selected) and get_detail.is_selected eq 1>checked</cfif>><cf_get_lang no ='2765.Basket Toplamda Miktar Bilgileri Gösterilsin'></td>
            </tr>
            <tr>
                <cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'is_paper_discount'</cfquery>
                <td colspan="5"><input type="checkbox" name="module_content" value="is_paper_discount" id="is_paper_discount" <cfif len(get_detail.is_selected) and get_detail.is_selected eq 1>checked</cfif>><cf_get_lang no ='2780.Basket Toplamda Fatura Altı İndirim Gösterilsin'></td>
            </tr>
         </table>
         <cf_seperator header="#getLang('settings',1058)#" id="promosyona_iliskin_bilgiler">
         <table id="promosyona_iliskin_bilgiler">
            <tr>
				<cfif x_show_language>
                    <cfquery name="get_detail" datasource="#dsn3#">
                        SELECT #dsn_alias#.Get_Dynamic_Language(BASKET_ROW_ID,'#session.ep.language#','SETUP_BASKET_ROWS','TITLE_NAME',NULL,NULL,TITLE_NAME) AS TITLE_NAME,LINE_ORDER_NO,IS_SELECTED,GENISLIK,IS_READONLY,B_TYPE,BASKET_ROW_ID FROM (SELECT * FROM SETUP_BASKET_ROWS WHERE BASKET_ID = #GET_BASKET.BASKET_ID# AND B_TYPE=1) AS XXX WHERE TITLE = 'promosyon_yuzde'
                    </cfquery>
                <cfelse>
                    <cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'promosyon_yuzde'</cfquery>
                </cfif>
                <td><input type="checkbox" name="module_content" id="module_content" value="promosyon_yuzde" <cfif len(get_detail.is_selected) and get_detail.is_selected eq 1>Checked </cfif><cfif get_basket.basket_id eq 52>disabled</cfif>></td>
                <td><cfinput type="text" name="promosyon_yuzde_sira" value="#get_detail.line_order_no#" style="width:25px" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>
                <td><cfinput type="text" name="promosyon_yuzde_genislik" value="#get_detail.genislik#" style="width:35px" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>
                <td><input type="textbox" name="promosyon_yuzde" id="promosyon_yuzde" value="<cfoutput>#get_detail.title_name#</cfoutput>" maxlength="200"></td>
					<cfif x_show_language>
                        <td>
                            <cf_language_info 
                                table_name="SETUP_BASKET_ROWS" 
                                column_name="TITLE_NAME" 
                                column_id_value="#get_detail.BASKET_ROW_ID#" 
                                maxlength="500" 
                                datasource="#dsn3#" 
                                column_id="BASKET_ROW_ID" 
                                control_type="0">
                        </td>
                    </cfif>
                <td><cf_get_lang no='674.Promosyon'> %</td>
            </tr>
            <tr>
				<cfif x_show_language>
                    <cfquery name="get_detail" datasource="#dsn3#">
                        SELECT #dsn_alias#.Get_Dynamic_Language(BASKET_ROW_ID,'#session.ep.language#','SETUP_BASKET_ROWS','TITLE_NAME',NULL,NULL,TITLE_NAME) AS TITLE_NAME,LINE_ORDER_NO,IS_SELECTED,GENISLIK,IS_READONLY,B_TYPE,BASKET_ROW_ID FROM (SELECT * FROM SETUP_BASKET_ROWS WHERE BASKET_ID = #GET_BASKET.BASKET_ID# AND B_TYPE=1) AS XXX WHERE TITLE = 'promosyon_maliyet'
                    </cfquery>
                <cfelse>
                    <cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'promosyon_maliyet'</cfquery>
                </cfif>
                <td><input type="checkbox" name="module_content" id="module_content" value="promosyon_maliyet" <cfif len(get_detail.is_selected) and get_detail.is_selected eq 1>Checked </cfif><cfif get_basket.basket_id eq 52>disabled</cfif>></td>
                <td><cfinput type="text" name="promosyon_maliyet_sira" value="#get_detail.line_order_no#" style="width:25px" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>
                <td><cfinput type="text" name="promosyon_maliyet_genislik" value="#get_detail.genislik#" style="width:35px" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>
                <td><input type="textbox" name="promosyon_maliyet" id="promosyon_maliyet" value="<cfoutput>#get_detail.title_name#</cfoutput>" maxlength="200"></td>
				<cfif x_show_language>
                    <td>
                        <cf_language_info 
                            table_name="SETUP_BASKET_ROWS" 
                            column_name="TITLE_NAME" 
                            column_id_value="#get_detail.BASKET_ROW_ID#" 
                            maxlength="500" 
                            datasource="#dsn3#" 
                            column_id="BASKET_ROW_ID" 
                            control_type="0">
                    </td>
                </cfif>
                <td><cf_get_lang no='674.Promosyon'><cf_get_lang_main no='846.maliyet'></td>
            </tr>
            <tr>
                <td colspan="4">
                    <cfsavecontent variable="message"><cf_get_lang no='995.Değer Nümerik olmalıdır'></cfsavecontent>
                    <cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'is_promotion'</cfquery>
                    <input type="checkbox" name="module_content" id="module_content" value="is_promotion" <cfif len(get_detail.is_selected) and get_detail.is_selected eq 1>Checked </cfif><cfif get_basket.basket_id eq 52>disabled</cfif>>
                    <input type="hidden" name="is_promotion" id="is_promotion" value="<cfoutput>#get_detail.title_name#</cfoutput>" maxlength="200">
                    <cf_get_lang no='1049.Promosyon Kullan/Kullanma'>
                </td>
            </tr>
         </table>
         <cf_seperator header="#getLang('settings',1048)#" id="teslim_ve_depoamaya_iliskin_bilgiler">
         <table id="teslim_ve_depoamaya_iliskin_bilgiler">
         	<cfif listfind('3,4,5,6,7,8,13,14,15,24,25,26,28,29,34,35,36,37,38,39,44,45,46,50,51,52',get_basket.basket_id)>
                <tr>
                    <cfif x_show_language>
                        <cfquery name="get_detail" datasource="#dsn3#">
                            SELECT #dsn_alias#.Get_Dynamic_Language(BASKET_ROW_ID,'#session.ep.language#','SETUP_BASKET_ROWS','TITLE_NAME',NULL,NULL,TITLE_NAME) AS TITLE_NAME,LINE_ORDER_NO,IS_SELECTED,GENISLIK,IS_READONLY,B_TYPE,BASKET_ROW_ID FROM (SELECT * FROM SETUP_BASKET_ROWS WHERE BASKET_ID = #GET_BASKET.BASKET_ID# AND B_TYPE=1) AS XXX WHERE TITLE = 'deliver_date'
                        </cfquery>
                    <cfelse>
                        <cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'deliver_date'</cfquery>
                    </cfif>
                    <td><input type="checkbox" name="module_content" id="module_content" value="deliver_date" <cfif len(get_detail.is_selected) and get_detail.is_selected eq 1>Checked </cfif> <cfif get_basket.basket_id eq 52>disabled</cfif>></td>
                    <td><cfinput type="text" name="DELIVER_DATE_sira" value="#get_detail.line_order_no#" style="width:25px" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>
                    <td><cfinput type="text" name="DELIVER_DATE_genislik" value="#get_detail.genislik#" style="width:35px" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>
                    <td><input type="textbox" name="DELIVER_DATE" id="DELIVER_DATE" value="<cfoutput>#get_detail.title_name#</cfoutput>" maxlength="200"></td>
                    <cfif x_show_language>
                        <td>
                            <cf_language_info 
                                table_name="SETUP_BASKET_ROWS" 
                                column_name="TITLE_NAME" 
                                column_id_value="#get_detail.BASKET_ROW_ID#" 
                                maxlength="500" 
                                datasource="#dsn3#" 
                                column_id="BASKET_ROW_ID" 
                                control_type="0">
                        </td>
                    </cfif>
                    <td><cf_get_lang no='833.Teslim Tarihi İrsaliye ve Faturada kullanılmaz'> (<cf_get_lang no='1629.Stok Açılış Ve Devir Fişlerinde Finansal Yaş Olarak Kullanılır'>)</td>
                </tr>
                <tr>
                    <cfif x_show_language>
                        <cfquery name="get_detail" datasource="#dsn3#">
                            SELECT #dsn_alias#.Get_Dynamic_Language(BASKET_ROW_ID,'#session.ep.language#','SETUP_BASKET_ROWS','TITLE_NAME',NULL,NULL,TITLE_NAME) AS TITLE_NAME,LINE_ORDER_NO,IS_SELECTED,GENISLIK,IS_READONLY,B_TYPE,BASKET_ROW_ID FROM (SELECT * FROM SETUP_BASKET_ROWS WHERE BASKET_ID = #GET_BASKET.BASKET_ID# AND B_TYPE=1) AS XXX WHERE TITLE = 'deliver_dept'
                        </cfquery>
                    <cfelse>
                        <cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'deliver_dept'</cfquery>
                    </cfif>
                    <td><input type="checkbox" name="module_content" id="module_content" value="deliver_dept" <cfif len(get_detail.is_selected) and get_detail.is_selected eq 1>Checked </cfif><cfif get_basket.basket_id eq 52>disabled</cfif>></td>
                    <td><cfinput type="text" name="DELIVER_DEPT_sira" value="#get_detail.line_order_no#" style="width:25px" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>
                    <td><cfinput type="text" name="DELIVER_DEPT_genislik" value="#get_detail.genislik#" style="width:35px" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>
                    <td><input type="textbox" name="DELIVER_DEPT" id="DELIVER_DEPT" value="<cfoutput>#get_detail.title_name#</cfoutput>" maxlength="200"></td>
                    <cfif x_show_language>
                        <td>
                            <cf_language_info 
                                table_name="SETUP_BASKET_ROWS" 
                                column_name="TITLE_NAME" 
                                column_id_value="#get_detail.BASKET_ROW_ID#" 
                                maxlength="500" 
                                datasource="#dsn3#" 
                                column_id="BASKET_ROW_ID" 
                                control_type="0">
                        </td>
                    </cfif>
                    <td><cf_get_lang no="834.Teslim depo İrsaliye ve Faturada kullanılmaz"></td>
                </tr>
            </cfif>
            <!---<tr>
				<cfif x_show_language>
                    <cfquery name="get_detail" datasource="#dsn3#">
                        SELECT #dsn_alias#.Get_Dynamic_Language(BASKET_ROW_ID,'#session.ep.language#','SETUP_BASKET_ROWS','TITLE_NAME',NULL,NULL,TITLE_NAME) AS TITLE_NAME,LINE_ORDER_NO,IS_SELECTED,GENISLIK,IS_READONLY,B_TYPE,BASKET_ROW_ID FROM (SELECT * FROM SETUP_BASKET_ROWS WHERE BASKET_ID = #GET_BASKET.BASKET_ID# AND B_TYPE=1) AS XXX WHERE TITLE = 'deliver_dept_assortment'
                    </cfquery>
                <cfelse>
                    <cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'deliver_dept_assortment'</cfquery>
                </cfif>
                <td><input type="checkbox" name="module_content" id="module_content" value="deliver_dept_assortment" <cfif len(get_detail.is_selected) and get_detail.is_selected eq 1>Checked </cfif><cfif get_basket.basket_id eq 52>disabled</cfif>></td>
                <td><cfinput type="text" name="deliver_dept_assortment_sira" value="#get_detail.line_order_no#" style="width:25px" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>
                <td><cfinput type="text" name="deliver_dept_assortment_genislik" value="#get_detail.genislik#" style="width:35px" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>
                <td><input type="textbox" name="deliver_dept_assortment" id="deliver_dept_assortment" value="<cfoutput>#get_detail.title_name#</cfoutput>" maxlength="200"></td>
				<cfif x_show_language>
                    <td>
                        <cf_language_info 
                            table_name="SETUP_BASKET_ROWS" 
                            column_name="TITLE_NAME" 
                            column_id_value="#get_detail.BASKET_ROW_ID#" 
                            maxlength="500" 
                            datasource="#dsn3#" 
                            column_id="BASKET_ROW_ID" 
                            control_type="0">
                    </td>
                </cfif>
                <td><cf_get_lang no='530.Teslim Depo Dağılım'></td>
            </tr>--->
            <tr>
				<cfif x_show_language>
                    <cfquery name="get_detail" datasource="#dsn3#">
                        SELECT #dsn_alias#.Get_Dynamic_Language(BASKET_ROW_ID,'#session.ep.language#','SETUP_BASKET_ROWS','TITLE_NAME',NULL,NULL,TITLE_NAME) AS TITLE_NAME,LINE_ORDER_NO,IS_SELECTED,GENISLIK,IS_READONLY,B_TYPE,BASKET_ROW_ID FROM (SELECT * FROM SETUP_BASKET_ROWS WHERE BASKET_ID = #GET_BASKET.BASKET_ID# AND B_TYPE=1) AS XXX WHERE TITLE = 'shelf_number'
                    </cfquery>
                <cfelse>
                    <cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'shelf_number'</cfquery>
                </cfif>
                <cfsavecontent variable="message2"><cf_get_lang no ='1933.Numarası nümerik olmalıdır'></cfsavecontent>
                <td><input type="checkbox" name="module_content" id="module_content" value="shelf_number" <cfif len(get_detail.is_selected) and get_detail.is_selected eq 1>Checked </cfif><cfif get_basket.basket_id eq 52>disabled</cfif>></td>
                <td><cfinput type="text" name="shelf_number_sira" value="#get_detail.line_order_no#" style="width:25px" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>
                <td><cfinput type="text" name="shelf_number_genislik" value="#get_detail.genislik#" style="width:35px" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>
                <td><input type="textbox" name="shelf_number" id="shelf_number" value="<cfoutput>#get_detail.title_name#</cfoutput>" maxlength="200"></td>
				<cfif x_show_language>
                    <td>
                        <cf_language_info 
                            table_name="SETUP_BASKET_ROWS" 
                            column_name="TITLE_NAME" 
                            column_id_value="#get_detail.BASKET_ROW_ID#" 
                            maxlength="500" 
                            datasource="#dsn3#" 
                            column_id="BASKET_ROW_ID" 
                            control_type="0">
                    </td>
                </cfif>
                <td><cf_get_lang no='1059.Raf No'></td>
            </tr>
            <tr>
				<cfif x_show_language>
                    <cfquery name="get_detail" datasource="#dsn3#">
                        SELECT #dsn_alias#.Get_Dynamic_Language(BASKET_ROW_ID,'#session.ep.language#','SETUP_BASKET_ROWS','TITLE_NAME',NULL,NULL,TITLE_NAME) AS TITLE_NAME,LINE_ORDER_NO,IS_SELECTED,GENISLIK,IS_READONLY,B_TYPE,BASKET_ROW_ID FROM (SELECT * FROM SETUP_BASKET_ROWS WHERE BASKET_ID = #GET_BASKET.BASKET_ID# AND B_TYPE=1) AS XXX WHERE TITLE = 'shelf_number_2'
                    </cfquery>
                <cfelse>
                    <cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'shelf_number_2'</cfquery>
                </cfif>
                <cfsavecontent variable="message2"><cf_get_lang no ='1933.Numarası nümerik olmalıdır'></cfsavecontent>
                <td><input type="checkbox" name="module_content" id="module_content" value="shelf_number_2" <cfif len(get_detail.is_selected) and get_detail.is_selected eq 1>Checked </cfif><cfif get_basket.basket_id eq 52>disabled</cfif>></td>
                <td><cfinput type="text" name="shelf_number_2_sira" value="#get_detail.line_order_no#" style="width:25px" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>
                <td><cfinput type="text" name="shelf_number_2_genislik" value="#get_detail.genislik#" style="width:35px" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>
                <td><input type="textbox" name="shelf_number_2" id="shelf_number_2" value="<cfoutput>#get_detail.title_name#</cfoutput>" maxlength="200"></td>
				<cfif x_show_language>
                    <td>
                        <cf_language_info 
                            table_name="SETUP_BASKET_ROWS" 
                            column_name="TITLE_NAME" 
                            column_id_value="#get_detail.BASKET_ROW_ID#" 
                            maxlength="500" 
                            datasource="#dsn3#" 
                            column_id="BASKET_ROW_ID" 
                            control_type="0">
                    </td>
                </cfif>
                <td><cf_get_lang no='1059.Raf No'>2 (<cf_get_lang no='1329.Çıkış Rafı'>)</td>
            </tr>
            <tr>
				<cfif x_show_language>
                    <cfquery name="get_detail" datasource="#dsn3#">
                        SELECT #dsn_alias#.Get_Dynamic_Language(BASKET_ROW_ID,'#session.ep.language#','SETUP_BASKET_ROWS','TITLE_NAME',NULL,NULL,TITLE_NAME) AS TITLE_NAME,LINE_ORDER_NO,IS_SELECTED,GENISLIK,IS_READONLY,B_TYPE,BASKET_ROW_ID FROM (SELECT * FROM SETUP_BASKET_ROWS WHERE BASKET_ID = #GET_BASKET.BASKET_ID# AND B_TYPE=1) AS XXX WHERE TITLE = 'spec'
                    </cfquery>
                <cfelse>
                    <cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'spec'</cfquery>
                </cfif>
                <td><input type="checkbox" name="module_content" id="module_content" value="spec" <cfif len(get_detail.is_selected) and get_detail.is_selected eq 1>Checked </cfif>></td>
                <td><cfinput type="text" name="SPEC_sira" value="#get_detail.line_order_no#" style="width:25px" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>
                <td><cfinput type="text" name="SPEC_genislik" value="#get_detail.genislik#" style="width:35px" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>
                <td><input type="textbox" name="SPEC" id="SPEC" value="<cfoutput>#get_detail.title_name#</cfoutput>" maxlength="200"></td>
				<cfif x_show_language>
                    <td>
                        <cf_language_info 
                            table_name="SETUP_BASKET_ROWS" 
                            column_name="TITLE_NAME" 
                            column_id_value="#get_detail.BASKET_ROW_ID#" 
                            maxlength="500" 
                            datasource="#dsn3#" 
                            column_id="BASKET_ROW_ID" 
                            control_type="0">
                    </td>
                </cfif>
                <td><cf_get_lang_main no='235.Spec'><cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'spec_product_cat_property'</cfquery></td>
            </tr>
            <tr>
				<cfif x_show_language>
                    <cfquery name="get_detail" datasource="#dsn3#">
                        SELECT #dsn_alias#.Get_Dynamic_Language(BASKET_ROW_ID,'#session.ep.language#','SETUP_BASKET_ROWS','TITLE_NAME',NULL,NULL,TITLE_NAME) AS TITLE_NAME,LINE_ORDER_NO,IS_SELECTED,GENISLIK,IS_READONLY,B_TYPE,BASKET_ROW_ID FROM (SELECT * FROM SETUP_BASKET_ROWS WHERE BASKET_ID = #GET_BASKET.BASKET_ID# AND B_TYPE=1) AS XXX WHERE TITLE = 'lot_no'
                    </cfquery>
                <cfelse>
                    <cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'lot_no'</cfquery>
                </cfif>
                <td><input type="checkbox" name="module_content" id="module_content" value="lot_no" <cfif len(get_detail.is_selected) and get_detail.is_selected eq 1>Checked </cfif><cfif get_basket.basket_id eq 52>disabled</cfif>></td>
                <td><cfinput type="text" name="lot_no_sira" value="#get_detail.line_order_no#" style="width:25px" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>
                <td><cfinput type="text" name="lot_no_genislik" value="#get_detail.genislik#" style="width:35px" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>
                <td><input type="textbox" name="lot_no" id="lot_no" value="<cfoutput>#get_detail.title_name#</cfoutput>" maxlength="200"></td>
				<cfif x_show_language>
                    <td>
                        <cf_language_info 
                            table_name="SETUP_BASKET_ROWS" 
                            column_name="TITLE_NAME" 
                            column_id_value="#get_detail.BASKET_ROW_ID#" 
                            maxlength="500" 
                            datasource="#dsn3#" 
                            column_id="BASKET_ROW_ID" 
                            control_type="0">
                    </td>
                </cfif>
                <td><cf_get_lang no='46.Lot No'></td>
            </tr>
            <tr>
				<cfif x_show_language>
                    <cfquery name="get_detail" datasource="#dsn3#">
                        SELECT #dsn_alias#.Get_Dynamic_Language(BASKET_ROW_ID,'#session.ep.language#','SETUP_BASKET_ROWS','TITLE_NAME',NULL,NULL,TITLE_NAME) AS TITLE_NAME,LINE_ORDER_NO,IS_SELECTED,GENISLIK,IS_READONLY,B_TYPE,BASKET_ROW_ID FROM (SELECT * FROM SETUP_BASKET_ROWS WHERE BASKET_ID = #GET_BASKET.BASKET_ID# AND B_TYPE=1) AS XXX WHERE TITLE = 'darali'
                    </cfquery>
                <cfelse>
                    <cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'darali'</cfquery>
                </cfif>
                <td><input type="checkbox" name="module_content" id="module_content" value="darali" <cfif len(get_detail.is_selected) and get_detail.is_selected eq 1>Checked </cfif><cfif get_basket.basket_id eq 52>disabled</cfif>></td>
                <td><cfinput type="text" name="darali_sira" value="#get_detail.line_order_no#" style="width:25px" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>
                <td><cfinput type="text" name="darali_genislik" value="#get_detail.genislik#" style="width:35px" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>
                <td><input type="textbox" name="darali" id="darali" value="<cfoutput>#get_detail.title_name#</cfoutput>" maxlength="200"></td>
				<cfif x_show_language>
                    <td>
                        <cf_language_info 
                            table_name="SETUP_BASKET_ROWS" 
                            column_name="TITLE_NAME" 
                            column_id_value="#get_detail.BASKET_ROW_ID#" 
                            maxlength="500" 
                            datasource="#dsn3#" 
                            column_id="BASKET_ROW_ID" 
                            control_type="0">
                    </td>
                </cfif>
                <td><cf_get_lang no='638.Daralı'></td>
            </tr>
            <tr>
				<cfif x_show_language>
                    <cfquery name="get_detail" datasource="#dsn3#">
                        SELECT #dsn_alias#.Get_Dynamic_Language(BASKET_ROW_ID,'#session.ep.language#','SETUP_BASKET_ROWS','TITLE_NAME',NULL,NULL,TITLE_NAME) AS TITLE_NAME,LINE_ORDER_NO,IS_SELECTED,GENISLIK,IS_READONLY,B_TYPE,BASKET_ROW_ID FROM (SELECT * FROM SETUP_BASKET_ROWS WHERE BASKET_ID = #GET_BASKET.BASKET_ID# AND B_TYPE=1) AS XXX WHERE TITLE = 'dara'
                    </cfquery>
                <cfelse>
                    <cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'dara'</cfquery>
                </cfif>
                <td><input type="checkbox" name="module_content" id="module_content" value="dara" <cfif len(get_detail.is_selected) and get_detail.is_selected eq 1>Checked </cfif><cfif get_basket.basket_id eq 52>disabled</cfif>></td>
                <td><cfinput type="text" name="dara_sira" value="#get_detail.line_order_no#" style="width:25px" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>
                <td><cfinput type="text" name="dara_genislik" value="#get_detail.genislik#" style="width:35px" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>
                <td><input type="textbox" name="dara" id="dara" value="<cfoutput>#get_detail.title_name#</cfoutput>" maxlength="200"></td>
				<cfif x_show_language>
                    <td>
                        <cf_language_info 
                            table_name="SETUP_BASKET_ROWS" 
                            column_name="TITLE_NAME" 
                            column_id_value="#get_detail.BASKET_ROW_ID#" 
                            maxlength="500" 
                            datasource="#dsn3#" 
                            column_id="BASKET_ROW_ID" 
                            control_type="0">
                    </td>
                </cfif>
                <td><cf_get_lang no='654.Dara'></td>
            </tr>								
            <tr>
				<cfif x_show_language>
                    <cfquery name="get_detail" datasource="#dsn3#">
                        SELECT #dsn_alias#.Get_Dynamic_Language(BASKET_ROW_ID,'#session.ep.language#','SETUP_BASKET_ROWS','TITLE_NAME',NULL,NULL,TITLE_NAME) AS TITLE_NAME,LINE_ORDER_NO,IS_SELECTED,GENISLIK,IS_READONLY,B_TYPE,BASKET_ROW_ID FROM (SELECT * FROM SETUP_BASKET_ROWS WHERE BASKET_ID = #GET_BASKET.BASKET_ID# AND B_TYPE=1) AS XXX WHERE TITLE = 'is_parse'
                    </cfquery>
                <cfelse>
                    <cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'is_parse'</cfquery>
                </cfif>
                <td><input type="checkbox" name="module_content" id="module_content" value="is_parse" <cfif len(get_detail.is_selected) and get_detail.is_selected eq 1>Checked </cfif><cfif get_basket.basket_id eq 52>disabled</cfif>></td>
                <td><cfinput type="text" name="is_parse_sira" value="#get_detail.line_order_no#" style="width:25px" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>
                <td><cfinput type="text" name="is_parse_genislik" value="#get_detail.genislik#" style="width:35px" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>
                <td><input type="hidden" name="is_parse" id="is_parse" value="<cfoutput>#get_detail.title_name#</cfoutput>" maxlength="200"></td>
				<cfif x_show_language>
                    <td>
                        <cf_language_info 
                            table_name="SETUP_BASKET_ROWS" 
                            column_name="TITLE_NAME" 

                            column_id_value="#get_detail.BASKET_ROW_ID#" 
                            maxlength="500" 
                            datasource="#dsn3#" 
                            column_id="BASKET_ROW_ID" 
                            control_type="0">
                    </td>
                </cfif>
                <td><cf_get_lang no='280.Dağılım'> (<cf_get_lang no='1067.Stok çeşitlerinin dağılımını yapar'>)</td>
            </tr>
            <cfif listfind('4,6,14,15,25,35,36,37,38,51',get_basket.basket_id)>
                <tr>
                    <cfif x_show_language>
                        <cfquery name="get_detail" datasource="#dsn3#">
                            SELECT #dsn_alias#.Get_Dynamic_Language(BASKET_ROW_ID,'#session.ep.language#','SETUP_BASKET_ROWS','TITLE_NAME',NULL,NULL,TITLE_NAME) AS TITLE_NAME,LINE_ORDER_NO,IS_SELECTED,GENISLIK,IS_READONLY,B_TYPE,BASKET_ROW_ID FROM (SELECT * FROM SETUP_BASKET_ROWS WHERE BASKET_ID = #GET_BASKET.BASKET_ID# AND B_TYPE=1) AS XXX WHERE TITLE = 'order_currency'
                        </cfquery>
                    <cfelse>
                        <cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'order_currency'</cfquery>
                    </cfif>
                    <td><input type="checkbox" name="module_content" id="module_content" value="order_currency" <cfif len(get_detail.is_selected) and get_detail.is_selected eq 1>Checked </cfif><cfif get_basket.basket_id eq 52>disabled</cfif>></td>
                    <td><cfinput type="text" name="order_currency_sira" value="#get_detail.line_order_no#" style="width:25px" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>
                    <td><cfinput type="text" name="order_currency_genislik" value="#get_detail.genislik#" style="width:35px" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>
                    <td><input type="textbox" name="order_currency" id="order_currency" value="<cfoutput>#get_detail.title_name#</cfoutput>" maxlength="200"></td>
                    <cfif x_show_language>
                        <td>
                            <cf_language_info 
                                table_name="SETUP_BASKET_ROWS" 
                                column_name="TITLE_NAME" 
                                column_id_value="#get_detail.BASKET_ROW_ID#" 
                                maxlength="500" 
                                datasource="#dsn3#" 
                                column_id="BASKET_ROW_ID" 
                                control_type="0">
                        </td>
                    </cfif>
                    <td><cf_get_lang no='1041.Sipariş Aşama'>(<cf_get_lang no='1068.Sevk, Üretim, Eksik Teslimat gibi durumlar izlenir'>)</td>
                </tr>
           	</cfif>
            <cfif listfind('4,6,14,15,25,35,37,38,51',get_basket.basket_id)>
                <tr>
                    <cfif x_show_language>
                        <cfquery name="get_detail" datasource="#dsn3#">
                            SELECT #dsn_alias#.Get_Dynamic_Language(BASKET_ROW_ID,'#session.ep.language#','SETUP_BASKET_ROWS','TITLE_NAME',NULL,NULL,TITLE_NAME) AS TITLE_NAME,LINE_ORDER_NO,IS_SELECTED,GENISLIK,IS_READONLY,B_TYPE,BASKET_ROW_ID FROM (SELECT * FROM SETUP_BASKET_ROWS WHERE BASKET_ID = #GET_BASKET.BASKET_ID# AND B_TYPE=1) AS XXX WHERE TITLE = 'reserve_type'
                        </cfquery>
                    <cfelse>
                        <cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'reserve_type'</cfquery>
                    </cfif>
                    <td><input type="checkbox" name="module_content" id="module_content" value="reserve_type" <cfif len(get_detail.is_selected) and get_detail.is_selected eq 1>Checked </cfif><cfif get_basket.basket_id eq 52>disabled</cfif>></td>
                    <td><cfinput type="text" name="reserve_type_sira" value="#get_detail.line_order_no#" style="width:25px" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>
                    <td><cfinput type="text" name="reserve_type_genislik" value="#get_detail.genislik#" style="width:35px" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>
                    <td><input type="textbox" name="reserve_type" id="reserve_type" value="<cfoutput>#get_detail.title_name#</cfoutput>" maxlength="200"></td>
                    <cfif x_show_language>
                        <td>
                            <cf_language_info 
                                table_name="SETUP_BASKET_ROWS" 
                                column_name="TITLE_NAME" 
                                column_id_value="#get_detail.BASKET_ROW_ID#" 
                                maxlength="500" 
                                datasource="#dsn3#" 
                                column_id="BASKET_ROW_ID" 
                                control_type="0">
                        </td>
                    </cfif>
                    <td><cf_get_lang no='1599.Rezerve Tipi'></td>
                </tr>
           	</cfif>
            <!---<tr>
				<cfif x_show_language>
                    <cfquery name="get_detail" datasource="#dsn3#">
                        SELECT #dsn_alias#.Get_Dynamic_Language(BASKET_ROW_ID,'#session.ep.language#','SETUP_BASKET_ROWS','TITLE_NAME',NULL,NULL,TITLE_NAME) AS TITLE_NAME,LINE_ORDER_NO,IS_SELECTED,GENISLIK,IS_READONLY,B_TYPE,BASKET_ROW_ID FROM (SELECT * FROM SETUP_BASKET_ROWS WHERE BASKET_ID = #GET_BASKET.BASKET_ID# AND B_TYPE=1) AS XXX WHERE TITLE = 'reserve_date'
                    </cfquery>
                <cfelse>
                    <cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'reserve_date'</cfquery>
                </cfif>
				<td><input type="checkbox" name="module_content" id="module_content" value="reserve_date" <cfif len(get_detail.is_selected) and get_detail.is_selected eq 1>Checked </cfif><cfif get_basket.basket_id eq 52>disabled</cfif>></td>
                <td><cfinput type="text" name="reserve_date_sira" value="#get_detail.line_order_no#" style="width:25px" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>
                <td><cfinput type="text" name="reserve_date_genislik" value="#get_detail.genislik#" style="width:35px" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>
                <td><input type="textbox" name="reserve_date" id="reserve_date" value="<cfoutput>#get_detail.title_name#</cfoutput>" maxlength="200"></td>
				<cfif x_show_language>
                    <td>
                        <cf_language_info 
                            table_name="SETUP_BASKET_ROWS" 
                            column_name="TITLE_NAME" 
                            column_id_value="#get_detail.BASKET_ROW_ID#" 
                            maxlength="500" 
                            datasource="#dsn3#" 
                            column_id="BASKET_ROW_ID" 
                            control_type="0">
                    </td>
                </cfif>
                <td><cf_get_lang no='1598.Rezerve Tarihi'></td>
            </tr>--->
            <tr>
				<cfif x_show_language>
                    <cfquery name="get_detail" datasource="#dsn3#">
                        SELECT #dsn_alias#.Get_Dynamic_Language(BASKET_ROW_ID,'#session.ep.language#','SETUP_BASKET_ROWS','TITLE_NAME',NULL,NULL,TITLE_NAME) AS TITLE_NAME,LINE_ORDER_NO,IS_SELECTED,GENISLIK,IS_READONLY,B_TYPE,BASKET_ROW_ID FROM (SELECT * FROM SETUP_BASKET_ROWS WHERE BASKET_ID = #GET_BASKET.BASKET_ID# AND B_TYPE=1) AS XXX WHERE TITLE = 'basket_employee'
                    </cfquery>
                <cfelse>
                    <cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'basket_employee'</cfquery>
                </cfif>
				<td><input type="checkbox" name="module_content" id="module_content" value="basket_employee" <cfif len(get_detail.is_selected) and get_detail.is_selected eq 1>Checked </cfif><cfif get_basket.basket_id eq 52>disabled</cfif>></td>
                <td><cfinput type="text" name="basket_employee_sira" value="#get_detail.line_order_no#" style="width:25px" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>
                <td><cfinput type="text" name="basket_employee_genislik" value="#get_detail.genislik#" style="width:35px" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>
                <td><input type="textbox" name="basket_employee" id="basket_employee" value="<cfoutput>#get_detail.title_name#</cfoutput>" maxlength="200"></td>
				<cfif x_show_language>
                    <td>
                        <cf_language_info 
                            table_name="SETUP_BASKET_ROWS" 
                            column_name="TITLE_NAME" 
                            column_id_value="#get_detail.BASKET_ROW_ID#" 
                            maxlength="500" 
                            datasource="#dsn3#" 
                            column_id="BASKET_ROW_ID" 
                            control_type="0">
                    </td>
                </cfif>
                <td><cf_get_lang no='1597.Satış Temsilcisi'></td>
            </tr>
            <tr>
				<cfif x_show_language>
                    <cfquery name="get_detail" datasource="#dsn3#">
                        SELECT #dsn_alias#.Get_Dynamic_Language(BASKET_ROW_ID,'#session.ep.language#','SETUP_BASKET_ROWS','TITLE_NAME',NULL,NULL,TITLE_NAME) AS TITLE_NAME,LINE_ORDER_NO,IS_SELECTED,GENISLIK,IS_READONLY,B_TYPE,BASKET_ROW_ID FROM (SELECT * FROM SETUP_BASKET_ROWS WHERE BASKET_ID = #GET_BASKET.BASKET_ID# AND B_TYPE=1) AS XXX WHERE TITLE = 'basket_project'
                    </cfquery>
                <cfelse>
                    <cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'basket_project'</cfquery>
                </cfif>
				<td><input type="checkbox" name="module_content" id="module_content" value="basket_project" <cfif len(get_detail.is_selected) and get_detail.is_selected eq 1>Checked </cfif><cfif get_basket.basket_id eq 52>disabled</cfif>></td>
                <td><cfinput type="text" name="basket_project_sira" value="#get_detail.line_order_no#" style="width:25px" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>
                <td><cfinput type="text" name="basket_project_genislik" value="#get_detail.genislik#" style="width:35px" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>
                <td><input type="textbox" name="basket_project" id="basket_project" value="<cfoutput>#get_detail.title_name#</cfoutput>" maxlength="200"></td>
				<cfif x_show_language>
                    <td>
                        <cf_language_info 
                            table_name="SETUP_BASKET_ROWS" 
                            column_name="TITLE_NAME" 
                            column_id_value="#get_detail.BASKET_ROW_ID#" 
                            maxlength="500" 
                            datasource="#dsn3#" 
                            column_id="BASKET_ROW_ID" 
                            control_type="0">
                    </td>
                </cfif>
                <td><cf_get_lang_main no='4.Proje'></td>
            </tr>
            <tr>
				<cfif x_show_language>
                    <cfquery name="get_detail" datasource="#dsn3#">
                        SELECT #dsn_alias#.Get_Dynamic_Language(BASKET_ROW_ID,'#session.ep.language#','SETUP_BASKET_ROWS','TITLE_NAME',NULL,NULL,TITLE_NAME) AS TITLE_NAME,LINE_ORDER_NO,IS_SELECTED,GENISLIK,IS_READONLY,B_TYPE,BASKET_ROW_ID FROM (SELECT * FROM SETUP_BASKET_ROWS WHERE BASKET_ID = #GET_BASKET.BASKET_ID# AND B_TYPE=1) AS XXX WHERE TITLE = 'basket_work'
                    </cfquery>
                <cfelse>
                    <cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'basket_work'</cfquery>
                </cfif>
				<td><input type="checkbox" name="module_content" id="module_content" value="basket_work" <cfif len(get_detail.is_selected) and get_detail.is_selected eq 1>Checked </cfif><cfif get_basket.basket_id eq 52>disabled</cfif>></td>
                <td><cfinput type="text" name="basket_work_sira" value="#get_detail.line_order_no#" style="width:25px" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>
                <td><cfinput type="text" name="basket_work_genislik" value="#get_detail.genislik#" style="width:35px" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>
                <td><input type="textbox" name="basket_work" id="basket_work" value="<cfoutput>#get_detail.title_name#</cfoutput>" maxlength="200"></td>
				<cfif x_show_language>
                    <td>
                        <cf_language_info 
                            table_name="SETUP_BASKET_ROWS" 
                            column_name="TITLE_NAME" 
                            column_id_value="#get_detail.BASKET_ROW_ID#" 
                            maxlength="500" 
                            datasource="#dsn3#" 
                            column_id="BASKET_ROW_ID" 
                            control_type="0">
                    </td>
                </cfif>
                <td><cf_get_lang_main no='1033.İş'></td>
         	</tr>
			<!--- Alis Faturasi basket sablonu icin masraf merkezi/butce kalemi/muhasebe kodu eklendi 20140626
                ama diger fatura tiplerinde problem olusmamasi acisindan tüm sablonlarda geliyor --->
            <cfif get_basket.basket_id eq 1>
                <tr>
                    <cfif x_show_language>
                        <cfquery name="get_detail" datasource="#dsn3#">
                            SELECT #dsn_alias#.Get_Dynamic_Language(BASKET_ROW_ID,'#session.ep.language#','SETUP_BASKET_ROWS','TITLE_NAME',NULL,NULL,TITLE_NAME) AS TITLE_NAME,LINE_ORDER_NO,IS_SELECTED,GENISLIK,IS_READONLY,B_TYPE,BASKET_ROW_ID FROM (SELECT * FROM SETUP_BASKET_ROWS WHERE BASKET_ID = #GET_BASKET.BASKET_ID# AND B_TYPE=1) AS XXX WHERE TITLE = 'basket_exp_center'
                        </cfquery>
                    <cfelse>
                        <cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'basket_exp_center'</cfquery>
                    </cfif>
                    <td><input type="checkbox" name="module_content" id="module_content" value="basket_exp_center" <cfif len(get_detail.is_selected) and get_detail.is_selected eq 1>Checked </cfif><cfif get_basket.basket_id eq 52>disabled</cfif>></td>
                    <td><cfinput type="text" name="basket_exp_center_sira" value="#get_detail.line_order_no#" style="width:25px" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>
                    <td><cfinput type="text" name="basket_exp_center_genislik" value="#get_detail.genislik#" style="width:35px" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>
                    <td><input type="textbox" name="basket_exp_center" id="basket_exp_center" value="<cfoutput>#get_detail.title_name#</cfoutput>" maxlength="200"></td>
                    <cfif x_show_language>
                        <td>
                            <cf_language_info 
                                table_name="SETUP_BASKET_ROWS" 
                                column_name="TITLE_NAME" 
                                column_id_value="#get_detail.BASKET_ROW_ID#" 
                                maxlength="500" 
                                datasource="#dsn3#" 
                                column_id="BASKET_ROW_ID" 
                                control_type="0">
                        </td>
                    </cfif>
                    <td><cf_get_lang_main no="1048.Masraf Merkezi"></td>
                </tr>
                <tr>
                    <cfif x_show_language>
                        <cfquery name="get_detail" datasource="#dsn3#">
                            SELECT #dsn_alias#.Get_Dynamic_Language(BASKET_ROW_ID,'#session.ep.language#','SETUP_BASKET_ROWS','TITLE_NAME',NULL,NULL,TITLE_NAME) AS TITLE_NAME,LINE_ORDER_NO,IS_SELECTED,GENISLIK,IS_READONLY,B_TYPE,BASKET_ROW_ID FROM (SELECT * FROM SETUP_BASKET_ROWS WHERE BASKET_ID = #GET_BASKET.BASKET_ID# AND B_TYPE=1) AS XXX WHERE TITLE = 'basket_exp_item'
                        </cfquery>
                    <cfelse>
                        <cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'basket_exp_item'</cfquery>
                    </cfif>
                    <td><input type="checkbox" name="module_content" id="module_content" value="basket_exp_item" <cfif len(get_detail.is_selected) and get_detail.is_selected eq 1>Checked </cfif><cfif get_basket.basket_id eq 52>disabled</cfif>></td>
                    <td><cfinput type="text" name="basket_exp_item_sira" value="#get_detail.line_order_no#" style="width:25px" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>
                    <td><cfinput type="text" name="basket_exp_item_genislik" value="#get_detail.genislik#" style="width:35px" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>
                    <td><input type="textbox" name="basket_exp_item" id="basket_exp_item" value="<cfoutput>#get_detail.title_name#</cfoutput>" maxlength="200"></td>
                    <cfif x_show_language>
                        <td>
                            <cf_language_info 
                                table_name="SETUP_BASKET_ROWS" 
                                column_name="TITLE_NAME" 
                                column_id_value="#get_detail.BASKET_ROW_ID#" 
                                maxlength="500" 
                                datasource="#dsn3#" 
                                column_id="BASKET_ROW_ID" 
                                control_type="0">
                        </td>
                    </cfif>
                    <td><cf_get_lang_main no="822.Bütçe Kalemi"></td>
                </tr>
                <tr>
                    <cfif x_show_language>
                        <cfquery name="get_detail" datasource="#dsn3#">
                            SELECT #dsn_alias#.Get_Dynamic_Language(BASKET_ROW_ID,'#session.ep.language#','SETUP_BASKET_ROWS','TITLE_NAME',NULL,NULL,TITLE_NAME) AS TITLE_NAME,LINE_ORDER_NO,IS_SELECTED,GENISLIK,IS_READONLY,B_TYPE,BASKET_ROW_ID FROM (SELECT * FROM SETUP_BASKET_ROWS WHERE BASKET_ID = #GET_BASKET.BASKET_ID# AND B_TYPE=1) AS XXX WHERE TITLE = 'basket_acc_code'
                        </cfquery>
                    <cfelse>
                        <cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'basket_acc_code'</cfquery>
                    </cfif>
                    <td><input type="checkbox" name="module_content" id="module_content" value="basket_acc_code" <cfif len(get_detail.is_selected) and get_detail.is_selected eq 1>Checked </cfif><cfif get_basket.basket_id eq 52>disabled</cfif>></td>
                    <td><cfinput type="text" name="basket_acc_code_sira" value="#get_detail.line_order_no#" style="width:25px" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>
                    <td><cfinput type="text" name="basket_acc_code_genislik" value="#get_detail.genislik#" style="width:35px" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>
                    <td><input type="textbox" name="basket_acc_code" id="basket_acc_code" value="<cfoutput>#get_detail.title_name#</cfoutput>" maxlength="200"></td>
                    <cfif x_show_language>
                        <td>
                            <cf_language_info 
                                table_name="SETUP_BASKET_ROWS" 
                                column_name="TITLE_NAME" 
                                column_id_value="#get_detail.BASKET_ROW_ID#" 
                                maxlength="500" 
                                datasource="#dsn3#" 
                                column_id="BASKET_ROW_ID" 
                                control_type="0">
                        </td>
                    </cfif>
                    <td><cf_get_lang_main no="1399.Muhasebe Kodu"></td>
                </tr>
            </cfif>
         </table>
         <cf_seperator header="#getLang('settings',1047)#" id="basket_genel_bilgileri">
         <table id="basket_genel_bilgileri">
            <!--- popup bilgileri --->
            <cfif not listfind('7,8,12,13,19,26,28,29,31,32,34,39,44,45,49,50,52',get_basket.basket_id)>
                <tr>
                    <td>
                        <cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'is_member_selected'</cfquery>
                        <input type="checkbox" name="module_content" id="module_content" value="is_member_selected" <cfif len(get_detail.is_selected) and get_detail.is_selected eq 1>Checked </cfif> >
                        <cf_get_lang no='164.Üye Seçme Zorunluluğu'>
                    </td>
                </tr>
                <tr>
                    <td>
                        <cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'is_member_not_change'</cfquery>
                        <input type="checkbox" name="module_content" id="module_content" value="is_member_not_change" <cfif len(get_detail.is_selected) and get_detail.is_selected eq 1>Checked </cfif> >
                        <cf_get_lang no ='1916.Baskette Ürün Varsa Cari Hesap Değiştirilemesin'>
                    </td>
                </tr>
           	</cfif>
            <tr>
                <td>
                    <cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'is_project_selected'</cfquery>
                    <input type="checkbox" name="module_content" id="module_content" value="is_project_selected" <cfif len(get_detail.is_selected) and get_detail.is_selected eq 1>Checked </cfif> ><!---urun seçmeden önce belgede proje secimi zorunlu olsun mu --->
                    <cf_get_lang no='2769.Proje Seçme Zorunluluğu'>
                </td>
            </tr>
            <tr>
                <td>
                    <cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'is_project_not_change'</cfquery>
                    <input type="checkbox" name="module_content" id="module_content" value="is_project_not_change" <cfif len(get_detail.is_selected) and get_detail.is_selected eq 1>Checked </cfif> >
                    <cf_get_lang no='2922.Baskette Ürün Varsa Proje Değiştirilemesin'>
                </td>
            </tr>
            <cfif listfind('1,2,3,4,5,6,7,10,11,14,15,17,18,20,21,24,25,37,38,51',get_basket.basket_id)>
                <tr>
                    <td>
                        <input type="checkbox" name="use_project_discount_" id="use_project_discount_" value="1" <cfif len(get_basket.USE_PROJECT_DISCOUNT) and get_basket.USE_PROJECT_DISCOUNT eq 1>checked</cfif>><!--- proje iskonto kontrolleri calıstırılsın mı --->
                        <cf_get_lang no="2605.Proje Baglantı Kontrolleri">
                    </td>
                </tr>
           	</cfif>
            <cfif listfind('3,4,5,6,14,15,35,36,37,38,51',get_basket.basket_id)>
                <tr>
                    <td>
                        <cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'check_row_discounts'</cfquery>
                        <input type="checkbox" name="module_content" id="module_content" value="check_row_discounts" <cfif len(get_detail.is_selected) and get_detail.is_selected eq 1>Checked </cfif> ><!---ayarlardaki şube yetki tanımlarına bağlı olarak satır iskontolarını kontrol eder --->
                        <cf_get_lang no="2770.sube İskonto Yetki Kontrolleri Yapılsın">
                    </td>
                </tr>
           	</cfif>
            <tr>
                <td>
                    <cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'zero_stock_status'</cfquery>
                    <input type="checkbox" name="module_content" id="module_content" value="zero_stock_status" <cfif len(get_detail.is_selected) and get_detail.is_selected eq 1>Checked </cfif> >
                    <cf_get_lang no='749.Sıfır Stok ile Çalış'>
                </td>
            </tr>					
            <tr>
                <td>
                    <cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'zero_stock_control_date'</cfquery>
                    <input type="checkbox" name="module_content" id="module_content" value="zero_stock_control_date" <cfif len(get_detail.is_selected) and get_detail.is_selected eq 1>Checked </cfif>>
                    <cf_get_lang no='3085.Sıfır Stok Kontrolünü Belge Tarihine Göre Yapsın'>
                </td>
            </tr>
            <cfif listfind('1,2,10,11,12,13,17,18,19,21,31,32,46,47,48,49',get_basket.basket_id)>
                <tr>
                    <td>
                        <cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'is_serialno_guaranty'</cfquery>
                        <input type="checkbox" name="module_content" id="module_content" value="is_serialno_guaranty" <cfif len(get_detail.is_selected) and get_detail.is_selected eq 1>Checked </cfif>>
                        <cf_get_lang no='745.Garanti Seri No'>
                    </td>
                </tr>
           	</cfif>
            <cfif listfind('1,2,3,4,5,6,10,11,14,15,17,18,20,21,24,25,37,38,42,43,51',get_basket.basket_id)>
                <tr>
                    <td>
                        <cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'is_risc'</cfquery>
                        <input type="checkbox" name="module_content" id="module_content" value="is_risc" <cfif len(get_detail.is_selected) and get_detail.is_selected eq 1>Checked </cfif> >
                        <cf_get_lang_main no='457.Risk Durumu'>
                    </td>
                </tr>
           	</cfif>
            <tr>
                <td>
                    <cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'is_cash_pos'</cfquery>
                    <input type="checkbox" name="module_content" id="module_content" value="is_cash_pos" <cfif len(get_detail.is_selected) and get_detail.is_selected eq 1>Checked </cfif> >
                    <cf_get_lang no='1911.Nakit ve Pos Ödeme'>
                </td>
            </tr>
            <tr>
                <td>
                    <cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'is_installment'</cfquery>
                    <input type="checkbox" name="module_content" id="module_content" value="is_installment" <cfif len(get_detail.is_selected) and get_detail.is_selected eq 1>Checked </cfif> >
                    <cf_get_lang no ='1913.Taksit Hesaplama'>
                </td>
            </tr>
            <cfif not listfind('12',get_basket.basket_id)>
                <tr>
                    <td>
                        <cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'otv_from_tax_price'</cfquery>
                        <input type="checkbox" name="module_content" id="module_content" value="otv_from_tax_price" <cfif get_detail.recordcount and get_detail.is_selected > Checked </cfif> >
                        <cf_get_lang no ='1917.OTV KDV Matrahına eklenir'>
                    </td>
                </tr>
            </cfif>
            <tr>
                <td>
                    <cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'is_use_add_unit'</cfquery>
                    <input type="checkbox" name="module_content" id="module_content" value="is_use_add_unit" <cfif get_detail.recordcount and get_detail.is_selected > Checked </cfif> >
                    <cf_get_lang no='442.2nci Birim Otomatik Hesaplansın'>
                </td>
            </tr>
         </table>
         <table>
        	<tr>
            	<td width="110"><cf_get_lang no ='2440.Satır Sayısı'></td>
                <td>
                	<input type="text" name="line_number" id="line_number" value="<cfoutput>#get_basket.LINE_NUMBER#</cfoutput>"  style="width:80px;"/>
                </td>
            </tr>
            <tr>
                <td><cf_get_lang no ='1927.Satır Yuvarlama'></td>
                <td>
                    <cfoutput>
                    <select name="price_round_num" id="price_round_num" style="width:80px;">
                        <cfloop from="1" to="8" index="tt">
                            <option value="#tt#" <cfif get_basket.PRICE_ROUND_NUMBER eq tt>selected</cfif>>#tt#</option>
                        </cfloop>
                    </select>
                    </cfoutput>
                </td>
            </tr>
            <tr>
                <td><cf_get_lang no ='1925.Basket Toplam Yuvarlama'></td>
                <td>
                <cfoutput>
                <select name="basket_total_round_num" id="basket_total_round_num" style="width:80px;">
                    <cfloop from="1" to="8" index="tx">
                        <option value="#tx#" <cfif get_basket.BASKET_TOTAL_ROUND_NUMBER eq tx>selected</cfif>>#tx#</option>
                    </cfloop>
                </select>
                </cfoutput>
                </td>
            </tr>
            <tr>
                <td><cf_get_lang no ='1926.Basket Kur Yuvarlama'></td>
                <td>
                <cfoutput>
                <select name="basket_rate_round_num" id="basket_rate_round_num" style="width:80px;">
                    <cfloop from="1" to="8" index="tr">
                        <option value="#tr#" <cfif get_basket.BASKET_RATE_ROUND_NUMBER eq tr>selected</cfif>>#tr#</option>
                    </cfloop>
                </select>
                </cfoutput>
                </td>
            </tr>
            <tr>
                <!--- PRODUCT_SELECT_TYPE'LARIN SIRALAMASINDA DEGİSİKLİK YAPMAYIN, YENİ URUN LISTELERİNİ SONA EKLEYEREK DEVAM EDELİM.
                BU SIRALAMAYA BAGLI OLARAK objects\display\list_products.cfm 'de URUN LISTESİ SAYFALARI INCLUDE EDİLİYOR!!!
                OZDEN20060824--->
                <td><cf_get_lang no='1042.Stok Seçim Sayfası'></td>
                <td>
                    <select name="product_select_type" id="product_select_type" style="width:300px;">
                        <option value="1" <cfif get_basket.product_select_type eq 1>selected</cfif>>1 - <cf_get_lang no='1466.Fiyatsız Standart Stok Listesi'></option><!--- Perakende Sektörü --->
                        <option value="2" <cfif get_basket.product_select_type eq 2>selected</cfif>>2 - <cf_get_lang no='1467.Stoklu Özel Fiyatlı Satış Listesi'></option><!--- IT Sektörü - Satış --->
                        <option value="3" <cfif get_basket.product_select_type eq 3>selected</cfif>>3 - <cf_get_lang no='1468.Stoklu Alış Listesi'></option><!--- 3 - IT Sektörü - Alış --->
                        <option value="4" <cfif get_basket.product_select_type eq 4>selected</cfif>>4 - <cf_get_lang no='1469.Stoklu Liste - Depo Fişleri'></option><!--- 4 - IT Sektörü - Depo Fişi --->
                        <option value="6" <cfif get_basket.product_select_type eq 6>selected</cfif>>5 - <cf_get_lang no='1471.Specli Stoklu Özel Fiyatlı Satış Listesi'></option><!--- 6 - IT Sektörü - Satış Specli --->
                        <option value="7" <cfif get_basket.product_select_type eq 7>selected</cfif>>6 - <cf_get_lang no='1472.Specli Stoklu Alış Listesi'></option> <!--- 7 - IT Sektörü - Alış Specli --->
                        <option value="8" <cfif get_basket.product_select_type eq 8>selected</cfif>>7 - <cf_get_lang no='1476.İşçilikli Stoklu Özel Fiyatlı Satış Listesi'></option> <!--- 8 - IT Sektörü - Satış İşçilikli --->
                        <option value="9" <cfif get_basket.product_select_type eq 9>selected</cfif>>8 - <cf_get_lang no ='1918.İşçilikli Specli Özel Fiyatlı Satış Listesi'></option><!--- 9 - IT Sektörü - Satış işçilikli specli ---> 
                        <option value="10" <cfif get_basket.product_select_type eq 10>selected</cfif>>9 - <cf_get_lang no ='1919.Tedarikçi Bazında Stok Stratejili Ürün Listesi'></option><!--- 10 - IT Sektörü - Satınalma siparişi icin ---> 
                        <option value="11" <cfif get_basket.product_select_type eq 11>selected</cfif>>10 - <cf_get_lang no ='1920.Raf ve Son Kullanma Tarihli Stok Listesi'></option>
                        <option value="12" <cfif get_basket.product_select_type eq 12>selected</cfif>>11 - <cf_get_lang no ='1921.Taksit Hesaplamalı Fiyat Listesi'></option> 
                        <option value="13" <cfif get_basket.product_select_type eq 13>selected</cfif>>12 - <cf_get_lang no ='1922.Fiyat Listeli Stok Listesi'></option> 
                    </select>
                </td>
            </tr>
     </table>
    </cf_area>
    <cf_form_box_footer>
    	<cf_record_info query_name='get_basket' add_function='kontrol()'>
        <cf_workcube_buttons is_upd='0'>
    </cf_form_box_footer>
 </cfform>
</cf_form_box>
<script type="text/javascript">
function kontrol()
{
	if (document.add_basket_details.line_number.value.length ==0)
	{ 
		alert ("<cf_get_lang no='2441.Satır Sayısı Değer Girmelisiniz'>!");
		return false;
	}
	return true;
}
</script>
