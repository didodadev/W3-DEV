<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cfsavecontent  variable="head"><cf_get_lang dictionary_id='43443.Ana Menü Ayarları'></cfsavecontent>
    <cf_box title="#head#" collapsable="0" resize="0">
        <cfform action="#request.self#?fuseaction=settings.emptypopup_add_main_menu" method="post" name="user_group" enctype="multipart/form-data">
            <cf_box_elements vertical="1">
                <div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12">
                    <label><input type="checkbox" name="is_active" id="is_active" value="1" checked><cf_get_lang dictionary_id='57493.Aktif'></label>
                </div>
                <div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12">
                    <label><input type="checkbox" name="is_publish" id="is_publish" value="1"><cf_get_lang dictionary_id ='44439.Bakım'> / <cf_get_lang dictionary_id='29479.Yayın'></label>
                </div>
                <div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12">
                    <label><input type="radio" name="site_type" id="site_type" value="1"><cf_get_lang dictionary_id ='44790.Çalışan Portalı'></label>
                </div>
                <div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12">
                    <label><input type="radio" name="site_type" id="site_type" value="2"><cf_get_lang dictionary_id ='44788.Üye Portalı'></label>
                </div>
                <div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12">
                    <label><input type="radio" name="site_type" id="site_type" value="3"><cf_get_lang dictionary_id ='44441.Kariyer Portalı'></label>
                </div>
                <div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12">
                    <label><input type="radio" name="site_type" id="site_type" value="4"><cf_get_lang dictionary_id='45154.PDA Portalı'></label>
                </div>
                <div class="form-group col col-3 col-md-3 col-sm-4 col-xs-12">
                    <label><cf_get_lang dictionary_id='43444.Menü Adı'> *</label>
                    <cfsavecontent  variable="message"><cf_get_lang dictionary_id='43444.Menü Adı'></cfsavecontent>
                    <cfinput type="text" name="menu_name" id="menu_name" value="" style="width:200px;" required="yes" message="#message#" maxlength="100">
                </div>
            </cf_box_elements>	
            <cf_box_footer>
                <cf_workcube_buttons is_upd='0'>
            </cf_box_footer>
        </cfform>
    </cf_box>
</div>
            
