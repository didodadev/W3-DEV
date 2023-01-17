<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>

    <cffunction name="getDataSource" access="public" returntype="query">
        <cfargument name="data_source_id" default="">
        <cfargument name="keyword" default="">
        <cfargument name="type" default="">
        <cfquery name="getDataSource" datasource="#dsn#">
            SELECT
                *
            FROM
                WRK_DATA_SOURCE
            WHERE
                1 = 1
                <cfif len(arguments.data_source_id)>
                    AND DATA_SOURCE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.data_source_id#">
                </cfif>
                <cfif len(arguments.keyword)>
                    AND DATA_SOURCE_NAME = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.keyword#">
                </cfif>
                <cfif len(arguments.type)>
                    AND TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.type#">
                </cfif>
        </cfquery>
        <cfreturn getDataSource>
    </cffunction>

    <cffunction name="addDataSource" access="public" returntype="any">
        <cfargument name="data_source_name" default="">
        <cfargument name="type" default="">
        <cfargument name="driver" default="">
        <cfargument name="host_ip" default="">
        <cfargument name="port" default="">
        <cfargument name="username" default="">
        <cfargument name="password" default="">
        <cfargument name="details" default="">
        <cfargument name="cf_password" default="">

        <cfquery name="addDataSource" datasource="#dsn#" result="MaxID">
            INSERT INTO
                WRK_DATA_SOURCE(
                    DATA_SOURCE_NAME,
                    TYPE,
                    DRIVER,
                    IP,
                    PORT,
                    USERNAME,
                    PASSWORD,
                    DETAILS,
                    RECORD_EMP,
                    RECORD_DATE,
                    RECORD_IP,
                    CF_PASSWORD
                )
                VALUES(
                    <cfif len(arguments.data_source_name)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.data_source_name#"><cfelse>NULL</cfif>,
                    <cfif len(arguments.type)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.type#"><cfelse>NULL</cfif>,
                    <cfif len(arguments.driver)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.driver#"><cfelse>NULL</cfif>,
                    <cfif len(arguments.host_ip)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.host_ip#"><cfelse>NULL</cfif>,
                    <cfif len(arguments.port)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.port#"><cfelse>NULL</cfif>,
                    <cfif len(arguments.username)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.username#"><cfelse>NULL</cfif>,
                    <cfif len(arguments.password)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.password#"><cfelse>NULL</cfif>,
                    <cfif len(arguments.details)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.details#"><cfelse>NULL</cfif>,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                    <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                    <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#cgi.REMOTE_ADDR#">,
                    <cfif len(arguments.cf_password)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.cf_password#"><cfelse>NULL</cfif>
                )
        </cfquery>

        <cfreturn MaxID>
    </cffunction>

    <cffunction name="updDataSource" access="public" returntype="any">
        <cfargument name="data_source_id" default="">
        <cfargument name="data_source_name" default="">
        <cfargument name="type" default="">
        <cfargument name="driver" default="">
        <cfargument name="host_ip" default="">
        <cfargument name="port" default="">
        <cfargument name="username" default="">
        <cfargument name="password" default="">
        <cfargument name="details" default="">
        <cfargument name="cf_password" default="">

        <cfquery name="addDataSource" datasource="#dsn#">
            UPDATE
                WRK_DATA_SOURCE
            SET
                DATA_SOURCE_NAME = <cfif len(arguments.data_source_name)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.data_source_name#"><cfelse>NULL</cfif>,
                TYPE = <cfif len(arguments.type)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.type#"><cfelse>NULL</cfif>,
                DRIVER = <cfif len(arguments.driver)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.driver#"><cfelse>NULL</cfif>,
                IP = <cfif len(arguments.host_ip)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.host_ip#"><cfelse>NULL</cfif>,
                PORT = <cfif len(arguments.port)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.port#"><cfelse>NULL</cfif>,
                USERNAME = <cfif len(arguments.username)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.username#"><cfelse>NULL</cfif>,
                PASSWORD = <cfif len(arguments.password)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.password#"><cfelse>NULL</cfif>,
                DETAILS = <cfif len(arguments.details)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.details#"><cfelse>NULL</cfif>,
                UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#cgi.REMOTE_ADDR#">,
                CF_PASSWORD = <cfif len(arguments.cf_password)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.cf_password#"><cfelse>NULL</cfif>
            WHERE
                DATA_SOURCE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.data_source_id#">
        </cfquery>
    </cffunction>

    <cffunction name="delDataSource" access="public" returntype="any">
        <cfargument name="data_source_id" default="">

        <cfquery name="delDataSource" datasource="#dsn#">
            DELETE FROM
                WRK_DATA_SOURCE
            WHERE
                DATA_SOURCE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.data_source_id#">
        </cfquery>
    </cffunction>

    <cffunction name="getLogoCompDetails" access="public" returntype="query">
        <cfargument name="dsn_name" default="">
        <cfquery name="getLogoCompDetails" datasource="#dsn_name#">
            SELECT
                *
            FROM
                L_CAPIFIRM
        </cfquery>
        <cfreturn getLogoCompDetails>
    </cffunction>

    <cffunction name="getLogoPeriodDetails" access="public" returntype="query">
        <cfargument name="dsn_name" default="">
        <cfquery name="getLogoPeriodDetails" datasource="#dsn_name#">
            SELECT
                PERIOD.*,
                COMP.TITLE COMP_FULLNAME
            FROM
                L_CAPIPERIOD PERIOD
                LEFT JOIN L_CAPIFIRM COMP ON COMP.NR = PERIOD.FIRMNR
        </cfquery>
        <cfreturn getLogoPeriodDetails>
    </cffunction>

</cfcomponent>