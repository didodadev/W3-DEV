<!---
    File: upd_flexible_worktime.cfm
    Controller: fuseaction is myhome = FlexibleWorkTimeController.cfm, fuseaction is hr = hrFlexibleWorkTimeController.cfm
    Author: Esma R. UYSAL
    Date: 07/12/2019 
    Description:
        Esnek çalışma saatleri gündelleme form sayfasıdır.
        Hem hr modülü ve myhome üzerinde çalışır.
        Myhome dan girildiğinde Başvuru yapan, Şube ve Departman seçili olarak gelmektedir.
--->
<cfset fuseaction = listFirst(attributes.fuseaction,".")>
<cfif fuseaction eq 'myhome'>
    <cfset attributes.flexible_id = contentEncryptingandDecodingAES(isEncode:0,content:attributes.flexible_id,accountKey:'wrk')>
</cfif>
<cfparam name="attributes.employee_id" default="#session.ep.userid#" />
<cfset cmp_branch = createObject("component","V16.hr.cfc.get_branch_comp")>
<cfset cmp_branch.dsn = dsn>
<cfset flex_component = createObject("component","V16.myhome.cfc.flexible_worktime")>
<cfset get_flexible_worktime = flex_component.GET_WORKTIME_FLEXIBLE(flexible_id : attributes.flexible_id)>
<cfset get_flexible_worktime_row = flex_component.GET_WORKTIME_FLEXIBLE_ROW(flexible_id : attributes.flexible_id)>
<cfset get_branches = cmp_branch.get_branch(branch_status:1)>
<cfset cmp_department = createObject("component","V16.hr.cfc.get_departments")>
<cfset cmp_department.dsn = dsn>
<cfset get_department = cmp_department.get_department(branch_id : get_flexible_worktime.branch_id)>
<cfset periods = createObject('component','V16.objects.cfc.periods')>
<cfset period_years = periods.get_period_year()>
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
<cfset record_count_row = 0>
<cf_catalystHeader>
<cfsavecontent variable = "header"><cf_get_lang dictionary_id = "38598.Flexible Work Application"></cfsavecontent>
<cf_box title="#header#" closable="0">
     <div class="row">
		<div class="col col-12 uniqueRow">
            <cfform name="flexible_worktime" id="flexible_worktime" action="" enctype="multipart/form-data" method="post">
                <div class="row" type="row">
                    <input type = "hidden" id = "row_count" name = "row_count" value = "">
                    <input type = "hidden" id = "flexible_id" name = "flexible_id" value = "<cfoutput>#attributes.flexible_id#</cfoutput>">
                    <div class="col col-5 col-md-6 col-xs-12" type="column" index="1" sort="true">
                        <div class="form-group" id="item-process">
                            <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id = '58859.Süreç'></label>
                            <div class="col col-9 col-xs-12">
                                <cf_workcube_process is_upd='0' select_value="#get_flexible_worktime.STAGE_ID#" is_detail='1'>
                            </div>
                        </div>
                        <div class="form-group" id="item-date">
                            <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id = '58593.Tarihi'> *</label>
                            <div class="col col-9 col-xs-12">
                                <div class="input-group">
                                   <cfinput type="text" name="request_date" id="request_date" maxlength="10" required="Yes" validate="#validate_style#"  style="width:65px;" value="#dateformat(get_flexible_worktime.request_date,dateformat_style)#">
                                   <span class="input-group-addon"> <cf_wrk_date_image date_field="request_date"> </span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-employee">
                            <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id="29514.Başvuru yapan"> *</label>
                            <div class="col col-9 col-xs-12">
                                <div class="input-group">
                                    <input type="hidden" name="employee_id" id="employee_id" value="<cfoutput>#get_flexible_worktime.employee_id#</cfoutput>">
                                    <input type="hidden" name="position_id" id="position_id" value="<cfoutput>#get_flexible_worktime.position_id#</cfoutput>">
                                    <input type="text" name="employee" id="employee" onFocus="AutoComplete_Create('employee','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','\'3,9\',\'0\',\'0\',\'0\',\'\',\'\',\'\',\'1\'','EMPLOYEE_ID,MEMBER_TYPE','employee_id','','3','135');" style="width:120px;" value="<cfoutput>#get_emp_info(get_flexible_worktime.employee_id,0,0)# </cfoutput>">
                                    <span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&is_display_self=1&is_cari_action=1&field_emp_id=add_health_expense.employee_id&field_name=add_health_expense.employee&field_type=add_health_expense.employee_id&field_id=position_id&select_list=1,9','list');"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-branch">
                            <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57453.Şube'> *</label>
                            <div class="col col-9 col-xs-12">
                                <select name="branch_id" id="branch_id" onChange="showDepartment(this.value)" >
                                    <cfoutput query="get_branches" group="NICK_NAME">
                                        <optgroup label="#get_branches.NICK_NAME#"></optgroup>
                                        <cfoutput>
                                            <option value="#get_branches.BRANCH_ID#"<cfif get_flexible_worktime.branch_id eq get_branches.branch_id>selected</cfif>>#get_branches.BRANCH_NAME#</option>
                                        </cfoutput>
                                    </cfoutput>
                                </select>
                            </div>
                        </div>
                        <div class="form-group" id="item-department">
                            <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57572.Departman'> *</label>
                            <div class="col col-9 col-xs-12" id="department_div">
                                <select name="department_id" id="department_id" > 
                                    <option value=""><cf_get_lang_main no='160.Departman'></option>
                                    <cfoutput query="get_department">
                                        <option value="#department_id#" <cfif get_flexible_worktime.department_id eq get_department.department_id>selected</cfif>>#department_head#</option>
                                    </cfoutput>
                                </select>
                            </div>
                        </div>
                        <div class="form-group" id="item-employee">
                            <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id="57467.Not"></label>
                            <div class="col col-9 col-xs-12">
                                <textarea id="desciription" name="woRktime_flexible_notice" class="form-control" style="height:50px;"><cfoutput>#get_flexible_worktime.worktime_flexible_notice#</cfoutput></textarea>
                            </div>
                        </div>
                    </div>
                    <div class = "col col-12 col-md-12 col-xs-12 " type="column" index="2" sort="false">
                        <div class="form-group mt-3 mb-3" id="item-label">
                            <label style="color : #E08283 ; font-size :14px"><b><cf_get_lang dictionary_id = '41799.Seçeceğiniz Ay ve Yıl İçerisinde Periyodik Olarak Esnek Çalışmak İstediğiniz Gün ve Saat Aralığını Girmek İçin + ya Tıklayınız..'></b></label>
                        </div>
                        <cf_form_list margin="1">
                            <thead>
                                <th style="text-align:center;width:25px;"><input type="button" class="eklebuton" title="" onClick="add_row();" value=""></th>
                                <th style="width:45px;" id = "year_th"><cf_get_lang dictionary_id = "58455.Yıl"></th>
                                <th style="width:60px;" id = "month_th"><cf_get_lang dictionary_id = "58724.Ay"></th>
                                <th style="width:65px;" id = "day_th"><cf_get_lang dictionary_id = "57490.Gün"></th>
                                <th style="width:200px;" ><cf_get_lang dictionary_id = "41014.Saat aralığı"></th>
                                <th style="width:45px;"></th>
                            </thead>
                            <tbody id="add_flexible_worktime_normal">
                                <cfif get_flexible_worktime_row.recordcount>
                                    <cfoutput query = "get_flexible_worktime_row" >
                                        <cfif not len(flexible_date)>
                                            <cfset record_count_row = record_count_row + 1>
                                            <input type = "hidden" name = "current_id#currentrow#" id = "current_id#currentrow#" value = "#WORKTIME_FLEXIBLE_ROW_ID#">
                                            <input type = "hidden" name = "is_del#currentrow#" id = "is_del#currentrow#" value = "0">
                                            <input type = "hidden" name = "is_approve#WORKTIME_FLEXIBLE_ROW_ID#" id = "is_approve#WORKTIME_FLEXIBLE_ROW_ID#" value = "<cfif len(is_approve)>#is_approve#<cfelse>0</cfif>">
                                            <tr id = "row_#currentrow#" name = "#currentrow#">
                                                <td style = "text-align:center"><a style="cursor:pointer" onclick="del_row(#currentrow#,#WORKTIME_FLEXIBLE_ROW_ID#);" ><img  src="images/delete_list.gif" border="0"></a></td>
                                                <td style = "text-align:center">
                                                    <select name = "period_years#currentrow#" id = "period_years#currentrow#" class = "boxtext multiSelect" <cfif len(flexible_date)>style = "display :none"</cfif>>
                                                        <cfloop query = "period_years"> 
                                                            <option value="#period_year#" <cfif get_flexible_worktime_row.flexible_year eq period_year>selected</cfif>>#period_year#</option>
                                                        </cfloop>
                                                    </select>
                                                </td>
                                                <td style = "text-align:center">
                                                    <select name = "flexible_month#currentrow#" id = "flexible_month#currentrow#" class = "boxtext" <cfif len(flexible_date)>style = "display :none"</cfif>>
                                                        <cfloop index="i" from="1" to="12">
                                                            <option value="#i#" <cfif get_flexible_worktime_row.flexible_month eq i>selected</cfif>>#Evaluate('ay#i#')#</option>
                                                        </cfloop>
                                                    </select>
                                                </td>
                                                <td style = "text-align:center">
                                                    <select name="flexible_day#currentrow#" id="flexible_day#currentrow#" class = "boxtext" <cfif len(flexible_date)>style = "display :none"</cfif>> 
                                                        <cfloop from="1" to="7" index="c">
                                                            <option value="#c#" <cfif flexible_day eq c>selected</cfif>>#listGetAt(days_name,c)#</option>
                                                        </cfloop>
                                                    </select>
                                                </td> 
                                                <td style = "text-align:center" nowrap="nowrap">
                                                    <cf_wrktimeformat name="flexible_start_hour#currentrow#" value = "#flexible_start_hour#"><select name="flexible_start_min#currentrow#">
                                                        <option value=""><cf_get_lang dictionary_id="58827.min"></option>
                                                        <cfloop from="0" to="59" index="i" step="5">
                                                            <option value="#i#" <cfif flexible_start_minute eq i>selected</cfif>><cfif i lt 10>0</cfif>#i#</option>
                                                        </cfloop>
                                                    </select> - 
                                                    <cf_wrktimeformat name="flexible_finish_hour#currentrow#" value = "#flexible_finish_hour#"><select name="flexible_finish_min#currentrow#">
                                                        <option value=""><cf_get_lang dictionary_id="58827.min"></option>
                                                        <cfloop from="0" to="59" index="i" step="5">
                                                            <option value="#i#" <cfif flexible_finish_minute eq i>selected</cfif>><cfif i lt 10>0</cfif>#i#</option>
                                                        </cfloop>
                                                    </select>
                                                </td>
                                                <td class="text-center">
                                                    <div id="approve_valid#WORKTIME_FLEXIBLE_ROW_ID#">              
                                                        <cfif get_flexible_worktime_row.IS_APPROVE eq 0>
                                                            <cfsavecontent variable="message"><cf_get_lang dictionary_id ='58196.Onaylamak istediğinizden emin misiniz'></cfsavecontent>
                                                            <label title="<cf_get_lang_main no ='1063.Onayla'>" onclick="if (confirm('#message#')) {is_approve(1,#WORKTIME_FLEXIBLE_ROW_ID#);} else {return false}"><i class="icon-check btnPointer font-green"></i></label>
                                                            <cfsavecontent variable="message"><cf_get_lang dictionary_id ='47665.OReddetmek istediğinizden emin misiniz'></cfsavecontent>					
                                                            <label title="<cf_get_lang_main no='1049.Reddet'>" onclick="if (confirm('#message#')) {is_approve('-1',#WORKTIME_FLEXIBLE_ROW_ID#);} else {return false}"><i class="icon-times btnPointer font-red"></i></label>
                                                        <cfelseif get_flexible_worktime_row.IS_APPROVE eq 1>
                                                            <cf_get_lang dictionary_id ="58699.Onaylandı">
                                                        <cfelseif get_flexible_worktime_row.IS_APPROVE eq -1> 
                                                            <cf_get_lang dictionary_id ="54645.Red Edildi">
                                                        </cfif>
                                                    </div>
                                                </td>
                                            </tr>
                                        </cfif>
                                    </cfoutput>
                                </cfif>
                            </tbody>
                        </cf_form_list>
                    </div>
                    <div class = "col col-12 col-md-12 col-xs-12 " type="column" index="3" sort="false">
                        <div class="form-group mt-3 mb-3" id="item-label">
                            <label style="color : #E08283 ; font-size :14px"><b><cf_get_lang dictionary_id = '41798.Esnek Çalışmak İsteiğiniz Tarih ve Saat Aralığı Eklemek İçin  + ya Tıklayınız.'></b></label>
                        </div>
                        <cf_form_list margin="1">
                            <thead>
                                <th style="text-align:center;width:25px;"><input type="button" class="eklebuton" title="" onClick="add_row_2();" value=""></th>
                                <th style="width:205px;" id = "date_th"><cf_get_lang dictionary_id = "57742.Tarih"></th>
                                <th style="width:200px;"><cf_get_lang dictionary_id = "41014.Saat aralığı"></th>
                                <th style="width:45px;"></th>
                            </thead>
                            <tbody id="add_flexible_worktime_period">
                                <cfif get_flexible_worktime_row.recordcount>
                                    <cfoutput query = "get_flexible_worktime_row" >
                                        <cfif len(flexible_date)>
                                            <cfset record_count_row = record_count_row + 1>
                                            <input type = "hidden" name = "current_id#currentrow#" id = "current_id#currentrow#" value = "#WORKTIME_FLEXIBLE_ROW_ID#">
                                            <input type = "hidden" name = "is_del#currentrow#" id = "is_del#currentrow#" value = "0">
                                            <input type = "hidden" name = "is_approve#WORKTIME_FLEXIBLE_ROW_ID#" id = "is_approve#WORKTIME_FLEXIBLE_ROW_ID#" value = "<cfif len(is_approve)>#is_approve#<cfelse>0</cfif>">
                                            <tr id = "row_#currentrow#" name = "#currentrow#">
                                                <td style = "text-align:center"><a style="cursor:pointer" onclick="del_row(#currentrow#,#WORKTIME_FLEXIBLE_ROW_ID#);" ><img  src="images/delete_list.gif" border="0"></a></td>
                                                <td >
                                                    <input type="text" name="work_date_row#currentrow#" id="work_date_row#currentrow#" class="text" maxlength="10" value="#dateformat(flexible_date,dateformat_style)#">
                                                    <!---<i class="icon-calendar-o" align="absbottom" id="work_date_row#currentrow#_image" border="0" style="cursor:pointer;"></i>---->
                                                    <cf_wrk_date_image date_field="work_date_row#currentrow#"> 
                                                </td>
                                                <td style = "text-align:center" nowrap="nowrap">
                                                    <cf_wrktimeformat name="flexible_start_hour#currentrow#" value = "#flexible_start_hour#"><select name="flexible_start_min#currentrow#">
                                                        <option value=""><cf_get_lang dictionary_id="58827.min"></option>
                                                        <cfloop from="0" to="59" index="i" step="5">
                                                            <option value="#i#" <cfif flexible_start_minute eq i>selected</cfif>><cfif i lt 10>0</cfif>#i#</option>
                                                        </cfloop>
                                                    </select> - 
                                                    <cf_wrktimeformat name="flexible_finish_hour#currentrow#" value = "#flexible_finish_hour#"><select name="flexible_finish_min#currentrow#">
                                                        <option value=""><cf_get_lang dictionary_id="58827.min"></option>
                                                        <cfloop from="0" to="59" index="i" step="5">
                                                            <option value="#i#" <cfif flexible_finish_minute eq i>selected</cfif>><cfif i lt 10>0</cfif>#i#</option>
                                                        </cfloop>
                                                    </select>
                                                </td>
                                                <td class="text-center">
                                                    <div id="approve_valid#WORKTIME_FLEXIBLE_ROW_ID#">  
                                                        <cfif get_flexible_worktime_row.IS_APPROVE eq 0>
                                                            <cfsavecontent variable="message"><cf_get_lang dictionary_id ='58196.Onaylamak istediğinizden emin misiniz'></cfsavecontent>
                                                            <label title="<cf_get_lang_main no ='1063.Onayla'>" onclick="if (confirm('#message#')) {is_approve(1,#WORKTIME_FLEXIBLE_ROW_ID#);} else {return false}"><i class="icon-check btnPointer font-green"></i></label>
                                                            <cfsavecontent variable="message"><cf_get_lang dictionary_id ='47665.OReddetmek istediğinizden emin misiniz'></cfsavecontent>					
                                                            <label title="<cf_get_lang_main no='1049.Reddet'>" onclick="if (confirm('#message#')) {is_approve('-1',#WORKTIME_FLEXIBLE_ROW_ID#);} else {return false}"><i class="icon-times btnPointer font-red"></i></label>
                                                        <cfelseif get_flexible_worktime_row.IS_APPROVE eq 1>
                                                            <cf_get_lang dictionary_id ="58699.Onaylandı">
                                                        <cfelseif get_flexible_worktime_row.IS_APPROVE eq -1> 
                                                            <cf_get_lang dictionary_id ="54645.Red Edildi">
                                                        </cfif>
                                                    </div>
                                                </td>
                                            </tr>
                                        </cfif>
                                    </cfoutput>
                                </cfif>
                            </tbody>
                        </cf_form_list>
                    </div>
                </div>
                <cf_box_footer>
                    <cf_record_info query_name="get_flexible_worktime">
                    <cf_workcube_buttons is_upd='1' add_function="kontrol()" is_delete ="0">
                </cf_box_footer>
            </cfform>
        </div>
    </div>
