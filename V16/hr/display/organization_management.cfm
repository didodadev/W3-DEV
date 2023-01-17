<!---
File: organization_management.cfm
Author: Workcube-Esma Uysal <esmauysal@workcube.com>
Controller: -
Description: Organizasyonel Planlamanın tek sayfadan yürütülmesini sağlar.
--->
<style>
    .pageMainLayout{
        padding:0!important;
    }
</style>
<script src="/JS/w3-imp-tool/bootstrap.min.js"></script>
<cfset wdo = createObject("component","V16.hr.cfc.organizationManagement")>
<cfset getHeadQuarters = WDO.getHeadQuarters()>
<cfset getObjectName = WDO.GetObjectsName(full_fuseaction : 'hr.list_headquarters')>
<cf_xml_page_edit fuseact="hr.organization_management">
<cf_catalystHeader>
<div class="imp-tool">
    <div class="page-wrapper">
        <!-- Modal -->
        <div class="modal fade" id="user_modal" tabindex="-1" role="dialog" aria-labelledby="user_modal" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered modal-lg" role="document">
                <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="user-modal-title">Üye Detayı</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body p-0">
                    <iframe src="" id="emp_modal_body"></iframe>
                </div>
                </div>
            </div>
        </div>
        <main class="page-content">
            <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                <cfsavecontent variable = "box_title">
                    <cf_get_lang dictionary_id = "58700.Organizasyon Birimleri">
                </cfsavecontent>
                <cf_box title="#box_title#" closable="0" collapsed="0">
                    <cfoutput query="getHeadQuarters">
                        <ul class="ui-list">
                            <li class="list-group-item" id="headQuerter#HEADQUARTERS_ID#">
                                <a href="javascript://">
                                    <div class="ui-list-left">
                                        <span class="ui-list-icon ctl-school" title="#getLang('main',1734,'Şirketler')#" onclick="subElements(1,#HEADQUARTERS_ID#)"></span>
                                        #NAME#
                                    </div>
                                    <div class="ui-list-right">
                                        <i class="fa fa-plus"  onclick="addWO(5,#HEADQUARTERS_ID#)" title="#getLang('contract',341,'Şirket ekle')#"></i>
                                        <i class="fa fa-pencil" onclick="updWO(5,#HEADQUARTERS_ID#)" title="#getLang('main',52,'Güncelle')#"></i>
                                    </div>
                                    
                                </a>
                                <ul id="CompanyElements#HEADQUARTERS_ID#">
                                    <li id="headQuerterAlt#HEADQUARTERS_ID#"></li> 
                                </ul>
                            </li>
                            
                        </ul>
                        <!--- <li class="list-group-item" id="headQuerter#HEADQUARTERS_ID#">
                            <div class="sltdiv">
                                <div class="sltdivL">
                                    <button type="button" class="btn btn-light btn-sm slt-btn" onclick="subElements(1,#HEADQUARTERS_ID#)"><img src="css/assets/icons/catalyst-icon-svg/ctl-school.svg" title="#getLang('main',1734,'Şirketler')#"></button>
                                    <h6><span>#NAME#</span></h6>
                                </div>
                                <div class="sltdivR">
                                    <button type="button" class="btn btn-light btn-sm slt-lft-btn" onclick="addWO(5,#HEADQUARTERS_ID#)" title="#getLang('contract',341,'Şirket ekle')#"><i class="fa fa-plus"></i></button>
                                    <button type="button" class="btn btn-light btn-sm slt-lft-btn" onclick="updWO(5,#HEADQUARTERS_ID#)" title="#getLang('main',52,'Güncelle')#"><i class="fa fa-edit"></i></button>
                                </div>
                                <div class="sltdiv" id="CompanyElements#HEADQUARTERS_ID#" style="display:none;">
                                    <div id="headQuerterAlt#HEADQUARTERS_ID#"></div> 
                                </div>
                            </div>
                        </li> --->
                    </cfoutput> 
                </cf_box>
            </div>            
            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                <div id="ajax_right">
                </div>           
            </div>
        </main>
    </div>  
