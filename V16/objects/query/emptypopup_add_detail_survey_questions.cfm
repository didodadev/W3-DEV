<!--- Gozat Belge Ekleme Kontrolleri- Dijital Varliklara Atiliyor --->
<cfset cfc=createObject("component","V16.training_management.cfc.training_survey")> 
<cfif isdefined("session.ww.userid")>
	<cfset member_id = session.ww.userid>
<cfelseif isdefined("session.pp.userid")>
	<cfset member_id = session.pp.userid>
<cfelse>
	<cfset member_id = 0>
</cfif>
<cfif isdefined("attributes.option_record_num") and len(attributes.option_record_num)>
	<cfset counter_ = attributes.option_record_num>
<cfelse>
	<cfset counter_ = 1>
</cfif>
<cfloop from="0" to="#counter_#" index="i">
	<cfif isdefined('attributes.option_image#i#') and len(evaluate("attributes.option_image#i#"))>
		<cfset upload_folder_ = "#upload_folder#helpdesk#dir_seperator#">
		<cfoutput>#evaluate('attributes.option_image#i#')#</cfoutput>
		<cftry>   
			<cffile action = "upload" fileField = "option_image#i#" destination = "#upload_folder_#" nameConflict = "MakeUnique" mode="777">
			<script type="text/javascript">
				alert("<cf_get_lang dictionary_id='49052.Dosyanız Upload Edildi!'>");
				history.back();
			</script>
			<cfcatch type="Any">
				<script type="text/javascript">
					alert("<cf_get_lang_main no='43.Dosyanız Upload Edilemedi ! Dosyanızı Kontrol Ediniz !'>");
					history.back();
				</script>
				<cfabort>
			</cfcatch>  
		</cftry>   
		<cfset file_name = "#createUUID()#.#cffile.serverfileext#">
		<cffile action="rename" source="#upload_folder_##cffile.serverfile#" destination="#upload_folder_##file_name#">
		<cfset asset_file_real_name = cffile.serverfile>
		<cfset fileSize = cffile.filesize>
		<cfset fileServerId=fusebox.server_machine>
		<cfset moduleName="call">
		<cfset moduleId=45>
		<cfset actionSection="CUS_HELP_ID">
        <cfset add_asset=cfc.AddAsset(assetcat_id:iif(isdefined("attributes.assetcat_id"),"attributes.assetcat_id",DE("")),
			property_id:iif(isdefined("attributes.property_id"),"attributes.property_id",DE("")),
			moduleName:moduleName,
			moduleId:moduleId,
			actionSection:actionSection,
			file_name:file_name,
			asset_file_real_name:asset_file_real_name,
			fileSize:ROUND(fileSize/1024),
			fileServerId:fileServerId,
			member_id:member_id)> 
	</cfif>
</cfloop>
<!--- //Gozat Belge Ekleme Kontrolleri- Dijital Varliklara Atiliyor --->

<!--- Ilgili Chapter'a Question ve Option Eklenir --->
<cfset get_line_number=cfc.GetLineNumber(survey_chapter_id:attributes.survey_chapter_id)>  
<cfif len(get_line_number.line_number)>
	<cfset line_number_plus = get_line_number.line_number + 1>
<cfelse>
	<cfset line_number_plus = 1>
</cfif>
<cfset add_survey_questions=cfc.AddSurveyQuestions(
	survey_chapter_id:attributes.survey_chapter_id,
	survey_id:attributes.survey_id,
	is_question:iif(isdefined("attributes.is_question"),"attributes.is_question",DE("")),
	line_number_plus:line_number_plus,
	question_head:iif(isdefined("attributes.question_head"),"attributes.question_head",DE("")),
	question_detail:iif(isdefined("attributes.question_detail"),"attributes.question_detail",DE("")),
	question_type:iif(isdefined("attributes.question_type"),"attributes.question_type",DE("")),
	question_design:iif(isdefined("attributes.question_design"),"attributes.question_design",DE("")),
	question_validation_question_id:iif(isdefined("attributes.question_validation_question_id"),"attributes.question_validation_question_id",DE("")),
	option_image0:iif(isdefined("attributes.option_image0"),"attributes.option_image0",DE("")),
	file_name:iif(isdefined("file_name"),"file_name",DE("")),
	question_asset:iif(isdefined("attributes.question_asset"),"attributes.question_asset",DE("")),
	question_time_limit:iif(isdefined("attributes.question_time_limit"),"attributes.question_time_limit",DE("")),
	is_show_gd:iif(isdefined("attributes.is_show_gd"),"attributes.is_show_gd",DE(""))
)>

