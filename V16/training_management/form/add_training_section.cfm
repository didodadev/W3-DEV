<cfinclude template="../query/get_training_cats.cfm">
<cf_catalystHeader>
<div class="col col-12">
    <cf_box title="#getLang('','Yeni Kayıt', 45697)#">
        <cfform name="add_training" method="post" action="#request.self#?fuseaction=training_management.emptypopup_add_training_section">
            <input type="hidden" name="counter" id="counter">
            <cf_box_elements>
                <div class="col col-4 col-xs-12" type="column" index="1" sort="true">
                    <div class="form-group" id="item-kategori">
                        <label class="col col-4 col-xs-12">
                            <cf_get_lang dictionary_id='57486.Kategori'>
                        </label>
                        <div class="col col-8 col-xs-12">
                            <select name="training_cat_id" id="training_cat_id" style="width:400px;">
                                        <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                <cfoutput query="get_training_cats">
                                        <option value="#training_cat_id#">#training_cat#</option>
                                </cfoutput>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-bolum">
                        <label class="col col-4 col-xs-12">
                            <cf_get_lang dictionary_id='57995.Bölüm'>
                        </label>
                        <div class="col col-8 col-xs-12">
                            <cfinput type="text" name="section_name" id="section_name" style="width:400px;" required="Yes"  value=""/>
                        </div>
                    </div>
                    <div class="form-group" id="item-amac">
                        <label class="col col-4 col-xs-12">
                            <cf_get_lang no='32.amaç'>
                        </label>
                        <div class="col col-8 col-xs-12">
                            <textarea name="section_detail" id="section_detail" maxlength="500" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" style="height:150px"></textarea>
                        </div>
                    </div>
                </div>
            </cf_box_elements>
            <cf_box_footer>
                <div class="col col-12">
                    <input type="Hidden" name="trainers" id="trainers" value="">
                    <cf_workcube_buttons type_format="1" is_upd='0' add_function='kontrol()'>
                </div>
            </cf_box_footer>
        </cfform>
    </cf_box>
</div>
<script type="text/javascript">
    function kontrol() {
        if($('#training_cat_id').val() == ''){
            alert("<cf_get_lang no ='521.Önce Eğitim Üst Kategorisi Seçiniz '>!!");
            return false;
        }
        return true;
    }
</script>