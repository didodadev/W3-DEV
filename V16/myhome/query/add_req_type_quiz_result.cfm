<cfif isdefined("attributes.start_date") and isdefined("attributes.finish_date")>
	<cf_date tarih='attributes.start_date'>
	<cf_date tarih='attributes.finish_date'>
	<cfquery name="get_per_form" datasource="#dsn#">
		SELECT 
			PER_ID 
		FROM 
			EMPLOYEE_PERFORMANCE
		WHERE 
			((START_DATE BETWEEN #attributes.start_date# AND #attributes.finish_date#)
			OR (FINISH_DATE BETWEEN #attributes.start_date# AND #attributes.finish_date#))
			AND POSITION_CODE=#attributes.position_code# 
			AND PER_ID <> #attributes.PER_ID#
	</cfquery>
	<cfif get_per_form.recordcount>
		<script type="text/javascript">
			alert("<cf_get_lang no ='1220.Tarih aralığında çalışan için form eklenmiştir'>");
			history.back(-1);
		</script>
		<cfabort>
	</cfif>
</cfif>
<cfif isdefined("attributes.amir_valid_1") and attributes.amir_valid_1 neq -1>
	<cfquery name="upd_perform" datasource="#dsn#">
		UPDATE
			EMPLOYEE_PERFORMANCE_TARGET
		SET
			<cfif isdefined("attributes.emp_target_opinion")>EMP_TARGET_OPINION = '#attributes.emp_target_opinion#',</cfif>
			<cfif isdefined("attributes.emp_req_opinion")>EMP_REQ_OPINION = '#attributes.emp_req_opinion#',</cfif>
			<cfif isdefined("attributes.manager_target_opinion")>MANAGER_TARGET_OPINION='#attributes.manager_target_opinion#',</cfif>
			<cfif isdefined("attributes.manager_req_opinion")>MANAGER_REQ_OPINION='#attributes.manager_req_opinion#',</cfif>
			<cfif isdefined("attributes.manager_career_exp")>MANAGER_CAREER_EXP='#attributes.manager_career_exp#',</cfif>
			PERFORM_POINT=#attributes.user_point#,
			<cfif isdefined("attributes.amir_valid_1") and attributes.amir_valid_1 eq 1>
				FIRST_BOSS_ID=#session.ep.userid#,
				FIRST_BOSS_VALID=1,
				FIRST_BOSS_VALID_DATE=#NOW()#,
			<cfelseif isdefined("attributes.amir_valid_2")>
				SECOND_BOSS_ID=#session.ep.userid#,
				SECOND_BOSS_VALID=1,
				SECOND_BOSS_VALID_DATE=#NOW()#,
			<cfelseif isdefined("attributes.amir_valid_3")>
				THIRD_BOSS_ID=#session.ep.userid#,
				THIRD_BOSS_VALID=1,
				THIRD_BOSS_VALID_DATE=#NOW()#,
			<cfelseif isdefined("attributes.amir_valid_4")>
				FOURTH_BOSS_ID=#session.ep.userid#,
				FOURTH_BOSS_VALID=1,
				FOURTH_BOSS_VALID_DATE=#NOW()#,
			<cfelseif isdefined("attributes.amir_valid_5")>
				FIFTH_BOSS_ID=#session.ep.userid#,
				FIFTH_BOSS_VALID=1,
				FIFTH_BOSS_VALID_DATE=#NOW()#,
			</cfif>
			UPDATE_EMP = '#SESSION.EP.USERID#',
			UPDATE_IP = '#CGI.REMOTE_ADDR#',
			UPDATE_DATE = #now()#
		WHERE
			PER_ID = #attributes.PER_ID#
	</cfquery>
	
	<cfif isdefined("attributes.start_date") and isdefined("attributes.finish_date")>
		<cfquery name="UPD_QUIZ_RESULT" datasource="#dsn#">
			UPDATE 
				EMPLOYEE_QUIZ_RESULTS
			SET
				START_DATE=#attributes.start_date#,
				FINISH_DATE=#attributes.finish_date#
			WHERE 
				RESULT_ID=#attributes.result_id#
		</cfquery>
	</cfif>
	<cfquery name="upd_perform" datasource="#dsn#">
		UPDATE
			EMPLOYEE_PERFORMANCE
		SET
			<cfif isdefined("attributes.start_date")>START_DATE=#attributes.start_date#,</cfif>
			<cfif isdefined("attributes.finish_date")>FINISH_DATE=#attributes.finish_date#,</cfif>
			USER_POINT=#attributes.user_point#
		WHERE
			PER_ID = #attributes.PER_ID#
	</cfquery>
<cfelse>
	<cfquery name="upd_perform" datasource="#dsn#">
		UPDATE
			EMPLOYEE_PERFORMANCE_TARGET
		SET
			FIRST_BOSS_VALID=NULL,
			FIRST_BOSS_VALID_DATE=NULL,
			SECOND_BOSS_VALID=NULL,
			SECOND_BOSS_VALID_DATE=NULL,
			THIRD_BOSS_VALID=NULL,
			THIRD_BOSS_VALID_DATE=NULL,
			FOURTH_BOSS_VALID=NULL,
			FOURTH_BOSS_VALID_DATE=NULL,
			FIFTH_BOSS_VALID=NULL,
			FIFTH_BOSS_VALID_DATE=NULL,
			UPDATE_EMP = '#SESSION.EP.USERID#',
			UPDATE_IP = '#CGI.REMOTE_ADDR#',
			UPDATE_DATE = #now()#
		WHERE
			PER_ID = #attributes.PER_ID#
	</cfquery>
</cfif>
<cflocation url="#request.self#?fuseaction=myhome.popup_form_add_req_type_result&position_code=#attributes.position_code#&result_id=#attributes.result_id#&per_id=#attributes.per_id#" addtoken="no">
