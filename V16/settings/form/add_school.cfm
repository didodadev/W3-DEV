<cf_box title="#getLang('', 'Okul Ekle', 42768)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
    <cfform action="#request.self#?fuseaction=settings.emptypopup_add_school" method="post" name="add_school">
        <cf_box_elements>
            <div class="col col-12">
                <div class="form-group col col-8 col-md-8 col-sm-8 col-xs-12">
                    <div class="col col-3 col-md-3 col-sm-3 col-xs-12">
                        <label><cf_get_lang dictionary_id='44803.Okul Tipi'></label>
                    </div>
                    <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
                        <select name="school_type" id="school_type">
                            <option value="0"><cf_get_lang dictionary_id='44806.Devlet'></option>
                            <option value="1"><cf_get_lang dictionary_id='57979.Özel'></option>
                            <option value="2"><cf_get_lang dictionary_id='44805.Vakıf Meslek Yüksek'></option>
                        </select>
                    </div>
                </div>
                <div class="form-group col col-8 col-md-8 col-sm-8 col-xs-12">
                    <div class="col col-3 col-md-3 col-sm-3 col-xs-12">
                        <label><cf_get_lang dictionary_id='58820.Başlık'>*</label>
                    </div>
                    <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='58059.Başlık Girmelisiniz'></cfsavecontent>
                        <cfinput type="Text" name="title" value="" maxlength="150" required="Yes" message="#message#">
                    </div>
                </div>
                <div class="form-group col col-8 col-md-8 col-sm-8 col-xs-12">
                    <div class="col col-3 col-md-3 col-sm-3 col-xs-12">
                        <label><cf_get_lang dictionary_id='36199.Açıklama'></label>
                    </div>
                    <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
                        <textarea name="title_detail" id="title_detail"></textarea>
                    </div>
                </div>
            </div>
        </cf_box_elements>
        <cf_box_footer>
            <cf_workcube_buttons is_upd='0' add_function="kontrol()">
        </cf_box_footer>
    </cfform>
</cf_box>
<script>
    function kontrol(){
        <cfif isdefined("attributes.draggable")>
            loadPopupBox('add_school' , 'add_school_box');
            return false;
        </cfif>
    }
</script>