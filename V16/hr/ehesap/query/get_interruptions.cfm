<cfinclude template="../../query/get_emp_codes.cfm">
<cfset aybasi = CreateDate(attributes.yil, attributes.aylar, 1)>
<cfset aysonu = date_add('m',1,aybasi)>
<cfquery name="get_interruption" datasource="#DSN#">
	  SELECT	
		SG.*,
		E.EMPLOYEE_NAME,
		EI.TC_IDENTY_NO,
		B.BRANCH_NAME,
		E.EMPLOYEE_SURNAME,
		EIO.DEPARTMENT_ID,
		EIO.IN_OUT_ID,
		EIO.START_DATE,
		EIO.FINISH_DATE,
		EP.POSITION_CAT_ID,
		EP.COLLAR_TYPE,
		EP.POSITION_NAME,
		D.DEPARTMENT_HEAD,
		SPC.POSITION_CAT,
        E.EMPLOYEE_NAME + ' ' + E.EMPLOYEE_SURNAME AS EMPLOYEE,
		SG.PROCESS_STAGE
	  FROM 
		SALARYPARAM_GET SG,
		EMPLOYEES_IN_OUT EIO
		LEFT JOIN DEPARTMENT D ON D.DEPARTMENT_ID = EIO.DEPARTMENT_ID,
		EMPLOYEES_IDENTY EI,
		BRANCH B,
		EMPLOYEES E
		LEFT JOIN EMPLOYEE_POSITIONS EP ON (E.EMPLOYEE_ID = EP.EMPLOYEE_ID AND EP.IS_MASTER = 1)
		LEFT JOIN SETUP_POSITION_CAT SPC ON SPC.POSITION_CAT_ID = EP.POSITION_CAT_ID
	  WHERE
		<cfif isdefined("attributes.collar_type") and len(attributes.collar_type)>
			EP.COLLAR_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.collar_type#"> AND
		</cfif>
		<cfif isdefined("attributes.position_cat_id") and len(attributes.position_cat_id)>
			EP.POSITION_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.position_cat_id#"> AND
		</cfif>
		(
			<cfif attributes.aylar lte attributes.end_mon>
				(START_SAL_MON <= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.aylar#"> AND END_SAL_MON >= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.aylar#">)
				OR
				(END_SAL_MON >= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.aylar#"> AND END_SAL_MON <= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.end_mon#">)
				OR
				(	
					END_SAL_MON = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.aylar#"> OR 
					END_SAL_MON = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.end_mon#"> OR 
					START_SAL_MON = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.aylar#"> OR 
					START_SAL_MON = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.end_mon#">
				)
			<cfelse>
				START_SAL_MON IS NULL
			</cfif>
		)
		AND
	  	EIO.BRANCH_ID = B.BRANCH_ID AND
		E.EMPLOYEE_ID = SG.EMPLOYEE_ID AND
		E.EMPLOYEE_ID = EI.EMPLOYEE_ID AND
		EIO.EMPLOYEE_ID = E.EMPLOYEE_ID AND
		EIO.IN_OUT_ID = SG.IN_OUT_ID AND
		SG.TERM = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.yil#">
	<cfif len(attributes.keyword)>
		AND ((E.EMPLOYEE_NAME + ' ' + E.EMPLOYEE_SURNAME) LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI
		OR EI.TC_IDENTY_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#"> OR E.EMPLOYEE_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#">)
	</cfif>
	<cfif isdefined("attributes.related_company") and len(attributes.related_company)>
		AND B.RELATED_COMPANY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.related_company#">
	</cfif>
	<cfif isdefined("attributes.BRANCH_ID") and attributes.BRANCH_ID is not "all">
		AND EIO.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#">
	<cfelseif not session.ep.ehesap>
		AND
		(
		EIO.BRANCH_ID IN (
						SELECT
							BRANCH_ID
						FROM
							EMPLOYEE_POSITION_BRANCHES
						WHERE
							EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">
						)
		)
	</cfif>
	<cfif len(attributes.odkes)>
		AND SG.COMMENT_GET = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.odkes#">
	</cfif>
	<cfif fusebox.dynamic_hierarchy>
		<cfloop list="#emp_code_list#" delimiters="+" index="code_i">
			<cfif database_type is "MSSQL">
				AND 
				('.' + E.DYNAMIC_HIERARCHY + '.' + E.DYNAMIC_HIERARCHY_ADD + '.') LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%.#code_i#.%"> COLLATE SQL_Latin1_General_CP1_CI_AI
					
			<cfelseif database_type is "DB2">
				AND 
				('.' || E.DYNAMIC_HIERARCHY || '.' || E.DYNAMIC_HIERARCHY_ADD || '.') LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%.#code_i#.%"> COLLATE SQL_Latin1_General_CP1_CI_AI
					
			</cfif>
		</cfloop>
	<cfelse>
		<cfloop list="#emp_code_list#" delimiters="+" index="code_i">
			<cfif database_type is "MSSQL">
				AND ('.' + E.HIERARCHY + '.') LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%.#code_i#.%"> COLLATE SQL_Latin1_General_CP1_CI_AI
			<cfelseif database_type is "DB2">
				AND ('.' || E.HIERARCHY || '.') LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%.#code_i#.%"> COLLATE SQL_Latin1_General_CP1_CI_AI
			</cfif>
		</cfloop>
	</cfif>
	<cfif isdefined("attributes.DEPARTMENT_ID") and len(attributes.DEPARTMENT_ID) and attributes.DEPARTMENT_ID gt 0>
		AND EIO.DEPARTMENT_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department_id#">
	</cfif>
	<cfif isdefined("attributes.expense_center_id") and len(attributes.expense_center_id) and isdefined("attributes.EXPENSE_CODE_NAME") and len(attributes.EXPENSE_CODE_NAME)>
		AND EIO.IN_OUT_ID IN(SELECT IN_OUT_ID FROM EMPLOYEES_IN_OUT_PERIOD WHERE EXPENSE_CENTER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.expense_center_id#"> AND PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">)
	</cfif>
	<cfif isdefined('attributes.inout_statue') and attributes.inout_statue eq 1><!--- Girişler --->
		<cfif isdefined('attributes.startdate') and isdate(attributes.startdate)>
			AND EIO.START_DATE >= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.startdate#">
		</cfif>
		<cfif isdefined('attributes.finishdate') and isdate(attributes.finishdate)>
			AND EIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.finishdate#">
		</cfif>
	<cfelseif isdefined('attributes.inout_statue') and attributes.inout_statue eq 0><!--- Çıkışlar --->
		<cfif isdefined('attributes.startdate') and isdate(attributes.startdate)>
			AND EIO.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.startdate#">
		</cfif>
		<cfif isdefined('attributes.finishdate') and isdate(attributes.finishdate)>
			AND EIO.FINISH_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.finishdate#">
		</cfif>
		AND	EIO.FINISH_DATE IS NOT NULL
	<cfelseif isdefined('attributes.inout_statue') and attributes.inout_statue eq 2><!--- aktif calisanlar --->
		AND E.EMPLOYEE_ID IN (SELECT DISTINCT EMPLOYEE_ID FROM EMPLOYEES_IN_OUT WHERE
		(
			<cfif isdate(attributes.startdate) or isdate(attributes.finishdate)>
				<cfif isdate(attributes.startdate) and not isdate(attributes.finishdate)>
				(
					(
						EIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.startdate#"> AND
						EIO.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.startdate#">
					)
					OR
					(
						EIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.startdate#"> AND
						EIO.FINISH_DATE IS NULL
					)
				)
				<cfelseif not isdate(attributes.startdate) and isdate(attributes.finishdate)>
				(
					(
						EIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.finishdate#"> AND
						EIO.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.finishdate#">
					)
					OR
					(
						EIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.finishdate#"> AND
						EIO.FINISH_DATE IS NULL
					)
				)
				<cfelse>
				(
					(
						EIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.startdate#"> AND
						EIO.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.finishdate#">
					)
					OR
					(
						EIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.startdate#"> AND
						EIO.FINISH_DATE IS NULL
					)
					OR
					(
						EIO.START_DATE >= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.startdate#"> AND
						EIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.finishdate#">
					)
					OR
					(
						EIO.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.startdate#"> AND
						EIO.FINISH_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.finishdate#">
					)
				)
				</cfif>
			<cfelse>
				EIO.FINISH_DATE IS NULL
			</cfif>
		) )
	<cfelse><!--- giriş ve çıkışlar Seçili ise --->
		AND 
		(
			(
				EIO.START_DATE IS NOT NULL
				<cfif isdefined('attributes.startdate') and isdate(attributes.startdate)>
					AND EIO.START_DATE >= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.startdate#">
				</cfif>
				<cfif isdefined('attributes.finishdate') and isdate(attributes.finishdate)>
					AND EIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.finishdate#">
				</cfif>
			)
			OR
			(
				EIO.START_DATE IS NOT NULL
				<cfif isdefined('attributes.startdate') and isdate(attributes.startdate)>
					AND EIO.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.startdate#">
				</cfif>
				<cfif isdefined('attributes.finishdate') and isdate(attributes.finishdate)>
					AND EIO.FINISH_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.finishdate#">
				</cfif>
			)
		)
	</cfif>
	<cfif isdefined("attributes.action_list_id") AND len(attributes.action_list_id)>
		AND SPG_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_list_id#" list ="yes">)
	</cfif>
	<cfif isdefined("attributes.filter_process") and len(attributes.filter_process)>
		AND SG.PROCESS_STAGE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.filter_process#">
	</cfif>
</cfquery>
