﻿<!--- Üretim emrinde sarf ve fire oluşturma... --->

<cfsetting showdebugoutput="no">
<cfquery name="get_product_sarf" datasource="#DSN3#">
	
SELECT
	PRODUCT_ID,
	STOCK_ID,
	SPECT_MAIN_ID,
	sum(AMOUNT) AMOUNT,
	PRODUCT_UNIT_ID,
	0 SPECT_MAIN_ROW_ID,
	PRODUCT_NAME,
	LOT_NO,
	STOCK_CODE,
	MAIN_UNIT,
	SPECT_MAIN_NAME,
	SPECT_VAR_ID,
	IS_PHANTOM,
	IS_SEVK,
	IS_PROPERTY,
	IS_FREE_AMOUNT,
	FIRE_AMOUNT,
	FIRE_RATE,
	PROPERTY
 FROM
	(
	SELECT 
		POS.PRODUCT_ID,
		POS.STOCK_ID,
		POS.SPECT_MAIN_ID,
		   POS.SPECT_VAR_ID,
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
		POS.LOT_NO,
		FIRE_RATE,
		S.PROPERTY
	FROM 
		PRODUCTION_ORDERS PO,
		PRODUCTION_ORDERS_STOCKS POS,
		STOCKS S,
		PRODUCT_UNIT PU
	WHERE
		POS.STOCK_ID = S.STOCK_ID AND 
		POS.PRODUCT_UNIT_ID = PU.PRODUCT_UNIT_ID AND
		POS.P_ORDER_ID =PO.P_ORDER_ID AND
		PO.PARTY_ID=#attributes.party_id# and
		TYPE = 2
	)
	as grp
GROUP BY 
	PRODUCT_ID,
		STOCK_ID,
		PRODUCT_UNIT_ID,
		--SPECT_MAIN_ROW_ID,
		PRODUCT_NAME,
		LOT_NO,
		STOCK_CODE,
		MAIN_UNIT,
		SPECT_MAIN_NAME,
		SPECT_MAIN_ID,
		SPECT_VAR_ID,
		IS_PHANTOM,
		IS_SEVK,
		IS_PROPERTY,
		IS_FREE_AMOUNT,
		FIRE_AMOUNT,
		FIRE_RATE,
		PROPERTY
</cfquery>
<cfquery name="get_product_fire" datasource="#DSN3#">
SELECT 
	POS.PRODUCT_ID,
	POS.STOCK_ID,
	POS.SPECT_MAIN_ID,
	POS.AMOUNT,
	POS.PRODUCT_UNIT_ID,
	POS.SPECT_MAIN_ROW_ID,
	POS.LOT_NO,
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
	PRODUCTION_ORDERS PO,
	PRODUCTION_ORDERS_STOCKS POS,
	STOCKS S,
	PRODUCT_UNIT PU
WHERE
	POS.STOCK_ID = S.STOCK_ID AND 
	POS.PRODUCT_UNIT_ID = PU.PRODUCT_UNIT_ID AND
	POS.P_ORDER_ID =PO.P_ORDER_ID AND
	PO.PARTY_ID=#attributes.party_id# AND
	TYPE = 3
ORDER BY
	POS.RECORD_DATE DESC
