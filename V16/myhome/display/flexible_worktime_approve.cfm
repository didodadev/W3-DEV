<!---
    File: flexible_worktime_approve.cfm
    Controller: FlexibleWorkTimeController.cfm
    Author: Esma R. UYSAL
    Date: 07/12/2019 
    Description:
        Diğer işlemler altında esnek çalışma talepleri onay sayfasıdır.
--->
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
<cfparam name="attributes.process_status" default="2">
<cfparam name="attributes.process_stage" default="">
<cfparam name="attributes.process_filter" default="">
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
    <cf_get_lang dictionary_id='31469.onay bekleyen'> <cf_get_lang dictionary_id='59820.Esnek çalışma talepleri'>
</cfsavecontent>
<cfquery name="get_upper_pos_code" datasource="#dsn#">
	SELECT 
		POSITION_CODE 
	FROM 
		EMPLOYEES E, 
		EMPLOYEE_POSITIONS EP 
	WHERE 
	E.EMPLOYEE_ID = EP.EMPLOYEE_ID 
	AND (
		UPPER_POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">
		OR UPPER_POSITION_CODE2 = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">
	)
	AND EMPLOYEE_STATUS = 1
</cfquery>

<cfset list_pos_code = 0>
<cfset list_pos_code = listappend(valuelist(get_upper_pos_code.position_code),list_pos_code)>

