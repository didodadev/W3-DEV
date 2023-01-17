<cfset attributes.to_day = CreateDate(year(now()),month(now()), day(now()))>
<cfset tarih = dateformat(attributes.to_day,'dd/mm/yyyy')>

<cfif isdefined('attributes.is_partner_event') and attributes.is_partner_event eq 1>
	<cfquery name="GET_PARTNERS" datasource="#DSN#">
		SELECT
			PARTNER_ID
		FROM
			COMPANY_PARTNER
		WHERE
			COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.company_id#">
	</cfquery>
</cfif>

<cfquery name="GET_DAILY_EVENTS" datasource="#DSN#">
	SELECT 
		EVENT_ID,
		STARTDATE,
		FINISHDATE,
		EVENTCAT,
		VALID,
		VALIDATOR_POSITION_CODE,
		EVENT.RECORD_EMP,
		EVENT.UPDATE_EMP,
		RECORD_PAR,
		UPDATE_PAR,
		EVENT_HEAD,
		EVENT_PLACE_ID,
		EVENT.IS_WIEW_DEPARTMENT,
		EVENT.IS_WIEW_BRANCH
	FROM 
		EVENT,
		EVENT_CAT
	WHERE
		EVENT.EVENTCAT_ID = EVENT_CAT.EVENTCAT_ID AND
		(
			( STARTDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.to_day#"> AND STARTDATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DATEADD('D',1,attributes.to_day)#">) OR
			( FINISHDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.to_day#"> AND FINISHDATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DATEADD('D',1,attributes.to_day)#">)
		) 
		<cfif isdefined('session.pp')>
			<cfif isdefined('attributes.is_partner_event') and attributes.is_partner_event eq 1>
				AND
				(
					EVENT.RECORD_PAR IN (#ValueList(get_partners.partner_id,',')#) OR
					EVENT.UPDATE_PAR IN (#ValueList(get_partners.partner_id,',')#)
					<cfloop query="get_partners">
						OR EVENT_TO_PAR LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#partner_id#,%"> 
						OR EVENT_CC_PAR LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#partner_id#,%">
					</cfloop>
				)
			<cfelse>
				AND 
				(
					EVENT.RECORD_PAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#"> OR
					EVENT.UPDATE_PAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#"> OR
					EVENT_TO_PAR LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#session.pp.userid#,%"> OR
					EVENT_CC_PAR LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#session.pp.userid#,%">
				)
			</cfif>
		<cfelseif isdefined('session.ww.userid')>
            AND 
            (
                EVENT.RECORD_PAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#"> OR
                EVENT.UPDATE_PAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#"> OR
                EVENT_TO_PAR LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#session.ww.userid#,%"> OR
                EVENT_TO_CON LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#session.ww.userid#,%"> OR
                EVENT_CC_PAR LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#session.ww.userid#,%">
            )
		</cfif>
</cfquery>


<table cellspacing="1" cellpadding="2" class="color-header" style="width:100%">
	<tr class="color-list" style="height:21px;">
		<td style="vertical-align:top">
			<table cellpadding="0" cellspacing="0" border="0" style="width:100%;">			  
				<tr>
					<td class="txtbold"><cfoutput>#tarih#</cfoutput></td>
					<td style="text-align:right; width:15px;"><a href="<cfoutput>#request.self#?fuseaction=objects2.form_add_event&date=#tarih#</cfoutput>" title="<cf_get_lang no ='1129.Ajandaya Olay Ekle'>"><img src="/images/plus_list.gif" border="0" alt="<cf_get_lang no ='1129.Ajandaya Olay Ekle'>"/></a></td>
				</tr>
			</table>
	  	</td>
	</tr>       
	<cfloop from="8" to="20" index="i">
		<tr class="color-row">
			<cfoutput>
				<td style="vertical-align:top;"> 
					<a href="#request.self#?fuseaction=objects2.form_add_event&date=#tarih#&hour=#i#">#i#.00</a>
					<cfif isdefined('session.pp')>
						<cfset attributes.hourstart=date_add('h',i-session.pp.time_zone,attributes.to_day)>
						<cfset attributes.hourfinish=date_add('h',i-session.pp.time_zone+1,attributes.to_day)>
					</cfif>
					<cfloop query="get_daily_events">
						<cfif ((get_daily_events.startdate gte attributes.hourstart) and (get_daily_events.startdate lt attributes.hourfinish)) or ((get_daily_events.finishdate gte attributes.hourstart) and (get_daily_events.finishdate lt attributes.hourfinish))>
							<a href="#request.self#?fuseaction=objects2.form_upd_event&event_id=#encrypt(event_id,session.pp.userid,"CFMX_COMPAT","Hex")#" class="tableyazi">#eventcat#-#event_head#</a>
							<cfif not len(get_daily_events.event_place_id)></cfif>
							<cfif get_daily_events.event_place_id eq 1><font color=red>(<cf_get_lang no='740.Ofis içi'>)</cfif>
							<cfif get_daily_events.event_place_id eq 2><font color=red>(<cf_get_lang no='741.Ofis Dışı'>)</cfif>
							<cfif get_daily_events.event_place_id eq 3><font color=red>(<cf_get_lang no='742.3 Parti Kurum'>)</cfif>
						</cfif>
					</cfloop>
				</td>
			</cfoutput> 
	  	</tr>
	</cfloop>
	<cfinclude template="../query/get_daily_warning.cfm">
	<cfset attributes.fromHome = true> 
	<cfif get_daily_warnings.recordcount >
		<tr class="color-list" style="height:22px;">
			<td class="txtboldblue"><img src="/images/listele.gif" alt="<cf_get_lang no='736.Günlük Uyarılar'>" title="<cf_get_lang no='736.Günlük Uyarılar'>" width="7" height="12" align="absmiddle"/><cf_get_lang no='736.Günlük Uyarılar'></td>
	  	</tr>
	  	<tr class="color-row">
			<td>
				<table cellpadding="0" cellspacing="0" border="0" style="width:100%;">
					<cfoutput query="get_daily_warnings">
					<tr>
						<td>*&nbsp;<a href="#request.self#?fuseaction=objects2.form_upd_event&event_id=#encrypt(event_id,session.pp.userid,"CFMX_COMPAT","Hex")#" class="tableyazi">#event_head#</a>
							<cfif not len(event_place_id)>
							<cfelseif event_place_id eq 1><font color=red>(<cf_get_lang no='740.Ofis içi'>)
							<cfelseif event_place_id eq 2><font color=red>(<cf_get_lang no='741.Ofis Dışı'>)
							<cfelseif event_place_id eq 3><font color=red>(<cf_get_lang no='742.3 Parti Kurum'>)
							</cfif>
						</td>
					 </tr>
					</cfoutput>
				</table>
			</td>
	  	</tr>
	</cfif>
</table>
