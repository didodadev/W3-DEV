<cfsetting showdebugoutput="no">
<cfinclude template="../query/get_quiz_relation.cfm">
<cfif get_quiz_relation.recordcount>
<cfset quiz_id_list = listsort(valuelist(get_quiz_relation.quiz_id,','),"numeric","ASC",',')>
<cfelse>
	<cfset quiz_id_list = "">
</cfif>
<cfquery name="GET_TRAINING_QUIZ_NAMES" datasource="#dsn#">
	SELECT 
		Q.QUIZ_ID, 
		Q.TRAINING_ID, 
		Q.QUIZ_HEAD,
		QR.CLASS_ID,
		Q.QUIZ_STARTDATE,
		Q.QUIZ_FINISHDATE
	FROM 
		QUIZ Q,
		QUIZ_RELATION QR
	WHERE
		Q.QUIZ_ID = QR.QUIZ_ID AND
		Q.QUIZ_ID IS NOT NULL
		<!--- <cfif len(quiz_id_list)>
			AND (QR.CLASS_ID = #attributes.class_id# OR Q.QUIZ_ID IN (#quiz_id_list#))
		<cfelse> --->
			AND QR.CLASS_ID = #attributes.class_id#
		<!--- </cfif> --->
</cfquery>
<cfif get_quiz_relation.recordcount>
	<cfset quiz_id_list = listsort(valuelist(get_quiz_relation.quiz_id,','),"numeric","ASC",',')>
<cfelse>
	<cfset quiz_id_list = "">
</cfif>
<cf_ajax_list>
	<cfif (get_training_quiz_names.recordcount neq 0) or (get_quiz_relation.recordcount neq 0)>
		<cfif get_training_quiz_names.recordcount>
			<cfoutput query="get_training_quiz_names"> 
				<tr>	
					<td><img src="/images/tree_1.gif" border="0"><a href="#request.self#?fuseaction=training_management.list_quizs&event=det&quiz_id=#quiz_id#&class_id=#attributes.class_id#" class="tableyazi">#quiz_head#</a></td>
						<!--- <td width="15" align="right"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=training_management.popup_list_class_quiz_attender&class_id=#attributes.class_id#&quiz_id=#quiz_id#','medium');"><img src="images/transfer.gif" border="0" alt="testi cevapla"></a></td>--->
						<cfsavecontent variable="delete_message"><cf_get_lang_main no ='121.Silmek istediğinize emin misiniz'></cfsavecontent>
					<td width="30" style="text-align:right;"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=training_management.popup_list_class_quiz_attender&class_id=#attributes.class_id#&quiz_id=#quiz_id#','medium');"><img src="images/transfer.gif" border="0" title="<cf_get_lang no ='513.testi cevapla'>"></a><a href="javascript://" onClick="if(confirm('#delete_message#')) windowopen('#request.self#?fuseaction=training_management.emptypopup_del_class_quiz&training_id=#training_id#&class_id=#attributes.class_id#&quiz_id=#quiz_id#','small');"><img  src="images/delete_list.gif" border="0" title="<cf_get_lang no ='512.testi sil'>"></a></td>
				</tr>
			</cfoutput> 
		</cfif>
	<cfelseif (get_training_quiz_names.recordcount EQ 0)>
		<tr><td><cfoutput>#getlang('main',72,'kayit yok')#</cfoutput> !</td></tr>
	</cfif>
</cf_ajax_list>
