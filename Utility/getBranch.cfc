<!-----------------------------------------------------------------------
*************************************************************************
		Copyright Workcube E-Business Inc. www.workcube.com
*************************************************************************
Analys		: Fatih Ayık			Developer	: Göksenin Sönmez Özkorucu
Analys Date : 19/05/2016			Dev Date	: 26/05/2016		
Description :
	Bu utility Şubeleri getirir
	
Patameters :
		authorizationEhesap : Ehesap yetkisine bakabilir

Used : branches.get(authorizationEhesap:session.ep.ehesap);
----------------------------------------------------------------------->

<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="get" access="public" returntype="query">
        <cfargument name="authorizationEhesap" type="numeric" default="#session.ep.ehesap#" required="no">
        <cfargument name="allData" type="numeric" default="0" required="no">
        
		<cfquery name="getBranches" datasource="#DSN#">
            SELECT
				BRANCH.BRANCH_ID,
				BRANCH.BRANCH_NAME
            	<cfif arguments.allData eq 0>
                    ,BRANCH.BRANCH_ID,
                    BRANCH.BRANCH_NAME,
                    BRANCH.BRANCH_STATUS,
                    BRANCH.HIERARCHY,
                    BRANCH.HIERARCHY2,
                    OUR_COMPANY.COMP_ID,
                    OUR_COMPANY.COMPANY_NAME,
                    OUR_COMPANY.NICK_NAME
                </cfif>
            FROM
                BRANCH
                <cfif arguments.allData eq 0>
                	INNER JOIN OUR_COMPANY ON BRANCH.COMPANY_ID = OUR_COMPANY.COMP_ID
                </cfif>
            WHERE
                BRANCH.BRANCH_ID IS NOT NULL
                <cfif arguments.authorizationEhesap eq 0>
                    AND BRANCH.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)
                </cfif>
            ORDER BY
            	<cfif arguments.allData eq 0>
	                OUR_COMPANY.NICK_NAME,
                </cfif>
                BRANCH.BRANCH_NAME
        </cfquery>
        
		<cfreturn getBranches>
	</cffunction>
</cfcomponent>