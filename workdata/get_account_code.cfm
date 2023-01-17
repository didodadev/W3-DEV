<!--- 
	amac            : gelen account code parametresine göre ACCOUNT_CODE,ACCOUNT_NAME bilgisini getirmek
	parametre adi   : account_code
	kullanim        : get_account_code('100.01.') 
	OZDEN20070910
 --->
<cffunction name="get_account_code" access="public" returnType="query" output="yes">
	<cfargument name="acc_plan_code_" required="yes" type="string">
	<cfargument name="maxrows" required="yes" type="string" default="">
	<cfargument name="sub_acc_" type="numeric" default="0">
	<cfargument name="is_acc_code_exist" required="no" default="0">		
    <cfargument name="new_dsn" required="no" default="#dsn2#">
	<cfset arguments.maxrows = 100>
	<cfif len(arguments.maxrows)>
		<cfquery name="GET_ACC_PLAN_CODE_" datasource="#new_dsn#" maxrows="#arguments.maxrows#">
			SELECT
            	ACCOUNT_ID,
				ACCOUNT_CODE,
				ACCOUNT_NAME,
				IFRS_CODE,
				ACCOUNT_CODE2,
                <cfif database_type is 'MSSQL'>
               	   ACCOUNT_CODE + ' - ' + ACCOUNT_NAME AS CODE_NAME
                <cfelseif database_type is 'DB2'>
     		       ACCOUNT_CODE|| ' -  ' || ACCOUNT_NAME AS CODE_NAME
            	</cfif>
			FROM 
				ACCOUNT_PLAN 
			WHERE
				(
				<cfif arguments.is_acc_code_exist eq 0>
					ACCOUNT_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.acc_plan_code_#%">
                    <!---Muhasebe Kodu alanının sadece Hesap koduna göre arama yapılması için kapatılmıştır.---> 
					<!---OR ACCOUNT_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.acc_plan_code_#%">--->
				<cfelse>
					ACCOUNT_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.acc_plan_code_#"> 
                    <!---Muhasebe Kodu alanının sadece Hesap koduna göre arama yapılması için kapatılmıştır.---> 
					<!---OR ACCOUNT_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.acc_plan_code_#">--->
				</cfif>
				)
				<cfif arguments.sub_acc_ eq 0>
					AND SUB_ACCOUNT = <cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.sub_acc_#">
				</cfif>
			ORDER BY
				ACCOUNT_CODE
		</cfquery>
	<cfelse>	
		<cfquery name="GET_ACC_PLAN_CODE_" datasource="#new_dsn#">
			SELECT
            	ACCOUNT_ID,
				ACCOUNT_CODE,
				ACCOUNT_NAME,
				IFRS_CODE,
				ACCOUNT_CODE2,
				<cfif database_type is 'MSSQL'>
               	   ACCOUNT_CODE + ' - ' + ACCOUNT_NAME AS CODE_NAME
                <cfelseif database_type is 'DB2'>
     		       ACCOUNT_CODE || ' -  ' || ACCOUNT_NAME AS CODE_NAME
            	</cfif>
			FROM 
				ACCOUNT_PLAN 
			WHERE
				<!---(---> ACCOUNT_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.acc_plan_code_#%">
				<!---Muhasebe Kodu alanının sadece Hesap koduna göre arama yapılması için kapatılmıştır.---> 
				<!---OR ACCOUNT_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.acc_plan_code_#%">)--->
				<cfif arguments.sub_acc_ eq 0>
				AND SUB_ACCOUNT = <cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.sub_acc_#">
				</cfif>
			ORDER BY
				ACCOUNT_CODE
		</cfquery>
	</cfif>
	<cfreturn GET_ACC_PLAN_CODE_>
</cffunction>
