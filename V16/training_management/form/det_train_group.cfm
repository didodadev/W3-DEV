<cf_catalystHeader>
<div class="col col-9 col-xs-12 uniqueRow">
    <cfinclude template="../query/get_class_ang_groups.cfm">
    <cf_box
        box_page="#request.self#?fuseaction=training_management.popup_group_att_tests_report&train_group_id=#attributes.train_group_id#"
        title="#getLang('','Katılımcıların Devam Durumları ve ÖNTEST / SONTEST Değerlendirme Sonuçları',46480)#">
    </cf_box>
</div>
<div class="col col-3 col-xs-12">   
    <!--- Yan kısım--->
    <cfif isdefined("attributes.class_id") and len(attributes.class_id)>
        <cf_box 
            id="attainer_exam" 
            title="#getLang('training_management',266)#" 
            closable="0" 
            unload_body="1" 
            box_page="#request.self#?fuseaction=objects.popup_ajax_survey&type=8&class_id=#attributes.class_id#&train_group_id=#attributes.train_group_id#&finishdate=#get_trainings.FINISH_DATE#&start_date=#get_trainings.START_DATE#">
        </cf_box>
    <cfelse>
        <cf_box 
            id="attainer_exam" 
            title="#getLang('training_management',266)#" 
            closable="0" 
            unload_body="1" 
            box_page="#request.self#?fuseaction=objects.popup_ajax_survey&type=8&train_group_id=#attributes.train_group_id#&finishdate=#get_trainings.FINISH_DATE#&start_date=#get_trainings.START_DATE#">
        </cf_box>
    </cfif>
    <cfif isdefined("attributes.class_id") and len(attributes.class_id)>
        <cf_box 
            id="trainer_exam" 
            title="#getLang('training_management',267)#" 
            closable="0" 
            unload_body="1" 
            box_page="#request.self#?fuseaction=objects.popup_ajax_survey&type=9&class_id=#attributes.class_id#&train_group_id=#attributes.train_group_id#&finishdate=#get_trainings.FINISH_DATE#&start_date=#get_trainings.START_DATE#">
        </cf_box>
    <cfelse>
        <cf_box 
            id="trainer_exam" 
            title="#getLang('training_management',267)#" 
            closable="0" 
            unload_body="1" 
            box_page="#request.self#?fuseaction=objects.popup_ajax_survey&type=9&train_group_id=#attributes.train_group_id#&finishdate=#get_trainings.FINISH_DATE#&start_date=#get_trainings.START_DATE#">
        </cf_box>
    </cfif>
</div>