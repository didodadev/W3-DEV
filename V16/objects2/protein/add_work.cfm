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
<cfset get_project = ProjectCmp.get_projects()>
<cfset get_work_cat = getComponent.GET_WORK_CAT()>
<cfset get_process_types = getComponentSer.get_process_types(faction:'project.works')>

<cfset proIdList = valueList(get_project.project_id)>

<cfset get_cats = getComponent.get_cats(session_base:session_base.language)>
<cfset company_cmp = createObject("component","V16.member.cfc.member_company")> 
<cfset get_emp = company_cmp.GET_PARTS_EMPS(cpid: session.pp.COMPANY_ID,proid:len("proIdList") ? proIdList : "")>

<cfform name="add_cwork" method="post">
    <cfinput type="hidden" name="session_base" id="session_base" value="#session_base.our_company_id#">
    <cfinput type="hidden" name="work_status" id="work_status" value="#session_base.our_company_id#">
    <input type="hidden" name="g_service_id" id="g_service_id" value="<cfif isDefined('attributes.g_service_id')><cfoutput>#attributes.g_service_id#</cfoutput></cfif>">
    <div class="row ui-scroll">
        <div class="col-md-12">
                <div class="form-group">
                    <label class="font-weight-bold"><cf_get_lang dictionary_id='58820.Title'></label>
                    <input type="text" class="form-control"  name="work_head" id="work_head" required="Yes">
                </div>
        </div>
        <div class="col-md-12">
            <label class="font-weight-bold"><cf_get_lang dictionary_id='57771.Detail'></label>
            <textarea class="form-control" id="work_detail" name="work_detail"></textarea>
        </div>  
    <div class="col-md-6"> 
        <div class="form-group">
        <label class="font-weight-bold"><cf_get_lang dictionary_id='57486.Category'>*</label>
        <select class="form-control" id="pro_work_cat" name="pro_work_cat">
           <option value="" selected="selected"><cf_get_lang dictionary_id='57734.Seçiniz'></option>
            <cfoutput query="get_work_cat">
                <option value="#work_cat_id#"<cfif isDefined('attributes.pro_work_cat') and attributes.pro_work_cat eq work_cat_id>selected</cfif>>#work_cat#</option>
            </cfoutput>
        </select>
        </div>

        <div class="form-group">
            <label class="font-weight-bold"><cf_get_lang dictionary_id='58054.Süreç - Aşama'>*</label>
            <select id="process_stage" name="process_stage" class="form-control">
                <option value="" selected><cf_get_lang dictionary_id='57734.Please Select'></option>
                <cfoutput query="get_process_types">
                    <option value="#process_row_id#" <cfif isdefined("attributes.process_stage") and (attributes.process_stage eq process_row_id)>selected</cfif>>#stage#</option>
                </cfoutput>
            </select>
        </div>

        <div class="form-group">
            <label class="font-weight-bold"><cf_get_lang dictionary_id='57416.Project'>*</label>
            <select class="form-control" id="project_id" name="project_id"  required="Yes">
                <option value="" selected="selected"><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                <cfoutput query="get_project">
                    <option value="#project_id#" <cfif isDefined('attributes.project_id') and attributes.project_id eq project_id>selected</cfif>>#project_head#</option>
                </cfoutput>
            </select>
        </div>            
    </div>           
           

    <div class="col-md-6">               

        <div class="form-group ">
        <label class="font-weight-bold"><cf_get_lang dictionary_id='57569.Staff'>*</label>
        <select class="form-control" id="work_emp_id" name="work_emp_id">
            <option value="" selected="selected"><cf_get_lang dictionary_id='57734.Seçiniz'></option>
            <cfoutput query="get_emp">
                <option value="#ID_CE#_#TYPE#">#name_surname#</option>
            </cfoutput>
        </select>
        </div>
        <div class="form-group">
            <label class="font-weight-bold"><cf_get_lang dictionary_id='57485.priority'></label>
            <select class="form-control" name="priority_cat" id="priority_cat" >
                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                <cfoutput query="get_cats">
                    <option value="#priority_id#">#priority#</option>
                </cfoutput>
            </select>
        </div>
        <div class="form-group">
            <label class="font-weight-bold"><cf_get_lang dictionary_id='36798.Termin'>*</label>
            <input type="date" id="terminate_date" name="terminate_date"  required="Yes" class="form-control">
        </div>
        <div class="form-group">
        <label class="font-weight-bold"><cf_get_lang dictionary_id='38176.Estimated Duration'></label>
        <div class="form-row">
            <div class="col-6 ">
                <input type="text" id="total_time_hour" name="total_time_hour" class="form-control" placeholder="Saat">
            </div>
            <div class="col-6">
                <input type="text" class="form-control" id="total_time_minute" id="total_time_minute" placeholder="Dakika" >
            </div>
        </div>
        </div>                 
    </div>
    </div>
    <div class="draggable-footer">
        <cf_workcube_buttons is_insert="1" data_action="/V16/project/cfc/get_work:add_work" next_page="#site_language_path#/taskdetail?wid=">
    </div>
</cfform>

<script>
ClassicEditor
        .create( document.querySelector( '#work_detail' ) )
        .then( editor => {
            console.log( 'Editor was initialized', editor );
            myEditor = editor;
        } )
        .catch( err => {
            console.error( err.stack );
        } );     
</script>
   