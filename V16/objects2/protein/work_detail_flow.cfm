<cfif isdefined("session.pp")>
    <cfset session_base = evaluate('session.pp')>
    <cfset session_base.period_is_integrated = 0>
<cfelseif isdefined("session.ep")>
    <cfset session_base = evaluate('session.ep')>
<cfelseif isdefined("session.cp")>
    <cfset session_base = evaluate('session.cp')>
<cfelseif isdefined("session.ww")>
    <cfset session_base = evaluate('session.ww')>
</cfif>
<cfset getComponentSer = createObject('component','V16.callcenter.cfc.call_center')>
<cfset getComponent = createObject('component','V16.project.cfc.get_work')>
<cfset ProjectCmp =createObject("component", "V16/project/cfc/projectData")>
<cfset company_cmp = createObject("component","V16.member.cfc.member_company")> 
<cfset work_detail = getComponent.DET_WORK(id : attributes.wid)>
<cfset get_project = ProjectCmp.get_projects()>
<cfset proIdList = valueList(get_project.project_id)>

<cfset get_work_cat = getComponent.GET_WORK_CAT()>
<cfset get_emp = company_cmp.GET_PARTS_EMPS(cpid : session_base.company_id,proid:len("proIdList") ? proIdList : "")>
<cfset get_process_types = getComponentSer.get_process_types(faction:'project.works')>
<cfparam name="attributes.process_stage" default="">
<cfform name="add_cwork" method="post">
    <cfinput type="hidden" name="session_base" id="session_base" value="#session_base.our_company_id#">
    <cfinput type="hidden" name="work_head" id="work_head" value="#work_detail.work_head#">
    <cfinput type="hidden" name="target_start" id="target_start" value="#work_detail.target_start#">
    <cfinput type="hidden" name="project_id" id="project_id" value="#work_detail.project_id#">
    <cfinput type="hidden" name="pro_work_cat" id="pro_work_cat" value="#work_detail.work_cat_id#">
    <cfinput type="hidden" name="work_id" id="work_id" value="#attributes.wid#">
<div class="row">
    <div class="col-md-12">
        <label class="font-weight-bold"><cf_get_lang dictionary_id='57771.Detail'></label>
        <textarea class="inputStyle" id="editor" name="work_detail"></textarea>
    </div>
</div>
<div class="form-row mt-3">
    <div class="col-md-5 col-lg-5 col-xl-3 mb-2">
        <label class="font-weight-bold"><cf_get_lang dictionary_id='57569.Staff'></label>
        <select class="form-control" id="work_emp_id" name="work_emp_id">
            <option value="" selected="selected"><cf_get_lang dictionary_id='57734.Seçiniz'></option>
            <cfoutput query="get_emp">
                <option value="#ID_CE#_#TYPE#">#NAME_SURNAME#</option>
            </cfoutput>
        </select>
    </div>
    <div class="col-md-5 col-lg-5 col-xl-3 mb-2">
        <label class="font-weight-bold"><cf_get_lang dictionary_id='58054.Process - Stage'></label>
        <cf_workcube_process is_upd="0" is_detail="0" is_select_text="1">
    </div>

    <div class="form-group col-md-4 col-lg-4 col-xl-2 mb-2">
        <label class="font-weight-bold"><cf_get_lang dictionary_id='36798.Termin'></label>
        <input type="date" id="terminate_date" name="terminate_date"  required="Yes" class="form-control">
    </div>

    <div class="form-group col-sm-4 col-md-4 col-lg-3 col-xl-2 mb-2">
        <label class="font-weight-bold"><cf_get_lang dictionary_id='34989.Harcanan Zaman'></label>
        <div class="form-row">
            <div class="col-6">
                <input type="text" id="total_time_hour" name="total_time_hour" class="form-control" placeholder="Saat">
            </div>
            <div class="col-6">
                <input type="text" id="total_time_minute" name="total_time_minute" class="form-control"  placeholder="Dk" >
            </div>
        </div>
    </div>  
    <div class="form-group col-5 col-sm-4 col-md-3 col-lg-2 col-xl-2">
        <label class="font-weight-bold"><cf_get_lang dictionary_id='34413.Tamamlanma'> %</label>
        <input type="text" class="form-control"  name="to_complate" id="to_complate">
    </div>
    <div class="form-group col-sm-2 col-md-2 col-lg-2 col-xl-1 mb-5">                
        <label class="font-weight-bold"><cf_get_lang dictionary_id='57493.Aktif'></label><br>
        <label class="checkbox-container-lg font-weight-bold mb-0">
            <cfinput type="checkbox" name="work_status" id="work_status" checked="checked"/>
            <span class="checkmark-lg"></span>
        </label>                
    </div>
</div>
<hr>
<div class="row">
    <div class="col-md-12">
        <div class="button-class float-right">
            <div class="form-row"> 
                <cf_workcube_buttons is_insert="1" data_action="/V16/project/cfc/get_work:upd_work" next_page="#site_language_path#/taskdetail?wid=#contentEncryptingandDecodingAES(isEncode:1,content:attributes.wid,accountKey:"wrk")#&project_id=" after_function="kontrol" >
            </div>   
        </div>
    </div>
</div>
</cfform>
<script>
    ClassicEditor
        .create(document.querySelector('#editor'))
        .catch(error => {
            console.error(error);
        });
</script>