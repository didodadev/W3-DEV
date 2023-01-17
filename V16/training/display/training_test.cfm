<cfquery name="get_training_quiz_names" datasource="#dsn#">
	SELECT 
		QUIZ_ID, 
		TRAINING_ID, 
		QUIZ_HEAD,
		CLASS_ID,
		QUIZ_STARTDATE,
		QUIZ_FINISHDATE
	FROM 
		QUIZ
	WHERE
		QUIZ_ID IS NOT NULL AND 
		(CLASS_ID = #attributes.class_id# OR 
		QUIZ_ID IN (SELECT QUIZ_ID FROM QUIZ_RELATION WHERE QUIZ_ID IS NOT NULL AND CLASS_ID = #attributes.class_id#))
</cfquery>	
<cf_ajax_list>
	<tbody>
		<cfif get_training_quiz_names.recordcount>
		<cfoutput query="get_training_quiz_names"> 
			<tr height="20"> 
				<td><img src="/images/question_back.gif"  border="0"><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.popup_make_quiz&quiz_id=#quiz_id#&class_id=#attributes.class_id#','medium');" class="tableyazi">#quiz_head#</a></td>
			</tr>
		</cfoutput> 
		  <cfelse>
		  	<tr>
				<td><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</td>
			</tr>
		</cfif>
	</tbody>
</cf_ajax_list>
