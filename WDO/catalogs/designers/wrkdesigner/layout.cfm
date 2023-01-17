<!---
    File: layout.cfm
    Author: Botan KAYĞAN <botankaygan@workcube.com>
    Date: 27.08.2019
    Controller: -
    Description: WO ekleme ve detay sayfasıdır.
--->
<style>
    .wo-row{
        display:flex;
        flex-direction:row;
        justify-content:space-around;
    }
    .wo-menu{
        order:1;
        flex-grow:1;
        margin-right:5px;
    }
    .wo-main{
        order: 2;
        flex-grow:10;
    }
</style>
<script src="/JS/assets/plugins/menuDesigner/vue.js"></script>
<script src="/JS/assets/plugins/menuDesigner/axios.min.js"></script>
<script src="/JS/assets/plugins/menuDesigner/jquery.nestable.min.js"></script>
<script src="/JS/assets/custom/script.js" type="text/javascript"></script>
<script src="/JS/assets/plugins/menuDesigner/bootstrap-select.min.js"></script>
<script src="/JS/assets/plugins/menuDesigner/popper.min.js" crossorigin="anonymous"></script>
<script src="/JS/assets/plugins/menuDesigner/bootstrap.min.js" crossorigin="anonymous"></script>
<link rel="stylesheet" href="/css/assets/template/workdev/animate.css">
<link rel="stylesheet" href="/css/assets/template/workdev/workdev.min.css">
<cfparam name="attributes.fuseaction_control" default="">
<cfsavecontent  variable="head">Workdev <cfif len(get_wrk_fuseactions.head)> : <cfoutput>#get_wrk_fuseactions.head#</cfoutput></cfif>
</cfsavecontent>
<div class="wo-row">
<cfif isdefined("attributes.fuseact") and len(attributes.fuseact) and attributes.fuseaction neq 'objects.emptypopup_system'>
    <cfquery name="qUserFriendly" datasource="#dsn#">
        SELECT WRK_OBJECTS_ID, FRIENDLY_URL, HEAD FROM WRK_OBJECTS WHERE FULL_FUSEACTION = <cfqueryparam value="#attributes.fuseact#" cfsqltype="cf_sql_nvarchar">
    </cfquery>
    <div class="wo-menu">
        <cf_box>
            <ul class="ui-list" id="workdevmenu">
                <li class="list-group-item" title="Workcube Object">
                    <a href="<cfoutput>#request.self#?fuseaction=dev.wo&event=upd&fuseact=#attributes.fuseact#&woid=#qUserFriendly.WRK_OBJECTS_ID#</cfoutput>">
                        <div class="ui-list-left">
                            <i class="catalyst-info"></i>
                            Info
                        </div>
                    </a>
                </li>
                <li class="list-group-item" title="Model">
                    <a href="javascript://" onclick="open_objects('<cfoutput>#request.self#?fuseaction=dev.model&fuseact=#attributes.fuseact#</cfoutput>')">
                        <div class="ui-list-left">
                            <i class="catalyst-calculator" title="Model"></i>
                            Model
                        </div>
                    </a>
                </li>
                <li class="list-group-item" title="Widgets">
                    <a href="javascript://" onclick="open_objects('<cfoutput>#request.self#?fuseaction=dev.widget&fuseact=#attributes.fuseact#&woid=#qUserFriendly.WRK_OBJECTS_ID#&selfwo=1&woid=#attributes.woid#</cfoutput>')">
                        <div class="ui-list-left">
                            <i class="fa fa-stack-overflow" ></i>
                            Widgets
                        </div>
                    </a>
                </li>
                <li class="list-group-item" title="Events">
                    <a href="javascript://" onclick="open_objects('<cfoutput>#request.self#?fuseaction=dev.events&mode=list&fuseact=#attributes.fuseact#&selfwo=1&woid=#attributes.woid#</cfoutput>')">
                        <div class="ui-list-left">
                            <i class="catalyst-layers"></i>
                            <cf_get_lang dictionary_id="64539.Rest API">
                        </div>
                    </a>
                </li>
                <cfif len(get_wrk_fuseactions.DATA_CFC)>
                    <li class="list-group-item" title="<cf_get_lang dictionary_id="64539.Rest API">">
                        <a href="javascript://" onclick="open_objects('<cfoutput>#request.self#?fuseaction=dev.restapi&fuseact=#attributes.fuseact#&userfriendly=#qUserFriendly.FRIENDLY_URL#</cfoutput>')">
                            <div class="ui-list-left">
                                <i class="fa fa-gitlab"></i>
                                <cf_get_lang dictionary_id="64538.Wex API"> 
                            </div>
                        </a>
                    </li>
                </cfif>
                <li class="list-group-item" title="<cf_get_lang dictionary_id="61246.Controller">">
                    <a href="javascript://" onclick="open_objects('<cfoutput>#request.self#?fuseaction=dev.controller&fuseact=#attributes.fuseact#&userfriendly=#qUserFriendly.FRIENDLY_URL#</cfoutput>')">
                        <div class="ui-list-left">
                            <i class="catalyst-directions"></i>
                            <cf_get_lang dictionary_id="61246.Controller">  
                        </div>
                    </a>
                </li>
                <!--- <li onclick="Router.navigate('trigger')" title="Trigger"> <!--- Sayfa tamamlanmamış bu sebeble yoruma alındı --->
                    <i class="catalyst-link" ></i>
                    <span class="title">Trigger</span>
                </li> --->
                <li class="list-group-item" title="<cf_get_lang dictionary_id="37100.Output">"><!---callPage('output');--->
                    <a href="javascript://" onclick="window.open('<cfoutput>#request.self#?fuseaction=dev.output_templates&related_wo=#attributes.fuseact#&is_submitted=1</cfoutput>')">
                        <div class="ui-list-left">
                            <i class="catalyst-printer" ></i>
                            <cf_get_lang dictionary_id="37100.Output">  
                        </div>
                    </a>
                </li>                
                <li class="list-group-item"  title="<cf_get_lang dictionary_id="46021.Test Sonuçları">">
                    <a href="javascript://" onclick="open_objects('<cfoutput>#request.self#?fuseaction=dev.testkits&fuse=#attributes.fuseact#</cfoutput>&is_submited=1')" >
                        <div class="ui-list-left">
                            <i class="catalyst-eyeglasses"></i>
                            <cf_get_lang dictionary_id="58826.Test">
                        </div>
                    </a>
                </li>
                <li class="list-group-item"  title="<cf_get_lang dictionary_id="47612.Çağrılar">">
                    <a href="javascript://" onclick="open_objects('<cfoutput>#request.self#?fuseaction=objects.call_center&Workfuse=#attributes.fuseact#</cfoutput>')" >
                        <div class="ui-list-left">
                            <i class="catalyst-support"></i>
                          <cf_get_lang dictionary_id="47612.Çağrılar"> 
                        </div>
                    </a>
                </li>
                <li class="list-group-item"  title="<cf_get_lang dictionary_id="58020.İşler">">
                    <a href="javascript://" onclick="open_objects('<cfoutput>#request.self#?fuseaction=project.emptypopup_ajax_project_works&project_detail_id=2&WorkdevList=1&Workfuse=#attributes.fuseact#</cfoutput>&is_submited=1')" >
                        <div class="ui-list-left">
                            <i class="catalyst-wrench"></i>
                            <cf_get_lang dictionary_id="58020.İşler"> 
                        </div>
                    </a>
                </li>
                <li class="list-group-item"  title="<cf_get_lang dictionary_id="64537.Tips">">
                    <a href="<cfoutput>#request.self#?fuseaction=help.worktips&help_fuseaction=#attributes.fuseact#</cfoutput>&is_submited=1')" target="_blank">
                        <div class="ui-list-left">
                            <i class="catalyst-bulb"></i>
                            <cf_get_lang dictionary_id="64537.Tips">    
                        </div>
                    </a>
                </li>
                <li class="list-group-item"  title="<cf_get_lang dictionary_id="60721.Wiki">">
                    <a href="<cfoutput>https://networg.workcube.com/index.cfm?fuseaction=content.list_content&meta_head=#attributes.fuseact#</cfoutput>&form_submitted=1" target="_blank">
                        <div class="ui-list-left">
                            <i style="color:#9c9e9c;font-style:normal">W</i>
                        <cf_get_lang dictionary_id="60721.Wiki">
                        </div>
                    </a>
                </li>
            <!---  <li onclick="Router.navigate('support')" title="Helps"> <!--- Sayfa tamamlanmamış bu sebeble yoruma alındı --->
                    <i class="catalyst-support"></i>
                    <span class="title">Helps</span>
                </li>  --->    
            </ul>
        </cf_box>
    </div>
