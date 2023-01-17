<cf_box scroll="1" collapsable="0" resize="0" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
    <cfloop from="1" to="#listlen(attributes.id_list)#" index="i">
        <cfset QUIZ_ID = listfirst(listgetat(attributes.id_list,i,','),';')>
        <cfset QUESTION_ID = listlast(listgetat(attributes.id_list,i,','),';')>
        <cfquery name="GET_question2quiz" datasource="#dsn#">
            SELECT
                QUESTION_ID
            FROM
                QUIZ_QUESTIONS
            WHERE
                QUIZ_ID=#QUIZ_ID#
            AND
                QUESTION_ID=#QUESTION_ID#
        </cfquery>
        
        <cfif NOT GET_question2quiz.RecordCount>
            <cfquery name="add_question2quiz" datasource="#dsn#">
                INSERT INTO
                    QUIZ_QUESTIONS
                    (
                    QUIZ_ID,
                    QUESTION_ID
                    )
                VALUES
                    (
                    #QUIZ_ID#,
                    #QUESTION_ID#
                    )
            </cfquery>
        </cfif>
    </cfloop>
</cf_box>
<script>
	<cfif not isdefined("attributes.draggable")>
		wrk_opener_reload();
		window.close();
        <cflocation url="#request.self#?fuseaction=training_management.list_quizs&event=det&quiz_id=#attributes.quiz_id#" addtoken="no">
	<cfelseif isdefined("attributes.draggable")>
		closeBoxDraggable( 'add_question_to_quiz');
		$("#list_quiz_questions .catalyst-refresh").click();
	</cfif>
</script>