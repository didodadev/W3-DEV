<cfcomponent>
    <cfset dsn = application.systemParam.systemParam().dsn>
    
    <cffunction name="insert_process_template" returntype="any" access="public">
        <cfargument name="process_template_name" type="any" default="">
        <cfargument name="active" type="any" default="">
        <cfargument name="main" type="any" default="">
        <cfargument name="stage" type="any" default="">
        <cfargument name="display" type="any" default="">
        <cfargument name="action" type="any" default="">
        <cfargument name="bp_code" type="any" default="">
        <cfargument name="process_template_detail" type="any" default="">
        <cfargument name="product_id" type="any" default="">
        <cfargument name="licence" type="any" default="">
        <cfargument name="related_wo" type="any" default="">
        <cfargument name="author_partner_id" type="any" default="">
        <cfargument name="author" type="any" default="">
        <cfargument name="icon_path" type="any" default=""> 
        <cfargument name="related_sectors" type="any" default="">
        <cfargument name="process_stage" type="any" default="">
        <cfargument name="version" type="any" default="">
        <cfargument name="template_path" type="any" default="">
        <cfargument name="module" type="any" default="">
        <cfquery name="insert_process_template" datasource="#DSN#">
            INSERT INTO WRK_process_TEMPLATES
            (
                WRK_PROCESS_TEMPLATE_NAME,
                IS_ACTIVE,
                IS_ACTION,
                IS_DISPLAY,
                IS_STAGE,
                IS_MAIN,
                BEST_PRACTISE_CODE,
                PROCESS_TEMPLATE_DETAIL,
                WORKCUBE_PRODUCT_ID,
                LICENCE_TYPE,
                RELATED_WO,
                AUTHOR_PARTNER_ID,
                AUTHOR_NAME,
                PROCESS_TEMPLATE_ICON_PATH,
                PROCESS_TEMPLATE_SECTORS,
                WRK_PROCESS_STAGE,
                PROCESS_TEMPLATE_VERSION,
                RECORD_DATE,
                RECORD_EMP,
                RECORD_IP,
                PROCESS_TEMPLATE_PATH,
                MODULE_ID
            )
            VALUES
            (
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.process_template_name#">,
                <cfif len(arguments.active)>1<cfelse>0</cfif>,
                <cfif len(arguments.action)>1<cfelse>0</cfif>,
                <cfif len(arguments.display)>1<cfelse>0</cfif>,
                <cfif len(arguments.stage)>1<cfelse>0</cfif>,
                <cfif len(arguments.main)>1<cfelse>0</cfif>,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.bp_code#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.process_template_detail#">,
                <cfif len(arguments.product_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.product_id#"><cfelse>NULL</cfif>,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.licence#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.related_wo#">,
                <cfif len(arguments.author_partner_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.author_partner_id#"><cfelse>NULL</cfif>,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.author#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.icon_path#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.related_sectors#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.process_stage#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.version#">,
                #now()#,
                #session.ep.userid#,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
                <cfif len(arguments.template_path)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.template_path#"><cfelse>NULL</cfif>,
                <cfif len(arguments.module)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.module#"><cfelse>NULL</cfif>
            )
        </cfquery>
        
    </cffunction>
    <cffunction name="upd_process_template" returntype="any" access="public">
        <cfargument name="process_template_id" type="any" default="">
        <cfargument name="process_template_name" type="any" default="">
        <cfargument name="active" type="any" default="">
        <cfargument name="main" type="any" default="">
        <cfargument name="stage" type="any" default="">
        <cfargument name="display" type="any" default="">
        <cfargument name="action" type="any" default="">
        <cfargument name="bp_code" type="any" default="">
        <cfargument name="process_template_detail" type="any" default="">
        <cfargument name="product_id" type="any" default="">
        <cfargument name="licence" type="any" default="">
        <cfargument name="related_wo" type="any" default="">
        <cfargument name="author_partner_id" type="any" default="">
        <cfargument name="author" type="any" default="">
        <cfargument name="icon_path" type="any" default="">
        <cfargument name="related_sectors" type="any" default="">
        <cfargument name="process_stage" type="any" default="">
        <cfargument name="version" type="any" default="">
        <cfargument name="template_path" type="any" default="">
        <cfargument name="module" type="any" default="">
        <cfquery name="upd_process_template" datasource="#DSN#">
            UPDATE WRK_PROCESS_TEMPLATES
            SET 
                WRK_PROCESS_TEMPLATE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.process_template_name#">,
                IS_ACTIVE = <cfif isdefined("arguments.active") and len(arguments.active)>1<cfelse>0</cfif>,
                IS_MAIN = <cfif isdefined("arguments.main") and len(arguments.main)>1<cfelse>0</cfif>,
                IS_STAGE = <cfif isdefined("arguments.stage") and len(arguments.stage)>1<cfelse>0</cfif>,
                IS_DISPLAY = <cfif isdefined("arguments.display") and len(arguments.display)>1<cfelse>0</cfif>,
                IS_ACTION = <cfif isdefined("arguments.action") and len(arguments.action)>1<cfelse>0</cfif>,
                BEST_PRACTISE_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.bp_code#">,
                PROCESS_TEMPLATE_DETAIL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.process_template_detail#">,
                WORKCUBE_PRODUCT_ID = <cfif len(arguments.product_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.product_id#"><cfelse>NULL</cfif>,
                LICENCE_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.licence#">,
                RELATED_WO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.related_wo#">,
                AUTHOR_PARTNER_ID = <cfif len(arguments.author_partner_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.author_partner_id#"><cfelse>NULL</cfif>,
                AUTHOR_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.author#">,
                PROCESS_TEMPLATE_ICON_PATH = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.icon_path#">,
                PROCESS_TEMPLATE_SECTORS = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.related_sectors#">,
                WRK_PROCESS_STAGE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.process_stage#">,
                PROCESS_TEMPLATE_VERSION = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.version#">,
                UPDATE_DATE = #now()#,
                UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
                UPDATE_EMP = #session.ep.userid#,
                PROCESS_TEMPLATE_PATH = <cfif len(arguments.template_path)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.template_path#"><cfelse>NULL</cfif>,
                MODULE_ID = <cfif len(arguments.module)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.module#"><cfelse>NULL</cfif>
            WHERE  WRK_PROCESS_TEMPLATE_ID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.process_template_id#">
        </cfquery>
    </cffunction>
    <cffunction name="get_process_template" returntype="query" access="public">
        <cfargument name="process_template_id" type="any" default="">
        <cfquery name="get_process_template" datasource="#DSN#">
           SELECT * FROM WRK_PROCESS_TEMPLATES WHERE WRK_PROCESS_TEMPLATE_ID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.process_template_id#">
        </cfquery>
        <cfreturn get_process_template>
    </cffunction>
    <cffunction name="get_process_templates" returntype="query" access="public">
        <cfargument name="keyword" type="any" default="">
        <cfargument name="bp_code" type="any" default="">
        <cfargument name="licence" type="any" default="">
        <cfargument name="related_sectors" type="any" default="">
        <cfargument name="related_wo" type="any" default="">
        <cfargument name="active" type="any" default="">
        <cfargument name="module" type="any" default="">
        <cfquery name="get_process_templates" datasource="#DSN#">
            SELECT * FROM WRK_PROCESS_TEMPLATES WPT LEFT JOIN WRK_MODULE WM ON WPT.MODULE_ID = WM.MODULE_ID 
            WHERE 
            WRK_PROCESS_TEMPLATE_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%">  
            <cfif isdefined("arguments.licence") and len(arguments.licence)>
                AND  LICENCE_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.licence#">
            </cfif> 
            <cfif isdefined("arguments.module") and len(arguments.module)>
                AND  WM.MODULE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.module#">
            </cfif> 
            <cfif isdefined("arguments.related_wo") and len(arguments.related_wo)>
                AND  RELATED_WO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.related_wo#%"> 
            </cfif> 
            <cfif isdefined("arguments.related_sectors") and len(arguments.related_sectors)>
                AND  PROCESS_TEMPLATE_SECTORS LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.related_sectors#%">
            </cfif> 
            <cfif isdefined("arguments.bp_code") and len(arguments.bp_code)>
                AND  BEST_PRACTISE_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.bp_code#%">
            </cfif>
            <cfif isdefined("arguments.type") and arguments.type eq 1>
                AND  IS_DISPLAY = 1
            <cfelseif isdefined("arguments.type") and arguments.type eq 2>
                AND  IS_ACTION = 1
            </cfif>  
            <cfif isdefined("arguments.active") and len(arguments.active)>
                AND IS_ACTIVE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.active#">
            </cfif>
        </cfquery>
        <cfreturn get_process_templates>
    </cffunction>   
    <cffunction name="del_process_template" access="public">
        <cfargument name="process_template_id" type="any" default="">
        <cfquery name="all_component" datasource="#DSN#">
            DELETE FROM WRK_PROCESS_TEMPLATES WHERE WRK_PROCESS_TEMPLATE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.process_template_id#">            
        </cfquery>
    </cffunction>
    <cffunction name="get_sector_cats" returntype="query" access="public">
        <cfquery name="get_sector_cats" datasource="#dsn#">
            SELECT * FROM SETUP_SECTOR_CATS ORDER BY SECTOR_CAT
        </cfquery>
        <cfreturn get_sector_cats>
    </cffunction>
    <cffunction name="get_modules" returntype="query" access="public">
        <cfquery name="get_modules" datasource="#dsn#">
            SELECT MODULE_ID, MODULE FROM WRK_MODULE
        </cfquery>
        <cfreturn get_modules>
    </cffunction>
    <cffunction name="get_module" returntype="string" access="public">
        <cfargument name="module" type="any" default="">
        <cfquery name="get_module" datasource="#dsn#">
            SELECT MODULE_ID, MODULE FROM WRK_MODULE WHERE MODULE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.module#">            
        </cfquery>
        <cfreturn get_module.module>
    </cffunction>
</cfcomponent>
