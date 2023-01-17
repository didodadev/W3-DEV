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
		EMPLOYEE_QUIZ_QUESTION
		(
		CHAPTER_ID,
		QUESTION,
		QUESTION_INFO,
	<cfif attributes.ANSWER_NUMBER>
		ANSWER_NUMBER,
		<cfloop FROM="0" TO="#EVALUATE(attributes.ANSWER_NUMBER-1)#" INDEX="I">
		ANSWER#EVALUATE(I+1)#_TEXT,
		ANSWER#EVALUATE(I+1)#_PHOTO,
		ANSWER#EVALUATE(I+1)#_PHOTO_SERVER_ID,
		ANSWER#EVALUATE(I+1)#_POINT,
		</cfloop>
	</cfif>
		OPEN_ENDED,
		RECORD_DATE,
		RECORD_IP,
		RECORD_EMP
		)
	VALUES
		(
		#CHAPTER_ID#,
		'#attributes.QUESTION#',
		'#attributes.QUESTION_INFO#',
	<cfif attributes.ANSWER_NUMBER>
		#attributes.ANSWER_NUMBER#,
		<cfloop FROM="0" TO="#EVALUATE(attributes.ANSWER_NUMBER-1)#" INDEX="I">
		'#wrk_eval("attributes.ANSWER"&I&"_TEXT")#',
		'#wrk_eval("attributes.ANSWER"&I&"_PHOTO")#',
		#fusebox.server_machine#,
		<cfif IsNumeric(EVALUATE("attributes.ANSWER"&I&"_POINT"))>#EVALUATE("attributes.ANSWER"&I&"_POINT")#,<cfelse>0,</cfif>
		</cfloop>
	</cfif>
		<cfif isdefined("attributes.open_ended") and len(attributes.open_ended)>1<cfelse>0</cfif>,
		#now()#,
		'#CGI.REMOTE_ADDR#',
		#SESSION.EP.USERID#
		)
</cfquery>	

<cfoutput>
	<script type="text/javascript">
		location.href = document.referrer;
	<cfif attributes.more>
		<cfif IsDefined("attributes.quiz_id")>
			<cfif IsDefined("attributes.answertype")>
				window.location="#request.self#?fuseaction=hr.popup_form_add_question&quiz_id=#quiz_id#&CHAPTER_ID=#attributes.CHAPTER_ID#&answertype=1";
			<cfelse>
				window.location="#request.self#?fuseaction=hr.popup_form_add_question&quiz_id=#quiz_id#&CHAPTER_ID=#attributes.CHAPTER_ID#";
			</cfif>
		<cfelseif IsDefined("attributes.req_type_id")>
			<cfif IsDefined("attributes.answertype")>
				window.location="#request.self#?fuseaction=hr.popup_form_add_question&req_type_id=#attributes.req_type_id#&CHAPTER_ID=#attributes.CHAPTER_ID#&answertype=1";
			<cfelse>
				window.location="#request.self#?fuseaction=hr.popup_form_add_question&req_type_id=#attributes.req_type_id#&CHAPTER_ID=#attributes.CHAPTER_ID#";
			</cfif>
		</cfif>
	<cfelse>
		location.href = document.referrer;
	</cfif>
	</script>
</cfoutput>
