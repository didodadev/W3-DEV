<cfinclude template="../query/get_rank_detail.cfm">
<cf_medium_list>
	<thead>
		<tr>
			<th><cf_get_lang dictionary_id="34749.Derece-Kademe"></th>
			<th><cf_get_lang dictionary_id="34755.Terfi Başlangıç"></th>
			<th><cf_get_lang dictionary_id="34746.Terfi Bitiş"></th>
			<th><cf_get_lang dictionary_id="34723.Terfi Nedeni"></th>
			<th></th>
		</tr>
	</thead>
	<tbody>
		<cfif get_rank_detail.recordcount>
		<cfoutput query="get_rank_detail">
			<cfif promotion_reason eq 1><cfsavecontent variable="reason"><cf_get_lang dictionary_id="34715.Hizmet İntibakı"></cfsavecontent>
			<cfelseif promotion_reason eq 2><cfsavecontent variable="reason"><cf_get_lang dictionary_id="58567.Terfi"></cfsavecontent>
			<cfelseif promotion_reason eq 3><cfsavecontent variable="reason"><cf_get_lang dictionary_id="30483.Yüksek Lisans"></cfsavecontent>
			<cfelseif promotion_reason eq 4><cfsavecontent variable="reason"><cf_get_lang dictionary_id="31293.Doktora"></cfsavecontent>
            <cfelseif promotion_reason eq 5><cfsavecontent variable="reason"><cf_get_lang dictionary_id="34713.Lise Hazırlık"></cfsavecontent>
            <cfelseif promotion_reason eq 6><cfsavecontent variable="reason"><cf_get_lang dictionary_id="34704.İlk Görev"></cfsavecontent>
            <cfelseif promotion_reason eq 7><cfsavecontent variable="reason"><cf_get_lang dictionary_id="58156.Diğer"></cfsavecontent>
			</cfif>
			<tr>
				<td>#grade#-#step#</td>
				<td>#dateformat(promotion_start,dateformat_style)#</td>
				<td>#dateformat(promotion_finish,dateformat_style)#</td>
				<td><cfif len(promotion_reason)>#reason#</cfif></td>
				<td width="15" align="center"><a href="#request.self#?fuseaction=#fusebox.circuit#.popup_form_upd_rank&employee_id=#employee_id#&id=#id#"><img src="/images/update_list.gif" align="absmiddle" border="0"></a></td>
			</tr>
		</cfoutput>
		<cfelse>
		<tr><td colspan="8"><cf_get_lang_main no="72.Kayıt Yok">!</td></tr>
		</cfif>
	</tbody>
</cf_medium_list>
