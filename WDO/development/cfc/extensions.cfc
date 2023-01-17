<cfcomponent>
    <cfset dsn = application.systemParam.systemParam().dsn>
    
    <cffunction name="insert_extension" returntype="any" access="public">
        <cfargument name="extension_name" type="any" default="">
        <cfargument name="active" type="any" default="">
        <cfargument name="bp_code" type="any" default="">
        <cfargument name="extension_detail" type="any" default="">
        <cfargument name="product_id" type="any" default="">
        <cfargument name="licence" type="any" default="">
        <cfargument name="related_wo" type="any" default="">
        <cfargument name="author_partner_id" type="any" default="">
        <cfargument name="author" type="any" default="">
        <cfargument name="icon_path" type="any" default="">
        <cfargument name="related_sectors" type="any" default="">
        <cfargument name="process_stage" type="any" default="">
        <cfargument name="version" type="any" default="">
        <cfquery name="insert_extension" datasource="#DSN#">
            INSERT INTO WRK_EXTENSIONS
            (
                WRK_EXTENSION_NAME,
                IS_ACTIVE,
                BEST_PRACTISE_CODE,
                EXTENSION_DETAIL,
                WORKCUBE_PRODUCT_ID,
                LICENCE_TYPE,
                RELATED_WO,
                AUTHOR_PARTNER_ID,
                AUTHOR_NAME,
                EXTENSION_ICON_IMAGE_PATH,
                EXTENSION_SECTORS,
                WRK_PROCESS_STAGE,
                EXTENSION_VERSION,
                RECORD_DATE,
                RECORD_EMP,
                RECORD_IP
            )
            VALUES
            (
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.extension_name#">,
                <cfif isdefined("arguments.active") and len(arguments.active)>1<cfelse>0</cfif>,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.bp_code#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.extension_detail#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.product_id#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.licence#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.related_wo#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.author_partner_id#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.author#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.icon_path#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.related_sectors#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.process_stage#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.version#">,
                #now()#,
                #session.ep.userid#,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">	
            )
        </cfquery>
        
    </cffunction>
    <cffunction name="upd_extension" returntype="any" access="public">
        <cfargument name="extension_id" type="any" default="">
        <cfargument name="extension_name" type="any" default="">
        <cfargument name="active" type="any" default="">
        <cfargument name="bp_code" type="any" default="">
        <cfargument name="extension_detail" type="any" default="">
        <cfargument name="product_id" type="any" default="">
        <cfargument name="licence" type="any" default="">
        <cfargument name="related_wo" type="any" default="">
        <cfargument name="author_partner_id" type="any" default="">
        <cfargument name="author" type="any" default="">
        <cfargument name="icon_path" type="any" default="">
        <cfargument name="related_sectors" type="any" default="">
        <cfargument name="process_stage" type="any" default="">
        <cfargument name="version" type="any" default="">
        <cfquery name="upd_extension" datasource="#DSN#">
            UPDATE WRK_EXTENSIONS
            SET 
                WRK_EXTENSION_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.extension_name#">,
                IS_ACTIVE = <cfif isdefined("arguments.active") and len(arguments.active)>1<cfelse>0</cfif>,
                BEST_PRACTISE_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.bp_code#">,
                EXTENSION_DETAIL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.extension_detail#">,
                WORKCUBE_PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.product_id#">,
                LICENCE_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.licence#">,
                RELATED_WO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.related_wo#">,
                AUTHOR_PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.author_partner_id#">,
                AUTHOR_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.author#">,
                EXTENSION_ICON_IMAGE_PATH = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.icon_path#">,
                EXTENSION_SECTORS = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.related_sectors#">,
                WRK_PROCESS_STAGE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.process_stage#">,
                EXTENSION_VERSION = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.version#">,
                UPDATE_DATE = #now()#,
                UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
                UPDATE_EMP = #session.ep.userid#
            WHERE  WRK_EXTENSION_ID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.extension_id#">
        </cfquery>
    </cffunction>
    <cffunction name="get_extension" returntype="query" access="public">
        <cfargument name="extension_id" type="any" default="">
        <cfquery name="get_extension" datasource="#DSN#">
           SELECT * FROM WRK_EXTENSIONS WHERE WRK_EXTENSION_ID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.extension_id#">
        </cfquery>
        <cfreturn get_extension>
    </cffunction>
    <cffunction name="get_extensions" returntype="query" access="public">
        <cfargument name="keyword" type="any" default="">
        <cfargument name="bp_code" type="any" default="">
        <cfargument name="licence" type="any" default="">
        <cfargument name="related_sectors" type="any" default="">
        <cfargument name="related_wo" type="any" default="">
        <cfargument name="active" type="any" default="">
        <cfquery name="get_extensions" datasource="#DSN#">
            SELECT * FROM WRK_EXTENSIONS WHERE 
                WRK_EXTENSION_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%">  
                <cfif isdefined("arguments.licence") and len(arguments.licence)>
                    AND  LICENCE_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.licence#">
                </cfif> 
                <cfif isdefined("arguments.related_wo") and len(arguments.related_wo)>
                    AND  RELATED_WO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.related_wo#%"> 
                </cfif> 
                <cfif isdefined("arguments.related_sectors") and len(arguments.related_sectors)>
                    AND  EXTENSION_SECTORS LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.related_sectors#%">
                </cfif> 
                <cfif isdefined("arguments.bp_code") and len(arguments.bp_code)>
                    AND  BEST_PRACTISE_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.bp_code#%">
                </cfif> 
                <cfif isdefined("arguments.active") and len(arguments.active)>
                    AND IS_ACTIVE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.active#">
                </cfif>
        </cfquery>
        <cfreturn get_extensions>
    </cffunction>
    <cffunction name="insert_component" returntype="any" access="public">
        <cfargument name="extension_id" type="any" default="">
        <cfargument name="number" type="any" default="">
        <cfargument name="component_name" type="any" default="">
        <cfargument name="file_path" type="any" default="">
        <cfargument name="place" type="any" default="">
        <cfargument name="action" type="any" default="">
        <cfargument name="is_active" type="any" default="">
        <cfargument name="is_add" type="any" default="">
        <cfargument name="is_upd" type="any" default="">
        <cfargument name="is_det" type="any" default="">
        <cfargument name="is_list" type="any" default="">
        <cfargument name="is_dash" type="any" default="">
        <cfargument name="is_info" type="any" default="">
        <cfargument name="is_del" type="any" default="">
        <cfargument name="component_detail" type="any" default="">
        <cfquery name="insert_component" datasource="#DSN#">
            INSERT INTO WRK_COMPONENTS
            (
                WRK_EXTENSION_ID,
                WORKING_NUMBER,
                WRK_COMPONENT_NAME,
                COMPONENT_FILE_PATH,
                WORKING_PLACE,
                WORKING_ACTION,
                IS_ACTIVE,
                IS_ADD_WORK,
                IS_UPD_WORK,
                IS_DET_WORK,
                IS_LIST_WORK,
                IS_DASHBOARD_WORK,
                IS_INFO_WORK,
                IS_DEL_WORK,
                WRK_COMPONENT_DETAIL,
                RECORD_DATE,
                RECORD_EMP,
                RECORD_IP
            )
            VALUES
            (
                <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.extension_id#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.number#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.component_name#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.file_path#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.place#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.action#">,
                <cfif isdefined("arguments.is_active") and len(arguments.is_active)>1<cfelse>0</cfif>,
                <cfif isdefined("arguments.is_add") and len(arguments.is_add)>1<cfelse>0</cfif>,
                <cfif isdefined("arguments.is_upd") and len(arguments.is_upd)>1<cfelse>0</cfif>,
                <cfif isdefined("arguments.is_det") and len(arguments.is_det)>1<cfelse>0</cfif>,
                <cfif isdefined("arguments.is_list") and len(arguments.is_list)>1<cfelse>0</cfif>,
                <cfif isdefined("arguments.is_dash") and len(arguments.is_dash)>1<cfelse>0</cfif>,
                <cfif isdefined("arguments.is_info") and len(arguments.is_info)>1<cfelse>0</cfif>,
                <cfif isdefined("arguments.is_del") and len(arguments.is_del)>1<cfelse>0</cfif>,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.component_detail#">,
                #now()#,
                #session.ep.userid#,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">	
            )
        </cfquery>
    </cffunction>
    <cffunction name="upd_component" returntype="any" access="public">
        <cfargument name="component_id" type="any" default="">
        <cfargument name="number" type="any" default="">
        <cfargument name="component_name" type="any" default="">
        <cfargument name="file_path" type="any" default="">
        <cfargument name="place" type="any" default="">
        <cfargument name="action" type="any" default="">
        <cfargument name="is_active" type="any" default="">
        <cfargument name="is_add" type="any" default="">
        <cfargument name="is_upd" type="any" default="">
        <cfargument name="is_det" type="any" default="">
        <cfargument name="is_list" type="any" default="">
        <cfargument name="is_dash" type="any" default="">
        <cfargument name="is_info" type="any" default="">
        <cfargument name="is_del" type="any" default="">
        <cfargument name="component_detail" type="any" default="">
        <cfquery name="upd_component" datasource="#DSN#">
            UPDATE WRK_COMPONENTS
            SET 
                WORKING_NUMBER = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.number#">,
                WRK_COMPONENT_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.component_name#">,
                COMPONENT_FILE_PATH = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.file_path#">,
                WORKING_PLACE =  <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.place#">,
                WORKING_ACTION =  <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.action#">,
                IS_ACTIVE = <cfif isdefined("arguments.is_active") and len(arguments.is_active)>1<cfelse>0</cfif>,
                IS_ADD_WORK = <cfif isdefined("arguments.is_add") and len(arguments.is_add)>1<cfelse>0</cfif>,
                IS_UPD_WORK = <cfif isdefined("arguments.is_upd") and len(arguments.is_upd)>1<cfelse>0</cfif>,
                IS_DET_WORK = <cfif isdefined("arguments.is_det") and len(arguments.is_det)>1<cfelse>0</cfif>,
                IS_LIST_WORK = <cfif isdefined("arguments.is_list") and len(arguments.is_list)>1<cfelse>0</cfif>,
                IS_DASHBOARD_WORK = <cfif isdefined("arguments.is_dash") and len(arguments.is_dash)>1<cfelse>0</cfif>,
                IS_INFO_WORK = <cfif isdefined("arguments.is_info") and len(arguments.is_info)>1<cfelse>0</cfif>,
                IS_DEL_WORK = <cfif isdefined("arguments.is_del") and len(arguments.is_del)>1<cfelse>0</cfif>,
                WRK_COMPONENT_DETAIL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.component_detail#">,
                UPDATE_DATE = #now()#,
                UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
                UPDATE_EMP = #session.ep.userid#
            WHERE  WRK_COMPONENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.component_id#">
        </cfquery>
    </cffunction>
    <cffunction name="del_component" access="public">
        <cfargument name="component_id" type="any" default="">
        <cfquery name="del_component" datasource="#DSN#">
            DELETE FROM WRK_COMPONENTS WHERE WRK_COMPONENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.component_id#">
        </cfquery>
    </cffunction>
    <cffunction name="all_del_component" access="public">
        <cfargument name="extension_id" type="any" default="">
        <cfquery name="all_del_component" datasource="#DSN#">
            DELETE FROM WRK_COMPONENTS WHERE WRK_EXTENSION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.extension_id#">            
        </cfquery>
        <cfquery name="all_component" datasource="#DSN#">
            DELETE FROM WRK_EXTENSIONS WHERE WRK_EXTENSION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.extension_id#">            
        </cfquery>
    </cffunction>
    <cffunction name="get_component" returntype="query" access="public">
        <cfargument name="component_id" type="any" default="">
        <cfquery name="get_component" datasource="#DSN#">
            SELECT * FROM WRK_COMPONENTS WHERE WRK_COMPONENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.component_id#">
        </cfquery>
        <cfreturn get_component>
    </cffunction>
    <cffunction name="get_components" returntype="query" access="public">
        <cfargument name="extension_id" type="any" default="">
        <cfquery name="get_components" datasource="#DSN#">
            SELECT * FROM WRK_COMPONENTS WHERE WRK_EXTENSION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.extension_id#">  
        </cfquery>
        <cfreturn get_components>
    </cffunction>
    <cffunction name="get_sector_cats" returntype="query" access="public">
        <cfquery name="get_sector_cats" datasource="#dsn#">
            SELECT * FROM SETUP_SECTOR_CATS ORDER BY SECTOR_CAT
        </cfquery>
        <cfreturn get_sector_cats>
    </cffunction>
    <cffunction name="get_related_components" access="public">
        <cfargument name="wo" default="myhome.welcome">
        <cfargument name="place" default="1">
        <cfargument name="action" default="1">
        <cfargument name="event" default="DISALLOW">
        <cfquery name="query_related_components" datasource="#DSN#">
            SELECT 
            CMP.COMPONENT_FILE_PATH
            FROM WRK_EXTENSIONS EXT
            INNER JOIN WRK_COMPONENTS CMP ON EXT.WRK_EXTENSION_ID = CMP.WRK_EXTENSION_ID
            WHERE 
            EXT.IS_ACTIVE = 1
            AND CMP.IS_ACTIVE = 1
            <cfif arguments.event eq "add">
            AND CMP.IS_ADD_WORK = 1
            <cfelseif arguments.event eq "upd">
            AND CMP.IS_UPD_WORK = 1
            <cfelseif arguments.event eq "det">
            AND CMP.IS_DET_WORK = 1
            <cfelseif arguments.event eq "list">
            AND CMP.IS_LIST_WORK = 1
            <cfelseif arguments.event eq "dashboard">
            AND CMP.IS_DASHBOARD_WORK = 1
            <cfelseif arguments.event eq "info">
            AND CMP.IS_INFO_WORK = 1
            <cfelse>
            AND 1=2
            </cfif>
            AND CMP.WORKING_PLACE = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.place#'>
            AND CMP.WORKING_ACTION = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.action#'>
            AND EXT.RELATED_WO LIKE <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='%#arguments.wo#%'>
            ORDER BY CMP.WORKING_NUMBER ASC
        </cfquery>
        <cfreturn query_related_components>
    </cffunction>
</cfcomponent>
