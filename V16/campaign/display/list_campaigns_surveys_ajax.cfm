<cfsetting showdebugoutput="no">
<cfquery name="GET_CAMP_SURVEY" datasource="#dsn#">
	SELECT 
		SURVEY.SURVEY_ID,
		SURVEY.SURVEY
	FROM 
		#dsn3_alias#.CAMPAIGN_SURVEYS AS CAMPAIGN_SURVEYS,
		SURVEY
	WHERE 
		SURVEY.SURVEY_ID = CAMPAIGN_SURVEYS.SURVEY_ID AND
		CAMPAIGN_SURVEYS.CAMP_ID = #attributes.camp_id#
</cfquery>
<cf_ajax_list>
	<thead>
        <tr>
            <th colspan="2"><cf_get_lang_main no="68.konu"></th>
        </tr>
    </thead>
    <tbody>
	<cfif get_camp_survey.recordcount>
		<cfoutput query="get_camp_survey">
		<tr id="__erase__#survey_id#_#currentrow#">
			<td>
				<a href="#request.self#?fuseaction=campaign.form_upd_survey&survey_id=#survey_id#" class="tableyazi">#survey#</a><br/>
			</td>
			<div id="erase#survey_id#" style="display:none;"></div>
			<td id ="camp_surv_info_#survey_id#" style="text-align:right;"> 
				<cfsavecontent variable="message_del"><cf_get_lang_main no='121.Silmek Istediginizden Emin Misiniz'></cfsavecontent>
				<a href="javascript://" onClick="if(confirm('#message_del#')) AjaxPageLoad('#request.self#?fuseaction=campaign.emptypopup_del_camp_survey&camp_id=#camp_id#&survey_id=#survey_id#','erase#survey_id#',0,'Siliniyor',''); else return false;"><img src="/images/delete_list.gif" alt="Sil" border="0"></a></td>
			</td>
		</tr>
		</cfoutput>
	<cfelse>
		<tr>
			<td colspan="2"><cf_get_lang_main no='72.Kayıt Bulunamadı'> !</td>
		</tr>
	</cfif>
    </tbody>
</cf_ajax_list>

