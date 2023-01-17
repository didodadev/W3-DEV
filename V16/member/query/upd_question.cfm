<cflock name="#CREATEUUID()#" timeout="20">
<cftransaction>
<cfinclude template="../query/get_question_answers.cfm">
<cfif isdefined('attributes.answer_number') and attributes.answer_number neq 0>
	<cfset upload_folder = "#upload_folder#member#dir_seperator#">
	<!--- resimleri yeniden upload et---->
	<cfloop from="0" to="#attributes.answer_number-1#" index="i">
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
		<cfelse>
			<cfquery name="get_photo" dbtype="query">
				SELECT ANSWER_PHOTO FROM get_question_answers WHERE ROW = #i+1#
			</cfquery>
			<cfif get_photo.recordcount and not isdefined("attributes.del_image#i#")>
				<cfset "form.answer#i#_photo" = '#get_photo.answer_photo#'>
			</cfif>
		</cfif>
	</cfloop>
</cfif>
<cfquery name="UPD_QUESTION" datasource="#DSN#">
	UPDATE
		MEMBER_QUESTION
	SET
		QUESTION = #sql_unicode()#'#attributes.question#',
		<cfif isDefined('attributes.question_type')>QUESTION_TYPE = #attributes.question_type#,</cfif>
		ANALYSIS_ID = #attributes.analysis_id#,
		QUESTION_INFO = <cfif len(attributes.question_info)>#sql_unicode()#'#attributes.question_info#'<cfelse>NULL</cfif>,
		<cfif isDefined('attributes.answer_number')>ANSWER_NUMBER = #attributes.answer_number#,</cfif>
		UPDATE_DATE =  #now()#,
		UPDATE_IP = '#cgi.remote_addr#',
		UPDATE_EMP = #session.ep.userid#
	WHERE
		QUESTION_ID = #attributes.question_id#
</cfquery>
<!---şıklar ayrı tabloya kayıt ediliyor --->
<cfif isDefined('attributes.answer_number')>
	<cfquery name="del_question_answers" datasource="#dsn#">
		DELETE FROM MEMBER_QUESTION_ANSWERS WHERE QUESTION_ID = #attributes.question_id#
	</cfquery>
</cfif>
<cfif isDefined('attributes.answer_number') and attributes.answer_number neq 0>
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
				#attributes.question_id#,
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
				<cfif len(ccc)>'#ccc#'<cfelse>NULL</cfif>,
				<cfif len(ccc)>#fusebox.server_machine#<cfelse>NULL</cfif>,
				<cfif len(eee) and len(ddd)>#ddd#<cfelse>NULL</cfif>
			)
	</cfquery>
	</cfloop>
<cfelse><!--- sik sayisi readonly ise sadece "Şık ve Açıklama" alanlarını güncellemeye izin verir --->
	<cfquery name="get_question_answers" datasource="#dsn#">
		SELECT * FROM MEMBER_QUESTION_ANSWERS WHERE QUESTION_ID = #attributes.question_id#
	</cfquery>
	<cfloop query="get_question_answers">
		<cfquery name="upd_question_answers" datasource="#dsn#">
			UPDATE 
				MEMBER_QUESTION_ANSWERS
			SET
				ANSWER_TEXT = '#evaluate("attributes.answer#currentrow-1#_text")#',
				ANSWER_INFO = '#evaluate("attributes.answer#currentrow-1#_info")#'
			WHERE 
				QUESTION_ANSWER_ID = #get_question_answers.question_answer_id#
		</cfquery>
	</cfloop>
</cfif>
<!--- Kaydet ve yeni soru ekle --->
<cfif attributes.more eq 1>
	<script type="text/javascript">
		window.location.href = '<cfoutput>#request.self#?fuseaction=member.list_analysis&event=addSub&analysis_id=#attributes.analysis_id#</cfoutput>';
	</script>
<cfelse>
	<script type="text/javascript">
		window.location.href = '<cfoutput>#request.self#?fuseaction=member.list_analysis&event=upd&analysis_id=#attributes.analysis_id#</cfoutput>';
	</script>
</cfif>
</cftransaction>
</cflock>