<cfif attributes.emp_pro_selection eq 1>
	<!--- pozisyon(dolu-bos) --->
	<cfquery name="get_total_full_positions" dbtype="query">
		SELECT COUNT(EMPLOYEE_ID) EMPLOYEE_NUMBER FROM get_emp_positions_det WHERE EMPLOYEE_ID <> 0 AND EMPLOYEE_ID IS NOT NULL
	</cfquery>
	<cfquery name="get_total_empty_positions" dbtype="query">
		SELECT COUNT(EMPLOYEE_ID) EMPLOYEE_NUMBER FROM get_emp_positions_det_ WHERE EMPLOYEE_ID = 0 OR EMPLOYEE_ID IS NULL
	</cfquery>
	<!--- yaka tipi --->
	<cfquery name="get_total_white_collar" dbtype="query">
		SELECT COUNT(COLLAR_TYPE) EMPLOYEE_NUMBER FROM get_emp_positions_det WHERE COLLAR_TYPE = 2
	</cfquery>
	<cfquery name="get_total_blue_collar" dbtype="query">
		SELECT COUNT(COLLAR_TYPE) EMPLOYEE_NUMBER FROM get_emp_positions_det WHERE COLLAR_TYPE = 1
	</cfquery>
	<!--- cinsiyet --->
	<cfquery name="get_total_emp_women" dbtype="query">
		SELECT COUNT(EMPLOYEE_ID) EMPLOYEE_NUMBER  FROM get_emp_edu_det WHERE SEX = 0
	</cfquery>
	<cfquery name="get_total_emp_men" dbtype="query">
		SELECT COUNT(EMPLOYEE_ID) EMPLOYEE_NUMBER  FROM get_emp_edu_det WHERE SEX = 1
	</cfquery>

	<!--- ogrenim durumu --->
	<cfloop query="get_education_level">
		<cfquery name="get_total_emp_edu#currentrow#" dbtype="query">
			SELECT COUNT(LAST_SCHOOL) EMPLOYEE_NUMBER FROM get_emp_edu_det WHERE LAST_SCHOOL = #get_education_level.edu_level_id#
		</cfquery>
	</cfloop>
	<cfquery name="get_all_emp" dbtype="query">
		SELECT 1 TYPE,EMPLOYEE_NUMBER FROM get_total_full_positions
		UNION ALL
		SELECT 2 TYPE,EMPLOYEE_NUMBER FROM get_total_empty_positions
		UNION ALL
		SELECT 3 TYPE,EMPLOYEE_NUMBER FROM get_total_emp_women
		UNION ALL
		SELECT 4 TYPE,EMPLOYEE_NUMBER FROM get_total_emp_men
		UNION ALL
		SELECT 5 TYPE,EMPLOYEE_NUMBER FROM get_total_white_collar
		UNION ALL
		SELECT 6 TYPE,EMPLOYEE_NUMBER FROM get_total_blue_collar
		<cfloop query="get_education_level" startrow="1" endrow="5">
			<cfoutput>UNION ALL SELECT #currentrow+6# TYPE,EMPLOYEE_NUMBER FROM get_total_emp_edu#currentrow#</cfoutput>
		</cfloop>
	</cfquery>
	<cfquery name="get_all_emp2" dbtype="query">
		SELECT 1 TYPE,EMPLOYEE_NUMBER FROM get_total_emp_women
		UNION ALL
		SELECT 2 TYPE,EMPLOYEE_NUMBER FROM get_total_emp_men
		<cfloop query="get_education_level" startrow="1" endrow="5">
			<cfoutput>UNION ALL SELECT #currentrow+2# TYPE,EMPLOYEE_NUMBER FROM get_total_emp_edu#currentrow#</cfoutput>
		</cfloop>
	</cfquery>
	<cfquery name="get_all_emp3" dbtype="query">
		SELECT 1 TYPE,EMPLOYEE_NUMBER FROM get_total_white_collar
		UNION ALL
		SELECT 2 TYPE,EMPLOYEE_NUMBER FROM get_total_blue_collar
		<cfloop query="get_education_level" startrow="1" endrow="5">
			<cfoutput>UNION ALL SELECT #currentrow+2# TYPE,EMPLOYEE_NUMBER FROM get_total_emp_edu#currentrow#</cfoutput>
		</cfloop>
	</cfquery>
</cfif>

