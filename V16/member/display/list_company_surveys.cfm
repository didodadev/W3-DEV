<cfinclude template="../query/get_surveys.cfm">
<cfset url_str = "">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.company_id" default="">
<cfif len(attributes.keyword)>
	<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
</cfif>
<cfif len(attributes.company_id)>
	<cfset url_str = "#url_str#&company_id=#attributes.company_id#">
</cfif>
<cfif isdefined("attributes.COMPANYCAT_ID")>
	<cfset url_str = "#url_str#&COMPANYCAT_ID=#attributes.COMPANYCAT_ID#">
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.modal_id" default="">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default="#get_surveys.recordcount#">
<cfif not (isDefined('attributes.maxrows') and isNumeric(attributes.maxrows))>
	<cfset attributes.maxrows = session.ep.maxrows>
  </cfif>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box title="#getLang('','Anketler','57947')#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
		<cfform name="search" method="post" action="">
			<input type="hidden" value="<cfoutput>#attributes.COMPANYCAT_ID#</cfoutput>" name="COMPANYCAT_ID" id="COMPANYCAT_ID">
			<cf_box_search more="0">
				<div class="form-group" id="keyword">
					<cfinput type="text" name="keyword" placeholder="#getLang('','Filtre','57460')#" value="#attributes.keyword#" maxlength="255">
				</div>
				<div class="form-group small">
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#getLang('','Sayi_Hatasi_Mesaj','57537')#" maxlength="3">
				</div>	
				   <div class="form-group">
					<cf_wrk_search_button button_type="4" search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('search' , #attributes.modal_id#)"),DE(""))#">
				</div>
			</cf_box_search>
			<cf_flat_list>	
				<cfif get_surveys.recordcount>
					<cfoutput query="get_surveys" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#"> 
					<cfsavecontent variable="title">
						<cf_get_lang dictionary_id='30420.Anket Başlığı'>: 
						<cfif not listfindnocase(denied_pages,'campaign.form_vote_survey')>
							<a href="javascript://" onClick="window.opener.location.href='#request.self#?fuseaction=campaign.list_survey&event=dashboard&survey_id=#survey_id#';self.close();" class="txtboldblue">#survey_head#</a>
						<cfelse>
							#survey_head#
						</cfif>
						- <cf_get_lang dictionary_id='58810.Soru'>: #survey#
					</cfsavecontent>
					<cf_seperator id="#SURVEY_ID#" header="#title#" is_closed="1">
						<table id="#SURVEY_ID#" style="display:none;">
							<cfset attributes.survey_id = get_surveys.survey_id>
							<cfquery name="GET_PAR_NAMES" datasource="#DSN#">
								SELECT 
									COMPANY_PARTNER.COMPANY_PARTNER_NAME,
									COMPANY_PARTNER.COMPANY_PARTNER_SURNAME,
									COMPANY_PARTNER.PARTNER_ID,
									SURVEY_VOTES.VOTES
								FROM
									COMPANY_PARTNER,
									SURVEY_VOTES AS SURVEY_VOTES
								WHERE
									COMPANY_PARTNER.COMPANY_ID = #attributes.company_id# AND
									SURVEY_VOTES.SURVEY_ID = #attributes.SURVEY_ID# AND
									SURVEY_VOTES.PAR_ID = COMPANY_PARTNER.PARTNER_ID				   
							</cfquery>
							<cfif GET_PAR_NAMES.recordcount>
								<cfloop query="GET_PAR_NAMES">
									<tr>
										<td width="200"><a href="javascript://"  onclick="windowopen('#request.self#?fuseaction=objects.popup_par_det&par_id=#PARTNER_ID#','medium','popup_par_det');" class="tableyazi">#company_partner_name# #company_partner_surname#</a></td>
										<td><cfif listlen(listsort(VOTES,'Numeric'))>
												<cfquery name="GET_ANS" datasource="#DSN#">
													SELECT ALT FROM SURVEY_ALTS WHERE ALT_ID IN (#listsort(VOTES,'Numeric')#)
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
						</table>
					</cfoutput>
				<cfelse>
					<table>			
						<tr>
							<td><cf_get_lang dictionary_id='30420.Anket Başlığı'> - <cf_get_lang dictionary_id='58810.Soru'></td>
						</tr>
						<tr> 
							<td><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>
						</tr>
					</table>
				</cfif>
			</cf_flat_list>	
			<cfif attributes.totalrecords gt attributes.maxrows>
				<table width="99%" align="center">
					<tr> 
						<td><cf_pages 
								page="#attributes.page#" 
								maxrows="#attributes.maxrows#" 
								totalrecords="#attributes.totalrecords#" 
								startrow="#attributes.startrow#" 
								adres="member.popup_list_company_surveys#url_str#"> 
						</td>
						<!-- sil -->
						<td  style="text-align:right;"><cfoutput><cf_get_lang dictionary_id='57540.Toplam Kayıt'>:#attributes.totalrecords#&nbsp;-&nbsp;<cf_get_lang dictionary_id='57581.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td>
						<!-- sil -->
					</tr>
				</table>
			</cfif>			
		</cfform>
	</cf_box>
</div>
