<cfparam name="attributes.formsubmited" default="">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.maxrow" default="#session.ep.maxrows#">
<cfparam name="attributes.totalrecords" default="0">
<cfparam name="attributes.page" default="1">

<cfif len( attributes.formsubmited )>
    <cfscript>
        qparam = structNew();
    </cfscript>
    <cfset query_theme = list_theme(attributes.keyword)>
    <cfset attributes.totalrecords = query_theme.recordcount>
</cfif>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrow)+1>
<cf_box id="theme_search_area">
    <cfform name="listBP" id="listBP" action="#request.self#?fuseaction=dev.themes">
        <input type="hidden" name="formsubmited" id="formsubmited" value="1">
        <cf_box_search more="0">
            <div class="form-group mrgl">
                <input type="text" name="keyword" id="keyword" style="width:100px;" value="<cfoutput>#attributes.keyword#</cfoutput>" placeholder="<cf_get_lang_main no='48.Filtre'>" maxlength="255" onKeyDown="if(event.keyCode == 13) {searchComponents()}">
            </div>
            <div class="form-group small" id="item-maxrows">
                <input type="text" name="maxrow" id="maxrow" value="<cfoutput>#attributes.maxrow#</cfoutput>" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,999"  maxlength="3">
            </div>
            <div class="form-group">
                <cf_wrk_search_button button_type="4">
            </div>
            <div class="form-group">
                <cfoutput>
                    <a href="#request.self#?fuseaction=dev.themes&event=add" class="ui-btn ui-btn-gray"><i class="fa fa-plus"></i></a>
                </cfoutput>
            </div>
        </cf_box_search>
    </cfform>
</cf_box>
<cf_box title="Themes" id="bp_list" uidrop="1" hide_table_column="1">
    <cf_ajax_list>
        <thead>
            <tr>
                <th style="width: 60px;">No</th>
                <th>Name</th>
                <th style="width: 25%">Author</th>
                <th style="width: 20%">Product Code</th>
                <th width="20"><a href="<cfoutput>#request.self#?fuseaction=dev.themes&event=add&type=bp&mode=add</cfoutput>"><i class="fa fa-plus"></i></a></th>
            </tr>
        </thead>
        <tbody>
            <cfif len( attributes.formsubmited ) and isDefined( "query_theme" ) and query_theme.recordcount gt 0>
            <cfoutput query="query_theme"  startrow="#attributes.startrow#" maxrows="#attributes.maxrow#">
            <tr>
                <td>#currentrow#</td>
                <td>
                    <a href="#request.self#?fuseaction=dev.themes&event=upd&mode=upd&id=#THEME_ID#">#THEME_NAME#</a>
                </td>
                <td>#THEME_AUTHOR#</td>
                <td>#THEME_PRODUCT_CODE#</td>
                <td><a href="#request.self#?fuseaction=dev.themes&event=upd&mode=upd&id=#THEME_ID#"><i class="fa fa-pencil"></i></a></td>
            </tr>
            </cfoutput>
            <cfelse>
                <td colspan="14" class="color-row"><cfif len( attributes.formsubmited )><cf_get_lang_main no="72.Kayıt Yok"> !<cfelse><cf_get_lang_main no="289.Filtre Ediniz"> !</cfif></td>
            </cfif>
        </tbody>
    </cf_ajax_list>
    <cfif attributes.totalrecords gt attributes.maxrow>
        <cfset adres="dev.themes&formsubmited=1">
        <cfif len(attributes.maxrow)>
            <cfset adres = "#adres#&maxrow=#attributes.maxrow#">
        </cfif>
        <cf_paging 
            page="#attributes.page#" 
            maxrows="#attributes.maxrow#" 
            totalrecords="#attributes.totalrecords#" 
            startrow="#attributes.startrow#" 
            adres="#adres#">
    </cfif>
</cf_box>
<script type="text/javascript">
    function searchComponents() {
        var serialized = $("#listBP").serialize();
        AjaxPageLoad('<cfoutput>#request.self#?fuseaction=#attributes.fuseaction#&type=bp</cfoutput>&'+serialized, 'workDev-page-content');
    }
</script>