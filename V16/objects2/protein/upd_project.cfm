<cfscript>
	CreateCompenent = createObject("component", "/V16/workdata/get_branches");
	get_branches = CreateCompenent.get_branches_fnc(is_comp_branch : 1, is_pos_branch: 1);
    getComponent = createObject("component", "V16/project/cfc/projectData");
	GET_DEPARTMENT_NAME = getComponent.GET_DEPARTMENT_NAME();
	get_special_def = getComponent.GET_SPECIAL_DEF();
</cfscript>
<cfset getComponent_1 = createObject('component','V16.project.cfc.get_work')>
<cfset get_workgroups = getComponent_1.GET_WORKGROUPS()>
<cfset get_emp = getComponent_1.GET_POSITIONS(our_cid : session_base.our_company_id)>
<cfset get_project = getComponent.PROJECT_DETAIL(id : attributes.project_id)>

<cfquery name="GET_SALE_ZONES" datasource="#DSN#">
	SELECT SZ_ID,SZ_NAME FROM SALES_ZONES WHERE IS_ACTIVE = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
</cfquery>
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
<cfform name="add_pro_com" method="post">
    <cfinput type="hidden" name="session_base" id="session_base" value="#session_base.our_company_id#">
    <cfinput type="hidden" name="money_base" id="money_base" value="#session_base.money#">
    <cfinput type="hidden" name="project_id" id="project_id" value="#attributes.project_id#">
    <div class="row ui-scroll">
        <div class="col-lg-12 col-xl-7">
            <div class="row">
                <div class="col-md-12">
                    <div class="form-group">
                        <label class="font-weight-bold"><cf_get_lang dictionary_id='58820.Title'></label>
                        <cfinput type="text" class="form-control"  name="project_head" id="PROJECT_HEAD" value="#get_project.project_head#" required="Yes">
                    </div>
                </div>
            </div>
            <div class="row mb-5">
                <div class="col-md-12">
                    <label class="font-weight-bold"><cf_get_lang dictionary_id='57771.Detail'></label>
                        <textarea class="form-control" id="project_detail" name="project_detail">
                        <cfoutput>
                            #get_project.project_detail#
                        </cfoutput>
                    </textarea>
                </div>
            </div>
        </div>
        <div class="col-lg-12 col-xl-5">
            <div class="form-row mb-3">
                <div class="col-4 col-sm-4 col-md-4 col-lg-4 col-xl-4 font-weight-bold"><cf_get_lang dictionary_id='57493.Active'></div>
                <div class="col-8 col-sm-8 col-md-8 col-lg-8 col-xl-8">
                    <label class="checkbox-container font-weight-bold">
                        <input type="checkbox" value="1" name="project_status" <cfif get_project.project_status eq 1>checked</cfif>>
                        <span class="checkmark"></span>
                        </label>    
                </div>
            </div>
            <div class="form-row mb-3">
                <div class="col-12 col-sm-4 col-md-4 col-lg-4 col-xl-4 font-weight-bold"><cf_get_lang dictionary_id='57486.Category'></div>
                <div class="col-12 col-sm-6 col-md-6 col-lg-6 col-xl-8">
                    <cf_workcube_main_process_cat fuseaction="project.projects" main_process_cat="#get_project.PROCESS_CAT#">
                </div>
            </div>
            <div class="form-row mb-3">
                <div class="col-12 col-sm-4 col-md-4 col-lg-4 col-xl-4 font-weight-bold"><cf_get_lang dictionary_id='57482.Stage'></div>
                <div class="col-12 col-sm-6 col-md-6 col-lg-6 col-xl-8">
                    <cf_workcube_process is_upd='0' is_detail='1' select_value="#get_project.PRO_CURRENCY_ID#" >
                </div>
            </div>
            <div class="form-row mb-3">
                <div class="col-12 col-sm-4 col-md-4 col-lg-4 col-xl-4 font-weight-bold"><cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></div>
                    <div class="col-8 col-sm-6 col-md-4 col-lg-4 col-xl-4">
                        <div class="input-group">
                            <input type="text" name="target_start" id="target_start" class="form-control" value="<cfoutput>#dateformat(get_project.target_start,'dd/mm/yyyy')#</cfoutput>">
                            <div class="input-group-append">
                                <span class="input-group-text"><cf_wrk_date_image date_field="target_start"> </span>
                            </div>	
                        </div>
                    </div>
                    <div class="col-4 col-sm-2 col-md-2 col-lg-2 col-xl-2">
                        <input type="number" name="start_hour" class="form-control" value="<cfoutput>#Timeformat(get_project.target_start,"HH")#</cfoutput>" min="0" max="23">
                    </div>   
                    <div class="col-4 col-sm-2 col-md-2 col-lg-2 col-xl-2">
                        <input type="number" name="start_min" class="form-control" value="<cfoutput>#Timeformat(get_project.target_start,"mm")#</cfoutput>" min="0" max="60">
                    </div>    
            </div>
            <div class="form-row mb-3">
                <div class="col-12 col-sm-4 col-md-4 col-lg-4 col-xl-4 font-weight-bold"><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></div>
                <div class="col-8 col-sm-6 col-md-4 col-lg-4 col-xl-4">
                    <div class="input-group">
                        <input type="text" name="target_finish" id="target_finish" class="form-control" value="<cfoutput>#dateformat(get_project.target_finish,'dd/mm/yyyy')#</cfoutput>">
                        <div class="input-group-append">
                            <span class="input-group-text"><cf_wrk_date_image date_field="target_finish"> </span>
                        </div>	
                    </div>
                </div>
                <div class="col-2 col-sm-2 col-md-2 col-lg-2 col-xl-2">
                    <cfinput type="number" name="finish_hour" class="form-control" value="#timeformat(get_project.target_finish,"HH")#" min="0" max="23">
                </div>         
                <div class="col-2 col-sm-2 col-md-2 col-lg-2 col-xl-2">
                    <cfinput type="number" name="finish_min" class="form-control" value="#timeformat(get_project.target_finish,"mm")#" min="0" max="60">
                </div>           
            </div>
            <div class="form-row mb-3">
                <div class="col-12 col-md-4 col-sm-4 col-lg-4 col-xl-4 font-weight-bold"><cf_get_lang dictionary_id='57569.Görevli'></div>
                <div class="col-12 col-md-6 col-sm-6 col-lg-6 col-xl-8">
                    <select class="form-control" id="project_emp_id" name="project_emp_id">
                        <option value="" selected="selected"><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                        <cfoutput query="get_emp">
                            <option value="#employee_id#" <cfif isDefined('get_project.project_emp_id') and get_project.project_emp_id eq employee_id>selected</cfif>>#employee_name# #employee_surname#</option>
                        </cfoutput>
                    </select>
                </div>
            </div>
        </div>
    </div>
    <div class="draggable-footer">
        <cf_workcube_buttons is_upd="1" is_delete="0" data_action="/V16/project/cfc/projectData:upd_project" next_page="#site_language_path#/projectDetail?id=">
    </div>
