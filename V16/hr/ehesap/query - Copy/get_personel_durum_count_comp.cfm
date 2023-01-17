<cfset this_month_starts = CreateDate(attributes.SAL_YEAR, attributes.SAL_MON, 1)>
<cfset this_month_ends = CreateDate(attributes.SAL_YEAR, attributes.SAL_MON, daysinmonth(this_month_starts))>
<cfquery name="get_branch" datasource="#dsn#">
	SELECT
		*
	FROM
		BRANCH
	WHERE
		COMPANY_ID = #attributes.comp_id#
</cfquery>

<cfif not get_branch.RECORDCOUNT>
	<script type="text/javascript">
		alert("Şube Bilgileri Eksik ! \n Şube Şehri, SSK Şube Adı, SSK No Bilgilerini Kontrol Ediniz !");
		history.back();
	</script>
	<cfabort>
</cfif>

<cfinclude template="../../query/get_emp_codes.cfm">


<cfquery name="get_puantaj" datasource="#dsn#">
	SELECT DISTINCT
		EMPLOYEES_PUANTAJ_ROWS.*,
		EMPLOYEES.HIERARCHY,
		EMPLOYEES.DYNAMIC_HIERARCHY,
		EMPLOYEES.DYNAMIC_HIERARCHY_ADD,
		EMPLOYEES.EMPLOYEE_NAME,
		EMPLOYEES.EMPLOYEE_SURNAME,
		EMPLOYEES.GROUP_STARTDATE,
		EMPLOYEES_IDENTY.TC_IDENTY_NO,
		EMPLOYEES_IN_OUT.USE_SSK,
		EMPLOYEES_IN_OUT.IN_OUT_ID,
		BRANCH.BRANCH_ID
	FROM
		EMPLOYEES_PUANTAJ_ROWS,
		EMPLOYEES_PUANTAJ,
		EMPLOYEES,
		EMPLOYEES_IDENTY,
		EMPLOYEES_IN_OUT,
		BRANCH
	WHERE		
		EMPLOYEES_PUANTAJ.SAL_YEAR = #attributes.sal_year# AND
		EMPLOYEES_PUANTAJ.SAL_MON = #attributes.sal_mon# AND
		EMPLOYEES_PUANTAJ_ROWS.PUANTAJ_ID = EMPLOYEES_PUANTAJ.PUANTAJ_ID AND
		EMPLOYEES.EMPLOYEE_ID = EMPLOYEES_PUANTAJ_ROWS.EMPLOYEE_ID AND
		EMPLOYEES_PUANTAJ.SSK_OFFICE = BRANCH.SSK_OFFICE AND
		EMPLOYEES_PUANTAJ.SSK_OFFICE_NO = BRANCH.SSK_NO AND
		EMPLOYEES_PUANTAJ_ROWS.EMPLOYEE_ID = EMPLOYEES_IN_OUT.EMPLOYEE_ID AND
		EMPLOYEES_IN_OUT.BRANCH_ID = BRANCH.BRANCH_ID AND
		BRANCH.BRANCH_ID IN (#valuelist(get_branch.BRANCH_ID)#) AND
		EMPLOYEES_IDENTY.EMPLOYEE_ID = EMPLOYEES_PUANTAJ_ROWS.EMPLOYEE_ID AND 
		(
			(EMPLOYEES_IN_OUT.FINISH_DATE >= #CreateODBCDateTime(this_month_starts)# AND EMPLOYEES_IN_OUT.VALID = 1)
			OR 
			EMPLOYEES_IN_OUT.FINISH_DATE IS NULL
		)
	ORDER BY
		EMPLOYEES.EMPLOYEE_NAME,
		EMPLOYEES.EMPLOYEE_SURNAME
</cfquery>

<cfquery name="get_all_personel" datasource="#dsn#">
	SELECT
		EMPLOYEES_IN_OUT.EMPLOYEE_ID,
		EMPLOYEES_IN_OUT.IN_OUT_ID,
		EMPLOYEES.EMPLOYEE_NAME,
		EMPLOYEES.EMPLOYEE_SURNAME,
		EMPLOYEES_IN_OUT.START_DATE,
		EMPLOYEES_IN_OUT.FINISH_DATE,
		EMPLOYEES_IN_OUT.VALID,
		EMPLOYEES_DETAIL.SEX,
		EMPLOYEES_DETAIL.TERROR_WRONGED,
		EMPLOYEES_DETAIL.DEFECTED,
		EMPLOYEES_DETAIL.SENTENCED,
		EMPLOYEES_IN_OUT.DEFECTION_LEVEL,
		EMPLOYEES_IN_OUT.SURELI_IS_AKDI,
		EMPLOYEES_IN_OUT.SALARY_TYPE
	FROM
		EMPLOYEES,
		EMPLOYEES_IN_OUT,
		EMPLOYEES_SALARY,
		EMPLOYEES_DETAIL,
		BRANCH	
	WHERE
		<cfif get_puantaj.recordcount>
			EMPLOYEES_SALARY.IN_OUT_ID IN (#VALUELIST(get_puantaj.IN_OUT_ID)#) AND
		</cfif>
		EMPLOYEES_IN_OUT.USE_SSK = 1 
		AND EMPLOYEES_SALARY.PERIOD_YEAR = #attributes.SAL_YEAR#
		AND EMPLOYEES_SALARY.M#attributes.SAL_MON# > 0
		AND EMPLOYEES_SALARY.IN_OUT_ID = EMPLOYEES_IN_OUT.IN_OUT_ID
		AND EMPLOYEES.EMPLOYEE_ID = EMPLOYEES_IN_OUT.EMPLOYEE_ID
		AND EMPLOYEES_DETAIL.EMPLOYEE_ID = EMPLOYEES_IN_OUT.EMPLOYEE_ID
		AND EMPLOYEES_IN_OUT.START_DATE < #DATEADD("d",1,this_month_ends)#
		AND
		(
			(EMPLOYEES_IN_OUT.FINISH_DATE >= #CreateODBCDateTime(this_month_starts)# AND EMPLOYEES_IN_OUT.VALID = 1)
			OR 
			EMPLOYEES_IN_OUT.FINISH_DATE IS NULL
		)
		AND EMPLOYEES_IN_OUT.BRANCH_ID = BRANCH.BRANCH_ID AND
		BRANCH.BRANCH_ID IN (#valuelist(get_branch.BRANCH_ID)#)
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
	ORDER BY
		EMPLOYEES.EMPLOYEE_NAME,
		EMPLOYEES.EMPLOYEE_SURNAME
</cfquery> 


<cfif not get_all_personel.RECORDCOUNT>
	<script type="text/javascript">
		alert("Çalışan Kaydı Bulunamadı !");
		history.back();
	</script>
	<cfabort>
</cfif>
<cfquery name="GET_ALL_WOMEN" dbtype="query">
	SELECT
		EMPLOYEE_ID,
		START_DATE,
		FINISH_DATE,
		DEFECTED,
		DEFECTION_LEVEL,
		TERROR_WRONGED,
		SENTENCED,
		VALID,
		SURELI_IS_AKDI,
		SALARY_TYPE
	FROM
		get_all_personel
	WHERE
		SEX = 0 OR SEX IS NULL
</cfquery>

<cfif GET_ALL_WOMEN.recordcount>
	<cfquery name="GET_ALL_WOMEN_STARTED" dbtype="QUERY">
		SELECT
			EMPLOYEE_ID,START_DATE
		FROM
			GET_ALL_WOMEN
		WHERE
			START_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#this_month_starts#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#this_month_ends#">
	</cfquery>
	
	<cfquery name="GET_ALL_WOMEN_FIRED" dbtype="QUERY">
		SELECT
			EMPLOYEE_ID
		FROM
			GET_ALL_WOMEN
		WHERE
			FINISH_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#this_month_starts#"> AND  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#this_month_ends#">
			AND VALID = 1
	</cfquery>

	<cfquery name="GET_ALL_WOMEN_SAKAT" dbtype="QUERY">
		SELECT
			EMPLOYEE_ID,
			START_DATE,
			FINISH_DATE,
			VALID
		FROM
			GET_ALL_WOMEN
		WHERE
			DEFECTION_LEVEL > 0
	</cfquery>

	<cfquery name="GET_ALL_WOMEN_HUKUMLU" dbtype="QUERY">
		SELECT
			EMPLOYEE_ID,
			START_DATE,
			FINISH_DATE,
			VALID
		FROM
			GET_ALL_WOMEN
 		WHERE             
			SENTENCED = 1
	</cfquery>

	<cfquery name="GET_ALL_WOMEN_TEROR" dbtype="QUERY">
		SELECT
			EMPLOYEE_ID,
			START_DATE,
			FINISH_DATE,
			VALID
		FROM
			GET_ALL_WOMEN
		WHERE
			TERROR_WRONGED = 1
	</cfquery>

	<cfquery name="GET_ALL_WOMEN_SURELI" dbtype="QUERY">
		SELECT
			EMPLOYEE_ID,
			START_DATE,
			FINISH_DATE,
			VALID
		FROM
			GET_ALL_WOMEN
		WHERE
			SURELI_IS_AKDI = 1 AND
			(
			DEFECTION_LEVEL = 0 AND
			(TERROR_WRONGED = 0 OR TERROR_WRONGED IS NULL) AND
			(SENTENCED = 0 OR SENTENCED IS NULL)
			)
	</cfquery>

	<cfquery name="GET_ALL_WOMEN_SURESIZ" dbtype="QUERY">
		SELECT
			EMPLOYEE_ID,
			START_DATE,
			FINISH_DATE,
			VALID
		FROM
			GET_ALL_WOMEN
		WHERE
			(SURELI_IS_AKDI = 0 OR SURELI_IS_AKDI IS NULL) AND
			(
			DEFECTION_LEVEL = 0 AND
			(TERROR_WRONGED = 0 OR TERROR_WRONGED IS NULL) AND
			(SENTENCED = 0 OR SENTENCED IS NULL)
			)
	</cfquery>
	

	<cfquery name="GET_ALL_WOMEN_PARTTIME" dbtype="QUERY">
		SELECT
			EMPLOYEE_ID,
			START_DATE,
			FINISH_DATE,
			VALID
		FROM
			GET_ALL_WOMEN
		WHERE
			SALARY_TYPE = 0
	</cfquery>

	<cfif GET_ALL_WOMEN_SAKAT.recordcount>
		<cfquery name="GET_ALL_WOMEN_STARTED_SAKAT" dbtype="QUERY">
			SELECT
				EMPLOYEE_ID
			FROM
				GET_ALL_WOMEN_SAKAT
			WHERE
				START_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#this_month_starts#"> AND  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#this_month_ends#">
		</cfquery>
	
		<cfquery name="GET_ALL_WOMEN_FIRED_SAKAT" dbtype="QUERY">
			SELECT
				EMPLOYEE_ID
			FROM
				GET_ALL_WOMEN_SAKAT
			WHERE
				FINISH_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#this_month_starts#"> AND  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#this_month_ends#">
				AND VALID = 1
		</cfquery>
		
		<cfset ALL_WOMEN_SAKAT = GET_ALL_WOMEN_SAKAT.RECORDCOUNT + 0>
		<cfset STARTED_WOMEN_SAKAT = GET_ALL_WOMEN_STARTED_SAKAT.RECORDCOUNT + 0>
		<cfset FIRED_WOMEN_SAKAT = GET_ALL_WOMEN_FIRED_SAKAT.RECORDCOUNT + 0>
	<cfelse>
		<cfset ALL_WOMEN_SAKAT = 0>
		<cfset STARTED_WOMEN_SAKAT = 0>
		<cfset FIRED_WOMEN_SAKAT = 0>
	</cfif>
	
	<cfif GET_ALL_WOMEN_HUKUMLU.recordcount>

		<cfquery name="GET_ALL_WOMEN_STARTED_HUKUMLU" dbtype="QUERY">
			SELECT
				EMPLOYEE_ID
			FROM
				GET_ALL_WOMEN_HUKUMLU
			WHERE
				START_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#this_month_starts#"> AND  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#this_month_ends#">
		</cfquery>
	
		<cfquery name="GET_ALL_WOMEN_FIRED_HUKUMLU" dbtype="QUERY">
			SELECT
				EMPLOYEE_ID
			FROM
				GET_ALL_WOMEN_HUKUMLU
			WHERE
				FINISH_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#this_month_starts#"> AND  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#this_month_ends#">
				AND VALID = 1
		</cfquery>
		
		<cfset ALL_WOMEN_HUKUMLU = GET_ALL_WOMEN_HUKUMLU.RECORDCOUNT + 0>
		<cfset STARTED_WOMEN_HUKUMLU = GET_ALL_WOMEN_STARTED_HUKUMLU.RECORDCOUNT + 0>
		<cfset FIRED_WOMEN_HUKUMLU = GET_ALL_WOMEN_FIRED_HUKUMLU.RECORDCOUNT + 0>
	<cfelse>
		<cfset ALL_WOMEN_HUKUMLU = 0>
		<cfset STARTED_WOMEN_HUKUMLU = 0>
		<cfset FIRED_WOMEN_HUKUMLU = 0>
	</cfif>
	
	<cfif GET_ALL_WOMEN_TEROR.recordcount>

		<cfquery name="GET_ALL_WOMEN_STARTED_TEROR" dbtype="QUERY">
			SELECT
				EMPLOYEE_ID
			FROM
				GET_ALL_WOMEN_TEROR
			WHERE
				START_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#this_month_starts#"> AND  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#this_month_ends#">
		</cfquery>
	
		<cfquery name="GET_ALL_WOMEN_FIRED_TEROR" dbtype="QUERY">
			SELECT
				EMPLOYEE_ID
			FROM
				GET_ALL_WOMEN_TEROR
			WHERE
				FINISH_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#this_month_starts#"> AND  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#this_month_ends#">
				AND VALID = 1
		</cfquery>
		
		<cfset ALL_WOMEN_TEROR = GET_ALL_WOMEN_TEROR.RECORDCOUNT + 0>
		<cfset STARTED_WOMEN_TEROR = GET_ALL_WOMEN_STARTED_TEROR.RECORDCOUNT + 0>
		<cfset FIRED_WOMEN_TEROR = GET_ALL_WOMEN_FIRED_TEROR.RECORDCOUNT + 0>
	<cfelse>
		<cfset ALL_WOMEN_TEROR = 0>
		<cfset STARTED_WOMEN_TEROR = 0>
		<cfset FIRED_WOMEN_TEROR = 0>
	</cfif>
	
	<cfif GET_ALL_WOMEN_SURELI.recordcount>

		<cfquery name="GET_ALL_WOMEN_STARTED_SURELI" dbtype="QUERY">
			SELECT
				EMPLOYEE_ID
			FROM
				GET_ALL_WOMEN_SURELI
			WHERE
				START_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#this_month_starts#"> AND  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#this_month_ends#">
		</cfquery>
	
		<cfquery name="GET_ALL_WOMEN_FIRED_SURELI" dbtype="QUERY">
			SELECT
				EMPLOYEE_ID
			FROM
				GET_ALL_WOMEN_SURELI
			WHERE
				FINISH_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#this_month_starts#"> AND  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#this_month_ends#">
				AND VALID = 1
		</cfquery>
		
		<cfset ALL_WOMEN_SURELI = GET_ALL_WOMEN_SURELI.RECORDCOUNT + 0>
		<cfset STARTED_WOMEN_SURELI = GET_ALL_WOMEN_STARTED_SURELI.RECORDCOUNT + 0>
		<cfset FIRED_WOMEN_SURELI = GET_ALL_WOMEN_FIRED_SURELI.RECORDCOUNT + 0>
	<cfelse>
		<cfset ALL_WOMEN_SURELI = 0>
		<cfset STARTED_WOMEN_SURELI = 0>
		<cfset FIRED_WOMEN_SURELI = 0>
	</cfif>
	
	<cfif GET_ALL_WOMEN_SURESIZ.recordcount>
		<cfquery name="GET_ALL_WOMEN_STARTED_SURESIZ" dbtype="QUERY">
			SELECT
				EMPLOYEE_ID
			FROM
				GET_ALL_WOMEN_SURESIZ
			WHERE
				START_DATE >= <cfqueryparam value="#this_month_starts#" cfsqltype="cf_sql_timestamp"> AND 
				START_DATE <= <cfqueryparam value="#this_month_ends#" cfsqltype="cf_sql_timestamp">
		</cfquery>
		
		<cfquery name="GET_ALL_WOMEN_FIRED_SURESIZ" dbtype="QUERY">
			SELECT
				EMPLOYEE_ID
			FROM
				GET_ALL_WOMEN_SURESIZ
			WHERE
				FINISH_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#this_month_starts#"> AND  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#this_month_ends#">
				AND VALID = 1
		</cfquery>
		
		<cfset ALL_WOMEN_SURESIZ = GET_ALL_WOMEN_SURESIZ.RECORDCOUNT + 0>
		<cfset STARTED_WOMEN_SURESIZ = GET_ALL_WOMEN_STARTED_SURESIZ.RECORDCOUNT + 0>
		<cfset FIRED_WOMEN_SURESIZ = GET_ALL_WOMEN_FIRED_SURESIZ.RECORDCOUNT + 0>
	<cfelse>
		<cfset ALL_WOMEN_SURESIZ = 0>
		<cfset STARTED_WOMEN_SURESIZ = 0>
		<cfset FIRED_WOMEN_SURESIZ = 0>
	</cfif>
	
	<cfif GET_ALL_WOMEN_PARTTIME.recordcount>

		<cfquery name="GET_ALL_WOMEN_STARTED_PARTTIME" dbtype="QUERY">
			SELECT
				EMPLOYEE_ID
			FROM
				GET_ALL_WOMEN_PARTTIME
			WHERE
				START_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#this_month_starts#"> AND  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#this_month_ends#">
		</cfquery>
	
		<cfquery name="GET_ALL_WOMEN_FIRED_PARTTIME" dbtype="QUERY">
			SELECT
				EMPLOYEE_ID
			FROM
				GET_ALL_WOMEN_PARTTIME
			WHERE
				FINISH_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#this_month_starts#"> AND  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#this_month_ends#">
				AND VALID = 1
		</cfquery>
		
		<cfset ALL_WOMEN_PARTTIME = GET_ALL_WOMEN_PARTTIME.RECORDCOUNT + 0>
		<cfset STARTED_WOMEN_PARTTIME = GET_ALL_WOMEN_STARTED_PARTTIME.RECORDCOUNT + 0>
		<cfset FIRED_WOMEN_PARTTIME = GET_ALL_WOMEN_FIRED_PARTTIME.RECORDCOUNT + 0>
	<cfelse>
		<cfset ALL_WOMEN_PARTTIME = 0>
		<cfset STARTED_WOMEN_PARTTIME = 0>
		<cfset FIRED_WOMEN_PARTTIME = 0>
	</cfif>

	<cfset ALL_WOMEN = GET_ALL_WOMEN.RECORDCOUNT + 0>
	<cfset STARTED_WOMEN = GET_ALL_WOMEN_STARTED.RECORDCOUNT + 0>
	<cfset FIRED_WOMEN = GET_ALL_WOMEN_FIRED.RECORDCOUNT + 0>

<cfelse>
	<cfset ALL_WOMEN = 0>
	<cfset STARTED_WOMEN = 0>
	<cfset FIRED_WOMEN = 0>
	<cfset ALL_WOMEN_SAKAT = 0>
	<cfset STARTED_WOMEN_SAKAT = 0>
	<cfset FIRED_WOMEN_SAKAT = 0>
	<cfset ALL_WOMEN_TEROR = 0>
	<cfset STARTED_WOMEN_TEROR = 0>
	<cfset FIRED_WOMEN_TEROR = 0>
	<cfset ALL_WOMEN_HUKUMLU = 0>
	<cfset STARTED_WOMEN_HUKUMLU = 0>
	<cfset FIRED_WOMEN_HUKUMLU = 0>
	<cfset ALL_WOMEN_SURELI = 0>
	<cfset STARTED_WOMEN_SURELI = 0>
	<cfset FIRED_WOMEN_SURELI = 0>
	<cfset ALL_WOMEN_SURESIZ = 0>
	<cfset STARTED_WOMEN_SURESIZ = 0>
	<cfset FIRED_WOMEN_SURESIZ = 0>
	<cfset ALL_WOMEN_PARTTIME = 0>
	<cfset STARTED_WOMEN_PARTTIME = 0>
	<cfset FIRED_WOMEN_PARTTIME = 0>
</cfif>

<cfquery name="GET_ALL_MEN" dbtype="query">
	SELECT
		EMPLOYEE_ID,
		START_DATE,
		FINISH_DATE,
		DEFECTED,
		DEFECTION_LEVEL,
		TERROR_WRONGED,
		SENTENCED,
		VALID,
		SURELI_IS_AKDI,
		SALARY_TYPE
	FROM
		get_all_personel
	WHERE
		SEX = 1
</cfquery>

<cfif GET_ALL_MEN.recordcount>
	<cfquery name="GET_ALL_MEN_STARTED" dbtype="QUERY">
		SELECT
			EMPLOYEE_ID
		FROM
			GET_ALL_MEN
		WHERE
			START_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#this_month_starts#"> AND  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#this_month_ends#">
	</cfquery>

	<cfquery name="GET_ALL_MEN_FIRED" dbtype="QUERY">
		SELECT
			EMPLOYEE_ID
		FROM
			GET_ALL_MEN
		WHERE
			FINISH_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#this_month_starts#"> AND  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#this_month_ends#">
			AND VALID = 1
	</cfquery>

	<cfquery name="GET_ALL_MEN_SAKAT" dbtype="QUERY">
		SELECT
			EMPLOYEE_ID,
			START_DATE,
			FINISH_DATE,
			VALID
		FROM
			GET_ALL_MEN
		WHERE
			DEFECTION_LEVEL > 0
	</cfquery>

	<cfquery name="GET_ALL_MEN_HUKUMLU" dbtype="QUERY">
		SELECT
			EMPLOYEE_ID,
			START_DATE,
			FINISH_DATE,
			VALID
		FROM
			GET_ALL_MEN
		WHERE
			SENTENCED = 1
	</cfquery>

	<cfquery name="GET_ALL_MEN_TEROR" dbtype="QUERY">
		SELECT
			EMPLOYEE_ID,
			START_DATE,
			FINISH_DATE,
			VALID
		FROM
			GET_ALL_MEN
		WHERE
			TERROR_WRONGED = 1
	</cfquery>

	<cfquery name="GET_ALL_MEN_SURELI" dbtype="QUERY">
		SELECT
			EMPLOYEE_ID,
			START_DATE,
			FINISH_DATE,
			VALID
		FROM
			GET_ALL_MEN
		WHERE
			SURELI_IS_AKDI = 1 AND
			(
			DEFECTION_LEVEL = 0 AND
			(TERROR_WRONGED = 0 OR TERROR_WRONGED IS NULL) AND
			(SENTENCED = 0 OR SENTENCED IS NULL)
			)
	</cfquery>

	<cfquery name="GET_ALL_MEN_SURESIZ" dbtype="QUERY">
		SELECT
			EMPLOYEE_ID,
			START_DATE,
			FINISH_DATE,
			VALID
		FROM
			GET_ALL_MEN
		WHERE
			(SURELI_IS_AKDI = 0 OR SURELI_IS_AKDI IS NULL) AND
			(
			DEFECTION_LEVEL = 0 AND
			(TERROR_WRONGED = 0 OR TERROR_WRONGED IS NULL) AND
			(SENTENCED = 0 OR SENTENCED IS NULL)
			)
	</cfquery>

	<cfquery name="GET_ALL_MEN_PARTTIME" dbtype="QUERY">
		SELECT
			EMPLOYEE_ID,
			START_DATE,
			FINISH_DATE,
			VALID
		FROM
			GET_ALL_MEN
		WHERE
			SALARY_TYPE = 0
	</cfquery>

	<cfif GET_ALL_MEN_SAKAT.recordcount>

		<cfquery name="GET_ALL_MEN_STARTED_SAKAT" dbtype="QUERY">
			SELECT
				EMPLOYEE_ID
			FROM
				GET_ALL_MEN_SAKAT
			WHERE
				START_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#this_month_starts#"> AND  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#this_month_ends#">
		</cfquery>
	
		<cfquery name="GET_ALL_MEN_FIRED_SAKAT" dbtype="QUERY">
			SELECT
				EMPLOYEE_ID
			FROM
				GET_ALL_MEN_SAKAT
			WHERE
				FINISH_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#this_month_starts#"> AND  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#this_month_ends#">
				AND VALID = 1
		</cfquery>
		
		<cfset ALL_MEN_SAKAT = GET_ALL_MEN_SAKAT.RECORDCOUNT + 0>
		<cfset STARTED_MEN_SAKAT = GET_ALL_MEN_STARTED_SAKAT.RECORDCOUNT + 0>
		<cfset FIRED_MEN_SAKAT = GET_ALL_MEN_FIRED_SAKAT.RECORDCOUNT + 0>
	<cfelse>
		<cfset ALL_MEN_SAKAT = 0>
		<cfset STARTED_MEN_SAKAT = 0>
		<cfset FIRED_MEN_SAKAT = 0>
	</cfif>
	
	<cfif GET_ALL_MEN_HUKUMLU.recordcount>

		<cfquery name="GET_ALL_MEN_STARTED_HUKUMLU" dbtype="QUERY">
			SELECT
				EMPLOYEE_ID
			FROM
				GET_ALL_MEN_HUKUMLU
			WHERE
				START_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#this_month_starts#"> AND  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#this_month_ends#">
		</cfquery>
	
		<cfquery name="GET_ALL_MEN_FIRED_HUKUMLU" dbtype="QUERY">
			SELECT
				EMPLOYEE_ID
			FROM
				GET_ALL_MEN_HUKUMLU
			WHERE
				FINISH_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#this_month_starts#"> AND  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#this_month_ends#">
				AND VALID = 1
		</cfquery>
		
		<cfset ALL_MEN_HUKUMLU = GET_ALL_MEN_HUKUMLU.RECORDCOUNT + 0>
		<cfset STARTED_MEN_HUKUMLU = GET_ALL_MEN_STARTED_HUKUMLU.RECORDCOUNT + 0>
		<cfset FIRED_MEN_HUKUMLU = GET_ALL_MEN_FIRED_HUKUMLU.RECORDCOUNT + 0>
	<cfelse>
		<cfset ALL_MEN_HUKUMLU = 0>
		<cfset STARTED_MEN_HUKUMLU = 0>
		<cfset FIRED_MEN_HUKUMLU = 0>
	</cfif>
	
	<cfif GET_ALL_MEN_TEROR.recordcount>

		<cfquery name="GET_ALL_MEN_STARTED_TEROR" dbtype="QUERY">
			SELECT
				EMPLOYEE_ID
			FROM
				GET_ALL_MEN_TEROR
			WHERE
				START_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#this_month_starts#"> AND  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#this_month_ends#">
		</cfquery>
	
		<cfquery name="GET_ALL_MEN_FIRED_TEROR" dbtype="QUERY">
			SELECT
				EMPLOYEE_ID
			FROM
				GET_ALL_MEN_TEROR
			WHERE
				FINISH_DATE BETWEEN <cfqueryparam value="#this_month_starts#" cfsqltype="cf_sql_timestamp"> AND  <cfqueryparam value="#this_month_ends#" cfsqltype="cf_sql_timestamp">
				AND VALID = 1
		</cfquery>
		
		<cfset ALL_MEN_TEROR = GET_ALL_MEN_TEROR.RECORDCOUNT + 0>
		<cfset STARTED_MEN_TEROR = GET_ALL_MEN_STARTED_TEROR.RECORDCOUNT + 0>
		<cfset FIRED_MEN_TEROR = GET_ALL_MEN_FIRED_TEROR.RECORDCOUNT + 0>
	<cfelse>
		<cfset ALL_MEN_TEROR = 0>
		<cfset STARTED_MEN_TEROR = 0>
		<cfset FIRED_MEN_TEROR = 0>
	</cfif>
	
	<cfif GET_ALL_MEN_SURELI.recordcount>

		<cfquery name="GET_ALL_MEN_STARTED_SURELI" dbtype="QUERY">
			SELECT
				EMPLOYEE_ID
			FROM
				GET_ALL_MEN_SURELI
			WHERE
				START_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#this_month_starts#"> AND  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#this_month_ends#">
		</cfquery>
	
		<cfquery name="GET_ALL_MEN_FIRED_SURELI" dbtype="QUERY">
			SELECT
				EMPLOYEE_ID
			FROM
				GET_ALL_MEN_SURELI
			WHERE
				FINISH_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#this_month_starts#"> AND  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#this_month_ends#">
				AND VALID = 1
		</cfquery>
		
		<cfset ALL_MEN_SURELI = GET_ALL_MEN_SURELI.RECORDCOUNT + 0>
		<cfset STARTED_MEN_SURELI = GET_ALL_MEN_STARTED_SURELI.RECORDCOUNT + 0>
		<cfset FIRED_MEN_SURELI = GET_ALL_MEN_FIRED_SURELI.RECORDCOUNT + 0>
	<cfelse>
		<cfset ALL_MEN_SURELI = 0>
		<cfset STARTED_MEN_SURELI = 0>
		<cfset FIRED_MEN_SURELI = 0>
	</cfif>
	
	<cfif GET_ALL_MEN_SURESIZ.recordcount>

		<cfquery name="GET_ALL_MEN_STARTED_SURESIZ" dbtype="QUERY">
			SELECT
				EMPLOYEE_ID
			FROM
				GET_ALL_MEN_SURESIZ
			WHERE
				START_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#this_month_starts#"> AND  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#this_month_ends#">
		</cfquery>
	
		<cfquery name="GET_ALL_MEN_FIRED_SURESIZ" dbtype="QUERY">
			SELECT
				EMPLOYEE_ID
			FROM
				GET_ALL_MEN_SURESIZ
			WHERE
				FINISH_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#this_month_starts#"> AND  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#this_month_ends#">
				AND VALID = 1
		</cfquery>
		
		<cfset ALL_MEN_SURESIZ = GET_ALL_MEN_SURESIZ.RECORDCOUNT + 0>
		<cfset STARTED_MEN_SURESIZ = GET_ALL_MEN_STARTED_SURESIZ.RECORDCOUNT + 0>
		<cfset FIRED_MEN_SURESIZ = GET_ALL_MEN_FIRED_SURESIZ.RECORDCOUNT + 0>
	<cfelse>
		<cfset ALL_MEN_SURESIZ = 0>
		<cfset STARTED_MEN_SURESIZ = 0>
		<cfset FIRED_MEN_SURESIZ = 0>
	</cfif>
	
	<cfif GET_ALL_MEN_PARTTIME.recordcount>

		<cfquery name="GET_ALL_MEN_STARTED_PARTTIME" dbtype="QUERY">
			SELECT
				EMPLOYEE_ID
			FROM
				GET_ALL_MEN_PARTTIME
			WHERE
				START_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#this_month_starts#"> AND  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#this_month_ends#">
		</cfquery>
	
		<cfquery name="GET_ALL_MEN_FIRED_PARTTIME" dbtype="QUERY">
			SELECT
				EMPLOYEE_ID
			FROM
				GET_ALL_MEN_PARTTIME
			WHERE
				FINISH_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#this_month_starts#"> AND  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#this_month_ends#">
				AND VALID = 1
		</cfquery>
		
		<cfset ALL_MEN_PARTTIME = GET_ALL_MEN_PARTTIME.RECORDCOUNT + 0>
		<cfset STARTED_MEN_PARTTIME = GET_ALL_MEN_STARTED_PARTTIME.RECORDCOUNT + 0>
		<cfset FIRED_MEN_PARTTIME = GET_ALL_MEN_FIRED_PARTTIME.RECORDCOUNT + 0>
	<cfelse>
		<cfset ALL_MEN_PARTTIME = 0>
		<cfset STARTED_MEN_PARTTIME = 0>
		<cfset FIRED_MEN_PARTTIME = 0>
	</cfif>

	<cfset ALL_MEN = GET_ALL_MEN.RECORDCOUNT + 0>
	<cfset STARTED_MEN = GET_ALL_MEN_STARTED.RECORDCOUNT + 0>
	<cfset FIRED_MEN = GET_ALL_MEN_FIRED.RECORDCOUNT + 0>

<cfelse>
	<cfset ALL_MEN_SAKAT = 0>
	<cfset STARTED_MEN_SAKAT = 0>
	<cfset FIRED_MEN_SAKAT = 0>
	<cfset ALL_MEN_TEROR = 0>
	<cfset STARTED_MEN_TEROR = 0>
	<cfset FIRED_MEN_TEROR = 0>
	<cfset ALL_MEN_HUKUMLU = 0>
	<cfset STARTED_MEN_HUKUMLU = 0>
	<cfset FIRED_MEN_HUKUMLU = 0>
	<cfset ALL_MEN = 0>
	<cfset STARTED_MEN = 0>
	<cfset FIRED_MEN = 0>
	<cfset ALL_MEN_SURELI = 0>
	<cfset STARTED_MEN_SURELI = 0>
	<cfset FIRED_MEN_SURELI = 0>
	<cfset ALL_MEN_SURESIZ = 0>
	<cfset STARTED_MEN_SURESIZ = 0>
	<cfset FIRED_MEN_SURESIZ = 0>
	<cfset ALL_MEN_PARTTIME = 0>
	<cfset STARTED_MEN_PARTTIME = 0>
	<cfset FIRED_MEN_PARTTIME = 0>
</cfif>

<cfquery name="get_worktimes" dbtype="query">
	SELECT
		EMPLOYEE_ID
	FROM
		get_all_personel
	WHERE
		SALARY_TYPE = 0
</cfquery>

<cfif get_worktimes.RECORDCOUNT>
	<cfquery name="get_worktimes" datasource="#dsn#">
		SELECT
			SUM(TOTAL_DAYS * SSK_WORK_HOURS) AS TOPLAM_GUN,
			SUM(TOTAL_HOURS) AS TOPLAM_SAAT
		FROM
			EMPLOYEES_PUANTAJ,
			EMPLOYEES_PUANTAJ_ROWS
		WHERE
			EMPLOYEES_PUANTAJ_ROWS.EMPLOYEE_ID IN (0,#VALUELIST(get_worktimes.EMPLOYEE_ID)#)
			AND EMPLOYEES_PUANTAJ.PUANTAJ_ID = EMPLOYEES_PUANTAJ_ROWS.PUANTAJ_ID
			AND EMPLOYEES_PUANTAJ.SAL_YEAR = #attributes.sal_year#
			AND EMPLOYEES_PUANTAJ.SAL_MON = #attributes.sal_mon#
	</cfquery>
	<cfif len(get_worktimes.TOPLAM_SAAT) or len(get_worktimes.TOPLAM_GUN)>
		<cfset TOPLAM_PART_TIME = get_worktimes.TOPLAM_GUN + get_worktimes.TOPLAM_SAAT>
	<cfelse>
		<cfset TOPLAM_PART_TIME = 0>
	</cfif>
	
<cfelse>
	<cfset TOPLAM_PART_TIME = 0>
</cfif>
