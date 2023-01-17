<cfquery name="get_survey_participants" datasource="#dsn#">
	SELECT 
		SURVEY_MAIN_RESULT_ID,
		PARTNER_ID,
		CONSUMER_ID,
		EMP_ID,
		RECORD_EMP,
		COMPANY_ID,
		ACTION_TYPE,
		ACTION_ID,
		RECORD_DATE,
		SCORE_RESULT,
		CASE WHEN (ACTION_TYPE=6 OR ACTION_TYPE=8 OR ACTION_TYPE= 10)
			THEN (SELECT PC.POSITION_CAT FROM EMPLOYEE_POSITIONS AS EP INNER JOIN SETUP_POSITION_CAT AS PC ON EP.POSITION_CAT_ID = PC.POSITION_CAT_ID WHERE EP.IS_MASTER= 1 AND EP.EMPLOYEE_ID = SURVEY_MAIN_RESULT.ACTION_ID)
			ELSE ''
		END AS POSITION_CAT_NAME,
		CASE WHEN (ACTION_TYPE=6 OR ACTION_TYPE=8 OR ACTION_TYPE= 10)
			THEN (SELECT D.DEPARTMENT_HEAD FROM EMPLOYEE_POSITIONS AS EP INNER JOIN DEPARTMENT AS D ON EP.DEPARTMENT_ID = D.DEPARTMENT_ID WHERE EP.IS_MASTER= 1 AND EP.EMPLOYEE_ID = SURVEY_MAIN_RESULT.ACTION_ID)
			ELSE ''
		END AS DEPARTMENT_NAME,
		CASE WHEN (ACTION_TYPE=6 OR ACTION_TYPE=8 OR ACTION_TYPE= 10)
			THEN (SELECT B.BRANCH_NAME FROM EMPLOYEE_POSITIONS AS EP INNER JOIN DEPARTMENT AS D ON EP.DEPARTMENT_ID = D.DEPARTMENT_ID INNER JOIN BRANCH AS B ON D.BRANCH_ID = D.BRANCH_ID WHERE EP.IS_MASTER= 1 AND EP.EMPLOYEE_ID = SURVEY_MAIN_RESULT.ACTION_ID AND EP.DEPARTMENT_ID = D.DEPARTMENT_ID AND D.BRANCH_ID = B.BRANCH_ID)
			ELSE ''
		END AS BRANCH,
		PROCESS_ROW_ID,
		SCORE_RESULT_EMP,
		SCORE_RESULT_MANAGER1,
		SCORE_RESULT_MANAGER2,
		SCORE_RESULT_MANAGER3,
		SCORE_RESULT_MANAGER4
	FROM 
		SURVEY_MAIN_RESULT 
	WHERE 
		SURVEY_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.survey_id#"> 
		<cfif isdefined("attributes.related_id") and len(attributes.related_id) and isdefined("attributes.related_head") and len(attributes.related_head)>
			AND ACTION_ID = #attributes.related_id#
		</cfif>
		<cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>
			AND ACTION_ID IN(SELECT 
								EMPLOYEE_ID 
							FROM 
								EMPLOYEE_POSITIONS AS EP 
								INNER JOIN DEPARTMENT AS D 
								ON EP.DEPARTMENT_ID = D.DEPARTMENT_ID 
							WHERE 
								D.BRANCH_ID = #attributes.branch_id#
							)
		</cfif>
		<cfif isdefined("attributes.department") and len(attributes.department)>
			AND ACTION_ID IN(SELECT 
								EMPLOYEE_ID 
							FROM 
								EMPLOYEE_POSITIONS AS EP 
								INNER JOIN DEPARTMENT AS D 
								ON EP.DEPARTMENT_ID = D.DEPARTMENT_ID 
							WHERE 
								D.DEPARTMENT_ID = #attributes.department#
							)
		</cfif>
		<cfif isdefined("attributes.position_cat_id") and len(attributes.position_cat_id)>
			AND ACTION_ID IN(SELECT EMPLOYEE_ID FROM EMPLOYEE_POSITIONS AS EP WHERE EP.POSITION_CAT_ID = #attributes.position_cat_id#)
		</cfif>
		<cfif isdefined("attributes.process_stage_id") and len(attributes.process_stage_id)>
			AND PROCESS_ROW_ID = #attributes.process_stage_id#
		</cfif>
	ORDER BY 
		SURVEY_MAIN_RESULT_ID DESC
</cfquery>
<cfquery name="get_total_result" dbtype="query">
    SELECT 
         SURVEY_MAIN_RESULT_ID,
         SCORE_RESULT AS TOTAL_POINT
    FROM 
        get_survey_participants
    GROUP BY	
        SURVEY_MAIN_RESULT_ID,
        SCORE_RESULT
</cfquery>
<cfquery name="get_survey" datasource="#dsn#">
	SELECT 
		SURVEY_MAIN_HEAD,
		TOTAL_SCORE,
		SCORE1,
		COMMENT1,
		SCORE2,
		COMMENT2,
		SCORE3,
		COMMENT3,
		SCORE4,
		COMMENT4,
		SCORE5,
		COMMENT5,
		AVERAGE_SCORE,
		PROCESS_ID,
		IS_MANAGER_0,
		IS_MANAGER_3,
		IS_MANAGER_1,
		IS_MANAGER_4,
		IS_MANAGER_2,
		MANAGER_QUIZ_WEIGHT_2,
		MANAGER_QUIZ_WEIGHT_1,
		EMP_QUIZ_WEIGHT,
		MANAGER_QUIZ_WEIGHT_3,
		MANAGER_QUIZ_WEIGHT_4
	FROM 
		SURVEY_MAIN 
	WHERE 
		SURVEY_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.survey_id#">
</cfquery>
<cfloop from="1" to="6" index="x">
	<cfset 'score#x#_count' = 0>	
</cfloop>	
<cfif len(get_survey.score1)>
    <cfset "_score_1" = get_survey.score1>
<cfelse>
    <cfset "_score_1" = 0>
</cfif>
<cfif len(get_survey.score2)>
    <cfset "_score_2" = get_survey.score2>
<cfelse>
    <cfset "_score_2" =0>
</cfif>
<cfif len(get_survey.score3)>
    <cfset "_score_3" = get_survey.score3>
<cfelse>
    <cfset "_score_3" = 0>
</cfif>
<cfif len(get_survey.score4)>
    <cfset "_score_4" = get_survey.score4>
<cfelse>
    <cfset "_score_4" = 0>
</cfif>
<cfif len(get_survey.score5)>
    <cfset "_score_5" = get_survey.score5>
<cfelse>
    <cfset "_score_5" = 0>
</cfif>
<cfset "_score_6" = get_survey.total_score>

<cfoutput query="get_total_result">
    <cfloop from="1" to="5" index="m">
    <cfif get_total_result.total_point gte evaluate('_score_#m#') and get_total_result.total_point lt evaluate('_score_#m+1#')>
        <cfset 'score#m#_count' = evaluate('score#m#_count')+1>	
    </cfif>
    </cfloop>
</cfoutput>
<cfif get_total_result.recordcount>
<!--
	<cfchart show3d="yes" labelformat="number" pieslicestyle="solid" format="jpg" chartheight="200"> 
		<cfchartseries type="bar"> 
			<cfoutput query="get_survey">
			<cfloop from="1" to="5" index="y">
			<cfif len(evaluate('get_survey.score#y#')) and len(evaluate('get_survey.comment#y#'))>
			<cfchartdata item="#evaluate('get_survey.comment#y#')#" value="#evaluate('score#y#_count')#">
			</cfif>
			</cfloop>
			</cfoutput>
		</cfchartseries>
	</cfchart> -->
	<script src="JS/Chart.min.js"></script>
			<cfoutput query="get_survey">
			<cfloop from="1" to="5" index="y">
			<cfset 'get_survey.score#y#'="#evaluate('get_survey.score#y#')#">
			<cfset  'get_survey.comment#y#'="#evaluate('get_survey.comment#y#')#">
			<cfif len('get_survey.score#y#') and len('get_survey.comment#y#')>
				<cfset 'item_#currentrow#'="#evaluate('get_survey.comment#y#')#">
				<cfset  'value_#currentrow#'="#evaluate('score#y#_count')#">
			</cfif>
			</cfloop>
			</cfoutput>
		 
                                        <canvas id="myChart" style="float:left;max-height:300px;max-width:300px;"></canvas>
                                        <script>
                                            var ctx = document.getElementById('myChart');
                                                var myChart = new Chart(ctx, {
                                                    type: 'bar',
                                                    data: {
                                                        labels: [<cfloop from="1" to="#get_survey.recordcount#" index="jj">
                                                                        <cfoutput>"#evaluate("item_#jj#")#"</cfoutput>,</cfloop>],
                                                        datasets: [{
                                                            label: "<cf_get_lang dictionary_id='64194.grafik sonucu'>",
                                                            backgroundColor: [<cfloop from="1" to="#get_survey.recordcount#" index="jj">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>],
                                                            data: [<cfloop from="1" to="#get_survey.recordcount#" index="jj"><cfoutput>"#evaluate("value_#jj#")#"</cfoutput>,</cfloop>],
                                                        }]
                                                    },
                                                    options: {}
                                            });
                                        </script>		       
<cfelse>
	<cf_get_lang dictionary_id='57484.Kayıt Yok'>!
</cfif>

