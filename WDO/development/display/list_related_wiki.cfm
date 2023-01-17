<cfparam  name="attributes.wo_type" default="">
<cfparam  name="attributes.module_no" default="">
<cfparam  name="attributes.rel_wiki" default="">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.solution" default="">
<cfparam name="attributes.family" default="">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfset list_wbo = createObject("component", "WDO.development.cfc.list_wbo")>
<cfset getSolutions = list_wbo.getSolution()>
<cfparam name="attributes.lang" default="#session.ep.language#">
<cfset GET_LANGUAGE = createObject('component','V16.content.cfc.get_content').GET_LANGUAGE()>


<div id="div2">
    <cfform name="wiki_dev" action="#request.self#?fuseaction=dev.dsp_linked_wiki" method="post">
        <input type="hidden" name="is_form_submitted" id="is_form_submitted" value="1">
        <cf_box_search>
            <div class="form-group">
                <input type="text" name="keyword" id="keyword" style="width:100px;" value="<cfoutput>#attributes.keyword#</cfoutput>" placeholder="<cf_get_lang dictionary_id='57460.Filter'>" maxlength="255" onKeyDown="if(event.keyCode == 13) {searchButtonFunc()}">
            </div>
            <div class="form-group">
                <select id="solution" name="solution" onchange="loadFamilies(this.value,'family','module_no')">
                    <option value="">Solution</option>
                    <cfoutput query="getSolutions">
                        <option value="#WRK_SOLUTION_ID#"<cfif attributes.solution eq WRK_SOLUTION_ID>selected</cfif>>#NAME#</option>
                    </cfoutput>
                </select>
            </div>
            <div class="form-group">
                <select id="family" name="family" onchange="loadModules(this.value,'module_no')">
                    <option value="">Family</option>
                </select>
            </div>
            <div class="form-group">
                <select id="module_no" name="module_no">
                    <option value="">Module</option>
                </select>
            </div>
            <div class="form-group">
                <select id="wo_type" name="wo_type">
                    <option value=""><cf_get_lang dictionary_id='52735.Type'></option>
                    <option value="0" <cfif attributes.wo_type eq 0>selected</cfif>><cf_get_lang dictionary_id='52708.WBO'></option>
                    <option value="13" <cfif attributes.wo_type eq 13>selected</cfif>><cf_get_lang dictionary_id='63588.Dashboard'></option>
                    <option value="8" <cfif attributes.wo_type eq 8>selected</cfif>><cf_get_lang dictionary_id='52714.Report'></option>
                    <option value="9" <cfif attributes.wo_type eq 9>selected</cfif>><cf_get_lang dictionary_id='32470.General'></option>
                    <option value="1" <cfif attributes.wo_type eq 1>selected</cfif>><cf_get_lang dictionary_id='222.Param'></option>           
                    <option value="2" <cfif attributes.wo_type eq 2>selected</cfif>><cf_get_lang dictionary_id='47646.SYSTEM'></option>
                    <option value="3" <cfif attributes.wo_type eq 3>selected</cfif>><cf_get_lang dictionary_id='52718.Import'></option>
                    <option value="12" <cfif attributes.wo_type eq 12>selected</cfif>><cf_get_lang dictionary_id='59097.Export'></option>
                    <option value="4" <cfif attributes.wo_type eq 4>selected</cfif>><cf_get_lang dictionary_id='51459.Period'></option>
                    <option value="5" <cfif attributes.wo_type eq 5>selected</cfif>><cf_get_lang dictionary_id='62287.Maintenance'></option>
                    <option value="6" <cfif attributes.wo_type eq 6>selected</cfif>><cf_get_lang dictionary_id='60175.Utility'></option>
                    <option value="7" <cfif attributes.wo_type eq 7>selected</cfif>><cf_get_lang dictionary_id='47614.DEV'></option>
                    <option value="10" <cfif attributes.wo_type eq 10>selected</cfif>><cf_get_lang dictionary_id='61135.Child WO'></option>
                    <option value="11" <cfif attributes.wo_type eq 11>selected</cfif>><cf_get_lang dictionary_id='60688.Query-Backend'></option>
                    <option value="14" <cfif attributes.wo_type eq 14>selected</cfif>><cf_get_lang dictionary_id='46138.Output Template'></option>
                    <option value="15" <cfif attributes.wo_type eq 15>selected</cfif>><cf_get_lang dictionary_id='43246.Process'></option>
                </select>
            </div>
            <div class="form-group">
                <select id="rel_wiki" name="rel_wiki">
                    <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                    <option value="1" <cfif attributes.rel_wiki eq 1>selected</cfif>><cf_get_lang dictionary_id='46914.Linked'></option>
                    <option value="0" <cfif attributes.rel_wiki eq 0>selected</cfif>><cf_get_lang dictionary_id='41031.Unlinked'></option>

                </select>
            </div>
            <div class="form-group" id="div_lang" <cfif attributes.rel_wiki neq 1>style="display:none"</cfif>>
                <select id="lang" name="lang">
                    <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                    <cfoutput query="get_language">
                        <option value="#language_short#" <cfif attributes.lang eq language_short>selected="selected"</cfif>>#language_set#</option>
                    </cfoutput>
                </select>
            </div>
            <div class="form-group small">
                <cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Incorrect Record Number'></cfsavecontent>
                <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
            </div>
            <div class="form-group">
                <cf_wrk_search_button button_type="4" search_function="ajax_fucnt()">
            </div>
        </cf_box_search>
    </cfform>
   
    <cfif isdefined("attributes.is_form_submitted")>
        <cfset GET_RELATED_WIKI = createObject('component','WDO.development.cfc.wiki_development').get_related_wiki(
            wo_type: attributes.wo_type,
            lang : attributes.lang,
            rel_wiki : attributes.rel_wiki,
            module_no : attributes.module_no,
            keyword : attributes.keyword,
            solution : attributes.solution,
            family : attributes.family)>
    <cfelse>
        <cfset GET_RELATED_WIKI.recordcount = 0>
    </cfif>

    <cfparam name="attributes.totalrecords" default='#GET_RELATED_WIKI.recordcount#'>
    <cf_grid_list sort="1">
        <thead>
            <tr>
                <th width="20"><cf_get_lang dictionary_id='57487.No'></th>
                <th><cf_get_lang dictionary_id='55452.Modül'></th>
                <th><cf_get_lang dictionary_id='55063.Fuseaction'></th>
                <th><cf_get_lang dictionary_id='52831.Head'></th>
                <th><cf_get_lang dictionary_id='60721.Wiki'> - <cf_get_lang dictionary_id='65341.Meta'></th>
                <th width="20">&nbsp</th>
                <th width="20">&nbsp</th>
            </tr>
        </thead>
        <tbody>
            <cfif GET_RELATED_WIKI.recordcount>
                <cfoutput query="GET_RELATED_WIKI" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                    <tr>
                        <td>#currentrow#</td>
                        <td>#MODUL#</td>
                        <td>#FULL_FUSEACTION#</td>
                        <td>#head#</td>
                        <td>
                            <cfif len(GET_RELATED_WIKI.FULL_FUSEACTION)>
                                <cfquery name="get_action" datasource="#DSN#">
                                    SELECT
                                    C.CONTENT_ID CID
                                    FROM
                                        META_DESCRIPTIONS MD 
                                    LEFT JOIN CONTENT C ON C.CONTENT_ID= MD.ACTION_ID
                                    WHERE
                                    MD.META_DESC_HEAD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#GET_RELATED_WIKI.FULL_FUSEACTION#%">
                                        AND MD.ACTION_TYPE = <cfqueryparam cfsqltype="cf_sql_varchar" value="CONTENT_ID">
                                        <cfif len(attributes.lang)>
                                            AND MD.LANGUAGE_SHORT = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.lang#">
                                        </cfif>
                                    GROUP BY C.CONTENT_ID
                                    ORDER BY C.CONTENT_ID
                                </cfquery>
                            </cfif>
                            <cfset counter= 0>
                            <cfif get_action.recordCount>
                                <cfloop query="get_action">
                                    <cfset counter++>
                                    <a href="#request.self#?fuseaction=content.list_content&event=det&cntid=#CID#">#CID#</a><cfif counter lt get_action.recordCount>,</cfif>
                                </cfloop>
                            </cfif>
                        </td>
                        <td class="text-center"><a href="#request.self#?fuseaction=content.list_content&meta_head=#FULL_FUSEACTION#&form_submitted=1"<i class="fa fa-file-text-o"></i></a></td>
                        <td class="text-center"><a href="#request.self#?fuseaction=help.wiki&keyword=#FULL_FUSEACTION#&form_submitted=1"><i class="fa fa-wikipedia-w"></i></a></td>
                    </tr>
                </cfoutput>
            </cfif>
        </tbody>
    </cf_grid_list>
    <cfif GET_RELATED_WIKI.recordcount eq 0>
        <div class="ui-info-bottom">
            <p><cfif isDefined('is_form_submitted') and is_form_submitted eq 1><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'> !<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz '> !</cfif></p>
        </div>
    </cfif>
    <cfif attributes.totalrecords gt attributes.maxrows>   
        <cfscript>
            url_string = '';
            if (isdefined('attributes.wo_type')) url_string = '#url_string#&wo_type=#attributes.wo_type#';
            if (isdefined('attributes.module_no')) url_string = '#url_string#&module_no=#attributes.module_no#';
            if (isdefined('attributes.solution')) url_string = '#url_string#&solution=#attributes.solution#';
            if (isdefined('attributes.family')) url_string = '#url_string#&family=#attributes.family#';
            if (isdefined('attributes.lang')) url_string = '#url_string#&lang=#attributes.lang#';
            if (isdefined('attributes.rel_wiki')) url_string = '#url_string#&rel_wiki=#attributes.rel_wiki#';
            if (isdefined('attributes.keyword')) url_string = '#url_string#&keyword=#attributes.keyword#';
            if (isdefined('attributes.is_form_submitted')) url_string = '#url_string#&is_form_submitted=1';
        </cfscript>
        <cf_paging
        page="#attributes.page#" 
        maxrows="#attributes.maxrows#"
        totalrecords="#attributes.totalrecords#"
        startrow="#attributes.startrow#"
        adres="dev.dsp_linked_wiki&#url_string#"
        target="body_div1"
        isAjax="1">
    </cfif>
