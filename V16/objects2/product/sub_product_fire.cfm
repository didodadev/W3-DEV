<!--- Üretim emrinde sarf ve fire oluşturma... --->
<cfsetting showdebugoutput="no">
<cfquery name="GET_PRODUCT_SARF" datasource="#DSN3#">
	SELECT 
		POS.PRODUCT_ID,
		POS.STOCK_ID,
		POS.SPECT_MAIN_ID,
		POS.AMOUNT,
		POS.PRODUCT_UNIT_ID,
		POS.SPECT_MAIN_ROW_ID,
		S.PRODUCT_NAME,
		S.STOCK_CODE,
		PU.MAIN_UNIT,
		(SELECT TOP 1 SPECT_MAIN_NAME FROM SPECT_MAIN SM WHERE SM.STOCK_ID = S.STOCK_ID) SPECT_MAIN_NAME,
		ISNULL(POS.IS_PHANTOM,0) IS_PHANTOM,
		IS_SEVK,
		IS_PROPERTY,
		IS_FREE_AMOUNT,
		FIRE_AMOUNT,
		FIRE_RATE
	FROM 
		PRODUCTION_ORDERS_STOCKS POS,
		STOCKS S,
		PRODUCT_UNIT PU
	WHERE
		POS.STOCK_ID = S.STOCK_ID AND 
		POS.PRODUCT_UNIT_ID = PU.PRODUCT_UNIT_ID AND
		P_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.upd#"> AND
		TYPE = 2
	ORDER BY
		POS.RECORD_DATE DESC
</cfquery>
<cfquery name="GET_PRODUCT_FIRE" datasource="#DSN3#">
	SELECT 
		POS.PRODUCT_ID,
		POS.STOCK_ID,
		POS.SPECT_MAIN_ID,
		POS.AMOUNT,
		POS.PRODUCT_UNIT_ID,
		POS.SPECT_MAIN_ROW_ID,
		S.PRODUCT_NAME,
		S.STOCK_CODE,
		PU.MAIN_UNIT,
		(SELECT TOP 1 SPECT_MAIN_NAME FROM SPECT_MAIN SM WHERE SM.STOCK_ID = S.STOCK_ID) SPECT_MAIN_NAME,
		IS_PHANTOM,
		IS_SEVK,
		IS_PROPERTY,
		IS_FREE_AMOUNT,
		FIRE_AMOUNT,
		FIRE_RATE
	FROM 
		PRODUCTION_ORDERS_STOCKS POS,
		STOCKS S,
		PRODUCT_UNIT PU
	WHERE
		POS.STOCK_ID = S.STOCK_ID AND 
		POS.PRODUCT_UNIT_ID = PU.PRODUCT_UNIT_ID AND
		P_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.upd#"> AND
		TYPE = 3
	ORDER BY
		POS.RECORD_DATE DESC
