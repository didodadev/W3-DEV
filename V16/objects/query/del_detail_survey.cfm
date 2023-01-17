<!--- form generator form silme SG 20121010--->
<cfset cfc=createObject("component","V16.training_management.cfc.training_survey")> 
<!--- şık seçenekleri siliniyor--->
<cfset del_survey_option=cfc.DelSurveyOption(survey_main_id:attributes.survey_main_id)> 
<!--- bölümler siliniyor ---->
<cfset del_survey_chapter=cfc.DelSurveyChapter(survey_main_id:attributes.survey_main_id)>
<!--- sorular siliniyor ---->
<cfset del_survey_question=cfc.DelSurveyQuestion(survey_main_id:attributes.survey_main_id)>
<!--- ilişkili alanlar siliniyor ---->
<cfset del_survey_relation=cfc.DelSurveyRelation(survey_main_id:attributes.survey_main_id)>
<!--- form siliniyor ---->
<cfset del_survey_main=cfc.DelSurveyMain(survey_main_id:attributes.survey_main_id)>
<cfif fuseaction contains 'objects'>
	<!---
	<script type="text/javascript">
		wrk_opener_reload();
		window.close();
	</script>
	--->
    <script type="text/javascript">
    	window.location.href="<cfoutput>#request.self#?fuseaction=settings.list_detail_survey</cfoutput>";
    </script>
<cfelse>
	<script type="text/javascript">
    	window.location.href="<cfoutput>#request.self#?fuseaction=settings.list_detail_survey</cfoutput>";
    </script>
</cfif>