<cfinclude template="../../query/get_emp_codes.cfm">
<cfset aybasi = CreateDate(attributes.yil, attributes.start_mon,1)>
<cfset aysonu = date_add('m',1,aybasi)>
<cfquery name="get_payments" datasource="#DSN#">
	SELECT	
		SG.SPP_ID,
		E.EMPLOYEE_ID,
		COMMENT_PAY,                                        
		PERIOD_PAY,
		METHOD_PAY,
		AMOUNT_PAY,
		START_SAL_MON,
		END_SAL_MON,
		SG.PROCESS_STAGE,
		E.EMPLOYEE_NAME,
		E.EMPLOYEE_SURNAME,
		B.BRANCH_NAME,
		EIO.DEPARTMENT_ID,
		EIO.IN_OUT_ID,
		EIO.START_DATE,
		EIO.FINISH_DATE,
		EMP_IDENTY.TC_IDENTY_NO,
		EP.POSITION_CAT_ID,
		EP.COLLAR_TYPE,
		EP.POSITION_NAME,
		D.DEPARTMENT_HEAD,
		SPC.POSITION_CAT,
		(SELECT TOP 1 EIOP.EXPENSE_CENTER_ID FROM EMPLOYEES_IN_OUT_PERIOD EIOP,BRANCH B2 WHERE B2.BRANCH_ID = EIO.BRANCH_ID AND B2.COMPANY_ID = EIOP.PERIOD_COMPANY_ID AND EIOP.IN_OUT_ID = EIO.IN_OUT_ID AND EIOP.PERIOD_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.yil#">) AS EXPENSE_CENTER_ID,
        E.EMPLOYEE_NAME + ' ' + E.EMPLOYEE_SURNAME AS EMPLOYEE
	FROM
		SALARYPARAM_PAY SG 
		INNER JOIN EMPLOYEES_IN_OUT EIO ON SG.IN_OUT_ID = EIO.IN_OUT_ID 
        INNER JOIN EMPLOYEES E ON E.EMPLOYEE_ID = EIO.EMPLOYEE_ID 
        INNER JOIN EMPLOYEES_IDENTY EMP_IDENTY ON EMP_IDENTY.EMPLOYEE_ID = E.EMPLOYEE_ID
        INNER JOIN BRANCH B ON EIO.BRANCH_ID = B.BRANCH_ID
        LEFT JOIN DEPARTMENT D ON EIO.DEPARTMENT_ID = D.DEPARTMENT_ID
		LEFT JOIN EMPLOYEE_POSITIONS EP ON (E.EMPLOYEE_ID = EP.EMPLOYEE_ID AND EP.IS_MASTER = 1)
		LEFT JOIN SETUP_POSITION_CAT SPC ON SPC.POSITION_CAT_ID = EP.POSITION_CAT_ID
	WHERE
		SG.TERM = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.yil#">		
		<cfif isdefined("attributes.collar_type") and len(attributes.collar_type)>
			AND EP.COLLAR_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.collar_type#">
		</cfif>
		<cfif isdefined("attributes.position_cat_id") and len(attributes.position_cat_id)>
			AND EP.POSITION_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.position_cat_id#">
		</cfif>
		<cfif isdefined("attributes.title_id") and len(attributes.title_id)>
			AND EP.TITLE_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#attributes.title_id#">)
		</cfif>
		AND
        ( 
		<cfif attributes.start_mon lte attributes.end_mon>
			(
            	START_SAL_MON <= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.start_mon#"> AND 
            	END_SAL_MON > = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.start_mon#">
            )
			OR
			(
            	END_SAL_MON >= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.start_mon#"> AND 
                END_SAL_MON <= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.end_mon#">
            )
			OR
			(	
				END_SAL_MON = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.start_mon#"> OR 
				END_SAL_MON = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.end_mon#"> OR 
				START_SAL_MON = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.start_mon#"> OR 
				START_SAL_MON = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.end_mon#">
			)
		<cfelse>
			START_SAL_MON IS NULL
		</cfif>
		)
	<cfif isdefined("attributes.related_company") and len(attributes.related_company)>
        AND B.RELATED_COMPANY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.related_company#">
    </cfif>
	<cfif isdefined("attributes.BRANCH_ID") and attributes.BRANCH_ID is not "all">
		AND EIO.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.BRANCH_ID#">
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
	<cfif isdefined("attributes.DEPARTMENT_ID") and len(DEPARTMENT_ID) and attributes.DEPARTMENT_ID gt 0>
		AND EIO.DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.DEPARTMENT_ID#">
	</cfif>
	<cfif len(attributes.tax)>AND SG.TAX=<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.tax#"></cfif>
	<cfif len(attributes.ssk)>AND SG.SSK=<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ssk#"></cfif>
	<cfif len(attributes.keyword)>
	AND 
	(
    	(E.EMPLOYEE_NAME + ' ' + E.EMPLOYEE_SURNAME) LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI
		OR 
        EMP_IDENTY.TC_IDENTY_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#"> OR E.EMPLOYEE_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#">
    )
	</cfif>
	<cfif len(attributes.odkes)>
		AND SG.COMMENT_PAY_ID IN (#attributes.odkes#)
	</cfif>
	<cfif fusebox.dynamic_hierarchy>
		<cfloop list="#emp_code_list#" delimiters="+" index="code_i">
			<cfif database_type is "MSSQL">
				AND 
				('.' + E.DYNAMIC_HIERARCHY + '.' + E.DYNAMIC_HIERARCHY_ADD + '.') LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%.#code_i#.%">
					
			<cfelseif database_type is "DB2">
				AND 
				('.' || E.DYNAMIC_HIERARCHY || '.' || E.DYNAMIC_HIERARCHY_ADD || '.') LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%.#code_i#.%">
					
			</cfif>
		</cfloop>
	<cfelse>
		<cfloop list="#emp_code_list#" delimiters="+" index="code_i">
			<cfif database_type is "MSSQL">
				AND ('.' + E.HIERARCHY + '.') LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%.#code_i#.%">
			<cfelseif database_type is "DB2">
				AND ('.' || E.HIERARCHY || '.') LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%.#code_i#.%">
			</cfif>
		</cfloop>
	</cfif>
	<cfif isdefined("attributes.expense_center_id") and len(attributes.expense_center_id) and isdefined("attributes.EXPENSE_CODE_NAME") and len(attributes.EXPENSE_CODE_NAME)>
		AND EIO.IN_OUT_ID IN (SELECT IN_OUT_ID FROM EMPLOYEES_IN_OUT_PERIOD WHERE EXPENSE_CENTER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.expense_center_id#"> AND PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">)
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
	<cfif isdefined("attributes.filter_process") and len(attributes.filter_process)>
		AND SG.PROCESS_STAGE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.filter_process#">
	</cfif>
	<cfif isdefined("attributes.action_list_id") and len(attributes.action_list_id)>
		AND SPP_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_list_id#" list ="yes">)
	</cfif>
	ORDER BY
		E.EMPLOYEE_NAME,
		E.EMPLOYEE_SURNAME
</cfquery>