</cfquery>
<input type="hidden" name="main_stock_id" id="main_stock_id" value="<cfoutput>#attributes.stock_id#</cfoutput>" >
<input type="hidden" name="product_sarf_recordcount" id="product_sarf_recordcount" value="<cfoutput>#get_product_sarf.recordcount#</cfoutput>">
<input type="hidden" name="product_fire_recordcount" id="product_fire_recordcount" value="<cfoutput>#get_product_fire.recordcount#</cfoutput>">
<cfset deger_value_row = get_product_sarf.recordcount>
<cfset deger_value_row_fire = get_product_fire.recordcount>
<input type="hidden" name="record_num_exit" id="record_num_exit" value="<cfoutput>#deger_value_row#</cfoutput>"/>
<input type="hidden" name="record_num_outage" id="record_num_outage" value="<cfoutput>#deger_value_row#</cfoutput>"/>
<!---/*Sarflar*/--->
<!---<cf_seperator header="#lang_array.item[607]#" id="table2">--->
<table style="width:100%;">
	<thead>
        <tr>
	        <td class="headbold"><br/><br/>Sarflar</td>
        </tr>
        <tr class="color-header" style="height:22px;">
           <!---<cfif isdefined("is_add_product_sarf_fire") and is_add_product_sarf_fire eq 1>
                <th width="15">
                    <a href="javascript://" onClick="add_row_exit();"><img src="/images/plus_list.gif" align="absmiddle" border="0"></a>
                </th>
            </cfif>--->
            <th class="form-title"><cf_get_lang_main no="75.No"></th>
            <th class="form-title"><cf_get_lang_main no='106.Stok Kodu'></th>
            <th class="form-title"><cf_get_lang_main no='245.Ürün'></th>
            <th class="form-title"><cf_get_lang_main no='235.Spec'></th>
            <th class="form-title"><cf_get_lang_main no='223.Miktar'></th>
            <th class="form-title"><cf_get_lang_main no='224.Birim'></th>
        </tr>
    </thead>
    <tbody id="table2" name="table2">
    <cfif get_product_sarf.recordcount>
		<cfoutput query="get_product_sarf">
            <tr id="frm_row_exit#currentrow#" <cfif is_phantom eq 1>bgcolor="66CCFF" title="Phantom Ağaç Ürünü"<cfelseif is_phantom eq 0>class="color-row"</cfif> style="height:20px;">
                <!---<cfif isdefined("is_add_product_sarf_fire") and is_add_product_sarf_fire eq 1>
                    <td>
                        <a style="cursor:pointer;" onclick="sil_exit('#currentrow#');"><img src="images/delete_list.gif" border="0" align="absmiddle" title="<cf_get_lang_main no='51.Sil'>"></a>
                    </td>
                </cfif> --->
                <td>#currentrow#</td>
                <td>
                    <input type="hidden" name="row_kontrol_exit#currentrow#" id="row_kontrol_exit#currentrow#" value="1">
                    <input type="hidden" name="is_phantom_exit#currentrow#" id="is_phantom_exit#currentrow#" value="#is_phantom#">
                    <input type="hidden" name="is_sevk_exit#currentrow#" id="is_sevk_exit#currentrow#" value="#is_sevk#">
                    <input type="hidden" name="is_property_exit#currentrow#" id="is_property_exit#currentrow#" value="#is_property#">
                    <input type="hidden" name="is_free_amount_exit#currentrow#" id="is_free_amount_exit#currentrow#" value="#is_free_amount#">
                    <input type="hidden" name="fire_amount_exit#currentrow#" id="fire_amount_exit#currentrow#" value="#fire_amount#">
                    <input type="hidden" name="fire_rate_exit#currentrow#" id="fire_rate_exit#currentrow#" value="#fire_rate#">
                    <input type="text" name="stock_code_exit#currentrow#" id="stock_code_exit#currentrow#" value="#stock_code#" style="width:120px;" readonly="">
                </td>
                <td nowrap>
                    <input type="hidden" name="product_id_exit#currentrow#" id="product_id_exit#currentrow#"value="#product_id#">
                    <input type="hidden" name="stock_id_exit#currentrow#" id="stock_id_exit#currentrow#" value="#stock_id#">
                    <input type="text" name="product_name_exit#currentrow#" id="product_name_exit#currentrow#" value="#product_name#" readonly style="width:170px;">
                    <!---<a href="javascript://" onClick="pencere_ac_alternative('#currentrow#',document.add_production_order.product_id_exit#currentrow#.value,document.add_production_order.main_stock_id.value);"><img src="/images/plus_thin.gif" align="absmiddle" border="0" title="Alternatif Ürünler"></a>
                    <a href="javascript://" onClick="get_stok_spec_detail_ajax('#product_id#');"><img src="/images/plus_thin_p.gif" style="cursor:pointer;" align="absmiddle" border="0" title="Stok Detay"></a>--->
                </td>
                <td>
                    <input type="hidden" name="spect_main_row_exit#currentrow#" id="spect_main_row_exit#currentrow#" value="#spect_main_row_id#">
                    <input type="text" name="spec_main_id_exit#currentrow#" id="spec_main_id_exit#currentrow#" value="#spect_main_id#" readonly style="width:40px;">
                    <input type="text" name="spect_name_exit#currentrow#" id="spect_name_exit#currentrow#" value="#spect_main_name#" readonly style="width:100px;">
                </td>
                <td>
                    <input type="text" name="amount_exit#currentrow#" id="amount_exit#currentrow#" value="#TlFormat(wrk_round(amount,8,1),2)#" onkeyup="return(FormatCurrency(this,event,8));" readonly onblur="aktar();" class="moneybox" style="width:100px;">
                    <input type="hidden" name="amount_exit_#currentrow#" id="amount_exit_#currentrow#" value="#TlFormat(wrk_round(amount,8,1),8)#" onkeyup="return(FormatCurrency(this,event,8));" onblur="aktar();" class="moneybox" style="width:100px;">
                </td>
                <td>
                    <input type="hidden" name="unit_id_exit#currentrow#" id="unit_id_exit#currentrow#" value="#product_unit_id#">
                    <input type="text" name="unit_exit#currentrow#" id="unit_exit#currentrow#" value="#main_unit#" readonly style="width:60px;">
                </td>
            </tr>
        </cfoutput>
    <cfelse>
         <tr id="frm_row_exit#currentrow#">
            <td colspan="6">Kayıt Yok!</td>
        </tr>   
    </cfif>
   	</tbody>
