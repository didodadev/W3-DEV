<cfsetting showdebugoutput="no">
<cfinclude template="../query/get_class.cfm">
<table cellspacing="0" cellpadding="0" border="0" width="100%">
	<cfquery name="GET_QUIZ" datasource="#DSN#">
			SELECT
				DISTINCT
				EQU.QUIZ_ID,
				EQU.QUIZ_HEAD
				<cfif not isdefined("attributes.class_ids")>
				,TCQ.TRAINING_QUIZ_ID
				</cfif>
			FROM
				TRAINING_CLASS_QUIZES TCQ,
				EMPLOYEE_QUIZ EQU 
			WHERE
				EQU.QUIZ_ID=TCQ.QUIZ_ID
				<cfif isdefined("attributes.class_ids")>
				AND
				TCQ.CLASS_ID IN (#attributes.class_ids#)
				<cfelse>
				AND
				TCQ.CLASS_ID=#attributes.class_id#
				</cfif>
				<cfif get_class.recordcount><!--- Eğer sisteme giren eğitimci ise eğitimci için oluşturulmuş formları göremez.. --->
				<cfif (get_class.TRAINER_EMP eq session.ep.userid)>
				AND  EQU.IS_EDUCATION=1
			</cfif>
			</cfif>	 
	</cfquery>
	<cfif GET_QUIZ.recordcount>
		<cfoutput query="GET_QUIZ">
		<tr class="color-row">
		<td><a href="#request.self#?fuseaction=training_management.dsp_eval_quiz&quiz_id=#QUIZ_ID#" class="tableyazi" >#QUIZ_HEAD#</a></td>
		<td width="15"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=training_management.popup_form_add_class_eval&class_id=#attributes.class_id#&quiz_id=#QUIZ_ID#','medium');"><img  src="images/transfer.gif" border="0" title="<cf_get_lang_main no='350.formu doldur'>"></a></td>
		<cfsavecontent variable="delete_message"><cf_get_lang_main no ='121.Silmek istediğinize emin misiniz'></cfsavecontent>
		<td width="15"><a href="javascript://" onClick="if(confirm('#delete_message#')) windowopen('#request.self#?fuseaction=training_management.emptypopup_del_eval_train_quizes&training_quiz_id=#TRAINING_QUIZ_ID#&class_id=#attributes.class_id#&quiz_id=#QUIZ_ID#','small');"><img  src="images/delete_list.gif" border="0" title="<cf_get_lang_main no='51.sil'>"></a></td>
		</tr>
		</cfoutput> 
	<cfelse>
		<tr class="color-row">
		<td colspan="3">&nbsp;<cf_get_lang_main no='72.Kayıt Bulunamadı'>!</td>
		</tr>							
	</cfif>
</table>
