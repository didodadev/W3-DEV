<cfparam name="attributes.fuseact" default="">
<cfset getObj = CreateObject("component","cfc.system")>
<cfset widgets = getObj.GET_WIDGETS(fuseaction: attributes.fuseact)>
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
        <cfif widgets.recordcount>
            <cfoutput query="widgets">
                <tr>
                    <td>#WIDGETID#</td>
                    <td>#WIDGET_TITLE#</td>
                    <td>#WIDGET_EVENT_TYPE#</td>
                    <td>#WIDGET_VERSION#</td>
                </tr>
            </cfoutput>
        <cfelse>
            <tr><td colspan="4"><cf_get_lang dictionary_id='57484.No record'>!</td></tr>
        </cfif>
    </tbody>
</cf_flat_list>