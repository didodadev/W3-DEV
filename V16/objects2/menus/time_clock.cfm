<cfif isdefined("session.ww")>
	<cfset saat  = date_add('h', session.ww.TIME_ZONE, Now())>
	<cfset tarih  = date_add('h', session.ww.TIME_ZONE, Now())>
<cfelseif isdefined("session.pp")>
	<cfset saat  = date_add('h', session.pp.TIME_ZONE, Now())>
	<cfset tarih  = date_add('h', session.pp.TIME_ZONE, Now())>
</cfif>
<table>
	<tr>
		<td><cfoutput>#dateformat(tarih,'dd/mm/yyyy')# - #Timeformat(saat,'HH:mm')#</cfoutput></td>
	</tr>
	<!--- <tr>
		<td align="center"><cfoutput><b>#Timeformat(saat,'HH:mm')#</b></cfoutput></td>
	</tr> --->
</table>
