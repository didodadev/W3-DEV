<cfif form.answer_number>
	<cfif not DirectoryExists("#upload_folder#training#dir_seperator#")>
		<cfdirectory action="create" directory="#upload_folder#training#dir_seperator#">
	</cfif>

	<cfset upload_folder = "#upload_folder#training#dir_seperator#">	
	<cfloop from="0" to="#form.answer_number#" index="i">

		<cfif len(evaluate("form.ANSWER"&i&"_photo"))>
			<!--- photo --->
			<cftry>
				<cffile 
					action="UPLOAD" 
					filefield="answer#i#_photo" 
					destination="#upload_folder#" 
					mode="777" nameconflict="MAKEUNIQUE">
				<cfset file_name = createUUID()>
				<cffile action="rename" source="#upload_folder##cffile.serverfile#" destination="#upload_folder##file_name#.#cffile.serverfileext#">
				<!---Script dosyalarını engelle  02092010 FA-ND --->
				<cfset assetTypeName = listlast(cffile.serverfile,'.')>
				<cfset blackList = 'php,pdf,php2,php3,php4,php5,phtml,pwml,inc,asp,aspx,ascx,jsp,cfm,csv,cfml,cfc,pl,bat,exe,com,dll,vbs,reg,cgi,htaccess,asis'>
				<cfif listfind(blackList,assetTypeName,',')>
					<cffile action="delete" file="#upload_folder##file_name#.#cffile.serverfileext#">
					<script type="text/javascript">
						alert("\'php\',\'jsp\',\'asp\',\'cfm\',\'cfml\' Formatlarında Dosya Girmeyiniz!!");
						history.back();
					</script>
					<cfabort>
				</cfif>	
				<cfset "form.ANSWER#i#_photo" = '#file_name#.#cffile.serverfileext#'>
				<cfcatch type="Any">
					<script type="text/javascript">
						alert("<cf_get_lang_main no='43.Dosyanız Upload Edilemedi ! Dosyanızı Kontrol Ediniz '>!");
						history.back();
					</script>
					<cfabort>
				</cfcatch>  
			</cftry>
			
			<!--- dosya boyutu kontrol --->
		</cfif>

	</cfloop>
</cfif>

<CFLOCK name="#CREATEUUID()#" timeout="20">
	<CFTRANSACTION>

		<cfquery name="ADD_QUESTION" datasource="#dsn#" result="MAX_ID">
			INSERT INTO
				QUESTION
				(
				QUESTION,
				QUESTION_INFO,
				TRAINING_SEC_ID,
				TRAINING_CAT_ID,
				TRAINING_ID,
			<cfif isDefined("FORM.TIME")>
				QUESTION_TIME,
			</cfif>
			<cfif isDefined("FORM.QUESTION_POINT")>
				QUESTION_POINT,
			</cfif>
			<cfif form.ANSWER_NUMBER>
				ANSWER_NUMBER,
				<cfloop FROM="0" TO="#EVALUATE(form.ANSWER_NUMBER-1)#" INDEX="I">
				ANSWER#EVALUATE(I+1)#_TEXT,
				ANSWER#EVALUATE(I+1)#_PHOTO,
				ANSWER#EVALUATE(I+1)#_TRUE,
				</cfloop>
			</cfif>
				
				RECORD_DATE,
				RECORD_IP,
				RECORD_EMP,
				STATUS
				)
			VALUES
				(
				'#form.QUESTION#',
				'#form.QUESTION_INFO#',
				<cfif len(attributes.TRAINING_SEC_ID) and attributes.TRAINING_SEC_ID neq 0>
					#attributes.TRAINING_SEC_ID#,
				<cfelse>
					NULL,
				</cfif>
				<cfif len(attributes.TRAINING_CAT_ID) and attributes.TRAINING_CAT_ID neq 0>
					#attributes.TRAINING_CAT_ID#,
				<cfelse>
					NULL,
				</cfif>
				<cfif len(attributes.TRAINING_ID) and attributes.TRAINING_ID neq 0>
					#attributes.TRAINING_ID#,
				<cfelse>
					NULL,
				</cfif>
			<cfif isDefined("FORM.TIME")>
				#form.TIME#,
			</cfif>
			<cfif isDefined("FORM.QUESTION_POINT")>
				#form.QUESTION_POINT#,
			</cfif>
			<cfif form.ANSWER_NUMBER>
				#form.ANSWER_NUMBER#,
				<cfloop FROM="0" TO="#EVALUATE(form.ANSWER_NUMBER-1)#" INDEX="I">
				'#wrk_eval("form.ANSWER"&I&"_TEXT")#',
				'#wrk_eval("form.ANSWER"&I&"_PHOTO")#',
				#EVALUATE("form.ANSWER"&I&"_TRUE")#,
				</cfloop>
			</cfif>
		
				#now()#,
				'#CGI.REMOTE_ADDR#',
				#SESSION.EP.USERID#,
				<cfif isdefined("attributes.STATUS")>1<cfelse>0</cfif>
				)
		</cfquery>
		<cfif isdefined("attributes.QUIZ_ID")>
			<cfquery name="add_quiz_question" datasource="#dsn#">
				INSERT INTO
					QUIZ_QUESTIONS
					(
					QUIZ_ID,
					QUESTION_ID
					)
				VALUES
					(
					#attributes.QUIZ_ID#,
					#MAX_ID.IDENTITYCOL#
					)
			</cfquery>
		</cfif>
	</CFTRANSACTION>
