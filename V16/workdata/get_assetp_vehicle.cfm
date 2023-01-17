<cffunction name="get_assetp_vehicle" access="public" returnType="query" output="no">
	<cfargument name="assetp_name" required="yes" type="string">
	<cfquery name="get_assetp_vehicle" datasource="#dsn#">
		SELECT
			ASSET_P.ASSETP,
			ASSET_P.ASSETP_ID	
		FROM
			EMPLOYEE_POSITIONS,
			ASSET_P,
			SETUP_BRAND_TYPE,
			SETUP_BRAND,
			DEPARTMENT,
			BRANCH
		WHERE			
			BRANCH.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">) AND
			ASSET_P.ASSETP_CATID IN (SELECT ASSETP_CATID FROM ASSET_P_CAT WHERE MOTORIZED_VEHICLE = 1) AND
			ASSET_P.DEPARTMENT_ID2 = DEPARTMENT.DEPARTMENT_ID AND
			DEPARTMENT.BRANCH_ID = BRANCH.BRANCH_ID AND
			ASSET_P.BRAND_TYPE_ID = SETUP_BRAND_TYPE.BRAND_TYPE_ID AND
			SETUP_BRAND_TYPE.BRAND_ID = SETUP_BRAND.BRAND_ID AND
			ASSET_P.POSITION_CODE = EMPLOYEE_POSITIONS.POSITION_CODE AND
			EMPLOYEE_POSITIONS.EMPLOYEE_ID > 0
			AND ASSET_P.STATUS = 1 AND 
			ASSET_P.ASSETP LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.assetp_name#%">
		ORDER BY
			ASSET_P.ASSETP
	</cfquery>
	<cfreturn get_assetp_vehicle>
</cffunction> 
