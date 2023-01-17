<cfquery name="GET_RISK_SEGMANTATIONS" datasource="#DSN#">
	SELECT 
		SEGMANTATION_ID,
		SEGMANTATION,
		MIN_LIMIT,
		MAX_LIMIT
	FROM 
		SETUP_RISK_SEGMANTATION
	ORDER BY
		SEGMANTATION_ID
</cfquery>
<table width="135" cellpadding="0" cellspacing="0" border="0">
  <tr> 
    <td class="txtbold" height="20" colspan="2">&nbsp;&nbsp;<cf_get_lang dictionary_id='43341.Segmentasyon'></td>
  </tr>
<cfif get_risk_segmantations.recordcount>
  <cfoutput query="get_risk_segmantations">
  <tr>
  	<td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
    <td width="115"><a href="#request.self#?fuseaction=settings.form_upd_risk_segmantation&id=#segmantation_id#" class="tableyazi">#segmantation# (#min_limit# - #max_limit#)</a></td>
  </tr>
  </cfoutput>
<cfelse>
  <tr>
	<td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
    <td width="115"><font class="tableyazi"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'> !</font></td>
  </tr>
 </cfif>
</table>
