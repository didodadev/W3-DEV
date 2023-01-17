<!-----------------------------------------------------------------------
*************************************************************************
		Copyright Workcube E-Business Inc. www.workcube.com
*************************************************************************
Analys		: Fatih Ayık			Developer	: Göksenin Sönmez Özkorucu		
Analys Date : 01/04/2016			Dev Date	: 07/06/2016		
Description :
	Bu component verdiğim hedefler objesine ait list fonksiyonlarını gerceklestirir.
----------------------------------------------------------------------->

<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    
    <!--- list --->
    <cffunction name="list" access="public" returntype="query">
    	<cfargument name="keyword" type="string" default="" required="no" hint="Keyword; hedefe göre arama yapar">
        <cfargument name="targetEmp" type="numeric" default="0" required="no" hint="Hedef Veren">
        
    	<cfquery name="get_assign_targets" datasource="#dsn#">
            SELECT
            	T.CALCULATION_TYPE,
                T.FINISHDATE,
            	T.POSITION_CODE,
                T.STARTDATE,
                T.TARGET_EMP,
                T.TARGET_HEAD,
                T.TARGET_ID,
                T.TARGET_NUMBER,
                TC.TARGETCAT_NAME,
                EP.EMPLOYEE_NAME,
				EP.EMPLOYEE_SURNAME,
                EP.EMPLOYEE_ID
            FROM 
                TARGET T
                INNER JOIN TARGET_CAT TC ON TC.TARGETCAT_ID = T.TARGETCAT_ID
                LEFT JOIN EMPLOYEE_POSITIONS EP ON EP.POSITION_CODE = T.POSITION_CODE
            WHERE
            	1 = 1
            	<cfif len(arguments.targetEmp) and arguments.targetEmp neq 0>
                	AND T.TARGET_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.targetEmp#">
               	</cfif>
                <cfif len(arguments.keyword)>
                	AND T.TARGET_HEAD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%">
                </cfif>
            ORDER BY 
            	STARTDATE DESC
        </cfquery>
		<cfreturn get_assign_targets>
    </cffunction>
</cfcomponent>