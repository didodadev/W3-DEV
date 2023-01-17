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
<cfset proIdList = valueList(get_project.project_id)>
<cfset get_process_types = getComponentSer.get_process_types(faction:'project.works')>
<cfset company_cmp = createObject("component","V16.member.cfc.member_company")> 
<cfset get_emp = company_cmp.GET_PARTS_EMPS(cpid: session.pp.COMPANY_ID,proid:len("proIdList") ? proIdList : "")>
<cfset upd_work = getComponent.det_work(id : attributes.work_id,company_control: 0)>
<cfset work_detail_first = getComponent.GET_WORK_FIRST_DETAIL(id : attributes.work_id)>
<cfif upd_work.recordcount>
    <cfset sdate=len(upd_work.target_start)?date_add("h",session.pp.time_zone,upd_work.target_start):upd_work.target_start>
    <cfset fdate=len(upd_work.target_finish)?date_add("h",session.pp.time_zone,upd_work.target_finish):upd_work.target_finish>
    <cfset shour=len(sdate)?datepart("h",sdate):0>
    <cfset fhour=len(fdate)?datepart("h",fdate):0>
    <cfset saat=0>
    <cfset dak=0>
    <cfform name="add_work" method="post">
        <cfinput type="hidden" name="session_base" id="session_base" value="#session_base.our_company_id#">
        <cfinput type="hidden" name="work_id" id="work_id" value="#attributes.work_id#">
        <input type="hidden" name="g_service_id" id="g_service_id" value="<cfif isDefined('attributes.g_service_id')><cfoutput>#attributes.g_service_id#</cfoutput></cfif>">
        <div class="ui-scroll">
            <cfoutput query = "upd_work">
                <cfset get_work_cat = getComponent.GET_WORK_CAT()>
                <cfif isdefined('upd_work.estimated_time') and len(upd_work.estimated_time)>
                    <cfset liste=upd_work.estimated_time/60>
                    <cfset saat=listfirst(liste,'.')>
                    <cfset dak=upd_work.estimated_time-saat*60>
                </cfif>
                <div class="row">
                    <div class="col-md-12">
                        <div class="form-group">
                            <label class="font-weight-bold"><cf_get_lang dictionary_id='58820.Title'></label>
                            <input type="text" class="form-control"  name="work_head" id="work_head" required="Yes" value="#work_head#">
                        </div>
                    </div>
                </div> 
                <div class="form-row mb-3"> 
                    <div class="form-group col-sm-12 col-md-12 col-lg-6 col-xl-4">
                        <label class="font-weight-bold"><cf_get_lang dictionary_id='57486.Category'></label>
                        <select class="form-control" id="pro_work_cat" name="pro_work_cat" required>
                        <option value="" selected="selected"><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                            <cfloop query="get_work_cat">
                                <option value="#work_cat_id#"<cfif work_cat_id eq upd_work.work_cat_id>selected</cfif>>#work_cat#</option>
                            </cfloop>
                        </select>
                    </div>
                    <div class="form-group col-sm-12 col-md-12 col-lg-6 col-xl-4">
                        <label class="font-weight-bold"><cf_get_lang dictionary_id='58054.Süreç - Aşama'></label>
                        <select id="process_stage" name="process_stage" class="form-control" required>
                            <option value="" selected><cf_get_lang dictionary_id='57734.Please Select'></option>
                            <cfloop query="get_process_types">
                                <option value="#process_row_id#" <cfif upd_work.work_currency_id eq process_row_id>selected</cfif>>#stage#</option>
                            </cfloop>
                        </select>
                    </div>
                    <div class="form-group col-sm-12 col-md-12 col-lg-6 col-xl-4">
                        <label class="font-weight-bold"><cf_get_lang dictionary_id='57416.Project'></label>
                        <select class="form-control" id="project_id" name="project_id"  required="Yes">
                            <option value="" selected="selected"><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                            <cfloop query="get_project">
                                <option value="#project_id#" <cfif upd_work.project_id eq project_id>selected</cfif>>#project_head#</option>
                            </cfloop>
                        </select>
                    </div>            
                </div>           
                <div class="row mb-3">
                    <div class="col-md-12">
                        <label class="font-weight-bold"><cf_get_lang dictionary_id='57771.Detail'></label>
                        <input type="hidden" name="first_work_detail" id="first_work_detail" value="#work_detail_first.history_id#">
                        <textarea class="inputStyle" id="work_detail" name="work_detail" >#work_detail_first.work_detail#</textarea>
                    </div>
                </div>         
                <div class="form-row mb-3">     
                    <div class="form-group col-12 col-sm-8 col-md-6 col-lg-4">
                    <label class="font-weight-bold"><cf_get_lang dictionary_id='57569.Staff'></label>
                    <cfset resp_id = "">
                    <cfif len(upd_work.project_emp_id)>
                        <cfset resp_id = upd_work.project_emp_id>
                    <cfelseif len(upd_work.OUTSRC_PARTNER_ID)>
                        <cfset resp_id =upd_work.OUTSRC_PARTNER_ID>
                    </cfif>      
                    <select class="form-control" id="work_emp_id" name="work_emp_id">
                        <option value="" selected="selected"><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                        <cfloop query="get_emp">
                            <option value="#ID_CE#_#TYPE#" <cfif resp_id eq ID_CE>selected</cfif>>#name_surname#</option>
                        </cfloop>
                    </select>
                    </div>
                    <div class="form-group col-12 col-sm-6 col-md-6 col-lg-4 ">
                        <label class="font-weight-bold"><cf_get_lang dictionary_id='36798.Termin'></label>
                        <input type="date" id="terminate_date" name="terminate_date"  required="Yes" class="form-control" value="#dateformat(terminate_date,'dd.mm.yyyy')#">
                    </div>
                    <div class="form-group col-9 col-sm-6 col-md-3 col-lg-3 ">
                        <label class="font-weight-bold"><cf_get_lang dictionary_id='38176.Estimated Duration'></label>
                        <div class="form-row">
                            <div class="col-6 ">
                                <input type="text" id="estimated_time" name="estimated_time" class="form-control"  value="#saat#">
                            </div>
                            <div class="col-6">
                                <input type="text" class="form-control" name="estimated_time_minute" id="estimated_time_minute"  value="#dak#">
                            </div>
                        </div>
                    </div>                 
                </div>
            </cfoutput>
        </div>
        <div class="draggable-footer">
            <cf_workcube_buttons is_upd="1" is_delete="0" data_action="/V16/project/cfc/get_work:upd_work" next_page="#site_language_path#/taskdetail?wid=">
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
<cfelse>
    <table border="0" cellspacing="0" cellpadding="0" style="width:100%">
        <tr class="color-row" style="height:20px;">
                <td colspan="9"><cf_get_lang_main no='72.kayıt yok'></td>
        </tr>
    </table>
</cfif>
    