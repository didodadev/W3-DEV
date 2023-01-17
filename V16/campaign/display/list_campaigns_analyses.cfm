<cfquery name="GET_CAMP_ANALYSE" datasource="#dsn3#">
	SELECT 
		MEMBER_ANALYSIS.ANALYSIS_ID,
		MEMBER_ANALYSIS.ANALYSIS_HEAD

	FROM 
		CAMPAIGN_ANALYSES,
		#dsn_alias#.MEMBER_ANALYSIS AS MEMBER_ANALYSIS
	WHERE 
		MEMBER_ANALYSIS.ANALYSIS_ID = CAMPAIGN_ANALYSES.ANALYSE_ID AND
		CAMP_ID = #attributes.camp_id#
</cfquery>
<table cellspacing="0" cellpadding="0" width="98%" border="0">
  <tr class="color-border">
	<td>
	  <table cellspacing="1" cellpadding="2" width="100%" border="0">
		<tr class="color-header" height="22">
		  <td class="form-title"><cf_get_lang_main no ='1387.Analizler'></td>
		  <td width="15"><a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_analyse&camp_id=#camp_id#&from_promotion=1</cfoutput>','list')"><img src="/images/plus_square.gif" border="0" alt="<cf_get_lang no='51.Promosyon Ekle'>" title="<cf_get_lang no='51.Promosyon Ekle'>" align="absmiddle"></a></td>
		</tr>
		<cfif get_camp_analyse.recordcount>
		  <cfoutput query="get_camp_analyse">
			<tr class="color-row">
			  <td><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=member.analysis&analyse_id=#analysis_id#','list')" class="tableyazi">#analysis_head#</a><br/>
			  </td>
			  <cfsavecontent variable="del_message"><cf_get_lang_main no='121.Silmek Istediginizden Emin Misiniz'></cfsavecontent>
			  <td><a href="javascript://" onClick="javascript:if (confirm('#del_message#')) windowopen('#request.self#?fuseaction=objects.emptypopup_del_analyse&analyse_id=#analysis_id#&camp_id=#camp_id#','list'); else return false;"><img src="/images/delete_list.gif" alt="<cf_get_lang no='14.Kampanyadan Çıkar'>" title="<cf_get_lang no='14.Kampanyadan Çıkar'>" border="0"></a></td>
			</tr>
		  </cfoutput>
		  <cfelse>
		  <tr class="color-row">
			<td colspan="2"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</td>
		  </tr>
		</cfif>
	  </table>
	</td>
  </tr>
</table>
