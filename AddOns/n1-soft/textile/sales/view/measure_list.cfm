<cfparam name="attributes.req_id" default="">
<cfparam name="attributes.req_name" default="">
<cfparam name="attributes.pid" default="">
<cfobject name="measure" component="addons.n1-soft.textile.cfc.measure">
<cfif len(attributes.req_id) or isdefined("attributes.searched")>
<cfset measure_list = measure.get_measure_header_list( attributes.req_id )>
<cfset attributes.totalrecords = measure_list.recordcount>
<cfelse>
<cfset attributes.totalrecords = 0>
</cfif>
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfform action="#request.self#?fuseaction=#attributes.fuseaction#&event=#attributes.event#" method="post">
<input type="hidden" name="searched" value="1">
<cf_big_list_search title="ÖLÇÜ LİSTESİ">
    <cf_big_list_search_area>
        <div class="row form-inline">
            <div class="form-group">
                <div class="input-group">
                    <cfoutput>
                    <input type="hidden" name="req_id" id="req_id" value="<cfif len(attributes.req_id)>#attributes.req_id#</cfif>">
                    <input type="hidden" name="pid" id="pid" value="<cfif len(attributes.pid)>#attributes.pid#</cfif>">
                    <input type="text" name="req_name" id="req_name" placeholder="<cf_get_lang no=5>" value="<cfif len(attributes.req_name)>#attributes.req_name#</cfif>">
                    <span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('#request.self#?fuseaction=textile.popup_list_sample_request&field_id=req_id&field_text=req_name&field_pid=pid', 'list')"></span>
                    </cfoutput>
                </div>
            </div>
            <div class="form-group">
                <div>
                    <input type="text" name="maxrows" id="maxrows" value="<cfoutput>#attributes.maxrows#</cfoutput>">
                </div>
            </div>
            <div class="form-group">
                <div>
                    <button type="submit" class="btn green-haze">ARA</button>
                </div>
            </div>
            <cfif len(attributes.pid)>
            <div class="form-group">
                <div><cfoutput><a href="#request.self#?fuseaction=#attributes.fuseaction#&event=measure_form&req_id=#attributes.req_id#&pid=#attributes.pid#" class="btn grey-cascade btn-small icon-pluss margin-left-5"></a></cfoutput></div>
            </div>
            </cfif>
        </div>
    <cf_big_list_search_area>
</cf_big_list_search>
</cfform>
<cf_big_list>
    <thead>
        <tr>
            <th>Numune No</th>
            <th>Ölçü No</th>
            <th>Tarih</th>
            <th>En Oran&iota;</th>
            <th>Boy Oran&iota;</th>
            <th>&nbsp;</th>
        </tr>
    </thead>
    <tbody>
        <cfif attributes.totalrecords>
        <cfoutput query="measure_list" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
            <tr>
                <td>#REQ_NO#</td>
                <td>OT-#HEADER_ID#</td>
                <td>#dateformat( PROCDATE, dateformat_style )#</td>
                <td>#ERATE#</td>
                <td>#BRATE#</td>
                <td>
                    <a href="#request.self#?fuseaction=#attributes.fuseaction#&event=measure_form&req_id=#REQUEST_ID#&pid=#PRODUCT_ID#&mh_id=#HEADER_ID#"><i class="fa fa-edit"></i></a>
                </td>
            </tr>
        </cfoutput>
        <cfelse>
            <tr>
                <td>
            </tr>
        </cfif>
    </tbody>
</cf_big_list>
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