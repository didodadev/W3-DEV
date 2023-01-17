<!--- 
	Bu sayfada basket ayarlamaları  goruntu duzenlemeleri icin  secme ekranıdır.
	setup_basket tablosundaki B_TYPE alani 1 olan kayıtlar eklenir.
	B_TYPE =1 demek isleme sayfasi demektir.B_TYPE=0 olsa idi goruntu sayfası olurdu.
 --->
<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)>
    <cfquery name="GET_MODULE_DSP" datasource="#DSN3#">
        SELECT * FROM SETUP_BASKET_ROWS WHERE BASKET_ID = #attributes.add_basket_id# AND B_TYPE=1
    </cfquery>
    <cfquery name="get_basket_this" datasource="#DSN3#">
        SELECT
            *
        FROM
            SETUP_BASKET
        WHERE
            B_TYPE = 1 AND 
            BASKET_ID = #attributes.add_basket_id#
        ORDER BY
            BASKET_ID
    </cfquery>
</cfif>

<cfform name="add_basket_details" method="post" action="#request.self#?fuseaction=settings.add_bskt_detail_act">
<input type="hidden" name="basket_id_" id="basket_id_" value="<cfoutput>#basket_id_#</cfoutput>" />
<input type="hidden" name="add_basket_id" id="add_basket_id" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#attributes.add_basket_id#</cfoutput></cfif>" />
<input type="hidden" name="sec_id" id="sec_id" value="<cfoutput>#sec_id#</cfoutput>"/>
<input type="hidden" name="b_type" id="b_type" value="<cfoutput>#b_type#</cfoutput>"/>
    <table width="100%">
        <tr class="color-list">
            <td class="txtbold"><input type="checkbox" name="select_all" id="select_all" onClick="sec();" /><cf_get_lang no='705.Hepsini Seç'></td>
        </tr>
    </table>
    <table>
            <tr class="txtboldblue">
                <td><cf_get_lang_main no='1281.Seç'></td>
                <td><cf_get_lang_main no='1165.Sıra'></td>
                <td><cf_get_lang no='670.En'></td>
                <td><cf_get_lang no='818.Basket Adı'></td>
                <td><cf_get_lang no='819.Sistem Adı'></td>
            </tr>
            <cfif not listfind('14,15',attributes.basket_id_)>
                <tr>
                    <td><cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'basket_cursor'</cfquery></cfif>
                        <input type="checkbox" name="module_content" id="module_content" value="basket_cursor" <cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id) and get_detail.IS_SELECTED>checked<cfelseif not isdefined('attributes.add_basket_id')>checked</cfif>>
                    </td>
                    <td>&nbsp;</td>
                    <td>&nbsp;</td>
                    <td><input type="textbox"  name="basket_cursor" id="basket_cursor" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.TITLE_NAME#</cfoutput><cfelse><cf_get_lang_main no='221.Barkod'></cfif>"></td>
                    <td colspan="3"><cf_get_lang no='393.Barkod Cihazı'></td>
                </tr>
            </cfif>
            <tr>
                <td><cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'stock_code'</cfquery></cfif>
                <input type="checkbox" name="module_content" id="module_content" value="stock_code" <cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id) and get_detail.IS_SELECTED>checked<cfelseif not isdefined('attributes.add_basket_id')>checked</cfif>></td>
                <td><input type="text" name="stock_code_sira" id="stock_code_sira" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.line_order_no#</cfoutput><cfelse>1</cfif>" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3" style="width:25px;"></td>
                <td><input type="text"  name="stock_code_genislik" id="stock_code_genislik"  value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.genislik#</cfoutput><cfelse>50</cfif>" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3" style="width:35px"></td>
                <td><input type="textbox" name="stock_code" id="stock_code" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.title_name#</cfoutput><cfelse><cf_get_lang_main no='106.Stok Kodu'></cfif>" maxlength="200"></td>
                <td><cf_get_lang_main no='106.Stok Kodu'></td>
            </tr>
            <tr>
                <td><cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'special_code'</cfquery></cfif>
                <input type="checkbox" name="module_content" id="module_content" value="special_code" <cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id) and get_detail.IS_SELECTED>checked</cfif>></td>
                <td><input type="text" name="special_code_sira" id="special_code_sira" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.line_order_no#</cfoutput><cfelse>1</cfif>" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3" style="width:25px;"></td>
                <td><input type="text"  name="special_code_genislik" id="special_code_genislik"  value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.genislik#</cfoutput><cfelse>50</cfif>" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3" style="width:35px"></td>
                <td><input type="textbox" name="special_code" id="special_code" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.title_name#</cfoutput><cfelse><cf_get_lang_main no='377.ÖZel Kod'></cfif>" maxlength="200"></td>
                <td><cf_get_lang_main no='377.Özel Kod'></td>
            </tr>
            <cfif session.ep.our_company_info.workcube_sector is 'tersane'>
                <tr>
                    <td><cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'pbs_code'</cfquery></cfif>
                    <input type="checkbox" name="module_content" id="module_content" value="pbs_code" <cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id) and get_detail.IS_SELECTED>checked</cfif>></td>
                    <td><input type="text" name="pbs_code_sira" id="pbs_code_sira" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.line_order_no#</cfoutput><cfelse>1</cfif>" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3" style="width:25px;"></td>
                    <td><input type="text"  name="pbs_code_genislik" id="pbs_code_genislik"  value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.genislik#</cfoutput><cfelse>50</cfif>" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3" style="width:35px"></td>
                    <td><input type="textbox" name="pbs_code" id="pbs_code" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.title_name#</cfoutput><cfelse><cf_get_lang no='3170.PBS Kodu'></cfif>" maxlength="200"></td>
                    <td><cf_get_lang no='3170.PBS Kodu'></td>
                </tr>
            </cfif>
            <tr>
                <td><cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'Barcod'</cfquery></cfif>
                <input type="checkbox" name="module_content" id="module_content" value="Barcod" <cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id) and get_detail.IS_SELECTED>checked</cfif>></td>
                <td><input type="text" name="Barcod_sira" id="Barcod_sira" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.line_order_no#</cfoutput><cfelse>3</cfif>" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3" style="width:25px"></td>
                <td><input type="text" name="Barcod_genislik" id="Barcod_genislik"  value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.genislik#</cfoutput><cfelse>50</cfif>" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3" style="width:35px"></td>
                <td><input type="textbox" name="Barcod" id="Barcod" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.title_name#</cfoutput><cfelse><cf_get_lang_main no='221.Barkod'></cfif>" maxlength="200"></td>
                <td><cf_get_lang_main no='221.Barkod'></td>
            </tr>
            <tr><cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'manufact_code'</cfquery></cfif>
                <td><input type="checkbox" name="module_content" value="manufact_code" <cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id) and get_detail.IS_SELECTED>checked<cfelseif not isdefined('attributes.add_basket_id')>checked</cfif> id="manufact_code_box"></td>
                <td><input type="text" name="manufact_code_sira" id="manufact_code_sira" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.line_order_no#</cfoutput><cfelse>2</cfif>" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3" style="width:25px"></td>
                <td><input type="text" name="manufact_code_genislik" id="manufact_code_genislik" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.genislik#</cfoutput><cfelse>50</cfif>" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3" style="width:35px"></td>
                <td><input type="text" name="manufact_code" id="manufact_code" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.TITLE_NAME#</cfoutput><cfelse><cf_get_lang_main no='222.Üretici Kodu'></cfif>" maxlength="200"></td>
                <td><cf_get_lang_main no='222.Üretici Kodu'></td>
            </tr>
            <tr>
                <td><cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'product_name'</cfquery></cfif>			  				  				  
                    <input type="checkbox" name="module_content" id="module_content" value="product_name" <cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id) and get_detail.IS_SELECTED>checked<cfelseif not isdefined('attributes.add_basket_id')>checked</cfif>></td>
                <td><input type="text" name="product_name_sira" id="product_name_sira" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.line_order_no#</cfoutput><cfelse>4</cfif>" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3" style="width:25px"></td>
                <td><input type="text" name="product_name_genislik" id="product_name_genislik" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.genislik#</cfoutput><cfelse>100</cfif>" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"  style="width:35px"></td>
                <td><input type="text" name="product_name" id="product_name" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.TITLE_NAME#</cfoutput><cfelse><cf_get_lang_main no='245.Ürün'></cfif>" maxlength="200"></td>
                <td><select name="product_name_readonly" id="product_name_readonly"><!--- ilerde, sıra ve genişlik özellikleri gibi diger alanlara da readonly degeri atanabilir --->
                        <option value="0" <cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id) and len(get_detail.IS_READONLY) and get_detail.IS_READONLY eq 0>selected<cfelse>selected</cfif>><cf_get_lang no='2923.Değiştirilebilir'></option>
                        <option value="1" <cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id) and len(get_detail.IS_READONLY) and get_detail.IS_READONLY eq 1>selected</cfif>><cf_get_lang no='2924.Değiştirilemez'></option>
                    </select>
                    <cf_get_lang no='394.Ürün İsmi'></td>
            </tr>
            <tr>
                <td><cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'Amount'</cfquery></cfif>
                    <input type="checkbox" name="module_content" id="module_content" value="Amount" <cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id) and get_detail.IS_SELECTED>checked<cfelseif not isdefined('attributes.add_basket_id')>checked</cfif>>
                </td>
                <td><input type="text" name="Amount_sira" id="Amount_sira" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.line_order_no#</cfoutput><cfelse>7</cfif>" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3" style="width:25px"></td>				  
                <td><input type="text" name="Amount_genislik" id="Amount_genislik" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.genislik#</cfoutput><cfelse>20</cfif>" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3" style="width:35px"></td>
                <td><input type="textbox" name="Amount" id="Amount" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.TITLE_NAME#</cfoutput><cfelse><cf_get_lang_main no='223.Miktar'></cfif>" maxlength="200"></td>
                <td><select name="amount_round" id="amount_round">
                        <option value="0" <cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id) and isdefined('get_basket_this.amount_round') and len(get_basket_this.amount_round) and get_basket_this.amount_round eq 0>selected</cfif>>0</option>
                        <option value="1" <cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id) and isdefined('get_basket_this.amount_round') and len(get_basket_this.amount_round) and get_basket_this.amount_round eq 1>selected</cfif>>1</option>
                        <option value="2" <cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id) and isdefined('get_basket_this.amount_round') and len(get_basket_this.amount_round) and get_basket_this.amount_round eq 2>selected</cfif>>2</option>
                        <option value="3" <cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id) and isdefined('get_basket_this.amount_round') and len(get_basket_this.amount_round) and get_basket_this.amount_round eq 3>selected</cfif>>3</option>
                        <option value="4" <cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id) and isdefined('get_basket_this.amount_round') and len(get_basket_this.amount_round) and get_basket_this.amount_round eq 4>selected</cfif>>4</option>
                    </select>
                    <cf_get_lang_main no='223.Miktar'>
                    <cf_get_lang_main no='577.ve'><cf_get_lang_main no='298.Yuvarlama'>(1 - 1,1 - 1,111 - 1,1111 <cf_get_lang no='1070.şeklinde miktar düzenlenir'>)
                </td>
            </tr>
            <tr>
                <td><cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'Unit'</cfquery></cfif>			  
                    <input type="checkbox" name="module_content" id="module_content" value="Unit" <cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id) and get_detail.IS_SELECTED>checked<cfelseif not isdefined('attributes.add_basket_id')>checked</cfif>></td>
                <td><input type="text" name="Unit_sira" id="Unit_sira" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.line_order_no#</cfoutput><cfelse>8</cfif>" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3" style="width:25px"></td>					
                <td><input type="text" name="Unit_genislik" id="Unit_genislik" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.genislik#</cfoutput><cfelse>20</cfif>" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3" style="width:35px"></td>
                <td><input type="textbox" name="Unit" id="Unit" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.TITLE_NAME#</cfoutput><cfelse><cf_get_lang_main no='224.Birim'></cfif>"maxlength="200"></td>
                <td><cf_get_lang_main no='224.Birim'></td>
            </tr>
            <tr>
                <td><cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'Tax'</cfquery></cfif>			  
                    <input type="checkbox" name="module_content" id="module_content" value="Tax" <cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id) and get_detail.IS_SELECTED>checked<cfelseif not isdefined('attributes.add_basket_id')>checked</cfif>></td>
                <td><input type="text" name="Tax_sira" id="Tax_sira" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.line_order_no#</cfoutput><cfelse>35</cfif>" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3" style="width:25px"></td>					
                <td><input type="text" name="Tax_genislik" id="Tax_genislik" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.genislik#</cfoutput><cfelse>20</cfif>" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3" style="width:35px"></td>
                <td><input type="textbox" name="Tax" id="Tax" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.TITLE_NAME#</cfoutput><cfelse><cf_get_lang_main no='227.KDV'></cfif>" maxlength="200"></td>
                <td><cf_get_lang no='610.Vergi KDV'>(%) </td>
            </tr>
            <tr>
                <td><cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'OTV'</cfquery></cfif>			  
                    <input type="checkbox" name="module_content" value="OTV" <cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id) and get_detail.IS_SELECTED>checked<cfelseif not isdefined('attributes.add_basket_id')>checked</cfif> id="otv_box"></td>
                <td><input type="text" name="OTV_sira" id="OTV_sira" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.line_order_no#</cfoutput><cfelse>37</cfif>" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3" style="width:25px"></td>					
                <td><input type="text" name="OTV_genislik" id="OTV_genislik" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.genislik#</cfoutput><cfelse>20</cfif>" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3" style="width:35px"></td>
                <td><input type="textbox" name="OTV" id="OTV" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.TITLE_NAME#</cfoutput><cfelse>OTV</cfif>" maxlength="200"></td>
                <td><cf_get_lang_main no ='609.ÖTV'> (%)</td>
            </tr>
            <tr>
                <td><cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'List_price'</cfquery></cfif>
                    <input type="checkbox" name="module_content" value="List_price" <cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id) and get_detail.IS_SELECTED>checked<cfelseif not isdefined('attributes.add_basket_id')>checked</cfif> id="list_price_box"></td>
                <td><input type="text" name="List_price_sira" id="List_price_sira" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.line_order_no#</cfoutput><cfelse>13</cfif>" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3" style="width:25px"></td>					
                <td><input type="text" name="List_price_genislik" id="List_price_genislik" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.genislik#</cfoutput><cfelse>50</cfif>" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3" style="width:35px"></td>
                <td><input type="textbox" name="List_price" id="List_price" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.TITLE_NAME#</cfoutput><cfelse><cf_get_lang no='2427.Liste Fiyatı'></cfif>" maxlength="200"></td>
                <td><cf_get_lang no='2427.Liste Fiyatı'></td>
            </tr>
            <tr>
                <td><cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'list_price_discount'</cfquery></cfif>
                    <input type="checkbox" name="module_content" value="list_price_discount" <cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id) and get_detail.IS_SELECTED>checked<cfelseif not isdefined('attributes.add_basket_id')>checked</cfif> id="list_price_discount_box"></td>
                <td><input type="text" name="list_price_discount_sira" id="list_price_discount_sira" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.line_order_no#</cfoutput><cfelse>13</cfif>" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3" style="width:25px"></td>					
                <td><input type="text" name="list_price_discount_genislik" id="list_price_discount_genislik" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.genislik#</cfoutput><cfelse>50</cfif>" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3" style="width:35px"></td>
                <td><input type="textbox" name="list_price_discount" id="list_price_discount" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.TITLE_NAME#</cfoutput><cfelse><cf_get_lang no='1701.Liste Fiyatı İskontosu'></cfif>" maxlength="200"></td>
                <td><cf_get_lang no='1701.Liste Fiyatı İskontosu'></td>
            </tr>
            <tr>
                <td><cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'Price'</cfquery></cfif>
                    <input type="checkbox" name="module_content" id="module_content" value="Price" <cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id) and get_detail.IS_SELECTED>checked<cfelseif not isdefined('attributes.add_basket_id')>checked</cfif>></td>
                <td><input type="text" name="Price_sira" id="Price_sira" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.line_order_no#</cfoutput><cfelse>16</cfif>" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3" style="width:25px"></td>					
                <td><input type="text" name="Price_genislik" id="Price_genislik" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.genislik#</cfoutput><cfelse>50</cfif>" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3" style="width:35px"></td>
                <td><input type="textbox" name="Price" id="Price" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.TITLE_NAME#</cfoutput><cfelse><cf_get_lang_main no='672.Fiyat'></cfif>" maxlength="200"></td>
                <td><cf_get_lang_main no='672.Fiyat'></td>
            </tr>
            <tr>
                <td><cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'tax_price'</cfquery></cfif>
                    <input type="checkbox" name="module_content" id="module_content" value="tax_price" <cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id) and get_detail.IS_SELECTED>checked<cfelseif not isdefined('attributes.add_basket_id')>checked</cfif>></td>
                <td><input type="text" name="tax_price_sira" id="tax_price_sira" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.line_order_no#</cfoutput><cfelse>36</cfif>" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3" style="width:25px"></td>					
                <td><input type="text" name="tax_price_genislik" id="tax_price_genislik" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.genislik#</cfoutput><cfelse>50</cfif>" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3" style="width:35px"></td>
                <td><input type="textbox" name="tax_price" id="tax_price" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.TITLE_NAME#</cfoutput><cfelse><cf_get_lang no='1914.KDV li Birim Fiyat'></cfif>" maxlength="200"></td>
                <td><cf_get_lang no ='1914.KDV li Birim Fiyat'></td>
            </tr>
            <tr>
                <td><cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'other_money'</cfquery></cfif>
                    <input type="checkbox" name="module_content" id="module_content" value="other_money" <cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id) and get_detail.IS_SELECTED>checked<cfelseif not isdefined('attributes.add_basket_id')>checked</cfif>></td>
                <td><input type="text" name="other_money_sira" id="other_money_sira" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.line_order_no#</cfoutput><cfelse>17</cfif>" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3" style="width:25px"></td>					
                <td><input type="text" name="other_money_genislik" id="other_money_genislik" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.genislik#</cfoutput><cfelse>20</cfif>" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3" style="width:35px"></td>
                <td><input type="textbox" name="other_money" id="other_money" maxlength="200" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.TITLE_NAME#</cfoutput><cfelse><cf_get_lang_main no='265.Döviz'></cfif>" ></td>
                <td><cf_get_lang_main no='265.Döviz'></td>
            </tr>						
            <tr>
                <td><cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'price_other'</cfquery></cfif>
                    <input type="checkbox" name="module_content" id="module_content" value="price_other" <cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id) and get_detail.IS_SELECTED>checked<cfelseif not isdefined('attributes.add_basket_id')>checked</cfif>></td>
                <td><input type="text" name="PRICE_OTHER_sira" id="PRICE_OTHER_sira" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.line_order_no#</cfoutput><cfelse>18</cfif>" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3" style="width:25px"></td>				  
                <td><input type="text" name="PRICE_OTHER_genislik" id="PRICE_OTHER_genislik" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.genislik#</cfoutput><cfelse>20</cfif>" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3" style="width:35px"></td>
                <td><input type="textbox" name="PRICE_OTHER" id="PRICE_OTHER" maxlength="200" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.TITLE_NAME#</cfoutput><cfelse><cf_get_lang_main no='265.Döviz'><cf_get_lang_main no='672.Fiyat'></cfif>"></td>
                <td><cf_get_lang_main no='265.Döviz'><cf_get_lang_main no='672.Fiyat'></td>
            </tr>
            <tr>
                <td><cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'product_name2'</cfquery></cfif>				  				  				  
                    <input type="checkbox" name="module_content" value="product_name2" id="product_name2_box" <cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id) and get_detail.IS_SELECTED>checked<cfelseif not isdefined('attributes.add_basket_id')>checked</cfif>></td>
                <td><input type="text" name="product_name2_sira" id="product_name2_sira" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.line_order_no#</cfoutput><cfelse>6</cfif>" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3" style="width:25px"></td>
                <td><input type="text" name="product_name2_genislik" id="product_name2_genislik" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.genislik#</cfoutput><cfelse>100</cfif>" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"  style="width:35px"></td>
                <td><input type="textbox" name="product_name2" id="product_name2" maxlength="200" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.TITLE_NAME#</cfoutput><cfelse><cf_get_lang_main no='217.Açıklama'>2</cfif>"></td>
                <td><cf_get_lang_main no='217.Açıklama'>2 (<cf_get_lang no='1060.Etiket No, Özel Açıklama, Üründeki'>2. <cf_get_lang no='1076.Açıklama yazılabilir'>)</td>
            </tr>
            <tr>
                <td><cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'Amount2'</cfquery></cfif>
                    <input type="checkbox" name="module_content" value="Amount2" id="Amount2_box" <cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id) and get_detail.IS_SELECTED>checked</cfif>></td>
                <td><input type="text" name="Amount2_sira" id="Amount2_sira" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.line_order_no#</cfoutput><cfelse>10</cfif>" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3" style="width:25px"></td>				  
                <td><input type="text" name="Amount2_genislik" id="Amount2_genislik" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.genislik#</cfoutput><cfelse>20</cfif>" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3" style="width:35px"></td>
                <td><input type="textbox" name="Amount2" id="Amount2" maxlength="200" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.TITLE_NAME#</cfoutput><cfelse><cf_get_lang_main no='223.Miktar'> 2</cfif>"></td>
                <td><cf_get_lang_main no='223.Miktar'> 2</td>
            </tr>
            <tr>
                <td><cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'Unit2'</cfquery></cfif>				  
                    <input type="checkbox" name="module_content" value="Unit2" id="Unit2_box" <cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id) and get_detail.IS_SELECTED > Checked</cfif>></td>
                <td><input type="text" name="Unit2_sira" id="Unit2_sira" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.line_order_no#</cfoutput><cfelse>9</cfif>" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3" style="width:25px"></td>					
                <td><input type="text" name="Unit2_genislik" id="Unit2_genislik" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.genislik#</cfoutput><cfelse>20</cfif>" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3" style="width:35px"></td>
                <td><input type="textbox" name="Unit2" id="Unit2" maxlength="200" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.TITLE_NAME#</cfoutput><cfelse><cf_get_lang_main no='224.Birim'>2</cfif>"></td>
                <td><cf_get_lang_main no='224.Birim'>2 (<cf_get_lang no='1923.Stoğun Birimi'>)</td>
            </tr>
            <tr>
                <td><cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'basket_extra_info'</cfquery></cfif>				  
                    <input type="checkbox" name="module_content" value="basket_extra_info" id="basket_extra_info_box" <cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id) and get_detail.IS_SELECTED > Checked</cfif>></td>
                <td><input type="text" name="basket_extra_info_sira" id="basket_extra_info_sira" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.line_order_no#</cfoutput><cfelse>48</cfif>" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3" style="width:25px"></td>					
                <td><input type="text" name="basket_extra_info_genislik" id="basket_extra_info_genislik" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.genislik#</cfoutput><cfelse>20</cfif>" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3" style="width:35px"></td>
                <td><input type="textbox" name="basket_extra_info" id="basket_extra_info" maxlength="200" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.TITLE_NAME#</cfoutput><cfelse><cf_get_lang no='698.Ek Açıklama'></cfif>"></td>
                <td><cf_get_lang no ='1915.Ek Açıklama (Basket Ek Açıklama Bölümünde Tanımlanmış Standart Açıklamalar)'></td>
            </tr>
            <tr>
                <td><cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'select_info_extra'</cfquery></cfif>				  
                    <input type="checkbox" name="module_content" value="select_info_extra" id="select_info_extra_box" <cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id) and get_detail.IS_SELECTED > Checked</cfif>></td>
                <td><input type="text" name="select_info_extra_sira" id="select_info_extra_sira" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.line_order_no#</cfoutput><cfelse>48</cfif>" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3" style="width:25px"></td>					
                <td><input type="text" name="select_info_extra_genislik" id="select_info_extra_genislik" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.genislik#</cfoutput><cfelse>20</cfif>" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3" style="width:35px"></td>
                <td><input type="textbox" name="select_info_extra" id="select_info_extra" maxlength="200" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.TITLE_NAME#</cfoutput><cfelse><cf_get_lang no='698.Ek Açıklama'> 2</cfif>"></td>
                <td><cf_get_lang no ='1915.Ek Açıklama (Basket Ek Açıklama Bölümünde Tanımlanmış Standart Açıklamalar)'></td>
            </tr>
            <tr>
                <td><cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'detail_info_extra'</cfquery></cfif>				  				  				  
                    <input type="checkbox" name="module_content" value="detail_info_extra" id="detail_info_extra_box" <cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id) and get_detail.IS_SELECTED>checked<cfelseif not isdefined('attributes.add_basket_id')>checked</cfif>></td>
                <td><input type="text" name="detail_info_extra_sira" id="detail_info_extra_sira" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.line_order_no#</cfoutput><cfelse>6</cfif>" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3" style="width:25px"></td>
                <td><input type="text" name="detail_info_extra_genislik" id="detail_info_extra_genislik" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.genislik#</cfoutput><cfelse>100</cfif>" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"  style="width:35px"></td>
                <td><input type="textbox" name="detail_info_extra" id="detail_info_extra" maxlength="200" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.TITLE_NAME#</cfoutput><cfelse><cf_get_lang_main no='217.Açıklama'>3</cfif>"></td>
                <td><cf_get_lang_main no='217.Açıklama'>3 (<cf_get_lang no='1060.Etiket No, Özel Açıklama, Üründeki'>3. <cf_get_lang no='1076.Açıklama yazılabilir'>)</td>
            </tr>
            <cfif listfind('2',attributes.basket_id_)>
            <tr>
                <td>
					<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'reason_code'</cfquery></cfif>				  
                    <input type="checkbox" name="module_content" value="reason_code" id="reason_code_box" <cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id) and get_detail.is_selected> Checked</cfif>>
             	</td>
                <td><input type="text" name="reason_code_sira" id="reason_code_sira" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.line_order_no#</cfoutput><cfelse>35</cfif>" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3" style="width:25px"></td>					
                <td><input type="text" name="reason_code_genislik" id="reason_code_genislik" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.genislik#</cfoutput><cfelse>20</cfif>" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3" style="width:35px"></td>
                <td><input type="textbox" name="reason_code" id="reason_code" maxlength="200" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.TITLE_NAME#</cfoutput><cfelse><cf_get_lang no='1475.İstisna Kodu'></cfif>"></td>
                <td><cf_get_lang no='1475.İstisna Kodu'></td>
            </tr>
           	</cfif>         
        </table>
        <cf_seperator header="#getLang('settings',681)#" id="urun_boyut_bilgileri">
        <table id="urun_boyut_bilgileri">
      <tr>
                <td><cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'row_width'</cfquery></cfif>				  
                    <input type="checkbox" name="module_content" value="row_width" id="row_width_box" <cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id) and get_detail.IS_SELECTED > Checked</cfif>></td>
                <td><input type="text" name="row_width_sira" id="row_width_sira" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.line_order_no#</cfoutput><cfelse>9</cfif>" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3" style="width:25px"></td>					
                <td><input type="text" name="row_width_genislik" id="row_width_genislik" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.genislik#</cfoutput><cfelse>20</cfif>" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3" style="width:35px"></td>
                <td><input type="textbox" name="row_width" id="row_width" maxlength="200" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.TITLE_NAME#</cfoutput><cfelse><cf_get_lang_main no='283.Genişlik'></cfif>"></td>
                <td><cf_get_lang_main no='283.Genişlik'></td>
            </tr>
            <tr>
                <td><cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'row_depth'</cfquery></cfif>				  
                    <input type="checkbox" name="module_content" value="row_depth" id="row_depth_box" <cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id) and get_detail.IS_SELECTED > Checked</cfif>></td>
                <td><input type="text" name="row_depth_sira" id="row_depth_sira" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.line_order_no#</cfoutput><cfelse>9</cfif>" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3" style="width:25px"></td>					
                <td><input type="text" name="row_depth_genislik" id="row_depth_genislik" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.genislik#</cfoutput><cfelse>20</cfif>" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3" style="width:35px"></td>
                <td><input type="textbox" name="row_depth" id="row_depth" maxlength="200" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.TITLE_NAME#</cfoutput><cfelse><cf_get_lang no='692.Derinlik'></cfif>"></td>
                <td><cf_get_lang no='692.Derinlik'></td>
            </tr>
            <tr>
                <td><cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'row_height'</cfquery></cfif>				  
                    <input type="checkbox" name="module_content" value="row_height" id="row_width_box" <cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id) and get_detail.IS_SELECTED > Checked</cfif>></td>
                <td><input type="text" name="row_height_sira" id="row_height_sira" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.line_order_no#</cfoutput><cfelse>9</cfif>" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3" style="width:25px"></td>					
                <td><input type="text" name="row_height_genislik" id="row_height_genislik" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.genislik#</cfoutput><cfelse>20</cfif>" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3" style="width:35px"></td>
                <td><input type="textbox" name="row_height" id="row_height" maxlength="200" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.TITLE_NAME#</cfoutput><cfelse><cf_get_lang_main no='284.Yükseklik'></cfif>"></td>
                <td><cf_get_lang_main no='284.Yükseklik'></td>
            </tr>
          </table>
        <cf_seperator header="#getLang('settings',1054)#" id="indirim_maliyet_ve_hesaplama_bilgileri">
        <!--- ikincil bilgiler --->
  <table id="indirim_maliyet_ve_hesaplama_bilgileri">
            <tr>
                <td><cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'ek_tutar'</cfquery></cfif>				
                    <input type="checkbox" name="module_content" value="ek_tutar" <cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id) and get_detail.IS_SELECTED>checked<cfelseif not isdefined('attributes.add_basket_id')>checked</cfif> id="ek_tutar_box"></td>
                <td><input type="text" name="ek_tutar_sira" id="ek_tutar_sira" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.line_order_no#</cfoutput><cfelse>19</cfif>" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3" style="width:25px"></td>					
                <td><input type="text" name="ek_tutar_genislik" id="ek_tutar_genislik" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.genislik#</cfoutput><cfelse>40</cfif>" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3" style="width:35px"></td>
                <td><input type="textbox" name="ek_tutar" id="ek_tutar" maxlength="200" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.TITLE_NAME#</cfoutput><cfelse><cf_get_lang no='1037.Ek Tutar'></cfif>"></td>
                <td><cf_get_lang no='1037.Ek Tutar'>(<cf_get_lang no='1071.Mal veya Hizmete İlişkin Ek Bir Fiyat'>: <cf_get_lang_main no='372.İşcilik'> vb.)</td>
            </tr>
            <tr>
                <td><cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'ek_tutar_price'</cfquery></cfif>				
                    <input type="checkbox" name="module_content" value="ek_tutar_price" <cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id) and get_detail.IS_SELECTED>checked<cfelseif not isdefined('attributes.add_basket_id')>checked</cfif> id="ek_tutar_price_box"></td>
                <td><input type="text" name="ek_tutar_price_sira" id="ek_tutar_price_sira" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.line_order_no#</cfoutput><cfelse>19</cfif>" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3" style="width:25px"></td>					
                <td><input type="text" name="ek_tutar_price_genislik" id="ek_tutar_price_genislik" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.genislik#</cfoutput><cfelse>40</cfif>" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3" style="width:35px"></td>
                <td><input type="textbox" name="ek_tutar_price" id="ek_tutar_price" maxlength="200" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.TITLE_NAME#</cfoutput><cfelse><cf_get_lang no='1700.İşçilik Birim Ücreti'></cfif>"></td>
                <td><cf_get_lang no='1700.İşçilik Birim Ücreti'></td>
            </tr>
            <tr>
                <td><cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'ek_tutar_cost'</cfquery></cfif>				
                    <input type="checkbox" name="module_content" value="ek_tutar_cost" <cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id) and get_detail.IS_SELECTED>checked<cfelseif not isdefined('attributes.add_basket_id')>checked</cfif> id="ek_tutar_cost_box"></td>
                <td><input type="text" name="ek_tutar_cost_sira" id="ek_tutar_cost_sira" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.line_order_no#</cfoutput><cfelse>22</cfif>" style="width:25px"  class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>					
                <td><input type="text" name="ek_tutar_cost_genislik" id="ek_tutar_cost_genislik" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.genislik#</cfoutput><cfelse>20</cfif>" style="width:35px"  class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>
                <td><input type="textbox" name="ek_tutar_cost" id="ek_tutar_cost" maxlength="200" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.TITLE_NAME#</cfoutput><cfelse><cf_get_lang no='1634.İşçilik Maliyet'></cfif>"></td>
                <td><cf_get_lang no='1634.İşçilik Maliyet'></td>
            </tr>
            <tr>
                <td><cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'ek_tutar_marj'</cfquery></cfif>				
                    <input type="checkbox" name="module_content" value="ek_tutar_marj" <cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id) and get_detail.IS_SELECTED>checked<cfelseif not isdefined('attributes.add_basket_id')>checked</cfif> id="ek_tutar_marj_box"></td>
                <td><input type="text" name="ek_tutar_marj_sira" id="ek_tutar_marj_sira" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.line_order_no#</cfoutput><cfelse>22</cfif>" style="width:25px"  class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>					
                <td><input type="text" name="ek_tutar_marj_genislik" id="ek_tutar_marj_genislik" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.genislik#</cfoutput><cfelse>20</cfif>" style="width:35px"  class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>
                <td><input type="textbox" name="ek_tutar_marj" id="ek_tutar_marj" maxlength="200" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.TITLE_NAME#</cfoutput><cfelse><cf_get_lang no='1635.Ek Tutar Marj'></cfif>"></td>
                <td><cf_get_lang no='1635.Ek Tutar Marj'></td>
            </tr>
            <tr>
                <td><cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'ek_tutar_other_total'</cfquery></cfif>
                    <input type="checkbox" name="module_content" value="ek_tutar_other_total" <cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id) and get_detail.IS_SELECTED>checked<cfelseif not isdefined('attributes.add_basket_id')>checked</cfif> id="ek_tutar_other_total_box"></td>
                <td><input type="text" name="ek_tutar_other_total_sira" id="ek_tutar_other_total_sira" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.line_order_no#</cfoutput><cfelse>20</cfif>" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3" style="width:25px"></td>					
                <td><input type="text" name="ek_tutar_other_total_genislik" id="ek_tutar_other_total_genislik" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.genislik#</cfoutput><cfelse>40</cfif>" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3" style="width:35px"></td>
                <td><input type="textbox" name="ek_tutar_other_total" id="ek_tutar_other_total" maxlength="200" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.TITLE_NAME#</cfoutput><cfelse><cf_get_lang no='1606.Satır Ek Tutar Toplamı'></cfif>"></td>
                <td><cf_get_lang no='1606.Satır Ek Tutar Toplamı'> (<cf_get_lang no='1037.Ek Tutar'> * <cf_get_lang_main no='223.Miktar'>)</td>
            </tr>
            <tr>
                <td><cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'iskonto_tutar'</cfquery></cfif>				
                    <input type="checkbox" name="module_content" value="iskonto_tutar" <cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id) and get_detail.IS_SELECTED>checked<cfelseif not isdefined('attributes.add_basket_id')>checked</cfif> id="iskonto_tutar_box"></td>
                <td><input type="text" name="iskonto_tutar_sira" id="iskonto_tutar_sira" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.line_order_no#</cfoutput><cfelse>21</cfif>" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3" style="width:25px"></td>					
                <td><input type="text" name="iskonto_tutar_genislik" id="iskonto_tutar_genislik" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.genislik#</cfoutput><cfelse>40</cfif>" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3" style="width:35px"></td>
                <td><input type="textbox" name="iskonto_tutar" id="iskonto_tutar" maxlength="200" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.TITLE_NAME#</cfoutput><cfelse><cf_get_lang no='1038.İskonto Tutar'></cfif>"></td>
                <td><cf_get_lang_main no='261.tutar'><cf_get_lang_main no='229.İndirim'></td>
            </tr>
            <tr>
                <td><cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'disc_ount'</cfquery></cfif>				  
                    <input type="checkbox" name="module_content" value="disc_ount" <cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id) and get_detail.IS_SELECTED>checked<cfelseif not isdefined('attributes.add_basket_id')>checked</cfif> id="disc_ount_box"></td>
                <td><input type="text" name="disc_ount_sira" id="disc_ount_sira" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.line_order_no#</cfoutput><cfelse>22</cfif>" style="width:25px"  class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>					
                <td><input type="text" name="disc_ount_genislik" id="disc_ount_genislik" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.genislik#</cfoutput><cfelse>20</cfif>" style="width:35px"  class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>
                <td><input type="textbox" name="disc_ount" id="disc_ount" maxlength="200" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.TITLE_NAME#</cfoutput><cfelse><cf_get_lang_main no='229.İSK'>1</cfif>"></td>
                <td><cf_get_lang_main no='229.İndirim'>1</td>
            </tr>
            <tr>
                <td><cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'disc_ount2_'</cfquery></cfif>				  
                    <input type="checkbox" name="module_content" value="disc_ount2_" <cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id) and get_detail.IS_SELECTED>checked<cfelseif not isdefined('attributes.add_basket_id')>checked</cfif> id="disc_ount2_box"></td>
                <td><input type="text" name="disc_ount2__sira" id="disc_ount2__sira" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.line_order_no#</cfoutput><cfelse>23</cfif>" style="width:25px" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>					
                <td><input type="text" name="disc_ount2__genislik" id="disc_ount2__genislik" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.genislik#</cfoutput><cfelse>20</cfif>" style="width:35px" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>
                <td><input type="textbox" name="disc_ount2_" id="disc_ount2_" maxlength="200" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.TITLE_NAME#</cfoutput><cfelse><cf_get_lang_main no='229.İSK'>2</cfif>"></td>
                <td><cf_get_lang_main no='229.İndirim'>2</td>
            </tr>
            <tr>
                <td><cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'disc_ount3_'</cfquery></cfif>				  
                    <input type="checkbox" name="module_content" value="disc_ount3_" <cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id) and get_detail.IS_SELECTED>checked<cfelseif not isdefined('attributes.add_basket_id')>checked</cfif> id="disc_ount3_box"></td>
                <td><input type="text" name="disc_ount3__sira" id="disc_ount3__sira" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.line_order_no#</cfoutput><cfelse>24</cfif>" style="width:25px"  class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>					
                <td><input type="text" name="disc_ount3__genislik" id="disc_ount3__genislik" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.genislik#</cfoutput><cfelse>20</cfif>" style="width:35px"  class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>
                <td><input type="textbox" name="disc_ount3_" id="disc_ount3_" maxlength="200" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.TITLE_NAME#</cfoutput><cfelse><cf_get_lang_main no='229.İSK'>3</cfif>"></td>
                <td><cf_get_lang_main no='229.İndirim'>3</td>
            </tr>
            <tr>		  
                <td><cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'disc_ount4_'</cfquery></cfif>				  
                    <input type="checkbox" name="module_content" value="disc_ount4_" id="disc_ount4_box" <cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id) and get_detail.IS_SELECTED > Checked</cfif>></td>
                <td><input type="text" name="disc_ount4__sira" id="disc_ount4__sira" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.line_order_no#</cfoutput><cfelse>25</cfif>" style="width:25px"  class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>					
                <td><input type="text" name="disc_ount4__genislik" id="disc_ount4__genislik" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.genislik#</cfoutput><cfelse>20</cfif>" style="width:35px"  class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>
                <td><input type="textbox" name="disc_ount4_" id="disc_ount4_" maxlength="200" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.TITLE_NAME#</cfoutput><cfelse><cf_get_lang_main no='229.İSK'>4</cfif>"></td>
                <td><cf_get_lang_main no='229.İndirim'>4</td>
            </tr>
            <tr>
                <td><cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'disc_ount5_'</cfquery></cfif>				  
                    <input type="checkbox" name="module_content" value="disc_ount5_" id="disc_ount5_box" <cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id) and get_detail.IS_SELECTED > Checked</cfif>></td>
                <td><input type="text" name="disc_ount5__sira" id="disc_ount5__sira" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.line_order_no#</cfoutput><cfelse>26</cfif>" style="width:25px"  class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>					
                <td><input type="text" name="disc_ount5__genislik" id="disc_ount5__genislik" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.genislik#</cfoutput><cfelse>20</cfif>" style="width:35px"  class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>
                <td><input type="textbox" name="disc_ount5_" id="disc_ount5_" maxlength="200" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.TITLE_NAME#</cfoutput><cfelse><cf_get_lang_main no='229.İSK'>5</cfif>"></td>
                <td><cf_get_lang_main no='229.İndirim'>5</td>
            </tr>
            <tr>
                <td><cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'disc_ount6_'</cfquery></cfif>				  
                    <input type="checkbox" name="module_content" value="disc_ount6_" id="disc_ount6_box" <cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id) and get_detail.IS_SELECTED > Checked</cfif>></td>
                <td><input type="text" name="disc_ount6__sira" id="disc_ount6__sira" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.line_order_no#</cfoutput><cfelse>27</cfif>" style="width:25px"  class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>					
                <td><input type="text" name="disc_ount6__genislik" id="disc_ount6__genislik" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.genislik#</cfoutput><cfelse>20</cfif>" style="width:35px"  class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>
                <td><input type="textbox" name="disc_ount6_" id="disc_ount6_" maxlength="200" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.TITLE_NAME#</cfoutput><cfelse><cf_get_lang_main no='229.İSK'>6</cfif>"></td>
                <td><cf_get_lang_main no='229.İndirim'>6</td>
            </tr>
            <tr>
                <td><cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'disc_ount7_'</cfquery></cfif>			  
                    <input type="checkbox" name="module_content" value="disc_ount7_" id="disc_ount7_box" <cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id) and get_detail.IS_SELECTED > Checked</cfif>></td>
                <td><input type="text" name="disc_ount7__sira" id="disc_ount7__sira" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.line_order_no#</cfoutput><cfelse>28</cfif>" style="width:25px"  class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>					
                <td><input type="text" name="disc_ount7__genislik" id="disc_ount7__genislik" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.genislik#</cfoutput><cfelse>20</cfif>" style="width:35px"  class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>
                <td><input type="textbox" name="disc_ount7_" id="disc_ount7_" maxlength="200" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.TITLE_NAME#</cfoutput><cfelse><cf_get_lang_main no='229.İSK'>7</cfif>"></td>
                <td><cf_get_lang_main no='229.İndirim'>7</td>
            </tr>	
            <tr>
                <td><cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'disc_ount8_'</cfquery></cfif>				  
                    <input type="checkbox" name="module_content" value="disc_ount8_" id="disc_ount8_box" <cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id) and get_detail.IS_SELECTED > Checked</cfif>></td>
                <td><input type="text" name="disc_ount8__sira" id="disc_ount8__sira" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.line_order_no#</cfoutput><cfelse>29</cfif>" style="width:25px"  class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>					
                <td><input type="text" name="disc_ount8__genislik" id="disc_ount8__genislik" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.genislik#</cfoutput><cfelse>20</cfif>" style="width:35px"  class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>
                <td><input type="textbox" name="disc_ount8_" id="disc_ount8_" maxlength="200" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.TITLE_NAME#</cfoutput><cfelse><cf_get_lang_main no='229.İSK'>8</cfif>"></td>
                <td><cf_get_lang_main no='229.İndirim'>8</td>
            </tr>
            <tr>
                <td><cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'disc_ount9_'</cfquery></cfif>				  
                    <input type="checkbox" name="module_content" value="disc_ount9_" id="disc_ount9_box" <cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id) and get_detail.IS_SELECTED > Checked</cfif>></td>
                <td><input type="text" name="disc_ount9__sira" id="disc_ount9__sira" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.line_order_no#</cfoutput><cfelse>30</cfif>" style="width:25px"  class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>					
                <td><input type="text" name="disc_ount9__genislik" id="disc_ount9__genislik" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.genislik#</cfoutput><cfelse>20</cfif>" style="width:35px"  class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>
                <td><input type="textbox" name="disc_ount9_" id="disc_ount9_" maxlength="200" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.TITLE_NAME#</cfoutput><cfelse><cf_get_lang_main no='229.İSK'>9</cfif>"></td>
                <td><cf_get_lang_main no='229.İndirim'>9</td>
            </tr>
            <tr>
                <td><cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'disc_ount10_'</cfquery></cfif>			  
                    <input type="checkbox" name="module_content" value="disc_ount10_" id="disc_ount10_box" <cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id) and get_detail.IS_SELECTED > Checked</cfif>></td>
                <td><input type="text" name="disc_ount10__sira" id="disc_ount10__sira" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.line_order_no#</cfoutput><cfelse>31</cfif>" style="width:25px"  class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>					
                <td><input type="text" name="disc_ount10__genislik" id="disc_ount10__genislik" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.genislik#</cfoutput><cfelse>20</cfif>" style="width:35px"  class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>
                <td><input type="textbox" name="disc_ount10_" id="disc_ount10_" maxlength="200" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.TITLE_NAME#</cfoutput><cfelse><cf_get_lang_main no='229.İSK'>10</cfif>"></td>
                <td><cf_get_lang_main no='229.İndirim'>10</td>
            </tr>									
            <tr>
                <td><cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'price_net'</cfquery></cfif>
                    <input type="checkbox" name="module_content" id="module_content" value="price_net" <cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id) and get_detail.IS_SELECTED>checked<cfelseif not isdefined('attributes.add_basket_id')>checked</cfif>></td>
                <td><input type="text" name="PRICE_NET_sira" id="PRICE_NET_sira" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.line_order_no#</cfoutput><cfelse>33</cfif>" style="width:25px" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>				  
                <td><input type="text" name="PRICE_NET_genislik" id="PRICE_NET_genislik" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.genislik#</cfoutput><cfelse>50</cfif>" style="width:35px"  class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>
                <td><input type="textbox" name="PRICE_NET" id="PRICE_NET" maxlength="200" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.TITLE_NAME#</cfoutput><cfelse><cf_get_lang_main no='671.Net'> <cf_get_lang_main no='672.Fiyat'></cfif>"></td>
                <td><cf_get_lang_main no='671.Net'> <cf_get_lang_main no='672.Fiyat'></td>
            </tr>
            <tr>
                <td><cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'price_net_doviz'</cfquery></cfif>
                    <input type="checkbox" name="module_content" id="module_content" value="price_net_doviz" <cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id) and get_detail.IS_SELECTED>checked<cfelseif not isdefined('attributes.add_basket_id')>checked</cfif>></td>
                <td><input type="text" name="PRICE_NET_DOVIZ_sira" id="PRICE_NET_DOVIZ_sira" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.line_order_no#</cfoutput><cfelse>34</cfif>" style="width:25px" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>
                <td><input type="text" name="PRICE_NET_DOVIZ_genislik" id="PRICE_NET_DOVIZ_genislik" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.genislik#</cfoutput><cfelse>50</cfif>" style="width:35px"  class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>
                <td><input type="textbox" name="PRICE_NET_DOVIZ" id="PRICE_NET_DOVIZ" maxlength="200" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.TITLE_NAME#</cfoutput><cfelse><cf_get_lang no='744.Net Döviz'> <cf_get_lang_main no='672.Fiyat'></cfif>"></td>
                <td><cf_get_lang no='744.Net Döviz'> <cf_get_lang no='824.Fiyat(Döviz Fiyata Bağlı)'></td>
            </tr>
            <cfif listfind('1,2,3,4,5,6,10,11,14,15,17,18,20,21,37,38,51',attributes.basket_id_)>	
                <tr>
                    <td><cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'number_of_installment'</cfquery></cfif>				  
                        <input type="checkbox" name="module_content" value="number_of_installment" id="number_of_installment_box" <cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id) and get_detail.IS_SELECTED > Checked</cfif>></td>
                    <td><input type="text" name="number_of_installment_sira" id="number_of_installment_sira" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.line_order_no#</cfoutput><cfelse>14</cfif>" style="width:25px" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>					
                    <td><input type="text" name="number_of_installment_genislik" id="number_of_installment_genislik" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.genislik#</cfoutput><cfelse>25</cfif>" style="width:35px"  class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>
                    <td><input type="textbox" name="number_of_installment" id="number_of_installment" maxlength="200" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.TITLE_NAME#</cfoutput><cfelse><cf_get_lang no ='506.Taksit Sayısı'></cfif>"></td>
                    <td><cf_get_lang no='506.Taksit Sayısı'></td>
                </tr>
            </cfif>	
            <tr>
                <td><cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'Duedate'</cfquery></cfif>				  
                    <input type="checkbox" name="module_content" value="Duedate" id="Duedate_box" <cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id) and get_detail.IS_SELECTED > Checked</cfif>></td>
                <td><input type="text" name="Duedate_sira" id="Duedate_sira" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.line_order_no#</cfoutput><cfelse>15</cfif>" style="width:25px" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>					
                <td><input type="text" name="Duedate_genislik" id="Duedate_genislik" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.genislik#</cfoutput><cfelse>25</cfif>" style="width:35px"  class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>
                <td><input type="textbox" name="Duedate" id="Duedate" maxlength="200" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.TITLE_NAME#</cfoutput><cfelse><cf_get_lang_main no='228.Vade'></cfif>"></td>
                <td><cf_get_lang_main no='228.Vade'>(<cf_get_lang no='1065.Satırın Vadesi Gün'>) (<cf_get_lang no='1066.Stok açılış fişinde fiziksel stok yaşı gün olarak kullanılır'>)</td>
            </tr>
            <tr>
                <td><cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'net_maliyet'</cfquery></cfif>			
                    <input type="checkbox" name="module_content" value="net_maliyet" id="net_maliyet_box" <cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id) and get_detail.IS_SELECTED > Checked</cfif>></td>
                <td><input type="text" name="net_maliyet_sira" id="net_maliyet_sira" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.line_order_no#</cfoutput><cfelse>44</cfif>" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3" style="width:25px"></td>					
                <td><input type="text" name="net_maliyet_genislik" id="net_maliyet_genislik" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.genislik#</cfoutput><cfelse>40</cfif>" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3" style="width:35px"></td>
                <td><input type="textbox" name="net_maliyet" id="net_maliyet" maxlength="200" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.TITLE_NAME#</cfoutput><cfelse><cf_get_lang no='680.Net Maliyet'></cfif>"></td>
                <td><cf_get_lang no='680.Net Maliyet'></td>
            </tr>				
            <tr>
                <td><cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'extra_cost'</cfquery></cfif>				
                    <input type="checkbox" name="module_content" value="extra_cost" id="extra_cost_box" <cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id) and get_detail.IS_SELECTED > Checked</cfif>></td>
                <td><input type="text" name="extra_cost_sira" id="extra_cost_sira" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.line_order_no#</cfoutput><cfelse>45</cfif>" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3" style="width:25px"></td>
                <td><input type="text" name="extra_cost_genislik" id="extra_cost_genislik" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.genislik#</cfoutput><cfelse>50</cfif>" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3" style="width:35px"></td>					
                <td><input type="textbox" name="extra_cost" id="extra_cost" maxlength="200" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.TITLE_NAME#</cfoutput><cfelse><cf_get_lang no='993.Ek Maliyet'></cfif>"></td>
                <td><cf_get_lang no='993.ek Maliyet'></td>
            </tr>
            <tr>
                <td><cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'extra_cost_rate'</cfquery></cfif>			
                    <input type="checkbox" name="module_content" value="extra_cost_rate" id="extra_cost_rate_box" <cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id) and get_detail.IS_SELECTED > Checked</cfif>></td>
                <td><input type="text" name="extra_cost_rate_sira" id="extra_cost_rate_sira" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.line_order_no#</cfoutput><cfelse>45</cfif>" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3" style="width:25px"></td>
                <td><input type="text" name="extra_cost_rate_genislik" id="extra_cost_rate_genislik" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.genislik#</cfoutput><cfelse>50</cfif>" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3" style="width:35px"></td>					
                <td><input type="textbox" name="extra_cost_rate" id="extra_cost_rate" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.TITLE_NAME#</cfoutput><cfelse><cf_get_lang no='1633.Ek Maliyet Oranı'></cfif>"></td>
                <td><cf_get_lang no='1633.Ek Maliyet Oranı'></td>
            </tr>
            <tr>
                <td><cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'row_cost_total'</cfquery></cfif>				
                    <input type="checkbox" name="module_content" value="row_cost_total" id="row_cost_total_box" <cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id) and get_detail.IS_SELECTED > Checked</cfif>></td>
                <td><input type="text" name="row_cost_total_sira" id="row_cost_total_sira" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.line_order_no#</cfoutput><cfelse>45</cfif>" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3" style="width:25px"></td>
                <td><input type="text" name="row_cost_total_genislik" id="row_cost_total_genislik" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.genislik#</cfoutput><cfelse>50</cfif>" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3" style="width:35px"></td>					
                <td><input type="textbox" name="row_cost_total" id="row_cost_total" maxlength="200" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.TITLE_NAME#</cfoutput><cfelse><cf_get_lang no='1632.Toplam Maliyet'></cfif>"></td>
                <td><cf_get_lang no='1632.Toplam Maliyet'></td>
            </tr>
            <tr>
                <td><cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'marj'</cfquery></cfif>			
                    <input type="checkbox" name="module_content" value="marj" id="marj_box" <cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id) and get_detail.IS_SELECTED > Checked</cfif>></td>
                <td><input type="text" name="marj_sira" id="marj_sira" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.line_order_no#</cfoutput><cfelse>46</cfif>" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3" style="width:25px"></td>
                <td><input type="text" name="marj_genislik" id="marj_genislik" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.genislik#</cfoutput><cfelse>20</cfif>" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3" style="width:35px"></td>					
                <td><input type="textbox" name="marj" id="marj" maxlength="200" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.TITLE_NAME#</cfoutput><cfelse><cf_get_lang no='544.Marj'></cfif>"></td>
                <td><cf_get_lang no='544.Marj'></td>
            </tr>				
            <tr>
                <td><cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'row_total'</cfquery></cfif>				  
                    <input type="checkbox" name="module_content" id="module_content" value="row_total" <cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id) and get_detail.IS_SELECTED>checked<cfelseif not isdefined('attributes.add_basket_id')>checked</cfif>></td>
                <td><input type="text" name="row_total_sira" id="row_total_sira" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.line_order_no#</cfoutput><cfelse>40</cfif>" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3" style="width:25px"></td>					
                <td><input type="text" name="row_total_genislik" id="row_total_genislik" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.genislik#</cfoutput><cfelse>50</cfif>" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3" style="width:35px"></td>
                <td><input type="textbox" name="row_total" id="row_total" maxlength="200" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.TITLE_NAME#</cfoutput><cfelse><cf_get_lang_main no='758.Satir Toplam'></cfif>"></td>
                <td><cf_get_lang no='825.Satır Toplam(Fiyata Bağlı)'></td>
            </tr>
            <tr>
                <td><cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'row_nettotal'</cfquery></cfif>				  
                    <input type="checkbox" name="module_content" id="module_content" value="row_nettotal" <cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id) and get_detail.IS_SELECTED>checked<cfelseif not isdefined('attributes.add_basket_id')>checked</cfif>></td>
                <td><input type="text" name="row_nettotal_sira" id="row_nettotal_sira" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.line_order_no#</cfoutput><cfelse>41</cfif>" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3" style="width:25px" ></td>					
                <td><input type="text" name="row_nettotal_genislik" id="row_nettotal_genislik" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.genislik#</cfoutput><cfelse>50</cfif>" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3" style="width:35px"></td>
                <td><input type="textbox" name="row_nettotal" id="row_nettotal" maxlength="200" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.TITLE_NAME#</cfoutput><cfelse><cf_get_lang no='306.Net Satır Toplamı'></cfif>"></td>
                <td><cf_get_lang no='826.Net Satır Toplam(Fiyata Bağlı)'></td>
            </tr>
            <tr>
                <td><cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'row_taxtotal'</cfquery></cfif>			  
                    <input type="checkbox" name="module_content" id="module_content" value="row_taxtotal" <cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id) and get_detail.IS_SELECTED>checked<cfelseif not isdefined('attributes.add_basket_id')>checked</cfif>></td>
                <td><input type="text" name="row_taxtotal_sira" id="row_taxtotal_sira" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.line_order_no#</cfoutput><cfelse>38</cfif>" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3" style="width:25px"></td>					
                <td><input type="text" name="row_taxtotal_genislik" id="row_taxtotal_genislik" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.genislik#</cfoutput><cfelse>50</cfif>" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3" style="width:35px"></td>
                <td><input type="textbox" name="row_taxtotal" id="row_taxtotal" maxlength="200" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.TITLE_NAME#</cfoutput><cfelse><cf_get_lang no='307.Vergi Toplam'></cfif>"></td>
                <td><cf_get_lang no='827.Vergi Toplam(Fiyat ve KDVye Bağlı)'></td>
            </tr>
            <tr>
                <td><cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'row_otvtotal'</cfquery></cfif>			  
                    <input type="checkbox" name="module_content" value="row_otvtotal" <cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id) and get_detail.IS_SELECTED>checked<cfelseif not isdefined('attributes.add_basket_id')>checked</cfif> id="row_otvtotal_box"></td>
                <td><input type="text" name="row_otvtotal_sira" id="row_otvtotal_sira" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.line_order_no#</cfoutput><cfelse>39</cfif>" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3" style="width:25px"></td>					
                <td><input type="text" name="row_otvtotal_genislik" id="row_otvtotal_genislik" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.genislik#</cfoutput><cfelse>50</cfif>" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3" style="width:35px"></td>
                <td><input type="textbox" name="row_otvtotal" id="row_otvtotal" maxlength="200" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.TITLE_NAME#</cfoutput><cfelse>OTV<cf_get_lang_main no='80.Toplam'></cfif>"></td>
                <td><cf_get_lang no ='1924.Satır ÖTV Toplamı'></td>
            </tr>
            <tr>
                <td><cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'row_lasttotal'</cfquery></cfif>				
                    <input type="checkbox" name="module_content" id="module_content" value="row_lasttotal" <cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id) and get_detail.IS_SELECTED>checked<cfelseif not isdefined('attributes.add_basket_id')>checked</cfif>></td>
                <td><input type="text" name="row_lasttotal_sira" id="row_lasttotal_sira" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.line_order_no#</cfoutput><cfelse>43</cfif>" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3" style="width:25px"></td>					
                <td><input type="text" name="row_lasttotal_genislik" id="row_lasttotal_genislik" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.genislik#</cfoutput><cfelse>50</cfif>" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3" style="width:35px"></td>
                <td><input type="textbox" name="row_lasttotal" id="row_lasttotal" maxlength="200" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.TITLE_NAME#</cfoutput><cfelse><cf_get_lang_main no='232.Son Toplam'></cfif>"></td>
                <td><cf_get_lang no='599.KDV,Fiyat ve Net Toplama Bağlı'></td>
            </tr>
            <tr>
                <td><cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'other_money_value'</cfquery></cfif>				  
                    <input type="checkbox" name="module_content" id="module_content" value="other_money_value" <cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id) and get_detail.IS_SELECTED>checked<cfelseif not isdefined('attributes.add_basket_id')>checked</cfif>></td>
                <td><input type="text" name="other_money_value_sira" id="other_money_value_sira" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.line_order_no#</cfoutput><cfelse>42</cfif>" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3" style="width:25px"></td>
                <td><input type="text" name="other_money_value_genislik" id="other_money_value_genislik" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.genislik#</cfoutput><cfelse>50</cfif>" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3" style="width:35px"></td>
                <td><input type="textbox" name="other_money_value" id="other_money_value" maxlength="200" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.TITLE_NAME#</cfoutput><cfelse><cf_get_lang no='45.Satır Döviz Tutarı'></cfif>"></td>
                <td><cf_get_lang no='45.Satır Döviz Tutarı'></td>
            </tr>
            <tr>
                <td><cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'other_money_gross_total'</cfquery></cfif>
                    <input type="checkbox" name="module_content" id="module_content" value="other_money_gross_total" <cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id) and get_detail.IS_SELECTED>checked<cfelseif not isdefined('attributes.add_basket_id')>checked</cfif>></td>
                <td><input type="text" name="other_money_gross_total_sira" id="other_money_gross_total_sira" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.line_order_no#</cfoutput><cfelse>56</cfif>" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3" style="width:25px"></td>
                <td><input type="text" name="other_money_gross_total_genislik" id="other_money_gross_total_genislik" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.genislik#</cfoutput><cfelse>56</cfif>" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3" style="width:35px"></td>										
                <td><input type="textbox" name="other_money_gross_total" id="other_money_gross_total" maxlength="200" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.TITLE_NAME#</cfoutput><cfelse><cf_get_lang no='761.Satır Döviz Vergili Toplam'></cfif>"></td>
                <td><cf_get_lang no='829.Satır Vergi Toplamı(Döviz Fiyata Bağlı)'></td>
            </tr>
            <tr>
                <td><cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'price_total'</cfquery></cfif>				  
                    <input type="checkbox" name="module_content" id="module_content" value="price_total" <cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id) and get_detail.IS_SELECTED>checked<cfelseif not isdefined('attributes.add_basket_id')>checked</cfif>></td>
                <td><input type="text" name="price_total_sira" id="price_total_sira" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.line_order_no#</cfoutput><cfelse>57</cfif>" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3" style="width:25px"></td>					
                <td><input type="text" name="price_total_genislik" id="price_total_genislik" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.genislik#</cfoutput><cfelse>50</cfif>" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3" style="width:35px"></td>
                <td><input type="textbox" name="price_total" id="price_total" maxlength="200" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.TITLE_NAME#</cfoutput><cfelse><cf_get_lang no='837.Basket Toplam'></cfif>"></td>
                <td colspan="3"><cf_get_lang no='831.Basket Toplam Belgenin bütün toplamı'>(<cf_get_lang no='620.KDV ve Fiyata Bağlı'>)</td>
            </tr>
            <tr>
                <td><cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'Kdv'</cfquery></cfif>
                    <input type="checkbox" name="module_content" id="module_content" value="Kdv" <cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id) and get_detail.IS_SELECTED>checked<cfelseif not isdefined('attributes.add_basket_id')>checked</cfif>></td>
                <td><input type="text" name="Kdv_sira" id="Kdv_sira" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.line_order_no#</cfoutput><cfelse>58</cfif>" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3" style="width:25px"></td>
                <td><input type="text" name="Kdv_genislik" id="Kdv_genislik"  value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.genislik#</cfoutput><cfelse>20</cfif>" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3" style="width:35px"></td>					
               <td colspan="4"><input type="hidden" name="Kdv" id="Kdv" maxlength="200" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.TITLE_NAME#</cfoutput><cfelse>KDV Toplam</cfif>"><cf_get_lang no='667.KDV Toplam KDV ye Bağl Satır Vergi Toplamına Bağlı'></td>
            </tr>
            <tr>
                <td><cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'is_price_total_other_money'</cfquery></cfif>
                    <input type="checkbox" name="module_content" maxlength="200" value="is_price_total_other_money" id="is_price_total_other_money" <cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id) and get_detail.IS_SELECTED>checked<cfelseif not isdefined('attributes.add_basket_id')>checked</cfif>>
                </td>
                <td colspan="6"><cf_get_lang no ='2429.Basket Toplamda Döviz Bilgileri Gösterilsin'></td>
            </tr>
            <tr>
                <td><cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'is_amount_total'</cfquery></cfif>
                    <input type="checkbox" name="module_content" maxlength="200" alue="is_amount_total" id="is_amount_total" <cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id) and get_detail.IS_SELECTED>checked<cfelseif not isdefined('attributes.add_basket_id')>checked</cfif>>
                </td>
                <td colspan="6"><cf_get_lang no ='2765.Basket Toplamda Miktar Bilgileri Gösterilsin'></td>
            </tr>
            <tr>
                <td><cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'is_paper_discount'</cfquery></cfif>
                    <input type="checkbox" name="module_content" maxlength="200" value="is_paper_discount" id="is_paper_discount" <cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id) and get_detail.IS_SELECTED>checked<cfelseif not isdefined('attributes.add_basket_id')>checked</cfif>>
                </td>
                <td colspan="6"><cf_get_lang no ='2780.Basket Toplamda Fatura Altı İndirim Gösterilsin'></td>
            </tr>
          </table>
        <cf_seperator header="#getLang('settings',1058)#" id="promosyona_iliskin_bilgiler">
        <table id="promosyona_iliskin_bilgiler">
      <tr>
                <td><cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'promosyon_yuzde'</cfquery></cfif>			
                    <input type="checkbox" name="module_content" value="promosyon_yuzde" id="promosyon_yuzde_box" <cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id) and get_detail.IS_SELECTED > Checked</cfif>></td>
                <td><input type="text" name="promosyon_yuzde_sira" id="promosyon_yuzde_sira" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.line_order_no#</cfoutput><cfelse>32</cfif>" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3" style="width:25px"></td>
                <td><input type="text" name="promosyon_yuzde_genislik" id="promosyon_yuzde_genislik"  value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.genislik#</cfoutput><cfelse>20</cfif>" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3" style="width:35px"></td>					
                <td><input type="text" name="promosyon_yuzde" id="promosyon_yuzde" maxlength="200" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.TITLE_NAME#</cfoutput><cfelse><cf_get_lang no='1039.Promosyon Yüzdesi'></cfif>"></td>
                <td><cf_get_lang no='674.Promosyon'> %</td>
            </tr>
            <tr>
                <td><cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'promosyon_maliyet'</cfquery></cfif>				
                    <input type="checkbox" name="module_content" id="module_content" value="promosyon_maliyet" id="promosyon_maliyet_box" <cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id) and get_detail.IS_SELECTED > Checked</cfif>></td>
                <td><input type="text" name="promosyon_maliyet_sira" id="promosyon_maliyet_sira" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.line_order_no#</cfoutput><cfelse>47</cfif>" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3" style="width:25px"></td>
                <td><input type="text" name="promosyon_maliyet_genislik" id="promosyon_maliyet_genislik"  value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.genislik#</cfoutput><cfelse>20</cfif>" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3" style="width:35px"></td>					
                <td><input type="text" name="promosyon_maliyet" id="promosyon_maliyet" maxlength="200" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.TITLE_NAME#</cfoutput><cfelse><cf_get_lang no='1040.Promosyon Maliyeti'></cfif>"></td>
                <td><cf_get_lang no='1040.Promosyon maliyet'></td>
            </tr>
            <tr>
                <td><cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'is_promotion'</cfquery></cfif>			  				  
                    <input type="checkbox" name="module_content" value="is_promotion" id="is_promotion_box"<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id) and get_detail.IS_SELECTED > Checked</cfif>></td>
                    <cfsavecontent variable="message"><cf_get_lang no='995.Değer Nümerik olmalıdır'></cfsavecontent>
                <td colspan="6"><input type="hidden" name="is_promotion" id="is_promotion" maxlength="200" value="Ödeme Yöntemi"><cf_get_lang no='1049.Promosyon Kullan/Kullanma'></td>
            </tr>
          </table>
        <cf_seperator header="#getLang('settings',1048)#" id="teslim_ve_depolamaya_iliskin_bilgiler">
        <table id="teslim_ve_depolamaya_iliskin_bilgiler">
   	  <cfif listfind('3,4,5,6,7,8,13,14,15,24,25,26,28,29,34,35,36,37,38,39,44,45,46,50,51,52',attributes.basket_id_)>
                <tr>
                    <td><cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'deliver_date'</cfquery></cfif>				  
                        <input type="checkbox" name="module_content" value="deliver_date" id="deliver_date_box" <cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id) and get_detail.IS_SELECTED > Checked</cfif>></td>
                    <td><input type="text" name="deliver_date_sira" id="deliver_date_sira" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.line_order_no#</cfoutput><cfelse>48</cfif>" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3" style="width:25px"></td>					
                    <td><input type="text" name="deliver_date_genislik" id="deliver_date_genislik" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.genislik#</cfoutput><cfelse>40</cfif>" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3" style="width:35px"></td>
                    <td><input type="textbox" name="deliver_date" id="deliver_date" maxlength="200" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.TITLE_NAME#</cfoutput><cfelse><cf_get_lang_main no='233.Teslim Tarihi'></cfif>"></td>
                    <td><cf_get_lang no='833.Teslim Tarihi İrsaliye ve Faturada kullanılmaz'> (<cf_get_lang no='1629.Stok Açılış Ve Devir Fişlerinde Finansal Yaş Olarak Kullanılır'>)</td>
                </tr>
                <tr>
                    <td><cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'deliver_dept'</cfquery></cfif>
                        <input type="checkbox" name="module_content" value="deliver_dept" id="deliver_dept_box" <cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id) and get_detail.IS_SELECTED > Checked</cfif>></td>
                    <td><input type="text" name="deliver_dept_sira" id="deliver_dept_sira" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.line_order_no#</cfoutput><cfelse>49</cfif>" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3" style="width:25px" ></td>					
                    <td><input type="text" name="deliver_dept_genislik" id="deliver_dept_genislik" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.genislik#</cfoutput><cfelse>40</cfif>"  class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3" style="width:35px" ></td>
                    <td><input type="textbox" name="deliver_dept" id="deliver_dept" maxlength="200" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.TITLE_NAME#</cfoutput><cfelse><cf_get_lang_main no='234.Teslim Depo'></cfif>"></td>
                    <td><cf_get_lang no="834.Teslim depo İrsaliye ve Faturada kullanılmaz"></td>
                </tr>
           	</cfif>
            <!---<tr>
                <td><cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'deliver_dept_assortment'</cfquery></cfif>
                    <input type="checkbox" name="module_content" value="deliver_dept_assortment" id="deliver_dept_assortment_box" <cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id) and get_detail.IS_SELECTED > Checked</cfif>></td>
                <td><input type="text" name="deliver_dept_assortment_sira" id="deliver_dept_assortment_sira" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.line_order_no#</cfoutput><cfelse>59</cfif>" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3" style="width:25px"></td>
                <td><input type="text" name="deliver_dept_assortment_genislik" id="deliver_dept_assortment_genislik" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.genislik#</cfoutput><cfelse>20</cfif>"   class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3" style="width:35px"></td>
                <td><input type="textbox" name="deliver_dept_assortment" id="deliver_dept_assortment" maxlength="200" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.TITLE_NAME#</cfoutput><cfelse><cf_get_lang no='530.Teslim Depo Dağılım'></cfif>"></td>
                <td><cf_get_lang no='530.Teslim Depo Dağılım'></td>
            </tr>--->
            <tr>
                <td><cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'shelf_number'</cfquery></cfif>
                    <input type="checkbox" name="module_content" value="shelf_number" id="shelf_number_box" <cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id) and get_detail.IS_SELECTED > Checked</cfif>></td>
                <td><input type="text" name="shelf_number_sira" id="shelf_number_sira" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.line_order_no#</cfoutput><cfelse>50</cfif>" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3" style="width:25px"></td>
                <td><input type="text" name="shelf_number_genislik" id="shelf_number_genislik" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.genislik#</cfoutput><cfelse>100</cfif>" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3" style="width:35px"></td>
                <td><input type="textbox" name="shelf_number" id="shelf_number" maxlength="200" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.TITLE_NAME#</cfoutput><cfelse><cf_get_lang no='1059.Raf No'></cfif>"></td>
                <td><cf_get_lang no='1059.Raf No'></td>
            </tr>		
            <tr>
                <td><cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'shelf_number_2'</cfquery></cfif>
                    <input type="checkbox" name="module_content" value="shelf_number_2" id="shelf_number_box" <cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id) and get_detail.IS_SELECTED > Checked</cfif>></td>
                <td><input type="text" name="shelf_number_2_sira" id="shelf_number_2_sira" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.line_order_no#</cfoutput><cfelse>50</cfif>" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3" style="width:25px"></td>
                <td><input type="text" name="shelf_number_2_genislik" id="shelf_number_2_genislik" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.genislik#</cfoutput><cfelse>100</cfif>" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"  style="width:35px"></td>
                <td><input type="textbox" name="shelf_number_2" id="shelf_number_2" maxlength="200" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.TITLE_NAME#</cfoutput><cfelse><cf_get_lang no='1059.Raf No'></cfif>"></td>
                <td><cf_get_lang no='1059.Raf No'> 2 (<cf_get_lang no='1329.Çıkış Rafı'>)</td>
            </tr>		
            <tr>
                <td><cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'spec'</cfquery></cfif>			  
                    <input type="checkbox" name="module_content" value="spec" id="spec_box" <cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id) and get_detail.IS_SELECTED > Checked</cfif>></td>
                <td><input type="text" name="spec_sira" id="spec_sira" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.line_order_no#</cfoutput><cfelse>5</cfif>" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3" style="width:25px"></td>					
                <td><input type="text" name="spec_genislik" id="spec_genislik" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.genislik#</cfoutput><cfelse>40</cfif>" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3" style="width:35px"></td>
                <td><input type="textbox" name="spec" id="spec" maxlength="200" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.TITLE_NAME#</cfoutput><cfelse><cf_get_lang_main no='235.Spec'></cfif>"></td>
                <td><cf_get_lang_main no='235.Spec'></td>
            </tr>
            <tr>
                <td><cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'lot_no'</cfquery></cfif>
                    <input type="checkbox" name="module_content" value="lot_no" id="lot_no_box" <cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id) and get_detail.IS_SELECTED > Checked</cfif>></td>
                <td><input type="text" name="lot_no_sira" id="lot_no_sira" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.line_order_no#</cfoutput><cfelse>60</cfif>" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3" style="width:25px"></td>					
                <td><input type="text" name="lot_no_genislik" id="lot_no_genislik" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.genislik#</cfoutput><cfelse>40</cfif>" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3" style="width:35px"></td>
                <td><input type="textbox" name="lot_no" id="lot_no" maxlength="200" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.TITLE_NAME#</cfoutput><cfelse><cf_get_lang no='46.Lot No'></cfif>"></td>
                <td><cf_get_lang no='46.Lot No'></td>
            </tr>
            <tr>
                <td><cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'darali'</cfquery></cfif>
                    <input type="checkbox" name="module_content" value="darali" id="darali_box" <cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id) and get_detail.IS_SELECTED > Checked</cfif>></td>
                <td><input type="text" name="darali_sira" id="darali_sira" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.line_order_no#</cfoutput><cfelse>12</cfif>" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3" style="width:25px"></td>
                <td><input type="text" name="darali_genislik" id="darali_genislik" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.genislik#</cfoutput><cfelse>20</cfif>" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3" style="width:35px"></td>
                <td><input type="textbox" name="darali" id="darali" maxlength="200" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.TITLE_NAME#</cfoutput><cfelse><cf_get_lang no='638.Daralı'></cfif>"></td>
                <td><cf_get_lang no='638.Daralı'></td>
            </tr>
            <tr>
                <td><cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'dara'</cfquery></cfif>
                    <input type="checkbox" name="module_content" id="module_content" value="dara" id="dara_box" <cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id) and get_detail.IS_SELECTED > Checked</cfif>></td>
                <td><input type="text" name="dara_sira" id="dara_sira" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.line_order_no#</cfoutput><cfelse>11</cfif>" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3" style="width:25px"></td>
                <td><input type="text" name="dara_genislik" id="dara_genislik"  value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.genislik#</cfoutput><cfelse>25</cfif>" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3" style="width:35px"></td>
                <td><input type="textbox" name="dara" id="dara" maxlength="200" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.TITLE_NAME#</cfoutput><cfelse><cf_get_lang no='654.Dara'></cfif>"></td>
                <td><cf_get_lang no='654.Dara'></td>
            </tr>	
            <tr>
                <td><cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'is_parse'</cfquery></cfif>			  
                    <input type="checkbox" name="module_content" value="is_parse" id="is_parse_box" <cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id) and get_detail.IS_SELECTED > Checked</cfif>></td>
                <td><input type="text" name="is_parse_sira" id="is_parse_sira" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.line_order_no#</cfoutput><cfelse>51</cfif>" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3" style="width:25px"></td>				
                <td><input type="text" name="is_parse_genislik" id="is_parse_genislik" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.genislik#</cfoutput><cfelse>20</cfif>" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3" style="width:35px"></td>					
                <td colspan="3"><input type="hidden" name="is_parse" id="is_parse" maxlength="200" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.TITLE_NAME#</cfoutput><cfelse>Dağılım</cfif>"><cf_get_lang no='280.Dağılım'> (<cf_get_lang no='1067.Stok çeşitlerinin dağılımını yapar'>)</td>
            </tr>
            <cfif listfind('4,6,14,15,25,35,36,37,38,51',attributes.basket_id_)>
                <tr>
                    <td><cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'order_currency'</cfquery></cfif>
                        <input type="checkbox" name="module_content" id="module_content" value="order_currency" id="order_currency_box" <cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id) and get_detail.IS_SELECTED > Checked</cfif>></td>
                    <td><input type="text" name="order_currency_sira" id="order_currency_sira" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.line_order_no#</cfoutput><cfelse>55</cfif>" style="width:25px"  class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>					
                    <td><input type="text" name="order_currency_genislik" id="order_currency_genislik" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.genislik#</cfoutput><cfelse>20</cfif>" style="width:35px"  class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>
                    <td><input type="textbox" name="order_currency" id="order_currency" maxlength="200" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.TITLE_NAME#</cfoutput><cfelse><cf_get_lang no='1041.Sipariş Aşama'></cfif>"></td>
                    <td><cf_get_lang no='1041.Sipariş Aşama'>(<cf_get_lang no='1068.Sevk, Üretim, Eksik Teslimat gibi durumlar izlenir'>) </td>
                </tr>
            </cfif>
            <cfif listfind('4,6,14,15,25,35,37,38,51',attributes.basket_id_)>	
                <tr>
                    <td><cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'reserve_type'</cfquery></cfif>
                        <input type="checkbox" name="module_content" id="module_content" value="reserve_type" id="reserve_type_box" <cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id) and get_detail.IS_SELECTED > Checked</cfif>></td>
                    <td><input type="text" name="reserve_type_sira" id="reserve_type_sira" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.line_order_no#</cfoutput><cfelse>52</cfif>" style="width:25px"  class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>					
                    <td><input type="text" name="reserve_type_genislik" id="reserve_type_genislik" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.genislik#</cfoutput><cfelse>75</cfif>" style="width:35px"  class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>
                    <td><input type="textbox" name="reserve_type" id="reserve_type" maxlength="200" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.TITLE_NAME#</cfoutput><cfelse><cf_get_lang no='1599.Rezerve Tipi'></cfif>"></td>
                    <td><cf_get_lang no='1599.Rezerve Tipi'> </td>
                </tr>	
            </cfif>
            <!---<tr>
                <td><cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'reserve_date'</cfquery></cfif>
                    <input type="checkbox" name="module_content" id="module_content" value="reserve_date" id="reserve_date_box" <cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id) and get_detail.IS_SELECTED > Checked</cfif>></td>
                <td><input type="text" name="reserve_date_sira" id="reserve_date_sira" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.line_order_no#</cfoutput><cfelse>53</cfif>" style="width:25px"  class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>					
                <td><input type="text" name="reserve_date_genislik" id="reserve_date_genislik" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.genislik#</cfoutput><cfelse>75</cfif>" style="width:35px"  class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>
                <td><input type="textbox" name="reserve_date" id="reserve_date" maxlength="200" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.TITLE_NAME#</cfoutput><cfelse><cf_get_lang no='1598.Rezerve Tarihi'></cfif>"></td>
                <td><cf_get_lang no='1598.Rezerve Tarihi'> </td>
            </tr>--->
            <tr>
                <td><cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'basket_employee'</cfquery></cfif>
                    <input type="checkbox" name="module_content" id="module_content" value="basket_employee" id="basket_employee_box" <cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id) and get_detail.IS_SELECTED > Checked</cfif>></td>
                <td><input type="text"  name="basket_employee_sira" id="basket_employee_sira" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.line_order_no#</cfoutput><cfelse>54</cfif>" style="width:25px"  class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>
                <td><input type="text"  name="basket_employee_genislik" id="basket_employee_genislik" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.genislik#</cfoutput><cfelse>100</cfif>" style="width:35px"  class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>
                <td><input type="textbox"  name="basket_employee" id="basket_employee"  maxlength="200" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.TITLE_NAME#</cfoutput><cfelse><cf_get_lang no='1597.Satış Temsilcisi'></cfif>"></td>
                <td><cf_get_lang no='1597.Satış Temsilcisi'></td>
            </tr>		
            <tr>
                <td><cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'basket_project'</cfquery></cfif>
                    <input type="checkbox" name="module_content" id="module_content" value="basket_project" id="basket_project_box" <cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id) and get_detail.IS_SELECTED > Checked</cfif>></td>
                <td><input type="text"  name="basket_project_sira" id="basket_project_sira" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.line_order_no#</cfoutput><cfelse>55</cfif>" style="width:25px"  class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>
                <td><input type="text"  name="basket_project_genislik" id="basket_project_genislik" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.genislik#</cfoutput><cfelse>100</cfif>" style="width:35px"  class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>
                <td><input type="textbox"  name="basket_project" id="basket_project"  maxlength="200" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.TITLE_NAME#</cfoutput><cfelse><cf_get_lang_main no='4.Proje'></cfif>"></td>
                <td><cf_get_lang_main no='4.Proje'></td>
            </tr>
            <tr>
                <td><cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'basket_work'</cfquery></cfif>
                    <input type="checkbox" name="module_content" id="module_content" value="basket_work" id="basket_work_box" <cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id) and get_detail.IS_SELECTED > Checked</cfif>></td>
                <td><input type="text"  name="basket_work_sira" id="basket_work_sira" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.line_order_no#</cfoutput><cfelse>55</cfif>" style="width:25px"  class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>
                <td><input type="text"  name="basket_work_genislik" id="basket_work_genislik" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.genislik#</cfoutput><cfelse>100</cfif>" style="width:35px"  class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>
                <td><input type="textbox"  name="basket_work" id="basket_work"  maxlength="200" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.TITLE_NAME#</cfoutput><cfelse><cf_get_lang_main no='1033.İş'></cfif>"></td>
                <td><cf_get_lang_main no='1033.İş'></td>
            </tr>
            <cfif isdefined('attributes.add_basket_id') and attributes.basket_id_ eq 1>
                <tr>
                    <td><cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'basket_exp_center'</cfquery></cfif>
                        <input type="checkbox" name="module_content" id="module_content" value="basket_exp_center" id="basket_exp_center_box" <cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id) and get_detail.IS_SELECTED > Checked</cfif>></td>
                    <td><input type="text"  name="basket_exp_center_sira" id="basket_exp_center_sira" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.line_order_no#</cfoutput><cfelse>55</cfif>" style="width:25px"  class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>
                    <td><input type="text"  name="basket_exp_center_genislik" id="basket_exp_center_genislik" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.genislik#</cfoutput><cfelse>100</cfif>" style="width:35px"  class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>
                    <td><input type="textbox"  name="basket_exp_center" id="basket_exp_center"  maxlength="200" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.TITLE_NAME#</cfoutput><cfelse><cf_get_lang_main no='1033.İş'></cfif>"></td>
                    <td><cf_get_lang_main no="1048.Masraf Merkezi"></td>
                </tr>
                <tr>
                    <td><cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'basket_exp_item'</cfquery></cfif>
                        <input type="checkbox" name="module_content" id="module_content" value="basket_exp_item" id="basket_exp_item_box" <cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id) and get_detail.IS_SELECTED > Checked</cfif>></td>
                    <td><input type="text"  name="basket_exp_item_sira" id="basket_exp_item_sira" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.line_order_no#</cfoutput><cfelse>55</cfif>" style="width:25px"  class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>
                    <td><input type="text"  name="basket_exp_item_genislik" id="basket_exp_item_genislik" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.genislik#</cfoutput><cfelse>100</cfif>" style="width:35px"  class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>
                    <td><input type="textbox"  name="basket_exp_item" id="basket_exp_item"  maxlength="200" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.TITLE_NAME#</cfoutput><cfelse><cf_get_lang_main no='1033.İş'></cfif>"></td>
                    <td><cf_get_lang_main no="822.Bütçe Kalemi"></td>
                </tr>
                <tr>
                    <td><cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'basket_acc_code'</cfquery></cfif>
                        <input type="checkbox" name="module_content" id="module_content" value="basket_acc_code" id="basket_acc_code_box" <cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id) and get_detail.IS_SELECTED > Checked</cfif>></td>
                    <td><input type="text"  name="basket_acc_code_sira" id="basket_acc_code_sira" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.line_order_no#</cfoutput><cfelse>55</cfif>" style="width:25px"  class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>
                    <td><input type="text"  name="basket_acc_code_genislik" id="basket_acc_code_genislik" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.genislik#</cfoutput><cfelse>100</cfif>" style="width:35px"  class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" maxlength="3"></td>
                    <td><input type="textbox"  name="basket_acc_code" id="basket_acc_code"  maxlength="200" value="<cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfoutput>#get_detail.TITLE_NAME#</cfoutput><cfelse><cf_get_lang_main no='1033.İş'></cfif>"></td>
                    <td><cf_get_lang_main no="1399.Muhasebe Kodu"></td>
                </tr>
        	</cfif>
        </table>	
        <cf_seperator header="#getLang('settings',1047)#" id="basket_genel_bilgileri">	
        <table id="basket_genel_bilgileri">
            <cfif not listfind('7,8,12,13,19,26,28,29,31,32,34,39,44,45,46,49,50,52',attributes.basket_id_)>
                <tr>
                    <td><cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'is_member_selected'</cfquery></cfif>
                        <input type="checkbox" name="module_content" id="module_content" maxlength="200" value="is_member_selected" <cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id) and get_detail.IS_SELECTED > Checked</cfif>></td>
                    <td colspan="6"><cf_get_lang no='164.Üye Seçme Zorunluluğu'></td>
                </tr>
                <tr>
                    <td><cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'is_member_not_change'</cfquery></cfif>
                        <input type="checkbox" name="module_content" id="module_content" maxlength="200" value="is_member_not_change" <cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id) and get_detail.IS_SELECTED > Checked</cfif>></td>
                    <td colspan="6"><cf_get_lang no ='1916.Baskette Ürün Varsa Cari Hesap Değiştirilemesin'></td>
                </tr>
            </cfif>
            <tr>
                <td><cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'is_project_selected'</cfquery></cfif>
                    <input type="checkbox" name="module_content" id="module_content" maxlength="200" value="is_project_selected" <cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id) and get_detail.IS_SELECTED > Checked</cfif>></td><!---urun seçmeden önce belgede proje secimi zorunlu olsun mu --->
                <td colspan="6"><cf_get_lang no='2769.Proje Seçme Zorunluluğu'></td>
            </tr>
            <tr>
                <td><cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'is_project_not_change'</cfquery></cfif>
                    <input type="checkbox" name="module_content" id="module_content" maxlength="200" value="is_project_not_change" <cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id) and get_detail.IS_SELECTED > Checked</cfif>></td>
                <td colspan="6"><cf_get_lang no='2922.Baskette Ürün Varsa Proje Değiştirilemesin'></td>
            </tr>
            <cfif listfind('1,2,3,4,5,6,7,10,11,14,15,17,18,20,21,24,25,37,38,51',attributes.basket_id_)>
                <tr>
                    <td><input type="checkbox" name="use_project_discount_" id="use_project_discount_" value="1" <cfif isdefined('get_basket_this.USE_PROJECT_DISCOUNT') and len(get_basket_this.USE_PROJECT_DISCOUNT) and get_basket_this.USE_PROJECT_DISCOUNT eq 1>checked</cfif>></td><!--- proje iskonto kontrolleri calıstırılsın mı --->
                    <td colspan="6"><cf_get_lang no="2605.Proje Baglantı Kontrolleri"></td>
                </tr>
           	</cfif>
            <cfif listfind('3,4,5,6,14,15,35,36,37,38,51',attributes.basket_id_)>
                <tr>
                    <td><cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'check_row_discounts'</cfquery></cfif>
                        <input type="checkbox" name="module_content" id="module_content" maxlength="200" value="check_row_discounts" <cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id) and get_detail.IS_SELECTED > Checked</cfif>></td><!---ayarlardaki şube yetki tanımlarına bağlı olarak satır iskontolarını kontrol eder --->
                    <td colspan="6"><cf_get_lang no="2770.sube İskonto Yetki Kontrolleri Yapılsın"></td>
                </tr>
           	</cfif>
            <tr>
                <td><cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'zero_stock_status'</cfquery></cfif>
                    <input type="checkbox" name="module_content" id="module_content" maxlength="200" value="zero_stock_status" <cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id) and get_detail.IS_SELECTED > Checked</cfif>></td>
                <td colspan="6"><cf_get_lang no='749.Sıfır Stok ile Çalış'></td>
            </tr>
            <tr>
                <td><cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'zero_stock_control_date'</cfquery></cfif>
                    <input type="checkbox" name="module_content" id="module_content" maxlength="200" value="zero_stock_control_date" <cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id) and get_detail.IS_SELECTED > Checked</cfif>></td>
                <td colspan="6">Sıfır Stok Kontrolünü Belge Tarihine Göre Yapsın</td>
            </tr>
            <cfif listfind('1,2,10,11,12,13,17,18,19,21,31,32,46,47,48,49',attributes.basket_id_)>
                <tr>
                    <td><cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'is_serialno_guaranty'</cfquery></cfif>				  
                        <input type="checkbox" name="module_content" id="module_content" maxlength="200" value="is_serialno_guaranty" <cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id) and get_detail.IS_SELECTED > Checked</cfif>></td>
                    <td colspan="6"><cf_get_lang no='745.Garanti Seri No'></td>
                </tr>
           	</cfif>
            <cfif listfind('1,2,3,4,5,6,10,11,14,15,17,18,20,21,24,25,37,38,42,43,51',attributes.basket_id_)>
                <tr>
                    <td><cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'is_risc'</cfquery></cfif>				  
                        <input type="checkbox" name="module_content" id="module_content" maxlength="200" value="is_risc" <cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id) and get_detail.IS_SELECTED > Checked</cfif>></td>
                    <td colspan="6"><cf_get_lang_main no='457.Risk Durumu'></td>
                </tr>
           	</cfif>
            <tr>
                <td><cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'is_cash_pos'</cfquery></cfif>				  
                    <input type="checkbox" name="module_content" id="module_content" maxlength="200" value="is_cash_pos" <cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id) and get_detail.IS_SELECTED > Checked</cfif>></td>
                <td colspan="6"><cf_get_lang no='1911.Nakit ve Pos Ödeme'> </td>
            </tr>
            <tr>
                <td><cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'is_installment'</cfquery></cfif>			  
                    <input type="checkbox" name="module_content" id="module_content" maxlength="200" value="is_installment" <cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id) and get_detail.IS_SELECTED > Checked</cfif>></td>
                <td colspan="6"><cf_get_lang no ='1913.Taksit Hesaplama'></td>
            </tr>
            <tr>
                <td><cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)><cfquery name="get_detail" dbtype="query">SELECT * FROM GET_MODULE_DSP WHERE TITLE = 'otv_from_tax_price'</cfquery></cfif>
                    <input type="checkbox" name="module_content" id="module_content" maxlength="200" value="otv_from_tax_price" <cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id) and get_detail.IS_SELECTED > Checked</cfif>></td>
                <td colspan="6"><cf_get_lang no ='1917.OTV KDV Matrahına eklenir'></td>
            </tr>
          </table>
        <table>
        	<tr>
            	<td width="110"><cf_get_lang no ='2440.Satır Sayısı'></td>
                <td>
                	<input type="text" name="line_number" id="line_number" value="<cfoutput><cfif isdefined("get_basket_this")>#get_basket_this.LINE_NUMBER#<cfelse>20</cfif></cfoutput>"  style="width:80px;"/>
                </td>
            </tr>
            <tr>
                <td width="110"><cf_get_lang no ='1927.Satır Yuvarlama'></td>
                <td>					
                <cfoutput>
                <select name="price_round_num" id="price_round_num" style="width:80px;">
                    <cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)>
                        <cfloop from="1" to="8" index="tt">
                            <option value="#tt#" <cfif len(get_basket_this.PRICE_ROUND_NUMBER) and get_basket_this.PRICE_ROUND_NUMBER eq tt>selected</cfif>>#tt#</option>
                        </cfloop>
                    <cfelse>
                        <cfloop from="1" to="8" index="tt">
                            <option value="#tt#" <cfif tt eq 4>selected</cfif>>#tt#</option>
                        </cfloop>
                    </cfif>
                </select>
                </cfoutput>
                </td>
            </tr>
            <tr>
                <td><cf_get_lang no ='1925.Basket Toplam Yuvarlama'></td>
                <td>					
                    <cfoutput>
                    <select name="basket_total_round_num" id="basket_total_round_num" style="width:80px;">
                    <cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)>
                        <cfloop from="1" to="8" index="tx">
                            <option value="#tx#" <cfif len(get_basket_this.BASKET_TOTAL_ROUND_NUMBER) and get_basket_this.BASKET_TOTAL_ROUND_NUMBER eq tx>selected</cfif>>#tx#</option>
                        </cfloop>
                    <cfelse>
                         <cfloop from="1" to="8" index="tx">
                            <option value="#tx#" <cfif tx eq 4>selected</cfif>>#tx#</option>
                        </cfloop>
                    </cfif>
                    </select>
                    </cfoutput>
                </td>
            </tr>
            <tr>
                <td><cf_get_lang no ='1926.Basket Kur Yuvarlama'></td>
                <td>
                    <cfoutput>
                    <select name="basket_rate_round_num" id="basket_rate_round_num" style="width:80px;">
                    <cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id)>
                        <cfloop from="1" to="8" index="tr">
                            <option value="#tr#" <cfif len(get_basket_this.BASKET_RATE_ROUND_NUMBER) and get_basket_this.BASKET_RATE_ROUND_NUMBER eq tr>selected</cfif>>#tr#</option>
                        </cfloop>
                    <cfelse>
                        <cfloop from="1" to="8" index="tr">
                            <option value="#tr#" <cfif tr eq 4>selected</cfif>>#tr#</option>
                        </cfloop>
                    </cfif>
                    </select>
                    </cfoutput>
                </td>
            </tr>
            <tr>
                <td><cf_get_lang no='1042.Stok Seçim Sayfası'></td>
                <td>
                    <select name="PRODUCT_SELECT_TYPE" id="PRODUCT_SELECT_TYPE" style="width:380px;">
                        <option value="1" <cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id) and isdefined('get_basket_this.PRODUCT_SELECT_TYPE') and len(get_basket_this.PRODUCT_SELECT_TYPE) and get_basket_this.PRODUCT_SELECT_TYPE eq 1>selected</cfif>>1 - <cf_get_lang no='1466.Fiyatsız Standart Stok Listesi'></option><!--- Perakende Sektörü --->
                        <option value="2" <cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id) and isdefined('get_basket_this.PRODUCT_SELECT_TYPE') and len(get_basket_this.PRODUCT_SELECT_TYPE) and get_basket_this.PRODUCT_SELECT_TYPE eq 2>selected</cfif>>2 - <cf_get_lang no='1467.Stoklu Özel Fiyatlı Satış Listesi'></option><!--- IT Sektörü - Satış --->
                        <option value="3" <cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id) and isdefined('get_basket_this.PRODUCT_SELECT_TYPE') and len(get_basket_this.PRODUCT_SELECT_TYPE) and get_basket_this.PRODUCT_SELECT_TYPE eq 3>selected</cfif>>3 - <cf_get_lang no='1468.Stoklu Alış Listesi'></option><!--- 3 - IT Sektörü - Alış --->
                        <option value="4" <cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id) and isdefined('get_basket_this.PRODUCT_SELECT_TYPE') and len(get_basket_this.PRODUCT_SELECT_TYPE) and get_basket_this.PRODUCT_SELECT_TYPE eq 4>selected</cfif>>4 - <cf_get_lang no='1469.Stoklu Liste - Depo Fişleri'> </option><!--- 4 - IT Sektörü - Depo Fişi --->
                        <option value="6" <cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id) and isdefined('get_basket_this.PRODUCT_SELECT_TYPE') and len(get_basket_this.PRODUCT_SELECT_TYPE) and get_basket_this.PRODUCT_SELECT_TYPE eq 6>selected</cfif>>5 - <cf_get_lang no='1471.Specli Stoklu Özel Fiyatlı Satış Listesi'> </option><!--- 6 - IT Sektörü - Satış Specli --->
                        <option value="7" <cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id) and isdefined('get_basket_this.PRODUCT_SELECT_TYPE') and len(get_basket_this.PRODUCT_SELECT_TYPE) and get_basket_this.PRODUCT_SELECT_TYPE eq 7>selected</cfif>>6 - <cf_get_lang no='1472.Specli Stoklu Alış Listesi'> </option><!--- 7 - IT Sektörü - Alış Specli --->
                        <option value="8" <cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id) and isdefined('get_basket_this.PRODUCT_SELECT_TYPE') and len(get_basket_this.PRODUCT_SELECT_TYPE) and get_basket_this.PRODUCT_SELECT_TYPE eq 8>selected</cfif>>7 - <cf_get_lang no='1476.İşçilikli Stoklu Özel Fiyatlı Satış Listesi'></option><!--- 8 - IT Sektörü - Satış işçilikli ---> 
                        <option value="9" <cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id) and isdefined('get_basket_this.PRODUCT_SELECT_TYPE') and len(get_basket_this.PRODUCT_SELECT_TYPE) and get_basket_this.PRODUCT_SELECT_TYPE eq 9>selected</cfif>>8 - <cf_get_lang no ='1918.İşçilikli Specli Özel Fiyatlı Satış Listesi'></option><!--- 9 - IT Sektörü - Satış işçilikli specli ---> 
                        <option value="10" <cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id) and isdefined('get_basket_this.PRODUCT_SELECT_TYPE') and len(get_basket_this.PRODUCT_SELECT_TYPE) and get_basket_this.PRODUCT_SELECT_TYPE eq 10>selected</cfif>>9 - <cf_get_lang no ='1919.Tedarikçi Bazında Stok Stratejili Ürün Listesi'></option><!--- 10 - IT Sektörü - Satınalma siparişi icin ---> 
                        <option value="11" <cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id) and isdefined('get_basket_this.PRODUCT_SELECT_TYPE') and len(get_basket_this.PRODUCT_SELECT_TYPE) and get_basket_this.PRODUCT_SELECT_TYPE eq 11>selected</cfif>>10 - <cf_get_lang no ='1920.Raf ve Son Kullanma Tarihli Stok Listesi'></option> 
                        <option value="12" <cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id) and isdefined('get_basket_this.PRODUCT_SELECT_TYPE') and len(get_basket_this.PRODUCT_SELECT_TYPE) and get_basket_this.PRODUCT_SELECT_TYPE eq 12>selected</cfif>>11 - <cf_get_lang no ='1921.Taksit Hesaplamalı Fiyat Listesi'></option> 
                        <option value="13" <cfif isdefined('attributes.add_basket_id') and len(attributes.add_basket_id) and isdefined('get_basket_this.PRODUCT_SELECT_TYPE') and len(get_basket_this.PRODUCT_SELECT_TYPE) and get_basket_this.PRODUCT_SELECT_TYPE eq 13>selected</cfif>>12 - <cf_get_lang no ='1922.Fiyat Listeli Stok Listesi'></option> 
                    </select>
                </td>
            </tr>
        </table>
</cfform>
