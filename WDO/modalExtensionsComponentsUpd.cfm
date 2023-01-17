<cfparam name="caller.lang_array_main" default="">
<cf_get_lang_set_main>
<cfset getComponent = createObject('component','WDO.development.cfc.extensions')>
<cfset get_component = getComponent.get_component(component_id:attributes.component_id)>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box title="Component: #get_component.WRK_COMPONENT_NAME#" closable="1" draggable="1">
        <cfform name="upd_comp" action="#request.self#?fuseaction=dev.emptypopup_upd_extensions&is_upd_comp=1" method="post">
            <input type="hidden" name="is_comp" id="is_comp" value="1">
            <input type="hidden" name="component_id" id="component_id" value="<cfoutput>#attributes.component_id#</cfoutput>">
            <cf_box_elements vertical="1">
                <cfoutput query="get_component">
                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12" index="1" type="column" sort="true">
                        <div class="form-group" id="item-number">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58577.Line'> * </label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <input type="text" id="number" name="number" value="#WORKING_NUMBER#" required onKeyUp="isNumber(this)">
                            </div>
                        </div>
                        <div class="form-group" id="item-component-name">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12">Name *</label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <input type="text" id="component_name" name="component_name" value="#WRK_COMPONENT_NAME#" required>
                            </div>
                        </div>
                        <div class="form-group" id="item-file-path">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12">File Path *</label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <input type="text" id="file_path" name="file_path" value="#COMPONENT_FILE_PATH#" required>
                            </div>
                        </div>
                        <div class="form-group" id="item-place">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12">Place *</label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <select id="place" name="place" required>
                                    <option value=""><cf_get_lang dictionary_id='57734.Please Select'></option>
                                        <option value="1" <cfif WORKING_PLACE eq 1>selected</cfif>>Display</option>
                                        <option value="2" <cfif WORKING_PLACE eq 2>selected</cfif>>Action</option>
                                </select>
                            </div>
                        </div> 
                        <div class="form-group" id="item-action">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12">Action *</label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <select id="action" name="action" required>
                                    <option value=""><cf_get_lang dictionary_id='57734.Please Select'></option>
                                        <option value="1" <cfif WORKING_ACTION eq 1>selected</cfif>>Before</option>
                                        <option value="2" <cfif WORKING_ACTION eq 2>selected</cfif>>After</option>
                                </select>
                            </div>
                        </div>

                        <div class="form-group" id="item-detail">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12">Detail</label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <textarea id="component_detail" name="component_detail">#WRK_COMPONENT_DETAIL#</textarea>
                            </div>
                        </div>
                    </div>
                    <div class="col col-4 col-md-4 col-sm-4 col-xs-12" index="2" type="column" sort="true">
                        <div class="form-group" id="item-active">
                            <label class="col col-12 col-md-12 col-sm-12 col-xs-12">
                                Active
                                <input type="checkbox" id="is_active" name="is_active" <cfif is_active eq 1>checked</cfif>>
                            </label>
                        </div>
                        <div class="form-group" id="item-events">
                            <label class="col col-12 col-md-12 col-sm-12 col-xs-12 bold">
                                Events
                            </label>
                            <label class="col col-12 col-md-12 col-sm-12 col-xs-12">
                                Add
                                <input type="checkbox" id="is_add" name="is_add" <cfif is_add_work eq 1>checked</cfif>>
                            </label>
                            <label class="col col-12 col-md-12 col-sm-12 col-xs-12">
                                Upd
                                <input type="checkbox" id="is_upd" name="is_upd" <cfif is_upd_work eq 1>checked</cfif>>
                            </label>
                            <label class="col col-12 col-md-12 col-sm-12 col-xs-12">
                                Det
                                <input type="checkbox" id="is_det" name="is_det" <cfif is_det_work eq 1>checked</cfif>>
                            </label>
                            <label class="col col-12 col-md-12 col-sm-12 col-xs-12">
                                List
                                <input type="checkbox" id="is_list" name="is_list" <cfif is_list_work eq 1>checked</cfif>>
                            </label>
                            <label class="col col-12 col-md-12 col-sm-12 col-xs-12">
                                Info
                                <input type="checkbox" id="is_info" name="is_info" <cfif is_info_work eq 1>checked</cfif>>
                            </label>
                            <label class="col col-12 col-md-12 col-sm-12 col-xs-12">
                                Dashboard
                                <input type="checkbox" id="is_dash" name="is_dash" <cfif is_dashboard_work eq 1>checked</cfif>>
                            </label>
                            <label class="col col-12 col-md-12 col-sm-12 col-xs-12">
                                Del
                                <input type="checkbox" id="is_del" name="is_del" <cfif is_del_work eq 1>checked</cfif>>
                            </label>
                        </div>
                    </div>
                </cfoutput>
            </cf_box_elements>
            <cf_box_footer>
                <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                    <cf_record_info query_name="get_component">
                </div>
                <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                    <cf_workcube_buttons is_upd='1' is_delete='0' add_function="control()">
                </div>                
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