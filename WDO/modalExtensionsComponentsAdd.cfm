<cfparam name="caller.lang_array_main" default="">
<cf_get_lang_set_main>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box title="Components Ekle" closable="1" draggable="1">
        <cfform name="add_comp" action="#request.self#?fuseaction=dev.emptypopup_upd_extensions&is_add_comp=1" method="post">
            <input type="hidden" name="extension_id" id="extension_id" value="<cfoutput>#attributes.extensions_id#</cfoutput>">
            <input type="hidden" name="is_comp" id="is_comp" value="1">
            <cf_box_elements vertical="1">
                <div class="col col-8 col-md-8 col-sm-8 col-xs-12" index="1" type="column" sort="true">
                    <div class="form-group" id="item-number">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58577.Line'>*</label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <input type="text" id="number" name="number" value="" onKeyUp="isNumber(this)" required>
                        </div>
                    </div>
                    <div class="form-group" id="item-component-name">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12">Name *</label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <input type="text" id="component_name" name="component_name" value="" required>
                        </div>
                    </div>
                    <div class="form-group" id="item-file-path">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12">File Path *</label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <input type="text" id="file_path" name="file_path" value="" required>
                        </div>
                    </div>
                    <div class="form-group" id="item-place">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12">Place *</label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <select id="place" name="place" required>
                                <option value=""><cf_get_lang dictionary_id='57734.Please Select'></option>
                                    <option value="1">Display</option>
                                    <option value="2">Action</option>
                            </select>
                        </div>
                    </div> 
                    <div class="form-group" id="item-action">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12">Action</label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <select id="action" name="action" required>
                                <option value=""><cf_get_lang dictionary_id='57734.Please Select'></option>
                                    <option value="1">Before</option>
                                    <option value="2">After</option>
                            </select>
                        </div>
                    </div>

                    <div class="form-group" id="item-detail">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12">Detail</label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <textarea id="component_detail" name="component_detail"></textarea>
                        </div>
                    </div>
                </div>
                <div class="col col-4 col-md-4 col-sm-4 col-xs-12" index="2" type="column" sort="true">
                    <div class="form-group" id="item-active">
                        <label class="col col-12 col-md-12 col-sm-12 col-xs-12">
                            Active
                            <input type="checkbox" id="is_active" name="is_active" value="">
                        </label>
                    </div>
                    <div class="form-group" id="item-events">
                        <label class="col col-12 col-md-12 col-sm-12 col-xs-12 bold">
                            Events
                        </label>
                        <label class="col col-12 col-md-12 col-sm-12 col-xs-12">
                            Add
                            <input type="checkbox" id="is_add" name="is_add">
                        </label>
                        <label class="col col-12 col-md-12 col-sm-12 col-xs-12">
                            Upd
                            <input type="checkbox" id="upd" name="upd">
                        </label><label class="col col-12 col-md-12 col-sm-12 col-xs-12">
                            Det
                            <input type="checkbox" id="is_det" name="is_det">
                        </label>
                        <label class="col col-12 col-md-12 col-sm-12 col-xs-12">
                            List
                            <input type="checkbox" id="is_list" name="is_list">
                        </label>
                        <label class="col col-12 col-md-12 col-sm-12 col-xs-12">
                            Info
                            <input type="checkbox" id="is_info" name="is_info">
                        </label>
                        <label class="col col-12 col-md-12 col-sm-12 col-xs-12">
                            Dashboard
                            <input type="checkbox" id="is_dash" name="is_dash">
                        </label>
                        <label class="col col-12 col-md-12 col-sm-12 col-xs-12">
                            Del
                            <input type="checkbox" id="is_del" name="is_del">
                        </label>
                    </div>
                </div>
            </cf_box_elements>
            <cf_box_footer>
                <cf_workcube_buttons add_function="control()">
            </cf_box_footer>
        </cfform>
    </cf_box>
</div>
<script>
    function control(){
        if($('#number').val() =='' || $('#component_name').val() =='' || $('#file_path').val() =='' || $('#action').val() =='' || $('#place').val() ==''){
            alert('<cf_get_lang dictionary_id='29722.Please fill in the mandatory fields.'>!');
            return false;
        }
    }
</script>