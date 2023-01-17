<!--- 
Author : Sevim Çelik
Date   : 20/09/2019
Description : Kurumsal ve Bireysel Müşteri Kategorileri kullanıcının yetkisine ve ilgili şirkete göre getirilir.
--->
<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="get_comp_category_fnc">
        <cfargument name="our_company_id" default="#session.ep.company_id#">
        <cfargument name="employee_id" default="#session.ep.userid#">
		<cfquery name="get_comp_category" datasource="#dsn#">
			SELECT DISTINCT	
				COMPANYCAT_ID CATEGORY_ID,
				COMPANYCAT CATEGORY_NAME
			FROM
				GET_MY_COMPANYCAT
			WHERE
				EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.employee_id#"> 
			<cfif len(arguments.our_company_id)>
				AND OUR_COMPANY_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.our_company_id#" list="yes">)
			</cfif>
			ORDER BY
				CATEGORY_NAME
		</cfquery>
        <cfreturn get_comp_category>
    </cffunction>
	<cffunction name="get_cons_category_fnc">
        <cfargument name="our_company_id" default="#session.ep.company_id#">
        <cfargument name="employee_id" default="#session.ep.userid#">
		<cfquery name="get_cons_category" datasource="#dsn#">			
			SELECT DISTINCT	
				CONSCAT_ID CATEGORY_ID,
				CONSCAT CATEGORY_NAME
			FROM
				GET_MY_CONSUMERCAT
			WHERE
				EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.employee_id#"> 
				<cfif len(arguments.our_company_id)>
					AND OUR_COMPANY_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.our_company_id#" list="yes">)
				</cfif>
			ORDER BY
				CATEGORY_NAME
		</cfquery>
        <cfreturn get_cons_category>
    </cffunction>
</cfcomponent>