<cfset ProjectCmp =createObject("component", "V16/project/cfc/projectData")>
<cfset getComponent = createObject('component','V16.callcenter.cfc.call_center')>
<cfset getComponent2 = createObject('component','V16.project.cfc.get_work')>
<cfset get_project = ProjectCmp.get_projects()>
<cfset get_subscriptions = getComponent.GET_SUBSCRIPTION()>
<cfset GET_SERVICE_APPCAT = getComponent.GET_SERVICE_APPCAT()>
<cfset get_process_types = getComponent.get_process_types(faction:'call.list_service')>
<cfset get_priority = getComponent.get_priority()>
<cfset get_emp = getComponent2.GET_POSITIONS(our_cid : session_base.our_company_id)>
<cfset company_cmp = createObject("component","V16.member.cfc.member_company")> 
<cfset GET_PARTNER = company_cmp.GET_PARTS_EMPS(cpid: session.pp.COMPANY_ID)>

<form name="addCall" method="post">
    <div class="row ui-scroll">
        <div class="col-md-7">
            <div class="row">
                <div class="col-md-12">               
                    <div class="form-group">
                        <label class="font-weight-bold"><cf_get_lang dictionary_id='58820.Title'>*</label>
                        <input type="text" id="service_head" name="service_head" class="form-control form-control-sm" placeholder="" required>
                    </div>                
                </div>
            </div>
            <div class="row mb-5">
                <div class="col-md-12">
                    <label class="font-weight-bold"><cf_get_lang dictionary_id='57771.Detail'>*</label>
                    <textarea class="inputStyle" id="editor" name="service_detail"></textarea>
                </div>
            </div>
            <div class="row">
                <div class="col-md-6">
                    <div class="form-group">
                        <label class="font-weight-bold"><cf_get_lang dictionary_id='57416.Project'>*</label>
                        <select class="form-control form-control-sm" id="project_id" name="project_id" required>
                            <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                            <cfoutput query="get_project">
                                <option value="#project_id#">#project_head#</option>
                            </cfoutput>
                        </select>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="form-group">
                        <label class="font-weight-bold"><cf_get_lang dictionary_id='58832.Subscription'>*</label>
                        <select class="form-control form-control-sm" id="subscription_id" name="subscription_id" required>
                            <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                            <cfoutput query="get_subscriptions">
                                <option value="#SUBSCRIPTION_ID#">#SUBSCRIPTION_NO# - #SUBSCRIPTION_HEAD#</option>
                            </cfoutput>
                        </select>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-lg-12 col-xl-5 mt-2">
            <div class="form-row mb-3">
                <div class="col-4 col-sm-4 col-md-4 col-lg-4 col-xl-4 font-weight-bold"><cf_get_lang dictionary_id='57493.Active'></div>
                <div class="col-8 col-sm-8 col-md-8 col-lg-8 col-xl-8">
                    <label class="checkbox-container font-weight-bold">
                        <input type="checkbox" id="is_status" name="is_status" value="1">
                        <span class="checkmark"></span>
                    </label>    
                </div>
            </div>
            <div class="form-row mb-3">
                <div class="col-12 col-sm-4 col-md-4 col-lg-4 col-xl-4 font-weight-bold"><cf_get_lang dictionary_id='57486.Category'>*</div>
                <div class="col-12 col-sm-6 col-md-6 col-lg-6 col-xl-8">
                    <select class="form-control form-control-sm" id="appcat_id" name="appcat_id" required>
                        <option value=""><cf_get_lang dictionary_id='57734.Please Select'></option>
                        <cfoutput query="GET_SERVICE_APPCAT">
                            <option value="#servicecat_id#">#servicecat#</option>
                        </cfoutput>
                    </select>
                </div>
            </div>
            <div class="form-row mb-3">
                <div class="col-12 col-sm-4 col-md-4 col-lg-4 col-xl-4 font-weight-bold"><cf_get_lang dictionary_id='57482.Stage'>*</div>
                <div class="col-12 col-sm-6 col-md-6 col-lg-6 col-xl-8">
                    <select class="form-control form-control-sm" id="process_stage" name="process_stage" required>
                        <option value=""><cf_get_lang dictionary_id='57734.Please Select'></option>
                        <cfoutput query="get_process_types">
                            <option value="#process_row_id#">#stage#</option>
                        </cfoutput>
                    </select>
                </div>
            </div>
            <div class="form-row mb-3">
                <div class="col-12 col-sm-4 col-md-4 col-lg-4 col-xl-4 font-weight-bold"><cf_get_lang dictionary_id='57485.Öncelik'>*</div>
                <div class="col-12 col-sm-6 col-md-6 col-lg-6 col-xl-8">
                    <select class="form-control form-control-sm" id="priority_id" name="priority_id" required>
                        <option value=""><cf_get_lang dictionary_id='57734.Please Select'></option>
                        <cfoutput query="get_priority">
                            <option value="#priority_id#">#priority#</option>
                        </cfoutput>
                    </select>
                </div>
            </div>
            <div class="form-row mb-3">
                <div class="col-12 col-sm-4 col-md-4 col-lg-4 col-xl-4 font-weight-bold"><cf_get_lang dictionary_id='55116.Application'>*</div>
                <div class="col-8 col-sm-4 col-md-4 col-lg-4 col-xl-5 ">
                    <input type="date" class="form-control form-control-sm" id="apply_date" name="apply_date" required>
                </div>
                <div class="col-4 col-sm-2 col-md-2 col-lg-2 col-xl-2">
                    <input type="text" class="form-control form-control-sm" placeholder="12:10" id="apply_hour" name="apply_hour" required>
                </div>                   
            </div>
            <div class="form-row mb-3">
                <div class="col-12 col-sm-4 col-md-4 col-lg-4 col-xl-4 font-weight-bold"><cf_get_lang dictionary_id='56261.Acceptance'>*</div>
                <div class="col-8 col-sm-4 col-md-4 col-lg-4 col-xl-5">
                    <input type="date" class="form-control form-control-sm" id="start_date1" name="start_date1" required>
                </div>
                <div class="col-4 col-sm-2 col-md-2 col-lg-2 col-xl-2">
                    <input type="text" class="form-control form-control-sm" id="start_hour" name="start_hour" placeholder="12:10" required>
                </div>                   
            </div>
            <div class="form-row mb-3">
                <div class="col-12 col-sm-4 col-md-4 col-lg-4 col-xl-4 font-weight-bold"><cf_get_lang dictionary_id='57502.Finish'></div>
                <div class="col-8 col-sm-4 col-md-4 col-lg-4 col-xl-5">
                    <input type="date" class="form-control form-control-sm" id="finish_date" name="finish_date">
                </div>
                <div class="col-4 col-sm-2 col-md-2 col-lg-2 col-xl-2 ">
                    <input type="text" class="form-control form-control-sm" placeholder="12:10" id="finish_hour" name="finish_hour">
                </div>                   
            </div>
            <div class="form-row mb-3">
                <div class="col-12 col-md-4 col-sm-4 col-lg-4 col-xl-4 font-weight-bold"><cf_get_lang dictionary_id='57544.Responsible'></div>
                <div class="col-12 col-md-6 col-sm-6 col-lg-6 col-xl-8">
                    <select class="form-control" id="resp_id" name="resp_id" required>
                        <option value=""><cf_get_lang dictionary_id='57734.Please Select'></option>
                        <cfoutput query="GET_PARTNER">
                            <option value="#ID_CE#_#TYPE#">#name_surname#</option>
                        </cfoutput>
                    </select>
                </div>
            </div>
        </div>
    </div>
    <div class="draggable-footer">
        <cf_workcube_buttons is_insert="1" data_action="/V16/callcenter/cfc/call_center:add_service" next_page="#site_language_path#/callDet?id=" add_function="control()" > 
    </div>
</form>


<script>
    ClassicEditor
        .create( document.querySelector( '#editor' ) )
        .then( editor => {
            console.log( 'Editor was initialized', editor );
            myEditor = editor;
        } )
        .catch( err => {
            console.error( err.stack );
        } );
    function control(){
        var service_detail_= myEditor.getData().replace(/<[^>]+>/g, '');
		if (service_detail_.length <= 10 )
		{ 
			alert ("<cf_get_lang dictionary_id='57425.uyarı'>:<cf_get_lang dictionary_id='57629.Açıklama'><cf_get_lang dictionary_id='49304.En Az 10 Karakter'>!");
			return false;
		}
    }
</script>