<table id="table1">
  <tr class="color-header" height="20">
	<td width="15">
	  <input type="hidden" name="payment_record_num" id="payment_record_num" value="0">
	  <input type="button" class="eklebuton" title="<cf_get_lang_main no='170.Ekle'>" onClick="add_row(1);">
	</td>
	<td class="form-title" width="80"><cf_get_lang_main no='330.Tarih'>*</td>
	<td width="90" class="form-title" style="text-align:right;"><cf_get_lang no='12.Ana Para'> *</td>
	<td width="90" class="form-title" style="text-align:right;"><cf_get_lang_main no='1089.Vade Farkı'></td>
	<td width="90" class="form-title" style="text-align:right;"><cf_get_lang no='14.Vergi/Masraf'></td>
	<td width="90" class="form-title" style="text-align:right;"><cf_get_lang_main no='80.Toplam'></td>
	<td class="form-title" width="60"><cf_get_lang_main no='77.Para Br'></td>			
	<td class="form-title" width="150"><cf_get_lang_main no='217.Açıklama'></td>
	<td class="form-title"><cf_get_lang no='21.Ödendi'></td>
  </tr>
<cfoutput query="get_rows_1">
  <cfif is_paid eq 0>
	  <tr id="payment_frm_row#currentrow#">
		<td>
		  <input type="hidden" name="payment_row_kontrol#currentrow#" id="payment_row_kontrol#currentrow#" value="1">
		  <a style="cursor:pointer" onclick="delete_row('#currentrow#',1);"><img  src="images/delete_list.gif" alt="<cf_get_lang dictionary_id='57463.Sil'>" border="0"></a>
		</td>
		<td>
		  <input type="hidden" name="payment_credit_contract_row_id#currentrow#" id="payment_credit_contract_row_id#currentrow#" value="#credit_contract_row_id#">
		  <input type="text" name="payment_date#currentrow#" id="payment_date#currentrow#" value="#dateformat(process_date,dateformat_style)#" style="width:75px;">
		  <a href="javascript://" onClick="pencere_ac_date('#currentrow#',1);"><img border="0" src="/images/calendar.gif" alt="Tarih" align="absmiddle"></a>
		</td>
		<td><input type="text" name="payment_capital_price#currentrow#" id="payment_capital_price#currentrow#" value="#TlFormat(capital_price,session.ep.our_company_info.rate_round_num)#" onKeyup="return(FormatCurrency(this,event));" onblur="write_total_amount();" class="moneybox" style="width:90px;"></td>
		<td><input type="text" name="payment_interest_price#currentrow#" id="payment_interest_price#currentrow#" value="#TlFormat(interest_price,session.ep.our_company_info.rate_round_num)#" onKeyup="return(FormatCurrency(this,event));" onblur="write_total_amount();" class="moneybox" style="width:90px;"></td>
		<td><input type="text" name="payment_tax_price#currentrow#" id="payment_tax_price#currentrow#" value="#TlFormat(tax_price,session.ep.our_company_info.rate_round_num)#" onKeyup="return(FormatCurrency(this,event));" onblur="write_total_amount();" class="moneybox" style="width:90px;"></td>
		<td><input type="text" name="payment_total_price#currentrow#" id="payment_total_price#currentrow#" value="#TlFormat(total_price,session.ep.our_company_info.rate_round_num)#" onKeyup="return(FormatCurrency(this,event));" class="moneybox" readonly style="width:90px;"></td>
		<td>
		  <cfset money_temp = get_rows_1.other_money>
		  <select name="payment_money#currentrow#" id="payment_money#currentrow#" style="width:60px;">
              <cfloop query="get_money">
                <option value="#money#"<cfif money eq money_temp>selected</cfif>>#money#</option>
              </cfloop>
		  </select>
		</td>
		<td><input type="text" name="payment_detail#currentrow#" id="payment_detail#currentrow#" value="#detail#" maxlength="50" style="width:150px;"></td>
		<td>
		  <input type="checkbox" name="payment_is_paid#currentrow#" id="payment_is_paid#currentrow#" value="" <cfif is_paid eq 1>checked</cfif> disabled>
		  <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=credit.popup_add_credit_payment&credit_contract_row_id=#credit_contract_row_id#','list');"><img src="images/money_plus.gif" alt="" border="0"></a>
		</td>
	  </tr>
  <cfelse>
	  <tr id="frm_row#currentrow#">
		<td><input type="hidden" name="payment_row_kontrol#currentrow#" id="payment_row_kontrol#currentrow#" value="1"></td>
		<td>
		  <input type="hidden" name="payment_credit_contract_row_id#currentrow#" id="payment_credit_contract_row_id#currentrow#" value="#credit_contract_row_id#">
		  <input type="text" name="payment_date#currentrow#" id="payment_date#currentrow#" value="#dateformat(process_date,dateformat_style)#" readonly style="width:75px;">
		  <a href="javascript://" onClick=""><img border="0" src="/images/calendar.gif" alt="" align="absmiddle"></a>
		</td>
		<td><input type="text" name="payment_capital_price#currentrow#" id="payment_capital_price#currentrow#" value="#TlFormat(capital_price,session.ep.our_company_info.rate_round_num)#" class="moneybox" readonly style="width:90px;"></td>
		<td><input type="text" name="payment_interest_price#currentrow#" id="payment_interest_price#currentrow#" value="#TlFormat(interest_price,session.ep.our_company_info.rate_round_num)#" class="moneybox" readonly style="width:90px;"></td>
		<td><input type="text" name="payment_tax_price#currentrow#" id="payment_tax_price#currentrow#" value="#TlFormat(tax_price,session.ep.our_company_info.rate_round_num)#" class="moneybox" readonly style="width:90px;"></td>
		<td><input type="text" name="payment_total_price#currentrow#" id="payment_total_price#currentrow#" value="#TlFormat(total_price,session.ep.our_company_info.rate_round_num)#" class="moneybox" readonly style="width:90px;"></td>
		<td>
		  <cfset money_temp = get_rows_1.other_money>
		  <select name="payment_money#currentrow#" id="payment_money#currentrow#" style="width:60px;">
              <cfloop query="get_money">
                <option value="#money#"<cfif money eq money_temp>selected</cfif>>#money#</option>
              </cfloop>
		  </select>
		</td>
		<td><input type="text" name="payment_detail#currentrow#" id="payment_detail#currentrow#" value="#detail#" maxlength="50" readonly style="width:150px;"></td>
		<td>
		  <input type="checkbox" name="payment_is_paid#currentrow#" id="payment_is_paid#currentrow#" value="" checked disabled>
		  <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=credit.popup_upd_credit_payment&credit_contract_row_id=#credit_contract_row_id#&period_id=#period_id#&our_company_id=#our_company_id#','list');"><img src="images/money_plus.gif" alt="" border="0"></a>
		</td>
	  </tr>  
  </cfif>
