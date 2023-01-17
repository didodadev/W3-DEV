<CFTRANSACTION>
	<cfquery name="get_emp_att" datasource="#dsn#"><!--- İlgili Dersin Katılımcıları Geliyor. --->
	  SELECT EMP_ID FROM TRAINING_CLASS_ATTENDER WHERE CLASS_ID=#attributes.CLASS_ID# AND EMP_ID IS NOT NULL AND PAR_ID IS NULL AND CON_ID IS NULL
	</cfquery>
	<cfloop query="get_emp_att">
	<cfset attributes.emp_id = get_emp_att.EMP_ID>
		<cfquery name="GET_QUIZ_RESULT" datasource="#dsn#">
			SELECT
				CLASS_EVAL_ID
			FROM
				TRAINING_CLASS_EVAL
			WHERE
				EMP_ID=#attributes.emp_id#
				AND
				QUIZ_ID = #attributes.QUIZ_ID#
				AND
				CLASS_ID = #attributes.CLASS_ID#
		</cfquery>	
	<cfif GET_QUIZ_RESULT.RECORDCOUNT>
		<cfset RESULTID = GET_QUIZ_RESULT.CLASS_EVAL_ID> 
		<cfquery name="GET_RESULT_ID" datasource="#dsn#"><!--- İlgili Dersin detayları siliniyor. --->
			DELETE FROM
				TRAINING_CLASS_EVAL_DETAILS
			WHERE
				CLASS_EVAL_ID = #RESULTID#
		</cfquery>

<!--- form sonuç kaydı --->
	<!--- kağıdı gönder --->
 	<!--- <cfquery name="ADD_RESULT" datasource="#dsn#">
		UPDATE
			TRAINING_CLASS_EVAL
		SET
			QUIZ_ID = #attributes.QUIZ_ID#,
			EMP_ID = #attributes.EMP_ID#,
			UPDATE_DATE = #now()#,
			UPDATE_EMP = #session.ep.userid#,
			UPDATE_IP = #cgi.REMOTE_ADDR#
		WHERE
			CLASS_EVAL_ID = #RESULTID#
	</cfquery> --->
		<cfinclude template="../query/get_training_eval_quiz_chapters.cfm"><!--- İlgili sorunun tüm bilgileri geliyor. --->
			<cfset puan = 0>
				<cfloop query="get_quiz_chapters">
				<cfset attributes.CHAPTER_ID = get_quiz_chapters.CHAPTER_ID>
				<cfinclude template="../query/get_training_eval_quiz_questions.cfm"><!--- İlgili sorunu detayları şıkları vs.  --->
					<cfloop query="get_quiz_questions">
						
						<cfset formdaki_puan = 'FORM.USER_ANSWER_'&get_quiz_chapters.currentrow&'_'&get_quiz_questions.currentrow&'_'&attributes.emp_id>
						
						<cfif IsDefined("#formdaki_puan#") AND IsNumeric(Evaluate(formdaki_puan))>
							<cfset puan = puan + Evaluate(formdaki_puan)>
						</cfif>
						<cfoutput>puan+++#puan#</cfoutput><br/>
			<!--- 				<cfset puan = puan + #ListGetAt(
							EVALUATE('FORM.USER_ANSWER_'&get_quiz_chapters.currentrow&'_'&get_quiz_questions.currentrow&'_POINT'), 
							EVALUATE('FORM.USER_ANSWER_'&get_quiz_chapters.currentrow&'_'&get_quiz_questions.currentrow))#>
								
								#ListGetAt(EVALUATE("FORM.USER_ANSWER_"&get_quiz_chapters.currentrow&"_"&get_quiz_questions.currentrow&"_POINT"), 
								EVALUATE("FORM.USER_ANSWER_"&get_quiz_chapters.currentrow&"_"&get_quiz_questions.currentrow))#
	 --->				<cfquery name="ADD_RESULT_DETAIL" datasource="#dsn#">
							INSERT INTO
								TRAINING_CLASS_EVAL_DETAILS
								(
								CLASS_EVAL_ID,
								QUESTION_ID,
								
								QUESTION_POINT
								)
							VALUES
								(
								#RESULTID#,
								#GET_QUIZ_QUESTIONS.QUESTION_ID#,
								
								<cfif IsDefined("#formdaki_puan#") AND IsNumeric(Evaluate(formdaki_puan))>
									#Evaluate(formdaki_puan)#
								<cfelse>
									0
								</cfif>
								)
						</cfquery>
				</cfloop> 
			<!--- </cfif> --->
		</cfloop> <cfoutput>puan#puan#</cfoutput><br/>

	<!--- // kağıdı gönder --->
	<!--- <cfif not isDefined("form.open_question")>
			<cfoutput> 
				<cfset puan = 0>
				<cfloop query="get_quiz_questions">
					question_id#question_id# =	#EVALUATE("FORM.USER_ANSWER_#CURRENTROW#")#<br/>
					<cfloop list="#EVALUATE("FORM.USER_ANSWER_#CURRENTROW#")#" index="aa">
					#aa#-#ListGetAt(EVALUATE("FORM.user_answer_#currentrow#_point"), aa)#<br/>
					<cfset puan = puan + #ListGetAt(EVALUATE("FORM.user_answer_#currentrow#_point"), aa)#>
					</cfloop>
				</cfloop>
				 puan = #puan# 
			 </cfoutput>  --->
		<!--- sonucu veritabanına gönder --->
		 <cfquery name="UPD_RESULT" datasource="#dsn#">
			UPDATE
				TRAINING_CLASS_EVAL
			SET
				USER_POINT = #puan#,
				QUIZ_ID = #attributes.QUIZ_ID#,
				EMP_ID = #attributes.emp_id#,
				IS_UNNAMED = #Evaluate('attributes.IS_UNNAMED_'&attributes.emp_id)#,
				UPDATE_DATE = #now()#,
				UPDATE_EMP = #session.ep.userid#,
				UPDATE_IP = '#cgi.REMOTE_ADDR#'
			WHERE
				CLASS_EVAL_ID = #RESULTID#
		</cfquery> 
	</cfif>
	</cfloop> 
	<!--- </cfif> --->
