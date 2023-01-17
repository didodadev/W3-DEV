<cfinclude template="../../objects/display/imageprocess/imcontrol.cfm">
<cfparam name="attributes.modal_id" default="">
<cf_box title="#getLang('','Görev Tanımları',47117)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
    <cfform name="add_position_content" action="#request.self#?fuseaction=hr.emptypopup_add_position_content" method="POST">
        <cfif isdefined("attributes.position_id")>
            <input type="hidden" value="<cfoutput>#attributes.position_id#</cfoutput>" name="position_id" id="position_id">
        <cfelse>
            <input type="hidden" value="<cfoutput>#attributes.position_cat_id#</cfoutput>" name="position_cat_id" id="position_cat_id">
        </cfif>
        <cf_box_elements>
            <div class="col col-12 col-md-12 col-sm-12 col-xs-12" type="column" index="2" sort="true">
                <div class="form-group require" id="item-head">
                    <label class="col col-1 col-sm-12"><cf_get_lang dictionary_id='58820.Başlık'></label>
                    <div class="col col-3 col-sm-12">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='58820.Başlık'></cfsavecontent>
                        <cfinput type="text" name="CONTENT_HEAD" value="" required="Yes" message="#message#" maxlength="100">
                    </div>                
                </div> 
                <div class="form-group require" id="item-editor">
                    <cfmodule
                        template="/fckeditor/fckeditor.cfm"
                        toolbarset="WRKContent"
                        basepath="/fckeditor/"
                        instancename="content_topic"
                        valign="top"
                        value=""
                        width="570"
                        height="240">
                </div>
            </div>
        </cf_box_elements>
        <cf_box_footer>
            <cf_workcube_buttons type_format="1" is_upd='0' add_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('add_position_content' , #attributes.modal_id#)"),DE(""))#">
        </cf_box_footer>
    </cfform>
</cf_box>


