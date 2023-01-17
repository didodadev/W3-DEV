<cfcomponent displayname="" extends="WMO.functions">
    <cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="GET_MEASUREMENT_PARAMETERS" returntype="any" output="false">
        <cfargument  name="measurement_id" default="">
        <cfquery name="GET_MEASUREMENT_PARAMETERS" datasource="#dsn#">
            SELECT 
                MEASUREMENT_ID,
                #dsn#.Get_Dynamic_Language(MEASUREMENT_ID,'#session.ep.language#','MEASUREMENT_PARAMETERS','MEASUREMENT_NAME',NULL,NULL,MEASUREMENT_NAME) AS MEASUREMENT_NAME
            FROM 
                MEASUREMENT_PARAMETERS
            WHERE
                1 = 1
                <cfif len(arguments.measurement_id)>
                    AND MEASUREMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.measurement_id#">
                </cfif>
        </cfquery>
        <cfreturn GET_MEASUREMENT_PARAMETERS>
    </cffunction>
    <cffunction name="GET_MEASUREMENT_PARAMETERS_ROW" returntype="any" output="false">
        <cfargument  name="measurement_id" default="">
        <cfquery name="GET_MEASUREMENT_PARAMETERS_ROW" datasource="#dsn#">
            SELECT 
                * 
            FROM 
            MEASUREMENT_PARAMETERS_ROWS
            WHERE
                1 = 1
                <cfif len(arguments.measurement_id)>
                    AND MEASUREMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.measurement_id#">
                </cfif>
        </cfquery>
        <cfreturn GET_MEASUREMENT_PARAMETERS_ROW>
    </cffunction>
    <cffunction name="GET_MEASUREMENT_PARAMETER_ROW" returntype="any" output="false">
        <cfargument  name="measurement_id">
        <cfquery name="GET_MEASUREMENT_PARAMETER_ROW" datasource="#dsn#">
            SELECT * FROM MEASUREMENT_PARAMETERS_ROWS WHERE MEASUREMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.measurement_id#">
        </cfquery>
        <cfreturn GET_MEASUREMENT_PARAMETER_ROW>
    </cffunction>
    <cffunction name="STOCK_LOCATION_MEASUREMENT" returntype="any" output="false">
        <cfargument name="location_id" default="">
        <cfargument name="department_id" default="">
        <cfargument name = "measurement_id" default="">
        <cfargument name = "stock_location_id" default="">
        <cfquery name="STOCK_LOCATION_MEASUREMENT" datasource="#dsn#">
            SELECT 
                * 
            FROM 
                STOCK_LOCATION_MEASUREMENT 
            WHERE 
                1 = 1
                <cfif len(arguments.measurement_id)>
                    AND MEASUREMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.measurement_id#">
                </cfif>
                <cfif len(arguments.location_id)>
                    AND LOCATION_ID  = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.location_id#">
                </cfif>
                <cfif len(arguments.department_id)>
                    AND DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.department_id#">
                </cfif>
                <cfif len(arguments.stock_location_id)>
                    AND STOCK_LOCATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.stock_location_id#">
                </cfif>
        </cfquery>
        <cfreturn STOCK_LOCATION_MEASUREMENT>
    </cffunction>
</cfcomponent>