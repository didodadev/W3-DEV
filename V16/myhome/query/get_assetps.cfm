<cfquery name="GET_ASSETPS" datasource="#DSN#">
    SELECT 
        ASSET_P.ASSETP_ID,
        ASSET_P.ASSETP,
        ASSET_P.ASSETP_CATID,
        ASSET_P.UPDATE_DATE,
        ASSET_P.POSITION_CODE,
        ASSET_P.POSITION_CODE2,
        ASSET_P.ASSETP_STATUS,
        ASSET_P_CAT.ASSETP_CAT,
        ASSET_P_CAT.IT_ASSET,
        ASSET_P.INVENTORY_NUMBER,
        ASSET_P_SPACE.SPACE_NAME,
        ASSET_P_CAT.MOTORIZED_VEHICLE,
        ZONE.ZONE_NAME,
        BRANCH.BRANCH_NAME,
        DEPARTMENT.DEPARTMENT_HEAD,
        EMPLOYEES.EMPLOYEE_ID,
        EMPLOYEES.EMPLOYEE_NAME,
        EMPLOYEES.EMPLOYEE_SURNAME
    FROM 
        ASSET_P_CAT,
        ZONE,
        BRANCH,
        DEPARTMENT,
        EMPLOYEES,
        ASSET_P
        LEFT JOIN ASSET_P_SPACE ON ASSET_P_SPACE.ASSET_P_SPACE_ID = ASSET_P.ASSET_P_SPACE_ID
    WHERE
        ASSET_P.STATUS = 1 AND
        ASSET_P.ASSETP_CATID = ASSET_P_CAT.ASSETP_CATID AND
        ASSET_P.DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID AND
        DEPARTMENT.BRANCH_ID = BRANCH.BRANCH_ID AND
        BRANCH.ZONE_ID = ZONE.ZONE_ID AND
        ASSET_P.EMPLOYEE_ID = EMPLOYEES.EMPLOYEE_ID AND
        ASSET_P.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
        <cfif len(attributes.keyword)>
            AND 
            (
                ASSET_P.ASSETP LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR 
                ASSET_P.INVENTORY_NUMBER = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#">
            )
        </cfif>
        <cfif len(attributes.asset_cat)>AND ASSET_P.ASSETP_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.asset_cat#"></cfif>
    ORDER BY 
        ASSET_P.ASSETP 
</cfquery>
