<!-----------------------------------------------------------------------
*************************************************************************
		Copyright Workcube E-Business Inc. www.workcube.com
*************************************************************************
Analys		: Fatih Ayık			Developer	: Meltem Aşkın		
Analys Date : 01/04/2016			Dev Date	: 25/05/2016		
Description :
	Bu component personel talepleri objesine ait CRUD ve list fonksiyonlarını gerceklestirir.
----------------------------------------------------------------------->

<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    
    <!--- get --->
    <cffunction name="get" access="public" returntype="query">
		<cfargument name="per_req_id" type="numeric" default="0" required="yes">
        
		<cfquery name="get" datasource="#dsn#">
            SELECT
                PRF.*,
                B.BRANCH_NAME,
                D.DEPARTMENT_HEAD,
                OC.NICK_NAME,
                EP.POSITION_NAME,
                EP.EMPLOYEE_NAME,
                EP.EMPLOYEE_SURNAME,
                SPC.POSITION_CAT
            FROM
                PERSONEL_REQUIREMENT_FORM PRF
                LEFT JOIN OUR_COMPANY OC ON OC.COMP_ID = PRF.OUR_COMPANY_ID
                LEFT JOIN BRANCH B ON B.BRANCH_ID = PRF.BRANCH_ID AND B.COMPANY_ID = OC.COMP_ID
                LEFT JOIN DEPARTMENT D ON D.DEPARTMENT_ID = PRF.DEPARTMENT_ID
                LEFT JOIN EMPLOYEE_POSITIONS EP ON EP.POSITION_CODE = PRF.POSITION_ID
                LEFT JOIN SETUP_POSITION_CAT SPC ON SPC.POSITION_CAT_ID = PRF.POSITION_CAT_ID
            WHERE
                PRF.PERSONEL_REQUIREMENT_ID = #arguments.per_req_id#
        </cfquery>
		<cfreturn get>
	</cffunction>
    
</cfcomponent>