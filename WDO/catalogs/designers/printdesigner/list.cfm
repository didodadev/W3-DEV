<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.formsubmited" default="1">
<cfparam name="attributes.maxrow" default="#session.ep.maxrows#">
<cfparam name="attributes.totalrecords" default="0">
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.startrow" default="#(attributes.page-1)*(attributes.maxrow)#">
<cfparam name="attributes.type" default="">
<cfset list_wbo = createObject("component", "WDO.development.cfc.list_wbo")>
<cfinclude template="model.cfm">

<cfif len(attributes.formsubmited)>
    <cfscript>
        qparam = structNew();
        if (len(attributes.keyword)) {
            qparam.PRINT_HEAD = attributes.keyword;
            qparam.PRINT_FUSEACTION = attributes.keyword;
            qparam.PRINT_SYSNAME = attributes.keyword;
        }
        if (isDefined("attributes.solutionid")) {
            qparam.PRINT_SOLUTIONID = attributes.solutionid;
        }
        if (isDefined("attributes.familyid")) {
            qparam.FAMILIYID = attributes.familyid;
        }
        if (isDefined("attributes.moduleid")) {
            qparam.MODULEID = attributes.moduleid;
        }
    </cfscript>
    <cfset query_print = listPrint(argumentcollection=qparam)>
</cfif>

<form name="listPrints" id="listPrints" method="get">
    <input type="hidden" name="formsubmited" id="formsubmited" value="1">
    <cfoutput><input type="hidden" name="fuseact" id="fuseact" value="#attributes.fuseact#"></cfoutput>
    <cf_box>
        <cf_box_search more="0">
            <div class="form-group">
                <input type="text" name="keyword" id="keyword" value="<cfoutput>#attributes.keyword#</cfoutput>" placeholder="Keyword">
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
            <div class="form-group small" id="item-maxrows">
                <input type="text" name="maxrow" id="maxrow" value="<cfoutput>#attributes.maxrow#</cfoutput>">
            </div>
            <div class="form-group" id="item-submit">
                <a href="javascript://" class="ui-btn ui-btn-green" onclick="searchPrints()"><i class="fa fa-search"></i></a>
            </div>
            <div class="form-group">
                <cfoutput>
                    <a href="javascript://" class="ui-btn ui-btn-gray" onclick="AjaxPageLoad('#request.self#?fuseaction=dev.output&fuseact=#attributes.fuseact#&mode=form','objects')"><i class="fa fa-plus"></i></a>
                </cfoutput>
            </div>
        </cf_box_search>
    </cf_box>
</form>

<cf_box title="Ouputs">
    <cf_flat_list>
        <thead>
            <th>No</th>
            <th>Title</th>
            <th>Fuseaction</th>
            <th>Solution</th>
            <th>Family</th>
            <th width="20"><a href="javascript:void(0)" title="Form"><i class="fa fa-pencil"></i></a></th>
            <th width="20"><a href="javascript:void(0)" title="Layout"><i class="fa fa-object-group"></i></a></th>
        </thead>
        <tbody>
            <cfif len( attributes.formsubmited ) and query_print.recordCount>
            <cfoutput query="query_print">
            <tr>
                <td>#currentrow#</td>
                <td>#PRINT_HEAD#</td>
                <td>#PRINT_FUSEACTION#</td>
                <td>#PRINT_SOLUTION#</td>
                <td>#PRINT_FAMILY#</td>
                <td>
                    <a href="javascript:void(0)" onclick="AjaxPageLoad('#request.self#?fuseaction=dev.output&fuseact=#PRINT_FUSEACTION#&mode=form&id=#PRINTID#', 'objects')" title="Form"><i class="fa fa-pencil"></i></a>
                </td>
                <td>
                    <a href="javascript:void(0)" onclick="AjaxPageLoad('#request.self#?fuseaction=dev.output&fuseact=#PRINT_FUSEACTION#&mode=layout&id=#PRINTID#','objects')" title="Layout"><i class="fa fa-object-group"></i></a>
                </td>
            </tr>
            </cfoutput>
            <cfelseif len( attributes.formsubmited ) and not query_print.recordCount>
                <tr>
                    <td colspan="6">No record found!</td>
                </tr>
            <cfelse>
                <tr>
                    <td colspan="6"><cf_get_lang_main no="289.Filtre Ediniz"> !</td>
                </tr>
            </cfif>
        </tbody>
    </cf_flat_list>
    <cfif attributes.totalrecords gt attributes.maxrow>
        <cfset adres="#request.self#?fuseaction=#attributes.fuseaction#&type=#attributes.type#">
        <cfscript>
            if ( len( attributes.keyword ) ) {
                adres = "#adres#&keyword=#attributes.keyword#";
            }
            if ( isDefined( "attributes.solutionid" ) and len( attributes.solutionid ) ) {
                adres = "#adres#&solutionid=#attributes.solutionid#";
            }
            if ( isDefined( "attributes.familyid" ) and len( attributes.familyid ) ) {
                adres = "#adres#&familyid=#attributes.familyid#";
            }
            if ( isDefined( "attributes.moduleid" ) and len( attributes.moduleid ) ) {
                adres = "#adres#&moduleid=#attributes.moduleid#";
            }
            if ( len( attributes.maxrow ) ) {
                adres = "#adres#&maxrow=#attributes.maxrow#";
            }
        </cfscript>
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
    $(function() {

    });

    function searchPrints() {
        var serialized = $("#listPrints").serialize();
        AjaxPageLoad('<cfoutput>#request.self#?fuseaction=#attributes.fuseaction#&type=#attributes.type#</cfoutput>&'+serialized, 'objects');
    }

    function goFormDetail(option, id) 
	{
		$("#workdevmenu li.workdevActive").attr('class', '');
		$("#workdevmenu li[title="+option+"]").attr('class', 'workdevActive');
		callPage(option, null, null, '&fuseact='+id);
	}
    
</script>