<cfset start_date = dateformat(attributes.startdate,dateformat_style)>
<cfset finish_date = dateformat(attributes.finishdate,dateformat_style)>
<cfset cfc=createObject("component","V16.training_management.cfc.training_survey")> 
 <cfset upd_survey_main=cfc.UpdSurveyMain(
	head:iif(isdefined("attributes.head"),"attributes.head",DE("")),
	detail:iif(isdefined("attributes.detail"),"attributes.detail",DE("")),
	is_active:iif(isdefined("attributes.is_active"),"attributes.is_active",DE("")),
	is_one_result:iif(isdefined("attributes.is_one_result"),"attributes.is_one_result",DE("")),
	is_selected_attender:iif(isdefined("attributes.is_selected_attender"),"attributes.is_selected_attender",DE("")),
	is_not_show_saved:iif(isdefined("attributes.IS_NOT_SHOW_SAVED"),"attributes.IS_NOT_SHOW_SAVED",DE("")),
	is_show_myhome:iif(isdefined("attributes.IS_SHOW_MYHOME"),"attributes.IS_SHOW_MYHOME",DE("")),
	is_position_competence_measured:iif(isdefined("attributes.IS_POSITION_COMPETENCE_MEASURED"),"attributes.IS_POSITION_COMPETENCE_MEASURED",DE("")),
	is_position_targets_measured:iif(isdefined("attributes.IS_POSITION_TARGETS_MEASURED"),"attributes.IS_POSITION_TARGETS_MEASURED",DE("")),
	type:iif(isdefined("attributes.type"),"attributes.type",DE("")),
	process_stage:iif(isdefined("attributes.process_stage"),"attributes.process_stage",DE("")),
	language_id:iif(isdefined("attributes.language_id"),"attributes.language_id",DE("")),
	employee_id:iif(isdefined("attributes.employee_id"),"attributes.employee_id",DE("")),
	score1:iif(isdefined("attributes.score1"),"attributes.score1",DE("")),
	score2:iif(isdefined("attributes.score2"),"attributes.score2",DE("")),
	score3:iif(isdefined("attributes.score3"),"attributes.score3",DE("")),
	score4:iif(isdefined("attributes.score4"),"attributes.score4",DE("")),
	score5:iif(isdefined("attributes.score5"),"attributes.score5",DE("")),
	comment1:iif(isdefined("attributes.comment1"),"attributes.comment1",DE("")),
	comment2:iif(isdefined("attributes.comment2"),"attributes.comment2",DE("")),
	comment3:iif(isdefined("attributes.comment3"),"attributes.comment3",DE("")),
	comment4:iif(isdefined("attributes.comment4"),"attributes.comment4",DE("")),
	comment5:iif(isdefined("attributes.comment5"),"attributes.comment5",DE("")),
	analysis_average:iif(isdefined("attributes.analysis_average"),"attributes.analysis_average",DE("")),
	total_score:iif(isdefined("attributes.total_score"),"attributes.total_score",DE("")),
	is_manager_0:iif(isdefined("attributes.IS_MANAGER_0"),"attributes.IS_MANAGER_0",DE("")),
	is_manager_1:iif(isdefined("attributes.IS_MANAGER_1"),"attributes.IS_MANAGER_1",DE("")),
	is_manager_2:iif(isdefined("attributes.IS_MANAGER_2"),"attributes.IS_MANAGER_2",DE("")),
	is_manager_3:iif(isdefined("attributes.IS_MANAGER_3"),"attributes.IS_MANAGER_3",DE("")),
	is_manager_4:iif(isdefined("attributes.IS_MANAGER_4"),"attributes.IS_MANAGER_4",DE("")),
	emp_quiz_weight:iif(isdefined("attributes.emp_quiz_weight"),"attributes.emp_quiz_weight",DE("")),
	manager_quiz_weight_1:iif(isdefined("attributes.manager_quiz_weight_1"),"attributes.manager_quiz_weight_1",DE("")),
	manager_quiz_weight_2:iif(isdefined("attributes.manager_quiz_weight_2"),"attributes.manager_quiz_weight_2",DE("")),
	manager_quiz_weight_3:iif(isdefined("attributes.manager_quiz_weight_3"),"attributes.manager_quiz_weight_3",DE("")),
	manager_quiz_weight_4:iif(isdefined("attributes.manager_quiz_weight_4"),"attributes.manager_quiz_weight_4",DE("")),
	process_id:iif(isdefined("attributes.process_id"),"attributes.process_id",DE("")),
	startdate:start_date,
	finishdate:finish_date,
    survey_id:iif(isdefined("attributes.survey_id"),"attributes.survey_id",DE("")),
	survey_period:iif(isdefined("attributes.survey_period"),"attributes.survey_period",DE("0"))
)> 
<cfset del_position_cats=cfc.DelPositionCats(survey_id:attributes.survey_id)> 
 <cfset del_project_cats=cfc.DelProjectCats(survey_id:attributes.survey_id)> 
 <cfset del_work_cats=cfc.DelWorkCats(survey_id:attributes.survey_id)> 
<!--- pozisyon tipleri ekleme--->
<cfif isdefined("attributes.position_cats") and len(attributes.position_cats)>
	<cfloop list="#attributes.position_cats#" index="i" delimiters=",">
		<cfset add_main_position_cats=cfc.AddMainPositionCatsUpd(survey_id:attributes.survey_id,i:i)>
	</cfloop>
</cfif>
<!--- proje kategorileri ekleme--->
<cfif isdefined("attributes.project_cats") and len(attributes.project_cats)>
	<cfloop list="#attributes.project_cats#" index="i" delimiters=",">
		 <cfset add_main_project_cats=cfc.AddMainProjectCatUpd(survey_id:attributes.survey_id,i:i)> 
	</cfloop>
</cfif>
<!--- iş kategorileri ekleme--->
<cfif isdefined("attributes.work_cats") and len(attributes.work_cats)>
	<cfloop list="#attributes.work_cats#" index="i" delimiters=",">
		 <cfset add_main_work_cats=cfc.AddMainWorkCatsUpd(survey_id:attributes.survey_id,i:i)> 
	</cfloop>
</cfif>
<cfset attributes.actionId = attributes.survey_id>
<cfif isdefined("attributes.is_popup") and attributes.is_popup eq 1>
	<script type="text/javascript">
    	window.location.href="<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_detail_survey&event=upd&survey_id=#attributes.survey_id#</cfoutput>";
    </script>
<cfelse>
	<script type="text/javascript">
    	window.location.href="<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_detail_survey&event=upd&survey_id=#attributes.survey_id#</cfoutput>";
    </script>
</cfif>