<cfquery name="get_upper_emps" datasource="#dsn#">
	SELECT EMPLOYEE_ID FROM EMPLOYEE_POSITIONS WHERE POSITION_CODE IN (#list_pos_code#)
</cfquery>
<cfset list_emp_ids = 0>
<cfset list_emp_ids = listappend(valuelist(get_upper_emps.employee_id),list_emp_ids)>

<cfset flex_component = createObject("component","V16.myhome.cfc.flexible_worktime")>
<cfset fuseaction = listFirst(attributes.fuseaction,".")>
<cfset get_flexible_worktime =  flex_component.GET_WORKTIME_FLEXIBLE_LIST( employee_id: list_emp_ids,process_status : attributes.process_status, stage_id : attributes.process_filter)>
<cfset cmp_branch = createObject("component","V16.hr.cfc.get_branch_comp")>
<cfset cmp_branch.dsn = dsn>
<cfset cmp_department = createObject("component","V16.hr.cfc.get_departments")>
<cfset cmp_department.dsn = dsn>
<cf_box>
    <cfform name = "search_form" method="post" action=""> 
        <div class="ui-form-list flex-list">
            <div class="form-group">
                <select name="process_status" id="process_status" onchange="show_hide_process()">
                    <option value="2" <cfif attributes.process_status eq 2>selected</cfif>>İK Sürecini Bekleyenler</option>
                    <option value="1" <cfif attributes.process_status eq 1>selected</cfif>>IK Tarafından Onaylananlar</option>
                    <option value="0" <cfif attributes.process_status eq 0>selected</cfif>>IK Tarafından Red Edilenler</option>
                    <option value="3" <cfif attributes.process_status eq 3>selected</cfif>>Benim Onayımı Bekleyenler</option>
                </select>
            </div>
            <div class="form-group" style="display:none" id="process_div">
                    <cf_workcube_process is_upd='0' select_value='#attributes.process_filter#' is_select_text='1' process_cat_width='150' is_detail='0' select_name="process_filter">
            </div>
            <div class="form-group">
                <cf_wrk_search_button button_type="4">
            </div>
        </div>
    </cfform>
</cf_box>
<cfform name = "setProcessForm" id="setProcessForm" method="post" action="#request.self#?fuseaction=myhome.emptypopup_upd_list_warning">
    <cf_box id="list_worknet_list" closable="0" collapsable="1" title="#title#"> 
        <cf_ajax_list>
            <div id="Note_list">
                <thead>
                    <tr>
                        <th><cf_get_lang dictionary_id = '57576.Çalışan'></th>
                        <th><cf_get_lang dictionary_id ='57453.Şube'></th>
                        <th><cf_get_lang dictionary_id ='57572.Departman'></th>
                        <th><cf_get_lang dictionary_id = "55285.Talep Tarihi"></th>
                        <th><cf_get_lang dictionary_id = "41129.Süreç/Aşama"></th>
                        <th><i class="fa fa-pencil"></i></th>
                        <th><input class="checkControl" type="checkbox" id="checkAll" name="checkAll" value="0"/></th>
                    </tr>
                </thead>
                <tbody>
                    <cfif get_flexible_worktime.recordcount>
                        <cfoutput query = "get_flexible_worktime">
                            <tr>
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
                                    <a href="javascript://" onclick="open_update_page('#contentEncryptingandDecodingAES(isEncode:1,content:get_flexible_worktime.worktime_flexible_id,accountKey:'wrk')#')" title ="#upd_title#"><i class="fa fa-pencil"></i></a>
                                </td>
                                <td>
                                    <cfif isdefined("w_id") and len(w_id)>
                                        <input class="checkControl" type="checkbox" name="action_list_id" id="action_list_id" value="#w_id#"/>
                                    </cfif>
                                </td>
                            </tr>
                        </cfoutput>
                    <cfelse>
                        <tr>
                            <td colspan="6"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'> !</td>
                        </tr>
                    </cfif>
                </tbody>
            </div>
        </cf_ajax_list>
        <cfif isdefined("attributes.process_filter") and len(attributes.process_filter)>
            <cf_box_footer>
                <div class="col col-12 col-xs-12 text-right">
                    <input type="hidden" name="approve_submit" id="approve_submit" value="1">
                    <input type="hidden" name="valid_ids" id="valid_ids" value="">
                    <input type="hidden" name="refusal_ids" id="refusal_ids" value="">
                    <input type="hidden" name="fuseaction_" id="fuseaction_" value="<cfoutput>#attributes.fuseaction#</cfoutput>">
                    <input type="hidden" name="fuseaction_reload" id="fuseaction_reload" value="<cfoutput>#attributes.fuseaction#</cfoutput>">
                    <input type="hidden" name="process_filter" id="process_filter" value="<cfoutput>#attributes.process_filter#</cfoutput>">
                    <input type="hidden" name="process_status" id="process_status" value="<cfoutput>#attributes.process_status#</cfoutput>">
                    <cfsavecontent variable="onayla"><cf_get_lang dictionary_id="58475.Onayla"></cfsavecontent>
                    <cfsavecontent variable="reddet"><cf_get_lang dictionary_id="58461.reddet"></cfsavecontent>
                    <cf_workcube_buttons extraButton="1" extraButtonText="#reddet#" extraFunction="setFlexibleWorktimeProcess_(2)" update_status="0">
                    <cf_workcube_buttons extraButton="1" extraButtonText="#onayla#" extraFunction="setFlexibleWorktimeProcess_(1)" update_status="0">
                </div>
            </cf_box_footer>
        </cfif>
    </cf_box>
</cfform>
<script type="text/javascript">
    show_hide_process();
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
    function setFlexibleWorktimeProcess_(type){
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
       
        if(type == 2){
			$("#action_list_id:checked").each(function () {
				$(this).attr('name', 'refusal_ids');
			});
		}else{
			$("#action_list_id:checked").each(function () {
				$(this).attr('name', 'valid_ids');

			});
		}
        $('#setProcessForm').submit();
        
    }
    function open_update_page (flexible_id){
        window.open("<cfoutput>#request.self#?fuseaction=#fuseaction#.flexible_worktime_approve&event=upd&flexible_id=</cfoutput>"+flexible_id, '_blank');
    }
    function show_hide_process(){
		process_status = $('#process_status').val();
		if (process_status != 3){
			document.getElementById('process_div').style.display = 'none';
            document.getElementById('process_stage').value = ''; 
            document.getElementById('process_filter').value = '';
		}else{
			document.getElementById('process_div').style.display = '';            
		}
	}
</script>
