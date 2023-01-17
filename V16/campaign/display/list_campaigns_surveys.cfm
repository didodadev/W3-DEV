<cfquery name="GET_CAMP_SURVEY" datasource="#DSN#">
	SELECT 
		SURVEY.SURVEY_ID,
		SURVEY.SURVEY
	FROM 
		#dsn3_alias#.CAMPAIGN_SURVEYS,
		SURVEY
	WHERE 
		SURVEY.SURVEY_ID = CAMPAIGN_SURVEYS.SURVEY_ID AND
		CAMPAIGN_SURVEYS.CAMP_ID = #attributes.camp_id#
</cfquery>
<table cellspacing="0" cellpadding="0" width="98%" border="0">
  <tr class="color-border">
	<td>
	  <table cellspacing="1" cellpadding="2" width="100%" border="0">
		<tr class="color-header" height="22">
		  <td class="form-title"><cf_get_lang_main no ='1387.Analizler'></td>
		  <td width="15"><a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=campaign.popup_list_target_surveys&camp_id=#camp_id#&from_promotion=1</cfoutput>','list')"><img src="/images/plus_square.gif" alt="<cf_get_lang no='7.Anket Ekle'>" border="0" title="<cf_get_lang no='7.Anket Ekle'>" align="absmiddle"></a></td>
		</tr>
		<cfif get_camp_survey.recordcount>
		  <cfoutput query="get_camp_survey">
			<tr class="color-row">
			  <td><a href="#request.self#?fuseaction=campaign.form_upd_survey&survey_id=#survey_id#" class="tableyazi">#survey#</a><br/></td>
			  <cfsavecontent variable="del_message"><cf_get_lang_main no='121.Silmek Istediginizden Emin Misiniz'></cfsavecontent>
			  <td><a href="javascript://" onClick="javascript:if (confirm('#del_message#')) windowopen('#request.self#?fuseaction=campaign.emptypopup_del_camp_survey&camp_id=#camp_id#&survey_id=#survey_id#','list'); else return false;"><img src="/images/delete_list.gif" alt="<cf_get_lang no='14.Kampanyadan Çıkar'>" title="<cf_get_lang no='14.Kampanyadan Çıkar'>" border="0"></a></td>
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
