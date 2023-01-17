<cf_date tarih='attributes.start_date'>
<cf_date tarih='attributes.finish_date'>
<cftransaction> 
	<cfquery name="upd_perform" datasource="#dsn#">
		 UPDATE
			EMPLOYEE_PERFORMANCE
		 SET	
			EMPLOYEE_OPINION = '#EMPLOYEE_OPINION#',
			<cfif isdefined('EMPLOYEE_OPINION_ID')>
			EMPLOYEE_OPINION_ID = #EMPLOYEE_OPINION_ID#,
			</cfif>
			EMPLOYEE_OPINION_DATE = #now()#,
			EMPLOYEE_OPINION_EMP_ID = #session.ep.userid#
		WHERE
			EMP_ID = #attributes.emp_id#
		AND
			START_DATE = #attributes.start_date#
		AND
			FINISH_DATE = #attributes.finish_date#
		AND
			RESULT_ID IN (SELECT RESULT_ID FROM EMPLOYEE_QUIZ_RESULTS WHERE QUIZ_ID=#attributes.QUIZ_ID# 
							AND 
								EMP_ID = #attributes.emp_id#
							AND
								START_DATE = #attributes.start_date#
							AND
								FINISH_DATE = #attributes.finish_date#
								)
	</cfquery> 
</cftransaction>

<cflocation addtoken="no" url="#request.self#?fuseaction=myhome.myperformance">