</cfoutput>
</table>
<table id="table2">
  <tr>
	<td width="15"></td>
	<td width="85"><cf_get_lang_main no='80.Toplam'></td>
	<td width="90"><input name="payment_total_capital_price" id="payment_total_capital_price" value="" class="box" readonly style="width:90px;"></td>
	<td width="90"><input name="payment_total_interest_price" id="payment_total_interest_price" value="" class="box" readonly style="width:90px;"></td>
	<td width="90"><input name="payment_total_tax_price" id="payment_total_tax_price" value="" class="box" readonly style="width:90px;"></td>
	<td width="90"><input name="payment_total_price" id="payment_total_price" value="" class="box" readonly style="width:90px;"></td>
  </tr>	  
</table>
<hr>
<table id="table3">
	<tr>
		<td colspan="9" class="headbold">TAHSİLATLAR</td>
	</tr>	
	<tr class="color-header">
		<td width="15">
		  <input type="hidden" name="revenue_record_num" id="revenue_record_num" value="0">
		  <input type="button" class="eklebuton" title="<cf_get_lang_main no='170.Ekle'>" onClick="add_row(2);">
		</td>
		<td class="form-title" width="90">Tahsilat Tarihi *</td>
		<td class="form-title" width="90"><cf_get_lang no='12.Ana Para'> *</td>
		<td class="form-title" width="90"><cf_get_lang_main no='1089.Vade Farki'></td>
		<td class="form-title" width="90"><cf_get_lang no='14.Vergi/Masraf'></td>
		<td class="form-title" width="90"><cf_get_lang_main no='80.Toplam'></td>
		<td class="form-title" width="60"><cf_get_lang_main no='1651.Döviz Cinsi'></td>
		<td class="form-title" width="150"><cf_get_lang_main no='217.Açıklama'></td>
		<td class="form-title"><cf_get_lang no='21.Ödendi'></td>
	</tr>
	<cfoutput query="get_rows_2">
	  <cfif is_paid eq 0>
	  <tr id="revenue_frm_row#currentrow#">
		<td>
		  <input type="hidden" name="revenue_row_kontrol#currentrow#" id="revenue_row_kontrol#currentrow#" value="1">
		  <a style="cursor:pointer" onclick="delete_row('#currentrow#',2);"><img  src="images/delete_list.gif" alt="<cf_get_lang dictionary_id='57463.sil'>" border="0"></a>
		</td>
		<td>
		  <input type="hidden" name="revenue_credit_contract_row_id#currentrow#" id="revenue_credit_contract_row_id#currentrow#" value="#credit_contract_row_id#">
		  <input type="text" name="revenue_date#currentrow#" id="revenue_date#currentrow#" value="#dateformat(process_date,dateformat_style)#" style="width:75px;">
		  <a href="javascript://" onClick="pencere_ac_date('#currentrow#',2);"><img border="0" src="/images/calendar.gif" alt="Tarih" align="absmiddle"></a>
		</td>
		<td><input type="text" name="revenue_capital_price#currentrow#" id="revenue_capital_price#currentrow#" value="#TlFormat(capital_price,session.ep.our_company_info.rate_round_num)#" onKeyup="return(FormatCurrency(this,event));" onblur="write_total_amount();" class="moneybox" style="width:90px;"></td>
		<td><input type="text" name="revenue_interest_price#currentrow#" id="revenue_interest_price#currentrow#" value="#TlFormat(interest_price,session.ep.our_company_info.rate_round_num)#" onKeyup="return(FormatCurrency(this,event));" onblur="write_total_amount();" class="moneybox" style="width:90px;"></td>
		<td><input type="text" name="revenue_tax_price#currentrow#" id="revenue_tax_price#currentrow#" value="#TlFormat(tax_price,session.ep.our_company_info.rate_round_num)#" onKeyup="return(FormatCurrency(this,event));" onblur="write_total_amount();" class="moneybox" style="width:90px;"></td>
		<td><input type="text" name="revenue_total_price#currentrow#" id="revenue_total_price#currentrow#" value="#TlFormat(total_price,session.ep.our_company_info.rate_round_num)#" onKeyup="return(FormatCurrency(this,event));" class="moneybox" readonly style="width:90px;"></td>
		<td>
		  <cfset money_temp = get_rows_2.other_money>
		  <select name="revenue_money#currentrow#" id="revenue_money#currentrow#" style="width:60px;">
		  <cfloop query="get_money">
			<option value="#money#"<cfif money eq money_temp>selected</cfif>>#money#</option>
		  </cfloop>
		  </select>
		</td>
		<td><input type="text" name="revenue_detail#currentrow#" id="revenue_detail#currentrow#" value="#detail#" maxlength="50" style="width:150px;"></td>
		<td>
		  <input type="checkbox" name="revenue_is_paid#currentrow#" id="revenue_is_paid#currentrow#" value="" <cfif is_paid eq 1>checked</cfif> disabled>
		  <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=credit.popup_add_credit_revenue&credit_contract_row_id=#credit_contract_row_id#','list');"><img src="images/money_plus.gif" alt="" border="0"></a>
		</td>
	  </tr>
	  <cfelse>
		  <tr id="frm_row#currentrow#">
			<td><input type="hidden" name="revenue_row_kontrol#currentrow#" id="revenue_row_kontrol#currentrow#" value="1"></td>
			<td>
			  <input type="hidden" name="revenue_credit_contract_row_id#currentrow#" id="revenue_credit_contract_row_id#currentrow#" value="#credit_contract_row_id#">
			  <input type="text" name="revenue_date#currentrow#" id="revenue_date#currentrow#" value="#dateformat(process_date,dateformat_style)#" readonly style="width:75px;">
			  <a href="javascript://" onClick=""><img border="0" src="/images/calendar.gif" alt="Tarih" align="absmiddle"></a>
			</td>
			<td><input type="text" name="revenue_capital_price#currentrow#" id="revenue_capital_price#currentrow#" value="#TlFormat(capital_price,session.ep.our_company_info.rate_round_num)#" class="moneybox" readonly style="width:90px;"></td>
			<td><input type="text" name="revenue_interest_price#currentrow#" id="revenue_interest_price#currentrow#" value="#TlFormat(interest_price,session.ep.our_company_info.rate_round_num)#" class="moneybox" readonly style="width:90px;"></td>
			<td><input type="text" name="revenue_tax_price#currentrow#" id="revenue_tax_price#currentrow#" value="#TlFormat(tax_price,session.ep.our_company_info.rate_round_num)#" class="moneybox" readonly style="width:90px;"></td>
			<td><input type="text" name="revenue_total_price#currentrow#" id="revenue_total_price#currentrow#" value="#TlFormat(total_price,session.ep.our_company_info.rate_round_num)#" class="moneybox" readonly style="width:90px;"></td>
			<td>
			  <cfset money_temp = get_rows_2.other_money>
			  <select name="revenue_money#currentrow#" id="revenue_money#currentrow#" style="width:60px;">
                  <cfloop query="get_money">
                    <option value="#money#"<cfif money eq money_temp>selected</cfif>>#money#</option>
                  </cfloop>
			  </select>
			</td>
			<td><input type="text" name="revenue_detail#currentrow#" id="revenue_detail#currentrow#" value="#detail#" maxlength="50" readonly style="width:150px;"></td>
			<td>
			  <input type="checkbox" name="revenue_is_paid#currentrow#" id="revenue_is_paid#currentrow#" value="" checked disabled>
			  <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=credit.popup_upd_credit_revenue&credit_contract_row_id=#credit_contract_row_id#&period_id=#period_id#&our_company_id=#our_company_id#','list');"><img src="images/money_plus.gif" alt="" border="0"></a>
			</td>
		  </tr>  
	  </cfif>
	</cfoutput>
</table>
<table id="table4">
  <tr>
	<td width="15"></td>
	<td width="85"><cf_get_lang_main no='80.T O P L A M'></td>
	<td width="90"><input name="revenue_total_capital_price" id="revenue_total_capital_price" value="" class="box" readonly style="width:90px;"></td>
	<td width="90"><input name="revenue_total_interest_price" id="revenue_total_interest_price" value="" class="box" readonly style="width:90px;"></td>
	<td width="90"><input name="revenue_total_tax_price" id="revenue_total_tax_price" value="" class="box" readonly style="width:90px;"></td>
	<td width="90"><input name="revenue_total_price" id="revenue_total_price" value="" class="box" readonly style="width:90px;"></td>
  </tr>	  
</table>
