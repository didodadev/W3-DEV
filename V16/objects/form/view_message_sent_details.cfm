<!--- gidenler --->
<cfquery name="get_email_sent" datasource="#dsn#">
	SELECT 
		SEND_CONTENTS.CONT_ID,
		C.CONT_HEAD AS SUBJECT,
		'Gönderildi' AS STATUS,
		'EMAIL' AS CONT_TYPE
	FROM 
		SEND_CONTENTS,
		CONTENT_RELATION CR,
		CONTENT C
	WHERE 
		SEND_CONTENTS.SEND_#attributes.type# = #url.user_id#
		AND SEND_CONTENTS.CONT_TYPE = 1
		AND CR.ACTION_TYPE = 'CAMPAIGN_ID'
		AND SEND_CONTENTS.CONT_ID = C.CONTENT_ID 
		AND CR.CONTENT_ID = C.CONTENT_ID
		AND CR.ACTION_TYPE_ID = #attributes.camp_id#
		<cfif isDefined("attributes.email_cont_id")>
			AND CR.CONTENT_ID= #attributes.email_cont_id#
		</cfif> 
</cfquery>
<cfset sent_email_list = ValueList(get_email_sent.CONT_ID)>
<cfquery name="get_sms_sent" datasource="#dsn#">
	SELECT 
		CONT_ID,
		CAMPAIGN_SMS_CONT.SMS_BODY AS SUBJECT,
		'Gönderildi' AS STATUS,
		'SMS' AS CONT_TYPE
	FROM 
		SEND_CONTENTS,
		#dsn3_alias#.CAMPAIGN_SMS_CONT CAMPAIGN_SMS_CONT
	WHERE
		SEND_CONTENTS.SEND_#attributes.type# = #attributes.user_id#
		AND SEND_CONTENTS.CONT_TYPE = 1
		AND CAMPAIGN_SMS_CONT.sms_CONT_ID = SEND_CONTENTS.CONT_ID
		AND CAMPAIGN_SMS_CONT.CAMP_ID = #attributes.camp_id#
		AND CAMPAIGN_SMS_CONT.IS_SENT = 1
