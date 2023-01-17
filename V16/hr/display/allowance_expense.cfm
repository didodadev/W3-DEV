<!---
    File: allowance_expense.cfm
    Controller: hrAllowenceExpenseController.cfm
    Author: Esma R. UYSAL
    Date: 07/12/2019 
    Description:
        Myhome harcama talebi listeleme sayfasıdır.
--->
<cfsetting showdebugoutput="no"> 
<cfsavecontent variable = "title">
    <cf_get_lang dictionary_id = "59777.Harcırah talepleri">
</cfsavecontent>
<cfif isdefined("attributes.STARTDATE") and len(attributes.STARTDATE)>
	<cf_date tarih="attributes.startdate">
</cfif>
<cfif isdefined("attributes.FINISHDATE") and len(attributes.FINISHDATE)>
	<cf_date tarih="attributes.finishdate">
</cfif>
<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.department_id" default="">
<cfparam name="attributes.employee_id" default="">
<cfparam name="attributes.employee_name" default="">
<cfparam name="attributes.employee" default="">
<cfparam name="attributes.process_stage" default="">
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.startdate" default="">
<cfparam name="attributes.finishdate" default="">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfset expense_component = createObject("component","V16.myhome.cfc.allowance_expense")>
<cfset fuseaction = listFirst(attributes.fuseaction,".")>
<cfset GET_EXPENSE =  expense_component.GET_EXPENSE(
                                        emp_id : attributes.employee_id,
                                        branch_id : attributes.branch_id,
                                        department_id : attributes.department_id,
                                        process_stage : attributes.process_stage,
                                        employee_name : attributes.employee_name,
                                        keyword : attributes.keyword,
                                        startdate : attributes.startdate,
                                        finishdate : attributes.finishdate,
                                        expense_type : 1
                                        )>
<cfparam name="attributes.totalrecords" default=#GET_EXPENSE.recordcount#>
<cfset cmp_branch = createObject("component","V16.hr.cfc.get_branch_comp")>
<cfset cmp_branch.dsn = dsn>
<cfset get_branches = cmp_branch.get_branch(branch_status:1)>
<cfset adres="#fuseaction#.allowance_expense" />

<cfif isDefined('attributes.branch_id') and Len(attributes.branch_id)>
	<cfset adres = '#adres#&keyword=#attributes.branch_id#' />
</cfif>
<cfif isDefined('attributes.employee_id') and Len(attributes.employee_id)>
	<cfset adres = '#adres#&employee_id=#attributes.employee_id#' />
</cfif>
<cfif isDefined('attributes.stage_id') and Len(attributes.stage_id)>
	<cfset adres = '#adres#&stage_id=#attributes.stage_id#' />
</cfif>
<cfif isDefined('attributes.department_id') and Len(attributes.department_id)>
	<cfset adres = '#adres#&department_id=#attributes.department_id#' />
