<!---
    File: list_flexible_worktime.cfm
    Controller: hrFlexibleWorkTimeController.cfm
    Author: Esma R. UYSAL
    Date: 07/12/2019 
    Description:
        HR modüülü esnek çalışma saatleri listeleme sayfasıdır.
--->
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
<!--- Toplu Onay --->
<cfif isdefined("attributes.paper_submit") and len(attributes.paper_submit) and attributes.paper_submit eq 1>
    <cfif isDefined("attributes.action_list_id") and Listlen(attributes.action_list_id) gt 0>
        <cfset totalValues = structNew()>
        <cfset totalValues = {
                total_offtime : 0
            }>
        <cfset action_list_id = replace(attributes.action_list_id,";",",","all")>
        <cf_workcube_general_process
            mode = "query"
            general_paper_parent_id = "#(isDefined("attributes.general_paper_parent_id") and len(attributes.general_paper_parent_id)) ? attributes.general_paper_parent_id : 0#"
            general_paper_no = "#attributes.general_paper_no#"
            general_paper_date = "#attributes.general_paper_date#"
            action_list_id = "#action_list_id#"
            process_stage = "#attributes.process_stage#"
            general_paper_notice = "#attributes.general_paper_notice#"
            responsible_employee_id = "#(isDefined("attributes.responsible_employee_id") and len(attributes.responsible_employee_id) and isDefined("attributes.responsible_employee") and len(attributes.responsible_employee)) ? attributes.responsible_employee_id : 0#"
            responsible_employee_pos = "#(isDefined("attributes.responsible_employee_pos") and len(attributes.responsible_employee_pos) and isDefined("attributes.responsible_employee") and len(attributes.responsible_employee)) ? attributes.responsible_employee_pos : 0#"
            action_table = 'WORKTIME_FLEXIBLE'
            action_column = 'WORKTIME_FLEXIBLE_ID'
            action_page = '#request.self#?fuseaction=hr.flexible_worktime'
            total_values = '#totalValues#'
        >
        <cfset attributes.approve_submit = 0>
    </cfif>
</cfif>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfif len(attributes.employee_id)>
    <cfset attributes.employee_id = listFirst(attributes.employee_id,"_")>
</cfif>
<cfparam name="attributes.position_id" default="">
<cfsavecontent variable = "title">
    <cf_get_lang dictionary_id = "59820.Esnek Çalışma Talepleri">
</cfsavecontent>
<cfset flex_component = createObject("component","V16.myhome.cfc.flexible_worktime")>
<cfset fuseaction = listFirst(attributes.fuseaction,".")>
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
<cfset get_branches = cmp_branch.get_branch(branch_status:1)>
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
                            <input type="text" name="group_paper_no" id="group_paper_no" placeholder="Toplu Belge No" value="<cfoutput>#attributes.group_paper_no#</cfoutput>" />
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
                        <cf_wrk_search_button  button_type="4">
                    </div>
                </div>
            </div>
        </cfform>
    </cf_box_search>
