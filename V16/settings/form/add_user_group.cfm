<div class="row mainBox">
	<cfif not isdefined("attributes.newRecord")>
        <div class="col col-3 col-md-4 col-sm-12 colBox">
        <div class="row divBox">
            <div class="col col-12"> 
                <cfinclude template="../display/list_user_group.cfm"></div>
            </div>
        </div>
	</cfif>
        <div id="userGroup" <cfif not isdefined("attributes.newRecord")>class="col col-9 col-md-8 col-sm-12 text-left" style="padding:0;"<cfelse>class="col-12" style="padding-left:10px;"</cfif>>
			<div class="row divBox">
				<div class="col col-12">
                    <cfform name="add_user_group">                    
                        <div class="row form-group">
                        	<div class="col col-9">
                            	<div class="row">
                                	<div class="col col-2 text-left">
	                                    <label><cf_get_lang no='527.Yetki Grubu'> *</label>
                                    </div>
                                    <div class="col col-10 text-left form-control">
                                        <cfsavecontent variable="message"><cf_get_lang no='119.Yetki Grubu girmelisiniz'></cfsavecontent>
                                        <cfinput type="text" name="user_group_name" size="60" value="" maxlength="50" required="Yes" message="#message#">
                                    </div>
                                </div>
                            </div>
                            <div class="col col-2">
                            	<label><input type="checkbox" name="branch" value="1">Şubeye Göre Çalış</label>
                            </div>
                        </div>
                        <div class="row checkbox">
                            <label>
                              <input type="checkbox" class="allModules" value="1"><cf_get_lang_main no="2564.Ana Moduller">
                            </label>
                            <hr />
                        </div>
                        <div class="row">
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
                                                                                <input style="float:left" class="data" type="checkbox" name="level_id_#modul_no#" id="level_id_#modul_no#" value="1" <cfif modul_no eq 47>checked disabled</cfif>><!--- Genel Kullanım objects yetkisi --->#MODULE#</label>
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
                        <div class="row checkbox">
                            <label>
                                <input type="checkbox" class="extraModules" value="1"><cf_get_lang no='9.Add On' module_name='agenda'>
                            </label>
                            <hr />
                        </div>           
                        <div class="row">
                            <div class="col col-12 text-right"><cf_workcube_buttons is_upd='0' add_function="kontrol()"></div>
                        </div>
                    </cfform>
				</div>
			</div>
        </div>
    <div>	
</div>
