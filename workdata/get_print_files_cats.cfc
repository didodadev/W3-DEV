<cfcomponent> 
    <cfset dsn = application.systemParam.systemParam().dsn>
    <cfset dsn3 = "#dsn#_#session.ep.company_id#">
    <cfset dsn3_alias= dsn3>
    <cfset dsn_alias= dsn>
    <cffunction name="GetPrintCats" access="public" >
        <cfargument name="print_type" default="">
        <cfquery name="get_print_cats" datasource="#dsn#">
            SELECT
                SETUP_PRINT_FILES_CATS.PRINT_MODULE_ID,  
                SETUP_LANGUAGE_TR.ITEM_#session.ep.language# PRINT_NAME,
                SETUP_PRINT_FILES_CATS.PRINT_TYPE,
                SETUP_PRINT_FILES_CATS.PRINT_DICTIONARY_ID,
                SETUP_LANGUAGE_TR.DICTIONARY_ID,
            CASE 
                WHEN SETUP_LANGUAGE_TR.ITEM_#session.ep.language#='?' THEN SETUP_PRINT_FILES_CATS.PRINT_NAME ELSE SETUP_LANGUAGE_TR.ITEM_#session.ep.language# END AS print_namenew
            FROM 
                SETUP_PRINT_FILES_CATS
            LEFT JOIN 
                SETUP_LANGUAGE_TR
            ON      
                SETUP_LANGUAGE_TR.DICTIONARY_ID = SETUP_PRINT_FILES_CATS.PRINT_DICTIONARY_ID
            <cfif isdefined("arguments.print_type") and len(arguments.print_type)>
                WHERE SETUP_PRINT_FILES_CATS.PRINT_TYPE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.print_type#"> 
            </cfif>                
            ORDER BY 
                SETUP_PRINT_FILES_CATS.PRINT_NAME
        </cfquery>  
    <cfreturn get_print_cats>
    </cffunction>
    <cffunction  name="GetListPrintFiles" access="public" >
        <cfargument name="use_period" default="">
            <cfif (arguments.use_period)>
               <cfset center_dsn = dsn3_alias>
            <cfelse>
                <cfset center_dsn = dsn_alias>
            </cfif>
        <cfquery name="GET_FILES" datasource="#dsn3#">
            SELECT
                SPF.FORM_ID,
                SPF.NAME,		
                SLT.ITEM_#session.ep.language# PRINT_NAME,
            CASE 
                WHEN SLT.ITEM_#session.ep.language#='?' THEN SPFC.PRINT_NAME ELSE SLT.ITEM_#session.ep.language# END AS print_namenew
            FROM
                #center_dsn#.SETUP_PRINT_FILES SPF
            INNER JOIN   
                #dsn#.SETUP_PRINT_FILES_CATS SPFC
            ON
                SPF.PROCESS_TYPE = SPFC.PRINT_TYPE
            LEFT JOIN
                #dsn#.SETUP_LANGUAGE_TR  SLT  
            ON 
                SLT.DICTIONARY_ID= SPFC.PRINT_DICTIONARY_ID  
            ORDER BY
                SPFC.PRINT_NAME,
                SPF.NAME
        </cfquery>
    <cfreturn get_files>
    </cffunction> 
</cfcomponent>