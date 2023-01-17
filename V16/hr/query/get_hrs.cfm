<cfif isdefined("attributes.keyword2") and len(attributes.keyword2) and listlen(attributes.keyword2,'-') eq 3><!--- 20141107 SG 82595 idli işte Çalışan no filtresi ile ilgili düzenleme --->
	<cfquery name="get_temp_table" datasource="#dsn#">
		IF object_id('tempdb..##Employee_No_List') IS NOT NULL
		   BEGIN DROP TABLE ##Employee_No_List END
	</cfquery>
    <cfquery name="temp_table" datasource="#dsn#">
        CREATE TABLE ##Employee_No_List 
        (
        	EMPLOYEE_ID	int,
            EMP_NO_FIRST nvarchar(100),
            EMP_NO_LAST int
        )
    </cfquery>	
    <cfquery name="Add_Employee_No_List" datasource="#dsn#">
        INSERT INTO ##Employee_No_List 
        (	
        	EMPLOYEE_ID,
            EMP_NO_FIRST,
            EMP_NO_LAST
        )
        SELECT 
            *
         FROM 
        (
        SELECT 
            EMPLOYEE_ID,
            CASE WHEN CHARINDEX('-',EMPLOYEE_NO) >0 THEN
            SUBSTRING(EMPLOYEE_NO,1,(CHARINDEX('-',EMPLOYEE_NO)-1))
            END AS EMP_NO_FIRST,
            CASE WHEN CHARINDEX('-',EMPLOYEE_NO) >0 THEN
            SUBSTRING(EMPLOYEE_NO,(CHARINDEX('-',EMPLOYEE_NO)+1),LEN(EMPLOYEE_NO))	
            END AS EMP_NO_LAST
        FROM
            EMPLOYEES
        ) EMP_NO_TABLE
        WHERE
            ISNUMERIC(EMP_NO_TABLE.EMP_NO_LAST) = 1            
	</cfquery>
</cfif>
<cfif (len(attributes.position_cat_id) or len(attributes.title_id) or (isdefined("attributes.branch_id") and attributes.branch_id is not "all") or len(attributes.func_id) or len(attributes.organization_step_id) or len(attributes.position_name)) OR Len(attributes.collar_type)>
	<cfset hr_search_type = "with_position">
	<cfset attributes.ana_query = 1>
<cfelse>
	<cfset attributes.ana_query = 0>
	<cfset hr_search_type = "">
