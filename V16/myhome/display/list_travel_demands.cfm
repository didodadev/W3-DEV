<cfscript>
	get_demands = createObject("component","V16.myhome.cfc.get_travel_demands");
	get_demands.dsn = dsn;
	get_travel_demand = get_demands.travel_demands
					(
						employee_id : session.ep.userid
					);

</cfscript>	
<cfsavecontent variable="title"><cf_get_lang dictionary_id="32380.Seyahat Taleplerim"></cfsavecontent>
	<cf_box title="#title#" closable="0">
	<cf_ajax_list>
			<thead>
				<tr>
					<th width="20"><cf_get_lang dictionary_id='57487.No'></th>
					<th><cf_get_lang dictionary_id='57570.Ad Soyad'></th>
					<th><cf_get_lang dictionary_id='57574.Şirket'></th>
					<th><cf_get_lang dictionary_id='57453.Şube'></th>
					<th><cf_get_lang dictionary_id='35449.Departman'></th>
					<th><cf_get_lang dictionary_id='57482.Aşama'></th>
					<th><cf_get_lang dictionary_id='45446.Göreve Gideceği Yer'></th>
					<th><cf_get_lang dictionary_id='45410.Gidiş Tarihi'></th>
					<th><cf_get_lang dictionary_id='45408.Dönüş Tarihi'></th>
					<th width="20"><a href="<cfoutput>#request.self#?fuseaction=myhome.list_travel_demands&event=add</cfoutput>"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='45588.Seyahat Talebi Ekle'>"></a></th>
				</tr>
		    </thead>
			<tbody>
				<cfif get_travel_demand.recordcount>
					<cfoutput query="get_travel_demand">
						<tr>
							<td width="20">#currentrow#</td>
							<td>#EMPNAME_SURNAME#</td>
							<td>#nick_name#</td>
							<td>#branch_name#</td>
							<td>#department_head#</td>
							<td>#stage#</td>
							<td>#place# / #city#</td>
							<td>#dateformat(DEPARTURE_DATE,dateformat_style)#</td>
							<td>#dateformat(DEPARTURE_OF_DATE,dateformat_style)#</td>
							<cfset attributes.demand_id= contentEncryptingandDecodingAES(isEncode:1,content:TRAVEL_DEMAND_ID,accountKey:'wrk')>
							<td width="20"><a href="#request.self#?fuseaction=myhome.list_travel_demands&event=upd&TRAVEL_DEMAND_ID=#attributes.demand_id#"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='30923.İzin Güncelle'>"></a></td>
						</tr>
					</cfoutput>
				<cfelse>
					<tr>
						<td colspan="11"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>
					</tr>
				</cfif>
			</tbody>
	</cf_ajax_list>
</cf_box>