</cfquery>
<!--- gitmeyenler --->
<cfquery name="get_email_not_sent" datasource="#dsn#">
	SELECT 
		C.CONTENT_ID,
		C.CONT_HEAD AS SUBJECT,
		'Gönder' AS STATUS,
		'EMAIL' AS CONT_TYPE
	FROM 
		CONTENT_RELATION CR,
		CONTENT C
	WHERE 
		CR.ACTION_TYPE = 'CAMPAIGN_ID'
		AND CR.CONTENT_ID = C.CONTENT_ID
		AND CR.ACTION_TYPE_ID = #attributes.camp_id#
		<cfif len(sent_email_list)>AND C.CONTENT_ID NOT IN (#sent_email_list#) </cfif>
</cfquery>
<cfquery name="get_sms_not_sent" datasource="#dsn3#">
	SELECT 
		SMS_CONT_ID CONT_ID,
		SMS_BODY AS SUBJECT, 
		'Gönder' AS STATUS, 
		'SMS' AS CONT_TYPE
	FROM 
		CAMPAIGN_SMS_CONT
	WHERE 
		CAMP_ID=#attributes.camp_id# 
		AND IS_SENT=0
</cfquery>
<cfquery name="Results" dbtype="query">
	SELECT * FROM get_email_sent
        UNION
	SELECT * FROM get_sms_sent
        UNION
	SELECT * FROM get_email_not_sent
        UNION
	SELECT * FROM get_sms_not_sent
	ORDER BY CONT_TYPE
</cfquery>
<cfquery name="ResultIDsEmail" dbtype="query">
	SELECT CONT_ID FROM get_email_sent
	UNION
	SELECT CONTENT_ID FROM get_email_not_sent
</cfquery>
<cfset cont_ids_email = ValueList(ResultIDsEmail.CONT_ID)>
<cfquery name="OtherNotSentEmail" datasource="#dsn#">
	SELECT 
		C.CONTENT_ID,
		C.CONT_HEAD AS SUBJECT,
		'Gönder' AS STATUS,
		'EMAIL' AS CONT_TYPE
	FROM 
		CONTENT_RELATION CR,
		CONTENT C
	WHERE 
		CR.ACTION_TYPE = 'CAMPAIGN_ID'
		AND CR.CONTENT_ID = C.CONTENT_ID
		AND CR.ACTION_TYPE_ID = #attributes.camp_id#
		<cfif len(cont_ids_email)>AND CR.CONTENT_ID NOT IN (#cont_ids_email#)</cfif>
</cfquery>
<cfquery dbtype="query" name="ResultIDsSMS">
	SELECT CONT_ID FROM get_sms_sent
	UNION
	SELECT CONT_ID FROM get_sms_not_sent
</cfquery>
<cfset cont_ids_sms = ValueList(ResultIDsSms.CONT_ID)>
<cfquery datasource="#dsn#" name="OtherNotSentSms">
	SELECT 
		CONT_ID,
		CAMPAIGN_SMS_CONT.SMS_BODY AS SUBJECT,
		'Gönder' AS STATUS,
		'SMS' AS CONT_TYPE
	FROM 
		SEND_CONTENTS,
		#dsn3_alias#.CAMPAIGN_SMS_CONT CAMPAIGN_SMS_CONT
	WHERE			
		SEND_CONTENTS.CONT_TYPE = 1
		AND CAMPAIGN_SMS_CONT.SMS_CONT_ID = SEND_CONTENTS.CONT_ID
		AND CAMPAIGN_SMS_CONT.CAMP_ID = #attributes.camp_id#
		AND CAMPAIGN_SMS_CONT.IS_SENT = 1
		<cfif len(cont_ids_sms)>AND CONT_ID NOT IN (#cont_ids_sms#)</cfif>
</cfquery>
<cfquery dbtype="query" name="Results">
	SELECT * FROM Results
	UNION
	SELECT * FROM OtherNotSentEmail
	UNION
	SELECT * FROM OtherNotSentSms
	ORDER BY CONT_TYPE
</cfquery>
<cfquery datasource="#dsn#" name="AnalysisList">
	SELECT 
		ANALYSIS_ID,
		ANALYSIS_HEAD,
		IS_ACTIVE
	FROM 
		MEMBER_ANALYSIS
</cfquery>
<cfloop query="AnalysisList">
	<cfquery datasource="#dsn#" name="AnalysisControl">
		SELECT 
			COUNT(*) AS KONTROL
		FROM 
			MEMBER_ANALYSIS_RESULTS
		WHERE
			ANALYSIS_ID = #ANALYSIS_ID#
		<cfif attributes.type is "con">
			AND CONSUMER_ID = #attributes.user_id#
		<cfelse>
			AND PARTNER_ID IN (
				SELECT 
					PARTNER_ID 
				FROM 
					COMPANY_PARTNER 
				WHERE 
					COMPANY_ID=(
								SELECT COMPANY_ID FROM COMPANY_PARTNER 
								WHERE COMPANY_PARTNER.PARTNER_ID = #attributes.user_id#)
			)
		</cfif>
	</cfquery>
	<cfif AnalysisControl.KONTROL GT 0>
		<cfset temp = QueryAddRow(Results)>
		<cfset temp2 = QuerySetCell(Results,"CONT_ID",ANALYSIS_ID)>
		<cfset temp2 = QuerySetCell(Results,"SUBJECT",ANALYSIS_HEAD)>
		<cfsavecontent variable="message"><cf_get_lang dictionary_id ='33964.Yapıldı'></cfsavecontent>
		<cfset temp2 = QuerySetCell(Results,"STATUS","#message#")>
		<cfset temp2 = QuerySetCell(Results,"CONT_TYPE","ANKET")>
	<cfelse>
		<cfset temp = QueryAddRow(Results)>
		<cfset temp2 = QuerySetCell(Results,"CONT_ID",ANALYSIS_ID)>
		<cfset temp2 = QuerySetCell(Results,"SUBJECT",ANALYSIS_HEAD)>
		<cfsavecontent variable="message1"><cf_get_lang dictionary_id ='33831.Yapılmadı'></cfsavecontent>
		<cfset temp2 = QuerySetCell(Results,"STATUS","#message1#")>
		<cfset temp2 = QuerySetCell(Results,"CONT_TYPE","ANKET")>

	</cfif>

	

</cfloop>
<cfquery datasource="#dsn3#" name="CAMPAING">
	SELECT * FROM CAMPAIGNS WHERE CAMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#camp_id#">
</cfquery>
<cfparam name="attributes.modal_id" default="">
<cfsavecontent variable="title_"><cf_get_lang dictionary_id='58045.İçerikler'> : <cfoutput>#CAMPAING.CAMP_HEAD#</cfoutput></cfsavecontent>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12"> 
	<cf_box id="box_sent_details" title="#title_#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
		<cf_grid_list>
			<thead>
				<tr>
					<th><cf_get_lang dictionary_id='58820.Başlık'></th>
					<th><cf_get_lang dictionary_id='57630.Tip'></th>
					<th width="150"><cf_get_lang dictionary_id='57756.Durum'></th>
				</tr>
			</thead>
			<tbody>
				<cfoutput query="Results">
					<tr>
						<td>
						<cfswitch expression="#CONT_TYPE#">
							<cfcase value="EMAIL">
								<a href="#request.self#?fuseaction=content.list_content&event=det&cntid=#CONT_ID#" >
								<!--- <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=campaign.popup_form_upd_email_cont&email_cont_id=#CONT_ID#&camp_id=#attributes.camp_id#','page');" class="tableyazi"> --->
							</cfcase>
							<cfcase value="SMS">
								<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=campaign.popup_form_upd_sms_cont&sms_cont_id=#CONT_ID#','small');" class="tableyazi">
							</cfcase>
							<cfcase value="ANKET">
								<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=member.analysis_results&analysis_id=#CONT_ID#','large');" class="tableyazi">
							</cfcase>
						</cfswitch>
						#SUBJECT#</a>
						</td>
						<td>#CONT_TYPE#</td>
						<td>
							<cfset name_ = attributes.consumer_name>
							<cfset surname_ = attributes.consumer_surname>
							<cfsavecontent variable="message1"><cf_get_lang dictionary_id ='33831.Yapılmadı'></cfsavecontent>
							<cfif STATUS is "Gönder" or STATUS is "#message1#">
								<cfif CONT_TYPE is "EMAIL"> 
									<div style="border:0!important;" class="ui-form-list-btn flex-start">
										<cfif attributes.type is "con">
											<a href="javascript://" class="ui-wrk-btn ui-wrk-btn-extra ui-wrk-btn-addon-left" style="width:100%;" onclick="openBoxDraggable('#request.self#?fuseaction=campaign.popup_form_send_camp_email&camp_id=#camp_id#&email_cont_id=#CONT_ID#&name=#name_#&surname=#surname_#&email=#attributes.consumer_email#&consumer_id=#url.user_id#');">
											
													<cfif STATUS is "Gönder">
														<cf_get_lang dictionary_id ='58743.Gönder'>
														<cfelse>
															#STATUS#
													</cfif>
													</a>
										<cfelse>
											<a href="javascript://" class="ui-wrk-btn ui-wrk-btn-extra ui-wrk-btn-addon-left" style="width:100%;" onclick="openBoxDraggable('#request.self#?fuseaction=campaign.popup_form_send_camp_email&camp_id=#camp_id#&email_cont_id=#CONT_ID#&name=#name_#&surname=#surname_#&email=#attributes.consumer_email#&partner_id=#url.user_id#','','ui-draggable-box-small');"><i class="fa fa-save" style="color:##FFFFFF!important;"></i>#STATUS#</a>
										</cfif>
									</div>
								</cfif>                    
								<cfif CONT_TYPE is "SMS">
									<div style="border:0!important;" class="ui-form-list-btn flex-start">
										<cfif attributes.type is "con">
											<a href="javascript://" class="ui-wrk-btn ui-wrk-btn-extra ui-wrk-btn-addon-left" style="width:100%;" onclick="windowopen('#request.self#?fuseaction=campaign.popup_form_send_camp_sms&camp_id=#camp_id#&sms_cont_id=#CONT_ID#&name=#attributes.consumer_name#&surname=#attributes.consumer_surname#&sms_code=#attributes.sms_code#&sms_tel=#attributes.sms_tel#&consumer_id=#url.user_id#','small');"><i class="fa fa-phone" style="color:##FFFFFF!important;"></i>#STATUS#</a>
										<cfelse>
											<a href="javascript://" class="ui-wrk-btn ui-wrk-btn-extra ui-wrk-btn-addon-left" style="width:100%;" onclick="windowopen('#request.self#?fuseaction=campaign.popup_form_send_camp_sms&camp_id=#camp_id#&sms_cont_id=#CONT_ID#&name=#attributes.consumer_name#&surname=#attributes.consumer_surname#&sms_code=#attributes.sms_code#&sms_tel=#attributes.sms_tel#&partner_id=#url.user_id#','small');"><i class="fa fa-phone" style="color:##FFFFFF!important;"></i>#STATUS#</a>
										</cfif>
									</div>
								</cfif>
								<cfif CONT_TYPE is "ANKET">
									<div style="border:0!important;" class="ui-form-list-btn flex-start">
										<cfif isdefined("attributes.member_type") and attributes.member_type is 'partner'>
											<a href="javascript://" class="ui-wrk-btn ui-wrk-btn-extra ui-wrk-btn-addon-left" style="width:100%;" onclick="openBoxDraggable('#request.self#?fuseaction=member.popup_add_member_analysis_result&analysis_id=#Results.CONT_ID#&partner_id=#attributes.user_id#&company_id=#attributes.comp_id#&member_type=partner','','ui-draggable-box-large');"><i class="fa fa-question" style="color:##FFFFFF!important;"></i>#STATUS#</a>
										<cfelseif isdefined("attributes.member_type") and attributes.member_type is 'consumer'>	
											<a href="javascript://" class="ui-wrk-btn ui-wrk-btn-extra ui-wrk-btn-addon-left" style="width:100%;" onclick="openBoxDraggable('#request.self#?fuseaction=member.popup_add_member_analysis_result&analysis_id=#Results.CONT_ID#&consumer_id=#attributes.user_id#&member_type=consumer','','ui-draggable-box-large');">#STATUS#</a>
										</cfif>
									</div>
								</cfif>
							<cfelse>
								<a class="ui-btn ui-btn-gray2" onClick('return false;')>#STATUS#</a>
							</cfif>
						</td>
					</tr>
				</cfoutput>
			</tbody>
		</cf_grid_list>
	</cf_box>
</div>
