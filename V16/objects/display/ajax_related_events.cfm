<cfsetting enablecfoutputonly="yes"><cfprocessingdirective suppresswhitespace="Yes">
<cfquery name="GET_RELATED_EVENTS" datasource="#DSN#">
	SELECT
		ER.EVENT_ID,
		ER.RELATED_ID,
		E.EVENT_HEAD,
		E.STARTDATE,
		ISNULL(ER.EVENT_TYPE,1) TYPE,
		'' EVENT_ROW_ID,
		EC.EVENTCAT
	FROM
		EVENTS_RELATED ER,
		EVENT E,
		EVENT_CAT EC
	WHERE
		E.EVENT_ID = ER.EVENT_ID AND	
		E.EVENTCAT_ID = EC.EVENTCAT_ID AND		
		ER.ACTION_SECTION = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ucase(attributes.action_section)#"> AND
		ER.ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_id#"> AND
		ISNULL(ER.EVENT_TYPE,1) = 1
	<cfif isdefined("attributes.company_id") and len(attributes.company_id)>
        AND ER.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
    </cfif>
	UNION ALL	
	SELECT
		ER.EVENT_ID,
		ER.RELATED_ID,
		E.EVENT_PLAN_HEAD EVENT_HEAD,
		EVENT_PLAN_ROW.START_DATE STARTDATE,
		ISNULL(ER.EVENT_TYPE,1) TYPE,
		ER.EVENT_ROW_ID,
		'' EVENTCAT
	FROM
		EVENTS_RELATED ER,
		EVENT_PLAN E,
		EVENT_PLAN_ROW
	WHERE
		E.EVENT_PLAN_ID = EVENT_PLAN_ROW.EVENT_PLAN_ID AND
		E.EVENT_PLAN_ID = ER.EVENT_ID AND	
		ER.ACTION_SECTION = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ucase(attributes.action_section)#"> AND
		ER.ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_id#"> AND
		ISNULL(ER.EVENT_TYPE,1) = 2
	<cfif isdefined("attributes.company_id") and len(attributes.company_id)>
        AND ER.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
    </cfif>	
	ORDER BY 
		E.STARTDATE DESC
</cfquery>
<cf_flat_list>
	<tbody>
		<cfif get_related_events.recordcount>
			<cfoutput query="get_related_events">
				<tr id="related_tr_#related_id#">
					<td>#DateFormat(startdate,dateformat_style)#-<cfif len(eventcat)>#eventcat#-</cfif>#event_head#</td>
					<td align="right" width="20">
						<cfif type eq 1>
							<a href="#request.self#?fuseaction=agenda.view_daily&event=popupUpd&event_id=#event_id#&action_id=#attributes.action_id#&action_section=#attributes.action_section#" target="_blank" ><i class="fa fa-pencil" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a> <!--- Guncelle --->
						<cfelse>
							<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_upd_event_plan_result&eventid=#event_id#&event_plan_row_id=#event_row_id#','page');"><i class="fa fa-pencil" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a>
						</cfif>
					</td>
					<div id="related_#related_id#" ></div>
					<td><a href="javascript://" onclick="AjaxPageLoad('#request.self#?fuseaction=objects.emptypopup_del_related_events&related_id=#related_id#','related_#related_id#'); gizle(related_tr_#related_id#);"><i class="fa fa-minus" alt="<cf_get_lang dictionary_id='57463.Sil'>" title="<cf_get_lang dictionary_id='57463.Sil'>"></i></a></td>
				</tr>
			</cfoutput>
		<cfelse>
			<cfoutput>
				<tr>
					<td colspan="3"><cf_get_lang dictionary_id='57484.Kayıt Yok'> !</td>
				</tr>
			</cfoutput>
		</cfif>
	</tbody>
</cf_flat_list>
</cfprocessingdirective><cfsetting enablecfoutputonly="no">