<cfif isdefined('attributes.option_record_num') and len(attributes.option_record_num)>
    <cfloop from="1" to="#attributes.option_record_num#" index="j">
        <cfif isdefined("attributes.add_row_kontrol#j#") and evaluate("attributes.add_row_kontrol#j#") eq 1>
            <cfparam name="attributes.option_point#j#" default="">
            <cfparam name="file_name" default="">
            <cfset add_survey_options1=cfc.add_survey_options2(
                survey_chapter_id:attributes.survey_chapter_id,
                IDENTITYCOL:add_survey_questions.IDENTITYCOL,
                option_head:"#evaluate('attributes.option_head#j#')#",
                option_detail:"#evaluate('attributes.option_detail#j#')#",
                option_score:'#iif(isDefined("attributes.option_score#j#"), 1, 0)#',
                option_score_rate1:"#iif(isdefined("attributes.option_score_rate1"),attributes.option_score_rate1,DE(""))#",
                option_score_rate2:"#iif(isdefined("attributes.option_score_rate2"),attributes.option_score_rate2,DE(""))#",
                option_point:"#iif(isdefined("attributes.option_point#j#") and len(evaluate("attributes.option_point#j#")),evaluate('attributes.option_point#j#'),DE(""))#",
                option_image:"#iif(isdefined("attributes.option_image#j#") and len(evaluate("attributes.option_image#j#")),file_name,DE(""))#"
            )>  
        </cfif>    
    </cfloop>
</cfif>

	<cfloop index="index" from="0" to="#counter_#">
		<cfif isdefined('#evaluate('attributes.question_type#i#')#') and evaluate('attributes.question_type#i#') eq 4>
			<cfset add_survey_options1=cfc.AddSurveyOptions1(survey_chapter_id:attributes.survey_chapter_id,
				identitycol:add_survey_questions.IDENTITYCOL,
				option_score_rate1:evaluate("attributes.option_score_rate1"),
				option_score_rate2:evaluate("attributes.option_score_rate2")
			)>
		<cfelseif isdefined('attributes.option_record_num') and len(attributes.option_record_num)>
        <script>alert("dorğu yerde");</script>
			<cfloop from="1" to="#attributes.option_record_num#" index="j">
				<cfif isdefined("attributes.add_row_kontrol#j#") and evaluate("attributes.add_row_kontrol#j#") eq 1>
					<cfparam name="attributes.option_point#j#" default="">
					<cfparam name="file_name" default="">
					<cfset add_survey_options1=cfc.add_survey_options2(
						survey_chapter_id:attributes.survey_chapter_id,
						IDENTITYCOL:add_survey_questions.IDENTITYCOL,
						option_head:"#evaluate('attributes.option_head#j#')#",
						option_detail:"#evaluate('attributes.option_detail#j#')#",
						option_score:'#iif(isDefined("attributes.option_score#j#"), 1, 0)#',
						option_score_rate1:"#iif(isdefined("attributes.option_score_rate1"),attributes.option_score_rate1,DE(""))#",
						option_score_rate2:"#iif(isdefined("attributes.option_score_rate2"),attributes.option_score_rate2,DE(""))#",
						option_point:"#iif(isdefined("attributes.option_point#j#") and len(evaluate("attributes.option_point#j#")),evaluate('attributes.option_point#j#'),DE(""))#",
						option_image:"#iif(isdefined("attributes.option_image#j#") and len(evaluate("attributes.option_image#j#")),file_name,DE(""))#"
					)>  
				</cfif>    
			</cfloop>
		</cfif>
		<cfset get_max_question_id=cfc.GetMaxQuestionId(survey_chapter_id:attributes.survey_chapter_id)> 
		<cfset get_survey_options=cfc.GetSurveyOptions(survey_chapter_id:attributes.survey_chapter_id)><!--- bolume eklenen siklar VARSA tip ve tasarim guncellenir--->
			<!---  var olan  GetSurveyOptions kullanılıyor --->
			<!--- bolume eklenen siklar VARSA tip ve tasarim guncellenir--->
			<!--- <cfquery name="get_survey_options" datasource="#dsn#">
				SELECT SURVEY_CHAPTER_ID,QUESTION_TYPE,QUESTION_DESIGN FROM SURVEY_OPTION WHERE SURVEY_CHAPTER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.survey_chapter_id#"> AND SURVEY_QUESTION_ID IS NULL
			</cfquery> --->
			<cfif isdefined('attributes.question_design') and len(attributes.question_design)><cfset question_design_="#attributes.question_design#"><cfelseif len(get_survey_options.question_design)><cfset question_design_="#get_survey_options.question_design#"><cfset question_design_=""></cfif>
			<cfset upd_survey_main=cfc.UpdSurveyMainQuestion(question_type:evaluate('attributes.question_type#i#'),
				question_design:question_design_,
				is_show_gd:iif(isdefined("attributes.is_show_gd"),"attributes.is_show_gd",DE("")),
				QUESTION_ID:get_max_question_id.QUESTION_ID
			)> 
	</cfloop>

<script language="javascript">
	<cfoutput>
		<cfif isdefined("attributes.currentrow")>
			opener.open_questions_list("#attributes.currentrow#","#attributes.survey_chapter_id#","#attributes.survey_id#",1);
		</cfif>
		window.location.href = "#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.popup_upd_detail_survey_questions&survey_question_id=#get_max_question_id.question_id#&survey_chapter_id=#attributes.survey_chapter_id#&survey_id=#attributes.survey_id#<cfif isdefined("attributes.currentrow")>&currentrow=#attributes.currentrow#</cfif>";
	</cfoutput>
</script>