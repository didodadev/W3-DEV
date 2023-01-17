<cfif attributes.answer_number>
	<cfset upload_folder = "#upload_folder#member#dir_seperator#">	
	<cfloop from="0" to="#attributes.answer_number#" index="i">
		<!--- Resim --->
		<cfif len(evaluate("form.answer"&i&"_photo"))>
			<cftry>
				<cffile 
					action="upload" 
					filefield="form.answer#i#_photo" 
					destination="#upload_folder#" 
					mode="777" nameconflict="MAKEUNIQUE" accept="image/*">
				<cfset file_name = createUUID()>
				<cffile action="rename" source="#upload_folder##cffile.serverfile#" destination="#upload_folder##file_name#.#cffile.serverfileext#">
				<cfset "form.answer#i#_photo" = '#file_name#.#cffile.serverfileext#'>
				<cfcatch type="Any">
					<script type="text/javascript">
						alert("<cf_get_lang_main no='43.Dosyanız Upload Edilemedi ! Dosyanızı Kontrol Ediniz'> !");
						history.back();
					</script>
					<cfabort>
				</cfcatch>  
			</cftry>
		</cfif>
	</cfloop>
</cfif>
<cflock name="#CREATEUUID()#" timeout="20">
	<cftransaction>
		<cfquery name="ADD_QUESTION" datasource="#DSN#">
			INSERT INTO
				MEMBER_QUESTION
			(
				QUESTION,
				QUESTION_INFO,
				QUESTION_TYPE,
				ANALYSIS_ID,
				ANSWER_NUMBER,
				<!--- cevap şıkları ayrı tabloya taşındı SG 20120718--->
				<!---<cfif attributes.answer_number>				
					<cfloop from="0" to="#attributes.answer_number-1#" index="i">
						ANSWER#i+1#_TEXT,
						ANSWER#i+1#_INFO,
						ANSWER#i+1#_POINT,
						ANSWER#i+1#_PHOTO,
						ANSWER#i+1#_PHOTO_SERVER_ID,
						ANSWER#i+1#_PRODUCT_ID,
					</cfloop>
				</cfif>--->
				RECORD_DATE,
				RECORD_IP,
				RECORD_EMP
			)
			VALUES
			(
				#sql_unicode()#'#attributes.question#',
				#sql_unicode()#'#attributes.question_info#',
				#attributes.question_type#,
				#attributes.analysis_id#,
				#attributes.answer_number#,
				<!--- cevap şıkları ayrı tabloya taşındı SG 20120718--->
				<!---
				<cfif attributes.answer_number>				
					<cfloop from="0" to="#attributes.answer_number-1#" index="i">
						<cfset aaa = evaluate("attributes.answer#i#_text")>
						<cfset answer_info_ = evaluate("attributes.answer#i#_info")>
						<cfset bbb = filternum(evaluate("attributes.answer#i#_point"))>
						<cfif not len(bbb)><cfset bbb = 0></cfif>
						<cfset ccc = evaluate("attributes.answer#i#_photo")>
						<cfset ddd = evaluate("attributes.answer#i#_product_id")>
						<cfset eee = evaluate("attributes.answer#i#_product_name")>
						#sql_unicode()#'#aaa#',
						#sql_unicode()#'#answer_info_#',
						#bbb#,
						<cfif len(ccc)>'#ccc#',#fusebox.server_machine#,<cfelse>NULL,NULL,</cfif>
						<cfif len(eee) and Len(ddd)>#ddd#<cfelse>NULL</cfif>,
					</cfloop>
				</cfif>--->
				#now()#,
				'#cgi.remote_addr#',
				#session.ep.userid#
			)
		</cfquery>	
		<!---cevap şıkları ayrı tabloya taşındı--->
		<cfif attributes.answer_number>	
		<cfquery name="get_max_id" datasource="#dsn#">
			SELECT MAX(QUESTION_ID) AS MAX_QUESTION_ID FROM MEMBER_QUESTION
		</cfquery>
		<cfloop from="0" to="#attributes.answer_number-1#" index="i">
		<cfquery name="add_question_answers" datasource="#dsn#">
			INSERT INTO
				MEMBER_QUESTION_ANSWERS
				(
					QUESTION_ID,
					ROW,
					ANSWER_TEXT,
					ANSWER_INFO,
					ANSWER_POINT,
					ANSWER_PHOTO,
					ANSWER_PHOTO_SERVER_ID,
					ANSWER_PRODUCT_ID
				)
				VALUES
				(
					#get_max_id.MAX_QUESTION_ID#,
					#i+1#,
					<cfset aaa = evaluate("attributes.answer#i#_text")>
					<cfset answer_info_ = evaluate("attributes.answer#i#_info")>
					<cfset bbb = filternum(evaluate("attributes.answer#i#_point"))>
					<cfif not len(bbb)><cfset bbb = 0></cfif>
					<cfset ccc = evaluate("form.answer#i#_photo")>
					<cfset ddd = evaluate("attributes.answer#i#_product_id")>
					<cfset eee = evaluate("attributes.answer#i#_product_name")>
					#sql_unicode()#'#aaa#',
					#sql_unicode()#'#answer_info_#',
					#bbb#,
					<cfif len(ccc)>'#ccc#',#fusebox.server_machine#,<cfelse>NULL,NULL,</cfif>
					<cfif len(eee) and Len(ddd)>#ddd#<cfelse>NULL</cfif>
				)
		</cfquery>
		</cfloop>
		</cfif>
		<script type="text/javascript">
			window.location='<cfoutput>#request.self#?fuseaction=member.list_analysis&event=upd&analysis_id=#attributes.analysis_id#</cfoutput>';
		</script>
	</cftransaction>
</cflock>
<!--- Kaydet ve yeni soru ekle --->

<script type="text/javascript">
<cfif isDefined("attributes.draggable")>
CloseBoxDraggable()
	
<cfelse>
	<cfif attributes.more eq 1>
		window.location.href = '<cfoutput>#request.self#?fuseaction=member.list_analysis&event=addSub&analysis_id=#attributes.analysis_id#</cfoutput>';
	<cfelse>
		window.location.href = '<cfoutput>#request.self#?fuseaction=member.list_analysis&event=upd&analysis_id=#attributes.analysis_id#</cfoutput>';
	</cfif>
</cfif>
</script>