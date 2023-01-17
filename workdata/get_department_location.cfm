<!--- amac:gelen department_head parametresine gore DEPARTMENT_NAME,DEPARTMENT_ID,LOCATION_ID bilgisini getirmek
	  kullanim yeri:Depolar ve Lokasyonlar
	  yazan:ST
	  tarih:20081219 --->
<cffunction name="get_department_location" access="public" returnType="query" output="no">
	<cfargument name="department_head" required="yes" type="string">
		<cfquery name="GET_DEPARTMENT_LOCATION_" datasource="#DSN#">
            SELECT  
                D.DEPARTMENT_ID,
                B.BRANCH_ID,
                B.COMPANY_ID,
                B.BRANCH_NAME,			
                D.DEPARTMENT_HEAD,
                SL.COMMENT,
                SL.LOCATION_ID,
                <cfif database_type is 'MSSQL'>
                	D.DEPARTMENT_HEAD + ' - ' + SL.COMMENT AS DEPARTMENT_NAME
                <cfelseif database_type is 'DB2'>
                	D.DEPARTMENT_HEAD || ' - ' || SL.COMMENT AS DEPARTMENT_NAME
                </cfif>
       		FROM 
                DEPARTMENT D,
                BRANCH B,
                STOCKS_LOCATION SL
        	WHERE 
                D.IS_STORE <> 2 AND
                <cfif isDefined('session.ep.userid')>
                	B.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
                <cfelse>
                	B.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pda.our_company_id#"> AND                
                </cfif>
                B.BRANCH_ID = D.BRANCH_ID AND
                SL.DEPARTMENT_ID = D.DEPARTMENT_ID  AND 
                D.DEPARTMENT_STATUS = 1 AND
                SL.STATUS = 1 AND
                (
               	 	D.DEPARTMENT_HEAD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.department_head#%">  OR
                    SL.COMMENT LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.department_head#%">
                )
        	ORDER BY
                B.BRANCH_NAME
		</cfquery>
	<cfreturn get_department_location_>
</cffunction>