</div>
<script>
function cfmodal(action, id, option){
	if( option != undefined && option.html != undefined ) $( "#"+id ).html(option.html);
	else AjaxPageLoad(action, id);
}
    function showUser(emp) { // emp -> emp id
      $('#emp_modal_body').attr('src','/index.cfm?fuseaction=objects.popup_emp_det&emp_id='+emp+'&spa=1');
      $('#user_modal').modal('show');
    } 
    function subElements(objectType,id,branch_id,department_id,position_catid,employee_id,department_name,branch_name) { // types---> 1 : Şirketler, 2 : Şube, 3 : departman, 4: Pozisyon , 5 : Çalışanlar, 6 : Çalışan Detay
        switch(objectType) {
            case 1:
                AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.organization_management&event=ajaxSub&type=' + objectType + '&head_id=' + id,'headQuerterAlt' + id);
                $('#CompanyElements' + id).toggle();
                break;
            case 2:
                AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.organization_management&event=ajaxSub&type=' + objectType + '&comp_id=' + id,'getCompanyBranches' + id);
                $('#headQuarters_Comp_Branch' + id).toggle();
                break;
            case 3:
                AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.organization_management&event=ajaxSub&type=' + objectType + '&branch_id=' + branch_id + '&branch='+ branch_name + '&comp_id=' + id,'CompanyBranchesDiv' + branch_id);
                $('#CompanyBranches' + branch_id).toggle();
                break;
            case 4:
                AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.organization_management&event=ajaxSub&type=' + objectType + '&branch_id=' + branch_id + '&branch='+ branch_name + '&comp_id=' + id + '&department_id=' + department_id + '&department=' + department_name,'BranchesDepartmentDiv' + department_id);
                $('#BranchesDepartment' + department_id).toggle();
                break;
            case 5:
                AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.organization_management&event=ajaxSub&type=' + objectType + '&branch_id=' + branch_id + '&branch='+ branch_name + '&comp_id=' + id + '&department_id=' + department_id + '&department=' + department_name + '&position_catid=' + position_catid,'DepartmentPositionsDiv' +  id + '_' + branch_id + '_' + department_id + '_' +position_catid);
                $('#DepartmentPositions' + id + '_' + branch_id + '_' + department_id + '_' + position_catid).toggle();
                break;
            case 6:
                AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.organization_management&event=ajaxSub&type=' + objectType + '&branch_id=' + branch_id + '&branch='+ branch_name + '&comp_id=' + id + '&department_id=' + department_id + '&department=' + department_name + '&position_catid=' + position_catid + '&employee_id=' + employee_id,'EmployeeDetailDiv' + employee_id);
                $('#EmployeeDetail' + employee_id).toggle();
                break;
        }
    }
    function addWO(objectType,id,branch_id,department_id,position_catid,employee_id,department_name,branch_name) { // types---> 1 :Şube, 2 : Departman, 3 : Pozisyon Tipi, 4 : Pozisyon, 5 : Şirket ,6 : Çalışan Güncelleme
        switch(objectType) {
            case 1:
                AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.list_branches&event=add&type=' + objectType + '&comp_id=' + id,'ajax_right');               
                break;
            case 2:
                AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.list_depts&event=add&type=' + objectType + '&branch_id=' + branch_id + '&branch='+ branch_name + '&comp_id=' + id,'ajax_right');            
                break;
            case 3:
                AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.list_position_cats&event=add&type=' + objectType + '&branch_id=' + branch_id + '&branch='+ branch_name + '&comp_id=' + id + '&department_id=' + department_id +'&department=' + department_name,'ajax_right');
                break;
            case 4:
                AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.list_positions&event=add&branch_id=' + branch_id + '&branch='+ branch_name + '&comp_id=' + id + '&department_id=' + department_id + '&position_catid=' + position_catid +'&department=' + department_name,'ajax_right');
                break;
            case 5:
                AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=settings.form_add_our_company&callAjax=1&head_id=' + id + '&type=' + objectType ,'ajax_right');
                break;
        }
    }    
    function updWO(objectType,id,branch_id,department_id,position_catid,employee_id,department_name,branch_name) { // types---> 1 :Şube, 2 : Departman, 3 : Pozisyon Tipi, 4 : Pozisyon,5 : Şirket ,6 : Çalışan Güncelleme
        switch(objectType) {
            case 1:
                AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=settings.form_upd_our_company&callAjax=1&ourcompany_id=' + id,'ajax_right');               
                break;
            case 2:
                AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.list_branches&event=upd&type=' + objectType + '&comp_id=' + id + '&id=' + branch_id + '&branch='+ branch_name ,'ajax_right');            
                break;
            case 3:
                AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.list_depts&event=upd&type=' + objectType + '&branch_id=' + branch_id + '&branch='+ branch_name + '&comp_id=' + id + '&id=' + department_id + '&department=' + department_name,'ajax_right');
                break;
            case 4:
                AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.list_position_cats&event=upd&position_id=' + position_catid + '&branch_id=' + branch_id + '&branch='+ branch_name + '&comp_id=' + id + '&department_id=' + department_id +'&department=' + department_name + '&position_catid=' + position_catid,'ajax_right');
                break;
            case 5:
                AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=settings.list_headquarters&event=upd&head_id=' + id + '&callAjax=1&type=' + objectType ,'ajax_right');
                break;
            case 6:
                AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.list_hr&event=upd&employee_id=' + employee_id + '&type=' + objectType ,'ajax_right');
                break;
        }
    }
    function showContract(cont_id){ // Çalışan Sözleşmesi
        AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_upd_employee_contract&cont_id=' + cont_id,'ajax_right');                       
    }    
</script>