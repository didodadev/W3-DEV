<!--- unıon un 2 qurubu session.ep.our_company_info.product_conf 0 sa stok_id olmadıgı icin koyuldu--->
<cfquery name="GET_SPECT_ROW" datasource="#dsn3#">
    <cfif attributes.type eq 'upd'>
        SELECT 
                STOCKS.IS_PRODUCTION,
                SPECTS_ROW.RELATED_SPECT_ID AS SPECT_MAIN_ID,
                SPECTS_ROW.*,
                STOCKS.STOCK_CODE,
                STOCKS.PROPERTY,
                SPECTS_ROW.LINE_NUMBER
            FROM 
                SPECTS_ROW,
                STOCKS
            WHERE 
                SPECT_ID = <cfqueryparam cfsqltype = "cf_sql_integer" value = "#attributes.id#">
                AND SPECTS_ROW.STOCK_ID=STOCKS.STOCK_ID
        UNION 
            SELECT
                0 AS IS_PRODUCTION,
                SPECTS_ROW.RELATED_SPECT_ID AS SPECT_MAIN_ID,
                SPECTS_ROW.*,
                '',
                '',
                SPECTS_ROW.LINE_NUMBER
            FROM 
                SPECTS_ROW
            WHERE 
                SPECT_ID = <cfqueryparam cfsqltype = "cf_sql_integer" value = "#attributes.id#"> AND
                STOCK_ID IS NULL
        ORDER BY  
                SPECTS_ROW.LINE_NUMBER
    <cfelse>
        SELECT 
            STOCKS.PRODUCT_NAME,
            STOCKS.PRODUCT_ID,
            STOCKS.IS_PRODUCTION,
            STOCKS.STOCK_ID,
            STOCKS.STOCK_CODE,
            STOCKS.PROPERTY,
            PRODUCT_TREE.AMOUNT,
            PRODUCT_TREE.PRODUCT_TREE_ID,
            PRODUCT_TREE.SPECT_MAIN_ID,
            PRODUCT_UNIT.MAIN_UNIT,
            PRODUCT_TREE.IS_CONFIGURE,
            PRODUCT_TREE.IS_SEVK,
            PRODUCT_TREE.LINE_NUMBER,
            (SELECT SPECT_MAIN_NAME FROM SPECT_MAIN SM WHERE SM.SPECT_MAIN_ID = PRODUCT_TREE.SPECT_MAIN_ID) SPECT_MAIN_NAME,
            0 AS IS_PROPERTY
        FROM
            STOCKS,
            PRODUCT_TREE,
            PRODUCT_UNIT
        WHERE
            PRODUCT_UNIT.PRODUCT_UNIT_ID = PRODUCT_TREE.UNIT_ID AND
            PRODUCT_TREE.RELATED_ID = STOCKS.STOCK_ID AND
            PRODUCT_TREE.STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.stock_id#">
        ORDER BY  PRODUCT_TREE.LINE_NUMBER,STOCKS.PRODUCT_NAME
    </cfif>
</cfquery>
<cfquery name="GET_PROPERTY" datasource="#dsn1#">
    SELECT 
		PRODUCT_DT_PROPERTIES.*,
		PRODUCT_PROPERTY.PROPERTY,
		PRODUCT_PROPERTY.PROPERTY_ID
	FROM 
		PRODUCT_DT_PROPERTIES,
		PRODUCT_PROPERTY
	WHERE 
		PRODUCT_DT_PROPERTIES.PRODUCT_ID = #attributes.product_id# AND
		PRODUCT_DT_PROPERTIES.PROPERTY_ID = PRODUCT_PROPERTY.PROPERTY_ID
</cfquery>
<cfquery name="GET_SPECT_PRO" dbtype="query">
    SELECT * FROM GET_SPECT_ROW WHERE IS_PROPERTY=1
