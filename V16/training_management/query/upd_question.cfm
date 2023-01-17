<cfinclude template="get_question.cfm">
<cfif form.answer_number neq 0>
	<cfset upload_folder = "#upload_folder#training#dir_seperator#">
	<cfloop from="0" to="#evaluate(form.answer_number-1)#" index="i">
		<cfif len(evaluate("get_question.ANSWER"&evaluate(i+1)&"_photo"))>
		
			<cfif len(evaluate("form.ANSWER"&i&"_photo"))>
			<!--- eskiyi sil yeniyi koy --->
				<cftry>
					<cffile action="DELETE" file="#upload_folder##evaluate("get_question.ANSWER"&evaluate(i+1)&"_photo")#">
					<cfcatch type="Any">
						<cfoutput>form.ANSWER#i#_photo => 
						<cf_get_lang no='282.Dosya bulunamadı ama veritabanından silindi !'> 1<br/></cfoutput>
					</cfcatch>
				</cftry>
				<cftry>
					<cffile 
						action="UPLOAD" 
						filefield="answer#i#_photo" 
						destination="#upload_folder#" 
						mode="777" nameconflict="MAKEUNIQUE" accept="image/*">
					<cfset file_name = createUUID()>
					<cffile action="rename" source="#upload_folder##cffile.serverfile#" destination="#upload_folder##file_name#.#cffile.serverfileext#">
					<!---Script dosyalarını engelle  02092010 FA-ND --->
					<cfset assetTypeName = listlast(cffile.serverfile,'.')>
					<cfset blackList = 'php,php2,php3,php4,php5,phtml,pwml,inc,asp,aspx,ascx,jsp,cfm,cfml,cfc,pl,bat,exe,com,dll,vbs,reg,cgi,htaccess,asis'>
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

			<cfelse>
				<cfif isdefined("form.del_image#i#")>
					<!--- eski sil --->
					<cftry>
						<cffile action="DELETE" file="#upload_folder##evaluate("get_question.ANSWER"&evaluate(i+1)&"_photo")#">
						<cfset "form.ANSWER#i#_photo" = "">
						<cfcatch type="Any">
							<cfset "form.ANSWER#i#_photo" = "">
							<cfoutput>form.ANSWER#i#_photo => 
							<cf_get_lang no='282.Dosya bulunamadı ama veritabanından silindi !'> 2<br/></cfoutput>
						</cfcatch>
					</cftry>

				<cfelse>

					<cfset "form.ANSWER#i#_photo" = evaluate("get_question.ANSWER"&evaluate(i+1)&"_photo")>

				</cfif>
			</cfif>
		<cfelse>

			<cfif len(evaluate("form.ANSWER"&i&"_photo"))>
			<!--- yeniyi koy --->
				<cftry>
					<cffile 
						action="UPLOAD" 
						filefield="answer#i#_photo" 
						destination="#upload_folder#" 
						mode="777" nameconflict="MAKEUNIQUE" accept="image/*">
					<cfset file_name = createUUID()>
					<cffile action="rename" source="#upload_folder##cffile.serverfile#" destination="#upload_folder##file_name#.#cffile.serverfileext#">
					<!---Script dosyalarını engelle  02092010 FA-ND --->
					<cfset assetTypeName = listlast(cffile.serverfile,'.')>
					<cfset blackList = 'php,php2,php3,php4,php5,phtml,pwml,inc,asp,aspx,ascx,jsp,cfm,cfml,cfc,pl,bat,exe,com,dll,vbs,reg,cgi,htaccess,asis'>
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
	
			</cfif>
				
		</cfif>
	</cfloop>
	<cfloop from="#form.answer_number#" to="19" index="i">
		<cfif len(evaluate("get_question.ANSWER#i+1#_photo"))>
			<cftry>
				<cffile action="DELETE" file="#upload_folder##evaluate("get_question.ANSWER#i+1#_photo")#">
				<cfcatch type="Any">
					<cfoutput>form.ANSWER#i#_photo => 
					<cf_get_lang no='282.Dosya bulunamadı ama veritabanından silindi !'> 3<br/></cfoutput>
				</cfcatch>
			</cftry>
		</cfif>
	</cfloop>
