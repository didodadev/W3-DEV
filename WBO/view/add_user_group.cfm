<cfsetting showdebugoutput="no">
<cfset component = createObject("component", "WBO.model.userGroup")>
<cfset get_gdpr_sevsitive = component.GET_GDPR_AUTHORIZATION()>
	<!--- 
	<cfif not isdefined("attributes.newRecord")>
        <div class="col col-3 col-md-4 col-sm-12 colBox">
        <div class="row divBox">
            <div class="col col-12"> 
                <cfinclude template="list_user_group.cfm"></div>
            </div>
        </div>
    </cfif> --->
    <style>.pageMainLayout{
        padding : 0;
    }</style>
    <cf_box title="#getLang(dictionary_id:30350)#">       
        <cfform name="add_user_group">  
            <input type="hidden" name="ID" id="ID" value="<cfoutput>#attributes.ID#</cfoutput>" />                  
           <cf_box_elements>
            <div class="col col-8 col-md-8 col-sm-8 col-xs-8" type="column" index="1" sort="true">
                <div class="form-group">
                    <label class="col col-4"><cf_get_lang no='527.Yetki Grubu'> *</label>
                    <div class="col col-8">
                        <cfsavecontent variable="message"><cf_get_lang no='119.Yetki Grubu girmelisiniz'></cfsavecontent>
                        <cfinput type="text" name="user_group_name" value="" maxlength="50" required="Yes" message="#message#">
                    </div>
                </div>
                <div class="form-group">
                    <label class="col col-4"><cf_get_lang dictionary_id='46577.DB Erişim yetki seviyesi'></label>
                    <div class="col col-8">
                        <select name ="db_authorization">
                            <option value ="1"><cf_get_lang dictionary_id='52713.Admin'></option>
                            <option value ="2"><cf_get_lang dictionary_id='46544.Geliştirici'></option>
                            <option value ="3"><cf_get_lang dictionary_id='46527.Üst Düzey Yönetici'></option>
                            <option value ="4"><cf_get_lang dictionary_id='57930.Kullanıcı'></option>
                            <option value ="5"><cf_get_lang dictionary_id='41911.Stajyer'></option>
                        </select>
                    </div>
                </div>
                <div class="form-group">
                    <label class="col col-4"><input type="checkbox" class="allModules" value="1"><cf_get_lang dictionary_id="59869.Ana Moduller"></label>
                </div>
            </div>
            <div class="col col-4 col-md-4 col-sm-4 col-xs-4" type="column" index="2" sort="true">
                <div class="form-group">
                   <label class="col col-6"><input type="checkbox" name="branch" value="1"><cf_get_lang dictionary_id="54643.Şubeye Göre Çalış"></label>
                </div>
                <div class="form-group">
                    <label class="col col-6"><input type="checkbox" name="is_default" value="1"><cf_get_lang no='1133.Default'></label>
                </div>
            </div>
            </cf_box_elements>
            <div class="row"> <hr />
                <div class="col col-12 text-left">
                    <div class="row">	                                    
                    <cfset colitem = 1>                                  
                    <cfoutput query="get_modules" group="SOLUTION">                        	
                        <cfif colitem eq 1 ><div class="col col-6 col-md-6 col-sm-12"></cfif>  
                        <div class="col col-12 "> 
                            <div class="row">
                                <div class="col col-12 portBox">                                                    
                                    <div class="color-#Left(SOLUTION, 2)# portHead"><span>#SOLUTION# </span><i class="fa fa-angle-down pull-right"></i></div>                                         
                                    <ul class="solutionUl" >
                                        <cfoutput group="FAMILY">                                                           									
                                            <li class="solutionItem">                                                                 
                                                <span class="solutionTitle">#FAMILY# <i class="fa fa-angle-down pull-right"></i></span>
                                                <ul class="moduleUl">
                                                    <cfoutput>
                                                        <li class="moduleItem checkbox">
                                                            <div class="row">
                                                                <div class="col col-10">
                                                                    <label>
                                                                        <input style="float:left" class="data" type="checkbox" name="level_id_#modul_no#" id="level_id_#modul_no#" value="1" <cfif modul_no eq 47>checked disabled</cfif>><!--- Genel Kullanım objects yetkisi --->#MODULE#
                                                                    </label>
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
                        </div>   
                        <cfif colitem gte 6 ></div><cfset colitem = 1>  <cfelse> <cfset colitem = colitem+1> </cfif> 
                    </cfoutput>
                    <cfif colitem lte 6></div></cfif>
                </div>
            </div>
            <!--- <div class="row checkbox">
                <label>
                    <input type="checkbox" class="extraModules" value="1"><cf_get_lang no='9.Add On' module_name='agenda'>
                </label>
                <hr />
            </div>   --->  
            <div class="row">
                <div class="col col-12 text-left">
                    <div class="row">
                        <div class="col col-6 col-md-6 col-sm-12">
                            <div class="col col-12 "> 
                                <div class="row">
                                    <div class="col col-12 portBox">                                                    
                                        <div class="color-HR portHead"><span><cf_get_lang dictionary_id="46598.GDPR Yetkisi"></span><i class="fa fa-angle-down pull-right"></i></div>                                         
                                        <ul class="solutionUl">
                                            <cfoutput query="get_gdpr_sevsitive">                                     
                                                <li class="moduleItem checkbox row">       
                                                    <label>
                                                        <input style="float:left" type="checkbox" class="data" name="sensitivity_label" id="sensitivity_label" value="#SENSITIVITY_LABEL_NO#" >#SENSITIVITY_LABEL#
                                                    </label>                                                                                                         
                                                </li>
                                            </cfoutput>
                                        </ul>
                                    </div>
                                </div>
                            </div>
                        </div>    
                    </div>
                </div>
            </div>            
            <cf_box_footer>
                <div class="col col-12 text-right"><cf_workcube_buttons is_upd='0' add_function="kontrolUserGroup()"></div>
            </cf_box_footer>
        </cfform>
    </cf_box>

