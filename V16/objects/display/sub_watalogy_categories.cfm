<cfparam name="attributes.keywords" default="">
<cfparam name="attributes.form_submitted" default="">
<cfparam name="attributes.fuseaction" default="objects.popup_watalogy_category_names">
<cfif isdefined("attributes.form_submitted")>
    <cfset cmp = createObject("component","V16/settings/cfc/watalogyControl")>
    <cfset get_categories = cmp.getCategories(keyword:attributes.keywords,hierarchy:attributes.id)>
</cfif>
<cfparam name="attributes.modal_id" default="">


<cfset url_string = "">
<cfif isdefined("attributes.field_name") and len(attributes.field_name)>
	<cfset url_string = "#url_string#&field_name=#attributes.field_name#">
</cfif>
<cfif isdefined("attributes.field_id") and len(attributes.field_id)>
	<cfset url_string = "#url_string#&field_id=#attributes.field_id#">
</cfif>
<cfif isdefined("attributes.form_submitted")>
    <cfset url_string = "#url_string#&form_submitted=#attributes.form_submitted#">
</cfif>
<div>   
    <cfform name="search#attributes.hierarchy#" id="search#attributes.hierarchy#" method="post" action="V16/objects/display/sub_watalogy_categories.cfm?#url_string#">
        <input type="hidden" name="form_submitted" id="form_submitted" value="1">
        <cfinput type="hidden" name="hierarchy" id="hierarchy" value="#attributes.hierarchy#">
        <cfinput type="hidden" name="id" id="id" value="#attributes.id#">
        <cf_box_search more="0">
            <div class="form-group">
                <cfsavecontent variable="message1"><cf_get_lang dictionary_id='57460.Filtre'></cfsavecontent>
                <cfinput type="text" name="keywords" placeholder="#message1#" value="#attributes.keywords#">
            </div>
            <div class="form-group">
                <cf_wrk_search_button button_type="4" search_function="ara(#attributes.hierarchy#,'#attributes.id#')">
            </div>
        </cf_box_search>
    </cfform>
    <cf_grid_list uiscroll="0">
        <tbody>
            <cfif get_categories.recordcount>
                <cfoutput query="get_categories">
                    <cfset getsubHierarchy = cmp.getCategories(hierarchy:HIERARCHY)>
                    <cfif ListLen(HIERARCHY,'.') eq attributes.hierarchy>
                        <tr id="row#GOOGLE_PRODUCT_CAT_ID#">
                            <td><a href="javascript://" <cfif getsubHierarchy.recordcount eq 0 or(isDefined("x_is_sub_main") and x_is_sub_main eq 1)>onClick="gonder(#GOOGLE_PRODUCT_CAT_ID#,'#TOP_CATEGORY_NAME#','#HIERARCHY#')"<cfelse>style="color:##555"</cfif>>#TOP_CATEGORY_NAME#</a> <cfif getsubHierarchy.recordcount gt 0>  <a href="javascript://" onClick="openSub('#HIERARCHY#',#attributes.hierarchy#,#GOOGLE_PRODUCT_CAT_ID#)" class="pull-right"><i class="fa fa-chevron-right"></i></a></cfif></td>
                        </tr>
                    <cfelseif ListLen(HIERARCHY,'.') eq attributes.hierarchy>
                        <tr>
                            <td><a href="javascript://" onClick="gonder(#GOOGLE_PRODUCT_CAT_ID#,'#TOP_CATEGORY_NAME#','#HIERARCHY#')">#TOP_CATEGORY_NAME#</a></td>
                        </tr>
                    </cfif>
                </cfoutput>    
            <cfelse>
                <tr><td><cf_get_lang dictionary_id='57484.No record'></td></tr>
            </cfif>       
        </tbody>
    </cf_grid_list>
    
</div>
<script type="text/javascript">
    $("#keywords").focus();
    function gonder(cat_id,cat_name,hierarchy){
        <cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_id#</cfoutput>.value = cat_id;
        <cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_name#</cfoutput>.value = hierarchy+' ' +cat_name; 
        closeBoxDraggable(<cfoutput>#attributes.modal_id#</cfoutput>);           
    }
    function openSub(id,hierarchy,row){
   
        $('tr[id*=row]').css("background-color","#fff");
        $('#row'+row).css("background-color","#ececda");
        for (let index = hierarchy+1; index < 8; index++)
            $('#category'+index).remove();
        $('#category'+hierarchy).after('<div class="col col-3 col-md-3 col-sm-3 col-xs-12 ui-scroll margin-top-20 margin-bottom-20" style="height:300px;overflow:scroll" id="category'+parseInt(hierarchy+1)+'"></div>');
        AjaxPageLoad('<cfoutput>V16/objects/display/sub_watalogy_categories.cfm?draggable=1&modal_id=#attributes.modal_id#&field_id=#attributes.field_id#&field_name=#attributes.field_name#</cfoutput>&hierarchy='+parseInt(hierarchy+1)+'&id='+id,'category'+parseInt(hierarchy+1));
    }
    function ara(hierarchy,id){
        <cfoutput>
            AjaxPageLoad('V16/objects/display/sub_watalogy_categories.cfm?draggable=&modal_id=#attributes.modal_id#&field_id=#attributes.field_id#&field_name=#attributes.field_name#&hierarchy='+hierarchy+'&id='+id+'&keywords='+$('##category'+hierarchy+' ##keywords').val(),'category'+hierarchy);
        </cfoutput>
        for (let index = hierarchy+1; index < 8; index++)
            $('#category'+index).remove();            
        return false;
    }
</script>