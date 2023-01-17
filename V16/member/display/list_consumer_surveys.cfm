<cfinclude template="../query/get_consumer_surveys.cfm">
<cfset url_str = "">
<cfparam name="attributes.keyword" default="">
<cfif len(attributes.keyword)>
	<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
</cfif>
<cfif isdefined("attributes.consumer_id")>
  <cfset url_str = "#url_str#&consumer_id=#attributes.consumer_id#">
</cfif>
<cfif isdefined("attributes.CONSUMER_CAT_ID")>
  <cfset url_str = "#url_str#&CONSUMER_CAT_ID=#attributes.CONSUMER_CAT_ID#">
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default=#get_surveys.recordcount#>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box title="#getLang('','Anketler','57947')#" popup_box="1">
    	<cfform name="search" method="post" action="">
			<input type="hidden" value="<cfoutput>#attributes.CONSUMER_CAT_ID#</cfoutput>" name="CONSUMER_CAT_ID" id="CONSUMER_CAT_ID">
			<input type="hidden" value="<cfoutput>#attributes.consumer_id#</cfoutput>" name="consumer_id" id="consumer_id">
			<cf_box_search>
				<div class="form-group">
					<cfinput type="text" name="keyword" maxlength="100" value="#attributes.keyword#" placeholder="#getLang('','Filtre','57460')#">
				</div>
				<div class="form-group small">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4" search_function="loadPopupBox('search','#attributes.modal_id#')">
				</div>
        	</cf_box_search>
     	</cfform>
		<cf_grid_list>
			<thead>
				<tr>
					<th width="25"><cf_get_lang dictionary_id='57487.No'></th>
					<th><cf_get_lang dictionary_id='58662.Anket'></th>
					<th><cf_get_lang dictionary_id='58810.Soru'></th>
					<th width="100"><cf_get_lang dictionary_id='30424.Üye Cevabı'></th>
				</tr>
			</thead>
			<tbody>
				<cfif get_surveys.recordcount>
				<cfoutput query="get_surveys" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
					<tr>
					<td>#survey_id#</td>
					<td>
						<cfif  not listfindnocase(denied_pages,'campaign.form_vote_survey')>
						<a href="javascript://" onClick="window.opener.location.href='#request.self#?fuseaction=campaign.form_vote_survey&survey_id=#survey_id#';self.close();" class="tableyazi">#survey_head#</a>
						<cfelse>
						#survey_head#
						</cfif>
					</td>
					<td>#survey#</td>
					<td>
						<cfset attributes.SURVEY_ID = GET_SURVEYS.SURVEY_ID>
						<cfinclude template="../query/get_consumer_surveys_votes.cfm">
						<cfif GET_SURVEY_RESULT.RECORDCOUNT>
						<cfloop query="GET_SURVEY_ANSWER">
							#GET_SURVEY_ANSWER.ALT#
							<cfif GET_SURVEY_ANSWER.currentrow neq GET_SURVEY_ANSWER.recordcount>
							</cfif>
						</cfloop>
						<cfelse>
						<cf_get_lang dictionary_id='30425.Ankete Cevap Verilmedi'>!
						</cfif>
					</td>
					</tr>
				</cfoutput>
				<cfelse>
				<tr>
					<td colspan="4"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>
				</tr>
				</cfif>
			</tbody>
		</cf_grid_list>
	</cf_box>
</div>
<cfif get_surveys.recordcount>
  <cfif attributes.totalrecords gt attributes.maxrows>
		<cf_paging
		page="#attributes.page#" 
		maxrows="#attributes.maxrows#" 
		totalrecords="#attributes.totalrecords#" 
		startrow="#attributes.startrow#" 
		adres="member.popup_list_consumer_surveys#url_str#"> </td>
  	</cfif>
</cfif>

