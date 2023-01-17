<!--- 
	Amaç            : Company id verilerek şirkete bağlı şubelere ulaşılabilir..
	parametre adi   : company_id
		ayirma isareti  : 
		kac parametreli : 1
		1. parametre: company_id
	kullanim        : 
	Yazan           : Cengiz Hark
	Tarih           : 23.04.2008
	Guncelleme      :  
 --->
<cffunction name="get_branch" access="public" returnType="query" output="no">
	<cfargument name="company_id" required="yes" type="string">
	<cfquery name="get_branch" datasource="#dsn#">
             SELECT 
                BRANCH_ID,
                BRANCH_NAME,
                BRANCH_FULLNAME
            FROM 
                BRANCH 
            WHERE 
				1 = 1
				<cfif len(arguments.company_id)>
                	AND COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.company_id#"> 
				</cfif>
				<cfif not get_module_power_user(67)>
					AND BRANCH_ID IN(SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#)
				</cfif>
	</cfquery>
	<cfreturn get_branch>
</cffunction>
	
