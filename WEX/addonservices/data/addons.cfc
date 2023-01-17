<cfcomponent>

    <cfset dsn = application.systemParam.systemParam().dsn>

    <cffunction name="get_addon">
        <cfargument name="product_id">

        <cfquery name="query_license" datasource="#dsn#">
            SELECT TOP 1 * FROM WRK_LICENSE WHERE PROD_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.product_id#'>
            <!--- product id sorgusu ve ekstraları --->
        </cfquery>
        <cfreturn query_license>
    </cffunction>

    <cffunction name="add_trial">
        <cfargument name="product_id">

        <cfquery name="query_add_trial" datasource="#dsn#">
            INSERT INTO WRK_LICENSE (TRIAL_PROD_ID, TRIAL_START) VALUES (
                <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.product_id#'>,
                #now()#
            )
        </cfquery>
    </cffunction>

    <cffunction name="add_prod">
        <cfargument name="product_id">

        <cfquery name="query_upd_trial" datasource="#dsn#">
            UPDATE WRK_LICENSE SET PROD_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.product_id#'> WHERE PROD_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#attributes.product_id#'>
        </cfquery>
    </cffunction>

</cfcomponent>