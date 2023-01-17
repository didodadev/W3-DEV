<cfcomponent>
	<cffunction name="get_app" access="public" returntype="query">
		<cfargument name="start_date" default="">
		<cfargument name="finish_date" default="">
		<cfargument name="keyword" default="">
		<cfargument name="commethod_id" default="">
		<cfargument name="status" default="">
		<cfargument name="company_id" default="">
		<cfargument name="process_stage" default="">
		<cfargument name="department_id" default="">
		<cfargument name="branch_id" default="">
		<cfargument name="our_company_id" default="">
		<cfargument name="notice_id" default="">
		<cfargument name="in_status" default="">
		<cfargument name="notice_cat_id" default="">
		<cfargument name="date_status" default="1">
		<cfargument name="startrow" default="">
		<cfargument name="maxrows" default="">
		<cfquery name="get_app_" datasource="#this.dsn#">
		SELECT
			EMPLOYEES_APP.EMPAPP_ID,
			EMPLOYEES_APP_POS.APP_POS_ID,
			EMPLOYEES_APP_POS.POSITION_ID,
			EMPLOYEES_APP_POS.POSITION_CAT_ID,
			EMPLOYEES_APP_POS.APP_DATE,
			EMPLOYEES_APP.NAME,
			EMPLOYEES_APP.SURNAME,
			EMPLOYEES_APP.STEP_NO,
			EMPLOYEES_APP_POS.NOTICE_ID,
			EMPLOYEES_APP.COMMETHOD_ID,
			EMPLOYEES_APP_POS.APP_POS_STATUS,
			EMPLOYEES_APP.RECORD_DATE,
			EMPLOYEES_IDENTY.BIRTH_DATE,
			NOTICES.NOTICE_NO,
			NOTICES.NOTICE_HEAD,
			SETUP_NOTICE_GROUP.NOTICE
		FROM
			EMPLOYEES_APP
			INNER JOIN EMPLOYEES_APP_POS ON EMPLOYEES_APP.EMPAPP_ID = EMPLOYEES_APP_POS.EMPAPP_ID
			INNER JOIN EMPLOYEES_IDENTY ON EMPLOYEES_APP.EMPAPP_ID = EMPLOYEES_IDENTY.EMPAPP_ID
			LEFT JOIN NOTICES ON NOTICES.NOTICE_ID = EMPLOYEES_APP_POS.NOTICE_ID
			LEFT JOIN SETUP_NOTICE_GROUP ON SETUP_NOTICE_GROUP.NOTICE_CAT_ID = NOTICES.NOTICE_CAT_ID
		WHERE
			EMPLOYEES_APP.EMPAPP_ID IS NOT NULL
			AND EMPLOYEES_IDENTY.EMPAPP_ID IS NOT NULL
			<cfif len(arguments.start_date)>
				AND EMPLOYEES_APP_POS.APP_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.start_date#">
			</cfif>
			<cfif len(arguments.finish_date)>
				AND EMPLOYEES_APP_POS.APP_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#dateadd('d',1,arguments.finish_date)#">
			</cfif>
			<cfif len(arguments.keyword)>
				AND (EMPLOYEES_APP.NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI OR
					EMPLOYEES_APP.SURNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI)
			</cfif>
			<cfif len(arguments.commethod_id) and (arguments.commethod_id neq 0)>
				AND EMPLOYEES_APP_POS.COMMETHOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.commethod_id#">
			</cfif>
			<cfif len(arguments.status) eq 1>
				AND EMPLOYEES_APP_POS.APP_POS_STATUS = <cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.status#">
			</cfif>
			<cfif len(arguments.company_id)>
				AND EMPLOYEES_APP_POS.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.company_id#">
			</cfif>
			<cfif len(arguments.process_stage)>
				AND EMPLOYEES_APP_POS.APP_STAGE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.process_stage#">
			</cfif>
			<cfif len(arguments.department_id)>
				AND EMPLOYEES_APP_POS.DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.department_id#">
			</cfif>
			<cfif len(arguments.branch_id)>
				AND EMPLOYEES_APP_POS.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.branch_id#">
				<cfif len(arguments.our_company_id)>
					AND EMPLOYEES_APP_POS.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.our_company_id#">
				</cfif>	
			</cfif>
			<cfif len(arguments.notice_id)>
				AND EMPLOYEES_APP_POS.NOTICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.notice_id#">
			</cfif>
			<cfif len(arguments.in_status)>
				AND EMPLOYEES_APP_POS.IS_INTERNAL = <cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.in_status#">
			</cfif>
			<cfif len(arguments.notice_cat_id)>
				AND EMPLOYEES_APP_POS.NOTICE_ID IN (SELECT NOTICE_ID FROM NOTICES WHERE NOTICE_CAT_ID IN (#arguments.notice_cat_id#))
			</cfif>
		</cfquery>
		<cfreturn get_app_>
	</cffunction>
</cfcomponent>
