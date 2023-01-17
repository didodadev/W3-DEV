<!---
    File: V16\hr\display\project_allowance.cfm
    Author: Esma R. Uysal <esmauysal@workcube.com>
    Date: 28.06.2021
    Description: Proje Bazlı Ödenek ve Bordro     
--->

<cfset branch_ = createObject("component","V16.hr.cfc.get_branches")>
<cfset branch_.dsn = dsn>
<cfset get_branch = branch_.get_branch()>

<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.expense_center" default="">
<cfparam name="attributes.general_budget_id" default="">
<cfparam name="attributes.is_form_submit" default="0">

<cfif attributes.is_form_submit eq 1>
    <cfset get_component = createObject("component","V16.hr.cfc.project_allowance") />
    <cfset get_project = get_component.get_project(
        branch_id : attributes.branch_id,
        general_budget_id : attributes.general_budget_id,
        expense_center : attributes.expense_center
    )>
</cfif>

<div id="project_list">
    <div class="col col-3 col-md-3 col-sm-3 col-xs-12"<!---  style="position: sticky; top: 50px;" --->>
        <cfsavecontent variable = "box_title">
            <cf_get_lang dictionary_id='58015.Projeler'>
        </cfsavecontent>
        <cf_box title="#box_title#" closable="0" collapsed="0" >
            <cfform name="project_allowance">
                <cf_box_elements verticable="1">
                    <cfoutput>
                        <div class="col col-12 col-md-12 col-sm-12 col-xs-12 column" id="column-1">
                            <div class="form-group">
                                <div class="col col-10 col-xs-12">
                                    <select name="branch_id" id="branch_id">
                                        <option value=""><cf_get_lang dictionary_id='29434.Şubeler'></option>
                                        <cfloop query="get_branch">
                                            <option value="#get_branch.branch_id#"<cfif attributes.branch_id eq get_branch.branch_id>selected</cfif>>#get_branch.branch_name#</option>
                                        </cfloop>
                                    </select>
                                </div>
                            </div>
                            <div class="form-group">
                                <div class="col col-10 col-xs-12">
                                    <cfsavecontent variable="budget_title"><cf_get_lang dictionary_id='59936.Bütçe Merkezi'></cfsavecontent>
                                    <cfquery name="GET_BUDGET" datasource="#dsn#">
                                        SELECT BUDGET_ID,BUDGET_NAME FROM BUDGET WHERE BUDGET_ID IS NOT NULL AND OUR_COMPANY_ID = #session.ep.company_id# AND BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#) ORDER BY BUDGET_NAME
                                    </cfquery>
                                    <select name="general_budget_id" id="general_budget_id">
                                        <option value=""><cf_get_lang dictionary_id='59936.Bütçe Merkezi'></option>
                                        <cfloop query="GET_BUDGET">
                                            <option value="#GET_BUDGET.budget_id#" <cfif attributes.general_budget_id eq GET_BUDGET.budget_id>selected</cfif>>#GET_BUDGET.budget_name#</option>
                                        </cfloop>
                                    </select>
                                </div>
                                <div class="col col-2 col-xs-12">
                                    <cf_wrk_search_button button_type="4" search_function="list_project()">
                                </div>
                            </div>
                        </div>
                    </cfoutput>
                    <div class="col col-12 col-md-12 col-sm-12 col-xs-12 column" id="column-2">
                        <cf_ajax_list>
                            <thead>
                                <tr>
                                    <th colspan="2"><cf_get_lang dictionary_id='57416.Proje'></th>
                                </tr>
                            </thead>
                            <tbody>
                                <cfif attributes.is_form_submit eq 1>
                                    <cfif get_project.recordcount gt 0>
                                        <cfoutput query = "get_project">
                                            <tr>
                                                <td>
                                                    <a href="javascript://" onclick="open_project(#PROJECT_ID#)">#PROJECT_NUMBER#</a></td>
                                                </td>
                                                <td><a href="javascript://" onclick="open_project(#PROJECT_ID#)">#PROJECT_HEAD#</a></td>
                                            </tr>
                                        </cfoutput>
                                    <cfelse>
                                        <tr>
                                            <td colspan="2"><cf_get_lang dictionary_id='57484.Kayıt Yok'></td>
                                        </tr>
                                    </cfif>
                                <cfelse>
                                    <tr>
                                        <td colspan="2"><cf_get_lang dictionary_id='57701.Filtre Ediniz'></td>
                                    </tr>
                                </cfif>
                            </tbody>
                        </cf_ajax_list>
                    </div>
                </cf_box_elements>
            </cfform>
        </cf_box>
    </div>
    <div class="col col-9 col-md-9 col-sm-9 col-xs-12" id="ajax_right">
    </div>
</div>
<script type = "text/javascript">

    function list_project()
    {

        if($("#branch_id").val() == '')
        {
            alert("<cf_get_lang dictionary_id='58579.Lütfen Şube Seçiniz'>");
            return false;
        }
        if($("#general_budget_id").val() == '')
        {
            alert("<cf_get_lang dictionary_id='59936.Bütçe Merkezi'>!");
            return false;
        }
        var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=hr.project_allowance&is_form_submit=1&branch_id=" + $("#branch_id").val() + "&general_budget_id=" +  $("#general_budget_id").val() ;
		AjaxPageLoad(send_address,'project_list',1,'Projeler');
    }

    function open_project(project_id)
    {
        general_budget_id = $("#general_budget_id").val();
        ssk_statue = $("#ssk_statue").val();
        statue_type = $("#statue_type").val();

        var send_address_ = "<cfoutput>#request.self#</cfoutput>?fuseaction=objects.widget_loader&widget_load=ProjectDetailInfo&ajax=1&ajax_box_page=1&isAjax=1&project_id="+project_id+"&general_budget_id="+general_budget_id+"&statue_type="+statue_type+"&ssk_statue="+ssk_statue+"&branch_id=" + $("#branch_id").val();
        AjaxPageLoad(send_address_,'ajax_right',1,'Projeler');
    }
    
</script>