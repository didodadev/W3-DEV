<!-----------------------------------------------------------------------
*************************************************************************
		Copyright Workcube E-Business Inc. www.workcube.com
*************************************************************************
Analys		: Fatih Ayık			Developer	: Fatih Ayık		
Analys Date : 26/05/2016			Dev Date	: 26/05/2016		
Description :
	Bu utility yetkili olduğum bireysel Üye Kategorilerini getirir applicationStart methodunda create edilir.
	
Patameters :

Used : getConsumerCat.get();
----------------------------------------------------------------------->

<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="get" access="public" returntype="query">
    	<cfargument name="status" type="string" default="" required="no">
        
		<cfquery name="get" datasource="#DSN#">
            SELECT DISTINCT	
                CONSCAT_ID,
                CONSCAT
            FROM
                GET_MY_CONSUMERCAT
            WHERE
                EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"> AND
                OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
                <cfif len(arguments.status)>AND IS_ACTIVE = #arguments.status#</cfif>
            ORDER BY
                CONSCAT		
        </cfquery>
        
		<cfreturn get>
	</cffunction>
</cfcomponent>