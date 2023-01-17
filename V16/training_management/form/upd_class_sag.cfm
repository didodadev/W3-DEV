<!--- Eğitimciler --->
<cfsavecontent variable="message"><cf_get_lang no ='118.Eğitimciler'></cfsavecontent>
    <cfset add_href = "openBoxDraggable('#request.self#?fuseaction=training_management.popup_form_add_class_trainer&class_id=#url.class_id#')">
    <cf_box
        id="trainer"
        closable="0" 
        unload_body="1" 
        collapsed="1" 
        add_href="#add_href#"
        <!--- add_href="#request.self#?fuseaction=training_management.popup_form_add_class_trainer&class_id=#url.class_id#" --->
        box_page="#request.self#?fuseaction=training_management.emptypopup_upd_class_trainers_ajax&class_id=#url.class_id#"
        title="#message#">
    </cf_box>
<!--- Ödevler - Çalışmalar --->
<cfsavecontent variable="message"><cf_get_lang dictionary_id='63656.Ödevler - Çalışmalar'></cfsavecontent>
<cf_box
    add_href="javascript:openBoxDraggable('#request.self#?fuseaction=training_management.list_class&event=addHomework&class_id=#url.class_id#','add_homework_box','ui-draggable-box-medium')"
    widget_load="listHomeworkStudy&class_id=#attributes.class_id#"
	id="homework_study"
    closable="0" 
    settings="0"
    title="#message#">
</cf_box>
<!--- Sınıflar--->
<cfsavecontent variable="message"><cf_get_lang_main no ='637.Sınıflar'></cfsavecontent>
    <cfset add_href = "openBoxDraggable('#request.self#?fuseaction=training_management.popup_list_training_groups&class_id=#url.class_id#')">
<cf_box
    id="training_groups"
    closable="0"
    add_href="#request.self#?fuseaction=training_management.list_training_groups&event=add&class_id=#url.class_id#"
    info_href="javascript:openBoxDraggable('#request.self#?fuseaction=training_management.popup_list_training_groups&class_id=#url.class_id#','add_training_group_box','ui-draggable-box-medium')"
    box_page="#request.self#?fuseaction=training_management.emptypopup_upd_class_training_groups_ajax&class_id=#url.class_id#"
    title="#message#">
</cf_box>
<!---Fiziki Varlık ve Rezervasyon---->
<cfsavecontent variable="message"><cf_get_lang no ='480.Fiziki Varlık ve Rezervasyon'></cfsavecontent>
<!--- <cfset add_href = "openBoxDraggable('#request.self#?fuseaction=objects.popup_assets&class_id=#attributes.class_id#')"> --->
    	
<cf_box 
    id="deneme3"
    closable="0"
    add_href="#request.self#?fuseaction=objects.popup_assets&class_id=#attributes.class_id#"
    box_page="#request.self#?fuseaction=training_management.emptypopup_upd_class_resarvation_ajax&class_id=#url.class_id#"
    title="#message#">
</cf_box>
<!--- Images --->
<cf_wrk_images class_id="#attributes.class_id#" type="training">

<cfif isDefined('xml_is_related_class') and xml_is_related_class eq 1>
    <!---Eğitimler ---->
    <cfsavecontent variable="message"><cf_get_lang no='464.İlişkili Eğitimler'></cfsavecontent>
    <cfset add_href = "javascript:openBoxDraggable('#request.self#?fuseaction=training_management.popup_list_class&rel_class=1&action_type_id=#attributes.class_id#&action_type=CLASS_ID')">
    <cf_box
        id="class"
        closable="0"
        info_href="#add_href#"
        box_page="#request.self#?fuseaction=training_management.emptypopup_upd_class_rel_ajax&class_id=#attributes.class_id#"
        title="#message#">
    </cf_box>
</cfif>
<script>
    function open_team(url,id){
        document.getElementById(id).style.display ='';
        document.getElementById(id).style.width ='500px';
        $("#"+id).css('left','50%');
        $("#"+id).css('top','20%');
        $("#"+id).css('position','absolute');
        
        AjaxPageLoad(url,id,1);
        return false;
    }
</script>