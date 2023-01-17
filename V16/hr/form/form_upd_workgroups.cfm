<cf_get_lang_set module_name="hr"><!--- sayfanin en altinda kapanisi var --->
<cfif isdefined('attributes.project_id')>
	<cfquery name="GET_WORKGROUP" datasource="#DSN#">
		SELECT WORKGROUP_ID FROM WORK_GROUP WHERE PROJECT_ID = #attributes.project_id#
	</cfquery>
	<cfset attributes.workgroup_id=	get_workgroup.workgroup_id>
</cfif>
<cfif not len(attributes.workgroup_id)>
	<cflocation url="#request.self#?fuseaction=objects.popup_form_list_pro_group&project_id=#attributes.project_id#" addtoken="no">
<cfelse>
	<cfquery name="GET_CATEGORY" datasource="#DSN#">
		SELECT 
    	    WORKGROUP_ID, 
            WORKGROUP_NAME, 
            GOAL, 
            ONLINE_HELP, 
            ONLINE_SALES, 
            COMPANY_ID, 
            PROJECT_ID, 
            STATUS, 
            RECORD_EMP, 
            RECORD_DATE,
            RECORD_IP, 
            HIERARCHY, 
            WORKGROUP_TYPE_ID, 
            MANAGER_POSITION_CODE, 
            IS_ORG_VIEW, 
            #dsn#.Get_Dynamic_Language(WORKGROUP_ID,'#ucase(session.ep.language)#','WORK_GROUP','MANAGER_ROLE_HEAD',NULL,NULL,MANAGER_ROLE_HEAD) AS MANAGER_ROLE_HEAD, 
            MANAGER_EMP_ID, 
            DEPARTMENT_ID, 
            BRANCH_ID, 
            OUR_COMPANY_ID, 
            HEADQUARTERS_ID, 
            UPDATE_DATE, 
            UPDATE_IP, 
            UPDATE_EMP, 
            SUB_WORKGROUP, 
            SPONSOR_EMP_ID, 
            IS_BUDGET 
        FROM 
	        WORK_GROUP 
        WHERE 
        	WORKGROUP_ID = #attributes.workgroup_id#
	</cfquery>
</cfif>
<cfif isDefined("get_category.department_id") AND len(get_category.department_id)>
	<cfquery name="GET_DEP_BRA" datasource="#DSN#">
		SELECT D.DEPARTMENT_HEAD,B.BRANCH_NAME FROM DEPARTMENT D,BRANCH B WHERE D.BRANCH_ID = B.BRANCH_ID AND D.DEPARTMENT_ID = #get_category.department_id#
	</cfquery>
</cfif>
<cfif isDefined("get_category.our_company_id") AND len(get_category.our_company_id)>
	<cfquery name="GET_OUR_COMP" datasource="#DSN#">
		SELECT COMPANY_NAME FROM OUR_COMPANY WHERE COMP_ID = #get_category.our_company_id#
	</cfquery>
</cfif>
<cfif isDefined("get_category.headquarters_id") AND len(get_category.headquarters_id)>
	<cfquery name="GET_HEAD" datasource="#DSN#">
		SELECT NAME FROM SETUP_HEADQUARTERS WHERE HEADQUARTERS_ID = #get_category.headquarters_id#
	</cfquery>
</cfif>
<cfquery name="GET_MONEY" datasource="#DSN#">
	SELECT
		MONEY
	FROM
		SETUP_MONEY
	WHERE
		PERIOD_ID = #session.ep.period_id# AND
		MONEY_STATUS = 1
	ORDER BY
		MONEY DESC
</cfquery> 

<cfif len(attributes.workgroup_id)>
	<cfquery name="GET_PROJECT" datasource="#DSN#">
		SELECT 
			PRO_PROJECTS.PROJECT_HEAD,
			PRO_PROJECTS.PROJECT_ID 
		FROM 
			PRO_PROJECTS,
			WORK_GROUP 
		WHERE 
			WORK_GROUP.WORKGROUP_ID = #attributes.workgroup_id# AND
			PRO_PROJECTS.PROJECT_ID = WORK_GROUP.PROJECT_ID
	</cfquery>
