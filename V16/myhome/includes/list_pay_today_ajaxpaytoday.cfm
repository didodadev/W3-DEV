<cfsetting showdebugoutput="no"> 
<cfinclude template="get_todays_cheques.cfm">
<cf_flat_list>
	<thead>
		<tr>
			<th style="text-align:left;"><cfoutput>#getLang('main',468)#</cfoutput></th>
			<th style="text-align:left;"><cfoutput>#getLang('main',672)#</cfoutput></th>
			<th style="text-align:left;"><cfoutput>#getLang('main',330)#</cfoutput></th>
			<th style="text-align:left;"><cfoutput>#getLang('main',107)#</cfoutput></th>
		</tr>
	</thead>	
	<tbody>
		<cfif get_ches_to_pay.recordcount>
			<cfparam name="attributes.page" default=1>
			<cfparam name="attributes.maxrows" default=20>
			<cfparam name="attributes.totalrecords" default=#get_ches_to_pay.recordcount#>
			<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
			<cfoutput query="get_ches_to_pay">
				<tr>
					<td width="25"><a href="#request.self#?fuseaction=cheque.form_add_payroll_endorsement&event=upd&ID=#action_id#" class="tableyazi">#PAYROLL_NO#</a></td>
					<td width="125"  style="text-align:right;">&nbsp;#TLFormat(CHEQUE_VALUE)# #CURRENCY_ID#</td>
					<td width="30%" align="center">&nbsp;#dateformat(CHEQUE_DUEDATE,dateformat_style)#</td>
					<td><a class="tableyazi" href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_com_det&company_id=#COMPANY_ID#','medium');">#NICKNAME#</a></td>
				</tr>
			</cfoutput>
		<cfelse>
			<tr>
				<td colspan="4"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</td>
			</tr>
		</cfif>
	</tbody>
</cf_flat_list>

