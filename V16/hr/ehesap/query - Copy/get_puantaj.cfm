<cfquery name="GET_PUANTAJ" datasource="#dsn#">
	SELECT
		*
	FROM
		EMPLOYEES_PUANTAJ
	WHERE
	<cfif not isdefined("attributes.puantaj_id")>
		SAL_MON = #attributes.SAL_MON# AND
		SAL_YEAR = <cfif isdefined("attributes.sal_year") and isnumeric(attributes.sal_year)>#attributes.sal_year#<cfelse>#session.ep.period_year#</cfif> AND
		<cfif isdefined("attributes.employee_id") and isdefined("attributes.in_out_id")>
			PUANTAJ_ID IN(SELECT PUANTAJ_ID FROM EMPLOYEES_PUANTAJ_ROWS WHERE EMPLOYEE_ID = #attributes.employee_id#)
			AND PUANTAJ_ID IN(SELECT PUANTAJ_ID FROM EMPLOYEES_PUANTAJ_ROWS WHERE IN_OUT_ID = #attributes.in_out_id#)
		<cfelseif isdefined("attributes.employee_id")>
			PUANTAJ_ID IN(SELECT PUANTAJ_ID FROM EMPLOYEES_PUANTAJ_ROWS WHERE EMPLOYEE_ID = #attributes.employee_id#)
		<cfelse>	
<!---			SSK_BRANCH_ID = #listgetat(attributes.SSK_OFFICE,3,'-')# AND--->
			SSK_BRANCH_ID = #attributes.SSK_OFFICE# AND
			PUANTAJ_TYPE = #attributes.puantaj_type#
		</cfif>
		<cfif isdefined("attributes.hierarchy") and len(attributes.hierarchy)>
			AND HIERARCHY = '#attributes.hierarchy#'
		</cfif>
		<cfif isdefined("attributes.ssk_statue") and len(attributes.ssk_statue)> 
			AND STATUE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ssk_statue#">
			<cfif isdefined("attributes.statue_type") and len(attributes.statue_type) and attributes.ssk_statue eq 2>
				AND STATUE_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.statue_type#">
				<cfif attributes.statue_type eq 10 and isdefined("attributes.statue_type_individual") and attributes.statue_type_individual neq 0>
					AND SP.COMMENT_PAY_ID = <cfqueryparam CFSQLType = "cf_sql_integer" value = "#attributes.statue_type_individual#">
				</cfif>
			</cfif>
		</cfif>
	<cfelse>
		PUANTAJ_ID = #attributes.PUANTAJ_ID#
	</cfif>
</cfquery>
