<cfcomponent>
    <cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="get_demand_list_fnc" returntype="query">
        <cfargument name="is_demand" default="">
        <cfargument name="id" default="">
        <cfquery name="GET_INTERNALDEMAND" datasource="#this.dsn#">
            SELECT 
                I.*,
                IR.PRO_MATERIAL_ID
            FROM 
                INTERNALDEMAND I,
                INTERNALDEMAND_ROW IR
            WHERE
                I.INTERNAL_ID = IR.I_ID
                <cfif len(id)>
                    AND INTERNAL_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#id#">
                </cfif>
                <cfif is_demand eq 1>
                    AND DEMAND_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
                <cfelse>
                    AND ISNULL(DEMAND_TYPE,0) = <cfqueryparam cfsqltype="cf_sql_integer" value="0">
                </cfif>
            ORDER BY
                IR.I_ROW_ID
        </cfquery>
        <cfreturn GET_INTERNALDEMAND>
    </cffunction>
    <cffunction name="GET_DEPARTMENT" returntype="query">
        <cfargument name="department_id" default="">
        <cfquery name="GET_DEPARTMENT" datasource="#dsn#">
            SELECT 
            DEPARTMENT_ID,
            DEPARTMENT_HEAD
            FROM 
                DEPARTMENT
            WHERE
                DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.department_id#">
        </cfquery>
        <cfreturn GET_DEPARTMENT>
    </cffunction>
</cfcomponent>
