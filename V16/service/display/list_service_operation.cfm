<cf_xml_page_edit fuseact="service.add_service">
<cfinclude template="../query/get_service_detail.cfm">
<cf_ajax_list>
	<tbody>
		<tr>
			<td>
				<cfoutput>
					<cfset str_link = "&form_submitted=1&made_application=#get_service_detail.applicator_name#">
					<cfif isdefined("attributes.employee_id") and len(attributes.employee_id)>
						<a href="#request.self#?fuseaction=service.list_service&employee_id=#attributes.employee_id##str_link#" class="tableyazi"><cf_get_lang no='28.Üyeye Ait Diğer Servis Başvuruları'></a>
					<cfelseif isdefined("attributes.partner_id") and len(attributes.partner_id)>
						<a href="#request.self#?fuseaction=service.list_service&partner_id=#attributes.partner_id##str_link#" class="tableyazi"><cf_get_lang no='28.Üyeye Ait Diğer Servis Başvuruları'></a>
					<cfelseif isdefined("attributes.consumer_id") and len(attributes.consumer_id)>
						<a href="#request.self#?fuseaction=service.list_service&consumer_id=#attributes.consumer_id##str_link#" class="tableyazi"><cf_get_lang no='28.Üyeye Ait Diğer Servis Başvuruları'></a>
					<cfelse>
						<cf_get_lang_main no='72.Kayıt Yok'>!
					</cfif>
				</cfoutput>
			</td>
		</tr>
	</tbody>
</cf_ajax_list>
