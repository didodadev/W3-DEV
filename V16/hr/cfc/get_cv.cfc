<cfcomponent>
	<cffunction name="get_cv" access="public" returntype="query">
		<cfargument name="keyword" default="">
		<cfargument name="cv_status" default="">
		<cfargument name="status" default="">
		<cfargument name="emp_app_type" default="">
		<cfargument name="startdate" default="">
		<cfargument name="finishdate" default="">
		<cfargument name="startrow" default="">
		<cfargument name="maxrows" default="">
        <cfargument name="process_stage" type="string"/>
		<cfquery name="get_cv_" datasource="#this.dsn#">
			WITH CTE1 AS (
				SELECT
					EA.EMPAPP_ID,
					EA.NAME,
					EA.SURNAME,
					EA.EMAIL,
					EA.MOBILCODE,
					EA.MOBIL,
					EA.MOBILCODE2,
					EA.MOBIL2,
					EA.PHOTO,
					EA.PHOTO_SERVER_ID,
					EA.HOMETELCODE,
					EA.HOMETEL,
					EA.SEX,
					EA.CV_STAGE,
					EA.APP_COLOR_STATUS,
					EA.RECORD_DATE,
					ED.EDU_NAME,
					ED.EDU_PART_NAME,
					WR.EXP,
					WR.EXP_POSITION,
					EI.BIRTH_DATE,
					PTR.STAGE
				FROM
					EMPLOYEES_APP EA
					LEFT JOIN EMPLOYEES_APP_EDU_INFO ED ON ED.EMPAPP_EDU_ROW_ID = (SELECT TOP 1 EMPAPP_EDU_ROW_ID FROM EMPLOYEES_APP_EDU_INFO WHERE EMPAPP_ID = EA.EMPAPP_ID ORDER BY EDU_START DESC)
					LEFT JOIN EMPLOYEES_APP_WORK_INFO WR ON WR.EMPAPP_ROW_ID = (SELECT TOP 1 EMPAPP_ROW_ID FROM EMPLOYEES_APP_WORK_INFO WHERE EMPAPP_ID = EA.EMPAPP_ID ORDER BY EXP_START DESC)
					LEFT JOIN EMPLOYEES_IDENTY EI ON EI.EMPAPP_ID = EA.EMPAPP_ID
					LEFT JOIN PROCESS_TYPE_ROWS PTR ON PTR.PROCESS_ROW_ID = EA.CV_STAGE
				WHERE
					EA.EMPAPP_ID IS NOT NULL
					<cfif len(arguments.keyword)>
						AND (EA.NAME + ' ' + EA.SURNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI OR EA.SURNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI)
					</cfif>
					<cfif len(arguments.cv_status)>
						AND EA.APP_COLOR_STATUS = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cv_status#">
					</cfif>
					<cfif len(arguments.status)>
						AND EA.APP_STATUS = <cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.status#">
					</cfif>
					<cfif len(arguments.emp_app_type) and arguments.emp_app_type eq 1>
						AND EA.RECORD_APP_IP IS NULL
						AND EA.RECORD_IP IS NOT NULL
					<cfelseif len(arguments.emp_app_type) and arguments.emp_app_type eq 0>
						AND EA.RECORD_IP IS NULL
						AND EA.RECORD_APP_IP IS NOT NULL
					</cfif>
					<cfif len(arguments.startdate) gt 5>
						AND EA.RECORD_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.startdate#">
					</cfif>
					<cfif len(arguments.finishdate) gt 5>
						AND EA.RECORD_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#dateadd('d',1,arguments.finishdate)#">
					</cfif>
                    <cfif isdefined('arguments.process_stage') and len(arguments.process_stage)>
                    AND EA.CV_STAGE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.process_stage#">
                </cfif>
			),
			CTE2 AS (
				SELECT
					CTE1.*,
					ROW_NUMBER() OVER (ORDER BY NAME
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
		<cfreturn get_cv_>
	</cffunction>
</cfcomponent>
