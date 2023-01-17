
<cfset component = createObject("component", "WBO.model.userGroup")>
<cfset get_menus = component.get_menus()>
<cfset get_gdpr_sevsitive = component.GET_GDPR_AUTHORIZATION()>
<style>.pageMainLayout{
    padding : 0;
}</style>       
    <cf_box id="user_group_tab" title="#get_user_group.user_group_name#">   
        <cf_tab divId="sayfa_1,sayfa_2" defaultOpen="sayfa_1" divLang="#getLang(dictionary_id:30350)#;#getLang(dictionary_id:58992)#" tabcolor="fff">
            <div id="unique_sayfa_2" class="uniqueBox">
                <cfset attributes.user_group_id = '#get_user_group.user_group_id#'>
                <cfinclude  template="members.cfm"> 
			</div>
			<div id="unique_sayfa_1" class="uniqueBox">    
                <cfform name="add_user_group" method="post" action="#request.self#?fuseaction=settings.emptypopup_user_group_upd"> 
                    <cfoutput>
                        <input type="hidden" name="ID" id="ID" value="#attributes.ID#" />     
                        <input type="hidden" name="user_group_id" id="user_group_id" value="#get_user_group.user_group_id#">
                        <input type="hidden" id="nListObject" name="nListObject" value="#attributes.nListObject#">
                        <input type="hidden" id="nAddObject" name="nAddObject" value="#attributes.nAddObject#">
                        <input type="hidden" id="nUpdObject" name="nUpdObject" value="#attributes.nUpdObject#">
                        <input type="hidden" id="nDelObject" name="nDelObject" value="#attributes.nDelObject#">
                    </cfoutput>
                        <cf_box_elements>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-8" type="column" index="1" sort="true">
                                <div class="form-group">
                                    <label class="col col-4"><cf_get_lang no='527.Yetki Grubu'> *</label>
                                    <div class="col col-8">
                                        <input type="text" name="user_group_name" id="user_group_name" size="60" value="<cfoutput>#get_user_group.user_group_name#</cfoutput>">
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="col col-4"><cf_get_lang dictionary_id='46577.DB Erişim yetki seviyesi'></label>
                                    <div class="col col-8">
                                        <select name ="db_authorization">
                                            <option value ="1" <cfif get_user_group.data_level eq 1>selected</cfif>><cf_get_lang dictionary_id='52713.Admin'></option>
                                            <option value ="2" <cfif get_user_group.data_level eq 2>selected</cfif>><cf_get_lang dictionary_id='46544.Geliştirici'></option>
                                            <option value ="3" <cfif get_user_group.data_level eq 3>selected</cfif>><cf_get_lang dictionary_id='46527.Üst Düzey Yönetici'></option>
                                            <option value ="4" <cfif get_user_group.data_level eq 4>selected</cfif>><cf_get_lang dictionary_id='57930.Kullanıcı'></option>
                                            <option value ="5" <cfif get_user_group.data_level eq 5>selected</cfif>><cf_get_lang dictionary_id='41911.Stajyer'></option>
                                        </select>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="col col-4"> <input type="checkbox" class="allModules" value="1"><cf_get_lang dictionary_id="59869.Ana Moduller"></label>
                                </div>
                            </div>
                            <div class="col col-4 col-md-4 col-sm-4 col-xs-4" type="column" index="2" sort="true">
                                <div class="form-group">
                                    <label class="col col-6"><input type="checkbox" name="branch" value="1" <cfif get_user_group.IS_BRANCH_AUTHORIZATION eq 1>checked</cfif>><cf_get_lang dictionary_id="54643.Şubeye Göre Çalış"></label>
                                </div>
                                <div class="form-group">
                                    <label class="col col-6"><input type="checkbox" name="is_default" value="1"<cfif get_user_group.IS_DEFAULT eq 1>checked</cfif>><cf_get_lang no='1133.Default'></label>
                                </div>
                            </div>
                        </cf_box_elements>
                        <div class="row">
                            <hr /><div class="col col-12 text-left">
                                <div class="row">	
                                    <cfset colitem = 1>                                  
                                    <cfoutput query="get_modules" group="SOLUTION">                        	
                                    <cfif colitem eq 1 ><div class="col col-6 col-md-6 col-sm-12 "></cfif>   
                                        <div class="row">
                                            <div class="col col-12 portBox">                                                    
                                                <div class="color-#Left(SOLUTION, 2)# portHead"><span>#SOLUTION#</span><i class="fa fa-angle-down pull-right"></i></div>                                         
                                                <ul class="solutionUl" >
                                                    <cfoutput group="FAMILY">                                                           									
                                                        <li class="solutionItem">                                                                 
                                                        <span class="solutionTitle">#FAMILY# <i class="fa fa-angle-down pull-right"></i></span>                                                                                                      
                                                            <ul class="moduleUl">
                                                                <cfoutput>
                                                                <li class="moduleItem checkbox">
                                                                    <div class="row">
                                                                        <div class="col col-5">
                                                                            <label>
                                                                                <input style="float:left" type="checkbox" class="data" name="level_id_#modul_no#" id="level_id_#modul_no#" value="1" <cfif modul_no eq 47>checked disabled</cfif><cfif listFindNoCase(get_user_group.user_group_permissions,modul_no,',')> checked</cfif> onclick="checkAreas('#modul_no#',1)"><!--- Genel Kullanım objects yetkisi --->#MODULE#
                                                                            </label>
                                                                        </div>
                                                                        <div class="col col-3">
                                                                            <label><input type="checkbox" name="powerUser_#modul_no#" id="powerUser_#modul_no#" value="1" <cfif modul_no eq 47>checked disabled</cfif><cfif listFindNoCase(get_user_group.powerUser,modul_no,',')> checked</cfif>>Power User</label>
                                                                        </div>
                                                                        <div class="col col-3">
                                                                            <label><input type="checkbox" name="report_user_level#modul_no#" id="report_user_level#modul_no#" value="1" <cfif modul_no eq 47>checked disabled</cfif><cfif listFindNoCase(get_user_group.report_user_level,modul_no,',')> checked</cfif>>Report User</label>
                                                                        </div>
                                                                        <!--- <cfif listFindNoCase(get_user_group.user_group_permissions,modul_no,',')> --->
                                                                            <div class="col col-1">
                                                                                <a href="javascript://" class="btnUserGroup" onclick="openPopup('#modul_no#','#MODULE#')">
                                                                                <i class="fa fa-wrench fa-lg "></i>
                                                                                </a>
                                                                            </div>
                                                                        <!--- </cfif> --->
                                                                    </div> 
                                                                    <div class="row" id="modul#modul_no#" style="display:none;">
                                                                        <div class="col col-12">
                                                                        
                                                                        </div>
                                                                    </div>                                                                                                               
                                                                </li>
                                                                </cfoutput>
                                                            </ul>
                                                        </li>                                    
                                                    </cfoutput>

                                                </ul>
                                            </div>
                                        </div>    
                                    <cfif colitem gte 6></div><cfset colitem = 1>  <cfelse> <cfset colitem = colitem+1> </cfif> 
                                    </cfoutput>
                                    <cfif colitem lte 6></div></cfif>
                                </div>
                                <cf_get_lang_set module_name="agenda">
                            <!---                    <div class="row checkbox">
                                    <label>
                                        <input type="checkbox" class="extraModules" value="1"><cf_get_lang no='9.Add On' module_name='agenda'>
                                    </label>
                                    <hr />
                                </div>      --->                     
                        </div>  
                        <div class="row">
                            <div class="col col-6">
                                <div class="row">
                                    <div class="col col-12 portBox">                                                    
                                        <div class="color-M portHead"><span>Menus</span><i class="fa fa-angle-down pull-right"></i></div>                                         
                                        <ul class="moduleUl">
                                            <cfoutput query="get_menus">                                     
                                                <li class="moduleItem checkbox row">       
                                                    <label>
                                                        <input style="float:left" type="checkbox" class="data" name="wrk_menu" id="wrk_menu" value="#WRK_MENU_ID#" <cfif listFindNoCase(get_user_group.WRK_MENU,WRK_MENU_ID,',')> checked</cfif>>#WRK_MENU_NAME#
                                                    </label>                                                                                                         
                                                </li>
                                            </cfoutput>
                                        </ul>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col col-6">
                                <div class="row">
                                    <div class="col col-12 portBox">                                                    
                                        <div class="color-HR portHead"><span><cf_get_lang dictionary_id="46598.GDPR Yetkisi"></span><i class="fa fa-angle-down pull-right"></i></div>                                         
                                        <ul class="moduleUl">
                                            <cfoutput query="get_gdpr_sevsitive">                                     
                                                <li class="moduleItem checkbox row">       
                                                    <label>
                                                        <input style="float:left" type="checkbox" class="data" name="sensitivity_label" id="sensitivity_label" value="#SENSITIVITY_LABEL_NO#" <cfif listFindNoCase(get_user_group.SENSITIVE_USER_LEVEL,SENSITIVITY_LABEL_NO,',')> checked</cfif>>#SENSITIVITY_LABEL#
                                                    </label>                                                                                                         
                                                </li>
                                            </cfoutput>
                                        </ul>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <cf_box_footer>
                            <div class="col col-6 col-xs-12">
                            <cf_record_info 
                                query_name="GET_USER_GROUP"
                                record_emp="RECORD_EMP" 
                                record_date="record_date"
                                is_partner='1'
                                update_emp="UPDATE_EMP"
                                update_date="update_date">
                            </div>
                            <div class="col col-6 text-right">
                                <cfif get_group_emp_count.total eq 0>
                                    <cf_workcube_buttons is_upd='1' add_function="kontrolUserGroup()">
                                <cfelse>
                                    <cf_workcube_buttons is_upd='1' add_function="kontrolUserGroup()" is_delete='0'>
                                </cfif>
                            </div>
                        </cf_box_footer>
                </cfform>
            </div>
		</cf_tab>
	</cf_box>
<!--- Modal ---->

<div class="modal modal-xl" id="uGroupModal" role="dialog" style="display: none;">
    <div class="modal-dialog">
      <!-- Modal content-->
      <div class="modal-content">
        <div class="modal-header">
          <button type="button" class="close" onclick="closeModal('uGroupModal')" data-dismiss="modal">×</button>
          <h4 class="modal-title"></h4>
        </div>
        <div id="userGroupModal" class="modal-body">
         </div>
        <div class="modal-footer">
            <div class="form-group text-right"> 
                <button type="submit" class="btn btn-primary">Kaydet</button> 
            </div>
        </div>
      </div>      
    </div>
    <div class="modal-backdrop" onclick="closeModal('uGroupModal')" style="display:none;"></div>
</div>