</cfif>
<div class="<cfif isdefined("attributes.fuseact") and len(attributes.fuseact) and attributes.fuseaction neq 'objects.emptypopup_system'>wo-main<cfelse>col col-12</cfif>">
    <div id="objects">
        <cf_box id="wo" title="#head#">
            <cfform name="updFuseactionForm" id="updFuseactionForm" method="post" action="#request.self#?fuseaction=#postaction#">
                <cfset attributes.headx="aaa">
                <input type="hidden" name="fuseaction_control" value="<cfoutput>#url.fuseaction#</cfoutput>">
                <cfif isDefined("attributes.fuseact")>
                    <input type="hidden" name="fuseact" value="<cfoutput>#attributes.fuseact#</cfoutput>">
                </cfif>
                <cf_box_elements>
                    <div class="col col-4 col-md-4 col-sm-4 col-xs-12" index="1" type="column" sort="true">
                        <div class="form-group" id="item-head">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12">Head*</label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <div class="input-group">
                                    <cfoutput>
                                        <input type="text" name="head" id="head" value="#get_wrk_fuseactions.head#" required>
                                        <input type="hidden" name="dictionary_id"  id="dictionary_id" value="#get_wrk_fuseactions.dictionary_id#">
                                        <input type="hidden" name="woid"  id="woid" value="#attributes.woid#">
                                        <span class="input-group-addon icon-ellipsis btnPointer" href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=settings.popup_list_lang_settings&is_use_send&lang_dictionary_id=updFuseactionForm.dictionary_id&lang_item_name=updFuseactionForm.head');return false"></span>
                                    </cfoutput>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-friendly-url">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12">User Friendly URL</label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <cfoutput>
                                    <input type="text" name="friendly_url" id="friendly_url" value="#get_wrk_fuseactions.friendly_url#" />
                                </cfoutput>
                            </div>
                        </div>
                        <div class="form-group" id="item-full-fus">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12">Full Fuseaction*</label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <cfoutput>
                                    <input type="text" name="fuseaction_name" id="fuseaction_name" value="#get_wrk_fuseactions.full_fuseaction#" maxlength="100" onclick="event.ctrlKey && window.open('/index.cfm?fuseaction='+this.value)" title="Ctrl+Click open link in a new window..." onmousemove="if (event.ctrlKey) { this.style.textDecoration='underline';this.style.color='blue'; } else { this.style.textDecoration='none';this.style.color='##555' }" onmouseout="this.style.textDecoration='none';this.style.color='##555'">
                                    <input type="hidden" name="old_fuseaction" id="old_fuseaction" value="#get_wrk_fuseactions.full_fuseaction#">
                                </cfoutput>
                            </div>
                        </div>
                        <div class="form-group" id="item-ext-fus">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12">External Fuseaction</label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <cfoutput>
                                    <input type="text" name="external_fuseaction" id="external_fuseaction" value="#get_wrk_fuseactions.external_fuseaction#" maxlength="100">
                                </cfoutput>
                            </div>
                        </div>
                        <div class="form-group" id="item-security">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12">Security*</label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <select name="security" id="security">
                                    <option value="Standart"<cfif get_wrk_fuseactions.security eq 'Standart'>selected</cfif>>Standard</option>
                                    <option value="Light"<cfif get_wrk_fuseactions.security eq 'Standart'>selected</cfif>>Light</option>
                                    <option value="Dark"<cfif get_wrk_fuseactions.security eq 'Standart'>selected</cfif>>Dark</option>
                                </select>
                            </div>
                        </div>
                        <div class="form-group" id="item-mode">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12">Mode *</label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <cfoutput>
                                    <select name="is_legacy" id="is_legacy" required>
                                        <option value=""><cf_get_lang dictionary_id='57734.Please Select'></option>
                                        <option value="0" #iif( get_wrk_fuseactions.is_legacy eq 0, de(' selected="selected"'), de("") )#><cf_get_lang dictionary_id='61133.Catalyst'></option>
                                        <option value="2" #iif( get_wrk_fuseactions.is_legacy eq 2, de(' selected="selected"'), de("") )#><cf_get_lang dictionary_id='49029.Holistic'></option>
                                        <option value="1" #iif( get_wrk_fuseactions.is_legacy eq 1, de(' selected="selected"'), de("") )#><cf_get_lang dictionary_id='61134.Legacy'></option>
                                    </select>
                                </cfoutput>
                            </div>
                        </div>
                        <div class="form-group" id="item-icon">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12">Icon</label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <div class="input-group">
                                    <cfinput type="text" name="icon" id="icon" value="#get_wrk_fuseactions.icon#">
                                    <span class="input-group-addon icon-ellipsis" onclick="windowopen('index.cfm?fuseaction=objects.popup_list_icons&is_popup=1&field_name=icon','medium');"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-mode">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12">Window Type *</label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <cfoutput>
                                    <select name="window_type" id="window_type" required>
                                        <option value=""><cf_get_lang dictionary_id='57734.Please Select'></option>
                                        <option value="normal" #iif( get_wrk_fuseactions.WINDOW eq 'normal', de(' selected="selected"'), de("") )#>normal</option>
                                        <option value="popup" #iif( get_wrk_fuseactions.WINDOW eq 'popup', de(' selected="selected"'), de("") )#>popup</option>
                                        <option value="draggable" #iif( get_wrk_fuseactions.WINDOW eq 'draggable', de(' selected="selected"'), de("") )#>draggable</option>
                                    </select>
                                </cfoutput>
                            </div>
                        </div>
                        <div class="form-group" id="item-settings">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12">Settings</label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                                    <label>
                                        <input type="checkbox" name="is_active" id="is_active" value="1" <cfif get_wrk_fuseactions.is_active eq 1>checked="checked"</cfif>>
                                        Active
                                    </label>
                                </div>
                                <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                    <label>
                                        <input type="checkbox" name="is_menu" id="is_menu" value="1" <cfif get_wrk_fuseactions.is_menu eq 1>checked="checked"</cfif>>
                                        Show Menu
                                    </label>
                                </div>                                
                            </div>
                        </div>
                        <div class="form-group" id="item-public">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id="46090.Yayın Alanı"> *</label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <cfoutput>
                                    <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                                        <label><input type="checkbox" id="is_public" name="is_public" <cfif isdefined('get_wrk_fuseactions.is_public') and get_wrk_fuseactions.is_public eq 1>checked</cfif>>Public</label>
                                        <label><input type="checkbox" id="is_employee" name="is_employee" <cfif isdefined('get_wrk_fuseactions.is_employee') and get_wrk_fuseactions.is_employee eq 1>checked</cfif>>Employee</label>
                                        <label><input type="checkbox" id="is_employee_app" name="is_employee_app" <cfif isdefined('get_wrk_fuseactions.is_employee_app') and get_wrk_fuseactions.is_employee_app eq 1>checked</cfif>>Career</label>
                                    </div>
                                    <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                                        <label><input type="checkbox" id="is_company" name="is_company" <cfif isdefined('get_wrk_fuseactions.is_company') and get_wrk_fuseactions.is_company eq 1>checked</cfif>>Company</label>
                                        <label><input type="checkbox" id="is_consumer" name="is_consumer" <cfif isdefined('get_wrk_fuseactions.is_consumer') and get_wrk_fuseactions.is_consumer eq 1>checked</cfif>>Consumer</label>
                                    </div>
                                    <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                                        <label><input type="checkbox" id="is_machines" name="is_machines" <cfif isdefined('get_wrk_fuseactions.is_machines') and get_wrk_fuseactions.is_machines eq 1>checked</cfif>>Machines </label>
                                        <label><input type="checkbox" id="is_livestock" name="is_livestock" <cfif isdefined('get_wrk_fuseactions.is_livestock') and get_wrk_fuseactions.is_livestock eq 1>checked</cfif>>LiveStock</label>
                                    </div>
                                </cfoutput>
                            </div>
                        </div>
                    </div>
                    <div class="col col-4 col-md-4 col-sm-4 col-xs-12" index="2" type="column" sort="true">
                        <div class="form-group" id="item-solution">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12">Solution*</label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <select id="solution" name="solution" onchange="loadFamilies(this.value,'family','module')" required>
                                    <option value=""><cf_get_lang dictionary_id='57734.Please Select'></option>
                                    <cfoutput query="getSolution">
                                        <option value="#WRK_SOLUTION_ID#" <cfif get_wrk_fuseactions.SOLUTION_ID eq WRK_SOLUTION_ID>selected</cfif>>#NAME#</option>
                                    </cfoutput>
                                </select>
                            </div>
                        </div>
                        <div class="form-group" id="item-family">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12">Family*</label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <select id="family" name="family" onchange="loadModules(this.value,'module')" required>
                                    <option value=""><cf_get_lang dictionary_id='57734.Please Select'></option>
                                </select>
                            </div>
                        </div>
                        <div class="form-group" id="item-module">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12">Module*</label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <select id="module" name="module" required>
                                    <option value=""><cf_get_lang dictionary_id='57734.Please Select'></option>
                                </select>
                            </div>
                        </div>
                        <div class="form-group" id="item-wat_solution">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12">Watomic Solution</label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <select id="onchange="loadWatFamilies(this.value,'wat_family')"" name="wat_solution" onchange="loadWatFamilies(this.value,'wat_family')">
                                    <option value=""><cf_get_lang dictionary_id='57734.Please Select'></option>
                                    <cfoutput query="getWatomicSol">
                                        <option value="#WRK_WATOMIC_SOLUTION_ID#" <cfif get_wrk_fuseactions.WATOMIC_SOLUTION_ID eq WRK_WATOMIC_SOLUTION_ID>selected</cfif>>#NAME#</option>
                                    </cfoutput>
                                </select>
                            </div>
                        </div>
                        <div class="form-group" id="item-wat_family">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12">Watomic Family</label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <select id="wat_family" name="wat_family">
                                    <option value=""><cf_get_lang dictionary_id='57734.Please Select'></option>
                                    <cfif len(get_wrk_fuseactions.WATOMIC_FAMILY_ID)>
                                        <cfoutput query="getWatFamily">
                                            <option value="#WRK_WATOMIC_FAMILY_ID#" <cfif get_wrk_fuseactions.WATOMIC_FAMILY_ID eq WRK_WATOMIC_FAMILY_ID>selected</cfif>>#NAME#</option>
                                        </cfoutput>
                                    </cfif>
                                </select>
                            </div>
                        </div>
                        <div class="form-group" id="item-best-practice">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12">Best Practice</label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <cfset query_bp = list_wbo.getBestpractice()>
                                <cfset query_this_bp = list_wbo.getObjectsBestpractice(attributes.woid)>
                                <select name="bestpractice">
                                    <option value=""><cf_get_lang dictionary_id='57734.Please Select'></option>
                                    <cfoutput query="query_bp">
                                    <cfquery name="query_has_bestpractice" dbtype="query">
                                        SELECT COUNT(*) AS CNT FROM query_this_bp WHERE BESTPRACTICE_ID = #BESTPRACTICE_ID#
                                    </cfquery>
                                    <option value="#BESTPRACTICE_ID#"<cfif query_has_bestpractice.CNT neq "" and query_has_bestpractice.CNT gt 0><cfoutput> selected="selected"</cfoutput></cfif>>#BESTPRACTICE_NAME#</option>
                                    </cfoutput>
                                </select>
                            </div>
                        </div>        
                        <div class="form-group" id="item-type">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12">Type*</label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <select name="type" id="type" required>
                                    <option value=""><cf_get_lang dictionary_id='57734.Please Select'></option>
                                    <option value="0" <cfif get_wrk_fuseactions.type eq 0>selected</cfif>>WBO</option>
                                    <option value="13" <cfif get_wrk_fuseactions.type eq 13>selected</cfif>>Dashboard</option>
                                    <option value="8" <cfif get_wrk_fuseactions.type eq 8>selected</cfif>>Report</option>
                                    <option value="9" <cfif get_wrk_fuseactions.type eq 9>selected</cfif>>General</option>
                                    <option value="1" <cfif get_wrk_fuseactions.type eq 1>selected</cfif>>Param</option>
                                    <option value="2" <cfif get_wrk_fuseactions.type eq 2>selected</cfif>>SYSTEM</option>
                                    <option value="3" <cfif get_wrk_fuseactions.type eq 3>selected</cfif>>Import</option>
                                    <option value="12" <cfif get_wrk_fuseactions.type eq 12>selected</cfif>>Export</option>
                                    <option value="4" <cfif get_wrk_fuseactions.type eq 4>selected</cfif>>Period</option>
                                    <option value="5" <cfif get_wrk_fuseactions.type eq 5>selected</cfif>>Maintenance</option>
                                    <option value="6" <cfif get_wrk_fuseactions.type eq 6>selected</cfif>>Utility</option>
                                    <option value="7" <cfif get_wrk_fuseactions.type eq 7>selected</cfif>>DEV</option>
                                    <option value="10" <cfif get_wrk_fuseactions.type eq 10>selected</cfif>>Child WO</option>
                                    <option value="11" <cfif get_wrk_fuseactions.type eq 11>selected</cfif>>Query-Backend</option>
                                    <option value="14" <cfif get_wrk_fuseactions.type eq 14>selected</cfif>>Output Template</option>
                                    <option value="15" <cfif get_wrk_fuseactions.type eq 15>selected</cfif>>Process</option>

                                </select>
                            </div>
                        </div>
                        <div class="form-group" id="item-licence">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12">Licence'*</label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <select id="licence" name="licence" required>
                                    <option value=""><cf_get_lang dictionary_id='57734.Please Select'></option>
                                    <option value="1" <cfif get_wrk_fuseactions.LICENCE eq 1>selected</cfif>>Standard</option>
                                    <option value="2" <cfif get_wrk_fuseactions.LICENCE eq 2>selected</cfif>>Add-On</option>
                                </select>
                            </div>
                        </div>
                        <cfoutput>
                            <div class="form-group" id="item-author">
                                <label class="col col-4 col-md-4 col-sm-4 col-xs-12">Author</label>
                                <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                    <input type="hidden" name="author_emp_id" id="author_emp_id" value="#get_wrk_fuseactions.author#">
                                    <input type="text" name="author_name" id="author_name" value="#get_wrk_fuseactions.AUTHOR#">
                                </div>
                            </div>
                        </cfoutput>
                        <div class="form-group" id="item-events">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12">Events*</label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                                    <label>
                                        <input type="checkbox" name="eventAdd" id="eventAdd" value="1" <cfif get_wrk_fuseactions.event_add eq 1>checked="checked"</cfif>>
                                        Add
                                    </label> 
                                    <label>
                                        <input type="checkbox" name="eventUpd" id="eventUpd" value="1" <cfif get_wrk_fuseactions.event_upd eq 1>checked="checked"</cfif>>
                                        Update
                                    </label> 
                                </div>
                                <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                                    <label>
                                        <input type="checkbox" name="eventList" id="eventList" value="1" <cfif get_wrk_fuseactions.event_list eq 1>checked="checked"</cfif>>
                                        List
                                    </label>
                                    <label>
                                        <input type="checkbox" name="eventDetail" id="eventDetail" value="1" <cfif get_wrk_fuseactions.event_detail eq 1>checked="checked"</cfif>>
                                        Detail
                                    </label>
                                </div>
                                <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                                    <label>
                                        <input type="checkbox" name="eventDashboard" id="eventDashboard" value="1" <cfif get_wrk_fuseactions.event_dashboard eq 1>checked="checked"</cfif>>
                                        Dashboard
                                    </label>
                                    <label>
                                        <input type="checkbox" name="eventOutput" id="eventOutput" value="1" <cfif get_wrk_fuseactions.event_output eq 1>checked="checked"</cfif>>
                                        Output
                                    </label>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col col-4 col-md-4 col-sm-4 col-xs-12"  index="3" type="column" sort="true">
                        <div class="form-group" id="item-version">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12">Version* Main - Object</label>
                            <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                                <cfoutput>
                                    <input type="text" name="main_version" id="main_version" value="#get_wrk_fuseactions.main_version#">
                                </cfoutput>
                            </div>
                            <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                                <cfoutput>
                                    <input type="text" name="version" id="version" value="#get_wrk_fuseactions.version#" required>
                                </cfoutput>
                            </div>
                        </div>
                        <div class="form-group" id="item-statu">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12">Status*</label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <select name="status" id="status" required>
                                    <option value="Analys"<cfif get_wrk_fuseactions.status eq 'Analys'>selected</cfif>>Analysis</option>
                                    <option value="Deployment"<cfif get_wrk_fuseactions.status eq 'Deployment'>selected</cfif>>Deployment</option>
                                    <option value="Design"<cfif get_wrk_fuseactions.status eq 'Design'>selected</cfif>>Design</option>
                                    <option value="Development"<cfif get_wrk_fuseactions.status eq 'Development'>selected</cfif>>Development</option>
                                    <option value="Testing"<cfif get_wrk_fuseactions.status eq 'Testing'>selected</cfif>>Testing</option>
                                    <option value="Cancel"<cfif get_wrk_fuseactions.status eq 'Cancel'>selected</cfif>>Cancel</option>
                                </select>
                            </div>
                        </div>
                        <div class="form-group" id="item-stage">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12">Stage*</label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <cf_workcube_process is_upd='0' process_cat_width='150' is_detail='0' fusepath="dev.workdev">
                            </div>
                        </div>
                        <cfoutput>
                       
                        <div class="form-group" id="item-file-path">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12">File Path *</label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <input type="text" name="file_path" id="file_path" value="#get_wrk_fuseactions.FILE_PATH#">
                            </div>
                        </div>
                        <div class="form-group" id="item-file-path">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12">XML Path</label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <input type="text" name="xml_path" id="xml_path" value="#get_wrk_fuseactions.XML_PATH#">
                            </div>
                        </div>
                        <div class="form-group" id="item-data_cfc">
                            <label class="col col-4 col-xs-12">Data CFC</label>
                            <div class="col col-8 col-xs-12">
                                <input type="text" name="data_cfc" id="data_cfc" value="#get_wrk_fuseactions.DATA_CFC#">
                            </div>
                        </div>
                        <div class="form-group" id="controllerFilePath">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12">Controller File Path</label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <input type="text" name="controllerFilePath" id="controllerFilePath" value="#GET_WRK_FUSEACTIONS.CONTROLLER_FILE_PATH#">
                            </div>
                        </div>
                        <div class="form-group" id="addOptionsController">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12">Add-Options Controller File Path</label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <input type="text" name="addOptionsControllerFilePath" id="addOptionsControllerFilePath" value="#get_wrk_fuseactions.ADDOPTIONS_CONTROLLER_FILE_PATH#">
                            </div>
                        </div>
                        </cfoutput> <div class="form-group" id="item-process">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12">Process</label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                                    <label>
                                        <input type="checkbox" name="use_workflow" id="use_workflow" value="1" <cfif get_wrk_fuseactions.use_workflow eq 1>checked="checked"</cfif>>
                                        Use Workflow
                                    </label>
                                    <label>
                                        <input type="checkbox" name="use_system_no" id="use_system_no" value="1" <cfif get_wrk_fuseactions.use_system_no eq 1>checked="checked"</cfif>>
                                        Use System Paper No
                                    </label>
                                </div>
                                <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                                    <label>
                                        <input type="checkbox" name="use_process_cat" id="use_process_cat" value="1" onclick="process_cat_show(this);" <cfif get_wrk_fuseactions.use_process_cat eq 1>checked="checked"</cfif>>
                                        Process Type
                                    </label>
                                </div>
                            </div>
                        </div>
                    </div>
                </cf_box_elements>
                <div id="broadcast_area" vertical="1">
                    <cf_seperator title="Detail" id="detail_seperator">
                    <div style="display:none;" id="detail_seperator">
                        <cf_box_elements vertical="1">
                            <div class="col col-12 col-md-12 col-sm-12 col-xs-12" index="7" type="column" sort="true">
                                <div class="form-group" id="item-editor">
                                    <label style="display:none!important">Detail</label>
                                    <div class="col col-12" id="editor_id">
                                        <input type="hidden" name="detail_old_length" id="detail_old_length" value="<cfoutput>#len(get_wrk_fuseactions.detail)#</cfoutput>"> 
                                        <cfmodule template="/fckeditor/fckeditor.cfm"
                                        toolbarset="Basic"
                                        basepath="/fckeditor/"
                                        instancename="wo_detail"
                                        valign="top"
                                        value="#get_wrk_fuseactions.detail#"
                                        width="100%"
                                        height="180"> 
                                    </div>
                                </div>
                            </div>
                        </cf_box_elements>
                    </div>
                </div>
                <cf_seperator title="Extends" id="extends_seperator">
                <div style="display:none;" id="extends_seperator">
                    <cf_box_elements>
                        <div class="col col-6 col-md-6 col-sm-6 col-xs-12" index="8" type="column" sort="true">
                            <div><h4>Display</h4></div>
                            <div class="form-group" id="item-display_before_path">
                                <label class="col col-4 col-md-4 col-sm-4 col-xs-12">Before Run Path</label>
                                <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                    <input type="text" name="display_before_path" value="<cfoutput>#get_wrk_fuseactions.display_before_path#</cfoutput>">
                                </div>
                            </div>
                            <div class="form-group" id="item-display_after_path">
                                <label class="col col-4 col-md-4 col-sm-4 col-xs-12">After Run Path</label>
                                <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                    <input type="text" name="display_after_path" value="<cfoutput>#get_wrk_fuseactions.display_after_path#</cfoutput>">
                                </div>
                            </div>
                        </div>
                        <div class="col col-6 col-md-6 col-sm-6 col-xs-12" index="9" type="column" sort="true">
                            <div><h4>Action</h4></div>
                            <div class="form-group" id="item-action_before_path">
                                <label class="col col-4 col-md-4 col-sm-4 col-xs-12">Before Run Path</label>
                                <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                    <input type="text" name="action_before_path" value="<cfoutput>#get_wrk_fuseactions.action_before_path#</cfoutput>">
                                </div>
                            </div>
                            <div class="form-group" id="item-action_after_path">
                                <label class="col col-4 col-md-4 col-sm-4 col-xs-12">After Run Path</label>
                                <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                    <input type="text" name="action_after_path" value="<cfoutput>#get_wrk_fuseactions.action_after_path#</cfoutput>">
                                </div>
                            </div>
                        </div>
                    </cf_box_elements>
                </div>
                <cf_box_footer>
                    <cfif GET_WRK_FUSEACTIONS.recordcount>
                        <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                            <cf_record_info query_name="GET_WRK_FUSEACTIONS">
                        </div>
                        <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                            <cf_workcube_buttons is_upd='1' is_delete="0" add_function='OnFormSubmit()'>
                        </div>                        
                    <cfelse>
                        <cf_workcube_buttons is_upd='0' add_function='OnFormSubmit()'>
                    </cfif>
                </cf_box_footer>
                <button type="submit" id="hidden_submit_btn" style="display: none;"></button>
            </cfform>
            <div id="fuseactionControlDiv" style="display:block;"></div>
        </cf_box>
        <cfif len(get_wrk_fuseactions.full_fuseaction)>
            <cf_box title="Extensions" widget_load="Woextensions&is_submitted=1&related_wo=#get_wrk_fuseactions.full_fuseaction#&wo=1&fuseact=#get_wrk_fuseactions.full_fuseaction#"></cf_box>
        </cfif>
        <cf_box title="Insert Script" id="script" closable="0">
            <cf_box_elements>
                <cfoutput>
                    <textarea rows="110" cols="70">
                        IF NOT EXISTS (
                        SELECT WRK_OBJECTS_ID
                        FROM WRK_OBJECTS
                        WHERE FULL_FUSEACTION = '#get_wrk_fuseactions.full_fuseaction#'
                        )
                        BEGIN
                            INSERT [WRK_OBJECTS] (
                                [IS_ACTIVE]
                                ,[MODULE_NO]
                                ,[HEAD]
                                ,[DICTIONARY_ID]
                                ,[FRIENDLY_URL]
                                ,[FULL_FUSEACTION]
                                ,[FILE_PATH]
                                ,[CONTROLLER_FILE_PATH]
                                ,[MAIN_VERSION]
                                ,[LICENCE]
                                ,[STATUS]
                                ,[IS_MENU]
                                ,[WINDOW]
                                ,[VERSION]
                                ,[USE_PROCESS_CAT]
                                ,[USE_SYSTEM_NO]
                                ,[USE_WORKFLOW]
                                ,[AUTHOR]
                                ,[OBJECTS_COUNT]
                                ,[RECORD_IP]
                                ,[RECORD_EMP]
                                ,[RECORD_DATE]
                                ,[UPDATE_IP]
                                ,[UPDATE_EMP]
                                ,[UPDATE_DATE]
                                ,[SECURITY]
                                ,[STAGE]
                                ,[MODUL]
                                ,[MODUL_SHORT_NAME]
                                ,[FUSEACTION]
                                ,[FILE_NAME]
                                ,[IS_ADD]
                                ,[IS_UPDATE]
                                ,[IS_DELETE]
                                ,[IS_WBO_DENIED]
                                ,[IS_WBO_LOCK]
                                ,[IS_WBO_LOG]
                                ,[IS_SPECIAL]
                                ,[EVENT_ADD]
                                ,[EVENT_DASHBOARD]
                                ,[EVENT_DETAIL]
                                ,[EVENT_LIST]
                                ,[EVENT_UPD]
                                ,[TYPE]
                                ,[POPUP_TYPE]
                                ,[EXTERNAL_FUSEACTION]
                                ,[IS_LEGACY]
                                ,[ADDOPTIONS_CONTROLLER_FILE_PATH]
                                )
                            VALUES (
                                #get_wrk_fuseactions.is_active#
                                ,#get_wrk_fuseactions.module_no#
                                ,'#get_wrk_fuseactions.head#'
                                ,<cfif len(get_wrk_fuseactions.dictionary_id)>#get_wrk_fuseactions.dictionary_id#<cfelse>NULL</cfif>
                                ,<cfif len(get_wrk_fuseactions.friendly_url)>'#get_wrk_fuseactions.friendly_url#'<cfelse>NULL</cfif>
                                ,'#get_wrk_fuseactions.full_fuseaction#'
                                ,'#get_wrk_fuseactions.file_path#'
                                ,<cfif len(get_wrk_fuseactions.controller_file_path)>'#get_wrk_fuseactions.controller_file_path#'<cfelse>NULL</cfif>
                                ,<cfif len(get_wrk_fuseactions.main_version)>'#get_wrk_fuseactions.main_version#'<cfelse>NULL</cfif>
                                ,#get_wrk_fuseactions.licence#
                                ,'#get_wrk_fuseactions.status#'
                                ,<cfif len(get_wrk_fuseactions.is_menu)>#get_wrk_fuseactions.is_menu#<cfelse>NULL</cfif>
                                ,<cfif len(get_wrk_fuseactions.window)>'#get_wrk_fuseactions.window#'<cfelse>NULL</cfif>
                                ,'#get_wrk_fuseactions.version#'
                                ,<cfif len(get_wrk_fuseactions.use_process_cat)>#get_wrk_fuseactions.use_process_cat#<cfelse>NULL</cfif>
                                ,<cfif len(get_wrk_fuseactions.use_system_no)>#get_wrk_fuseactions.use_system_no#<cfelse>NULL</cfif>
                                ,<cfif len(get_wrk_fuseactions.use_workflow)>#get_wrk_fuseactions.use_workflow#<cfelse>NULL</cfif>
                                ,<cfif len(get_wrk_fuseactions.author)>'#get_wrk_fuseactions.author#'<cfelse>NULL</cfif>
                                ,<cfif len(get_wrk_fuseactions.objects_count)>#get_wrk_fuseactions.objects_count#<cfelse>NULL</cfif>
                                ,<cfif len(get_wrk_fuseactions.record_ip)>'#get_wrk_fuseactions.record_ip#'<cfelse>NULL</cfif>
                                ,<cfif len(get_wrk_fuseactions.record_emp)>#get_wrk_fuseactions.record_emp#<cfelse>NULL</cfif>
                                ,<cfif len(get_wrk_fuseactions.record_date)>'#get_wrk_fuseactions.record_date#'<cfelse>NULL</cfif>
                                ,<cfif len(get_wrk_fuseactions.update_ip)>'#get_wrk_fuseactions.update_ip#'<cfelse>NULL</cfif>
                                ,<cfif len(get_wrk_fuseactions.update_emp)>#get_wrk_fuseactions.update_emp#<cfelse>NULL</cfif>
                                ,<cfif len(get_wrk_fuseactions.update_date)>'#get_wrk_fuseactions.update_date#'<cfelse>NULL</cfif>
                                ,'#get_wrk_fuseactions.security#'
                                ,<cfif len(get_wrk_fuseactions.stage)>#get_wrk_fuseactions.stage#<cfelse>NULL</cfif>
                                ,<cfif len(get_wrk_fuseactions.modul)>'#get_wrk_fuseactions.modul#'<cfelse>NULL</cfif>
                                ,'#get_wrk_fuseactions.modul_short_name#'
                                ,'#get_wrk_fuseactions.fuseaction#'
                                ,<cfif len(get_wrk_fuseactions.file_name)>'#get_wrk_fuseactions.file_name#'<cfelse>NULL</cfif>
                                ,<cfif len(get_wrk_fuseactions.is_add)>#get_wrk_fuseactions.is_add#<cfelse>NULL</cfif>
                                ,<cfif len(get_wrk_fuseactions.is_update)>#get_wrk_fuseactions.is_update#<cfelse>NULL</cfif>
                                ,<cfif len(get_wrk_fuseactions.is_delete)>#get_wrk_fuseactions.is_delete#<cfelse>NULL</cfif>
                                ,<cfif len(get_wrk_fuseactions.is_wbo_denied)>#get_wrk_fuseactions.is_wbo_denied#<cfelse>NULL</cfif>
                                ,<cfif len(get_wrk_fuseactions.is_wbo_lock)>#get_wrk_fuseactions.is_wbo_lock#<cfelse>NULL</cfif>
                                ,<cfif len(get_wrk_fuseactions.is_wbo_log)>#get_wrk_fuseactions.is_wbo_log#<cfelse>NULL</cfif>
                                ,<cfif len(get_wrk_fuseactions.is_special)>#get_wrk_fuseactions.is_special#<cfelse>NULL</cfif>
                                ,<cfif len(get_wrk_fuseactions.event_add)>#get_wrk_fuseactions.event_add#<cfelse>NULL</cfif>
                                ,<cfif len(get_wrk_fuseactions.event_dashboard)>#get_wrk_fuseactions.event_dashboard#<cfelse>NULL</cfif>
                                ,<cfif len(get_wrk_fuseactions.event_detail)>#get_wrk_fuseactions.event_detail#<cfelse>NULL</cfif>
                                ,<cfif len(get_wrk_fuseactions.event_list)>#get_wrk_fuseactions.event_list#<cfelse>NULL</cfif>
                                ,<cfif len(get_wrk_fuseactions.event_upd)>#get_wrk_fuseactions.event_upd#<cfelse>NULL</cfif>
                                ,<cfif len(get_wrk_fuseactions.type)>#get_wrk_fuseactions.type#<cfelse>NULL</cfif> 
                                ,<cfif len(get_wrk_fuseactions.popup_type)>#get_wrk_fuseactions.popup_type#<cfelse>NULL</cfif> 
                                ,<cfif len(get_wrk_fuseactions.external_fuseaction)>'#get_wrk_fuseactions.external_fuseaction#'<cfelse>NULL</cfif> 
                                ,<cfif len(get_wrk_fuseactions.is_legacy)>#get_wrk_fuseactions.is_legacy#<cfelse>NULL</cfif>
                                ,<cfif len(get_wrk_fuseactions.addoptions_controller_file_path)>'#get_wrk_fuseactions.addoptions_controller_file_path#'<cfelse>NULL</cfif>
                                )
                        END
                    </textarea>
                </cfoutput>
            </cf_box_elements>
        </cf_box>
        <cfif get_wrk_fuseactions.is_legacy eq 0 or get_wrk_fuseactions.is_legacy eq 1>
            <cfinclude template = "_controller_and_list.cfm" />
        <cfelseif get_wrk_fuseactions.is_legacy eq 2>
            <cfinclude template = "_widget.cfm" />
            <cfinclude template = "_event.cfm" />
        
        </cfif>
    </div>
