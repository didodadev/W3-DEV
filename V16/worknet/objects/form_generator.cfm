<cfset getFormGenerator = createObject("component","worknet.objects.worknet_objects").getFormGenerator(
	action_id:attributes.cid,
	action_type:2
) />
<cfif getFormGenerator.recordcount>
    <iframe 
        src="<cfoutput>#request.self#?fuseaction=objects.popup_form_add_detailed_survey_main_result&survey_id=#getFormGenerator.survey_main_id#&action_type=2&action_type_id=#attributes.cid#&is_popup=2</cfoutput>" 
        width="100%" 
        height="600" 
        frameborder="0" 
        scrolling="ye">
    </iframe>
</cfif>
