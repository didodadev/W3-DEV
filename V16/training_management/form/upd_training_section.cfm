<cfinclude template="../query/get_training_cats.cfm">
<cfinclude template="../query/get_training_sec.cfm">
<cfinclude template="../query/get_training_sec_trainers.cfm">
<cfinclude template="../query/get_training_sec_relations.cfm">
<cf_catalystHeader>
<div class="col col-12">
    <cf_box title="#get_training_sec.SECTION_NAME#">
        <cfform name="add_training" method="post" action="#request.self#?fuseaction=training_management.emptypopup_upd_training_section">
        <input type="hidden" name="counter" id="counter">
        <input type="hidden" name="training_sec_id" id="training_sec_id" value="<cfoutput>#attributes.training_sec_id#</cfoutput>">
            <cf_box_elements>
                <div class="col col-4 col-xs-12" type="column" index="1" sort="true">
                    <div class="form-group" id="item-kategori">
                        <label class="col col-4 col-xs-12">
                            <cf_get_lang dictionary_id='57486.Kategori'>
                        </label>
                        <div class="col col-8 col-xs-12">
                            <select name="training_cat_id" id="training_cat_id">
                            <cfoutput query="get_training_cats">
                                <option value="#training_cat_id#"<cfif get_training_sec.training_cat_id eq training_cat_id>selected</cfif>>#training_cat#</option>
                            </cfoutput>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-bolum">
                        <label class="col col-4 col-xs-12">
                            <cf_get_lang dictionary_id='57995.Bölüm'>
                        </label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <cfinput type="text" name="section_name" style="width:400px" required="Yes" value="#get_training_sec.section_name#">
                                <span class="input-group-addon">
                                    <cf_language_info
                                        table_name="TRAINING_SEC"
                                        column_name="SECTION_NAME"
                                        column_id_value="#attributes.training_sec_id#"
                                        maxlength="500"
                                        datasource="#dsn#"
                                        column_id="TRAINING_SEC_ID"
                                        control_type="0">
                                </span>
                            </div>
    
                        </div>
                    </div>
                    <div class="form-group" id="item-amac">
                        <label class="col col-4 col-xs-12">
                            <cf_get_lang no='32.amaç'>
                        </label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <textarea name="section_detail" id="section_detail" maxlength="500" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" style="width:height:140px">
                                    <cfoutput>#get_training_sec.section_detail#</cfoutput>
                                </textarea>
                                <span class="input-group-addon">
                                    <cf_language_info
                                        table_name="TRAINING_SEC"
                                        column_name="SECTION_DETAIL"
                                        column_id_value="#attributes.training_sec_id#"
                                        maxlength="500"
                                        datasource="#dsn#"
                                        column_id="TRAINING_SEC_ID"
                                        control_type="0">
                                </span>
                            </div>
                        </div>
                    </div>
                </div>
            </cf_box_elements>
            <cf_box_footer>
                <div class="col col-6">
                    <cf_record_info query_name="get_training_sec">
                </div>
                <div class="col col-6">
                    <input type="Hidden" name="trainers" id="trainers" value="<cfoutput>#all_trainer_ids#</cfoutput>">
                    <cfif get_training_rel.RecordCount OR get_training_class_rel.RecordCount>
                        <cf_workcube_buttons type_format="1" is_upd='1' is_delete='0' add_function='kontrol()'>
                    <cfelse>
                        <cf_workcube_buttons type_format="1" is_upd='1' delete_page_url = '#request.self#?fuseaction=training_management.emptypopup_del_training_section&training_sec_id=#attributes.TRAINING_SEC_ID#'>
                    </cfif>
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