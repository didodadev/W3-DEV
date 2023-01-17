<cfsetting showdebugoutput="no">
<cfquery name="get_cont_body" datasource="#dsn#">
	SELECT CONT_SUMMARY,CONT_BODY,IS_DSP_SUMMARY FROM CONTENT WHERE CONTENT_ID = '#URL.content_id#'
</cfquery>
<cfoutput>
<table>
	<cfif get_cont_body.IS_DSP_SUMMARY eq 0>
	<tr>
		<td class="txtbold">#get_cont_body.CONT_SUMMARY#<br/><br/></td>
	</tr>
	</cfif>
	<tr>
		<td>#get_cont_body.CONT_BODY#</td>
	</tr>
</table>
</cfoutput>