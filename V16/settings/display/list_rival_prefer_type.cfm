<cfquery name="RIVAL_PREFERENCE_REASONS" datasource="#DSN#">
	SELECT 
		PREFERENCE_REASON_ID,
		PREFERENCE_REASON 
	FROM 
		SETUP_RIVAL_PREFERENCE_REASONS 
	ORDER BY 
		PREFERENCE_REASON
</cfquery>	

<table width="170" cellpadding="0" cellspacing="0" border="0">
	<tr> 
		<td class="txtbold" height="20" colspan="2"><cf_get_lang dictionary_id='42174.Rakip Tercih Nedenleri'></td>
	</tr>
<cfif rival_preference_reasons.recordcount>
  <cfoutput query="rival_preference_reasons">
	<tr>
		<td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
		<td width="150"><a href="#request.self#?fuseaction=settings.form_upd_rival_prefer_type&id=#preference_reason_id#" class="tableyazi">#preference_reason#</a></td>
	</tr>
  </cfoutput>
<cfelse>
	<tr>
		<td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
		<td width="150"><font class="tableyazi"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</font></td>
	</tr>
</cfif>
</table>

