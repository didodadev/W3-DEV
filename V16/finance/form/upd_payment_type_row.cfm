  <table width="100%" cellpadding="2" cellspacing="1" border="0" height="100%">
	  <tr class="color-list">
		<td class="headbold" colspan="5" height="22"><cf_get_lang no='530.Bakım Kalemleri'></td>
	 </tr>
	 <tr>
	   <td class="color-row" valign="top">
		 <table name="table1" id="table1">
			<tr class="txtboldblue">
			  <td width="165"><cf_get_lang no='141.Bakım Kalemi'> *</td>
			  <td width="200"><cf_get_lang_main no='217.Açıklama'></td>
			  <td width="50"><cf_get_lang_main no='223.Miktar'> *</td>
			  <td width="60"><cf_get_lang_main no='224.Birim'> *</td>
			  <td width="15"><input name="record_num" id="record_num" type="hidden" value="0"><input type="button" class="eklebuton" title="<cf_get_lang_main no='170.Ekle'>" onClick="add_row();"></td>
			</tr>
			<cfif get_care_report_row.recordCount>
			<cfoutput query="get_care_report_row">
			<tr id="frm_row#currentrow#">
			  <td nowrap>
				<input type="hidden" value="1" name="row_kontrol#currentrow#" id="row_kontrol#currentrow#">
				<input type="hidden" name="care_cat_id#currentrow#"id="care_cat_id#currentrow#" value="#get_care_report_row.care_cat_id#">
				<input type="text" name="care_cat#currentrow#" id="care_cat#currentrow#" value="#get_care_report_row.hierarchy# #get_care_report_row.care_cat#" readonly="yes" style="width:150px;">
				<a href="javascript://"onClick="windowopen('#request.self#?fuseaction=objects.popup_care_cat_names&field_id=upd_asset_care.care_cat_id#currentrow#&field_name=upd_asset_care.care_cat#currentrow#','list');"><img src="/images/plus_thin.gif" border="0"  align="absmiddle"></a>
			  </td>
			  <td nowrap><input type="text" name="detail#currentrow#" id="detail#currentrow#" value="#get_care_report_row.detail#" maxlength="50" style="width:200px;"></td>
			  <td nowrap><input type="text" name="quantity#currentrow#" id="quantity#currentrow#" class="moneybox" value="#tlformat(get_care_report_row.quantity)#" onKeyUp='return(FormatCurrency(this,event));' style="width:50px;"></td>
			  <td nowrap>
				<select name="unit#currentrow#" id="unit#currentrow#" style="width:60px;">
				<cfset unit_ = unit>
				<cfinclude template="../query/get_unit.cfm">		
				<cfloop query="get_unit">
					<option value="#unit_id#" <cfif unit_ eq unit_id>selected</cfif>>#unit#</option>
				</cfloop>
				</select>
			  </td>
			  <td nowrap><a style="cursor:pointer" onClick="sil_sor(#currentrow#);"><img  src="images/delete_list.gif" border="0" align="absmiddle"></a></td>
			</cfoutput>
			</cfif>
		 </table>
	   </td>
	</tr>
  </table>

