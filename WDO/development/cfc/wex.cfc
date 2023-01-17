<cfcomponent>
    <cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name = "insert" returnType = "any">
        <cfargument name="is_active" type="numeric" default="1">
        <cfargument name="module" type="numeric" required="yes">
        <cfargument name="head" type="string" required="yes">
        <cfargument name="dictionary_id" type="numeric" required="yes">
        <cfargument name="version" type="string">
        <cfargument name="type" type="numeric" required="yes">
        <cfargument name="licence" type="numeric">
        <cfargument name="rest_name" type="string" required="yes">
        <cfargument name="time_plan_type" type="numeric" required="yes">
        <cfargument name="time_plan" type="string">
        <cfargument name="authentication" type="numeric" required="yes">
        <cfargument name="status" type="string" required="yes">
        <cfargument name="process_stage" type="numeric">
        <cfargument name="author_name" type="string" required="yes">
        <cfargument name="file_path" type="string" required="yes">
        <cfargument name="related_wo" type="string">
        <cfargument name="image" type="string" required="yes">
        <cfargument name="wex_detail" type="string">
        <cfargument name="source_wo" default="">
        <cfargument name="wex_file_id" default="">
        <cfargument name="is_dataservice" default="">
        <cfargument name="main_version" default="">
        <cfargument name="publishing_date" default="">
        <cfargument name="data_converter" type="string" default="">

        <cfset response = StructNew()>
        <cftry>
            <cfquery name="ADD_WRK_WEX" datasource="#DSN#" result="MAX_ID">
                INSERT INTO
                    WRK_WEX
                    (
                        IS_ACTIVE,
                        MODULE,
                        HEAD,
                        TYPE,
                        DICTIONARY_ID,
                        VERSION,
                        LICENCE,
                        REST_NAME,
                        TIME_PLAN_TYPE,
                        TIME_PLAN,
                        AUTHENTICATION,
                        STATUS,
                        STAGE,
                        AUTHOR,
                        FILE_PATH,
                        RELATED_WO,
                        IMAGE,
                        DETAIL,
                        RECORD_IP,
                        RECORD_EMP,
                        RECORD_DATE,
                        SOURCE_WO,
                        WEX_FILE_ID,
                        IS_DATASERVICE,
                        MAIN_VERSION,
                        PUBLISHING_DATE,
                        DATA_CONVERTER
                    )
                VALUES
                    (
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.is_active#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.module#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.head#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.type#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.dictionary_id#">,
                        <cfif isdefined("arguments.version") and len(arguments.version)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.version#"><cfelse>NULL</cfif>,
                        <cfif isdefined("arguments.licence") and len(arguments.licence)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.licence#"><cfelse>NULL</cfif>,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.rest_name#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.time_plan_type#">,
                        <cfif isdefined("arguments.time_plan") and len(arguments.time_plan)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.time_plan#"><cfelse>NULL</cfif>,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.authentication#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.status#">,
                        <cfif isdefined("arguments.process_stage") and len(arguments.process_stage)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.process_stage#"><cfelse>NULL</cfif>,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.author_name#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.file_path#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.related_wo#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.image#">,
                        <cfif isdefined("arguments.wex_detail") and len(arguments.wex_detail)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.wex_detail#"><cfelse>NULL</cfif>,
                        '#cgi.remote_addr#',
                        #session.ep.userid#,
                        #now()#,
                        <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.source_wo#">,
                        <cfif len(arguments.wex_file_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.wex_file_id#"><cfelse>NULL</cfif>,
                        <cfif isdefined("arguments.is_dataservice") and len(arguments.is_dataservice)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.is_dataservice#"><cfelse>0</cfif>,
                        <cfif isdefined("arguments.main_version") and len(arguments.main_version)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.main_version#"><cfelse>NULL</cfif>,
                        <cfif isdefined("arguments.publishing_date") and len(arguments.publishing_date)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.publishing_date#"><cfelse>NULL</cfif>,
                        <cfif isDefined("arguments.data_converter") and len(arguments.data_converter)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.data_converter#"><cfelse>NULL</cfif>
                    )
            </cfquery>

            <cfset response.status = true>
            <cfset response.message = "Kayıt işlemi başarıyla gerçekleşti!">
            <cfset response.result = MAX_ID>
            <cfcatch type = "any">
                <cfset response.status = false>
                <cfset response.message = "Kayıt işlemi sırasında bir hata oluştu!">
            </cfcatch>
        </cftry>
        <cfreturn response>
    </cffunction>

    <cffunction name = "select" returnType = "any">
        <cfargument name="wex_id" default="0">
        <cfargument name="keyword" type="string">
        <cfargument name="solution">
        <cfargument name="family">
        <cfargument name="module">
        <cfargument name="licence">
        <cfargument name="wex_type">

        <cfquery name = "GET_WRK_WEX" datasource = "#DSN#">
            SELECT
                WX.WEX_ID,
                WX.IS_ACTIVE,
                WX.MODULE,
                ISNULL(Replace(S1.ITEM_#UCASE(session.ep.language)#,'''',''),WX.HEAD) AS HEAD,
                ISNULL(Replace(S2.ITEM_#UCASE(session.ep.language)#,'''',''),WM.MODULE) AS MODULE,
                ISNULL(Replace(S3.ITEM_#UCASE(session.ep.language)#,'''',''),WF.FAMILY) AS FAMILY,
                ISNULL(Replace(S4.ITEM_#UCASE(session.ep.language)#,'''',''),WS.SOLUTION) AS SOLUTION,
                WM.MODULE_DICTIONARY_ID,
                WF.FAMILY_DICTIONARY_ID,
                WS.SOLUTION_DICTIONARY_ID,
                WX.DICTIONARY_ID,
                WM.MODULE_NO,
                WF.WRK_FAMILY_ID,
                WS.WRK_SOLUTION_ID,
                WX.VERSION,
                WX.TYPE,
                WX.LICENCE,
                WX.REST_NAME,
                WX.SOURCE_WO,
                WX.WEX_FILE_ID,
                WX.TIME_PLAN_TYPE,
                WX.TIME_PLAN,
                WX.AUTHENTICATION,
                WX.STATUS,
                WX.STAGE,
                WX.AUTHOR,
                WX.FILE_PATH,
                WX.RELATED_WO,
                WX.IMAGE,
                WX.DETAIL,
                WX.RECORD_EMP,
                WX.RECORD_DATE,
                WX.UPDATE_EMP,
                WX.UPDATE_DATE,
                WX.IS_DATASERVICE,
                WX.MAIN_VERSION,
                WX.PUBLISHING_DATE,
                WX.DATA_CONVERTER
            FROM
                WRK_WEX WX 
                JOIN SETUP_LANGUAGE_TR AS S1 ON WX.DICTIONARY_ID = S1.DICTIONARY_ID
                JOIN WRK_MODULE AS WM ON WX.MODULE = WM.MODULE_NO
                JOIN SETUP_LANGUAGE_TR AS S2 ON WM.MODULE_DICTIONARY_ID = S2.DICTIONARY_ID
                JOIN WRK_FAMILY AS WF ON WM.FAMILY_ID = WF.WRK_FAMILY_ID
                JOIN SETUP_LANGUAGE_TR AS S3 ON WF.FAMILY_DICTIONARY_ID = S3.DICTIONARY_ID
                JOIN WRK_SOLUTION AS WS ON WF.WRK_SOLUTION_ID = WS.WRK_SOLUTION_ID
                JOIN SETUP_LANGUAGE_TR AS S4 ON WS.SOLUTION_DICTIONARY_ID = S4.DICTIONARY_ID
            WHERE
                1 = 1
                <cfif arguments.wex_id neq 0>
                AND WX.WEX_ID = <cfqueryparam value = "#arguments.wex_id#" CFSQLType = "cf_sql_integer">
                </cfif>
                <cfif isdefined("arguments.solution") and len(arguments.solution)>
                AND WS.WRK_SOLUTION_ID = <cfqueryparam value = "#arguments.solution#" CFSQLType = "cf_sql_integer">
                </cfif>
                <cfif isdefined("arguments.family") and len(arguments.family)>
                AND WF.WRK_FAMILY_ID = <cfqueryparam value = "#arguments.family#" CFSQLType = "cf_sql_integer">
                </cfif>
                <cfif isdefined("arguments.module") and len(arguments.module)>
                AND WM.MODULE_NO = <cfqueryparam value = "#arguments.module#" CFSQLType = "cf_sql_integer">
                </cfif>
                <cfif isdefined("arguments.licence") and len(arguments.licence)>
                AND WX.LICENCE = <cfqueryparam value = "#arguments.licence#" CFSQLType = "cf_sql_integer">
                </cfif>
                <cfif isdefined("arguments.wex_type") and len(arguments.wex_type)>
                AND WX.TYPE = <cfqueryparam value = "#arguments.wex_type#" CFSQLType = "cf_sql_integer">
                </cfif>
        </cfquery>
        <cfreturn GET_WRK_WEX>

    </cffunction>

    <cffunction name = "update" returnType = "any">
        <cfargument name="wex_id" type="numeric" required="yes">
        <cfargument name="is_active" type="numeric" default="1">
        <cfargument name="module" type="numeric" required="yes">
        <cfargument name="head" type="string" required="yes">
        <cfargument name="dictionary_id" type="numeric" required="yes">
        <cfargument name="version" type="string">
        <cfargument name="type" type="numeric" required="yes">
        <cfargument name="licence" type="numeric">
        <cfargument name="rest_name" type="string" required="yes">
        <cfargument name="time_plan_type" type="numeric" required="yes">
        <cfargument name="time_plan" type="string">
        <cfargument name="authentication" type="numeric" required="yes">
        <cfargument name="status" type="string" required="yes">
        <cfargument name="process_stage" type="numeric">
        <cfargument name="author_name" type="string" required="yes">
        <cfargument name="file_path" type="string" required="yes">
        <cfargument name="related_wo" type="string">
        <cfargument name="image" type="string" required="yes">
        <cfargument name="wex_detail" type="string">
        <cfargument name="source_wo" default="">
        <cfargument name="wex_file_id" default="">
        <cfargument name="is_dataservice" default="">
        <cfargument name="main_version" default="">
        <cfargument name="publishing_date" default="">
        <cfargument name="data_converter" default="">
        <cfset response = StructNew()>
        <cftry>
            <cfquery name="UPD_WRK_WEX" datasource="#DSN#" result="MAX_ID">
                UPDATE
                    WRK_WEX
                SET
                    IS_ACTIVE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.is_active#">,
                    MODULE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.module#">,
                    HEAD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.head#">,
                    TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.type#">,
                    DICTIONARY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.dictionary_id#">,
                    <cfif isdefined("arguments.version") and len(arguments.version)> 
                    VERSION = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.version#">,
                    </cfif>
                    <cfif isdefined("arguments.licence") and len(arguments.licence)>
                    LICENCE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.licence#">,
                    </cfif>
                    REST_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.rest_name#">,
                    TIME_PLAN_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.time_plan_type#">,
                    <cfif isdefined("arguments.time_plan") and len(arguments.time_plan)>
                    TIME_PLAN = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.time_plan#">,
                    </cfif>
                    AUTHENTICATION = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.authentication#">,
                    STATUS = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.status#">,
                    <cfif isdefined("arguments.process_stage") and len(arguments.process_stage)>
                    STAGE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.process_stage#">,
                    </cfif>
                    AUTHOR = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.author_name#">,
                    FILE_PATH = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.file_path#">,
                    RELATED_WO = <cfif isdefined("arguments.related_wo") and len(arguments.related_wo)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.related_wo#"><cfelse>NULL</cfif>,
                    IMAGE = <cfif isdefined("arguments.image") and len(arguments.image)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.image#"><cfelse>NULL</cfif>,
                    DETAIL = <cfif len(arguments.wex_detail)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.wex_detail#"><cfelse>NULL</cfif>,
                    UPDATE_IP = '#cgi.remote_addr#',
                    UPDATE_EMP = #session.ep.userid#,
                    UPDATE_DATE = #now()#,
                    SOURCE_WO = <cfif len(arguments.source_wo)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.source_wo#"><cfelse>NULL</cfif>,
                    WEX_FILE_ID = <cfif len(arguments.wex_file_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.wex_file_id#"><cfelse>NULL</cfif>,
                    IS_DATASERVICE = <cfif isdefined("arguments.is_dataservice") and len(arguments.is_dataservice)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.is_dataservice#"><cfelse>0</cfif>,
                    MAIN_VERSION = <cfif isdefined("arguments.main_version") and len(arguments.main_version)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.main_version#"><cfelse>NULL</cfif>,
                    PUBLISHING_DATE = <cfif isdefined("arguments.publishing_date") and len(arguments.publishing_date)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.publishing_date#"><cfelse>NULL</cfif>,
                    DATA_CONVERTER = <cfif isdefined("arguments.data_converter") and len(arguments.data_converter)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.data_converter#"><cfelse>NULL</cfif>
                WHERE
                    WEX_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.wex_id#">
            </cfquery>

            <cfset response.status = true>
            <cfset response.message = "Güncelleme işlemi başarıyla gerçekleşti!">
            <cfset response.result = MAX_ID>

            <cfcatch type = "any">
                <cfset response.status = false>
                <cfset response.message = "Güncelleme işlemi sırasında bir hata oluştu!">
            </cfcatch>
        </cftry>
        <cfreturn response>
    </cffunction>

</cfcomponent>