</cfif>
<cf_box id="allowance_expense" closable="0" collapsable="0">
    <cf_box_search more="0">
        <cfform name="allowance_expense_form" method="post" action="">
            <input type="hidden" name="form_submitted" id="form_submitted" value="1">
            <div class="row form-inline">
                <div class="form-group" id="item-employee">
                    <cfoutput>
                        <input type="text" name="keyword" id="employee" style="width:120px;" value="#attributes.keyword#" placeholder='<cf_get_lang dictionary_id="57701.filtrre ediniz">'>
                    </cfoutput>
                </div>
                <div class="form-group" id="item-employee">
                    <div class="input-group">
                        <cfoutput>
                            <input type="hidden" name="employee_id" id="employee_id" value="<cfif len(attributes.employee)>#attributes.employee_id#</cfif>">
                            <input type="hidden" name="position_id" id="position_id" value="<cfif len(attributes.employee)>#attributes.position_id#</cfif>">
                            <input type="text" name="employee" id="employee" onFocus="AutoComplete_Create('employee','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','\'3,9\',\'0\',\'0\',\'0\',\'\',\'\',\'\',\'1\'','EMPLOYEE_ID,MEMBER_TYPE','employee_id','','3','135');" style="width:120px;" value="#get_emp_info(attributes.employee_id,0,0)#" placeholder='<cf_get_lang dictionary_id="57576.Çalışan">'>
                            <span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&is_display_self=1&is_cari_action=1&field_emp_id=allowance_expense_form.employee_id&field_name=allowance_expense_form.employee&field_type=allowance_expense_form.employee_id&field_id=position_id&select_list=1,9','list');"></span>
                        </cfoutput>
                    </div>
                </div>
                <div class="form-group" id="item-employee">
                    <!---<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57453.Şube'></label>--->
                    <select name="branch_id" id="branch_id">
                        <cfoutput query="get_branches" group="NICK_NAME">
                            <option value=""><cf_get_lang dictionary_id='57453.Şube'></option>
                            <optgroup label="#get_branches.NICK_NAME#"></optgroup>
                            <cfoutput>
                                <option value="#get_branches.BRANCH_ID#"<cfif attributes.branch_id eq get_branches.branch_id> selected</cfif>>#get_branches.BRANCH_NAME#</option>
                            </cfoutput>
                        </cfoutput>
                    </select>
                </div>
                <div class="form-group" id="form_ul_search">
                    <cf_workcube_process is_upd='0' process_cat_width='150' is_detail='0' select_value="#attributes.process_stage#">
                </div>
                <div class="form-group large" id="item-startdate">
                    <div class="input-group">
                        <cfoutput>
                            <input type="text" name="startdate" id="startdate" placeHolder="<cf_get_lang dictionary_id ='57501.Başlangıç'>" value="#dateformat(attributes.startdate,dateformat_style)#" maxlength="10" style="width:100px">
                            <span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="startdate"></span>
                        </cfoutput>
                    </div>
                </div>
                <div class="form-group large" id="item-finishdate">
                    <div class="input-group">
                        <cfoutput>
                            <input type="text" name="finishdate" id="finishdate" placeHolder="<cf_get_lang dictionary_id ='57502.bitiş'>" value="#dateformat(attributes.finishdate,dateformat_style)#" maxlength="10" style="width:100px">
                            <span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="finishdate"></span>
                        </cfoutput>
                    </div>
                </div>
                <div class="form-group small">
                    <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,999"  maxlength="3" style="width:25px;">
                </div>
                <div class="form-group" id="form_ul_search">
                    <div class="input-group">
                        <cf_wrk_search_button button_type="4">
                    </div>
                </div>
                    <div class="form-group">
                        <a class="ui-btn ui-btn-gray" href="<cfoutput>#request.self#?fuseaction=#fuseaction#.allowance_expense&event=add</cfoutput>"><i class="fa fa-plus"></i></a>
                </div>
            </div>
        </cfform>
    </cf_box_search>
</cf_box>
<cf_box id="list_worknet_list" closable="0" collapsable="1" title="#title#" add_href="#request.self#?fuseaction=#fuseaction#.allowance_expense&event=add" > 
    <cf_flat_list>
        <thead>
            <tr>
                <th><cf_get_lang dictionary_id = "57880.Belge No"></th>
                <th><cf_get_lang dictionary_id = "57742.Tarih"></th>
                <th><cf_get_lang dictionary_id = "57576.Çalışan"></th>
                <th><cf_get_lang dictionary_id = "58859.Süreç"></th>
                <th><cf_get_lang dictionary_id = "56975.KDV'li tutar"></th>
                <th></th>
            </tr>
        </thead>
        <tbody>
            <cfif isdefined("attributes.form_submitted") and len(attributes.form_submitted)>
                <cfif GET_EXPENSE.recordcount>
                    <cfoutput query = "GET_EXPENSE"  startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                        <tr>
                            <td>
                                #PAPER_NO#
                            </td>
                            <td>
                                #dateFormat(EXPENSE_DATE,dateformat_style)#
                            </td>
                            <td>
                                #get_emp_info(emp_id,0,0)#
                            </td>
                            <td>
                                #STAGE#
                            </td>
                            <td>
                                #TLFormat(OTHER_MONEY_NET_TOTAL)# #OTHER_MONEY#
                            </td>
                            <td style="text-align:center">
                                <cfsavecontent  variable="upd_title">
                                    <cf_get_lang dictionary_id = "57464.Güncelle">
                                </cfsavecontent>
                                <a href="javascript://" onclick="open_update_page('#EXPENSE_ID#')" title ="#upd_title#"><i class="fa fa-pencil"></i></a>
                            </td>
                        </tr>
                    </cfoutput>
                <cfelse>
                    <tr>
                        <td colspan="6"><cf_get_lang dictionary_id="57484.Kayıt yok">!</td>
                    </tr>
                </cfif>
            <cfelse>
                <tr>
                    <td colspan="6"><cf_get_lang dictionary_id="57701.filtre ediniz">!</td>
                </tr>
            </cfif>
        </tbody>
    </cf_flat_list>
    <cfif attributes.totalrecords gt attributes.maxrows>
        <cf_paging page="#attributes.page#"
                maxrows="#attributes.maxrows#"
                totalrecords="#attributes.totalrecords#"
                startrow="#attributes.startrow#"
                adres="#adres#&is_form_submitted=1">
    </cfif>
</cf_box>
<script>
    function open_update_page (flexible_id){
        window.open("<cfoutput>#request.self#?fuseaction=#fuseaction#.allowance_expense&event=upd&request_id=</cfoutput>"+flexible_id, '_blank');
    }
</script>