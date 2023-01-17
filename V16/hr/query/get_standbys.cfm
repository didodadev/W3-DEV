<cfinclude template="get_emp_codes.cfm">
<cfquery name="get_standbys" datasource="#dsn#">
	SELECT
		EMPLOYEE_POSITIONS.POSITION_ID,
		EMPLOYEE_POSITIONS.POSITION_CODE,
		EMPLOYEE_POSITIONS.POSITION_CAT_ID,
		EMPLOYEE_POSITIONS.POSITION_NAME,
		EMPLOYEE_POSITIONS.EMPLOYEE_ID,
		EMPLOYEE_POSITIONS.EMPLOYEE_NAME,
		EMPLOYEE_POSITIONS.EMPLOYEE_SURNAME,
		EMPLOYEE_POSITIONS_STANDBY.SB_ID,
		EMPLOYEE_POSITIONS_STANDBY.CHIEF1_CODE,
		EMPLOYEE_POSITIONS_STANDBY.CHIEF2_CODE,
		EMPLOYEE_POSITIONS_STANDBY.CHIEF3_CODE,
        EMPLOYEE_POSITIONS_STANDBY.CANDIDATE_POS_1,
		D.DEPARTMENT_HEAD,
		B.BRANCH_NAME
	FROM
		EMPLOYEE_POSITIONS_STANDBY,
		EMPLOYEE_POSITIONS
		,BRANCH B
		,DEPARTMENT D
	WHERE
		EMPLOYEE_POSITIONS.POSITION_CODE = EMPLOYEE_POSITIONS_STANDBY.POSITION_CODE
		<cfif isdefined("attributes.positions") and attributes.positions eq 2>
		AND
		EMPLOYEE_POSITIONS.EMPLOYEE_ID <> 0
		<cfelseif isdefined("attributes.positions") and attributes.positions eq 3>
		AND
		EMPLOYEE_POSITIONS.EMPLOYEE_ID = 0
		</cfif>
		AND EMPLOYEE_POSITIONS.DEPARTMENT_ID=D.DEPARTMENT_ID
		AND D.BRANCH_ID=B.BRANCH_ID
		<cfif not session.ep.ehesap>
		AND B.BRANCH_ID IN(SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #SESSION.EP.POSITION_CODE#)
		</cfif>
		<cfif (attributes.branch_id is not 'all')>
			AND B.BRANCH_ID = #attributes.branch_id#
		</cfif>
	<cfif isdefined('attributes.department') and len(attributes.department)>
		AND EMPLOYEE_POSITIONS.DEPARTMENT_ID = #attributes.department#
	</cfif>
	<cfif isdefined('attributes.keyword') and len(attributes.keyword)>
		AND
		(
		EMPLOYEE_POSITIONS.EMPLOYEE_NAME LIKE '%#attributes.KEYWORD#%'
		OR
		EMPLOYEE_POSITIONS.EMPLOYEE_SURNAME LIKE '%#attributes.KEYWORD#%'
		OR
		EMPLOYEE_POSITIONS.POSITION_NAME LIKE '%#attributes.KEYWORD#%'
		)
	</cfif>
			<cfif fusebox.dynamic_hierarchy>
		<cfloop list="#emp_code_list#" delimiters="+" index="code_i">
			<cfif database_type is "MSSQL">
				AND 
				('.' + EMPLOYEE_POSITIONS.DYNAMIC_HIERARCHY + '.' + EMPLOYEE_POSITIONS.DYNAMIC_HIERARCHY_ADD + '.') LIKE '%.#code_i#.%'
					
			<cfelseif database_type is "DB2">
				AND 
				('.' || EMPLOYEE_POSITIONS.DYNAMIC_HIERARCHY || '.' || EMPLOYEE_POSITIONS.DYNAMIC_HIERARCHY_ADD || '.') LIKE '%.#code_i#.%'
					
			</cfif>
		</cfloop>
	<cfelse>
		<cfloop list="#emp_code_list#" delimiters="+" index="code_i">
			<cfif database_type is "MSSQL">
				AND ('.' + EMPLOYEE_POSITIONS.HIERARCHY + '.') LIKE '%.#code_i#.%'
			<cfelseif database_type is "DB2">
				AND ('.' || EMPLOYEE_POSITIONS.HIERARCHY || '.') LIKE '%.#code_i#.%'
			</cfif>
		</cfloop>
	</cfif>
	UNION
			SELECT
				EMPLOYEE_POSITIONS.POSITION_ID,
				EMPLOYEE_POSITIONS.POSITION_CODE,
				EMPLOYEE_POSITIONS.POSITION_CAT_ID,
				EMPLOYEE_POSITIONS.POSITION_NAME,
				EMPLOYEE_POSITIONS.EMPLOYEE_ID,
				EMPLOYEE_POSITIONS.EMPLOYEE_NAME,
				EMPLOYEE_POSITIONS.EMPLOYEE_SURNAME,
				'' AS SB_ID,
				'' AS CHIEF1_CODE,
				'' AS CHIEF2_CODE,
				'' AS CHIEF3_CODE,
                '' AS CANDIDATE_POS_1,
				D.DEPARTMENT_HEAD,
				B.BRANCH_NAME
			FROM
				EMPLOYEE_POSITIONS
				,BRANCH B
				,DEPARTMENT D
			WHERE
				EMPLOYEE_POSITIONS.POSITION_CODE NOT IN (SELECT POSITION_CODE FROM EMPLOYEE_POSITIONS_STANDBY)
				<cfif isdefined("attributes.positions") and attributes.positions eq 2>
				AND
				EMPLOYEE_POSITIONS.EMPLOYEE_ID <> 0
				<cfelseif isdefined("attributes.positions") and attributes.positions eq 3>
				AND
				EMPLOYEE_POSITIONS.EMPLOYEE_ID = 0
				</cfif>
		<!--- <cfif isdefined("attributes.branch_id") and len(attributes.branch_id)> --->
				AND EMPLOYEE_POSITIONS.DEPARTMENT_ID=D.DEPARTMENT_ID
				AND D.BRANCH_ID=B.BRANCH_ID
				<cfif not session.ep.ehesap>
				AND B.BRANCH_ID IN(SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #SESSION.EP.POSITION_CODE#)
				</cfif>
				<cfif (attributes.branch_id is not 'all')>
					AND B.BRANCH_ID = #attributes.branch_id#
				</cfif>
			<cfif isdefined('attributes.department') and len(attributes.department)>
				AND EMPLOYEE_POSITIONS.DEPARTMENT_ID = #attributes.department#
			</cfif>
			<cfif isdefined('attributes.keyword') and len(attributes.keyword)>
				AND
				(
				EMPLOYEE_POSITIONS.EMPLOYEE_NAME LIKE '%#attributes.KEYWORD#%'
				OR
				EMPLOYEE_POSITIONS.EMPLOYEE_SURNAME LIKE '%#attributes.KEYWORD#%'
				OR
				EMPLOYEE_POSITIONS.POSITION_NAME LIKE '%#attributes.KEYWORD#%'
				)
			</cfif>
					<cfif fusebox.dynamic_hierarchy>
				<cfloop list="#emp_code_list#" delimiters="+" index="code_i">
					<cfif database_type is "MSSQL">
						AND 
						('.' + EMPLOYEE_POSITIONS.DYNAMIC_HIERARCHY + '.' + EMPLOYEE_POSITIONS.DYNAMIC_HIERARCHY_ADD + '.') LIKE '%.#code_i#.%'
							
					<cfelseif database_type is "DB2">
						AND 
						('.' || EMPLOYEE_POSITIONS.DYNAMIC_HIERARCHY || '.' || EMPLOYEE_POSITIONS.DYNAMIC_HIERARCHY_ADD || '.') LIKE '%.#code_i#.%'
							
					</cfif>
				</cfloop>
			<cfelse>
				<cfloop list="#emp_code_list#" delimiters="+" index="code_i">
					<cfif database_type is "MSSQL">
						AND ('.' + EMPLOYEE_POSITIONS.HIERARCHY + '.') LIKE '%.#code_i#.%'
					<cfelseif database_type is "DB2">
						AND ('.' || EMPLOYEE_POSITIONS.HIERARCHY || '.') LIKE '%.#code_i#.%'
					</cfif>
				</cfloop>
			</cfif>
		ORDER BY B.BRANCH_NAME,D.DEPARTMENT_HEAD,EMPLOYEE_POSITIONS.EMPLOYEE_NAME,EMPLOYEE_POSITIONS.EMPLOYEE_SURNAME
</cfquery>
