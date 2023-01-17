<!--- File: ajax_hr_list.cfm
    Author: Canan Ebret <cananebret@workcube.com>
    Date: 12.09.2019
    Controller: -
    Description: kim kimdir sayfasında cf_loader custom taginin kullanılabilmesi için oluşturulmuştur.​
 --->
<cfinclude template="../query/get_position_cats.cfm">
<cfset getHrCFC = CreateObject("component","V16.hr.cfc.get_hrs")>
<cfset listHrCFC = CreateObject("component","V16.rules.cfc.list_hr")>
<cfset HR = getHrCFC.get_hr(
		keyword: attributes.keyword?:"",
		keyword2: attributes.keyword2?:"",
		position_cat_id: position_cat_id?:"",
		title_id: attributes.title_id?:"",
		branch_id: attributes.branch_id?:"",
		func_id: attributes.func_id?:"",
		organization_step_id:attributes.organization_step_id?:"",
		position_name:attributes.position_name?:"",
		collar_type:attributes.collar_type?:"",
		emp_status: attributes.emp_status?:"",
		hierarchy: attributes.hierarchy?:"",
		emp_code_list:attributes.emp_code_list?:"",
		department: attributes.department?:"",
		process_stage: attributes.process_stage?:"",
		duty_type: attributes.duty_type?:"",
		fusebox_dynamic_hierarchy: fusebox.dynamic_hierarchy,
		database_type: database_type,
		maxrows:attributes.maxrows?:"",
		startrow:attributes.startrow?:""
		)>
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.totalrecords" default='#HR.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>		
<cfset employee_list = ''>
<cfset mobiltel_list = "">
<cfoutput query="HR">
    <cfif len(employee_id) and not ListFind(mobiltel_list,employee_id,',')>
        <cfset mobiltel_list = ListAppend(mobiltel_list,employee_id,',')>
    </cfif>
        <cfset employee_list = listappend(employee_list,HR.employee_id,',')>
</cfoutput>
<cfif ListLen(mobiltel_list)>
    <cfset get_employee_detail= listHrCFC.GetEmployeeDetail(mobiltel_list:mobiltel_list)>
    <cfset mobiltel_list = ListSort(ListDeleteDuplicates(ValueList(get_employee_detail.employee_id,",")),"numeric","asc",",")>
</cfif>
<cfset GET_POSITIONS= listHrCFC.GetPositions(employee_list:employee_list)>	
<cfoutput query="HR"> 
    <cfset GET_POSITION = listHrCFC.GetPosition(employee_id:employee_id)>
    <div class="col col-3 col-md-3 col-sm-4 col-xs-12">
        <cf_box>
            <div class="who_item">
                <div class="who_item_img">
                    <cfif len(PHOTO)>
                        <img src="/documents/hr/#PHOTO#">
                    <cfelseif SEX eq 1>
                        <img src="/images/maleicon.jpg">
                    <cfelse>
                        <img src="/images/femaleicon.jpg">
                    </cfif>
                </div>
                <div class="who_info">
                    <div class="who_info_name">							
                        <!--- <a href="javascript://" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#employee_id#')">#employee_name# #employee_surname#</a> --->
                        <a href="#request.self#?fuseaction=rule.list_hr&event=det&emp_id=#employee_id#">#employee_name# #employee_surname#</a>
                    </div>
                    <div class="who_info_desc">
                        <p><cfif get_position.recordcount>#get_position.department_head#, #get_position.position_name#</cfif></p>
                    </div>
                </div> 
                <div class="who_btn">
                    <a href="javascript://" onclick="openBoxDraggable('#request.self#?fuseaction=myhome.popup_form_add_warning&employee_id=#employee_id#')"><i class="catalyst-share"></i>Workshare</a>
                    <a href="javascript://" onclick="window.open('index.cfm?fuseaction=objects.workflowpages&tab=1&subtab=1','Chatflow');"><i class="catalyst-bubbles"></i>Chatflow</a>
                </div>
            </div>
        </cf_box>
    </div>											
</cfoutput>