<cfparam name="attributes.component" default="0">
<cfparam name="attributes.formsubmited" default="">
<cfparam name="attributes.maxrow" default="#session.ep.maxrows#">
<cfparam name="attributes.totalrecords" default="0">
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.startrow" default="#(attributes.page-1)*(attributes.maxrow)#">
<cfset list_wbo = createObject("component", "WDO.development.cfc.list_wbo")>

<cfif len(attributes.formsubmited) || isDefined("attributes.selfwo")>
    <cfscript>
        qparam = structNew();
        if (isDefined("attributes.selfwo")) {
            qparam.fuseaction = attributes.fuseact;
        }
        if (isDefined("attributes.solutionid") && len(attributes.solutionid)) {
            qparam.solutionid = attributes.solutionid;
        }
        if (isDefined("attributes.familyid") && len(attributes.familyid)) {
            qparam.familyid = attributes.familyid;
        }
        if (isDefined("attributes.moduleid") && len(attributes.moduleid)) {
            qparam.moduleid = attributes.moduleid;
        }
        if (isDefined("attributes.event_type")) {
            qparam.type = attributes.event_type;
        }
        if (isDefined("attributes.keyword")) {
            qparam.title = attributes.keyword;
        }
    </cfscript>
    <cfset query_event = get_events(argumentCollection = qparam)>
</cfif>
<form name="listEvents" id="listEvents" method="get">
    <input type="hidden" name="formsubmited" id="formsubmited" value="1">
    <cfoutput><input type="hidden" name="fuseact" id="fuseact" value="#attributes.fuseact#"></cfoutput>
    <cfif isDefined("attributes.selfwo")>
        <input type="hidden" name="selfwo" id="selfwo" value="1">
    </cfif>

    <cf_box>
        <cf_box_search>
            <div class="form-group">
                <input type="text" name="keyword" id="keyword" value="<cfoutput>#iif(isDefined("attributes.keyword"), "attributes.keyword", de(""))#</cfoutput>" placeholder="Keyword">
            </div>
            <div class="form-group">
                <select id="solutionid" name="solutionid" onchange="loadFamilies(this.value, 'familyid', 'moduleid')">
                    <option value="">Solutions</option>
                    <cfset get_solution = list_wbo.getSolution()>
                    <cfoutput query="get_solution">
                        <option value="#WRK_SOLUTION_ID#"#iif(isdefined("attributes.solutionid") && attributes.solutionid eq WRK_SOLUTION_ID, de(' selected="selected"'), de(""))#>#NAME#</option>
                    </cfoutput>
                </select>
            </div>
            <div class="form-group">
                <select id="familyid" onchange="loadModules(this.value, 'moduleid')">
                    <option value="">Families</option>
                </select>
            </div>
            <div class="form-group">
                <select id="moduleid">
                    <option value="">Modules</option>
                </select>
            </div>
            <div class="form-group">
                <select name="licence" id="licence" style="width:100px;">
                    <option value="">Licence</option>
                    <option value="1" <cfif isdefined("attributes.licence")&& attributes.licence eq 1>selected</cfif>>Standart</option>
                    <option value="2" <cfif isdefined("attributes.licence")&& attributes.licence eq 2>selected</cfif>>Add-On</option>
                    <option value="3" <cfif isdefined("attributes.licence")&& attributes.licence eq 3>selected</cfif>>Add-Opitons</option>
                </select>
            </div>
            <div class="form-group small" id="item-maxrows">
                <input type="text" name="maxrow" id="maxrow" value="<cfoutput>#attributes.maxrow#</cfoutput>">
            </div>
            <div class="form-group">
                <cf_wrk_search_button button_type="4" search_function="searchComponents()">
            </div>
        </cf_box_search>
    </cf_box>
</form>
<cf_box title="Events">
    <cf_flat_list>
        <thead>
            <tr>
                <th>#</th>
                <th>Title</th>
                <th>Fuseaction</th>
                <th>Event</th>
                <th>Solution</th>
                <th>Family</th>
                <th>Version</th>
                <th width="20"><a href="javascript:void(0)" title="Form"><i class="fa fa-pencil"></i></a></th>
                <th width="20"><a href="javascript:void(0)" title="Layout"><i class="fa fa-object-group"></i></a></th>
            </tr>
        </thead>
        <tbody>
            <cfif (len(attributes.formsubmited) || isDefined("attributes.selfwo") ) && query_event.recordCount>
                <cfoutput query="query_event">
                <tr>
                    <td>#currentrow#</td>
                    <td>#EVENT_TITLE#</td>
                    <td>#EVENT_FUSEACTION#</td>
                    <td>#EVENT_TYPE#</td>
                    <td>#EVENT_SOLUTION#</td>
                    <td>#EVENT_FAMILY#</td>
                    <td>#EVENT_VERSION#</td>
                    <td>
                        <cfif isDefined("attributes.selfwo")>
                            <a href="javascript:void(0)" onclick="AjaxPageLoad('#request.self#?fuseaction=dev.events&mode=add&fuseact=#attributes.fuseact#&id=#EVENTID#&woid=#attributes.woid#', 'objects')"><i class="fa fa-pencil"></i></a>
                        <cfelse>
                            <a href="#request.self#?fuseaction=dev.workdev&fuseact=#EVENT_FUSEACTION#">#EVENT_TITLE#</a>
                        </cfif>
                    </td>
                    <td>
                        <a href="#request.self#?fuseaction=dev.events&event=upd&fuseact=#EVENT_FUSEACTION#&event_type=#EVENT_TYPE#&version=#EVENT_VERSION#&id=#EVENTID#&woid=#attributes.woid#" title="Designer"><i class="fa fa-object-group"></i></a> 
                    </td>
                </tr>
                </cfoutput>
            <cfelseif len(attributes.formsubmited) && ! query_event.recordCount>
                <tr>
                    <td colspan="8">No record found !</td>
                </tr>
            <cfelse>
                <tr>
                    <td colspan="8"><cf_get_lang_main no='289.Filtre Ediniz '> !</td>
                </tr>
            </cfif>
        </tbody>
    </cf_flat_list>
    <cfif attributes.totalrecords gt attributes.maxrow>    
        <cfset adres="#request.self#?fuseaction=#attributes.fuseaction#&formsubmited=1">
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
        <cfif len(attributes.maxrow)>
            <cfset adres = "#adres#&maxrow=#attributes.maxrow#">
        </cfif>
        <cf_paging 
            page="#attributes.page#" 
            maxrows="#attributes.maxrow#" 
            totalrecords="#attributes.totalrecords#" 
            startrow="#attributes.startrow#" 
            isAjax="1"
            target="objects"
            adres="#adres#">
    </cfif>
</cf_box>
<script type="text/javascript">

    function searchComponents() {
        var serialized = $("#listEvents").serialize();
        AjaxPageLoad('<cfoutput>#request.self#?fuseaction=#attributes.fuseaction#</cfoutput>&event=list&'+serialized, 'objects');
        return false;
    }

    function goFormDetail(option, id) 
	{
		<cfif attributes.component eq 0>
		$("#workdevmenu li.workdevActive").attr('class', '');
		$("#workdevmenu li[title="+option+"]").attr('class', 'workdevActive');
		callPage(option, null, null, '&fuseact='+id);
		<cfelse>
		location.href = '<cfoutput>#request.self#?fuseaction=dev.workdev&fuseact=</cfoutput>' + id;
		</cfif>
	}
    
</script>