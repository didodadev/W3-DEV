<cfsavecontent variable="text"><cf_get_lang no='118.Önceki Başvurular'></cfsavecontent>
<cf_box 
	id="service_related"
	title="#text#" 
	box_page="#request.self#?fuseaction=call.popup_ajax_service_related&service_id=#attributes.service_id#&company_id=#get_service_detail.service_company_id#&consumer_id=#get_service_detail.service_consumer_id#&employee_id=#get_service_detail.service_employee_id#" 
	collapsed="0"
	closable="0">
</cf_box>
