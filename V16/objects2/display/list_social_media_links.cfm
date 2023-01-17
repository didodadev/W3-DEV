<cfquery name="GET_SOCIAL_MEDIA_CATS" datasource="#DSN#">
	SELECT 
		SML.LINK,
		SM.SMCAT,
		SM.SMCAT_ICON 
	FROM 
		SETUP_SOCIAL_MEDIA_CAT SM,
		SETUP_SOCIAL_MEDIA_CAT_LINK SML 
	WHERE 
	<cfif isdefined("session.pp")>
		SML.OUR_COMPANY_ID = #session.pp.our_company_id# AND 
	<cfelseif isdefined("session.ww")>
		SML.OUR_COMPANY_ID = #session.ww.our_company_id# AND 
	</cfif>
		SML.IS_INTERNET = 1 AND 
		SML.SMCAT_ID = SM.SMCAT_ID
</cfquery>
<table style="width:100%" border="0">
	<tr>
		<td style="text-align:left;color: #0f97c9; font-weight: bold;" colspan="<cfoutput>#get_social_media_cats.recordcount+1#</cfoutput>">Bizi Takip Edin...</td>
	</tr>
	<tr>
		<cfoutput query="get_social_media_cats">
			<td style="width:15px;"><a href="#link#" target="_blank"><img src="../../documents/settings/#smcat_icon#" alt="#smcat#" border="0" title="#smcat#" style="width:30px; height:30px;"/></a></td>
		</cfoutput>
			<td>&nbsp;</td>
	</tr>
</table>
