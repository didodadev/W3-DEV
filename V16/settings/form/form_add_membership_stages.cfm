<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cfsavecontent variable="header"><cf_get_lang dictionary_id='43351.Durum Ekle'></cfsavecontent>
    <cf_box title="#header#">
        <cfform action="#request.self#?fuseaction=settings.emptypopup_add_membership_stages" method="post" name="add_stages">
            <cf_box_elements>
                <input type="hidden" name="counter" id="counter">
                <div class="form-group">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57480.Başlık '>*</label>
                    <div class="col col-8 col-xs-12">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='57736.Başlık Girmelisiniz!'></cfsavecontent>
                        <cfinput type="Text" name="tr_name" style="width:250px;" value="" maxlength="50" required="Yes" message="#message#">
                    </div>
                </div>
                <div class="form-group">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
                    <div class="col col-8 col-xs-12">
                        <textarea name="tr_detail" id="tr_detail" style="width:250px;height:100px;"></textarea>
                    </div>
                </div>
            </cf_box_elements>
            <cf_box_footer>
                <cf_workcube_buttons is_upd='0'>
            </cf_box_footer>
        </cfform>
    </cf_box>
</div>

                      
