<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cfform name="add_process" method="post" action="#request.self#?fuseaction=process.emptypopup_add_main_process">
            <cf_box_elements>
                <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                    <cfoutput>
                    <div class="form-group" id="item-process_name">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='36294.Ana Süreç'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id="58194.Zorunlu Alan"> : <cf_get_lang dictionary_id='36208.Süreç Adı Girmelisiniz'></cfsavecontent>
                            <cfinput type="Text" name="process_name"  maxlength="200" required="Yes" message="#message#">
                        </div>
                    </div>
                </div>
                <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
                    <div class="form-group" id="item-project_head">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57416.Proje'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <div class="input-group">
                                <input type="hidden" name="project_id" id="project_id" value="<cfif isdefined('attributes.project_id') and len(attributes.project_id)>#attributes.project_id#</cfif>">
                                <input name="project_head" type="text" id="project_head" value="<cfif isdefined('attributes.project_id') and len(attributes.project_id)>#get_project_name(attributes.project_id)#</cfif>"onFocus="AutoComplete_Create('project_head','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','','3','200');" autocomplete="off">
                                <span class="input-group-addon icon-ellipsis btnPointer" onClick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_projects&project_head=add_process.project_head&project_id=add_process.project_id');"></span>				
                            </div>
                        </div>	
                    </div>
                </div>
                <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                    <div class="form-group" id="item-detail">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <textarea name="detail" id="detail"></textarea>
                        </div>
                    </div>
                    </cfoutput>
                </div>
            </cf_box_elements>
            <cf_box_footer>  
                <cf_workcube_buttons type_format="1" is_upd='0'>
            </cf_box_footer>    
        </cfform>
    </cf_box>
</div> 
