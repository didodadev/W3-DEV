<cfinclude template="../query/get_payment_actions.cfm">
<cfquery name="get_paymethod" datasource="#DSN#">
	SELECT
		SETUP_PAYMETHOD.PAYMETHOD,
		SETUP_PAYMETHOD.PAYMETHOD_ID
	FROM
		SETUP_PAYMETHOD,
		COMPANY_CREDIT
	WHERE
	<cfif isdefined("attributes.member_id") and len(attributes.member_id)>
		COMPANY_CREDIT.COMPANY_ID = #attributes.member_id# AND
	<cfelse>
		COMPANY_CREDIT.CONSUMER_ID = #attributes.consumer_id# AND
	</cfif>
		SETUP_PAYMETHOD.PAYMETHOD_ID = COMPANY_CREDIT.PAYMETHOD_ID AND
		SETUP_PAYMETHOD.PAYMETHOD_STATUS = 1
</cfquery>
<input type="hidden" name="money_type" id="money_type" value="<cfif isdefined("attributes.money_type")><cfoutput>#attributes.money_type#</cfoutput></cfif>">
<input type="hidden" name="all_records" id="all_records" value="<cfoutput>#get_cari_rows.recordcount#</cfoutput>">
<input type="hidden" name="member_id" id="member_id" value="">
<input type="hidden" name="consumer_id" id="consumer_id" value="">
<input type="hidden" name="money_type" id="money_type" value="">
<table cellspacing="1" cellpadding="2" border="0" align="center" width="98%" class="color-border">
	<tr class="color-list" height="20">
		<td class="formbold" height="25" colspan="13"> &raquo; <cf_get_lang_main no='365.İşlemler'></td>
	</tr>
	<cfoutput>
	<tr class="color-header" height="20">
		<td class="form-title" width="20" rowspan="2"></td>
		<td class="form-title" width="60" rowspan="2"><cf_get_lang_main no="468.Belge No"></td>			
		<td class="form-title" width="30%"rowspan="2" nowrap="nowrap"><cf_get_lang_main no="388.İşlem Tipi"></td>
		<td class="form-title" width="60" rowspan="2"><cf_get_lang_main no="467.İşlem Tarihi"></td>
		<td class="form-title" width="40" rowspan="2"><cf_get_lang_main no='228.Vade'></td>
		<td class="form-title" width="60" rowspan="2"><cf_get_lang_main no="469.Vade Tarihi"></td>
		<td class="form-title" width="180" align="center" colspan="2"><cf_get_lang_main no="1511.Belge Tutarı"></td>
		<td class="form-title" width="180" align="center" colspan="2"><cf_get_lang no="65.Kapanmış Tutar"></td>
		<td class="form-title" width="220" align="center" colspan="3"><cfif attributes.act_type eq 1><cf_get_lang no="25.Kapama"><cfelseif attributes.act_type eq 2><cf_get_lang no="17.Talep"><cfelseif attributes.act_type eq 3><cf_get_lang no="24.Emir"></cfif></td>
    </tr>
	<tr class="color-header" height="20">
		<td width="90" align="right" class="form-title" style="text-align:right;">#session.ep.money# <cf_get_lang_main no='261.Tutar'></td>
		<td width="90"  class="form-title" style="text-align:right;"><cf_get_lang no="562.İşlem Tutar"></td>
		<td width="90"  class="form-title" style="text-align:right;">#session.ep.money# <cf_get_lang_main no='261.Tutar'></td>
		<td width="90"  class="form-title" style="text-align:right;"><cf_get_lang no="562.İşlem Tutar"></td>
		<td width="90"  class="form-title" style="text-align:right;">#session.ep.money# <cf_get_lang_main no='261.Tutar'></td>
		<td width="90"  class="form-title" style="text-align:right;"><cf_get_lang no="562.İşlem Tutar"></td>
		<td class="form-title" width="40"></td>
    </tr>
	</cfoutput>
	<cfset checked = 0>
	<cfif get_cari_rows.recordcount>
		<cfoutput query="get_cari_rows">
			<cfif (len(from_cmp_id) and isdefined("attributes.member_id") and len(attributes.member_id) and from_cmp_id eq attributes.member_id) or (len(from_consumer_id) and len(attributes.consumer_id) and from_consumer_id eq attributes.consumer_id)>
				<tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
					<td>
					  <input type="hidden" name="purchase_sales#currentrow#" id="purchase_sales#currentrow#" value="1">
					  <input type="hidden" name="type_#currentrow#" id="type_#currentrow#" value="0">
					  <input type="hidden" name="action_id_#currentrow#" id="action_id_#currentrow#" value="#action_id#">
					  <input type="hidden" name="cari_action_id_#currentrow#" id="cari_action_id_#currentrow#" value="#cari_action_id#">
					  <input type="hidden" name="action_type_id_#currentrow#" id="action_type_id_#currentrow#" value="#action_type_id#">
					  <input type="hidden" name="action_value_#currentrow#" id="action_value_#currentrow#" value="#action_value#">
					  <input type="hidden" name="other_money_#currentrow#" id="other_money_#currentrow#" value="#other_money#">
					  <input type="hidden" name="due_date_#currentrow#" id="due_date_#currentrow#" value="#dateformat(due_date,dateformat_style)#">
					  <input type="hidden" name="action_date_#currentrow#" id="action_date_#currentrow#" value="#dateformat(action_date,dateformat_style)#">
					  <input type="hidden" name="rate2_#currentrow#" id="rate2_#currentrow#" value="<cfif len(other_cash_act_value) and other_cash_act_value gt 0>#wrk_round(CR_ACTION_VALUE/other_cash_act_value,session.ep.our_company_info.rate_round_num)#</cfif>">
					  <input name="is_closed_#currentrow#" id="is_closed_#currentrow#" type="checkbox" value="" onchange="check_kontrol(this);total_amount();" onClick="check_kontrol(this);total_amount();" <cfif isdefined("attributes.row_action_id") and action_id eq attributes.row_action_id and action_type_id eq attributes.row_action_type>checked</cfif>></td>
					  <cfif isdefined("attributes.row_action_id") and action_id eq attributes.row_action_id and action_type_id eq attributes.row_action_type>
						<cfset checked=1>
					  </cfif>
					<td>#paper_no#</td>
					<td>#action_name#</td>
					<td>#dateformat(action_date,dateformat_style)#</td>
					<td align="center"><cfif len(due_date)>#datediff("d",action_date, due_date)#<cfelse>0</cfif></td>
					<td><cfif len(due_date)>#dateformat(due_date,dateformat_style)#<cfelse>&nbsp;</cfif></td>
					<td  style="text-align:right;">#TLFormat(action_value)# #session.ep.money#</td>
					<td  style="text-align:right;"><cfif len(other_cash_act_value)>#TLFormat(other_cash_act_value)# #other_money#</cfif></td>
					<cfif attributes.act_type eq 1>
						<td  style="text-align:right;">
						  <input type="hidden" name="h_closed_amount_#currentrow#" id="h_closed_amount_#currentrow#" value="#total_closed_amount#">#tlformat(total_closed_amount)#&nbsp;#session.ep.money#
						</td>
						<td  style="text-align:right;">#tlformat(other_closed_amount)# #I_OTHER_MONEY# #other_money#</td>
						<td  style="text-align:right;">
						  <input type="hidden" name="h_to_closed_amount_#currentrow#" id="h_to_closed_amount_#currentrow#" value="#tlformat(action_value-total_closed_amount)#">
						  <input type="text" name="to_closed_amount_#currentrow#" id="to_closed_amount_#currentrow#" value="#tlformat(action_value-total_closed_amount)#" onblur="convert_to_other_money(#currentrow#);total_amount();" onkeyup="return(FormatCurrency(this,event));convert_to_system_money(#currentrow#);" class="moneybox" style="width:100px">
						</td>
						<td  style="text-align:right;">		 
						  <input type="text" name="other_closed_amount_#currentrow#" id="other_closed_amount_#currentrow#" value="<cfif len(OTHER_CLOSED_AMOUNT) and len(other_cash_act_value)>#tlformat(other_cash_act_value-OTHER_CLOSED_AMOUNT)#</cfif>" onBlur="convert_to_system_money(#currentrow#);total_amount();" onkeyup="return(FormatCurrency(this,event));convert_to_system_money(#currentrow#);" class="moneybox" style="width:100%">
						</td>
                        <td>#other_money#</td>
					<cfelseif attributes.act_type eq 2>
						<td  style="text-align:right;">
						  <input type="hidden" name="h_closed_amount_#currentrow#" id="h_closed_amount_#currentrow#" value="#total_payment_value#">#tlformat(total_payment_value)# #session.ep.money#
						</td>
						<td  style="text-align:right;">#tlformat(OTHER_PAYMENT_VALUE)# #I_OTHER_MONEY# #other_money#</td>
						<td  style="text-align:right;">
						  <input type="hidden" name="h_to_closed_amount_#currentrow#" id="h_to_closed_amount_#currentrow#" value="#tlformat(action_value-total_payment_value)#">
						  <input type="text" name="to_closed_amount_#currentrow#" id="to_closed_amount_#currentrow#" value="#tlformat(action_value-total_payment_value)#" onblur="convert_to_other_money(#currentrow#);total_amount();" onkeyup="return(FormatCurrency(this,event));convert_to_system_money(#currentrow#);" class="moneybox" style="width:100px">
						</td>
						<td  style="text-align:right;">		 
						  <input type="text" name="other_closed_amount_#currentrow#" id="other_closed_amount_#currentrow#" value="<cfif len(OTHER_PAYMENT_VALUE) and len(other_cash_act_value)>#tlformat(other_cash_act_value-OTHER_PAYMENT_VALUE)#</cfif>" onBlur="convert_to_system_money(#currentrow#);total_amount();" onkeyup="return(FormatCurrency(this,event));convert_to_system_money(#currentrow#);" class="moneybox" style="width:100%">
						</td>
                        <td>#other_money#</td>
					<cfelseif attributes.act_type eq 3>
						<td  style="text-align:right;">
						  <input type="hidden" name="h_closed_amount_#currentrow#" id="h_closed_amount_#currentrow#" value="#total_p_order_value#">#tlformat(total_p_order_value)# #session.ep.money#
						</td>
						<td  style="text-align:right;">#tlformat(OTHER_P_ORDER_VALUE)# #I_OTHER_MONEY# #other_money#</td>
						<td  style="text-align:right;">
						  <input type="hidden" name="h_to_closed_amount_#currentrow#" id="h_to_closed_amount_#currentrow#" value="#tlformat(action_value-total_p_order_value)#">
						  <input type="text" name="to_closed_amount_#currentrow#" id="to_closed_amount_#currentrow#" value="#tlformat(action_value-total_p_order_value)#" onblur="convert_to_other_money(#currentrow#);total_amount();" onkeyup="return(FormatCurrency(this,event));convert_to_system_money(#currentrow#);" class="moneybox" style="width:100px">
						</td>
						<td  style="text-align:right;">		 
						  <input type="text" name="other_closed_amount_#currentrow#" id="other_closed_amount_#currentrow#" value="<cfif len(OTHER_P_ORDER_VALUE) and len(other_cash_act_value)>#tlformat(other_cash_act_value-OTHER_P_ORDER_VALUE)#</cfif>" onBlur="convert_to_system_money(#currentrow#);total_amount();" onkeyup="return(FormatCurrency(this,event));convert_to_system_money(#currentrow#);" class="moneybox" style="width:100%">
						</td>
                        <td>#other_money#</td>
					</cfif>
				</tr>
			<cfelse>
				<tr class="color-row" height="20">
					<td>
						<input type="hidden" name="purchase_sales#currentrow#" id="purchase_sales#currentrow#" value="0">
						<input type="hidden" name="type_#currentrow#" id="type_#currentrow#" value="1">
						<input type="hidden" name="action_id_#currentrow#" id="action_id_#currentrow#" value="#action_id#">
						<input type="hidden" name="cari_action_id_#currentrow#" id="cari_action_id_#currentrow#" value="#cari_action_id#">
						<input type="hidden" name="action_type_id_#currentrow#" id="action_type_id_#currentrow#" value="#action_type_id#">
						<input type="hidden" name="action_value_#currentrow#" id="action_value_#currentrow#" value="#action_value#">
						<input type="hidden" name="other_money_#currentrow#" id="other_money_#currentrow#" value="#other_money#">
						<input type="hidden" name="action_date_#currentrow#" id="action_date_#currentrow#" value="#dateformat(action_date,dateformat_style)#">
						<input type="hidden" name="due_date_#currentrow#" id="due_date_#currentrow#" value="#dateformat(due_date,dateformat_style)#">
						<input type="hidden" name="rate2_#currentrow#" id="rate2_#currentrow#" value="<cfif len(other_cash_act_value) and other_cash_act_value gt 0>#wrk_round(CR_ACTION_VALUE/other_cash_act_value,session.ep.our_company_info.rate_round_num)#</cfif>">
						<input name="is_closed_#currentrow#" id="is_closed_#currentrow#" type="checkbox" value="" onchange="check_kontrol(this);total_amount();" onClick="check_kontrol(this);total_amount();" <cfif isdefined("attributes.row_action_id") and action_id eq attributes.row_action_id and action_type_id eq attributes.row_action_type>checked</cfif>>
					 </td>
					<cfif isdefined("attributes.row_action_id") and action_id eq attributes.row_action_id and action_type_id eq attributes.row_action_type>
						<cfset checked=1>
					</cfif>
					<td><font color="red">#paper_no#</font></td>
					<td><font color="red">#action_name#</font></td>
					<td><font color="red">#dateformat(action_date,dateformat_style)#</font></td>
					<td align="center"><font color="red"><cfif len(due_date)>#datediff("d",action_date, due_date)#<cfelse>0</cfif></font></td>
					<td><font color="red"><cfif len(due_date)>#dateformat(due_date,dateformat_style)#<cfelse>&nbsp;</cfif></font></td>				
					<td  style="text-align:right;"><font color="red">#TLFormat(action_value)# #session.ep.money#</font></td>
					<td  style="text-align:right;"><font color="red"><cfif len(other_cash_act_value)>#TLFormat(other_cash_act_value)# #other_money#</font></cfif></td>
					<cfif attributes.act_type eq 1>
						<td  style="text-align:right;">
							<input type="hidden" name="h_closed_amount_#currentrow#" id="h_closed_amount_#currentrow#" value="#total_closed_amount#"><font color="red">#tlformat(total_closed_amount)#&nbsp;#session.ep.money#</font>
						</td>
						<td  style="text-align:right;"><font color="red">#tlformat(other_closed_amount)# #I_OTHER_MONEY# #other_money#</font></td>
						<td  style="text-align:right;">
							<input type="hidden" name="h_to_closed_amount_#currentrow#" id="h_to_closed_amount_#currentrow#" value="#wrk_round(action_value-total_closed_amount)#">
							<input type="text" name="to_closed_amount_#currentrow#" id="to_closed_amount_#currentrow#" value="#tlformat(action_value-total_closed_amount)#" onblur="convert_to_other_money(#currentrow#);total_amount();" onkeyup="return(FormatCurrency(this,event));convert_to_system_money(#currentrow#);" class="moneybox" style="width:100px">
						</td>
						<td  style="text-align:right;">			 
							<input type="text" name="other_closed_amount_#currentrow#" id="other_closed_amount_#currentrow#" value="<cfif len(OTHER_CLOSED_AMOUNT) and len(other_cash_act_value)>#tlformat(other_cash_act_value-OTHER_CLOSED_AMOUNT)#</cfif>" onBlur="convert_to_system_money(#currentrow#);total_amount();" onkeyup="return(FormatCurrency(this,event));convert_to_system_money(#currentrow#);" class="moneybox" style="width:100%">
						</td>
                        <td>#other_money#</td>
					<cfelseif attributes.act_type eq 2>
						<td  style="text-align:right;">
							<input type="hidden" name="h_closed_amount_#currentrow#" id="h_closed_amount_#currentrow#" value="#total_payment_value#"><font color="red">#tlformat(total_payment_value)# #session.ep.money#</font>
						</td>
						<td  style="text-align:right;"><font color="red">#tlformat(OTHER_PAYMENT_VALUE)# #I_OTHER_MONEY# #other_money#</font></td>
						<td  style="text-align:right;">
							<input type="hidden" name="h_to_closed_amount_#currentrow#" id="h_to_closed_amount_#currentrow#" value="#wrk_round(action_value-total_payment_value)#">
							<input type="text" name="to_closed_amount_#currentrow#" id="to_closed_amount_#currentrow#" value="#tlformat(action_value-total_payment_value)#" onblur="convert_to_other_money(#currentrow#);total_amount();" onkeyup="return(FormatCurrency(this,event));convert_to_system_money(#currentrow#);" class="moneybox" style="width:100px">
						</td>
						<td  style="text-align:right;">			 
							<input type="text" name="other_closed_amount_#currentrow#" id="other_closed_amount_#currentrow#" value="<cfif len(OTHER_PAYMENT_VALUE) and len(other_cash_act_value)>#tlformat(other_cash_act_value-OTHER_PAYMENT_VALUE)#</cfif>" onBlur="convert_to_system_money(#currentrow#);total_amount();" onkeyup="return(FormatCurrency(this,event));convert_to_system_money(#currentrow#);" class="moneybox" style="width:100%">
						</td>
                        <td>#other_money#</td>
					<cfelseif attributes.act_type eq 3>
						<td  style="text-align:right;">
							<input type="hidden" name="h_closed_amount_#currentrow#" id="h_closed_amount_#currentrow#" value="#total_p_order_value#"><font color="red">#tlformat(total_p_order_value)# #session.ep.money#</font>
						</td>
						<td  style="text-align:right;"><font color="red">#tlformat(OTHER_P_ORDER_VALUE)# #I_OTHER_MONEY# #other_money#</font></td>
						<td  style="text-align:right;">
							<input type="hidden" name="h_to_closed_amount_#currentrow#" id="h_to_closed_amount_#currentrow#" value="#wrk_round(action_value-total_p_order_value)#">
							<input type="text" name="to_closed_amount_#currentrow#" id="to_closed_amount_#currentrow#" value="#tlformat(action_value-total_p_order_value)#" onblur="convert_to_other_money(#currentrow#);total_amount();" onkeyup="return(FormatCurrency(this,event));convert_to_system_money(#currentrow#);" class="moneybox" style="width:100px">
						</td>
						<td  style="text-align:right;">			 
							<input type="text" name="other_closed_amount_#currentrow#" id="other_closed_amount_#currentrow#" value="<cfif len(OTHER_P_ORDER_VALUE) and len(other_cash_act_value)>#tlformat(other_cash_act_value-OTHER_P_ORDER_VALUE)#</cfif>" onBlur="convert_to_system_money(#currentrow#);total_amount();" onkeyup="return(FormatCurrency(this,event));convert_to_system_money(#currentrow#);" class="moneybox" style="width:100px">
						</td>
                        <td>#other_money#</td>
					</cfif>
				</tr>
			</cfif>
		</cfoutput>
	<cfelse>
		<tr class="color-row">
			<td colspan="12" class="rowbold"><cf_get_lang_main no='72.Kayıt Bulunamadı'></td>
		</tr>		 
	</cfif>