</CFLOCK>
<!---20131102--->
<cfif isdefined("attributes.QUIZ_ID")>
	<cfquery name="GET_MAX_QUESTIONS" datasource="#dsn#">
		SELECT 
			MAX_QUESTIONS
		FROM
			QUIZ
		WHERE
			QUIZ_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.quiz_id#">
	</cfquery>
	<cfquery name="GET_QUESTION_COUNT" datasource="#dsn#">
		SELECT COUNT(QUESTION_ID) AS Q_COUNT
		FROM
			QUIZ_QUESTIONS
		WHERE
			QUIZ_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.quiz_id#">
	</cfquery>
	<cfset max_q = GET_MAX_QUESTIONS.MAX_QUESTIONS - GET_QUESTION_COUNT.Q_COUNT>
<cfelse>
	<cfset max_q = 0>
</cfif>
<!---20131102--->
<cfif isdefined("max_q") and form.more and (not isdefined("attributes.popup")) and max_q gt 0><!---20131102--->
	<cflocation url="#request.self#?fuseaction=training_management.form_add_question&training_sec_id=#attributes.training_sec_id#&training_id=#attributes.training_id#" addtoken="no">
<cfelseif form.more and isdefined("attributes.popup") and max_q gt 0><!---20131102--->
	<cfif isdefined("attributes.training_sec_id") and len(attributes.training_sec_id) and isdefined("attributes.training_id") and len(attributes.training_id)>
			<script type="text/javascript">
				wrk_opener_reload();
				window.location=<cfoutput>"#request.self#?fuseaction=training_management.popup_form_add_question&popup=1&training_sec_id=#attributes.training_sec_id#&training_id=#attributes.training_id#&training_cat_id=#attributes.training_cat_id#&<cfif isdefined("attributes.quiz_id")>quiz_id=#attributes.quiz_id#</cfif></cfoutput>";
			</script>
		<!--- <cflocation url="#request.self#?fuseaction=training_management.popup_form_add_question&popup=1&training_sec_id=#attributes.training_sec_id#&training_id=#attributes.training_id#" addtoken="no"> --->
	<cfelse>
		<cflocation url="#request.self#?fuseaction=training_management.popup_form_add_question&popup=1" addtoken="no">
	</cfif>
<cfelseif isdefined("attributes.popup") and ((form.more neq 1) or (form.more eq 1 and max_q eq 0))><!---20131102--->
	<script type="text/javascript">
	location.href = document.referrer;
	</script>
<cfelse>
	<script>
	<cfif not isdefined("attributes.draggable")>
		<cflocation url="#request.self#?fuseaction=training_management.list_questions" addtoken="no">
	<cfelseif isdefined("attributes.draggable")>
		closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );
	</cfif>
	</script>
</cfif>
