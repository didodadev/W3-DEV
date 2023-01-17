<cfinclude template="../query/get_camp_tmarkets.cfm"><!--- buradan hedef kitleler geliyor. --->
<cfif attributes.goal eq 'sms'>
	<cfinclude template="../query/get_camp_sms_conts.cfm"><!---SMS İçerikleri gelsin--->
</cfif>
<cfinclude template="../query/get_campaign.cfm">
<cfset getComponent = createObject('component', 'WEX.emailservices.cfc.sendgrid')>
<cfset getSendgridInformations = getComponent.getSendgridInformations()>
<cfparam name="attributes.want_email" default="1">
<cfinclude template="../query/get_cons.cfm">
<cfinclude template="../query/get_pars.cfm">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.modal_id" default="">
<cfquery name="get_surveys_campaign" datasource="#DSN#">
	SELECT 
		SURVEY.SURVEY_ID,
		SURVEY.SURVEY
	FROM 
		#dsn3_alias#.CAMPAIGN_SURVEYS CAMPAIGN_SURVEYS,
		SURVEY
	WHERE 
		SURVEY.SURVEY_ID = CAMPAIGN_SURVEYS.SURVEY_ID AND
		CAMPAIGN_SURVEYS.CAMP_ID = #attributes.camp_id#
</cfquery>

<cfset mailList=valuelist(get_cons.CONSUMER_EMAIL)>
<cfset mailList=valuelist(get_pars.COMPANY_PARTNER_EMAIL)>
<cfif isdefined("email_cont_id") and len(email_cont_id)>
	<cfset cfc= createObject("component","V16.content.cfc.get_content")>
	<cfset get_content =cfc.get_content_list_fnc(cntid : email_cont_id)> 
