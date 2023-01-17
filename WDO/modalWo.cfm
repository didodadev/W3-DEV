<cf_get_lang_set module_name="dev">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.author_emp_id" default="">
<cfparam name="attributes.base" default="">
<cfparam name="attributes.query_order" default="">
<cfparam name="attributes.modul" default="">
<cfparam name="attributes.process_stage" default="">
<cfparam name="attributes.status" default="">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.is_active" default=1>
<cfparam name="attributes.is_special" default="">
<cfparam name="attributes.solution" default="">
<cfparam name="attributes.wat_solution" default="">
<cfparam name="attributes.wat_family" default="">
<cfparam name="attributes.family" default="">
<cfparam name="attributes.module" default="">
<cfparam name="attributes.is_menu" default="">
<cfparam name="attributes.is_legacy" default="">
<cfparam name="attributes.maxrow" default='#session.ep.maxrows#'>
<cfparam name="attributes.licence" default="">
<cfparam name="attributes.typeObject" default="">
<cfparam name="attributes.author" default="">
<cfparam name="attributes.main_version" default="">
<cfparam name="attributes.publish_on" default="">
<cfparam name="attributes.events" default="">
<!--- Sayfa Tipleri tanimlaniyor --->
<!--- Isme gore siralandi sira degistirilmesin --->
<cfset item_count = 0>
<cfset list_wbo = createObject("component", "development.cfc.list_wbo")>
<cfif isdefined("attributes.is_submitted")>
    <cfset get_wbo = list_wbo.getWrkFuesactions(
            dsn : dsn,
            woid : '',
            solution : '#IIf(len(attributes.solution),"attributes.solution",DE(""))#',
            family : '#IIf(len(attributes.family),"attributes.family",DE(""))#',
            module : '#IIf(len(attributes.module),"attributes.module",DE(""))#',
            is_menu : '#IIf(IsDefined("attributes.is_menu"),"attributes.is_menu",DE(""))#',
            is_legacy : '#IIf(IsDefined("attributes.is_legacy"),"attributes.is_legacy",DE(""))#',
            typeObject : '#IIf(len(attributes.typeObject),"attributes.typeObject",DE(""))#',
            keyword : '#IIf(len(attributes.keyword),"attributes.keyword",DE(""))#',
            licence : '#IIf(len(attributes.licence),"attributes.licence",DE(""))#',
            status : '#IIf(len(attributes.status),"attributes.status",DE(""))#',
            author : '#IIf(len(attributes.author),"attributes.author",DE(""))#',
            main_version : '#IIf(len(attributes.main_version),"attributes.main_version",DE(""))#',
            publish_on : '#IIf(len(attributes.publish_on),"attributes.publish_on",DE(""))#',
            events : '#IIf(len(attributes.events),"attributes.events",DE(""))#',
            wat_solution: '#IIf(len(attributes.wat_solution),"attributes.wat_solution",DE(""))#',
            wat_family: '#IIf(len(attributes.wat_family),"attributes.wat_family",DE(""))#'
    )>
<cfelse>
    <cfset get_wbo.recordcount=0>
