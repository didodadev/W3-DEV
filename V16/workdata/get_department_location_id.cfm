<!--- amac:gelen branch_id parametresine gore DEPARTMENT_NAME,DEPARTMENT_ID,LOCATION_ID bilgisini getirmek
	  kullanim yeri:Depolar ve Lokasyonlar
	  yazan:SÇ
	  tarih:20181123 --->
<cffunction name="get_department_location_id" access="public" returnType="query" output="no">
	<cfargument name="branch_id" required="yes" type="string">
		<cfquery name="GET_DEPARTMENT_LOCATION_" datasource="#DSN#">
            SELECT  
                D.DEPARTMENT_ID,
                B.BRANCH_ID,
                B.COMPANY_ID,
                B.BRANCH_NAME,			
                D.DEPARTMENT_HEAD,
                SL.COMMENT,
                SL.LOCATION_ID,
                <cfif isdefined("database_type") and database_type is 'MSSQL'>
                	D.DEPARTMENT_HEAD + ' - ' + SL.COMMENT AS DEPARTMENT_NAME
                <cfelseif isdefined("database_type") and database_type is 'DB2'>
                	D.DEPARTMENT_HEAD || ' - ' || SL.COMMENT AS DEPARTMENT_NAME
                <cfelse>
                       D.DEPARTMENT_HEAD + ' - ' + SL.COMMENT AS DEPARTMENT_NAME
                </cfif>
       		FROM 
                DEPARTMENT D,
                BRANCH B,
                STOCKS_LOCATION SL
        	WHERE 
                D.IS_STORE <> 2 AND
                <cfif isDefined('session.ep.userid')>
                	B.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
                <cfelseif isdefined("session.pp")>
                        B.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.our_company_id#"> AND   
                <cfelseif isdefined("session.cp")>
                        B.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.cp.our_company_id#"> AND  
                 <cfelseif isdefined("session.ww")>
                        B.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.our_company_id#"> AND 
                <cfelse>
                	B.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pda.our_company_id#"> AND                
                </cfif>
                B.BRANCH_ID = D.BRANCH_ID AND
                SL.DEPARTMENT_ID = D.DEPARTMENT_ID  AND 
                D.DEPARTMENT_STATUS = 1 AND
                SL.STATUS = 1 
				<cfif len(arguments.branch_id)>
					AND D.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.branch_id#">
				</cfif>
        	ORDER BY
                B.BRANCH_NAME
		</cfquery>
	<cfreturn get_department_location_>
</cffunction>