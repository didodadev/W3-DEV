<cfquery name="GET_RELATED_EVENTS" datasource="#DSN#">
	SELECT
		RE.EVENT_ID,
		E.EVENT_HEAD,
        E.STARTDATE
	FROM
		EVENTS_RELATED RE,
		EVENT E
	WHERE
		E.EVENT_ID = RE.EVENT_ID AND		
		RE.ACTION_SECTION = 'OPPORTUNITY_ID' AND
		RE.ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.opp_id#">
		<cfif isdefined("attributes.company_id") and len(attributes.company_id)>
			AND RE.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
		 </cfif>	
	ORDER BY 
		E.STARTDATE DESC
</cfquery>
<table cellspacing="1" cellpadding="2" border="0" style="width:100%;">
    <cfoutput query="get_related_events">
        <tr class="color-row" style="height:20px;">
            <td>
				#DateFormat(startdate,'DD/MM/YYY')#<br>
				<a href="#request.self#?fuseaction=objects2.form_upd_event&event_id=#encrypt(event_id,session.pp.userid,"CFMX_COMPAT","Hex")#&action_id=#attributes.opp_id#&action_section=OPP_ID;">#Left(event_head,35)#<cfif len(event_head) gt 35>..</cfif></a>
            </td>
        </tr>
    </cfoutput>
    <cfif not get_related_events.recordcount>
        <tr class="color-row" style="height:22px;">
            <td colspan="2"><cf_get_lang_main no='72.Kayit Bulunamadi'>!</td>
        </tr>		
    </cfif>
</table>

