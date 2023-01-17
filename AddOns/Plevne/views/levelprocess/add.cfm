<cfinclude template="../../config.cfm" runonce="true">
<cfinclude template="../../models/types.cfm" runonce="true">

<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cfform name="add_form" method="post">
            <cf_box_elements>
                <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                    <div class="form-group" id="item-level">
                        <label class="col col-4 col-xs-12">Contrast</label>
                        <div class="col col-8 col-xs-12">
                            <select name="contrast" id="contrast">
                                <option value="light">Light</option>
                                <option value="standart">Standart</option>
                                <option value="dark">Dark</option>
                            </select>
                        </div>
                    </div>
                </div>
                <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                    <div class="form-group" id="item-process_kind">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='50161.İşlem Türü'></label>
                        <div class="col col-8 col-xs-12">
                            <select name="process_kind" id="process_kind" onchange="setRelation('', '')">
                                <option value="<cfset writeOutput(plevne_kinds.REQUEST_FILTER)>">Request Filter</option>
                                <option value="<cfset writeOutput(plevne_kinds.UPLOAD_CONTROL)>">Upload Control</option>
                            </select>
                        </div>
                    </div>
                </div>
                <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
                    <div class="form-group" id="item-process_type">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='61806.İşlem Tipi'></label>
                        <div class="col col-8 col-xs-12">
                            <select name="process_type" id="process_type" onchange="setRelation('', '')">
                                <option value="<cfset writeOutput(plevne_process_types.EXPRESSION)>">Expression</option>
                                <option value="<cfset writeOutput(plevne_process_types.INTERCEPTOR)>">Interceptor</option>
                            </select>
                        </div>
                    </div>
                </div>
                <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="4" sort="true">
                    <div class="form-group" id="item-process_title">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='35377.İşlem Adı'></label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <input type="hidden" name="relation_id" id="relation_id" value="">
                                <input type="text" name="process_title" id="process_title" value="" readonly required>
                                <span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('index.cfm?fuseaction=plevne.popup_relations&type='+document.getElementById('process_type').value+'&kind='+document.getElementById('process_kind').value)">
                            </div>
                        </div>
                    </div>
                </div>
            </cf_box_elements>
            <cf_box_footer>
                <cf_workcube_buttons is_upd='0' add_function='kontrol()'>
            </cf_box_footer>
        </cfform>
    </cf_box>
</div>
<script type="text/javascript">
    function setRelation(id, text) {
        document.getElementById("relation_id").value = id;
        document.getElementById("process_title").value = text;
    }
    function kontrol() {
        return document.getElementById("add_form").checkValidity();
    }
</script>