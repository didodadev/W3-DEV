<cfquery name="GET_REPORTS" datasource="#DSN#">
	SELECT DISTINCT
		REPORTS.REPORT_ID,
		REPORTS.REPORT_NAME,
		REPORTS.IS_SPECIAL,
		REPORTS.IS_FILE,
		REPORTS.RECORD_DATE,
		REPORTS.REPORT_DETAIL,
		REPORTS.REPORT_STATUS,
		EMPLOYEES.EMPLOYEE_NAME,
		EMPLOYEES.EMPLOYEE_SURNAME,
		REPORTS.RECORD_EMP,
        REPORTS.REPORT_CAT_ID
	FROM
		REPORTS,
		EMPLOYEES
		<cfif session.ep.admin neq 1>,REPORT_ACCESS_RIGHTS</cfif>   
	WHERE
	    EMPLOYEES.EMPLOYEE_ID = REPORTS.RECORD_EMP
	<cfif isdefined("attributes.keyword") and len(attributes.keyword)>
		<cfset attributes.keyword = trim(attributes.keyword)>
		<cfif len(attributes.keyword) eq 1>
			AND REPORTS.REPORT_NAME LIKE '#attributes.keyword#%'
		<cfelse>
			AND (REPORTS.REPORT_NAME LIKE '%#attributes.keyword#%' OR REPORTS.REPORT_DETAIL LIKE '%#attributes.keyword#%')
		</cfif>
	</cfif>
    <cfif isdefined("attributes.report_cat_id") and len(attributes.report_cat_id)>
        AND( REPORTS.REPORT_CAT_ID IN (SELECT 
            								SETUP_REPORT_CAT.REPORT_CAT_ID 
                                       FROM 
                                       		SETUP_REPORT_CAT 
                                       WHERE 
                                           SETUP_REPORT_CAT.HIERARCHY LIKE '#attributes.report_cat_id#.%' 
                                           OR 
                                           SETUP_REPORT_CAT.HIERARCHY LIKE '%.#attributes.report_cat_id#.%'
                                           OR 
                                           SETUP_REPORT_CAT.REPORT_CAT_ID = #attributes.report_cat_id#
                                           ))
    </cfif>
	<cfif isdate(attributes.record_date)>
		AND REPORTS.RECORD_DATE >= #attributes.record_date#
		AND REPORTS.RECORD_DATE < #DATEADD
		("d",1,attributes.record_date)#
	</cfif>
	<cfif isdefined("attributes.report_status") and (attributes.report_status neq -1)>
		AND REPORTS.REPORT_STATUS = #attributes.report_status#
	<cfelseif not isDefined("attributes.report_status")>
		AND REPORTS.REPORT_STATUS = 1
	</cfif>
	<cfif isdefined("attributes.employee_id") and isdefined("attributes.employee") and attributes.employee_id gt 0 and len(attributes.employee)>
		AND REPORTS.RECORD_EMP = #attributes.employee_id#
	</cfif>
	<cfif session.ep.admin neq 1>
		AND REPORTS.ADMIN_STATUS <> 1
		AND REPORT_ACCESS_RIGHTS.REPORT_ID = REPORTS.REPORT_ID
		AND (
				POS_CAT_ID = (SELECT POSITION_CAT_ID FROM EMPLOYEE_POSITIONS WHERE EMPLOYEE_ID = #session.ep.userid# AND IS_MASTER = 1) OR
				POS_CODE = (SELECT POSITION_CODE FROM EMPLOYEE_POSITIONS WHERE EMPLOYEE_ID = #session.ep.userid# AND IS_MASTER = 1)
			)
	</cfif>
	ORDER BY
		REPORTS.REPORT_NAME
</cfquery>
