<cfquery name="GET_CAMP_VISIT" datasource="#dsn#">
	SELECT 
		EVENT_PLAN_HEAD,
		EVENT_PLAN_ID
	FROM
		EVENT_PLAN
	WHERE
		CAMPAIGN_ID = #attributes.camp_id#
</cfquery>
<table cellspacing="0" cellpadding="0" width="98%" border="0">
  <tr class="color-border">
	<td>
	  <table cellspacing="1" cellpadding="2" width="100%" border="0">
		<tr class="color-header" height="22">
		  <td width="1191" class="form-title">Ziyaretler</td>
		  <td width="32"><a href="<cfoutput>#request.self#?fuseaction=sales.form_add_visit&camp_id=#camp_id#</cfoutput>"><img src="/images/plus_square.gif" alt="<cf_get_lang no='51.Promosyon Ekle'>" border="0" title="<cf_get_lang no='51.Promosyon Ekle'>" align="absmiddle"></a></td>
		</tr>
		<cfif get_camp_visit.recordcount>
		  <cfoutput query="get_camp_visit">
			<tr class="color-row">
			  <td colspan="2"><a href="#request.self#?fuseaction=sales.form_upd_visit&visit_id=#event_plan_id#" class="tableyazi">#event_plan_head#</a><br/>
			</tr>
		  </cfoutput>
		  <cfelse>
		  <tr class="color-row">
			<td colspan="2"><cf_get_lang_main no='72.Kayıt Bulunamadı'> !</td>
		  </tr>
		</cfif>
	  </table>
	</td>
  </tr>
</table>
