<cfsetting showdebugoutput="no">
<cfset day_1 = date_add('d',30,now())>
<cfset day_2 = date_add('d', -30,now())>
<cfquery name="get_old_contracts" datasource="#dsn3#">
	SELECT CONTRACT_ID,CONTRACT_HEAD,FINISHDATE FROM RELATED_CONTRACT WHERE OUR_COMPANY_ID = #SESSION.EP.COMPANY_ID# AND (FINISHDATE >= #day_2# AND FINISHDATE <= #day_1#) ORDER BY	RECORD_DATE DESC
</cfquery>
<cf_flat_list>
	<cfif get_old_contracts.recordcount>
		<thead>
			<tr>
				<th><cf_get_lang_main no="68.konu"></th>
				<th><cf_get_lang_main no="330.tarih"></th>
			</tr>
		</thead>
		<tbody>
		<cfoutput query="get_old_contracts">
			<tr>
				<td width="632"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=contract.popup_dsp_member_contracts&contract_id=#contract_id#','wide2');" class="tableyazi">#Left(CONTRACT_HEAD,75)#</a></td>
				<td style="text-align:right; width:70px;">#dateformat(FINISHDATE,dateformat_style)#</td>
			</tr>
		</cfoutput>
		</tbody>
	<cfelse>
		<tbody>
			<tr>
				<td colspan="2"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</td>
			</tr>
		</tbody>
	</cfif>
</cf_flat_list>

