<cfif attributes.answer_number>
	<cfset upload_folder = "#upload_folder#hr#dir_seperator#">	
	<cfloop from="0" to="#attributes.answer_number#" index="i">
		<cfif len(evaluate("attributes.ANSWER"&i&"_photo"))>
		<!--- photo --->
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
	</cfloop>
</cfif>

<cfquery name="ADD_QUESTION" datasource="#dsn#">
	INSERT INTO
		EMPLOYEE_QUIZ_CHAPTER
		(
		<cfif isdefined("attributes.quiz_id") and len(attributes.quiz_id)>QUIZ_ID,</cfif>
		<cfif isdefined("attributes.req_type_id") and len(attributes.req_type_id)>REQ_TYPE_ID,</cfif>
		CHAPTER,
		CHAPTER_INFO,
		CHAPTER_WEIGHT,
		ANSWER_TYPE,
		ANSWER_NUMBER,
	<cfif attributes.ANSWER_NUMBER>
		<cfloop FROM="0" TO="#EVALUATE(attributes.ANSWER_NUMBER-1)#" INDEX="I">
		ANSWER#EVALUATE(I+1)#_TEXT,
		ANSWER#EVALUATE(I+1)#_PHOTO,
		ANSWER#EVALUATE(I+1)#_PHOTO_SERVER_ID,
		ANSWER#EVALUATE(I+1)#_POINT,
		</cfloop>
	</cfif>
		IS_EXP1,
		IS_EXP2,
		IS_EXP3,
		IS_EXP4,
		EXP1_NAME,
		EXP2_NAME,
		EXP3_NAME,
		EXP4_NAME,
		IS_EMP_EXP1,
		IS_CHIEF3_EXP1,
		IS_CHIEF1_EXP1,
		IS_CHIEF2_EXP1,
		IS_EMP_EXP2,
		IS_CHIEF3_EXP2,
		IS_CHIEF1_EXP2,
		IS_CHIEF2_EXP2,
		IS_EMP_EXP3,
		IS_CHIEF3_EXP3,
		IS_CHIEF1_EXP3,
		IS_CHIEF2_EXP3,
		IS_EMP_EXP4,
		IS_CHIEF3_EXP4,
		IS_CHIEF1_EXP4,
		IS_CHIEF2_EXP4,
		RECORD_DATE,
		RECORD_IP,
		RECORD_EMP
		)
	VALUES
		(
		<cfif isdefined("attributes.quiz_id") and len(attributes.quiz_id)>#attributes.QUIZ_ID#,</cfif>
		<cfif isdefined("attributes.req_type_id") and len(attributes.req_type_id)>#attributes.req_type_id#,</cfif>
		'#attributes.CHAPTER#',
		'#attributes.CHAPTER_INFO#',
		<cfif len(attributes.CHAPTER_WEIGHT)>#attributes.CHAPTER_WEIGHT#,<cfelse>NULL,</cfif>
		<cfif isdefined("attributes.answer_type")>#attributes.answer_type#<cfelse>1</cfif>,
		#attributes.ANSWER_NUMBER#,
	<cfif attributes.ANSWER_NUMBER>
		<cfloop FROM="0" TO="#EVALUATE(attributes.ANSWER_NUMBER-1)#" INDEX="I">
		'#wrk_eval("attributes.ANSWER"&I&"_TEXT")#',
		'#wrk_eval("attributes.ANSWER"&I&"_PHOTO")#',
		#fusebox.server_machine#,
		<cfif IsNumeric(EVALUATE("attributes.ANSWER"&I&"_POINT"))>#EVALUATE("attributes.ANSWER"&I&"_POINT")#,<cfelse>0,</cfif>
		</cfloop>
	</cfif>
		<cfif isdefined("attributes.is_exp1")>1<cfelse>0</cfif>,
		<cfif isdefined("attributes.is_exp2")>1<cfelse>0</cfif>,
		<cfif isdefined("attributes.is_exp3")>1<cfelse>0</cfif>,
		<cfif isdefined("attributes.is_exp4")>1<cfelse>0</cfif>,
		<cfif isdefined("attributes.exp1_name") and len(attributes.exp1_name)>'#attributes.exp1_name#'<cfelse>NULL</cfif>,
		<cfif isdefined("attributes.exp2_name") and len(attributes.exp2_name)>'#attributes.exp2_name#'<cfelse>NULL</cfif>,
		<cfif isdefined("attributes.exp3_name") and len(attributes.exp3_name)>'#attributes.exp3_name#'<cfelse>NULL</cfif>,
		<cfif isdefined("attributes.exp4_name") and len(attributes.exp4_name)>'#attributes.exp4_name#'<cfelse>NULL</cfif>,
		<cfif isdefined("attributes.is_emp_exp1")>1<cfelse>0</cfif>,
		<cfif isdefined("attributes.is_chief3_exp1")>1<cfelse>0</cfif>,
		<cfif isdefined("attributes.is_chief1_exp1")>1<cfelse>0</cfif>,
		<cfif isdefined("attributes.is_chief2_exp1")>1<cfelse>0</cfif>,
		<cfif isdefined("attributes.is_emp_exp2")>1<cfelse>0</cfif>,
		<cfif isdefined("attributes.is_chief3_exp2")>1<cfelse>0</cfif>,
		<cfif isdefined("attributes.is_chief1_exp2")>1<cfelse>0</cfif>,
		<cfif isdefined("attributes.is_chief2_exp2")>1<cfelse>0</cfif>,
		<cfif isdefined("attributes.is_emp_exp3")>1<cfelse>0</cfif>,
		<cfif isdefined("attributes.is_chief3_exp3")>1<cfelse>0</cfif>,
		<cfif isdefined("attributes.is_chief1_exp3")>1<cfelse>0</cfif>,
		<cfif isdefined("attributes.is_chief2_exp3")>1<cfelse>0</cfif>,
		<cfif isdefined("attributes.is_emp_exp4")>1<cfelse>0</cfif>,
		<cfif isdefined("attributes.is_chief3_exp4")>1<cfelse>0</cfif>,
		<cfif isdefined("attributes.is_chief1_exp4")>1<cfelse>0</cfif>,
		<cfif isdefined("attributes.is_chief2_exp4")>1<cfelse>0</cfif>,
		#now()#,
		'#CGI.REMOTE_ADDR#',
		#SESSION.EP.USERID#
		)
</cfquery>	

<script type="text/javascript">
wrk_opener_reload();
window.close();	
</script>
<!--- <cflocation url="#request.self#?fuseaction=hr.quiz&quiz_id=#attributes.quiz_id#"> --->

