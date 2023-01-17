<cfcomponent>
	<cfquery name="get_" datasource="workcube_cf">
		SELECT EMPLOYEE_NAME FROM EMPLOYEES WHERE EMPLOYEE_ID = 376
	</cfquery>
	<cfset this.querym = get_>
    <cfset This.basesalary=40*20>
</cfcomponent>
