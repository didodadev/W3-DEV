<cfquery name="get_overtime" datasource="#dsn#">
	SELECT
		WORKTIMES_ID,
		OVERTIME_PERIOD,
		OVERTIME_MONTH,
		EMPLOYEE_ID,
		IN_OUT_ID,
		OVERTIME_VALUE_0,
		OVERTIME_VALUE_1,
		OVERTIME_VALUE_2,
		OVERTIME_VALUE_3,
		RECORD_EMP,
		RECORD_DATE,
		RECORD_IP,
		UPDATE_EMP,
		UPDATE_DATE,
		UPDATE_IP
	FROM
		EMPLOYEES_OVERTIME
	WHERE	
		1=1
	<cfif isdefined('attributes.employee_id') and len(attributes.employee_id)>
		AND EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">
	</cfif>
	<cfif isdefined('attributes.in_out_id') and len(attributes.in_out_id)>
		AND IN_OUT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.in_out_id#">
	</cfif>
	<cfif isdefined('attributes.related_year') and len(attributes.related_year)>
		AND OVERTIME_PERIOD = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.related_year#">
	</cfif>
    <cfif isdefined('attributes.overtime_id') and len(attributes.overtime_id)>
    	AND WORKTIMES_ID = #attributes.overtime_id#
    </cfif>
</cfquery>
