<cf_get_lang_set module_name="hr"><!--- sayfanin en altinda kapanisi var --->
<cfinclude template="../query/get_workgroup_uppers.cfm">
<cfif isdefined("attributes.hierarchy1_code") and len(attributes.hierarchy1_code)>
	<cfquery name="GET_UPPER_GROUP_INFO" datasource="#DSN#">
		SELECT 
        	WORKGROUP_ID, 
            WORKGROUP_NAME, 
            GOAL, 
            ONLINE_HELP, 
            ONLINE_SALES, 
            COMPANY_ID, 
            PROJECT_ID, 
            STATUS, 
            HIERARCHY, 
            UPPER_WORKGROUP_ID, 
            WORKGROUP_TYPE_ID, 
            IS_ORG_VIEW, 
            MANAGER_ROLE_HEAD, 
            MANAGER_EMP_ID, 
            DEPARTMENT_ID, 
            BRANCH_ID, 
            OUR_COMPANY_ID, 
            HEADQUARTERS_ID, 
            SUB_WORKGROUP, 
            SPONSOR_EMP_ID, 
            IS_BUDGET 
	    FROM 
        	WORK_GROUP 
        WHERE 
        	HIERARCHY = '#attributes.hierarchy1_code#'
	</cfquery>
	<cfif len(get_upper_group_info.department_id)>
		<cfquery name="GET_DEP_BRA" datasource="#DSN#">
			SELECT D.DEPARTMENT_HEAD,B.BRANCH_NAME,D.DEPARTMENT_ID,D.BRANCH_ID FROM DEPARTMENT D,BRANCH B WHERE D.BRANCH_ID = B.BRANCH_ID AND D.DEPARTMENT_ID = #get_upper_group_info.department_id#
		</cfquery>
	</cfif>
	<cfif len(get_upper_group_info.our_company_id)>
		<cfquery name="GET_OUR_COMP" datasource="#DSN#">
			SELECT COMPANY_NAME,COMP_ID FROM OUR_COMPANY WHERE COMP_ID = #get_upper_group_info.our_company_id#
		</cfquery>
	</cfif>
	<cfif len(get_upper_group_info.headquarters_id)>
		<cfquery name="GET_HEAD" datasource="#DSN#">
			SELECT NAME,HEADQUARTERS_ID FROM SETUP_HEADQUARTERS WHERE HEADQUARTERS_ID = #get_upper_group_info.headquarters_id#
		</cfquery>
	</cfif>
</cfif>
<cfif isdefined('attributes.project_id') and len(attributes.project_id)>
	<cfquery name="GET_PROJE" datasource="#DSN#">
		SELECT PROJECT_HEAD,PROJECT_ID FROM PRO_PROJECTS WHERE PROJECT_ID = #attributes.project_id#
	</cfquery>
