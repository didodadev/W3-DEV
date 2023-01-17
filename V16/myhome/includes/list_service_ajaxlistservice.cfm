<cfsetting showdebugoutput="no">
<cfinclude template="get_service.cfm">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default=10>
<cfparam name="attributes.totalrecords" default="#get_service.recordcount#">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cf_flat_list>
	<thead>
		<tr>
			<th><cf_get_lang_main no="75.No"></th>
			<th><cf_get_lang_main no="68.Konu"></th>
			<th><cf_get_lang_main no="74.Kategori"></th>
			<th style="width:200px;"><cf_get_lang_main no="1717.Başvuru yapan"></th>
		</tr>
	</thead>
	<tbody>
		<cfoutput query="get_service" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
			<tr>
				<td>#currentrow#</td>
				<td><a href="#request.self#?fuseaction=service.list_service&event=upd&service_id=#SERVICE_ID#" class="tableyazi">#service_HEAD#</a></td>
				<td> #SERVICECAT# </td>
				<cfif len(get_service.SERVICE_COMPANY_ID)>
					<td>#get_par_info(get_service.SERVICE_COMPANY_ID,1,1,1)# #APPLICATOR_NAME#</td>
				</cfif>
		</cfoutput>
	  <cfif not get_service.recordcount>
		<tr>
		  <td><cf_get_lang_main no='72.Kayıt Yok'>!</td>
		</tr>
	  </cfif>
	</tbody>
</cf_flat_list>
 