</table>
<!---/*Fireler*/--->
<!---<cf_seperator header="#lang_array.item[9]#" id="table3"> --->
<table style="width:100%;">
	<thead>
        <tr>
            <td class="headbold"><br/><br/>Fireler</td>
        </tr>
		<tr class="color-header" style="height:22px;">
			<!---<cfif isdefined("is_add_product_sarf_fire") and is_add_product_sarf_fire eq 1>
				<th width="15">
					<a href="javascript://" onClick="add_row_outage();"><img src="/images/plus_list.gif" align="absmiddle" border="0"></a>
				</th>
			</cfif> --->
            <th class="form-title"><cf_get_lang_main no="75.No"></th>
			<th class="form-title"><cf_get_lang_main no='106.Stok Kodu'></th>
			<th class="form-title"><cf_get_lang_main no='245.Ürün'></th>
			<th class="form-title"><cf_get_lang_main no='235.Spec'></th>
			<th class="form-title"><cf_get_lang_main no='223.Miktar'></th>
			<th class="form-title"><cf_get_lang_main no='224.Birim'></th>
		</tr>
    </thead>
    <tbody id="table3" name="table3">
    	<cfif get_product_fire.recordcount>
		<cfoutput query="get_product_fire">
            <tr id="frm_row_outage#currentrow#" class="color-row" style="height:20px;">
                <!---<cfif isdefined("is_add_product_sarf_fire") and is_add_product_sarf_fire eq 1>
                    <td>
                        <a style="cursor:pointer" onclick="sil_outage('#currentrow#');"><img src="images/delete_list.gif" border="0" align="absmiddle" title="<cf_get_lang_main no='51.Sil'>"></a>
                    </td>
                </cfif> --->
                <td>#currentrow#</td>
                <td>
                    <input type="hidden" name="row_kontrol_outage#currentrow#" id="row_kontrol_outage#currentrow#" value="1">
                    <input type="hidden" name="is_phantom_outage#currentrow#" id="is_phantom_outage#currentrow#" value="#is_phantom#">
                    <input type="hidden" name="is_sevk_outage#currentrow#" id="is_sevk_outage#currentrow#" value="#is_sevk#">
                    <input type="hidden" name="is_property_outage#currentrow#" id="is_property_outage#currentrow#" value="#is_property#">
                    <input type="hidden" name="is_free_amount_outage#currentrow#" id="is_free_amount_outage#currentrow#" value="#is_free_amount#">
                    <input type="hidden" name="fire_amount_outage#currentrow#" id="fire_amount_outage#currentrow#" value="#fire_amount#">
                    <input type="hidden" name="fire_rate_outage#currentrow#" id="fire_rate_outage#currentrow#" value="#fire_rate#">
                    <input type="text" name="stock_code_outage#currentrow#" id="stock_code_outage#currentrow#" value="#stock_code#" style="width:120px;" readonly>
                </td>
                <td nowrap>
                    <input type="hidden" name="product_id_outage#currentrow#" id="product_id_outage#currentrow#" value="#product_id#">
                    <input type="hidden" name="stock_id_outage#currentrow#" id="stock_id_outage#currentrow#" value="#stock_id#">
                    <input type="text" name="product_name_outage#currentrow#" id="product_name_outage#currentrow#" value="#product_name#" readonly style="width:220px;">
                    <!---<a href="javascript://" onClick="pencere_ac_alternative_outage('#currentrow#',document.add_production_order.product_id_outage#currentrow#.value,document.add_production_order.main_stock_id.value);"><img src="/images/plus_thin.gif" align="absmiddle" border="0" title="Alternatif Ürünler"></a>
                    <a href="javascript://" onClick="get_stok_spec_detail_ajax_outage('#product_id#');"><img src="/images/plus_thin_p.gif" style="cursor:pointer;" align="absmiddle" border="0" title="Stok Detay"></a>--->
                </td>
                <td>
                    <input type="hidden" name="spect_main_row_outage#currentrow#" id="spect_main_row_outage#currentrow#" value="#spect_main_row_id#">
                    <input type="text" name="spec_main_id_outage#currentrow#" id="spec_main_id_outage#currentrow#" value="#spect_main_id#" readonly style="width:40px;">
                    <input type="text" name="spect_name_outage#currentrow#" id="spect_name_outage#currentrow#" value="#spect_main_name#" readonly style="width:200px;">
                </td>
                <td>
                    <input type="text" name="amount_outage#currentrow#" id="amount_outage#currentrow#" value="#TlFormat(wrk_round(amount,8,1),8)#" readonly onkeyup="return(FormatCurrency(this,event,8));" onblur="aktar();" class="moneybox" style="width:100px;">
                    <input type="hidden" name="amount_outage_#currentrow#" id="amount_outage_#currentrow#" value="#TlFormat(wrk_round(amount,8,1),8)#" onkeyup="return(FormatCurrency(this,event,8));" onblur="aktar();" class="moneybox" style="width:100px;">	
                </td>
                <td>
                    <input type="hidden" name="unit_id_outage#currentrow#" id="unit_id_outage#currentrow#" value="#product_unit_id#">
                    <input type="text" name="unit_outage#currentrow#" id="unit_outage#currentrow#" value="#main_unit#" readonly style="width:60px;">
                </td>
            </tr>
        </cfoutput>
	<cfelse>
         <tr id="frm_row_exit#currentrow#" class="color-row">
            <td colspan="6">Kayıt Yok!</td>
        </tr>   
    </cfif>
    </tbody>
</table>
<br/>
<div id="prod_stock_and_spec_detail_div" align="center" style="position:absolute;width:300px; height:150; overflow:hidden;z-index:1;"></div>