</cfif>
<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cfform name="add_workgroup" method="post" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_workgroup_add">
            <cf_box_elements>
                <div class="col col-12 col-md-12 col-sm-12 col-xs-12" type="column" index="1" sort="true">
                    <div class="form-group col col-2 col-md-1 col-sm-6 col-xs-12" id="item-status">
                        <label class="col col-12 col-md-12 col-sm-12 col-xs-12">
                            <input type="checkbox" name="status" id="status" checked><cf_get_lang dictionary_id='57493.Aktif'>
                        </label>
                    </div>
                    <cfif listgetat(attributes.fuseaction,1,'.') is not 'service'>
                    <div class="form-group col col-2 col-md-2 col-sm-6 col-xs-12" id="item-is_org_view">
                        <label class="col col-12 col-md-12 col-sm-12 col-xs-12">
                            <input name="is_org_view" id="is_org_view" type="checkbox" checked><cf_get_lang dictionary_id='56059.Org Şema Göster'>
                        </label>
                    </div>
                    </cfif>
                    <div class="form-group col col-2 col-md-2 col-sm-6 col-xs-12" id="item-is_budget">
                        <label class="col col-12 col-md-12 col-sm-12 col-xs-12">
                            <input name="is_budget" id="is_budget" type="checkbox"><cf_get_lang dictionary_id='56842.Butcede Goster'>
                        </label>
                    </div>
                    <div class="form-group col col-2 col-md-2 col-sm-6 col-xs-12" id="item-online_help">
                        <label class="col col-12 col-md-12 col-sm-12 col-xs-12">
                            <input name="online_help" id="online_help" type="checkbox" value="1" <cfif listgetat(attributes.fuseaction,1,'.') is 'service'>checked="checked" disabled="disabled"</cfif>><cf_get_lang dictionary_id='55475.Online Destek Ekibi'>
                        </label>
                    </div>
                    <div class="form-group col col-2 col-md-2 col-sm-6 col-xs-12" id="item-online_sales">
                        <label class="col col-12 col-md-12 col-sm-12 col-xs-12">
                            <input name="online_sales" id="online_sales" type="checkbox"><cf_get_lang dictionary_id='55476.Online Satış Ekibi'>
                        </label>
                    </div>
                </div>
                <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                    <div class="form-group" id="item-group_name">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58969.Grup Adı'> *</label>
                        <div class="col col-8 col-xs-12">
                            <cfinput type="Text" name="group_name" id="group_name" value="" maxlength="150" required="Yes" message="#getLang('','Grup Adı girmelisiniz',55459)#">
                        </div>
                    </div>
                    <div class="form-group" id="item-headquarters_name">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='56098.Grup Başkanlığı'></label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <input type="hidden" name="headquarters_id" id="headquarters_id" value="<cfif isdefined("get_head.recordcount") and get_head.recordcount><cfoutput>#get_head.HEADQUARTERS_ID#</cfoutput></cfif>">
                                <input type="text" name="headquarters_name" id="headquarters_name" value="<cfif isdefined("get_head.recordcount") and get_head.recordcount><cfoutput>#get_head.name#</cfoutput></cfif>" style="width:230px;">
                                <span class="input-group-addon icon-ellipsis" title="" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_headquarters&field_name=add_workgroup.headquarters_name&field_id=add_workgroup.headquarters_id</cfoutput>');"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-our_company">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57574.Şirket'></label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <input type="hidden" name="our_company_id" id="our_company_id" value="<cfif isdefined("get_our_comp.recordcount") and get_our_comp.recordcount><cfoutput>#get_our_comp.COMP_ID#</cfoutput></cfif>">
                                <input type="text" name="our_company" id="our_company" value="<cfif isdefined("get_our_comp.recordcount") and get_our_comp.recordcount><cfoutput>#get_our_comp.COMPANY_NAME#</cfoutput></cfif>" style="width:230px;">
                                <span class="input-group-addon icon-ellipsis" title="" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_our_companies&field_name=add_workgroup.our_company&field_id=add_workgroup.our_company_id</cfoutput>');"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-branch">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57453.Şube'></label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <input type="hidden" name="branch_id" id="branch_id" value="<cfif isdefined("get_dep_bra.recordcount") and get_dep_bra.recordcount><cfoutput>#get_dep_bra.branch_id#</cfoutput></cfif>">
                                <input type="text" name="branch" id="branch" value="<cfif isdefined("get_dep_bra.recordcount") and get_dep_bra.recordcount><cfoutput>#get_dep_bra.branch_name#</cfoutput></cfif>" style="width:230px;">
                                <span class="input-group-addon icon-ellipsis" title="" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=hr.popup_list_departments&field_id=add_workgroup.department_id&field_name=add_workgroup.department&field_branch_name=add_workgroup.branch&field_branch_id=add_workgroup.branch_id</cfoutput>');"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-department">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57572.Department'></label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <input type="hidden" name="department_id" id="department_id" value="<cfif isdefined("get_dep_bra.recordcount") and get_dep_bra.recordcount><cfoutput>#get_dep_bra.department_id#</cfoutput></cfif>">
                                <input type="text" name="department" id="department" value="<cfif isdefined("get_dep_bra.recordcount") and get_dep_bra.recordcount><cfoutput>#get_dep_bra.department_head#</cfoutput></cfif>" style="width:230px;">
                                <span class="input-group-addon icon-ellipsis" title="" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=hr.popup_list_departments&field_id=add_workgroup.department_id&field_name=add_workgroup.department&field_branch_name=add_workgroup.branch&field_branch_id=add_workgroup.branch_id</cfoutput>');"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-project_head">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57416.Proje'></label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <input type="hidden" name="project_id" id="project_id" value="<cfif isdefined('attributes.project_id') and len(attributes.project_id)><cfoutput>#attributes.PROJECT_ID#</cfoutput></cfif>"/>
                                <input type="text" name="project_head" id="project_head" value="<cfif isdefined('attributes.project_id') and len(attributes.project_id)><cfoutput>#get_proje.PROJECT_HEAD#</cfoutput></cfif>"/>
                                <span class="input-group-addon icon-ellipsis btnPointer" title="" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_projects&project_head=add_workgroup.project_head&project_id=add_workgroup.project_id</cfoutput>','popup_list_projects');"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-sponsor_position">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='56843.Sponsor'></label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <input type="hidden" name="conf_" id="conf_" value="">
                                <input type="hidden" name="sponsor_emp_id" id="sponsor_emp_id" value="">
                                <input type="text" name="sponsor_position" id="sponsor_position" value="" style="width:230px;">
                                <span class="input-group-addon icon-ellipsis btnPointer" title="<cf_get_lang dictionary_id ='56385.Sponsor Seç'>" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=hr.popup_list_emps&field_id=add_workgroup.sponsor_emp_id&field_name=add_workgroup.sponsor_position&conf_=add_workgroup.conf_</cfoutput>');"></span>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
                    <div class="form-group" id="item-manager_position">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='29511.Yönetici'> *</label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <input type="hidden" name="conf_" id="conf_" value="">
                                <input type="hidden" name="manager_emp_id" id="manager_emp_id" value="">
                                <input type="hidden" name="manager_pos_code" id="manager_pos_code" value="">
                                <input type="text" name="manager_position" id="manager_position" value="" style="width:230px;">
                                <span class="input-group-addon icon-ellipsis btnPointer" title="<cf_get_lang dictionary_id ='56386.Yönetici Seç'>" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=hr.popup_list_positions&field_code=add_workgroup.manager_pos_code&field_emp_name=add_workgroup.manager_position&field_emp_id=add_workgroup.manager_emp_id&show_empty_pos=1</cfoutput>');"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-manager_role_head">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='56100.Yönetici Rolü'></label>
                        <div class="col col-8 col-xs-12">
                            <input type="text" name="manager_role_head" id="manager_role_head" value="" maxlength="100" style="width:230px;">
                        </div>
                    </div>
                    <div class="form-group" id="item-upper_hierarchy">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='56099.Üst Grup'></label>
                        <div class="col col-8 col-xs-12">
                            <select value="<cfif isdefined("attributes.hierarchy1_code") and  len(attributes.hierarchy1_code)><cfoutput>#attributes.hierarchy1_code#</cfoutput></cfif>" name="upper_hierarchy" id="upper_hierarchy" onChange="document.add_workgroup.hierarchy1_code.value=document.add_workgroup.upper_hierarchy[document.add_workgroup.upper_hierarchy.selectedIndex].value;">
                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                <cfoutput query="get_workgroups"> 
                                    <option value="#hierarchy#"<cfif isdefined("attributes.hierarchy1_code") and len(attributes.hierarchy1_code) and (attributes.hierarchy1_code is hierarchy)> selected</cfif>>#hierarchy# #workgroup_name#</option>
                                </cfoutput>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-hierarchy">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57761.Hiyerarşi'> *</label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <input type="text" name="hierarchy1_code" id="hierarchy1_code" value="<cfif isdefined("attributes.hierarchy1_code") and len(attributes.hierarchy1_code)><cfoutput>#attributes.hierarchy1_code#</cfoutput></cfif>" readonly style="width:130px;">
                                <span class="input-group-addon no-bg"></span>
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='56091.Hiyerarşi Kodu Girmelisiniz'> !</cfsavecontent>
                                <cfinput type="text" name="hierarchy" id="hierarchy" value="" maxlength="50" required="Yes" message="#message#">
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-workgroup_type_id">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57630.Tip'></label>
                        <div class="col col-8 col-xs-12">
                            <cf_wrk_combo 
                                name="workgroup_type_id"
                                query_name="GET_WORKGROUP_TYPE"
                                option_name="workgroup_type_name"
                                option_value="workgroup_type_id"
                                width="230">
                        </div>
                    </div>
                    <div class="form-group" id="item-group_goal">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
                        <div class="col col-8 col-xs-12">
                            <textarea name="group_goal" id="group_goal" style="width:230px;height:80px;"></textarea>
                        </div>
                    </div>
                </div>
            </cf_box_elements>
            <cf_box_footer>
                <cf_workcube_buttons is_upd='0' add_function="kontrol()">
            </cf_box_footer>
        </cfform>
    </cf_box>
</div>
<script language="javascript" type="text/javascript">
function kontrol()
{
	if(document.getElementById("manager_pos_code").value == "" || document.getElementById("manager_position").value == "")
	{
		alert("<cf_get_lang dictionary_id='58194.Zorunlu Alan'> : <cf_get_lang dictionary_id='29511.Yönetici'>");
		return false;
	}
	return true
}	
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
