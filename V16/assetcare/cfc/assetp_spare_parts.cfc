<cfcomponent>
    <cfset dsn = application.systemParam.systemParam().dsn />
    <cfset dsn3 = '#dsn#_#session.ep.company_id#'> 
    <cfset request.self = application.systemParam.systemParam().request.self />
    <cffunction  name="add_parts"  access="remote" returntype="any">
        <cfset attributes = arguments>
            <cfquery name="add_parts" datasource="#dsn#">
                INSERT 	INTO
                ASSET_P_PARTS
                (
                    ASSET_P_ID,
                    PRODUCT_ID,
                    STOCK_ID,
                    CHANGE_PERIOD,
                    CHANGE_AMOUNT,
                    SPECT_ID,
                    RISK_POINT,
                    QUANTIY,
                    PRODUCT_UNIT_ID,
                    DETAIL,
                    RECORD_DATE,
                    RECORD_IP,
                    RECORD_EMP
                ) 
                VALUES
                (
                    <cfif isdefined("arguments.asset_p_id") and len(arguments.asset_p_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.asset_p_id#"><cfelse>NULL</cfif>,
                    <cfif isdefined("arguments.product_id") and len(arguments.product_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.product_id#"><cfelse>NULL</cfif>,
                    <cfif isdefined("arguments.add_stock_id") and len(arguments.add_stock_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.add_stock_id#"><cfelse>NULL</cfif>,
                    <cfif isdefined("arguments.change_period") and len(arguments.change_period)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.change_period#"><cfelse>NULL</cfif>,
                    <cfif isdefined("arguments.change_amount") and len(arguments.change_amount)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.change_amount#"><cfelse>NULL</cfif>,
                    <cfif isdefined("arguments.spect_main_id") and len(arguments.spect_main_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.spect_main_id#"><cfelse>NULL</cfif>,
                    <cfif isdefined("arguments.risk_point") and len(arguments.risk_point)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.risk_point#"><cfelse>NULL</cfif>,
                    <cfif isdefined("arguments.quantity") and len(arguments.quantity)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.quantity#"><cfelse>NULL</cfif>,
                    <cfif isdefined("arguments.unit_id") and len(arguments.unit_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.unit_id#"><cfelse>NULL</cfif>,
                    <cfif isdefined("arguments.detail") and len(arguments.detail)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.detail#"><cfelse>NULL</cfif>,
                    <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
                )
            </cfquery>
            <script>
                closeBoxDraggable('<cfoutput>#arguments.modal_id#</cfoutput>');
                jQuery('#upd_spare .catalyst-refresh' ).click();
            </script>
    </cffunction>
    
    <cffunction name="list_parts" access="public" returntype="query">
        <cfset attributes = arguments>
        <cfquery name="list_parts"  datasource="#DSN#">
            SELECT
                AP.ASSET_P_PARTS_ID,
                AP.ASSET_P_ID,
                AP.PRODUCT_ID,
                AP.STOCK_ID,
                AP.CHANGE_PERIOD,
                AP.CHANGE_AMOUNT,
                AP.SPECT_ID,
                AP.RISK_POINT,
                AP.QUANTIY,
                AP.PRODUCT_UNIT_ID,
                AP.DETAIL,
                S.STOCK_CODE,
                PU.MAIN_UNIT,
                P.PRODUCT_NAME,
                SM.SPECT_MAIN_NAME
            FROM
            ASSET_P_PARTS AP
            LEFT JOIN #dsn3#.STOCKS S ON S.STOCK_ID= AP.STOCK_ID
            LEFT JOIN #dsn3#.PRODUCT_UNIT PU ON PU.PRODUCT_UNIT_ID	= AP.PRODUCT_UNIT_ID
            LEFT JOIN #dsn3#.PRODUCT P ON P.PRODUCT_ID= AP.PRODUCT_ID
            LEFT JOIN #dsn3#.SPECT_MAIN SM ON SM.SPECT_MAIN_ID= AP.SPECT_ID
            WHERE ASSET_P_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.ASSET_P_ID#">
        </cfquery>
        <cfreturn list_parts>
    </cffunction>
    <cffunction name="get_parts" access="public" returntype="query">
        <cfset attributes = arguments>
        <cfquery name="get_parts"  datasource="#DSN#">
            SELECT
                AP.ASSET_P_PARTS_ID,
                AP.ASSET_P_ID,
                AP.PRODUCT_ID,
                AP.STOCK_ID,
                AP.CHANGE_PERIOD,
                AP.CHANGE_AMOUNT,
                AP.SPECT_ID,
                AP.RISK_POINT,
                AP.QUANTIY,
                AP.PRODUCT_UNIT_ID,
                AP.DETAIL,
                AP.UPDATE_DATE,
                AP.UPDATE_IP,
                AP.UPDATE_EMP,
                AP.RECORD_DATE,
                AP.RECORD_IP,
                AP.RECORD_EMP,
                S.STOCK_CODE,
                PU.MAIN_UNIT,
                P.PRODUCT_NAME,
                SM.SPECT_MAIN_NAME
            FROM
            ASSET_P_PARTS AP
            LEFT JOIN #dsn3#.STOCKS S ON S.STOCK_ID= AP.STOCK_ID
            LEFT JOIN #dsn3#.PRODUCT_UNIT PU ON PU.PRODUCT_UNIT_ID	= AP.PRODUCT_UNIT_ID
            LEFT JOIN #dsn3#.PRODUCT P ON P.PRODUCT_ID= AP.PRODUCT_ID
            LEFT JOIN #dsn3#.SPECT_MAIN SM ON SM.SPECT_MAIN_ID= AP.SPECT_ID
            WHERE ASSET_P_PARTS_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.ASSET_P_PARTS_ID#">
        </cfquery>
        <cfreturn get_parts>
    </cffunction>
    <cffunction  name="upd_parts"  access="remote" returntype="any">
        <cfset attributes = arguments>
            <cfquery name="upd_parts" datasource="#dsn#">
                UPDATE 
                    ASSET_P_PARTS
                SET 
                    ASSET_P_ID= <cfif isdefined("arguments.asset_p_id") and len(arguments.asset_p_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.asset_p_id#"><cfelse>NULL</cfif>,
                    PRODUCT_ID= <cfif isdefined("arguments.product_id") and len(arguments.product_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.product_id#"><cfelse>NULL</cfif>,
                    STOCK_ID= <cfif isdefined("arguments.add_stock_id") and len(arguments.add_stock_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.add_stock_id#"><cfelse>NULL</cfif>,
                    CHANGE_PERIOD= <cfif isdefined("arguments.change_period") and len(arguments.change_period)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.change_period#"><cfelse>NULL</cfif>,
                    CHANGE_AMOUNT= <cfif isdefined("arguments.change_amount") and len(arguments.change_amount)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.change_amount#"><cfelse>NULL</cfif>,
                    SPECT_ID= <cfif isdefined("arguments.spect_main_id") and len(arguments.spect_main_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.spect_main_id#"><cfelse>NULL</cfif>,
                    RISK_POINT= <cfif isdefined("arguments.risk_point") and len(arguments.risk_point)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.risk_point#"><cfelse>NULL</cfif>,
                    QUANTIY= <cfif isdefined("arguments.quantity") and len(arguments.quantity)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.quantity#"><cfelse>NULL</cfif>,
                    PRODUCT_UNIT_ID= <cfif isdefined("arguments.unit_id") and len(arguments.unit_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.unit_id#"><cfelse>NULL</cfif>,
                    DETAIL= <cfif isdefined("arguments.detail") and len(arguments.detail)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.detail#"><cfelse>NULL</cfif>,
                    UPDATE_DATE= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                    UPDATE_IP= <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
                    UPDATE_EMP= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
                WHERE 
                    ASSET_P_PARTS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.asset_parts_id#">
            </cfquery>
            <script>
                closeBoxDraggable('<cfoutput>#arguments.modal_id#</cfoutput>');
                jQuery('#upd_spare .catalyst-refresh' ).click();
            </script>
    </cffunction>

    <cffunction  name="del_parts"  access="public" returntype="any">
        <cfset attributes = arguments>
        <cfset responseStruct = structNew()>
        <cftry>
            <cfquery name="del_parts" datasource="#dsn#">
                DELETE FROM ASSET_P_PARTS WHERE ASSET_P_PARTS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.asset_parts_id#">
            </cfquery>
            <script>
                location.href= document.referrer;
            </script>
            <cfset responseStruct.message = "İşlem Başarılı">
            <cfset responseStruct.status = true>
            <cfset responseStruct.error = {}>
            <cfset responseStruct.identity = ''>
            <cfcatch>
                <cfset responseStruct.message = "İşlem Hatalı">
                <cfset responseStruct.status = false>
                <cfset responseStruct.error = cfcatch>
            </cfcatch>
        </cftry>
        <cfreturn responseStruct>
    </cffunction>

</cfcomponent>