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
							EP.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)
	ORDER BY
		OC.COMPANY_NAME
</cfquery>
<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
<cfsavecontent variable="head"><cf_get_lang dictionary_id='52288.Bütçe Ekle'></cfsavecontent>
<cf_box title="#head#" closable="0">
        <cfform name="add_budget" method="post" action="#request.self#?fuseaction=budget.emptypopup_add_budget">
            <cfoutput>
                <cf_box_elements>
                    <div class="col col-6 col-md-4 col-sm-12 column" id="column-1">
                        <div class="form-group" id="item-budget_name">
                            <label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang dictionary_id='57559.Bütçe'>*</label>
                            <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
                                <input type="text" name="budget_name" id="budget_name" required="yes" maxlength="100">
                            </div>
                        </div>
                        <div class="form-group" id="item-search_company">
                            <label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang dictionary_id='57574.Şirket'>*</label>
                            <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
                                <select name="search_company" id="search_company">
                                    <option value=""><cf_get_lang dictionary_id='57574.Şirket'></option>						
                                    <cfloop query="get_our_company">
                                        <option value="#comp_id#" <cfif session.ep.company_id eq comp_id>selected</cfif>>#company_name#</option>
                                    </cfloop>
                                </select>
                            </div>
                        </div>
                        <div class="form-group" id="item-search_year">
                            <label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang dictionary_id='58455.Yıl'> / <cf_get_lang dictionary_id='58472.Dönem'>*</label>
                            <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
                                <select name="search_year" id="search_year">
                                    <option value=""><cf_get_lang dictionary_id='58472.Dönem'></option>		
                                    <cfloop from="#evaluate(session.ep.period_year-1)#" to="#evaluate(session.ep.period_year+4)#" index="k">
                                        <cfoutput><option value="#k#" <cfif session.ep.period_year eq k>selected</cfif>>#k#</option></cfoutput>					
                                    </cfloop>
                                </select>
                            </div>
                        </div>
                        <div class="form-group" id="item-process">
                            <label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang dictionary_id="58859.Süreç">*</label>
                            <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
                                <cf_workcube_process is_upd='0' process_cat_width='150' is_detail='0'>
                            </div>
                        </div>
                        <div class="form-group" id="item-branch_id">
                            <label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang dictionary_id='57453.Şube'></label>
                            <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
                                <div class="input-group">
                                    <input type="hidden" name="branch_id" id="branch_id">
                                    <input type="text" name="branch_name" id="branch_name">
                                    <span class="input-group-addon btnPointer icon-ellipsis"  onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_branches&field_branch_id=add_budget.branch_id&field_branch_name=add_budget.branch_name</cfoutput>','list');"></span>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col col-6 col-md-4 col-sm-12 column" id="column-2">
                        <div class="form-group" id="item-department_id">
                            <label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang dictionary_id='57572.Departman'></label>
                            <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
                                <div class="input-group">
                                    <input type="hidden" name="department_id" id="department_id">
                                    <input type="text" name="department" id="department">
                                    <span class="input-group-addon btnPointer icon-ellipsis"  onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_departments&field_id=add_budget.department_id' +'&field_name=add_budget.department' ,'list')"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-workgroup_id">
                            <label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang dictionary_id='58140.İş Grubu'></label>
                            <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
                                <cfquery name="GET_WORKGROUPS" datasource="#dsn#">
                                    SELECT WORKGROUP_ID,WORKGROUP_NAME FROM WORK_GROUP WHERE STATUS = 1 AND IS_BUDGET = 1 ORDER BY WORKGROUP_ID
                                </cfquery>				
                                <select name="workgroup_id" id="workgroup_id">
                                    <option value=""><cf_get_lang dictionary_id='58140.İş Grubu'></option>
                                    <cfloop query="get_workgroups">
                                        <option value="#workgroup_id#">#WORKGROUP_NAME#</option>
                                    </cfloop>
                                </select>
                            </div>
                        </div>
                        <div class="form-group" id="item-project_id">
                            <cfif isDefined("attributes.project_id")><input type="hidden" name="is_project_info" id="is_project_info"></cfif>
                            <label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang dictionary_id='57416.Proje'></label>
                            <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
                                <div class="input-group">
                                    <input type="hidden" name="project_id" id="project_id" value="<cfif isDefined("attributes.project_id")>#attributes.project_id#</cfif>">
                                    <input type="text" name="project_head" id="project_head" value="<cfif isDefined("attributes.project_id")>#get_project_name(attributes.project_id)#</cfif>">
                                    <span class="input-group-addon btnPointer icon-ellipsis"  onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_projects&project_head=add_budget.project_head&project_id=add_budget.project_id');return false"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-detail">
                            <label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
                            <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
                                <textarea name="detail" id="detail"></textarea>
                            </div>
                        </div>
                    </div>
                </cf_box_elements>
                <div class="ui-form-list-btn">
                    <cf_workcube_buttons type_format="1" is_upd='0' add_function="kontrol()">
                </div>
            </cfoutput>   
        </cfform>
    </cf_box>
</div>
<script type="text/javascript">
function kontrol()
{
	if (document.add_budget.budget_name.value == "")
	{ 
		alert("<cf_get_lang dictionary_id='49168.Bütçe adını yazınız'>!");
		return false;
	}
	if (document.add_budget.search_company.value == "")
	{ 
		alert("<cf_get_lang dictionary_id='49134.Şirket Seçiniz'>");
		return false;
	}
	if (document.add_budget.search_year.value == "")
	{ 
		alert("<cf_get_lang dictionary_id='49186.Dönem Girmelisiniz'>");
		return false;
	}
	return process_cat_control();
	return true;
}
</script>
