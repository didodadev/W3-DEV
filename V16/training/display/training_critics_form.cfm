<cfif isdefined('session.ep')><!--- Partner tarafi icin bu kontrole alınmıstir FA kaldirmayın--->
<!--- Eğitim Formları --->
<!---
view_class cfm de get_class dan bilgi geliyor burada tekrar cekmeye gerek yok 20120703 SG
<cfquery name="get_class" datasource="#dsn#">
	SELECT
		*
	FROM
		TRAINING_CLASS
	WHERE
		CLASS_ID IS NOT NULL
	<cfif isDefined("attributes.class_id") and len(attributes.class_id)>
		AND CLASS_ID = #attributes.class_id#
	</cfif>
</cfquery>--->
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
		<cfif (isdefined('session.ep') and (get_class.TRAINER_EMP eq session.ep.userid)) or (isdefined('session.pp') and (get_class.TRAINER_PAR eq session.pp.userid))>
			AND  EQU.IS_EDUCATION=1
		</cfif>
	</cfif>
</cfquery>
	<cfsavecontent variable="trainingtitle"><cf_get_lang no ='132.Eğitim Değerlendirme Formları'></cfsavecontent>
    <cf_box title="#trainingtitle#" closable="0">
		<cfif isdefined('session.ep') and GET_QUIZ.recordcount>
			 <cfoutput query="GET_QUIZ"> 
			 <cfquery name="GET_TRAINING_PERF" datasource="#dsn#">
				SELECT
					TRAINING_PERFORMANCE_ID,
					CLASS_ID,
					USER_POINT,
					PERFORM_POINT,
					TRAINING_DETAIL
				FROM 
					TRAINING_PERFORMANCE
				WHERE
					TRAINING_QUIZ_ID = #GET_QUIZ.quiz_id# AND
					ENTRY_EMP_ID = #session.ep.userid# AND
					CLASS_ID = #attributes.class_id#
			</cfquery>
			<cfif GET_TRAINING_PERF.recordcount>
			   <table>
				 <tr class="color-row">
					<td width="150">#QUIZ_HEAD#</td>
					<td width="15"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.popup_form_upd_training_performance&class_id=#attributes.class_id#&quiz_id=#QUIZ_ID#','medium');"><img  src="images/transfer.gif" border="0" title="<cf_get_lang_main no='350.formu doldur'>"></a></td>
				  </tr>
			   </table>
			<cfelse>
			<table>
				<tr>
					<td width="150">
					#QUIZ_HEAD#
					</td>
					<td width="15"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.popup_form_add_training_performance&quiz_id=#QUIZ_ID#&employee_id=#session.ep.userid#&class_id=#attributes.CLASS_ID#','page')"><img src="/images/plus_list.gif" title="<cf_get_lang no='503.Formu Doldur'>" border="0" align="absmiddle"></a></td>
				</tr>
			</table>
			</cfif>
		</cfoutput>
		<cfelse>
			 <cf_get_lang_main no='72.Kayıt Bulunamadı'>! 
		</cfif>
        </cf_box>	
</cfif>
<!--- Eğitm Formları --->