</cf_box>
<cfif attributes.type eq 1>
    <cfform name="setProcessForm" id="setProcessForm" method="post" action="">
        <cfparam name="attributes.totalrecords" default=#get_flexible_worktime.recordcount#>
        <cf_box id="list_worknet_list" closable="0" collapsable="1" title="#title#" add_href="#request.self#?fuseaction=hr.flexible_worktime&event=add"> 
            <cf_ajax_list>
                <div id="Note_list">
                    <thead>
                        <tr>
							<th></th>
                            <th><cf_get_lang dictionary_id = '57576.Çalışan'></th>
                            <th><cf_get_lang dictionary_id='57453.Şube'></th>
                            <th><cf_get_lang_main no='160.Departman'></th>
                            <th><cf_get_lang dictionary_id = "55285.Talep Tarihi"></th>
                            <th><cf_get_lang dictionary_id = "41129.Süreç/Aşama"></th>
                            <th></th>
                            <cfif listfirst(attributes.fuseaction,'.') eq 'hr' and len(attributes.filter_process)>
                                <th><input class="checkControl" type="checkbox" id="checkAll" name="checkAll" value="0" /></th>
                            </cfif>
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
                                        <cf_workcube_process type="color-status" process_stage="#STAGE_ID#">
                                    </td>
                                    <td style="text-align:center">
                                        <cfsavecontent  variable="upd_title">
                                            <cf_get_lang dictionary_id = "57464.Güncelle">
                                        </cfsavecontent>
                                        <a href="javascript://" onclick="open_update_page('#worktime_flexible_id#','#get_flexible_worktime.employee_id#')" title ="#upd_title#"><span class="icn-md icon-update" style="color :##808080 !important"></span></a>
                                    </td>
                                    <cfif listfirst(attributes.fuseaction,'.') eq 'hr' and  len(attributes.filter_process)>
										<td>
											<input class="checkControl" type="checkbox" name="action_list_id" id="action_list_id" value="#worktime_flexible_id#" />
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
            </cf_ajax_list>
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
        <cfif len(attributes.filter_process)>
            <cf_box id="list_checked" closable="0" collapsable="0" title="Toplu Onay">
                <cfset get_process_f = cmp_process.GET_PROCESS_TYPES(
                    faction_list : 'hr.flexible_worktime',
                    filter_stage: attributes.filter_process
                    )>
                <div class="row" type="row">
                    <div class="col col-4 col-xs-12" type="column" index="1" sort="true">
                        <cf_workcube_general_process print_type="122" select_value = '#get_process_f.process_row_id#'>
                    </div>
                </div>
                <cf_box_footer>
                    <div class="col col-12 col-xs-12 text-right">
                        <input type="hidden" id="paper_submit" name="paper_submit" value="0">
                        <input type="submit" name="setOfftimeProcess" id="setOfftimeProcess" onclick="if(confirm('<cf_get_lang dictionary_id='57535.Kaydetmek istediğinize emin misiniz'>')) return setofftimesProcess(); else return false;" value="<cf_get_lang dictionary_id='57461.Kaydet'>">
                    </div>
                </cf_box_footer>
            </cf_box>
        </cfif>
    </cfform>
<cfelseif type eq 2>
    <cf_box id="list_worknet_list" closable="0" collapsable="1" title = "#title#"add_href="#request.self#?fuseaction=#fuseaction#.flexible_worktime&event=add" > 
        <cf_ajax_list>
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
                        <th></th>
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
                                    <td style="text-align:center">
                                        <cfsavecontent  variable="upd_title">
                                            <cf_get_lang dictionary_id = "57464.Güncelle">
                                        </cfsavecontent>
                                        <a href="javascript://" onclick="open_update_page('#get_flexible_worktime.worktime_flexible_id#','#get_flexible_worktime.employee_id#')" title ="#upd_title#"><span class="icn-md icon-update" style="color :##808080 !important"></span></a> 
                                    </td>
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
        <cf_ajax_list>
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
    $(function(){
            $('input[name=checkAll]').click(function(){
                if(this.checked){
                    $('.checkControl').each(function(){
                        $(this).prop("checked", true);
                    });
                }
                else{
                    $('.checkControl').each(function(){
                        $(this).prop("checked", false);
                    });
                }
            });
        });
	 function setofftimesProcess(){
		var controlChc = 0;
		$('.checkControl').each(function(){
			if(this.checked){
				controlChc += 1;
			}
		});
		if(controlChc == 0){
			alert("İzin Seçiniz");
			return false;
		}
		if( $.trim($('#general_paper_no').val()) == '' ){
			alert("<cf_get_lang dictionary_id='33367.Lütfen Belge No Giriniz'>");
			return false;
		}else{
			paper_no_control = wrk_safe_query('general_paper_control','dsn',0,$('#general_paper_no').val());
			if(paper_no_control.recordcount > 0)
			{
            	alert("<cf_get_lang dictionary_id='49009.Girdiğiniz Belge Numarası Kullanılmaktadır'>.<cf_get_lang dictionary_id='59367.Otomatik olarak değişecektir'>.");
				paper_no_val = $('#general_paper_no').val();
				paper_no_split = paper_no_val.split("-");
				if(paper_no_split.length == 1)
					paper_no = paper_no_split[0];
				else
					paper_no = paper_no_split[1];
				paper_no = parseInt(paper_no);
				paper_no++;
				if(paper_no_split.length  == 1)
					$('#general_paper_no').val(paper_no);
				else
					$('#general_paper_no').val(paper_no_split[0]+"-"+paper_no);
                return false;
			}
		}
		if( $.trim($('#general_paper_date').val()) == '' ){
			alert("Lütfen Belge Tarihi Giriniz!");
			return false;
		}
		if( $.trim($('#general_paper_notice').val()) == '' ){
			alert("Lütfen Ek Açıklama Giriniz!");
			return false;
		}
		document.getElementById("paper_submit").value = 1;
		$('#setProcessForm').submit();
		
	}
</script>