</div>
</div>
<cfinclude template="scripts.cfm">
<script>
    <cfif isdefined("attributes.Works")>
        $(document).ready(function(){
            AjaxPageLoad('<cfoutput>#request.self#?fuseaction=project.emptypopup_ajax_project_works&project_detail_id=2&WorkdevList=1&Workfuse=#attributes.fuseact#</cfoutput>&is_submited=1','objects',1);
        });
    <cfelseif  isdefined("attributes.Calls")>
        $(document).ready(function(){
        AjaxPageLoad('<cfoutput>#request.self#?fuseaction=objects.call_center&Workfuse=#attributes.fuseact#</cfoutput>','objects',1);
    });
    </cfif>
    function open_objects(url,id) {
		
		AjaxPageLoad(url,'objects',1);
		return false;
	}
    function loadWatFamilies(solutionId,target,related,selected)
    {
        $('#'+related+" option[value!='']").remove();
        $.ajax({
                url: '/WMO/GeneralFunctions.cfc?method=getWatomicFamily&dsn=<cfoutput>#dsn#</Cfoutput>&solutionId=' + solutionId,
                success: function(data) {
                if(data)
                {
                    $('#'+target+" option[value!='']").remove();
                    data = $.parseJSON( data );
                    for(i=0;i<data.DATA.length;i++)
                    {
                        var option = $('<option/>');
                        if(selected && selected == data.DATA[i][0])
                            option.attr({ 'value': data.DATA[i][0], 'selected':'selected' }).text(data.DATA[i][1]);
                        else
                            option.attr({ 'value': data.DATA[i][0] }).text(data.DATA[i][1]);
                        $('#'+target).append(option);
                    }
                }
                }
            });
    }
</script>