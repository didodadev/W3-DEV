<table cellpadding="2" cellspacing="1" border="0">
  <tr class="color-list">
	<td class="headbold" colspan="5" height="22"><cf_get_lang no ='207.Pos Ödeme Tipleri'></td>
 </tr>
 <tr>
   <td class="color-row" valign="top">	
   <table name="table1" id="table1">
	  <tr class="txtboldblue">
	  <td width="15"><input name="record_num" id="record_num" type="hidden" value="0"><input type="button" class="eklebuton" title="<cf_get_lang_main no='170.Ekle'>" onClick="add_row();"></td>
	  <td width="90"><cf_get_lang no ='208.Referans ID'> *</td>
	  <td width="150"><cf_get_lang_main no='1516.Ödeme Tipi'> *</td>
	  <td width="130"><cf_get_lang_main no='1399.Muhasebe Kodu'> *</td>

	</tr>
	<cfif get_payment_type_row.recordCount>
	<cfoutput query="get_payment_type_row">
	<tr id="frm_row#currentrow#">
	  <td><input  type="hidden" name="payment_row_kontrol#currentrow#" id="payment_row_kontrol#currentrow#" value="1"><a style="cursor:pointer" onClick="delete_row(#currentrow#);"><img  src="images/delete_list.gif"  alt="" border="0" align="absmiddle"></a></td>
	  <td>
	  	<!--- 0 Kasa EBircan istegi 20070115 --->
		<select name="referans_id#currentrow#" id="referans_id#currentrow#" style="width:90px">
		<cfloop from="1" to="39" index="i">
		  <option value="#i#" <cfif pos_referans_id eq i>selected</cfif>>#NumberFormat(i,00)#</option>
		</cfloop>
		</select>
	  </td>
	  <td><input type="text" name="payment_type#currentrow#" id="payment_type#currentrow#" value="#pos_payment_name#" maxlength="200" style="width:150px"></td>
	  <td>
	 	<input type="hidden" name="account_code#currentrow#" id="account_code#currentrow#" value="#pos_account_code#">
	    <input type="text" name="account_code_name#currentrow#" id="account_code_name#currentrow#" value="#pos_account_code# - #account_name#" readonly style="width:120px;">
		<a style="cursor:pointer" onClick="pencere_ac_acc(#currentrow#);"><img src="images/plus_thin.gif" alt="" border="0" align="absmiddle"></a>
	  </td>	  
	</cfoutput>
	</cfif>
	</table>
   </td>
  </tr>
</table>