</cfif>

<cfquery name="GET_EMPS" datasource="#DSN#">
	SELECT 
    	WRK_ROW_ID, 
        WORKGROUP_ID, 
        PARTNER_ID, 
        EMPLOYEE_ID, 
        POSITION_CODE, 
        ROLE_ID, 
        PROJECT_ID, 
        CONSUMER_ID, 
        COMPANY_ID, 
        OUR_COMPANY_ID, 
        HIERARCHY, 
        ROLE_HEAD, 
        IS_REAL, 
        UPPER_ROW_ID, 
        IS_CRITICAL, 
        IS_ORG_VIEW, 
        PRODUCT_ID, 
        PRODUCT_UNIT_PRICE, 
        PRODUCT_MONEY, 
        PRODUCT_UNIT, 
        RECORD_EMP, 
        RECORD_IP, 
        RECORD_DATE, 
        UPDATE_EMP, 
        UPDATE_IP,
        UPDATE_DATE 
    FROM 
    	WORKGROUP_EMP_PAR 
    WHERE 
	    WORKGROUP_ID = #attributes.workgroup_id# 
    ORDER BY 
    	HIERARCHY
</cfquery>
<cfinclude template="../query/get_workgroup_uppers.cfm">

<cfform action="#request.self#?fuseaction=#fusebox.circuit#.emptypopup_workgroup_upd" method="post" name="add_workgroup">
<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
<cf_box>
    <input type="hidden" name="workgroup_id" id="workgroup_id" value="<cfoutput>#attributes.workgroup_id#</cfoutput>">
    <input type="hidden" name="pageDelEvent" id="pageDelEvent" value="del">
    <cfif fusebox.circuit is 'hr' or  fusebox.circuit is 'service'>
        <cf_box_elements>
            <div class="col col-12 col-md-12 col-sm-12 col-xs-12" type="column" index="1" sort="true">
                <input type="hidden" name="employee_id" id="employee_id" value="<cfoutput>#valuelist(get_emps.employee_id)#</cfoutput>">
                <input type="hidden" name="del_emp" id="del_emp" value="">
                <input type="hidden" name="del_par" id="del_par" value="">
                <div class="form-group col col-2 col-md-1 col-sm-6 col-xs-12" id="item-status">
                    <label class="col col-12 col-md-12 col-sm-12 col-xs-12">
                        <input type="checkbox" name="status" id="status" <cfif isDefined("get_category.status") AND get_category.status eq 1> checked</cfif>><cf_get_lang dictionary_id='57493.Aktif'></label>
                </div>
                <div class="form-group col col-2 col-md-2 col-sm-6 col-xs-12" id="item-is_org_view">
                    <label class="col col-12 col-md-12 col-sm-12 col-xs-12">
                        <input name="online_help" id="online_help" type="checkbox"<cfif fusebox.circuit is 'service'>checked="checked" disabled="disabled"</cfif>><cf_get_lang dictionary_id='56096.Online Destek'>
                    </label>
                </div>
                <div class="form-group col col-2 col-md-2 col-sm-6 col-xs-12" id="item-is_budget">
                    <label class="col col-12 col-md-12 col-sm-12 col-xs-12">
                        <input name="online_sales" id="online_sales" type="checkbox"<cfif isDefined("get_category.online_sales") AND get_category.online_sales eq 1> checked</cfif>><cf_get_lang dictionary_id='56097.Online Satış'>
                    </label>
                </div>
                <cfif fusebox.circuit is not 'service'>
                <div class="form-group col col-2 col-md-2 col-sm-6 col-xs-12" id="item-online_help">
                    <label class="col col-12 col-md-12 col-sm-12 col-xs-12">
                        <input name="is_org_view" id="is_org_view" type="checkbox"<cfif isDefined("get_category.is_org_view") AND get_category.is_org_view eq 1> checked</cfif>><cf_get_lang dictionary_id='56059.Org Şemada Göster'>
                    </label>
                </div>
                </cfif>
                <div class="form-group col col-2 col-md-2 col-sm-6 col-xs-12" id="item-online_sales">
                    <label class="col col-12 col-md-12 col-sm-12 col-xs-12">
                        <input name="is_budget" id="is_budget" type="checkbox" <cfif isDefined("get_category.is_budget") AND get_category.is_budget eq 1> checked</cfif>><cf_get_lang dictionary_id='56842.Butcede Goster'>
                    </label>
                </div>
            </div>
            <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                <div class="form-group" id="item-group_name">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58969.Grup Adı'> *</label>
                    <div class="col col-8 col-xs-12">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='55459.Grup Adı girmelisiniz'> !</cfsavecontent>
                        <cfset wrkGroupName = "">
                        <cfif isDefined("get_category.workgroup_name")>
                            <cfset wrkGroupName = #get_category.workgroup_name#>
                        </cfif>
                        <cfinput type="Text" name="workgroup_name" id="workgroup_name" value="#wrkGroupName#" maxlength="50" required="Yes" message="#message#" style="width:200px;">
                    </div>
                </div>
                <div class="form-group" id="item-headquarters_name">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='56098.Grup Başkanlığı'></label>
                    <div class="col col-8 col-xs-12">
                        <div class="input-group">
                            <input type="hidden" name="headquarters_id" id="headquarters_id" value="<cfif isDefined("get_category.headquarters_id")><cfoutput>#get_category.headquarters_id#</cfoutput></cfif>">
                            <input type="text" name="headquarters_name" id="headquarters_name" value="<cfif isDefined("get_category.headquarters_id") AND len(get_category.headquarters_id)><cfoutput>#get_head.name#</cfoutput></cfif>">
                            <span class="input-group-addon icon-ellipsis btnPointer" title="" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_headquarters&field_name=add_workgroup.headquarters_name&field_id=add_workgroup.headquarters_id</cfoutput>');"></span>
                        </div>
                    </div>
                </div>
                <div class="form-group" id="item-our_company">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57574.Şirket'></label>
                    <div class="col col-8 col-xs-12">
                        <div class="input-group">
                            <input type="hidden" name="our_company_id" id="our_company_id" value="<cfif isDefined("get_category.our_company_id")><cfoutput>#get_category.our_company_id#</cfoutput></cfif>">
                            <input type="text" name="our_company" id="our_company" value="<cfif isDefined("get_category.our_company_id") AND len(get_category.our_company_id)><cfoutput>#get_our_comp.company_name#</cfoutput></cfif>">
                            <span class="input-group-addon icon-ellipsis btnPointer" title="" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_our_companies&field_name=add_workgroup.our_company&field_id=add_workgroup.our_company_id</cfoutput>');"></span>
                        </div>
                    </div>
                </div>
                <div class="form-group" id="item-branch">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57453.Şube'></label>
                    <div class="col col-8 col-xs-12">
                        <div class="input-group">
                            <input type="hidden" name="branch_id" id="branch_id" value="<cfif isDefined("get_category.branch_id")><cfoutput>#get_category.branch_id#</cfoutput></cfif>">
                            <input type="text" name="branch" id="branch" value="<cfif isDefined("get_category.department_id") AND len(get_category.department_id)><cfoutput>#get_dep_bra.branch_name#</cfoutput></cfif>" style="width:200px;">
                            <span class="input-group-addon icon-ellipsis btnPointer" title="" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=hr.popup_list_departments&field_id=add_workgroup.department_id&field_name=add_workgroup.department&field_branch_name=add_workgroup.branch&field_branch_id=add_workgroup.branch_id</cfoutput>');"></span>
                        </div>
                    </div>
                </div>
                <div class="form-group" id="item-department">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57572.Departman'></label>
                    <div class="col col-8 col-xs-12">
                        <div class="input-group">
                            <input type="hidden" name="department_id" id="department_id" value="<cfif isDefined("get_category.department_id")><cfoutput>#get_category.department_id#</cfoutput></cfif>">
                            <input type="text" name="department" id="department" value="<cfif isDefined("get_category.department_id") AND len(get_category.department_id)><cfoutput>#get_dep_bra.department_head#</cfoutput></cfif>" style="width:200px;">
                            <span class="input-group-addon icon-ellipsis btnPointer" title="" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=hr.popup_list_departments&field_id=add_workgroup.department_id&field_name=add_workgroup.department&field_branch_name=add_workgroup.branch&field_branch_id=add_workgroup.branch_id</cfoutput>');"></span>
                        </div>
                    </div>
                </div>
                <div class="form-group" id="item-project_head">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57416.Proje'></label>
                    <div class="col col-8 col-xs-12">
                        <div class="input-group">
                            <input type="hidden" name="project_id" id="project_id" value="<cfif isDefined("get_category.project_id")><cfoutput>#get_project.project_id#</cfoutput></cfif>"/>
                            <input type="text" name="project_head" id="project_head" style="width:180px;" value="<cfoutput>#get_project.project_head#</cfoutput>">
                            <span class="input-group-addon icon-ellipsis btnPointer" title="" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_projects&project_head=add_workgroup.project_head&project_id=add_workgroup.project_id</cfoutput>');"></span>
                        </div>
                    </div>
                </div>
                <div class="form-group" id="item-sponsor_position">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='56843.Sponsor'></label>
                    <div class="col col-8 col-xs-12">
                        <div class="input-group">
                            <input type="hidden" name="conf_" id="conf_" value="">
                            <input type="hidden" name="sponsor_emp_id" id="sponsor_emp_id" value="<cfif isDefined("get_category.sponsor_emp_id")><cfoutput>#get_category.sponsor_emp_id#</cfoutput></cfif>">
                            <input type="text" name="sponsor_position" id="sponsor_position" value="<cfif isDefined("get_category.sponsor_emp_id") AND len(get_category.sponsor_emp_id)><cfoutput>#get_emp_info(get_category.sponsor_emp_id,0,0)#</cfoutput></cfif>" style="width:180px;">
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
                            <input type="hidden" name="manager_emp_id" id="manager_emp_id" value="<cfif isDefined("get_category.manager_emp_id")><cfoutput>#get_category.manager_emp_id#</cfoutput></cfif>">
                            <input type="hidden" name="manager_pos_code" id="manager_pos_code" value="<cfif isDefined("get_category.manager_position_code")><cfoutput>#get_category.manager_position_code#</cfoutput></cfif>">
                            <input type="text" name="manager_position" id="manager_position" value="<cfif isDefined("get_category.manager_emp_id") AND len(get_category.manager_emp_id)><cfoutput>#get_emp_info(get_category.manager_emp_id,0,0)#</cfoutput></cfif>" style="width:180px;">
                            <span class="input-group-addon icon-ellipsis btnPointer" title="<cf_get_lang dictionary_id ='56386.Yönetici Seç'>" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=hr.popup_list_positions&field_code=add_workgroup.manager_pos_code&field_emp_name=add_workgroup.manager_position&field_emp_id=add_workgroup.manager_emp_id&show_empty_pos=1</cfoutput>');"></span>
                        </div>
                    </div>
                </div>
                <div class="form-group" id="item-manager_role_head">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='56100.Yönetici Rolü'></label>
                    <div class="col col-8 col-xs-12">                        
                        <div class="input-group">
                            <input type="text" name="manager_role_head" id="manager_role_head" value="<cfif isDefined("get_category.manager_role_head")><cfoutput>#get_category.manager_role_head#</cfoutput></cfif>" style="width:180px;" maxlength="100">
                                <span class="input-group-addon">
                                    <cf_language_info 
                                    table_name="WORK_GROUP" 
                                    column_name="MANAGER_ROLE_HEAD" 
                                    column_id_value="#attributes.workgroup_id#" 
                                    maxlength="500" 
                                    datasource="#dsn#" 
                                    column_id="WORKGROUP_ID" 
                                    control_type="0">
                                </span>
                        </div>	
                    </div>
                </div>
                <div class="form-group" id="item-upper_hierarchy">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='56099.Üst Grup'></label>
                    <div class="col col-8 col-xs-12">
                        <input type="hidden" name="old_hierarchy" id="old_hierarchy" value="<cfif isDefined("get_category.hierarchy")></cfif>">
                        <cfif isDefined("get_category.hierarchy") and listlen(get_category.hierarchy,'.')>
                            <cfset cat_code=listlast(get_category.hierarchy,".")>
                            <cfset ust_cat_code=listdeleteat(get_category.hierarchy,ListLen(get_category.hierarchy,"."),".")>
                        <cfelse>
                            <cfset cat_code="">
                            <cfset ust_cat_code="">
                        </cfif>
                        <input type="hidden" name="old_sub_hierarchy" id="old_sub_hierarchy" value="<cfoutput>#cat_code#</cfoutput>">
                        <select name="upper_hierarchy" id="upper_hierarchy" onChange="document.add_workgroup.hierarchy1_code.value=document.add_workgroup.upper_hierarchy[document.add_workgroup.upper_hierarchy.selectedIndex].value;" style="width:200px;">
                            <option value=""<cfif ust_cat_code eq "">selected</cfif>><cf_get_lang dictionary_id='57734.Seçiniz'> 
                            <cfoutput query="get_workgroups">
                            <cfif isDefined("get_category.hierarchy") AND hierarchy is not get_category.hierarchy>
                                <option value="#hierarchy#"<cfif ust_cat_code is '#hierarchy#' and len(ust_cat_code) eq len(hierarchy)> selected</cfif>>#hierarchy# #WORKGROUP_NAME#</option>
                            </cfif>
                            </cfoutput>
                        </select>
                    </div>
                </div>
                <div class="form-group" id="item-hierarchy">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57761.Hiyerarşi'> *</label>
                    <div class="col col-4 col-xs-12">
                        <input type="text" name="hierarchy1_code" id="hierarchy1_code" value="<cfoutput>#ust_cat_code#</cfoutput>" readonly>
                    </div>
                    <div class="col col-4 col-xs-12">
                        <cfinput type="text" name="hierarchy" id="hierarchy" value="#cat_code#" maxlength="50" required="Yes" message="#getLang('','Hiyerarşi Kodu Girmelisiniz',56091)#">
                    </div>
                </div>
                <div class="form-group" id="item-workgroup_type_id">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57630.Tip'></label>
                    <div class="col col-8 col-xs-12">
                        <cf_wrk_combo 
                            name="workgroup_type_id"
                            query_name="GET_WORKGROUP_TYPE"
                            value="#iif(isDefined("get_category.workgroup_type_id"),'get_category.workgroup_type_id',DE(''))#"
                            option_name="workgroup_type_name"
                            option_value="workgroup_type_id"
                            width="180">
                    </div>
                </div>
                <div class="form-group" id="item-group_goal">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
                    <div class="col col-8 col-xs-12">
                        <textarea name="goal" id="goal" style="width:230px;height:80px;"><cfif isDefined("get_category.goal")><cfoutput>#get_category.goal#</cfoutput></cfif></textarea>
                    </div>
                </div>
            </div>
        </cf_box_elements>
        <cf_box_footer>
            <div class="col col-6 col-xs-12">
                <cf_record_info query_name="get_category">
            </div>
            <div class="col col-6 col-xs-12">
                <cfif isDefined("get_category.sub_workgroup") AND get_category.sub_workgroup eq 1 and fusebox.circuit is not 'objects'>
                    <cf_workcube_buttons type_format="1" is_upd='1' add_function="kontrol()" is_delete='0'>
                <cfelse>
                    <cfsavecontent variable="delete"><cf_get_lang dictionary_id='60875.Kayıtlı Grubu Siliyorsunuz.Bu Grupla Birlikte Tüm Çalışanlarda Silinecek. Emin misiniz?	'></cfsavecontent>
                    <cf_workcube_buttons type_format="1" is_upd='1' add_function="kontrol()" delete_page_url='#request.self#?fuseaction=#fusebox.circuit#.emptypopup_del_workgroup&GROUP_ID=#attributes.workgroup_id#' delete_alert='#delete#'>
                </cfif>
            </div>
        </cf_box_footer>
    </cfif>