</cfif>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box title="#getLang('','Hedef Kitle',49363)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
		<cfif attributes.goal eq 'email'>
			<cfset form_action='emptypopup_send_camp_emails&email_cont_id=#email_cont_id#&camp_id=#camp_id#'>
		<cfelseif attributes.goal eq 'sms'>
			<cfset form_action='emptypopup_send_camp_smss&sms_cont_id=#attributes.sms_cont_id#&camp_id=#attributes.camp_id#'>
		</cfif>
		<cfform method="post" name="target_list" id="target_list" action="#request.self#?fuseaction=campaign.#form_action#">
			<cfif isdefined("attributes.consumer_id")>
				<input type="Hidden" name="consumer_id" id="consumer_id" value="<cfoutput>#attributes.consumer_id#</cfoutput>">
			</cfif>
			<cfif isdefined("attributes.partner_id")>
				<input type="Hidden" name="partner_id" id="partner_id" value="<cfoutput>#attributes.partner_id#</cfoutput>">
			</cfif>
			<cf_box_elements>
				<div class="col col-12 col-md-12 col-sm-12 col-xs-12" type="column" index="1" sort="true">
					<cfif attributes.goal eq 'email'>
						<!--- ilgili kampanyaya ait email gonderim sayisi --->
						<cfquery name="get_email_count" datasource="#dsn#">
							SELECT 
								MAX(COUNT) COUNT,
								SEND_DATE,
								E.EMPLOYEE_NAME + ' '  + E.EMPLOYEE_SURNAME NAME
							FROM 
								SEND_CONTENTS
								LEFT JOIN EMPLOYEES E ON SEND_CONTENTS.SENDER_EMP = E.EMPLOYEE_ID
							WHERE 
								CAMP_ID = #attributes.camp_id# 
								AND CONT_ID = #email_cont_id# 
								AND CONT_TYPE = 1
							GROUP BY
								E.EMPLOYEE_NAME,
								E.EMPLOYEE_SURNAME,
								SEND_DATE
							ORDER BY
								COUNT DESC
						</cfquery>
						<div class="form-group">
							<label class="col col-12 col-md-12 col-sm-12 col-xs-12 bold"><cf_get_lang no='210.Hedef Kitle - Kişi Sayısı'></label>
						</div>
			
						<div class="form-group">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57143.Gönderim Tipi'>
							</label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<select name="submission_type" id="submission_type">
									<option value="0"><cf_get_lang dictionary_id='29463.Mail'></option>
									<cfif getSendgridInformations.IS_SENDGRID_INTEGRATED eq 1 and len(getSendgridInformations.MAIL_API_KEY) and len(getSendgridInformations.sender_mail)>
										<option value="1"><cf_get_lang dictionary_id='43645.SendGrid'></option>
									</cfif>
								</select>
							</div>
						</div>
						<div class="form-group">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58662.Anket'></label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<select name="survey_id" id="survey_id">
									<option value=""><cf_get_lang dictionary_id='57734.Please Select'></option>
									<cfoutput query="get_surveys_campaign">
										<option value="#SURVEY_ID#">#SURVEY#</option>
									</cfoutput>
								</select>
							</div>
						</div>
				
						<div class="form-group">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='62874.Liste Yöneticisi Toplam Sayı'></label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<cfset total_no = get_cons.RECORDCOUNT + get_pars.RECORDCOUNT>
								<cfoutput><font color="##0000FF">#total_no#</font></cfoutput>
							</div>
						</div>
						<div class="form-group">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='40101.Sender'></label>
							<cfif getSendgridInformations.IS_SENDGRID_INTEGRATED eq 1 and len(getSendgridInformations.SENDER_MAIL)>
								<label class="col col-8 col-md-8 col-sm-8 col-xs-12"><cfoutput>#getSendgridInformations.SENDER_MAIL#</cfoutput></label>
							<cfelseif attributes.goal eq 'email' and isdefined("campaign_mail_address_list") and listlen(campaign_mail_address_list)>
								<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
									<select name="email_sender" id="email_sender">
										<cfloop list="#campaign_mail_address_list#" delimiters=";" index="ccc">
											<cfoutput>
											<option value="#ccc#">#listlast(ccc,',')#</option>
											</cfoutput>
										</cfloop>
									</select>
								</div>
							<cfelse>
								<label class="col col-8 col-md-8 col-sm-8 col-xs-12"><cfoutput>#session.ep.company#<#session.ep.company_email#></cfoutput></label>
							</cfif>
						</div>
						<cfif isdefined("get_email_count") and get_email_count.recordcount>
							<div class="form-group">
								<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='62875.Gönderi Sayısı'></label>
								<div class="col col-8 col-md-8 col-sm-8 col-xs-12"><cfoutput>#get_email_count.COUNT#</cfoutput></div>
							</div>
							<div class="form-group">
								<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='62788.Son gönderen'></label>
								<div class="col col-8 col-md-8 col-sm-8 col-xs-12"><cfoutput>#get_email_count.NAME# - #dateformat(get_email_count.SEND_DATE,dateformat_style)#</cfoutput></div>
							</div>
						<cfelse>
							<div class="form-group">
								<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='62875.Gönderi Sayısı'></label>
								<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
									<cfoutput><cf_get_lang dictionary_id="54720.Daha Önce Bu İçeriğe Ait Mail Gönderimi Yapılmamıştır">.</cfoutput>
								</div>
							</div>
						</cfif>
						<div class="form-group" id="item-is-temp" style="display:none">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='62760.Template olarak kaydet'>
							</label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<input type="checkbox" id"is_temp" name="is_temp" value="1">
							</div>
						</div>
					</cfif>
					<cfif attributes.goal eq 'sms'>
						<div class="form-group">
							<label class=" col col-12 col-md-12 col-sm-12 col-xs-12 text-bold">
								<cf_get_lang dictionary_id='48277.Gönderi'>:&nbsp <cfoutput> #campaign.camp_head#</cfoutput>
							</label>
						</div>
						<cf_flat_list>
							<tbody>
								<tr style="border-bottom:none">
									<td><label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='40122.SMS Submission Date'></label></td>
										<td>
											<div class="form-group">
												<div class="col col-6 col-md-6 col-sm-6 col-xs-12"> 
													<div class="input-group">
														<cfinput type="text" name="send_date" value="#dateformat(now(),dateformat_style)#" validate="#validate_style#" maxlength="10" message="">
														<span class="input-group-addon"><cf_wrk_date_image date_field="send_date"></span>
													</div>
												</div>
												<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
													<select name="send_hour" id="send_hour">
														<option value="0" selected><cf_get_lang dictionary_id='57491.Saat'></option>
														<cfloop from="0" to="23" index="i">
															<cfoutput><option value="#i#" <cfif datepart('H',date_add('h',session.ep.time_zone, now())) eq i>selected</cfif>>#i#</option></cfoutput>
														</cfloop>
													</select>
												</div>
												<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
													<cfset now_minute=datepart('n',now())>
													<select name="send_minute" id="send_minute">
														<cfloop from="0" to="55" index="j" step="5">
															<cfoutput><option value="#j#" <cfif  now_minute gte j and now_minute lt (j+5)>selected</cfif>>#NumberFormat(j,00)#</option></cfoutput>
														</cfloop>
													</select>
												</div>
										</div>	</td>
								</tr>
								<cfoutput query="camp_tmarkets"><!--- eklenen içerik --->						
									<cfif not ListContains(CAMP_SMS_CONTS.SENDED_TARGET_MASS, TMARKET_ID)><!--- Bu Hedef Kitle'ye SMS gönderilmemişse .....--->
										<cfset attributes.TMARKET_ID = TMARKET_ID>
										<cfinclude template="../query/get_target_markets.cfm">
										<cfinclude template="../query/get_target_people.cfm">
										<cfscript>
											'cons_#TMARKET_ID#' = 0;
											'par_#TMARKET_ID#' = 0;
											target_people = ValueList(GET_TARGET_PEOPLE.CON_ID);
											sms_valid_rc = 0;
											sms_invalid_rc = 0;
											sms_empty_rc = 0;
											uemobile = "";
											valid_cons_sms_list = "";
											valid_pars_sms_list = "";
										</cfscript>
										<cfif (TARGET_MARKET_TYPE eq 2) or (TARGET_MARKET_TYPE eq 0)>
											<cfinclude template="../query/get_tmarket_consumers.cfm">
											<cfscript>
												for(g = 1; g lte GET_TMARKET_USERS.recordcount; g = g + 1)
												{
													if(not ListContains(target_people,GET_TMARKET_USERS.CONSUMER_ID[g])) //Bu üye listeden çıkarılmışsa bir sonrakine geç
														continue;
													uemobile = GET_TMARKET_USERS.C_MOBILPHONE[g];
													if(not Len(uemobile))
													{
														sms_empty_rc = sms_empty_rc + 1;
													}
													else if((len(uemobile) EQ 10))
													{
													sms_valid_rc = sms_valid_rc + 1;
													valid_cons_sms_list = ListAppend(valid_cons_sms_list,GET_TMARKET_USERS.CONSUMER_ID[g],',');
													}
													else
													{
													sms_invalid_rc = sms_invalid_rc + 1;
													}
												}
											</cfscript> 
											<cfset 'cons_#TMARKET_ID#' = GET_TMARKET_USERS.recordcount>
										</cfif>
										<cfif (TARGET_MARKET_TYPE eq 1) or (TARGET_MARKET_TYPE eq 0)>
											<cfinclude template="../query/get_tmarket_partner_ids.cfm"><!--- Hedef Kitledeki Kurumsal üyeler --->
											<cfscript>
												target_people = ValueList(GET_TARGET_PEOPLE.PAR_ID);
												for(h = 1; h lte GET_TMARKET_PARTNERS.recordcount; h = h + 1)
												{
													if(not ListContains(target_people,GET_TMARKET_PARTNERS.PARTNER_ID[h]))
													continue;
													UEMOBILE = GET_TMARKET_PARTNERS.CP_MOBILPHONE[h];
													if(not Len(UEMOBILE))
														sms_empty_rc = sms_empty_rc + 1;
													else if((len(UEMOBILE) EQ 10))
													{
														sms_valid_rc = sms_valid_rc + 1;
														valid_pars_sms_list = ListAppend(valid_pars_sms_list,GET_TMARKET_PARTNERS.PARTNER_ID[h],',');
													}
													else
													{
														sms_invalid_rc = sms_invalid_rc + 1;
													}
												}
											</cfscript> 
											<cfset 'par_#TMARKET_ID#' = GET_TMARKET_PARTNERS.recordcount>
										</cfif>
										<cfset total_no = evaluate("cons_#TMARKET_ID#") + evaluate("par_#TMARKET_ID#")>
										<tr>
											<td>
												<label class="col col-4 col-md-4 col-sm-4 col-xs-12">#tmarket_name#</label>
											</td>
											<td>
												<input type="checkbox" name="target_mass" id="target_mass" value="#attributes.TMARKET_ID#">
												<input type="hidden" name="cons_sms_list_#TMARKET_ID#" id="cons_sms_list_#TMARKET_ID#" value="#valid_cons_sms_list#">
												<input type="hidden" name="pars_sms_list_#TMARKET_ID#" id="pars_sms_list_#TMARKET_ID#" value="#valid_pars_sms_list#">
											</td>
										</tr>
										<tr>
											<td>
												<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><font color="##0000FF"><cf_get_lang dictionary_id='63439.Liste Yöneticisine Kaydedilmiş Hedef Kitle Kişi Sayısı'>:&nbsp #sms_valid_rc + sms_invalid_rc + sms_empty_rc#</font></label>
											</td>
											<td>
												<div class="form-group">
													<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
														<font color="##0000FF">#total_no#</font>
													</div>
												</div>
											</td>
										</tr>
										<tr>
											<td>
												<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id="54714.SMS Geçerli"></label>
											</td>
											<td>
												<div class="form-group">
													<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
														<font color="##0000FF">#sms_valid_rc#</font>
													</div>
												</div>
											</td>
										</tr>
										<tr>
											<td>
												<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id="54715.SMS Geçersiz"></label>
											</td>
											<td>
												<div class="form-group">
													<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
														<font color="##0000FF">#sms_invalid_rc#</font>
													</div>
												</div>
											</td>
										</tr>
										<tr>
											<td>
												<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id="54716.SMS Boş"></label>
											</td>
											<td>
												<div class="form-group">
													<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
														<font color="##0000FF">#sms_empty_rc#</font>
													</div>
												</div>
											</td>
										</tr>
									</cfif>
								</cfoutput>
							<!---SMS Elle Eklenmiş Kurumsal Üyeleri getiriyor----->
								<cfinclude template="../query/get_outof_target_mass.cfm"><!--- Elle Eklenmiş Kurumsal Üyeleri getiriyor --->
								<cfif not ListContains(CAMP_SMS_CONTS.SENDED_TARGET_MASS, '-1')>
									<cfscript>
										sms_valid_rc = 0;
										sms_invalid_rc = 0;
										sms_empty_rc = 0;
										other_valid_cons_sms_list = "";
										other_valid_pars_sms_list = "";
										if(ListLen(consumer_list))
										{
											for(h = 1; h lte GET_OUTOF_TARGET_USERS.recordcount; h = h + 1)
											{
												uemobile = GET_OUTOF_TARGET_USERS.U_MOBILEPHONE[h];
												if(not Len(UEMOBILE))
												{
													sms_empty_rc = sms_empty_rc + 1;
												}
												else if((len(UEMOBILE) EQ 10))
												{
													other_valid_cons_sms_list =ListAppend(other_valid_cons_sms_list,GET_OUTOF_TARGET_USERS.CONSUMER_ID[h],','); //elle eklenmiş bireysel üyeleri listeye atıyoruz.
													sms_valid_rc = sms_valid_rc + 1;
												}
												else
													sms_invalid_rc = sms_invalid_rc + 1;
												
											}
										}
										if(ListLen(partner_list))
										{
											for(h = 1; h lte GET_OUTOF_TARGET_PARTNERS.recordcount; h = h + 1)
											{
												uemobile = GET_OUTOF_TARGET_PARTNERS.CP_MOBILEPHONE[h];
												if(not Len(UEMOBILE))
												{
													sms_empty_rc = sms_empty_rc + 1;
												}
												else if((len(UEMOBILE) EQ 10))
												{
													sms_valid_rc = sms_valid_rc + 1;
													other_valid_pars_sms_list =ListAppend(other_valid_pars_sms_list,GET_OUTOF_TARGET_PARTNERS.PARTNER_ID[h],','); //elle eklenmiş bireysel üyeleri listeye atıyoruz.
												}
												else
												{sms_invalid_rc = sms_invalid_rc + 1;}
											}
										}
									</cfscript>
									<cfoutput>
										<tr>
											<td>
												<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id="54719.Liste Yöneticisine Elle Eklenmiş Üyeler"></label>
											</td>
											<td>
												<input type="checkbox" name="target_mass_other" id="target_mass_other" value="1">
												<input type="hidden" name="other_cons_sms_list" id="other_cons_sms_list" value="#other_valid_cons_sms_list#">
												<input type="hidden" name="other_pars_sms_list" id="other_pars_sms_list" value="#other_valid_pars_sms_list#">
											</td>
										</tr>
										<tr>
											<td>
												<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='63440.Liste Yöneticisine Elle Eklenen Kişi Sayısı'></label>
											</td>
											<td>
												<div class="form-group">
													<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
														<font color="##0000FF">#get_outof_target_mass.RecordCount#</font>
													</div>
												</div>
											</td>
										</tr>
										<tr>
											<td>
												<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id="54714.SMS Geçerli"></label>
											</td>
											<td>
												<div class="form-group">
													<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
														<font color="##0000FF">#sms_valid_rc#</font>
													</div>
												</div>
											</td>
										</tr>
										<tr>
											<td>
												<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id="54715.SMS Geçersiz"></label>
											</td>
											<td>
												<div class="form-group">
													<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
														<font color="##0000FF">#sms_invalid_rc#</font>
													</div>
												</div>
											</td>
										</tr>
										<tr style="border-bottom:none"> 
											<td>
												<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id="54716.SMS Boş"></label>
											</td>
											<td>
												<div class="form-group">
													<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
														<font color="##0000FF">#sms_empty_rc#</font>
													</div>
												</div>
											</td>
										</tr>
									</cfoutput>
								</cfif>
							</tbody>
						</cf_flat_list>
					</cfif>	
				</div>
			</cf_box_elements>
			<cf_box_footer>
				<cf_workcube_buttons insert_info='#getLang('','Gönder',58743)#' is_upd='0' add_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('target_list' , #attributes.modal_id#)"),DE(""))#"> 
			</cf_box_footer>
		</cfform>
	</cf_box>
</div>
<script>
	$("#submission_type").change(function(){
		if($('#submission_type').val() == 1)$('#item-is-temp').show();
		else $('#item-is-temp').hide();
	});
</script>