</cf_box>
<script type="text/javascript">
    row_count = "<cfoutput>#record_count_row#</cfoutput>";
    row_count_control = "<cfoutput>#record_count_row#</cfoutput>";
    document.getElementById("row_count").value = row_count;
    function showDepartment(branch_id)	
	{
		var branch_id = document.getElementById('branch_id').value;
		if (branch_id != "")
		{
			var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_ajax_list_hr&show_div=0&branch_id="+branch_id;
			AjaxPageLoad(send_address,'department_div',1,'İlişkili Departmanlar');
		}
	}
    function add_row(){
        row_count++;
        row_count_control++;
        var newRow;
        document.getElementById("row_count").value = row_count;
        newRow = document.getElementById("add_flexible_worktime_normal").insertRow(document.getElementById("add_flexible_worktime_normal").rows.length);	
        newRow.setAttribute("name","" + row_count);
        newRow.setAttribute("id","row_" + row_count);
        
        newCell = newRow.insertCell(newRow.cells.length);
        newCell.innerHTML = '<input type = "hidden" name = "is_approve' + row_count +'" id = "is_approve' + row_count +'" value = "0"><input type = "hidden" name = "is_del' + row_count +'" id = "is_del' + row_count +'" value = "0"><input type = "hidden" name = "current_id' + row_count +'" id = "current_id' + row_count +'" value = "-1"><a style="cursor:pointer" onclick="del_row(' + row_count + ');" ><img  src="images/delete_list.gif" border="0"></a>';
        newCell.setAttribute("style","text-align:center");

        newCell = newRow.insertCell(newRow.cells.length);
        newCell.innerHTML = '<select name = "period_years'+ row_count +'" id = "period_years'+ row_count +'" class = "boxtext"><cfoutput query = "period_years"> <option value="#period_year#" <cfif session.ep.period_year eq period_year>selected</cfif>>#period_year#</option></cfoutput></select>';
        newCell.setAttribute("style","text-align:center");

        newCell = newRow.insertCell(newRow.cells.length);
        newCell.innerHTML = '<select name = "flexible_month'+ row_count +'" id = "flexible_month'+ row_count +'" class = "boxtext"><cfloop index="i" from="1" to="12"><cfoutput><option value="#i#">#Evaluate('ay#i#')#</option></cfoutput></cfloop></select>';
        newCell.setAttribute("style","text-align:center");
 
        newCell = newRow.insertCell(newRow.cells.length);		
		newCell.innerHTML = '<select name="flexible_day' + row_count +'" id="flexible_day' + row_count +'" class = "boxtext"> <cfloop from="1" to="7" index="c"><cfoutput><option value="#c#">#listGetAt(days_name,c)#</option></cfoutput></cfloop></select>';
        newCell.setAttribute("style","text-align:center");

		newCell = newRow.insertCell(newRow.cells.length);		
		newCell.innerHTML = '<cf_wrktimeformat name="flexible_start_hour' + row_count + '"><select name="flexible_start_min' + row_count + '"><option value=""><cf_get_lang dictionary_id="58827.min"></option><cfloop from="0" to="59" index="i" step="5"><cfoutput><option value="#i#"><cfif i lt 10>0</cfif>#i#</option></cfoutput></cfloop></select> - <cf_wrktimeformat name="flexible_finish_hour' + row_count + '"><select name="flexible_finish_min' + row_count + '"><option value=""><cf_get_lang dictionary_id="58827.min"></option><cfloop from="0" to="59" index="i" step="5"><cfoutput><option value="#i#"><cfif i lt 10>0</cfif>#i#</option></cfoutput></cfloop></select>';
        newCell.setAttribute("style","text-align:center");
        newCell.setAttribute("nowrap","nowrap");
        <cfif fuseaction is 'hr'>newCell = newRow.insertCell(newRow.cells.length);</cfif>
    }
    function add_row_2(){
        row_count++;
        row_count_control++;
        var newRow;
        document.getElementById("row_count").value = row_count;
        newRow = document.getElementById("add_flexible_worktime_period").insertRow(document.getElementById("add_flexible_worktime_period").rows.length);	
        newRow.setAttribute("name","" + row_count);
        newRow.setAttribute("id","row_" + row_count);
        
        newCell = newRow.insertCell(newRow.cells.length);
        newCell.innerHTML = '<input type = "hidden" name = "is_approve' + row_count +'" id = "is_approve' + row_count +'" value = "0"><input type = "hidden" name = "is_del' + row_count +'" id = "is_del' + row_count +'" value = "0"><input type = "hidden" name = "current_id' + row_count +'" id = "current_id' + row_count +'" value = "-1"><a style="cursor:pointer" onclick="del_row(' + row_count + ');" ><img  src="images/delete_list.gif" border="0"></a>';
        newCell.setAttribute("style","text-align:center");

        newCell = newRow.insertCell(newRow.cells.length);
        newCell.setAttribute("id","work_date_row" + row_count + "_td");
        newCell.innerHTML = '<input type="text" name="work_date_row' + row_count +'" id="work_date_row' + row_count +'" class="text" maxlength="10" value="" > ';
        wrk_date_image('work_date_row' + row_count);


		newCell = newRow.insertCell(newRow.cells.length);		
		newCell.innerHTML = '<cf_wrktimeformat name="flexible_start_hour' + row_count + '"><select name="flexible_start_min' + row_count + '"><option value=""><cf_get_lang dictionary_id="58827.min"></option><cfloop from="0" to="59" index="i" step="5"><cfoutput><option value="#i#"><cfif i lt 10>0</cfif>#i#</option></cfoutput></cfloop></select> - <cf_wrktimeformat name="flexible_finish_hour' + row_count + '"><select name="flexible_finish_min' + row_count + '"><option value=""><cf_get_lang dictionary_id="58827.min"></option><cfloop from="0" to="59" index="i" step="5"><cfoutput><option value="#i#"><cfif i lt 10>0</cfif>#i#</option></cfoutput></cfloop></select>';
        newCell.setAttribute("style","text-align:center");
        newCell.setAttribute("nowrap","nowrap");
        <cfif fuseaction is 'hr'>newCell = newRow.insertCell(newRow.cells.length);</cfif>

    }
    function del_row(del_row_num,id)//Satır silme fonksiyonu
    {
        if(confirm ("<cf_get_lang dictionary_id = '36628.Satırı silmek istediğinize emin misiniz?'> ? "))
        {
            $( "[id = 'row_"+del_row_num+"']" ).each(function( index ) {
                
                $( this ).remove();
                document.getElementById("is_del"+del_row_num).value=1;
                row_count_control--;
            });
        }else return false;
    }
    function is_approve(valid_type_,approve_id)
	{
		div_id = 'approve_valid'+approve_id;
		var send_address = '<cfoutput>#request.self#</cfoutput>?fuseaction=myhome.flexible_worktime&event=ajaxApprove&valid_type='+ valid_type_ +'&approve_id='+approve_id;
		AjaxPageLoad(send_address,div_id,1);
	}
    function kontrol(){
        if(row_count_control == 0 ){
            alert("<cf_get_lang dictionary_id = '33822.Lütfen satır ekleyiniz'>");
            return false;
        }else{
            for(i = 1; i <= row_count_control; i++){
                if(document.getElementById("work_date_row"+i)){
                    if(document.getElementById("work_date_row"+i).value == ''){
                        alert("<cf_get_lang dictionary_id = '58222.Lütfen Satıra Tarih Giriniz'>");
                        return false;
                    }
                }
                start_clock = $('#flexible_start_hour'+i).val();
                finish_clock = $('#flexible_finish_hour'+i).val();
                start_minute = $('#flexible_start_min'+i).val();
                finish_minute = $('#flexible_finish_min'+i).val();
                if(start_clock != undefined && start_minute != undefined && finish_clock != undefined && finish_minute != undefined)
                {
                    if(start_clock > finish_clock) 
                    {
                        alert("<cf_get_lang dictionary_id='31409.Başlangıç Saati Bitiş Saatinden Büyük Olamaz'>!");
                        return false;
                    }
                    else if((start_clock == finish_clock) && (start_minute ==finish_minute))
                    {	
                        alert("<cf_get_lang dictionary_id ='31636.Başlangıç Ve  Bitiş Saati Aynı Olamaz'>!");
                        return false;
                    }
                    else if((start_clock == finish_clock) && (start_minute > finish_minute))
                    {
                        alert("<cf_get_lang dictionary_id ='31409.Başlangıç Saati Bitiş Saatinden Büyük Olamaz'>!");
                        return false;
                    }
                }
            }
            if(document.getElementById("request_date").value == ''){
                alert("<cf_get_lang dictionary_id = '58503.Lütfen Tarih Giriniz'>");
                return false;
            }
            if(document.getElementById("employee_id").value == ''){
                alert("<cf_get_lang dictionary_id = '41876.Başvuru yapan seçmelisiniz.'>");
                return false;
            }
            if(document.getElementById("branch_id").value == ''){
                alert("<cf_get_lang dictionary_id = '36397.Şube ve departman seçmelisiniz.'>");
                return false;
            }
            /*if(document.getElementById("DEPARTMENT_ID").value == ''){
                alert("<cf_get_lang dictionary_id = '36397.Şube ve departman  seçmelisiniz.'>");
                return false;
            }*/
        }
        return true;
    }
</script>