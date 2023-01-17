<!---
Author: Esma R. Uysal <esmauysal@workcube.com>
Date: 2020-07-02
Description:
    Esnek çalışma belge bazında ve satır bazında listeleme raporudur.
--->
<cf_xml_page_edit fuseact='report.flexible_worktime'>
<cfset cmp_org_step = createObject("component","V16.hr.cfc.get_organization_steps")>
<cfset cmp_org_step.dsn = dsn>
<cfif not (isDefined('attributes.maxrows') and isNumeric(attributes.maxrows))>
    <cfset attributes.maxrows = session.ep.maxrows />
</cfif>
<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.department_id" default="">
<cfparam name="attributes.employee_id" default="">
<cfparam name="attributes.employee" default="">
<cfparam name="attributes.position_id" default="">
<cfparam name="attributes.process_stage" default="">
<cfparam name="attributes.filter_process" default="">
<cfparam name="attributes.startdate" default="">
<cfparam name="attributes.finishdate" default="">
<cfparam name="attributes.type" default="1">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.group_paper_no" default="" />
<cfparam name="attributes.is_excel" default="">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1 />
<cfsavecontent variable="ay1"><cf_get_lang dictionary_id='57592.Ocak'></cfsavecontent>
<cfsavecontent variable="ay2"><cf_get_lang dictionary_id='57593.Subat'></cfsavecontent>
<cfsavecontent variable="ay3"><cf_get_lang dictionary_id='57594.Mart'></cfsavecontent>
<cfsavecontent variable="ay4"><cf_get_lang dictionary_id='57595.Nisan'></cfsavecontent>
<cfsavecontent variable="ay5"><cf_get_lang dictionary_id='57596.Mayis'></cfsavecontent>
<cfsavecontent variable="ay6"><cf_get_lang dictionary_id='57597.Haziran'></cfsavecontent>
<cfsavecontent variable="ay7"><cf_get_lang dictionary_id='57598.Temmuz'></cfsavecontent>
<cfsavecontent variable="ay8"><cf_get_lang dictionary_id='57599.Agustos'></cfsavecontent>
<cfsavecontent variable="ay9"><cf_get_lang dictionary_id='57600.Eylül'></cfsavecontent>
<cfsavecontent variable="ay10"><cf_get_lang dictionary_id='57601.Ekim'></cfsavecontent>
<cfsavecontent variable="ay11"><cf_get_lang dictionary_id='57602.Kasim'></cfsavecontent>
<cfsavecontent variable="ay12"><cf_get_lang dictionary_id='57603.Aralik'></cfsavecontent>
<cfset days_name = "">
<cfloop from="1" to="7" index="c">
	<cfif	c eq 1><cfsavecontent variable="day_name"><cf_get_lang dictionary_id = "57604.Pazartesi"></cfsavecontent>
	<cfelseif c eq 2><cfsavecontent variable="day_name"><cf_get_lang dictionary_id = "57605.Salı"></cfsavecontent>
	<cfelseif c eq 3><cfsavecontent variable="day_name"><cf_get_lang dictionary_id = "57606.Çarşamba"></cfsavecontent>
	<cfelseif c eq 4><cfsavecontent variable="day_name"><cf_get_lang dictionary_id = "57607.Perşembe"></cfsavecontent>
	<cfelseif c eq 5><cfsavecontent variable="day_name"><cf_get_lang dictionary_id = "57608.Cuma"></cfsavecontent>
	<cfelseif c eq 6><cfsavecontent variable="day_name"><cf_get_lang dictionary_id = "57609.Cumartesi"></cfsavecontent>
	<cfelseif c eq 7><cfsavecontent variable="day_name"><cf_get_lang dictionary_id = "57610.Pazar"></cfsavecontent>
	</cfif>
	<cfset days_name = listappend(days_name,'#day_name#')>
</cfloop>
<cfsavecontent variable = "title">
    <cf_get_lang dictionary_id = "59820.Esnek Çalışma Talepleri">
</cfsavecontent>
<cfset flex_component = createObject("component","V16.myhome.cfc.flexible_worktime")>
<cfset fuseaction = listFirst(attributes.fuseaction,".")>
<cfif len(attributes.employee_id)>
    <cfset attributes.employee_id = listfirst(attributes.employee_id,'_')>
