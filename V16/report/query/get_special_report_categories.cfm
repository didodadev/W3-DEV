<cfquery name="GET_SPECIAL_REPORT_CATEGORIES" datasource="#DSN#">
	SELECT
		SRC.REPORT_CAT_ID,
		SRC.REPORT_CAT,
		SRC.DETAIL,
		SRC.RECORD_DATE,
        SRC.RECORD_EMP,
        SRC.HIERARCHY,
		EMPLOYEES.EMPLOYEE_NAME,
		EMPLOYEES.EMPLOYEE_SURNAME
	FROM
		SETUP_REPORT_CAT SRC
		LEFT JOIN EMPLOYEES ON EMPLOYEES.EMPLOYEE_ID = SRC.RECORD_EMP
	WHERE
		1=1
		<cfif isdefined("attributes.keyword") and len(attributes.keyword)>
            <cfset attributes.keyword = trim(attributes.keyword)>
            AND (
                SRC.REPORT_CAT LIKE '%#attributes.keyword#%' OR 
                SRC.DETAIL LIKE '%#attributes.keyword#%'
                )
        </cfif>
	ORDER BY
		SRC.HIERARCHY
</cfquery>
