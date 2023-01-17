<cfcomponent>
	<cffunction name="get_employe_asset" access="public" returntype="query">
        <cfargument name="employee_id" type="numeric">
        <cfargument name="is_view_myhome">
        <cfquery name="get_asset_row" datasource="#this.dsn#"> 
            SELECT 
                AC.ASSET_CAT,
                AR.ASSET_DATE,
                AR.ASSET_FINISH_DATE,
                AR.ASSET_NO,
                AR.ASSET_NAME,
                AR.ASSET_FILE,
                AR.ASSET_NO2,
                (SELECT ASSET_CAT FROM SETUP_EMPLOYMENT_ASSET_CAT WHERE ASSET_CAT_ID = AC.UPPER_ASSET_CAT_ID) AS UPPER_ASSET_CAT
            FROM 
                EMPLOYEE_EMPLOYMENT_ROWS AR INNER JOIN SETUP_EMPLOYMENT_ASSET_CAT AC 
                ON AR.ASSET_CAT_ID = AC.ASSET_CAT_ID
            WHERE 
                AR.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.employee_id#">
                <cfif isdefined('arguments.is_view_myhome') and len(arguments.is_view_myhome)>
                    AND AC.IS_VIEW_MYHOME = <cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.is_view_myhome#">       
				</cfif>
            ORDER BY
				(SELECT ASSET_CAT FROM SETUP_EMPLOYMENT_ASSET_CAT WHERE ASSET_CAT_ID = AC.UPPER_ASSET_CAT_ID),            
                AC.ASSET_CAT,
                AR.ASSET_NAME              
         </cfquery>
        <cfreturn get_asset_row>
    </cffunction>
    <cffunction name="get_employee_personal_certificate" access="public" returntype="any">
        <cfargument name="employee_id" default="">
        <cfquery name="get_emp_driverlicence_rows" datasource="#this.dsn#">
            SELECT
                EDR.EMPLOYEE_ID, 
                EDR.EMPLOYEE_ID, 
                EDR.LICENCECAT_ID, 
                EDR.LICENCE_START_DATE, 
                EDR.LICENCE_FINISH_DATE, 
                EDR.LICENCE_NO,
                EDR.LICENCE_FILE,
                EDR.LICENCE_STAGE,
                SD.LICENCECAT
            FROM
                EMPLOYEE_DRIVERLICENCE_ROWS EDR
                INNER JOIN SETUP_DRIVERLICENCE SD ON SD.LICENCECAT_ID = EDR.LICENCECAT_ID
            WHERE
                EMPLOYEE_ID = #arguments.employee_id#
        </cfquery>
        <cfreturn get_emp_driverlicence_rows>
    </cffunction>
</cfcomponent>
