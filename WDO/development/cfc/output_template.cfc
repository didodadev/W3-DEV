<cfcomponent>
    <cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="insert_output_template" returntype="any" access="public">
        <cfargument name="output_template_name" type="any" default="">
        <cfargument name="output_template_patent" type="any" default="">
        <cfargument name="active" type="any" default="">
        <cfargument name="bp_code" type="any" default="">
        <cfargument name="output_template_detail" type="any" default="">
        <cfargument name="product_id" type="any" default="">
        <cfargument name="licence" type="any" default="">
        <cfargument name="related_wo" type="any" default="">
        <cfargument name="author_partner_id" type="any" default="">
        <cfargument name="author" type="any" default="">
        <cfargument name="view_path" type="any" default=""> 
        <cfargument name="related_sectors" type="any" default="">
        <cfargument name="process_stage" type="any" default="">
        <cfargument name="version" type="any" default="">
        <cfargument name="print_type" type="any" default="">
        <cfargument name="template_path" type="any" default=""> 
        <cfargument name="use_logo" type="any" default="">
        <cfargument name="use_adress" type="any" default="">
        <cfargument name="page_width" type="any" default="">
        <cfargument name="page_height" type="any" default="">
        <cfargument name="page_margin_left" type="any" default="">
        <cfargument name="page_margin_right" type="any" default="">
        <cfargument name="page_margin_top" type="any" default="">
        <cfargument name="page_margin_bottom" type="any" default="">
        <cfargument name="page_header_height" type="any" default="">
        <cfargument name="page_footer_height" type="any" default="">
        <cfargument name="rule_unit" type="any" default="">
        <cfargument name="logo_width" type="any" default="">
        <cfargument name="logo_height" type="any" default="">
        <cfargument name="schema_markup" type="any" default="">
        <cfargument name="dictionary_id" type="any" default="">
        <cfquery name="insert_output_template" datasource="#DSN#">
            INSERT INTO WRK_OUTPUT_TEMPLATES
            (
                WRK_OUTPUT_TEMPLATE_NAME,
                WRK_OUTPUT_TEMPLATE_PATENT,
                IS_ACTIVE,
                BEST_PRACTISE_CODE,
                OUTPUT_TEMPLATE_DETAIL,                
                WORKCUBE_PRODUCT_ID,
                LICENCE_TYPE,
                RELATED_WO,
                AUTHOR_PARTNER_ID,
                AUTHOR_NAME,
                OUTPUT_TEMPLATE_VIEW_PATH,
                OUTPUT_TEMPLATE_SECTORS,
                WRK_PROCESS_STAGE,
                OUTPUT_TEMPLATE_VERSION,
                RECORD_DATE,
                RECORD_EMP,
                RECORD_IP,
                PRINT_TYPE,
                OUTPUT_TEMPLATE_PATH,
                USE_LOGO,
                USE_ADRESS,
                PAGE_WIDTH,
                PAGE_HEIGHT,
                PAGE_MARGIN_LEFT,
                PAGE_MARGIN_RIGHT,
                PAGE_MARGIN_TOP,
                PAGE_MARGIN_BOTTOM,
                PAGE_HEADER_HEIGHT,
                PAGE_FOOTER_HEIGHT,
                RULE_UNIT,
                LOGO_WIDTH,
                LOGO_HEIGHT,
                SCHEMA_MARKUP,
                DICTIONARY_ID
            )
            VALUES
            (
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.output_template_name#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.output_template_patent#">,
                <cfif isdefined("arguments.active") and len(arguments.active)>1<cfelse>0</cfif>,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.bp_code#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.output_template_detail#">,                
                <cfif len(arguments.product_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.product_id#"><cfelse>NULL</cfif>,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.licence#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.related_wo#">,
                <cfif len(arguments.author_partner_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.author_partner_id#"><cfelse>NULL</cfif>,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.author#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.view_path#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.related_sectors#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.process_stage#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.version#">,
                #now()#,
                #session.ep.userid#,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
                <cfif len(arguments.print_type)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.print_type#"><cfelse>NULL</cfif>,
                <cfif len(arguments.template_path)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.template_path#"><cfelse>NULL</cfif>,
                <cfif isdefined("arguments.use_logo") and len(arguments.use_logo)>1<cfelse>0</cfif>,
                <cfif isdefined("arguments.use_adress") and len(arguments.use_adress)>1<cfelse>0</cfif>,
                <cfif len(arguments.page_width)><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.page_width#"><cfelse>NULL</cfif>,
                <cfif len(arguments.page_height)><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.page_height#"><cfelse>NULL</cfif>,
                <cfif len(arguments.page_margin_Left)><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.page_margin_Left#"><cfelse>NULL</cfif>,
                <cfif len(arguments.page_margin_right)><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.page_margin_right#"><cfelse>NULL</cfif>,
                <cfif len(arguments.page_margin_top)><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.page_margin_top#"><cfelse>NULL</cfif>,
                <cfif len(arguments.page_margin_bottom)><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.page_margin_bottom#"><cfelse>NULL</cfif>,
                <cfif len(arguments.page_header_height)><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.page_header_height#"><cfelse>NULL</cfif>,
                <cfif len(arguments.page_footer_height)><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.page_footer_height#"><cfelse>NULL</cfif>,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.rule_unit#">,
                <cfif len(arguments.logo_width)><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.logo_width#"><cfelse>NULL</cfif>,
                <cfif len(arguments.logo_height)><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.logo_height#"><cfelse>NULL</cfif>,
                <cfif len(arguments.schema_markup)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.schema_markup#"><cfelse>NULL</cfif>,
                <cfif isDefined("arguments.dictionary_id") and len(arguments.dictionary_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.dictionary_id#"><cfelse>NULL</cfif>
            )
        </cfquery>
    </cffunction>
    <cffunction name="upd_output_template" returntype="any" access="public">
        <cfargument name="output_template_id" type="any" default="">
        <cfargument name="output_template_name" type="any" default="">
        <cfargument name="active" type="any" default="">
        <cfargument name="bp_code" type="any" default="">
        <cfargument name="output_template_detail" type="any" default="">
        <cfargument name="use_Logo" type="any" default="">
        <cfargument name="use_Adress" type="any" default="">
        <cfargument name="page_Width" type="any" default="">
        <cfargument name="page_Height" type="any" default="">
        <cfargument name="page_margin_Left" type="any" default="">
        <cfargument name="page_margin_Right" type="any" default="">
        <cfargument name="page_margin_Top" type="any" default="">
        <cfargument name="page_margin_Bottom" type="any" default="">
        <cfargument name="page_Header_Height" type="any" default="">
        <cfargument name="page_Footer_Height" type="any" default="">
        <cfargument name="Rule_Unit" type="any" default="">
        <cfargument name="logo_width" type="any" default="">
        <cfargument name="logo_height" type="any" default="">
        <cfargument name="product_id" type="any" default="">
        <cfargument name="licence" type="any" default="">
        <cfargument name="related_wo" type="any" default="">
        <cfargument name="author_partner_id" type="any" default="">
        <cfargument name="author" type="any" default="">
        <cfargument name="view_path" type="any" default="">
        <cfargument name="related_sectors" type="any" default="">
        <cfargument name="process_stage" type="any" default="">
        <cfargument name="version" type="any" default="">
        <cfargument name="print_type" type="any" default="">
        <cfargument name="template_path" type="any" default="">
        <cfargument name="schema_markup" type="any" default="">
        <cfargument name="dictionary_id" type="any" default="">
        <cfquery name="upd_output_template" datasource="#DSN#">
        
            UPDATE WRK_OUTPUT_TEMPLATES
            SET 
                WRK_OUTPUT_TEMPLATE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.output_template_name#">,
                WRK_OUTPUT_TEMPLATE_PATENT = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.output_template_patent#">,
                IS_ACTIVE = <cfif isdefined("arguments.active") and len(arguments.active)>1<cfelse>0</cfif>,
                BEST_PRACTISE_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.bp_code#">,
                OUTPUT_TEMPLATE_DETAIL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.output_template_detail#">,
                WORKCUBE_PRODUCT_ID = <cfif len(arguments.product_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.product_id#"><cfelse>NULL</cfif>,
                LICENCE_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.licence#">,
                RELATED_WO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.related_wo#">,
                AUTHOR_PARTNER_ID = <cfif len(arguments.author_partner_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.author_partner_id#"><cfelse>NULL</cfif>,
                AUTHOR_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.author#">,
                OUTPUT_TEMPLATE_VIEW_PATH = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.view_path#">,
                OUTPUT_TEMPLATE_SECTORS = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.related_sectors#">,
                WRK_PROCESS_STAGE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.process_stage#">,
                OUTPUT_TEMPLATE_VERSION = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.version#">,
                UPDATE_DATE = #now()#,
                UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
                UPDATE_EMP = #session.ep.userid#,
                PRINT_TYPE = <cfif len(arguments.print_type)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.print_type#"><cfelse>NULL</cfif>,
                OUTPUT_TEMPLATE_PATH = <cfif len(arguments.template_path)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.template_path#"><cfelse>NULL</cfif>,
                USE_LOGO=<cfif isdefined("arguments.USE_LOGO") and len(arguments.USE_LOGO)>1<cfelse>0</cfif>,
                USE_ADRESS=<cfif isdefined("arguments.USE_ADRESS") and len(arguments.USE_ADRESS)>1<cfelse>0</cfif>,
                PAGE_WIDTH=<cfif len(arguments.page_width)><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.page_width #"><cfelse>NULL</cfif>,
                PAGE_HEIGHT=<cfif len(arguments.page_height)><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.page_height #"><cfelse>NULL</cfif>,
                PAGE_MARGIN_LEFT=<cfif len(arguments.page_margin_Left)><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.page_margin_Left #"><cfelse>NULL</cfif>,
                PAGE_MARGIN_RIGHT=<cfif len(arguments.page_margin_Right)><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.page_margin_Right #"><cfelse>NULL</cfif>,
                PAGE_MARGIN_TOP=<cfif len(arguments.page_margin_Top)><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.page_margin_Top #"><cfelse>NULL</cfif>,
                PAGE_MARGIN_BOTTOM=<cfif len(arguments.page_margin_Bottom)><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.page_margin_Bottom #"><cfelse>NULL</cfif>,
                PAGE_HEADER_HEIGHT=<cfif len(arguments.page_header_Height)><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.page_header_Height #"><cfelse>NULL</cfif>,
                PAGE_FOOTER_HEIGHT=<cfif len(arguments.page_footer_Height)><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.page_footer_Height #"><cfelse>NULL</cfif>,
                RULE_UNIT=<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.rule_unit#">,
                LOGO_WIDTH=<cfif len(arguments.logo_width)><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.logo_width#"><cfelse>NULL</cfif>,
                LOGO_HEIGHT=<cfif len(arguments.logo_height)><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.logo_height#"><cfelse>NULL</cfif>,
                SCHEMA_MARKUP=<cfif len(arguments.schema_markup)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.schema_markup#"><cfelse>NULL</cfif>,
                DICTIONARY_ID=<cfif isDefined("arguments.dictionary_id") and len(arguments.dictionary_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.dictionary_id#"><cfelse>NULL</cfif>
            WHERE  WRK_OUTPUT_TEMPLATE_ID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.output_template_id#">
        </cfquery>
    </cffunction>
    <cffunction name="get_output_template" returntype="query" access="public">
        <cfargument name="output_template_id" type="any" default="">
        <cfquery name="get_output_template" datasource="#DSN#">
           SELECT * FROM WRK_OUTPUT_TEMPLATES WHERE WRK_OUTPUT_TEMPLATE_ID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.output_template_id#">
        </cfquery>
        <cfreturn get_output_template>
    </cffunction>
    <cffunction name="get_output_templates" returntype="query" access="public">
        <cfargument name="keyword" type="any" default="">
        <cfargument name="bp_code" type="any" default="">
        <cfargument name="licence" type="any" default="">
        <cfargument name="related_sectors" type="any" default="">
        <cfargument name="related_wo" type="any" default="">
        <cfargument name="active" type="any" default="">
        <cfquery name="get_output_templates" datasource="#DSN#">
            SELECT * FROM WRK_OUTPUT_TEMPLATES WHERE 
            WRK_OUTPUT_TEMPLATE_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%">  
            <cfif isdefined("arguments.licence") and len(arguments.licence)>
                AND  LICENCE_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.licence#">
            </cfif> 
            <cfif isdefined("arguments.related_wo") and len(arguments.related_wo)>
                AND  RELATED_WO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.related_wo#%"> 
            </cfif> 
            <cfif isdefined("arguments.related_sectors") and len(arguments.related_sectors)>
                AND  OUTPUT_TEMPLATE_SECTORS LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.related_sectors#%">
            </cfif> 
            <cfif isdefined("arguments.bp_code") and len(arguments.bp_code)>
                AND  BEST_PRACTISE_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.bp_code#%">
            </cfif> 
            <cfif isdefined("arguments.active") and len(arguments.active)>
                AND IS_ACTIVE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.active#">
            </cfif>
        </cfquery>
        <cfreturn get_output_templates>
    </cffunction>   
    <cffunction name="del_output_template" access="public">
        <cfargument name="output_template_id" type="any" default="">
        <cfquery name="all_component" datasource="#DSN#">
            DELETE FROM WRK_OUTPUT_TEMPLATES WHERE WRK_OUTPUT_TEMPLATE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.output_template_id#">            
        </cfquery>
    </cffunction>
    <cffunction name="get_sector_cats" returntype="query" access="public">
        <cfquery name="get_sector_cats" datasource="#dsn#">
            SELECT * FROM SETUP_SECTOR_CATS ORDER BY SECTOR_CAT
        </cfquery>
        <cfreturn get_sector_cats>
    </cffunction>
</cfcomponent>
