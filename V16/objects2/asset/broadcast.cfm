<cfset to_day = CreateDate(year(now()),month(now()), day(now()))>
<cfquery name="get_broadcast_live" datasource="#dsn#">
	SELECT 
		* 
	FROM 
		BROADCAST_TV 
	WHERE 
		<cfif isdefined('attributes.broadcast_all') and attributes.broadcast_all eq 0>
			IS_LIVE = 1 AND 
		</cfif>
		BROADCAST_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#to_day#"> AND BROADCAST_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DATEADD('D',1,to_day)#">
	ORDER BY
		RECORD_DATE
</cfquery>
<table cellpadding="0" cellspacing="0" width="90%" align="center" border="0">
	<tr>
		<td><cfoutput>#dateformat(now(),'dd/mm/yyyy')#</cfoutput> >> <br /><hr style="height:0.1px; color:000000;" /></td>
	</tr>
	<cfif get_broadcast_live.recordcount>
		<cfoutput query="get_broadcast_live" maxrows="5">
			<tr>
				<td <cfif isdefined('attributes.broadcast_all') and attributes.broadcast_all eq 1 and is_live eq 1>style="color:DD5E27;"</cfif>>
					#left(start_time,5)# - #left(finish_time,5)#<br />#title#<br />
					<cfif get_broadcast_live.recordcount neq currentrow><hr style="height:0.1px; color:000000;" /></cfif>
				</td>
			</tr>
		</cfoutput>
		<cfif isdefined('attributes.broadcast_all') and attributes.broadcast_all eq 1>
			<tr height="35">
				<td>Tüm Akış >></td>
			</tr>
		</cfif>
	<cfelse>
		<tr>
			<td><cf_get_lang_main no='72.Kayıt Yok'>!</td>
		</tr>
	</cfif>
</table>

