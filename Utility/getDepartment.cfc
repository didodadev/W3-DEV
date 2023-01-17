<!-----------------------------------------------------------------------
*************************************************************************
		Copyright Workcube E-Business Inc. www.workcube.com
*************************************************************************
Analys		: Fatih Ayık			Developer	: Göksenin Sönmez Özkorucu
Analys Date : 19/05/2016			Dev Date	: 26/05/2016		
Description :
	Bu utility Departmanları getirir
	
Patameters :
		branch_id : İlgili şubenin departmanlarını getirir


Used : departments.get(branch_id:get_audit.audit_branch_id);
----------------------------------------------------------------------->

<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="get" access="public" returntype="query">
        <cfargument name="branchId" type="numeric" default="0" required="no" hint="Şube Id'si">
        <cfargument name="all" type="boolean" default="0" required="no" hint="Şube Bilgileri Gelsin">
        <cfargument name="ehesapControl" type="numeric" default="" required="no" hint="Üst Düzey İK Kontrolü">
        
        <cfquery name="get_department" datasource="#dsn#">
            SELECT 
            	DEPARTMENT.DEPARTMENT_ID,
                DEPARTMENT.DEPARTMENT_HEAD
                <cfif arguments.all eq 1>
                	,DEPARTMENT.ADMIN1_POSITION_CODE
                    ,DEPARTMENT.ADMIN2_POSITION_CODE
                    ,BRANCH.BRANCH_NAME
                    ,BRANCH.BRANCH_ID
                </cfif>
			FROM 
            	DEPARTMENT
                <cfif arguments.all eq 1>
                	INNER JOIN BRANCH ON BRANCH.BRANCH_ID = DEPARTMENT.BRANCH_ID
                </cfif>
			WHERE
            	1 = 1
                <cfif arguments.branchId neq 0>
	            	AND BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.branchId#">
				</cfif>
                <cfif arguments.all eq 1>
                	AND DEPARTMENT.IS_STORE <> 1
                    AND BRANCH.SSK_NO IS NOT NULL
                    AND BRANCH.SSK_OFFICE IS NOT NULL
                    AND BRANCH.SSK_BRANCH IS NOT NULL
                    AND BRANCH.SSK_NO <> ''
                    AND BRANCH.SSK_OFFICE <> ''
                    AND BRANCH.SSK_BRANCH <> ''
                </cfif>
                <cfif len(arguments.ehesapControl) and not arguments.ehesapControl>
                	AND BRANCH.BRANCH_ID IN (
								SELECT
									BRANCH_ID
								FROM
									EMPLOYEE_POSITION_BRANCHES
								WHERE
									POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">
								)
                </cfif>
			ORDER BY
            	<cfif arguments.all eq 1>
                	BRANCH.BRANCH_NAME,
                </cfif>
            	DEPARTMENT.DEPARTMENT_HEAD
        </cfquery>
        
		<cfreturn get_department>
	</cffunction>
</cfcomponent>