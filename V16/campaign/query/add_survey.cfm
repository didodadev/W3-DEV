<cfif len(attributes.view_date_start)><cf_date tarih="attributes.view_date_start"></cfif>
<cfif len(attributes.view_date_finish)><cf_date tarih="attributes.view_date_finish"></cfif>
<cflock name="#CreateUUID()#" timeout="20">
	<cftransaction>
		<cfquery name="ADD_SURVEY" datasource="#DSN#" result="MAX_ID">
			INSERT INTO
				SURVEY
			(
				SURVEY,
				SURVEY_HEAD,
				DETAIL,
				ANSWER_NUMBER,
				SURVEY_GUEST,
				<cfif isDefined("survey_partners")>
					SURVEY_PARTNERS,
				</cfif>
				<cfif isDefined("survey_consumers")>
					SURVEY_CONSUMERS,
				</cfif>
				<cfif isDefined("survey_departments")>
					SURVEY_DEPARTMENTS,
				</cfif>
				<cfif isDefined("attributes.survey_our_comp")>
					SURVEY_OUR_COMP,
				</cfif>
				<cfif isdefined("campaign_product_id") and len(campaign_product_id)>
					PRODUCT_ID,
				</cfif>
				STAGE_ID,
				SURVEY_STATUS,
				VIEW_DATE_START,
				VIEW_DATE_FINISH,
				RECORD_DATE,
				RECORD_IP,
				RECORD_EMP,
				SURVEY_TYPE,
				CAREER_VIEW
			)
			VALUES
			(
				'#survey#',
				'#survey_head#',
				'#detail#',
				#attributes.answer_number#,
				<cfif isDefined("survey_guest")>1<cfelse>0</cfif>,
				<cfif isDefined("survey_partners")>
                    ',#survey_partners#,',
                </cfif>
                <cfif isDefined("survey_consumers")>
                    ',#survey_consumers#,',
                </cfif>
                <cfif isDefined("survey_departments")>
                    ',#survey_departments#,',
                </cfif>
                <cfif isDefined("attributes.survey_our_comp")>
                    ',#survey_our_comp#,',
                </cfif>
                <cfif isdefined("campaign_product_id") and len(campaign_product_id)>
                    #campaign_product_id#,
                </cfif>
				#attributes.process_stage#,
				<cfif isDefined("form.survey_status")>1<cfelse>0</cfif>,
				<cfif len(attributes.view_date_start)>#attributes.view_date_start#<cfelse>NULL</cfif>,
				<cfif len(attributes.view_date_finish)>#attributes.view_date_finish#<cfelse>NULL</cfif>,
				#NOW()#,
				'#CGI.REMOTE_ADDR#',
				#session.ep.userid#,
				#attributes.survey_type#,
				<cfif isdefined("attributes.career_view")>1<cfelse>0</cfif>
			)
		</cfquery>
		<cfloop from="1" to="#evaluate(attributes.answer_number)#" index="I">
			<cfset icerik_ = evaluate("answer#evaluate(i-1)#_text")>
			<cfquery name="ADD_SURVEY_ALT" datasource="#DSN#">
				INSERT INTO
					SURVEY_ALTS
				(
					SURVEY_ID,
					ALT,
                    VOTE_COUNT
				)
				VALUES
				(
					#MAX_ID.IDENTITYCOL#,
					'#icerik_#',
                    0
				)
			</cfquery>
		</cfloop>
	</cftransaction>
</cflock>
<cfif isdefined('attributes.camp_id')>
	<cfquery name="ADD_CAMPAIGN_SURVEYS" datasource="#DSN3#">
		INSERT INTO
			CAMPAIGN_SURVEYS
			(
				CAMP_ID,
				SURVEY_ID
			)
			VALUES
			(
				#attributes.camp_id#,
				#MAX_ID.IDENTITYCOL#
			)
	</cfquery>
    <cfset attributes.actionId = attributes.camp_id>
    <script type="text/javascript">
		window.location.href = '<cfoutput>#request.self#?fuseaction=campaign.list_campaign&event=upd&camp_id=#attributes.camp_id#</Cfoutput>';
	</script>
<cfelse>
	<cfset attributes.actionId = MAX_ID.IDENTITYCOL>
	<script type="text/javascript">
		window.location.href = '<cfoutput>#request.self#?fuseaction=campaign.list_survey&event=upd&camp_id=#MAX_ID.IDENTITYCOL#</Cfoutput>';
	</script>
</cfif>
