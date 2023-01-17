<cffunction name="get_assept" access="public" returnType="query" output="no">
	<cfargument name="assept_name" required="yes" type="string">
		<cfquery name="GET_ASSEPT_" datasource="#DSN#">
              SELECT
                    EMPLOYEE_POSITIONS.EMPLOYEE_ID,
                    <cfif database_type is 'MSSQL'>
                    EMPLOYEE_POSITIONS.EMPLOYEE_NAME + ' ' + EMPLOYEE_POSITIONS.EMPLOYEE_SURNAME AS FULL_NAME,	
                    <cfelseif database_type is 'DB2'>
                    EMPLOYEE_POSITIONS.EMPLOYEE_NAME || ' ' || EMPLOYEE_POSITIONS.EMPLOYEE_SURNAME AS FULL_NAME,
                    </cfif>
                    ASSET_P.ASSETP,
                    ASSET_P.ASSETP_ID,			
                    ASSET_P.DEPARTMENT_ID,
                    ASSET_P.DEPARTMENT_ID2,
                    ASSET_P.BRAND_TYPE_ID,
                    ASSET_P.MAKE_YEAR,
                    ASSET_P.FUEL_TYPE,
                    ASSET_P.BRAND_TYPE_ID
            FROM
                    EMPLOYEE_POSITIONS,
                    ASSET_P
            WHERE			
                    ASSET_P.ASSETP_CATID IN (4,3,1,5,2,12) AND
                    ASSET_P.POSITION_CODE = EMPLOYEE_POSITIONS.POSITION_CODE AND
                    EMPLOYEE_POSITIONS.EMPLOYEE_ID > 0 AND
                    ASSET_P.ASSETP LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.assept_name#%">
            ORDER BY
                    ASSET_P.ASSETP
		</cfquery>	
	<cfreturn get_assept_>
</cffunction>
