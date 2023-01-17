<cfinclude template="../query/get_eval_question.cfm">
	<cfif attributes.answer_number neq 0>
		<cfset upload_folder = "#upload_folder#hr#dir_seperator#">
		<cfloop from="0" to="#evaluate(attributes.answer_number-1)#" index="i">
			<cfif len(evaluate("get_question.ANSWER"&evaluate(i+1)&"_photo"))>
			
				<cfif len(evaluate("attributes.ANSWER"&i&"_photo"))>
				<!--- eskiyi sil yeniyi koy --->
					<!--- <cftry>
						<cffile action="DELETE" file="#upload_folder##evaluate("get_question.ANSWER"&evaluate(i+1)&"_photo")#">
						<cfcatch type="Any">
							<cfoutput>attributes.ANSWER#i#_photo => Dosya bulunamadı ama veritabanından silindi ! 1<br/></cfoutput>
						</cfcatch>
					</cftry> --->
					<cf_del_server_file output_file="hr/#evaluate("get_question.ANSWER#i#_photo")#" output_server="#evaluate("get_question.ANSWER#i#_photo_server_id")#">
				<cftry>
					<cffile 
						action="UPLOAD" 
						filefield="answer#i#_photo" 
						destination="#upload_folder#" 
						mode="777" nameconflict="MAKEUNIQUE" accept="image/*">
					<cfcatch type="Any">
						<script type="text/javascript">
							alert("<cf_get_lang_main no ='43.Dosyanýz upload edilemedi ! Dosyanýzý kontrol ediniz '>!");
							history.back();
						</script>
					</cfcatch>  
				</cftry>

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
				<cfset "attributes.ANSWER#i#_photo" = '#file_name#.#cffile.serverfileext#'>

				<cfelse>
					<cfif isdefined("attributes.del_image#i#")>
						<!--- eski sil --->
						<!--- <cftry>
							<cffile action="DELETE" file="#upload_folder##evaluate("get_question.ANSWER"&evaluate(i+1)&"_photo")#">
							<cfset "attributes.ANSWER#i#_photo" = "">
							<cfcatch type="Any">
								<cfset "attributes.ANSWER#i#_photo" = "">
								<cfoutput>attributes.ANSWER#i#_photo => Dosya bulunamadı ama veritabanından silindi ! 2<br/></cfoutput>
							</cfcatch>
						</cftry> --->
						<cf_del_server_file output_file="hr/#evaluate("get_question.ANSWER"&evaluate(i+1)&"_photo")#" output_server="#evaluate("get_question.ANSWER"&evaluate(i+1)&"_photo_server_id")#">
					<cfelse>

						<cfset "attributes.ANSWER#i#_photo" = evaluate("get_question.ANSWER"&evaluate(i+1)&"_photo")>

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
							alert("<cf_get_lang_main no ='43.Dosyanýz upload edilemedi ! Dosyanýzý kontrol ediniz '>!");
							history.back();
						</script>
					</cfcatch>  
				</cftry>

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
				<cfset "attributes.ANSWER#i#_photo" = '#file_name#.#cffile.serverfileext#'>

				</cfif>
					
			</cfif>
		</cfloop>
		<cfloop from="#attributes.answer_number#" to="19" index="i">
			<cfif len(evaluate("get_question.ANSWER"&evaluate(i+1)&"_photo"))>
				<!--- <cftry>
					<cffile action="DELETE" file="#upload_folder##evaluate("get_question.ANSWER"&evaluate(i)&"_photo")#">
					<cfcatch type="Any">
						<cfoutput>attributes.ANSWER#i#_photo => Dosya bulunamadı ama veritabanından silindi ! 3<br/></cfoutput>
					</cfcatch>
				</cftry> --->
				<cf_del_server_file output_file="hr/#evaluate("get_question.ANSWER"&evaluate(i)&"_photo")#" output_server="#evaluate("get_question.ANSWER"&evaluate(i)&"_photo_server_id")#">
			</cfif>
		</cfloop>
	</cfif>
	<cfquery name="UPD_QUESTION" datasource="#dsn#">
		UPDATE
			EMPLOYEE_QUIZ_QUESTION
		SET
			CHAPTER_ID = #attributes.CHAPTER_ID#,
			QUESTION = '#attributes.QUESTION#',
			<!--- ANSWER_TYPE = #attributes.ANSWER_TYPE#, --->
 			<cfif isDefined("attributes.QUESTION_INFO")>	
			QUESTION_INFO = '#attributes.QUESTION_INFO#',
			</cfif>
			ANSWER_NUMBER = #attributes.ANSWER_NUMBER#,

	<cfif attributes.ANSWER_NUMBER NEQ 0>
		<cfloop FROM="0" TO="#EVALUATE(attributes.ANSWER_NUMBER-1)#" INDEX="I">
			ANSWER#EVALUATE(I+1)#_TEXT = '#EVALUATE("attributes.ANSWER"&I&"_TEXT")#',
			ANSWER#EVALUATE(I+1)#_PHOTO = '#EVALUATE("attributes.ANSWER"&I&"_PHOTO")#',
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

			UPDATE_DATE =  #now()#,
			UPDATE_IP = '#CGI.REMOTE_ADDR#',
			UPDATE_EMP = #SESSION.EP.USERID#
		WHERE
			QUESTION_ID = #attributes.QUESTION_ID#
	</cfquery>	

<cfoutput>
	<script type="text/javascript">
		wrk_opener_reload();
	<cfif attributes.more>
		<cfif IsDefined("attributes.answertype")>
			window.location="#request.self#?fuseaction=training_management.popup_form_add_eval_question&quiz_id=#quiz_id#&CHAPTER_ID=#attributes.CHAPTER_ID#&answertype=1";
		<cfelse>
			window.location="#request.self#?fuseaction=training_management.popup_form_add_eval_question&quiz_id=#quiz_id#&CHAPTER_ID=#attributes.CHAPTER_ID#";
		</cfif>
	<cfelse>
		<cfif IsDefined("attributes.answertype")>
			window.close();
		<cfelse>
			window.close();
			/*window.location="#request.self#?fuseaction=training_management.popup_form_add_question&CHAPTER_ID=#attributes.CHAPTER_ID#";*/
		</cfif>
	</cfif>
	</script>
</cfoutput>
