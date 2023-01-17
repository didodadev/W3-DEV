<cfquery name="get_demand_reasons" datasource="#dsn#">
	SELECT 
		REASON_ID,
		REASON
	FROM
		SETUP_INVENTORY_DEMAND_REASON 
	ORDER BY	
    	REASON
</cfquery>
<table width="200" cellpadding="0" cellspacing="0" border="0">
	<cfif get_demand_reasons.recordcount>
		<cfoutput query="get_demand_reasons">
			<tr>
				<td><img src="/images/tree_1.gif" width="13"><a href="#request.self#?fuseaction=settings.form_upd_inventory_demand_reason&reason_id=#reason_id#" class="tableyazi">#REASON#</a></td>
			</tr>
      	</cfoutput>
	<cfelse>
		<tr>
			<td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
			<td width="180" nowrap><font class="tableyazi"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</font></td>
		</tr>
	 </cfif>
</table>
