<cfinclude template="../query/old_chapter_list.cfm">
<cfinclude template="../query/get_content_cat.cfm">
<cfsavecontent variable="title"><cf_get_lang dictionary_id='50568.İçerik Bölümü Ekle'></cfsavecontent>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box title="#title#" is_blank="0">
        <cfform name="form_chapter" action="#request.self#?fuseaction=content.emptypopup_add_chapter" method="post" enctype="multipart/form-data">
            <input type="hidden" name="public_image" id="public_image">
            <input type="hidden" name="public_image1" id="public_image1">
            <cf_box_elements>	
                <div class="col col-5 col-xs-12">             
                    <div class="form-group"> 
                        <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57756.Durum'></label>
                        <label class="col col-6 col-md-6 col-sm-12 col-xs-12"><input type="Checkbox" name="status" id="status"><cf_get_lang dictionary_id='57494.Pasif'></label>
                    </div>
                    <div class="form-group"> 
                        <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57486.Kategori'> *</label>
                        <div class="col col-6 col-md-6 col-sm-12 col-xs-12">
                            <div class="input-group">
                                <input type="hidden" name="contentcat_id" id="contentcat_id">
                                <input type="hidden" name="hierarchy" id="hierarchy">
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.Zorunlu Alan'>:<cf_get_lang dictionary_id='57486.Kategori'>/<cf_get_lang dictionary_id='57761.Hiyerarşi'></cfsavecontent>
                                <cfinput type="text" name="contentcat_name" id="contentcat_name" style="width:200px;" value="" readonly required="yes" message="#message#">
                                <span class="input-group-addon icon-ellipsis btnPointer" href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=content.popup_list_hierarchy</cfoutput>&hierarchy=form_chapter.hierarchy&id=form_chapter.contentcat_id&alan=form_chapter.contentcat_name','list');"></span>
                            </div>
                        </div>	
                    </div>
                    <div class="form-group"> 
                        <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57995.Bölüm'> *</label>
                        <div class="col col-6 col-md-6 col-sm-12 col-xs-12">
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.Zorunlu Alan'>:<cf_get_lang dictionary_id='57995.Bölüm'></cfsavecontent>
                            <div class="input-group">
                                <cfoutput>
                                    <input type="text" name="chapter_name" id="chapter_name" message="#message#" value="" required>
                                    <input type="hidden" name="chapter_dictionary_id" id="chapter_dictionary_id" value="">
                                    <span class="input-group-addon icon-ellipsis btnPointer" href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=settings.popup_list_lang_settings&is_use_send&lang_dictionary_id=form_chapter.chapter_dictionary_id&lang_item_name=form_chapter.chapter_name');return false"></span>
                                </cfoutput>
                            </div>
                        </div>
                    </div>
                    <div class="form-group"> 
                        <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='29762.İmaj'> 1</label>
                        <div class="col col-6 col-md-6 col-sm-12 col-xs-12">
                            <input type="File" name="image1" id="image1" style="width:200px;">
                        </div>
                    </div>
                    <div class="form-group"> 
                        <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='29762.İmaj'> 2</label>
                        <div class="col col-6 col-md-6 col-sm-12 col-xs-12">
                            <input type="File" name="image2" id="image2" style="width:200px;">
                        </div>
                    </div> 
                </div>
            </cf_box_elements>
            <div class="row formContentFooter">
                <cf_workcube_buttons is_upd='0'>
            </div>
        </cfform>
    </cf_box>
</div>
