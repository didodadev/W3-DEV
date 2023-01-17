<cfset get_cat = createObject("component","V16.settings.cfc.department_cat").getDepartmentCat(cat_id:attributes.cat_id)/>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box title="#getLang('','Departman Kategorileri','64603')#" add_href="#request.self#?fuseaction=settings.add_department_cat" is_blank="0">
        <div class="col col-3 col-md-3 col-sm-3 col-xs-12 scrollContent scroll-x3">
            <cfinclude template="../display/list_department_cat.cfm">
        </div>
        <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
            <cfform name="department">
                <cfinput type="hidden" name="cat_id" id="cat_id" value="#attributes.cat_id#">
                <cf_box_elements>
                    <div class="col col-6 col-md-6 col-sm-6 col-xs-12" index="1" type="column" sort="true">
                        <div class="form-group" id="item-dep_cat_name">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='64604.Departman Kategorisi'>*</label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12"> 
                                <div class="input-group">
                                    <cfinput type="text" name="dep_cat_name" id="dep_cat_name" value="#get_cat.DEPARTMENT_CAT#">
                                    <span class="input-group-addon">
                                        <cf_language_info
                                            table_name="SETUP_DEPARTMENT_CAT"
                                            column_name="DEPARTMENT_CAT"
                                            column_id_value="#attributes.cat_id#"
                                            maxlength="500"
                                            datasource="#dsn#" 
                                            column_id="DEPARTMENT_CAT_ID" 
                                            control_type="0">
                                    </span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-detail">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12"> 
                                <textarea name="detail" id="detail" rows="2" cols="21"><cfoutput>#get_cat.detail#</cfoutput></textarea>
                            </div>
                        </div>
                    </div>
                </cf_box_elements>
                <cf_box_footer>
                    <cf_record_info query_name="get_cat">
                    <cf_workcube_buttons
                    data_action ="/V16/settings/cfc/department_cat:upd_dep_cat"
                    next_page="#request.self#?fuseaction=settings.add_department_cat&event=upd&cat_id="
                    del_action= '/V16/settings/cfc/department_cat:DEL:cat_id=#attributes.cat_id#'
                    del_next_page="#request.self#?fuseaction=settings.add_department_cat"
                    add_function='kontrol()'
                    is_upd="1">
                </cf_box_footer>
            </cfform>
        </div>
    </cf_box>
</div>
<script>
    function kontrol() {
        if($('#dep_cat_name').val()== ""){
            alert("<cf_get_lang dictionary_id='57471.Eksik Veri'>: <cf_get_lang dictionary_id='64604.Departman Kategorisi'>!");
            return false;
        }
    }
</script>