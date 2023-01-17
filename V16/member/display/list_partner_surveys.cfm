<cf_get_lang_set module_name="member">
<cfinclude template="../query/get_surveys.cfm">
<cfset url_str = "">
<cfparam name="attributes.keyword" default="">
<cfif isdefined("attributes.COMPANYCAT_ID")>
	<cfset url_str = "#url_str#&COMPANYCAT_ID=#attributes.COMPANYCAT_ID#">
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default=#get_surveys.recordcount#>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<cf_box title="#getLang('','Anketler',57947)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<div class="ui-scroll">
		<cfform name="search_partner_surveys" method="post" action="#request.self#?fuseaction=member.popup_list_partner_surveys#url_str#">
			<cf_box_search more="0">
				<input type="hidden" value="<cfoutput>#attributes.partner_id#</cfoutput>" name="partner_id" id="partner_id">
				<div class="form-group">
					<cfinput type="text" name="keyword" value="#attributes.keyword#" maxlength="50" placeholder="#getLang('','Filtre',57460)#">
				</div>
				<div class="form-group small">
					<cfinput type="text" name="maxrows" onKeyUp="isNumber(this)" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#getLang('','Kayıt Sayısı Hatalı',57537)#" maxlength="3">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4" search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('search_partner_surveys' , #attributes.modal_id#)"),DE(""))#">
				</div>
			</cf_box_search>
		</cfform>
		<cfif get_surveys.recordcount>
			<cfoutput query="get_surveys" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#"> 
				<cfsavecontent variable="header_">
					<cf_get_lang dictionary_id='30420.Anket Başlığı'>: 
					<cfif not listfindnocase(denied_pages,'campaign.form_vote_survey')>
						<span onclick="window.open('#request.self#?fuseaction=campaign.form_vote_survey&survey_id=#survey_id#')">#survey_head#</span>
					<cfelse>
						#survey_head#
					</cfif>
				</cfsavecontent>
				<cf_seperator id="#SURVEY_ID#" header="#header_#" is_closed="1">
				<cf_grid_list id="#SURVEY_ID#" style="display:none;">
					<thead>
					<tr>
						<th colspan="2">
							#survey#
						</th>
					</tr>
					</thead>
					<cfset attributes.survey_id = get_surveys.survey_id>
					<cfquery name="GET_VOTES" datasource="#DSN#">
						SELECT
							VOTES
						FROM
							SURVEY_VOTES AS SURVEY_VOTES
						WHERE
							SURVEY_VOTES.SURVEY_ID = #attributes.SURVEY_ID#
							AND
							SURVEY_VOTES.PAR_ID = #ATTRIBUTES.PARTNER_ID#			   
					</cfquery>
					<cfif GET_VOTES.recordcount>
						<cfloop query="GET_VOTES">
							<tr>
								<td colspan="2">
									<cfif listlen(listsort(VOTES,'Numeric'))>
										<cfquery name="GET_ANS" datasource="#DSN#">
											SELECT 
												ALT 
											FROM 
												SURVEY_ALTS 
											WHERE 
												ALT_ID IN (#listsort(VOTES,'Numeric')#)
										</cfquery>
										<cfloop query="GET_ANS">
											#GET_ANS.ALT# <cfif GET_ANS.currentrow neq GET_ANS.recordcount>, </cfif>  
										</cfloop>
									</cfif>
								</td>
							</tr>
						</cfloop>
					<cfelse>
						<tr>
							<td colspan="2"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>
						</tr>
					</cfif>	
				</cf_grid_list>			
			</cfoutput>
		<cfelse>
			<table>
				<tr> 
					<td colspan="3"><cf_get_lang dictionary_id='30420.Anket Başlığı'> - <cf_get_lang dictionary_id='58810.Soru'></td>
				</tr>
				<tr> 
					<td colspan="3"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>
				</tr>
			</table>
		</cfif>
	</div>
	<cfif attributes.totalrecords gt attributes.maxrows>
		<cfif isDefined("attributes.partner_id") and len(attributes.partner_id)>
			<cfset url_str = '#url_str#&partner_id=#attributes.partner_id#'>
		</cfif>
		<cf_paging 
			page="#attributes.page#" 
			maxrows="#attributes.maxrows#" 
			totalrecords="#attributes.totalrecords#" 
			startrow="#attributes.startrow#" 
			adres="member.popup_list_partner_surveys#url_str#"
			isAjax="#iif(isdefined("attributes.draggable"),1,0)#"> 
	</cfif>
</cf_box>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
