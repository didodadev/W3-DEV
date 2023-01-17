<cfinclude template="../query/get_class.cfm">
 <cfquery name="get_emp_att" datasource="#dsn#">
	SELECT DISTINCT
		TRAINING_CLASS_ATTENDER.EMP_ID,
		EMPLOYEE_POSITIONS.EMPLOYEE_NAME,
		EMPLOYEE_POSITIONS.EMPLOYEE_SURNAME
	FROM 
		TRAINING_CLASS_ATTENDER,
		EMPLOYEE_POSITIONS,
		DEPARTMENT,
		BRANCH,
		OUR_COMPANY C
	WHERE 
		EMPLOYEE_POSITIONS.DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID AND
		DEPARTMENT.BRANCH_ID=BRANCH.BRANCH_ID AND 
		BRANCH.BRANCH_ID IN (
                                SELECT
                                    BRANCH_ID
                                FROM
                                    EMPLOYEE_POSITION_BRANCHES
                                WHERE
                                    POSITION_CODE = #SESSION.EP.POSITION_CODE#	
                            ) AND 
		C.COMP_ID=BRANCH.COMPANY_ID AND
		EMPLOYEE_POSITIONS.EMPLOYEE_ID = TRAINING_CLASS_ATTENDER.EMP_ID AND
		CLASS_ID=#attributes.CLASS_ID# AND 
		EMP_ID IS NOT NULL AND
		PAR_ID IS NULL AND 
		CON_ID IS NULL
	ORDER BY
		EMPLOYEE_POSITIONS.EMPLOYEE_NAME,
		EMPLOYEE_POSITIONS.EMPLOYEE_SURNAME
</cfquery>
<cfquery name="GET_QUIZ" datasource="#dsn#">
	SELECT 
        TRAINING_ID,
        QUIZ_ID, 
        QUIZ_HEAD, 
        QUIZ_STARTDATE, 
        QUIZ_FINISHDATE, 
        TAKE_LIMIT, 
        RECORD_EMP, 
        CLASS_ID
    FROM 
        QUIZ 
    WHERE 
    	QUIZ_ID=#attributes.quiz_id#
</cfquery>
<cf_popup_box title="#getLang('training_management',2)#">
	<table>
		<cfif get_emp_att.recordcount>
		<cfset attender_emp_id_list=''>
			<cfoutput query="get_emp_att">
				<cfif not listfind(attender_emp_id_list,EMP_ID)>
					<cfset attender_emp_id_list=listappend(attender_emp_id_list,EMP_ID)>
				</cfif>
			</cfoutput>
		<cfset attender_emp_id_list=listsort(attender_emp_id_list,"numeric")>
		<cfif len(attender_emp_id_list)>
			<cfquery name="GET_QUIZ_RESULTS_2" datasource="#dsn#">
				SELECT 
					USER_POINT,
					RESULT_ID,
					EMP_ID,
					RECORD_EMP
				FROM 
					QUIZ_RESULTS
				WHERE
					QUIZ_RESULTS.QUIZ_ID = #attributes.QUIZ_ID# AND
					EMP_ID IN (#attender_emp_id_list#)
				ORDER BY EMP_ID DESC
			</cfquery>	
		</cfif>
		<cfoutput query="get_emp_att">
				<cfquery name="GET_USER_JOIN_QUIZ" datasource="#dsn#">
					SELECT 
						RESULT_ID,
						EMP_ID
					FROM 
						QUIZ_RESULTS
					WHERE
						EMP_ID=#emp_id# AND
						QUIZ_ID=#attributes.QUIZ_ID# AND
						IS_STOPPED_QUIZ = 0
				</cfquery>
			<cfquery name="GET_USER_JOIN_QUIZ_STOPPED" datasource="#dsn#">
				SELECT 
					RESULT_ID,
					EMP_ID
				FROM 
					QUIZ_RESULTS
				WHERE
					EMP_ID=#emp_id# AND
					QUIZ_ID=#attributes.QUIZ_ID# AND
					IS_STOPPED_QUIZ = 1
			</cfquery>
			<cfquery name="GET_QUIZ_RESULTS" dbtype="query" maxrows="1">
				SELECT 
					USER_POINT,
					RECORD_EMP
				FROM 
					GET_QUIZ_RESULTS_2
				WHERE
					EMP_ID = #emp_id#
				ORDER BY RESULT_ID DESC
			</cfquery>
			<cfquery name="GET_USER_JOIN_QUIZ_MAX_RECORD" datasource="#dsn#" maxrows="1">
				SELECT 
					RESULT_ID,
					RECORD_EMP
				FROM 
					QUIZ_RESULTS
				WHERE
					EMP_ID=#emp_id# AND
					QUIZ_ID=#attributes.QUIZ_ID#
				ORDER BY RESULT_ID ASC
			</cfquery>
			<tr>
				<td>#EMPLOYEE_NAME#&nbsp;#EMPLOYEE_SURNAME#</td>
				<td>
					<cfif GET_USER_JOIN_QUIZ_STOPPED.recordcount>
						<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=training_management.popup_make_quiz&result_id=#get_user_join_quiz_stopped.result_id#&quiz_id=#attributes.quiz_id#&emp_id=#emp_id#&page_type=1','medium');" class="tableyazi"><img src="images/transfer.gif" border="0" title="testi cevapla"></a>
						<cfelse>
						<cfif get_user_join_quiz.recordcount LTE get_quiz.take_limit>
						<cfif get_user_join_quiz.recordcount eq 0>
							<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=training_management.popup_make_quiz&quiz_id=#attributes.quiz_id#&emp_id=#emp_id#&page_type=1','medium');" class="tableyazi"><img src="images/plus_list.gif" border="0" title="testi cevapla"></a>
						<!--- <cfif GET_QUIZ_RESULTS.recordcount>#GET_QUIZ_RESULTS.USER_POINT#/100</cfif> --->
						</cfif>
						<cfif get_user_join_quiz.recordcount gt 0 and get_user_join_quiz.recordcount neq get_quiz.take_limit>
						<cfif (GET_USER_JOIN_QUIZ_MAX_RECORD.RECORD_EMP eq session.ep.userid or session.ep.userid eq emp_id)>
							<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=training_management.popup_make_quiz&quiz_id=#attributes.quiz_id#&emp_id=#emp_id#&page_type=1','medium');" class="tableyazi"><img src="images/update_list.gif" border="0" title="testi cevapla"></a>
						</cfif>
						<cfif GET_QUIZ_RESULTS.recordcount>#GET_QUIZ_RESULTS.USER_POINT#/100</cfif>
						</cfif>
						</cfif>
						<cfif get_user_join_quiz.recordcount GTE get_quiz.take_limit>
							#GET_QUIZ_RESULTS.USER_POINT#/100
						</cfif>
					</cfif>
				</td>
			</tr>
		</cfoutput>
		<cfelse>
			<tr>
				<td>Kullanıcı Yok !</td>
			</tr>
		</cfif>
	</table>
</cf_popup_box>

