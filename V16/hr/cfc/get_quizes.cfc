<cfcomponent>
	<cffunction name="get_quiz" access="public" returntype="query">
		<cfargument name="relation_action" default="">
		<cfargument name="is_active" default="">
		<cfargument name="is_education" default="">
		<cfargument name="is_trainer" default="">
		<cfargument name="form_year" default="">
		<cfargument name="startrow" default="">
		<cfargument name="maxrows" default="">
        <cfquery name="get_quiz_" datasource="#this.dsn#">
        	WITH CTE1 AS (
	            SELECT 
					QUIZ_ID,
					QUIZ_HEAD,
					POSITION_ID, 
					RS.RELATION_ACTION_ID POSITION_CAT_ID,
					FORM_OPEN_TYPE
				FROM 
					EMPLOYEE_QUIZ
					INNER JOIN RELATION_SEGMENT_QUIZ RS ON EMPLOYEE_QUIZ.QUIZ_ID = RS.RELATION_FIELD_ID
				WHERE
					1 = 1
					<cfif len(arguments.relation_action)>
						AND RS.RELATION_ACTION = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.relation_action#"> <!--- RELATION_SEGMENT_QUIZ tablosunda pozisyon tipi alanını ifade eder --->
					</cfif>
					<cfif len(arguments.is_active)>
						AND EMPLOYEE_QUIZ.IS_ACTIVE = <cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.is_active#">
					</cfif>
					<cfif len(arguments.is_education)>
						AND EMPLOYEE_QUIZ.IS_EDUCATION = <cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.is_education#">
					</cfif>
					<cfif len(arguments.is_trainer)>
						AND EMPLOYEE_QUIZ.IS_TRAINER = <cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.is_trainer#">
					</cfif>
					<cfif len(arguments.form_year)>
						AND EMPLOYEE_QUIZ.FORM_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.form_year#">
					</cfif>
			),
			CTE2 AS (
				SELECT
					CTE1.*,
					ROW_NUMBER() OVER (ORDER BY QUIZ_HEAD
			) AS RowNum,(SELECT COUNT(*) FROM CTE1) AS QUERY_COUNT
				FROM
					CTE1
			)
			SELECT
				CTE2.*
			FROM
				CTE2
			<cfif len(arguments.startrow) and len(arguments.maxrows)>
				WHERE
					RowNum BETWEEN #arguments.startrow# and #arguments.startrow#+(#arguments.maxrows#-1)
			</cfif>
        </cfquery>
  		<cfreturn get_quiz_>
	</cffunction>
</cfcomponent>