</table>
<cfif checked eq 1>
	<input type="hidden" name="total_record" id="total_record" value="1">
<cfelse>
	<input type="hidden" name="total_record" id="total_record" value="0">
</cfif><br/>
<table cellspacing="1" cellpadding="2" border="0" align="center" width="98%" class="color-border">
	<tr class="color-row">
		<td>
			<table>
				<tr>
                	<td class="txtbold"><cfif attributes.act_type eq 1><cf_get_lang no="25.Kapama"><cfelseif attributes.act_type eq 2><cf_get_lang no="17.Talep"><cfelseif attributes.act_type eq 3><cf_get_lang no="24.Emir"></cfif></td>
                </tr>
                <tr>
					<td width="80"><cf_get_lang no="69.Borç Toplamı"></td>
					<td width="150"><input type="text" name="total_debt_amount" id="total_debt_amount" value="" class="moneybox" readonly style="width:100px;"> <cfif isdefined("attributes.money_type") and len(attributes.money_type)> <cfoutput>#attributes.money_type#</cfoutput><cfelse><cfoutput>#session.ep.money#</cfoutput></cfif></td>
					<td width="80"><cfif attributes.act_type eq 1><cf_get_lang no="25.Kapama"><cfelseif attributes.act_type eq 2><cf_get_lang no="17.Talep"><cfelseif attributes.act_type eq 3><cf_get_lang no="24.Emir"></cfif> <cf_get_lang_main no="330.Tarih"></td>
                    <td width="160"><cfsavecontent variable="message"><cf_get_lang_main no='1091.Lutfen Tarih Giriniz'></cfsavecontent>
                    <cfinput type="text" name="payment_date" style="width:70px;" required="Yes" message="#message#" value="#dateformat(now(),dateformat_style)#" validate="#validate_style#" maxlength="10">
                    <cf_wrk_date_image date_field="payment_date"></td>
					<td width="80"><cf_get_lang_main no='1447.Süreç'>*</td>
					<td width="180"><cf_workcube_process is_upd='0' process_cat_width='180' is_detail='0'></td>
                </tr>
                <tr>
                    <td><cf_get_lang no="70.Alacak Toplamı"></td>
					<td><input type="text" name="total_claim_amount" id="total_claim_amount" value="" class="moneybox" readonly style="width:100px;"> <cfif isdefined("attributes.money_type") and len(attributes.money_type)> <cfoutput>#attributes.money_type#</cfoutput> <cfelse><cfoutput>#session.ep.money#</cfoutput></cfif></td>
					<td><cf_get_lang_main no="449.Ortalama Vade"></td>
					<td><cfsavecontent variable="message"><cf_get_lang no="68.Vade Tarihi Girmelisiniz"></cfsavecontent>
						<cfinput type="text" name="due_date" style="width:70px;" required="Yes" message="#message#" value="#dateformat(now(),dateformat_style)#" validate="#validate_style#" maxlength="10">
						<cf_wrk_date_image date_field="due_date">
					</td>
					<td><cf_get_lang_main no="217.Açıklama"></td>
					<td rowspan="2"><textarea name="action_detail" id="action_detail" style="width:180px;height:50px;"></textarea></td>
                </tr>
                <tr>
                    <td><cfif attributes.act_type eq 1><cf_get_lang no="25.Kapama"><cfelseif attributes.act_type eq 2><cf_get_lang no="17.Talep"><cfelseif attributes.act_type eq 3><cf_get_lang no="24.Emir"></cfif> <cf_get_lang no="66.Tutarı"></td>
					<td><input type="text" name="total_difference_amount" id="total_difference_amount" value="" class="moneybox" readonly style="width:100px;"> <cfif isdefined("attributes.money_type") and len(attributes.money_type)> <cfoutput>#attributes.money_type#</cfoutput> <cfelse><cfoutput>#session.ep.money#</cfoutput></cfif></td>
					<td><cf_get_lang_main no="1104.Ödeme Yöntemi"></td>
					<td>
						<input type="hidden" name="paymethod_id" id="paymethod_id" value="<cfif get_paymethod.recordcount><cfoutput>#get_paymethod.paymethod_id#</cfoutput></cfif>">
						<input type="text" name="paymethod" id="paymethod" style="width:140px;" value="<cfif get_paymethod.recordcount><cfoutput>#get_paymethod.paymethod#</cfoutput></cfif>"> 
						<a href="javascript://" onClick="open_pay_window();"><img src="/images/plus_thin.gif" alt="<cf_get_lang no='83.seçiniz'>" title="<cf_get_lang no='83.seçiniz'>" border="0" align="absmiddle"></a> 
					</td>
                </tr>
                <tr>
					<td height="30" colspan="6"  style="text-align:right;">
						<cfif attributes.act_type eq 1><cf_workcube_buttons is_upd='0' is_cancel='0' insert_info='Kapama İşlemi' add_function='kontrol2(1)'></cfif>
						<cfif attributes.act_type eq 2><cf_workcube_buttons is_upd='0' is_cancel='0' insert_info='Talep Oluştur' add_function='kontrol2(2)'></cfif>
						<cfif attributes.act_type eq 3><cf_workcube_buttons is_upd='0' is_cancel='0' insert_info='Ödeme Emri Ver' add_function='kontrol2(3)'></cfif>
					</td>
                </tr>		  
			</table>
		</td>
	</tr>