</cfquery>
<div class="row">
	<input type="hidden" name="main_stock_id" id="main_stock_id" value="<cfoutput>#attributes.stock_id#</cfoutput>" >
	<input type="hidden" name="product_sarf_recordcount" id="product_sarf_recordcount" value="<cfoutput>#get_product_sarf.recordcount#</cfoutput>">
	<input type="hidden" name="product_fire_recordcount" id="product_fire_recordcount" value="<cfoutput>#get_product_fire.recordcount#</cfoutput>">
	<cfset deger_value_row = get_product_sarf.recordcount>
	<cfset deger_value_row_fire = get_product_fire.recordcount>
	<input type="hidden" name="record_num_exit" id="record_num_exit" value="<cfoutput>#deger_value_row#</cfoutput>"/>
	<input type="hidden" name="record_num_outage" id="record_num_outage" value="<cfoutput>#deger_value_row#</cfoutput>"/>
	<!---/*Sarflar*/--->
	<cf_seperator title="#getLang('main',2212)#" id="sarf_" is_closed="1">
	<div id="sarf_" style="display:none;">
		<cf_ajax_list id="table2">
			<thead>
				<tr>
						<cfif isdefined("is_add_product_sarf_fire") and is_add_product_sarf_fire eq 1>
					<th width="40"> <a href="javascript://" onClick="add_row_exit();"><img src="/images/plus_list.gif" align="absmiddle" border="0" ></a> </th>
						</cfif>
					<th width="15"><cf_get_lang_main no="75.No"></th>
					<th width="125"><cf_get_lang_main no='106.Stok Kodu'></th>
					<th width="300"><cf_get_lang_main no='245.Ürün'></th>
					<th width="300"><cf_get_lang_main no='235.Spec'></th>
						<cfif isdefined("is_show_lot_no") and is_show_lot_no eq 1>
					<th width="120"><cf_get_lang no='385.Lot No'></th>
						</cfif>
					<th width="100"><cf_get_lang_main no='223.Miktar'></th>
					<th width="60"><cf_get_lang_main no='224.Birim'></th>
					<th width="5">Seç</th>
					<!---<th width="5"></th>--->
				</tr>
			</thead>
			<tbody>
				<cfoutput query="get_product_sarf">
					<tr id="frm_row_exit#currentrow#" <cfif IS_PHANTOM eq 1>bgcolor="66CCFF" title="Phantom Ağaç Ürünü"<cfelseif IS_PHANTOM eq 0>class="color-row"</cfif>>
						<cfif isdefined("is_add_product_sarf_fire") and is_add_product_sarf_fire eq 1>
							<td nowrap="nowrap">
								<a style="cursor:pointer" onclick="copy_row_exit('#currentrow#');"><img src="images/copy_list.gif" title="<cf_get_lang_main no='1560.Satır Kopyala'>" border="0"></a><a style="cursor:pointer;" onclick="sil_exit('#currentrow#');"><img src="images/delete_list.gif" border="0" align="absmiddle" title="<cf_get_lang_main no='51.Sil'>"></a>
							</td>
						</cfif>
						<td>#currentrow#</td>
						<td>
							<input type="hidden" name="row_kontrol_exit#currentrow#" id="row_kontrol_exit#currentrow#" value="1">
							<input type="hidden" name="is_phantom_exit#currentrow#" id="is_phantom_exit#currentrow#"value="#IS_PHANTOM#">
							<input type="hidden" name="is_sevk_exit#currentrow#" id="is_sevk_exit#currentrow#"value="#IS_SEVK#">
							<input type="hidden" name="is_property_exit#currentrow#" id="is_property_exit#currentrow#"value="#IS_PROPERTY#">
							<input type="hidden" name="is_free_amount_exit#currentrow#" id="is_free_amount_exit#currentrow#"value="#IS_FREE_AMOUNT#">
							<input type="hidden" name="fire_amount_exit#currentrow#" id="fire_amount_exit#currentrow#"value="#FIRE_AMOUNT#">
							<input type="hidden" name="fire_rate_exit#currentrow#" id="fire_rate_exit#currentrow#"value="#FIRE_RATE#">
							<!---<input type="hidden" name="line_number_exit#currentrow#" id="line_number_exit#currentrow#"value="#LINE_NUMBER#">
							<input type="hidden" name="wrk_row_id_exit#currentrow#" id="wrk_row_id_exit#currentrow#"value="#WRK_ROW_ID#">--->
							<input type="text" name="stock_code_exit#currentrow#" id="stock_code_exit#currentrow#" value="#STOCK_CODE#" style="width:150px; border:none;" readonly="">
						</td>
						<td nowrap>
							<input type="hidden" name="product_id_exit#currentrow#" id="product_id_exit#currentrow#" value="#product_id#">
							<input type="hidden" name="stock_id_exit#currentrow#" id="stock_id_exit#currentrow#" value="#stock_id#">
							<input type="text" name="product_name_exit#currentrow#" id="product_name_exit#currentrow#" value="#PRODUCT_NAME# #PROPERTY#" readonly style="width:280px; border:none;">
							<!---<a href="javascript://" onClick="pencere_ac_alternative('#currentrow#',document.add_production_order.product_id_exit#currentrow#.value,document.add_production_order.main_stock_id.value);"><img src="/images/plus_thin.gif" align="absmiddle" border="0" title="Alternatif Ürünler"></a>--->
							<a href="javascript://" onClick="get_stok_spec_detail_ajax('#product_id#');"><img src="/images/plus_thin_p.gif" style="cursor:pointer;" align="absmiddle" border="0" title="Stok Detay"></a>
						</td>
						<td nowrap="nowrap">
							<input type="hidden" name="spect_main_row_exit#currentrow#" id="spect_main_row_exit#currentrow#" value="#SPECT_MAIN_ROW_ID#">
							<input type="hidden" name="spect_id_exit#currentrow#" id="spect_id_exit#currentrow#" value="#spect_var_id#">
							<input type="text"   name="spec_main_id_exit#currentrow#" id="spec_main_id_exit#currentrow#" value="#spect_main_id#" readonly style="width:40px; border:none;">
							<input type="text"   name="spect_name_exit#currentrow#" id="spect_name_exit#currentrow#" value="#SPECT_MAIN_NAME#" readonly style="width:200px; border:none;">
							<a href="javascript://" onclick="pencere_ac_spect('#currentrow#',2);"><img src="/images/plus_thin.gif" align="absbottom" border="0"></a>
						</td>
						<cfif isdefined("is_show_lot_no") and is_show_lot_no eq 1>
							<td nowrap="nowrap">
								<input type="text" name="lot_no_exit#currentrow#" id="lot_no_exit#currentrow#" value="#lot_no#" onKeyup="lotno_control(#currentrow#,2);" style="width:100px; border:none;"/>
								<a href="javascript://" onclick="pencere_ac_list_product('#currentrow#','2');"><img src="/images/plus_thin.gif" style="cursor:pointer;" align="absbottom" border="0"></a>
							</td>
						</cfif>
						<td>
							<input type="text"   name="amount_exit#currentrow#"  id="amount_exit#currentrow#"  value="#TlFormat(wrk_round(AMOUNT,0),2)#" <cfif isdefined("is_update_sarf_amount") and is_update_sarf_amount eq 0>readonly="readonly"</cfif> onKeyup="return(FormatCurrency(this,event,8));" onblur="aktar2(2,#currentrow#);" class="moneybox" style="width:100px; border:none;">
							<input type="hidden" name="amount_exit_#currentrow#" id="amount_exit_#currentrow#" value="#TlFormat(wrk_round(AMOUNT,0),2)#" onKeyup="return(FormatCurrency(this,event,8));" class="moneybox" style="width:100px; border:none;">
						</td>
						<td>
							<input type="hidden" name="unit_id_exit#currentrow#" id="unit_id_exit#currentrow#" value="#product_unit_id#">
							<input type="text"   name="unit_exit#currentrow#"    id="unit_exit#currentrow#"    value="#main_unit#" readonly style="width:60px; border:none;">
							<input type="hidden" name="old_stock_id#currentrow#" id="old_stock_id#currentrow#" value="">
						</td>
						<td>
							<input type="checkbox" name="sec#currentrow#">	
						</td>
						<!---<td><a href="javascript://" onClick="open_product_sarf('#currentrow#');"><img src="/images/plus_thin.gif" align="absmiddle" border="0" title="Alternatif Ürünler"></a></td>--->
					</tr>
				</cfoutput>
			</tbody>
		</cf_ajax_list>
		<tfoot>
			<tr>
				<td colspan="8" style="text-align:right;"><input type="button" value="İç Talep Oluştur" onClick="gondertalep(1)">
				<!---<input type="button" value="Stok Fişi Oluştur" onClick="gondertalep(2)"></td>--->
			</tr>
		</tfoot>
	</div>
	<!---/*Fireler*/--->
	<cf_seperator header="#getLang('prod',9)#" id="fire_" is_closed="1">
	<div id="fire_" style="display:none;">
		<cf_form_list id="table3">
			<thead>
				<tr>
						<cfif isdefined("is_add_product_sarf_fire") and is_add_product_sarf_fire eq 1>
					<th width="40">
						<a href="javascript://" onClick="add_row_outage();"><img src="/images/plus_list.gif" align="absmiddle" border="0"></a>
					</th>
						</cfif>
					<th width="15"><cf_get_lang_main no="75.No"></th>
					<th width="125"><cf_get_lang_main no='106.Stok Kodu'></th>
					<th width="300"><cf_get_lang_main no='245.Ürün'></th>
					<th width="300"><cf_get_lang_main no='235.Spec'></th>
						<cfif isdefined("is_show_lot_no") and is_show_lot_no eq 1>
					<th width="120"><cf_get_lang no='385.Lot No'></th>
						</cfif>
					<th width="100"><cf_get_lang_main no='223.Miktar'></th>
					<th width="60"><cf_get_lang_main no='224.Birim'></th>
				</tr>
			</thead>
			<tbody>
			<cfoutput query="get_product_fire">
				<tr id="frm_row_outage#currentrow#">
						<cfif isdefined("is_add_product_sarf_fire") and is_add_product_sarf_fire eq 1>
					<td nowrap="nowrap">
						<a style="cursor:pointer" onclick="copy_row_outage('#currentrow#');"><img src="images/copy_list.gif"  title="<cf_get_lang_main no='1560.Satır Kopyala'>" border="0"></a><a style="cursor:pointer" onclick="sil_outage('#currentrow#');"><img src="images/delete_list.gif" border="0" align="absmiddle" title="<cf_get_lang_main no='51.Sil'>"></a>
					</td>
						</cfif>
					<td>#currentrow#</td>
					<td>
						<input type="hidden" name="row_kontrol_outage#currentrow#" id="row_kontrol_outage#currentrow#" value="1">
						<input type="hidden" name="is_phantom_outage#currentrow#" id="is_phantom_outage#currentrow#"value="#IS_PHANTOM#">
						<input type="hidden" name="is_sevk_outage#currentrow#" id="is_sevk_outage#currentrow#"value="#IS_SEVK#">
						<input type="hidden" name="is_property_outage#currentrow#" id="is_property_outage#currentrow#"value="#IS_PROPERTY#">
						<input type="hidden" name="is_free_amount_outage#currentrow#" id="is_free_amount_outage#currentrow#"value="#IS_FREE_AMOUNT#">
						<input type="hidden" name="fire_amount_outage#currentrow#" id="fire_amount_outage#currentrow#"value="#FIRE_AMOUNT#">
						<input type="hidden" name="fire_rate_outage#currentrow#" id="fire_rate_outage#currentrow#"value="#FIRE_RATE#">
						<input type="hidden" name="line_number_outage#currentrow#" id="line_number_outage#currentrow#"value="#LINE_NUMBER#">
						<input type="hidden" name="wrk_row_id_outage#currentrow#" id="wrk_row_id_outage#currentrow#"value="#WRK_ROW_ID#">
						<input type="text"   name="stock_code_outage#currentrow#" id="stock_code_outage#currentrow#" value="#STOCK_CODE#" style="width:150px;" readonly>
					</td>
					<td nowrap>
						<input type="hidden" name="product_id_outage#currentrow#" id="product_id_outage#currentrow#"value="#product_id#">
						<input type="hidden" name="stock_id_outage#currentrow#" id="stock_id_outage#currentrow#" value="#stock_id#" style="border:none;">
						<input type="text" name="product_name_outage#currentrow#" id="product_name_outage#currentrow#" value="#PRODUCT_NAME#" readonly style="width:280px; border:none;">
						<!---<a href="javascript://" onClick="pencere_ac_alternative_outage('#currentrow#',document.add_production_order.product_id_outage#currentrow#.value,document.add_production_order.main_stock_id.value);"><img src="/images/plus_thin.gif" align="absmiddle" border="0" title="Alternatif Ürünler"></a>--->
						<a href="javascript://" onClick="get_stok_spec_detail_ajax_outage('#product_id#');"><img src="/images/plus_thin_p.gif" style="cursor:pointer; border:none;" align="absmiddle" border="0" title="Stok Detay"></a>
					</td>
					<td nowrap="nowrap">
						<input type="hidden" name="spect_main_row_outage#currentrow#" id="spect_main_row_outage#currentrow#"value="#SPECT_MAIN_ROW_ID#">
						<input type="hidden" name="spect_id_outage#currentrow#" id="spect_id_outage#currentrow#"value="#spect_var_id#">
						<input type="text" name="spec_main_id_outage#currentrow#" id="spec_main_id_outage#currentrow#" value="#spect_main_id#" readonly style="width:40px; ">
						<input type="text" name="spect_name_outage#currentrow#" id="spect_name_outage#currentrow#" value="#SPECT_MAIN_NAME#" readonly style="width:200px;">
						<a href="javascript://" onclick="pencere_ac_spect('#currentrow#',3);"><img src="/images/plus_thin.gif" align="absbottom" border="0"></a>
					</td>
						<cfif isdefined("is_show_lot_no") and is_show_lot_no eq 1>
					<td nowrap="nowrap">
						<input type="text" name="lot_no_outage#currentrow#" id="lot_no_outage#currentrow#" value="#lot_no#" onKeyup="lotno_control(#currentrow#,3);" style="width:100px;" />
						<a href="javascript://" onclick="pencere_ac_list_product('#currentrow#','3');"><img src="/images/plus_thin.gif" style="cursor:pointer;" align="absbottom" border="0"></a>
					</td>
						</cfif>
					<td>
						<input type="text" name="amount_outage#currentrow#" id="amount_outage#currentrow#" value="#TlFormat(wrk_round(AMOUNT,8,1),8)#" <cfif isdefined("is_update_sarf_amount") and is_update_sarf_amount eq 0>readonly="readonly"</cfif> onKeyup="return(FormatCurrency(this,event,8));" onblur="aktar2(3,#currentrow#);" class="moneybox" style="width:100px;">
						<input type="hidden" name="amount_outage_#currentrow#" id="amount_outage_#currentrow#" value="#TlFormat(wrk_round(AMOUNT,8,1),8)#" onKeyup="return(FormatCurrency(this,event,8));" class="moneybox" style="width:100px;">	
					</td>
					<td>
						<input type="hidden" name="unit_id_outage#currentrow#" id="unit_id_outage#currentrow#" value="#product_unit_id#">
						<input type="text" name="unit_outage#currentrow#" id="unit_outage#currentrow#" value="#main_unit#" readonly style="width:60px; border:none;">
					</td>
				</tr>
			</cfoutput>
			</tbody>
		</cf_form_list>
	</div>
	<br/>
	<div id="prod_stock_and_spec_detail_div" align="center" style="position:absolute;width:300px; height:150; overflow:hidden;z-index:1;"></div>
</div>