</cfif>
<cfset getSolutions = list_wbo.getSolution()>
<cfset getFamilies = list_wbo.getFamily()>
<cfset getModules = list_wbo.getModule()>
<cfset getWatomicSol = list_wbo.getWatomicSolution()>
<cfparam name="attributes.totalrecords" default="#get_wbo.recordcount#">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrow)+1>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
<cf_box id="wo_search_area" closable="0" collapsable="0">
    <cfform name="wbo_list" action="#request.self#?fuseaction=dev.wo" method="post" target="_self">
        <input type="hidden" name="is_submitted" id="is_submitted" value="1" />
        <cf_box_search>
            <div class="form-group">
                <input type="text" name="keyword" id="keyword" style="width:100px;" value="<cfoutput>#attributes.keyword#</cfoutput>" placeholder="<cf_get_lang dictionary_id='57460.Filter'>" maxlength="255" onKeyDown="if(event.keyCode == 13) {searchButtonFunc()}">
            </div>
            <div class="form-group">
                <select id="solution" name="solution" onchange="loadFamilies(this.value,'family','module')">
                    <option value="">Solution</option>
                    <cfoutput query="getSolutions">
                        <option value="#WRK_SOLUTION_ID#"<cfif attributes.solution eq WRK_SOLUTION_ID>selected</cfif>>#NAME#</option>
                    </cfoutput>
                </select>
            </div>
            <div class="form-group">
                <select id="family" name="family" onchange="loadModules(this.value,'module')">
                    <option value="">Family</option>
                </select>
            </div>
            <div class="form-group">
                <select id="module" name="module">
                    <option value="">Module</option>
                </select>
            </div>
            <div class="form-group">
                <select name="licence" id="licence">
                    <option value="">Licence</option>
                    <option value="1" <cfif attributes.licence eq 1>selected</cfif>>Standard</option>
                    <option value="2" <cfif attributes.licence eq 2>selected</cfif>>Add-On</option>
                </select>
            </div>
            <div class="form-group">
                <select name="typeObject" id="typeObject" style="width:100px;">
                    <option value="">Type</option>
                    <option value="0" <cfif attributes.typeObject eq 0>selected</cfif>>WBO</option>
                    <option value="13" <cfif attributes.typeObject eq 13>selected</cfif>>Dashboard</option>
                    <option value="8" <cfif attributes.typeObject eq 8>selected</cfif>>Report</option>
                    <option value="9" <cfif attributes.typeObject eq 9>selected</cfif>>General</option>
                    <option value="1" <cfif attributes.typeObject eq 1>selected</cfif>>Param</option>           
                    <option value="2" <cfif attributes.typeObject eq 2>selected</cfif>>SYSTEM</option>
                    <option value="3" <cfif attributes.typeObject eq 3>selected</cfif>>Import</option>
                    <option value="12" <cfif attributes.typeObject eq 12>selected</cfif>>Export</option>
                    <option value="4" <cfif attributes.typeObject eq 4>selected</cfif>>Period</option>
                    <option value="5" <cfif attributes.typeObject eq 5>selected</cfif>>Maintenance</option>
                    <option value="6" <cfif attributes.typeObject eq 6>selected</cfif>>Utility</option>
                    <option value="7" <cfif attributes.typeObject eq 7>selected</cfif>>DEV</option>
                    <option value="10" <cfif attributes.typeObject eq 10>selected</cfif>>Child WO</option>
                    <option value="11" <cfif attributes.typeObject eq 11>selected</cfif>>Query-Backend</option>
                    <option value="14" <cfif attributes.typeObject eq 14>selected</cfif>>Output Template</option>
                    <option value="15" <cfif attributes.typeObject eq 15>selected</cfif>>Process</option>
                </select>
            </div>
            <div class="form-group">
                <select name="status" id="status">
                    <option value="">Status</option>
                    <option value="Analys"<cfif attributes.status eq 'Analys'>selected</cfif>>Analysis</option>
                    <option value="Deployment"<cfif attributes.status eq 'Deployment'>selected</cfif>>Deployment</option>
                    <option value="Design"<cfif attributes.status eq 'Design'>selected</cfif>>Design</option>
                    <option value="Development"<cfif attributes.status eq 'Development'>selected</cfif>>Development</option>
                    <option value="Testing"<cfif attributes.status eq 'Testing'>selected</cfif>>Testing</option>
                    <option value="Cancel"<cfif attributes.status eq 'Cancel'>selected</cfif>>Cancel</option>
                </select>
            </div>
            <div class="form-group">
                <cfoutput>
                    <select name="is_legacy" id="is_legacy">
                        <option value="">Mode</option>
                        <option value="0"#iif( attributes.is_legacy eq 0, de(' selected="selected"'), de("") )#>Catalyst</option>
                        <option value="2"#iif( attributes.is_legacy eq 2, de(' selected="selected"'), de("") )#>Holistic</option>
                        <option value="1"#iif( attributes.is_legacy eq 1, de(' selected="selected"'), de("") )#>Legacy</option>
                    </select>
                </cfoutput>
            </div>  
            <div class="form-group">
                <label><input type="checkbox" name="is_menu" id="is_menu" value="1" <cfif isdefined("attributes.is_menu")></cfif>/>Menu</label>
            </div><!---
            <div class="form-group">
                <label><input type="checkbox" name="is_legacy" id="is_legacy" value="1" <cfif isdefined("attributes.is_legacy")>checked="checked"</cfif>/>Legacy</label> --->
            
            
            <div class="form-group small">
                <cfsavecontent variable="message">Incorrect Record Number</cfsavecontent>
                <cfinput type="text" name="maxrow" value="#attributes.maxrow#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
            </div>
            <div class="form-group">
                <cf_wrk_search_button button_type='4'>
            </div>
        </cf_box_search>
        <cf_box_search_detail>
            <div class="col col-6 col-md-6 col-sm-6 col-xs-12" index="1" type="column" sort="true">
                <div class="col col-6 col-md-3 col-sm-6 col-xs-12" index="1" type="column" sort="true">
                    <div class="form-group" id="item-publish-on">
                        <label>Yayın Alanı</label>
                        <cfoutput>
                            <select id="publish_on" name="publish_on" multiple style="height: 90px;">
                                <option value="is_public" <cfif listfind(attributes.publish_on,'is_public',',')>selected</cfif>>Public</option>
                                <option value="is_employee" <cfif listfind(attributes.publish_on,'is_employee',',')>selected</cfif>>Employee</option>
                                <option value="is_employee_app" <cfif listfind(attributes.publish_on,'is_employee_app',',')>selected</cfif>>Career</option>
                                <option value="is_company"<cfif listfind(attributes.publish_on,'is_company',',')>selected</cfif>>Company</option>
                                <option value="is_consumer" <cfif listfind(attributes.publish_on,'is_consumer',',')>selected</cfif>>Consumer</option>
                                <option value="is_machines" <cfif listfind(attributes.publish_on,'is_machines',',')>selected</cfif>>Machines</option>
                                <option value="is_livestock" <cfif listfind(attributes.publish_on,'is_livestock',',')>selected</cfif>>LiveStock</option>
                            </select> 
                        </cfoutput>
                    </div>
                </div>
                <div class="col col-6 col-md-3 col-sm-6 col-xs-12" index="2" type="column" sort="true">
                    <div class="form-group" id="item-events">
                        <label>Events</label>
                        <cfoutput>
                            <select id="events" name="events" multiple style="height: 90px;">
                                <option value="is_add" <cfif listfind(attributes.events,'is_add',',')>selected</cfif>>Add</option>
                                <option value="is_update" <cfif listfind(attributes.events,'is_update',',')>selected</cfif>>Update</option>
                                <option value="is_list" <cfif listfind(attributes.events,'is_list',',')>selected</cfif>>List</option>
                                <option value="is_detail"<cfif listfind(attributes.events,'is_detail',',')>selected</cfif>>Detail</option>
                                <option value="is_dashboard" <cfif listfind(attributes.events,'is_dashboard',',')>selected</cfif>>Dashboard</option>
                                <option value="is_output" <cfif listfind(attributes.events,'is_output',',')>selected</cfif>>Output</option>
                            </select> 
                        </cfoutput>
                    </div>
                </div>
            </div>
            <div class="col col-6 col-md-6 col-sm-6 col-xs-12" index="2" type="column" sort="true">
                <div class="col col-6 col-md-3 col-sm-6 col-xs-12" index="1" type="column" sort="true">
                    <div class="form-group" id="item-wat_solution">
                        <label>Watomic Solution</label>
                        <select id="wat_solution" name="wat_solution" onchange="loadWatFamilies(this.value,'wat_family')">
                            <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                            <cfoutput query="getWatomicSol">
                                <option value="#WRK_WATOMIC_SOLUTION_ID#" <cfif attributes.wat_solution eq WRK_WATOMIC_SOLUTION_ID>selected</cfif>>#NAME#</option>
                            </cfoutput>
                        </select>
                    </div>
                </div>
                <div class="col col-6 col-md-3 col-sm-6 col-xs-12" index="2" type="column" sort="true">
                    <div class="form-group" id="item-wat_family">
                        <label>Watomic Family</label>
                        <select id="wat_family" name="wat_family">
                            <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                        </select>
                    </div>
                </div>
                <div class="col col-6 col-md-3 col-sm-6 col-xs-12" index="3" type="column" sort="true">
                    <div class="form-group" id="item-author">
                        <label>Author</label>
                        <cfinput type="text" name="author" id="author" value="#attributes.author#" maxlength="255">
                    </div>
                </div>
                <div class="col col-6 col-md-3 col-sm-6 col-xs-12" index="4" type="column" sort="true">
                    <div class="form-group" id="item-main_version">
                        <label>Main Version</label>
                        <cfinput type="text" name="main_version" id="main_version" value="#attributes.main_version#" maxlength="250">
                    </div>
                </div>
            </div>
        </cf_box_search_detail>
    </cfform>