</cf_box>
<cfif fusebox.circuit is 'objects'>
	<cfinclude template="../display/project_work.cfm"></td>
</cfif>
</cfform>
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
    
<cfif fusebox.circuit is 'hr' or fusebox.circuit is 'service'>
    <cfsavecontent variable="message"><cf_get_lang dictionary_id="55497.Grup Çalışanları"></cfsavecontent>
    <cf_box title="#message#">
        <cf_grid_list>
            <thead>
                <tr>
                    <th><cf_get_lang dictionary_id='58585.Kod'></th>
                    <th><cf_get_lang dictionary_id='55478.Rol'></th>
                    <th><cf_get_lang dictionary_id='56101.İlgili'></th>
                    <th><cf_get_lang dictionary_id='57756.Durum'></th>
                    <th><cf_get_lang dictionary_id='57630.Tip'></th>
                    <th width="20" class="header_icn_none text-center"><a href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=#fusebox.circuit#.list_workgroup&event=addWorker&WORKGROUP_ID=#attributes.workgroup_ID#</cfoutput>')"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='55699.Gruba Çalışan Ekle'>" alt="<cf_get_lang dictionary_id='55699.Gruba Çalışan Ekle'>"></i></a></th>
                </tr>
            <tbody>
            <cfif get_emps.recordcount>
                <cfoutput query="get_emps">
                    <tr>
                        <td>#hierarchy#</td>
                        <td><cfloop from="1" to="#listlen(hierarchy,'.')-2#" index="i"></cfloop><a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=#fusebox.circuit#.popup_form_upd_worker2&WRK_ROW_ID=#WRK_ROW_ID#')" class="tableyazi">#role_head#</a></td>
                        <td><cfif len(employee_id)>
                                <a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#employee_id#')" class="tableyazi">#get_emp_info(employee_id,0,0)#</a>
                            <cfelseif len(consumer_id)>
                                <a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=objects.popup_con_det&con_id=#consumer_id#')" class="tableyazi">#get_cons_info(consumer_id,1,0)#</a>
                            <cfelseif len(partner_id)>
                                <a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=objects.popup_par_det&par_id=#partner_id#')" class="tableyazi">#get_par_info(partner_id,0,0,0)#</a>
                            </cfif>
                        </td>
                        <td><cfif is_real eq 1><cf_get_lang dictionary_id='56015.Asıl'><cfelseif is_real eq 0><cf_get_lang dictionary_id='56088.Vekil'><cfelse><cf_get_lang dictionary_id='58845.Tanımsız'></cfif></td>
                        <td><cfif len(role_id)>
                                <cfquery name="GET_ROL_NAME" datasource="#DSN#">
                                    SELECT PROJECT_ROLES FROM SETUP_PROJECT_ROLES WHERE PROJECT_ROLES_ID = #role_id#
                                </cfquery>
                                #get_rol_name.project_roles#
                            </cfif>               
                        </td>
                        <td><a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=#fusebox.circuit#.popup_form_upd_worker2&wrk_row_id=#wrk_row_id#')"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></td>
                    </tr>
                </cfoutput>
            <cfelse>
                <tr>
                    <td colspan="7"><cf_get_lang dictionary_id='57484.Kayıt Yok'></td>
                </tr>
            </cfif>
            </tbody>
        </cf_grid_list>
    </cf_box>
</cfif>

<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
