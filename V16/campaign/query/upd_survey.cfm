<cfif len(attributes.view_date_start)><cf_date tarih="attributes.view_date_start"></cfif>
<cfif len(attributes.view_date_finish)><cf_date tarih="attributes.view_date_finish"></cfif>
<cfquery name="GET_ALT_IDS" datasource="#DSN#">
	SELECT
		ALT_ID
	FROM
		SURVEY_ALTS
	WHERE
		SURVEY_ID = #SURVEY_ID#	
</cfquery>
<cfset OLD_ALTS = VALUELIST(GET_ALT_IDS.ALT_ID)>
<cfquery name="UPD_SURVEY" datasource="#DSN#">
	UPDATE
		SURVEY
	SET
		SURVEY_HEAD = '#attributes.survey_head#',
		SURVEY = '#attributes.survey#',
		DETAIL = '#attributes.detail#',
		ANSWER_NUMBER = #attributes.answer_number#,
		SURVEY_GUEST = <cfif isDefined("SURVEY_GUEST")>1<cfelse>0</cfif>,
		SURVEY_PARTNERS = <cfif isDefined("SURVEY_PARTNERS")>',#attributes.survey_partners#,'<cfelse>NULL</cfif>,
		SURVEY_CONSUMERS = <cfif isDefined("SURVEY_CONSUMERS")>',#attributes.survey_consumers#,'<cfelse>NULL</cfif>,
		SURVEY_DEPARTMENTS = <cfif isDefined("SURVEY_DEPARTMENTS")>',#attributes.SURVEY_DEPARTMENTS#,'<cfelse>NULL</cfif>,
		SURVEY_OUR_COMP = <cfif isDefined("attributes.survey_our_comp")>',#attributes.survey_our_comp#,'<cfelse>NULL</cfif>,
		<cfif isDefined("attributes.campaign_product_id") and len(attributes.campaign_product_id)>PRODUCT_ID = #attributes.campaign_product_id#,</cfif>
		STAGE_ID =  #attributes.process_stage#,
		SURVEY_STATUS = <cfif isDefined("FORM.SURVEY_STATUS")>1<cfelse>0</cfif>,
		VIEW_DATE_START = <cfif len(attributes.view_date_start)>#attributes.view_date_start#<cfelse>NULL</cfif>,
		VIEW_DATE_FINISH = <cfif len(attributes.view_date_finish)>#attributes.view_date_finish#<cfelse>NULL</cfif>,
		SURVEY_TYPE = #attributes.SURVEY_TYPE#,
		CAREER_VIEW = <cfif isdefined("attributes.career_view")>1<cfelse>0</cfif>,
		UPDATE_IP = '#CGI.REMOTE_ADDR#',
		UPDATE_EMP = #SESSION.EP.USERID#,
		UPDATE_DATE = #NOW()#		
	WHERE
		SURVEY_ID = #SURVEY_ID#
</cfquery>
<cfloop from="0" to="#EVALUATE(ANSWER_NUMBER-1)#" index="I">
	<cfif listlen(old_alts) gt i>
		<cfset icerik_ = EVALUATE("ANSWER"&I&"_TEXT")>
		<cfquery name="UPD_SURVEY_ALT" datasource="#DSN#">
			UPDATE
				SURVEY_ALTS
			SET
				ALT = '#icerik_#'
			WHERE
				ALT_ID = #LISTGETAT(OLD_ALTS,I+1)#
		</cfquery>
	<cfelse>
		<cfset icerik_ = EVALUATE("ANSWER"&I&"_TEXT")>
		<cfquery name="UPD_SURVEY_ALT" datasource="#DSN#">
			INSERT INTO
				SURVEY_ALTS
			(
				SURVEY_ID,
				ALT
			)
			VALUES
			(
				#SURVEY_ID#,
				'#icerik_#'
			)
		</cfquery>
	</cfif>
</cfloop>
<cfif listlen(old_alts) gt answer_number>
	<cfloop from="1" to="#evaluate(ANSWER_NUMBER)#" index="j">
		<cfset old_alts = listdeleteat(old_alts,1)>
	</cfloop>
	<!--- iptal edilen şıkları sil --->
	<cfif len(old_alts)>
		<cfquery name="CLEAN_OLDS" datasource="#DSN#">
			DELETE	FROM
				SURVEY_ALTS
			WHERE
				ALT_ID IN (#OLD_ALTS#)
		</cfquery>
	</cfif>
</cfif>
<cfset attributes.actionId = survey_id>
<script type="text/javascript">
	window.location.href = '<cfoutput>#request.self#?fuseaction=campaign.list_survey&event=upd&survey_id=#survey_id#</cfoutput>';
</script>