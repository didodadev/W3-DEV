<cfquery name="GET_RELATED_EVENTS" datasource="#DSN#">
	SELECT
		RE.*,
		E.STARTDATE,
		E.EVENT_HEAD
	FROM
		EVENTS_RELATED RE,
		EVENT E
	WHERE
		E.EVENT_ID = RE.EVENT_ID AND		
		RE.ACTION_SECTION = 'PROJECT_ID' AND
		RE.ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
	  	<cfif isdefined("attributes.company_id") and len(attributes.company_id)>
			AND RE.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
	  	</cfif>	
	ORDER BY 
		E.STARTDATE DESC
</cfquery>

<table cellSpacing="0" cellpadding="0" style="width:98%;">
  	<tr class="color-border">
		<td>
			<table cellspacing="1" cellpadding="2" style="width:100%;">
                <tr class="color-header" style="height:22px;">
                    <cfoutput>
                    <td class="form-title" style="width:90%;"><cf_get_lang_main no='581.İlişkili Olaylar'></td>
                    <td  style="text-align:right;">
                        <a href="#request.self#?fuseaction=objects2.form_add_event&action_id=#attributes.project_id#&action_section=PROJECT_ID"><img src="/images/plus_square.gif" title="İlişkili Olay Ekle" border="0"></a>
                    </td>
                    </cfoutput>
                </tr>
                <cfoutput query="get_related_events">
                    <tr class="color-row" style="height:20px;">
                        <td>#DateFormat(startdate,'dd/mm/yyyy')#- #Left(event_head,25)#<cfif len(event_head) gt 25>..</cfif> </td>
                        <td  style="text-align:right;">
                        <a href="#request.self#?fuseaction=objects2.form_upd_event&event_id=#encrypt(event_id,session.pp.userid,"CFMX_COMPAT","Hex")#&action_id=#attributes.project_id#&action_section=PROJECT_ID;"><img src="/images/update_list.gif" border="0"  align="absmiddle"></a>
                        </td>
                    </tr>
                </cfoutput>
                <cfif not get_related_events.recordcount>
                    <tr class="color-row" style="height:22px;">
                        <td colspan="2"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</td>
                    </tr>		
                </cfif>
			</table>
		</td>
  	</tr>
</table>
