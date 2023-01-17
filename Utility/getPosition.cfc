<!-----------------------------------------------------------------------
*************************************************************************
		Copyright Workcube E-Business Inc. www.workcube.com
*************************************************************************
Analys		: Göksenin Sönmez Özkorucu		Developer	: Göksenin Sönmez Özkorucu	
Analys Date : 06/06/2016					Dev Date	: 06/06/2016		
Description :
	Bu utility pozisyon bilgilerini getirir applicationStart methodunda create edilir.

Used : getPosition.get();
----------------------------------------------------------------------->

<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="get" access="public" returntype="query">
        <cfargument name="positionCode" type="numeric" default="0" required="no" hint="Pozisyon Kodu">
        <cfargument name="employeeId" type="numeric" default="0" required="no" hint="Çalışan ID">
        <cfargument name="positionStatus" type="string" default="" required="no" hint="Aktif/Pasif">
        
		<cfquery name="getPositions" datasource="#dsn#">
            SELECT
            	EMPLOYEE_ID,
                POSITION_CODE
         	FROM
            	EMPLOYEE_POSITIONS
           	WHERE
            	1 = 1
                <cfif len(arguments.positionCode) and arguments.positionCode neq 0>
                	AND POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.positionCode#">
                </cfif>
                <cfif len(arguments.employeeId) and arguments.employeeId neq 0>
                	AND EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.employeeId#">
                </cfif>
                <cfif len(arguments.positionStatus)>
                	AND POSITION_STATUS = <cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.positionStatus#">
                </cfif>
        </cfquery>
        
		<cfreturn getPositions>
	</cffunction>
</cfcomponent>