<cfif isdefined('attributes.virtual_offer_id') or isdefined('attributes.upd_id')>
	<cfset grosstotal = get_virtual_offer.GROSSTOTAL>
    <cfset nettotal = get_virtual_offer.NETTOTAL>
    <cfset discounttotal = get_virtual_offer.DISCOUNTTOTAL>
    <cfset sub_discounttotal = get_virtual_offer.SUB_DISCOUNTTOTAL>
    <cfset tax = get_virtual_offer.TAX>
<cfelse>
	<cfset grosstotal = 0>
    <cfset nettotal = 0>
    <cfset discounttotal = 0>
    <cfset sub_discounttotal = 0>
    <cfset tax = 0>
</cfif>
<table cellspacing="0" cellpadding="0" border="0" width="99%"> 
  	<tr class="color-border">
    	<td style="text-align:left; width:15%;">
        	<table cellspacing="1" cellpadding="1" border="0" style="height:100%; width:100%">
                <tr class="color-list">
                	<td class="txtbold" style="text-align:center; height:25px" colspan="2">Döviz</td>
                </tr>
                <cfif isdefined('attributes.virtual_offer_id')>
                	<cfinput type="hidden" name="money_recordcount" value="#get_money.recordcount#">
                    <cfoutput query="get_virtual_offer_money">
                        <tr class="color-list">
                            <td style="width:30%"><input type="radio" name="basket" value="#money_type#" onchange="doviz_change(#currentrow#)" <cfif IS_SELECTED>checked</cfif>> #money_type#</td>
                            <td style="text-align:right; width:70%; height:20px">
                                <input type="text" name="money_#currentrow#" id="money_#currentrow#" value="#TlFormat(rate2,4)#" onchange="doviz_change(#currentrow#)" class="box" <cfif session.ep.money eq money_type>readonly="readonly"</cfif>/>
                                <input type="hidden" name="money_type_#currentrow#" id="money_type_#currentrow#" value="#money_type#"  />
                            </td>
                        </tr>
                    </cfoutput>
                <cfelse>
                    <cfinput type="hidden" name="money_recordcount" value="#get_money.recordcount#">
                    <cfoutput query="get_money">
                        <tr class="color-list">
                            <td style="width:30%"><input type="radio" name="basket" value="#money#" onchange="doviz_change(#currentrow#)" <cfif session.ep.money eq money>checked</cfif>> #money#</td>
                            <td style="text-align:right; width:70%; height:20px">
                                <input type="text" name="money_#currentrow#" id="money_#currentrow#" value="#TlFormat(rate2,4)#" onchange="doviz_change(#currentrow#)" class="box" <cfif session.ep.money eq money>readonly="readonly"</cfif>/>
                                <input type="hidden" name="money_type_#currentrow#" id="money_type_#currentrow#" value="#money#"  />
                            </td>
                        </tr>
                    </cfoutput>
                </cfif>
            </table>
        </td>
		<td style="text-align:right" width="85%" height="100%"> 
			<table cellspacing="1" cellpadding="1" border="0" width="100%" height="100%">
				<cfoutput>
				<tr height="20" class="color-list">
					<td class="txtbold" rowspan="6" valign="top" height="100%">
						<table style="height:100%; width:100%" cellpadding="0" cellspacing="0">
							<tr><td style="height:100%; width:100%"></td></tr>
						</table>
					</td>
					<td width="205" class="txtbold" style="text-align:right; height:25px"><cf_get_lang_main no='80.Toplam'>&nbsp;</td>
                    <td style="text-align:right; width:75px" name="total_default">
                    	<input type="text" name="sub_total_brut_other" id="sub_total_brut_other" style="width:75px;text-align:right; font-weight:bold" class="boxtext" value="#TlFormat(GROSSTOTAL,2)#" readonly>
                        <input type="hidden" name="sub_total_net_other" id="sub_total_net_other" value="#TlFormat(GROSSTOTAL-DISCOUNTTOTAL,2)#">
                    </td>
					<td style="text-align:right; width:75px" name="total_default">
                    	<input type="text" name="sub_total_brut" id="sub_total_brut" style="width:75px;text-align:right; font-weight:bold" class="boxtext" value="#TlFormat(GROSSTOTAL,2)#" readonly>
                        <input type="hidden" name="sub_total_net" id="sub_total_net" value="#TlFormat(GROSSTOTAL-DISCOUNTTOTAL,2)#">
                    </td>
				</tr>	
                <tr class="color-list">
                    <td class="txtbold" style="text-align:right;height:25px"><cf_get_lang_main no='237.Toplam İndirim'>&nbsp;</td>
                    <td class="txtbold" style="text-align:right;" name="total_discount_default">
                    	<input type="text" name="sub_total_discount_other" id="sub_total_discount_other" style="width:75px;text-align:right; font-weight:bold" class="boxtext" value="#TlFormat(DISCOUNTTOTAL,2)#" readonly>
                    </td>
                    <td class="txtbold" style="text-align:right;" name="total_discount_default">
                    	<input type="text" name="sub_total_discount" id="sub_total_discount" style="width:75px;text-align:right; font-weight:bold" class="boxtext" value="#TlFormat(DISCOUNTTOTAL,2)#" readonly>
                    </td>
                </tr>
                <tr height="20" class="color-list">
                    <td class="txtbold" style="text-align:right;"><cf_get_lang_main no='227.KDV'>&nbsp;</td>
                    <td class="txtbold" style="text-align:right;" name="total_discount_default">
                    	<input type="text" name="sub_total_tax_other" id="sub_total_tax_other" style="width:75px;text-align:right; font-weight:bold" class="boxtext" value="#TlFormat(TAX,2)#" readonly>
                    </td>
                    <td class="txtbold" style="text-align:right;" name="total_discount_default">
                    	<input type="text" name="sub_total_tax" id="sub_total_tax" style="width:75px;text-align:right; font-weight:bold" class="boxtext" value="#TlFormat(TAX,2)#" readonly>
                    </td>
                </tr>
                <tr class="color-list">
                    <td class="txtbold" style="text-align:right;height:25px"><cf_get_lang_main no='266.Fatura Altı İndirim'>&nbsp;</td>
                    <td class="txtbold" style="text-align:right;" name="total_tax_default">
                    	<input type="text" name="sub_total_discount_ext_other" id="sub_total_discount_ext_other" style="width:75px;text-align:right; font-weight:bold" class="boxtext" onChange="sub_total();" value="#TlFormat(SUB_DISCOUNTTOTAL,2)#">
                    </td>
                    <td class="txtbold" style="text-align:right;" name="total_tax_default">
                    	<input type="text" name="sub_total_discount_ext" id="sub_total_discount_ext" style="width:75px;text-align:right; font-weight:bold" class="boxtext" onChange="sub_total();" value="#TlFormat(SUB_DISCOUNTTOTAL,2)#">
                    </td>
                </tr>
                <tr class="color-list">
                    <td class="txtbold" style="text-align:right;height:25px">Genel Toplam&nbsp;</td>
                    <td class="txtbold" style="text-align:right;" name="net_total_default">
                    	<input type="text" name="sub_total_end_other" id="sub_total_end_other" style="width:75px;text-align:right; font-weight:bold" class="boxtext" value="#TlFormat(NETTOTAL,2)#" readonly>
                    </td>
                    <td class="txtbold" style="text-align:right;" name="net_total_default">
                    	<input type="text" name="sub_total_end" id="sub_total_end" style="width:75px;text-align:right; font-weight:bold" class="boxtext" value="#TlFormat(NETTOTAL,2)#" readonly>
                    </td>
                </tr>

				</cfoutput>
			</table>
		</td>
	</tr>
</table>
<script type="text/javascript">
	sub_total();
	function doviz_change(currentrow)
	{
		document.getElementById('virtual_offer_money').value = document.getElementById('money_type_'+currentrow).value;
		document.getElementById('virtual_offer_rate2').value = document.getElementById('money_'+currentrow).value;
		for (var ra=1;ra<=document.form_basket.record_num.value;ra++)
		{
			if(document.getElementById('money'+ra).value == document.getElementById('money_type_'+currentrow).value)
			{
				document.getElementById('row_rate2_'+ra).value = document.getElementById('virtual_offer_rate2').value;
			}
		 	hesapla(ra);
		}
		sub_total();
	}
</script>
