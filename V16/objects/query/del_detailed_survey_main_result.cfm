<cfquery name="del_main_result" datasource="#dsn#">
	DELETE FROM SURVEY_MAIN_RESULT WHERE SURVEY_MAIN_RESULT_ID = #attributes.result_id#
</cfquery>
<cfquery name="del_question_result" datasource="#dsn#">
	DELETE FROM SURVEY_QUESTION_RESULT WHERE SURVEY_MAIN_RESULT_ID = #attributes.result_id#
</cfquery>
<script type="text/javascript">
	wrk_opener_reload();
	<cfif fuseaction contains 'objects'>
		<cfif not isdefined("attributes.draggable")>location.href = document.referrer;<cfelse>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>');</cfif>
	</cfif>
</script>
<cfif fuseaction contains 'objects'>
<cfelse>
	<cflocation addtoken="no" url="#request.self#?fuseaction=settings.list_participants&survey_id=#attributes.survey_id#&result_id=#attributes.result_id#"> 
</cfif>