</div>
<script>
$("#rel_wiki").change(function() {
    if($("#rel_wiki").val() == 1){
        $("#div_lang").show();
    }
    else  $("#div_lang").hide();
})


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
function ajax_fucnt()
{
    md=$('#wo_type').val();
    lg= $('#lang').val();
    rel=$('#rel_wiki').val();
    ky=$('#keyword').val();
    mr=$('#maxrows').val();
    mdn=$('#module_no').val();
    sol = $('#solution').val();
    fam = $('#family').val();
    AjaxPageLoad('<cfoutput>#request.self#?fuseaction=dev.dsp_linked_wiki&wo_type='+ md +'&rel_wiki='+ rel +'&lang='+ lg +'&keyword='+ ky +'&maxrows='+ mr +'&module_no='+ mdn +'&solution='+ sol +'&family='+ fam +'&is_form_submitted=1</cfoutput>' ,'div2');
    return false;	
}

$(function(){
<cfif len(attributes.SOLUTION)>
    loadFamilies('<cfoutput>#attributes.SOLUTION#</cfoutput>','family','module_no','<cfoutput>#attributes.family#</cfoutput>');
</cfif>
<cfif len(attributes.family)>
    loadModules('<cfoutput>#attributes.family#</cfoutput>','module_no','<cfoutput>#attributes.module_no#</cfoutput>');
</cfif>
});
</script>