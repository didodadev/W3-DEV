<cfsetting showdebugoutput="no">
<cfset attributes.to_day = CreateDate(year(now()),month(now()), day(now()))>
<cfset warning_date = dateformat(attributes.to_day,dateformat_style)>
<cf_flat_list>
	<cfquery name="get_warnings" datasource="#dsn#">
		SELECT 
			URL_LINK,
					WARNING_HEAD,
					RECORD_DATE
		FROM 
			PAGE_WARNINGS AS WARNINGS
		WHERE
			POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#"> AND
			IS_ACTIVE = 1 AND
			LAST_RESPONSE_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.to_day#"> AND
			LAST_RESPONSE_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateAdd('d',1,attributes.to_day)#"> AND
			SETUP_WARNING_ID IS NULL
	</cfquery>
	<tbody>
		<cfif get_warnings.recordcount>
			<cfoutput query="get_warnings">
				<cfif find('.popup',url_link)><cfset is_popup=1><cfelse><cfset is_popup=0></cfif>
					<tr>
						<td width="75%"><a href="#user_domain##URL_LINK#" class="tableyazi">#warning_head#</a></td>
						<td width="25%">&nbsp;&nbsp;&nbsp;&nbsp;#dateformat(date_add("h",session.ep.time_zone,record_date),dateformat_style)# #timeformat(date_add("h",session.ep.time_zone,record_date),timeformat_style)#</td>												
					</tr>
				</cfoutput>
		<cfelse>
			<tr>
				<td><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</td>
			</tr>
		</cfif>
	</tbody>
</cf_flat_list>