</cf_box>
<cf_box title="Workcube Objects" id="wo_list" hide_table_column="1" uidrop="1">
    <cf_ajax_list>
        <thead>
            <tr>
                <th width="15">No</th>
                <th>Head</th>
                <th width="30">User Friendly</th>
                <th>Fuseaction</th>
                <th>Solution / Family / Module</th>
                <th>Watomic Solution/ Family</th>
                <th>Licence</th>
                <th>Status</th>
                <th>Type</th>
                <th style="width:130px;">Author</th>
                <th width="30">Count</th>
                <th width="20"><a href="<cfoutput>#request.self#?fuseaction=dev.wo&event=add</cfoutput>"><i class="fa fa-plus"></i></a></th>
            </tr>
        </thead>
        <cfif get_wbo.recordcount>
            <cfoutput query="get_wbo" startrow="#attributes.startrow#" maxrows="#attributes.maxrow#">
                <tbody>
                    <tr>
                        <td>#currentrow#</td>
                        <td><a href="#request.self#?fuseaction=dev.wo&event=upd&fuseact=#full_fuseaction#&woid=#WRK_OBJECTS_ID#" class="tableyazi">#head#</a></td>
                        <td>#FRIENDLY_URL#</td>
                        <td><cfif len(full_fuseaction)>#full_fuseaction#<cfelse>#EXTERNAL_FUSEACTION#</cfif></td>
                        <td>
                            <cfif len(MODULE_NO)>
                                <cf_get_lang dictionary_id="#solution_dictionary_id#"> / <cf_get_lang dictionary_id="#family_dictionary_id#"> / <cf_get_lang dictionary_id="#module_dictionary_id#">
                            <cfelse>
                                Modul Definition Empty
                            </cfif>
                        </td>
                        <td>
                            <cfif len(WRK_WATOMIC_FAMILY_DICTONARY_ID)>
                                <cf_get_lang dictionary_id="#WRK_WATOMIC_SOLUTION_DICTIONARY_ID#"> / <cf_get_lang dictionary_id="#WRK_WATOMIC_FAMILY_DICTONARY_ID#">
                            </cfif>
                            </td>
                        <td><cfif LICENCE eq 1>Standard<cfelseif LICENCE eq 2>Add-On</cfif></td>
                        <td>#status#</td>
                        <td>
                            <cfif TYPE eq 0>WBO</cfif>
                            <cfif TYPE eq 13>Dashboard</cfif>
                            <cfif TYPE eq 8>Report</cfif>
                            <cfif TYPE eq 9>General</cfif>
                            <cfif TYPE eq 1>Param</cfif>
                            <cfif TYPE eq 2>SYSTEM</cfif>
                            <cfif TYPE eq 3>Import</cfif>
                            <cfif TYPE eq 12>Export</cfif>
                            <cfif TYPE eq 4>Period</cfif>
                            <cfif TYPE eq 5>Maintenance</cfif>
                            <cfif TYPE eq 6>Utility</cfif>
                            <cfif TYPE eq 7>DEV</cfif>
                            <cfif TYPE eq 10>Child WO</cfif>
                            <cfif TYPE eq 11>Query-Backend</cfif>
                            <cfif TYPE eq 14>Output Template</cfif>
                            <cfif TYPE eq 15>Process</cfif>
                        </td>
                        <td>#AUTHOR#</td>
                        <td>#objects_count#</td>
                        <td> <a href="#request.self#?fuseaction=dev.wo&event=upd&fuseact=#full_fuseaction#&woid=#WRK_OBJECTS_ID#"><i class="fa fa-pencil"></i></a></td>                        
                    </tr>
                </tbody>
            </cfoutput>
        <cfelse>
            <td colspan="11"><cfif isdefined("attributes.is_submitted")><cf_get_lang dictionary_id='57484.No record'> !<cfelse><cf_get_lang dictionary_id='57701.Please Filter'> !</cfif></td>
        </cfif> 
    </cf_ajax_list>
    <cfif attributes.totalrecords gt attributes.maxrow>    
        <cfset adres="dev.wo&is_submitted=1">
        <cfif isDefined('attributes.keyword') and len(attributes.keyword)>
            <cfset adres = "#adres#&keyword=#attributes.keyword#">
        </cfif>
        <cfif isDefined('attributes.solution') and len(attributes.solution)>
            <cfset adres = "#adres#&solution=#attributes.solution#">
        </cfif>
        <cfif isDefined('attributes.family') and len(attributes.family)>
            <cfset adres = "#adres#&family=#attributes.family#">
        </cfif>
        <cfif isdefined("attributes.module") and len(attributes.module)>
            <cfset adres = "#adres#&module=#attributes.module#" >
        </cfif>
        <cfif isdefined("attributes.licence") and len(attributes.licence)>
            <cfset adres = "#adres#&licence=#attributes.licence#">
        </cfif>
        <cfif isdefined("attributes.typeObject") and len(attributes.typeObject)>
            <cfset adres = "#adres#&typeObject=#attributes.typeObject#">
        </cfif>
        <cfif isdefined("attributes.status") and len(attributes.status)>
            <cfset adres = "#adres#&status=#attributes.status#">
        </cfif>
        <cfif isdefined("attributes.is_menu") and len(attributes.is_menu)>
            <cfset adres = "#adres#&is_menu=#attributes.is_menu#">
        </cfif>
        <cfif isdefined("attributes.is_legacy") and len(attributes.is_legacy)>
            <cfset adres = "#adres#&is_legacy=#attributes.is_legacy#">
        </cfif>
        <cfif isdefined("attributes.events") and len(attributes.events)>
            <cfset adres = "#adres#&events=#attributes.events#">
        </cfif>
        <cfif len(attributes.maxrow)>
            <cfset adres = "#adres#&maxrow=#attributes.maxrow#">
        </cfif>
        <cfif len(attributes.main_version)>
            <cfset adres = "#adres#&main_version=#attributes.main_version#">
        </cfif>
        <cfif len(attributes.publish_on)>
            <cfset adres = "#adres#&publish_on=#attributes.publish_on#">
        </cfif>
        <cf_paging 
        page="#attributes.page#" 
        maxrows="#attributes.maxrow#" 
        totalrecords="#attributes.totalrecords#"
        startrow="#attributes.startrow#" 
        adres="#adres#">
    </cfif>