</cfif>
<cfset get_flexible_worktime =  flex_component.GET_WORKTIME_FLEXIBLE_LIST_HR(
    employee_id : len(attributes.employee) ? attributes.employee_id : "",
    stage_id : attributes.filter_process,
    branch_id : attributes.branch_id,
    position_id : attributes.position_id,
    department_id : attributes.department_id,
    startdate : attributes.type eq 1 ? attributes.startdate : "",
    finishdate : attributes.type eq 1 ? attributes.finishdate : "",
    group_paper_no : attributes.group_paper_no
    )>
<cfset cmp_branch = createObject("component","V16.hr.cfc.get_branch_comp")>
<cfset cmp_branch.dsn = dsn>
<cfset get_branches = cmp_branch.get_branch(branch_status:1, ehesap_control : 1)>
<cfset cmp_department = createObject("component","V16.hr.cfc.get_departments")>
<cfset cmp_department.dsn = dsn>
<cfset get_department = cmp_department.get_department(branch_id :attributes.branch_id)>
<!--- Aşama Component --->
<cfset cmp_process = createObject('component','V16.workdata.get_process')>
<cfset get_process = cmp_process.GET_PROCESS_TYPES(faction_list : 'hr.flexible_worktime')>
<cfset adres="#fuseaction#.flexible_worktime" />

<cfif isDefined('attributes.branch_id') and Len(attributes.branch_id)>
	<cfset adres = '#adres#&keyword=#attributes.branch_id#' />
</cfif>
<cfif isDefined('attributes.employee_id') and Len(attributes.employee_id)>
	<cfset adres = '#adres#&employee_id=#attributes.employee_id#' />
</cfif>
<cfif isDefined('attributes.stage_id') and Len(attributes.stage_id)>
	<cfset adres = '#adres#&stage_id=#attributes.stage_id#' />
</cfif>
<cfif isDefined('attributes.position_id') and Len(attributes.position_id)>
	<cfset adres = '#adres#&position_id=#attributes.position_id#' />
</cfif>
<cfif isDefined('attributes.department_id') and Len(attributes.department_id)>
	<cfset adres = '#adres#&department_id=#attributes.department_id#' />
</cfif>
<cfif isDefined('attributes.type') and Len(attributes.type)>
	<cfset adres = '#adres#&type=#attributes.type#' />
</cfif>
<cfif isDefined('attributes.group_paper_no') and Len(attributes.group_paper_no)>
	<cfset adres = '#adres#&group_paper_no=#attributes.group_paper_no#' />
