<cf_xml_page_edit fuseact="training_management.form_upd_class">
<cf_catalystHeader>
<cfinclude template="../query/get_class.cfm">
<cfset attributes.training_id = get_class.training_id>
    <div class="col col-9 col-md-9 col-xs-12">
	    <cf_get_workcube_form_generator action_type='9' related_type='9' xml_is_survey_add='0' action_type_id='#url.class_id#' design='3'><!---Detaylı Anketler  20120704 SG degerlendirme formlari bu customtag ile olusturulacak--->
    </div>
    <div class="col col-3 col-md-3 col-xs-12">
        <cf_get_workcube_note action_section='CLASS_ID' action_id='#url.class_id#'><!--- Notlar --->
        <!--- Testler--->
        <cfsavecontent variable="message"><cf_get_lang_main no='639.Testler'></cfsavecontent>
        <cf_box
            id="quiz"
            closable="0"
            add_href="#request.self#?fuseaction=training_management.list_quizs&event=add&class_id=#url.class_id#&xml_is_quiz_add=#xml_is_quiz_add#"
            info_href="#request.self#?fuseaction=training_management.popup_list_quiz_relation&class_id=#url.class_id#&xml_is_quiz_add=#xml_is_quiz_add#"
            box_page="#request.self#?fuseaction=training_management.emptypopup_upd_class_test_ajax&class_id=#url.class_id#"
            title="#message#">
        </cf_box>       
        <!---  meta tanımları  --->
        <cf_meta_descriptions action_id='#attributes.class_id#' action_type ='CLASS_ID' faction_type='#listgetat(attributes.fuseaction,1,"&")#'> 
        <!---Katılımcılar ---->
        <cfsavecontent variable="message"><cf_get_lang_main no ='178.Katılımcılar'></cfsavecontent>
        <cf_box 
            id="attender"
            closable="0"
            box_page="#request.self#?fuseaction=training_management.emptypopup_upd_class_attender_ajax&training_id=#attributes.training_id#&class_id=#url.class_id#"
            title="#message#"></cf_box>
    </div>