</cfif>
<cfif not session.ep.ehesap>
	<cfquery name="my_branches" datasource="#dsn#">
		SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">
	</cfquery>
	<cfif not my_branches.recordcount>
		<script type="text/javascript">alert("<cf_get_lang no ='1746.Hiçbir Şubeye Yetkiniz Yok!Şube Yetkilerinizi Düzenleyiniz'>!");history.back();</script>
		<cfabort>
	</cfif>
	<cfset my_branch_list = valuelist(my_branches.branch_id)>
	<cfquery name="get_emps_ins" datasource="#dsn#">
		SELECT EMPLOYEE_ID FROM EMPLOYEES_IN_OUT WHERE
		<cfif listlen(my_branch_list)>
			BRANCH_ID IN (#my_branch_list#)
		<cfelse>
			BRANCH_ID=0
		</cfif>
		<cfif attributes.branch_id is not "all">AND BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#"></cfif>
	</cfquery>
	<cfset in_out_employee_list = valuelist(get_emps_ins.employee_id)>
</cfif>
<cfinclude template="get_emp_codes.cfm">
<!---<cf_wrk_query datasource="#dsn#" name="get_hrs" case_value="EMPLOYEES.EMPLOYEE_ID">--->
<cfquery datasource="#dsn#" name="get_hrs">
	SELECT 
		BRANCH.BRANCH_NAME,
		DEPARTMENT.DEPARTMENT_HEAD,
		EMPLOYEE_POSITIONS.POSITION_NAME,
        EMPLOYEE_POSITIONS.POSITION_ID,
		EMPLOYEE_POSITIONS.POSITION_CODE,
		SETUP_POSITION_CAT.POSITION_CAT,
		EMPLOYEES.EMPLOYEE_ID,
		EMPLOYEES.EMPLOYEE_NAME,
		EMPLOYEES.EMPLOYEE_EMAIL,
		EMPLOYEES.EMPLOYEE_USERNAME,
		EMPLOYEES.EMPLOYEE_SURNAME,
		EMPLOYEES.EMPLOYEE_NO,
		EMPLOYEES.GROUP_STARTDATE,
		EMPLOYEES.EMPLOYEE_STATUS,
		EMPLOYEES.MOBILCODE,
		EMPLOYEES.MOBILTEL,
		EMPLOYEES_DETAIL.MOBILCODE_SPC,
		EMPLOYEES_DETAIL.MOBILTEL_SPC,
		EMPLOYEES.DIRECT_TELCODE,
		EMPLOYEES.DIRECT_TEL,
		EMPLOYEES.PHOTO,
		EMPLOYEES_DETAIL.SEX,
		EMPLOYEES.PHOTO_SERVER_ID,
		EMPLOYEES_IDENTY.LAST_SURNAME,
		EMPLOYEES_IDENTY.TC_IDENTY_NO,
        EMPLOYEES.HIERARCHY,
		EMPLOYEES_IN_OUT.START_DATE,
		EMPLOYEES_IN_OUT.FINISH_DATE
	FROM
		EMPLOYEES
		INNER JOIN EMPLOYEES_IDENTY ON EMPLOYEES.EMPLOYEE_ID = EMPLOYEES_IDENTY.EMPLOYEE_ID
		INNER JOIN EMPLOYEES_DETAIL ON EMPLOYEES.EMPLOYEE_ID = EMPLOYEES_DETAIL.EMPLOYEE_ID
		<cfif isdefined("attributes.keyword2") and len(attributes.keyword2) and listlen(attributes.keyword2,'-') eq 3>
			INNER JOIN ##Employee_No_List EMPLOYEE_NO_TABLE ON EMPLOYEES.EMPLOYEE_ID = EMPLOYEE_NO_TABLE.EMPLOYEE_ID
		</cfif>
		LEFT JOIN EMPLOYEE_POSITIONS ON EMPLOYEE_POSITIONS.EMPLOYEE_ID = EMPLOYEES.EMPLOYEE_ID AND EMPLOYEE_POSITIONS.POSITION_STATUS = 1 AND EMPLOYEE_POSITIONS.IS_MASTER = 1
		LEFT JOIN DEPARTMENT ON EMPLOYEE_POSITIONS.DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID
		LEFT JOIN BRANCH ON DEPARTMENT.BRANCH_ID = BRANCH.BRANCH_ID
		LEFT JOIN SETUP_POSITION_CAT ON SETUP_POSITION_CAT.POSITION_CAT_ID = EMPLOYEE_POSITIONS.POSITION_CAT_ID
		LEFT JOIN EMPLOYEES_IN_OUT ON EMPLOYEES_IN_OUT.EMPLOYEE_ID = EMPLOYEES.EMPLOYEE_ID AND EMPLOYEES_IN_OUT.IN_OUT_ID = (SELECT TOP 1 IN_OUT_ID FROM EMPLOYEES_IN_OUT WHERE EMPLOYEE_ID = EMPLOYEES.EMPLOYEE_ID <cfif not session.ep.ehesap>AND BRANCH_ID IN (#my_branch_list#)</cfif> ORDER BY START_DATE DESC,IN_OUT_ID DESC)
	WHERE
		<cfif isdefined("attributes.emp_status")>
		    <cfif attributes.emp_status eq 1>
				EMPLOYEES.EMPLOYEE_STATUS = 1
			<cfelseif attributes.emp_status eq -1>
				EMPLOYEES.EMPLOYEE_STATUS = 0
			<cfelseif attributes.emp_status eq 0>
				EMPLOYEES.EMPLOYEE_STATUS IS NOT NULL
			</cfif>
		<cfelse>
			EMPLOYEES.EMPLOYEE_STATUS=1
		</cfif>
		<cfif isdefined("attributes.keyword") and len(attributes.keyword)>
			AND
			(
				(
				<cfif database_type is "MSSQL">
					EMPLOYEES.EMPLOYEE_NAME+' '+EMPLOYEES.EMPLOYEE_SURNAME LIKE '<cfif len(attributes.keyword) gt 2>%</cfif>#attributes.keyword#%'
				<cfelseif database_type is "DB2">
					EMPLOYEES.EMPLOYEE_NAME||' '||EMPLOYEES.EMPLOYEE_SURNAME LIKE '<cfif len(attributes.keyword) gt 2>%</cfif>#attributes.keyword#%'
				</cfif>
				)
				OR EMPLOYEES_IDENTY.LAST_SURNAME LIKE '<cfif len(attributes.keyword) gt 2>%</cfif>#attributes.keyword#%'
				OR EMPLOYEES_IDENTY.TC_IDENTY_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#">
			)
		</cfif>
		<cfif fusebox.dynamic_hierarchy>
			<cfloop list="#emp_code_list#" delimiters="+" index="code_i">
				<cfif database_type is "MSSQL">
					AND 
					('.' + EMPLOYEES.DYNAMIC_HIERARCHY + '.' + EMPLOYEES.DYNAMIC_HIERARCHY_ADD + '.') LIKE '%.#code_i#.%'
						
				<cfelseif database_type is "DB2">
					AND 
					('.' || EMPLOYEES.DYNAMIC_HIERARCHY || '.' || EMPLOYEES.DYNAMIC_HIERARCHY_ADD || '.') LIKE '%.#code_i#.%'
						
				</cfif>
			</cfloop>
		<cfelse>
			<cfloop list="#emp_code_list#" delimiters="+" index="code_i">
				<cfif database_type is "MSSQL">
					AND ('.' + EMPLOYEES.HIERARCHY + '.') LIKE '%.#code_i#.%'
				<cfelseif database_type is "DB2">
					AND ('.' || EMPLOYEES.HIERARCHY || '.') LIKE '%.#code_i#.%'
				</cfif>
			</cfloop>
		</cfif>
		<cfif isdefined('attributes.hierarchy') and len(attributes.hierarchy)>
			AND 
			(
				EMPLOYEES.OZEL_KOD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%attributes.hierarchy%"> OR
				EMPLOYEES.OZEL_KOD2 LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%attributes.hierarchy%"> OR
				EMPLOYEES.HIERARCHY LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%attributes.hierarchy%"> OR
				EMPLOYEES.EMPLOYEE_ID IN (SELECT EMPLOYEE_ID FROM EMPLOYEE_POSITIONS WHERE OZEL_KOD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%attributes.hierarchy%">)
			)
		</cfif>
		<cfif (isdefined("attributes.branch_id") and attributes.branch_id is not 'all')>
			AND DEPARTMENT.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#">
		</cfif>
		<cfif Len(hr_search_type) and Len(attributes.collar_type)>
			AND EMPLOYEE_POSITIONS.COLLAR_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.collar_type#">
		</cfif>
		<cfif isdefined("attributes.position_cat_id") and len(attributes.position_cat_id)>
			AND EMPLOYEE_POSITIONS.POSITION_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.position_cat_id#">
		</cfif>
		<cfif isdefined("attributes.position_name") and len(attributes.position_name)>
			AND EMPLOYEE_POSITIONS.POSITION_NAME LIKE '<cfif len(attributes.position_name) gt 2>%</cfif>#attributes.position_name#%'
		</cfif>
		<cfif isdefined('attributes.title_id') and len(attributes.title_id)>
			AND EMPLOYEE_POSITIONS.TITLE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.title_id#">
		</cfif>
		<cfif isdefined('attributes.func_id') and len(attributes.func_id)>
			AND EMPLOYEE_POSITIONS.FUNC_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.func_id#">
		</cfif>
		<cfif isdefined('attributes.organization_step_id') and len(attributes.organization_step_id)>
			AND EMPLOYEE_POSITIONS.ORGANIZATION_STEP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.organization_step_id#">
		</cfif>
		<cfif len(hr_search_type) and isdefined("attributes.branch_id") and attributes.branch_id is 'all' and not session.ep.ehesap>
			AND DEPARTMENT.BRANCH_ID IN (#my_branch_list#)
		</cfif>
		<cfif isdefined('attributes.department') and len(attributes.department)>
			AND DEPARTMENT.DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department#">
		</cfif> 
		<cfif isdefined('attributes.process_stage') and len(attributes.process_stage)>
			AND EMPLOYEES.EMPLOYEE_STAGE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_stage#">
		</cfif>
		<cfif not len(hr_search_type) and isdefined("attributes.branch_id") and attributes.branch_id is 'all' and (not session.ep.ehesap)>
			AND 
			(
				EMPLOYEES.EMPLOYEE_ID IN (SELECT EMPLOYEE_ID FROM EMPLOYEE_POSITIONS,DEPARTMENT WHERE EMPLOYEE_POSITIONS.DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID AND DEPARTMENT.BRANCH_ID IN (#my_branch_list#))
				OR EMPLOYEES.EMPLOYEE_ID NOT IN (SELECT DISTINCT EMPLOYEE_ID FROM EMPLOYEE_POSITIONS WHERE EMPLOYEE_ID IS NOT NULL AND EMPLOYEE_ID <> 0)
			)
			AND 
			<!---giriş-çıkış şube yetkisi kontrolü --->
			(
				EMPLOYEES.EMPLOYEE_ID NOT IN (SELECT EMPLOYEE_ID FROM EMPLOYEES_IN_OUT)
				OR EMPLOYEES.EMPLOYEE_ID IN (SELECT EMPLOYEE_ID FROM EMPLOYEES_IN_OUT WHERE BRANCH_ID IN (#my_branch_list#))
			)
		</cfif>
		<cfif isdefined("attributes.duty_type") and len(attributes.duty_type)>
			AND EMPLOYEES.EMPLOYEE_ID IN(SELECT EMPLOYEE_ID FROM EMPLOYEES_IN_OUT WHERE DUTY_TYPE IN(#attributes.duty_type#) AND FINISH_DATE IS NULL)
		</cfif>
        <cfif isdefined("attributes.keyword2") and len(attributes.keyword2) and listlen(attributes.keyword2,'-') eq 3>
        	AND EMPLOYEE_NO_TABLE.EMP_NO_FIRST = <cfqueryparam cfsqltype="cf_sql_varchar" value="#listgetat(attributes.keyword2,1,'-')#"> 
            AND EMPLOYEE_NO_TABLE.EMP_NO_LAST >= <cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(attributes.keyword2,2,'-')#"> 
			AND EMPLOYEE_NO_TABLE.EMP_NO_LAST <= <cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(attributes.keyword2,3,'-')#">
		<cfelseif isdefined("attributes.keyword2") and len(attributes.keyword2)>
			AND EMPLOYEES.EMPLOYEE_NO LIKE '<cfif len(attributes.keyword2) gt 1>%</cfif>#attributes.keyword2#%'
        </cfif>
		<cfif not len(hr_search_type) and not session.ep.ehesap>
			AND 
            	(
            		EMPLOYEES.RECORD_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"> OR
                    EMPLOYEES.EMPLOYEE_ID IN (SELECT EMPLOYEE_ID FROM EMPLOYEE_POSITIONS,DEPARTMENT WHERE EMPLOYEE_POSITIONS.DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID AND DEPARTMENT.BRANCH_ID IN (#my_branch_list#))
				)
      	</cfif>
	ORDER BY
		EMPLOYEES.EMPLOYEE_NAME
</cfquery>
<!---</cf_wrk_query>--->
