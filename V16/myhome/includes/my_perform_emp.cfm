<cfset attributes.to_day = CreateDate(year(now()),month(now()), day(now()))>
<cfset warning_date = dateformat(attributes.to_day,dateformat_style)>
<table width="98%" border="0" cellspacing="1" cellpadding="2" class="color-border" align="center">
	<tr class="color-list" height="22"> 
		<td class="txtboldblue">
			<a href="javascript://" onclick="gizle_goster_img('list_performp_img1','list_performp_img2','list_performp_menu');"><img src="/images/listele_down.gif" title="<cf_get_lang no='116.Ayrıntıları Gizle'>"  border="0" align="absmiddle" id="list_performp_img1" style="display:;cursor:pointer;"></a>
			<a href="javascript://" onclick="gizle_goster_img('list_performp_img1','list_performp_img2','list_performp_menu');"><img src="/images/listele.gif" title="<cf_get_lang no='337.Ayrıntıları Göster'>" border="0" align="absmiddle" id="list_performp_img2" style="display:none;cursor:pointer;"></a>
			Deneme Süresi Bitenler
		</td>
	</tr>
	<tr class="color-row" id="list_performp_menu">
		<td>
		<table cellspacing="0" cellpadding="0" width="100%" border="0">
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
			<cfif get_warnings.recordcount>
				<cfoutput query="get_warnings">
					<cfif find('.popup',url_link)><cfset is_popup=1><cfelse><cfset is_popup=0></cfif>
					<tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
						<td align="left" width="75%"><a href="#user_domain##URL_LINK#" class="tableyazi">#warning_head#</a></td>
						<td width="25%">&nbsp;&nbsp;&nbsp;&nbsp;#dateformat(date_add("h",session.ep.time_zone,record_date),dateformat_style)# #timeformat(date_add("h",session.ep.time_zone,record_date),timeformat_style)#</td>												
					</tr>
				</cfoutput>
			<cfelse>
				<tr>
					<td><cf_get_lang_main no='72.Kayıt Yok'>!</td>
				</tr>
			</cfif>
		</table>
		</td>
	</tr>
</table>
<br/>
