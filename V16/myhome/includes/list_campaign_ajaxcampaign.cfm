<cfsetting showdebugoutput="no">
<cfinclude template="get_campaigns.cfm">
<cf_flat_list>
	<cfif campaigns.recordcount>
		<thead>
			<tr>
				<th><cf_get_lang_main no="34.kampanya"></th>
				<th><cf_get_lang_main no="218.tip"></th>
				<th><cfoutput>#getLang('main',641)#</cfoutput></th>
				<th><cfoutput>#getLang('main',288)#</cfoutput></th>
			</tr>
		</thead>
		
		<tbody>	
		  <cfoutput query="campaigns" maxrows="15">
			<tr>
				<td width="250"><a href="#request.self#?fuseaction=campaign.list_campaign&event=upd&camp_id=#camp_id#" class="tableyazi">#camp_head#</a></td>
				<td>#camp_cat_name#</td>
				<td>#dateformat(dateadd('h',session.ep.time_zone,CAMP_STARTDATE),dateformat_style)#</td>
				<td>#dateformat(dateadd('h',session.ep.time_zone,CAMP_FINISHDATE),dateformat_style)#</td>
			</tr>
		  </cfoutput>
		</tbody>
	<cfelse>
		<tbody>
			<tr>
				<td colspan="4"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</td>
			</tr>
		</tbody>
	</cfif>
</cf_flat_list>
