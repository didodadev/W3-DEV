<cfcomponent>
    <cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="GET_SSK_XML_EXPORTS" access="remote"  returntype="any">
        <cfargument name="sal_mon" required="true">
        <cfargument name="sal_year" required="true">
        <cfargument name="ssk_office" required="true">

        <cfquery name="GET_SSK_XML_EXPORTS" datasource="#DSN#">
			SELECT 
				EMPLOYEES_MUHTASAR_EXPORTS.SSK_OFFICE,
				EMPLOYEES_MUHTASAR_EXPORTS.SSK_OFFICE_NO,
				EMPLOYEES_MUHTASAR_EXPORTS.RECORD_DATE,
				EMPLOYEES_MUHTASAR_EXPORTS.EME_ID,
				EMPLOYEES_MUHTASAR_EXPORTS.EXCEL_FILE_NAME,
				EMPLOYEES_MUHTASAR_EXPORTS.FILE_NAME,
				EMPLOYEES_MUHTASAR_EXPORTS.FILE_NAME_7103,
				EMPLOYEES_MUHTASAR_EXPORTS.SAL_MON,
				EMPLOYEES_MUHTASAR_EXPORTS.SAL_YEAR,
				EMPLOYEES_MUHTASAR_EXPORTS.EXPORT_REASON,
				EMPLOYEES_MUHTASAR_EXPORTS.EXPORT_TYPE,
				EMPLOYEES_MUHTASAR_EXPORTS.SSK_BRANCH_ID,
				EMPLOYEES_MUHTASAR_EXPORTS.COMPANY_ID,
				EMPLOYEES_MUHTASAR_EXPORTS.EXCEL_FILE_NAME_7103,
				EMPLOYEES_MUHTASAR_EXPORTS.EXCEL_XLS_FILE_NAME_7103,
                EMPLOYEES_MUHTASAR_EXPORTS.EXCEL_XLS_FILE_NAME
			FROM 
				EMPLOYEES_MUHTASAR_EXPORTS
					LEFT JOIN BRANCH ON (BRANCH.BRANCH_ID = EMPLOYEES_MUHTASAR_EXPORTS.SSK_BRANCH_ID)
					LEFT JOIN OUR_COMPANY ON (OUR_COMPANY.COMP_ID = EMPLOYEES_MUHTASAR_EXPORTS.COMPANY_ID)
			WHERE
                (
					(
						BRANCH.BRANCH_ID IN 
						(
							SELECT
								BRANCH_ID
							FROM
								EMPLOYEE_POSITION_BRANCHES
							WHERE
								EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = #session.ep.position_code#
						)
					)
					OR
					(
						EMPLOYEES_MUHTASAR_EXPORTS.RECORD_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
					)
				)
				<cfif len(arguments.sal_year)>
					AND EMPLOYEES_MUHTASAR_EXPORTS.SAL_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.sal_year#">
				</cfif>
				<cfif len(arguments.sal_mon)>
					AND EMPLOYEES_MUHTASAR_EXPORTS.SAL_MON = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.sal_mon#">
				</cfif>
				<cfif len(arguments.ssk_office)>
					AND BRANCH.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.ssk_office#">
				</cfif>				
			ORDER BY
				EMPLOYEES_MUHTASAR_EXPORTS.RECORD_DATE DESC
		</cfquery>
        <cfreturn GET_SSK_XML_EXPORTS>
    </cffunction>
</cfcomponent>