<cfcomponent extends="cfc.queryJSONConverter">
	<cfset dsn = application.systemParam.systemParam().dsn>

    <cffunction name="getData" access="public" returntype="query">
        <cfargument name="data_import_id" default="">
        <cfargument name="keyword" default="">
        <cfargument name="type" default="">
        <cfargument name="import_wo" default="">
        <cfargument name="fuseaction" default="">
        <cfquery name="getData" datasource="#dsn#">
            SELECT
                *
            FROM
                WRK_DATA_IMPORT_LIBRARY
            WHERE
                1 = 1
                <cfif len(arguments.data_import_id)>
                    AND DATA_IMPORT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.data_import_id#">
                </cfif>
                <cfif len(arguments.keyword)>
                    AND NAME LIKE <cfqueryparam cfsqltype="cf_sql_nvarchar" value="%#arguments.keyword#%">
                </cfif>
                <cfif len(arguments.type)>
                    AND TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.type#">
                </cfif>
                <cfif len(arguments.import_wo)>
                    AND IMPORT_WO LIKE <cfqueryparam cfsqltype="cf_sql_nvarchar" value="%#arguments.import_wo#%">
                </cfif>
                <cfif len(arguments.fuseaction)>
                    AND IMPORT_WO = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.fuseaction#">
                </cfif>
        </cfquery>
        <cfreturn getData>
    </cffunction>

    <cffunction name="addData" access="public" returntype="any">
        <cfargument name="data_import_name" default="">
        <cfargument name="type" default="">
        <cfargument name="import_wo" default="">
        <cfargument name="author" default="">
        <cfargument name="file_path" default="">
        <cfargument name="best_practice" default="">
        <cfargument name="is_comp" default="">
        <cfargument name="is_period" default="">

        <cfquery name="addData" datasource="#dsn#" result="MaxID">
            INSERT INTO
                WRK_DATA_IMPORT_LIBRARY(
                    NAME,
                    TYPE,
                    IMPORT_WO,
                    AUTHOR,
                    FILE_PATH,
                    BEST_PRACTICE,
                    IS_COMP,
                    IS_PERIOD,
                    RECORD_EMP,
                    RECORD_DATE,
                    RECORD_IP
                )
                VALUES(
                    <cfif len(arguments.data_import_name)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.data_import_name#"><cfelse>NULL</cfif>,
                    <cfif len(arguments.type)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.type#"><cfelse>NULL</cfif>,
                    <cfif len(arguments.import_wo)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.import_wo#"><cfelse>NULL</cfif>,
                    <cfif len(arguments.author)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.author#"><cfelse>NULL</cfif>,
                    <cfif len(arguments.file_path)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.file_path#"><cfelse>NULL</cfif>,
                    <cfif len(arguments.best_practice)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.best_practice#"><cfelse>NULL</cfif>,
                    <cfif len(arguments.is_comp)><cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.is_comp#"><cfelse>NULL</cfif>,
                    <cfif len(arguments.is_period)><cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.is_period#"><cfelse>NULL</cfif>,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                    <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                    <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#cgi.REMOTE_ADDR#">
                )
        </cfquery>

        <cfreturn MaxID>
    </cffunction>

    <cffunction name="updData" access="public" returntype="any">
        <cfargument name="data_import_id" default="">
        <cfargument name="data_import_name" default="">
        <cfargument name="type" default="">
        <cfargument name="import_wo" default="">
        <cfargument name="author" default="">
        <cfargument name="file_path" default="">
        <cfargument name="best_practice" default="">
        <cfargument name="is_comp" default="">
        <cfargument name="is_period" default="">

        <cfquery name="updData" datasource="#dsn#">
            UPDATE
                WRK_DATA_IMPORT_LIBRARY
            SET
                NAME = <cfif len(arguments.data_import_name)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.data_import_name#"><cfelse>NULL</cfif>,
                TYPE = <cfif len(arguments.type)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.type#"><cfelse>NULL</cfif>,
                IMPORT_WO = <cfif len(arguments.import_wo)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.import_wo#"><cfelse>NULL</cfif>,
                AUTHOR = <cfif len(arguments.author)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.author#"><cfelse>NULL</cfif>,
                FILE_PATH = <cfif len(arguments.file_path)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.file_path#"><cfelse>NULL</cfif>,
                BEST_PRACTICE = <cfif len(arguments.best_practice)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.best_practice#"><cfelse>NULL</cfif>,
                IS_COMP = <cfif len(arguments.is_comp)><cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.is_comp#"><cfelse>NULL</cfif>,
                IS_PERIOD = <cfif len(arguments.is_period)><cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.is_period#"><cfelse>NULL</cfif>,
                UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#cgi.REMOTE_ADDR#">
            WHERE
                DATA_IMPORT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.data_import_id#">
        </cfquery>
    </cffunction>

    <cffunction name="delData" access="public" returntype="any">
        <cfargument name="data_import_id" default="">

        <cfquery name="delData" datasource="#dsn#">
            DELETE FROM
                WRK_DATA_IMPORT_LIBRARY
            WHERE
                DATA_IMPORT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.data_import_id#">
        </cfquery>
    </cffunction>

    <cffunction name="getDBCompanies" access="remote" returnformat="JSON">
        <cfargument name="data_source_id" default="">
        <cfquery name="getDsnDetails" datasource="#dsn#">
            SELECT
                DATA_SOURCE_NAME
            FROM
                WRK_DATA_SOURCE
            WHERE
                DATA_SOURCE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.data_source_id#">
        </cfquery>
        <cfquery name="getDBCompanies" datasource="#getDsnDetails.DATA_SOURCE_NAME#">
            SELECT
                NR,
                NAME,
                TITLE
            FROM
                L_CAPIFIRM
        </cfquery>
        <cfif getDBCompanies.recordcount><cfreturn Replace(SerializeJson(this.returnData( Replace( SerializeJson( getDBCompanies ), "//", "" ))), "//", "") /><cfelse>[]</cfif>
    </cffunction>

    <cffunction name="getDBPeriods" access="remote" returnformat="JSON">
        <cfargument name="data_source_id" default="">
        <cfargument name="comp_id" default="">
        <cfquery name="getDsnDetails" datasource="#dsn#">
            SELECT
                DATA_SOURCE_NAME
            FROM
                WRK_DATA_SOURCE
            WHERE
                DATA_SOURCE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.data_source_id#">
        </cfquery>
        <cfquery name="getDBPeriods" datasource="#getDsnDetails.DATA_SOURCE_NAME#">
            SELECT
                NR,
                CONVERT(varchar, BEGDATE, 103) AS BEGDATE,
                CONVERT(varchar, ENDDATE, 103) AS ENDDATE
            FROM
                L_CAPIPERIOD
            WHERE
                FIRMNR = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.comp_id#">
        </cfquery>
        <cfif getDBPeriods.recordcount><cfreturn Replace(SerializeJson(this.returnData( Replace( SerializeJson( getDBPeriods ), "//", "" ))), "//", "") /><cfelse>[]</cfif>
    </cffunction>

</cfcomponent>