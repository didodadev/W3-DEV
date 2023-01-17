<cfsetting showdebugoutput="no">
<cfif not isdefined("attributes.CONTENT_ID")>
	<cfset attributes.CONTENT_ID = #attributes.cid#>
</cfif>
<cfquery name="getContentComment" datasource="#DSN#">
	SELECT 
		*
	FROM
		CONTENT_COMMENT
	WHERE
		CONTENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.CONTENT_ID#">
	ORDER BY
		RECORD_DATE DESC
</cfquery>
<table align="center" width="100%" cellpadding="2" cellspacing="1" border="0">
	<cfif getContentComment.RECORDCOUNT>
		<cfoutput query="getContentComment">
			<tr>
				<td>
				<table class="color-border" width="100%" cellpadding="2" cellspacing="1" border="0">
				<tr <cfif currentrow mod 2>class="color-list"<cfelse>class="color-row"</cfif>>
					<td valign="top">
						<table width="100%">
							<tr>
								<td><b>#name# #surname#</b> - #content_comment#</td>
							</tr>
							<cfif isdefined('session.pp.time_zone')>
								<tr>
									<td>#dateformat(date_add('h',session.pp.time_zone,record_date),'dd/mm/yyyy')#, #timeformat(date_add('h',session.pp.time_zone,record_date),'HH:mm')#</td>
								</tr>
							<cfelse>
								<tr>
									<td>#dateformat(date_add('h',session.ww.time_zone,record_date),'dd/mm/yyyy')#, #timeformat(date_add('h',session.ww.time_zone,record_date),'HH:mm')#</td>
								</tr>
							</cfif>
						</table>
					</td>
				 </tr>
			</table>
			</td>
		</tr>
		</cfoutput>
	</cfif>
</table>
<cfabort>
