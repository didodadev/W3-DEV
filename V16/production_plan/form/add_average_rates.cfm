<cfquery name="GET_RATES" datasource="#DSN3#">
	SELECT * FROM ASSEMPTION_AVERAGE_RATES
</cfquery>
<cfoutput query="get_rates">
	<cfset "rate_#method_id#_#month_value#" = average_rate>
</cfoutput>
<cfsavecontent variable="title"><cf_get_lang dictionary_id='36587.Ağırlıklı Ortalama Katsayıları'></cfsavecontent>
<cf_box title="#title#">
    <cfform name="add_average_rates" method="post" action="#request.self#?fuseaction=prod.emptypopup_add_average_rates"> 
		<cf_box_elements>
		<cf_flat_list>
				<thead>
					<tr>
						<th class="text-center"><cf_get_lang dictionary_id='58672.Aylar'></th>
						<th class="text-center"><cf_get_lang dictionary_id='29784.Ağırlık'> 1</th>
						<th class="text-center"><cf_get_lang dictionary_id='29784.Ağırlık'> 2</th>
						<th class="text-center"><cf_get_lang dictionary_id='29784.Ağırlık'> 3</th>
						<th class="text-center"><cf_get_lang dictionary_id='29784.Ağırlık'> 4</th>
						<th class="text-center"><cf_get_lang dictionary_id='29784.Ağırlık'> 5</th>
						<th class="text-center"><cf_get_lang dictionary_id='29784.Ağırlık'> 6</th>
					</tr>
				</thead>
					<tbody>
					<cfoutput>
						<tr>
							<td >3 <cf_get_lang dictionary_id='58724.Ay'></td>
							<td class="text-right"><div class="form-group"><input name="value_5_1" id="value_5_1" type="text"  class="moneybox" <cfif isdefined("rate_5_1")>value="#tlformat(rate_5_1,2)#"<cfelse>value="#tlformat(0,2)#"</cfif> onkeyup="return(FormatCurrency(this,event,2));"></div></td>
							<td class="text-right"><div class="form-group"><input name="value_5_2" id="value_5_2" type="text"  class="moneybox" <cfif isdefined("rate_5_2")>value="#tlformat(rate_5_2,2)#"<cfelse>value="#tlformat(0,2)#"</cfif> onkeyup="return(FormatCurrency(this,event,2));"></div></td>
							<td class="text-right"><div class="form-group"><input name="value_5_3" id="value_5_3" type="text"  class="moneybox" <cfif isdefined("rate_5_3")>value="#tlformat(rate_5_3,2)#"<cfelse>value="#tlformat(0,2)#"</cfif> onkeyup="return(FormatCurrency(this,event,2));"></div></td>
							<td class="text-right"></td>
							<td class="text-right"></td>
							<td class="text-right"></td>
						</tr>
						<tr>
							<td >4 <cf_get_lang dictionary_id='58724.Ay'></td>
							<td class="text-right"><div class="form-group"><input name="value_6_1" id="value_6_1" type="text"  class="moneybox" <cfif isdefined("rate_6_1")>value="#tlformat(rate_6_1,2)#"<cfelse>value="#tlformat(0,2)#"</cfif> onkeyup="return(FormatCurrency(this,event,2));"></div></td>
							<td class="text-right"><div class="form-group"><input name="value_6_2" id="value_6_2" type="text"  class="moneybox" <cfif isdefined("rate_6_2")>value="#tlformat(rate_6_2,2)#"<cfelse>value="#tlformat(0,2)#"</cfif> onkeyup="return(FormatCurrency(this,event,2));"></div></td>
							<td class="text-right"><div class="form-group"><input name="value_6_3" id="value_6_3" type="text"  class="moneybox" <cfif isdefined("rate_6_3")>value="#tlformat(rate_6_3,2)#"<cfelse>value="#tlformat(0,2)#"</cfif> onkeyup="return(FormatCurrency(this,event,2));"></div></td>
							<td class="text-right"><div class="form-group"><input name="value_6_4" id="value_6_4" type="text"  class="moneybox" <cfif isdefined("rate_6_4")>value="#tlformat(rate_6_4,2)#"<cfelse>value="#tlformat(0,2)#"</cfif> onkeyup="return(FormatCurrency(this,event,2));"></div></td>
							<td class="text-right"></td>
							<td class="text-right"></td>
						</tr>
						<tr>
							<td >5 <cf_get_lang dictionary_id='58724.Ay'></td>
							<td class="text-right"><div class="form-group"><input name="value_7_1" id="value_7_1" type="text"  class="moneybox" <cfif isdefined("rate_7_1")>value="#tlformat(rate_7_1,2)#"<cfelse>value="#tlformat(0,2)#"</cfif> onkeyup="return(FormatCurrency(this,event,2));"></div></td>
							<td class="text-right"><div class="form-group"><input name="value_7_2" id="value_7_2" type="text"  class="moneybox" <cfif isdefined("rate_7_2")>value="#tlformat(rate_7_2,2)#"<cfelse>value="#tlformat(0,2)#"</cfif> onkeyup="return(FormatCurrency(this,event,2));"></div></td>
							<td class="text-right"><div class="form-group"><input name="value_7_3" id="value_7_3" type="text"  class="moneybox" <cfif isdefined("rate_7_3")>value="#tlformat(rate_7_3,2)#"<cfelse>value="#tlformat(0,2)#"</cfif> onkeyup="return(FormatCurrency(this,event,2));"></div></td>
							<td class="text-right"><div class="form-group"><input name="value_7_4" id="value_7_4" type="text"  class="moneybox" <cfif isdefined("rate_7_4")>value="#tlformat(rate_7_4,2)#"<cfelse>value="#tlformat(0,2)#"</cfif> onkeyup="return(FormatCurrency(this,event,2));"></div></td>
							<td class="text-right"><div class="form-group"><input name="value_7_5" id="value_7_5" type="text"  class="moneybox" <cfif isdefined("rate_7_5")>value="#tlformat(rate_7_5,2)#"<cfelse>value="#tlformat(0,2)#"</cfif> onkeyup="return(FormatCurrency(this,event,2));"></div></td>
							<td class="text-right"></td>
						</tr>
						<tr>
							<td >6 <cf_get_lang dictionary_id='58724.Ay'></td>
							<td class="text-right"><div class="form-group"><input name="value_8_1" id="value_8_1" type="text"  class="moneybox" <cfif isdefined("rate_8_1")>value="#tlformat(rate_8_1,2)#"<cfelse>value="#tlformat(0,2)#"</cfif> onkeyup="return(FormatCurrency(this,event,2));"></div></td>
							<td class="text-right"><div class="form-group"><input name="value_8_2" id="value_8_2" type="text"  class="moneybox" <cfif isdefined("rate_8_2")>value="#tlformat(rate_8_2,2)#"<cfelse>value="#tlformat(0,2)#"</cfif> onkeyup="return(FormatCurrency(this,event,2));"></div></td>
							<td class="text-right"><div class="form-group"><input name="value_8_3" id="value_8_3" type="text"  class="moneybox" <cfif isdefined("rate_8_3")>value="#tlformat(rate_8_3,2)#"<cfelse>value="#tlformat(0,2)#"</cfif> onkeyup="return(FormatCurrency(this,event,2));"></div></td>
							<td class="text-right"><div class="form-group"><input name="value_8_4" id="value_8_4" type="text"  class="moneybox" <cfif isdefined("rate_8_4")>value="#tlformat(rate_8_4,2)#"<cfelse>value="#tlformat(0,2)#"</cfif> onkeyup="return(FormatCurrency(this,event,2));"></div></td>
							<td class="text-right"><div class="form-group"><input name="value_8_5" id="value_8_5" type="text"  class="moneybox" <cfif isdefined("rate_8_5")>value="#tlformat(rate_8_5,2)#"<cfelse>value="#tlformat(0,2)#"</cfif> onkeyup="return(FormatCurrency(this,event,2));"></div></td>
							<td class="text-right"><div class="form-group"><input name="value_8_6" id="value_8_6" type="text"  class="moneybox" <cfif isdefined("rate_8_6")>value="#tlformat(rate_8_6,2)#"<cfelse>value="#tlformat(0,2)#"</cfif> onkeyup="return(FormatCurrency(this,event,2));"></div></td>
						</tr>
					</cfoutput>
				</tbody>
			</cf_flat_list>
		</cf_box_elements>
        <cf_box_footer>
			<cf_record_info query_name="get_rates">
			<cf_workcube_buttons is_upd='0'>
		</cf_box_footer>
    </cfform>
</cf_box>