</table><br/>
<iframe id="tarihsel" name="tarihsel" width="0" height="0" frameborder="0" scrolling="no" src=""></iframe>
<script type="text/javascript">
	function open_pay_window()
	{
		windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_paymethods&field_id=add_payment_actions2.paymethod_id&field_name=add_payment_actions2.paymethod</cfoutput>&paymentdate_value=' + add_payment_actions2.payment_date.value ,'list');
	}
	var control_closed=document.all.control_closed;
	function kontrol2(type_info)
	{
		if(type_info == 1)
		{
			if(control_closed < 2)
			{
				alert("<cf_get_lang dictionary_id='54438.Fatura Kapama İçin En Az İki İşlem Seçmelisiniz'>");
				return false;
			}
			total_difference_amount_ = filterNum(add_payment_actions2.total_difference_amount.value);
			if(total_difference_amount_ != 0)
			{
				alert("<cf_get_lang dictionary_id='54436.Borç ve Alacak Toplamları Eşit Olmalı'>");
				return false;
			}
		}
		total_amount();
		for (var i=1; i <= <cfoutput>#get_cari_rows.recordcount#</cfoutput>; i++)
		{
			if(eval('add_payment_actions2.is_closed_'+i).checked)	
			{
				if(parseFloat(filterNum(eval('add_payment_actions2.to_closed_amount_'+i).value))>parseFloat(filterNum(eval('add_payment_actions2.h_to_closed_amount_'+i).value)))
				{
					alert("<cf_get_lang dictionary_id='50098.Kapanacak Tutar Değerini Kontrol Ediniz'>");
					eval('add_payment_actions2.to_closed_amount_'+i).focus();
					return false;
				}
			}
		}
		for (var i=1; i <= <cfoutput>#get_cari_rows.recordcount#</cfoutput>; i++)
		{
			if(eval('add_payment_actions2.is_closed_'+i).checked)
			{
				eval("add_payment_actions2.to_closed_amount_" + i).value = filterNum(eval("add_payment_actions2.to_closed_amount_" + i).value);
				eval("add_payment_actions2.other_closed_amount_" + i).value = filterNum(eval("add_payment_actions2.other_closed_amount_" + i).value);
			}
		}
		document.add_payment_actions2.total_debt_amount.value = filterNum(document.add_payment_actions2.total_debt_amount.value);
		document.add_payment_actions2.total_claim_amount.value = filterNum(document.add_payment_actions2.total_claim_amount.value);
		document.add_payment_actions2.total_difference_amount.value = filterNum(document.add_payment_actions2.total_difference_amount.value);
		document.add_payment_actions2.member_id.value = document.add_payment_actions.member_id.value;
		document.add_payment_actions2.consumer_id.value = document.add_payment_actions.consumer_id.value;
		document.add_payment_actions2.money_type.value = document.add_payment_actions.money_type.value;
		document.add_payment_actions2.action = '<cfoutput>#request.self#</cfoutput>?fuseaction=finance.emptypopup_add_payment_actions&act_type='+type_info;
		return process_cat_control();
	}
	function check_kontrol(nesne)
	{
		if(nesne.checked)
			control_closed++;
		else
			control_closed--;
	}
	function total_amount()
	{
		var order_total = 0;
		var due_datelist = '';
		var action_datelist = '';
		var value_list ='';
		var total_debt_amount = 0;
		var total_claim_amount = 0;
		for (var i=1; i <= <cfoutput>#get_cari_rows.recordcount#</cfoutput>; i++)
		{		
			if(eval('add_payment_actions2.is_closed_'+i).checked)	
			{
				if(eval('add_payment_actions2.type_'+i).value == 1)
					total_debt_amount += filterNum(eval('add_payment_actions2.other_closed_amount_'+i).value);
				else
					total_claim_amount += filterNum(eval('add_payment_actions2.other_closed_amount_'+i).value);
				
				bool_alis=eval("document.add_payment_actions2.purchase_sales" + i);
				if(bool_alis.value == 0 || (bool_alis.value == 1 && eval("document.add_payment_actions2.due_date_" + i+".value") != eval("document.add_payment_actions2.action_date_" + i+".value")))
				{
					due_datelist+=","+eval("document.add_payment_actions2.due_date_" + i+".value");
					action_datelist+=","+eval("document.add_payment_actions2.action_date_" + i+".value");
					value_list+=","+filterNum(eval("document.add_payment_actions2.to_closed_amount_" + i+".value"));
				}
				if(bool_alis.value == 0)
				{
					order_total += (parseFloat(eval("document.add_payment_actions2.to_closed_amount_" + i+".value")));
				}
				else
				{
					order_total -= (parseFloat(eval("document.add_payment_actions2.to_closed_amount_" + i+".value")));
				}
			}
		}
		document.create_ave_date.my_due_dates.value = due_datelist;
		document.create_ave_date.my_action_dates.value = action_datelist;
		document.create_ave_date.my_values.value = value_list;
		document.create_ave_date.target="<cf_get_lang dictionary_id='51418.Tarihsel'>";
		document.create_ave_date.submit();
		if(document.add_payment_actions2.total_debt_amount != undefined)
		{
			document.add_payment_actions2.total_debt_amount.value = commaSplit(total_debt_amount);
			document.add_payment_actions2.total_claim_amount.value = commaSplit(total_claim_amount);
			document.add_payment_actions2.total_difference_amount.value = commaSplit(total_debt_amount-total_claim_amount);
		}
	}
	function convert_to_other_money(i)
	{	
		if(eval('add_payment_actions2.is_closed_'+i).checked)	
		{
			rate2_eleman = eval('add_payment_actions2.rate2_'+i).value;
			eval('add_payment_actions2.other_closed_amount_'+i).value= commaSplit(filterNum(eval('add_payment_actions2.to_closed_amount_'+i).value)/rate2_eleman);
		}
	}
	function convert_to_system_money(i)
	{	
		if(eval('add_payment_actions2.is_closed_'+i).checked)	
		{
			rate2_eleman = eval('add_payment_actions2.rate2_'+i).value;
			eval('add_payment_actions2.to_closed_amount_'+i).value= commaSplit(filterNum(eval('add_payment_actions2.other_closed_amount_'+i).value)*rate2_eleman);
		}
	}
</script>