</cfif>
<cf_box id="flexible_worktime" closable="0" collapsable="0">
    <cf_box_search plus="0" more="0">
        <cfform name="flexible_worktime_form" method="post" action="">
            <input type="hidden" name="form_submitted" id="form_submitted" value="1">
            <div class="row">
                <div class="col col-12 form-inline">
                    <div class="form-group">
                        <div class="input-group">
                            <cfoutput>
                                <input type="hidden" name="employee_id" id="employee_id" value="<cfif len(attributes.employee)>#attributes.employee_id#</cfif>">
                                <input type="hidden" name="position_id" id="position_id" value="<cfif len(attributes.employee)>#attributes.position_id#</cfif>">
                                <input type="text" name="employee" id="employee" onFocus="AutoComplete_Create('employee','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','\'3,9\',\'0\',\'0\',\'0\',\'\',\'\',\'\',\'1\'','EMPLOYEE_ID,MEMBER_TYPE','employee_id','','3','135');" style="width:120px;" value="#get_emp_info(attributes.employee_id,0,0)#" placeholder='<cf_get_lang dictionary_id="57576.Çalışan">'>
                                <span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&is_display_self=1&is_cari_action=1&field_emp_id=flexible_worktime_form.employee_id&field_name=flexible_worktime_form.employee&field_type=flexible_worktime_form.employee_id&field_id=position_id&select_list=1,9','list');"></span>
                            </cfoutput>
                        </div>
                    </div>
                    <div class="form-group">
                        <!---<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57453.Şube'></label>--->
                        <select name="branch_id" id="branch_id" onChange="showDepartment(this.value)">
                            <cfoutput query="get_branches" group="NICK_NAME">
                                <option value=""><cf_get_lang dictionary_id='57453.Şube'></option>
                                <optgroup label="#get_branches.NICK_NAME#"></optgroup>
                                <cfoutput>
                                    <option value="#get_branches.BRANCH_ID#"<cfif attributes.branch_id eq get_branches.branch_id> selected</cfif>>#get_branches.BRANCH_NAME#</option>
                                </cfoutput>
                            </cfoutput>
                        </select>
                    </div>
                    <!---<label class="col col-1 col-xs-12"><cf_get_lang dictionary_id='57572.Departman'></label>--->
                    <div class="form-group" id="department_div">
                        <select name="department_id" id="department_id"> 
                            <option value=""><cf_get_lang_main no='160.Departman'></option>
                            <cfoutput query="get_department">
                                <option value="#department_id#" <cfif attributes.department_id eq get_department.department_id>selected</cfif>>#department_head#</option>
                            </cfoutput>
                        </select>
                    </div>
                    <div class="form-group">
                        <select name="filter_process" id="filter_process">
                            <option value="" ><cf_get_lang dictionary_id ="57734.SEÇİNİZ"></option>
                            <cfoutput query="get_process"> 
                                <option value="#process_row_id#" <cfif isdefined("attributes.filter_process") and (process_row_id eq attributes.filter_process)>selected</cfif>><cfif Len(stage_code)>#stage_code# - </cfif>#stage#</option>
                            </cfoutput>
                        </select>
                    </div>
                    <div class="form-group">
                        <select name="type" id="type"> 
                            <option value ="1" <cfif attributes.type eq 1>selected</cfif>><cf_get_lang dictionary_id = '57660.Belge bazında'></option>
                            <option value ="2" <cfif attributes.type eq 2>selected</cfif>><cf_get_lang dictionary_id = '29539.satır bazında'></option>
                        </select>
                    </div>
                    <div class="form-group">
                        <div class="input-group">  
                            <input type="text" name="group_paper_no" id="group_paper_no" placeholder="<cf_get_lang dictionary_id='60286.Toplu Belge No'>" value="<cfoutput>#attributes.group_paper_no#</cfoutput>" />
                        </div>
                    </div>
                    <div class="form-group">
                        <div class="input-group">
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='57738.başlangıç tarihi girmelisiniz'></cfsavecontent>
                            <cfif isdefined('attributes.startdate') and len(attributes.startdate)>
                                <cfinput type="text" name="startdate" id="startdate" style="width:65px;" maxlength="10" validate="#validate_style#" value="#dateformat(attributes.startdate,dateformat_style)#">
                            <cfelse>
                                <cfinput type="text" name="startdate" id="startdate" style="width:65px;" maxlength="10" validate="#validate_style#" >
                            </cfif>
                            <span class="input-group-addon"><cf_wrk_date_image date_field="startdate"></span>
                        </div>
                    </div>
                    <div class="form-group">
                        <div class="input-group">
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='57739.bitiş tarihi girmelisiniz'></cfsavecontent>
                            <cfif isdefined("attributes.finishdate") and len(attributes.finishdate)>
                                <cfinput type="text" name="finishdate" id="finishdate" style="width:65px;" maxlength="10" validate="#validate_style#"  value="#dateformat(attributes.finishdate,dateformat_style)#">
                            <cfelse>
                                <cfinput type="text" name="finishdate" id="finishdate" style="width:65px;" maxlength="10" validate="#validate_style#" >
                            </cfif>
                            <span class="input-group-addon"><cf_wrk_date_image date_field="finishdate"></span>
                        </div>
                    </div>
                    <div class="form-group small">
                        <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,999"  maxlength="3" style="width:25px;">
                    </div>
                    <div class="form-group">
                        <label><input type="checkbox" name="is_excel" id="is_excel" value="1" <cfif attributes.is_excel eq 1>checked</cfif>><cf_get_lang dictionary_id='57858.Excel Getir'></label>
                    </div>
                    <div class="form-group">
                        <cf_wrk_search_button  button_type="4" search_function="kontrol()">
                    </div>
                </div>
            </div>
        </cfform>
    </cf_box_search>
