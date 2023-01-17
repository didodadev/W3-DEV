<cfcomponent hint="cfc d�k�mani i�in bir test componenti" displayname="test">
	<cffunction name="get_employee_surname" returntype="query" hint="�alisan Soyadini d�d�ren metot">
		<cfargument name="employee_name" required="yes" hint="�alisan adini alir">
			<cfquery name="get_employee_surname" datasource="workcube_cf">
				SELECT EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEE_NAME='#employee_name#'
			</cfquery>
			<cfreturn get_employee_surname> 
	</cffunction>
</cfcomponent>

