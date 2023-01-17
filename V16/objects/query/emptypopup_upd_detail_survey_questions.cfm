<!--- İmaj Ekleniyor - Dijital Varliklara Atiliyor --->
<cfset cfc=createObject("component","V16.training_management.cfc.training_survey")> 
<cfif isdefined("session.ww.userid")>
	<cfset member_id = session.ww.userid>
<cfelseif isdefined("session.pp.userid")>
	<cfset member_id = session.pp.userid>
<cfelse>
	<cfset member_id = 0>
</cfif>
<cfloop from="1" to="#attributes.option_record_num#" index="i">
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
							member_id:member_id
							)> 
	</cfif>
</cfloop>
<!--- İmaj Ekleniyor - Dijital Varliklara Atiliyor --->
<!--- bolume eklenen siklar VARSA tekrar kayda izin vermez--->
<cfset get_survey_options=cfc.GetSurveyOptions(survey_chapter_id:attributes.survey_chapter_id)>

  <cfset upd_survey_main=cfc.UpdSurveyQuestion(
	is_question:iif(isdefined("attributes.is_question"),"attributes.is_question",DE("0")),
	head:iif(isdefined("attributes.head"),"attributes.head",DE("")),
	detail:iif(isdefined("attributes.detail"),"attributes.detail",DE("")),
	question_type:iif(isdefined("attributes.question_type"),"attributes.question_type","get_survey_options.question_type"),
	question_design:iif(isDefined("attributes.question_design"),"attributes.question_design","get_survey_options.question_design"),
	option_image0:iif(isdefined("attributes.option_image0"),"attributes.option_image0",DE("")),
	file_name:iif(isdefined("file_name"),"file_name",DE("")),
	question_image:iif(isdefined("attributes.question_image"),"attributes.question_image",DE("")),
	asset:iif(isdefined("attributes.asset"),"attributes.asset",DE("")),
	question_time_limit:iif(isdefined("attributes.question_time_limit"),"attributes.question_time_limit",DE("")),
	validation_question_id:iif(isdefined("attributes.validation_question_id"),"attributes.validation_question_id",DE("")),
	is_show_gd:iif(isdefined("attributes.is_show_gd"),"attributes.is_show_gd",DE("")),
	survey_question_id:iif(isdefined("attributes.survey_question_id"),"attributes.survey_question_id",DE(""))
)>  
 
<cfset del_survey_options=cfc.DelSurveyOptions(attributes.survey_question_id)>

<!--- <cfif isdefined('attributes.question_type') and attributes.question_type eq 4>
	<cfquery name="add_survey_options" datasource="#dsn#">
		INSERT INTO 
			SURVEY_OPTION
			(	
				SURVEY_CHAPTER_ID,
				SURVEY_QUESTION_ID<!--- ,
				SCORE_RATE1,
				SCORE_RATE2 --->
			)
			VALUES
			(	
				<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.survey_chapter_id#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.survey_question_id#"><!--- ,
				<cfif isdefined("attributes.option_score_rate1") and len(evaluate("attributes.option_score_rate1"))><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.option_score_rate1')#">,<cfelse>NULL,</cfif> 
				<cfif isdefined("attributes.option_score_rate1") and len(evaluate("attributes.option_score_rate2"))><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.option_score_rate2')#"><cfelse>NULL</cfif>  ---> 
			)
	</cfquery>
<cfelse>   --->
	
	<cfif not get_survey_options.recordcount>
		<cfloop from="1" to="#attributes.option_record_num#" index="i">
			<cfif isdefined("attributes.row_kontrol_options#i#") and evaluate("attributes.row_kontrol_options#i#") eq 1>
				<cfif isdefined("attributes.option_image#i#") and len(evaluate("attributes.option_image#i#"))><cfset option_image_="#file_name#"><cfelseif isdefined("attributes.opt_image#i#") and len(evaluate("attributes.opt_image#i#"))><cfset option_image_="#evaluate('attributes.opt_image#i#')#"><cfelse><cfset option_image_=""></cfif> 
				 <cfset add_survey_options=cfc.AddSurveyOptions(
					survey_chapter_id:attributes.survey_chapter_id,
					survey_question_id:attributes.survey_question_id,
					option_head:evaluate("attributes.option_head#i#"),
					option_detail:evaluate("attributes.option_detail#i#"),
					option_point:iif(isdefined("attributes.option_point#i#"),"attributes.option_point#i#",DE("")),
					option_image:option_image_

				)>  
			</cfif>
		</cfloop>
    <cfelse>
	</cfif>
<!--- </cfif>  --->
<script language="javascript">
	<cfif isDefined("attributes.draggable")>
		closeBoxDraggable('<cfoutput>#attributes.modal_id#</cfoutput>');
	<cfelse>
		<cfoutput>
			<cfif isdefined("attributes.currentrow")>
				opener.open_questions_list("#attributes.currentrow#","#attributes.survey_chapter_id#","#attributes.survey_id#",1);
			</cfif>
			window.location.href = "#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.popup_upd_detail_survey_questions&survey_question_id=#attributes.survey_question_id#&survey_chapter_id=#attributes.survey_chapter_id#&survey_id=#attributes.survey_id#<cfif isdefined("attributes.currentrow")>&currentrow=#attributes.currentrow#</cfif>";
		</cfoutput>
	</cfif>
</script>