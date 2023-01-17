<cfinclude template="../query/get_general_budget.cfm">
<cfquery name="GET_BUDGET_PLAN" datasource="#dsn#">
	SELECT BUDGET_PLAN_ID FROM BUDGET_PLAN WHERE BUDGET_ID = #attributes.budget_id#
</cfquery>
<cfquery name="get_our_company" datasource="#dsn#">
	SELECT DISTINCT
		OC.COMP_ID,
		OC.COMPANY_NAME
	FROM 
		SETUP_PERIOD SP,
		OUR_COMPANY OC
	WHERE
		SP.OUR_COMPANY_ID = OC.COMP_ID AND
		SP.PERIOD_ID IN (SELECT 
							EPP.PERIOD_ID
						FROM
							EMPLOYEE_POSITIONS EP,
							EMPLOYEE_POSITION_PERIODS EPP
						WHERE
							EP.POSITION_ID = EPP.POSITION_ID AND
							EP.POSITION_CODE = #session.ep.position_code#)
	ORDER BY
		OC.COMPANY_NAME
</cfquery>

<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
<cfsavecontent variable="message"><cf_get_lang dictionary_id='57964.Hedefler'></cfsavecontent>
<cf_box title="#message#" closable="0">
<cfoutput>
    <cfform name="upd_budget" method="post" action="#request.self#?fuseaction=budget.emptypopup_upd_budget">
        <cf_box_elements>
            <input type="hidden" name="budget_id" id="budget_id" value="#attributes.budget_id#">
            <div class="col col-6 col-md-4 col-sm-12 column" id="column-1">
                <div class="form-group" id="item1">
                    <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57559.Bütçe'>*</label>
                    <div class="col col-8 col-sm-12">
                        <input type="text" name="budget_name" id="budget_name"  value="#get_budget_detail.budget_name#"  required="yes"  maxlength="100">
                    </div>
                </div>
                <div class="form-group" id="item2">
                    <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57574.Şirket'>*</label>
                    <div class="col col-8 col-sm-12">
                        <select name="search_company" id="search_company" style="width:150px;">
                            <option value=""><cf_get_lang dictionary_id='57574.Şirket'></option>						
                            <cfloop query="get_our_company">
                                <option value="#comp_id#" <cfif get_budget_detail.our_company_id eq comp_id>selected</cfif>>#company_name#</option>
                            </cfloop>
                        </select>
                    </div>
                </div>
                <div class="form-group" id="item3">
                    <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='58455.Yıl'> / <cf_get_lang dictionary_id='58472.Dönem'>*</label>
                    <div class="col col-8 col-sm-12">
                        <select name="search_year" id="search_year" style="width:150px;">
                            <option value=""><cf_get_lang dictionary_id='58472.Dönem'></option>
                            <cfloop from="#evaluate(session.ep.period_year-1)#" to="#evaluate(session.ep.period_year+4)#" index="k">
                                <cfoutput><option value="#k#" <cfif get_budget_detail.period_year eq k>selected</cfif>>#k#</option></cfoutput>					
                            </cfloop>
                        </select>
                    </div>
                </div>
                <div class="form-group" id="item4">
                    <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id="58859.Süreç">*</label>
                    <div class="col col-8 col-sm-12">
                        <cf_workcube_process is_upd='0' select_value='#get_budget_detail.budget_stage#' is_detail='1'>
                    </div>
                </div>
                <div class="form-group" id="item-process_cat">
                    <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57453.Şube'></label>
                    <div class="col col-8 col-sm-12">
                        <div class="input-group">
                            <cfif len(GET_BUDGET_DETAIL.BRANCH_ID)>
                                <cfquery name="GET_BRANCHES" datasource="#dsn#">
                                    SELECT BRANCH_NAME FROM BRANCH WHERE BRANCH_ID = #GET_BUDGET_DETAIL.BRANCH_ID#
                                </cfquery>
                                <input type="hidden" name="branch_id" id="branch_id" value="<cfoutput>#GET_BUDGET_DETAIL.BRANCH_ID#</cfoutput>">
                                <input name="branch_name" id="branch_name" type="text" style="width:150px;" value="<cfoutput>#GET_BRANCHES.BRANCH_NAME#</cfoutput>">
                            <cfelse>
                                <input type="hidden" name="branch_id" id="branch_id" value="">
                                <input name="branch_name" id="branch_name" type="text" style="width:150px;" value="">
                            </cfif>					
                            <span class="input-group-addon btnPointer icon-ellipsis"  onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_branches&field_branch_id=upd_budget.branch_id&field_branch_name=upd_budget.branch_name</cfoutput>','list');"></span>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col col-6 col-md-4 col-sm-12 column" id="column-2">
                <div class="form-group" id="item-process_cat">
                    <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57572.Departman'></label>
                    <div class="col col-8 col-sm-12">
                        <div class="input-group">
                            <cfif len(GET_BUDGET_DETAIL.DEPARTMENT_ID)>
                                <cfquery name="GET_DEPARTMENT" datasource="#dsn#">
                                    SELECT DEPARTMENT_HEAD FROM DEPARTMENT WHERE DEPARTMENT_ID = #GET_BUDGET_DETAIL.DEPARTMENT_ID#
                                </cfquery>
                                <input type="hidden" name="department_id" id="department_id" value="<cfoutput>#GET_BUDGET_DETAIL.DEPARTMENT_ID#</cfoutput>">
                                <input type="text" name="department" id="department" style="width:150px;" value="<cfoutput>#GET_DEPARTMENT.DEPARTMENT_HEAD#</cfoutput>">
                            <cfelse>
                                <input type="hidden" name="department_id" id="department_id" value="">
                                <input type="text"  name="department"  id="department" style="width:150px;" value="">
                            </cfif>
                            <span class="input-group-addon btnPointer icon-ellipsis"  onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_departments&field_id=upd_budget.department_id' +'&field_name=upd_budget.department','list');"></span>
                        </div>
                    </div>
                </div>
                <div class="form-group" id="item-process_cat">
                    <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='58140.İş Grubu'></label>
                    <div class="col col-8 col-sm-12">
                        <cfquery name="GET_WORKGROUPS" datasource="#dsn#">
                            SELECT WORKGROUP_ID,WORKGROUP_NAME FROM WORK_GROUP WHERE STATUS = 1 AND IS_BUDGET = 1 ORDER BY WORKGROUP_ID
                        </cfquery>				
                        <select name="workgroup_id" id="workgroup_id" style="width:150px;">
                            <option value=""><cf_get_lang dictionary_id='58140.İş Grubu'></option>
                            <cfloop query="get_workgroups">
                                <option value="#workgroup_id#" <cfif GET_BUDGET_DETAIL.WORKGROUP_ID eq workgroup_id>selected</cfif>>#WORKGROUP_NAME#</option>
                            </cfloop>
                        </select>
                    </div>
                </div>
                <div class="form-group" id="item-process_cat">
                    <cfif isDefined("attributes.project_id")><input type="hidden" name="is_project_info" id="is_project_info"></cfif>
                    <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57416.Proje'></label>
                    <div class="col col-8 col-sm-12">
                        <div class="input-group">
                            <cfif len(GET_BUDGET_DETAIL.PROJECT_ID)>
                                <cfquery name="GET_PROJECT" datasource="#dsn#" >
                                    SELECT PROJECT_HEAD FROM PRO_PROJECTS WHERE PROJECT_ID=#GET_BUDGET_DETAIL.PROJECT_ID#
                                </cfquery>
                                <input type="hidden" name="project_id" id="project_id" value="<cfoutput>#GET_BUDGET_DETAIL.PROJECT_ID#</cfoutput>">
                                <input type="text" name="project_head" id="project_head" style="width:150px;" value="<cfoutput>#GET_PROJECT.PROJECT_HEAD#</cfoutput>">
                            <cfelse>
                                <input type="hidden" name="project_id" id="project_id" value="">
                                <input type="text" name="project_head" id="project_head" style="width:150px;" value="">
                            </cfif>
                            <span class="input-group-addon btnPointer icon-ellipsis"  onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_projects&project_head=upd_budget.project_head&project_id=upd_budget.project_id');return false;"></span>
                        </div>
                    </div>
                </div>
                <div class="form-group" id="item-process_cat">
                    <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
                    <div class="col col-8 col-sm-12">
                        <textarea  name="detail" id="detail"><cfoutput>#GET_BUDGET_DETAIL.DETAIL#</cfoutput></textarea>
                    </div>
                </div>
            </div>
        </cf_box_elements>
        <cf_box_footer>
            <div class="col col-6 col-xs-6">
                <cf_record_info query_name="GET_BUDGET_DETAIL">
            </div>
            <div class="col col-6 col-xs-6">
                <cfif get_budget_plan.recordcount><!--- bütçe gelir gider fişi kaydedilmişse bütçe silinemez! --->
                <cf_workcube_buttons is_upd='1' add_function="kontrol()" is_delete=false>
            <cfelse>
                <cf_workcube_buttons is_upd='1' add_function="kontrol()" delete_page_url='#request.self#?fuseaction=budget.emptypopup_del_budget&budget_id=#attributes.budget_id#'>
            </cfif>
            </div>
        </cf_box_footer>
    </cfform>
</cfoutput>

</cf_box>
</div>
<script type="text/javascript">
function kontrol()
{
	if (document.upd_budget.search_company.value == "")
	{ 
		alert("<cf_get_lang dictionary_id='49134.Şirket Seçiniz'>");
		return false;
	}
	if (document.upd_budget.search_year.value == "")
	{ 
		alert("<cf_get_lang dictionary_id='49186.Dönem Girmelisiniz'>");
		return false;
	}
	return process_cat_control();
}
</script>
