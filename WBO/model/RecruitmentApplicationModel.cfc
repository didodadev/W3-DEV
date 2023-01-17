<!-----------------------------------------------------------------------
*************************************************************************
		Copyright Workcube E-Business Inc. www.workcube.com
*************************************************************************
Analys		: Fatih Ayık			Developer	: Meltem Aşkın		
Analys Date : 01/04/2016			Dev Date	: 25/05/2016		
Description :
	Bu component İlan Başvuruları objesine ait CRUD ve list fonksiyonlarını gerceklestirir.
----------------------------------------------------------------------->

<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    
    <!--- get --->
    <cffunction name="get" access="public" returntype="query">
		<cfargument name="notice_id" type="numeric" default="0" required="yes">
        
		<cfquery name="get" datasource="#dsn#">
            SELECT
                APP_POS_ID,
                EMPAPP_ID,
                POSITION_ID,
                POSITION_CAT_ID,
                APP_DATE,
                COMPANY_ID,
                OUR_COMPANY_ID,
                BRANCH_ID,
                DEPARTMENT_ID,
                SALARY_WANTED,
                SALARY_WANTED_MONEY,
                STARTDATE_IF_ACCEPTED,
                APP_POS_STATUS,
                DETAIL
            FROM
                EMPLOYEES_APP_POS
            WHERE
                NOTICE_ID = #arguments.NOTICE_ID#
        </cfquery>

		<cfreturn get>
	</cffunction>
    
</cfcomponent>