<cfquery name="GET_REMAINDER" datasource="#DSN2#">
	SELECT
		*
	FROM
		COMPANY_REMAINDER
	WHERE
		COMPANY_REMAINDER.COMPANY_ID = #attributes.company_id#
</cfquery>
<cfif get_remainder.recordcount>
	<cfset borc = get_remainder.borc>
	<cfset alacak = get_remainder.alacak>
	<cfset bakiye = get_remainder.bakiye>
	<cfif len(get_remainder.borc2)><cfset borc2 = get_remainder.borc2><cfelse><cfset borc2 = 0></cfif>
	<cfif len(get_remainder.alacak2)><cfset alacak2 = get_remainder.alacak2><cfelse><cfset alacak2 = 0></cfif>
<cfelse>
	<cfset borc = 0>
	<cfset alacak = 0>
	<cfset bakiye = 0>
	<cfset borc2 = 0>
	<cfset alacak2 = 0>
</cfif>
<table>
	<tr class="txtbold">
		<td><cf_get_lang dictionary_id ='57866.Borç Alacak Durumu'></td>
		<td height="25" style="text-align:right;">(<cfoutput>#session.ep.money#</cfoutput>)</td>
		<td width="15" rowspan="4"></td>
		<td style="text-align:right;">(<cfoutput>#session.ep.money2#</cfoutput>)</td>
	</tr>
	<tr>
		<td class="txtbold" width="125"><cf_get_lang dictionary_id ='57587.Borç'></td>
		<td width="110" style="text-align:right;"><cfoutput>#TLFormat(ABS(borc))# #session.ep.money#</cfoutput></td>
		<td width="110" style="text-align:right;"><cfoutput>#TLFormat(ABS(borc2))# #session.ep.money2#</cfoutput></td>
	</tr>
	<tr>
		<td class="txtbold"><cf_get_lang dictionary_id ='57588.Alacak'></td>
		<td style="text-align:right;"><cfoutput>#TLFormat(ABS(alacak))# #session.ep.money#</cfoutput></td>
		<td style="text-align:right;"><cfoutput>#TLFormat(ABS(alacak2))# #session.ep.money2#</cfoutput></td>
	</tr>
	<tr>
		<td class="txtbold"><font color="FF0000"><cf_get_lang dictionary_id ='57589.Bakiye'></font></td>
		<td nowrap="nowrap" class="txtbold" style="text-align:right;"><font color="FF0000"><cfoutput>#TLFormat(ABS(bakiye))# #session.ep.money#</cfoutput> <cfif borc gte alacak>(B)<cfelse>(A)</cfif></font></font></td>
		<td nowrap="nowrap" class="txtbold" style="text-align:right;"><font color="FF0000"><cfoutput>#TLFormat((ABS(alacak2))-(ABS(borc2)))# #session.ep.money2#</cfoutput> <cfif borc gte alacak>(B)<cfelse>(A)</cfif></font></font></td>
	</tr>
</table>
