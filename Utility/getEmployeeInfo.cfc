<!-----------------------------------------------------------------------
*************************************************************************
		Copyright Workcube E-Business Inc. www.workcube.com
*************************************************************************
Analys		: Fatih Ayık			Developer	: Fatih Ayık		
Analys Date : 20/05/2016			Dev Date	: 20/05/2016		
Description :
	Bu utility çalışana ait bilgileri getirir applicationStart methodunda create edilir.
	
Patameters :
		employeeId : kullanıcı ıd. Gönderilmez ise session daki kullanıcı bilgilerini getirir.

Used : getEmployeeInfo.get(employeeId:23);
----------------------------------------------------------------------->

<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="get" access="public" returntype="query">
        <cfargument name="employeeId" type="numeric" default="#session.ep.userid#" required="yes" hint="Çalışan ID">
		<cfquery name="get" datasource="#DSN#">
            SELECT 
            	*
            FROM 
            	EMPLOYEES
            WHERE 
            	EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.employeeId#">
        </cfquery>
		<cfreturn get>
	</cffunction>
</cfcomponent>