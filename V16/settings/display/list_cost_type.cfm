<cfquery NAME="GET_COST_TYPE_LIST" datasource="#DSN#">
	SELECT
		*
	FROM 
		SETUP_COST_TYPE
</cfquery> 
<table width="200" cellpadding="0" cellspacing="0" border="0">
	<tr>
		<td class="txtbold" colspan="2" height="20">&nbsp;&nbsp;<cf_get_lang no='1573.Maliyet Tipleri'></td>	
	</tr>
	<cfif GET_COST_TYPE_LIST.RECORDCOUNT>
	<cfoutput query="GET_COST_TYPE_LIST">
		<tr>
			<td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" border="0" align="absmiddle"></td>
			<td width="180"><a href="#request.self#?fuseaction=settings.form_upd_cost_type&cost_type_id=#COST_TYPE_ID#" class="tableyazi">#COST_TYPE_NAME#</a></td>
		</tr>
	</cfoutput>
	<cfelse>
		<tr>
			<td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" border="0" align="absmiddle"></td>
			<td width="180"><cf_get_lang_main no='72.kayıt yok'></td>
		</tr>
	</cfif> 
</table>
