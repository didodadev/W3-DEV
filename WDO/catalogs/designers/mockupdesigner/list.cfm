<cfparam name="attributes.is_form_submitted" default="0">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.maxrow" default="#session.ep.maxrows#">
<cfparam name="attributes.totalrecords" default="0">
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.startrow" default="#((attributes.page-1)*attributes.maxrow)+1#">

<cfif attributes.is_form_submitted eq 1>
    <cfset getMockup = model.get( 
        keyword: attributes.keyword,
        startrow: attributes.startrow,
        maxrow: attributes.maxrow
    ) />
    <cfset attributes.totalrecords = getMockup.recordcount ? getMockup.QUERY_COUNT : 0>
</cfif>

<cf_box id="mockup_search_area">
    <cfform name="list_mockup" id="list_mockup" action="#request.self#?fuseaction=dev.mockup">
        <input type="hidden" name="is_form_submitted" id="is_form_submitted" value="1">
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
                <a href="<cfoutput>#request.self#?fuseaction=dev.mockup&event=add</cfoutput>" class="ui-btn ui-btn-gray"><i class="fa fa-plus"></i></a>
            </div>
        </cf_box_search>
    </cfform>
</cf_box>
<cf_box title="Mockup" id="mockup_list" uidrop="1" hide_table_column="1">
    <cf_ajax_list>
        <thead>
            <tr>
                <th style="width: 60px;">No</th>
                <th>Mockup Name</th>
                <th style="width: 25%">Author</th>
                <th style="width: 25%">Relation Work</th>
                <th style="width: 25%">Relation Qpic-RS</th>
                <th class="text-right"><i class="fa fa-eye"></i></th>
                <th class="text-right"><i class="fa fa-pencil"></i></th>
            </tr>
        </thead>
        <tbody>
            <cfif attributes.is_form_submitted eq 1 and isDefined( "getMockup" ) and getMockup.recordcount gt 0>
                <cfoutput query="getMockup"  startrow="#attributes.startrow#" maxrows="#attributes.maxrow#">
                <tr>
                    <td>#currentrow#</td>
                    <td><a href="#request.self#?fuseaction=dev.mockup&event=upd&id=#MOCKUP_ID##len(WORK_ID) ? 'work_id=#WORK_ID#' : ''#">#MOCKUP_NAME#</a></td>
                    <td>#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#</td>
                    <td>#WORK_HEAD#</td>
                    <td></td>
                    <td class="text-right"><a href="#request.self#?fuseaction=dev.mockup&event=det&id=#MOCKUP_ID##len(WORK_ID) ? '&work_id=#WORK_ID#' : ''#"><i class="fa fa-eye"></i></a></td>
                    <td class="text-right"><a href="#request.self#?fuseaction=dev.mockup&event=upd&id=#MOCKUP_ID##len(WORK_ID) ? '&work_id=#WORK_ID#' : ''#"><i class="fa fa-pencil"></i></a></td>
                </tr>
                </cfoutput>
            <cfelse>
                <td colspan="7" class="color-row"><cfif attributes.is_form_submitted eq 1><cf_get_lang_main no="72.Kayıt Yok"> !<cfelse><cf_get_lang_main no="289.Filtre Ediniz"> !</cfif></td>
            </cfif>
        </tbody>
    </cf_ajax_list>
    <cfif attributes.totalrecords gt attributes.maxrow>
        <cfset adres="dev.mockup&is_form_submitted=1">
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