<cfquery name="GET_CAMP_SURVEY" datasource="#DSN#">
	SELECT 
		SURVEY.SURVEY_ID,
		SURVEY.SURVEY
	FROM 
		#dsn3_alias#.CAMPAIGN_SURVEYS,
		SURVEY
	WHERE 
		SURVEY.SURVEY_ID = CAMPAIGN_SURVEYS.SURVEY_ID AND
		CAMPAIGN_SURVEYS.CAMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.camp_id#"> AND
		(#NOW()# BETWEEN SURVEY.VIEW_DATE_START AND SURVEY.VIEW_DATE_FINISH)	
</cfquery>
<cfif get_camp_survey.recordcount>
	<table cellspacing="1" cellpadding="2" style="width:100%;">
		  <cfoutput query="get_camp_survey">
			<tr>
			  <td><a href="#request.self#?fuseaction=objects2.poll&poll_id=#survey_id#" class="tableyazi">#survey#</a><br/></td>
			</tr>
		  </cfoutput>
	</table>
</cfif>