</cfquery>
<cfset colspan = 3 />
<cf_grid_list>
    <thead>
        <tr>
            <th width="100"><cf_get_lang dictionary_id ='57632.Özellik'></th>
            <th width="110"><cf_get_lang dictionary_id ='33615.Varyasyon'></th>
            <th width="140"><cf_get_lang dictionary_id ='57629.Açıklama'></th>
            <cfif isdefined('is_show_value') and is_show_value eq 1>
                <th width="65"><cf_get_lang dictionary_id ='33616.Değer'></th>
                <cfset colspan++ />
            </cfif>
            <cfif isdefined('is_show_tolerance_property') and is_show_tolerance_property eq 1>
                <th width="30"><cf_get_lang dictionary_id='29443.Tolerans'></th>
                <cfset colspan++ />
            </cfif>
            <cfif isdefined('is_show_property_amount') and is_show_property_amount eq 1>
                <th width="50"><cf_get_lang dictionary_id ='57635.Miktar'></th>
                <cfset colspan++ />
            </cfif>
            <cfif isdefined('is_show_property_price') and is_show_property_price eq 1>
                <th width="80"><cf_get_lang dictionary_id ='57673.Tutar'></th>
                <th width="50"><cf_get_lang dictionary_id ='57489.Para Br'></th>
                <th width="80"><cf_get_lang dictionary_id ='33932.Toplam Fiyat'></th>
                <cfset colspan += 3 />
            </cfif>
        </tr>
    </thead>
    <tbody>
        <cfif GET_SPECT_PRO.RECORDCOUNT>
            <cfoutput query="GET_SPECT_PRO"> 
                <tr>
                    <cfquery name="GET_VARIATION" datasource="#DSN1#">
                        SELECT PROPERTY_DETAIL_ID, PROPERTY_DETAIL FROM PRODUCT_PROPERTY_DETAIL WHERE PRPT_ID = #property_id#
                    </cfquery>
                    <cfquery name="GET_PROPERTY_NAME" dbtype="query">
                        SELECT PROPERTY FROM GET_PROPERTY WHERE PROPERTY_ID = #property_id#
                    </cfquery>
                    <td><b>#GET_PROPERTY_NAME.property#</b></td>
                    <td>
                        <div class="form-group">
                            <input type="hidden" name="is_active#currentrow#" id="is_active#currentrow#" value="1">
                            <input type="hidden" name="pro_property_id#currentrow#" id="pro_property_id#currentrow#" value="#GET_SPECT_PRO.property_id#">
                            <select name="pro_variation_id#currentrow#" id="pro_variation_id#currentrow#" style="width:140px;">
                                <option value="" style="width:100px;">Varyasyon</option>
                                <cfloop query="get_variation">	
                                    <option value="#PROPERTY_DETAIL_ID#" <cfif GET_SPECT_PRO.VARIATION_ID eq PROPERTY_DETAIL_ID>selected</cfif>>#PROPERTY_DETAIL#</option>
                                </cfloop>
                            </select>
                        </div>
                    </td>
                    <td><div class="form-group"><input type="text" name="pro_product_name#currentrow#" id="pro_product_name#currentrow#" value="#GET_SPECT_PRO.product_name#" onBlur="hesapla_();" maxlength="250"></div></td>
                    <cfif isdefined('is_show_value') and is_show_value eq 0><td nowrap="nowrap">
                        <div class="form-group">
                            <cfinput type="text" name="pro_total_min#currentrow#" value="#TLFormat(GET_SPECT_PRO.TOTAL_MIN,8)#" validate="float" message="#getLang('','Sayı Giriniz',33933)#">
                            <cfinput type="text" name="pro_total_max#currentrow#" value="#TLFormat(GET_SPECT_PRO.TOTAL_MAX,8)#" validate="float" message="#getLang('','Sayı Giriniz',33933)#">
                        </div>
                    </td>
                    </cfif>
                    <td <cfif isdefined('is_show_tolerance_property') and is_show_tolerance_property eq 0> style="display:none"</cfif>><div class="form-group"><input type="text" name="pro_tolerance#currentrow#" id="pro_tolerance#currentrow#" value="#GET_SPECT_PRO.TOLERANCE#" style="width:50px;"></div></td>
                    <td <cfif isdefined('is_show_property_amount') and is_show_property_amount eq 0> style="display:none"</cfif>><div class="form-group"><cfinput type="text" name="pro_amount#currentrow#" value="#TLFormat(GET_SPECT_PRO.AMOUNT_VALUE,8)#" onkeyup="return(FormatCurrency(this,event,8));"  validate="float" onBlur="hesapla_();" class="moneybox" message="#getLang('','Sayı Giriniz',33933)#"></div></td>
                    <td <cfif isdefined('is_show_property_price') and is_show_property_price eq 0> style="display:none"</cfif>><div class="form-group"><input type="text" name="pro_total_amount#currentrow#" id="pro_total_amount#currentrow#" onBlur="hesapla_();" value="#TLFormat(GET_SPECT_PRO.TOTAL_VALUE,8)#" onkeyup="return(FormatCurrency(this,event,8));" class="moneybox"></div></td>
                    <td <cfif isdefined('is_show_property_price') and is_show_property_price eq 0> style="display:none"</cfif>><div class="form-group"><select name="pro_money_type#currentrow#" id="pro_money_type#currentrow#" onChange="hesapla_();" style="width:50px;"><cfloop query="get_money"><option value="#rate1#,#rate2#,#money#" <cfif GET_SPECT_PRO.MONEY_CURRENCY eq money>selected</cfif>>#money#</option></cfloop></select></div></td>
                    <td <cfif isdefined('is_show_property_price') and is_show_property_price eq 0> style="display:none"</cfif>><div class="form-group"><input type="text" name="pro_sum_amount#currentrow#" id="pro_sum_amount#currentrow#" value="#TLFormat(0,8)#" onkeyup="return(FormatCurrency(this,event,8));" class="moneybox" onBlur="hesapla_();"></div></td>
                </tr>
            </cfoutput>
        <cfelseif GET_PROPERTY.RECORDCOUNT>
            <cfoutput query="get_property">
                <tr>
                    <cfquery name="GET_VARIATION" datasource="#DSN1#">
                        SELECT PROPERTY_DETAIL_ID, PROPERTY_DETAIL FROM PRODUCT_PROPERTY_DETAIL WHERE PRPT_ID = #property_id#
                    </cfquery>
                    <cfquery name="GET_PROPERTY_NAME" dbtype="query">
                        SELECT PROPERTY FROM GET_PROPERTY WHERE PROPERTY_ID = #property_id#
                    </cfquery>
                    <td><b>#GET_PROPERTY_NAME.property#</b></td>
                    <td>
                        <div class="form-group">
                            <input type="hidden" name="pro_property_id#currentrow#" id="pro_property_id#currentrow#" value="#property_id#">
                            <select name="pro_variation_id#currentrow#" id="pro_variation_id#currentrow#" style="width:140px;">
                                <cfset var_value = get_property.variation_id>
                                <option value=""><cf_get_lang dictionary_id ='33615.Varyasyon'></option>
                                <cfloop query="get_variation">	
                                <option value="#PROPERTY_DETAIL_ID#" <cfif var_value eq PROPERTY_DETAIL_ID>selected</cfif>>#PROPERTY_DETAIL#</option>
                                </cfloop>
                            </select>
                        </div>
                    </td>
                    <td><div class="form-group"><input type="text" name="pro_product_name#currentrow#" id="pro_product_name#currentrow#"></div></td>
                    <cfif isdefined('is_show_value') and is_show_value eq 0>
                        <td nowrap="nowrap">
                        <div class="form-group">
                            <cfinput type="text" name="pro_total_min#currentrow#" value="" validate="float" message="#getLang('','Sayı Giriniz',33933)#">
                            <cfinput type="text" name="pro_total_max#currentrow#" value="" validate="float" message="#getLang('','Sayı Giriniz',33933)#">
                        </div>
                    </td>
                    </cfif>
                    <cfif isdefined('is_show_tolerance_property') and is_show_tolerance_property eq 1><td><div class="form-group"><input type="text" name="pro_tolerance#currentrow#" id="pro_tolerance#currentrow#" value="0" style="width:50px;"></div></td></cfif>
                    <cfif isdefined('is_show_property_amount') and is_show_property_amount eq 1><td><div class="form-group"><cfinput type="text" name="pro_amount#currentrow#" value="" validate="float" message="#getLang('','Sayı Giriniz',33933)#" style="width:50px" class="moneybox" onBlur="hesapla_();"></div></td></cfif>
                    <cfif isdefined('is_show_property_price') and is_show_property_price eq 1><td><div class="form-group"><input type="text" name="pro_total_amount#currentrow#" id="pro_total_amount#currentrow#" value="" onkeyup="return(FormatCurrency(this,event,8));" class="moneybox" style="width:80px" onBlur="hesapla_();"></div></td></cfif>
                    <cfif isdefined('is_show_property_price') and is_show_property_price eq 1> <td><div class="form-group"><select name="pro_money_type#currentrow#" id="pro_money_type#currentrow#" onChange="hesapla_();" style="width:50px;"><cfloop query="get_money"><option value="#rate1#,#rate2#,#money#" <cfif money eq session.ep.money>selected</cfif>>#money#</option></cfloop></select></div></td></cfif>
                    <cfif isdefined('is_show_property_price') and is_show_property_price eq 1><td><div class="form-group"><input type="text" name="pro_sum_amount#currentrow#" id="pro_sum_amount#currentrow#" value="#TLFormat(0,8)#" onkeyup="return(FormatCurrency(this,event,8));" class="moneybox" style="width:80px" onBlur="hesapla_();"></div></td></cfif>
                </tr>
            </cfoutput>
        <cfelse>
            <tr><td colspan = "<cfoutput>#colspan#</cfoutput>"><cf_get_lang dictionary_id = '57484.Kayıt Yok'></td></tr>
        </cfif>
    </tbody>
    <input type="hidden" name="pro_record_num" id="pro_record_num" value="<cfoutput>#GET_SPECT_PRO.RECORDCOUNT ? GET_SPECT_PRO.RECORDCOUNT : GET_PROPERTY.RECORDCOUNT#</cfoutput>">
</cf_grid_list>