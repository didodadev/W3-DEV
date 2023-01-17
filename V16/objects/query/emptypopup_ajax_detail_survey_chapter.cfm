<!---<cfset fullData = deserializeJSON(toString( getHttpRequestData().content )) />
<cfloop index = "ListElement" list = "#fullData#" delimiters = "&">
	<cfset attributes['#listFirst(ListElement,"=")#'] = listLast(ListElement,"=")> 
</cfloop>--->
<cfparam name="attributes.delete_ids" default="0">
<cfset cfc=createObject("component","V16.training_management.cfc.training_survey")> 
<cfsetting showdebugoutput="no">
<cfparam name="attributes.survey_id" default="">
<cflock name="#CreateUUID()#" timeout="20">
	<cftransaction>
		<!--- Row_Kontrol_List 0 ise satir silinir --->
		   <cfset get_question=cfc.GetQuestion(survey_id:attributes.survey_id)>  
		<!--- <cfif get_question.recordcount>
			<cfloop query="get_question"> --->
				<!--- <cfif isdefined("attributes.row_kontrol_list_question#survey_question_id#") and evaluate("attributes.row_kontrol_list_question#survey_question_id#") eq 0> --->
					
					<cfset del_survey_chapter=cfc.DelSurveyChapterFirst(survey_question_id:evaluate("attributes.delete_ids"))>  
					<cfset del_survey_chapter=cfc.DelSurveyChapterSecond(survey_question_id:evaluate("attributes.delete_ids"))>   
				<!--- </cfif> --->
			<!--- </cfloop>
		</cfif> --->
		<!--- Analize Chapter Insetr Edilir, Silinir, Update Yapılır --->
		<cfif isDefined("attributes.add_new_chapter") and attributes.add_new_chapter eq 1>
			<cfif isdefined('attributes.record_num') and len(attributes.record_num)>
				<cfloop from="1" to="#attributes.record_num#" index="i">
					<cfif isdefined("attributes.row_kontrol#i#") and evaluate("attributes.row_kontrol#i#") eq 1>
						<!--- Row_Kontrol 1 ise ve Survey_Chapter_Id dolu ise varolan satir guncelleniyor --->
						<cfif isDefined("attributes.survey_chapter_id#i#") and Len(evaluate("attributes.survey_chapter_id#i#"))>
							<cfset upd_survey_chapter=cfc.UpdSurveyChapter(
								survey_id:attributes.survey_id,
								survey_chapter_code:evaluate("attributes.survey_chapter_code#i#"), 
								survey_chapter_head:evaluate("attributes.survey_chapter_head#i#"),
								survey_chapter_detail:evaluate("attributes.survey_chapter_detail#i#"),
								survey_chapter_weight:evaluate("attributes.survey_chapter_weight#i#"),
								survey_chapter_id:evaluate("attributes.survey_chapter_id#i#")
								
								  )>  
						<cfelse>
							<!--- Row_Kontrol 1 ise ve Survey_Chapter_Id bossa yeni bir satir ekleniyor --->
							  <cfset add_survey_chapter=cfc.AddSurveyChapter(
								survey_id:attributes.survey_id,
								survey_chapter_code:evaluate("attributes.survey_chapter_code#i#"), 
								survey_chapter_head:evaluate("attributes.survey_chapter_head#i#"),
								survey_chapter_detail:evaluate("attributes.survey_chapter_detail#i#"),
								survey_chapter_weight:evaluate("attributes.survey_chapter_weight#i#")						
								  )> 
						</cfif>
					<cfelse>
						<!--- Row_Kontrol 0 ise ve Survey_Chapter_Id dolu ise satir silinir --->
						<cfif isDefined("attributes.survey_chapter_id#i#") and Len(evaluate("attributes.survey_chapter_id#i#"))>
                            <cfif isdefined("attributes.row_kontrol#i#") and evaluate("attributes.row_kontrol#i#") eq 0>
                                <cfset del_survey_chapter=cfc.DelSurveyChapterthird(
                                    survey_id:evaluate("attributes.survey_id"),
                                    survey_chapter_id:evaluate("attributes.survey_chapter_id#i#")
                                )>
                                    <cfset del_survey_question=cfc.DelSurveyQuestionfourth(survey_chapter_id:evaluate("attributes.survey_chapter_id#i#")
                                )>
                            </cfif>
						</cfif>
					</cfif>
				</cfloop>
			</cfif>
		</cfif>
		<!--- //Analize Chapter Insert Edilir, Silinir, Update Yapılır --->
	
		<!--- Ilgili Chapter'a Question ve Option Eklenir --->
		<!--- <cfif isdefined('attributes.add_new_question') and attributes.add_new_question eq 1>
			<cfquery name="get_line_number" datasource="#dsn#">
				SELECT MAX(LINE_NUMBER) AS LINE_NUMBER FROM SURVEY_QUESTION WHERE SURVEY_CHAPTER_ID = #attributes.survey_chapter_id#
			</cfquery>
			<cfif len(get_line_number.line_number)>
				<cfset line_number_plus = get_line_number.line_number + 1>
			<cfelse>
				<cfset line_number_plus = 1>
			</cfif>
			<cfquery name="add_survey_questions" datasource="#dsn#">
				INSERT INTO 
					SURVEY_QUESTION
					(	
						SURVEY_CHAPTER_ID,
						SURVEY_MAIN_ID,
						LINE_NUMBER,
						QUESTION_HEAD,
						QUESTION_DETAIL,
						QUESTION_TYPE,
						QUESTION_DESIGN,
						QUESTION_IMAGE_PATH,
						QUESTION_FLASH_PATH,
						QUESTION_TIME_LIMIT,
						RECORD_EMP,
						RECORD_DATE,
						RECORD_IP 
					)
					VALUES
					(	
						<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.survey_chapter_id#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.survey_id#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#line_number_plus#">,
						<cfif isdefined('attributes.question_head') and len(attributes.question_head)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#attributes.question_head#"><cfelse>NULL</cfif>,
						<cfif isdefined('attributes.question_detail') and len(attributes.question_detail)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#attributes.question_detail#"><cfelse>NULL</cfif>,
						<cfif isdefined('attributes.question_type') and len(attributes.question_type)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.question_type#"><cfelse>NULL</cfif>,
						<cfif isdefined('attributes.question_design') and len(attributes.question_design)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.question_design#"><cfelse>NULL</cfif>,
						<cfif isdefined('attributes.question_image') and len(attributes.question_image)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.question_image#"><cfelse>NULL</cfif>,
						<cfif isdefined('attributes.question_asset') and len(attributes.question_asset)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.question_asset#"><cfelse>NULL</cfif>,
						<cfif isdefined('attributes.question_time_limit') and len(attributes.question_time_limit)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.question_time_limit#"><cfelse>NULL</cfif>,   
						<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#now()#">,
						<cfqueryparam cfsqltype="cf_sql_nvarchar" value="#cgi.remote_addr#">
					)
			</cfquery>
			<cfif isDefined("attributes.add_new_option") and attributes.add_new_option eq 1>
				<cfquery name="get_max_survey_question_id" datasource="#dsn#">
					SELECT MAX(SURVEY_QUESTION_ID) AS MAX_ID FROM SURVEY_QUESTION
				</cfquery> 
				<cfloop from="1" to="#attributes.option_record_num#" index="j">
				<cfquery name="add_survey_options1" datasource="#dsn#">
					INSERT INTO 
						SURVEY_OPTION
						(	
							SURVEY_QUESTION_ID,
							OPTION_HEAD,
							OPTION_DETAIL,
							OPTION_NOTE,
							OPTION_SCORE, 
							SCORE_RATE1,
							SCORE_RATE2,  
							OPTION_POINT
						)
						VALUES
						(	
							#get_max_survey_question_id.MAX_ID#,
							<cfif len(evaluate("attributes.option_head#j#"))><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#evaluate('attributes.option_head#j#')#">,<cfelse>NULL,</cfif>
							<cfif len(evaluate("attributes.option_detail#j#"))><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#evaluate('attributes.option_detail#j#')#">,<cfelse>NULL,</cfif>
							<cfif isdefined("attributes.option_add_note#j#")>1<cfelse>0</cfif>,
							<cfif isdefined("attributes.option_score#j#")>1<cfelse>0</cfif>,
							<cfif len(evaluate("attributes.option_score_rate1_#j#"))><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.option_score_rate1_#j#')#">,<cfelse>NULL,</cfif> 
							<cfif len(evaluate("attributes.option_score_rate2_#j#"))><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.option_score_rate2_#j#')#">,<cfelse>NULL,</cfif>  
							<cfif len(evaluate("attributes.option_point#j#"))><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.option_point#j#')#"><cfelse>NULL</cfif> 
						)
				</cfquery>
			</cfloop>  
			</cfif>   
		</cfif> --->
		<!--- //Ilgili Chapter'a Question ve Option Eklenir --->
		
		<!--- Manuel Soru Sıralaması İçin Kullanılır --->
		   <cfif isdefined('attributes.survey_question_id') and len(attributes.survey_question_id)>
			 <cfset get_plus=cfc.GetPlus(survey_question_id:attributes.survey_question_id)>   
			  <cfif isdefined('attributes.line_replace') and (attributes.line_replace gt get_plus.line_number)>
			    <cfset upd_minus=cfc.UpdMinus(survey_chapter_id:get_plus.survey_chapter_id,line_number:get_plus.line_number,line_replace:attributes.line_replace)>  
				<cfset upd_plus=cfc.UpdPlus(line_replace:attributes.line_replace,survey_question_id:attributes.survey_question_id)>
			<cfelseif isdefined('attributes.line_replace') and (attributes.line_replace lt get_plus.line_number)>
				 <cfset upd_minus1=cfc.UpdMinus1(survey_chapter_id:get_plus.survey_chapter_id,line_replace:attributes.line_replace,line_number:get_plus.line_number)> 
				<cfset upd_plus1=cfc.UpdPlus(line_replace:attributes.line_replace,survey_question_id:attributes.survey_question_id)> 
				<!---  UpdPlus la yanı query kullanılmış --->
			    <!--- <cfquery name="upd_plus1" datasource="#dsn#">    
					UPDATE
						SURVEY_QUESTION
					SET
						LINE_NUMBER = #attributes.line_replace#
					WHERE
						SURVEY_QUESTION_ID = #attributes.survey_question_id#
				</cfquery> ---> 
			</cfif>   
		</cfif>   
		<!--- Manuel Soru Sıralaması İçin Kullanılır --->
	</cftransaction>
</cflock>
<!---<script type="text/javascript">
	<cfoutput>
		refresh_box('div_related_chapter','#request.self#?fuseaction=objects.emptypopupajax_form_upd_detail_survey_chapter&survey_id=#attributes.survey_id#','0');
	</cfoutput>
</script>--->
<script type="text/javascript">
	$("#div_related_chapter .catalyst-refresh").click();
</script>