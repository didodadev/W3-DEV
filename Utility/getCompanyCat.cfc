<!-----------------------------------------------------------------------
*************************************************************************
		Copyright Workcube E-Business Inc. www.workcube.com
*************************************************************************
Analys		: Fatih Ayık			Developer	: Fatih Ayık		
Analys Date : 19/05/2016			Dev Date	: 19/05/2016		
Description :
	Bu utility yetkili olduğum kurumsal Üye Kategorilerini getirir applicationStart methodunda create edilir.
	
Patameters :

Used : getCompanyCat.get();
----------------------------------------------------------------------->

<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="get" access="public" returntype="query">
        
		<cfquery name="get" datasource="#DSN#">
            SELECT DISTINCT	
                COMPANYCAT_ID,
                COMPANYCAT
            FROM
                GET_MY_COMPANYCAT
            WHERE
                EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"> AND
                OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
            ORDER BY
                COMPANYCAT		
        </cfquery>
        
		<cfreturn get>
	</cffunction>
</cfcomponent>