<cfset cfc= createObject("component","V16.training_management.cfc.TrainingTest")>
<cfset GET_RESULTS=cfc.GET_QUIZ_RESULTS_FUNC(QUIZ_ID:url.quiz_id)>
<cfset result_quiz_list = valuelist(get_results.result_id)>
<cfset DEL_QUESTIONS=cfc.DEL_QUESTION_FUNC(QUIZ_ID:url.quiz_id,relation_status:1,result_quiz_list:result_quiz_list,del_result_status:1,del_quiz_status:1)>
<!---
<cflocation url="#request.self#?fuseaction=training_management.list_quizs" addtoken="no">
--->
<script>
	window.location.href = "<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_quizs</cfoutput>";
</script>