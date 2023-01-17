<cfinclude template="../query/get_trainin_join_request.cfm">
<cfset attributes.CLASS_ID = get_trainin_join_request.CLASS_ID>
<cfsavecontent variable="img"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=training.popup_form_add_class_join_request"><img src="/images/plus1.gif" title="<cf_get_lang_main no='170.Ekle'>"></a></cfsavecontent>
<cf_popup_box title="#getLang('training',93)#" right_images="#img#">
    <cfinclude template="dsp_training_join_request_details.cfm"></td>
</cf_popup_box>