</cf_box>
</div>
<script type="text/javascript">

function searchButtonFunc()
{
    str = '';
    $("#wbo_list").find("select,input").each(function(index,element){
            if($(element).attr('type') != 'checkbox')
                str = str + '&'+$(element).attr('name')+'='+$(element).val();
            else
                {
                    if($(element).is(':checked'))
                        str = str + '&'+$(element).attr('name')+'='+$(element).val();
                }
        });
    AjaxPageLoad('<cfoutput>#request.self#?fuseaction=objects.emptypopup_system&type=wo</cfoutput>&'+str,'workDev-page-content');	
    return false; 
}


function loadFamilies(solutionId,target,related,selected)
{
    $('#'+related+" option[value!='']").remove();
    $.ajax({
            url: '/WMO/GeneralFunctions.cfc?method=getFamily&dsn=<cfoutput>#dsn#</Cfoutput>&solutionId=' + solutionId,
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
function loadModules(familyId,target,selected)
{
    $.ajax({
            url: '/WMO/GeneralFunctions.cfc?method=getModule&dsn=<cfoutput>#dsn#</Cfoutput>&familyId=' + familyId,
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

$(function(){
    <cfif len(attributes.SOLUTION)>
        loadFamilies('<cfoutput>#attributes.SOLUTION#</cfoutput>','family','module','<cfoutput>#attributes.family#</cfoutput>');
    </cfif>
    <cfif len(attributes.family)>
        loadModules('<cfoutput>#attributes.family#</cfoutput>','module','<cfoutput>#attributes.module#</cfoutput>');
    </cfif>
    <cfif len(attributes.wat_solution)>
        loadWatFamilies('<cfoutput>#attributes.wat_solution#</cfoutput>','wat_family','wat_family','<cfoutput>#attributes.wat_family#</cfoutput>');
    </cfif>
    });


function goObject(fuseaction,external)
{
    AjaxPageLoad('<cfoutput>#request.self#?fuseaction=objects.emptypopup_system&type=workcubeobject&event=upd&fuseact=</cfoutput>'+fuseaction+'&fuseactExternal='+external,'workDev-page-content');
}
</script>

