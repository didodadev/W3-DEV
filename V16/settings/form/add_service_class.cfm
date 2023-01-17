<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box title="#getLang('','Hizmet Sınıfları','64612')#" add_href="#request.self#?fuseaction=settings.add_service_class" is_blank="0">
        <div class="col col-3 col-md-3 col-sm-3 col-xs-12 scrollContent scroll-x3">
            <cfinclude template="../display/list_service_class.cfm">
        </div>
        <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
            <cfform name="service_class">
                <cf_box_elements>
                    <div class="col col-6 col-md-6 col-sm-6 col-xs-12" index="1" type="column" sort="true">
                        <div class="form-group" id="item-service_class_name">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='64104.Hizmet Sınıfı'>*</label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12"> 
                                <cfinput type="text" name="service_class_name" id="service_class_name">
                            </div>
                        </div>
                        <div class="form-group" id="item-detail">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12"> 
                                <textarea name="detail" id="detail" rows="2" cols="21"></textarea>
                            </div>
                        </div>
                        <div class="form-group" id="item-special_code">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57789.Özel Kod'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12"> 
                                <cfinput type="text" name="special_code" id="special_code">
                            </div>
                        </div>
                    </div>
                </cf_box_elements>
                <cf_box_footer>
                    <cf_workcube_buttons
                    is_upd='0'
                    add_function="kontrol()"
                    data_action ="/V16/settings/cfc/service_class:add_service_class"
                    next_page="#request.self#?fuseaction=settings.add_service_class&event=upd&class_id=">
                </cf_box_footer>
            </cfform>
        </div>
    </cf_box>
</div>
<script>
    function kontrol() {
        if($('#service_class_name').val()== ""){
            alert("<cf_get_lang dictionary_id='57471.Eksik Veri'>: <cf_get_lang dictionary_id='64104.Hizmet Sınıfı'>!");
            return false;
        }
    }
</script>