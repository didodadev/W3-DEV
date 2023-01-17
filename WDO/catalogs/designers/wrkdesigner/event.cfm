<cfparam name="attributes.fuseact" default="">
<cfset getObj = CreateObject("component","cfc.system")>
<cfset events = getObj.GET_EVENTS(fuseaction: attributes.fuseact)>
<cf_flat_list>
    <thead>
        <tr>
            <th width="20">#</th>
            <th>Title</th>
            <th>Event</th>
            <th>Version</th>
        </tr>
    </thead>
    <tbody>
        <cfif events.recordcount>
            <cfoutput query="events">
                <tr>
                    <td>#EVENTID#</td>
                    <td>#EVENT_TITLE#</td>
                    <td>#EVENT_TYPE#</td>
                    <td>#EVENT_VERSION#</td>
                </tr>
            </cfoutput>
        <cfelse>
            <tr><td colspan="4"><cf_get_lang dictionary_id='57484.No record'>!</td></tr>
        </cfif>
    </tbody>
</cf_flat_list>
