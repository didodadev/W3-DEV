<cfsavecontent variable="text"><cf_get_lang no='116.Servis Tarihçesi'></cfsavecontent>
<cf_box id="History_Service" 
    title="#text#" 
	box_page="#request.self#?fuseaction=call.popup_ajax_service_history&service_id=#attributes.service_id#" 
    closable="0"></cf_box>
