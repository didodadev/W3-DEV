<cfif isDefined('session.pp.userid')>
	<cfset url.event_id = Decrypt(url.event_id,session.pp.userid,"CFMX_COMPAT","Hex")>
	<cfset attributes.event_id = Decrypt(attributes.event_id,session.pp.userid,"CFMX_COMPAT","Hex")>
<cfelseif isDefined('session.ww.userid')>
	<cfset url.event_id = Decrypt(url.event_id,session.ww.userid,"CFMX_COMPAT","Hex")>
	<cfset attributes.event_id = Decrypt(attributes.event_id,session.ww.userid,"CFMX_COMPAT","Hex")>
</cfif>
<cfquery name="DSP_EVENT_" datasource="#DSN#">
	SELECT 
		EVENT_ID,
		STARTDATE,
		FINISHDATE,
		EVENT_HEAD,
		EVENT_DETAIL
	FROM 
		EVENT
	WHERE
		EVENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.event_id#">
</cfquery>
<table border="0" cellspacing="1" cellpadding="0" class="color-border" style="width:100%">
	<tr class="color-row">
    	<td>
            <table cellpadding="0" align="center" cellspacing="0" border="0" style="width:98%">
				<cfoutput>
                    <tr><td><br /></td></tr>
                    <tr>
                        <td class="form-title">#dateformat(dsp_event_.startdate,'dd/mm/yyyy')# - #timeformat(date_add('h',session_base.time_zone,dsp_event_.startdate),'HH:mm')# | #dateformat(dsp_event_.finishdate,'dd/mm/yyyy')# - #timeformat(date_add('h',session_base.time_zone,dsp_event_.finishdate),'HH:mm')#</td>
                    </tr>
                    <tr>
                        <td class="form-title"><br/>#dsp_event_.event_head#</td>
                    </tr>
                    <tr>
                        <td><br/>#dsp_event_.event_detail#</td>
                    </tr>
                    <tr><td><br /></td></tr>
                </cfoutput>
            </table>
	  	</td>
	</tr>
</table>
