<cfsetting showdebugoutput="no">
<cfinclude template="get_cons_ct.cfm">
<cf_flat_list>
	<cfif get_cons_ct.recordcount>
		<thead>
			<th><cf_get_lang_main no="158.ad soyad"></th>
			<th><cf_get_lang_main no="74.kategori"></th>
			<th><cf_get_lang_main no="330.tarih"></th> 
		</thead>
		
		<tbody>
			<cfparam name="attributes.page" default=1>
			<cfparam name="attributes.maxrows" default=20>
			<cfparam name="attributes.totalrecords" default="#get_cons_ct.recordcount#">
			<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
			<cfoutput query="get_cons_ct" maxrows="#attributes.maxrows#" startrow="#attributes.startrow#">
				<tr>
					<td width="250"><a href="#request.self#?fuseaction=member.consumer_list&event=det&cid=#consumer_id#" class="tableyazi">#CONSUMER_NAME# #CONSUMER_surname#</a></td>
					<td>#conscat#</td>
					<td width="65"><cfif len(RECORD_DATE)>#dateformat(date_add('h',session.ep.time_zone,RECORD_DATE),dateformat_style)#</cfif></td>
				</tr>
			</cfoutput>
		<cfelse>
			<tr>
				<td><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</td>
			</tr>
		</tbody>
	</cfif>
</cf_flat_list>