</cfif>
<cfquery name="UPD_QUESTION" datasource="#dsn#">
	UPDATE
		QUESTION
	SET
		QUESTION = '#form.QUESTION#',
		TRAINING_SEC_ID = #attributes.TRAINING_SEC_ID#,
		TRAINING_CAT_ID = #attributes.TRAINING_CAT_ID#,
		TRAINING_ID = <cfif isDefined("form.TRAINING_ID")>#attributes.TRAINING_ID#<cfelse>NULL</cfif>,
		QUESTION_INFO = <cfif isDefined("form.QUESTION_INFO")>'#form.QUESTION_INFO#'<cfelse>NULL</cfif>,
		QUESTION_TIME = <cfif isDefined("form.TIME")>#form.TIME#<cfelse>NULL</cfif>,
		QUESTION_POINT = <cfif isDefined("form.QUESTION_POINT")>#form.QUESTION_POINT#<cfelse>NULL</cfif>,
		ANSWER_NUMBER = #form.ANSWER_NUMBER#,
		STATUS=	<cfif isdefined("attributes.STATUS")>1,<cfelse>0,</cfif>
<cfif form.ANSWER_NUMBER NEQ 0>
	<cfloop FROM="0" TO="#EVALUATE(form.ANSWER_NUMBER-1)#" INDEX="I">
		ANSWER#EVALUATE(I+1)#_TEXT = '#EVALUATE("form.ANSWER"&I&"_TEXT")#',
		ANSWER#EVALUATE(I+1)#_PHOTO = '#EVALUATE("form.ANSWER"&I&"_PHOTO")#',
		ANSWER#EVALUATE(I+1)#_TRUE = #EVALUATE("form.ANSWER"&I&"_TRUE")#,
	</cfloop>
	<cfloop FROM="#EVALUATE(form.ANSWER_NUMBER+1)#" TO="20" INDEX="I">
		ANSWER#EVALUATE(I)#_TEXT = '',
		ANSWER#EVALUATE(I)#_PHOTO = '',
		ANSWER#EVALUATE(I)#_TRUE = 0,
	</cfloop>
<cfelse>
	<!--- 
		0 CEVAP VARSA AÇİK UÇLU SORU DEMEKTIR
		BU SORU IÇIN CEVAPLARİ SİFİRLA
	--->
	<cfloop FROM="1" TO="20" INDEX="I">
		ANSWER#EVALUATE(I)#_TEXT = '',
		ANSWER#EVALUATE(I)#_PHOTO = '',
		ANSWER#EVALUATE(I)#_TRUE = 0,
	</cfloop>

</cfif>

		UPDATE_DATE =  #now()#,
		UPDATE_IP = '#CGI.REMOTE_ADDR#',
		UPDATE_EMP = #SESSION.EP.USERID#
	WHERE
		QUESTION_ID = #form.QUESTION_ID#
</cfquery>	

<cfif not isdefined("attributes.draggable")>
	<cfif attributes.more and (not isdefined("attributes.popup"))>
		<cflocation url="#request.self#?fuseaction=training_management.form_add_question" addtoken="no">
	<cfelseif isdefined("attributes.popup") and (not attributes.more)>
		<script type="text/javascript">
		location.href = document.referrer;
		</script>
	<cfelseif isdefined("attributes.popup") and attributes.more>
		<cflocation url="#request.self#?fuseaction=training_management.popup_form_add_question&popup=1" addtoken="no">
	<cfelse>
		<cflocation url="#request.self#?fuseaction=training_management.list_questions" addtoken="no">
	</cfif>
<cfelseif isdefined("attributes.draggable")>
	<script>
		closeBoxDraggable( 'edit_question_box');
		$("#list_quiz_questions .catalyst-refresh").click();
	</script>
</cfif>