</cf_box>
<cfif attributes.type eq 1>
    <cfform name="setProcessForm" id="setProcessForm" method="post" action="">
        <cfparam name="attributes.totalrecords" default=#get_flexible_worktime.recordcount#>
        <cf_box id="list_worknet_list" closable="0" collapsable="1" title="#title#"> 
            <cfif attributes.is_excel eq 1>
                <cfset filename = "#createuuid()#">
                <cfheader name="Expires" value="#Now()#">
                <cfcontent type="application/vnd.msexcel;charset=utf-16">
                <cfheader name="Content-Disposition" value="attachment; filename=#filename#.xls">
                <meta http-equiv="Content-Type" content="text/html; charset=utf-16">
                <cfset attributes.maxrows = get_flexible_worktime.recordcount>
            </cfif>
            <cf_grid_list>
                <div id="Note_list">
                    <thead>
                        <tr>
							<th></th>
                            <th><cf_get_lang dictionary_id = '57576.Çalışan'></th>
                            <th><cf_get_lang dictionary_id='57453.Şube'></th>
                            <th><cf_get_lang_main no='160.Departman'></th>
                            <th><cf_get_lang dictionary_id = "55285.Talep Tarihi"></th>
                            <th><cf_get_lang dictionary_id = "41129.Süreç/Aşama"></th>
                            <cfif isDefined("x_show_level") and x_show_level eq 1><th><cf_get_lang dictionary_id='62040.Kademeli Departman'></th></cfif>
                        </tr>
                    </thead>
                    <tbody>
                        <cfif get_flexible_worktime.recordcount>
                            <cfoutput query = "get_flexible_worktime" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                                <tr>
									<td>
                                        #currentrow#
                                    </td>
                                    <td>
                                        #get_emp_info(employee_id,0,0)#
                                    </td>
                                    <td>
                                        <cfset get_branches_row = cmp_branch.get_branch(branch_status:1,branch_id : branch_id)>
                                        #get_branches_row.branch_name#
                                    </td>
                                    <td>
                                        <cfset get_department_ = cmp_department.get_department(department_id :department_id)>
                                        #get_department_.department_head#
                                    </td>
                                    <td>
                                        #dateFormat(REQUEST_DATE,dateformat_style)#
                                    </td>
                                    <td>
                                        <cfquery name="get_stage" dbtype="query">
                                            SELECT STAGE FROM get_process WHERE PROCESS_ROW_ID = #STAGE_ID#
                                        </cfquery>
                                        #get_stage.STAGE#
                                    </td>
                                    <cfif isDefined("x_show_level") and x_show_level eq 1>
                                        <td>                            
                                            <cfset up_dep_len = listlen(HIERARCHY_DEP_ID1,'.')>
                                            <cfif up_dep_len gt 0>
                                                <cfset temp = up_dep_len> 
                                                <cfloop from="1" to="#up_dep_len#" index="i" step="1">
                                                    <cfif isdefined("HIERARCHY_DEP_ID1") and listlen(HIERARCHY_DEP_ID1,'.') gt temp>
                                                        <cfset up_dep_id = ListGetAt(HIERARCHY_DEP_ID1, listlen(HIERARCHY_DEP_ID1,'.')-temp,".")>
                                                        <cfquery name="get_upper_departments" datasource="#dsn#">
                                                            SELECT DEPARTMENT_HEAD, LEVEL_NO FROM DEPARTMENT WHERE DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#up_dep_id#">
                                                        </cfquery>
                                                        <cfset up_dep_head = get_upper_departments.department_head>
                                                        #up_dep_head# 
                                                            <cfset get_org_level = cmp_org_step.get_organization_step(level_no : get_upper_departments.LEVEL_NO)>
                                                            <cfif get_org_level.recordcount>
                                                                (#get_org_level.ORGANIZATION_STEP_NAME#)
                                                            </cfif>
                                                        <cfif up_dep_len neq i>
                                                            >
                                                        </cfif>
                                                    <cfelse>
                                                        <cfset up_dep_head = ''>
                                                    </cfif>
                                                    <cfset temp = temp - 1>
                                                </cfloop>
                                            </cfif>​
                                        </td>
                                    </cfif>
                                </tr>
                            </cfoutput>
                        <cfelse>
                            <tr>
                                <td colspan="6"><cfif isdefined("attributes.form_submitted")><cf_get_lang_main no='72.Kayıt Bulunamadı'> !<cfelse><cf_get_lang_main no='289.Filtre Ediniz '>!</cfif></td>
                            </tr>
                        </cfif>
                    </tbody>
                </div>
            </cf_grid_list>
            <cfif attributes.totalrecords gt attributes.maxrows>
                <cf_paging page="#attributes.page#"
                        maxrows="#attributes.maxrows#"
                        totalrecords="#attributes.totalrecords#"
                        startrow="#attributes.startrow#"
                        adres="#adres#&is_form_submitted=1"
                        is_form="1"
                        name="setProcessForm"
                        >
            </cfif>
        </cf_box>
    </cfform>
<cfelseif type eq 2>
    <cf_box id="list_worknet_list" closable="0" collapsable="1" title = "#title#"> 
        <cfif attributes.is_excel eq 1>
            <cfset filename = "#createuuid()#">
            <cfheader name="Expires" value="#Now()#">
            <cfcontent type="application/vnd.msexcel;charset=utf-16">
            <cfheader name="Content-Disposition" value="attachment; filename=#filename#.xls">
            <meta http-equiv="Content-Type" content="text/html; charset=utf-16">
            <cfset attributes.maxrows = get_flexible_worktime.recordcount>
        </cfif>
        <cf_grid_list>
            <div id="Note_list">
                <thead>
                    <tr>
						<th></th>
                        <th><cf_get_lang dictionary_id = '57576.Çalışan'></th>
                        <th><cf_get_lang dictionary_id='57453.Şube'></th>
                        <th><cf_get_lang_main no='160.Departman'></th>
                        <th><cf_get_lang dictionary_id = "57742.Tarih"></th>
                        <th><cf_get_lang dictionary_id = "57491.Saat"></th>
                        <th><cf_get_lang dictionary_id = "41129.Süreç/Aşama"></th>
                        <cfif isDefined("x_show_level") and x_show_level eq 1><th><cf_get_lang dictionary_id='62040.Kademeli Departman'></th></cfif>
                    </tr>
                </thead>
                <tbody>
					<cfset current_row = 1>
                    <cfloop query = "get_flexible_worktime" >
                        <cfset get_flexible_worktime_row = flex_component.GET_WORKTIME_FLEXIBLE_ROW(
                            flexible_id : get_flexible_worktime.worktime_flexible_id,   
                            startdate : attributes.startdate,
                            finishdate : attributes.finishdate)
                        >
                        <cfparam name="attributes.totalrecords" default=#get_flexible_worktime_row.recordcount#>
                        <cfoutput query = "get_flexible_worktime_row" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                            <cfif get_flexible_worktime_row.recordcount>
                                <tr>
									<td>
                                        #current_row#
										<cfset current_row = current_row + 1>
                                    </td>
                                    <td>
                                        #get_emp_info(get_flexible_worktime.employee_id,0,0)#
                                    </td>
                                    <td>
                                        <cfset get_branches_row = cmp_branch.get_branch(branch_status:1,branch_id : get_flexible_worktime.branch_id)>
                                        #get_branches_row.branch_name#
                                    </td>
                                    <td>
                                        <cfset get_department_ = cmp_department.get_department(department_id :get_flexible_worktime.department_id)>
                                        #get_department_.department_head#
                                    </td>
                                    <td> 
                                        <cfif len(get_flexible_worktime_row.FLEXIBLE_DATE)>
                                            #dateFormat(get_flexible_worktime_row.FLEXIBLE_DATE,dateformat_style)#
                                        <cfelse>
                                            #get_flexible_worktime_row.FLEXIBLE_YEAR# - #Evaluate('ay#get_flexible_worktime_row.FLEXIBLE_MONTH#')# - #listGetAt(days_name,get_flexible_worktime_row.FLEXIBLE_DAY)#
                                        </cfif>
                                    </td>
                                    <td>
                                        <cfif #get_flexible_worktime_row.flexible_start_hour# lt 10>0</cfif>#get_flexible_worktime_row.flexible_start_hour#.<cfif #get_flexible_worktime_row.flexible_start_minute# lt 10>0</cfif>#get_flexible_worktime_row.flexible_start_minute# - <cfif #get_flexible_worktime_row.flexible_finish_hour# lt 10>0</cfif>#get_flexible_worktime_row.flexible_finish_hour#.<cfif #get_flexible_worktime_row.flexible_finish_minute# lt 10>0</cfif>#get_flexible_worktime_row.flexible_finish_minute# 
                                    </td>
                                    <td>
                                        <cfif get_flexible_worktime_row.IS_APPROVE eq 0><cf_get_lang dictionary_id ="57615.Onay Bekliyor"><cfelseif get_flexible_worktime_row.IS_APPROVE eq 1><cf_get_lang dictionary_id ="58699.Onaylandı"><cfelseif get_flexible_worktime_row.IS_APPROVE eq -1> <cf_get_lang dictionary_id ="54645.Red Edildi"></cfif>
                                    </td>
                                    <cfif isDefined("x_show_level") and x_show_level eq 1>
                                        <td>                            
                                            <cfset up_dep_len = listlen(HIERARCHY_DEP_ID1,'.')>
                                            <cfif up_dep_len gt 0>
                                                <cfset temp = up_dep_len> 
                                                <cfloop from="1" to="#up_dep_len#" index="i" step="1">
                                                    <cfif isdefined("HIERARCHY_DEP_ID1") and listlen(HIERARCHY_DEP_ID1,'.') gt temp>
                                                        <cfset up_dep_id = ListGetAt(HIERARCHY_DEP_ID1, listlen(HIERARCHY_DEP_ID1,'.')-temp,".")>
                                                        <cfquery name="get_upper_departments" datasource="#dsn#">
                                                            SELECT DEPARTMENT_HEAD, LEVEL_NO FROM DEPARTMENT WHERE DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#up_dep_id#">
                                                        </cfquery>
                                                        <cfset up_dep_head = get_upper_departments.department_head>
                                                        #up_dep_head# 
                                                            <cfset get_org_level = cmp_org_step.get_organization_step(level_no : get_upper_departments.LEVEL_NO)>
                                                            <cfif get_org_level.recordcount>
                                                                (#get_org_level.ORGANIZATION_STEP_NAME#)
                                                            </cfif>
                                                        <cfif up_dep_len neq i>
                                                            >
                                                        </cfif>
                                                    <cfelse>
                                                        <cfset up_dep_head = ''>
                                                    </cfif>
                                                    <cfset temp = temp - 1>
                                                </cfloop>
                                            </cfif>​
                                        </td>
                                    </cfif>
                                </tr>
                            <cfelse>
                                <tr>
                                    <td colspan="7"><cfif isdefined("attributes.form_submitted")><cf_get_lang_main no='72.Kayıt Bulunamadı'> !<cfelse><cf_get_lang_main no='289.Filtre Ediniz '>!</cfif></td>
                                </tr>
                            </cfif>
                        </cfoutput>
                    </cfloop>
                </tbody>
            </div>
        <cf_grid_list>
        <cfif attributes.totalrecords gt attributes.maxrows>
            <cf_paging page="#attributes.page#"
                    maxrows="#attributes.maxrows#"
                    totalrecords="#attributes.totalrecords#"
                    startrow="#attributes.startrow#"
                    adres="#adres#&is_form_submitted=1"
                    >
        </cfif>
    </cf_box>
 </cfif>
<script type="text/javascript">
    function open_update_page (flexible_id,emp_id){
        window.open("<cfoutput>#request.self#?fuseaction=#fuseaction#.flexible_worktime&event=upd&flexible_id=</cfoutput>"+flexible_id+"&emp_id="+emp_id, '_blank');
    }
    function showDepartment(branch_id)	
	{
		var branch_id = document.getElementById('branch_id').value;
		if (branch_id != "")
		{
			var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_ajax_list_hr&show_div=0&branch_id="+branch_id;
			AjaxPageLoad(send_address,'department_div',1,'İlişkili Departmanlar');
		}
	}
    function kontrol()
    {
        if($("#is_excel").prop('checked') == false)
		{
            $('#flexible_worktime_form').attr('action', '<cfoutput>#request.self#?fuseaction=#attributes.fuseaction#</cfoutput>');
		}
		else{
           
            $('#flexible_worktime_form').attr('action', '<cfoutput>#request.self#?fuseaction=report.emptypopup_flexible_worktime</cfoutput>');

        }
        return true;
    }
</script>
