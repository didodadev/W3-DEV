<cfparam name="attributes.req_id" default="">
<cfparam name="attributes.req_name" default="">
<cfparam name="attributes.pid" default="">
<cfobject name="measure" component="WBP.Fashion.files.cfc.measure">
<cfif len(attributes.req_id) or isdefined("attributes.searched")>
<cfset measure_list = measure.get_measure_header_list( attributes.req_id )>
<cfset attributes.totalrecords = measure_list.recordcount>
<cfelse>
<cfset attributes.totalrecords = 0>
</cfif>
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cf_box scroll="0">
    <cfform action="#request.self#?fuseaction=#attributes.fuseaction#&event=#attributes.event?:'list'#" method="post">
        <input type="hidden" name="searched" value="1">
        <cf_box_search>
            <div class="form-group">
                <div class="input-group">
                    <cfoutput>
                    <input type="hidden" name="req_id" id="req_id" value="<cfif len(attributes.req_id)>#attributes.req_id#</cfif>">
                    <input type="hidden" name="pid" id="pid" value="<cfif len(attributes.pid)>#attributes.pid#</cfif>">
                    <input type="text" name="req_name" id="req_name" placeholder="Numune" value="<cfif len(attributes.req_name)>#attributes.req_name#</cfif>">
                    <span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('#request.self#?fuseaction=textile.popup_list_sample_request&field_id=req_id&field_text=req_name&field_pid=pid', 'list')"></span>
                    </cfoutput>
                </div>
            </div>
            <div class="form-group small">
                <div>
                    <input type="text" name="maxrows" id="maxrows" value="<cfoutput>#attributes.maxrows#</cfoutput>">
                </div>
            </div>
            <div class="form-group">
                <div>
                    <cf_wrk_search_button button_type="4">
                </div>
            </div>
            <cfif len(attributes.pid)> 
                <div class="form-group">
                    <cfoutput><a href="#request.self#?fuseaction=textile.measurement&event=upd&req_id=#attributes.req_id#&pid=#attributes.pid#" class="ui-btn ui-btn-gray"><i class="fa fa-plus"></i></a></cfoutput>
                </div>
            </cfif>
        </cf_box_search>
    </cfform>
</cf_box>
<cfsavecontent  variable="message"><cf_get_lang dictionary_id='62630.Ölçü Tablosu'>
</cfsavecontent>
<cf_box title="#message#" uidrop="1">
<cf_grid_list>
    <thead>
        <tr>
            <th><cf_get_lang dictionary_id='62568.Numune No'></th>
            <th><cf_get_lang dictionary_id='57686.Ölçü'><cf_get_lang dictionary_id='57487.No'></th>
            <th><cf_get_lang dictionary_id='62718.Çekme T.Grup'></th>
            <th><cf_get_lang dictionary_id='57742.Tarih'></th>
            <th><cf_get_lang dictionary_id='62719.En Oran'>&iota;</th>
            <th><cf_get_lang dictionary_id='62720.Boy Oran'>&iota;</th>
            <th>&nbsp;</th>
            <th>&nbsp;</th>
        </tr>
    </thead>
    <tbody>
        <cfif attributes.totalrecords>
        <cfoutput query="measure_list" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
            <tr>
                <td>#REQ_NO#</td>
                <td>OT-#HEADER_ID#</td>
                <td>#STRETCHING_GROUP#</td>
                <td>#dateformat( PROCDATE, dateformat_style )#</td>
                <td>#ERATE#</td>
                <td>#BRATE#</td>
                <td>
                    <!-- sil -->
                    <a href="#request.self#?fuseaction=textile.measurement&event=upd&req_id=#REQUEST_ID#&pid=#PRODUCT_ID#&mh_id=#HEADER_ID#"><i class="fa fa-edit"></i></a>
                    <!-- sil -->
                </td>
                <td>
                    <!-- sil -->
                    <a href="javascript://" onclick="windowopen('index.cfm?fuseaction=objects.popup_print_files&iid=#REQUEST_ID#&print_type=500&iiid=#HEADER_ID#','page')"><i class="icon-print"></i></a>
                    <!-- sil -->
                </td>
            </tr>
        </cfoutput>
        <cfelse>
            <tr>
                <td colspan="8"></td>
            </tr>
        </cfif>
    </tbody>
</cf_grid_list>
<table width="98%" align="center" height="35" cellpadding="0" cellspacing="0">
    <tr>
        <td colspan="3">
            <cfscript>
                str_url = "&searched=1";
                if (len(attributes.req_id)) str_url = "#str_url#&req_id=#attributes.req_id#";
                if (len(attributes.req_name)) str_url = "#str_url#&req_name=#attributes.req_name#";
                if (len(attributes.pid)) str_url = "#str_url#&pid=#attributes.pid#";
            </cfscript>
            <cf_paging page="#attributes.page#"
                maxrows="#attributes.maxrows#"
                totalrecords="#attributes.totalrecords#"
                startrow="#attributes.startrow#"
                adres="textile.stretching_test&event=measure_list#str_url#">
        </td>
    </tr>
</table>
</cf_box>