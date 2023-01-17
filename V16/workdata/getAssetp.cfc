<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="getCompenentFunction">
		<cfquery name="get_assetp_" datasource="#dsn#">
			SELECT
				EMPLOYEE_POSITIONS.EMPLOYEE_ID,
				<cfif database_type is 'MSSQL'>
					EMPLOYEE_POSITIONS.EMPLOYEE_NAME + ' ' + EMPLOYEE_POSITIONS.EMPLOYEE_SURNAME AS FULL_NAME,	
					ZONE.ZONE_NAME +' / '+ DEPARTMENT.DEPARTMENT_HEAD +' / '+ BRANCH_NAME AS DEPT_NAME,	
				<cfelseif database_type is 'DB2'>
					EMPLOYEE_POSITIONS.EMPLOYEE_NAME || ' ' || EMPLOYEE_POSITIONS.EMPLOYEE_SURNAME AS FULL_NAME,
					ZONE.ZONE_NAME ||' / '|| DEPARTMENT.DEPARTMENT_HEAD ||' / '|| BRANCH_NAME AS DEPT_NAME,	
				</cfif>
				ASSET_P.ASSETP,
				ASSET_P.ASSETP_ID,
				ASSET_P.BRAND_TYPE_ID,
				ASSET_P_CAT.ASSETP_CAT
			FROM
				EMPLOYEE_POSITIONS,
				ASSET_P,
				ASSET_P_CAT,			
				DEPARTMENT,
				BRANCH,
				ZONE
			WHERE			
				ASSET_P.STATUS = 1 
				AND ASSET_P.POSITION_CODE = EMPLOYEE_POSITIONS.POSITION_CODE 
				AND ASSET_P.DEPARTMENT_ID2 = DEPARTMENT.DEPARTMENT_ID  
				AND BRANCH.BRANCH_ID = DEPARTMENT.BRANCH_ID 
				AND ASSET_P_CAT.ASSETP_CATID = ASSET_P.ASSETP_CATID
				AND ZONE.ZONE_ID = BRANCH.ZONE_ID
				AND BRANCH.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#) 
				<cfif isDefined("arguments.keyword") and len(arguments.keyword)>
					AND ASSET_P.ASSETP LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.keyword#%">
				</cfif>
			UNION ALL
			SELECT
				'' EMPLOYEE_ID,
				<cfif database_type is 'MSSQL'>
					''  AS FULL_NAME,	
					ZONE.ZONE_NAME +' / '+ DEPARTMENT.DEPARTMENT_HEAD +' / '+ BRANCH_NAME AS DEPT_NAME,	
				<cfelseif database_type is 'DB2'>
					''  AS FULL_NAME,
					ZONE.ZONE_NAME ||' / '|| DEPARTMENT.DEPARTMENT_HEAD ||' / '|| BRANCH_NAME AS DEPT_NAME,	
				</cfif>
				ASSET_P.ASSETP,
				ASSET_P.ASSETP_ID,
				ASSET_P.BRAND_TYPE_ID,
				ASSET_P_CAT.ASSETP_CAT
			FROM
				ASSET_P,
				ASSET_P_CAT,			
				DEPARTMENT,
				BRANCH,
				ZONE
			WHERE			
				ASSET_P.STATUS = 1 
				AND ASSET_P.POSITION_CODE IS NULL
				AND ASSET_P.DEPARTMENT_ID2 = DEPARTMENT.DEPARTMENT_ID  
				AND BRANCH.BRANCH_ID = DEPARTMENT.BRANCH_ID 
				AND ASSET_P_CAT.ASSETP_CATID = ASSET_P.ASSETP_CATID
				AND ZONE.ZONE_ID = BRANCH.ZONE_ID
				AND BRANCH.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#) 
				<cfif isDefined("arguments.keyword") and len(arguments.keyword)>
					AND ASSET_P.ASSETP LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.keyword#%">
				</cfif>
			ORDER BY
				ASSET_P.ASSETP
		</cfquery>	
        <cfreturn get_assetp_>
    </cffunction>
</cfcomponent>
