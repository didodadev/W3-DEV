<!---
File: ajax_sub_elements.cfm
Author: Workcube-Esma Uysal <esmauysal@workcube.com>
Controller: -
Description: Organizasyonel Planlamanın ajax sayfaları bu cfm altında bulunur.
--->
<cfset wdo = createObject("component","V16.hr.cfc.organizationManagement")>
<cfswitch expression="#attributes.type#">
	<cfcase value="1"><!--- Şirketler --->
        <cfset headQuarters_alt = WDO.headQuarters_alt(head_id : attributes.head_id)><!--- Kurul --->
        <cfset getAllCompany =  WDO.getAllCompany(head_id : attributes.head_id)><!--- Gruba bağlı şirketler --->
        <cfset getObjectName = WDO.GetObjectsName(full_fuseaction : 'hr.company_info_list')><!--- Şirket WO'su --->
        
            <cfoutput query="getAllCompany">
               
                    <a href="javascript://" id="headQuarters_alt">
                        <div class="ui-list-left"  id="headQuarters_Company#COMP_ID#">
                            <span class="ui-list-icon ctl-flats" title="<cf_get_lang dictionary_id='29434.Şubeler'>"  onclick="subElements(2,#COMP_ID#)"></span>
                            #NICK_NAME#
                        </div>
                        <div class="ui-list-right">
                            <i class="fa fa-plus" onclick="addWO(1,#COMP_ID#)"	title="<cf_get_lang dictionary_id='42350.Şube Ekle'>"></i>
                            <i class="fa fa-pencil" onclick="updWO(1,#COMP_ID#)" title="<cf_get_lang dictionary_id='57464.Güncelle'>"></i>
                        </div>
                    </a>
                <ul id="headQuarters_Comp_Branch#COMP_ID#" style="display:none">            	
                    <li id = "getCompanyBranches#COMP_ID#"></li>            
                </ul>
               <!---  <li class="list-group-sub" id="headQuarters_Company#COMP_ID#">
                    <div class="sltdivL">
                        <button type="button" class="btn btn-light btn-sm slt-btn" onclick="subElements(2,#COMP_ID#)"><img src="css/assets/icons/catalyst-icon-svg/ctl-flats.svg" title="<cf_get_lang dictionary_id='29434.Şubeler'>"></button>
                        <h6>
                            <span>#NICK_NAME#</span>
                        </h6>
                    </div>
                    <div class="sltdivR">
                        <button type="button" class="btn btn-light btn-sm slt-lft-btn" onclick="updWO(1,#COMP_ID#)" title="<cf_get_lang dictionary_id='57464.Güncelle'>"><i class="fa icon-update"></i></button>
                        <button type="button" class="btn btn-light btn-sm slt-lft-btn" onclick="addWO(1,#COMP_ID#)"	title="<cf_get_lang dictionary_id='42350.Şube Ekle'>"><i class="fa fa-plus"></i></button>                        
                    </div>		
                    <div id="headQuarters_Comp_Branch#COMP_ID#" class="text-left" style="display:none;">            	
                        <div id = "getCompanyBranches#COMP_ID#"></div>            
                    </div>
                </li> --->
            </cfoutput>
    </cfcase>
    <cfcase value="2">      
        <cfset get_Branches = WDO.getCompanyBranches(comp_id : attributes.comp_id)><!--- Şube --->
        <cfset getObjectName = WDO.GetObjectsName(full_fuseaction : 'hr.list_branches')><!--- Şube WO'su --->    
        	
           
                <cfoutput query="get_Branches">
                     <a href="javascript://" id="sorterBranches">
                         <div class="ui-list-left" id="BranchesElement#BRANCH_ID#">
                             <span class="ui-list-icon ctl-shopping-store" title="#getLang('ehesap',603,'departmanlar')#"  onclick="subElements(3,#attributes.comp_id#,#BRANCH_ID#,'','','','','#BRANCH_NAME#')"></span>
                             #BRANCH_NAME#
                         </div>
                         <div class="ui-list-right">
                             <i class="fa fa-plus" onclick="addWO(2,#attributes.comp_id#,#BRANCH_ID#,'','','','','#BRANCH_NAME#')" title="<cf_get_lang dictionary_id='42332.Departman Ekle'>"></i>
                             <i class="fa fa-pencil" onclick="updWO(2,#attributes.comp_id#,#BRANCH_ID#,'','','','','#BRANCH_NAME#')" title="<cf_get_lang dictionary_id='57464.Güncelle'>"></i>
                         </div>
                     </a>
                    <ul id="CompanyBranches#BRANCH_ID#" style="display:none">            	
                        <li id = "CompanyBranchesDiv#BRANCH_ID#"></li>            
                    </ul>
                </cfoutput>
              <!---   <cfoutput query="get_Branches">
                    <li class="list-group-sub" id="BranchesElement#BRANCH_ID#">
                        <div class="sltdivL">
                            <button type="button" class="btn btn-light btn-sm slt-btn" onclick="subElements(3,#attributes.comp_id#,#BRANCH_ID#,'','','','','#BRANCH_NAME#')"><img src="css/assets/icons/catalyst-icon-svg/ctl-shopping-store.svg" title="#getLang('ehesap',603,'departmanlar')#"></button>
                            <h6>
                                <span>#BRANCH_NAME#</span>
                            </h6>
                        </div>
                        <div class="sltdivR">
                            <button type="button" class="btn btn-light btn-sm slt-lft-btn" onclick="updWO(2,#attributes.comp_id#,#BRANCH_ID#,'','','','','#BRANCH_NAME#')" title="<cf_get_lang dictionary_id='57464.Güncelle'>"><i class="fa icon-update"></i></button>                                    
                            <button type="button" class="btn btn-light btn-sm slt-lft-btn" onclick="addWO(2,#attributes.comp_id#,#BRANCH_ID#,'','','','','#BRANCH_NAME#')" title="<cf_get_lang dictionary_id='42332.Departman Ekle'>"><i class="fa fa-plus"></i></button>
                        </div>				
                        <div id="CompanyBranches#BRANCH_ID#" class="text-left" style="display:none;">            	
                            <div id = "CompanyBranchesDiv#BRANCH_ID#"></div>            
                        </div>
                    </li>
                </cfoutput> --->
    </cfcase>
    <cfcase value="3">       
        <cfset get_departments = WDO.getBranchDepartments(branch_id : attributes.branch_id)><!--- Departman --->
        <cfset getObjectName = WDO.GetObjectsName(full_fuseaction : 'hr.list_depts')><!--- Departman WO'su --->  
        <cfoutput query="get_departments">        
        <a href="javascript://" id="sorterDepartment">
            <div class="ui-list-left"  id="wrkDepartment">
                <span class="ui-list-icon ctl-online-shop-4" onclick="subElements(4,#attributes.comp_id#,#attributes.branch_id#,#DEPARTMENT_ID#,'','','#DEPARTMENT_HEAD#','#attributes.branch#')"></span>
                #DEPARTMENT_HEAD#
            </div>
            <div class="ui-list-right">
                <i class="fa fa-plus" onclick="addWO(3,#attributes.comp_id#,#attributes.branch_id#,#DEPARTMENT_ID#,'','','#DEPARTMENT_HEAD#','#attributes.branch#')" title="<cf_get_lang dictionary_id='55139.Pozisyon Tipi Ekle'>"></i>
                <i class="fa fa-pencil" onclick="updWO(3,#attributes.comp_id#,#attributes.branch_id#,#DEPARTMENT_ID#,'','','#DEPARTMENT_HEAD#','#attributes.branch#')" title="<cf_get_lang dictionary_id='57464.Güncelle'>"></i>
            </div>
            
        </a>    
        <ul id="BranchesDepartment#DEPARTMENT_ID#" style="display:none">            	
            <li id = "BranchesDepartmentDiv#DEPARTMENT_ID#"></li>            
        </ul>  
    </cfoutput>
       <!---  <div class="sltdiv">
            <ul class="list-group" id="sorterDepartment">
                <cfoutput query="get_departments">                
                    <li class="list-group-sub" id="wrkDepartment">
                        <div class="sltdivL">
                            <button type="button" class="btn btn-light btn-sm slt-btn" onclick="subElements(4,#attributes.comp_id#,#attributes.branch_id#,#DEPARTMENT_ID#,'','','#DEPARTMENT_HEAD#','#attributes.branch#')"><img src="css/assets/icons/catalyst-icon-svg/ctl-online-shop-4.svg" title="<cf_get_lang dictionary_id='47189.Roller - Pozisyonlar'>"></button>
                            <h6>
                                <span>#DEPARTMENT_HEAD#</span>
                            </h6>
                        </div>
                        <div class="sltdivR">
                            <button type="button" class="btn btn-light btn-sm slt-lft-btn" onclick="updWO(3,#attributes.comp_id#,#attributes.branch_id#,#DEPARTMENT_ID#,'','','#DEPARTMENT_HEAD#','#attributes.branch#')" title="<cf_get_lang dictionary_id='57464.Güncelle'>"><i class="fa icon-update"></i></button>           
                            <button type="button" class="btn btn-light btn-sm slt-lft-btn" onclick="addWO(3,#attributes.comp_id#,#attributes.branch_id#,#DEPARTMENT_ID#,'','','#DEPARTMENT_HEAD#','#attributes.branch#')" title="<cf_get_lang dictionary_id='55139.Pozisyon Tipi Ekle'>"><i class="fa fa-plus"></i></button> 
                        </div> 
                        <div id="BranchesDepartment#DEPARTMENT_ID#" class="text-left" style="display:none">            	
                            <div id = "BranchesDepartmentDiv#DEPARTMENT_ID#"></div>            
                        </div>               
                    </li>
                </cfoutput>
            </ul>
        </div> --->
    </cfcase>
    <cfcase value="4">             
        <!---<cfset get_positions = WDO.getDepartmentsPositions(department_id : attributes.department_id)> ---><!--- Pozisyon --->
        <cfset get_positions = WDO.getDepartmentsPositions(department_id : attributes.department_id, comp_id : attributes.comp_id, branch_id : attributes.branch_id)><!--- Pozisyon --->
        <cfset getObjectName = WDO.GetObjectsName(full_fuseaction : 'hr.list_positions')><!--- Pozisyonlar WO'su --->  
        <cfoutput query="get_positions"> 
        <a href="javascript://" >
            <div class="ui-list-left">
                <span class="ui-list-icon ctl-comfortable" onclick="subElements(5,#attributes.comp_id#,#attributes.branch_id#,#attributes.department_id#,#POSITION_CAT_ID#,'','#attributes.department#','#attributes.branch#')"></span>
                #POSITION_CAT#
            </div>
            <div class="ui-list-right">
                <i class="fa fa-plus" onclick="addWO(4,#attributes.comp_id#,#attributes.branch_id#,#attributes.department_id#,#POSITION_CAT_ID#,'','#attributes.department#','#attributes.branch#')" title="<cf_get_lang dictionary_id='42180.Pozisyon Ekle'>"></i>
                <i class="fa fa-pencil"  onclick="updWO(4,#attributes.comp_id#,#attributes.branch_id#,#attributes.department_id#,#POSITION_CAT_ID#,'','#attributes.department#','#attributes.branch#')" title="<cf_get_lang dictionary_id='57464.Güncelle'>"></i>
            </div>
        </a>
        <ul id="DepartmentPositions#attributes.comp_id#_#attributes.branch_id#_#attributes.department_id#_#POSITION_CAT_ID#" style="display:none">            	
            <li id = "DepartmentPositionsDiv#attributes.comp_id#_#attributes.branch_id#_#attributes.department_id#_#POSITION_CAT_ID#"></li>            
        </ul>    
       </cfoutput>
        <!--- <div class="sltdiv">
            <ul class="list-group" id="sorterPositions">
                <cfoutput query="get_positions">                
                    <li class="list-group-sub" id="wrkPositions">
                        <div class="sltdivL">
                            <button type="button" class="btn btn-light btn-sm slt-btn" onclick="subElements(5,#attributes.comp_id#,#attributes.branch_id#,#attributes.department_id#,#POSITION_CAT_ID#,'','#attributes.department#','#attributes.branch#')"><img src="css/assets/icons/catalyst-icon-svg/ctl-comfortable.svg"  title="<cf_get_lang dictionary_id='58875.Çalışanlar'>"></button>
                            <h6>
                                <span>#POSITION_CAT#</span>
                            </h6>
                        </div>
                        <div class="sltdivR">
                            <button type="button" class="btn btn-light btn-sm slt-lft-btn" onclick="updWO(4,#attributes.comp_id#,#attributes.branch_id#,#attributes.department_id#,#POSITION_CAT_ID#,'','#attributes.department#','#attributes.branch#')" title="<cf_get_lang dictionary_id='57464.Güncelle'>"><i class="fa icon-update"></i></button>           
                            <button type="button" class="btn btn-light btn-sm slt-lft-btn" onclick="addWO(4,#attributes.comp_id#,#attributes.branch_id#,#attributes.department_id#,#POSITION_CAT_ID#,'','#attributes.department#','#attributes.branch#')" title="<cf_get_lang dictionary_id='42180.Pozisyon Ekle'>"><i class="fa fa-plus"></i></button>
                        </div> 
                        <div id="DepartmentPositions#attributes.comp_id#_#attributes.branch_id#_#attributes.department_id#_#POSITION_CAT_ID#" class="text-left" style="display:none;">            	
                            <div id = "DepartmentPositionsDiv#attributes.comp_id#_#attributes.branch_id#_#attributes.department_id#_#POSITION_CAT_ID#"></div>            
                        </div>               
                    </li>
                </cfoutput>
            </ul>
        </div> --->
    </cfcase>
    <cfcase value="5"><!--- Pozisyona ait çalışanlar --->
        <cfset get_employee = WDO.getPositionsEmployee(department_id : attributes.department_id, comp_id : attributes.comp_id, branch_id : attributes.branch_id, position_catid : attributes.position_catid)><!--- Çalışan --->
        <cfset getObjectName = WDO.GetObjectsName(full_fuseaction : 'hr.list_hr')><!--- Çalışanlar WO'su ---> 
        <cfoutput query="get_employee">   
        <a href="javascript://"  id="sorterPositions">
            <div class="ui-list-left" id="wrkEmployee">
                <cfif len(PHOTO) and FileExists("#upload_folder#hr/#PHOTO#")>
                     <span href="javascript://" class="ui-list-icon" onclick="cfmodal('index.cfm?fuseaction=objects.popup_emp_det&emp_id=#employee_id#&spa=1','warning_modal')"></span><img class="img-circle" style="display:block;width:20px;height:20px;margin:0 5px 0 0;" src="../documents/hr/#PHOTO#" data-src=""/>
                <cfelse>
                    <span class="ui-list-icon" style="margin:2.5px 5px 2.5px 0;" onclick="cfmodal('index.cfm?fuseaction=objects.popup_emp_det&emp_id=#employee_id#&spa=1','warning_modal')">#Left(EMPLOYEE_NAME, 1)##Left(EMPLOYEE_SURNAME, 1)#</span>
                </cfif>
                #EMPLOYEE_NAME# #EMPLOYEE_SURNAME#
            </div>
            <div class="ui-list-right">
                <i class="fa fa-pencil" onclick="updWO(6,#attributes.comp_id#,#attributes.branch_id#,#attributes.department_id#,#attributes.position_catid#,#employee_id#,'#attributes.department#','#attributes.branch#')" title="<cf_get_lang dictionary_id='57464.Güncelle'>"></i>
            </div>
        </a>
        <ul id="EmployeeDetail#EMPLOYEE_ID#" style="display:none">            	
            <li id = "EmployeeDetailDiv#EMPLOYEE_ID#"></li>            
        </ul> 
    </cfoutput>
       <!---  <div class="sltdiv">
            <ul class="list-group" id="sorterPositions">
                <cfoutput query="get_employee">                
                    <li class="list-group-sub" id="wrkEmployee">    
                           <!--- ÇAlışan Detay Kartı
                            <cfif len(PHOTO) and FileExists("#upload_folder#hr/#PHOTO#")>
                                <a href="javascript://" class="photo_style" onclick="showUser(#employee_id#)"><img class="img-circle photo_img" src="../documents/hr/#PHOTO#" data-src=""/></a>
                            <cfelse>
                                <button type="button" class="btn btn-primary btn-sm slt-btn" onclick="showUser(#employee_id#)">#Left(EMPLOYEE_NAME, 1)##Left(EMPLOYEE_SURNAME, 1)#</button>
                            </cfif>
                            --->
                            <div class="stldivL">
                                <cfif len(PHOTO) and FileExists("#upload_folder#hr/#PHOTO#")>
                                    <a href="javascript://" class="photo_style" onclick="subElements(6,'','','','',#employee_id#)"><img class="img-circle photo_img" src="../documents/hr/#PHOTO#" title="<cf_get_lang dictionary_id='55816.Sözleşmeler'>"/></a>
                                <cfelse>
                                    <button type="button" class="btn btn-light btn-sm slt-btn" onclick="subElements(6,'','','','',#employee_id#)" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#">#UCase(Left(EMPLOYEE_NAME, 1))##UCase(Left(EMPLOYEE_SURNAME, 1))#</button>
                                </cfif>
                                <h6>
                                    <span>#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#
                                                  
                                    </span>
                                </h6>
                            </div>
                            <div class="stldivR">
                                <button type="button" class="btn btn-light btn-sm slt-lft-btn" onclick="updWO(6,#attributes.comp_id#,#attributes.branch_id#,#attributes.department_id#,#attributes.position_catid#,#employee_id#,'#attributes.department#','#attributes.branch#')" title="<cf_get_lang dictionary_id='57464.Güncelle'>"><i class="fa icon-update"></i></button> 
                            </div>
                        <div id="EmployeeDetail#EMPLOYEE_ID#" class="text-left" style="display:none;">            	
                            <div id = "EmployeeDetailDiv#EMPLOYEE_ID#"></div>            
                        </div>   
                    </li>
                </cfoutput>
            </ul>
        </div> --->
    </cfcase>
    <cfcase value="6"><!--- Çalışan Sözleşme --->
        <cfset GetEmployeeContract = WDO.GetEmployeeContract(employee_id : attributes.employee_id)><!--- Çalışan --->
        <cfset getObjectName = WDO.GetObjectsName(full_fuseaction : 'hr.list_hr')><!--- Çalışanlar WO'su ---> 
      <!---   <div class="sltdiv">
            <ul class="list-group" id="sorterContract">
               <cfoutput query="GetEmployeeContract">                
                    <li class="list-group-sub" id="sorterContract">
                        <div class="stldivL">
                            <button type="button" class="btn btn-light btn-sm slt-btn" ><img src="css/assets/icons/catalyst-icon-svg/ctl-check-mark.svg"></button>
                        <h6>
                            <span>#contract_head#
                                          
                            </span>
                        </h6> 
                        </div>
                        <div class="stldivR">
                            <button type="button" class="btn btn-light btn-sm slt-lft-btn" onclick="showContract('#CONTRACT_ID#')" title="<cf_get_lang dictionary_id='57464.Güncelle'>"><i class="fa icon-update"></i></button>
                        </div>   
                    </li>
                </cfoutput>
            </ul>
        </div> --->
        <cfoutput query="GetEmployeeContract">
            <a href="javascript://" id="sorterContract" >
                <div class="ui-list-left">
                    <span class="ui-list-icon ctl-check-mark"></span>
                    #contract_head#
                </div>
                <div class="ui-list-right">
                    <i class="fa fa-pencil" onclick="showContract('#CONTRACT_ID#')" title="<cf_get_lang dictionary_id='57464.Güncelle'>"></i>
                </div>
            </a>
        </cfoutput>
    </cfcase>  
    <!---<cfcase value="6"> Çalışan Detay      
        <cfset get_employee_det = WDO.getPositionsEmployee(department_id : attributes.department_id, comp_id : attributes.comp_id, branch_id : attributes.branch_id, position_catid : attributes.position_catid, employee_id : attributes.employee_id)>
        <cfset getObjectName = WDO.GetObjectsName(full_fuseaction : 'hr.list_hr')><!--- Çalışanlar WO'su --->        
        <div class="cl-12 cl-xs-12 sltdiv">
            <ul class="list-group" id="sorterPositions">
                <cfoutput query="get_employee_det">                
                    <li class="list-group-sub" id="wrkEmployeeDet">
                        <div class="cl-12 cl-xs-12">
                            <i class="fa fa-user btn btn-primary btn-sm slt-btn" ></i>                            
                            <h6 class="slt-padding"><span><cf_get_lang dictionary_id='57428.E-mail'>: #EMPLoYEE_EMAIL#</span></h6>
                            <cfif len(upper_position_code)>
                                <cfset attributes.pos_code = upper_position_code>
                                <cfinclude template="../query/get_position_info.cfm">
                            </cfif>
                            <cfif len(upper_position_code2)>
                                <cfset attributes.pos_code = upper_position_code2>
                                <cfinclude template="../query/get_position_info.cfm">
                            </cfif>
                            <h6 class="slt-padding"><span><cf_get_lang dictionary_id='56110.Birinci Amir'> : #get_position_info.position_name# - #get_position_info.employee_name# #get_position_info.employee_surname#</span></h6>
                            <h6 class="slt-padding"><span><cf_get_lang dictionary_id='56111.İkinci Amir'> : #get_position_info.position_name# - #get_position_info.employee_name# #get_position_info.employee_surname#</span></h6>
                        </div> 
                    </li>
                </cfoutput>
            </ul>
        </div>
    </cfcase>--->    
</cfswitch>
