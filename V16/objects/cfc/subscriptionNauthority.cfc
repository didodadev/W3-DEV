<cfcomponent>
    <cfset dsn = application.systemParam.systemParam().dsn>
    <cfset dsn3 = dsn & '_' & session.ep.company_id>
    
    <cffunction name="SelectAuthority" access="public">
         <cfquery name="GET_SUBSCRIPTION_AUTHORITY" datasource="#dsn#">
            SELECT
                ISNULL(OCI.IS_SUBSCRIPTION_AUTHORITY,0) AS IS_SUBSCRIPTION_AUTHORITY
            FROM
                OUR_COMPANY_INFO AS OCI
            WHERE
                OCI.COMP_ID = #session.ep.company_id#
        </cfquery>
        <cfreturn GET_SUBSCRIPTION_AUTHORITY>
    </cffunction>

    <cffunction name="SelectSubscription" access="public">
        <cfquery name="GET_SUBSCRIPTION_TYPE" datasource="#DSN3#">
            SELECT
                SST.SUBSCRIPTION_TYPE_ID,
                SST.SUBSCRIPTION_TYPE
            FROM
                SETUP_SUBSCRIPTION_TYPE AS SST
            <cfif GET_SUBSCRIPTION_AUTHORITY.IS_SUBSCRIPTION_AUTHORITY eq 1>
            WHERE
            EXISTS 
            (
                SELECT
                SPC.SUBSCRIPTION_TYPE_ID
                FROM        
                #dsn#.EMPLOYEE_POSITIONS AS EP,
                SUBSCRIPTION_GROUP_PERM SPC
                WHERE
                EP.POSITION_CODE = #session.ep.position_code# AND
                (
                    SPC.POSITION_CODE = EP.POSITION_CODE OR
                    SPC.POSITION_CAT = EP.POSITION_CAT_ID
                )
                    AND SST.SUBSCRIPTION_TYPE_ID = spc.SUBSCRIPTION_TYPE_ID
            )
            </cfif>
            ORDER BY
                SST.SUBSCRIPTION_TYPE
        </cfquery>
        <cfreturn GET_SUBSCRIPTION_TYPE>
    </cffunction>
</cfcomponent>