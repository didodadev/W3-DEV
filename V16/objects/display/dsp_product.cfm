<cfinclude template="../query/get_kdv.cfm">
<cfinclude template="../query/get_detail_product.cfm">
<cfinclude template="../query/get_detail_product_cat.cfm">
<cfinclude template="../query/get_detail_money.cfm">
<cfsavecontent variable="message"><cf_get_lang dictionary_id='32635.Varlık Tipi'></cfsavecontent>
<cf_popup_box title="#message# : #get_product.product_name#"><!---Ürün--->
    <table>
        <tr>
            <td width="70" class="txtbold"><cf_get_lang dictionary_id='57756.Durum'></td>
            <td class="txtbold">:</td>
            <td width="150">
				<cfif get_product.PRODUCT_STATUS is 1>
                    <cf_get_lang dictionary_id='57493.Aktif'>
                <cfelse>
                    <cf_get_lang dictionary_id='57494.Pasif'>
                </cfif>
            </td>
            <td class="txtbold"><cf_get_lang dictionary_id='57518.Stok Kodu'></td>
            <td class="txtbold">:</td>
            <td width="100" ><cfoutput>#get_product.product_code#</cfoutput></td>
            <td rowspan="10" valign="top">
            <cfquery name="GET_IMAGE" datasource="#DSN3#" maxrows="1">
                SELECT PATH, PRODUCT_ID FROM PRODUCT_IMAGES WHERE PRODUCT_ID = #attributes.PID# ORDER BY PRODUCT_IMAGEID DESC
            </cfquery>
            <cfoutput query="get_image"><img src="/documents/product/#path#" width="150" height="150"></cfoutput></td>
        </tr>
        <tr>
            <td class="txtbold"><cf_get_lang dictionary_id='32512.Envanter'></td>
            <td class="txtbold">:</td>
            <td>
				<cfif get_product.IS_INVENTORY is 1>
                    <cf_get_lang dictionary_id='32513.Envantere dahil'>
                <cfelse>
                    <cf_get_lang dictionary_id='32514.Envantere dahil değil'>
                </cfif>
            </td>
            <td class="txtbold"><cf_get_lang dictionary_id='57633.Barkod'></td>
            <td class="txtbold">:</td>
            <td><cfoutput>#get_product.barcod#</cfoutput></td>
        </tr>
        <tr>
            <td class="txtbold"><cf_get_lang dictionary_id='57456.Üretim'></td>
            <td class="txtbold">:</td>
            <td>
				<cfif get_product.is_production is 1>
                    <cf_get_lang dictionary_id='32517.Üretiliyor'>
                <cfelse>
                    <cf_get_lang dictionary_id='32518.Üretilmiyor'>
                </cfif>
            </td>
            <td class="txtbold"><cf_get_lang dictionary_id='57634.Üretici Kodu'></td>
            <td class="txtbold">:</td>
            <td><cfoutput>#get_product.MANUFACT_CODE#</cfoutput></td>
        </tr>
        <tr>
            <td class="txtbold"><cf_get_lang dictionary_id='57448.Satış'></td>
            <td class="txtbold">:</td>
            <td>
				<cfif get_product.is_SALES is 1>
                    <cf_get_lang dictionary_id='32520.Satışda'>
                <cfelse>
                    <cf_get_lang dictionary_id='32521.Satışta değil'>
                </cfif>
            </td>
            <td class="txtbold"><cf_get_lang dictionary_id='57657.Ürün'></td>
            <td class="txtbold">:</td>
            <td><cfoutput>#get_product.product_name#</cfoutput></td>
        </tr>
        <tr>
            <td class="txtbold"><cf_get_lang dictionary_id='29745.Tedarik'></td>
            <td class="txtbold">:</td>
            <td>
            <cfif get_product.is_purchase is 1>
            <cf_get_lang dictionary_id='32579.Tedarik ediliyor'>
            <cfelse>
            <cf_get_lang dictionary_id='32580.Tedarik yok'>
            </cfif>
            </td>
            <td class="txtbold"><cf_get_lang dictionary_id='57486.Kategori'></td>
            <td class="txtbold">:</td>
            <td>
            <cfoutput query="get_product_cat">
            <cfif PRODUCT_CATID is get_product.PRODUCT_CATID>
            #product_cat#
            </cfif>
            </cfoutput>
            </td>
        </tr>
        <tr>
            <td class="txtbold"><cf_get_lang dictionary_id='32523.Prototip'></td>
            <td class="txtbold">:</td>
            <td>
            <cfif get_product.is_prototype is 1>
            <cf_get_lang dictionary_id='32523.Prototip'>
            <cfelse>
            <cf_get_lang dictionary_id='32581.Prototip değil'>
            </cfif>
            </td>
            <td class="txtbold"></td>
            <td></td>
        </tr>
        <tr>
            <td class="txtbold"><cf_get_lang dictionary_id='32534.Std Fiyatı'></td>
            <td class="txtbold">:</td>
            <td>
                <cfquery name="GET_PRICE" datasource="#DSN3#">
                    SELECT 
                        PRICE,
                        MONEY 
                    FROM 
                        PRICE_STANDART,
                        PRODUCT_UNIT 
                    WHERE
                        PRICE_STANDART.PURCHASESALES = 1 AND 
                        PRODUCT_UNIT.IS_MAIN = 1 AND 
                        PRICE_STANDART.PRICESTANDART_STATUS = 1 AND 
                        PRICE_STANDART.PRODUCT_ID = #URL.PID# AND 
                        PRODUCT_UNIT.PRODUCT_ID = #URL.PID#
                </cfquery>
                <cfoutput>#get_price.price#</cfoutput> 
				<cfoutput query="get_money">
					<cfif get_money.money is get_price.money>
                    #get_money.money#
                    </cfif>
                </cfoutput> 
            </td>
        </tr>
        <tr>
            <td class="txtbold"><cf_get_lang dictionary_id='32549.Muh Kodu'></td>
            <td class="txtbold">:</td>
            <td>
                <cfquery name="get_acc" datasource="#DSN3#">
                    SELECT * FROM PRODUCT_PERIOD WHERE PRODUCT_ID=#URL.pid#
                </cfquery>
                <cfoutput>#get_acc.ACCOUNT_CODE#</cfoutput>
            </td>
            <td class="txtbold"><cf_get_lang dictionary_id='32536.KDV Oranı'></td>
            <td class="txtbold">:</td>
            <td>
				<cfoutput query="get_kdv">
					<cfif tax is get_product.tax>#tax#</cfif>
                </cfoutput>
            </td>
        </tr>
        <tr>
            <td class="txtbold"><cf_get_lang dictionary_id='57544.Sorumlu'></td>
            <td class="txtbold">:</td>
            <td>
				<cfif isdefined("attributes.sid")>
                    <cfquery name="GET_POSITIONS" datasource="#DSN#">
                        SELECT
                            EP.EMPLOYEE_NAME,EP.EMPLOYEE_SURNAME
                        FROM
                            EMPLOYEE_POSITIONS EP, #dsn3_alias#.PRODUCT_CAT PC
                        WHERE
                            PC.PRODUCT_CATID = #GET_PRODUCT.PRODUCT_CATID# AND
                            PC.POSITION_CODE = EP.POSITION_CODE AND EP.POSITION_STATUS = 1
                    </cfquery>
                	<cfoutput>#get_positions.EMPLOYEE_NAME# #get_positions.EMPLOYEE_SURNAME#</cfoutput>
                </cfif>
            </td>
            <td class="txtbold"><cf_get_lang dictionary_id='32538.Raf Ömrü'></td>
            <td class="txtbold">:</td>
            <td><cfoutput>#get_product.SHELF_LIFE# (<cf_get_lang dictionary_id='57490.Gün'>)</cfoutput></td>
        </tr>
        <tr>
            <td colspan="3"></td>
            <td class="txtbold"><cf_get_lang dictionary_id='57629.Açıklama'></td>
            <td class="txtbold">:</td>
            <td><cfoutput>#get_product.PRODUCT_DETAIL#</cfoutput></td>
        </tr>
        <tr>
            <td class="txtbold"><cf_get_lang dictionary_id='32541.Ek Birimler'></td>
            <td class="txtbold">:</td>
        </tr>
        <tr>
            <td colspan="2" valign="top" class="txtbold">
                <cfquery name="GET_PRODUCT_UNIT" datasource="#DSN3#">
                    SELECT 
                        * 
                    FROM 
                        PRODUCT_UNIT 
                    WHERE 
                        PRODUCT_ID = #URL.PID#
                        AND 
                        PRODUCT_UNIT_STATUS = 1
                </cfquery>
				<cfoutput query="GET_PRODUCT_UNIT">
					<cfif is_main is 1>
                        <font color="##ff0000">#add_unit# = #MULTIPLIER# x #main_unit#</font><br/>
                    <cfelse>
                        #add_unit# = #MULTIPLIER# x #main_unit#<br/>
                    </cfif>
                </cfoutput>
            </td>
        </tr>
    </table>
    <cf_popup_box_footer>
        <cf_record_info query_name="get_product" record_emp="record_member">
    </cf_popup_box_footer>
</cf_popup_box>
