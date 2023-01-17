<cfif isDefined("attributes.survey_question_id")>
<cflock name="#CreateUUID()#" timeout="60">
		<cftransaction>
			<!--- sorunun once optionslari silinir --->
			<cfquery name="del_survey_question_options" datasource="#dsn#">
				DELETE FROM SURVEY_OPTION WHERE SURVEY_QUESTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.survey_question_id#"> 
			</cfquery>
			<!--- soru silinir --->
			<cfquery name="del_survey_question" datasource="#dsn#">
				DELETE FROM SURVEY_QUESTION WHERE SURVEY_QUESTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.survey_question_id#"> 
			</cfquery>
		</cftransaction>
	</cflock>
</cfif>
<script type="text/javascript">
	<cflocation 
		url = "#request.self#?fuseaction=settings.list_detail_survey&event=upd&survey_id=#attributes.survey_id#" 
		addToken = "no">
</script>