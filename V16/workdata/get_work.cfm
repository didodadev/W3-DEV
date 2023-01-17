<!--- 
	amac            : gelen work_name parametresine göre WORK_HEAD,WORK_ID bilgisini getirmek
	parametre adi   : work_name
	kullanim        : get_work 
 --->
 <cffunction name="get_work" access="public" returnType="query" output="no">
	<cfargument name="work_name" required="yes" type="string">
	<cfargument name="maxrows" required="no" type="numeric" default="-1">
    <cfargument name="get_own_works" required="no" type="string" default="0,1"><!--- Autocomplete cagrildigi yerde 1 parametresi gonderilirse bütün isler goruntulenir --->
    <cfargument name="project_id" required="no" type="numeric" default="0">
    <cfargument name="employee_id" default="#session.ep.userid#">
	<cfargument name="employee" default="#get_emp_info(arguments.employee_id,0,0)#">

		<cfquery name="get_work_" datasource="#dsn#" maxrows="-1">
			SELECT
				WORK_ID,
				WORK_HEAD
			FROM 
				PRO_WORKS
			WHERE
				WORK_STATUS = 1 AND
				WORK_HEAD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.work_name#%">
				<cfif arguments.project_id neq 0>
					AND PROJECT_ID = #arguments.project_id#
				</cfif>
                <cfif get_own_works neq 1>
					<cfif len(arguments.employee_id) and len(arguments.employee)>
                        AND	PROJECT_EMP_ID = #arguments.employee_id#
                    </cfif>
                </cfif>
			ORDER BY WORK_HEAD
		</cfquery>
	<cfreturn get_work_>
</cffunction>
