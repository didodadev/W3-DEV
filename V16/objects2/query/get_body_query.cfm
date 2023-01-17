<cfsetting showdebugoutput="no">
<cfquery name="get_cont_body" datasource="#dsn#">
	SELECT CONT_SUMMARY,CONT_BODY,IS_DSP_SUMMARY FROM CONTENT WHERE CONTENT_ID = #url.content_id#
</cfquery>
<cfoutput>
<table>
	<cfif get_cont_body.IS_DSP_SUMMARY eq 0 and len(get_cont_body.CONT_SUMMARY)>
	<tr>
		<td class="txtbold">#get_cont_body.CONT_SUMMARY#<br/><br/></td>
	</tr>
	</cfif>	
	<cfif isdefined('attributes.is_body') and attributes.is_body eq 1>
		<tr>
			<td>#get_cont_body.cont_body#</td>
		</tr>
	</cfif>
</table>
</cfoutput>
