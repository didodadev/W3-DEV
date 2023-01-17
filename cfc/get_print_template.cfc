<!--- 
    Author : Uğur Hamurpet
    Create Date : 30/01/2020
    methods : {
        GET : 'Get print template'
    }
--->

<cfcomponent>

    <cfset dsn = application.systemParam.systemParam().dsn>
    
	<cfif application.systemParam.systemParam().fusebox.use_period eq true>
		<cfset dsn3 = "#dsn#_#session.ep.company_id#">
	<cfelse>
		<cfset dsn3 = "#dsn#">
	</cfif>
    <cffunction name="GET" returntype="query" access="public" hint="Get print template">
        <cfargument name="print_type" type="numeric" required="no" default="0">
        <cfargument name="form_type" type="numeric" required="no" default="0">
        
        <cfquery name="GET_PRINT_TEMPLATE" datasource="#dsn#">
            SELECT 
                DISTINCT SPF.FORM_ID,
                ISNULL(SPF.IS_STANDART,0) AS IS_STANDART,
                SPF.IS_XML,
                SPF.TEMPLATE_FILE,
                SPF.FORM_ID,
                SPF.IS_DEFAULT,
                SPF.NAME,
                SPF.PROCESS_TYPE,
                SPF.MODULE_ID,
                SPFC.PRINT_NAME
            FROM
                #dsn3#.SETUP_PRINT_FILES AS SPF
                LEFT JOIN SETUP_PRINT_FILES_CATS AS SPFC ON SPF.PROCESS_TYPE = SPFC.PRINT_TYPE
                LEFT JOIN WRK_MODULE AS WM ON WM.MODULE_ID = SPF.MODULE_ID
                LEFT JOIN SETUP_PRINT_FILES_POSITION AS SPFP ON SPFP.FORM_ID = SPF.FORM_ID
            WHERE
                SPF.ACTIVE = 1
                AND SPFP.FORM_ID IS NULL
                <cfif arguments.print_type neq 0>
                    AND SPFC.PRINT_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.print_type#">
                </cfif>
                <cfif arguments.form_type neq 0>
                    AND SPF.FORM_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.form_type#">
                </cfif>
            UNION ALL
                SELECT 
                    DISTINCT SPF.FORM_ID,
                    ISNULL(SPF.IS_STANDART,0) AS IS_STANDART,
                    SPF.IS_XML,
                    SPF.TEMPLATE_FILE,
                    SPF.FORM_ID,
                    SPF.IS_DEFAULT,
                    SPF.NAME,
                    SPF.PROCESS_TYPE,
                    SPF.MODULE_ID,
                    SPFC.PRINT_NAME
                FROM
                    #dsn3#.SETUP_PRINT_FILES AS SPF
                    LEFT JOIN SETUP_PRINT_FILES_CATS AS SPFC ON SPF.PROCESS_TYPE = SPFC.PRINT_TYPE
                    LEFT JOIN WRK_MODULE AS WM ON WM.MODULE_ID = SPF.MODULE_ID
                    LEFT JOIN SETUP_PRINT_FILES_POSITION AS SPFP ON SPFP.FORM_ID = SPF.FORM_ID
                    LEFT JOIN EMPLOYEE_POSITIONS EMP ON SPFP.POS_CAT_ID = EMP.POSITION_CAT_ID OR SPFP.POS_CODE = EMP.POSITION_CODE
                WHERE
                    SPF.ACTIVE = 1
                    <cfif arguments.print_type neq 0>
                        AND SPFC.PRINT_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.print_type#">
                    </cfif>
                    AND SPFP.FORM_ID IS NOT NULL
                    AND EMP.IS_MASTER = 1
                    <cfif arguments.form_type neq 0>
                        AND SPF.FORM_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.form_type#">
                    </cfif>
            ORDER BY
                SPF.IS_XML,
                SPF.NAME
        </cfquery>

      <cfreturn GET_PRINT_TEMPLATE>

    </cffunction>
    <cffunction name="get_print_positions" returntype="query" access="public">
        <cfargument name="form_type" type="numeric" required="no">
        <cfquery name="get_print_positions" datasource="#dsn#">
            SELECT * FROM SETUP_PRINT_FILES_POSITION WHERE FORM_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.form_type#">
        </cfquery>
        <cfreturn get_print_positions>
    </cffunction>
    <cffunction name="get_pos" returntype="query" access="public">
        <cfquery name="get_pos" datasource="#dsn#">
           SELECT POSITION_CODE, POSITION_CAT_ID FROM EMPLOYEE_POSITIONS WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
        </cfquery>
        <cfreturn get_pos>
    </cffunction>
    <cffunction name="print_position_control" returntype="query" access="public">
        <cfargument name="form_type" type="numeric" required="no">
        <cfargument name="position_code" type="numeric" required="no">
        <cfargument name="print_type" type="numeric" required="no">
        <cfquery name="print_position_control" datasource="#dsn#">
            SELECT 
                FORM_ID 
            FROM 
                SETUP_PRINT_FILES_POSITION 
            WHERE 
                FORM_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.form_type#"> AND
                (POS_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.position_code#"> OR POS_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.position_cat_id#">) AND 
                OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
        </cfquery>
        <cfreturn print_position_control>
    </cffunction>
    <cffunction name="get_templates" returntype="query" access="public">
        <cfargument name="action" type="string" required="true">
        <cfquery name="get_templates" datasource="#dsn#">
            SELECT   
                WRK_OUTPUT_TEMPLATE_ID,
                WRK_OUTPUT_TEMPLATE_NAME,
                OUTPUT_TEMPLATE_PATH,
                SCHEMA_MARKUP,
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
                LOGO_WIDTH,
                LOGO_HEIGHT,
                RULE_UNIT  
            FROM 
                WRK_OUTPUT_TEMPLATES 
            WHERE 
                RELATED_WO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.action#%">
        </cfquery>
        <cfreturn get_templates>
    </cffunction>
    <cffunction name="get_template" returntype="query" access="public">
        <cfargument name="template_id" type="numeric" required="true">
        <cfquery name="get_template" datasource="#dsn#">
            SELECT   
                WRK_OUTPUT_TEMPLATE_ID,
                WRK_OUTPUT_TEMPLATE_NAME,
                OUTPUT_TEMPLATE_PATH,
                SCHEMA_MARKUP,
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
                LOGO_WIDTH,
                LOGO_HEIGHT,
                RULE_UNIT,
                DATA_DESIGN,
                DICTIONARY_ID
            FROM 
                WRK_OUTPUT_TEMPLATES 
            WHERE 
                WRK_OUTPUT_TEMPLATE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.template_id#">
        </cfquery>
        <cfreturn get_template>
    </cffunction>
    <cffunction name="CHECK" returntype="query" access="public">
        <cfargument name="our_company_id" type="any" required="no" default="">
        <cfquery name="check" datasource="#dsn#">
            SELECT 
                ASSET_FILE_NAME2,
                ASSET_FILE_NAME2_SERVER_ID,
                COMPANY_NAME,
                ADDRESS,
                WEB,
                TAX_NO,
                TAX_OFFICE
            FROM 
                OUR_COMPANY 
            WHERE 
                <cfif len(arguments.our_company_id)>
                    COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.our_company_id#">
                <cfelse>
                    <cfif isDefined("session.ep.company_id") and len(session.ep.company_id)>
                        COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
                    <cfelseif isDefined("session.pp.company_id") and len(session.pp.company_id)>	
                        COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.company_id#">
                    <cfelseif isDefined("session.ww.our_company_id")>
                        COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.company_id#">
                    <cfelseif isDefined("session.cp.our_company_id")>
                        COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.cp.company_id#">
                    </cfif> 
                </cfif> 
        </cfquery>
        <cfreturn check>
    </cffunction>
</cfcomponent>