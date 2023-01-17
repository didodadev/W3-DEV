<cfcomponent>
    <cfset dsn = application.systemParam.systemParam().dsn />
    <cfset dsn_period = "#dsn#_#session.ep.period_year#_#session.ep.company_id#" />

    <cffunction name="set_ship_row" access="remote" returnformat="JSON">
        <cfargument name="ship_row_id" type="string">
        <cfargument name="serial_total" type="string">
        <cfargument name="serial_total_2" type="string">

        <cfset arrShip_row_id = listToArray( ship_row_id ) />
        <cfset arrSerial_total = listToArray( serial_total ) />
        <cfset arrSerial_total_2 = listToArray( serial_total_2 ) />

        <cftry>
            <cfloop array="#arrShip_row_id#" item="item" index="i">
                <cfquery name="set_ship_row" datasource="#dsn_period#">
                    UPDATE SHIP_ROW 
                    SET 
                        AMOUNT = <cfqueryparam cfsqltype="cf_sql_float" value="#arrSerial_total[i]#">,
                        AMOUNT2 = <cfqueryparam cfsqltype="cf_sql_float" value="#arrSerial_total_2[i]#">
                    WHERE SHIP_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#item#">
                </cfquery>
            </cfloop>
            <cfset response = { status: true }>
            
            <cfcatch type="any">
                <cfset response = { status: false }>
            </cfcatch>
        </cftry>

        <cfreturn replace(serializeJson(response), "//", "") />
    </cffunction>
</cfcomponent>