<!--- //form sonuç kaydı --->
 
</CFTRANSACTION>
<script type="text/javascript">
window.close();
</script>
<!--- <cfquery name="UPD_CLASS_EVAL" datasource="#dsn#">
	UPDATE
		TRAINING_CLASS_EVAL
	SET
		ISE_KATKI=<cfif IsDefined("attributes.ISE_KATKI")>#attributes.ISE_KATKI#,<cfelse>NULL,</cfif>
		MESAJ_ACIK=<cfif IsDefined("attributes.MESAJ_ACIK")>#attributes.MESAJ_ACIK#,<cfelse>NULL,</cfif>
		DERIN_BILGI=<cfif IsDefined("attributes.DERIN_BILGI")>#attributes.DERIN_BILGI#,<cfelse>NULL,</cfif>
		ORNEK_YETERLI=<cfif IsDefined("attributes.ORNEK_YETERLI")>#attributes.ORNEK_YETERLI#,<cfelse>NULL,</cfif>
		ICERIGE_UYGUN=<cfif IsDefined("attributes.ICERIGE_UYGUN")>#attributes.ICERIGE_UYGUN#,<cfelse>NULL,</cfif>
		MATERYAL_KOLAYLASTIRDI=<cfif IsDefined("attributes.MATERYAL_KOLAYLASTIRDI")>#attributes.MATERYAL_KOLAYLASTIRDI#,<cfelse>NULL,</cfif>
		SURE_YETERLI=<cfif IsDefined("attributes.SURE_YETERLI")>#attributes.SURE_YETERLI#,<cfelse>NULL,</cfif>
		KAVRAM_ACIK=<cfif IsDefined("attributes.KAVRAM_ACIK")>#attributes.KAVRAM_ACIK#,<cfelse>NULL,</cfif>
		ANLATIM_ORNEKLI=<cfif IsDefined("attributes.ANLATIM_ORNEKLI")>#attributes.ANLATIM_ORNEKLI#,<cfelse>NULL,</cfif>
		TATMINLI_YANITLAR=<cfif IsDefined("attributes.TATMINLI_YANITLAR")>#attributes.TATMINLI_YANITLAR#,<cfelse>NULL,</cfif>
		ZAMAN_IYI=<cfif IsDefined("attributes.ZAMAN_IYI")>#attributes.ZAMAN_IYI#,<cfelse>NULL,</cfif>
		YOL_GOSTERICI=<cfif IsDefined("attributes.YOL_GOSTERICI")>#attributes.YOL_GOSTERICI#,<cfelse>NULL,</cfif>
		TAVIR_TUTARLI=<cfif IsDefined("attributes.TAVIR_TUTARLI")>#attributes.TAVIR_TUTARLI#,<cfelse>NULL,</cfif>
		TARAFSIZ_DAVRANIS=<cfif IsDefined("attributes.TARAFSIZ_DAVRANIS")>#attributes.TARAFSIZ_DAVRANIS#,<cfelse>NULL,</cfif>
		KATILIMI_TESVIK=<cfif IsDefined("attributes.KATILIMI_TESVIK")>#attributes.KATILIMI_TESVIK#,<cfelse>NULL,</cfif>
		YARDIMCI_ARACLAR=<cfif IsDefined("attributes.YARDIMCI_ARACLAR")>#attributes.YARDIMCI_ARACLAR#,<cfelse>NULL,</cfif>
		ISTE_UYGULANABILIR=<cfif IsDefined("attributes.ISTE_UYGULANABILIR")>#attributes.ISTE_UYGULANABILIR#,<cfelse>NULL,</cfif>
		IS_DAHA_IYI=<cfif IsDefined("attributes.IS_DAHA_IYI")>#attributes.IS_DAHA_IYI#,<cfelse>NULL,</cfif>
		DIGERLERINE_KATILIRIM=<cfif IsDefined("attributes.DIGERLERINE_KATILIRIM")>#attributes.DIGERLERINE_KATILIRIM#,<cfelse>NULL,</cfif>
		EGITIMI_ONERIRIM=<cfif IsDefined("attributes.EGITIMI_ONERIRIM")>#attributes.EGITIMI_ONERIRIM#,<cfelse>NULL,</cfif>
		BUYUKLUK_UYGUN=<cfif IsDefined("attributes.BUYUKLUK_UYGUN")>#attributes.BUYUKLUK_UYGUN#,<cfelse>NULL,</cfif>
		SICAKLIK_UYGUN=<cfif IsDefined("attributes.SICAKLIK_UYGUN")>#attributes.SICAKLIK_UYGUN#,<cfelse>NULL,</cfif>
		HAVALANDIRMA_YETERLI=<cfif IsDefined("attributes.HAVALANDIRMA_YETERLI")>#attributes.HAVALANDIRMA_YETERLI#,<cfelse>NULL,</cfif>
		EGITIM_TATMIN_EDICI=<cfif IsDefined("attributes.EGITIM_TATMIN_EDICI")>#attributes.EGITIM_TATMIN_EDICI#,<cfelse>NULL,</cfif>
		EGITIMCI_TATMIN_EDICI=<cfif IsDefined("attributes.EGITIMCI_TATMIN_EDICI")>#attributes.EGITIMCI_TATMIN_EDICI#,<cfelse>NULL,</cfif>
		ORTAM_MEMNUN_EDICI=<cfif IsDefined("attributes.ORTAM_MEMNUN_EDICI")>#attributes.ORTAM_MEMNUN_EDICI#,<cfelse>NULL,</cfif>
		DIGERLERIN_ILGISI_YETERLI=<cfif IsDefined("attributes.DIGERLERIN_ILGISI_YETERLI")>#attributes.DIGERLERIN_ILGISI_YETERLI#,<cfelse>NULL,</cfif>

		OTHER_NOTES='#attributes.OTHER_NOTES#',

		UPDATE_DATE=#now()#,
		UPDATE_IP='#CGI.REMOTE_ADDR#',
		UPDATE_EMP=#SESSION.EP.USERID#
	WHERE
		CLASS_ID=#attributes.CLASS_ID#
		AND
		EMP_ID=#attributes.employee_id#
</cfquery>	

<cflocation addtoken="no" url="#request.self#?fuseaction=training_management.popup_list_class_eval&class_id=#attributes.class_id#"> --->
