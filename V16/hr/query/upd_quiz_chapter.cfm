<cfinclude template="../query/get_quiz_chapter.cfm">
	<cfif attributes.answer_number neq 0>
		<cfset upload_folder = "#upload_folder#hr#dir_seperator#">
		<cfloop from="0" to="#evaluate(attributes.answer_number-1)#" index="i">
			<cfif len(evaluate("GET_QUIZ_CHAPTER.ANSWER"&evaluate(i+1)&"_photo"))>
			
				<cfif len(evaluate("attributes.ANSWER"&i&"_photo"))>
				<!--- eskiyi sil yeniyi koy --->
					<!--- <cftry>
						<cffile action="DELETE" file="#upload_folder##evaluate(".ANSWER"&evaluate(i+1)&"_photo")#">
						<cfcatch type="Any">
							<cfoutput>attributes.ANSWER#i#_photo => Dosya bulunamadı ama veritabanından silindi ! 1<br/></cfoutput>
						</cfcatch>
					</cftry> --->
					<cf_del_server_file output_file="hr/#evaluate("GET_QUIZ_CHAPTER.ANSWER"&evaluate(i+1)&"_photo")#" output_server="#evaluate("GET_QUIZ_CHAPTER.ANSWER"&evaluate(i+1)&"_photo_server_id")#">
				<cftry>
					<cffile 
						action="UPLOAD" 
						filefield="answer#i#_photo" 
						destination="#upload_folder#" 
						mode="777" nameconflict="MAKEUNIQUE" accept="image/*">
					<cfcatch type="Any">
						<script type="text/javascript">
							alert("<cf_get_lang_main no ='43.Dosyanız upload edilemedi ! Dosyanızı kontrol ediniz'> !");
							history.back();
						</script>
					</cfcatch>  
				</cftry>

				<cfset file_name = createUUID()>
				<cffile action="rename" source="#upload_folder##cffile.serverfile#" destination="#upload_folder##file_name#.#cffile.serverfileext#">
				<cfset "attributes.ANSWER#i#_photo" = '#file_name#.#cffile.serverfileext#'>

				<cfelse>
					<cfif isdefined("attributes.del_image#i#")>
						<!--- eski sil --->
						<!--- <cftry>
							<cffile action="DELETE" file="#upload_folder##evaluate("GET_QUIZ_CHAPTER.ANSWER"&evaluate(i+1)&"_photo")#">
							<cfset "attributes.ANSWER#i#_photo" = "">
							<cfcatch type="Any">
								<cfset "attributes.ANSWER#i#_photo" = "">
								<cfoutput>attributes.ANSWER#i#_photo => Dosya bulunamadı ama veritabanından silindi ! 2<br/></cfoutput>
							</cfcatch>
						</cftry> --->
				<cf_del_server_file output_file="hr/#evaluate("GET_QUIZ_CHAPTER.ANSWER"&evaluate(i+1)&"_photo")#" output_server="#evaluate("GET_QUIZ_CHAPTER.ANSWER"&evaluate(i+1)&"_photo_server_id")#">
					<cfelse>

						<cfset "attributes.ANSWER#i#_photo" = evaluate("GET_QUIZ_CHAPTER.ANSWER"&evaluate(i+1)&"_photo")>

					</cfif>
				</cfif>
			<cfelse>

				<cfif len(evaluate("attributes.ANSWER"&i&"_photo"))>
				<!--- yeniyi koy --->
				<cftry>
					<cffile 
						action="UPLOAD" 
						filefield="answer#i#_photo" 
						destination="#upload_folder#" 
						mode="777" nameconflict="MAKEUNIQUE" accept="image/*">
					<cfcatch type="Any">
						<script type="text/javascript">
							alert("<cf_get_lang_main no ='43.Dosyanız upload edilemedi ! Dosyanızı kontrol ediniz'> !");
							history.back();
						</script>
					</cfcatch>  
				</cftry>

				<cfset file_name = createUUID()>
				<cffile action="rename" source="#upload_folder##cffile.serverfile#" destination="#upload_folder##file_name#.#cffile.serverfileext#">
				<cfset "attributes.ANSWER#i#_photo" = '#file_name#.#cffile.serverfileext#'>

				</cfif>
					
			</cfif>
		</cfloop>
		<cfloop from="#attributes.answer_number#" to="19" index="i">
			<cfif len(evaluate("GET_QUIZ_CHAPTER.ANSWER"&evaluate(i+1)&"_photo"))>
				<!--- <cftry>
					<cffile action="DELETE" file="#upload_folder##evaluate("GET_QUIZ_CHAPTER.ANSWER"&evaluate(i)&"_photo")#">
					<cfcatch type="Any">
						<cfoutput>attributes.ANSWER#i#_photo => Dosya bulunamadı ama veritabanından silindi ! 3<br/></cfoutput>
					</cfcatch>
				</cftry> --->
				<cf_del_server_file output_file="hr/#evaluate("GET_QUIZ_CHAPTER.ANSWER"&evaluate(i)&"_photo")#" output_server="#evaluate("GET_QUIZ_CHAPTER.ANSWER"&evaluate(i)&"_photo_server_id")#">
			</cfif>
		</cfloop>
	</cfif>
	<cfquery name="UPD_CHAPTER" datasource="#dsn#">
		UPDATE
			EMPLOYEE_QUIZ_CHAPTER
		SET
			CHAPTER = '#attributes.CHAPTER#',
 			<cfif isDefined("attributes.CHAPTER_INFO")>	
			CHAPTER_INFO = '#attributes.CHAPTER_INFO#',
			</cfif>
 			<cfif len(attributes.CHAPTER_WEIGHT)>
			CHAPTER_WEIGHT = #attributes.CHAPTER_WEIGHT#,
			</cfif>
			ANSWER_NUMBER = #attributes.ANSWER_NUMBER#,

	<cfif attributes.ANSWER_NUMBER NEQ 0>
		<cfloop FROM="0" TO="#EVALUATE(attributes.ANSWER_NUMBER-1)#" INDEX="I">
			ANSWER#EVALUATE(I+1)#_TEXT = '#wrk_eval("attributes.ANSWER"&I&"_TEXT")#',
			ANSWER#EVALUATE(I+1)#_PHOTO = '#wrk_eval("attributes.ANSWER"&I&"_PHOTO")#',
			ANSWER#EVALUATE(I+1)#_PHOTO_SERVER_ID=#fusebox.server_machine#, 
			<cfif IsNumeric(EVALUATE("attributes.ANSWER"&I&"_POINT"))>
			ANSWER#EVALUATE(I+1)#_POINT = #EVALUATE("attributes.ANSWER"&I&"_POINT")#,
			<cfelse>
			ANSWER#EVALUATE(I+1)#_POINT = 0,
			</cfif>
		</cfloop>
		<cfloop FROM="#EVALUATE(attributes.ANSWER_NUMBER+1)#" TO="20" INDEX="I">
			ANSWER#EVALUATE(I)#_TEXT = NULL,
			ANSWER#EVALUATE(I)#_PHOTO = NULL,
			ANSWER#EVALUATE(I)#_PHOTO_SERVER_ID=NULL,
			ANSWER#EVALUATE(I)#_POINT = NULL,
		</cfloop>
	<cfelse>
		<!--- 
			0 CEVAP VARSA AÇİK UÇLU SORU DEMEKTIR
			BU SORU IÇIN CEVAPLARİ SİFİRLA
		--->
		<cfloop FROM="1" TO="20" INDEX="I">
			ANSWER#EVALUATE(I)#_TEXT = NULL,
			ANSWER#EVALUATE(I)#_PHOTO = NULL,
			ANSWER#EVALUATE(I)#_PHOTO_SERVER_ID=NULL,
			ANSWER#EVALUATE(I)#_POINT = NULL,
		</cfloop>

	</cfif>
			IS_EXP1 = <cfif isdefined('attributes.is_exp1')>1<cfelse>0</cfif>,
			IS_EXP2 = <cfif isdefined('attributes.is_exp2')>1<cfelse>0</cfif>,
			IS_EXP3 = <cfif isdefined('attributes.is_exp3')>1<cfelse>0</cfif>,
			IS_EXP4 = <cfif isdefined('attributes.is_exp4')>1<cfelse>0</cfif>,
			EXP1_NAME = <cfif isdefined('attributes.exp1_name') and len(attributes.exp1_name)>'#attributes.exp1_name#'<cfelse>NULL</cfif>,
			EXP2_NAME = <cfif isdefined('attributes.exp2_name') and len(attributes.exp2_name)>'#attributes.exp2_name#'<cfelse>NULL</cfif>,
			EXP3_NAME = <cfif isdefined('attributes.exp3_name') and len(attributes.exp3_name)>'#attributes.exp3_name#'<cfelse>NULL</cfif>,
			EXP4_NAME = <cfif isdefined('attributes.exp4_name') and len(attributes.exp4_name)>'#attributes.exp4_name#'<cfelse>NULL</cfif>,
			IS_EMP_EXP1 = <cfif isdefined('attributes.is_emp_exp1')>1<cfelse>0</cfif>,
			IS_CHIEF3_EXP1 = <cfif isdefined('attributes.is_chief3_exp1')>1<cfelse>0</cfif>,
			IS_CHIEF1_EXP1 = <cfif isdefined('attributes.is_chief1_exp1')>1<cfelse>0</cfif>,
			IS_CHIEF2_EXP1 = <cfif isdefined('attributes.is_chief2_exp1')>1<cfelse>0</cfif>,
			IS_EMP_EXP2 = <cfif isdefined('attributes.is_emp_exp2')>1<cfelse>0</cfif>,
			IS_CHIEF3_EXP2 = <cfif isdefined('attributes.is_chief3_exp2')>1<cfelse>0</cfif>,
			IS_CHIEF1_EXP2 = <cfif isdefined('attributes.is_chief1_exp2')>1<cfelse>0</cfif>,
			IS_CHIEF2_EXP2 = <cfif isdefined('attributes.is_chief2_exp2')>1<cfelse>0</cfif>,
			IS_EMP_EXP3 = <cfif isdefined('attributes.is_emp_exp3')>1<cfelse>0</cfif>,
			IS_CHIEF3_EXP3 = <cfif isdefined('attributes.is_chief3_exp3')>1<cfelse>0</cfif>,
			IS_CHIEF1_EXP3 = <cfif isdefined('attributes.is_chief1_exp3')>1<cfelse>0</cfif>,
			IS_CHIEF2_EXP3 = <cfif isdefined('attributes.is_chief2_exp3')>1<cfelse>0</cfif>,
			IS_EMP_EXP4 = <cfif isdefined('attributes.is_emp_exp4')>1<cfelse>0</cfif>,
			IS_CHIEF3_EXP4 = <cfif isdefined('attributes.is_chief3_exp4')>1<cfelse>0</cfif>,
			IS_CHIEF1_EXP4 = <cfif isdefined('attributes.is_chief1_exp4')>1<cfelse>0</cfif>,
			IS_CHIEF2_EXP4 = <cfif isdefined('attributes.is_chief2_exp4')>1<cfelse>0</cfif>,
			UPDATE_DATE =  #now()#,
			UPDATE_IP = '#CGI.REMOTE_ADDR#',
			UPDATE_EMP = #SESSION.EP.USERID#
		WHERE
			CHAPTER_ID = #attributes.CHAPTER_ID#
	</cfquery>
<cfoutput>
	<script type="text/javascript">
		wrk_opener_reload();
	<cfif Isdefined("attributes.more") AND attributes.more>
		<cfif IsDefined("attributes.answertype")>
			window.location="#request.self#?fuseaction=hr.popup_form_add_CHAPTER&quiz_id=#quiz_id#&CHAPTER_ID=#attributes.CHAPTER_ID#&answertype=1";
		<cfelse>
			window.location="#request.self#?fuseaction=hr.popup_form_add_CHAPTER&quiz_id=#quiz_id#&CHAPTER_ID=#attributes.CHAPTER_ID#";
		</cfif>
	<cfelse>
		<cfif IsDefined("attributes.answertype")>
			window.close();
		<cfelse>
			window.close();
			/*window.location="#request.self#?fuseaction=hr.popup_form_add_CHAPTER&CHAPTER_ID=#attributes.CHAPTER_ID#";*/
		</cfif>
	</cfif>
	</script>
</cfoutput>
