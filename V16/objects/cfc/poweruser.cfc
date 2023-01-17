<!---Bu cfc yetkilendirme queryleri için oluşturuldu.ERU--->
<cfcomponent>
    <cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="GET_POS_ID" access="remote">
        <cfargument name="position_code" default="">
        <cfquery name="GET_POS_ID" datasource="#dsn#">
            SELECT
                POSITION_ID,
                EMPLOYEE_NAME + ' ' + EMPLOYEE_SURNAME AS 'EMPLOYEE_NAME'
            FROM
                EMPLOYEE_POSITIONS
            WHERE
                POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.position_code#">
        </cfquery>
        <cfreturn GET_POS_ID>
    </cffunction> 
</cfcomponent>