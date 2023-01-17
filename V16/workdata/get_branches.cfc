<!--- 
	Amaç : Bulunduğu şirkete ve kullanıcının yetkili olduğu şube bilgilerini getirmek
	Kullanım: Şubeler vs.
	Yazan: SÇ
	Tarih: 20181213 
--->
<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
	<cffunction name="get_branches_fnc" access="public" returnType="query" output="no">
		<cfargument name="is_comp_branch" required="no" type="numeric" default="1"> <!--- işlem yapılan şirkete bakılsın mı? --->
		<cfargument name="is_pos_branch" required="no" type="numeric" default="1"> <!--- kullanıcının şube yetkilerine bakılsın mı? --->
		<cfargument name="is_branch_status" required="no" type="numeric" default="1">
		<cfargument name="modul" required="no" type="string" default="">
		<cfif len(arguments.modul) and arguments.modul eq 'hr' and not get_module_power_user(67)>
			<cfset arguments.is_pos_branch = 1>
		</cfif>
		<cfquery name="get_branches_" datasource="#DSN#">
			SELECT
				BRANCH.BRANCH_STATUS,
				BRANCH.HIERARCHY,
				BRANCH.HIERARCHY2,
				BRANCH.BRANCH_ID,
				BRANCH.BRANCH_NAME,
				BRANCH.COMPANY_ID,
				BRANCH.SSK_OFFICE,
				BRANCH.SSK_NO,
				OUR_COMPANY.COMP_ID,
				OUR_COMPANY.COMPANY_NAME,
				OUR_COMPANY.NICK_NAME
			FROM
				BRANCH
				INNER JOIN OUR_COMPANY ON BRANCH.COMPANY_ID = OUR_COMPANY.COMP_ID
			WHERE
				BRANCH.BRANCH_ID IS NOT NULL
				<cfif len(arguments.is_branch_status) and arguments.is_branch_status eq 1>
					AND BRANCH.BRANCH_STATUS = 1 
				</cfif>
				<cfif isDefined('session.ep.userid') and arguments.is_comp_branch eq 1>
					AND BRANCH.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> 
				<cfelseif isDefined('session.pda.our_company_id') and arguments.is_comp_branch eq 1>
					AND BRANCH.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pda.our_company_id#">                 
				</cfif>
				<cfif isDefined('session.ep.position_code') and arguments.is_pos_branch eq 1>
					AND BRANCH.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)
				</cfif>
				<cfif isDefined('session.ep.isBranchAuthorization') and session.ep.isBranchAuthorization>
					AND BRANCH.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(session.ep.user_location,2,'-')#">
				</cfif>
			ORDER BY
				OUR_COMPANY.NICK_NAME,
				BRANCH.BRANCH_NAME 
		</cfquery>
		<cfreturn get_branches_>
	</cffunction>
</cfcomponent>