<cfif isdefined('attributes.start_date') and len(attributes.start_date)><cf_date tarih='attributes.start_date'></cfif>
<cfif isdefined('attributes.finish_date') and len(attributes.finish_date)><cf_date tarih='attributes.finish_date'></cfif>
<cfquery name="GET_TARGETS" datasource="#dsn#">
	SELECT 
		TARGET.TARGET_ID,
		TARGET.POSITION_CODE,
		TARGET.STARTDATE,
		TARGET.FINISHDATE,
		TARGET.TARGET_NUMBER,
		TARGET.TARGETCAT_ID,
		EMPLOYEE_POSITIONS.EMPLOYEE_NAME,
		EMPLOYEE_POSITIONS.EMPLOYEE_SURNAME,
		EMPLOYEE_POSITIONS.EMPLOYEE_ID,
		TARGET_CAT.TARGETCAT_NAME
	FROM 
		TARGET,
		EMPLOYEE_POSITIONS,
		TARGET_CAT,
		DEPARTMENT
	WHERE
		TARGET.POSITION_CODE IS NOT NULL AND
		EMPLOYEE_POSITIONS.POSITION_CODE = TARGET.POSITION_CODE AND
		TARGET_CAT.TARGETCAT_ID = TARGET.TARGETCAT_ID AND
		DEPARTMENT.DEPARTMENT_ID = EMPLOYEE_POSITIONS.DEPARTMENT_ID AND
		DEPARTMENT.BRANCH_ID IN (
                                    SELECT
                                        BRANCH_ID
                                    FROM
                                        EMPLOYEE_POSITION_BRANCHES
                                    WHERE
                                        POSITION_CODE = #SESSION.EP.POSITION_CODE#
                                )
		<cfif isdefined("attributes.keyword") and len(attributes.keyword)>
		AND (TARGET_DETAIL LIKE '%#attributes.keyword#%' COLLATE SQL_Latin1_General_CP1_CI_AI OR EMPLOYEE_NAME LIKE '%#attributes.keyword#%' COLLATE SQL_Latin1_General_CP1_CI_AI OR EMPLOYEE_SURNAME LIKE '%#attributes.keyword#%' COLLATE SQL_Latin1_General_CP1_CI_AI)
		</cfif>
		<cfif isdefined('attributes.targetcat_id') and len(attributes.targetcat_id)>AND TARGET.TARGETCAT_ID = #attributes.targetcat_id#</cfif>
		<cfif isdefined('attributes.start_date') and len(attributes.start_date)>AND STARTDATE >= #attributes.start_date#</cfif>
		<cfif isdefined('attributes.finish_date') and len(attributes.finish_date)>AND FINISHDATE <= #attributes.finish_date#</cfif>
		<cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>AND DEPARTMENT.BRANCH_ID = #attributes.branch_id#</cfif>
		<cfif isdefined("attributes.employee_poscode") and len(attributes.employee_poscode) and isdefined("attributes.employee_name") and len(attributes.employee_name) >
		AND TARGET.POSITION_CODE=#attributes.employee_poscode#
		</cfif>
	ORDER BY
		TARGET.STARTDATE DESC
</cfquery>