</cfform>
<script>
     ClassicEditor
        .create( document.querySelector( '#project_detail' ) )
        .then( editor => {
            console.log( 'Editor was initialized', editor );
            myEditor = editor;
        } )
        .catch( err => {
            console.error( err.stack );
        } );
    function LoadDepLoc(branch_id,field_select_object)
	{
		var district_len = eval("document.all." + field_select_object + ".options.length");
		for(j=district_len;j>=0;j--)
			eval("document.all." + field_select_object).options[j] = null;
		//Ilçe secili degilse
		if(branch_id != '')
		{
			var deger = workdata('get_department_location_id',branch_id);
			//alert(deger);
			eval("document.all." + field_select_object).options[0]=new Option('Seçiniz','');
			for(var jj=0;jj < deger.recordcount;jj++)
			{
				eval("document.all." + field_select_object).options[jj+1]=new Option(deger.DEPARTMENT_NAME[jj],deger.DEPARTMENT_ID[jj]+'-'+deger.LOCATION_ID[jj]);
			}
		}
		else
		{
			eval("document.all." + field_select_object).options[0]=new Option('Seçiniz','');
		}
    }

    $('.portBox .portHeadLightTitle span a').prepend(
        $('<i>')
        .addClass('far fa-life-ring')       
    );        
</script>